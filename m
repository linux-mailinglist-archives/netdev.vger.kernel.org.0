Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97D64C0EA6
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 09:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbiBWI6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 03:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBWI6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 03:58:19 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131457C162
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 00:57:52 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21N0xt1C015326;
        Wed, 23 Feb 2022 00:57:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=TrRKJU0iHTUd/cOXg3BSybPKlI3I3+qKcm/6WuTM/xU=;
 b=LB/BScKC2vtuhHEtAlnGQawRuqPejm8NTHgkH22qRCa2PV9YQHvvJCbfqGIOh/aP5b22
 LduCmFK+PA+685/gdxZNvlFH0r3A4jkfGN3v6KTAzHRYoBTJhdHbuW5WNlE3L2rLnzxQ
 6ddmQVdbyndouCK2akLy7fs1VVBZlBFo2iCt/oCSMghjS60vzdOzyx9secmUrEoKN2eM
 3g6NNszBgXnL/L8hMvI8LE4cWFn/qVYlxtLKEjF+fF+5c2iyyMlONkyam5yKS83IRFrP
 DNPcU8q5z0SucF45z6pZqsvS2xFm6pPTY0thn/3UuVbEveLPAwadI41sCtagTWdYKAGY cA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3edavgsqbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 00:57:44 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Feb
 2022 00:57:43 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Feb 2022 00:57:43 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0A5433F7079;
        Wed, 23 Feb 2022 00:57:43 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 21N8vWxC012066;
        Wed, 23 Feb 2022 00:57:32 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 21N8vMwx012065;
        Wed, 23 Feb 2022 00:57:22 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>, <palok@marvell.com>
Subject: [PATCH net] bnx2x: fix driver load from initrd
Date:   Wed, 23 Feb 2022 00:57:20 -0800
Message-ID: <20220223085720.12021-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: uDXeR1DEjutx8Gz7gEd6j4tjG1g-ICk1
X-Proofpoint-ORIG-GUID: uDXeR1DEjutx8Gz7gEd6j4tjG1g-ICk1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-23_03,2022-02-21_02,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0") added
new firmware support in the driver with maintaining older firmware
compatibility. However, older firmware was not added in MODULE_FIRMWARE()
which caused missing firmware files in initrd image leading to driver load
failure from initrd. This patch adds MODULE_FIRMWARE() for older firmware
version to have firmware files included in initrd.

Fixes: b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215627
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 774c1f1a..eedb48d 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -100,6 +100,9 @@
 MODULE_FIRMWARE(FW_FILE_NAME_E1);
 MODULE_FIRMWARE(FW_FILE_NAME_E1H);
 MODULE_FIRMWARE(FW_FILE_NAME_E2);
+MODULE_FIRMWARE(FW_FILE_NAME_E1_V15);
+MODULE_FIRMWARE(FW_FILE_NAME_E1H_V15);
+MODULE_FIRMWARE(FW_FILE_NAME_E2_V15);

 int bnx2x_num_queues;
 module_param_named(num_queues, bnx2x_num_queues, int, 0444);
--
1.8.3.1

