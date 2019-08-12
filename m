Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D568A7D3
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 22:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfHLUFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 16:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727429AbfHLUFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 16:05:07 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD87C20842;
        Mon, 12 Aug 2019 20:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565640306;
        bh=eyLaSFVCxVoW8U0Xb7urrTyIoBIp2Zh94kJ73Jl00EA=;
        h=From:To:Cc:Subject:Date:From;
        b=oeCqYQ1GmMEw9lrNxxRVq2d48wbunMreixLbyfnIgE/sq9ZtDN+4lkJK6wfPwXIpQ
         UtwRrGU+w0DsAIdCUqmtqzKgiaVMNiOOdsffiY3GR3CZ6Nn4EZVB1phYG8DyvsoJAe
         tukIH3nJ/1GJkLSTVXDLyiXo0Jr0PnYyaeXYb4LM=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com,
        edumazet@google.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] netlink: Fix nlmsg_parse as a wrapper for strict message parsing
Date:   Mon, 12 Aug 2019 13:07:07 -0700
Message-Id: <20190812200707.25587-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Eric reported a syzbot warning:

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

The root cause is nlmsg_parse calling __nla_parse which means the
header struct size is not checked.

nlmsg_parse should be a wrapper around __nlmsg_parse with
NL_VALIDATE_STRICT for the validate argument very much like
nlmsg_parse_deprecated is for NL_VALIDATE_LIBERAL.

Fixes: 3de6440354465 ("netlink: re-add parse/validate functions in strict mode")
Reported-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/netlink.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index e4650e5b64a1..b140c8f1be22 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -684,9 +684,8 @@ static inline int nlmsg_parse(const struct nlmsghdr *nlh, int hdrlen,
 			      const struct nla_policy *policy,
 			      struct netlink_ext_ack *extack)
 {
-	return __nla_parse(tb, maxtype, nlmsg_attrdata(nlh, hdrlen),
-			   nlmsg_attrlen(nlh, hdrlen), policy,
-			   NL_VALIDATE_STRICT, extack);
+	return __nlmsg_parse(nlh, hdrlen, tb, maxtype, policy,
+			     NL_VALIDATE_STRICT, extack);
 }
 
 /**
-- 
2.11.0

