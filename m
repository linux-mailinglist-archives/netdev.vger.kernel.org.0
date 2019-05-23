Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2FDE2775E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfEWHqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:46:42 -0400
Received: from hermes.domdv.de ([193.102.202.1]:3954 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfEWHqm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 03:46:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:To:From:
        Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gpLsZrYCMEZVFYRxO0I/koqkV/nyYMH0nPyv57wjdVw=; b=eMZCk53WAaZ2wXU9XD7LXJWWY3
        dd2tWn7Ba9mcs/30OVBaDTDrhec3RrF6QszxnpLHgAeRUb+Kk12Dz6ofIrzZhG0uOcmHGSrFuqVLY
        D2w32jgRa51/o4yuFsgVqQvnL0wXw9AhMLgVFN63O2trnk/6sUAKiBSXXftaAUmkArkU=;
Received: from [fd06:8443:81a1:74b0::212] (port=1096 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <ast@domdv.de>)
        id 1hTiQy-00073K-Fb; Thu, 23 May 2019 09:46:40 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <ast@domdv.de>)
        id 1hTiQL-0000w4-Q3; Thu, 23 May 2019 09:46:01 +0200
Message-ID: <32eb738a0a0f3ed5880911e4ac4ceedca76e3f52.camel@domdv.de>
Subject: [RESEND][PATCH] Fix MACsec kernel panics, oopses and bugs
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org
Date:   Thu, 23 May 2019 09:46:15 +0200
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MACsec causes oopses followed by a kernel panic when attached directly or indirectly to a bridge. It causes erroneous
checksum messages when attached to vxlan. When I did investigate I did find skb leaks, apparent skb mis-handling and
superfluous code. The attached patch fixes all MACsec misbehaviour I could find. As I am no kernel developer somebody
with sufficient kernel network knowledge should verify and correct the patch where necessary.

Signed-off-by: Andreas Steinmetz <ast@domdv.de>

--- linux.orig/drivers/net/macsec.c	2019-05-17 11:00:13.631121950 +0200
+++ linux/drivers/net/macsec.c	2019-05-17 18:41:41.333119772 +0200
@@ -911,6 +911,9 @@ static void macsec_decrypt_done(struct c
 			    macsec_extra_len(macsec_skb_cb(skb)->has_sci));
 	macsec_reset_skb(skb, macsec->secy.netdev);
 
+	/* FIXME: any better way to prevent calls to netdev_rx_csum_fault? */
+	skb->csum_complete_sw = 1;
+
 	len = skb->len;
 	if (gro_cells_receive(&macsec->gro_cells, skb) == NET_RX_SUCCESS)
 		count_rx(dev, len);
@@ -938,9 +941,6 @@ static struct sk_buff *macsec_decrypt(st
 	u16 icv_len = secy->icv_len;
 
 	macsec_skb_cb(skb)->valid = false;
-	skb = skb_share_check(skb, GFP_ATOMIC);
-	if (!skb)
-		return ERR_PTR(-ENOMEM);
 
 	ret = skb_cow_data(skb, 0, &trailer);
 	if (unlikely(ret < 0)) {
@@ -972,11 +972,6 @@ static struct sk_buff *macsec_decrypt(st
 
 		aead_request_set_crypt(req, sg, sg, len, iv);
 		aead_request_set_ad(req, macsec_hdr_len(macsec_skb_cb(skb)->has_sci));
-		skb = skb_unshare(skb, GFP_ATOMIC);
-		if (!skb) {
-			aead_request_free(req);
-			return ERR_PTR(-ENOMEM);
-		}
 	} else {
 		/* integrity only: all headers + data authenticated */
 		aead_request_set_crypt(req, sg, sg, icv_len, iv);
@@ -1102,20 +1097,12 @@ static rx_handler_result_t macsec_handle
 		return RX_HANDLER_PASS;
 	}
 
-	skb = skb_unshare(skb, GFP_ATOMIC);
-	if (!skb) {
-		*pskb = NULL;
-		return RX_HANDLER_CONSUMED;
-	}
-
 	pulled_sci = pskb_may_pull(skb, macsec_extra_len(true));
 	if (!pulled_sci) {
 		if (!pskb_may_pull(skb, macsec_extra_len(false)))
 			goto drop_direct;
 	}
 
-	hdr = macsec_ethhdr(skb);
-
 	/* Frames with a SecTAG that has the TCI E bit set but the C
 	 * bit clear are discarded, as this reserved encoding is used
 	 * to identify frames with a SecTAG that are not to be
@@ -1130,6 +1117,12 @@ static rx_handler_result_t macsec_handle
 			goto drop_direct;
 	}
 
+	skb = skb_unshare(skb, GFP_ATOMIC);
+	if (!skb)
+		return RX_HANDLER_CONSUMED;
+
+	hdr = macsec_ethhdr(skb);
+
 	/* ethernet header is part of crypto processing */
 	skb_push(skb, ETH_HLEN);
 
@@ -1213,22 +1206,22 @@ static rx_handler_result_t macsec_handle
 
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
-		*pskb = NULL;
-		return RX_HANDLER_CONSUMED;
-	}
 
-	if (!macsec_post_decrypt(skb, secy, pn))
-		goto drop;
+		if (!macsec_post_decrypt(skb, secy, pn))
+			goto drop;
+	}
 
 deliver:
 	macsec_finalize_skb(skb, secy->icv_len,
@@ -1239,6 +1232,9 @@ deliver:
 		macsec_rxsa_put(rx_sa);
 	macsec_rxsc_put(rx_sc);
 
+	/* FIXME: any better way to prevent calls to netdev_rx_csum_fault? */
+	skb->csum_complete_sw = 1;
+
 	ret = gro_cells_receive(&macsec->gro_cells, skb);
 	if (ret == NET_RX_SUCCESS)
 		count_rx(dev, skb->len);
@@ -1247,7 +1243,6 @@ deliver:
 
 	rcu_read_unlock();
 
-	*pskb = NULL;
 	return RX_HANDLER_CONSUMED;
 
 drop:
@@ -1257,7 +1252,6 @@ drop_nosa:
 	rcu_read_unlock();
 drop_direct:
 	kfree_skb(skb);
-	*pskb = NULL;
 	return RX_HANDLER_CONSUMED;
 
 nosci:
@@ -1303,8 +1297,8 @@ nosci:
 	}
 
 	rcu_read_unlock();
-	*pskb = skb;
-	return RX_HANDLER_PASS;
+	kfree_skb(skb);
+	return RX_HANDLER_CONSUMED;
 }
 
 static struct crypto_aead *macsec_alloc_tfm(char *key, int key_len, int icv_len)
-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
D.O.M. Datenverarbeitung GmbH
Geschäftssitz: Bahnhofstr. 41, 90402 Nürnberg
Telefon: +49 (0)911 - 99462-0, Fax: +49 (0)911 - 99462-11
Amtsgericht Nürnberg HRB 1455, UST-Ident.-Nr. DE133508452
Geschäftsführer: Alfred Jakob


