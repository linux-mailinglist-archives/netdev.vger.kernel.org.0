Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6148F103DCA
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 15:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbfKTOyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 09:54:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729157AbfKTOyk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 09:54:40 -0500
Received: from localhost.localdomain.com (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56781206F4;
        Wed, 20 Nov 2019 14:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574261680;
        bh=CQ03LOxX3qfdQP4gLMGjQolBpXCyqwlZgmCwjn9Oe/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PfP2qTLzfzarcHRep5tayN0+iJM748bIm/U1uCqn0ZroBVsIfpQQazyEAqkSB8ifV
         2AFSmE+xKxkTrXNMGASDLllEo2Q2nU0yX1T7Cxh9Fxwhl8bBssoeeFsI0nYwO+lqer
         BfSC9kJ2ASPoLMD4w5fvR8fcl86onakQQCgEAgHk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, ilias.apalodimas@linaro.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com, mcroce@redhat.com,
        jonathan.lemon@gmail.com
Subject: [PATCH v5 net-next 1/3] net: mvneta: rely on page_pool_recycle_direct in mvneta_run_xdp
Date:   Wed, 20 Nov 2019 16:54:17 +0200
Message-Id: <3642c3152a5d8ae30acac1f43097966511c438c2.1574261017.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1574261017.git.lorenzo@kernel.org>
References: <cover.1574261017.git.lorenzo@kernel.org>
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
index 12e03b15f0ab..f7713c2c68e1 100644
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

