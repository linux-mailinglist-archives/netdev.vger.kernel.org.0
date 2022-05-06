Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C889A51E288
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444709AbiEFWTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444700AbiEFWTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:19:20 -0400
Received: from smtp1.emailarray.com (smtp1.emailarray.com [65.39.216.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244E8F0E
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:15:35 -0700 (PDT)
Received: (qmail 14031 invoked by uid 89); 6 May 2022 22:15:33 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 6 May 2022 22:15:33 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next v2 01/10] ptp: ocp: 32-bit fixups for pci start address
Date:   Fri,  6 May 2022 15:15:22 -0700
Message-Id: <20220506221531.1308-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220506221531.1308-1-jonathan.lemon@gmail.com>
References: <20220506221531.1308-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 'resource_size_t' instead of 'unsigned long' when computing the
pci start address, for the benefit of 32-bit platforms.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 65e592ec272e..9bd83ee8b93f 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1404,7 +1404,7 @@ static const struct devlink_ops ptp_ocp_devlink_ops = {
 };
 
 static void __iomem *
-__ptp_ocp_get_mem(struct ptp_ocp *bp, unsigned long start, int size)
+__ptp_ocp_get_mem(struct ptp_ocp *bp, resource_size_t start, int size)
 {
 	struct resource res = DEFINE_RES_MEM_NAMED(start, size, "ptp_ocp");
 
@@ -1414,7 +1414,7 @@ __ptp_ocp_get_mem(struct ptp_ocp *bp, unsigned long start, int size)
 static void __iomem *
 ptp_ocp_get_mem(struct ptp_ocp *bp, struct ocp_resource *r)
 {
-	unsigned long start;
+	resource_size_t start;
 
 	start = pci_resource_start(bp->pdev, 0) + r->offset;
 	return __ptp_ocp_get_mem(bp, start, r->size);
@@ -1428,7 +1428,7 @@ ptp_ocp_set_irq_resource(struct resource *res, int irq)
 }
 
 static void
-ptp_ocp_set_mem_resource(struct resource *res, unsigned long start, int size)
+ptp_ocp_set_mem_resource(struct resource *res, resource_size_t start, int size)
 {
 	struct resource r = DEFINE_RES_MEM(start, size);
 	*res = r;
@@ -1441,7 +1441,7 @@ ptp_ocp_register_spi(struct ptp_ocp *bp, struct ocp_resource *r)
 	struct pci_dev *pdev = bp->pdev;
 	struct platform_device *p;
 	struct resource res[2];
-	unsigned long start;
+	resource_size_t start;
 	int id;
 
 	start = pci_resource_start(pdev, 0) + r->offset;
@@ -1468,7 +1468,7 @@ ptp_ocp_i2c_bus(struct pci_dev *pdev, struct ocp_resource *r, int id)
 {
 	struct ptp_ocp_i2c_info *info;
 	struct resource res[2];
-	unsigned long start;
+	resource_size_t start;
 
 	info = r->extra;
 	start = pci_resource_start(pdev, 0) + r->offset;
-- 
2.31.1

