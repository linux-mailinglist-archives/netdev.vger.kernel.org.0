Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F16CEAA0D
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 06:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfJaFI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 01:08:28 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45801 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfJaFI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 01:08:27 -0400
Received: by mail-pf1-f195.google.com with SMTP id c7so3389185pfo.12
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 22:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6U0DdVBt11P+lPbk4FcyAzrmyMTGkcNoAeqhfEhsYGc=;
        b=Bg15GGpOa4z2IdlJcPmrjBrRUhXPVsOK07ZiKHOd1weJEB6OBvro7WBmaRlz4OXpXw
         vDF5YuEqvYRtbNSYhUCnKFV4tX26yV9Lr1N2/qMFWKmd0geAZ4WJS3eJ+UW211hIKHb7
         ewFLCIGAvO3r9GnLpWB6ZzR1NaI5stKNQlmdc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6U0DdVBt11P+lPbk4FcyAzrmyMTGkcNoAeqhfEhsYGc=;
        b=p4qHclPpL3nKav/SRZYlUwRSEtBkNVfpIKiwqe0c3I8gg3EBerSidIXMLsfo+erwWZ
         p5VrXQ6TcjR2WewFGGVJa5Y4Ms8a5gfnXFpDSA9e6rMbywLxFYLsZkxiVlG3pKoehuxk
         gstAzXtUEmXuyUnrbCrMVT1sUZ+yXhkvmZCOsZRmmX7/BYSzyz1aStj2RFU/0MoLUpam
         hPV2d0PiPV0wdiLiDkSjgFrykWAOhbKVDwQkD6ecBwdGRBERNQmGHZK3O3j3vrsa7Ry0
         Ajbt4mfOQ/A/zRl7w84X212nEjEf07sqKoJ/MF8NFyjoQ6c8L6gyIvfuzNuavJ8F22PN
         +8oQ==
X-Gm-Message-State: APjAAAWhvvyuNEBGLVbqBl//uT9Gi1AiP4aQr/zAe3gRMVKdad4jo5vt
        y2TXitJQJ+Hp8TsTlS2jIcLGHg==
X-Google-Smtp-Source: APXvYqy3j8LMhBksC0I2sxdrfnj2pekO3ObICBYIlxZi5UdA1SqTpH/Thu9OC5DJ89kykFu9EIT6Mw==
X-Received: by 2002:a63:200e:: with SMTP id g14mr3960441pgg.91.1572498506243;
        Wed, 30 Oct 2019 22:08:26 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a8sm1690899pff.5.2019.10.30.22.08.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 22:08:25 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [PATCH net-next v2 7/7] bnxt_en: Call bnxt_ulp_stop()/bnxt_ulp_start() during suspend/resume.
Date:   Thu, 31 Oct 2019 01:07:51 -0400
Message-Id: <1572498471-31550-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
References: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Inform the RDMA driver to stop/start during suspend/resume.  The
RDMA driver needs to stop and start just like error recovery.

Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e7524c0..2467b79 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11892,6 +11892,7 @@ static int bnxt_suspend(struct device *device)
 	int rc = 0;
 
 	rtnl_lock();
+	bnxt_ulp_stop(bp);
 	if (netif_running(dev)) {
 		netif_device_detach(dev);
 		rc = bnxt_close(dev);
@@ -11925,6 +11926,7 @@ static int bnxt_resume(struct device *device)
 	}
 
 resume_exit:
+	bnxt_ulp_start(bp, rc);
 	rtnl_unlock();
 	return rc;
 }
-- 
2.5.1

