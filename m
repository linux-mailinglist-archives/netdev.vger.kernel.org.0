Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4F322AE14
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgGWLn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgGWLnz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:55 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF76120825;
        Thu, 23 Jul 2020 11:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504635;
        bh=1CzQqCTUmyLKEopK2Qer5LNolHABp6TF5qJ2CAF5T1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q07uqFck8wAQ/WUv0601A+HXx0vmbn5y90dCpgQmj8yd9B4pUQ5YCaUSSfoJD32BQ
         VcKwHq7T5wcq767A1HLUxyImxM50OHPQiQsyBK1yNYCU2tRyfdOL82osW3Qh4qNhU7
         A3ZA7XG+fcHBNTNLT6hAMhBElVdiOiFze1ioIyak=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 18/22] net: ixgbe: initialize mb bit in xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:30 +0200
Message-Id: <3f7a77d7cb269c5f362897d608b6173929e6f610.1595503780.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1595503780.git.lorenzo@kernel.org>
References: <cover.1595503780.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize multi-buffer bit (mb) to 0 in xdp_buff data structure.
This is a preliminary patch to enable xdp multi-buffer support.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 1 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 4d898ff21a46..327265ae3b68 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2303,6 +2303,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 #if (PAGE_SIZE < 8192)
 	xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, 0);
 #endif
+	xdp.mb = 0;
 
 	while (likely(total_rx_packets < budget)) {
 		union ixgbe_adv_rx_desc *rx_desc;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 6e9a397db583..134e8f1a0b77 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1133,6 +1133,7 @@ static int ixgbevf_clean_rx_irq(struct ixgbevf_q_vector *q_vector,
 	struct xdp_buff xdp;
 
 	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp.mb = 0;
 
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
 #if (PAGE_SIZE < 8192)
-- 
2.26.2

