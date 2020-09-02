Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A014725AF82
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgIBPk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgIBPBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 11:01:40 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC42420773;
        Wed,  2 Sep 2020 15:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599058900;
        bh=SK4nYvO38qvVRfI/Lx8Yp9FVil1zW/NL6C0b8WMtpDY=;
        h=Date:From:To:Cc:Subject:From;
        b=BSxzT0UhH6iH/VFnsyIqFh13nXQdv0+lMtmij304PLzD8hz9ikKgrcqSpXzwWvUhu
         /yvS865el3WOJMemRt8gE56J3AyNFmxGF8DUtdRZVaZDq+YsrvJhL8B8yL1eYB5upC
         4gULEkenKgB316QOdpwYOnl0EWeaJXgCVnWsp1kM=
Date:   Wed, 2 Sep 2020 10:07:50 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] xsk: Fix null check on error return path
Message-ID: <20200902150750.GA7257@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, dma_map is being checked, when the right object identifier
to be null-checked is dma_map->dma_pages, instead.

Fix this by null-checking dma_map->dma_pages.

Addresses-Coverity-ID: 1496811 ("Logically dead code")
Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
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

