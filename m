Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD90538BF0
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 09:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244493AbiEaH1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 03:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242971AbiEaH1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 03:27:36 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7951A49F8E;
        Tue, 31 May 2022 00:27:33 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LC3jq1T7VzjXBy;
        Tue, 31 May 2022 15:26:23 +0800 (CST)
Received: from container.huawei.com (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 15:27:29 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ap420073@gmail.com>
Subject: [PATCH net v2] macsec: fix UAF bug for real_dev
Date:   Tue, 31 May 2022 15:45:00 +0800
Message-ID: <20220531074500.1272846-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new macsec device but not get reference to real_dev. That can
not ensure that real_dev is freed after macsec. That will trigger the
UAF bug for real_dev as following:

==================================================================
BUG: KASAN: use-after-free in macsec_get_iflink+0x5f/0x70 drivers/net/macsec.c:3662
Call Trace:
 ...
 macsec_get_iflink+0x5f/0x70 drivers/net/macsec.c:3662
 dev_get_iflink+0x73/0xe0 net/core/dev.c:637
 default_operstate net/core/link_watch.c:42 [inline]
 rfc2863_policy+0x233/0x2d0 net/core/link_watch.c:54
 linkwatch_do_dev+0x2a/0x150 net/core/link_watch.c:161

Allocated by task 22209:
 ...
 alloc_netdev_mqs+0x98/0x1100 net/core/dev.c:10549
 rtnl_create_link+0x9d7/0xc00 net/core/rtnetlink.c:3235
 veth_newlink+0x20e/0xa90 drivers/net/veth.c:1748

Freed by task 8:
 ...
 kfree+0xd6/0x4d0 mm/slub.c:4552
 kvfree+0x42/0x50 mm/util.c:615
 device_release+0x9f/0x240 drivers/base/core.c:2229
 kobject_cleanup lib/kobject.c:673 [inline]
 kobject_release lib/kobject.c:704 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:721
 netdev_run_todo+0x72e/0x10b0 net/core/dev.c:10327

After commit faab39f63c1f ("net: allow out-of-order netdev unregistration")
and commit e5f80fcf869a ("ipv6: give an IPv6 dev to blackhole_netdev"), we
can add dev_hold_track() in macsec_dev_init() and dev_put_track() in
macsec_free_netdev() to fix the problem.

Fixes: 2bce1ebed17d ("macsec: fix refcnt leak in module exit routine")
Reported-by: syzbot+d0e94b65ac259c29ce7a@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

---
v2:
  - Add kdoc for new member @dev_tracker.

---
 drivers/net/macsec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 832f09ac075e..817577e713d7 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -99,6 +99,7 @@ struct pcpu_secy_stats {
  * struct macsec_dev - private data
  * @secy: SecY config
  * @real_dev: pointer to underlying netdevice
+ * @dev_tracker: refcount tracker for @real_dev reference
  * @stats: MACsec device stats
  * @secys: linked list of SecY's on the underlying device
  * @gro_cells: pointer to the Generic Receive Offload cell
@@ -107,6 +108,7 @@ struct pcpu_secy_stats {
 struct macsec_dev {
 	struct macsec_secy secy;
 	struct net_device *real_dev;
+	netdevice_tracker dev_tracker;
 	struct pcpu_secy_stats __percpu *stats;
 	struct list_head secys;
 	struct gro_cells gro_cells;
@@ -3459,6 +3461,9 @@ static int macsec_dev_init(struct net_device *dev)
 	if (is_zero_ether_addr(dev->broadcast))
 		memcpy(dev->broadcast, real_dev->broadcast, dev->addr_len);
 
+	/* Get macsec's reference to real_dev */
+	dev_hold_track(real_dev, &macsec->dev_tracker, GFP_KERNEL);
+
 	return 0;
 }
 
@@ -3704,6 +3709,8 @@ static void macsec_free_netdev(struct net_device *dev)
 	free_percpu(macsec->stats);
 	free_percpu(macsec->secy.tx_sc.stats);
 
+	/* Get rid of the macsec's reference to real_dev */
+	dev_put_track(macsec->real_dev, &macsec->dev_tracker);
 }
 
 static void macsec_setup(struct net_device *dev)
-- 
2.25.1

