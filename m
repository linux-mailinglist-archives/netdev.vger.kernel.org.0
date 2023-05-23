Return-Path: <netdev+bounces-4699-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 469E470DF2C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:29:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFA23281289
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8361F18E;
	Tue, 23 May 2023 14:29:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D91B1F176
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:29:35 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9CEDD;
	Tue, 23 May 2023 07:29:32 -0700 (PDT)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id BA459854DA;
	Tue, 23 May 2023 16:29:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1684852170;
	bh=nyydpcvCYcJ2fkOSjPCLykhfksngix993L7ypy8jbD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyaaTNuvLGUaIL7yqBimu9B657MlehkS853B3qB0Wp/L15dQgCxtOT6R5kBq1a9k6
	 LMlLfnWUs9wQ/PZ37QUYHRWbFYGlCraXC+nupvOr1U4DhORUIvhj9MVg97LJ/rz+kO
	 hAzgE0+88MgwHtLj0RuIuSIuOMUcYx9qjIbIIB5Bv2r9rrlplxO2r5YgKDBE5r9ABB
	 nSYNoxx8XuFnSz0IlENoCTxdWEYy1uL7gGKbaKGgjSXLV6Spa6u0t3+XuZQTTK/L8s
	 QMg6Ro+57AzhSoPcF4CUj8JOBu97QZsZU8CePt9/gAmCGvjcRybXVdr+cPE1gCE9Yn
	 kHvDTdBv4f/8A==
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
Subject: [PATCH v7 1/3] dsa: marvell: Define .set_max_frame_size() function for mv88e6250 SoC family
Date: Tue, 23 May 2023 16:29:10 +0200
Message-Id: <20230523142912.2086985-2-lukma@denx.de>
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

Switches from mv88e6250 family (the marketing name - "Link Street",
including mv88e6020 and mv88e6071) need the possibility to setup the
maximal frame size, as they support frames up to 2048 bytes.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
Changes for v6:
- New patch

Changes for v7:
- Update commit message
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


