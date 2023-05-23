Return-Path: <netdev+bounces-4701-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FECD70DF33
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C2B21C20DAF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BCD91F949;
	Tue, 23 May 2023 14:30:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1701F946
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:30:06 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EAA133;
	Tue, 23 May 2023 07:30:03 -0700 (PDT)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id DA750859F2;
	Tue, 23 May 2023 16:29:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1684852171;
	bh=bP+bcaDzdQP+Oo+ZLuCx4BZqoPSyMeSyqmyMd8Bg6H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2SSx9qovhk+7bHcjYSF26x7FQuhdgrrrNkpCLPMITmcEvqKt6yOqCP7F/Dfyj5WF
	 a0fOGNK9SEfI1/7ZozoDRoeVY+/+NbJfHEgHX+9xvAzN/MOInFNVRcyhdPWg6ljLYs
	 UYCDqfrq7WreHnxHW56J/mn2Y0ur8tEVWGWWi7HBAQzTLLhZl/IwqkVb+CH/MRGZl+
	 GSelbqG+yLMAiv3KRRiMWfdD5RGaIKUwaSBClwpINt0RZxou3IbkSHmwanK2v6O3F/
	 a9BjW56mzQ6KYN31OyRlU0Va8i+RryWYTkltbeGAJrVFOPt9uLY3mQ6xybbbB/AMRh
	 pU5qJ5JhpEMjQ==
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
Subject: [PATCH v7 3/3] net: dsa: mv88e6xxx: add support for MV88E6071 switch
Date: Tue, 23 May 2023 16:29:12 +0200
Message-Id: <20230523142912.2086985-4-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230523142912.2086985-1-lukma@denx.de>
References: <20230523142912.2086985-1-lukma@denx.de>
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

A mv88e6250 family (i.e. "LinkStreet") switch with 5 internal PHYs,
2 RMIIs and no PTP support.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
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
---
 drivers/net/dsa/mv88e6xxx/chip.c | 20 ++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 drivers/net/dsa/mv88e6xxx/port.h |  1 +
 3 files changed, 22 insertions(+)

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
index 4cfb16375deb..128715df5772 100644
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


