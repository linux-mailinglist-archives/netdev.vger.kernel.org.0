Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDD72F4146
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 02:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbhAMBi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 20:38:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbhAMBi4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 20:38:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB41B2310F;
        Wed, 13 Jan 2021 01:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610501895;
        bh=nXQKJuHXqcVXEQ7fA4OkmpuzJf/dqsi2h6uSXjiGVcU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WLbnB8FVuW8RC5fxMvmfRZjOSZmTeJyohQAzCyn1cREUIu+/DUqYuywA4VPTO1d9W
         mDCy8dvzILKcjqE4ByBb17s0phLWyWZsZ2ozJcGKRLGQQ4nq9y/iCEuj8zUrObguhC
         HnOQSaccR/IXsnM5MZ8cgQ/vMzHw0BGQdJp1aHdRkCLEcI3qkQM4PY1b9hRb/iinXy
         5aWr4gCeNvkEq8hcIED0/6sDqQCKg2k3PCVtTEQLqiQnJfzT4beRf2Qpd9GjAyczw+
         hoXdtmxDc6iubflAmM5ckWJ4ZriQm4shnB9lIkuGHLXE2JbiLyfaGzyCM/tz3/um/B
         tbJPp8bLEZhpg==
Date:   Tue, 12 Jan 2021 17:38:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] cls_flower: call nla_ok() before nla_next()
Message-ID: <20210112173813.17861ae6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112025548.19107-1-xiyou.wangcong@gmail.com>
References: <20210112025548.19107-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 18:55:48 -0800 Cong Wang wrote:
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
> Cc: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Xin Long <lucien.xin@gmail.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Thanks for keeping up with the syzbot bugs!

> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 1319986693fc..e265c443536e 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -1272,6 +1272,8 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
>  
>  		nla_opt_msk = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
>  		msk_depth = nla_len(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]);
> +		if (!nla_ok(nla_opt_msk, msk_depth))
> +			return -EINVAL;

Can we just add another call to nla_validate_nested_deprecated() 
here instead of having to worry about each attr individually?
See below..

>  	}
>  
>  	nla_for_each_attr(nla_opt_key, nla_enc_key,
> @@ -1308,7 +1310,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
>  				return -EINVAL;
>  			}
>  
> -			if (msk_depth)
> +			if (nla_ok(nla_opt_msk, msk_depth))
>  				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);

Should we not error otherwise? if msk_depth && !nla_ok() then the
message is clearly misformatted. If we don't error out we'll keep
reusing the same mask over and over, while the intention of this 
code was to have mask per key AFAICT.

>  			break;
>  		case TCA_FLOWER_KEY_ENC_OPTS_VXLAN:
