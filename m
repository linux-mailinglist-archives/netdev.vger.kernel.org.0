Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E91347B54B
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 22:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhLTVhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 16:37:41 -0500
Received: from yo2urs.ro ([86.126.81.149]:53678 "EHLO mail.yo2urs.ro"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231620AbhLTVhk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 16:37:40 -0500
Received: by mail.yo2urs.ro (Postfix, from userid 124)
        id AB6063636; Mon, 20 Dec 2021 23:28:54 +0200 (EET)
Received: from www.yo2urs.ro (localhost [127.0.0.1])
        by mail.yo2urs.ro (Postfix) with ESMTP id 624C633A1;
        Mon, 20 Dec 2021 23:28:52 +0200 (EET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 20 Dec 2021 23:28:52 +0200
From:   Gabriel Hojda <ghojda@yo2urs.ro>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Issues with smsc95xx driver since a049a30fc27c
In-Reply-To: <YcBEgE589cf5DhJd@lunn.ch>
References: <199eebbd6b97f52b9119c9fa4fd8504f8a34de18.camel@collabora.com>
 <Yb4QFDQ0rFfFsT+Y@lunn.ch> <36f765d8450ba08cb3f8aecab0cadd89@yo2urs.ro>
 <Yb4m3xms1zMf5C3T@lunn.ch> <Yb4pTu3FtkGPPpzb@lunn.ch>
 <c95954ec12dfcf8877c1bf92047c0268@yo2urs.ro> <YcBEgE589cf5DhJd@lunn.ch>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <df29df7d0799cd22c6e30ced02e7c760@yo2urs.ro>
X-Sender: ghojda@yo2urs.ro
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-20 10:53, Andrew Lunn wrote:
>>> next, when i have time and if there's still no progress, i think i 
>>> should
>> try to insert:
>> 
>>         ret = smsc95xx_reset(dev);
>> 	if (ret)
>> 		goto free_pdata;
>> 
>> before
>> 
>> 	ret = phy_connect_direct(dev->net, pdata->phydev,
>> 				 &smsc95xx_handle_link_change,
>> 				 PHY_INTERFACE_MODE_MII);
>> 
>> in smsc95xx_bind() to try to emulate the old behavior for the first 
>> call to
>> start_phy().
> 
> Yes, that will be in interesting experiment. Something in
> smsc95xx_reset() is required.
> 
> 	Andrew

since the above experiment did not work, i studied usbnet_open() in 
usbnet.c which really tries to reset() and then check_connect() ... 
after that i tried following patch which restored network functionality:

-----------------------------------------------------------------------------
--- a/drivers/net/usb/smsc95xx.c        2021-12-17 11:30:17.000000000 
+0200
+++ b/drivers/net/usb/smsc95xx.c        2021-12-20 22:47:30.401385947 
+0200
@@ -1961,7 +1961,8 @@
         .bind           = smsc95xx_bind,
         .unbind         = smsc95xx_unbind,
         .link_reset     = smsc95xx_link_reset,
-       .reset          = smsc95xx_start_phy,
+       .reset          = smsc95xx_reset,
+       .check_connect  = smsc95xx_start_phy,
         .stop           = smsc95xx_stop,
         .rx_fixup       = smsc95xx_rx_fixup,
         .tx_fixup       = smsc95xx_tx_fixup,
-----------------------------------------------------------------------------

i guess a call to smsc95xx_reset() is needed before phy_start() ...

Gabriel
