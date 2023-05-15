Return-Path: <netdev+bounces-2745-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AEE8703CE2
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69401281313
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75D0B18C18;
	Mon, 15 May 2023 18:43:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F1E846E
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 18:43:07 +0000 (UTC)
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21611550D
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1684176142; x=1715712142;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AikkA7pXOOdL9ZlEq07K8us3ptDOi8/7eROwfXmxtDA=;
  b=izqliBoz/KCWzx1pXaFEf6M7XA8SYb4Exh/ngEPQxaMwP0uxEOwtsdet
   y1tP0Tgd1vQmKoIHm1A9Jm6rIhjh/6L1lRRQhGbI+zXP/Ermk+w6Lfnz3
   gzwHUegKxgzMxWBQpTSC2yviJf/RastOFsSL3Z6fVYcl2FAcSzdUSAvnH
   k=;
X-IronPort-AV: E=Sophos;i="5.99,277,1677542400"; 
   d="scan'208";a="325241321"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 18:42:19 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id 49DF9A0720;
	Mon, 15 May 2023 18:42:17 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 15 May 2023 18:42:16 +0000
Received: from 88665a182662.ant.amazon.com.com (10.88.183.148) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 15 May 2023 18:42:14 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, <netdev@vger.kernel.org>, syzkaller
	<syzkaller@googlegroups.com>
Subject: [PATCH v1 net] tun: Fix memory leak for detached NAPI queue.
Date: Mon, 15 May 2023 11:42:04 -0700
Message-ID: <20230515184204.10598-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.88.183.148]
X-ClientProxiedBy: EX19D043UWC003.ant.amazon.com (10.13.139.240) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzkaller reported [0] memory leaks of sk and skb related to the TUN
device with no repro, but we can reproduce it easily with:

  struct ifreq ifr = {}
  int fd_tun, fd_tmp;
  char buf[4] = {};

  fd_tun = openat(AT_FDCWD, "/dev/net/tun", O_WRONLY, 0);
  ifr.ifr_flags = IFF_TUN | IFF_NAPI | IFF_MULTI_QUEUE;
  ioctl(fd_tun, TUNSETIFF, &ifr);

  ifr.ifr_flags = IFF_DETACH_QUEUE;
  ioctl(fd_tun, TUNSETQUEUE, &ifr);

  fd_tmp = socket(AF_PACKET, SOCK_PACKET, 0);
  ifr.ifr_flags = IFF_UP;
  ioctl(fd_tmp, SIOCSIFFLAGS, &ifr);

  write(fd_tun, buf, sizeof(buf));
  close(fd_tun);

If we enable NAPI and multi-queue on a TUN device, we can put skb into
tfile->sk.sk_write_queue after the queue is detached.  We should prevent
it by checking tfile->detached before queuing skb.

Note this must be done under tfile->sk.sk_write_queue.lock because write()
and ioctl(IFF_DETACH_QUEUE) can run concurrently.  Otherwise, there would
be a small race window:

  write()                             ioctl(IFF_DETACH_QUEUE)
  `- tun_get_user                     `- __tun_detach
     |- if (tfile->detached)             |- tun_disable_queue
     |  `-> false                        |  `- tfile->detached = tun
     |                                   `- tun_queue_purge
     |- spin_lock_bh(&queue->lock)
     `- __skb_queue_tail(queue, skb)

Another solution is to call tun_queue_purge() when closing and
reattaching the detached queue, but it could paper over another
problems.  Also, we do the same kind of test for IFF_NAPI_FRAGS.

[0]:
unreferenced object 0xffff88801edbc800 (size 2048):
  comm "syz-executor.1", pid 33269, jiffies 4295743834 (age 18.756s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
  backtrace:
    [<000000008c16ea3d>] __do_kmalloc_node mm/slab_common.c:965 [inline]
    [<000000008c16ea3d>] __kmalloc+0x4a/0x130 mm/slab_common.c:979
    [<000000003addde56>] kmalloc include/linux/slab.h:563 [inline]
    [<000000003addde56>] sk_prot_alloc+0xef/0x1b0 net/core/sock.c:2035
    [<000000003e20621f>] sk_alloc+0x36/0x2f0 net/core/sock.c:2088
    [<0000000028e43843>] tun_chr_open+0x3d/0x190 drivers/net/tun.c:3438
    [<000000001b0f1f28>] misc_open+0x1a6/0x1f0 drivers/char/misc.c:165
    [<000000004376f706>] chrdev_open+0x111/0x300 fs/char_dev.c:414
    [<00000000614d379f>] do_dentry_open+0x2f9/0x750 fs/open.c:920
    [<000000008eb24774>] do_open fs/namei.c:3636 [inline]
    [<000000008eb24774>] path_openat+0x143f/0x1a30 fs/namei.c:3791
    [<00000000955077b5>] do_filp_open+0xce/0x1c0 fs/namei.c:3818
    [<00000000b78973b0>] do_sys_openat2+0xf0/0x260 fs/open.c:1356
    [<00000000057be699>] do_sys_open fs/open.c:1372 [inline]
    [<00000000057be699>] __do_sys_openat fs/open.c:1388 [inline]
    [<00000000057be699>] __se_sys_openat fs/open.c:1383 [inline]
    [<00000000057be699>] __x64_sys_openat+0x83/0xf0 fs/open.c:1383
    [<00000000a7d2182d>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<00000000a7d2182d>] do_syscall_64+0x3c/0x90 arch/x86/entry/common.c:80
    [<000000004cc4e8c4>] entry_SYSCALL_64_after_hwframe+0x72/0xdc

unreferenced object 0xffff88802f671700 (size 240):
  comm "syz-executor.1", pid 33269, jiffies 4295743854 (age 18.736s)
  hex dump (first 32 bytes):
    68 c9 db 1e 80 88 ff ff 68 c9 db 1e 80 88 ff ff  h.......h.......
    00 c0 7b 2f 80 88 ff ff 00 c8 db 1e 80 88 ff ff  ..{/............
  backtrace:
    [<00000000e9d9fdb6>] __alloc_skb+0x223/0x250 net/core/skbuff.c:644
    [<000000002c3e4e0b>] alloc_skb include/linux/skbuff.h:1288 [inline]
    [<000000002c3e4e0b>] alloc_skb_with_frags+0x6f/0x350 net/core/skbuff.c:6378
    [<00000000825f98d7>] sock_alloc_send_pskb+0x3ac/0x3e0 net/core/sock.c:2729
    [<00000000e9eb3df3>] tun_alloc_skb drivers/net/tun.c:1529 [inline]
    [<00000000e9eb3df3>] tun_get_user+0x5e1/0x1f90 drivers/net/tun.c:1841
    [<0000000053096912>] tun_chr_write_iter+0xac/0x120 drivers/net/tun.c:2035
    [<00000000b9282ae0>] call_write_iter include/linux/fs.h:1868 [inline]
    [<00000000b9282ae0>] new_sync_write fs/read_write.c:491 [inline]
    [<00000000b9282ae0>] vfs_write+0x40f/0x530 fs/read_write.c:584
    [<00000000524566e4>] ksys_write+0xa1/0x170 fs/read_write.c:637
    [<00000000a7d2182d>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<00000000a7d2182d>] do_syscall_64+0x3c/0x90 arch/x86/entry/common.c:80
    [<000000004cc4e8c4>] entry_SYSCALL_64_after_hwframe+0x72/0xdc

Fixes: cde8b15f1aab ("tuntap: add ioctl to attach or detach a file form tuntap device")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 drivers/net/tun.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index d4d0a41a905a..d75456adc62a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1977,6 +1977,14 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		int queue_len;
 
 		spin_lock_bh(&queue->lock);
+
+		if (unlikely(tfile->detached)) {
+			spin_unlock_bh(&queue->lock);
+			rcu_read_unlock();
+			err = -EBUSY;
+			goto free_skb;
+		}
+
 		__skb_queue_tail(queue, skb);
 		queue_len = skb_queue_len(queue);
 		spin_unlock(&queue->lock);
@@ -2512,6 +2520,13 @@ static int tun_xdp_one(struct tun_struct *tun,
 	if (tfile->napi_enabled) {
 		queue = &tfile->sk.sk_write_queue;
 		spin_lock(&queue->lock);
+
+		if (unlikely(tfile->detached)) {
+			spin_unlock(&queue->lock);
+			kfree_skb(skb);
+			return -EBUSY;
+		}
+
 		__skb_queue_tail(queue, skb);
 		spin_unlock(&queue->lock);
 		ret = 1;
-- 
2.30.2


