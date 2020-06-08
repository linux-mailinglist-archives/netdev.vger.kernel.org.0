Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EAB1F21B6
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 00:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgFHWCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 18:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbgFHWCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 18:02:54 -0400
Received: from localhost.localdomain.com (unknown [151.48.128.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD7AF2074B;
        Mon,  8 Jun 2020 22:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591653774;
        bh=tuZCe8/XIL48jxk9PeigHg1u0l02XxI0zls81pAXqZE=;
        h=From:To:Cc:Subject:Date:From;
        b=NdLXcP7BWOhbfv3BlZ/grBY4WmiluN670TWlxZe/K1pGKiNFjCgAuqgKyMnsWn/YU
         gAXACiz5Pg3YPqQQ6aQv2A7G6XoZZAYFofbLojLdjDceoGNBnosVKPHGjyhdccVbFb
         DElordekR/QEQQopSHDPnRH1AUzZN3A1SzmTTuaI=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.petazzoni@bootlin.com,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: [PATCH net] net: mvneta: do not redirect frames during reconfiguration
Date:   Tue,  9 Jun 2020 00:02:39 +0200
Message-Id: <fd076dae0536d823e136ab4c114346602e02b6d7.1591653494.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable frames injection in mvneta_xdp_xmit routine during hw
re-configuration in order to avoid hardware hangs

Fixes: b0a43db9087a ("net: mvneta: add XDP_TX support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 4cc9abd61c43..946925bbcb2d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -452,11 +452,17 @@ struct mvneta_pcpu_port {
 	u32			cause_rx_tx;
 };
 
+enum {
+	__MVNETA_DOWN,
+};
+
 struct mvneta_port {
 	u8 id;
 	struct mvneta_pcpu_port __percpu	*ports;
 	struct mvneta_pcpu_stats __percpu	*stats;
 
+	unsigned long state;
+
 	int pkt_size;
 	void __iomem *base;
 	struct mvneta_rx_queue *rxqs;
@@ -2113,6 +2119,9 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 	struct netdev_queue *nq;
 	u32 ret;
 
+	if (unlikely(test_bit(__MVNETA_DOWN, &pp->state)))
+		return -ENETDOWN;
+
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
 
@@ -3568,12 +3577,16 @@ static void mvneta_start_dev(struct mvneta_port *pp)
 
 	phylink_start(pp->phylink);
 	netif_tx_start_all_queues(pp->dev);
+
+	clear_bit(__MVNETA_DOWN, &pp->state);
 }
 
 static void mvneta_stop_dev(struct mvneta_port *pp)
 {
 	unsigned int cpu;
 
+	set_bit(__MVNETA_DOWN, &pp->state);
+
 	phylink_stop(pp->phylink);
 
 	if (!pp->neta_armada3700) {
-- 
2.26.2

