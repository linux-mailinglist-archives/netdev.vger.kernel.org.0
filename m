Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0186405674
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359739AbhIINTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358504AbhIINLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7441961506;
        Thu,  9 Sep 2021 12:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188883;
        bh=J6b5laIYzgvwjPghl7bOg/QG7dQIDmTLFo6W8I6TZSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuFxmShLE2nKfE4SoOCKbVv8P+00e+G8ivKsqaKzVXPvfNGIcu54VW4cTlWuLu50F
         KJ9KLIMkI/BEl+KLx3kNQrPMeGpn5ERBlzGZAQo19afjVqGxwLqVe0u90cIF31ZHDv
         2YdnHG5L0wx3jQEHQxhdVVK97s7BVbnKG95QhcwjcdFXoVH9i7XBUMgwKKGezZt4Ma
         /8RjN8w7EhQ+HKN4cKo2uH2ZmBipCOJd/19xyBC8Wwo2W8kIUFtdmFPniJZqp/8HRI
         UEOIkZSV6fo+A8NwAP2S0wHUbxi2qdY8mxWgQ27N5eonN0qnouuukySg9VFrvLJp6/
         EsWB+/aGDJKEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yajun Deng <yajun.deng@linux.dev>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 05/35] netlink: Deal with ESRCH error in nlmsg_notify()
Date:   Thu,  9 Sep 2021 08:00:46 -0400
Message-Id: <20210909120116.150912-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120116.150912-1-sashal@kernel.org>
References: <20210909120116.150912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit fef773fc8110d8124c73a5e6610f89e52814637d ]

Yonghong Song report:
The bpf selftest tc_bpf failed with latest bpf-next.
The following is the command to run and the result:
$ ./test_progs -n 132
[   40.947571] bpf_testmod: loading out-of-tree module taints kernel.
test_tc_bpf:PASS:test_tc_bpf__open_and_load 0 nsec
test_tc_bpf:PASS:bpf_tc_hook_create(BPF_TC_INGRESS) 0 nsec
test_tc_bpf:PASS:bpf_tc_hook_create invalid hook.attach_point 0 nsec
test_tc_bpf_basic:PASS:bpf_obj_get_info_by_fd 0 nsec
test_tc_bpf_basic:PASS:bpf_tc_attach 0 nsec
test_tc_bpf_basic:PASS:handle set 0 nsec
test_tc_bpf_basic:PASS:priority set 0 nsec
test_tc_bpf_basic:PASS:prog_id set 0 nsec
test_tc_bpf_basic:PASS:bpf_tc_attach replace mode 0 nsec
test_tc_bpf_basic:PASS:bpf_tc_query 0 nsec
test_tc_bpf_basic:PASS:handle set 0 nsec
test_tc_bpf_basic:PASS:priority set 0 nsec
test_tc_bpf_basic:PASS:prog_id set 0 nsec
libbpf: Kernel error message: Failed to send filter delete notification
test_tc_bpf_basic:FAIL:bpf_tc_detach unexpected error: -3 (errno 3)
test_tc_bpf:FAIL:test_tc_internal ingress unexpected error: -3 (errno 3)

The failure seems due to the commit
    cfdf0d9ae75b ("rtnetlink: use nlmsg_notify() in rtnetlink_send()")

Deal with ESRCH error in nlmsg_notify() even the report variable is zero.

Reported-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Link: https://lore.kernel.org/r/20210719051816.11762-1-yajun.deng@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c20c41801845..260cba93a2cf 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2405,13 +2405,15 @@ int nlmsg_notify(struct sock *sk, struct sk_buff *skb, u32 portid,
 		/* errors reported via destination sk->sk_err, but propagate
 		 * delivery errors if NETLINK_BROADCAST_ERROR flag is set */
 		err = nlmsg_multicast(sk, skb, exclude_portid, group, flags);
+		if (err == -ESRCH)
+			err = 0;
 	}
 
 	if (report) {
 		int err2;
 
 		err2 = nlmsg_unicast(sk, skb, portid);
-		if (!err || err == -ESRCH)
+		if (!err)
 			err = err2;
 	}
 
-- 
2.30.2

