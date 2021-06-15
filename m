Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB343A7F6D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhFONaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230146AbhFON37 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 09:29:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86D3961474;
        Tue, 15 Jun 2021 13:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623763675;
        bh=mne4/DxiogxCmcs1XlEDrh6D/Q+G4LwKYHNeIX0G448=;
        h=From:To:Cc:Subject:Date:From;
        b=XPEywf+5EUdjUptF3GM0q+qMyYsJm+qJ8dohI3e2dP4FdgOzIKu8fAJgjCPQJcO14
         M62AUiYB5cNlygFHo+GJZXYDIRfV0X4y2e7nPFI4Ozz+Ho5jjIPSxWYSKdQ0fN6bwv
         ABYHpWXLoqHooVgpgBenaUw9PYG882xyEdtCIZtmhteXEntd0B01m38ycjL4OzBxLI
         5zZ3RkitLCfdoC/GPJjZvMZI8KuhqFFL99hMYlkQNH98XcQPqlnVZLayjDwM+gdmaR
         4JiXFFcmu7rJUccxY0ctaVxKs98XKGTpHDa7m67qA3SM+z7j65p1jQXOslUr9Yz2Ot
         rbJwlFeaqjfuw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        grygorii.strashko@ti.com, mcroce@linux.microsoft.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: [PATCH net-next] net: ti: add pp skb recycling support
Date:   Tue, 15 Jun 2021 15:27:41 +0200
Message-Id: <fa2ec166605fc2a60d9ed5e74bc349bd1e322b8d.1623763509.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As already done for mvneta and mvpp2, enable skb recycling for ti
ethernet drivers

ti driver on net-next:
----------------------
[perf top]
 47.15%  [kernel]     [k] _raw_spin_unlock_irqrestore
 11.77%  [kernel]     [k] __cpdma_chan_free
  3.16%  [kernel]     [k] ___bpf_prog_run
  2.52%  [kernel]     [k] cpsw_rx_vlan_encap
  2.34%  [kernel]     [k] __netif_receive_skb_core
  2.27%  [kernel]     [k] free_unref_page
  2.26%  [kernel]     [k] kmem_cache_free
  2.24%  [kernel]     [k] kmem_cache_alloc
  1.69%  [kernel]     [k] __softirqentry_text_start
  1.61%  [kernel]     [k] cpsw_rx_handler
  1.19%  [kernel]     [k] page_pool_release_page
  1.19%  [kernel]     [k] clear_bits_ll
  1.15%  [kernel]     [k] page_frag_free
  1.06%  [kernel]     [k] __dma_page_dev_to_cpu
  0.99%  [kernel]     [k] memset
  0.94%  [kernel]     [k] __alloc_pages_bulk
  0.92%  [kernel]     [k] kfree_skb
  0.85%  [kernel]     [k] packet_rcv
  0.78%  [kernel]     [k] page_address
  0.75%  [kernel]     [k] v7_dma_inv_range
  0.71%  [kernel]     [k] __lock_text_start

[iperf3 tcp]
[  5]   0.00-10.00  sec   873 MBytes   732 Mbits/sec    0   sender
[  5]   0.00-10.01  sec   866 MBytes   726 Mbits/sec        receiver

ti + skb recycling:
-------------------
[perf top]
 40.58%  [kernel]    [k] _raw_spin_unlock_irqrestore
 16.18%  [kernel]    [k] __softirqentry_text_start
 10.33%  [kernel]    [k] __cpdma_chan_free
  2.62%  [kernel]    [k] ___bpf_prog_run
  2.05%  [kernel]    [k] cpsw_rx_vlan_encap
  2.00%  [kernel]    [k] kmem_cache_alloc
  1.86%  [kernel]    [k] __netif_receive_skb_core
  1.80%  [kernel]    [k] kmem_cache_free
  1.63%  [kernel]    [k] cpsw_rx_handler
  1.12%  [kernel]    [k] cpsw_rx_mq_poll
  1.11%  [kernel]    [k] page_pool_put_page
  1.04%  [kernel]    [k] _raw_spin_unlock
  0.97%  [kernel]    [k] clear_bits_ll
  0.90%  [kernel]    [k] packet_rcv
  0.88%  [kernel]    [k] __dma_page_dev_to_cpu
  0.85%  [kernel]    [k] kfree_skb
  0.80%  [kernel]    [k] memset
  0.71%  [kernel]    [k] __lock_text_start
  0.66%  [kernel]    [k] v7_dma_inv_range
  0.64%  [kernel]    [k] gen_pool_free_owner

[iperf3 tcp]
[  5]   0.00-10.00  sec   884 MBytes   742 Mbits/sec    0   sender
[  5]   0.00-10.01  sec   878 MBytes   735 Mbits/sec        receiver

Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c     | 4 ++--
 drivers/net/ethernet/ti/cpsw_new.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index b1e80cc96f56..cbbd0f665796 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -430,8 +430,8 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		cpts_rx_timestamp(cpsw->cpts, skb);
 	skb->protocol = eth_type_trans(skb, ndev);
 
-	/* unmap page as no netstack skb page recycling */
-	page_pool_release_page(pool, page);
+	/* mark skb for recycling */
+	skb_mark_for_recycle(skb, page, pool);
 	netif_receive_skb(skb);
 
 	ndev->stats.rx_bytes += len;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 8d4f3c53385d..57d279fdcc9f 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -373,8 +373,8 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		cpts_rx_timestamp(cpsw->cpts, skb);
 	skb->protocol = eth_type_trans(skb, ndev);
 
-	/* unmap page as no netstack skb page recycling */
-	page_pool_release_page(pool, page);
+	/* mark skb for recycling */
+	skb_mark_for_recycle(skb, page, pool);
 	netif_receive_skb(skb);
 
 	ndev->stats.rx_bytes += len;
-- 
2.31.1

