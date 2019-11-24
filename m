Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F1010818F
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 04:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKXDbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 22:31:17 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41193 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfKXDbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 22:31:17 -0500
Received: by mail-pg1-f196.google.com with SMTP id 207so5361525pge.8
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 19:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=URb/e3h60Ba58HfCg570peP5xkRklD4hJL1Zuu444b8=;
        b=UBJHlVjbCYFBh+BYb41QiBSG11Yq5KYHMCO+lzwJEV0l61RL12Soj1JXEDkCf3EFHX
         9vXQv4bWuL5PWTyPWpRwvgzcydlVFMRvcRuCDyKaoh1Mg2O4vRTC0KCDN15xQIs9ahQy
         qdHQsntpgIfKEnj84P4KphPNXsgYGu7O6TUXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=URb/e3h60Ba58HfCg570peP5xkRklD4hJL1Zuu444b8=;
        b=kSTBslDykNdccQMKR3/l00K096aRyEwP/euq3vKTt1emkxo22ZrF0JdEYckUkyg2em
         sX1TRrCor0dGo/8PZXZ7PpilvpeWRQCAWkmo8eanY7tE9TZmyApURra2D9+9+ewlcOVD
         znmkjyzPrkwOKf/jLpn3tbYGI2w7iIiunsqlf78IEJIkQfJPXWRYu95AknxOgFUaTu/c
         C4DC1ll3V1EnjxQUC7wzycfGd8eeskZv9kiSCu3OOwyH9TqMvg6YwHdkxiJM23INFXy+
         RNF525XHulka5nKyyqKn5vim22Rv8yvz9ix9bsA08zYO/YDdwOfCs5uCESJoZdSjqDEk
         USFQ==
X-Gm-Message-State: APjAAAV6mp1WAo410knjVMPOyBp9v9h21FnIrAEmHmBlWwHpdNg+4Htw
        lNs0XWUk+1iZ1eX05+KEAi9nug==
X-Google-Smtp-Source: APXvYqzfu/883mpRkjzW5JeaL4Fu+lz9h84RfoGRKVpudOnrKxpb5dm4ymrzuAEqdEHw1AUIwRxV/g==
X-Received: by 2002:aa7:9a0a:: with SMTP id w10mr27175349pfj.127.1574566276602;
        Sat, 23 Nov 2019 19:31:16 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v63sm3111901pfb.181.2019.11.23.19.31.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 19:31:15 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next v2 03/13] bnxt_en: Do driver unregister cleanup in bnxt_init_one() failure path.
Date:   Sat, 23 Nov 2019 22:30:40 -0500
Message-Id: <1574566250-7546-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
References: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

In the bnxt_init_one() failure path, if the driver has already called
firmware to register the driver, it is not undoing the driver
registration.  Add this missing step to unregister for correctness,
so that the firmware knows that the driver has unloaded.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 13 ++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 14b6104..464e8bd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4483,9 +4483,12 @@ static int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp)
 
 	mutex_lock(&bp->hwrm_cmd_lock);
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (!rc && (resp->flags &
-		    cpu_to_le32(FUNC_DRV_RGTR_RESP_FLAGS_IF_CHANGE_SUPPORTED)))
-		bp->fw_cap |= BNXT_FW_CAP_IF_CHANGE;
+	if (!rc) {
+		set_bit(BNXT_STATE_DRV_REGISTERED, &bp->state);
+		if (resp->flags &
+		    cpu_to_le32(FUNC_DRV_RGTR_RESP_FLAGS_IF_CHANGE_SUPPORTED))
+			bp->fw_cap |= BNXT_FW_CAP_IF_CHANGE;
+	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
 }
@@ -4494,6 +4497,9 @@ static int bnxt_hwrm_func_drv_unrgtr(struct bnxt *bp)
 {
 	struct hwrm_func_drv_unrgtr_input req = {0};
 
+	if (!test_and_clear_bit(BNXT_STATE_DRV_REGISTERED, &bp->state))
+		return 0;
+
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_DRV_UNRGTR, -1, -1);
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
@@ -11864,6 +11870,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bnxt_clear_int_mode(bp);
 
 init_err_pci_clean:
+	bnxt_hwrm_func_drv_unrgtr(bp);
 	bnxt_free_hwrm_short_cmd_req(bp);
 	bnxt_free_hwrm_resources(bp);
 	bnxt_free_ctx_mem(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index e07311e..a38664eef 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1646,6 +1646,7 @@ struct bnxt {
 #define BNXT_STATE_IN_FW_RESET	4
 #define BNXT_STATE_ABORT_ERR	5
 #define BNXT_STATE_FW_FATAL_COND	6
+#define BNXT_STATE_DRV_REGISTERED	7
 
 	struct bnxt_irq	*irq_tbl;
 	int			total_irqs;
-- 
2.5.1

