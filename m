Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47E04DD351
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 03:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiCRCzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 22:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiCRCz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 22:55:28 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C7F1EF5EF
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 19:54:09 -0700 (PDT)
X-QQ-mid: bizesmtp75t1647572020t6n26plq
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 18 Mar 2022 10:53:33 +0800 (CST)
X-QQ-SSF: 01400000002000D0I000B00A0000000
X-QQ-FEAT: 9ftZnmyzxdiZygKhI/a9zsn2Ql3YkPwABNkaIECyxsLsHR0HX3LZxYTXcGRQN
        m/KV9Td9UttvaF421hJafNdN84yLyFLXh/3SwI7fhumPIHVOoHQgSiKgC6wYUJ4uBnotNI5
        yFUoyEco1kDAEXwtm7AV5ryuizUoeRS1ejNF4WSIdoDVNn7uPb2ClEkj+s6SFSQ96xRNEiY
        gkWb4KfvTqoNIcND6cSWlOwVAazxTUxi0TnJJ3aq933vRODCyB5Y11SzXTEefnQfefI9NYJ
        4P3CeX/j6o7pENkfjLH1G8vJqsf7I9ETEi0F2ql4tDe7sGBEKDp+l2ojgC7ytO/AjU2BZcW
        Y3rd8xrdbXQ4adIcfUgTADIuPO9iQ==
X-QQ-GoodBg: 2
From:   Meng Tang <tangmeng@uniontech.com>
To:     kvalo@kernel.org, davem@davemloft.net
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Meng Tang <tangmeng@uniontech.com>
Subject: [PATCH] net: wireless: ath10k: Use of_device_get_match_data() helper
Date:   Fri, 18 Mar 2022 10:53:31 +0800
Message-Id: <20220318025331.23030-1-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign8
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only the device data is needed, not the entire struct of_device_id.
Use of_device_get_match_data() instead of of_match_device().

Signed-off-by: Meng Tang <tangmeng@uniontech.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index ab8f77ae5e66..f0c615fa5614 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -728,20 +728,17 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
 	struct ath10k *ar;
 	struct ath10k_ahb *ar_ahb;
 	struct ath10k_pci *ar_pci;
-	const struct of_device_id *of_id;
 	enum ath10k_hw_rev hw_rev;
 	size_t size;
 	int ret;
 	struct ath10k_bus_params bus_params = {};
 
-	of_id = of_match_device(ath10k_ahb_of_match, &pdev->dev);
-	if (!of_id) {
-		dev_err(&pdev->dev, "failed to find matching device tree id\n");
+	hw_rev = (enum ath10k_hw_rev)of_device_get_match_data(&pdev->dev);
+	if (!hw_rev) {
+		dev_err(&pdev->dev, "OF data missing\n");
 		return -EINVAL;
 	}
 
-	hw_rev = (enum ath10k_hw_rev)of_id->data;
-
 	size = sizeof(*ar_pci) + sizeof(*ar_ahb);
 	ar = ath10k_core_create(size, &pdev->dev, ATH10K_BUS_AHB,
 				hw_rev, &ath10k_ahb_hif_ops);
-- 
2.20.1



