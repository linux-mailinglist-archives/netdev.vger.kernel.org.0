Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79183BFCB2
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 03:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfI0BYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 21:24:48 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:37170 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfI0BYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 21:24:48 -0400
Received: by mail-vk1-f202.google.com with SMTP id f63so1852173vkf.4
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 18:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=G/225dPrUfgAMJlfNuypViifVTmiFCFATURmIq5FCWk=;
        b=oBljFQ0RO4QSw8VdNAzYA7lzTkqBfXeqdjafmTP+svvSIQgewEF4bSTWike2912d+q
         R+NhQHmkNuaLBoeDHrdwIZvW2+mZstlV8wFw6sRA1kR484jGpxk9O1ZB45XIQ8M0t71J
         m5PWX7Y2vdkmwP+YtSo5diOdSotOITaMBxwrJSL/LKzQugRvxar1SsjpWYQztW0CLKiw
         AOwqp99OYJHXsf+XRBpqfBA8ASoGDgqP0Gi8LVmkTAzCdZ25qYAXGMArdzYErhsIqj+0
         KfHDDLeyl8LUTcclzSPWx357w79rsVlP+GkOM8zIGKvCK2OK/U7Y0f1BUIJpwAtD7Ygq
         +MJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=G/225dPrUfgAMJlfNuypViifVTmiFCFATURmIq5FCWk=;
        b=iDd9IahbMnjjtqm+MjXUTwSVkE2MinaPQKQkJXsJmCKWfW3GYNJ3m70p5VQaHkdHrq
         7vhvjbR6oFxNoLrIBEGg+5FnFV9pWGYe2nrHAljshqvp7QiLvM4l5alPyNH20WU9F1ID
         Mkaah7tg/ujurIecFIx92Geg7cybs963AShr4VYvZh9exX2lBVL+55rd1Zz2rITp9DLI
         t9IIMHRUEjh79EVjz3udFO3yJ8j2+D1owpQwWbCYl6srsNYmuNe3zWT59v0h8DzoPiwS
         bEbnZ8AhujQY/0Vqe8daZzZnoELXJP2yndQp4qlkU1Q26e0vfK4StEfCaEz66emwYij1
         IVPw==
X-Gm-Message-State: APjAAAVyAV50b0+KHwfJCUCxFB2VVu8j1E68vphXoE7E06d10z2egwxx
        4JPifYloKhZKsNhmCPP2BqrG+8EUAo0djA==
X-Google-Smtp-Source: APXvYqxC4/3Mik0XHNaLpJn+S2QqHcQyqFZbllIFhJAW8WGXgPFWFS1UmVOUpOkXTorFxS2g7BP9NSYRIoT3RQ==
X-Received: by 2002:a67:cfc3:: with SMTP id h3mr1077519vsm.25.1569547486767;
 Thu, 26 Sep 2019 18:24:46 -0700 (PDT)
Date:   Thu, 26 Sep 2019 18:24:43 -0700
Message-Id: <20190927012443.129446-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH net] sch_cbq: validate TCA_CBQ_WRROPT to avoid crash
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a crash in cbq_normalize_quanta() caused
by an out of range cl->priority.

iproute2 enforces this check, but malicious users do not.

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN PTI
Modules linked in:
CPU: 1 PID: 26447 Comm: syz-executor.1 Not tainted 5.3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:cbq_normalize_quanta.part.0+0x1fd/0x430 net/sched/sch_cbq.c:902
RSP: 0018:ffff8801a5c333b0 EFLAGS: 00010206
RAX: 0000000020000003 RBX: 00000000fffffff8 RCX: ffffc9000712f000
RDX: 00000000000043bf RSI: ffffffff83be8962 RDI: 0000000100000018
RBP: ffff8801a5c33420 R08: 000000000000003a R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000002ef
R13: ffff88018da95188 R14: dffffc0000000000 R15: 0000000000000015
FS:  00007f37d26b1700(0000) GS:ffff8801dad00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004c7cec CR3: 00000001bcd0a006 CR4: 00000000001626f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 [<ffffffff83be9d57>] cbq_normalize_quanta include/net/pkt_sched.h:27 [inline]
 [<ffffffff83be9d57>] cbq_addprio net/sched/sch_cbq.c:1097 [inline]
 [<ffffffff83be9d57>] cbq_set_wrr+0x2d7/0x450 net/sched/sch_cbq.c:1115
 [<ffffffff83bee8a7>] cbq_change_class+0x987/0x225b net/sched/sch_cbq.c:1537
 [<ffffffff83b96985>] tc_ctl_tclass+0x555/0xcd0 net/sched/sch_api.c:2329
 [<ffffffff83a84655>] rtnetlink_rcv_msg+0x485/0xc10 net/core/rtnetlink.c:5248
 [<ffffffff83cadf0a>] netlink_rcv_skb+0x17a/0x460 net/netlink/af_netlink.c:2510
 [<ffffffff83a7db6d>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5266
 [<ffffffff83cac2c6>] netlink_unicast_kernel net/netlink/af_netlink.c:1324 [inline]
 [<ffffffff83cac2c6>] netlink_unicast+0x536/0x720 net/netlink/af_netlink.c:1350
 [<ffffffff83cacd4a>] netlink_sendmsg+0x89a/0xd50 net/netlink/af_netlink.c:1939
 [<ffffffff8399d46e>] sock_sendmsg_nosec net/socket.c:673 [inline]
 [<ffffffff8399d46e>] sock_sendmsg+0x12e/0x170 net/socket.c:684
 [<ffffffff8399f1fd>] ___sys_sendmsg+0x81d/0x960 net/socket.c:2359
 [<ffffffff839a2d05>] __sys_sendmsg+0x105/0x1d0 net/socket.c:2397
 [<ffffffff839a2df9>] SYSC_sendmsg net/socket.c:2406 [inline]
 [<ffffffff839a2df9>] SyS_sendmsg+0x29/0x30 net/socket.c:2404
 [<ffffffff8101ccc8>] do_syscall_64+0x528/0x770 arch/x86/entry/common.c:305
 [<ffffffff84400091>] entry_SYSCALL_64_after_hwframe+0x42/0xb7

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/sch_cbq.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 06c7a2da21bc20e8f7e6ad02da0b0b3e3d933928..39b427dc751282db7adb2d0803eecccb0457c316 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1127,6 +1127,33 @@ static const struct nla_policy cbq_policy[TCA_CBQ_MAX + 1] = {
 	[TCA_CBQ_POLICE]	= { .len = sizeof(struct tc_cbq_police) },
 };
 
+static int cbq_opt_parse(struct nlattr *tb[TCA_CBQ_MAX + 1],
+			 struct nlattr *opt,
+			 struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (!opt) {
+		NL_SET_ERR_MSG(extack, "CBQ options are required for this operation");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested_deprecated(tb, TCA_CBQ_MAX, opt,
+					  cbq_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (tb[TCA_CBQ_WRROPT]) {
+		const struct tc_cbq_wrropt *wrr = nla_data(tb[TCA_CBQ_WRROPT]);
+
+		if (wrr->priority > TC_CBQ_MAXPRIO) {
+			NL_SET_ERR_MSG(extack, "priority is bigger than TC_CBQ_MAXPRIO");
+			err = -EINVAL;
+		}
+	}
+	return err;
+}
+
 static int cbq_init(struct Qdisc *sch, struct nlattr *opt,
 		    struct netlink_ext_ack *extack)
 {
@@ -1139,13 +1166,7 @@ static int cbq_init(struct Qdisc *sch, struct nlattr *opt,
 	hrtimer_init(&q->delay_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
 	q->delay_timer.function = cbq_undelay;
 
-	if (!opt) {
-		NL_SET_ERR_MSG(extack, "CBQ options are required for this operation");
-		return -EINVAL;
-	}
-
-	err = nla_parse_nested_deprecated(tb, TCA_CBQ_MAX, opt, cbq_policy,
-					  extack);
+	err = cbq_opt_parse(tb, opt, extack);
 	if (err < 0)
 		return err;
 
@@ -1464,13 +1485,7 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32 parentid, struct nlattr **t
 	struct cbq_class *parent;
 	struct qdisc_rate_table *rtab = NULL;
 
-	if (!opt) {
-		NL_SET_ERR_MSG(extack, "Mandatory qdisc options missing");
-		return -EINVAL;
-	}
-
-	err = nla_parse_nested_deprecated(tb, TCA_CBQ_MAX, opt, cbq_policy,
-					  extack);
+	err = cbq_opt_parse(tb, opt, extack);
 	if (err < 0)
 		return err;
 
-- 
2.23.0.444.g18eeb5a265-goog

