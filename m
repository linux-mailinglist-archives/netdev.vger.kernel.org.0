Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F265D8D5
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbfGCA35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:29:57 -0400
Received: from hermes.domdv.de ([193.102.202.1]:3922 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfGCA34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 20:29:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:Cc:To:From
        :Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZUOIa3ZDKQ5lq4xKbnKFmV4VGeSW+JMdaNhLcm+fmvU=; b=iug41mEIszDk3+IBOFOlanU1L+
        cWUfvrl3zghgSLMf8NVDNLbkoeZ+YFOFDEdhCSwYXFHOwdjmANcKY/ZTPtLMyLEpbGaauelGJsPLi
        JeiO8XM96mdbt0lOyG28fbKfpleUtppkwBmakUGa+KjVIqvscM5YbypmyinMTr+JJjg0=;
Received: from [fd06:8443:81a1:74b0::212] (port=1838 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hiPjD-0005HL-3p; Tue, 02 Jul 2019 22:50:15 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hiPjC-0005lg-VE; Tue, 02 Jul 2019 22:50:15 +0200
Message-ID: <2feb07a79b595302f1a5139595f6359752d64170.camel@domdv.de>
Subject: [PATCH net-next 3/3 v2] macsec: add brackets and indentation after
 calling macsec_decrypt
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Date:   Tue, 02 Jul 2019 22:50:14 +0200
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At this point, skb could only be a valid pointer, so this patch does
not introduce any functional change.

Change:

The patch now only moves the IS_ERR(skb) case under the block where
macsec_decrypt() is called, but not the call to macsec_post_decrypt().

Signed-off-by: Andreas Steinmetz <ast@domdv.de>

--- a/drivers/net/macsec.c	2019-07-02 06:31:27.550120145 +0200
+++ b/drivers/net/macsec.c	2019-07-02 06:33:38.637599529 +0200
@@ -1205,17 +1205,18 @@
 
 	/* Disabled && !changed text => skip validation */
 	if (hdr->tci_an & MACSEC_TCI_C ||
-	    secy->validate_frames != MACSEC_VALIDATE_DISABLED)
+	    secy->validate_frames != MACSEC_VALIDATE_DISABLED) {
 		skb = macsec_decrypt(skb, dev, rx_sa, sci, secy);
 
-	if (IS_ERR(skb)) {
-		/* the decrypt callback needs the reference */
-		if (PTR_ERR(skb) != -EINPROGRESS) {
-			macsec_rxsa_put(rx_sa);
-			macsec_rxsc_put(rx_sc);
+		if (IS_ERR(skb)) {
+			/* the decrypt callback needs the reference */
+			if (PTR_ERR(skb) != -EINPROGRESS) {
+				macsec_rxsa_put(rx_sa);
+				macsec_rxsc_put(rx_sc);
+			}
+			rcu_read_unlock();
+			return RX_HANDLER_CONSUMED;
 		}
-		rcu_read_unlock();
-		return RX_HANDLER_CONSUMED;
 	}
 
 	if (!macsec_post_decrypt(skb, secy, pn))

