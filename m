Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775372DD617
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 18:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgLQR0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 12:26:37 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11470 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727857AbgLQR03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 12:26:29 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BHHFFcc026081;
        Thu, 17 Dec 2020 09:23:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=bUjvrhhlh5VC7Y0BrD+JA5BY1eaGYhuovf7E4ET6iKU=;
 b=A4G07+qg2fzQqGuRYcX4UkUWMUJAPfm2qOF87iGPD53aVVvTpDGUtKxD+Lbykdx+8nZP
 gQfrxiGqoe2/cn0yyI6owD/t/3lbf3KUtyFKzpUxRczzYKZp+cUwdBHmlTkezJ7FKhNf
 urEL/qLWbvCk3gvKBDGMgmqNKj0OXSvcGhS0pUiJ4B+s8oYdm1HcHhC5dO5VSBu7nppm
 aCBZUbrYOkbNEYfL6n8Wn3Zw8v4S+NfxMQfHetSOZm8CmSO0+qaEzN4g564EJQGJrzq8
 zlEougBk1h5uQobjainVre+XZc2NsQ6ronNaqblZdcHfRkAn5gurxC3TZqrwspvVFTFb 3A== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35cx8tgchc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 09:23:33 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 09:23:31 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 09:23:31 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 09:23:31 -0800
Received: from stefan-pc.marvell.com (unknown [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 3FE7B3F703F;
        Thu, 17 Dec 2020 09:23:28 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <lironh@marvell.com>
Subject: [PATCH net] net: mvpp2: prs: fix PPPoE with ipv6 packet parse
Date:   Thu, 17 Dec 2020 19:23:11 +0200
Message-ID: <1608225791-13127-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_11:2020-12-15,2020-12-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Current PPPoE+IPv6 entry is jumping to 'next-hdr'
field and not to 'DIP' field as done for IPv4.

Fixes: db9d7d36eecc ("net: mvpp2: Split the PPv2 driver to a dedicated directory")
Reported-by: Liron Himi <lironh@marvell.com>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
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

