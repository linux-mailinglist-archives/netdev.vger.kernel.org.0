Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE1A5D8D6
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfGCAaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:30:00 -0400
Received: from hermes.domdv.de ([193.102.202.1]:3922 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbfGCA36 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 20:29:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:Cc:To:From
        :Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=e61PcNMpUqS8gfqTTLdvuOsOexxq+flNButaqRVcHnk=; b=HsQB95qSWdO6lDIGfx4nq5J/Be
        M4gDSNgo74xADFYskwLm35/Y19iuTtwz/UWpl99zGIkTG7XHt+uvPZAqAh/eq0XxMhmxQLiif4wmT
        67HucOTkLKwVXEan88KwNc3kgoyC/Sl72FQMPODyjOOJhaf/YUKrBWDi/v64qRqsuQ3g=;
Received: from [fd06:8443:81a1:74b0::212] (port=1834 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hiPiw-0005Ae-Tb; Tue, 02 Jul 2019 22:49:58 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hiPiw-0005kZ-OS; Tue, 02 Jul 2019 22:49:58 +0200
Message-ID: <09e748d728dbb222ff28685f144c4b8d082cc189.camel@domdv.de>
Subject: [PATCH net-next 1/3 v2] macsec: remove superfluous function calls
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Date:   Tue, 02 Jul 2019 22:49:58 +0200
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

