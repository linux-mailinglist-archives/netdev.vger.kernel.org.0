Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0DB67B925
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbjAYSTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235929AbjAYSTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:19:01 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195AC599A9
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 10:18:49 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30PIGEwI135833
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 18:16:15 GMT
Received: from canardo.dyn.mork.no (ip6-localhost [IPv6:0:0:0:0:0:0:0:1])
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPS id 30PIG9wX861939
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 19:16:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674670569; bh=Glgu/yk2U5EWQt75/QlM/u6TaWcg4FLsGoFLNc2dM8Q=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=jLHfsB+9vn9M1pra5DqILplh5sOkspMhCmwaInSgUgKKiowN+vyDyP5LxUJvVbylI
         /futpt6EyhEeQyCNB6QOe/lvShcEm8deayrSEp+SK6pk31DojCA5bH3XjlXgVvP5Ir
         47I1UarfpMSn/Xj7b20W2TbLWq3Y32p0teo7sVMY=
Received: (from bjorn@localhost)
        by canardo.dyn.mork.no (8.15.2/8.15.2/Submit) id 30PIG9S9861935;
        Wed, 25 Jan 2023 19:16:09 +0100
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v4 net 3/3] mtk_sgmii: enable PCS polling to allow SFP work
Date:   Wed, 25 Jan 2023 19:16:02 +0100
Message-Id: <20230125181602.861843-4-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230125181602.861843-1-bjorn@mork.no>
References: <20230125181602.861843-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
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

