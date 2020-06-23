Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037962067D4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388327AbgFWXCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388185AbgFWXCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:02:02 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B7CC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:02:02 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id l12so407731ejn.10
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UXF7jTK5X4sNmlIPqvfn443bKnwTja7vONLaRL+nHrE=;
        b=LOh6WLVWs0HTDR7zcdpOYBXURx4TXknsTvpZ2jh8hcsbdONMfSisTeBzqiqMG3OQF4
         sJ+q0G+e31hQaVIIiR3FI7EOWFpFYfzwz8V/tGy9L3MCV6PBM+wvzDNpR9pTChHojuVf
         I+8Nv2T+YUGqqp8hemqVVmk2fn8PW+B0Im7JQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UXF7jTK5X4sNmlIPqvfn443bKnwTja7vONLaRL+nHrE=;
        b=L5/F/4VKjnLofyPZ42bg0iTkLCThbtmWL3NvugnbRclfZcawIioG9/9knjw0SG96eq
         yo47mWffMOXGTSCKWeg9imZa5+qPIZUzZwdcBbTmPaYEW0iJMYibI29MrZWyHrk1ub5u
         1G7f1c3Nh7IdxW3uldGYoHtvjPY2FulN+x/L26YK5FfeBdsIkL4QM6UvEjLsdQR+4aSL
         VmLm5/RF0iwAoJc8vI1/M3Wcsqim4fJTYEXlfTVP156Qm5vtUB8B6agZuaepbzCiznOU
         nDALEKcMTc1zB3Do8VT5a3Em75+UAUdAt2E7jnPyJN+bNwFqNZsZZXmRSA/UBhEqX6zR
         x8Rw==
X-Gm-Message-State: AOAM531bAlq//hBTGLVQ/Hv+2JW/cEIZ/2vnh4sZ9glpQRO6AmBON3CM
        /uWYRnxzg6WwNqbr6aX4LY8I8Q==
X-Google-Smtp-Source: ABdhPJxAc0+nL+5N7GsEvLZGe20RILMHgAXwVV5RXnEpT4SYHrhBTsMvouRdfczLP78RcLFYm06NPg==
X-Received: by 2002:a17:906:4b16:: with SMTP id y22mr1109084eju.4.1592953320737;
        Tue, 23 Jun 2020 16:02:00 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cw19sm8205865ejb.39.2020.06.23.16.01.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jun 2020 16:02:00 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/4] bnxt_en: Read VPD info only for PFs
Date:   Tue, 23 Jun 2020 19:01:38 -0400
Message-Id: <1592953298-20858-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592953298-20858-1-git-send-email-michael.chan@broadcom.com>
References: <1592953298-20858-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Virtual functions does not have VPD information. This patch modifies
calling bnxt_read_vpd_info() only for PFs and avoids an unnecessary
error log.

Fixes: a0d0fd70fed5 ("bnxt_en: Read partno and serialno of the board from VPD")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6dc7cc4..6a884df 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11913,7 +11913,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->ethtool_ops = &bnxt_ethtool_ops;
 	pci_set_drvdata(pdev, dev);
 
-	bnxt_vpd_read_info(bp);
+	if (BNXT_PF(bp))
+		bnxt_vpd_read_info(bp);
 
 	rc = bnxt_alloc_hwrm_resources(bp);
 	if (rc)
-- 
1.8.3.1

