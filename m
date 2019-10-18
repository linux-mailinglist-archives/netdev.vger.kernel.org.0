Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D02EDD3CB
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 00:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391137AbfJRWUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 18:20:11 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:52489 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732044AbfJRWUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 18:20:10 -0400
Received: by mail-pg1-f201.google.com with SMTP id e15so5185836pgh.19
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 15:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=W1QDo0Jkh1ZxQ4EW+whWC6eIb/d7rLFoT83l2EeWuww=;
        b=WV5mtbaUjrJmLCmFJ271B+PRKjfC+rsRdMlnNMq7Ls0pPmItfJGi+miH/8eLq4Q9zt
         2THzuWIEF0nCR1ij6XIVR8JEkilaehr2P5P3V6GjpvYypVCjlvyXRZQ5jsfPhdRspHqX
         TpLmFr6BaTsZDtujofhpMhxUBJuXHFHbbpphNygQoZcWLO18OhXDG49SEdpHujlXbFK0
         dys+If5uZdu/ZO+8mIYEn8qhjkCGZegj/0CQyti4+twE0g5xBD6JvmPIyAoZHQAhnUd3
         LkCcN0i7KAtibuGHJXSV7yseDMHEELgOuJpbtQHZYHARUmYrnrxNvMFMCQKGR5db6aFd
         79tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=W1QDo0Jkh1ZxQ4EW+whWC6eIb/d7rLFoT83l2EeWuww=;
        b=WUGkU5VzM00I6X6F++lcq7pfwVlkvjUsNrLh1HCBUkDIXDW2731W9Aa1xQgIX3PBHC
         Dp8Hkjhz0adx2ZAQ+ueCMqbMhqA3Gm765gazA5D6mxtogZTVTExr0Xom02E5sSE1lQZy
         lRT/ADBYbnRspL430KAPwJE6AL1K4QuUFI34tEu5NvlrKbTxrbr/eB9lpekqYA8pz/nK
         Cwnx4149RnFIT29Gt2kKgITquCNBlY2AcuzL/OnGz0SVjJN6qKQJ6uPNIr8+IA56CDeC
         k68biwy1M7pwq/VBGBqG2rXXuSAiY1B34xp7aJfzTbnMHe4F3a2ezj9z7/VDWUhzT/Mu
         gyLg==
X-Gm-Message-State: APjAAAW/u87YfPvg7hORIFIVTGdXsLnVUBgUAIoVm/lCE+NLS+hMWUg8
        YX6W9wjCpQJQzcqCq5SzKI0DQGHRgQH0JA==
X-Google-Smtp-Source: APXvYqzvIVXpn9uKRFuhDwJAV/yzv5kF7dv7kYCjzQZH7tyWfIG028rGDlcgkN/Ccj7d2spCoLtmwg8PVv7CFQ==
X-Received: by 2002:a63:311:: with SMTP id 17mr12316474pgd.327.1571437209078;
 Fri, 18 Oct 2019 15:20:09 -0700 (PDT)
Date:   Fri, 18 Oct 2019 15:20:05 -0700
Message-Id: <20191018222005.45260-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH net] net: reorder 'struct net' fields to avoid false sharing
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intel test robot reported a ~7% regression on TCP_CRR tests
that they bisected to the cited commit.

Indeed, every time a new TCP socket is created or deleted,
the atomic counter net->count is touched (via get_net(net)
and put_net(net) calls)

So cpus might have to reload a contended cache line in
net_hash_mix(net) calls.

We need to reorder 'struct net' fields to move @hash_mix
in a read mostly cache line.

We move in the first cache line fields that can be
dirtied often.

We probably will have to address in a followup patch
the __randomize_layout that was added in linux-4.13,
since this might break our placement choices.

Fixes: 355b98553789 ("netns: provide pure entropy for net_hash_mix()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
---
 include/net/net_namespace.h | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index f8712bbeb2e039657e5cf8d37b15511de8c9c694..4c2cd937869964301117bea84aeefd8174d641fd 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -52,6 +52,9 @@ struct bpf_prog;
 #define NETDEV_HASHENTRIES (1 << NETDEV_HASHBITS)
 
 struct net {
+	/* First cache line can be often dirtied.
+	 * Do not place here read-mostly fields.
+	 */
 	refcount_t		passive;	/* To decide when the network
 						 * namespace should be freed.
 						 */
@@ -60,7 +63,13 @@ struct net {
 						 */
 	spinlock_t		rules_mod_lock;
 
-	u32			hash_mix;
+	unsigned int		dev_unreg_count;
+
+	unsigned int		dev_base_seq;	/* protected by rtnl_mutex */
+	int			ifindex;
+
+	spinlock_t		nsid_lock;
+	atomic_t		fnhe_genid;
 
 	struct list_head	list;		/* list of network namespaces */
 	struct list_head	exit_list;	/* To linked to call pernet exit
@@ -76,11 +85,11 @@ struct net {
 #endif
 	struct user_namespace   *user_ns;	/* Owning user namespace */
 	struct ucounts		*ucounts;
-	spinlock_t		nsid_lock;
 	struct idr		netns_ids;
 
 	struct ns_common	ns;
 
+	struct list_head 	dev_base_head;
 	struct proc_dir_entry 	*proc_net;
 	struct proc_dir_entry 	*proc_net_stat;
 
@@ -93,17 +102,18 @@ struct net {
 
 	struct uevent_sock	*uevent_sock;		/* uevent socket */
 
-	struct list_head 	dev_base_head;
 	struct hlist_head 	*dev_name_head;
 	struct hlist_head	*dev_index_head;
-	unsigned int		dev_base_seq;	/* protected by rtnl_mutex */
-	int			ifindex;
-	unsigned int		dev_unreg_count;
+	/* Note that @hash_mix can be read millions times per second,
+	 * it is critical that it is on a read_mostly cache line.
+	 */
+	u32			hash_mix;
+
+	struct net_device       *loopback_dev;          /* The loopback */
 
 	/* core fib_rules */
 	struct list_head	rules_ops;
 
-	struct net_device       *loopback_dev;          /* The loopback */
 	struct netns_core	core;
 	struct netns_mib	mib;
 	struct netns_packet	packet;
@@ -171,7 +181,6 @@ struct net {
 	struct sock		*crypto_nlsk;
 #endif
 	struct sock		*diag_nlsk;
-	atomic_t		fnhe_genid;
 } __randomize_layout;
 
 #include <linux/seq_file_net.h>
-- 
2.23.0.866.gb869b98d4c-goog

