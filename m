Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9866F33DCA5
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240060AbhCPSfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:35:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63118 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240033AbhCPSee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 14:34:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12GIGx6B026702;
        Tue, 16 Mar 2021 11:34:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=yn4iPzpg32Epu/i/mGquC1QeI3MjfjIlAknIinXpfqo=;
 b=TpxlQeGckggFgfWhp0xTZEsjyEzMrhvMAaXRhZaLHquzjV1g0WS+hSBxG/t6ukEWHHaB
 Z41EqouDC8uiICGRyJ/dBcPnqjLdEMNAW9fq5Nmp4EPmYTnAD7aDewTKV9R8o0amYEyS
 lo2byINpKL6VMc6hFoy+dzXgeWTvIfIv4Ns7Fs5+Mwge5RUiRocsO0wvjeknWg1Deg8G
 FZa5M3q4gkonnYFxczsqHVhbJgytlRBvk65fVEmQEsYlwqAwvCXUoPvs/wXj0lDYreCa
 1c8jEMH+j0DdgVCnZlb7lORmbKLEWngNdDB0nMCW94v1wOLmlZeuNgu9JF/B68QJO9UC BA== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqsg81-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 11:34:30 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Mar 2021 14:34:28 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 14:34:28 -0400
Received: from dc5-eodlnx05.marvell.com (dc5-eodlnx05.marvell.com [10.69.113.147])
        by maili.marvell.com (Postfix) with ESMTP id 0B22C3F7040;
        Tue, 16 Mar 2021 11:34:28 -0700 (PDT)
From:   Bhaskar Upadhaya <bupadhaya@marvell.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
CC:     <davem@davemloft.net>, <bupadhaya@marvell.com>
Subject: [PATCH net 1/2] qede: fix to disable start_xmit functionality during self adapter test
Date:   Tue, 16 Mar 2021 11:34:09 -0700
Message-ID: <1615919650-4262-2-git-send-email-bupadhaya@marvell.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1615919650-4262-1-git-send-email-bupadhaya@marvell.com>
References: <1615919650-4262-1-git-send-email-bupadhaya@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_06:2021-03-16,2021-03-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

start_xmit function should not be called during the execution of self
adapter test, netif_tx_disable() gives this guarantee, since it takes
the transmit queue lock while marking the queue stopped.  This will
wait for the transmit function to complete before returning.

Fixes: 16f46bf054f8 ("qede: add implementation for internal loopback test.")
Signed-off-by: Bhaskar Upadhaya <bupadhaya@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 1560ad3d9290..f9702cc7bc55 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -1611,7 +1611,7 @@ static int qede_selftest_run_loopback(struct qede_dev *edev, u32 loopback_mode)
 		return -EINVAL;
 	}
 
-	qede_netif_stop(edev);
+	netif_tx_disable(edev->ndev);
 
 	/* Bring up the link in Loopback mode */
 	memset(&link_params, 0, sizeof(link_params));
@@ -1623,6 +1623,8 @@ static int qede_selftest_run_loopback(struct qede_dev *edev, u32 loopback_mode)
 	/* Wait for loopback configuration to apply */
 	msleep_interruptible(500);
 
+	qede_netif_stop(edev);
+
 	/* Setting max packet size to 1.5K to avoid data being split over
 	 * multiple BDs in cases where MTU > PAGE_SIZE.
 	 */
-- 
2.17.1

