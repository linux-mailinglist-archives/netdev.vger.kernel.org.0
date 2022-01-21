Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97234959FF
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378723AbiAUGf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:35:27 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39020 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378728AbiAUGfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:35:25 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L068YP029629;
        Thu, 20 Jan 2022 22:35:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=dJaiqrOQp5HEnwE+VlEn5NG9f2e5CPbqmQXOEUzkA68=;
 b=QApY4cqZQ3MTU3NQm6/dWnGjcRo/ocTRx9Cq9tCX359CG+w2/sM9LZP/TCtUUK3g+gIR
 cGBv0rTq06eiwg7btqqC5+bBBPHzjICCoRlS8azeJBODRcNur0Ol1DbXHogzqeNyhSDL
 q5JZdt/DSMIsrNAHfqmtsO0rPfQLFbPSn55ZTEv1qr5MSPMCPsoj3x62nv+pwkgrG0jK
 r6pDnOVKxLanRbv46hh21VmsgjxZXz9TJ0DvyWo8qOPuJrna6ErgckIySH1zRePXBj8d
 526ZYoVtjRWofRQw5ElJBo9RZFgLJ1SZQKXpYcJXSv6QtbJbM+aBfaJnyxjv1Xn3CaV6 ZA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dqj05gxxw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 22:35:21 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Jan
 2022 22:35:20 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Jan 2022 22:35:20 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 235693F70A0;
        Thu, 20 Jan 2022 22:35:16 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 8/9] octeontx2-pf: Forward error codes to VF
Date:   Fri, 21 Jan 2022 12:04:46 +0530
Message-ID: <1642746887-30924-9-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
References: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: LL9IXSFzf-o4iujNT_1e2xQnYTV2XR6j
X-Proofpoint-ORIG-GUID: LL9IXSFzf-o4iujNT_1e2xQnYTV2XR6j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PF forwards its VF messages to AF and corresponding
replies from AF to VF. AF sets proper error code in the
replies after processing message requests. Currently PF
checks the error codes in replies and sends invalid
message to VF. This way VF lacks the information of
error code set by AF for its messages. This patch
changes that such that PF simply forwards AF replies
so that VF can handle error codes.

Fixes: d424b6c02415 ("octeontx2-pf: Enable SRIOV and added VF mbox handling")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 6080ebd..d39341e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -394,7 +394,12 @@ static int otx2_forward_vf_mbox_msgs(struct otx2_nic *pf,
 		dst_mdev->msg_size = mbox_hdr->msg_size;
 		dst_mdev->num_msgs = num_msgs;
 		err = otx2_sync_mbox_msg(dst_mbox);
-		if (err) {
+		/* Error code -EIO indicate there is a communication failure
+		 * to the AF. Rest of the error codes indicate that AF processed
+		 * VF messages and set the error codes in response messages
+		 * (if any) so simply forward responses to VF.
+		 */
+		if (err == -EIO) {
 			dev_warn(pf->dev,
 				 "AF not responding to VF%d messages\n", vf);
 			/* restore PF mbase and exit */
-- 
2.7.4

