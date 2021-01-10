Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706082F049A
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 01:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbhAJAl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 19:41:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAJAl6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 19:41:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67E4A22518;
        Sun, 10 Jan 2021 00:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610239277;
        bh=AmLjO8fHn2NQR6WSHD2p8Ch8CpUEdendY2OLk4lFBPE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A1o60jf5+HECgjIElHcl+z7MFeQzRgUs2JSXrCIAFcFJx7B2uxf1QG1k4FLduGKCJ
         QpoY/N5uJYi1VN5aW4vYOIuTNeW83aiVF2ixx2OWnezu1L8D0dWEGJ0+Iyq5Dz8CbA
         W8cmy75v685QGiWaWR67TUhcNVAzvT2zMx1qxK+jrngsFxRZL56q1ktAmttylCtY6y
         5i+jQcK47NHkDHyuShGtfZXOWJHkuro0rytaVvxs6pyKy+eNjKpZULuFhxGIXmIGqj
         SDeVKMubR0L0AAXlDreqoCRBQW2ab+UBrBg0kaApcIRum2cGsFoE+KbGZgfpqZxLZf
         D8pfJX5EEeo3g==
Date:   Sat, 9 Jan 2021 16:41:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <jerry.lilijun@huawei.com>, <xudingke@huawei.com>
Subject: Re: [PATCH net-next] devlink: fix return of uninitialized variable
 err
Message-ID: <20210109164116.708acd8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610112073-23424-1-git-send-email-wangyunjian@huawei.com>
References: <1610112073-23424-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Jan 2021 21:21:13 +0800 wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> There is a potential execution path in which variable err is
> returned without being properly initialized previously. Fix
> this by initializing variable err to 0.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: 1db64e8733f6 ("devlink: Add devlink formatted message (fmsg) API")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Fixes should generally be targeting net, not net-next.

I don't think this can trigger. 

Only devlink_nl_cmd_health_reporter_diagnose_doit() can call here, and
before it does it calls devlink_fmsg_obj_nest_start() and end(), so
there will at least be DEVLINK_ATTR_FMSG_OBJ_NEST_START to iterate over.

Please double check this analysis, and resend the patch with the commit
message updated to reflect this is not a bug fix and without the fixes
tag.

> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index ee828e4b1007..470215cd60b5 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -5699,7 +5699,7 @@ devlink_fmsg_prepare_skb(struct devlink_fmsg *fmsg, struct sk_buff *skb,
>  	struct devlink_fmsg_item *item;
>  	struct nlattr *fmsg_nlattr;
>  	int i = 0;
> -	int err;
> +	int err = 0;

Please order variable declaration lines longest to shortest.
err should be before i.

>  	fmsg_nlattr = nla_nest_start_noflag(skb, DEVLINK_ATTR_FMSG);
>  	if (!fmsg_nlattr)
