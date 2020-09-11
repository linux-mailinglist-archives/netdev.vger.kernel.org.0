Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9AB526625E
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgIKPoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:44:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51058 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726092AbgIKPki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:40:38 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08BDJhf3027622;
        Fri, 11 Sep 2020 06:21:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=pAOgqb6yFxNc4ilG3Yo3ZFkYRlvfXeINyZg9YFeZRcM=;
 b=iBlcGM75uZDD0J7HA4G0yZUmWNjdwsQPvCLir519XHrMmD02oZxl7Z3unWNrDfQY8aTx
 MkyLFVZ+A4oWWFBQb2GR+hccHgvi4gx2XFHVRI3SyM5JEm59vQ3T9reI4PvkDjPuQcWJ
 S6XLcL/xjdIZ/vaJfDXDFZyTdxqz29RPxyf2zvPdZBaHScZHECxuK5D+fi0BiRBIKa2Z
 uOvw8BcwwqpeIi7KsIMQovuF68NA3D7Q1oCbk7+MjwsQ98+bcLCIJtJSsHz2zL0F0VG2
 kGhPqYfq09Mko2goSwY09uNIIu0tiOUFxEZe2/sVuZ+7c75D+e6YIw9WaAzEMc4nDkql nQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81q9aw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 06:21:35 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 06:21:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Sep 2020 06:21:35 -0700
Received: from yoga.marvell.com (unknown [10.95.131.64])
        by maili.marvell.com (Postfix) with ESMTP id 7932B3F7043;
        Fri, 11 Sep 2020 06:21:33 -0700 (PDT)
From:   <skardach@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Stanislaw Kardach <skardach@marvell.com>
Subject: [PATCH net-next 1/3] octeontx2-af: fix LD CUSTOM LTYPE aliasing
Date:   Fri, 11 Sep 2020 15:21:22 +0200
Message-ID: <20200911132124.7420-2-skardach@marvell.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200911132124.7420-1-skardach@marvell.com>
References: <20200911132124.7420-1-skardach@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-11_04:2020-09-10,2020-09-11 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislaw Kardach <skardach@marvell.com>

Since LD contains LTYPE definitions tweaked toward efficient
NIX_AF_RX_FLOW_KEY_ALG(0..31)_FIELD(0..4) usage, the original location
of NPC_LT_LD_CUSTOM0/1 was aliased with MPLS_IN_* definitions.
Moving custom frame to value 6 and 7 removes the aliasing at the cost of
custom frames being also considered when TCP/UDP RSS algo is configured.

However since the goal of CUSTOM frames is to classify them to a
separate set of RQs, this cost is acceptable.

Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 3803af9231c6..c0ff5f70aa43 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -77,6 +77,8 @@ enum npc_kpu_ld_ltype {
 	NPC_LT_LD_ICMP,
 	NPC_LT_LD_SCTP,
 	NPC_LT_LD_ICMP6,
+	NPC_LT_LD_CUSTOM0,
+	NPC_LT_LD_CUSTOM1,
 	NPC_LT_LD_IGMP = 8,
 	NPC_LT_LD_ESP,
 	NPC_LT_LD_AH,
@@ -85,8 +87,6 @@ enum npc_kpu_ld_ltype {
 	NPC_LT_LD_NSH,
 	NPC_LT_LD_TU_MPLS_IN_NSH,
 	NPC_LT_LD_TU_MPLS_IN_IP,
-	NPC_LT_LD_CUSTOM0 = 0xE,
-	NPC_LT_LD_CUSTOM1 = 0xF,
 };
 
 enum npc_kpu_le_ltype {
-- 
2.20.1

