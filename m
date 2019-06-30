Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADEED5B1A4
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 22:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfF3Usp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 16:48:45 -0400
Received: from hermes.domdv.de ([193.102.202.1]:2120 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfF3Usp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 16:48:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:Cc:To:From
        :Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tuBT63ht/NOItm30L3h3F8sv61NJfXFWni3RWSveS7Y=; b=E5YU2l8Fdm+MuC2PrcO/KGcih3
        QaBlmT9B4lZ48JoDSJZAf/AIO6yFfIwXRGSYvgpRfRKzkBMK45kqDGx++M/yyTVgRsSF8QrlGg32D
        I4MHZkn2Jc7Tqiar3fAlFh84TW8S/6spUI0pESFDCt26x5yKg1GCXfOGdhhfhbcPPo1U=;
Received: from [fd06:8443:81a1:74b0::212] (port=4338 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgir-0005T0-LC; Sun, 30 Jun 2019 22:46:53 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgir-0007zv-Fz; Sun, 30 Jun 2019 22:46:53 +0200
Message-ID: <b10a63b0fb7be5a51de207198e0e6aa47dfda015.camel@domdv.de>
Subject: [PATCH net-next 2/3] macsec: remove superfluous zeroing of skb
 reference
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Date:   Sun, 30 Jun 2019 22:46:53 +0200
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove superfluous zeroing of skb pointer for the RX_HANDLER_CONSUMED
case, since in that case, __netif_receive_skb_core will simply ignore
the value.

Signed-off-by: Andreas Steinmetz <ast@domdv.de>

--- a/drivers/net/macsec.c	2019-06-30 22:04:10.003613880 +0200
+++ b/drivers/net/macsec.c	2019-06-30 22:04:22.405822436 +0200
@@ -1215,7 +1215,6 @@
 			macsec_rxsc_put(rx_sc);
 		}
 		rcu_read_unlock();
-		*pskb = NULL;
 		return RX_HANDLER_CONSUMED;
 	}
 
@@ -1239,7 +1238,6 @@
 
 	rcu_read_unlock();
 
-	*pskb = NULL;
 	return RX_HANDLER_CONSUMED;
 
 drop:
@@ -1249,7 +1247,6 @@
 	rcu_read_unlock();
 drop_direct:
 	kfree_skb(skb);
-	*pskb = NULL;
 	return RX_HANDLER_CONSUMED;
 
 nosci:

