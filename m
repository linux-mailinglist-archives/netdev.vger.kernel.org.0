Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7442711BADF
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730828AbfLKSAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:00:09 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47506 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730743AbfLKSAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:00:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBI06bB023980;
        Wed, 11 Dec 2019 10:00:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=mdmDe3ptmKcXFOZpNuZhn9ib40l9o8JWYwvKl30NJ1M=;
 b=ulgonakmEz9t6wkomJCPfDieoRDDPIOQWQQ/GVLauNrTHkPjMh77kR+Rg9mjvOTcdu/x
 p+jPtfTXoy2EVNIsdxpmZKJGx9qTCfF41Uvd1n5Cxo5FFaFl22YPi1ATnPjjyxgZJqvg
 GFEGrH5pPOLpePFo4xTQcYYVpW5jUfeisFtOanjuNk63fK3k8/gqNVgpcwFX2fIMx2D+
 P0VZRNIQYB3fXyph1jOrSrkCIX4Co+9WZoLITbLYp6KtQoGjDaH/udiGXbLC9+HVCsaH
 SdbXyRk56ViyN7P7oi+8//5q+0V4ZjEMX/qwberd1Vt3r7pdLd8SWmXGmg/EymDRhhMJ Pg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wst5t284p-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 10:00:07 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 11 Dec
 2019 10:00:04 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 11 Dec 2019 10:00:04 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B8A1C3F704E;
        Wed, 11 Dec 2019 10:00:04 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBBI04PV012073;
        Wed, 11 Dec 2019 10:00:04 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBBI047Y012001;
        Wed, 11 Dec 2019 10:00:04 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <skalluru@marvell.com>
Subject: [PATCH v2 net 2/2] bnx2x: Fix logic to get total no. of PFs per engine
Date:   Wed, 11 Dec 2019 09:59:56 -0800
Message-ID: <20191211175956.11948-3-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191211175956.11948-1-manishc@marvell.com>
References: <20191211175956.11948-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_05:2019-12-11,2019-12-11 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver doesn't calculate total number of PFs configured on a
given engine correctly which messed up resources in the PFs
loaded on that engine, leading driver to exceed configuration
of resources (like vlan filters etc.) beyond the limit per
engine, which ended up with asserts from the firmware.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
index 8b08cb18e363..3f63ffd7561b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -1109,7 +1109,7 @@ static inline u8 bnx2x_get_path_func_num(struct bnx2x *bp)
 		for (i = 0; i < E1H_FUNC_MAX / 2; i++) {
 			u32 func_config =
 				MF_CFG_RD(bp,
-					  func_mf_config[BP_PORT(bp) + 2 * i].
+					  func_mf_config[BP_PATH(bp) + 2 * i].
 					  config);
 			func_num +=
 				((func_config & FUNC_MF_CFG_FUNC_HIDE) ? 0 : 1);
-- 
2.18.1

