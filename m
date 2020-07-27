Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB5C22E94D
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgG0Jla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0Jl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:41:29 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5960C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:29 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f7so2840720pln.13
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1l7SwA1i9uTZ/QL+qfTtJnApyxV6aBEs35CWeg3VLCk=;
        b=Yth4FHrXsXmm0PnUlLJrZ4dGQn07KgzanEhc1tCo4eYw8rtZRRo7M/GbquQgwR2aue
         Bt7xlBM1z07iqnU0aCYi9UE9LPYRGuX4PI7IAQdjB3TSH1iF6PD0XQQZVshPwmf/hFJt
         EaUdPJ3EG/McfsZyjtXx2W+Upx5JqM6yMcdjs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1l7SwA1i9uTZ/QL+qfTtJnApyxV6aBEs35CWeg3VLCk=;
        b=ZmdfTKO62Yop/ymWB79QditdlJRtLEjP2Tzsu12oqARrKCCc59lJhUiMHBHqI0a+oO
         Z1rZlVAqbg7FsCzpG1XMQCadq5ULg5RCWuxzrEypMAwgwF40dpI9edjXGoCyyxLvvmC3
         5oY7aNQwMcDDa4FtZM6unZjuwerPkphzeegoWimrlPCAZ4NQOW6/YC0795PtP3QXO+uu
         3e2kIwdE+kKQXF+QCC5/LGMJtfX6qphGMiuldrscx0ndq0mj8yuPqDKPTsRJemTXOaSP
         9dwOI9t7jpC3oV1kiCBcQRRdW4rOdLLZ9HhaFC6wOAQNweqbMAYsILaSUjo2ALUkxdCO
         QH4w==
X-Gm-Message-State: AOAM531gMEyof6w6Uhm7/Tw8tkogjLbDY0/aU+bZYBw6vblyw7HHGTPX
        9N+9aL7+dfe4oCXOa4MN83IQAQ==
X-Google-Smtp-Source: ABdhPJwYoX/r3XrWYEOAmH/+fGpUuir3dfMx12XQ2lCL9VLe74BsBPe8M5DQv/AoyrzPg+ibeFdo0g==
X-Received: by 2002:a17:902:d391:: with SMTP id e17mr17660019pld.219.1595842889060;
        Mon, 27 Jul 2020 02:41:29 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f131sm14560945pgc.14.2020.07.27.02.41.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2020 02:41:28 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 08/10] bnxt_en: Accumulate all counters.
Date:   Mon, 27 Jul 2020 05:40:43 -0400
Message-Id: <1595842845-19403-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
References: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have the infrastructure in place, add the new function
bnxt_accumulate_all_stats() to periodically accumulate and check for
counter rollover of all ring stats and port stats.

A chip bug was also discovered that could cause some ring counters to
become 0 during DMA.  Workaround by ignoring zeros on the affected
chips.

Some older frimware will reset port counters during ifdown.  We need
to check for that and free the accumulated port counters during ifdown
to prevent bogus counter overflow detection during ifup.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 91 ++++++++++++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b79d8e9..a8e86da 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4043,6 +4043,8 @@ static void bnxt_free_mem(struct bnxt *bp, bool irq_re_init)
 	bnxt_free_ntp_fltrs(bp, irq_re_init);
 	if (irq_re_init) {
 		bnxt_free_ring_stats(bp);
+		if (!(bp->fw_cap & BNXT_FW_CAP_PORT_STATS_NO_RESET))
+			bnxt_free_port_stats(bp);
 		bnxt_free_ring_grps(bp);
 		bnxt_free_vnics(bp);
 		kfree(bp->tx_ring_map);
@@ -7584,6 +7586,88 @@ int bnxt_hwrm_fw_set_time(struct bnxt *bp)
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
+static void bnxt_add_one_ctr(u64 hw, u64 *sw, u64 mask)
+{
+	u64 sw_tmp;
+
+	sw_tmp = (*sw & ~mask) | hw;
+	if (hw < (*sw & mask))
+		sw_tmp += mask + 1;
+	WRITE_ONCE(*sw, sw_tmp);
+}
+
+static void __bnxt_accumulate_stats(__le64 *hw_stats, u64 *sw_stats, u64 *masks,
+				    int count, bool ignore_zero)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		u64 hw = le64_to_cpu(READ_ONCE(hw_stats[i]));
+
+		if (ignore_zero && !hw)
+			continue;
+
+		if (masks[i] == -1ULL)
+			sw_stats[i] = hw;
+		else
+			bnxt_add_one_ctr(hw, &sw_stats[i], masks[i]);
+	}
+}
+
+static void bnxt_accumulate_stats(struct bnxt_stats_mem *stats)
+{
+	if (!stats->hw_stats)
+		return;
+
+	__bnxt_accumulate_stats(stats->hw_stats, stats->sw_stats,
+				stats->hw_masks, stats->len / 8, false);
+}
+
+static void bnxt_accumulate_all_stats(struct bnxt *bp)
+{
+	struct bnxt_stats_mem *ring0_stats;
+	bool ignore_zero = false;
+	int i;
+
+	/* Chip bug.  Counter intermittently becomes 0. */
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		ignore_zero = true;
+
+	for (i = 0; i < bp->cp_nr_rings; i++) {
+		struct bnxt_napi *bnapi = bp->bnapi[i];
+		struct bnxt_cp_ring_info *cpr;
+		struct bnxt_stats_mem *stats;
+
+		cpr = &bnapi->cp_ring;
+		stats = &cpr->stats;
+		if (!i)
+			ring0_stats = stats;
+		__bnxt_accumulate_stats(stats->hw_stats, stats->sw_stats,
+					ring0_stats->hw_masks,
+					ring0_stats->len / 8, ignore_zero);
+	}
+	if (bp->flags & BNXT_FLAG_PORT_STATS) {
+		struct bnxt_stats_mem *stats = &bp->port_stats;
+		__le64 *hw_stats = stats->hw_stats;
+		u64 *sw_stats = stats->sw_stats;
+		u64 *masks = stats->hw_masks;
+		int cnt;
+
+		cnt = sizeof(struct rx_port_stats) / 8;
+		__bnxt_accumulate_stats(hw_stats, sw_stats, masks, cnt, false);
+
+		hw_stats += BNXT_TX_PORT_STATS_BYTE_OFFSET / 8;
+		sw_stats += BNXT_TX_PORT_STATS_BYTE_OFFSET / 8;
+		masks += BNXT_TX_PORT_STATS_BYTE_OFFSET / 8;
+		cnt = sizeof(struct tx_port_stats) / 8;
+		__bnxt_accumulate_stats(hw_stats, sw_stats, masks, cnt, false);
+	}
+	if (bp->flags & BNXT_FLAG_PORT_STATS_EXT) {
+		bnxt_accumulate_stats(&bp->rx_port_stats_ext);
+		bnxt_accumulate_stats(&bp->tx_port_stats_ext);
+	}
+}
+
 static int bnxt_hwrm_port_qstats(struct bnxt *bp, u8 flags)
 {
 	struct bnxt_pf_info *pf = &bp->pf;
@@ -8702,6 +8786,9 @@ static int bnxt_hwrm_phy_qcaps(struct bnxt *bp)
 		if (BNXT_PF(bp))
 			bp->fw_cap |= BNXT_FW_CAP_SHARED_PORT_CFG;
 	}
+	if (resp->flags & PORT_PHY_QCAPS_RESP_FLAGS_CUMULATIVE_COUNTERS_ON_RESET)
+		bp->fw_cap |= BNXT_FW_CAP_PORT_STATS_NO_RESET;
+
 	if (resp->supported_speeds_auto_mode)
 		link_info->support_auto_speeds =
 			le16_to_cpu(resp->supported_speeds_auto_mode);
@@ -10272,8 +10359,7 @@ static void bnxt_timer(struct timer_list *t)
 	if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY)
 		bnxt_fw_health_check(bp);
 
-	if (bp->link_info.link_up && (bp->flags & BNXT_FLAG_PORT_STATS) &&
-	    bp->stats_coal_ticks) {
+	if (bp->link_info.link_up && bp->stats_coal_ticks) {
 		set_bit(BNXT_PERIODIC_STATS_SP_EVENT, &bp->sp_event);
 		bnxt_queue_sp_work(bp);
 	}
@@ -10561,6 +10647,7 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_PERIODIC_STATS_SP_EVENT, &bp->sp_event)) {
 		bnxt_hwrm_port_qstats(bp, 0);
 		bnxt_hwrm_port_qstats_ext(bp, 0);
+		bnxt_accumulate_all_stats(bp);
 	}
 
 	if (test_and_clear_bit(BNXT_LINK_CHNG_SP_EVENT, &bp->sp_event)) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 69672ec..44c7812 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1769,6 +1769,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_VLAN_RX_STRIP		0x01000000
 	#define BNXT_FW_CAP_VLAN_TX_INSERT		0x02000000
 	#define BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED	0x04000000
+	#define BNXT_FW_CAP_PORT_STATS_NO_RESET		0x10000000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
 	u32			hwrm_spec_code;
-- 
1.8.3.1

