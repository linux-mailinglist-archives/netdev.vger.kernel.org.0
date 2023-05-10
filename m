Return-Path: <netdev+bounces-1542-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 558FB6FE3B0
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:14:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C83F28152A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 18:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852B4174D6;
	Wed, 10 May 2023 18:14:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9703D60
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 18:14:12 +0000 (UTC)
Received: from mx.dolansoft.org (s2.dolansoft.org [212.51.146.245])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870F75FCB;
	Wed, 10 May 2023 11:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=brun.one;
	s=s1; h=MIME-Version:Message-Id:Date:Subject:Cc:To:From:In-Reply-To:
	References:From:To:Subject:Date:Message-ID:Reply-To;
	bh=/LAmKF4DLtcx5felrrpNMnAfkFOO/8RdGO8zQwg8+es=; b=T1Yq4crw8JW3+geXEFxaOBybrw
	eo0UatDttiInVbKyCe0sPqB4kg6n5jZ6N5MVpywpG8roXOqRcuoDtc82gYa1beSxoaKgRz9V+egRm
	4o6VF33Zf9wtC3o/q5/laqNEvMtyErKiC0HxMoo4Tp2wobdwGY8qUmNJNzBarKUhrngcQ+zRDeqTc
	IuKMhCtLp0hSaGDzcldSXVgyBE1QtK6SrAVpbKo14VhOBo147Vfra+RlENffr+k3Ki/QN7H1+lZqs
	qAW01qg0rxLuEPAUZgWfh55dfQHPrMWQ3706c+Y4T5rcCu4OyACjSUxqgxtr9ESG9M96yAujEQVXK
	9q12+9TA==;
Received: from [212.51.153.89] (helo=blacklava.cluster.local)
	by mx.dolansoft.org with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <lorenz@dolansoft.org>)
	id 1pwoK2-000oTu-1n;
	Wed, 10 May 2023 18:13:54 +0000
From: Lorenz Brun <lorenz@brun.one>
To: Felix Fietkau <nbd@nbd.name>,
	John Crispin <john@phrozen.org>,
	Sean Wang <sean.wang@mediatek.com>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v2 net-next] net: ethernet: mtk_eth_soc: log clock enable errors
Date: Wed, 10 May 2023 20:13:50 +0200
Message-Id: <20230510181350.3743141-1-lorenz@brun.one>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: lorenz@dolansoft.org
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently errors in clk_prepare_enable are silently swallowed.
Add a log stating which clock failed to be enabled and what the error
code was.

Signed-off-by: Lorenz Brun <lorenz@brun.one>
---
v2: reflowed long line
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e14050e17862..ced12e5b7b32 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3445,8 +3445,11 @@ static int mtk_clk_enable(struct mtk_eth *eth)
 
 	for (clk = 0; clk < MTK_CLK_MAX ; clk++) {
 		ret = clk_prepare_enable(eth->clks[clk]);
-		if (ret)
+		if (ret) {
+			dev_err(eth->dev, "enabling clock %s failed with error %d\n",
+				mtk_clks_source_name[clk], ret);
 			goto err_disable_clks;
+		}
 	}
 
 	return 0;
-- 
2.39.2


