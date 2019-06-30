Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB1F5B1A0
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 22:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfF3Usb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 16:48:31 -0400
Received: from hermes.domdv.de ([193.102.202.1]:2100 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfF3Usb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 16:48:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:Cc:To:From
        :Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=obtir9XeMcGumUjGgOzAQFZKAeILcVyzDv09IWOrPLg=; b=W5ehasueE2DmZbQtyt5IkLxLkT
        W1EUQmxrKRE2k74qDc547b+jQH0ONxPGDs4B3rxqnpkNUjZjo/WQ6smVT2iPpuKqaOQRoIgmdqmUI
        cPIIvrab60eIpFNpSbx9ZYgN2jpX5eJFjC/8WWmx0sGyMxMXjGPA48HALyGfj8QoAJE4=;
Received: from [fd06:8443:81a1:74b0::212] (port=4328 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgig-0005SO-Pr; Sun, 30 Jun 2019 22:46:42 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgig-0007ze-LA; Sun, 30 Jun 2019 22:46:42 +0200
Message-ID: <88846d6ff622a908655562e0be1a094e3b5a3b2d.camel@domdv.de>
Subject: [PATCH net 1/2] macsec: fix use-after-free of skb during RX
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Date:   Sun, 30 Jun 2019 22:46:42 +0200
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix use-after-free of skb when rx_handler returns RX_HANDLER_PASS.

Signed-off-by: Andreas Steinmetz <ast@domdv.de>

--- a/drivers/net/macsec.c	2019-06-05 20:23:27.640154747 +0200
+++ b/drivers/net/macsec.c	2019-06-05 20:23:46.791565816 +0200
@@ -1103,10 +1103,9 @@ static rx_handler_result_t macsec_handle
 	}
 
 	skb = skb_unshare(skb, GFP_ATOMIC);
-	if (!skb) {
-		*pskb = NULL;
+	*pskb = skb;
+	if (!skb)
 		return RX_HANDLER_CONSUMED;
-	}
 
 	pulled_sci = pskb_may_pull(skb, macsec_extra_len(true));
 	if (!pulled_sci) {

