Return-Path: <netdev+bounces-6289-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ABF17158C9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E26B21C20BAD
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8103A12B63;
	Tue, 30 May 2023 08:39:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7716E1118F
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:39:46 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189CAB2;
	Tue, 30 May 2023 01:39:45 -0700 (PDT)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 931F28471A;
	Tue, 30 May 2023 10:39:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685435983;
	bh=cLZlrJ12olakaKifdtSsUoi0/xDFWi90I9u1jms08mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yruDc+ek+wMYzASJKALSqRryivig4frl2ME68o+GDmCresAOqS3RsFzTSwRbo187C
	 CY2sNILCzgENzfNDnNhOGJeWiC5hId4GSEHiBrIKW80GbsrWeJEEIMVpJ8QrX5MKpc
	 JB7Inv4jNoG3eqiSqHZr3zsMVfVlTATVm6XumxRCicXWyYq0WkCuGN8O0WTLJafOzB
	 6FvC55iJmKgnTzlj/V4BfcqGImuEJf3kU/M/4BemlU7AwQ9deBvteylTF2QWjrXhkm
	 1HxrubF3qfz/u/21w8s40SqSDW8OKaxZi72cqkj09uF5k/z09f8GYSjuVA9ukfjHrv
	 oF1JSY2ZtBH1Q==
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
Subject: [PATCH v8 1/3] net: dsa: Define .set_max_frame_size() callback for mv88e6250 SoC family
Date: Tue, 30 May 2023 10:39:14 +0200
Message-Id: <20230530083916.2139667-2-lukma@denx.de>
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

Switches from mv88e6250 family (including mv88e6020 and mv88e6071) need
the possibility to setup the maximal frame size, as they support frames
up to 2048 bytes.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes for v6:
- New patch

Changes for v7:
- Update commit message

Changes for v8:
- Update commit message and subject line
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 64a2f2f83735..b5e43dd40431 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5043,6 +5043,7 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6250_ptp_ops,
 	.phylink_get_caps = mv88e6250_phylink_get_caps,
+	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
 static const struct mv88e6xxx_ops mv88e6290_ops = {
-- 
2.20.1


