Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF153C3234
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 05:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhGJDTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 23:19:23 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:57424 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230233AbhGJDTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 23:19:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UfGEvcR_1625886995;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UfGEvcR_1625886995)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 10 Jul 2021 11:16:35 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        bpf@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: [PATCH net v4] xdp, net: fix use-after-free in bpf_xdp_link_release
Date:   Sat, 10 Jul 2021 11:16:35 +0800
Message-Id: <20210710031635.41649-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The problem occurs between dev_get_by_index() and dev_xdp_attach_link().
At this point, dev_xdp_uninstall() is called. Then xdp link will not be
detached automatically when dev is released. But link->dev already
points to dev, when xdp link is released, dev will still be accessed,
but dev has been released.

dev_get_by_index()        |
link->dev = dev           |
                          |      rtnl_lock()
                          |      unregister_netdevice_many()
                          |          dev_xdp_uninstall()
                          |      rtnl_unlock()
rtnl_lock();              |
dev_xdp_attach_link()     |
rtnl_unlock();            |
                          |      netdev_run_todo() // dev released
bpf_xdp_link_release()    |
    /* access dev.        |
       use-after-free */  |

[   45.966867] BUG: KASAN: use-after-free in bpf_xdp_link_release+0x3b8/0x3d0
[   45.967619] Read of size 8 at addr ffff00000f9980c8 by task a.out/732
[   45.968297]
[   45.968502] CPU: 1 PID: 732 Comm: a.out Not tainted 5.13.0+ #22
[   45.969222] Hardware name: linux,dummy-virt (DT)
[   45.969795] Call trace:
[   45.970106]  dump_backtrace+0x0/0x4c8
[   45.970564]  show_stack+0x30/0x40
[   45.970981]  dump_stack_lvl+0x120/0x18c
[   45.971470]  print_address_description.constprop.0+0x74/0x30c
[   45.972182]  kasan_report+0x1e8/0x200
[   45.972659]  __asan_report_load8_noabort+0x2c/0x50
[   45.973273]  bpf_xdp_link_release+0x3b8/0x3d0
[   45.973834]  bpf_link_free+0xd0/0x188
[   45.974315]  bpf_link_put+0x1d0/0x218
[   45.974790]  bpf_link_release+0x3c/0x58
[   45.975291]  __fput+0x20c/0x7e8
[   45.975706]  ____fput+0x24/0x30
[   45.976117]  task_work_run+0x104/0x258
[   45.976609]  do_notify_resume+0x894/0xaf8
[   45.977121]  work_pending+0xc/0x328
[   45.977575]
[   45.977775] The buggy address belongs to the page:
[   45.978369] page:fffffc00003e6600 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4f998
[   45.979522] flags: 0x7fffe0000000000(node=0|zone=0|lastcpupid=0x3ffff)
[   45.980349] raw: 07fffe0000000000 fffffc00003e6708 ffff0000dac3c010 0000000000000000
[   45.981309] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[   45.982259] page dumped because: kasan: bad access detected
[   45.982948]
[   45.983153] Memory state around the buggy address:
[   45.983753]  ffff00000f997f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   45.984645]  ffff00000f998000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   45.985533] >ffff00000f998080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   45.986419]                                               ^
[   45.987112]  ffff00000f998100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   45.988006]  ffff00000f998180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   45.988895] ==================================================================
[   45.989773] Disabling lock debugging due to kernel taint
[   45.990552] Kernel panic - not syncing: panic_on_warn set ...
[   45.991166] CPU: 1 PID: 732 Comm: a.out Tainted: G    B             5.13.0+ #22
[   45.991929] Hardware name: linux,dummy-virt (DT)
[   45.992448] Call trace:
[   45.992753]  dump_backtrace+0x0/0x4c8
[   45.993208]  show_stack+0x30/0x40
[   45.993627]  dump_stack_lvl+0x120/0x18c
[   45.994113]  dump_stack+0x1c/0x34
[   45.994530]  panic+0x3a4/0x7d8
[   45.994930]  end_report+0x194/0x198
[   45.995380]  kasan_report+0x134/0x200
[   45.995850]  __asan_report_load8_noabort+0x2c/0x50
[   45.996453]  bpf_xdp_link_release+0x3b8/0x3d0
[   45.997007]  bpf_link_free+0xd0/0x188
[   45.997474]  bpf_link_put+0x1d0/0x218
[   45.997942]  bpf_link_release+0x3c/0x58
[   45.998429]  __fput+0x20c/0x7e8
[   45.998833]  ____fput+0x24/0x30
[   45.999247]  task_work_run+0x104/0x258
[   45.999731]  do_notify_resume+0x894/0xaf8
[   46.000236]  work_pending+0xc/0x328
[   46.000697] SMP: stopping secondary CPUs
[   46.001226] Dumping ftrace buffer:
[   46.001663]    (ftrace buffer empty)
[   46.002110] Kernel Offset: disabled
[   46.002545] CPU features: 0x00000001,23202c00
[   46.003080] Memory Limit: none

Fixes: aa8d3a716b59db6c ("bpf, xdp: Add bpf_link-based XDP attachment API")
Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---

v4: fix commit message

v3: v1 + "link->dev = NULL"

 net/core/dev.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c253c2aafe97..9f508c597037 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9684,14 +9684,17 @@ int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 	struct net_device *dev;
 	int err, fd;

+	rtnl_lock();
 	dev = dev_get_by_index(net, attr->link_create.target_ifindex);
-	if (!dev)
+	if (!dev) {
+		rtnl_unlock();
 		return -EINVAL;
+	}

 	link = kzalloc(sizeof(*link), GFP_USER);
 	if (!link) {
 		err = -ENOMEM;
-		goto out_put_dev;
+		goto unlock;
 	}

 	bpf_link_init(&link->link, BPF_LINK_TYPE_XDP, &bpf_xdp_link_lops, prog);
@@ -9701,14 +9704,14 @@ int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err) {
 		kfree(link);
-		goto out_put_dev;
+		goto unlock;
 	}

-	rtnl_lock();
 	err = dev_xdp_attach_link(dev, NULL, link);
 	rtnl_unlock();

 	if (err) {
+		link->dev = NULL;
 		bpf_link_cleanup(&link_primer);
 		goto out_put_dev;
 	}
@@ -9718,6 +9721,9 @@ int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 	dev_put(dev);
 	return fd;

+unlock:
+	rtnl_unlock();
+
 out_put_dev:
 	dev_put(dev);
 	return err;
--
2.31.0

