Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3DB22C070
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 10:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgGXIH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 04:07:27 -0400
Received: from mail.zju.edu.cn ([61.164.42.155]:17430 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726572AbgGXIH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 04:07:26 -0400
Received: from localhost.localdomain (unknown [210.32.144.186])
        by mail-app4 (Coremail) with SMTP id cS_KCgAHiPyplhpfXiRFAA--.33653S4;
        Fri, 24 Jul 2020 16:07:09 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] octeontx2-af: Fix use of uninitialized pointer bmap
Date:   Fri, 24 Jul 2020 16:06:57 +0800
Message-Id: <20200724080657.19182-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgAHiPyplhpfXiRFAA--.33653S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tw17Wr47KFyxuw4fCF17KFg_yoW8Xr18pF
        W29FZ7AFyUXrW3Wa1Dta10qF45tw1a9F98Kayqkw1Sg34Fyrn5Xr4rKFWfXrsFkFWUGa47
        t3Z0y3y5ur98JrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9v1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxE
        wVAFwVW8ZwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1l4I8I3I
        0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
        GVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI
        0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0
        rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr
        0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUjNJ55UUUUU==
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAggHBlZdtPRcawAPs4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If req->ctype does not match any of NIX_AQ_CTYPE_CQ,
NIX_AQ_CTYPE_SQ or NIX_AQ_CTYPE_RQ, pointer bmap will remain
uninitialized and be accessed in test_bit(), which can lead
to kernal crash.

Fix this by returning an error code if this case is triggered.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 36953d4f51c7..20a64ed24474 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -869,19 +869,18 @@ static int nix_lf_hwctx_disable(struct rvu *rvu, struct hwctx_disable_req *req)
 		aq_req.cq_mask.bp_ena = 1;
 		q_cnt = pfvf->cq_ctx->qsize;
 		bmap = pfvf->cq_bmap;
-	}
-	if (req->ctype == NIX_AQ_CTYPE_SQ) {
+	} else if (req->ctype == NIX_AQ_CTYPE_SQ) {
 		aq_req.sq.ena = 0;
 		aq_req.sq_mask.ena = 1;
 		q_cnt = pfvf->sq_ctx->qsize;
 		bmap = pfvf->sq_bmap;
-	}
-	if (req->ctype == NIX_AQ_CTYPE_RQ) {
+	} else if (req->ctype == NIX_AQ_CTYPE_RQ) {
 		aq_req.rq.ena = 0;
 		aq_req.rq_mask.ena = 1;
 		q_cnt = pfvf->rq_ctx->qsize;
 		bmap = pfvf->rq_bmap;
-	}
+	} else
+		return NIX_AF_ERR_AQ_ENQUEUE;
 
 	aq_req.ctype = req->ctype;
 	aq_req.op = NIX_AQ_INSTOP_WRITE;
-- 
2.17.1

