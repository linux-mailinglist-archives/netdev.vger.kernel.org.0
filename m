Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9575B1A1
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 22:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfF3Ush (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 16:48:37 -0400
Received: from hermes.domdv.de ([193.102.202.1]:2106 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfF3Ush (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 16:48:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:Cc:To:From
        :Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=82w7jy1kjNSM8d/KcokO6tiXJLbDoImaJaPL3C8spjI=; b=nFPqBskg1TP8vbXcoIqCsaneNV
        Rwahm+Hx9WopzHgoXwJNaM7KVd7Z5xku2GPDEHRDZEVq6id5HADBZFW81pXmgOUIbuHmEPFKEdP3X
        lbBZaM3QG6IIsBV/SD9dFznbVbXR08Za9WEXor5kfAmqjrVZ2J3/ou7j+eQ6BZSPBIXE=;
Received: from [fd06:8443:81a1:74b0::212] (port=4332 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgij-0005Sa-UX; Sun, 30 Jun 2019 22:46:45 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgij-0007zj-Pu; Sun, 30 Jun 2019 22:46:45 +0200
Message-ID: <1250be5ff32bc4312b3f3e724a8798db0563ea3c.camel@domdv.de>
Subject: [PATCH net 2/2] macsec: fix checksumming after decryption
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Date:   Sun, 30 Jun 2019 22:46:45 +0200
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix checksumming after decryption.

Signed-off-by: Andreas Steinmetz <ast@domdv.de>

--- a/drivers/net/macsec.c	2019-06-30 22:14:10.250285314 +0200
+++ b/drivers/net/macsec.c	2019-06-30 22:15:11.931230417 +0200
@@ -869,6 +869,7 @@
 
 static void macsec_finalize_skb(struct sk_buff *skb, u8 icv_len, u8 hdr_len)
 {
+	skb->ip_summed = CHECKSUM_NONE;
 	memmove(skb->data + hdr_len, skb->data, 2 * ETH_ALEN);
 	skb_pull(skb, hdr_len);
 	pskb_trim_unique(skb, skb->len - icv_len);

