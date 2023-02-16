Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB846993B0
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 12:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjBPLzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 06:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBPLzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 06:55:07 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92C953574;
        Thu, 16 Feb 2023 03:55:06 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GAkbqV006122;
        Thu, 16 Feb 2023 03:54:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=bpTR0sa+6bkRJIVR9c8mDno+IelQ2999ac6hd0OZ9hU=;
 b=PgLPRh84gv4a95XWGDuEsKCyXuI0WaodIkZJUM8JzxjaXyw9rXOKittJoGTR2IXKYur4
 ygIgjusH31oDFiW5ZNldx5GfxgIGNDYVviFX6Lw1pHZSPSpH8CAdwUZFxuh9bQNBGQXD
 loE43AwdKhhLmVUftqM8i2f1cwzFSnbfUin23YtWu7Imoc9f1tn+i+bUzYjNyCJOO+wr
 qp63lHuAHty9R8HW95comk0/CbE7FNuC3KpbjJVUpA1O5JocuiKrDQKjMzyrDz6Rfr4q
 arX2bEFCdl93uNQkalexMnJb4SK8i7Khe+bejK8yuj1vNnEJLNFRM5J+jw9rQ8AHR09Y CA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3nsg888k4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 03:54:58 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 16 Feb
 2023 03:54:57 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Thu, 16 Feb 2023 03:54:57 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EADD43F7066;
        Thu, 16 Feb 2023 03:54:56 -0800 (PST)
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <stable@vger.kernel.org>, Bhaskar Upadhaya <bupadhaya@marvell.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net] qede: fix interrupt coalescing configuration
Date:   Thu, 16 Feb 2023 03:54:47 -0800
Message-ID: <20230216115447.17227-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: w3VtRq2e7bi6OMJ2vgBgEtMPtcT9MbAY
X-Proofpoint-GUID: w3VtRq2e7bi6OMJ2vgBgEtMPtcT9MbAY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_09,2023-02-16_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On default driver load device gets configured with unexpected
higher interrupt coalescing values instead of default expected
values as memory allocated from krealloc() is not supposed to
be zeroed out and may contain garbage values.

Fix this by allocating the memory of required size first with
kcalloc() and then use krealloc() to resize and preserve the
contents across down/up of the interface.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Fixes: b0ec5489c480 ("qede: preserve per queue stats across up/down of interface")
Cc: stable@vger.kernel.org
Cc: Bhaskar Upadhaya <bupadhaya@marvell.com>
Cc: David S. Miller <davem@davemloft.net>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2160054
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 953f304b8588..af39513db1ba 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -970,8 +970,15 @@ static int qede_alloc_fp_array(struct qede_dev *edev)
 		goto err;
 	}
 
-	mem = krealloc(edev->coal_entry, QEDE_QUEUE_CNT(edev) *
-		       sizeof(*edev->coal_entry), GFP_KERNEL);
+	if (!edev->coal_entry) {
+		mem = kcalloc(QEDE_MAX_RSS_CNT(edev),
+			      sizeof(*edev->coal_entry), GFP_KERNEL);
+	} else {
+		mem = krealloc(edev->coal_entry,
+			       QEDE_QUEUE_CNT(edev) * sizeof(*edev->coal_entry),
+			       GFP_KERNEL);
+	}
+
 	if (!mem) {
 		DP_ERR(edev, "coalesce entry allocation failed\n");
 		kfree(edev->coal_entry);
-- 
2.27.0

