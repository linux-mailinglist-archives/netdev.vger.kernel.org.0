Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3DF9B83E
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436950AbfHWVdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:33:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38164 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732682AbfHWVdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 17:33:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D74B1543B2AA;
        Fri, 23 Aug 2019 14:33:51 -0700 (PDT)
Date:   Fri, 23 Aug 2019 14:33:50 -0700 (PDT)
Message-Id: <20190823.143350.122492125918705806.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, jslaby@suse.cz
Subject: Re: [PATCH net 2/2] r8152: avoid using napi_disable after
 netif_napi_del.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-316-Taiwan-albertk@realtek.com>
References: <1394712342-15778-314-Taiwan-albertk@realtek.com>
        <1394712342-15778-316-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 14:33:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 23 Aug 2019 16:53:02 +0800

> Exchange netif_napi_del() and unregister_netdev() in rtl8152_disconnect()
> to avoid using napi_disable() after netif_napi_del().
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 690a24d1ef82..29390eda5251 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -5364,8 +5364,8 @@ static void rtl8152_disconnect(struct usb_interface *intf)
>  	if (tp) {
>  		rtl_set_unplug(tp);
>  
> -		netif_napi_del(&tp->napi);
>  		unregister_netdev(tp->netdev);
> +		netif_napi_del(&tp->napi);
>  		cancel_delayed_work_sync(&tp->hw_phy_work);
>  		tp->rtl_ops.unload(tp);
>  		free_netdev(tp->netdev);

This is completely redundant because free_netdev() will perform all of
the necessary netif_napi_del() calls.
