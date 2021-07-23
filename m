Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2934D3D3CEE
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbhGWPON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:14:13 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57302 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbhGWPNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:13:53 -0400
Received: from localhost.localdomain (unknown [78.30.39.111])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8CCF2642A3;
        Fri, 23 Jul 2021 17:53:56 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/6] netfilter: conntrack: adjust stop timestamp to real expiry value
Date:   Fri, 23 Jul 2021 17:54:10 +0200
Message-Id: <20210723155412.17916-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210723155412.17916-1-pablo@netfilter.org>
References: <20210723155412.17916-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

In case the entry is evicted via garbage collection there is
delay between the timeout value and the eviction event.

This adjusts the stop value based on how much time has passed.

Fixes: b87a2f9199ea82 ("netfilter: conntrack: add gc worker to remove timed-out entries")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 83c52df85870..5c03e5106751 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -670,8 +670,13 @@ bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
 		return false;
 
 	tstamp = nf_conn_tstamp_find(ct);
-	if (tstamp && tstamp->stop == 0)
+	if (tstamp) {
+		s32 timeout = ct->timeout - nfct_time_stamp;
+
 		tstamp->stop = ktime_get_real_ns();
+		if (timeout < 0)
+			tstamp->stop -= jiffies_to_nsecs(-timeout);
+	}
 
 	if (nf_conntrack_event_report(IPCT_DESTROY, ct,
 				    portid, report) < 0) {
-- 
2.20.1

