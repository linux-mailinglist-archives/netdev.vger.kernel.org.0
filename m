Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDC7311D6A
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 14:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhBFNSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 08:18:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42206 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhBFNSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 08:18:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 116D946u057665;
        Sat, 6 Feb 2021 13:17:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Zzsxe15nl3d988vk8AaqrmaUEcvQcJ5h5MrS5qwe/Xw=;
 b=ZgrOZj4abAsDitUmibPdAcO5HB7+NZf4gLbivW8HRCrPP1WAc4Ln6xgG1qhNf5zEnrBu
 QWlmJ5dpDfTveGnX2fxRs/ijF7X2E/iMhpwZ/BuTZJQBv4U4d+HKIu1cJRNorXbveP3l
 HzT+p5HJ9elQa9BVoW159wKv7JISv3RUJWh77YakhlZohoZuafh+yjISRBLpi4ZKbLu8
 0Uf8ZXhAjC3fPpLcG16KwB620aKZ8TTRjWJyFzaDQh1ylrX1oIV1aWNjMZWtqmK93OdJ
 YaM51oK2Ixi+mqw6UXlwDb6BQYe2mGEytg34hUbMbZZyVibNvMjTTgDoHFgPKWz0cmTl Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36hjhqgn9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Feb 2021 13:17:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 116DAQvt028419;
        Sat, 6 Feb 2021 13:17:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 36hjeh3f64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Feb 2021 13:17:09 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 116DH8h0030613;
        Sat, 6 Feb 2021 13:17:08 GMT
Received: from ban25x6uut24.us.oracle.com (/10.153.73.24) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Sat, 06 Feb 2021 05:16:17 -0800
MIME-Version: 1.0
Message-ID: <1612614564-4220-2-git-send-email-si-wei.liu@oracle.com>
Date:   Sat, 6 Feb 2021 04:29:23 -0800 (PST)
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     mst@redhat.com, jasowang@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        si-wei.liu@oracle.com
Subject: [PATCH 2/3] mlx5_vdpa: fix feature negotiation across device reset
References: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
In-Reply-To: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9886 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102060093
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9886 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102060093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx_features denotes the capability for which
set of virtio features is supported by device. In
principle, this field needs not be cleared during
virtio device reset, as this capability is static
and does not change across reset.

In fact, the current code may have the assumption
that mlx_features can be reloaded from firmware
via the .get_features ops after device is reset
(via the .set_status ops), which is unfortunately
not true. The userspace VMM might save a copy
of backend capable features and won't call into
kernel again to get it on reset. This causes all
virtio features getting disabled on newly created
virtqs after device reset, while guest would hold
mismatched view of available features. For e.g.,
the guest may still assume tx checksum offload
is available after reset and feature negotiation,
causing frames with bogus (incomplete) checksum
transmitted on the wire.

Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index b8416c4..aa6f8cd 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1788,7 +1788,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 		clear_virtqueues(ndev);
 		mlx5_vdpa_destroy_mr(&ndev->mvdev);
 		ndev->mvdev.status = 0;
-		ndev->mvdev.mlx_features = 0;
 		++mvdev->generation;
 		return;
 	}
-- 
1.8.3.1

