Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0BF15A6C8
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfF1WQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:16:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18402 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726829AbfF1WQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 18:16:01 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SMDg7l017188
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:16:00 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tdu5p82j8-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:16:00 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Jun 2019 15:15:56 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 86A56241A3720; Fri, 28 Jun 2019 15:15:55 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <jakub.kicinski@netronome.com>,
        <jeffrey.t.kirsher@intel.com>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 1/3 bpf-next] net: add convert_to_xdp_frame_keep_zc function
Date:   Fri, 28 Jun 2019 15:15:53 -0700
Message-ID: <20190628221555.3009654-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628221555.3009654-1-jonathan.lemon@gmail.com>
References: <20190628221555.3009654-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=979 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280254
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a function which converts a ZC xdp_buff to a an xdp_frame, while
keeping the zc backing storage.  This will be used to support TX of
received AF_XDP frames.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/net/xdp.h | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 40c6d3398458..abe5f47ff0a5 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -82,6 +82,7 @@ struct xdp_frame {
 	 */
 	struct xdp_mem_info mem;
 	struct net_device *dev_rx; /* used by cpumap */
+	unsigned long handle;
 };
 
 /* Clear kernel pointers in xdp_frame */
@@ -95,15 +96,12 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
 
 /* Convert xdp_buff to xdp_frame */
 static inline
-struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
+struct xdp_frame *__convert_to_xdp_frame(struct xdp_buff *xdp)
 {
 	struct xdp_frame *xdp_frame;
 	int metasize;
 	int headroom;
 
-	if (xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY)
-		return xdp_convert_zc_to_xdp_frame(xdp);
-
 	/* Assure headroom is available for storing info */
 	headroom = xdp->data - xdp->data_hard_start;
 	metasize = xdp->data - xdp->data_meta;
@@ -125,6 +123,20 @@ struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
 	return xdp_frame;
 }
 
+static inline
+struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
+{
+	if (xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY)
+		return xdp_convert_zc_to_xdp_frame(xdp);
+	return __convert_to_xdp_frame(xdp);
+}
+
+static inline
+struct xdp_frame *convert_to_xdp_frame_keep_zc(struct xdp_buff *xdp)
+{
+	return __convert_to_xdp_frame(xdp);
+}
+
 void xdp_return_frame(struct xdp_frame *xdpf);
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
 void xdp_return_buff(struct xdp_buff *xdp);
-- 
2.17.1

