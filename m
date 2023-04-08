Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B079A6DB93C
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 08:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjDHG4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 02:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDHG4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 02:56:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E64D501;
        Fri,  7 Apr 2023 23:56:42 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3383Waqj004888;
        Sat, 8 Apr 2023 06:56:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=gBdQ9z3RMrgblYJEU2yJN27X4Pd/JfytWfb4t7Ya1bI=;
 b=0RnLr7l/yqpn5vpncGx9jls5z6Y9P+mjK5NJC7RYfUS++uuGKpHyf5yjWRqOeTDCABfT
 C09+TwoTg+HsHJyWEFyuu+abGeIZJbwUU4MS8Erjmqp/wORWoKAjIMyPHY4FkOWMqiRs
 yhnZlZhfsFMgqrtHgQrw6oeumZ/ImbX5bkUQeTa6zzqA32pV5YJBYmnJu7UcrSBknjjM
 w+5n4gCXfDqUrsNSJ5o/JJyaxdyrSaNqxdlAVnhqxnAHYp4yRPSeUzdH9+BCxIW90/ka
 8wTC18c0J/eiyO0goRvHXv9SUG1FdsCYJ4vn6IeSddv8w1VOti3p414/7dUVqEebJCpa Og== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0eq04b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Apr 2023 06:56:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3383IZDH038795;
        Sat, 8 Apr 2023 06:56:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ptxq29n58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Apr 2023 06:56:26 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3386uP4w039417;
        Sat, 8 Apr 2023 06:56:25 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ptxq29n39-1;
        Sat, 08 Apr 2023 06:56:25 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, error27@gmail.com,
        simon.horman@corigine.com, kernel-janitors@vger.kernel.org,
        vegard.nossum@oracle.com,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH net] net: wwan: iosm: Fix error handling path in ipc_pcie_probe()
Date:   Fri,  7 Apr 2023 23:56:07 -0700
Message-Id: <20230408065607.1633970-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-08_01,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304080061
X-Proofpoint-GUID: OXpYRl3brXA8dabr4OUKqJvg65clH_IS
X-Proofpoint-ORIG-GUID: OXpYRl3brXA8dabr4OUKqJvg65clH_IS
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

Renamed the goto label as name of the label before this patch is not
relevant after this patch.

Fixes: 035e3befc191 ("net: wwan: iosm: fix driver not working with INTEL_IOMMU disabled")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
This is based on static analysis, only compile tested.
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 5bf5a93937c9..a6a6a0df1f7d 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -295,7 +295,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
 	ret = dma_set_mask(ipc_pcie->dev, DMA_BIT_MASK(64));
 	if (ret) {
 		dev_err(ipc_pcie->dev, "Could not set PCI DMA mask: %d", ret);
-		return ret;
+		goto err_disable_pci;
 	}
 
 	ipc_pcie_config_aspm(ipc_pcie);
@@ -308,7 +308,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
 	ipc_pcie->suspend = 0;
 
 	if (ipc_pcie_resources_request(ipc_pcie))
-		goto resources_req_fail;
+		goto err_disable_pci;
 
 	/* Establish the link to the imem layer. */
 	ipc_pcie->imem = ipc_imem_init(ipc_pcie, pci->device,
@@ -322,7 +322,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
 
 imem_init_fail:
 	ipc_pcie_resources_release(ipc_pcie);
-resources_req_fail:
+err_disable_pci:
 	pci_disable_device(pci);
 pci_enable_fail:
 	kfree(ipc_pcie);
-- 
2.38.1

