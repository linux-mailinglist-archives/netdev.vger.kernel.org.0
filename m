Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C056848F38
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfFQTbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:31:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:50086 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfFQTbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:31:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 12:31:23 -0700
X-ExtLoop1: 1
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga007.jf.intel.com with ESMTP; 17 Jun 2019 12:31:23 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH net-next v3 2/6] etf: Add skip_sock_check
Date:   Mon, 17 Jun 2019 12:31:06 -0700
Message-Id: <1560799870-18956-3-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1560799870-18956-1-git-send-email-vedang.patel@intel.com>
References: <1560799870-18956-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, etf expects a socket with SO_TXTIME option set for each packet
it encounters. So, it will drop all other packets. But, in the future
commits we are planning to add functionality which where tstamp value will
be set by another qdisc. Also, some packets which are generated from within
the kernel (e.g. ICMP packets) do not have any socket associated with them.

So, this commit adds support for skip_sock_check. When this option is set,
etf will skip checking for a socket and other associated options for all
skbs.

Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 include/uapi/linux/pkt_sched.h |  1 +
 net/sched/sch_etf.c            | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 8b2f993cbb77..69fc52e4d6bd 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -990,6 +990,7 @@ struct tc_etf_qopt {
 	__u32 flags;
 #define TC_ETF_DEADLINE_MODE_ON	BIT(0)
 #define TC_ETF_OFFLOAD_ON	BIT(1)
+#define TC_ETF_SKIP_SOCK_CHECK  BIT(2)
 };
 
 enum {
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index db0c2ba1d156..cebfb65d8556 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -22,10 +22,12 @@
 
 #define DEADLINE_MODE_IS_ON(x) ((x)->flags & TC_ETF_DEADLINE_MODE_ON)
 #define OFFLOAD_IS_ON(x) ((x)->flags & TC_ETF_OFFLOAD_ON)
+#define SKIP_SOCK_CHECK_IS_SET(x) ((x)->flags & TC_ETF_SKIP_SOCK_CHECK)
 
 struct etf_sched_data {
 	bool offload;
 	bool deadline_mode;
+	bool skip_sock_check;
 	int clockid;
 	int queue;
 	s32 delta; /* in ns */
@@ -77,6 +79,9 @@ static bool is_packet_valid(struct Qdisc *sch, struct sk_buff *nskb)
 	struct sock *sk = nskb->sk;
 	ktime_t now;
 
+	if (q->skip_sock_check)
+		goto skip;
+
 	if (!sk)
 		return false;
 
@@ -92,6 +97,7 @@ static bool is_packet_valid(struct Qdisc *sch, struct sk_buff *nskb)
 	if (sk->sk_txtime_deadline_mode != q->deadline_mode)
 		return false;
 
+skip:
 	now = q->get_time();
 	if (ktime_before(txtime, now) || ktime_before(txtime, q->last))
 		return false;
@@ -385,6 +391,7 @@ static int etf_init(struct Qdisc *sch, struct nlattr *opt,
 	q->clockid = qopt->clockid;
 	q->offload = OFFLOAD_IS_ON(qopt);
 	q->deadline_mode = DEADLINE_MODE_IS_ON(qopt);
+	q->skip_sock_check = SKIP_SOCK_CHECK_IS_SET(qopt);
 
 	switch (q->clockid) {
 	case CLOCK_REALTIME:
@@ -473,6 +480,9 @@ static int etf_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (q->deadline_mode)
 		opt.flags |= TC_ETF_DEADLINE_MODE_ON;
 
+	if (q->skip_sock_check)
+		opt.flags |= TC_ETF_SKIP_SOCK_CHECK;
+
 	if (nla_put(skb, TCA_ETF_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
 
-- 
2.7.3

