Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEC61FF8CC
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731965AbgFRQKF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31718 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731900AbgFRQJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:09:54 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG9kd3004695
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:53 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q653msbn-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:53 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:48 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 2C65A3D44E130; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 01/21] mm: add {add|release}_memory_pages
Date:   Thu, 18 Jun 2020 09:09:21 -0700
Message-ID: <20200618160941.879717-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 priorityscore=1501 impostorscore=0 cotscore=-2147483648 suspectscore=1
 spamscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=431 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows creation of system pages at a specific physical address,
which is useful for creating dummy backing pages which correspond to
unaddressable external memory at specific locations.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/memory_hotplug.h |  4 +++
 mm/memory_hotplug.c            | 65 ++++++++++++++++++++++++++++++++--
 2 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 375515803cd8..05e012e1a203 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -138,6 +138,10 @@ extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pages,
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
 		       struct mhp_params *params);
 
+struct resource *add_memory_pages(int nid, u64 start, u64 size,
+                                  struct mhp_params *params);
+void release_memory_pages(struct resource *res);
+
 #ifndef CONFIG_ARCH_HAS_ADD_PAGES
 static inline int add_pages(int nid, unsigned long start_pfn,
 		unsigned long nr_pages, struct mhp_params *params)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 9b34e03e730a..926cd4a2f81f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -125,8 +125,8 @@ static struct resource *register_memory_resource(u64 start, u64 size,
 			       resource_name, flags);
 
 	if (!res) {
-		pr_debug("Unable to reserve System RAM region: %016llx->%016llx\n",
-				start, start + size);
+		pr_debug("Unable to reserve %s region: %016llx->%016llx\n",
+				resource_name, start, start + size);
 		return ERR_PTR(-EEXIST);
 	}
 	return res;
@@ -1109,6 +1109,67 @@ int add_memory(int nid, u64 start, u64 size)
 }
 EXPORT_SYMBOL_GPL(add_memory);
 
+static int __ref add_memory_section(int nid, struct resource *res,
+				    struct mhp_params *params)
+{
+	u64 start, end, section_size;
+	int ret;
+
+	/* must align start/end with memory block size */
+	end = res->start + resource_size(res);
+	section_size = memory_block_size_bytes();
+	start = round_down(res->start, section_size);
+	end = round_up(end, section_size);
+
+	mem_hotplug_begin();
+	ret = __add_pages(nid,
+		PHYS_PFN(start), PHYS_PFN(end - start), params);
+	mem_hotplug_done();
+
+	return ret;
+}
+
+/* requires device_hotplug_lock, see add_memory_resource() */
+static struct resource * __ref __add_memory_pages(int nid, u64 start, u64 size,
+				    struct mhp_params *params)
+{
+	struct resource *res;
+	int ret;
+
+	res = register_memory_resource(start, size, "Private RAM");
+	if (IS_ERR(res))
+		return res;
+
+	ret = add_memory_section(nid, res, params);
+	if (ret < 0) {
+		release_memory_resource(res);
+		return ERR_PTR(ret);
+	}
+
+	return res;
+}
+
+struct resource *add_memory_pages(int nid, u64 start, u64 size,
+				  struct mhp_params *params)
+{
+	struct resource *res;
+
+	lock_device_hotplug();
+	res = __add_memory_pages(nid, start, size, params);
+	unlock_device_hotplug();
+
+	return res;
+}
+EXPORT_SYMBOL_GPL(add_memory_pages);
+
+void release_memory_pages(struct resource *res)
+{
+	lock_device_hotplug();
+	release_memory_resource(res);
+	unlock_device_hotplug();
+}
+EXPORT_SYMBOL_GPL(release_memory_pages);
+
 /*
  * Add special, driver-managed memory to the system as system RAM. Such
  * memory is not exposed via the raw firmware-provided memmap as system
-- 
2.24.1

