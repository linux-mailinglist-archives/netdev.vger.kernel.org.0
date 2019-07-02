Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E18505C86D
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 06:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbfGBEi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 00:38:27 -0400
Received: from hermes.domdv.de ([193.102.202.1]:1788 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbfGBEi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 00:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xeaBIMOPw7/voZfgKZji7SobaICXyrnnmWb+/5GMVRs=; b=V8LuTlxIEk+23G2vKwTk+bxVzF
        hWL1PejY+UqiYLmXYyA/s88/KLHa90TiARDYWMcDUTIY8DuivUyyVjLQ6hNigkRE0NZLYzZ6QJZcV
        1wM06HiabzZrGDV8iE6kpSd410oP2gZiA7TOgXrXQV5xdDfKyGY7lJp+tkMlSNnwCi0w=;
Received: from [fd06:8443:81a1:74b0::212] (port=1240 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hiAXj-0006mm-OU; Tue, 02 Jul 2019 06:37:23 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hiAXj-0006NC-JP; Tue, 02 Jul 2019 06:37:23 +0200
Message-ID: <b393fc9f9a9e4e49b9cbe6edebb3cd38301ffd92.camel@domdv.de>
Subject: Re: [PATCH net-next 3/3] macsec: add brackets and indentation after
 calling macsec_decrypt
From:   Andreas Steinmetz <ast@domdv.de>
To:     Sabrina Dubroca <sd@queasysnail.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Date:   Tue, 02 Jul 2019 06:37:23 +0200
In-Reply-To: <20190701132157.GA15622@bistromath.localdomain>
References: <4932e7da775e76aa928f44c19288aa3a6ec72313.camel@domdv.de>
         <CA+FuTSfmi3XCTR5CCiUk180XTy69mJsL4Y_5zStP727b=woWJQ@mail.gmail.com>
         <20190701132157.GA15622@bistromath.localdomain>
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ouch, I missed that when Andreas sent me that patch before. No, it is
> actually intended. If we skip macsec_decrypt(), we should still
> account for that packet in the InPktsUnchecked/InPktsDelayed
> counters. That's in Figure 10-5 in the standard.
> 
> Thanks for catching this, Willem. That patch should only move the
> IS_ERR(skb) case under the block where macsec_decrypt() is called, but
> not move the call to macsec_post_decrypt().

Updated patch below.

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

