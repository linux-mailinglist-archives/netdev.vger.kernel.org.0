Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C7C694F17
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjBMSTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjBMSTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:19:15 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC4913506;
        Mon, 13 Feb 2023 10:19:11 -0800 (PST)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31DHGVQo006845;
        Mon, 13 Feb 2023 18:18:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=Y+Le7LwRjpxda1vxKUtObFrDXg1v7xhnLppJdxbxaWs=;
 b=l3yLtaChpVY0x4FcEVEWhZ2dGD7ztX/W9v9fbhcoG4WKtn8f6Q3COUb5vbQszkhUQ5Dl
 gBV+07cMpQHPDjptNaclDtp5eiR6IGKFvY3LLTRjZDkPKMjw+/PIkWgTEjyuP4KfwfNQ
 QkF+5E6umLnx1AMDwF9WKfcqkPlQ2ZpgcC5nv/Ko0gUhVzbKlelWmQYvSCNgBxiWTdej
 oleVaDGssOIoXVd7yCk4T+Z0SPC7febYbSDwQEEtes2Lm0UXwFr/1mXQ2tYi403Z2Xt5
 54a6uikWApmNt4xdDTgB9shCopH5xrKa3/e9DoTbr3uqYNAACmyg6d/6nKJwjAJ9oA3f dA== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3np4agcpw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 18:18:54 +0000
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 31DIIram000624
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 18:18:53 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 13 Feb 2023 10:18:51 -0800
From:   Elliot Berman <quic_eberman@quicinc.com>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Amol Maheshwari <amahesh@qti.qualcomm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
CC:     Elliot Berman <quic_eberman@quicinc.com>,
        Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-remoteproc@vger.kernel.org>
Subject: [PATCH] firmware: qcom_scm: Use fixed width src vm bitmap
Date:   Mon, 13 Feb 2023 10:18:29 -0800
Message-ID: <20230213181832.3489174-1-quic_eberman@quicinc.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: Vl4WWr97nClKVOvR-5PTydbX9DG6Bncr
X-Proofpoint-GUID: Vl4WWr97nClKVOvR-5PTydbX9DG6Bncr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_12,2023-02-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130163
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The maximum VMID for assign_mem is 63. Use a u64 to represent this
bitmap instead of architecture-dependent "unsigned int" which varies in
size on 32-bit and 64-bit platforms.

Acked-by: Kalle Valo <kvalo@kernel.org> (ath10k)
Tested-by: Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 drivers/firmware/qcom_scm.c            | 12 +++++++-----
 drivers/misc/fastrpc.c                 |  2 +-
 drivers/net/wireless/ath/ath10k/qmi.c  |  4 ++--
 drivers/remoteproc/qcom_q6v5_mss.c     |  8 ++++----
 drivers/remoteproc/qcom_q6v5_pas.c     |  2 +-
 drivers/soc/qcom/rmtfs_mem.c           |  2 +-
 include/linux/firmware/qcom/qcom_scm.h |  2 +-
 7 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 468d4d5ab550..b95616b35bff 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -905,7 +905,7 @@ static int __qcom_scm_assign_mem(struct device *dev, phys_addr_t mem_region,
  * Return negative errno on failure or 0 on success with @srcvm updated.
  */
 int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
-			unsigned int *srcvm,
+			u64 *srcvm,
 			const struct qcom_scm_vmperm *newvm,
 			unsigned int dest_cnt)
 {
@@ -922,9 +922,9 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 	__le32 *src;
 	void *ptr;
 	int ret, i, b;
-	unsigned long srcvm_bits = *srcvm;
+	u64 srcvm_bits = *srcvm;
 
-	src_sz = hweight_long(srcvm_bits) * sizeof(*src);
+	src_sz = hweight64(srcvm_bits) * sizeof(*src);
 	mem_to_map_sz = sizeof(*mem_to_map);
 	dest_sz = dest_cnt * sizeof(*destvm);
 	ptr_sz = ALIGN(src_sz, SZ_64) + ALIGN(mem_to_map_sz, SZ_64) +
@@ -937,8 +937,10 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 	/* Fill source vmid detail */
 	src = ptr;
 	i = 0;
-	for_each_set_bit(b, &srcvm_bits, BITS_PER_LONG)
-		src[i++] = cpu_to_le32(b);
+	for (b = 0; b < BITS_PER_TYPE(u64); b++) {
+		if (srcvm_bits & BIT(b))
+			src[i++] = cpu_to_le32(b);
+	}
 
 	/* Fill details of mem buff to map */
 	mem_to_map = ptr + ALIGN(src_sz, SZ_64);
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index a701132638cf..f48466960f1b 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -262,7 +262,7 @@ struct fastrpc_channel_ctx {
 	int domain_id;
 	int sesscount;
 	int vmcount;
-	u32 perms;
+	u64 perms;
 	struct qcom_scm_vmperm vmperms[FASTRPC_MAX_VMIDS];
 	struct rpmsg_device *rpdev;
 	struct fastrpc_session_ctx session[FASTRPC_MAX_SESSIONS];
diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 90f457b8e1fe..038c5903c0dc 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -33,7 +33,7 @@ static int ath10k_qmi_map_msa_permission(struct ath10k_qmi *qmi,
 {
 	struct qcom_scm_vmperm dst_perms[3];
 	struct ath10k *ar = qmi->ar;
-	unsigned int src_perms;
+	u64 src_perms;
 	u32 perm_count;
 	int ret;
 
@@ -65,7 +65,7 @@ static int ath10k_qmi_unmap_msa_permission(struct ath10k_qmi *qmi,
 {
 	struct qcom_scm_vmperm dst_perms;
 	struct ath10k *ar = qmi->ar;
-	unsigned int src_perms;
+	u64 src_perms;
 	int ret;
 
 	src_perms = BIT(QCOM_SCM_VMID_MSS_MSA) | BIT(QCOM_SCM_VMID_WLAN);
diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index ab053084f7a2..1ba711bc0100 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -235,8 +235,8 @@ struct q6v5 {
 	bool has_qaccept_regs;
 	bool has_ext_cntl_regs;
 	bool has_vq6;
-	int mpss_perm;
-	int mba_perm;
+	u64 mpss_perm;
+	u64 mba_perm;
 	const char *hexagon_mdt_image;
 	int version;
 };
@@ -414,7 +414,7 @@ static void q6v5_pds_disable(struct q6v5 *qproc, struct device **pds,
 	}
 }
 
-static int q6v5_xfer_mem_ownership(struct q6v5 *qproc, int *current_perm,
+static int q6v5_xfer_mem_ownership(struct q6v5 *qproc, u64 *current_perm,
 				   bool local, bool remote, phys_addr_t addr,
 				   size_t size)
 {
@@ -967,7 +967,7 @@ static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw,
 	unsigned long dma_attrs = DMA_ATTR_FORCE_CONTIGUOUS;
 	dma_addr_t phys;
 	void *metadata;
-	int mdata_perm;
+	u64 mdata_perm;
 	int xferop_ret;
 	size_t size;
 	void *ptr;
diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 1e14ae4d233a..a0fa7176fde7 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -94,7 +94,7 @@ struct qcom_adsp {
 	size_t region_assign_size;
 
 	int region_assign_idx;
-	int region_assign_perms;
+	u64 region_assign_perms;
 
 	struct qcom_rproc_glink glink_subdev;
 	struct qcom_rproc_subdev smd_subdev;
diff --git a/drivers/soc/qcom/rmtfs_mem.c b/drivers/soc/qcom/rmtfs_mem.c
index 2d3ee22b9249..2657c6105bb7 100644
--- a/drivers/soc/qcom/rmtfs_mem.c
+++ b/drivers/soc/qcom/rmtfs_mem.c
@@ -31,7 +31,7 @@ struct qcom_rmtfs_mem {
 
 	unsigned int client_id;
 
-	unsigned int perms;
+	u64 perms;
 };
 
 static ssize_t qcom_rmtfs_mem_show(struct device *dev,
diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
index 1e449a5d7f5c..250ea4efb7cb 100644
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -94,7 +94,7 @@ extern int qcom_scm_mem_protect_video_var(u32 cp_start, u32 cp_size,
 					  u32 cp_nonpixel_start,
 					  u32 cp_nonpixel_size);
 extern int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
-			       unsigned int *src,
+			       u64 *src,
 			       const struct qcom_scm_vmperm *newvm,
 			       unsigned int dest_cnt);
 

base-commit: 09e41676e35ab06e4bce8870ea3bf1f191c3cb90
-- 
2.39.1

