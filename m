Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C71D2CEA09
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 09:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgLDIkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 03:40:47 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8687 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgLDIkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 03:40:47 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CnR2h12S5zkkrW;
        Fri,  4 Dec 2020 16:39:24 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 4 Dec 2020 16:39:52 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] vhost scsi: fix error return code in vhost_scsi_set_endpoint()
Date:   Fri, 4 Dec 2020 16:43:30 +0800
Message-ID: <1607071411-33484-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 25b98b64e284 ("vhost scsi: alloc cmds per vq instead of session")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/vhost/scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 6ff8a5096..4ce9f00 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1643,7 +1643,8 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			if (!vhost_vq_is_setup(vq))
 				continue;
 
-			if (vhost_scsi_setup_vq_cmds(vq, vq->num))
+			ret = vhost_scsi_setup_vq_cmds(vq, vq->num);
+			if (ret)
 				goto destroy_vq_cmds;
 		}
 
-- 
2.9.5

