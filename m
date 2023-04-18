Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337F36E5AA3
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 09:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjDRHn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 03:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDRHn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 03:43:27 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6103A8;
        Tue, 18 Apr 2023 00:43:25 -0700 (PDT)
Received: from zrt-virtual-machine.localdomain ([10.21.199.38])
        (user=u202112078@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33I7d2Go022630-33I7d2Gp022630
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 18 Apr 2023 15:39:13 +0800
From:   Ruting Zhang <u202112078@hust.edu.cn>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     hust-os-kernel-patches@googlegroups.com,
        Ruting Zhang <u202112078@hust.edu.cn>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: wwan: iosm: fix a resource leak in probe
Date:   Tue, 18 Apr 2023 15:38:57 +0800
Message-Id: <20230418073858.36507-1-u202112078@hust.edu.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: u202112078@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/wwan/iosm/iosm_ipc_pcie.c:298 ipc_pcie_probe() Smatch warn:
missing unwind goto?
There is a resource leak in this place.

Fix it by changing "return ret" into "goto resources_req_fail".
Fixes: 035e3befc191 ("net: wwan: iosm: fix driver not working with INTEL_IOMMU disabled")

Signed-off-by: Ruting Zhang <u202112078@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
---
The issue is found by static analysis and remains untested.
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 5bf5a93937c9..33339e8af1dc 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -295,7 +295,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
 	ret = dma_set_mask(ipc_pcie->dev, DMA_BIT_MASK(64));
 	if (ret) {
 		dev_err(ipc_pcie->dev, "Could not set PCI DMA mask: %d", ret);
-		return ret;
+		goto resources_req_fail;
 	}
 
 	ipc_pcie_config_aspm(ipc_pcie);
-- 
2.34.1

