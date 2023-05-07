Return-Path: <netdev+bounces-762-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FE7C6F9C00
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 23:41:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 418081C209A8
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 21:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BF7A8486;
	Sun,  7 May 2023 21:41:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A1F33D4
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 21:41:01 +0000 (UTC)
Received: from mx.dolansoft.org (s2.dolansoft.org [212.51.146.245])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C3E7EC8;
	Sun,  7 May 2023 14:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=brun.one;
	s=s1; h=MIME-Version:Message-Id:Date:Subject:Cc:To:From:In-Reply-To:
	References:From:To:Subject:Date:Message-ID:Reply-To;
	bh=xuCzk6DqyZ2fCjPccft51jSbkGYvG1zx5q2m3ZeEIiA=; b=EMpeMXaoM3PTi/AWcqlqN4Vo+1
	GtwN/vl+G7Xo45snqlEQUsMovgZKPeNAJtrXwgKZqnya3SNbtvq61PkWDCJEthVoC6h0xJWXpvh/Z
	UyCWAS/GxSDxaBNLoKZ2ZU/xh5jvwbJJQqMzPNznAqucDdLNvlQglAFK1rekGp93vKS+8808PUoxw
	POvUq0936evFcMk+JzCQJurx7o8XHEt9PqKjQo6p0ks7S8bg1XKw5Nashdxq1Kn4+zPcxtp4eJgoH
	gj9kllXFbxcEiRqmD30K6kXtYYlrSx+inhW42RWx0wo4raAyvR8WkWXVliN5fgmnD7YXUF/B27b9o
	mZldzv0Q==;
Received: from [212.51.153.89] (helo=blacklava.cluster.local)
	by mx.dolansoft.org with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <lorenz@dolansoft.org>)
	id 1pvm7U-000fES-32;
	Sun, 07 May 2023 21:40:40 +0000
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
Subject: [PATCH] net: ethernet: mtk_eth_soc: log clock enable errors
Date: Sun,  7 May 2023 23:40:35 +0200
Message-Id: <20230507214035.3266438-1-lorenz@brun.one>
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
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e14050e17862..ca66a573cfcb 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3445,8 +3445,10 @@ static int mtk_clk_enable(struct mtk_eth *eth)
 
 	for (clk = 0; clk < MTK_CLK_MAX ; clk++) {
 		ret = clk_prepare_enable(eth->clks[clk]);
-		if (ret)
+		if (ret) {
+			dev_err(eth->dev, "enabling clock %s failed with error %d\n", mtk_clks_source_name[clk], ret);
 			goto err_disable_clks;
+		}
 	}
 
 	return 0;
-- 
2.39.2


