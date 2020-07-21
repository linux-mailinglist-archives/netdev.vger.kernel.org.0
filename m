Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4F02286EA
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgGURO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729967AbgGUROZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:14:25 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367C0C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:14:25 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id o1so10550526plk.1
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2r8I5DpvGKF0uBCNvnKdu0+B/gTWJcgxD3P5Jc0eTIM=;
        b=m28DyhbFmruGf693wr6pY9aR8T2E3RyVOza57OuGUf6j3dkkOSriRDU6S/qzPyrnMj
         b3mGQCd2pwHo7DEQKg1m/wXOJc0hOXJRd75jUlGMRBDSs98ODCWD/tpGQhNGaC365iGh
         9nYLPi5/xheDFPg9IrOe/zwxwhrFQKpTqmqJK7qj9/NNvGrk3zUFbQTjJxjvX5YsCNXJ
         ghUyh7B7AM4nL0eL2U/ETjf3fcXFapU1IsUwHod6vceSWiSiWqVmQI2siVjZsdDCLm3a
         T5TVUwwsUnoCMMrC6a3iwPhSNORvYKDxRayCmbQb6JR3sJtgbCFqbB3FhGNkmnHoWeOv
         FSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2r8I5DpvGKF0uBCNvnKdu0+B/gTWJcgxD3P5Jc0eTIM=;
        b=S+YadycDFk1vHQIrlNz9+tSE+B6tGNQkG/FaKA/NNh8d45CfgqmW98BwhHzgE51sSX
         Hw4lCL4rvUQghr9iU42AbQzKyVQXN0YRPq6wPHjXm4b4+P7FYDEdoCfxAkk7MIR5qq1C
         Oo6qUA8sCxVgkA9w9E6i17co2+4hAGrNpnqrSJCuRcaZSjKs2QxKGYQBjpy9EqIgYctY
         mIazdholk93NzEVWVGzeLI3zd+ei2bYBJh7X5dBwyudPr56tv5PRTx1BtCYsgvnFk2M4
         MeduT5dGwTlH8ytdWLkGv+0Hq73nhjJU5YurjYlKfKYh77zGIBcZ08ReS1/9NU+EmWfY
         bxKg==
X-Gm-Message-State: AOAM531ZSQs9kQ/Mcuper3HNgQJkcGwW2/KDIo8YZPRIg+iKnI6XXPxI
        3toYjE3rd5sBz0VyILJWAMA=
X-Google-Smtp-Source: ABdhPJyHqsgbrM4tSGW2tlNCTbrumPX5QAHtISYl6Nypyas/WQrN8YMaWqK1TAYEJ4V5jawNvy1eLA==
X-Received: by 2002:a17:90a:9502:: with SMTP id t2mr5319211pjo.205.1595351664761;
        Tue, 21 Jul 2020 10:14:24 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id z20sm2982305pjr.43.2020.07.21.10.14.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 10:14:24 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     sgoutham@marvell.com, sbhatta@marvell.com
Subject: [PATCH net 1/3] octeontx2-pf: Fix reset_task bugs
Date:   Tue, 21 Jul 2020 22:44:06 +0530
Message-Id: <1595351648-10794-2-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595351648-10794-1-git-send-email-sundeep.lkml@gmail.com>
References: <1595351648-10794-1-git-send-email-sundeep.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Two bugs exist in the code related to reset_task
in PF driver one is the missing protection
against network stack ndo_open and ndo_close.
Other one is the missing cancel_work.
This patch fixes those problems.

Fixes: 4ff7d1488a84 ("octeontx2-pf: Error handling support")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 6478656..75a8c40 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1730,10 +1730,12 @@ static void otx2_reset_task(struct work_struct *work)
 	if (!netif_running(pf->netdev))
 		return;
 
+	rtnl_lock();
 	otx2_stop(pf->netdev);
 	pf->reset_count++;
 	otx2_open(pf->netdev);
 	netif_trans_update(pf->netdev);
+	rtnl_unlock();
 }
 
 static const struct net_device_ops otx2_netdev_ops = {
@@ -2111,6 +2113,7 @@ static void otx2_remove(struct pci_dev *pdev)
 
 	pf = netdev_priv(netdev);
 
+	cancel_work_sync(&pf->reset_task);
 	/* Disable link notifications */
 	otx2_cgx_config_linkevents(pf, false);
 
-- 
2.7.4

