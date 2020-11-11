Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D9F2AE55F
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732573AbgKKBO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:14:26 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7627 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731746AbgKKBOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 20:14:22 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CW6FW4x09zLx6D;
        Wed, 11 Nov 2020 09:14:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Nov 2020 09:14:17 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] vhost_vdpa: switch to vmemdup_user()
Date:   Wed, 11 Nov 2020 09:14:48 +0800
Message-ID: <1605057288-60400-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace opencoded alloc and copy with vmemdup_user()

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/vhost/vdpa.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 2754f30..4c39583 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -245,14 +245,10 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
 		return -EFAULT;
 	if (vhost_vdpa_config_validate(v, &config))
 		return -EINVAL;
-	buf = kvzalloc(config.len, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
 
-	if (copy_from_user(buf, c->buf, config.len)) {
-		kvfree(buf);
-		return -EFAULT;
-	}
+	buf = vmemdup_user(c->buf, config.len);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
 
 	ops->set_config(vdpa, config.off, buf, config.len);
 
-- 
2.7.4

