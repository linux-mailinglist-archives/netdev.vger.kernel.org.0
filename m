Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D804B12D9
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244258AbiBJQgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:36:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244254AbiBJQgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:36:06 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E0F1A8;
        Thu, 10 Feb 2022 08:36:07 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21AAJL0J008359;
        Thu, 10 Feb 2022 08:36:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=+YXeHLopDlrVI9hkQTBypubMSt1yVf2ZrvrNt0+T0pc=;
 b=WQ1/S+3WfAQz19ta23v1dpXtwFOslCeIlCjDyynztfW32Io1qrDo+eCg5tJwLilsFVdT
 zBl0q3r+y+kPeoIpM4HcbwkwOI+9+r3pEsxwHTtj3RXHF4SUD2ZWa+SehXoONQ+hPVFH
 OVogL1e161aujkvbTaL5hdl7XE+eXQ+QbmR623Y09YUjLAhq7XdDft8zJd96b+lrfUe0
 W8ERQ29pxYUHqA/FT3oH+leN9nlsn4FPrL5jhCydBTg75orSMIZTMDq6KLwDsC87qvNl
 Qt+gQnIohFr1rUGBh9RbcbEjAvnN449fshRHGDhX11nhW3+Hey8hyHZ42zqtFmDaWwFC PA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3e50uc9mga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 08:36:04 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 08:36:02 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 10 Feb 2022 08:36:02 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 097D73F706B;
        Thu, 10 Feb 2022 08:35:58 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH] octeontx2-af: fix array bound error
Date:   Thu, 10 Feb 2022 22:05:57 +0530
Message-ID: <20220210163557.7256-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 1xIyoBmz22_zbQOTThAQXlOzR5aC6Bye
X-Proofpoint-ORIG-GUID: 1xIyoBmz22_zbQOTThAQXlOzR5aC6Bye
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_07,2022-02-09_01,2021-12-02_01
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

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
---
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

