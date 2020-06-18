Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2227F1FF8CD
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731974AbgFRQKH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30590 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731894AbgFRQJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:09:54 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05IG7bm0013417
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:53 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 31q644vseg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:53 -0700
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 2EF753D44E132; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 02/21] mm: Allow DMA mapping of pages which are not online
Date:   Thu, 18 Jun 2020 09:09:22 -0700
Message-ID: <20200618160941.879717-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 cotscore=-2147483648 suspectscore=1 adultscore=0
 spamscore=0 clxscore=1034 priorityscore=1501 mlxscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=606 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the system RAM check from 'valid' to 'online', so dummy
pages which refer to external DMA resources can be mapped.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/dma-mapping.h | 4 ++--
 include/linux/mmzone.h      | 7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 78f677cf45ab..fb142a01d1ba 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -348,8 +348,8 @@ static inline dma_addr_t dma_map_resource(struct device *dev,
 
 	BUG_ON(!valid_dma_direction(dir));
 
-	/* Don't allow RAM to be mapped */
-	if (WARN_ON_ONCE(pfn_valid(PHYS_PFN(phys_addr))))
+	/* Don't allow online RAM to be mapped */
+	if (WARN_ON_ONCE(pfn_online(PHYS_PFN(phys_addr))))
 		return DMA_MAPPING_ERROR;
 
 	if (dma_is_direct(ops))
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c4c37fd12104..9a9fe5704f97 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1348,6 +1348,13 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 	return -1;
 }
 
+static inline int pfn_online(unsigned long pfn)
+{
+	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
+		return 0;
+	return online_section(__nr_to_section(pfn_to_section_nr(pfn)));
+}
+
 /*
  * These are _only_ used during initialisation, therefore they
  * can use __initdata ...  They could have names to indicate
-- 
2.24.1

