Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042734FCAE2
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240371AbiDLBCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345256AbiDLA6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:58:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A2A2FE76;
        Mon, 11 Apr 2022 17:51:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B2C4B815C8;
        Tue, 12 Apr 2022 00:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE46AC385A4;
        Tue, 12 Apr 2022 00:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724685;
        bh=Wlepa6YIr2hY5FeD4yQs2YIwB5qn8KB5kc30quQBXrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sp29ux/f+ByKrw1tqDZig35b/jNAf7dvxrjR0vgnNbRRvi6Jzov75lNCyGz+AoS0y
         RehVpAV8dtxLFIcnOQVtufvZ4W5MCV9kYsIjfTSwsuLquYPIXYhFYQNrbsA7l2e3r9
         9e9RaZDsMypH+IB5cfxxFKLvOrIMpLe18Yl8bLfqQdbLKUW+LsQALm0Eig2U/kBr3x
         u5DJWrW7d+Xcivsk8kKsvDP/CmKEuueGd7v6Rmm4Md6vEsS2E4MV8wC/HvnS8kRDig
         +k0Xs1bQ6mVKDzaygkW8qUgMZ1D7ENll/GLIJv5RQdGM2WGin+vJmz2PYMHVDkc8KN
         lzjd4bGmBrSIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcin Kozlowski <marcinguy@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/21] net: usb: aqc111: Fix out-of-bounds accesses in RX fixup
Date:   Mon, 11 Apr 2022 20:50:34 -0400
Message-Id: <20220412005042.351105-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005042.351105-1-sashal@kernel.org>
References: <20220412005042.351105-1-sashal@kernel.org>
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
index 7e44110746dd..68912e266826 100644
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

