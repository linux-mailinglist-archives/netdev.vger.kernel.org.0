Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 473DFF68D8
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 13:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfKJMJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 07:09:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbfKJMJj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 07:09:39 -0500
Received: from localhost.localdomain (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D76020818;
        Sun, 10 Nov 2019 12:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573387779;
        bh=Qk2GPzSFxxUXozjbxTEfX/lmLRqZXUDgmuEsyW0k+yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzGY/g3Z0QxH+HpazvCwdWETR7I6vzWtzntlnjabguzo9FY1KgeCrDMTfHpUDwupr
         WQc82rtwgnVvsx4ehJ3akNEHXrDrCoL3Hd4KnDQvYDf+0ugLk3gvYjQGhuVWG+vojH
         sw0uJWqa4GRYEP7BaT+nnmVFGLHf/FB+4t8wLZBc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com
Subject: [PATCH net-next 1/3] net: mvneta: rely on page_pool_recycle_direct in mvneta_run_xdp
Date:   Sun, 10 Nov 2019 14:09:08 +0200
Message-Id: <0f1be1e37107c7bb6e9829881373b5a9d4312611.1573383212.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1573383212.git.lorenzo@kernel.org>
References: <cover.1573383212.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rely on page_pool_recycle_direct and not on xdp_return_buff in
mvneta_run_xdp. This is a preliminary patch to limit the dma sync len
to the one strictly necessary

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 274ac39c0f0f..ed93eecb7485 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2097,7 +2097,8 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		err = xdp_do_redirect(pp->dev, xdp, prog);
 		if (err) {
 			ret = MVNETA_XDP_DROPPED;
-			xdp_return_buff(xdp);
+			page_pool_recycle_direct(rxq->page_pool,
+						 virt_to_head_page(xdp->data));
 		} else {
 			ret = MVNETA_XDP_REDIR;
 		}
@@ -2106,7 +2107,8 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	case XDP_TX:
 		ret = mvneta_xdp_xmit_back(pp, xdp);
 		if (ret != MVNETA_XDP_TX)
-			xdp_return_buff(xdp);
+			page_pool_recycle_direct(rxq->page_pool,
+						 virt_to_head_page(xdp->data));
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-- 
2.21.0

