Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF5C245FC5
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgHQIZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgHQIZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:25:01 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F33C061388;
        Mon, 17 Aug 2020 01:25:01 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y10so5573766plr.11;
        Mon, 17 Aug 2020 01:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ieaDS0kZabvaM2FQJESKDtwss85i612EBlDqx55UScQ=;
        b=r7fmQpvu0cXvpoW4a9CZ/cT3MW3lztUUfiJGRP8uWIdQW718lbHcerRIY+XPN5w2dW
         8g+GmL3UQQs5IIbiFNkDPeYmyJmo6J0G97FL2TFOQlxobIrYeQh4Dn+ntQyJsWRS19dy
         PTPV1tWwnnTudwXH3EQrSU8PuCBQePLEB3tvkFDsQf/gTFUy/QcukQKVyFRIHqYYhVbK
         XfL1vYS4KiGvTfyMx4FOO3+nJXthNtT0T5BY0uYgM16rcWekI1UZ4yLoM5VO2cIiYTSx
         p2FU4vZh0YJx9+hEx0TcRwmJdfBx6wOKgbsNWYUm9v0uh4ntUQD2A8SoKTqkRnAhIxsS
         Nk+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ieaDS0kZabvaM2FQJESKDtwss85i612EBlDqx55UScQ=;
        b=gweCUjG+xs/07YtEQdMp37lzPZlXjpa2ut93OLgY1Q8ibbHw3oTIw7R64BfcFCOomN
         uVJvilu1BMAO70Y6EKQvchp6sKfcwoxzzkPFihzGf0P5+v0rFvftVh1eHAD6rPqKokzb
         XvoNwfvh8rxoouyYVr53TCIxKjhUInSTBcBTfO9Om5sIzf+7Ch4OaMOUhYhyVfdaV7DA
         DfFQx5FaXX9uW73y3HKYhHnWCWp5YKsNWHWyA9SUiwirAd7KcT3ZWTxcZCMKSdz6lNeq
         4mA/gblIfnQHH6iYqkvd7fyz45vsgM+8RdtQJhOVP5A1MJbyLBqdYatO3q9uHa/eng8k
         276Q==
X-Gm-Message-State: AOAM530Yd/gR2yRxNfxRotmSoVhtWTt8MrJi0wEtYeb05O88nRBWtowc
        QRR/ZX8F1ybiDPwSdUHI9UU=
X-Google-Smtp-Source: ABdhPJwwdc3RrJJP+jyr+uic25vkwFOxlfTC4mqKC9ol3fps9vrV6VbuCUueQvJl/j2WyRrNR+MX0A==
X-Received: by 2002:a17:90b:100e:: with SMTP id gm14mr11406569pjb.39.1597652700729;
        Mon, 17 Aug 2020 01:25:00 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:25:00 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com
Cc:     keescook@chromium.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH] ethernet: cxgb4: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:15 +0530
Message-Id: <20200817082434.21176-3-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817082434.21176-1-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h           | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c | 3 +--
 drivers/net/ethernet/chelsio/cxgb4/sge.c             | 4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 9cb8b229c1b3..84fa9b8a9087 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -2100,7 +2100,7 @@ void free_tx_desc(struct adapter *adap, struct sge_txq *q,
 void cxgb4_eosw_txq_free_desc(struct adapter *adap, struct sge_eosw_txq *txq,
 			      u32 ndesc);
 int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc);
-void cxgb4_ethofld_restart(unsigned long data);
+void cxgb4_ethofld_restart(struct tasklet_struct *t);
 int cxgb4_ethofld_rx_handler(struct sge_rspq *q, const __be64 *rsp,
 			     const struct pkt_gl *si);
 void free_txq(struct adapter *adap, struct sge_txq *q);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index ae7123a9de8e..6c259de96f96 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -114,8 +114,7 @@ static int cxgb4_init_eosw_txq(struct net_device *dev,
 	eosw_txq->cred = adap->params.ofldq_wr_cred;
 	eosw_txq->hwqid = hwqid;
 	eosw_txq->netdev = dev;
-	tasklet_init(&eosw_txq->qresume_tsk, cxgb4_ethofld_restart,
-		     (unsigned long)eosw_txq);
+	tasklet_setup(&eosw_txq->qresume_tsk, cxgb4_ethofld_restart);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index e668e17711c8..482b2bd602e6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -3883,9 +3883,9 @@ static int napi_rx_handler(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-void cxgb4_ethofld_restart(unsigned long data)
+void cxgb4_ethofld_restart(struct tasklet_struct *t)
 {
-	struct sge_eosw_txq *eosw_txq = (struct sge_eosw_txq *)data;
+	struct sge_eosw_txq *eosw_txq = from_tasklet(eosw_txq, t, qresume_tsk);
 	int pktcount;
 
 	spin_lock(&eosw_txq->lock);
-- 
2.17.1

