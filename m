Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0438C22E94B
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgG0JlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0JlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:41:24 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDC4C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:23 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k18so1553677pfp.7
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WFWasp0Hp2d+HXAiFF5Euo9fzBUskqGy/gVdc7jSOD4=;
        b=IGO8M4Ynw4dXhMX7XJ9L/W1Eqz9tMhzcuOLWvk89+NQtcRNV5hunzxetDCtZBjGfes
         6kKLX85r8l+cd++5m6P/y8jZ5ErmSsagmHoBpfWz/GlbAyuDGCPa+vDEdjI/BjJkt9R4
         xpt8puK3BIDWDia8xILd6G1E3w1O/Oca4EiXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WFWasp0Hp2d+HXAiFF5Euo9fzBUskqGy/gVdc7jSOD4=;
        b=MH8YBynfNadFZT+qCuaP7945klmim2g1kqA9J7ntSklxjMlNiphAtnxJ+xdauPdagU
         Nwl6vYFhu/W0Hk6O2KTNhiJ7JNP8Nj//dST3bJ/aO2uk30rAaTds7PD+ruMjPMLxq6NG
         OkPpYJqqZXi4upRG//JiiUGaerDsCkgU2baxx0oUZSat2DdbjSrJvsfKWNClvyv53rJJ
         3xl2PoUomc7jFpR53OgA1IZi+gGDa71fh/ckJyEZFzZpM2XkAv0rjEA06k0d7TsihXHl
         N0pyJoI1f1yVCY4hI3SVtEdZR/mWCaTSBHlUOdQE+j6+yaRsFPlP/mQZioLOSoffpJlQ
         EMZg==
X-Gm-Message-State: AOAM5315cd/kA6nKjq2Mtpd516hsGnRl6Gm9b8vu9NA66ycpQr5BMksw
        oq9Kb6qTqw5xS6g8gfRSNm0ZhQ==
X-Google-Smtp-Source: ABdhPJxaXn2mc8wMHZ0TZBSpz5zpolp6lmvpR34MWr4g8nrIiWqYzeWkqmF8fbPeHx3EStwK3kD9uQ==
X-Received: by 2002:a62:1951:: with SMTP id 78mr4459384pfz.137.1595842883373;
        Mon, 27 Jul 2020 02:41:23 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f131sm14560945pgc.14.2020.07.27.02.41.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2020 02:41:22 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 06/10] bnxt_en: Retrieve hardware counter masks from firmware if available.
Date:   Mon, 27 Jul 2020 05:40:41 -0400
Message-Id: <1595842845-19403-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
References: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer firmware has a new call HWRM_FUNC_QSTATS_EXT to retrieve the
masks of all ring counters.  Make this call when supported to
initialize the hardware masks of all ring counters.  If the call
is not available, assume 48-bit ring counter masks on P5 chips.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 64 +++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 33dcb98..65d503f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3742,6 +3742,69 @@ static int bnxt_alloc_stats_mem(struct bnxt *bp, struct bnxt_stats_mem *stats,
 	return -ENOMEM;
 }
 
+static void bnxt_fill_masks(u64 *mask_arr, u64 mask, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++)
+		mask_arr[i] = mask;
+}
+
+static void bnxt_copy_hw_masks(u64 *mask_arr, __le64 *hw_mask_arr, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++)
+		mask_arr[i] = le64_to_cpu(hw_mask_arr[i]);
+}
+
+static int bnxt_hwrm_func_qstat_ext(struct bnxt *bp,
+				    struct bnxt_stats_mem *stats)
+{
+	struct hwrm_func_qstats_ext_output *resp = bp->hwrm_cmd_resp_addr;
+	struct hwrm_func_qstats_ext_input req = {0};
+	__le64 *hw_masks;
+	int rc;
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED) ||
+	    !(bp->flags & BNXT_FLAG_CHIP_P5))
+		return -EOPNOTSUPP;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_QSTATS_EXT, -1, -1);
+	req.flags = FUNC_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK;
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc)
+		goto qstat_exit;
+
+	hw_masks = &resp->rx_ucast_pkts;
+	bnxt_copy_hw_masks(stats->hw_masks, hw_masks, stats->len / 8);
+
+qstat_exit:
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	return rc;
+}
+
+static void bnxt_init_stats(struct bnxt *bp)
+{
+	struct bnxt_napi *bnapi = bp->bnapi[0];
+	struct bnxt_cp_ring_info *cpr;
+	struct bnxt_stats_mem *stats;
+	u64 mask;
+	int rc;
+
+	cpr = &bnapi->cp_ring;
+	stats = &cpr->stats;
+	rc = bnxt_hwrm_func_qstat_ext(bp, stats);
+	if (rc) {
+		if (bp->flags & BNXT_FLAG_CHIP_P5)
+			mask = (1ULL << 48) - 1;
+		else
+			mask = -1ULL;
+		bnxt_fill_masks(stats->hw_masks, mask, stats->len / 8);
+	}
+}
+
 static void bnxt_free_port_stats(struct bnxt *bp)
 {
 	bp->flags &= ~BNXT_FLAG_PORT_STATS;
@@ -4029,6 +4092,7 @@ static int bnxt_alloc_mem(struct bnxt *bp, bool irq_re_init)
 		rc = bnxt_alloc_stats(bp);
 		if (rc)
 			goto alloc_mem_err;
+		bnxt_init_stats(bp);
 
 		rc = bnxt_alloc_ntp_fltrs(bp);
 		if (rc)
-- 
1.8.3.1

