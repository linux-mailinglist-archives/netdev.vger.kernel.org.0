Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968D3702F2
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 17:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfGVPBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 11:01:44 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:43805 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfGVPBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 11:01:44 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M7KKA-1hmHUx1cEe-007niL; Mon, 22 Jul 2019 17:01:35 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Yuval Mintz <Yuval.Mintz@qlogic.com>,
        Manish Chopra <manishc@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Denis Bolotin <denis.bolotin@cavium.com>,
        Rahul Verma <rverma@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH net-next] qed: reduce maximum stack frame size
Date:   Mon, 22 Jul 2019 17:01:23 +0200
Message-Id: <20190722150133.1157096-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:+XcsDpkp6TN1nsOc+u8JZ0NBGgkbBC5mUSpZhfCcYijsitfVK32
 cInYXMWZsdNXb7YVd3/rNUTpoAbMzdvYCkXTMlL7/xEKHXO3408xrDYg7hLMzgNvFbg/XAV
 llAN93TIde3KdxfRUlgvykuSO6j58RpVCAZrW3XPSz9NR9oyXGDFVUwJwiTxJcMgm1GjxlI
 pdr8jd0u3zZyUe3r5wK4g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:k7SCg1PLTRo=:c/bnJbYQG+S5jDADBRCfNO
 iws3ofk8kglStWjPh6jowKeNxOW7MZR9WBlL2S8ODWYOi5qdtmunGsbuuUzVdzdbdE9ggbU7f
 IH90bmn1ogpzegLCkZ8LK1LHI30lrs0NwokHd3SsuXOR3hA0uZ0SkC3LvJgR6cZkzjLljvy8v
 mJk/TROBgY7F+2KDoIsxt8TGoZBNMUSZ1F/PIuqrAHU4GR/tuN4u/g36JgOqO8nRlFFioE7m0
 H/SUlJJzVjCxNj7PZ4fuqZ3fS4EdIJJHKK1Nasp4XLVs3+Ey/ogxktD9cEkTQuE6a7EwZEeEx
 df2Z39whjJneDqAxtUcC2EfPDr/hHarhs1H1Q6X5ioPnRpZfkZsGO9ZsXEd8vIW4I7GpVuC4w
 31VV7KL7BDUZB98zUKjTg9grPefIK3FC5n+v3WRT7UVNEyNLH2bETUPaewnnUDFGKV+cFORbN
 eu0gTvZKGGt/lHO4IYHiI5CWCw7PCOFc0l7k22y+StDHcQqvGMM+pOlnY65M2kZUGl+vFhZYf
 buPHREiuNozQ/xhCOWuoVnzVHij1MQBiI4/uYJBnFUxr+GDeOwCdEH0IYH7FYg8tnQpsFEfn4
 o3Yit4XEMR1+54wXMPrIVpXFXoR7/aMA2XGcn9Lq/lpj3DAwBoykJSMqX2neF0ACAyQonHTQu
 oumLzyze9CF7R033IpTHk3R8bSVJizE4Dmcw98nAdlND0tZTBNjdtimr82dtksGRAPy3hNgzG
 mntup3wzRmE6KYQedLKTF57bZ+Mzh2HPgJ9IWQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang warns about an overly large stack frame in one function
when it decides to inline all __qed_get_vport_*() functions into
__qed_get_vport_stats():

drivers/net/ethernet/qlogic/qed/qed_l2.c:1889:13: error: stack frame size of 1128 bytes in function '_qed_get_vport_stats' [-Werror,-Wframe-larger-than=]

Use a noinline_for_stack annotation to prevent clang from inlining
these, which keeps the maximum stack usage at around half of that
in the worst case, similar to what we get with gcc.

Fixes: 86622ee75312 ("qed: Move statistics to L2 code")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/qlogic/qed/qed_l2.c | 34 +++++++++++-------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 9f36e7948222..1a5fc2ae351c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -1631,10 +1631,9 @@ static void __qed_get_vport_pstats_addrlen(struct qed_hwfn *p_hwfn,
 	}
 }
 
-static void __qed_get_vport_pstats(struct qed_hwfn *p_hwfn,
-				   struct qed_ptt *p_ptt,
-				   struct qed_eth_stats *p_stats,
-				   u16 statistics_bin)
+static noinline_for_stack void
+__qed_get_vport_pstats(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+		       struct qed_eth_stats *p_stats, u16 statistics_bin)
 {
 	struct eth_pstorm_per_queue_stat pstats;
 	u32 pstats_addr = 0, pstats_len = 0;
@@ -1661,10 +1660,9 @@ static void __qed_get_vport_pstats(struct qed_hwfn *p_hwfn,
 	    HILO_64_REGPAIR(pstats.error_drop_pkts);
 }
 
-static void __qed_get_vport_tstats(struct qed_hwfn *p_hwfn,
-				   struct qed_ptt *p_ptt,
-				   struct qed_eth_stats *p_stats,
-				   u16 statistics_bin)
+static noinline_for_stack void
+__qed_get_vport_tstats(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+		       struct qed_eth_stats *p_stats, u16 statistics_bin)
 {
 	struct tstorm_per_port_stat tstats;
 	u32 tstats_addr, tstats_len;
@@ -1709,10 +1707,9 @@ static void __qed_get_vport_ustats_addrlen(struct qed_hwfn *p_hwfn,
 	}
 }
 
-static void __qed_get_vport_ustats(struct qed_hwfn *p_hwfn,
-				   struct qed_ptt *p_ptt,
-				   struct qed_eth_stats *p_stats,
-				   u16 statistics_bin)
+static noinline_for_stack
+void __qed_get_vport_ustats(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+			    struct qed_eth_stats *p_stats, u16 statistics_bin)
 {
 	struct eth_ustorm_per_queue_stat ustats;
 	u32 ustats_addr = 0, ustats_len = 0;
@@ -1751,10 +1748,9 @@ static void __qed_get_vport_mstats_addrlen(struct qed_hwfn *p_hwfn,
 	}
 }
 
-static void __qed_get_vport_mstats(struct qed_hwfn *p_hwfn,
-				   struct qed_ptt *p_ptt,
-				   struct qed_eth_stats *p_stats,
-				   u16 statistics_bin)
+static noinline_for_stack void
+__qed_get_vport_mstats(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+		       struct qed_eth_stats *p_stats, u16 statistics_bin)
 {
 	struct eth_mstorm_per_queue_stat mstats;
 	u32 mstats_addr = 0, mstats_len = 0;
@@ -1780,9 +1776,9 @@ static void __qed_get_vport_mstats(struct qed_hwfn *p_hwfn,
 	    HILO_64_REGPAIR(mstats.tpa_coalesced_bytes);
 }
 
-static void __qed_get_vport_port_stats(struct qed_hwfn *p_hwfn,
-				       struct qed_ptt *p_ptt,
-				       struct qed_eth_stats *p_stats)
+static noinline_for_stack void
+__qed_get_vport_port_stats(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+			   struct qed_eth_stats *p_stats)
 {
 	struct qed_eth_stats_common *p_common = &p_stats->common;
 	struct port_stats port_stats;
-- 
2.20.0

