Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1F514955A
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 12:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgAYLtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 06:49:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgAYLtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 06:49:06 -0500
Received: from p977.fit.wifi.vutbr.cz (unknown [147.229.117.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F200C20704;
        Sat, 25 Jan 2020 11:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579952946;
        bh=cskSgIKitgoWdwJ38kJ3gRDY9irF4/i9eaR8E1KNRXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvQWuSen6UKAvt2OWzKrWdNV0wrPDvqnabkvSO+9axL5S56ApqLSRzFZ0aQGLCmJC
         9QlVhU421OiNlQf19MCn+PMmcqTVY1T8Rt+iohAw48gU8QRb+ObmyU+7CHljCY/U0W
         1rfIj7G0NKMpTB8C74bhetAGthq+OWCrSf2ZwQ4o=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: [PATCH net 1/2] net: socionext: fix possible user-after-free in netsec_process_rx
Date:   Sat, 25 Jan 2020 12:48:50 +0100
Message-Id: <b66c3b2603da49706597d84aacb7ac8b4ffb1820.1579952387.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <cover.1579952387.git.lorenzo@kernel.org>
References: <cover.1579952387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix possible use-after-free in in netsec_process_rx that can occurs if
the first packet is sent to the normal networking stack and the
following one is dropped by the bpf program attached to the xdp hook.
Fix the issue defining the skb pointer in the 'budget' loop

Fixes: ba2b232108d3c ("net: netsec: add XDP support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 869a498e3b5e..0e12a9856aea 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -929,7 +929,6 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 	struct netsec_rx_pkt_info rx_info;
 	enum dma_data_direction dma_dir;
 	struct bpf_prog *xdp_prog;
-	struct sk_buff *skb = NULL;
 	u16 xdp_xmit = 0;
 	u32 xdp_act = 0;
 	int done = 0;
@@ -943,6 +942,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 		struct netsec_de *de = dring->vaddr + (DESC_SZ * idx);
 		struct netsec_desc *desc = &dring->desc[idx];
 		struct page *page = virt_to_page(desc->addr);
+		struct sk_buff *skb = NULL;
 		u32 xdp_result = XDP_PASS;
 		u16 pkt_len, desc_len;
 		dma_addr_t dma_handle;
-- 
2.21.1

