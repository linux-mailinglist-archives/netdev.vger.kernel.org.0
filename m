Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F02FF14D
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbfKPPsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:48:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730126AbfKPPsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:48:40 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 620C020885;
        Sat, 16 Nov 2019 15:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919319;
        bh=+F1QBt/M7/kXYdp+oOwPTbfq4rcy67ZihT++W2s3Ayw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gqjof5gelgergFoM4WTdrZcsNZ0eZCTyp1VwYD38m4VwDCStdKySC03u3IThGuLAT
         VqS/nqGg/oOpbtNXCCVFuNY7g3i79tA/a0SNRvCJwnXlg+wN5Fo2ZPEIcQDKjI19E3
         c47wsLFNorrUy0qUf9e6OFv4la/A1ulfseKxoSWo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Sasha Levin <sashal@kernel.org>,
        ceph-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 061/150] libceph: don't consume a ref on pagelist in ceph_msg_data_add_pagelist()
Date:   Sat, 16 Nov 2019 10:45:59 -0500
Message-Id: <20191116154729.9573-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

[ Upstream commit 894868330a1e038ea4a65dbb81741eef70ad71b1 ]

Because send_mds_reconnect() wants to send a message with a pagelist
and pass the ownership to the messenger, ceph_msg_data_add_pagelist()
consumes a ref which is then put in ceph_msg_data_destroy().  This
makes managing pagelists in the OSD client (where they are wrapped in
ceph_osd_data) unnecessarily hard because the handoff only happens in
ceph_osdc_start_request() instead of when the pagelist is passed to
ceph_osd_data_pagelist_init().  I counted several memory leaks on
various error paths.

Fix up ceph_msg_data_add_pagelist() and carry a pagelist ref in
ceph_osd_data.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c  | 2 +-
 net/ceph/messenger.c  | 1 +
 net/ceph/osd_client.c | 8 ++++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index b968334f841e8..a6096f959e54b 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2102,7 +2102,6 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 
 	if (req->r_pagelist) {
 		struct ceph_pagelist *pagelist = req->r_pagelist;
-		refcount_inc(&pagelist->refcnt);
 		ceph_msg_data_add_pagelist(msg, pagelist);
 		msg->hdr.data_len = cpu_to_le32(pagelist->length);
 	} else {
@@ -3191,6 +3190,7 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
 	mutex_unlock(&mdsc->mutex);
 
 	up_read(&mdsc->snap_rwsem);
+	ceph_pagelist_release(pagelist);
 	return;
 
 fail:
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 081a41c753413..9f4851c782fed 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -3293,6 +3293,7 @@ void ceph_msg_data_add_pagelist(struct ceph_msg *msg,
 
 	data = ceph_msg_data_create(CEPH_MSG_DATA_PAGELIST);
 	BUG_ON(!data);
+	refcount_inc(&pagelist->refcnt);
 	data->pagelist = pagelist;
 
 	list_add_tail(&data->links, &msg->data);
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 92b2641ab93b8..45850962acdd6 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -127,6 +127,9 @@ static void ceph_osd_data_init(struct ceph_osd_data *osd_data)
 	osd_data->type = CEPH_OSD_DATA_TYPE_NONE;
 }
 
+/*
+ * Consumes @pages if @own_pages is true.
+ */
 static void ceph_osd_data_pages_init(struct ceph_osd_data *osd_data,
 			struct page **pages, u64 length, u32 alignment,
 			bool pages_from_pool, bool own_pages)
@@ -139,6 +142,9 @@ static void ceph_osd_data_pages_init(struct ceph_osd_data *osd_data,
 	osd_data->own_pages = own_pages;
 }
 
+/*
+ * Consumes a ref on @pagelist.
+ */
 static void ceph_osd_data_pagelist_init(struct ceph_osd_data *osd_data,
 			struct ceph_pagelist *pagelist)
 {
@@ -304,6 +310,8 @@ static void ceph_osd_data_release(struct ceph_osd_data *osd_data)
 		num_pages = calc_pages_for((u64)osd_data->alignment,
 						(u64)osd_data->length);
 		ceph_release_page_vector(osd_data->pages, num_pages);
+	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGELIST) {
+		ceph_pagelist_release(osd_data->pagelist);
 	}
 	ceph_osd_data_init(osd_data);
 }
-- 
2.20.1

