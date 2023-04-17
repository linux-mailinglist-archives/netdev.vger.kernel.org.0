Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7754A6E4747
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbjDQMMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjDQMMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:12:53 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693A47296;
        Mon, 17 Apr 2023 05:12:20 -0700 (PDT)
Received: from lnk.. ([10.12.190.56])
        (user=lnk_01@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33HC06ws003063-33HC06wt003063
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 17 Apr 2023 20:00:10 +0800
From:   Li Ningke <lnk_01@hust.edu.cn>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
        Carl Huang <quic_cjhuang@quicinc.com>,
        P Praneesh <quic_ppranees@quicinc.com>
Cc:     hust-os-kernel-patches@googlegroups.com,
        Li Ningke <lnk_01@hust.edu.cn>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
        Baochen Qiang <quic_bqiang@quicinc.com>,
        Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath12k: fix missing unwind goto in `ath12k_pci_probe`
Date:   Mon, 17 Apr 2023 11:59:21 +0000
Message-Id: <20230417115921.176229-1-lnk_01@hust.edu.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: lnk_01@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch complains that
drivers/net/wireless/ath/ath12k/pci.c:1198 ath12k_pci_probe() warn: 
missing unwind goto?

In order to release the allocated resources before returning an
error, the statement that directly returns the error is changed
to a goto statement that first releases the resources in the error
handling section.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Li Ningke <lnk_01@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
---
The issue is found by static analysis and the patch remains untested.
---
 drivers/net/wireless/ath/ath12k/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index ae7f6083c9fc..f523aa15885f 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1195,7 +1195,8 @@ static int ath12k_pci_probe(struct pci_dev *pdev,
 			dev_err(&pdev->dev,
 				"Unknown hardware version found for QCN9274: 0x%x\n",
 				soc_hw_version_major);
-			return -EOPNOTSUPP;
+			ret = -EOPNOTSUPP;
+			goto err_pci_free_region;
 		}
 		break;
 	case WCN7850_DEVICE_ID:
-- 
2.34.1

