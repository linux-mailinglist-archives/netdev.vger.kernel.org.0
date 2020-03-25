Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782D41928FC
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbgCYMxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:53:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14988 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727457AbgCYMxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 08:53:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PCoN0O009175;
        Wed, 25 Mar 2020 05:53:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=itwi2ToL4W7nzRJv58uWA0ZxMBFYMoP2GBorxev9bWc=;
 b=AC3kgUtVDjOsq7mbXinX/m1xuE+IJthzryo7N+NWZ+BK5mYvh/OVcSE42yS7enxmYWMQ
 WSTSlM1dkBWiXFIZxGX9S3FdJetGL1oJFfXBDwVT8xQBuCc3tA5hT29MTlQzvgZJN5TC
 XdiuF2g8JEOLl7g9uzAhfgtNx4BWTb1yrDEFcq5OH0MN5LFxZZuvTNZHO/Wqx+gdPUJK
 O3HRT0re7KY8PGC3x/LeROQ06Gl3zsM/UW5ovC0SgWIu3SJmwq9vZh6sczr+Y7oBFbgo
 y1+A/W+xdi2+W4RIjPweBpBAxHsnweN9hK9RHAVLTBHPVbBCPz2usHNihv4i85nh5O4P 8w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nrgjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 05:53:31 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 05:53:29 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 05:53:29 -0700
Received: from localhost.localdomain (unknown [10.9.16.55])
        by maili.marvell.com (Postfix) with ESMTP id 402033F7041;
        Wed, 25 Mar 2020 05:53:27 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 17/17] net: atlantic: add XPN handling
Date:   Wed, 25 Mar 2020 15:52:46 +0300
Message-ID: <20200325125246.987-18-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325125246.987-1-irusskikh@marvell.com>
References: <20200325125246.987-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_05:2020-03-24,2020-03-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch adds XPN handling.
Our driver doesn't support XPN, but we should still update a couple
of places in the code, because the size of 'next_pn' field has
changed.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 4bd283ba0d56..0b3e234a54aa 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -452,6 +452,9 @@ static int aq_mdo_add_secy(struct macsec_context *ctx)
 	u32 txsc_idx;
 	int ret = 0;
 
+	if (secy->xpn)
+		return -EOPNOTSUPP;
+
 	sc_sa = sc_sa_from_num_an(MACSEC_NUM_AN);
 	if (sc_sa == aq_macsec_sa_sc_not_used)
 		return -EINVAL;
@@ -556,6 +559,7 @@ static int aq_update_txsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 			  const struct macsec_tx_sa *tx_sa,
 			  const unsigned char *key, const unsigned char an)
 {
+	const u32 next_pn = tx_sa->next_pn_halves.lower;
 	struct aq_mss_egress_sakey_record key_rec;
 	const unsigned int sa_idx = sc_idx | an;
 	struct aq_mss_egress_sa_record sa_rec;
@@ -565,7 +569,7 @@ static int aq_update_txsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 	memset(&sa_rec, 0, sizeof(sa_rec));
 	sa_rec.valid = tx_sa->active;
 	sa_rec.fresh = 1;
-	sa_rec.next_pn = tx_sa->next_pn;
+	sa_rec.next_pn = next_pn;
 
 	ret = aq_mss_set_egress_sa_record(hw, &sa_rec, sa_idx);
 	if (ret)
@@ -889,6 +893,7 @@ static int aq_update_rxsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 			  const unsigned char *key, const unsigned char an)
 {
 	struct aq_mss_ingress_sakey_record sa_key_record;
+	const u32 next_pn = rx_sa->next_pn_halves.lower;
 	struct aq_mss_ingress_sa_record sa_record;
 	struct aq_hw_s *hw = nic->aq_hw;
 	const int sa_idx = sc_idx | an;
@@ -897,7 +902,7 @@ static int aq_update_rxsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 	memset(&sa_record, 0, sizeof(sa_record));
 	sa_record.valid = rx_sa->active;
 	sa_record.fresh = 1;
-	sa_record.next_pn = rx_sa->next_pn;
+	sa_record.next_pn = next_pn;
 
 	ret = aq_mss_set_ingress_sa_record(hw, &sa_record, sa_idx);
 	if (ret)
-- 
2.17.1

