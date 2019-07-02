Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867285D8D4
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfGCA36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:29:58 -0400
Received: from hermes.domdv.de ([193.102.202.1]:3922 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727182AbfGCA35 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 20:29:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:Cc:To:From
        :Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tuBT63ht/NOItm30L3h3F8sv61NJfXFWni3RWSveS7Y=; b=Q82kKldFUYzvYWKmhdGeJhIo4N
        vGLT8UEhHaohmlntlKoup4WwCkNAFFr21Dai07od9isUBTqYm/8w/RqG97THejNIpVcgmtPPjDKGS
        Wi3exeOp1UpJu3Ns2mIbhznL5iNDjo1hR6E+XKKXE2hkoacLGkF9IzF8S3AdmAXnwEX8=;
Received: from [fd06:8443:81a1:74b0::212] (port=1836 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hiPj2-0005HC-3Q; Tue, 02 Jul 2019 22:50:04 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hiPj1-0005lc-Ut; Tue, 02 Jul 2019 22:50:04 +0200
Message-ID: <47a075ac95cbd4fcbb89f5ffc7e074eb503f3e5c.camel@domdv.de>
Subject: [PATCH net-next 2/3 v2] macsec: remove superfluous zeroing of skb
 reference
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Date:   Tue, 02 Jul 2019 22:50:03 +0200
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

