Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A150443A1
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388805AbfFMQa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:30:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36954 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730901AbfFMIbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 04:31:10 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D8TIM8013638;
        Thu, 13 Jun 2019 01:31:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=mgLN0qxHJ00sxTZnEbub4SdhpkJH9/WQhQ58HFbb+lM=;
 b=dlAgzRaUXlou1MjkX+rM5BDwmg2jkZGW6GQsV6NAbX7XqVGDTxoWZxMiDLt896pwP+Sk
 kTnL9sjgi5kNrnmWw77RYqdtjaJSWNv9qRBgdu8F38kkshs2rZHIHsMEo2WWkliVyM81
 043WmYYuRnztptELxhcb5rYUcRiO9HAoyrm5xuJwH0iEWO52UbDa2IuekKrXfpZ9mPrA
 Rt8tdniO9kfFxnn8N6Ll9KWtmg1HuN+RVIgE6meoX3o8cQ3O6n2z3d76AOsxiWoKhKHA
 0VfoRgGguhoFVljr70AOwfAhZLGpD7xUEooXETDJErLjjK6biAjWyVHaCR2IxXLBVGbk Rw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2t3j8205qd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 01:31:08 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 13 Jun
 2019 01:31:07 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 13 Jun 2019 01:31:07 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 935E13F703F;
        Thu, 13 Jun 2019 01:31:06 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH net-next 3/4] qed: iWARP - Fix tc for MPA ll2 connection
Date:   Thu, 13 Jun 2019 11:29:42 +0300
Message-ID: <20190613082943.5859-4-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190613082943.5859-1-michal.kalderon@marvell.com>
References: <20190613082943.5859-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver needs to assign a lossless traffic class for the MPA ll2
connection to ensure no packets are dropped when returning from the
driver as they will never be re-transmitted by the peer.

Fixes: ae3488ff37dc ("qed: Add ll2 connection for processing unaligned MPA packets")
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 099177c6aca2..431688c236ed 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -2712,6 +2712,8 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 	data.input.rx_num_desc = n_ooo_bufs * 2;
 	data.input.tx_num_desc = data.input.rx_num_desc;
 	data.input.tx_max_bds_per_packet = QED_IWARP_MAX_BDS_PER_FPDU;
+	data.input.tx_tc = PKT_LB_TC;
+	data.input.tx_dest = QED_LL2_TX_DEST_LB;
 	data.p_connection_handle = &iwarp_info->ll2_mpa_handle;
 	data.input.secondary_queue = true;
 	data.cbs = &cbs;
-- 
2.14.5

