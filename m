Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B107E22FC69
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgG0Wox convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:44:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20572 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726997AbgG0Wos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:44:48 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMfda2010751
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:47 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h50vprn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:47 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:46 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id BBB183FAB6F5F; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 03/21] mm: Allow DMA mapping of pages which are not online
Date:   Mon, 27 Jul 2020 15:44:26 -0700
Message-ID: <20200727224444.2987641-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=616 priorityscore=1501 adultscore=0
 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270153
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
index a33ed3954ed4..e9b1a8431568 100644
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
index f6f884970511..d0c6fc553304 100644
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

