Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB06428C04E
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388889AbgJLTDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388390AbgJLTDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68C8921582;
        Mon, 12 Oct 2020 19:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529380;
        bh=BYbbrFgph4SjLhGZw4fINy6lmVuypEQSdT6k9nzquQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJXwbpDh/qNsdNwUz5wCM7EnSLBrpIEXEki7sMBgNrJrL36+0sYlnYl9RT8Jv6KkF
         iCm535JwpGIO3GNbGqN2mOGk7rnCXf+4VcapVjoRk1cvd9IkpaQiXB1urugrVRyy96
         aUxD2NQIwyzJDe/yVpMSQulhzQ7nwaEEaRCjqVKM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 16/24] vhost vdpa: fix vhost_vdpa_open error handling
Date:   Mon, 12 Oct 2020 15:02:31 -0400
Message-Id: <20201012190239.3279198-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190239.3279198-1-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 37787e9f81e2e586b526ff5c29c94e4f41513e80 ]

We must free the vqs array in the open failure path, because
vhost_vdpa_release will not be called.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Link: https://lore.kernel.org/r/1600712588-9514-2-git-send-email-michael.christie@oracle.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index a54b60d6623f0..13cdf38f8578a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -760,6 +760,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 err_init_iotlb:
 	vhost_dev_cleanup(&v->vdev);
+	kfree(vqs);
 err:
 	atomic_dec(&v->opened);
 	return r;
-- 
2.25.1

