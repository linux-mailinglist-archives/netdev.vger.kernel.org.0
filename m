Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7097E24544C
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgHOWTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:19:17 -0400
Received: from correo.us.es ([193.147.175.20]:38942 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728861AbgHOWSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 18:18:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 32D57DA55D
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:32:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23DE9DA844
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:32:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 18543DA73D; Sat, 15 Aug 2020 12:32:27 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD5ADDA72F;
        Sat, 15 Aug 2020 12:32:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 15 Aug 2020 12:32:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [213.143.48.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id F419142EF4E0;
        Sat, 15 Aug 2020 12:32:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 8/8] netfilter: ebtables: reject bogus getopt len value
Date:   Sat, 15 Aug 2020 12:32:01 +0200
Message-Id: <20200815103201.1768-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200815103201.1768-1-pablo@netfilter.org>
References: <20200815103201.1768-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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

Fixes: fc66de8e16ec ("netfilter/ebtables: clean up compat {get, set}sockopt handling")
Reported-by: syzbot+5accb5c62faa1d346480@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.20.1

