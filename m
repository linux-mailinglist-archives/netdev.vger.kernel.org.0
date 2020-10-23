Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBBC296E36
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 14:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463452AbgJWMJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 08:09:07 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46530 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S463180AbgJWMJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 08:09:07 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NC5Au7095975;
        Fri, 23 Oct 2020 12:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=3u747VZC52iNeeNmOWRTKOGyZ8opg2btTPcZQUCsvGw=;
 b=g/GRiX9jjXejYbgaoQuSWf8mDKwf1QHkoc/k3V5GOM3mCrZ6r+su6cuS6jETcHwiCNdy
 T5lClorzd8RKcR0ifgboclLHVtg9aevcQqyI704DhbSq3Z6jH6H4jf9nSTa435BePGfK
 GKPsQivycYyys7T5j+4VixT+JP7JKgJ7MHFAJwv4LezfTxxPfb06pDDbar2Lp5dPHqDO
 1CLFnXX31cIlaqUVNLRxBQFGjy1P9wY6hYwfDvLLVQwtq+eVz6fbZuu388iTknY3lnY5
 c0nxcgHMCi4vaKMhyKDU/B74Xs2psh1yLMyP+gPOlNNnntABNohMFXcOYy9SP0JnjGPe qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 347p4bavxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Oct 2020 12:09:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NC558Y104567;
        Fri, 23 Oct 2020 12:09:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 348aj0wyb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Oct 2020 12:09:02 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09NC9099026344;
        Fri, 23 Oct 2020 12:09:01 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Oct 2020 05:08:59 -0700
Date:   Fri, 23 Oct 2020 15:08:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] vhost_vdpa: Return -EFUALT if copy_from_user() fails
Message-ID: <20201023120853.GI282278@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230086
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The copy_to/from_user() functions return the number of bytes which we
weren't able to copy but the ioctl should return -EFAULT if they fail.

Fixes: a127c5bbb6a8 ("vhost-vdpa: fix backend feature ioctls")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/vhost/vdpa.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 62a9bb0efc55..c94a97b6bd6d 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -428,12 +428,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	void __user *argp = (void __user *)arg;
 	u64 __user *featurep = argp;
 	u64 features;
-	long r;
+	long r = 0;
 
 	if (cmd == VHOST_SET_BACKEND_FEATURES) {
-		r = copy_from_user(&features, featurep, sizeof(features));
-		if (r)
-			return r;
+		if (copy_from_user(&features, featurep, sizeof(features)))
+			return -EFAULT;
 		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
 			return -EOPNOTSUPP;
 		vhost_set_backend_features(&v->vdev, features);
@@ -476,7 +475,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		break;
 	case VHOST_GET_BACKEND_FEATURES:
 		features = VHOST_VDPA_BACKEND_FEATURES;
-		r = copy_to_user(featurep, &features, sizeof(features));
+		if (copy_to_user(featurep, &features, sizeof(features)))
+			r = -EFAULT;
 		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
