Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282FF5B1A5
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 22:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfF3Usq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 16:48:46 -0400
Received: from hermes.domdv.de ([193.102.202.1]:2116 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfF3Usp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 16:48:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:Cc:To:From
        :Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qCc6gsUXYssbonrOrH/SXHnjP+hORD6iwz83OgvFENw=; b=MUXwPG2u4j6lU2PQ+oDkob6BIG
        PZVjWhofGDLOYdMBvOklA6/m4CdQ/Vxv1NUyJLtY82oUHoxdMb1jYjAliTaXXGDsLdeC7lDG7Eq8v
        HUyGt5NCpwGZddVxR13+uv4c+C11gvuV999JSjw6mvznjndcaHj8ivkbY+gjRCj8Ruyc=;
Received: from [fd06:8443:81a1:74b0::212] (port=4340 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgiu-0005T8-JC; Sun, 30 Jun 2019 22:46:56 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgiu-000800-E5; Sun, 30 Jun 2019 22:46:56 +0200
Message-ID: <4932e7da775e76aa928f44c19288aa3a6ec72313.camel@domdv.de>
Subject: [PATCH net-next 3/3] macsec: add brackets and indentation after
 calling macsec_decrypt
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Date:   Sun, 30 Jun 2019 22:46:56 +0200
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

Signed-off-by: Andreas Steinmetz <ast@domdv.de>

--- a/drivers/net/macsec.c	2019-06-30 22:05:17.785683634 +0200
+++ b/drivers/net/macsec.c	2019-06-30 22:05:20.526171178 +0200
@@ -1205,21 +1205,22 @@
 
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
-	}
 
-	if (!macsec_post_decrypt(skb, secy, pn))
-		goto drop;
+		if (!macsec_post_decrypt(skb, secy, pn))
+			goto drop;
+	}
 
 deliver:
 	macsec_finalize_skb(skb, secy->icv_len,

