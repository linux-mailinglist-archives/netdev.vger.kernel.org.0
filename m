Return-Path: <netdev+bounces-2049-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C291700177
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:27:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F03BF1C210FB
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 07:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C8E748D;
	Fri, 12 May 2023 07:27:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61C2748C
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 07:27:03 +0000 (UTC)
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5427E1FD4;
	Fri, 12 May 2023 00:26:59 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 225884000A;
	Fri, 12 May 2023 07:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1683876418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S6O6XHXGaPQp8FhdtCIzdi0IiRWPnFwN+hdXiZOfHu8=;
	b=KxyvAbq0qWquWrLLwZW0T1Qb1kS7X4uEX5m8UuleodbIqLG5sE+Eg/oAfw2ot0xOJWBCFu
	1qp9jjhi7q0J2KkZ5VoJBxsI5rXp7pZ6eOvwup6rhHhvJj5F/RyOznMRtzykfGgh+aKufE
	v0q5Oq/n7eu4A6XYq5aiDcfsBVyPr/6f1ps8J6hLt7clc+yEKy+j3KzWwMw57euKT0KIfd
	EDyMweb/TBLONwViuJkxv72vuzyqr4gKns4grC+nr5qlXRf2FXCxzoRF1YnmBY5C5O2ZnD
	aBkj4nO8Zm1R33K7T3eiCm89vYwCEgMZJOQqP0cRyc2cdNmTZ1WnSxj8MApJDA==
From: alexis.lothore@bootlin.com
To: andrew@lunn.ch,
	f.fainelli@gmail.com,
	olteanv@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: linux-renesas-soc@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	herve.codina@bootlin.com,
	miquel.raynal@bootlin.com,
	milan.stevanovic@se.com,
	jimmy.lalande@se.com,
	pascal.eberhard@se.com
Subject: [PATCH net v3 1/3] net: dsa: rzn1-a5psw: enable management frames for CPU port
Date: Fri, 12 May 2023 09:27:10 +0200
Message-Id: <20230512072712.82694-2-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512072712.82694-1-alexis.lothore@bootlin.com>
References: <20230512072712.82694-1-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Clément Léger <clement.leger@bootlin.com>

Currently, management frame were discarded before reaching the CPU port due
to a misconfiguration of the MGMT_CONFIG register. Enable them by setting
the correct value in this register in order to correctly receive management
frame and handle STP.

Fixes: 888cdb892b61 ("net: dsa: rzn1-a5psw: add Renesas RZ/N1 advanced 5 port switch driver")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
Changes since v2:
- move A5PSW_MGMT_CFG_ENABLE definition in this commit
---
 drivers/net/dsa/rzn1_a5psw.c | 2 +-
 drivers/net/dsa/rzn1_a5psw.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index 919027cf2012..8a419e2ffe2a 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -673,7 +673,7 @@ static int a5psw_setup(struct dsa_switch *ds)
 	}
 
 	/* Configure management port */
-	reg = A5PSW_CPU_PORT | A5PSW_MGMT_CFG_DISCARD;
+	reg = A5PSW_CPU_PORT | A5PSW_MGMT_CFG_ENABLE;
 	a5psw_reg_writel(a5psw, A5PSW_MGMT_CFG, reg);
 
 	/* Set pattern 0 to forward all frame to mgmt port */
diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
index c67abd49c013..b4fbf453ff74 100644
--- a/drivers/net/dsa/rzn1_a5psw.h
+++ b/drivers/net/dsa/rzn1_a5psw.h
@@ -36,7 +36,7 @@
 #define A5PSW_INPUT_LEARN_BLOCK(p)	BIT(p)
 
 #define A5PSW_MGMT_CFG			0x20
-#define A5PSW_MGMT_CFG_DISCARD		BIT(7)
+#define A5PSW_MGMT_CFG_ENABLE		BIT(6)
 
 #define A5PSW_MODE_CFG			0x24
 #define A5PSW_MODE_STATS_RESET		BIT(31)
-- 
2.40.1


