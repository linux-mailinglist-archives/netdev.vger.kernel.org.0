Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9BC215AE9
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgGFPj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:39:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24922 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729545AbgGFPj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:39:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066FaWY2025630;
        Mon, 6 Jul 2020 08:39:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=EoDuoExP13w77m6UR3ub2kw1eemJJKx7likKNCxb/Bg=;
 b=JzAHPxDHfuuyL6EzCt6FVA7Yh/7Mxc9suiqkURVYOEjDTMyBRFzWBaKH/mqCoqJk7N/W
 bM+h1kkiXtagnU3+wawM5PcEXiEJcMaJIUlzKuFk9kUXnDIQsyhq5r8qZYIrRj0sFmAV
 T1BxvhAV42FzFAnJ2duX/VN26DbT2mix5cDE8lE3FTZvFgSYb+J16slyxIM1Cp1cCliM
 mehBsabOjpNlx6Uap6D+UXcb3u4StKLFFToodUYBy2moqAtDLL1JgpXjB2kfFYuMNMfo
 zr6Ms2AyGa5Carw3Sb1D9FxethhoLUTcZ1xEg9SqfYd3dL4gphjzTa3C9I0Nt4C5KSKy Wg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 322q4pqm8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 08:39:25 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jul
 2020 08:39:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 08:39:24 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id A199B3F7040;
        Mon,  6 Jul 2020 08:39:20 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 9/9] net: qede: fix BE vs CPU comparison
Date:   Mon, 6 Jul 2020 18:38:21 +0300
Message-ID: <20200706153821.786-10-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706153821.786-1-alobakin@marvell.com>
References: <20200706153821.786-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_12:2020-07-06,2020-07-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flow Dissector's keys are mostly Network / Big Endian. U{16,32}_MAX are
the same in either of byteorders, but let's make sparse happy with
wrapping them into noops.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index db17a675bd02..d8100434e340 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1764,8 +1764,8 @@ qede_flow_parse_ports(struct qede_dev *edev, struct flow_rule *rule,
 		struct flow_match_ports match;
 
 		flow_rule_match_ports(rule, &match);
-		if ((match.key->src && match.mask->src != U16_MAX) ||
-		    (match.key->dst && match.mask->dst != U16_MAX)) {
+		if ((match.key->src && match.mask->src != htons(U16_MAX)) ||
+		    (match.key->dst && match.mask->dst != htons(U16_MAX))) {
 			DP_NOTICE(edev, "Do not support ports masks\n");
 			return -EINVAL;
 		}
@@ -1817,8 +1817,8 @@ qede_flow_parse_v4_common(struct qede_dev *edev, struct flow_rule *rule,
 		struct flow_match_ipv4_addrs match;
 
 		flow_rule_match_ipv4_addrs(rule, &match);
-		if ((match.key->src && match.mask->src != U32_MAX) ||
-		    (match.key->dst && match.mask->dst != U32_MAX)) {
+		if ((match.key->src && match.mask->src != htonl(U32_MAX)) ||
+		    (match.key->dst && match.mask->dst != htonl(U32_MAX))) {
 			DP_NOTICE(edev, "Do not support ipv4 prefix/masks\n");
 			return -EINVAL;
 		}
-- 
2.25.1

