Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3910E368C7B
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240582AbhDWFWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240437AbhDWFV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:21:57 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD01C06138B;
        Thu, 22 Apr 2021 22:21:21 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id e2so20355368plh.8;
        Thu, 22 Apr 2021 22:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HlVoF4WBd28mr16LsVXI69/qoWczDKwnY5ulmKa3JqU=;
        b=PJqw7qbCVerNFMqSHMZJzZ+oDBUc8T1s4RQIMW64itnCYPn5unf5oOv9h5yu4Tv80a
         e1PEbJY4tA4JypLmdonjfmuV92iSNxIZiEfeLwgsjYsBBDq3nG6rWkKTJNIwTZAcCRpX
         /n4i//CxaXnSkPlW4l5365q/tShaCQswbt0Fs0/h4x+dDnGprpxCccXJbISBjtSIqCzS
         S032twqbKbFTD6jmzp4E4db8WyOnFKEIGhKQ+cTmEPH7Bg/pz+E9JrTj2Ca9WhDHFeQp
         Ro1FaVrnmMf71olrDnUNLHHaee+6dRtHpgS8O4aBHVHQpcO906KVNgmRx9ePq4/roMSn
         YwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HlVoF4WBd28mr16LsVXI69/qoWczDKwnY5ulmKa3JqU=;
        b=MrwQiYKLWchXIyKVEsnjTJRn25aktGGA/zM+rWI9EFjG0Bxep1R+aDrEEkn0lF+P9r
         tP795N5WanbgLasrae7zf7FqVvBYyJ0KYuHMVK1rsMh2M2mecH3SSiM+FQ5BBVRMm72G
         If309/SxgXwyxySZBm+7ftEYm/CfxxLT3po+DAqFOlGlFgwKAuNjrccgGfd9zlK5Yi08
         wr32Q+97lrwXPzNSfdbBBwHZwU6I1ytH+EmDhnRbHBtdKs5iab3xss7S5OfrmnPBzUhd
         OKVFNmmZbz5+Jb5tSQujn+HrzIBd2Qok7vDmIiBjxxrPSviPLXofJPwxB+ySMfRS7EIb
         uUMQ==
X-Gm-Message-State: AOAM53392D03e+6wUaF3FbXvCTDlxbgmTkN0LjM3ZhcktTbtSrwdw1wK
        qJdXcMvPzBiNtMz0sgdCiDM=
X-Google-Smtp-Source: ABdhPJxfR910IzfiJ+sHCtn/47cz6QgVT8Cwpw1BicgmMT5qd/MKnS0aDxdWUSWwkQH3YllxqCDcNQ==
X-Received: by 2002:a17:90a:fb87:: with SMTP id cp7mr3818203pjb.78.1619155280763;
        Thu, 22 Apr 2021 22:21:20 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:20 -0700 (PDT)
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
Subject: [PATCH net-next v2 03/15] net: ethernet: mtk_eth_soc: fix build_skb cleanup
Date:   Thu, 22 Apr 2021 22:20:56 -0700
Message-Id: <20210423052108.423853-4-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case build_skb fails, call skb_free_frag on the correct pointer. Also
update the DMA structures with the new mapping before exiting, because
the mapping was successful

Suggested-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 540003f3fcb8..07daa5de8bec 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1304,9 +1304,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		/* receive data */
 		skb = build_skb(data, ring->frag_size);
 		if (unlikely(!skb)) {
-			skb_free_frag(new_data);
+			skb_free_frag(data);
 			netdev->stats.rx_dropped++;
-			goto release_desc;
+			goto skip_rx;
 		}
 		skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
 
@@ -1326,6 +1326,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		skb_record_rx_queue(skb, 0);
 		napi_gro_receive(napi, skb);
 
+skip_rx:
 		ring->data[idx] = new_data;
 		rxd->rxd1 = (unsigned int)dma_addr;
 
-- 
2.31.1

