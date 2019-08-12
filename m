Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A9289D36
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbfHLLgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:36:21 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:47447 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbfHLLgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:36:20 -0400
Received: by mail-pf1-f201.google.com with SMTP id q12so6099181pfl.14
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 04:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dSATQ80Fzo36m5+MgjcLgrfpCX8doHYZ70664kHYZGw=;
        b=FWc2rabivejtO+K4ZPgfqR+A9xlcA4GwqhRn6dceo7y4txWREwP7vYGQetb55i86N0
         sSvjUr9Zqv6etQ1FufXgP35O6TzrpIBmQjwv+Vu+JYs40LpPrKcH+eGWIG52A1E7/TtO
         4MjwQaR5uUmCffQZQ12EQc6J3+OPDDnAcgKFLeZQuYMaAy+SNrp4vaLM3wyt47ats4UA
         APfjzTdYU2UWMEyfwfUrUZ2s7eBFLS/sUf9MJoKTBvJ2jrGsDqOwKTLezPGh8JKw4wBa
         LX+HafgelnfDy8FeoQsU+L5+QYEREl+7l2Iro6QLD78ZSQWVBlXrZXR5v99XMG6PgcDs
         Om+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=dSATQ80Fzo36m5+MgjcLgrfpCX8doHYZ70664kHYZGw=;
        b=U4UrZYazmHq6Zz8f4xzJPbOsLDcL9Evwhsc0/g8BujkZ5MhYMvtu5XVdfSpRyJNV1u
         ytC8PiQ8kNBPx+b1AHKMquXLLfF2ofE0puhW5lkzE8ts7A+TlJJU/1px+yQ1gT1KiPcd
         d5r2MbyNCWnT85LYAN0Q/9ypzKFN2Xv16CPpKIQJ3HGdGVDD7+/LHEtdJQIne3XcURn0
         snB8zPCCFwlzl4Om/RlJ3lTWYYMNPIVWxYISBTDycl9xBHrdwQHmC0x6ABn++WNTkITO
         DlgSTJMPJif0DfT7iVvUPoqpECkXueQxjZFnM//UXpcEegQqmYSurXsMtlr+jTvTDD6O
         A/iA==
X-Gm-Message-State: APjAAAXjb2U+cyvu+fhxqH56maxVxk04/InfxVg2BeYerlmmW2vTjXXb
        5tRpZrwfYJm85lE7oNfOFTUjn3Vir3TohQ==
X-Google-Smtp-Source: APXvYqyv355EKM/DuegaOD13GqqIIEBImOlm/JmueFvh2TYjzeLfMaM/l20zXRNrC2wFyHNReiNeRGhDRoza7A==
X-Received: by 2002:a63:ec48:: with SMTP id r8mr28580707pgj.387.1565609779701;
 Mon, 12 Aug 2019 04:36:19 -0700 (PDT)
Date:   Mon, 12 Aug 2019 04:36:16 -0700
Message-Id: <20190812113616.51725-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH net] nexthop: use nlmsg_parse_deprecated()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David missed that commit 8cb081746c03 ("netlink: make validation
more configurable for future strictness") has renamed nlmsg_parse()

syzbot reported :
BUG: KMSAN: uninit-value in nh_valid_get_del_req+0x6f1/0x8c0 net/ipv4/nexthop.c:1510
CPU: 0 PID: 11812 Comm: syz-executor444 Not tainted 5.3.0-rc3+ #17
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x191/0x1f0 lib/dump_stack.c:113
 kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
 __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
 nh_valid_get_del_req+0x6f1/0x8c0 net/ipv4/nexthop.c:1510
 rtm_del_nexthop+0x1b1/0x610 net/ipv4/nexthop.c:1543
 rtnetlink_rcv_msg+0x115a/0x1580 net/core/rtnetlink.c:5223
 netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5241
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0xf6c/0x1050 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x110f/0x1330 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg net/socket.c:657 [inline]
 ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
 __sys_sendmmsg+0x53a/0xae0 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2439
 __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2439
 do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x63/0xe7

Fixes: ab84be7e54fc ("net: Initial nexthop code")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: David Ahern <dsahern@gmail.com>
---
 net/ipv4/nexthop.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5fe5a3981d4316ad8d9dbf54f5d9017b89e24038..2672e1a7b544253f2d1d0aaffd2bab9db5d76b9f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1304,8 +1304,8 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 	struct nlattr *tb[NHA_MAX + 1];
 	int err;
 
-	err = nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*nhm), tb, NHA_MAX,
+				     rtm_nh_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -1488,8 +1488,8 @@ static int nh_valid_get_del_req(struct nlmsghdr *nlh, u32 *id,
 	struct nlattr *tb[NHA_MAX + 1];
 	int err, i;
 
-	err = nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*nhm), tb, NHA_MAX,
+				     rtm_nh_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -1639,8 +1639,8 @@ static int nh_valid_dump_req(const struct nlmsghdr *nlh, int *dev_idx,
 	int err, i;
 	u32 idx;
 
-	err = nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
-			  NULL);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*nhm), tb, NHA_MAX,
+				     rtm_nh_policy, NULL);
 	if (err < 0)
 		return err;
 
-- 
2.23.0.rc1.153.gdeed80330f-goog

