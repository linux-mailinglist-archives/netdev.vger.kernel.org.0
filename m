Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F59513EDE8
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406971AbgAPSFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:05:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404977AbgAPRju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:39:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 338FD24708;
        Thu, 16 Jan 2020 17:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196390;
        bh=IZzp67DvSMYz/mYJtZFaQojq3mSE991PWm9I9K89Y64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHZrIiVAjcdnhuDRGnKhfftb+3oB1vozdxtkT28vry5bL+GPsPE5yKMOuWX9xVxek
         bc/08UEXHH1413gpDdCaIx1qiAoE2recKYoVVS5PdK2ETtOOnkl1cjetacu/s7nz3K
         bHKlWrPkgVv32Qh45mhVqGgB9+o1tAnSIUu53zqs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.9 170/251] qed: reduce maximum stack frame size
Date:   Thu, 16 Jan 2020 12:35:19 -0500
Message-Id: <20200116173641.22137-130-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7c116e02a4a7575c8c62bfd2106e3e3ec8fb99dc ]

clang warns about an overly large stack frame in one function
when it decides to inline all __qed_get_vport_*() functions into
__qed_get_vport_stats():

drivers/net/ethernet/qlogic/qed/qed_l2.c:1889:13: error: stack frame size of 1128 bytes in function '_qed_get_vport_stats' [-Werror,-Wframe-larger-than=]

Use a noinline_for_stack annotation to prevent clang from inlining
these, which keeps the maximum stack usage at around half of that
in the worst case, similar to what we get with gcc.

Fixes: 86622ee75312 ("qed: Move statistics to L2 code")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_l2.c | 34 +++++++++++-------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 715776e2cfe5..2d198f6ee21d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -1328,10 +1328,9 @@ static void __qed_get_vport_pstats_addrlen(struct qed_hwfn *p_hwfn,
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
@@ -1351,10 +1350,9 @@ static void __qed_get_vport_pstats(struct qed_hwfn *p_hwfn,
 	p_stats->tx_err_drop_pkts += HILO_64_REGPAIR(pstats.error_drop_pkts);
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
@@ -1397,10 +1395,9 @@ static void __qed_get_vport_ustats_addrlen(struct qed_hwfn *p_hwfn,
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
@@ -1436,10 +1433,9 @@ static void __qed_get_vport_mstats_addrlen(struct qed_hwfn *p_hwfn,
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
@@ -1463,9 +1459,9 @@ static void __qed_get_vport_mstats(struct qed_hwfn *p_hwfn,
 		HILO_64_REGPAIR(mstats.tpa_coalesced_bytes);
 }
 
-static void __qed_get_vport_port_stats(struct qed_hwfn *p_hwfn,
-				       struct qed_ptt *p_ptt,
-				       struct qed_eth_stats *p_stats)
+static noinline_for_stack void
+__qed_get_vport_port_stats(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+			   struct qed_eth_stats *p_stats)
 {
 	struct port_stats port_stats;
 	int j;
-- 
2.20.1

