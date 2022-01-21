Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E25D4959FD
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378717AbiAUGfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:35:22 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64802 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233954AbiAUGfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:35:18 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L05jDr029262;
        Thu, 20 Jan 2022 22:35:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=DUpiGbrExK6I/TObFKQS/KdcaRhdO+OVw7X29u9FCFM=;
 b=ijgLEaS4LRp2tp2mkDnizmtid1nL42KaVLFlqR1/2YPfVtBSTxmK/bDUC5tCZmvd8f4u
 bUaibyGWumQhx8XUwel+hka9P7HvR1084kq14BSgGh7I9lojpylgmmMkJ0BLLv0YrbxX
 wHbGSqUVykXPGu5ErMzV7DKYwSMYnQOdQMA3jIwM59GHC/IhTTUh+quMJYVwZCul+JxZ
 cNvoFaP/eRfg3ZUXzUUckDsJ94hP0q/RMwYccssKTelQQlgId31nzx0l9N0vtX+qUAHM
 XMT/y404QbsjYGl9ury2rjPhi1Mk3Vt5cB7lwz75wpqlYqV3zi2SIXLrLXe6TcT09K8+ iw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dqj05gxx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 22:35:15 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 22:35:13 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 20 Jan 2022 22:35:13 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 83A333F7095;
        Thu, 20 Jan 2022 22:35:10 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 6/9] octeontx2-af: Increase link credit restore polling timeout
Date:   Fri, 21 Jan 2022 12:04:44 +0530
Message-ID: <1642746887-30924-7-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
References: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: s_Iv-ck7ty59OV1f0zrgjtiKoRK18zeB
X-Proofpoint-ORIG-GUID: s_Iv-ck7ty59OV1f0zrgjtiKoRK18zeB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

It's been observed that sometimes link credit restore takes
a lot of time than the current timeout. This patch increases
the default timeout value and return the proper error value
on failure.

Fixes: 1c74b89171c3 ("octeontx2-af: Wait for TX link idle for credits change")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h    | 1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 4e79e91..58e2aee 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -732,6 +732,7 @@ enum nix_af_status {
 	NIX_AF_ERR_BANDPROF_INVAL_REQ  = -428,
 	NIX_AF_ERR_CQ_CTX_WRITE_ERR  = -429,
 	NIX_AF_ERR_AQ_CTX_RETRY_WRITE  = -430,
+	NIX_AF_ERR_LINK_CREDITS  = -431,
 };
 
 /* For NIX RX vtag action  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index de6e5a1..97fb619 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3891,8 +3891,8 @@ nix_config_link_credits(struct rvu *rvu, int blkaddr, int link,
 			    NIX_AF_TL1X_SW_XOFF(schq), BIT_ULL(0));
 	}
 
-	rc = -EBUSY;
-	poll_tmo = jiffies + usecs_to_jiffies(10000);
+	rc = NIX_AF_ERR_LINK_CREDITS;
+	poll_tmo = jiffies + usecs_to_jiffies(200000);
 	/* Wait for credits to return */
 	do {
 		if (time_after(jiffies, poll_tmo))
-- 
2.7.4

