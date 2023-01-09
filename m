Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672F4662B66
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 17:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbjAIQjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 11:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbjAIQja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 11:39:30 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D04636325
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 08:39:28 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id a9so4470990ilp.6
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 08:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xrg136BCp0PmT+E9WTU4STUIwjfV5DcN5FDK70FqYcI=;
        b=aIFfWS0cT4UCU3f6+rKm+5rHYgjr2Tnu5w/qCdXoxWFfN6ueukXs1tp/iAqvpFruK7
         6tN75Q/bqrlviXjadh9+tAa31LXc9OPq9r3CqA566MBQTvoURfX3gKuDU8AqrQDRBhyZ
         c06SMvz82ThLUp5ehRVxJiZtnjJqPdFRKpKEA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xrg136BCp0PmT+E9WTU4STUIwjfV5DcN5FDK70FqYcI=;
        b=BS1klp0c4chD9JL8f5f9SiAT0M0U/kemHks3NQZx/Nqvw3R8jpUoExiM/SlfQXA22t
         Akc4nOks6u6E3CsKZsB12YLamZItzKOWr+SBW6fWSTMLMC/rxkBSCwJEOpHdooxXYjR1
         Cc4JQRdw10e2raD7KCUDGSC/gLH+mCIpLNTtvAjf5cLFMLTgIbUihozcVt5Q5onLQNqH
         Zge9/KWLkL5nRwtzXXgjd1/GR/6AJmiCk3/BNw1Ro/dffR7A3rNFKE4P663mkEAOqndq
         VFWvFK2ZE9vgRpdUjoL4Z/o6speXnGFJpZyHdEP8bB2VDU93XGqGa2wmjOOAMyKBSItC
         P+4w==
X-Gm-Message-State: AFqh2kow83Y4qFNyWho09po+UDhBwBi3gpi9QYa4CMEuJcQLQQx6k64X
        QH4KbU76cGx9LAYunGhP294Ktg==
X-Google-Smtp-Source: AMrXdXsKno4G65HN0v8xsEuZOmhCnZC8InIBvJDkqhetZl7+YX9yYEGFPoFLGieuDFZqVW7UzXp4lQ==
X-Received: by 2002:a05:6e02:2205:b0:30d:92c4:8d6 with SMTP id j5-20020a056e02220500b0030d92c408d6mr9444298ilf.10.1673282367876;
        Mon, 09 Jan 2023 08:39:27 -0800 (PST)
Received: from localhost.localdomain ([70.57.89.124])
        by smtp.gmail.com with ESMTPSA id w17-20020a92ad11000000b0030c44ed932asm2790684ilh.29.2023.01.09.08.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 08:39:27 -0800 (PST)
From:   Frederick Lawler <fred@cloudflare.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        zymon.heidrich@gmail.com, phil@nwl.cc, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Frederick Lawler <fred@cloudflare.com>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>
Subject: [PATCH net] net: sched: disallow noqueue for qdisc classes
Date:   Mon,  9 Jan 2023 10:39:06 -0600
Message-Id: <20230109163906.706000-1-fred@cloudflare.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While experimenting with applying noqueue to a classful queue discipline,
we discovered a NULL pointer dereference in the __dev_queue_xmit()
path that generates a kernel OOPS:

    # dev=enp0s5
    # tc qdisc replace dev $dev root handle 1: htb default 1
    # tc class add dev $dev parent 1: classid 1:1 htb rate 10mbit
    # tc qdisc add dev $dev parent 1:1 handle 10: noqueue
    # ping -I $dev -w 1 -c 1 1.1.1.1

[    2.172856] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    2.173217] #PF: supervisor instruction fetch in kernel mode
...
[    2.178451] Call Trace:
[    2.178577]  <TASK>
[    2.178686]  htb_enqueue+0x1c8/0x370
[    2.178880]  dev_qdisc_enqueue+0x15/0x90
[    2.179093]  __dev_queue_xmit+0x798/0xd00
[    2.179305]  ? _raw_write_lock_bh+0xe/0x30
[    2.179522]  ? __local_bh_enable_ip+0x32/0x70
[    2.179759]  ? ___neigh_create+0x610/0x840
[    2.179968]  ? eth_header+0x21/0xc0
[    2.180144]  ip_finish_output2+0x15e/0x4f0
[    2.180348]  ? dst_output+0x30/0x30
[    2.180525]  ip_push_pending_frames+0x9d/0xb0
[    2.180739]  raw_sendmsg+0x601/0xcb0
[    2.180916]  ? _raw_spin_trylock+0xe/0x50
[    2.181112]  ? _raw_spin_unlock_irqrestore+0x16/0x30
[    2.181354]  ? get_page_from_freelist+0xcd6/0xdf0
[    2.181594]  ? sock_sendmsg+0x56/0x60
[    2.181781]  sock_sendmsg+0x56/0x60
[    2.181958]  __sys_sendto+0xf7/0x160
[    2.182139]  ? handle_mm_fault+0x6e/0x1d0
[    2.182366]  ? do_user_addr_fault+0x1e1/0x660
[    2.182627]  __x64_sys_sendto+0x1b/0x30
[    2.182881]  do_syscall_64+0x38/0x90
[    2.183085]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
...
[    2.187402]  </TASK>

Previously in commit d66d6c3152e8 ("net: sched: register noqueue
qdisc"), NULL was set for the noqueue discipline on noqueue init
so that __dev_queue_xmit() falls through for the noqueue case. This
also sets a bypass of the enqueue NULL check in the
register_qdisc() function for the struct noqueue_disc_ops.

Classful queue disciplines make it past the NULL check in
__dev_queue_xmit() because the discipline is set to htb (in this case),
and then in the call to __dev_xmit_skb(), it calls into htb_enqueue()
which grabs a leaf node for a class and then calls qdisc_enqueue() by
passing in a queue discipline which assumes ->enqueue() is not set to NULL.

Fix this by not allowing classes to be assigned to the noqueue
discipline. Linux TC Notes states that classes cannot be set to
the noqueue discipline. [1] Let's enforce that here.

Links:
1. https://linux-tc-notes.sourceforge.net/tc/doc/sch_noqueue.txt

Fixes: d66d6c3152e8 ("net: sched: register noqueue qdisc")
Cc: stable@vger.kernel.org
Signed-off-by: Frederick Lawler <fred@cloudflare.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/sched/sch_api.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 2317db02c764..72d2c204d5f3 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1133,6 +1133,11 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 			return -ENOENT;
 		}
 
+		if (new && new->ops == &noqueue_qdisc_ops) {
+			NL_SET_ERR_MSG(extack, "Cannot assign noqueue to a class");
+			return -EINVAL;
+		}
+
 		err = cops->graft(parent, cl, new, &old, extack);
 		if (err)
 			return err;
-- 
2.34.1

