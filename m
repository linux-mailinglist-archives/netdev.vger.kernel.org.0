Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A09A6ADC45
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 11:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCGKrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 05:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjCGKrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 05:47:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5468A14EB2;
        Tue,  7 Mar 2023 02:47:31 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327844Eo002231;
        Tue, 7 Mar 2023 10:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=/tJZ3YePYEELuocuqcOTMWUm8BXxNbj3l4AIZJllPnc=;
 b=09Z6MRQKK+W7TIbWUTSzYuqnAcP5aCEEW/AgWmYCg7rtI7Ve1+Rs1xSw9uxaVjM70okn
 bEanX38tbANrZOPOHqQGgONPzTwKy5nUPDxRSfeMyqILEXvs2Sfetl6jriyqjRtnx6nt
 IBDP82Er1jNG3ihw90PHsmj4m0cmInKEaLGaLW+eg/1S1QiiKON1T1n2JcZCVCNDQopg
 8C6WDqM2c46kuXx4xmM8pLw/NPwbWNoQTSFXmRuD4rwnMwVhsjM3rAl+FkhImKHyDFm9
 70uXCJhmFnbn5rHMguBpYsu5watTU0trUkPKOZgiGkiP+UXMmpl+M3065VmbL5vyA3Wt 2w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4161w529-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 10:47:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 327AGvID037021;
        Tue, 7 Mar 2023 10:47:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4txeahvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 10:47:13 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 327AlDvT022134;
        Tue, 7 Mar 2023 10:47:13 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p4txeahut-1;
        Tue, 07 Mar 2023 10:47:13 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     error27@gmail.com,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        P Praneesh <quic_ppranees@quicinc.com>,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
        Wen Gong <quic_wgong@quicinc.com>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath12k: Add missing unwind goto in ath12k_pci_probe()
Date:   Tue,  7 Mar 2023 02:47:06 -0800
Message-Id: <20230307104706.240119-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_04,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070097
X-Proofpoint-GUID: Y8xNgqQ2VEOOh30QKLX5QqXehDa4Q4Po
X-Proofpoint-ORIG-GUID: Y8xNgqQ2VEOOh30QKLX5QqXehDa4Q4Po
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch Warns:
	drivers/net/wireless/ath/ath12k/pci.c:1198 ath12k_pci_probe()
	warn: missing unwind goto?

Store the error value in ret and use correct label with a goto.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/all/Y+426q6cfkEdb5Bv@kili/
Suggested-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
Only Compile tested, found with Smatch.
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
2.38.1

