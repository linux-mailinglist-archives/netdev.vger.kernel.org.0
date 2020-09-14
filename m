Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E381269487
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgINSLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:11:39 -0400
Received: from mail1.windriver.com ([147.11.146.13]:33682 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgINSLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:11:33 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail1.windriver.com (8.15.2/8.15.2) with ESMTPS id 08EIBMfk012981
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Mon, 14 Sep 2020 11:11:22 -0700 (PDT)
Received: from pek-lwang1-u1404.wrs.com (128.224.162.178) by
 ALA-HCA.corp.ad.wrs.com (147.11.189.40) with Microsoft SMTP Server id
 14.3.487.0; Mon, 14 Sep 2020 11:11:21 -0700
From:   Li Wang <li.wang@windriver.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] vhost: reduce stack usage in log_used
Date:   Tue, 15 Sep 2020 02:08:09 +0800
Message-ID: <1600106889-25013-1-git-send-email-li.wang@windriver.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1199326218.16921082.1600051335160.JavaMail.zimbra@redhat.com>
References: <1199326218.16921082.1600051335160.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the warning: [-Werror=-Wframe-larger-than=]

drivers/vhost/vhost.c: In function log_used:
drivers/vhost/vhost.c:1906:1:
warning: the frame size of 1040 bytes is larger than 1024 bytes

Signed-off-by: Li Wang <li.wang@windriver.com>
---
 drivers/vhost/vhost.c | 2 +-
 drivers/vhost/vhost.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b45519c..31837a5
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1884,7 +1884,7 @@ static int log_write_hva(struct vhost_virtqueue *vq, u64 hva, u64 len)
 
 static int log_used(struct vhost_virtqueue *vq, u64 used_offset, u64 len)
 {
-	struct iovec iov[64];
+	struct iovec *iov = vq->log_iov;
 	int i, ret;
 
 	if (!vq->iotlb)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 9032d3c..5fe4b47
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -123,6 +123,7 @@ struct vhost_virtqueue {
 	/* Log write descriptors */
 	void __user *log_base;
 	struct vhost_log *log;
+	struct iovec log_iov[64];
 
 	/* Ring endianness. Defaults to legacy native endianness.
 	 * Set to true when starting a modern virtio device. */
-- 
2.7.4

