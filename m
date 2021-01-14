Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1092F6D55
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbhANVhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbhANVhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 16:37:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDDEE235DD;
        Thu, 14 Jan 2021 21:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610660187;
        bh=izhUaKSlwAMBHsz6wANqARoOHOpm4pOGqJsgs0xUrbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fYWsDpj+jbJ8kfe82rKcG0EUdr3ooqJ9KF0acfBmLUoQ4fg5v7eQlLX5QyCRo7ALG
         vCTDkBtgxTrJVXRfCwmlwFoXKhYfqc/D/aStEj2vhGjv9+U0PoJS9AGnUKUaNR0Dh/
         7FbOGJzCkFdDl3+rkFk6OtWES3TycOL7bSb5F93TGQL6Ejkty4/oudTusPszerEvqP
         z1I5caSaEasHrkE9x+gNfhw9Wa4DrREE5BQHt+VzK3yCICnaanR4Gf3ZsRCu0iEOwa
         YkidaBnMd2FqNHXxQvKkQoTOnZqda6FVKNa+/82AFNdPlz9bvtVyN8yVEn3lGsgH5y
         xAsBKPW2+QVNg==
Date:   Thu, 14 Jan 2021 13:36:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+2624e3778b18fc497c92@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Xin Long <lucien.xin@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net v3] cls_flower: call nla_ok() before nla_next()
Message-ID: <20210114133625.0d1ea5e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114210749.61642-1-xiyou.wangcong@gmail.com>
References: <20210114210749.61642-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 13:07:49 -0800 Cong Wang wrote:
> -			if (msk_depth)
> -				nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
>  			break;
>  		default:
>  			NL_SET_ERR_MSG(extack, "Unknown tunnel option type");
>  			return -EINVAL;
>  		}
> +
> +		if (!nla_opt_msk)
> +			continue;

Why the switch from !msk_depth to !nla_opt_msk?

Seems like previously providing masks for only subset of options 
would have worked.
