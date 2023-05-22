Return-Path: <netdev+bounces-4271-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44BBD70BDC0
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2B7E28100F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8290514281;
	Mon, 22 May 2023 12:17:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C5115485
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:17:09 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22951FCC;
	Mon, 22 May 2023 05:16:51 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-96fd3a658eeso186902566b.1;
        Mon, 22 May 2023 05:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757806; x=1687349806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=50+e+zsfVv5J1BqpAiWf9C7KcKligVVxQwX0YPFvKBI=;
        b=sjnpuNcMC4vPuNPM5W8qAKHq8laEr0IiAs8Yv8iF7D6XCl2l39DG4sCvemNN4DXMs3
         ygsXI11bEbL4/sQHwESDh5EijbGBg0RFP7Bgk80DGY4cAwRo2iK+FiCX/ApZ+Pp5xjIH
         PoXGQ/fNfKgDR0sfgxwy/1E++kxv7CmxHSTppQ/sSAD/si0gUa4LHUf/78iNajzyzreo
         aRCWFhGX1GF6TLN/e+8vq6PeNM81ysMzgguyezsQRJ1g6kPblL8ZxH8mzUeRSvOUlbWP
         et0xQ/W7NAx3eCpXY2a52dWtedYRdKGxpOrP4dt1+TzYuTNxIoDpLv5/aKY8yyldcukJ
         ZHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757806; x=1687349806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=50+e+zsfVv5J1BqpAiWf9C7KcKligVVxQwX0YPFvKBI=;
        b=RSwFH6BSD0flXgrcsVlVJ7eL7t1s/xe0M8Yaw7NqzKnOR+NENHL+8izlqPrnIj2XJp
         FsXWRepKoVsAt7NEY3BdCm0Mlr9TL/gS/g8C/7xPccTaGI1uOfZUzxbM9UFrNSGQZ3hD
         XTlhlj87XIwjd0DJhPM6q30jJTGDUBtqxlRBCDaQffEXcq1XBJLh6QmqitzYf4bHRLod
         9l6Qh2FRH9naoSx5UefTwxlM0wcfkedfUa0sN2f3MYzC1mjZPMs+X8MlJDOEYpQacmuK
         LliEn/s59wXOXtMGYIsY9YKrxfo8o9a0x7/JpmgNbrQJVd+wEsipsars0YGy7warPMwL
         /bdA==
X-Gm-Message-State: AC+VfDyu+8cQvc3bHeBk+HyTp0v32Nq7KVrWQ7HRJEcITfHTcjQXzxKm
	HXBm2cYQrXeAHBIJDO7BzVM=
X-Google-Smtp-Source: ACHHUZ4M8Me0lXeuQHSHRWp3YouOQ/LLClhxE/remDAZsXN4DblDXCqROAKiLf/beTuFQ7E/eEU2Qw==
X-Received: by 2002:a17:907:60ce:b0:96a:f21f:ab64 with SMTP id hv14-20020a17090760ce00b0096af21fab64mr8346390ejc.49.1684757806185;
        Mon, 22 May 2023 05:16:46 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:16:45 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>
Cc: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com,
	mithat.guner@xeront.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 20/30] net: dsa: mt7530: properly reset MT7531 switch
Date: Mon, 22 May 2023 15:15:22 +0300
Message-Id: <20230522121532.86610-21-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230522121532.86610-1-arinc.unal@arinc9.com>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Arınç ÜNAL <arinc.unal@arinc9.com>

According to the document MT7531 Reference Manual for Development Board
v1.0, the SW_PHY_RST bit on the SYS_CTRL register doesn't exist for
MT7531. This is likely why forcing link-down on the MACs is necessary for
MT7531.

Therefore, do not set SW_PHY_RST on mt7531_setup().

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 0c261ef87bee..aafb7415e2ce 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2416,14 +2416,12 @@ mt7531_setup(struct dsa_switch *ds)
 	val = mt7530_read(priv, MT7531_TOP_SIG_SR);
 	priv->p5_sgmii = !!(val & PAD_DUAL_SGMII_EN);
 
-	/* all MACs must be forced link-down before sw reset */
+	/* Force link-down on all MACs before internal reset */
 	for (i = 0; i < MT7530_NUM_PORTS; i++)
 		mt7530_write(priv, MT7530_PMCR_P(i), MT7531_FORCE_LNK);
 
 	/* Reset the switch through internal reset */
-	mt7530_write(priv, MT7530_SYS_CTRL,
-		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
-		     SYS_CTRL_REG_RST);
+	mt7530_write(priv, MT7530_SYS_CTRL, SYS_CTRL_SW_RST | SYS_CTRL_REG_RST);
 
 	if (!priv->p5_sgmii) {
 		mt7531_pll_setup(priv);
-- 
2.39.2


