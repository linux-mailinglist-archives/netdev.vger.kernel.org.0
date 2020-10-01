Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD962808F9
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387465AbgJAVBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:01:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49698 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgJAVBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 17:01:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091L03gw134672;
        Thu, 1 Oct 2020 21:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=zXkx84w5tl9t6q8pRAhHxciaF+0XLChHsEh+wOkrN40=;
 b=o6P8Cd50cKYGE6Xe+70KXlv0b+jS8OxYNjWisXb2+Ie78bGN6JTQtrkv4BNVnfto03fC
 Hy321fkMA6m+b5tffWZXsQk9s4OWmRgcyRbOpm7WlMg+rQyu65gKmpOaDJ4NR7v7FKQM
 Q8LOk6TsHmEDz6v9F9QPqhi9X0LF2FzwmVQYu61+vddiLCbKEjHwY3NH1cMeetNzc1MU
 slehNrPMVHoyHwpkR/UP7oOiabp7GWiTWZKbseH8dsIj6Cuxgy9IeW8emMTOL8x1W+bN
 D8AAZ6nNBooVqBTzil8V6zrNC2l2NxmY+OkfVgCtATrQtz2FQHlx1+rlfqPjCfsjORKu CQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33su5b8g02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 01 Oct 2020 21:01:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091KixfQ097828;
        Thu, 1 Oct 2020 20:59:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33uv2hea2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Oct 2020 20:59:33 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 091KxXfe024670;
        Thu, 1 Oct 2020 20:59:33 GMT
Received: from ban25x6uut24.us.oracle.com (/10.153.73.24)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 13:59:32 -0700
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com
Cc:     joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] vdpa/mlx5: should keep avail_index despite device status
Date:   Thu,  1 Oct 2020 16:18:31 -0400
Message-Id: <1601583511-15138-1-git-send-email-si-wei.liu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1011 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010169
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A VM with mlx5 vDPA has below warnings while being reset:

vhost VQ 0 ring restore failed: -1: Resource temporarily unavailable (11)
vhost VQ 1 ring restore failed: -1: Resource temporarily unavailable (11)

We should allow userspace emulating the virtio device be
able to get to vq's avail_index, regardless of vDPA device
status. Save the index that was last seen when virtq was
stopped, so that userspace doesn't complain.

Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 70676a6..74264e59 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1133,15 +1133,17 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
 	if (!mvq->initialized)
 		return;
 
-	if (query_virtqueue(ndev, mvq, &attr)) {
-		mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
-		return;
-	}
 	if (mvq->fw_state != MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY)
 		return;
 
 	if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
 		mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
+
+	if (query_virtqueue(ndev, mvq, &attr)) {
+		mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
+		return;
+	}
+	mvq->avail_idx = attr.available_index;
 }
 
 static void suspend_vqs(struct mlx5_vdpa_net *ndev)
@@ -1411,8 +1413,14 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
 	struct mlx5_virtq_attr attr;
 	int err;
 
-	if (!mvq->initialized)
-		return -EAGAIN;
+	/* If the virtq object was destroyed, use the value saved at
+	 * the last minute of suspend_vq. This caters for userspace
+	 * that cares about emulating the index after vq is stopped.
+	 */
+	if (!mvq->initialized) {
+		state->avail_index = mvq->avail_idx;
+		return 0;
+	}
 
 	err = query_virtqueue(ndev, mvq, &attr);
 	if (err) {
-- 
1.8.3.1

