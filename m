Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A03F5B1A3
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 22:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfF3Usn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 16:48:43 -0400
Received: from hermes.domdv.de ([193.102.202.1]:2112 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfF3Usn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 16:48:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:Cc:To:From
        :Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=e61PcNMpUqS8gfqTTLdvuOsOexxq+flNButaqRVcHnk=; b=dhMAWsP4/4swjCHlRmgcd2AW4T
        FV8eizf4jgyGHmSHvBHWmIC09FAOHrrMrjFLp3AaZgqVp1Vvb5/Ghu0lGLPlhSJQgbCMLelrXFn2c
        kRkf6REcVsRAWm4n6dCnLijcMbszhWfoz7Qo/f8tVMUxyMGooxi4qXIo8X7c4z+ZjmgA=;
Received: from [fd06:8443:81a1:74b0::212] (port=4336 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgip-0005Sq-Ab; Sun, 30 Jun 2019 22:46:51 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgip-0007zr-5c; Sun, 30 Jun 2019 22:46:51 +0200
Message-ID: <e748ac8df5f8a3451540ad144a2c0afb962632f8.camel@domdv.de>
Subject: [PATCH net-next 1/3] macsec: remove superfluous function calls
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Date:   Sun, 30 Jun 2019 22:46:50 +0200
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove superfluous skb_share_check() and skb_unshare().
macsec_decrypt is only called by macsec_handle_frame which
already does a skb_unshare().

Signed-off-by: Andreas Steinmetz <ast@domdv.de>

--- a/drivers/net/macsec.c	2019-06-30 22:02:54.906908179 +0200
+++ b/drivers/net/macsec.c	2019-06-30 22:03:07.315785186 +0200
@@ -939,9 +939,6 @@
 	u16 icv_len = secy->icv_len;
 
 	macsec_skb_cb(skb)->valid = false;
-	skb = skb_share_check(skb, GFP_ATOMIC);
-	if (!skb)
-		return ERR_PTR(-ENOMEM);
 
 	ret = skb_cow_data(skb, 0, &trailer);
 	if (unlikely(ret < 0)) {
@@ -973,11 +970,6 @@
 
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

