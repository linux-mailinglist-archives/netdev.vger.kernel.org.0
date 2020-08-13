Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3314924352C
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 09:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHMHqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 03:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgHMHqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 03:46:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DEDC061757;
        Thu, 13 Aug 2020 00:46:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k67wL-0000Sg-8E; Thu, 13 Aug 2020 09:46:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     hch@lst.de, syzkaller-bugs@googlegroups.com,
        <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        syzbot+5accb5c62faa1d346480@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter/ebtables: reject bogus getopt len value
Date:   Thu, 13 Aug 2020 09:46:11 +0200
Message-Id: <20200813074611.281558-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <000000000000ece9db05ac4054e8@google.com>
References: <000000000000ece9db05ac4054e8@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller reports splat:
------------[ cut here ]------------
Buffer overflow detected (80 < 137)!
Call Trace:
 do_ebt_get_ctl+0x2b4/0x790 net/bridge/netfilter/ebtables.c:2317
 nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
 ip_getsockopt net/ipv4/ip_sockglue.c:1778 [inline]

caused by a copy-to-user with a too-large "*len" value.
This adds a argument check on *len just like in the non-compat version
of the handler.

Before the "Fixes" commit, the reproducer fails with -EINVAL as
expected:
1. core calls the "compat" getsockopt version
2. compat getsockopt version detects the *len value is possibly
   in 64-bit layout (*len != compat_len)
3. compat getsockopt version delegates everything to native getsockopt
   version
4. native getsockopt rejects invalid *len

-> compat handler only sees len == sizeof(compat_struct) for GET_ENTRIES.

After the refactor, event sequence is:
1. getsockopt calls "compat" version (len != native_len)
2. compat version attempts to copy *len bytes, where *len is random
   value from userspace

Fixes: fc66de8e16e ("netfilter/ebtables: clean up compat {get, set}sockopt handling")
Reported-by: syzbot+5accb5c62faa1d346480@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebtables.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 1641f414d1ba..ebe33b60efd6 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2238,6 +2238,10 @@ static int compat_do_ebt_get_ctl(struct sock *sk, int cmd,
 	struct ebt_table *t;
 	struct net *net = sock_net(sk);
 
+	if ((cmd == EBT_SO_GET_INFO || cmd == EBT_SO_GET_INIT_INFO) &&
+	    *len != sizeof(struct compat_ebt_replace))
+		return -EINVAL;
+
 	if (copy_from_user(&tmp, user, sizeof(tmp)))
 		return -EFAULT;
 
-- 
2.26.2

