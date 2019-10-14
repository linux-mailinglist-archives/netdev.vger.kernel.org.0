Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60976D6AD7
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 22:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731044AbfJNUhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 16:37:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:15986 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730700AbfJNUhu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 16:37:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 13:37:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="396587614"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.82])
  by fmsmga006.fm.intel.com with ESMTP; 14 Oct 2019 13:37:49 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        Ederson de Souza <ederson.desouza@intel.com>
Subject: [PATCH net v1] sched: etf: Fix ordering of packets with same txtime
Date:   Mon, 14 Oct 2019 13:38:22 -0700
Message-Id: <20191014203822.31741-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a application sends many packets with the same txtime, they may
be transmitted out of order (different from the order in which they
were enqueued).

This happens because when inserting elements into the tree, when the
txtime of two packets are the same, the new packet is inserted at the
left side of the tree, causing the reordering. The only effect of this
change should be that packets with the same txtime will be transmitted
in the order they are enqueued.

The application in question (the AVTP GStreamer plugin, still in
development) is sending video traffic, in which each video frame have
a single presentation time, the problem is that when packetizing,
multiple packets end up with the same txtime.

The receiving side was rejecting packets because they were being
received out of order.

Fixes: 25db26a91364 ("net/sched: Introduce the ETF Qdisc")
Reported-by: Ederson de Souza <ederson.desouza@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_etf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index cebfb65d8556..b1da5589a0c6 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -177,7 +177,7 @@ static int etf_enqueue_timesortedlist(struct sk_buff *nskb, struct Qdisc *sch,
 
 		parent = *p;
 		skb = rb_to_skb(parent);
-		if (ktime_after(txtime, skb->tstamp)) {
+		if (ktime_compare(txtime, skb->tstamp) >= 0) {
 			p = &parent->rb_right;
 			leftmost = false;
 		} else {
-- 
2.23.0

