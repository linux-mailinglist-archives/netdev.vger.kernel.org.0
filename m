Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756216B7AB7
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjCMOp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjCMOp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:45:28 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9DB8A273;
        Mon, 13 Mar 2023 07:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=XUkM4
        tC9qgJ8JI69+mwuIdhC3T7dE6qVZKBv5HYpx0Y=; b=qKXWjSSmM3koMhRB8d27B
        I4aKIwSo/UP2YwU1X4xtHvKEsTelVQmhZsOkvZ6aVQU3K3gO/N9s+gw4UPzDlNdq
        SSzb597sWD7A4f8SIs7IbaqB3GXzBUobt6GYj6KY1detxJL9OLL93I1VLObOw4GO
        PqLqX7u7g6yAXc+kfUTxbs=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g1-3 (Coremail) with SMTP id _____wD3_7OONg9khOEOAA--.14012S2;
        Mon, 13 Mar 2023 22:43:26 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     ericvh@gmail.com
Cc:     michal.swiatkowski@linux.intel.com, lucho@ionkov.net,
        asmadeus@codewreck.org, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hackerzheng666@gmail.com, 1395428693sheep@gmail.com,
        alex000young@gmail.com, Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH net v3] 9p/xen : Fix use after free bug in xen_9pfs_front_remove  due  to race condition
Date:   Mon, 13 Mar 2023 22:43:25 +0800
Message-Id: <20230313144325.3622082-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wD3_7OONg9khOEOAA--.14012S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF15Cw48JFy5Kr1kWF4DJwb_yoW8XrW8pa
        nakF45CFyUAF10yFsYy3WxJ3WFyw48Gr1Iga12kw4fJr98Zry8XFZ5t34Yga4UAr4YqF4r
        Cw1UXFWDJFWDAw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zE6pBkUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiGhcxU1aEEjbiJwAAsc
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In xen_9pfs_front_probe, it calls xen_9pfs_front_alloc_dataring
to init priv->rings and bound &ring->work with p9_xen_response.

When it calls xen_9pfs_front_event_handler to handle IRQ requests,
it will finally call schedule_work to start the work.

When we call xen_9pfs_front_remove to remove the driver, there
may be a sequence as follows:

Fix it by finishing the work before cleanup in xen_9pfs_front_free.

Note that, this bug is found by static analysis, which might be
false positive.

CPU0                  CPU1

                     |p9_xen_response
xen_9pfs_front_remove|
  xen_9pfs_front_free|
kfree(priv)          |
//free priv          |
                     |p9_tag_lookup
                     |//use priv->client

Fixes: 71ebd71921e4 ("xen/9pfs: connect to the backend")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
v3:
- remove unnecessary comment and move definition to the
for loop suggested by Michal Swiatkowski

v2:
- fix type error of ring found by kernel test robot
---
 net/9p/trans_xen.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index c64050e839ac..df467ffb52d0 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -280,6 +280,10 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 	write_unlock(&xen_9pfs_lock);
 
 	for (i = 0; i < priv->num_rings; i++) {
+		struct xen_9pfs_dataring *ring = &priv->rings[i];
+
+		cancel_work_sync(&ring->work);
+
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
-- 
2.25.1

