Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D571F6B6E56
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 05:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjCMEPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 00:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCMEPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 00:15:04 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C12152886E;
        Sun, 12 Mar 2023 21:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=SHitx
        /p2v515lWIUtrn7VLSosh3Eis87AfBcSEwzhzA=; b=jxU/5wgcfYNdDyK7u6Hjc
        DjkHb77etGnELIsNQN/ri/2VB+L9s/MYXYheXz0Ie/NKcr0oPNGpYrCMCrYdSea0
        eK9QeazJYKHM0Ig3giywQfJpnz36lEWQR2jw08WBNSaWKG2YaWNnlLzlPGeR+lLX
        FYeMbjn3pEWORK8silVnt8=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g4-0 (Coremail) with SMTP id _____wBXdh_Rog5kJ4YGAA--.1868S2;
        Mon, 13 Mar 2023 12:13:05 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     ericvh@gmail.com
Cc:     lucho@ionkov.net, asmadeus@codewreck.org, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hackerzheng666@gmail.com, 1395428693sheep@gmail.com,
        alex000young@gmail.com, Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH net] 9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition
Date:   Mon, 13 Mar 2023 12:13:03 +0800
Message-Id: <20230313041303.3158458-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wBXdh_Rog5kJ4YGAA--.1868S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF15Cw48JFy5tr1xuF45Wrg_yoW8WF4Upa
        1Skrn5AFyqya1YyFsYy3WxJ3WYkw4rGr1Iga12kw4fJr98Ary8XrZ5tr1Yg34UAr4YqF4r
        Gw1DXa98JFZrAw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziaZXrUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiXQ8xU1WBo41K9wABs2
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
 net/9p/trans_xen.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index c64050e839ac..60adb3aadd63 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -274,16 +274,21 @@ static const struct xenbus_device_id xen_9pfs_front_ids[] = {
 static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 {
 	int i, j;
+	struct xen_9pfs_dataring *ring = NULL;
 
 	write_lock(&xen_9pfs_lock);
 	list_del(&priv->list);
 	write_unlock(&xen_9pfs_lock);
 
 	for (i = 0; i < priv->num_rings; i++) {
+		ring = priv->rings[i];
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
 			unbind_from_irqhandler(priv->rings[i].irq, priv->dev);
+
+		cancel_work_sync(&ring->work);
+
 		if (priv->rings[i].data.in) {
 			for (j = 0;
 			     j < (1 << priv->rings[i].intf->ring_order);
-- 
2.25.1

