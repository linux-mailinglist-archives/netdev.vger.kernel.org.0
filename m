Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE56F13F2A
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 13:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfEELRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 07:17:31 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37888 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbfEELR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 07:17:29 -0400
Received: by mail-pf1-f196.google.com with SMTP id 10so5217756pfo.5
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 04:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=31vfbB0sYysbgmmfrNzsDpWpYc0vZCSf5tdivnF6r+4=;
        b=N2rFeqcZLRBPqmJg0DHJT19pIdGT8lJwUxuCBTv4PPGvdHM+vdsltK+uw5IWUrfiAi
         8JkMEQ8sr8VGJT8SKxyETb1sr9falXbZIXrm89GodrpO4G/686p4KfHN3k0gEHWx+cIc
         f/XohTLkUV1ul30fEmzzZ3nT0vsRqPNM4/puQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=31vfbB0sYysbgmmfrNzsDpWpYc0vZCSf5tdivnF6r+4=;
        b=DFK+PDMjRDgP0SJaPVJDmOzRC98RXiT/X3kUZCOqf3F9vgqWRoWTsfTaVYdYLrxYDT
         l+ahKaCI1CZbl9WtY+5gIuw4W0U4qt0XGvxasDwQMX5gSzrTq8N71KCkVek0khfUrPA6
         DeZM36hOIgK5FBBV+F64aOAAIXDm6ZG8q/sFwgnwvEpjNKZZr7hVAeE2PMwbO5BKAkbx
         tprg+QC3Yr4si7ZH04xONQG6oyn4QxfTcGBGqKWAfVSGAa0QJOfs6bn7u22wSp6P+PoC
         q4HFfOaZuHWS1Wgxfru2xqqeBGYHVbO8F/AEokt6k/Am4LOtIxYeS5s6t8PPeCmbBidM
         IkAg==
X-Gm-Message-State: APjAAAWwmeL/AlWtP7UzpKy6JhVHk6gWXyeCa43nIhHr/+D8PWyZ6NeE
        3pDB6pZYMmpSR5QtoGyI9FLQKg==
X-Google-Smtp-Source: APXvYqxmzAsaDPNU2IhqHtGBC7F11hYct1nBKvhgnQWcDX+zqFv4ZdN0WubLhgkgM24JuCzT2D2ZPg==
X-Received: by 2002:a63:b507:: with SMTP id y7mr24052534pge.237.1557055049073;
        Sun, 05 May 2019 04:17:29 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id 10sm9378902pfh.14.2019.05.05.04.17.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 04:17:28 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 10/11] bnxt_en: Add support for aRFS on 57500 chips.
Date:   Sun,  5 May 2019 07:17:07 -0400
Message-Id: <1557055028-14816-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
References: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set RSS ring table index of the RFS destination ring for the NTUPLE
filters on 57500 chips.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c9dad7c..143fdc9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4226,16 +4226,25 @@ static int bnxt_hwrm_cfa_ntuple_filter_free(struct bnxt *bp,
 static int bnxt_hwrm_cfa_ntuple_filter_alloc(struct bnxt *bp,
 					     struct bnxt_ntuple_filter *fltr)
 {
-	struct bnxt_vnic_info *vnic = &bp->vnic_info[fltr->rxq + 1];
 	struct hwrm_cfa_ntuple_filter_alloc_input req = {0};
 	struct hwrm_cfa_ntuple_filter_alloc_output *resp;
 	struct flow_keys *keys = &fltr->fkeys;
+	struct bnxt_vnic_info *vnic;
+	u32 dst_ena = 0;
 	int rc = 0;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_CFA_NTUPLE_FILTER_ALLOC, -1, -1);
 	req.l2_filter_id = bp->vnic_info[0].fw_l2_filter_id[fltr->l2_fltr_idx];
 
-	req.enables = cpu_to_le32(BNXT_NTP_FLTR_FLAGS);
+	if (bp->fw_cap & BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX) {
+		dst_ena = CFA_NTUPLE_FILTER_ALLOC_REQ_ENABLES_RFS_RING_TBL_IDX;
+		req.rfs_ring_tbl_idx = cpu_to_le16(fltr->rxq);
+		vnic = &bp->vnic_info[0];
+	} else {
+		vnic = &bp->vnic_info[fltr->rxq + 1];
+	}
+	req.dst_id = cpu_to_le16(vnic->fw_vnic_id);
+	req.enables = cpu_to_le32(BNXT_NTP_FLTR_FLAGS | dst_ena);
 
 	req.ethertype = htons(ETH_P_IP);
 	memcpy(req.src_macaddr, fltr->src_mac_addr, ETH_ALEN);
@@ -4273,7 +4282,6 @@ static int bnxt_hwrm_cfa_ntuple_filter_alloc(struct bnxt *bp,
 	req.dst_port = keys->ports.dst;
 	req.dst_port_mask = cpu_to_be16(0xffff);
 
-	req.dst_id = cpu_to_le16(vnic->fw_vnic_id);
 	mutex_lock(&bp->hwrm_cmd_lock);
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (!rc) {
@@ -9114,7 +9122,7 @@ static bool bnxt_rfs_capable(struct bnxt *bp)
 	int vnics, max_vnics, max_rss_ctxs;
 
 	if (bp->flags & BNXT_FLAG_CHIP_P5)
-		return false;
+		return bnxt_rfs_supported(bp);
 	if (!(bp->flags & BNXT_FLAG_MSIX_CAP) || !bnxt_can_reserve_rings(bp))
 		return false;
 
-- 
2.5.1

