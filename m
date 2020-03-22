Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC0718EC35
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 21:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgCVUkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 16:40:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39297 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgCVUkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 16:40:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id d25so6404417pfn.6
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 13:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T9HVlQ8lTXeZ2isQQq1S688+mHKaEmwWE+YdSKsQQhU=;
        b=Zy5jMdh0IO1ryc8b+vaKRxMjd/IEVKi/XGx6hpz5t+QHhugIWmXiK3joCvIuIbZ/CR
         3HbgY3KHkF+SKV4ts+16LUiRe+aW7oSrB4jhRKrM0ASQJVR+hd2ZVTBGz0EfEddskqdt
         thAHGMjfQPNjaaKP/BYK0LOyneYgGDpSNvG+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T9HVlQ8lTXeZ2isQQq1S688+mHKaEmwWE+YdSKsQQhU=;
        b=T0Fbos8NFItetImRLgZNThvMbPG8D2jL94uC+T0bMT1ksHVXcWZKZdtBundQUmIm5B
         OPRvqx9cRMuphGFil/VUCEcjd9rOGH3iUdBop7lJsLcLUy+zkt2xhS/0fMgLMQJxTKwo
         +VKr+buaDNXAAS5MV4gAi9e3hx0CTdhWNhni3l/tck4un5HAw9QUcYZ6fMYujPVyMuzA
         o7Xq8cHfnP/cef1s6+NmiLa0IJViYJsjKyJhoxaGo1tNWKD1YsP2iN3eId/LTdVp9iBr
         LGbUbHMhWyH7I/e1CAJUZzxcmpjIdX6bc/94IfKJKvnKi2HwbxUFdPu5pCdZKpGWMAfv
         FZAg==
X-Gm-Message-State: ANhLgQ1uOtS2fk43a2arpVmZ6h7+VqsMIz6VZQPxLPzO61Pwfd6tBXHc
        kdSlVtQGxwquhztNimXOyoyKrc8eewI=
X-Google-Smtp-Source: ADFU+vtH/4U8i3ur+B6hb6Y3J3f1PV431OLLRx5oAMWxRGKL0o/0Z5FiFHzYo0F8zPiCMK0n6Jao+w==
X-Received: by 2002:a63:f447:: with SMTP id p7mr18822607pgk.326.1584909641873;
        Sun, 22 Mar 2020 13:40:41 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y131sm11575843pfb.78.2020.03.22.13.40.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 13:40:41 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 3/5] bnxt_en: Return error if bnxt_alloc_ctx_mem() fails.
Date:   Sun, 22 Mar 2020 16:40:03 -0400
Message-Id: <1584909605-19161-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
References: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code ignores the return value from
bnxt_hwrm_func_backing_store_cfg(), causing the driver to proceed in
the init path even when this vital firmware call has failed.  Fix it
by propagating the error code to the caller.

Fixes: 1b9394e5a2ad ("bnxt_en: Configure context memory on new devices.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b66ee1d..0628a6a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6880,12 +6880,12 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	}
 	ena |= FUNC_BACKING_STORE_CFG_REQ_DFLT_ENABLES;
 	rc = bnxt_hwrm_func_backing_store_cfg(bp, ena);
-	if (rc)
+	if (rc) {
 		netdev_err(bp->dev, "Failed configuring context mem, rc = %d.\n",
 			   rc);
-	else
-		ctx->flags |= BNXT_CTX_FLAG_INITED;
-
+		return rc;
+	}
+	ctx->flags |= BNXT_CTX_FLAG_INITED;
 	return 0;
 }
 
-- 
2.5.1

