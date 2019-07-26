Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5E4076B4C
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 16:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfGZORN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 10:17:13 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42698 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfGZORN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 10:17:13 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so24586986pff.9;
        Fri, 26 Jul 2019 07:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dNnqQwHX3ETnAbhTD2AqV3KPRBqgqiL6QbUT7t0Db40=;
        b=aCuPaDhXVM0L+4hA6IRjIBoywOkmHWDMoGVV8FRhqt4MYj3M7Fhzi+b6Lb1sfpBDTn
         Us31F+UYEGzp/6hNLWyB3wTdQYnV603w845xUBGcOc41Dv5/Qz49XnOqGJDdRkTBTp7M
         arVmCDNZ0tz54v6N4mLpaTsibLt/xDg93Z5ZNLCM3LbXnHMOoCJkwpfflvm2bA2xeBEG
         x/GVx1DJejxlYLJanhWmcGZkTU1HVOaznc0cvMIURwMquqM4VqME9UUgzC6YdwzV0yAc
         NX5hUNourXGvVqvaUPTO7Y5uLX0K1MnPMq5B9epbstfcWpknZOVl2APDjPfqPNGbxgK3
         UT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dNnqQwHX3ETnAbhTD2AqV3KPRBqgqiL6QbUT7t0Db40=;
        b=mliyaJ6yDNbGjQvrcD1cXQUw0xNdyhar29DWAmzymj2RpjmROL1FNCkjlCtXQ+kz9e
         duLDbzcmDqiuS0QiV5o1SlIhjrloqtMN8BsBJ6GW12upUtbbSaBXDR6irKHUOG75zM/t
         i3OrazZOur2nl31ba/+dU10bC6m4zQzO/urOhltCsJ5xioD5yhrI4UzJrDi1o4N2/M7n
         GhcuhY0gUlMHPTV1zxuhpofpTqnGL8tFBUBahlfNWrCHbCpJ7kwCuvhAAcr2eFIRDbYI
         YpEkj2vBW1qCCefTPSvBkYixLTp2m5Xd1jJjb0IMi99lvAOlrnf08BXEbZ2wR7W4HB1u
         psGQ==
X-Gm-Message-State: APjAAAVZqty9QronGIidQxj7hV3+D4hs0zE1xvgTUsE76zk5RUV0uKSF
        zUXe/m+z9VJWy66pVtHEtn0=
X-Google-Smtp-Source: APXvYqx9xaENXC9Svdu6KwkHC2A9K/PjsmPxmfUJp6ijl9Wjql7ZHhAQYVndsn6qMVE5bD7MC+MKcg==
X-Received: by 2002:aa7:9afc:: with SMTP id y28mr22080870pfp.252.1564150632442;
        Fri, 26 Jul 2019 07:17:12 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id j6sm70251565pjd.19.2019.07.26.07.17.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 07:17:11 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: rds: Fix possible null-pointer dereferences in rds_rdma_cm_event_handler_cmn()
Date:   Fri, 26 Jul 2019 22:17:05 +0800
Message-Id: <20190726141705.9585-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rds_rdma_cm_event_handler_cmn(), there are some if statements to
check whether conn is NULL, such as on lines 65, 96 and 112.
But conn is not checked before being used on line 108:
    trans->cm_connect_complete(conn, event);
and on lines 140-143:
    rdsdebug("DISCONNECT event - dropping connection "
            "%pI6c->%pI6c\n", &conn->c_laddr,
            &conn->c_faddr);
    rds_conn_drop(conn);

Thus, possible null-pointer dereferences may occur.

To fix these bugs, conn is checked before being used.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/rds/rdma_transport.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index ff74c4bbb9fc..9986d6065c4d 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -105,7 +105,8 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 		break;
 
 	case RDMA_CM_EVENT_ESTABLISHED:
-		trans->cm_connect_complete(conn, event);
+		if (conn)
+			trans->cm_connect_complete(conn, event);
 		break;
 
 	case RDMA_CM_EVENT_REJECTED:
@@ -137,6 +138,8 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 		break;
 
 	case RDMA_CM_EVENT_DISCONNECTED:
+		if (!conn)
+			break;
 		rdsdebug("DISCONNECT event - dropping connection "
 			 "%pI6c->%pI6c\n", &conn->c_laddr,
 			 &conn->c_faddr);
-- 
2.17.0

