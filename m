Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94B3249FCC
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 15:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgHSN0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 09:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbgHSNPu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 09:15:50 -0400
Received: from lore-desk.redhat.com (unknown [151.48.139.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64E4F20825;
        Wed, 19 Aug 2020 13:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597842891;
        bh=Y061M4ar3nglvUj4QoM5qnmcswxlbE0Bc8f2da2JCd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=waDwV3ovAeJ0rxBu4jayO71bWU1iRbaFQefg0soVnP4nr1aSFfZ4c4oOL8abYiIf4
         fvpck8WMylgN+80uTgjmqHnvT8wVjPEGqG4u6toehGP1knZoyI7RyzhJKSL/SlkZLa
         ETjBNWG1nhUBq1OsnjGKTrTiFEtWJubfcwxPaixk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org
Subject: [PATCH net-next 3/6] net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
Date:   Wed, 19 Aug 2020 15:13:48 +0200
Message-Id: <08f8656e906ff69bd30915a6a37a01d5f0422194.1597842004.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1597842004.git.lorenzo@kernel.org>
References: <cover.1597842004.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
XDP remote drivers if this is a "non-linear" XDP buffer

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 832bbb8b05c8..36a3defa63fa 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2170,11 +2170,14 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	       struct bpf_prog *prog, struct xdp_buff *xdp,
 	       u32 frame_sz, struct mvneta_stats *stats)
 {
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	unsigned int len, data_len, sync;
 	u32 ret, act;
 
 	len = xdp->data_end - xdp->data_hard_start - pp->rx_offset_correction;
 	data_len = xdp->data_end - xdp->data;
+
+	xdp->mb = !!sinfo->nr_frags;
 	act = bpf_prog_run_xdp(prog, xdp);
 
 	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
-- 
2.26.2

