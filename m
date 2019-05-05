Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A6013E39
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 09:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfEEHp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 03:45:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46422 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfEEHp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 03:45:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A5DCF14C043F5;
        Sun,  5 May 2019 00:45:56 -0700 (PDT)
Date:   Sun, 05 May 2019 00:45:56 -0700 (PDT)
Message-Id: <20190505.004556.492323065607253635.davem@davemloft.net>
To:     Jan.Kloetzke@preh.de
Cc:     oneukum@suse.com, jan@kloetzke.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] usbnet: fix kernel crash after disconnect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190430141440.9469-1-Jan.Kloetzke@preh.de>
References: <1556563688.20085.31.camel@suse.com>
        <20190430141440.9469-1-Jan.Kloetzke@preh.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 00:45:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kloetzke Jan <Jan.Kloetzke@preh.de>
Date: Tue, 30 Apr 2019 14:15:07 +0000

> @@ -1431,6 +1432,11 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
>  		spin_unlock_irqrestore(&dev->txq.lock, flags);
>  		goto drop;
>  	}
> +	if (WARN_ON(netif_queue_stopped(net))) {
> +		usb_autopm_put_interface_async(dev->intf);
> +		spin_unlock_irqrestore(&dev->txq.lock, flags);
> +		goto drop;
> +	}

If this is known to happen and is expected, then we should not warn.
