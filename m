Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837DA367849
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhDVEKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhDVEKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:15 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AE6C06138C;
        Wed, 21 Apr 2021 21:09:39 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p16so18887391plf.12;
        Wed, 21 Apr 2021 21:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IhMuV7pk/e6sV7VUIyv8mgUtfEot/XwuLzvlzQOD9tE=;
        b=Qk50RbXnIUW3ik6C9BPq9pGE/g7IPmSF/zub/U4v6eFD9JYzpDwkpMh2dWa4LYF0Lz
         54kiRiI1+SrUhtd1xZEMQIF/luZ56IJBvynQzQgOFLegROKwyJWKS040JzeiMUEzbDq4
         hEGRAI3JbZclg1+zCKkPbE9gdEKnOg91hFQmkTDhHA09FRWQwq1lGwvV4yorElKuwCsY
         bq+foLDZHdCbyB8+XvO5L/qh0q2rbIUy0DgHc+V08aIdUkQSBZ0QRktS3BatdlhT7Q23
         l8Ih/fNd+vWMy2OweWy31wcVjSlqLxpR6vcmHFznz5eouZnqPHeRFi7uMYP56ZduOVm0
         JOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IhMuV7pk/e6sV7VUIyv8mgUtfEot/XwuLzvlzQOD9tE=;
        b=mwEIRCNEwAD2EP7Hp+VeCyCLbfXycbtE4Nc/VI6s41/jcCki4mMrP6fpwyT/Iw5vws
         PrirzmHTCWVgZFXi5akiSaJdt3u1HhD6ZAFX7jQKBFqQTrt7bMMuFSvyezu8Y6U0aC1G
         1PW+q+7EB1cTShNQH/nad1dofdbwvECly+7C3FTk0Y7m2LwSDb2reRTnX+RG3u8vReah
         EAPnsQOxkb5UdihZ1Q5k8Ofev/3RnR+/6nNOUNdOgZBZFepB4rZZzXptunyzwPB/t9lB
         7CnUDmtcUhOEWwOqOtoKQTPLmyjYFqTFJh1hxrjJgHKxCLbjw2BhTa9FpP26BXDt7ajP
         G2jA==
X-Gm-Message-State: AOAM5333oxYoR9pEJNbnGFukN1IbZNa49hae5npcwbUaSF/LQyE2GdEc
        H2B4QwWo6rgeo5KzIh4elQA=
X-Google-Smtp-Source: ABdhPJzg3V/PbtiIRa3CF472CaR81Ax8xdtPWol7R5JM+E25Dw25nASa8kWgFBbWcDd0jFjpUa+sLg==
X-Received: by 2002:a17:902:8693:b029:eb:53f:1336 with SMTP id g19-20020a1709028693b02900eb053f1336mr1466781plo.52.1619064579325;
        Wed, 21 Apr 2021 21:09:39 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:39 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 02/14] net: ethernet: mtk_eth_soc: unmap RX data before calling build_skb
Date:   Wed, 21 Apr 2021 21:09:02 -0700
Message-Id: <20210422040914.47788-3-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Since build_skb accesses the data area (for initializing shinfo), dma unmap
needs to happen before that call

Signed-off-by: Felix Fietkau <nbd@nbd.name>
[Ilya: split build_skb cleanup fix into a separate commit]
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b2175ec451ab..540003f3fcb8 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1298,6 +1298,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			goto release_desc;
 		}
 
+		dma_unmap_single(eth->dev, trxd.rxd1,
+				 ring->buf_size, DMA_FROM_DEVICE);
+
 		/* receive data */
 		skb = build_skb(data, ring->frag_size);
 		if (unlikely(!skb)) {
@@ -1307,8 +1310,6 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		}
 		skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
 
-		dma_unmap_single(eth->dev, trxd.rxd1,
-				 ring->buf_size, DMA_FROM_DEVICE);
 		pktlen = RX_DMA_GET_PLEN0(trxd.rxd2);
 		skb->dev = netdev;
 		skb_put(skb, pktlen);
-- 
2.31.1

