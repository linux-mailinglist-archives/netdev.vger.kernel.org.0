Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCADD25B137
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgIBQP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:15:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59766 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbgIBQNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:13:39 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kDVO8-0005jC-I8; Wed, 02 Sep 2020 16:13:32 +0000
From:   Colin King <colin.king@canonical.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] xsk: fix incorrect memory allocation failure check on dma_map->dma_pages
Date:   Wed,  2 Sep 2020 17:13:32 +0100
Message-Id: <20200902161332.199961-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The failed memory allocation check for dma_map->dma_pages is incorrect,
it is null checking dma_map and not dma_map->dma_pages. Fix this.

Addresses-Coverity: ("Logicall dead code")
Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/xdp/xsk_buff_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 795d7c81c0ca..5b00bc5707f2 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -287,7 +287,7 @@ static struct xsk_dma_map *xp_create_dma_map(struct device *dev, struct net_devi
 		return NULL;
 
 	dma_map->dma_pages = kvcalloc(nr_pages, sizeof(*dma_map->dma_pages), GFP_KERNEL);
-	if (!dma_map) {
+	if (!dma_map->dma_pages) {
 		kfree(dma_map);
 		return NULL;
 	}
-- 
2.27.0

