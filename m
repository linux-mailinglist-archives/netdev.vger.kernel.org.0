Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C838108193
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 04:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKXDbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 22:31:25 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43318 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfKXDbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 22:31:24 -0500
Received: by mail-pg1-f196.google.com with SMTP id b1so5356381pgq.10
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 19:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CEEKHwN0X2Vjw7eHGh5ig2JX1Z6w8+yMLtvgY6iCPNw=;
        b=MLPM4Qcjjjn2CUIkA7S9UmkpuNX/CSaNWjTBxRp6/egf2d+wqLtEuWyHRk7F5Ou2mC
         En3L1BNOgbYwBFgFt900mXa0y+bdHs8EmPAJAznmn6hwNcRlzW5IHkWBCLM3h6TKQfS6
         sA3/UEV9M4qr+WTyfbVAfrjyCQEbu8wWTqnnU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CEEKHwN0X2Vjw7eHGh5ig2JX1Z6w8+yMLtvgY6iCPNw=;
        b=VwVPRm3d7b3yz6okPJsgl+YBl/BSb/CdMme6/X7Uk4pR/mi2JTfPDQJckdNmfes/Ia
         XQxhpj6lUiUXmieHjk0vtIWPNehyBaJFYXEDujOw9YWYB4RdNrVfK5H6ICx/usoUWiJC
         sYh0WLYKhZGTyjJquPtSdK5n6EHY7sNIq1ZV0NjVV20mw3HGOaTG0+1//ZCFd861L4XL
         3/sq1D4bpdfxNspmDIKkNUeAZOJTGCbzJAk01DnNXWagPrB8+a7LhGbN7hQswcrImxtE
         rfTXQGAryiVlk70Nc+63i3m0mA18art2YwPXOAAsh7BCLXlF2tPbBnQ119wv8FB9dc6l
         zi6g==
X-Gm-Message-State: APjAAAUKwXFxL7Nq0pMi30Jk1+icIHf54YyWBDk9vxZISVkXQU1G6gWZ
        FpByI1VKQzf3nRUmeuLOuZ9mVA==
X-Google-Smtp-Source: APXvYqzXMnkgU3G4Ls7JGYdhvYb3fIp0dH+9+MxoqT0SCUlMg+H/B9vh/fWmjuVww1iSh9f0ZtKyJg==
X-Received: by 2002:aa7:9592:: with SMTP id z18mr27205300pfj.176.1574566283991;
        Sat, 23 Nov 2019 19:31:23 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v63sm3111901pfb.181.2019.11.23.19.31.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 19:31:23 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next v2 06/13] bnxt_en: Fix suspend/resume path on 57500 chips
Date:   Sat, 23 Nov 2019 22:30:43 -0500
Message-Id: <1574566250-7546-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
References: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Driver calls HWRM_FUNC_RESET firmware call while resuming the device
which clears the context memory backing store. Because of which
allocating firmware resources would eventually fail. Fix it by freeing
all context memory during suspend and reallocate the memory during resume.

Call bnxt_hwrm_queue_qportcfg() in resume path.  This firmware call
is needed on the 57500 chips so that firmware will set up the proper
queue mapping in relation to the context memory.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 69d7ab1..6a12ab5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11916,6 +11916,9 @@ static int bnxt_suspend(struct device *device)
 	}
 	bnxt_hwrm_func_drv_unrgtr(bp);
 	pci_disable_device(bp->pdev);
+	bnxt_free_ctx_mem(bp);
+	kfree(bp->ctx);
+	bp->ctx = NULL;
 	rtnl_unlock();
 	return rc;
 }
@@ -11944,6 +11947,17 @@ static int bnxt_resume(struct device *device)
 		goto resume_exit;
 	}
 
+	if (bnxt_hwrm_queue_qportcfg(bp)) {
+		rc = -ENODEV;
+		goto resume_exit;
+	}
+
+	if (bp->hwrm_spec_code >= 0x10803) {
+		if (bnxt_alloc_ctx_mem(bp)) {
+			rc = -ENODEV;
+			goto resume_exit;
+		}
+	}
 	if (BNXT_NEW_RM(bp))
 		bnxt_hwrm_func_resc_qcaps(bp, false);
 
-- 
2.5.1

