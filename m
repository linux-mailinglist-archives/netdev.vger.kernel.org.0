Return-Path: <netdev+bounces-6447-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6DC3716522
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B5511C20ADC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E934F23C6D;
	Tue, 30 May 2023 14:52:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2E219516
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:52:38 +0000 (UTC)
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEE99C;
	Tue, 30 May 2023 07:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1685458358;
  x=1716994358;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=L4vUnBXtNja0+OWRdVrOfhc0fbcEoks5geNKas0s+Eg=;
  b=FWynHoZUxm+DE/neDwTE9RYFcSaVcM5rxkeLuBIsYc1NGScRaZo3vwoL
   XoukAwb/0w9cFVlYPu15ih10ypD+e3SMri1HRNc3kUGqvwpnLBnrfeza7
   OFNdWCChCquf4g/mEBCmD0MNil0Qmuo7/TjEmsxG2lQqmwjVAberGxy/0
   HR9CnPofN+Rp50UhpgY9gA58ljk3Xkq6dXDDTirws7BdjE3DQ6hGIzv38
   s+8lv1du1NbyMKvbgghNTGTi/jqft+Y+OWzuOSpJ0txg1ChH3ZbcJa6mR
   2P8yky3SuY4R4E/Lctp1MZz9N2Z5oPRvCJyCJo80Vn4o62+cNzZHaaFHv
   g==;
From: Andreas Svensson <andreas.svensson@axis.com>
To: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>
CC: <kernel@axis.com>, Andreas Svensson <andreas.svensson@axis.com>, "Baruch
 Siach" <baruch@tkos.co.il>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: dsa: mv88e6xxx: Increase wait after reset deactivation
Date: Tue, 30 May 2023 16:52:23 +0200
Message-ID: <20230530145223.1223993-1-andreas.svensson@axis.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A switch held in reset by default needs to wait longer until we can
reliably detect it.

An issue was observed when testing on the Marvell 88E6393X (Link Street).
The driver failed to detect the switch on some upstarts. Increasing the
wait time after reset deactivation solves this issue.

The updated wait time is now also the same as the wait time in the
mv88e6xxx_hardware_reset function.

Fixes: 7b75e49de424 ("net: dsa: mv88e6xxx: wait after reset deactivation")
Signed-off-by: Andreas Svensson <andreas.svensson@axis.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 64a2f2f83735..08a46ffd53af 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -7170,7 +7170,7 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 		goto out;
 	}
 	if (chip->reset)
-		usleep_range(1000, 2000);
+		usleep_range(10000, 20000);
 
 	/* Detect if the device is configured in single chip addressing mode,
 	 * otherwise continue with address specific smi init/detection.
-- 
2.30.2


