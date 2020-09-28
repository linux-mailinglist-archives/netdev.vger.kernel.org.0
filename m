Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D7927B7D4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgI1XSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgI1XSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:18:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9125C0610D3;
        Mon, 28 Sep 2020 15:58:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F5EE12747825;
        Mon, 28 Sep 2020 15:42:05 -0700 (PDT)
Date:   Mon, 28 Sep 2020 15:58:52 -0700 (PDT)
Message-Id: <20200928.155852.490566722532403628.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ms@dev.tdt.de
Subject: Re: [PATCH net] drivers/net/wan/x25_asy: Keep the ldisc running
 even when netif is down
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200926205610.21045-1-xie.he.0141@gmail.com>
References: <20200926205610.21045-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 15:42:05 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Sat, 26 Sep 2020 13:56:10 -0700

> @@ -265,7 +269,9 @@ static void x25_asy_write_wakeup(struct tty_struct *tty)
>  		 * transmission of another packet */
>  		sl->dev->stats.tx_packets++;
>  		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
> -		x25_asy_unlock(sl);
> +		/* FIXME: The netif may go down after netif_running returns */
> +		if (netif_running(sl->dev))
> +			x25_asy_unlock(sl);
>  		return;

It could also go back down and also back up again after you do this
test.  Maybe even 10 or 100 times over.

You can't just leave things so incredibly racy like this, please apply
proper synchronization between netdev state changes and this TTY code.

Thank you.
