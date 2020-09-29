Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA6327C11F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgI2J2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:28:54 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26470 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728050AbgI2J2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 05:28:49 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T9OYcE010727;
        Tue, 29 Sep 2020 02:28:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=rF/uD6YoP6dYXq8eBQIB7/Ntz22D0wKHeL/3T+AmwQg=;
 b=R1d34MbY2nHXyM6+tSzFlX+kE5oLF/krU6pOfyAEffUSxFc0/4Kpkd76eFk5gPyt+x49
 Cp3zRv7c3GhFuaGXxqtLOlk2fXsRP+82HVGJm70NkZPbAEP5eqrsx8iF8yWQGuB8XzNt
 UkVfiQ2N4cA1bkc3xW4O+R4zQPtMQL5YL0CTXA8LAKLzA0LVTIELeJO0Ibp/MsI2k7rM
 hIaSxB5IxViuCToqV1EUklY7fxUBzWmWD/DvS/SsHi832CQH23F6eJzLBhFK2Wi2UTGt
 eLsN7TksEEtm7M/1yAQso5RpEGZbLktt+zrzhMZh26omNwTxIa8Ub4+wQy8uEZW7vaj9 Gw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemb7xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 02:28:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 02:28:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 02:28:46 -0700
Received: from yoga.marvell.com (unknown [10.95.131.226])
        by maili.marvell.com (Postfix) with ESMTP id 6285E3F703F;
        Tue, 29 Sep 2020 02:28:44 -0700 (PDT)
From:   Stanislaw Kardach <skardach@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     <kda@semihalf.com>, Satha Rao <skoteshwar@marvell.com>
Subject: [PATCH net-next 4/7] octeontx2-af: fix Extended DSA and eDSA parsing
Date:   Tue, 29 Sep 2020 11:28:17 +0200
Message-ID: <20200929092820.22487-5-skardach@marvell.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200929092820.22487-1-skardach@marvell.com>
References: <20200929092820.22487-1-skardach@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Satha Rao <skoteshwar@marvell.com>

KPU profile interpret Extended DSA and eDSA by looking source dev. This
was incorrect and it restricts to use few source device ids and also
created confusion while parsing regular DSA tag. With below patch lookup
was based on bit 12 of Word0. This is always zero for DSA tag and it
should be one for Extended DSA and eDSA.

Signed-off-by: Satha Rao <skoteshwar@marvell.com>
Acked-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index adc94bab9cba..55264a8a25a3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -988,7 +988,7 @@ static const struct npc_kpu_profile_action ikpu_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		12, 16, 20, 0, 0,
+		12, 14, 20, 0, 0,
 		NPC_S_KPU1_EXDSA, 0, 0,
 		NPC_LID_LA, NPC_LT_NA,
 		0,
@@ -1360,10 +1360,10 @@ static const struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 	},
 	{
 		NPC_S_KPU1_EXDSA, 0xff,
-		NPC_DSA_EXTEND,
-		NPC_DSA_EXTEND,
 		0x0000,
 		0x0000,
+		NPC_DSA_EXTEND,
+		NPC_DSA_EXTEND,
 		0x0000,
 		0x0000,
 	},
-- 
2.20.1

