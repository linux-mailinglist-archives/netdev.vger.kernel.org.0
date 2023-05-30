Return-Path: <netdev+bounces-6292-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 858E37158D4
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0014B1C20A0E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26DF134D4;
	Tue, 30 May 2023 08:39:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89B7134D2
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:39:47 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD65BF;
	Tue, 30 May 2023 01:39:45 -0700 (PDT)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id BD3AC8479D;
	Tue, 30 May 2023 10:39:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685435984;
	bh=6GJwBDDct10oVmEZtBr/h4GZj5W9Lqzw3dL+25QIt4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LR4fbbSlqmLJewmYht1nMbAK+cugHwex89ZhC3ZfNu8z8WrP+rTP2anEQf1jwbRG
	 rn1uTMWURbmTbW+HgZ4RIZNl7n/efc5wPo/P1zHxkjG0p4++ymd4ZMFfLk+vdzVFRf
	 eYhmlKAuIHr7pFlfMO44eP3XUsJm8r4TI36sFSxhCKTVkmEdDuuqOoR4S1xrfxEe6x
	 ioFZTNI/zdFHO+D+4ocWqW+7/h0pCXO1xb3R/D4FnBUPJzJMWSokQNe2ljlul0mzc7
	 vJzTPF6Of4LQCK6TNjHCzRxqW/v7HR4lB2ktRI1AV99vzaA6HSM0YSTwD5QDgrKizL
	 8NK2QBr43MExg==
From: Lukasz Majewski <lukma@denx.de>
To: Andrew Lunn <andrew@lunn.ch>,
	Vladimir Oltean <olteanv@gmail.com>,
	Russell King <linux@armlinux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukasz Majewski <lukma@denx.de>
Subject: [PATCH v8 3/3] net: dsa: mv88e6xxx: add support for MV88E6071 switch
Date: Tue, 30 May 2023 10:39:16 +0200
Message-Id: <20230530083916.2139667-4-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230530083916.2139667-1-lukma@denx.de>
References: <20230530083916.2139667-1-lukma@denx.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A mv88e6250 family switch with 5 internal PHYs, 2 RMIIs
and no PTP support.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes for v2:
- Update commit message
- Add information about max frame size

Changes for v3:
- None

Changes for v4:
- None

Changes for v5:
- None

Changes for v6:
- Reorder patches for better readiness

Changes for v7:
- Provide just support for this IC (remove the part with setting
  max frame info as it is not needed anymore)

Changes for v8:
- Update commit message and comment regarding mv88e6250 family
---
 drivers/net/dsa/mv88e6xxx/chip.c | 20 ++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  3 ++-
 drivers/net/dsa/mv88e6xxx/port.h |  1 +
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9cb76a5b8ff5..8d4c1ab4c85d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5663,6 +5663,26 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.ops = &mv88e6250_ops,
 	},
 
+	[MV88E6071] = {
+		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6071,
+		.family = MV88E6XXX_FAMILY_6250,
+		.name = "Marvell 88E6071",
+		.num_databases = 64,
+		.num_ports = 7,
+		.num_internal_phys = 5,
+		.max_vid = 4095,
+		.port_base_addr = 0x08,
+		.phy_base_addr = 0x00,
+		.global1_addr = 0x0f,
+		.global2_addr = 0x07,
+		.age_time_coeff = 15000,
+		.g1_irqs = 9,
+		.g2_irqs = 5,
+		.atu_move_port_mask = 0xf,
+		.dual_chip = true,
+		.ops = &mv88e6250_ops,
+	},
+
 	[MV88E6085] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6085,
 		.family = MV88E6XXX_FAMILY_6097,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e249d4a3f853..150a06de633f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -55,6 +55,7 @@ enum mv88e6xxx_frame_mode {
 /* List of supported models */
 enum mv88e6xxx_model {
 	MV88E6020,
+	MV88E6071,
 	MV88E6085,
 	MV88E6095,
 	MV88E6097,
@@ -95,7 +96,7 @@ enum mv88e6xxx_family {
 	MV88E6XXX_FAMILY_6097,	/* 6046 6085 6096 6097 */
 	MV88E6XXX_FAMILY_6165,	/* 6123 6161 6165 */
 	MV88E6XXX_FAMILY_6185,	/* 6108 6121 6122 6131 6152 6155 6182 6185 */
-	MV88E6XXX_FAMILY_6250,	/* 6220 6250 6020 */
+	MV88E6XXX_FAMILY_6250,	/* 6220 6250 6020 6071 */
 	MV88E6XXX_FAMILY_6320,	/* 6320 6321 */
 	MV88E6XXX_FAMILY_6341,	/* 6141 6341 */
 	MV88E6XXX_FAMILY_6351,	/* 6171 6175 6350 6351 */
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 56efba08abdc..e423ef13a827 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -112,6 +112,7 @@
 #define MV88E6XXX_PORT_SWITCH_ID		0x03
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_MASK	0xfff0
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6020	0x0200
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6071	0x0710
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6085	0x04a0
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6095	0x0950
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6097	0x0990
-- 
2.20.1


