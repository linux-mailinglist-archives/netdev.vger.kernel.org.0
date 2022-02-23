Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163D44C090B
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237792AbiBWCda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbiBWCce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:32:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A655A085;
        Tue, 22 Feb 2022 18:30:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1981F6155B;
        Wed, 23 Feb 2022 02:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7871BC340FA;
        Wed, 23 Feb 2022 02:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583431;
        bh=HFHNgNb2sk/EDRKrFsACtTis3QDI7ANP8TMbbBEU5EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DoAk7CCscp7bMSVIZyGCbidYYTiUYH74aY0+Qd72mPoYliLhrV5vdAk99J8ByLg7R
         zG+Q7HDh5Lbn7xHP4IfTEa24JqzVo3NyK6GEPpwOTF3VBSDT3ZIms5kjc/wTVt23l+
         0Pm92j21qzd/Qn+8fb6ODulWJiKAkdFrXLzYpntp5T7z+hgcXtMBFQgKcVv/CBPqMX
         zO6m+VfWvBTB1KEg+eQOnoMqgDmozuW9v7Lt5eNDZ6g630fie33flyq2VBVLPsrF9G
         Mcc2ni9rl0RezhOmU+gv4Q46F7nStOFgY78DkaReGRRMb8Eh8kn6if/W6187OlFP+A
         1v80YeQCsi9RA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, oliver@neukum.org,
        kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 26/28] CDC-NCM: avoid overflow in sanity checking
Date:   Tue, 22 Feb 2022 21:29:27 -0500
Message-Id: <20220223022929.241127-26-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022929.241127-1-sashal@kernel.org>
References: <20220223022929.241127-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 8d2b1a1ec9f559d30b724877da4ce592edc41fdc ]

A broken device may give an extreme offset like 0xFFF0
and a reasonable length for a fragment. In the sanity
check as formulated now, this will create an integer
overflow, defeating the sanity check. Both offset
and offset + len need to be checked in such a manner
that no overflow can occur.
And those quantities should be unsigned.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index e303b522efb50..15f91d691bba3 100644
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
@@ -1790,8 +1790,8 @@ int cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in)
 			break;
 		}
 
-		/* sanity checking */
-		if (((offset + len) > skb_in->len) ||
+		/* sanity checking - watch out for integer wrap*/
+		if ((offset > skb_in->len) || (len > skb_in->len - offset) ||
 				(len > ctx->rx_max) || (len < ETH_HLEN)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "invalid frame detected (ignored) offset[%u]=%u, length=%u, skb=%p\n",
-- 
2.34.1

