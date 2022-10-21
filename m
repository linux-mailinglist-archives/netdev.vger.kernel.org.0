Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE4F607D26
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 19:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiJURCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 13:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiJURCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 13:02:21 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED32265518
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 10:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666371737; x=1697907737;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r+08vGzy2YpbwqCd/H24Nd/mRryGXneIkJ0fl8Cn480=;
  b=l19mvi8LpBCPcg7eeIPU2WYRBhsVE50ZXaNH0S0ni+liJmrP9lUQQdaJ
   3a6fEXnWQ+2fi7vvQJLwj0yN3E3PifegZQZevR7kzq0BPMLlKPbff40Jn
   nfi8RGWwSeb6qSNItVgHdgEAkgfWJnD+/iXd6s2+5y/UCe+hf2GDW8nQG
   g=;
X-IronPort-AV: E=Sophos;i="5.95,202,1661817600"; 
   d="scan'208";a="235144507"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 17:02:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com (Postfix) with ESMTPS id 0E5462033BD;
        Fri, 21 Oct 2022 17:02:08 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 21 Oct 2022 17:02:07 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.179) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Fri, 21 Oct 2022 17:02:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [PATCH net-next] net: add a refcount tracker for kernel sockets
Date:   Fri, 21 Oct 2022 10:01:54 -0700
Message-ID: <20221021170154.88207-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221020232018.3333414-1-edumazet@google.com>
References: <20221020232018.3333414-1-edumazet@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.179]
X-ClientProxiedBy: EX13D37UWA002.ant.amazon.com (10.43.160.211) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Date:   Thu, 20 Oct 2022 23:20:18 +0000
From:   Eric Dumazet <edumazet@google.com>
> Commit ffa84b5ffb37 ("net: add netns refcount tracker to struct sock")
> added a tracker to sockets, but did not track kernel sockets.
> 
> We still have syzbot reports hinting about netns being destroyed
> while some kernel TCP sockets had not been dismantled.
> 
> This patch tracks kernel sockets, and adds a ref_tracker_dir_print()
> call to net_free() right before the netns is freed.
> 
> Normally, each layer is responsible for properly releasing its
> kernel sockets before last call to net_free().
> 
> This debugging facility is enabled with CONFIG_NET_NS_REFCNT_TRACKER=y
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Tested-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thanks for the patch!
I confirmed it worked with a buggy module :)

---8<---
$ head -n 100 *
==> kern_sk.c <==
#include <linux/module.h>
#include <net/tcp.h>

MODULE_LICENSE("GPL");

struct socket *sock = NULL;

static int __init init_kern_sk(void)
{
	struct net *net = current->nsproxy->net_ns;
	int ret;

	ret = sock_create_kern(net, AF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);

	return ret;
}

static void __exit exit_kern_sk(void)
{
	sock_release(sock);
}


module_init(init_kern_sk);
module_exit(exit_kern_sk);

==> Makefile <==
obj-m := kern_sk.o
SRC := /mnt/ec2-user/kernel/kern_sk_reftracker
PWD := $(shell pwd)

default:
	$(MAKE) -C $(SRC) M=$(PWD) modules

clean:
	$(MAKE) -C $(SRC) M=$(PWD) clean

---8<---

---8<---
[root@localhost ~]# unshare -n insmod ./kern_sk.ko
[   22.650224] kern_sk: loading out-of-tree module taints kernel.
[root@localhost ~]# [   22.693636] leaked reference.
[   22.693836]  sk_alloc+0x1f3/0x210
[   22.694009]  inet_create+0xca/0x370
[   22.694194]  __sock_create+0x106/0x1c0
[   22.694388]  do_one_initcall+0x3c/0x1f0
[   22.694588]  do_init_module+0x46/0x1c0
[   22.694781]  __do_sys_finit_module+0xa6/0x100
[   22.695000]  do_syscall_64+0x38/0x90
[   22.695183]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   22.695470] ------------[ cut here ]------------
[   22.695709] WARNING: CPU: 2 PID: 58 at lib/ref_tracker.c:39 ref_tracker_dir_exit.cold+0x62/0x6e
[   22.696142] Modules linked in: kern_sk(O)
[   22.696344] CPU: 2 PID: 58 Comm: kworker/u8:2 Tainted: G           O       6.0.0-11828-g86ae4a5d11bc #4
[   22.696811] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.amzn2022.0.1 04/01/2014
[   22.697285] Workqueue: netns cleanup_net
[   22.697487] RIP: 0010:ref_tracker_dir_exit.cold+0x62/0x6e
[   22.697767] Code: 00 00 00 00 ad de 48 89 45 08 4c 89 6d 00 4c 89 e5 e8 7a f0 45 ff 49 8b 04 24 49 39 dc 75 12 4c 89 f6 4c 89 ff e8 16 18 05 00 <0f> 0b e9 23 94 7e ff 49 89 c4 eb 9c 48 c7 c7 80 f1 58 82 48 89 04
[   22.698671] RSP: 0018:ffffc90000a1fe08 EFLAGS: 00010246
[   22.698931] RAX: 0000000000000000 RBX: ffff888107838ea0 RCX: 0000000000000000
[   22.699285] RDX: 0000000000000001 RSI: 0000000000000282 RDI: 00000000ffffffff
[   22.699650] RBP: ffff888107838ea0 R08: 0000000000000001 R09: ffffffff81d65800
[   22.700000] R10: ffffffff82856080 R11: ffffffff82906080 R12: ffff888107838ea0
[   22.700351] R13: dead000000000100 R14: 0000000000000282 R15: ffff888107838e88
[   22.700710] FS:  0000000000000000(0000) GS:ffff88842fd00000(0000) knlGS:0000000000000000
[   22.701106] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.701391] CR2: 00005578b9031148 CR3: 0000000102358001 CR4: 0000000000770ee0
[   22.701760] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   22.702108] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   22.702456] PKRU: 55555554
[   22.702613] Call Trace:
[   22.702750]  <TASK>
[   22.702890]  net_free+0x34/0x50
[   22.703077]  cleanup_net+0x2cd/0x330
[   22.703260]  process_one_work+0x1d4/0x3a0
[   22.703466]  worker_thread+0x48/0x3c0
[   22.703669]  ? process_one_work+0x3a0/0x3a0
[   22.703881]  kthread+0xe0/0x110
[   22.704049]  ? kthread_complete_and_exit+0x20/0x20
[   22.704287]  ret_from_fork+0x1f/0x30
[   22.704472]  </TASK>
[   22.704640] ---[ end trace 0000000000000000 ]---
---8<---
