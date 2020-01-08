Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1DA6134A1C
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbgAHSGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:06:12 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45105 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730095AbgAHSGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:06:12 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yishaih@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [10.7.2.17])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 008I65WQ030036;
        Wed, 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [127.0.0.1])
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8) with ESMTP id 008I6587022346;
        Wed, 8 Jan 2020 20:06:05 +0200
Received: (from yishaih@localhost)
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8/Submit) id 008I65Bx022345;
        Wed, 8 Jan 2020 20:06:05 +0200
From:   Yishai Hadas <yishaih@mellanox.com>
To:     linux-rdma@vger.kernel.org, jgg@mellanox.com, dledford@redhat.com
Cc:     saeedm@mellanox.com, yishaih@mellanox.com, maorg@mellanox.com,
        michaelgur@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH rdma-next 07/10] RDMA/efa: Allow passing of optional access flags for MR registration
Date:   Wed,  8 Jan 2020 20:05:37 +0200
Message-Id: <1578506740-22188-8-git-send-email-yishaih@mellanox.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

As part of adding a range of optional access flags that drivers need to
be able to accept, mask this range inside efa driver.
This will prevent the driver from failing when an access flag from
that range is passed.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 50c2257..b6b936c 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1370,6 +1370,7 @@ struct ib_mr *efa_reg_mr(struct ib_pd *ibpd, u64 start, u64 length,
 		IB_ACCESS_LOCAL_WRITE |
 		(is_rdma_read_cap(dev) ? IB_ACCESS_REMOTE_READ : 0);
 
+	access_flags &= ~IB_UVERBS_ACCESS_OPTIONAL_RANGE;
 	if (access_flags & ~supp_access_flags) {
 		ibdev_dbg(&dev->ibdev,
 			  "Unsupported access flags[%#x], supported[%#x]\n",
-- 
1.8.3.1

