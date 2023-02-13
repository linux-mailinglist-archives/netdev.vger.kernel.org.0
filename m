Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EDD693D7A
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 05:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjBMEel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 23:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBMEej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 23:34:39 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4139AD0D;
        Sun, 12 Feb 2023 20:34:38 -0800 (PST)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D3gpYa023941;
        Mon, 13 Feb 2023 04:34:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=qX0JS5W/1suHDx3spw91V512mgHnNNSyitwv18V84oQ=;
 b=LFSIToEN2rpQXYfXUzFqHC+i1Q0nO3CKMkH3t1xB963/4qgKjAhtJiCMXeBE49BJuOMl
 nUSg+a1DVVDQ0v+8yRlQOnpooF7Z4oxaN/IZAX8TYl5gVxfK75VcL4ufPdY8e/ZI8+2S
 lPAp9Z+bDImqAP9kMjcKgSV1gKq18Pza759Wo1/OVA3cNui/uU0ltAfKqFxgQYtwpFo1
 QVI7d/ZCqc8r1Luox/+w7O+W7vqrulOWlvUSHOlzuaL9QMB4dJRFy4Eoq1CyQf02NlNz
 TFEEq2D6PdbMTf2c9QP7nw0+v8OYdeleSdHggU4tKmXKXWrmVUb8TTiNRaQMEFl1hwJ5 rA== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3np3sptxk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 04:34:30 +0000
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 31D4YT8h032289
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 04:34:29 GMT
Received: from localhost (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 20:34:28 -0800
From:   Neeraj Upadhyay <quic_neeraju@quicinc.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <quic_sramana@quicinc.com>,
        <quic_tsoni@quicinc.com>, <sudeep.holla@arm.com>,
        <vincent.guittot@linaro.org>, <Souvik.Chakravarty@arm.com>,
        <cristian.marussi@arm.com>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>
Subject: [PATCH] vhost: Add uAPI for Vhost SCMI backend
Date:   Mon, 13 Feb 2023 10:04:17 +0530
Message-ID: <20230213043417.20249-1-quic_neeraju@quicinc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: D0SpYjSnsBmf96EZy7QnlPdDmFeW1hED
X-Proofpoint-ORIG-GUID: D0SpYjSnsBmf96EZy7QnlPdDmFeW1hED
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_01,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 adultscore=0
 mlxlogscore=383 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130042
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a uAPI for starting and stopping a SCMI vhost based
backend.

Signed-off-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
---

SCMI Vhost backend implementation is work in progress: https://lore.kernel.org/linux-arm-kernel/20220609071956.5183-1-quic_neeraju@quicinc.com/

 include/uapi/linux/vhost.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 92e1b700b51c..80f589f35295 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -188,4 +188,7 @@
  */
 #define VHOST_VDPA_RESUME		_IO(VHOST_VIRTIO, 0x7E)
 
+/* VHOST_SCMI specific defines */
+#define VHOST_SCMI_SET_RUNNING          _IOW(VHOST_VIRTIO, 0x90, int)
+
 #endif
-- 
2.17.1

