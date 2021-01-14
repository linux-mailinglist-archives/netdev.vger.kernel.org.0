Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED39A2F69C1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbhANSja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbhANSja (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 13:39:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 203B523B1A;
        Thu, 14 Jan 2021 18:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610649529;
        bh=UO//Lmj5SghpwqX2tZQjD8fdNXOT/sqqjmhi0vZqLks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UUwp3vXk/Khuia9HLdImRC9dDcH/Sba4tFqeCk4JtKNCCrELSLpJp1mBZLiJ6J39y
         avr1HzwdSSev7sJ2b6W5QCsjgAS92Y9ccQOg9EsIX6eCla5pWPzeSFAwsXAHaoAf5o
         Po0KhHwsgwz2p+6WaMWs5N6+74+WuOTOgVluNcjRlME0XbIuwVMv6uAh8WWFHFpEAB
         OizPHC19B1fUihKaMR0CMFFOyI0E8Gnc6Y2f9rWY/aehPTtZ8jPqs/+7abu0WYNyRw
         eSJ290IuZSbTXv+4ebMaz923UP61ULUNFSoexKk8vpimH8zNA6MymGiCqglip3T9LF
         LX25MNghd5lcw==
Date:   Thu, 14 Jan 2021 10:38:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net v2] cls_flower: call nla_ok() before nla_next()
Message-ID: <20210114103848.5153aa5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114163822.56306-1-xiyou.wangcong@gmail.com>
References: <20210114163822.56306-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 08:38:22 -0800 Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> fl_set_enc_opt() simply checks if there are still bytes left to parse,
> but this is not sufficent as syzbot seems to be able to generate
> malformatted netlink messages. nla_ok() is more strict so should be
> used to validate the next nlattr here.
> 
> And nla_validate_nested_deprecated() has less strict check too, it is
> probably too late to switch to the strict version, but we can just
> call nla_ok() too after it.
> 
> Reported-and-tested-by: syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com
> Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")

> @@ -1340,9 +1341,6 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
>  				NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
>  				return -EINVAL;
>  			}
> -
> -			if (msk_depth)
> -				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
>  			break;
>  		case TCA_FLOWER_KEY_ENC_OPTS_ERSPAN:
>  			if (key->enc_opts.dst_opt_type) {
> @@ -1373,14 +1371,17 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
>  				NL_SET_ERR_MSG(extack, "Key and mask miss aligned");
>  				return -EINVAL;
>  			}
> -
> -			if (msk_depth)
> -				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
>  			break;
>  		default:
>  			NL_SET_ERR_MSG(extack, "Unknown tunnel option type");
>  			return -EINVAL;
>  		}
> +
> +		if (!nla_ok(nla_opt_msk, msk_depth)) {
> +			NL_SET_ERR_MSG(extack, "Mask attribute is invalid");
> +			return -EINVAL;
> +		}
> +		nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);

we lost the if (msk_depth) now, nla_opt_msk may be NULL -
neither nla_ok() nor nla_next() take NULL

>  	}
>  
>  	return 0;

