Return-Path: <netdev+bounces-4256-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8CCC70BD5B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 810BE280FAB
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20AB113AD1;
	Mon, 22 May 2023 12:16:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8DA13ACD
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:16:50 +0000 (UTC)
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AF310EA;
	Mon, 22 May 2023 05:16:26 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-969f90d71d4so899872066b.3;
        Mon, 22 May 2023 05:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757761; x=1687349761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQcn9eyXcNEwugtqgEyoEot5MQa0J15Im9Ea15IZnyQ=;
        b=iGd4d/eNlJZWp2oXmaFPGGvB5V+LnVfT+TDU23AHK6BJWyfqj4MIXVhPvxvSSmYdiD
         hFkMako8wOCbJ6MGfmKCdq0sVmPEOIYyWpfAMNHTvoed7ZnqfPxJDHIOU9jkK46Rulpu
         JB+wLkKYP+OI669v6S3A5Wx1Lcn7P9Zf3XT8UrEMoNIs7nPNGjYdZOty+n8qYW1giRXG
         pF2lrrZ42uixJ/c5QcjIZ3LXVNb1NDFlNJ9ZgVPNkmg8ZsjQuBQo0jLgR4dWiFk02WwE
         nzJzvP5IGGEcfh/KhCI2C4ZUpLoku20jDywnG4bjkM0/QO/T0sGAZqmEtWEO/HkE3m0v
         CdNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757761; x=1687349761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LQcn9eyXcNEwugtqgEyoEot5MQa0J15Im9Ea15IZnyQ=;
        b=PHf9roHod3BftlwmLocCVT5QBU8HmnBJWcQw8k4imCPdWf+f4UMQgEgIh2l4zifR0P
         KNqfhjwC1cua1WqXF8m17D7gGXgVCfnL92JobyFhe5/tHTIPjBYCLVEf8RDd0JNg/KZy
         fw5XqlZL9/yV4Cy+LDmexTgn8QM2hODZEzojy5Tupn9HLL7DaLUHiAqBaL8yos0SeM3C
         6LPPB9spXPB3/XesXLr+T0QEMtF3K96cSYWl1GyYJx+xm9+HWa9NKx2uAxH2VNLA1cT8
         KEKAuFX57grf8lHOwPBOeE4E8I1vAzJnRFFj2mMyqY9vTs7wXFiNm79AKp6/9detn2mA
         vT2Q==
X-Gm-Message-State: AC+VfDzxxbgpGHvO9RUkHTGirV0FelQq8QIC5iTECaPIX+fcICKf8wWl
	smwBzBkPz/CkvbBPFReHw00=
X-Google-Smtp-Source: ACHHUZ5P+tKIaefrm8CRNcI/l3sCxAnxzWr5pEupyw+ftNKshFpNzvCL9rsXwjaSvX7GdKaUmeoQKw==
X-Received: by 2002:a17:907:704:b0:967:769e:a098 with SMTP id xb4-20020a170907070400b00967769ea098mr8290807ejb.15.1684757760705;
        Mon, 22 May 2023 05:16:00 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:16:00 -0700 (PDT)
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
Subject: [PATCH net-next 05/30] net: dsa: mt7530: read XTAL value from correct register
Date: Mon, 22 May 2023 15:15:07 +0300
Message-Id: <20230522121532.86610-6-arinc.unal@arinc9.com>
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

On commit 7ef6f6f8d237 ("net: dsa: mt7530: Add MT7621 TRGMII mode support")
macros for reading the crystal frequency were added under the MT7530_HWTRAP
register. However, the value given to the xtal variable on
mt7530_pad_clk_setup() is read from the MT7530_MHWTRAP register instead.

Although the document MT7621 Giga Switch Programming Guide v0.3 states that
the value can be read from both registers, use the register where the
macros were defined under.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index b28d66a7c0b2..1a842d6fbc27 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -406,7 +406,7 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	struct mt7530_priv *priv = ds->priv;
 	u32 ncpo1, ssc_delta, trgint, xtal;
 
-	xtal = mt7530_read(priv, MT7530_MHWTRAP) & HWTRAP_XTAL_MASK;
+	xtal = mt7530_read(priv, MT7530_HWTRAP) & HWTRAP_XTAL_MASK;
 
 	if (xtal == HWTRAP_XTAL_20MHZ) {
 		dev_err(priv->dev,
-- 
2.39.2


