Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2D06E7313
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 08:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjDSGVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 02:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjDSGVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 02:21:14 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077525FEA;
        Tue, 18 Apr 2023 23:20:59 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33J3rEGb023194;
        Tue, 18 Apr 2023 23:20:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=ZlSrOLdBRNFKeLr7Ip+8w0eprD3EHpIspAhBFP9tXz8=;
 b=Oa2UuxlgKoKxhUQ+eiV8Oqe0lHGmuxnYfvntgab4w0p/t/9E+rYUefndp+3rWrQYPe7G
 gYPTmx6TTnOxFgX65xfrhqdTGe+ZYzc15L0cNh5iro2RTkiTB2q6D47N2SJiub0vYFWF
 VsKXy/ommzINNtdgxB8kMqo52HuhsTW3g60dQ27NVK04m721NcvCDcSGnprs9XtxkjIj
 sw1rNZGeVrjo52RK8WYL2Poicv7tHNAB84X+U8DHJq2tRSwF2ixRKNWx5AlEhibIG9JW
 Y2w/l9XbZ6dQiPqtZeb0m9iTh6qSZPsKZxZXfVUznuNVQt3RPTkuDu3Jr4/juJh38vjn gg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q28s0gmge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 23:20:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 18 Apr
 2023 23:20:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 18 Apr 2023 23:20:51 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id B43D13F705C;
        Tue, 18 Apr 2023 23:20:46 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <simon.horman@corigine.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v3 05/10] octeontx2-af: Add validation for lmac type
Date:   Wed, 19 Apr 2023 11:50:13 +0530
Message-ID: <20230419062018.286136-6-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419062018.286136-1-saikrishnag@marvell.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: qvfGANIWC7PoniY24ls-zSe9l8a4znw1
X-Proofpoint-ORIG-GUID: qvfGANIWC7PoniY24ls-zSe9l8a4znw1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_02,2023-04-18_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

Upon physical link change, firmware reports to the kernel about the
change along with the details like speed, lmac_type_id, etc.
Kernel derives lmac_type based on lmac_type_id received from firmware.

In a few scenarios, firmware returns an invalid lmac_type_id, which
is resulting in below kernel panic. This patch adds the missing
validation of the lmac_type_id field.

Internal error: Oops: 96000005 [#1] PREEMPT SMP
[   35.321595] Modules linked in:
[   35.328982] CPU: 0 PID: 31 Comm: kworker/0:1 Not tainted
5.4.210-g2e3169d8e1bc-dirty #17
[   35.337014] Hardware name: Marvell CN103XX board (DT)
[   35.344297] Workqueue: events work_for_cpu_fn
[   35.352730] pstate: 40400089 (nZcv daIf +PAN -UAO)
[   35.360267] pc : strncpy+0x10/0x30
[   35.366595] lr : cgx_link_change_handler+0x90/0x180

Fixes: 61071a871ea6 ("octeontx2-af: Forward CGX link notifications to PFs")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 724df6398bbe..bd77152bb8d7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1231,6 +1231,14 @@ static inline void link_status_user_format(u64 lstat,
 	linfo->an = FIELD_GET(RESP_LINKSTAT_AN, lstat);
 	linfo->fec = FIELD_GET(RESP_LINKSTAT_FEC, lstat);
 	linfo->lmac_type_id = FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, lstat);
+
+	if (linfo->lmac_type_id >= LMAC_MODE_MAX) {
+		dev_err(&cgx->pdev->dev, "Unknown lmac_type_id %d reported by firmware on cgx port%d:%d",
+			linfo->lmac_type_id, cgx->cgx_id, lmac_id);
+		strncpy(linfo->lmac_type, "Unknown", LMACTYPE_STR_LEN - 1);
+		return;
+	}
+
 	lmac_string = cgx_lmactype_string[linfo->lmac_type_id];
 	strncpy(linfo->lmac_type, lmac_string, LMACTYPE_STR_LEN - 1);
 }
-- 
2.25.1

