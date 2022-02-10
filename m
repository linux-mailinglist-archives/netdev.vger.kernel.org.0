Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D254B1221
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243822AbiBJPy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:54:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243819AbiBJPy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:54:59 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C24C27;
        Thu, 10 Feb 2022 07:55:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 31AEF1F391;
        Thu, 10 Feb 2022 15:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644508499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=OKxQrN6mxBbuh+p9hUZ4hw4C3t64iHUhouTTRpVebX8=;
        b=nq7k7eM8al3DcrjAZruKFoR4tSHWCiewh13/umjLkrWkppym26Fzhjr/iMMJe37EOzMxf9
        gm9IgSVX0MOgGwSvlKHJfCMiX93V4Wr9qNJsqFmhOJx6c8btpPfrgEeGyDeGT3iO5X5Lo1
        oTNPZUoDNGBxsQAyvCZELmzt2DrSD20=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E30E213BEF;
        Thu, 10 Feb 2022 15:54:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BzDCNVI1BWIVIQAAMHmgww
        (envelope-from <oneukum@suse.com>); Thu, 10 Feb 2022 15:54:58 +0000
From:   Oliver Neukum <oneukum@suse.com>
To:     bjorn@mork.no, linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [RFC] CDC-NCM: avoid overflow in sanity checking
Date:   Thu, 10 Feb 2022 16:54:55 +0100
Message-Id: <20220210155455.4601-1-oneukum@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A broken device may give an extreme offset like 0xFFF0
and a reasonable length for a fragment. In the sanity
check as formulated now, this will create an integer
overflow, defeating the sanity check. It needs to be
rewritten as a subtraction and the variables should be
unsigned.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/cdc_ncm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index e303b522efb5..f78fccbc4b93 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1715,10 +1715,10 @@ int cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in)
 {
 	struct sk_buff *skb;
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
-	int len;
+	unsigned int len;
 	int nframes;
 	int x;
-	int offset;
+	unsigned int offset;
 	union {
 		struct usb_cdc_ncm_ndp16 *ndp16;
 		struct usb_cdc_ncm_ndp32 *ndp32;
@@ -1791,7 +1791,7 @@ int cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in)
 		}
 
 		/* sanity checking */
-		if (((offset + len) > skb_in->len) ||
+		if ((offset > skb_in->len - len) ||
 				(len > ctx->rx_max) || (len < ETH_HLEN)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "invalid frame detected (ignored) offset[%u]=%u, length=%u, skb=%p\n",
-- 
2.34.1

