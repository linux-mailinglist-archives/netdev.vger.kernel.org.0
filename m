Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23A32316FA
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731002AbgG2AwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730869AbgG2AwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:52:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDEEC061794;
        Tue, 28 Jul 2020 17:52:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78B0D128D74D3;
        Tue, 28 Jul 2020 17:35:18 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:52:02 -0700 (PDT)
Message-Id: <20200728.175202.598794850221205861.davem@davemloft.net>
To:     Jisheng.Zhang@synaptics.com
Cc:     thomas.petazzoni@bootlin.com, kuba@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-nex 2/2] net: mvneta: Don't speed down the PHY when
 changing mtu
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200727195314.704dfaed@xhacker.debian>
References: <20200727195012.4bcd069d@xhacker.debian>
        <20200727195314.704dfaed@xhacker.debian>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 17:35:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Mon, 27 Jul 2020 19:53:14 +0800

> @@ -3651,7 +3651,8 @@ static void mvneta_stop_dev(struct mvneta_port *pp)
>  
>  	set_bit(__MVNETA_DOWN, &pp->state);
>  
> -	if (device_may_wakeup(&pp->dev->dev))
> +	if (device_may_wakeup(&pp->dev->dev) &&
> +	    pp->pkt_size == MVNETA_RX_PKT_SIZE(pp->dev->mtu))
>  		phylink_speed_down(pp->phylink, false);
>  

This is too much for me.

You shouldn't have to shut down the entire device and take it back up
again just to change the MTU.

Unfortunately, this is a common pattern in many drivers and it is very
dangerous to take this lazy path of just doing "stop/start" around
the MTU change.

It means you can't recover from partial failures properly,
f.e. recovering from an inability to allocate queue resources for the
new MTU.

To solve this properly, you must restructure the MTU change such that
is specifically stops the necessary and only the units of the chip
necessary to change the MTU.

It should next try to allocate the necessary resources to satisfy the
MTU change, keeping the existing resources allocated in case of
failure.

Then, only is all resources are successfully allocated, it should
commit the MTU change fully and without errors.

Then none of these link flapping issues are even possible.
