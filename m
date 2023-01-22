Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F846772A2
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 22:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjAVVXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 16:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjAVVXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 16:23:01 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80C31350B
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 13:22:58 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30MLM3Bp2545324
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Sun, 22 Jan 2023 21:22:05 GMT
Received: from canardo.dyn.mork.no (ip6-localhost [IPv6:0:0:0:0:0:0:0:1])
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPS id 30MLLwSc295469
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Sun, 22 Jan 2023 22:21:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674422518; bh=pEbD6rdrmrX5MNjXH05Pz0DxOFMtWaS9oD3WsLKiUQI=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=enVONNA5B6wH4kCe/IZQhDja9OTl2wqWrj4LbbWvjLNy8D7gIipg+yiBMC6yX1c6o
         z1jyAdD1zmJXWQn64ha6JL0JCgT2v/hxWQOG+luTY9D6XyPjiOPxx++ngaBN99029l
         pzyp12SQwAZo+XgMeDR+KMI8NzgXH2VSr7bYtT6g=
Received: (from bjorn@localhost)
        by canardo.dyn.mork.no (8.15.2/8.15.2/Submit) id 30MLLwnx295463;
        Sun, 22 Jan 2023 22:21:58 +0100
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v3 net 3/3] mtk_sgmii: enable PCS polling to allow SFP work
Date:   Sun, 22 Jan 2023 22:21:53 +0100
Message-Id: <20230122212153.295387-4-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230122212153.295387-1-bjorn@mork.no>
References: <20230122212153.295387-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Couzens <lynxis@fe80.eu>

Currently there is no IRQ handling (even the SGMII supports it).
Enable polling to support SFP ports.

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
[ bmork: changed "1" => "true" ]
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index c4261069b521..bb00de1003ac 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -187,6 +187,7 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
 			return PTR_ERR(ss->pcs[i].regmap);
 
 		ss->pcs[i].pcs.ops = &mtk_pcs_ops;
+		ss->pcs[i].pcs.poll = true;
 		ss->pcs[i].interface = PHY_INTERFACE_MODE_NA;
 	}
 
-- 
2.30.2

