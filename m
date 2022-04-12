Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76264FC9D7
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 02:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243170AbiDLAsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 20:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242887AbiDLAsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:48:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9860B2ED5C;
        Mon, 11 Apr 2022 17:45:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21B5B617F3;
        Tue, 12 Apr 2022 00:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686A2C385AD;
        Tue, 12 Apr 2022 00:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724349;
        bh=Bcm/L4B9jJWb+jV5TvnT5U/PTAjme2W/RGdOOBuZDt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZOkFu1e6B7vGBK+a0X7vUxMUGLheKeypelhJb+TyGu3TytzMeDB9B8wqBazeZnMJ
         cvurx3zLXW+AuTvd0q89yT+MEswJbtvg033W/GvQ44AhgBOwLnvtLSv4NlQCn/GUbi
         WhZCuPFj6pBZ6pclhKJiUlS2JFbHUgMwLHxV//fG1YEm+aO7Syiwz3P0lgezHo9LUd
         W1aUXbDqZrynzH3LZRLv8DgKFTcmeuOc+e3kvEGbXxIc0tMiRuWok0YupC9wKAEsKN
         Jg2JY8rBKyOORcV7waPaF20BcrdwrCPYKXPGtTdDVsDPOWHtqg4uBvLk9n7q8F+ZA6
         UMeWKD1L0BL+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcin Kozlowski <marcinguy@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 32/49] net: usb: aqc111: Fix out-of-bounds accesses in RX fixup
Date:   Mon, 11 Apr 2022 20:43:50 -0400
Message-Id: <20220412004411.349427-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
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

From: Marcin Kozlowski <marcinguy@gmail.com>

[ Upstream commit afb8e246527536848b9b4025b40e613edf776a9d ]

aqc111_rx_fixup() contains several out-of-bounds accesses that can be
triggered by a malicious (or defective) USB device, in particular:

 - The metadata array (desc_offset..desc_offset+2*pkt_count) can be out of bounds,
   causing OOB reads and (on big-endian systems) OOB endianness flips.
 - A packet can overlap the metadata array, causing a later OOB
   endianness flip to corrupt data used by a cloned SKB that has already
   been handed off into the network stack.
 - A packet SKB can be constructed whose tail is far beyond its end,
   causing out-of-bounds heap data to be considered part of the SKB's
   data.

Found doing variant analysis. Tested it with another driver (ax88179_178a), since
I don't have a aqc111 device to test it, but the code looks very similar.

Signed-off-by: Marcin Kozlowski <marcinguy@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/aqc111.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index ea06d10e1c21..ca409d450a29 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -1102,10 +1102,15 @@ static int aqc111_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	if (start_of_descs != desc_offset)
 		goto err;
 
-	/* self check desc_offset from header*/
-	if (desc_offset >= skb_len)
+	/* self check desc_offset from header and make sure that the
+	 * bounds of the metadata array are inside the SKB
+	 */
+	if (pkt_count * 2 + desc_offset >= skb_len)
 		goto err;
 
+	/* Packets must not overlap the metadata array */
+	skb_trim(skb, desc_offset);
+
 	if (pkt_count == 0)
 		goto err;
 
-- 
2.35.1

