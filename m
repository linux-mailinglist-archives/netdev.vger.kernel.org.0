Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71A62821A3
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 07:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgJCFnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 01:43:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48986 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCFnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 01:43:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0935e7Dx156387;
        Sat, 3 Oct 2020 05:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=qhhQMpRs2K5aWL/DfM8e6Fp1one8sKEeO5zQ74OeflU=;
 b=MDjLPRC8CGR7S1jBRNgh5hp1zwavPeNjMHKP+j5o+pQJXA2NCYJcnbeFbIqcVRQ/Tgg7
 EbKrpRNEOECQGt1t5rO6bCmkllvPnVqvSKMLgGzUgcWWtS8RJT8E0IZl2OpWVr+dR8pQ
 +2QicSTQ36KxdNe5JYSM+3yUAgbcaqMemI7LDpk3c9HV09mbZTEaLJKW8+wdkAs3LAng
 xLCZIdm17ReptigON8QrCFDcNCJcjAc/v7kt3IRP9Mo+BDpznxT1sPPEws5BjOKaTO9W
 ZenyEGM7MmE7vCrf5y2TZ5XjLF0oygywKEn2NjqrWuTA3mYfeqJRHof5JKr23sHhzOZr bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetagabm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 05:43:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0935eZtp071130;
        Sat, 3 Oct 2020 05:43:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33xh3y29uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 05:43:15 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0935hDKq022858;
        Sat, 3 Oct 2020 05:43:13 GMT
Received: from ban25x6uut24.us.oracle.com (/10.153.73.24)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 22:43:13 -0700
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     mst@redhat.com, jasowang@redhat.com, lingshan.zhu@intel.com
Cc:     joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v3 1/2] vhost-vdpa: fix vhost_vdpa_map() on error condition
Date:   Sat,  3 Oct 2020 01:02:09 -0400
Message-Id: <1601701330-16837-2-git-send-email-si-wei.liu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com>
References: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030050
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vhost_vdpa_map() should remove the iotlb entry just added
if the corresponding mapping fails to set up properly.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
---
 drivers/vhost/vdpa.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 796fe97..0f27919 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -565,6 +565,9 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
 			      perm_to_iommu_flags(perm));
 	}
 
+	if (r)
+		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
+
 	return r;
 }
 
-- 
1.8.3.1

