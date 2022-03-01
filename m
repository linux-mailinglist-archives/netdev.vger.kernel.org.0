Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CDA4C95F3
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 21:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiCAUSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 15:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238260AbiCAUSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 15:18:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC52923BCA;
        Tue,  1 Mar 2022 12:17:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77C5B61715;
        Tue,  1 Mar 2022 20:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEB7C340EE;
        Tue,  1 Mar 2022 20:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165850;
        bh=FTSM6DSbiOxEW6wNuPkqXpYZ5oFWR17UYBbYYSmZ1tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kywwQhQ0Wska5Q7OhxQVA9CZqTBaMoRzQ4POiv5cTVzFEEdriSKR+ZELKIsYpaUcQ
         NgdV4NqCn6QqxNH085Ig3icsQeHSZolDk80/VDEKVW3tDSOw/kpoSMIf4PXrEpcsag
         1TtIx6KKFzwOV5N4kFjo60vHo6/3G7/+5cbKQF3siAoBCPt2QIaLhKVHTB+mPqwtyM
         vwW518iJ31NaLE5227pQenlkIIa891Hq2unZ5wQo2i6JqJJF6+E1SC9xkov2hcK6en
         4GkUdhr37dfKR6AcEZamz4wzPgnK+KcrIjkL8YqE2tnyD1LOGBzPL62tBOmevBcHyL
         riQ9BQkyHhFGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        Grant Grundler <grundler@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        andrew@lunn.ch, arnd@arndb.de, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/23] sr9700: sanity check for packet length
Date:   Tue,  1 Mar 2022 15:16:11 -0500
Message-Id: <20220301201629.18547-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201629.18547-1-sashal@kernel.org>
References: <20220301201629.18547-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit e9da0b56fe27206b49f39805f7dcda8a89379062 ]

A malicious device can leak heap data to user space
providing bogus frame lengths. Introduce a sanity check.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/sr9700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 6516a37893e27..0c50f24671da3 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -410,7 +410,7 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		/* ignore the CRC length */
 		len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
-		if (len > ETH_FRAME_LEN)
+		if (len > ETH_FRAME_LEN || len > skb->len)
 			return 0;
 
 		/* the last packet of current skb */
-- 
2.34.1

