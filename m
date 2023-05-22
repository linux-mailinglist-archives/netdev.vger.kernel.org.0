Return-Path: <netdev+bounces-4278-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AEC6F70BDE7
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:25:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69AD6280E25
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A08C16428;
	Mon, 22 May 2023 12:17:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4ED1640D
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:17:22 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF3C1703;
	Mon, 22 May 2023 05:17:09 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-96f5d651170so717215666b.1;
        Mon, 22 May 2023 05:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757827; x=1687349827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BR4WaMfs6beJCKcHWOQHHYOIrYTJQ7SOSyqfSGCZK48=;
        b=nwiwhL23+3X1oPllcBS1eFqvx6YOW0qrnjo6coLOpG+/Db0N6PmxOO20Bgw4/Ko7jC
         NNQFp+/ri7bHwwBz1/mJDxdeV7ipq02QonFCuub9e8XWjjowcJenASuiwMeUCw7AmKBq
         ZTd7O2Nbd9X1aRA1nGMwka7Cu/XaR7hXZxF4WzI+1gTuK3kFppDxa5C+QUxNnmp8L49h
         ZRJepRgXz5UXIkIh9T2ToZJIfwb5dZYtSxMf994Xd1X2OO6S6XpTcyUS7S7P1o5LreyU
         Nv87UeNeTA4S9RSGc5qa8+EULyB46WbQOvE5VuO5jQuqp7gNlsRVEegDRBiChqB+ds3h
         IhlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757827; x=1687349827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BR4WaMfs6beJCKcHWOQHHYOIrYTJQ7SOSyqfSGCZK48=;
        b=Wk88Isiivb+N5CnrhVjc5D3RWdK0vQn3ZYyVUtCLQ7xbmZpBTkdACZSkJSC7Dzxf0h
         //oNQnEyHs6jNb7M9u/9QxOP+maL4z0qXWy9OzHM/5lVrNAGOdqKxxnXcW0jsvUBrVuW
         guElToUQBQ9yCSLcJ3r2FFkIESxYS3sQeRrLTHGxPjGlH0VX8KB5wBuG3u5/ZsvgBL3w
         psKlEnejZh8stISxq80gxfFCnl7pK4Bc9bYKA68njkm0JbGSy9zEPSRFFQnEK3hc9dJF
         GC9NAqab1Lq625/KHlCV8ELnEpzA3gg7rgmkLueZF3EahyUwj0VRczx3CAz9fVgwdEtC
         YpTA==
X-Gm-Message-State: AC+VfDzK/aLNkopz1biCb1NipLknuhZfbguHOA6wZBJGSmBi+2yvmJ8/
	4gQqM9kk4Z+RfIDULLO0bpg=
X-Google-Smtp-Source: ACHHUZ56qzah9yxHVqSw1YLNAtp+w9qL77H/bmaw8t3TgdQHUL42y3kfN0W7hPVk5MauUttl9OVMrA==
X-Received: by 2002:a17:907:7211:b0:96f:8afc:b310 with SMTP id dr17-20020a170907721100b0096f8afcb310mr6981274ejc.3.1684757827140;
        Mon, 22 May 2023 05:17:07 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:17:06 -0700 (PDT)
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
Subject: [PATCH net-next 27/30] net: dsa: mt7530: introduce BPDU trapping for MT7530 switch
Date: Mon, 22 May 2023 15:15:29 +0300
Message-Id: <20230522121532.86610-28-arinc.unal@arinc9.com>
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

The MT753X switches are capable of trapping certain frames. Introduce
trapping BPDUs to the CPU port for the MT7530 switch.

BPDUs will be trapped to the numerically smallest CPU port which is affine
to the DSA conduit interface that is set up. The BPDUs won't necessarily be
trapped to the CPU port the user port, which these BPDUs are received from,
is affine to.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index cd16911fcb01..2fb4b0bc6335 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2223,6 +2223,10 @@ mt7530_setup(struct dsa_switch *ds)
 	val |= MHWTRAP_MANUAL;
 	mt7530_write(priv, MT7530_MHWTRAP, val);
 
+	/* Trap BPDUs to the CPU port */
+	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
+		   MT753X_BPDU_CPU_ONLY);
+
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
-- 
2.39.2


