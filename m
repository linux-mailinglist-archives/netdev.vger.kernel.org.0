Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC768280ABA
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387470AbgJAXAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:00:12 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:35864 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733166AbgJAW7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 18:59:44 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091MrsHD167363;
        Thu, 1 Oct 2020 22:59:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=vEPBYhSXye04MgPYucd/wpb879n10z8HePSUZrjurvY=;
 b=XvRhjiEgp7f5W9VWS2xE59DqK2gVrTMeNXW76UWDlAOx0lXm61oqzgDAbIutSRd/UVVP
 D8iKId1byiB6P9JGKCVLDgcJst5nowyHqoJSB2CWU+bLQswovCDLAodPUBSwOTfZ8XXl
 27ny9FAoD/nxKbD4P1XOmR0hxWcuXxyAjmqm31LS7unXiu0fuh8xaVxWQL5y2hTC9Ijc
 jgoFid1AWtSlNCNOzaDU4FpwX5yPr8s97ScslFHutzNf9zPg79D6ecn4tPlFM4UYd1Ys
 2rNrubUd3g+JO2sXTMfQOf4Q5lnhEY9KVH3Tw7JQPm212aAQEDbEKB1+73SQ8nlJEzmJ Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33su5b8v2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 01 Oct 2020 22:59:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091MuXwE061026;
        Thu, 1 Oct 2020 22:59:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33tfj28wxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Oct 2020 22:59:36 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 091MxaW3018534;
        Thu, 1 Oct 2020 22:59:36 GMT
Received: from ban25x6uut24.us.oracle.com (/10.153.73.24)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 15:59:35 -0700
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     mst@redhat.com, jasowang@redhat.com, lingshan.zhu@intel.com
Cc:     joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v2] vhost-vdpa: fix page pinning leakage in error path
Date:   Thu,  1 Oct 2020 18:18:35 -0400
Message-Id: <1601590715-17303-1-git-send-email-si-wei.liu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=2 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=2
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010184
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pinned pages are not properly accounted particularly when
mapping error occurs on IOTLB update. Clean up dangling
pinned pages for the error path. As the inflight pinned
pages, specifically for memory region that strides across
multiple chunks, would need more than one free page for
book keeping and accounting. For simplicity, pin pages
for all memory in the IOVA range in one go rather than
have multiple pin_user_pages calls to make up the entire
region. This way it's easier to track and account the
pages already mapped, particularly for clean-up in the
error path.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
---
Changes in v2:
- Fix incorrect target SHA1 referenced

 drivers/vhost/vdpa.c | 121 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 73 insertions(+), 48 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 796fe97..abc4aa2 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -565,6 +565,8 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
 			      perm_to_iommu_flags(perm));
 	}
 
+	if (r)
+		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
 	return r;
 }
 
@@ -592,21 +594,19 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 	struct vhost_dev *dev = &v->vdev;
 	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct page **page_list;
-	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
+	struct vm_area_struct **vmas;
 	unsigned int gup_flags = FOLL_LONGTERM;
-	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
-	unsigned long locked, lock_limit, pinned, i;
+	unsigned long map_pfn, last_pfn = 0;
+	unsigned long npages, lock_limit;
+	unsigned long i, nmap = 0;
 	u64 iova = msg->iova;
+	long pinned;
 	int ret = 0;
 
 	if (vhost_iotlb_itree_first(iotlb, msg->iova,
 				    msg->iova + msg->size - 1))
 		return -EEXIST;
 
-	page_list = (struct page **) __get_free_page(GFP_KERNEL);
-	if (!page_list)
-		return -ENOMEM;
-
 	if (msg->perm & VHOST_ACCESS_WO)
 		gup_flags |= FOLL_WRITE;
 
@@ -614,61 +614,86 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 	if (!npages)
 		return -EINVAL;
 
+	page_list = kvmalloc_array(npages, sizeof(struct page *), GFP_KERNEL);
+	vmas = kvmalloc_array(npages, sizeof(struct vm_area_struct *),
+			      GFP_KERNEL);
+	if (!page_list || !vmas) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
 	mmap_read_lock(dev->mm);
 
-	locked = atomic64_add_return(npages, &dev->mm->pinned_vm);
 	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	if (locked > lock_limit) {
+	if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
 		ret = -ENOMEM;
-		goto out;
+		goto unlock;
 	}
 
-	cur_base = msg->uaddr & PAGE_MASK;
-	iova &= PAGE_MASK;
+	pinned = pin_user_pages(msg->uaddr & PAGE_MASK, npages, gup_flags,
+				page_list, vmas);
+	if (npages != pinned) {
+		if (pinned < 0) {
+			ret = pinned;
+		} else {
+			unpin_user_pages(page_list, pinned);
+			ret = -ENOMEM;
+		}
+		goto unlock;
+	}
 
-	while (npages) {
-		pinned = min_t(unsigned long, npages, list_size);
-		ret = pin_user_pages(cur_base, pinned,
-				     gup_flags, page_list, NULL);
-		if (ret != pinned)
-			goto out;
-
-		if (!last_pfn)
-			map_pfn = page_to_pfn(page_list[0]);
-
-		for (i = 0; i < ret; i++) {
-			unsigned long this_pfn = page_to_pfn(page_list[i]);
-			u64 csize;
-
-			if (last_pfn && (this_pfn != last_pfn + 1)) {
-				/* Pin a contiguous chunk of memory */
-				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
-				if (vhost_vdpa_map(v, iova, csize,
-						   map_pfn << PAGE_SHIFT,
-						   msg->perm))
-					goto out;
-				map_pfn = this_pfn;
-				iova += csize;
+	iova &= PAGE_MASK;
+	map_pfn = page_to_pfn(page_list[0]);
+
+	/* One more iteration to avoid extra vdpa_map() call out of loop. */
+	for (i = 0; i <= npages; i++) {
+		unsigned long this_pfn;
+		u64 csize;
+
+		/* The last chunk may have no valid PFN next to it */
+		this_pfn = i < npages ? page_to_pfn(page_list[i]) : -1UL;
+
+		if (last_pfn && (this_pfn == -1UL ||
+				 this_pfn != last_pfn + 1)) {
+			/* Pin a contiguous chunk of memory */
+			csize = last_pfn - map_pfn + 1;
+			ret = vhost_vdpa_map(v, iova, csize << PAGE_SHIFT,
+					     map_pfn << PAGE_SHIFT,
+					     msg->perm);
+			if (ret) {
+				/*
+				 * Unpin the rest chunks of memory on the
+				 * flight with no corresponding vdpa_map()
+				 * calls having been made yet. On the other
+				 * hand, vdpa_unmap() in the failure path
+				 * is in charge of accounting the number of
+				 * pinned pages for its own.
+				 * This asymmetrical pattern of accounting
+				 * is for efficiency to pin all pages at
+				 * once, while there is no other callsite
+				 * of vdpa_map() than here above.
+				 */
+				unpin_user_pages(&page_list[nmap],
+						 npages - nmap);
+				goto out;
 			}
-
-			last_pfn = this_pfn;
+			atomic64_add(csize, &dev->mm->pinned_vm);
+			nmap += csize;
+			iova += csize << PAGE_SHIFT;
+			map_pfn = this_pfn;
 		}
-
-		cur_base += ret << PAGE_SHIFT;
-		npages -= ret;
+		last_pfn = this_pfn;
 	}
 
-	/* Pin the rest chunk */
-	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
-			     map_pfn << PAGE_SHIFT, msg->perm);
+	WARN_ON(nmap != npages);
 out:
-	if (ret) {
+	if (ret)
 		vhost_vdpa_unmap(v, msg->iova, msg->size);
-		atomic64_sub(npages, &dev->mm->pinned_vm);
-	}
+unlock:
 	mmap_read_unlock(dev->mm);
-	free_page((unsigned long)page_list);
+free:
+	kvfree(vmas);
+	kvfree(page_list);
 	return ret;
 }
 
-- 
1.8.3.1

