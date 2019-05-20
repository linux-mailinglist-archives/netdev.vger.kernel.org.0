Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5798322C57
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 08:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbfETGym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 02:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbfETGym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 02:54:42 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 757432081C;
        Mon, 20 May 2019 06:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558335282;
        bh=964HHLuk9G82W04NBaPbUzSUHqiaO/7vMaLWZyDV5pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rq5jV/qbQ4U2V9HrGaMZtZ0BOEWvuLqjkfyfyJQkn6xheWXfJaw8KORrMNfIf4GMq
         r3MMQ2+GNBL9un4pUvqLJ8Vu8rHlaRQ4U+fcp848T3y7xyw6v4+R0NNy5vsVXJHCSx
         j470a+3iIUOhDLjf0MzeCIYVSJZ8kZ0VCnWlwgGo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Glenn Streiff <gstreiff@neteffect.com>,
        Steve Wise <swise@opengridcomputing.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH rdma-next 01/15] rds: Don't check return value from destroy CQ
Date:   Mon, 20 May 2019 09:54:19 +0300
Message-Id: <20190520065433.8734-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520065433.8734-1-leon@kernel.org>
References: <20190520065433.8734-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

There is no value in checking ib_destroy_cq() result and skipping
to clear struct ic fields. This connection needs to be reinitialized
anyway.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 net/rds/ib_cm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 66c6eb56072b..5a42ebb892cd 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -611,11 +611,11 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 qp_out:
 	rdma_destroy_qp(ic->i_cm_id);
 recv_cq_out:
-	if (!ib_destroy_cq(ic->i_recv_cq))
-		ic->i_recv_cq = NULL;
+	ib_destroy_cq(ic->i_recv_cq);
+	ic->i_recv_cq = NULL;
 send_cq_out:
-	if (!ib_destroy_cq(ic->i_send_cq))
-		ic->i_send_cq = NULL;
+	ib_destroy_cq(ic->i_send_cq);
+	ic->i_send_cq = NULL;
 rds_ibdev_out:
 	rds_ib_remove_conn(rds_ibdev, conn);
 out:
--
2.20.1

