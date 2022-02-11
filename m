Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626544B2974
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 16:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349429AbiBKPzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 10:55:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240763AbiBKPzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 10:55:51 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C02D196;
        Fri, 11 Feb 2022 07:55:50 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21B7wbaT013056;
        Fri, 11 Feb 2022 07:55:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=dWr+tSglDx+SxNcNWkY4QkhK2Es0TIOHiTqTfSn34L0=;
 b=TqJfnbO0dOKYNaX8TG4T/yllxqWoENzSU2JDZjstt3+0ph2Y8OpO1o2F6rgoONtcgLht
 eBaa2MkRGHiRLcnYXwph05ejp3dlNyi7Zu449WOnzcedGkLxta6i/Gue3Wz3Atmzb0+a
 0NVHyGM/gRGR1WWeLER8VySVjj3FCxwU3q6cC7e6XZKERNnpADfgMQxX8jt8LlMAeDg9
 Iq+m/QyMIDn59gCu0eIACjBWLf0EDzs83D3xGgV1sJhh+mLYX/k1cFds1mEDqmbqeW5w
 QO+Fhf0cbsNWFGhMNfQQ0u+2M4iJ61nPntlk1l6RgKRzZxy4u6Rx5rwLcxiWs55CaTqM IA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e5134e98j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 07:55:45 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Feb
 2022 07:55:43 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 11 Feb 2022 07:55:43 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id BF4683F7043;
        Fri, 11 Feb 2022 07:55:40 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH V2] octeontx2-af: fix array bound error
Date:   Fri, 11 Feb 2022 21:25:39 +0530
Message-ID: <20220211155539.13931-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: nUI8qYgSoa5e5qqkpw3uMI-KRDppvV40
X-Proofpoint-ORIG-GUID: nUI8qYgSoa5e5qqkpw3uMI-KRDppvV40
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes below error by using proper data type.

drivers/net/ethernet/marvell/octeontx2/af/rpm.c: In function
'rpm_cfg_pfc_quanta_thresh':
include/linux/find.h:40:23: error: array subscript 'long unsigned
int[0]' is partly outside array bounds of 'u16[1]' {aka 'short unsigned
int[1]'} [-Werror=array-bounds]
   40 |                 val = *addr & GENMASK(size - 1, offset);

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
---
v2 * add Reported-by tag

 drivers/net/ethernet/marvell/octeontx2/af/rpm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index d7a8aad46e12..47e83d7a5804 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -141,14 +141,15 @@ int rpm_lmac_get_pause_frm_status(void *rpmd, int lmac_id,
 	return 0;
 }

-static void rpm_cfg_pfc_quanta_thresh(rpm_t *rpm, int lmac_id, u16 pfc_en,
+static void rpm_cfg_pfc_quanta_thresh(rpm_t *rpm, int lmac_id,
+				      unsigned long pfc_en,
 				      bool enable)
 {
 	u64 quanta_offset = 0, quanta_thresh = 0, cfg;
 	int i, shift;

 	/* Set pause time and interval */
-	for_each_set_bit(i, (unsigned long *)&pfc_en, 16) {
+	for_each_set_bit(i, &pfc_en, 16) {
 		switch (i) {
 		case 0:
 		case 1:
--
2.17.1
