Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152C146C8B1
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242815AbhLHAde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:33:34 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55840 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhLHAdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 19:33:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EFA86CE1ECA;
        Wed,  8 Dec 2021 00:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E928BC341C5;
        Wed,  8 Dec 2021 00:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638923397;
        bh=rORyKjECn4pwxkj+rs4DbYycXgiRJxCbKUSgWRiAebQ=;
        h=Date:From:To:Cc:Subject:From;
        b=KnuhaJVeAOyNp6OdxNYo33gUdD9MdJY3AEBJVVXFZrbHNGKvZXGC7/Mb8txpvVJCH
         V+Ls4K8zqaOvx3qtGKQBb098QmJ9asldY179YN2lfw+tPnVBuv62rt2LhGCUrh9Igw
         i3+Uqmxn7X4k7kc+7KLe1meSCDX/gZ2tcwunva2Vem8aXLJGHCpee/t4O5RuuvJdRh
         8xTkxxo+vCLcrVVxPgOAoZ08cCpH1deSeNirKI2fepMvv6h2CREt9ZZ2EvLzXViTMu
         Mm+C1DZVh7kZh4udspYEwD1ys6SIB1nfoKvWbCT/NZ69scZbHv73zorRm0+W/s/Jwt
         jsPT/q/TdKZog==
Date:   Tue, 7 Dec 2021 18:35:27 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: hinic: Use devm_kcalloc() instead of
 devm_kzalloc()
Message-ID: <20211208003527.GA75483@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 2-factor multiplication argument form devm_kcalloc() instead
of devm_kzalloc().

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_io.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
index a6e43d686293..c4a0ba6e183a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
@@ -375,31 +375,30 @@ int hinic_io_create_qps(struct hinic_func_to_io *func_to_io,
 {
 	struct hinic_hwif *hwif = func_to_io->hwif;
 	struct pci_dev *pdev = hwif->pdev;
-	size_t qps_size, wq_size, db_size;
 	void *ci_addr_base;
 	int i, j, err;
 
-	qps_size = num_qps * sizeof(*func_to_io->qps);
-	func_to_io->qps = devm_kzalloc(&pdev->dev, qps_size, GFP_KERNEL);
+	func_to_io->qps = devm_kcalloc(&pdev->dev, num_qps,
+				       sizeof(*func_to_io->qps), GFP_KERNEL);
 	if (!func_to_io->qps)
 		return -ENOMEM;
 
-	wq_size = num_qps * sizeof(*func_to_io->sq_wq);
-	func_to_io->sq_wq = devm_kzalloc(&pdev->dev, wq_size, GFP_KERNEL);
+	func_to_io->sq_wq = devm_kcalloc(&pdev->dev, num_qps,
+					 sizeof(*func_to_io->sq_wq), GFP_KERNEL);
 	if (!func_to_io->sq_wq) {
 		err = -ENOMEM;
 		goto err_sq_wq;
 	}
 
-	wq_size = num_qps * sizeof(*func_to_io->rq_wq);
-	func_to_io->rq_wq = devm_kzalloc(&pdev->dev, wq_size, GFP_KERNEL);
+	func_to_io->rq_wq = devm_kcalloc(&pdev->dev, num_qps,
+					 sizeof(*func_to_io->rq_wq), GFP_KERNEL);
 	if (!func_to_io->rq_wq) {
 		err = -ENOMEM;
 		goto err_rq_wq;
 	}
 
-	db_size = num_qps * sizeof(*func_to_io->sq_db);
-	func_to_io->sq_db = devm_kzalloc(&pdev->dev, db_size, GFP_KERNEL);
+	func_to_io->sq_db = devm_kcalloc(&pdev->dev, num_qps,
+					 sizeof(*func_to_io->sq_db), GFP_KERNEL);
 	if (!func_to_io->sq_db) {
 		err = -ENOMEM;
 		goto err_sq_db;
-- 
2.27.0

