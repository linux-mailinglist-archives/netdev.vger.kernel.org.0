Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31552635A2
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgIISLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIISLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:11:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EFCC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:11:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1B1B12954930;
        Wed,  9 Sep 2020 10:54:30 -0700 (PDT)
Date:   Wed, 09 Sep 2020 11:11:16 -0700 (PDT)
Message-Id: <20200909.111116.304046519568129762.davem@davemloft.net>
To:     allen.lkml@gmail.com
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, romain.perier@gmail.com
Subject: Re: [PATCH v2 07/20] ethernet: dlink: convert tasklets to use new
 tasklet_setup() API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909084510.648706-8-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
        <20200909084510.648706-8-allen.lkml@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 10:54:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>
Date: Wed,  9 Sep 2020 14:14:57 +0530

> @@ -1312,10 +1311,11 @@ static irqreturn_t intr_handler(int irq, void *dev_instance)
>  	return IRQ_RETVAL(handled);
>  }
>  
> -static void rx_poll(unsigned long data)
> +static void rx_poll(struct tasklet_struct *t)
>  {
> -	struct net_device *dev = (struct net_device *)data;
> -	struct netdev_private *np = netdev_priv(dev);
> +	struct netdev_private *np = from_tasklet(np, t, rx_tasklet);
> +	struct net_device *dev = (struct net_device *)((char *)np -
> +				  ALIGN(sizeof(struct net_device), NETDEV_ALIGN));

Just like patch #1, I don't want to see this brittle construct.
