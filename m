Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048F218EC34
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 21:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgCVUkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 16:40:41 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36675 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgCVUkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 16:40:40 -0400
Received: by mail-pj1-f66.google.com with SMTP id nu11so5073055pjb.1
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 13:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kEbnuwwIX51XTwIXZxTvJJMhY2aomi8Xj5zi66we3fU=;
        b=iOImKVoJOIgYrRyCzzyQ6PwUcxu4QWUhycf4qA/IgH7E8jWeR/LmWIKyssskRs4svj
         IGCqf7uDJ7mPebvUB+9RMn+PNcdW3xPCe0Xsdwv3WYhbQM+tBLjZpfKZFOP2m5qv4ybH
         upmLU1rXepwGOuRiboH9r/Toh7cx2/FA2JSv4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kEbnuwwIX51XTwIXZxTvJJMhY2aomi8Xj5zi66we3fU=;
        b=MjPQOivVUkNoiyDQ8WebvCk9YyrPV1j09Wtk5MP6/E2hnY1edzIEO38ss0XDwsqJ0o
         4uKSuz2ZLHMEvd/hb1RI0zEl+IzD57JSV4QX1T4oN6w8V79Kc6wLdXKhCc/NuEzpMdoE
         iTQ7tXL7xPkHRePUYcuvMkufPyz1QHAe18uGq265UIlMGV82G9j9aN+Y3e9tx77l0esh
         1awOSa4r7czSOkpvNlFKJXNNwYTfaseYeQeMFXOFs2ui57TskRZ/3pSY4T7i7CiF4oOi
         ak7q2lJFz4lR6k501qVF1veiv7sv9PaJFu/yKPzir28dG7GN94YNwcmO0PMjtrsujYdO
         Fv/A==
X-Gm-Message-State: ANhLgQ1ZxSExgKL7mfoF/jeL4viAxJ7dPq15IB9wTrPzAe+BToz/34tJ
        lUDe9C76ICjoab0Lij+t0TEjc0SibDQ=
X-Google-Smtp-Source: ADFU+vu/duawI0rWEXH9hXNiXaZpZV+7Xm/PcVxCN5ITlJAQQt2EfB8gT66WIfcOVjshSkm7uUwriw==
X-Received: by 2002:a17:90b:1954:: with SMTP id nk20mr21731080pjb.69.1584909639823;
        Sun, 22 Mar 2020 13:40:39 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y131sm11575843pfb.78.2020.03.22.13.40.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 13:40:39 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 2/5] bnxt_en: fix memory leaks in bnxt_dcbnl_ieee_getets()
Date:   Sun, 22 Mar 2020 16:40:02 -0400
Message-Id: <1584909605-19161-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
References: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

The allocated ieee_ets structure goes out of scope without being freed,
leaking memory. Appropriate result codes should be returned so that
callers do not rely on invalid data passed by reference.

Also cache the ETS config retrieved from the device so that it doesn't
need to be freed. The balance of the code was clearly written with the
intent of having the results of querying the hardware cached in the
device structure. The commensurate store was evidently missed though.

Fixes: 7df4ae9fe855 ("bnxt_en: Implement DCBNL to support host-based DCBX.")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
index fb6f30d..b1511bc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -479,24 +479,26 @@ static int bnxt_dcbnl_ieee_getets(struct net_device *dev, struct ieee_ets *ets)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct ieee_ets *my_ets = bp->ieee_ets;
+	int rc;
 
 	ets->ets_cap = bp->max_tc;
 
 	if (!my_ets) {
-		int rc;
-
 		if (bp->dcbx_cap & DCB_CAP_DCBX_HOST)
 			return 0;
 
 		my_ets = kzalloc(sizeof(*my_ets), GFP_KERNEL);
 		if (!my_ets)
-			return 0;
+			return -ENOMEM;
 		rc = bnxt_hwrm_queue_cos2bw_qcfg(bp, my_ets);
 		if (rc)
-			return 0;
+			goto error;
 		rc = bnxt_hwrm_queue_pri2cos_qcfg(bp, my_ets);
 		if (rc)
-			return 0;
+			goto error;
+
+		/* cache result */
+		bp->ieee_ets = my_ets;
 	}
 
 	ets->cbs = my_ets->cbs;
@@ -505,6 +507,9 @@ static int bnxt_dcbnl_ieee_getets(struct net_device *dev, struct ieee_ets *ets)
 	memcpy(ets->tc_tsa, my_ets->tc_tsa, sizeof(ets->tc_tsa));
 	memcpy(ets->prio_tc, my_ets->prio_tc, sizeof(ets->prio_tc));
 	return 0;
+error:
+	kfree(my_ets);
+	return rc;
 }
 
 static int bnxt_dcbnl_ieee_setets(struct net_device *dev, struct ieee_ets *ets)
-- 
2.5.1

