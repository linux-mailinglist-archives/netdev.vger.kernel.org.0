Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F28C22E475
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 05:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgG0Dad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 23:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgG0Dac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 23:30:32 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E346C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:32 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id w2so8580264pgg.10
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WFWasp0Hp2d+HXAiFF5Euo9fzBUskqGy/gVdc7jSOD4=;
        b=djJ1l8q9yc8kn+Foizun8ypkhAm5DNn+xEvQr1tiQWMznUCTEeMnSI+ng5XYKdn4cJ
         LfbVh+4FaSpFT6ewGAQVfPKjLE5bVdA8dWCoVfjLP2oFDPN0z7CIPpdi+1vAa07iulG+
         OE1Tody9kVGF8ZTQTfR8FIDO7hZBBXzG+VGXw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WFWasp0Hp2d+HXAiFF5Euo9fzBUskqGy/gVdc7jSOD4=;
        b=XSMRqSG9qLGymXFX7p5s/PcOETqNmK+oIPwHXmHNFEPqHU9zJ+3MJnKPTjMGjODUsV
         pfmDWnEIAJ08+TSSdnwNUOkRQkte5OKIRrCuRzYDNUR55072M+jqAXUXhO1quyXP7ghH
         QEx+PFzOI9aDLwxUOlSYKwx31MWrPDPO3tvSWSTFWHjy3Gik0Aq4HQHTrkLoNolrLzPv
         Rt1TDif8LAPgIzGxKrisX/QfIw517AHxG93A99Lefwc8frR9P3Vm2bsNlrmoJsqP0+9I
         cypazeeYWXTGtoXvN2x1i1MSArR9iFA8eaLi6fP9qNPCajYIo7mxXA1/pmTZpW2xYbm6
         Ig1Q==
X-Gm-Message-State: AOAM530xsgPwadXHoTczEmO9rVK8FD0qqUt29yCcyndiazkMly7rMk4d
        NlGCXsov4jaohTsbjmf03gTAtaPZ05w=
X-Google-Smtp-Source: ABdhPJy+Ftiu+6A2CXs0FyIjTX1kVyj9D6pvtvXipYUVQv2fPkN5dmozTlaFJHK0sq1U/l7/qvAGUQ==
X-Received: by 2002:a65:60d4:: with SMTP id r20mr17700176pgv.436.1595820631611;
        Sun, 26 Jul 2020 20:30:31 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n25sm13504506pff.51.2020.07.26.20.30.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2020 20:30:31 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 06/10] bnxt_en: Retrieve hardware counter masks from firmware if available.
Date:   Sun, 26 Jul 2020 23:29:42 -0400
Message-Id: <1595820586-2203-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
References: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
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

