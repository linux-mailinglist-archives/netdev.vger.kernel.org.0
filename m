Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA5C1517FE
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 10:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgBDJhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 04:37:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41344 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgBDJhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 04:37:25 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 905B41577F51A;
        Tue,  4 Feb 2020 01:37:23 -0800 (PST)
Date:   Tue, 04 Feb 2020 10:37:18 +0100 (CET)
Message-Id: <20200204.103718.1343105885567379294.davem@davemloft.net>
To:     harini.katakam@xilinx.com
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@xilinx.com,
        harinikatakamlinux@gmail.com
Subject: Re: [PATCH v2 1/2] net: macb: Remove unnecessary alignment check
 for TSO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1580735882-7429-2-git-send-email-harini.katakam@xilinx.com>
References: <1580735882-7429-1-git-send-email-harini.katakam@xilinx.com>
        <1580735882-7429-2-git-send-email-harini.katakam@xilinx.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 01:37:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>
Date: Mon,  3 Feb 2020 18:48:01 +0530

> The IP TSO implementation does NOT require the length to be a
> multiple of 8. That is only a requirement for UFO as per IP
> documentation.
> 
> Fixes: 1629dd4f763c ("cadence: Add LSO support.")
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> ---
> v2:
> Added Fixes tag

Several problems with this.

The subject talks about alignemnt check, but you are not changing
the alignment check.  Instead you are modifying the linear buffer
check:

> @@ -1792,7 +1792,7 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
>  	/* Validate LSO compatibility */
>  
>  	/* there is only one buffer */
> -	if (!skb_is_nonlinear(skb))
> +	if (!skb_is_nonlinear(skb) || (ip_hdr(skb)->protocol != IPPROTO_UDP))
>  		return features;

So either your explanation is wrong or the code change is wrong.

Furthermore, if you add this condition then there is now dead code
below this.  The code that checks for example:

	/* length of header */
	hdrlen = skb_transport_offset(skb);
	if (ip_hdr(skb)->protocol == IPPROTO_TCP)
		hdrlen += tcp_hdrlen(skb);

will never trigger this IPPROTO_TCP condition after your change.

A lot of things about this patch do not add up.

