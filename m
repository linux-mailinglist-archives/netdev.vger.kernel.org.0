Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8C422D4FC
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 06:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgGYEoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 00:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGYEoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 00:44:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09419C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 21:44:13 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mn17so6448339pjb.4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 21:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jrzGaiLKHqZqkLl9ScsX3SMhjOpuWszxik9ksIsSN3g=;
        b=dO/FzQEKCjzj27OdE5OpmPqmu28lYUahgb9R4b8gvdJO1itjzm3WKA9EIyOAPJBh62
         IcUUI0zW55QePAGPuUEPp5fnrYlI/G+BUOScZ5mXfI21795VeNjwaDWCLtSH97xbtw4d
         kJ+cMUebNsqFaXtVvUfxXQD/UaSVKh5cgOWszzmAnH1DWhQ7sg6nh94XygqkXZuYp+hn
         FhZaca1Ju6FhNnugFjA3YfXlM1aGZBpZF0jMYNwBGVBkGC3kvWzqlEVhL7xgXf6L0HSo
         T50A+ZSQ1UQj/idmhVJgNDswua/hLlxdTjO21aMzilnxPi4kkOnxAejtClYL6tt69TlF
         b3KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jrzGaiLKHqZqkLl9ScsX3SMhjOpuWszxik9ksIsSN3g=;
        b=jgokiU2wkI00PP/BO8mmwZBqbExWeOc9SpTe6y2H2+0nozv0ccMcr1k/1lOyJdTday
         5aYf9C/dq5YA2KkrB+ZNx2AwRAj21BjVXu/sNmg9pjPVwXN7cYNW3qTNzpSXiEMcI+Kb
         a06M/Se7lS3LF8XIKQeuEjwzyv0cd8Qie+sLRsmVJK9lUDJ9REtStps4up98P2BVvCKK
         otvcU8vCZRCSyezZTPeFYix32e2V0CpMJx1XGgV5lx7no8r6yu7PH2ZZykqkiRs3DbE7
         MsOfREolu24TxChmCF83NaFheUvZVjg3MxVj9H4EwlF8Xbq2H9VKgqb3zFkGSORJ8cIx
         PkXQ==
X-Gm-Message-State: AOAM5333rrQm/KcnM2bTjsuIpnApfmf4p/OMX59aJVHyKbJFrJ0yLndX
        83KspJPmV1DJW3OUMnPxFeLyXaTS/RI=
X-Google-Smtp-Source: ABdhPJxSCEY0TB4dKM6yA80aCYaHvy35YlyWWFjlJ94G7Szx5uIbu7QxDs93MuoXWw0VBrSQtcIhog==
X-Received: by 2002:a17:90b:196:: with SMTP id t22mr8886789pjs.13.1595652252609;
        Fri, 24 Jul 2020 21:44:12 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id e18sm7906618pff.37.2020.07.24.21.44.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2020 21:44:12 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     sgoutham@marvell.com, sbhatta@marvell.com
Subject: [PATCH net v2 1/3] octeontx2-pf: Fix reset_task bugs
Date:   Sat, 25 Jul 2020 10:13:52 +0530
Message-Id: <1595652234-29834-2-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595652234-29834-1-git-send-email-sundeep.lkml@gmail.com>
References: <1595652234-29834-1-git-send-email-sundeep.lkml@gmail.com>
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

v2 changes:
	None


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

