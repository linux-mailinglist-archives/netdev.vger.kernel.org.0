Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAC122E478
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 05:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgG0Daj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 23:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgG0Dai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 23:30:38 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00564C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:37 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s189so8584853pgc.13
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1l7SwA1i9uTZ/QL+qfTtJnApyxV6aBEs35CWeg3VLCk=;
        b=ZXEPcgMnN9aBnnHdWEyhnAuIkhbDGyvVQPTFD4YpL3cmIh8vLBVQw23692doBV9uSS
         h/mNBSy+kZ2GDqYUDGXZaVzOOx/y3Dat9pJZI5/W1VB7gtin7SK8ibFozUCJL2PThLmT
         Pi8ywouIvKC6Ozvw7YlOjQ6nNuNrOe321NlOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1l7SwA1i9uTZ/QL+qfTtJnApyxV6aBEs35CWeg3VLCk=;
        b=rXTrqPKdbBvVgefKUfzvrbLIv7Ay8k/drl0iuaLQFD8c9wPt8XSVwM2XDDp7kcQWaA
         4GO2WwUWydC4qpGJGJzFSgMunbAr5+rxVo/K5EjxzQvgakQCvYs7upZezzzKEgU/ek7u
         G55utP3/i5tzD4tOobin0lmNn3B7mxED8mbcWsx9+GJQu3aIK3BQVZ9ORsy76qnRD33h
         quEbSK50H5apgnBOMltRUHb/2Syx7rs68ceN3SPM5H28sLLUyUKLeRfPCHB3HEsXWw4V
         quZZTlFGUDbTTrbC9VWjjER0DPjM+0SsiciH/UGlmVnBzEEKUooCtlatvG7d0IPdi+ns
         O1hg==
X-Gm-Message-State: AOAM531pcwACOGutyRtD/m0DFcqc+VVWOfF9ONZWHVRlARz21TjO2E49
        Ujm5VMQJPmsBP87AKRUvNtc//uI+xcM=
X-Google-Smtp-Source: ABdhPJyHKHC53gAeVfOOwnSt1G3HUgFteOPSd2ZGQ/ITS9PaKPtI3jqleo9DJn307lhE64os2iaF5Q==
X-Received: by 2002:a62:35c3:: with SMTP id c186mr11705123pfa.1.1595820637359;
        Sun, 26 Jul 2020 20:30:37 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n25sm13504506pff.51.2020.07.26.20.30.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2020 20:30:36 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 08/10] bnxt_en: Accumulate all counters.
Date:   Sun, 26 Jul 2020 23:29:44 -0400
Message-Id: <1595820586-2203-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
References: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
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

