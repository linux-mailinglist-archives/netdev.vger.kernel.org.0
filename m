Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D3414955B
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 12:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgAYLtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 06:49:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgAYLtK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 06:49:10 -0500
Received: from p977.fit.wifi.vutbr.cz (unknown [147.229.117.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4B8820704;
        Sat, 25 Jan 2020 11:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579952949;
        bh=+JzB7yLZcr3orX5CcpEDPzmjOeC1wIQbj82tn5c4h7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awH3P2CJz+vJA6pW+CqKpDPvP877Qtm5XvrCU3vpFArdKL3YgezxeP+8jJWfiKP1m
         1bNqnUVfCjLI0GZEmYS4tYAm0ZOUskYNb2ckbXGM3uDGAXTb2Qe7G6nCJMuswV0pXO
         eZ65TywjGlaom0pop0tFQhEzjMvMlYdHTueL8aKA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: [PATCH net 2/2] net: socionext: fix xdp_result initialization in netsec_process_rx
Date:   Sat, 25 Jan 2020 12:48:51 +0100
Message-Id: <6c5c8394590826f4d69172cf31e95d44eae92245.1579952387.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <cover.1579952387.git.lorenzo@kernel.org>
References: <cover.1579952387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix xdp_result initialization in netsec_process_rx in order to not
increase rx counters if there is no bpf program attached to the xdp hook
and napi_gro_receive returns GRO_DROP

Fixes: ba2b232108d3c ("net: netsec: add XDP support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 0e12a9856aea..56c0e643f430 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -942,8 +942,8 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 		struct netsec_de *de = dring->vaddr + (DESC_SZ * idx);
 		struct netsec_desc *desc = &dring->desc[idx];
 		struct page *page = virt_to_page(desc->addr);
+		u32 xdp_result = NETSEC_XDP_PASS;
 		struct sk_buff *skb = NULL;
-		u32 xdp_result = XDP_PASS;
 		u16 pkt_len, desc_len;
 		dma_addr_t dma_handle;
 		struct xdp_buff xdp;
-- 
2.21.1

