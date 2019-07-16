Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFB206A1F7
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 07:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfGPFzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 01:55:17 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40350 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfGPFzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 01:55:17 -0400
Received: by mail-pl1-f193.google.com with SMTP id a93so9501045pla.7
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 22:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RlCA90112tAvbzPxVBehLoEGm+dZ8qWusJBsaqezzKQ=;
        b=HJ0GlqX9vNn5vyxctp74cdCbjz9LEVbhrk+p9eA0p2nK9nPpRuTOort7hvWFlkEQZ1
         Ew7LwFerYdTHFIFvbadzxE6pOIveTNOWTcYInHyxxXbvcpvZ+2gR5FAOkqn4Kf2IfJwR
         A2rfO5rcuggbU94Cq/khoqv2jp11FtO2+ROyczZyLA4fvbTVcLGXXhndCw3Tgq6Qyedm
         wUIVNdsj8uHgxz7DWBwTvuLe4aJDGIHsPyrjAnwx3B/miZ7wNRAbBvaewiKh54ni9JDn
         F39jfn5yoQS1rt86M8KDzvEJ863o1kDCYTSC464UQbv7k0eZ0FQhs3Z57S0k1bRSLSiO
         RRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RlCA90112tAvbzPxVBehLoEGm+dZ8qWusJBsaqezzKQ=;
        b=EOYds4nl1l3GfXa9Y7PKFysFoGMlXhlWHasWNaQdCkmsLxnUtxbA7N4qXdNHI8PUxL
         BLTQcJ+V3bhwZ+/m0L/1eyuxIAbDAn44R5iLmGrJlliQGbq5Os4yEsS9ZMgyqibUk/xw
         z8CRX8UnWJjVqgXC2JGvaiPRM0wcQWBQuPlntVE0k7R+wv3OtspgMLXooaC1CwWe2Llt
         SlH3cEL+RVg0fklucBkBtgWLg5aLqSI4A3xKPV9aPJdbFXJ7nsArl9XylKJp6FxB3WJc
         d4CAn8fKg0cK0PGldTGr/+LMaVIDx/Losc5M6msm7gT8zxuvGO1Uu/YlVsncNpcjC3zh
         6ptg==
X-Gm-Message-State: APjAAAVEB7mu6shSO50EE4KNlODfWOMtjaLIZopaAgymrqHavE2ZC7L1
        YmyS9gZ0C9uBcfv4wPec4z0oClvG
X-Google-Smtp-Source: APXvYqxIcfcb9KUVUeGLcIrM9l2ZeilXyPBlIyHa8kHAGZnRTQBO3fAUfhL61rCxNjOQG/fTtECgpw==
X-Received: by 2002:a17:902:b186:: with SMTP id s6mr32909467plr.343.1563256517040;
        Mon, 15 Jul 2019 22:55:17 -0700 (PDT)
Received: from localhost.localdomain ([110.227.64.207])
        by smtp.gmail.com with ESMTPSA id d8sm14787330pgh.45.2019.07.15.22.55.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 22:55:16 -0700 (PDT)
From:   Nishka Dasgupta <nishkadg.linux@gmail.com>
To:     nbd@openwrt.org, john@phrozen.org, sean.wang@mediatek.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Nishka Dasgupta <nishkadg.linux@gmail.com>
Subject: [PATCH] net: ethernet: mediatek: mtk_eth_soc: Add of_node_put() before goto
Date:   Tue, 16 Jul 2019 11:25:04 +0530
Message-Id: <20190716055504.3113-1-nishkadg.linux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each iteration of for_each_child_of_node puts the previous node, but in
the case of a goto from the middle of the loop, there is no put, thus
causing a memory leak. Hence add an of_node_put before the goto.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b20b3a5a1ebb..c39d7f4ab1d4 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2548,8 +2548,10 @@ static int mtk_probe(struct platform_device *pdev)
 			continue;
 
 		err = mtk_add_mac(eth, mac_np);
-		if (err)
+		if (err) {
+			of_node_put(mac_np);
 			goto err_deinit_hw;
+		}
 	}
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SHARED_INT)) {
-- 
2.19.1

