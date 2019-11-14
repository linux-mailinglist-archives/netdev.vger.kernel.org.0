Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4228FC875
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 15:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfKNOLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 09:11:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfKNOLA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 09:11:00 -0500
Received: from localhost.localdomain.com (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5691020715;
        Thu, 14 Nov 2019 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573740660;
        bh=CQ03LOxX3qfdQP4gLMGjQolBpXCyqwlZgmCwjn9Oe/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxqM0WfABiNtvh5rlV6Qq9UxMOcNbqCNGT2bbN7S1uaEZZIrvjVsTwBEsWEgRiDBm
         Lr7gUNZmYcgOZWcYqGU0L4wUskP/skxkNaQLj+cyuJQ6e8B565ruQcjEGjxtPflyun
         iyX/AN/pHxbc3Pe9ryorejnSV8TZsOZRieYt0+0Y=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, ilias.apalodimas@linaro.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com, mcroce@redhat.com
Subject: [PATCH v2 net-next 1/3] net: mvneta: rely on page_pool_recycle_direct in mvneta_run_xdp
Date:   Thu, 14 Nov 2019 16:10:35 +0200
Message-Id: <3e131f374a23e091c7bc51aba36e74932e7a85ce.1573740067.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1573740067.git.lorenzo@kernel.org>
References: <cover.1573740067.git.lorenzo@kernel.org>
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

