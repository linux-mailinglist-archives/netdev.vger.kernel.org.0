Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40AE6DBCCC
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 21:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjDHTno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 15:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDHTnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 15:43:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595CD9030;
        Sat,  8 Apr 2023 12:43:42 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3383VKtL010821;
        Sat, 8 Apr 2023 19:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=AtS8zjXakwrxxJgPfeR+XZVojVzYcJTQIzBrMyrACHc=;
 b=CEA1kwYQIQ6DPeGxyYJ19CKXoQ6VUp73LYMPUQw2BQNzRMtlcFo/J6QQAFPPcNiY2wwP
 FpQ6dxQZI5sUkOLz5JpWT8seKIoaDfBOrRa8rev38NYuJaVzyuM9PqT0B+/hBEFiYPbw
 Ah+iAtVMjgBjtX0eL9PozfHn31oN+i8C+CTS5gGl04Z54u/iiGmTRMx4qwYMXpN360qB
 QLPUioeB4mS3+LQpLW6SnoSspMOWUJDH1ZGC28JOG9gP5iX/1emyXQkFI8fZWj1Kc/Tv
 zAQMWmOHSYcU51QI1fyNpe6htB5kHSpyG2SThGB93vHfrYJHkYm5fc/E/zvyXDEDrij2 hA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e78p7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Apr 2023 19:43:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 338ISV3s007788;
        Sat, 8 Apr 2023 19:43:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ptxq2x9m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Apr 2023 19:43:26 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 338JhQbv017594;
        Sat, 8 Apr 2023 19:43:26 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ptxq2x9m0-1;
        Sat, 08 Apr 2023 19:43:26 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, simon.horman@corigine.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, error27@gmail.com,
        kernel-janitors@vger.kernel.org, vegard.nossum@oracle.com,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH net V2] net: wwan: iosm: Fix error handling path in ipc_pcie_probe()
Date:   Sat,  8 Apr 2023 12:43:21 -0700
Message-Id: <20230408194321.1647805-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-08_10,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304080178
X-Proofpoint-ORIG-GUID: fC7E-TYjb7qbvc4q31wAUD1kF4K7nw6i
X-Proofpoint-GUID: fC7E-TYjb7qbvc4q31wAUD1kF4K7nw6i
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch reports:
	drivers/net/wwan/iosm/iosm_ipc_pcie.c:298 ipc_pcie_probe()
	warn: missing unwind goto?

When dma_set_mask fails it directly returns without disabling pci
device and freeing ipc_pcie. Fix this my calling a correct goto label

As dma_set_mask returns either 0 or -EIO, we can use a goto label, as
it finally returns -EIO.

Add a set_mask_fail goto label which stands consistent with other goto
labels in this function..

Fixes: 035e3befc191 ("net: wwan: iosm: fix driver not working with INTEL_IOMMU disabled")
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
This is based on static analysis, only compile tested.

v1 --> v2: Address comment by Simon Horman(better goto label name)
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 5bf5a93937c9..04517bd3325a 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -295,7 +295,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
 	ret = dma_set_mask(ipc_pcie->dev, DMA_BIT_MASK(64));
 	if (ret) {
 		dev_err(ipc_pcie->dev, "Could not set PCI DMA mask: %d", ret);
-		return ret;
+		goto set_mask_fail;
 	}
 
 	ipc_pcie_config_aspm(ipc_pcie);
@@ -323,6 +323,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
 imem_init_fail:
 	ipc_pcie_resources_release(ipc_pcie);
 resources_req_fail:
+set_mask_fail:
 	pci_disable_device(pci);
 pci_enable_fail:
 	kfree(ipc_pcie);
-- 
2.38.1

