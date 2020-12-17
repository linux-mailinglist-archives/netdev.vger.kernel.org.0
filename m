Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1342DD88A
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbgLQSkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:40:46 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44102 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730006AbgLQSkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 13:40:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BHITo5n008598;
        Thu, 17 Dec 2020 10:37:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=ICK56uBNX2dDuWBYCdcKxEqr85RW+3jB3uacjPBZO/8=;
 b=hN6YCNx7kD4eH67QRKWOUZuhauWGYbgz1CTfmAR/FWLF38vBP5er8u9EolTTVIXy7jV1
 Iuayy9b2xqqyxSegmRgzusRo3O8AxWXv24VJxg3sE3FepgO2hiMnI07o9vojzPOrISem
 MI/Qd8RqpMxQoDgR/8L9y2AcOZxVpu+daQxnYm++XxNRSy4gn7ttMmqh4tm0Jwe2Aon9
 20swQcLBkx8VxdqAgcRIkwe7z1E5JyBzl88Qc4I89SEc0OoBgu7UsJA9V3adX26gg4cb
 7rpIJtL75CO5K9bPwMRojJni8htFDUl2AhyUz++JWoX8J+L4HgECDk0n1J2yKtB4wG/r ZA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35g4rp1ku2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:37:55 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 10:37:54 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 10:37:53 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 10:37:53 -0800
Received: from stefan-pc.marvell.com (unknown [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 5B2E93F703F;
        Thu, 17 Dec 2020 10:37:50 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@redhat.com>
Subject: [PATCH net v2] net: mvpp2: prs: fix PPPoE with ipv6 packet parse
Date:   Thu, 17 Dec 2020 20:37:46 +0200
Message-ID: <1608230266-22111-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_13:2020-12-15,2020-12-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Current PPPoE+IPv6 entry is jumping to 'next-hdr'
field and not to 'DIP' field as done for IPv4.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Reported-by: Liron Himi <lironh@marvell.com>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---

Changes in v2:
- Fix "fixes tag"

 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index b9e5b08..1a272c2 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -1655,8 +1655,9 @@ static int mvpp2_prs_pppoe_init(struct mvpp2 *priv)
 	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP6);
 	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP6,
 				 MVPP2_PRS_RI_L3_PROTO_MASK);
-	/* Skip eth_type + 4 bytes of IPv6 header */
-	mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN + 4,
+	/* Jump to DIP of IPV6 header */
+	mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN + 8 +
+				 MVPP2_MAX_L3_ADDR_SIZE,
 				 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
 	/* Set L3 offset */
 	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3,
-- 
1.9.1

