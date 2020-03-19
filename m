Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6176E18C2C6
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 23:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgCSWLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 18:11:52 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:34470 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCSWLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 18:11:50 -0400
Received: by mail-qv1-f67.google.com with SMTP id o18so1970124qvf.1
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 15:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pzfdJRx1oF6jiIvR2C9U9rEyO4S41Htu1IVIdua7ZaQ=;
        b=hzQ9Ozgc3eHqxFwistOuYhvE2qISqi2ldxN1oF5OZ+DuD8DfcdzWGvcgWGprkU23gj
         1UrAGG5mtmeu8Ny9Y37Kse9f8a4kCaBCz0aSoNkKdnYn3siLeFx6MLWELNnnuT8m1T9H
         PDJj+UvFUPet3RDP2CoyTlY3ZYUGpcvTeC61TfEbnIh2Pr5n8nI3L0GgHxDdbFjEDZUe
         6L/mb6aqKD/4IIAJYjdcc/8zO6J3TWS/51gmh7UKYsbEW8n69IZ6EuD6XRdsZqnXxXx5
         FpkAUkxjm3IpfzXpjj6LUJ20seDXd++BpAQga6H5Ma/swI7kxBSMCEbzGjwVD21aqi4o
         FEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pzfdJRx1oF6jiIvR2C9U9rEyO4S41Htu1IVIdua7ZaQ=;
        b=n50blUOBHz2Up/EJq5SKPDj3a2hj/LEd3q638n42KEL+10RO4TALWxARNVYps3akY6
         QHPt58WHdIw4X3ty+70cRMXVwfcghhI1cbpScWRoD745GOB+GglXCTF8CqyQT1WfDToi
         7W4SAYbob+eSnm9gL4piWuJJMsJU3zx4vSmQ+rmU8BY3QOnZqntsLsOkQuJEs4RNzhmQ
         i7IIW3aGvawaZiiOUnf51cJalBC7+nFqewIk6DPDu/AunslAGPaj6R79/+l4BlbzuWct
         2mThiq769DhaPqLKWwFLoWamGiaFQRxEa8py2nDE0d7OVUeLrEr/XM+2ti902aDl7TvE
         cLFg==
X-Gm-Message-State: ANhLgQ2pMQ/eWzFgd0p/zVdaW32ADn65OIIE9iTp1xqCRlADY80lr7U9
        PhblvSNOEc4BVFYE/3jHRH8/2A==
X-Google-Smtp-Source: ADFU+vtSKBdVdLUNbDulH29r3gYb5+UBaLtQ+hKG13rkQbY88mxT+6kICnVtmSCjJ3pRmBBejOm5fA==
X-Received: by 2002:a0c:db86:: with SMTP id m6mr5133668qvk.116.1584655908780;
        Thu, 19 Mar 2020 15:11:48 -0700 (PDT)
Received: from ovpn-66-200.rdu2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id m10sm2635693qte.71.2020.03.19.15.11.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Mar 2020 15:11:48 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     davem@davemloft.net
Cc:     alexander.h.duyck@linux.intel.com, kuznet@ms2.inr.ac.ru,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH] ipv4: fix a RCU-list bug in inet_dump_fib()
Date:   Thu, 19 Mar 2020 18:11:41 -0400
Message-Id: <20200319221141.8814-1-cai@lca.pw>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a place,

inet_dump_fib()
  fib_table_dump
    fn_trie_dump_leaf()
      hlist_for_each_entry_rcu()

without rcu_read_lock() triggers a warning,

 WARNING: suspicious RCU usage
 -----------------------------
 net/ipv4/fib_trie.c:2216 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by ip/1923:
  #0: ffffffff8ce76e40 (rtnl_mutex){+.+.}, at: netlink_dump+0xd6/0x840

 Call Trace:
  dump_stack+0xa1/0xea
  lockdep_rcu_suspicious+0x103/0x10d
  fn_trie_dump_leaf+0x581/0x590
  fib_table_dump+0x15f/0x220
  inet_dump_fib+0x4ad/0x5d0
  netlink_dump+0x350/0x840
  __netlink_dump_start+0x315/0x3e0
  rtnetlink_rcv_msg+0x4d1/0x720
  netlink_rcv_skb+0xf0/0x220
  rtnetlink_rcv+0x15/0x20
  netlink_unicast+0x306/0x460
  netlink_sendmsg+0x44b/0x770
  __sys_sendto+0x259/0x270
  __x64_sys_sendto+0x80/0xa0
  do_syscall_64+0x69/0xf4
  entry_SYSCALL_64_after_hwframe+0x49/0xb3

Signed-off-by: Qian Cai <cai@lca.pw>
---
 net/ipv4/fib_frontend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 577db1d50a24..5e441282d647 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -987,6 +987,8 @@ static int inet_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 	if (filter.flags & RTM_F_PREFIX)
 		return skb->len;
 
+	rcu_read_lock();
+
 	if (filter.table_id) {
 		tb = fib_get_table(net, filter.table_id);
 		if (!tb) {
@@ -1004,8 +1006,6 @@ static int inet_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 	s_h = cb->args[0];
 	s_e = cb->args[1];
 
-	rcu_read_lock();
-
 	for (h = s_h; h < FIB_TABLE_HASHSZ; h++, s_e = 0) {
 		e = 0;
 		head = &net->ipv4.fib_table_hash[h];
-- 
2.21.0 (Apple Git-122.2)

