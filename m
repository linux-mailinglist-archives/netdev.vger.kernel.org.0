Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F4A1C34EC
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgEDIvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728422AbgEDIvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:21 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7297C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mq3so3509561pjb.1
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DlcHEeUPhljZuU6pyIa1Xdb30eTQ73mJQ0NrV1TD+NM=;
        b=DF7ihhsCXbiefNuEUxzHf3xu7ols7RHPjuynVmP2xsjSruh9UMx8NNxmu7KPbdZbgP
         u4Gi3hHsPwRzY9F2V5GZ6o9GUpKZAfEC0emGrCyNP5FwKaZRLR9R1MfRT+vDIxp4oGk9
         JLoCY1e2Eup34TjRgq+9yVl8FuWv3JCu3zN/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DlcHEeUPhljZuU6pyIa1Xdb30eTQ73mJQ0NrV1TD+NM=;
        b=alwmrr7qiaoES0S4XSkebFEmqCQZKnT5rrYcch9/AWaGz+0Ia6oA3o1j/7kbZmTRvA
         DrxsJVbnsRTHPpLXqTPdIJENWyZiKtbdoKyBiUk8a1NL6IAlue8OS5Ja5D+K07gwBJGO
         ihJKa8IXP/RS+PSNt75zceZrxh9weL2BLlQ3w6J3x1F1/gdpuGis7LpI6OZlVDlO/WUZ
         Ec2tJViX3S/Fa9hMsb8N6bU5Kw6oNwBAj47YIJe2dn8tbimj+WFq9OpWhzcqf+T4Yr7J
         T9rKS8Y1eeflQKQWcdBzot11xHCgxKx649riNca+aIhWYvK15Hv510WhqneEoLLK9921
         tMog==
X-Gm-Message-State: AGi0PuaVBm72QAfAhXhci2HqtjBpQwg6wfH9mns/YDQAGirgMa7oB1jq
        9vdxVkROYvnvpVHerPWgvej3rg==
X-Google-Smtp-Source: APiQypI7f4Vz74N06fr4kSiSjf5OeL+Rt+1i3I1XEBZ0rh5SEoYmTX6fqiXJGaxQFkF7skRqXtX82A==
X-Received: by 2002:a17:90a:2b8f:: with SMTP id u15mr16906406pjd.137.1588582281171;
        Mon, 04 May 2020 01:51:21 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.51.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:51:20 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 12/15] bnxt_en: Add doorbell information to bnxt_en_dev struct.
Date:   Mon,  4 May 2020 04:50:38 -0400
Message-Id: <1588582241-31066-13-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this is to inform the RDMA driver the size of the doorbell
BAR that the L2 driver has mapped and the portion that is mapped
uncacheable.  The unchaeable portion is shared with the RoCE driver.
Any remaining unmapped doorbell BAR can be used by the RDMA driver for
its own purpose.  Currently, the entire L2 portion is mapped uncacheable.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 2 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 4b40778..8c8368c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -481,6 +481,8 @@ struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev)
 			edev->flags |= BNXT_EN_FLAG_ROCEV2_CAP;
 		edev->net = dev;
 		edev->pdev = bp->pdev;
+		edev->l2_db_size = bp->db_size;
+		edev->l2_db_size_nc = bp->db_size;
 		bp->edev = edev;
 	}
 	return bp->edev;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index 9895406..6b4d255 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -67,6 +67,14 @@ struct bnxt_en_dev {
 	#define BNXT_EN_FLAG_ULP_STOPPED	0x8
 	const struct bnxt_en_ops	*en_ops;
 	struct bnxt_ulp			ulp_tbl[BNXT_MAX_ULP];
+	int				l2_db_size;	/* Doorbell BAR size in
+							 * bytes mapped by L2
+							 * driver.
+							 */
+	int				l2_db_size_nc;	/* Doorbell BAR size in
+							 * bytes mapped as non-
+							 * cacheable.
+							 */
 };
 
 struct bnxt_en_ops {
-- 
2.5.1

