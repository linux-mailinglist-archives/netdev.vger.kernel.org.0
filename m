Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2696EBE63
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 11:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjDWJ4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 05:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjDWJz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 05:55:56 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030A635A2;
        Sun, 23 Apr 2023 02:55:34 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33N4rD1P023177;
        Sun, 23 Apr 2023 02:55:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=MvKUifaDN0R/r8ga9RxdPP8lMzJVpDGVwvrqlyPPOoo=;
 b=RNp51MdfFhB/VZRvYQa3QvDjeobqq7OlBrt0jlutzIwobKkWUpGtiyvQkEeajWTN8G99
 6e+kp9ypAzWe9RAkaz2a3k8PLlETW7ADtccCLPUlOjIDYCyxRi7pKDGkmkNSunpMc+3F
 zcdBsKGtWUiipWtVgS2B4N5wTGq+6JYocwILDvwk2g+3YYdMjFJIempoUFdz9pbTCR/v
 1sz7W8qSUJgspiikXA+hyDggQ6D4J/zr0M4vSRFsURJKF1OVNTxF1GPv3N3cbGNUFn5a
 FxhuqCmM9MtptIdYhcgn6LzlEGgovd9KukSRnPcTUakQzMsoexll5qrbo6mIbrUEbkg6 eA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3p2pra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Apr 2023 02:55:28 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 23 Apr
 2023 02:55:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 23 Apr 2023 02:55:26 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id AD29E3F706A;
        Sun, 23 Apr 2023 02:55:22 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 7/9] octeontx2-pf: mcs: Clear stats before freeing resource
Date:   Sun, 23 Apr 2023 15:24:52 +0530
Message-ID: <20230423095454.21049-8-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230423095454.21049-1-gakula@marvell.com>
References: <20230423095454.21049-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: KzerrgJeW9QxqhvasNwDkhpvn7syDdtH
X-Proofpoint-GUID: KzerrgJeW9QxqhvasNwDkhpvn7syDdtH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-23_06,2023-04-21_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

When freeing MCS hardware resources like SecY, SC and
SA the corresponding stats needs to be cleared. Otherwise
previous stats are shown in newly created macsec interfaces.

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c    | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index f3140f466b37..a108f986be50 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -150,11 +150,20 @@ static void cn10k_mcs_free_rsrc(struct otx2_nic *pfvf, enum mcs_direction dir,
 				enum mcs_rsrc_type type, u16 hw_rsrc_id,
 				bool all)
 {
+	struct mcs_clear_stats *clear_req;
 	struct mbox *mbox = &pfvf->mbox;
 	struct mcs_free_rsrc_req *req;
 
 	mutex_lock(&mbox->lock);
 
+	clear_req = otx2_mbox_alloc_msg_mcs_clear_stats(mbox);
+	if (!clear_req)
+		goto fail;
+
+	clear_req->id = hw_rsrc_id;
+	clear_req->type = type;
+	clear_req->dir = dir;
+
 	req = otx2_mbox_alloc_msg_mcs_free_resources(mbox);
 	if (!req)
 		goto fail;
-- 
2.25.1

