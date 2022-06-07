Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7810553FEC4
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 14:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240266AbiFGM2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 08:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiFGM2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 08:28:47 -0400
Received: from smtp.ruc.edu.cn (m177126.mail.qiye.163.com [123.58.177.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD7B5F8D0;
        Tue,  7 Jun 2022 05:28:43 -0700 (PDT)
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp.ruc.edu.cn (Hmail) with ESMTPSA id D86058008D;
        Tue,  7 Jun 2022 20:28:40 +0800 (CST)
From:   Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
To:     Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sameeh Jubran <sameehj@amazon.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] net: ena_netdev: fix resource leak
Date:   Tue,  7 Jun 2022 20:28:31 +0800
Message-Id: <20220607122831.32738-1-xiaohuizhang@ruc.edu.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUhPN1dZLVlBSVdZDwkaFQgSH1lBWUMYTE5WSUtIQ01ITxkaGB
        kaVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktITUpVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6P006Cio6MT0*Fxc8AU8iSzUe
        S1EwCkxVSlVKTU5PTUtPQklKTElNVTMWGhIXVQMSGhQTDhIBExoVHDsJDhhVHh8OVRgVRVlXWRIL
        WUFZSUtJVUpKSVVKSkhVSUpJWVdZCAFZQUlOSUo3Bg++
X-HM-Tid: 0a813e2379f42c20kusnd86058008d
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the handling of u132_hcd_init in commit f276e002793c
("usb: u132-hcd: fix resource leak"), we thought a patch might be
needed here as well.

If platform_driver_register fails, cleanup the allocated resource
gracefully.

Signed-off-by: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 6a356a6cee15..c0624ee8d867 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4545,13 +4545,17 @@ static struct pci_driver ena_pci_driver = {
 
 static int __init ena_init(void)
 {
+	int retval;
 	ena_wq = create_singlethread_workqueue(DRV_MODULE_NAME);
 	if (!ena_wq) {
 		pr_err("Failed to create workqueue\n");
 		return -ENOMEM;
 	}
+	retval = pci_register_driver(&ena_pci_driver);
+	if (retval)
+		destroy_workqueue(ena_wq);
 
-	return pci_register_driver(&ena_pci_driver);
+	return retval;
 }
 
 static void __exit ena_cleanup(void)
-- 
2.17.1

