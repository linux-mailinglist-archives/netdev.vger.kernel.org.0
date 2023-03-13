Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59AF6B7205
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjCMJGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjCMJGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:06:13 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F5F2126DA;
        Mon, 13 Mar 2023 02:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Gp4+C
        4gCMjSOFnYU898NA74fjHaBuOlyPKxcR6f/MrM=; b=KGETv7MYHU+IHxw98BaBR
        VDQdxpMYuwdI1zU0dSr77DawJfbRVpRuAa0fgLiQwAxWr3trRXIyDtCzcrX1TD5f
        naMFYoZ39uhUIHbo6a2mEgnQ3hC+dMZ3QXhHe4GFxefMpqA3DwnqwItVIKaYqQYU
        gXBFT+1IfXoEjwX0xtGnXQ=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g0-3 (Coremail) with SMTP id _____wDXOaAT5g5kXWohAA--.8836S2;
        Mon, 13 Mar 2023 17:00:04 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     ericvh@gmail.com
Cc:     lucho@ionkov.net, asmadeus@codewreck.org, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hackerzheng666@gmail.com, 1395428693sheep@gmail.com,
        alex000young@gmail.com, Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH net v2] 9p/xen : Fix use after free bug in xen_9pfs_front_remove due  to race condition
Date:   Mon, 13 Mar 2023 17:00:02 +0800
Message-Id: <20230313090002.3308025-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDXOaAT5g5kXWohAA--.8836S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF15Cw48JFy5Kr1kWF4DJwb_yoW8Xw1xpa
        nakFWrAFyUA3WjyFsYyas7G3WrCw4rGr1Iga12kw4fJr98Jry8XFZ5t34Yg345Ar4YqF1r
        Cw1UWFWDJFWDZw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziID73UUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiXRoxU1WBo5B68QAAsJ
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
v2:
- fix type error of ring found by kernel test robot
---
 net/9p/trans_xen.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index c64050e839ac..83764431c066 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -274,12 +274,17 @@ static const struct xenbus_device_id xen_9pfs_front_ids[] = {
 static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 {
 	int i, j;
+	struct xen_9pfs_dataring *ring = NULL;
 
 	write_lock(&xen_9pfs_lock);
 	list_del(&priv->list);
 	write_unlock(&xen_9pfs_lock);
 
 	for (i = 0; i < priv->num_rings; i++) {
+		/*cancel work*/
+		ring = &priv->rings[i];
+		cancel_work_sync(&ring->work);
+
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
-- 
2.25.1

