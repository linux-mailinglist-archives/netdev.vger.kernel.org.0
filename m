Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4F7661E9D
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 07:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbjAIGNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 01:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjAIGNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 01:13:45 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217AEA197;
        Sun,  8 Jan 2023 22:13:44 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 308McDcN018600;
        Sun, 8 Jan 2023 22:13:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=0oXfUSucqDnprNu/xjDfCXx1MiNwuNLq5i0naIl8Ado=;
 b=eKIFupSz/vaiFF0HGQIZpg3G3SVaivFMcIqb6Z+zyWVYh76DmJ7aN6Gd3RM4h8Bz7z8S
 +lg6gI7CTteNj9ZRohtn4f27yjuWcN+84I5wVokqmf77OEXXmg9J6q7u5tlXnJSSgUIK
 uS3WpWHsYhyHTFE3swfWuOvJLm79R2AdOmWRzrAYiMUxS/iLftNFwT7MdnDqaeZji5zV
 8szZ9ER6PDK6KUkEkRs+tEq1I4H0rVNlIRDUPNLf1U4IwivWBqYbi49AluA3TnBOGiGE
 b4FmuHkgUTQqsAazjmmuDQvWroq2iF776uRdUu84hOlFKcd3qnpGS6gbPPAiZUZ6r2bu Xw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3my94tmbgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 08 Jan 2023 22:13:31 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sun, 8 Jan
 2023 22:13:29 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Sun, 8 Jan 2023 22:13:29 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 6D7E93F7090;
        Sun,  8 Jan 2023 22:13:26 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>
Subject: [net PATCH] octeontx2-pf: Fix resource leakage in VF driver unbind
Date:   Mon, 9 Jan 2023 11:43:25 +0530
Message-ID: <20230109061325.21395-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: D2BdtYno9FprCMkB1oCNyC5ZRHhCIqe_
X-Proofpoint-GUID: D2BdtYno9FprCMkB1oCNyC5ZRHhCIqe_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_02,2023-01-06_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

resources allocated like mcam entries to support the Ntuple feature
and hash tables for the tc feature are not getting freed in driver
unbind. This patch fixes the issue.

Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 86653bb8e403..7f8ffbf79cf7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -758,6 +758,8 @@ static void otx2vf_remove(struct pci_dev *pdev)
 	if (vf->otx2_wq)
 		destroy_workqueue(vf->otx2_wq);
 	otx2_ptp_destroy(vf);
+	otx2_mcam_flow_del(vf);
+	otx2_shutdown_tc(vf);
 	otx2vf_disable_mbox_intr(vf);
 	otx2_detach_resources(&vf->mbox);
 	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
-- 
2.17.1

