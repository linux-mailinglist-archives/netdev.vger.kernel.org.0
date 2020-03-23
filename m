Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C2A18F579
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 14:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgCWNP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 09:15:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12316 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728426AbgCWNP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 09:15:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ND6OGd010599;
        Mon, 23 Mar 2020 06:15:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=4tRVerfTUmvExULVhvv03GDgv4tbrQtjBQEwIX/LA9Q=;
 b=kNdCotXmmPxnXQpd0/1/uSq9zLi1xut9+o4hG9KvhqvnsUGzrl8mWFuF2BGlBlJLCUJs
 YdSxBpELVtq5UT9TSyJ5fW1lesKFsXLBio+8vwRTGHD7E6XIX8hx36mmRjXloTPP8V2V
 NZ9Frv+PW6H6xrLQ4fm/H9KWnmLjobss+BrFjOj8VrKSdTZ2k7Km9C7KM5krJgjKkNhN
 qeV4M95oQyd7y+SuFmLUT/4UyMV7kd61XBtqLuUHnvQCem6XOC/qJrDmFICk8nbIYBQr
 lhI5XVBbdigsce0kI97RVEwqfc5k2q+mEC/LrOBivz8ycZ5I5OF1dCwDYIXMf6FRsiRH mw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nefsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 06:15:22 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Mar
 2020 06:15:21 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Mar
 2020 06:15:20 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Mar 2020 06:15:20 -0700
Received: from localhost.localdomain (unknown [10.9.16.91])
        by maili.marvell.com (Postfix) with ESMTP id ED32C3F703F;
        Mon, 23 Mar 2020 06:15:18 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 17/17] net: atlantic: add XPN handling
Date:   Mon, 23 Mar 2020 16:13:48 +0300
Message-ID: <20200323131348.340-18-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323131348.340-1-irusskikh@marvell.com>
References: <20200323131348.340-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_04:2020-03-21,2020-03-23 signatures=0
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
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index dc1da79b8b26..bc23b8bf4a72 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -461,6 +461,9 @@ static int aq_mdo_add_secy(struct macsec_context *ctx)
 	u32 txsc_idx;
 	int ret = 0;
 
+	if (secy->xpn)
+		return -EOPNOTSUPP;
+
 	sc_sa = sc_sa_from_num_an(MACSEC_NUM_AN);
 	if (sc_sa == aq_macsec_sa_sc_not_used)
 		return -EINVAL;
@@ -567,6 +570,7 @@ static int aq_update_txsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 			  const struct macsec_tx_sa *tx_sa,
 			  const unsigned char *key, const unsigned char an)
 {
+	const u32 next_pn = tx_sa->next_pn_halves.lower;
 	struct aq_mss_egress_sakey_record key_rec;
 	const unsigned int sa_idx = sc_idx | an;
 	struct aq_mss_egress_sa_record sa_rec;
@@ -574,12 +578,12 @@ static int aq_update_txsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 	int ret = 0;
 
 	netdev_dbg(nic->ndev, "set tx_sa %d: active=%d, next_pn=%d\n", an,
-		   tx_sa->active, tx_sa->next_pn);
+		   tx_sa->active, next_pn);
 
 	memset(&sa_rec, 0, sizeof(sa_rec));
 	sa_rec.valid = tx_sa->active;
 	sa_rec.fresh = 1;
-	sa_rec.next_pn = tx_sa->next_pn;
+	sa_rec.next_pn = next_pn;
 
 	ret = aq_mss_set_egress_sa_record(hw, &sa_rec, sa_idx);
 	if (ret) {
@@ -941,18 +945,19 @@ static int aq_update_rxsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 			  const unsigned char *key, const unsigned char an)
 {
 	struct aq_mss_ingress_sakey_record sa_key_record;
+	const u32 next_pn = rx_sa->next_pn_halves.lower;
 	struct aq_mss_ingress_sa_record sa_record;
 	struct aq_hw_s *hw = nic->aq_hw;
 	const int sa_idx = sc_idx | an;
 	int ret = 0;
 
 	netdev_dbg(nic->ndev, "set rx_sa %d: active=%d, next_pn=%d\n", an,
-		   rx_sa->active, rx_sa->next_pn);
+		   rx_sa->active, next_pn);
 
 	memset(&sa_record, 0, sizeof(sa_record));
 	sa_record.valid = rx_sa->active;
 	sa_record.fresh = 1;
-	sa_record.next_pn = rx_sa->next_pn;
+	sa_record.next_pn = next_pn;
 
 	ret = aq_mss_set_ingress_sa_record(hw, &sa_record, sa_idx);
 	if (ret) {
-- 
2.17.1

