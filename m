Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5834119A77
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfLJV4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:56:37 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16978 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726417AbfLJV4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:56:36 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBALuLTg018139;
        Tue, 10 Dec 2019 13:56:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=mdmDe3ptmKcXFOZpNuZhn9ib40l9o8JWYwvKl30NJ1M=;
 b=kB9Ryys9682CkYUs7I+4LHJn3VguidDSnTg6j7+hqQQIYMnr2KBZontkBmvf/KyzZG3j
 8wKl7yngXe/27nOOV2VMVbj5aDeNAFJvWggXLTGQYdHopCY/o7jxSxX4922tYry8e20F
 6NCLIetWYNTcvtLr1sC43HWRzyuXDq5gb54Xx5ztDZB6vXzkcBh1MnK2/Gf5Erg8+DY+
 c/ENnCeiCg8LEZDBNa7J2fOgyhTO9ISyQDS1nhkYIQTxEemZ1X2x/8ceGUJQc3oxE23Y
 k0sJFFGDzvwfLHYtv8Z3fiM81EWPGHJuWorvCgstRCwa0NycUMxc+NZelo7buUD3v35J LQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wtbqg28hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 13:56:34 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 10 Dec
 2019 13:56:32 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 10 Dec 2019 13:56:32 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5C7103F7040;
        Tue, 10 Dec 2019 13:56:32 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBALuW2A023995;
        Tue, 10 Dec 2019 13:56:32 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBALuWN2023994;
        Tue, 10 Dec 2019 13:56:32 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <skalluru@marvell.com>
Subject: [PATCH net 2/2] bnx2x: Fix logic to get total no. of PFs per engine
Date:   Tue, 10 Dec 2019 13:56:23 -0800
Message-ID: <20191210215623.23950-3-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191210215623.23950-1-manishc@marvell.com>
References: <20191210215623.23950-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_07:2019-12-10,2019-12-10 signatures=0
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

