Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7972067D2
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388244AbgFWXB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388185AbgFWXB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:01:58 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B0FC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:01:58 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id w7so53048edt.1
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0SmOR+oMRjSFZ3fgb9UmqPxABn3hoz6kTNhtlRoukMk=;
        b=RABcm4TAEWfT0irzHefq59/g2rW+/VPX+KalVvlelJIeHGhBcbTfpDt8y1Q/gX7ERr
         JmylfV5NZEBFsWox+c1t+p8blzq/J3u4tbrpkN1+Md9aOI/2zc2nGEp5M8C8Slsh/tiH
         5Yt7AurAli9D9diJ3oKp5eA2Fg5sET0wU41vQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0SmOR+oMRjSFZ3fgb9UmqPxABn3hoz6kTNhtlRoukMk=;
        b=T3vNBiCPD0ZPG1DsLBZelgyoh40p0X9rPaSKW4hEDMRF9k3pYnRqsVnY6b3DRTxbSP
         nS4uQe+df0IJ1fVaXOAfSVzI3jEzo+1VZewzyNZA1nPtejKMhr1GP67iuw7b6rasfast
         IbTFb0QATBhSjTU8Bp2K6jKTde36drrnTnwPJTTlEZ8aFRH+l9X+xDA+uTq0sxDK02QT
         y9mO4vS+7B5FZ93++RtIY1lfMKaoX+NYlKVvRy0LTKAt9r70w4wmhpYCAU2YP+y46BVd
         CXPzLBxZBUYw8HFvs0SuLIpgQrJnUKbycUheq6GPsHUZyC17cBh+CcnQ7ouv3+IK4HCX
         uO8Q==
X-Gm-Message-State: AOAM530z64yPTT0qdYsfWQrVvJSMERyP/cEUCciag49xA9t64bsaHq+m
        52dYONWfezHlbyI7ADDCpFbHVA==
X-Google-Smtp-Source: ABdhPJwJNNGhyGi4MHT7vb4XA6g8ciNN5rSjHHdm1yUIaHvjyeYjOHqMvTSr4KAbb/yJToC80p0nhA==
X-Received: by 2002:aa7:cd6c:: with SMTP id ca12mr24445223edb.36.1592953316862;
        Tue, 23 Jun 2020 16:01:56 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cw19sm8205865ejb.39.2020.06.23.16.01.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jun 2020 16:01:56 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/4] bnxt_en: Do not enable legacy TX push on older firmware.
Date:   Tue, 23 Jun 2020 19:01:36 -0400
Message-Id: <1592953298-20858-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592953298-20858-1-git-send-email-michael.chan@broadcom.com>
References: <1592953298-20858-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Older firmware may not support legacy TX push properly and may not
be disabling it.  So we check certain firmware versions that may
have this problem and disable legacy TX push unconditionally.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0ad8d49..f8c50b1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6976,7 +6976,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->fw_cap |= BNXT_FW_CAP_ERR_RECOVER_RELOAD;
 
 	bp->tx_push_thresh = 0;
-	if (flags & FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED)
+	if ((flags & FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED) &&
+	    BNXT_FW_MAJ(bp) > 217)
 		bp->tx_push_thresh = BNXT_TX_PUSH_THRESH;
 
 	hw_resc->max_rsscos_ctxs = le16_to_cpu(resp->max_rsscos_ctx);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 858440e..78e2fd6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1749,6 +1749,7 @@ struct bnxt {
 	u64			fw_ver_code;
 #define BNXT_FW_VER_CODE(maj, min, bld, rsv)			\
 	((u64)(maj) << 48 | (u64)(min) << 32 | (u64)(bld) << 16 | (rsv))
+#define BNXT_FW_MAJ(bp)		((bp)->fw_ver_code >> 48)
 
 	__be16			vxlan_port;
 	u8			vxlan_port_cnt;
-- 
1.8.3.1

