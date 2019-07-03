Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D1B5E9B3
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 18:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfGCQuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 12:50:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38729 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbfGCQuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 12:50:40 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hiiSr-00065L-BJ; Wed, 03 Jul 2019 16:50:37 +0000
From:   Colin King <colin.king@canonical.com>
To:     Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] gve: fix -ENOMEM null check on a page allocation
Date:   Wed,  3 Jul 2019 17:50:37 +0100
Message-Id: <20190703165037.3041-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the check to see if a page is allocated is incorrect
and is checking if the pointer page is null, not *page as
intended.  Fix this.

Addresses-Coverity: ("Dereference before null check")
Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 6a147ed4627f..6ea74c364a4b 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -516,7 +516,7 @@ int gve_alloc_page(struct device *dev, struct page **page, dma_addr_t *dma,
 		   enum dma_data_direction dir)
 {
 	*page = alloc_page(GFP_KERNEL);
-	if (!page)
+	if (!*page)
 		return -ENOMEM;
 	*dma = dma_map_page(dev, *page, 0, PAGE_SIZE, dir);
 	if (dma_mapping_error(dev, *dma)) {
-- 
2.20.1

