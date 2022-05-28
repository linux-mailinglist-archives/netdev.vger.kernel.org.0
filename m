Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E07536BDB
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 11:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbiE1JTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 05:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbiE1JTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 05:19:30 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F558D6;
        Sat, 28 May 2022 02:19:29 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L9GMX63WBzDqSc;
        Sat, 28 May 2022 17:19:20 +0800 (CST)
Received: from container.huawei.com (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 28 May 2022 17:19:27 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ap420073@gmail.com>
Subject: [PATCH net] macsec: fix UAF bug for real_dev
Date:   Sat, 28 May 2022 17:36:59 +0800
Message-ID: <20220528093659.3186312-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
 drivers/net/macsec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 832f09ac075e..75f85e809a89 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -107,6 +107,7 @@ struct pcpu_secy_stats {
 struct macsec_dev {
 	struct macsec_secy secy;
 	struct net_device *real_dev;
+	netdevice_tracker dev_tracker;
 	struct pcpu_secy_stats __percpu *stats;
 	struct list_head secys;
 	struct gro_cells gro_cells;
@@ -3459,6 +3460,9 @@ static int macsec_dev_init(struct net_device *dev)
 	if (is_zero_ether_addr(dev->broadcast))
 		memcpy(dev->broadcast, real_dev->broadcast, dev->addr_len);
 
+	/* Get macsec's reference to real_dev */
+	dev_hold_track(real_dev, &macsec->dev_tracker, GFP_KERNEL);
+
 	return 0;
 }
 
@@ -3704,6 +3708,8 @@ static void macsec_free_netdev(struct net_device *dev)
 	free_percpu(macsec->stats);
 	free_percpu(macsec->secy.tx_sc.stats);
 
+	/* Get rid of the macsec's reference to real_dev */
+	dev_put_track(macsec->real_dev, &macsec->dev_tracker);
 }
 
 static void macsec_setup(struct net_device *dev)
-- 
2.25.1

