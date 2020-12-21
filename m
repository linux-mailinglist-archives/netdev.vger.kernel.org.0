Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C3B2DFD19
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 15:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgLUO4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 09:56:43 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11646 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbgLUO4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 09:56:43 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BLEoGfw022091;
        Mon, 21 Dec 2020 06:56:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=g9Ds/7ffhqzh4ZTp7G8cA76fTF/sixWysoQH3p1zzS4=;
 b=bqP5sRmO6DsS/Nh8SpHwtTKXzIS49Nj5O4dak+HAkBVvPkNhGdcvSZFk2898y34ihGEd
 gIR0TENHECSHAXkXBc+pmA2wFmeAOKnIGm0WXFh37WDZL3GbRQzgpgmoXNTp1e2OzxWH
 yCrx5pTMWWooP2wPEeszRgcuUnn42eeydmWr6HyxaWM5tT8lE/kXdP2asaIRlvfHcvnz
 T/dQLCb0IMfkzVEDYYQ4NwfuSoXHy+DChwwCw0VvB10mzC0DKow6UjNzWU9pqXRI/77U
 9s1EjJSo3J+CLTnWewlqccJHbC3NJ0qxA6Qx9TeJzqnaNfymMl+Ju5ZmiWOU0uo8zXrj Uw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35j4wvjgdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 21 Dec 2020 06:55:59 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Dec
 2020 06:55:58 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Dec
 2020 06:55:57 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 21 Dec 2020 06:55:57 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 117B93F7040;
        Mon, 21 Dec 2020 06:55:57 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0BLEtuwM007816;
        Mon, 21 Dec 2020 06:55:56 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0BLEtuBQ007815;
        Mon, 21 Dec 2020 06:55:56 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <skalluru@marvell.com>
Subject: [PATCH net 1/1] qede: fix offload for IPIP tunnel packets
Date:   Mon, 21 Dec 2020 06:55:30 -0800
Message-ID: <20201221145530.7771-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-21_08:2020-12-21,2020-12-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPIP tunnels packets are unknown to device,
hence these packets are incorrectly parsed and
caused the packet corruption, so disable offlods
for such packets at run time.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Sudarsana Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index a2494bf..ca0ee29 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1799,6 +1799,11 @@ netdev_features_t qede_features_check(struct sk_buff *skb,
 			      ntohs(udp_hdr(skb)->dest) != gnv_port))
 				return features & ~(NETIF_F_CSUM_MASK |
 						    NETIF_F_GSO_MASK);
+		} else if (l4_proto == IPPROTO_IPIP) {
+			/* IPIP tunnels are unknown to the device or at least unsupported natively,
+			 * offloads for them can't be done trivially, so disable them for such skb.
+			 */
+			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 		}
 	}
 
-- 
1.8.3.1

