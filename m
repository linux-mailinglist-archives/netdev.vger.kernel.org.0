Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A35226E54
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbgGTSdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:33:11 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24512 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730570AbgGTSdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:33:10 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KIG879015959;
        Mon, 20 Jul 2020 11:33:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=bGreeV2Lqk83ABngTrDONwzzqHM/IR3EJd2wU+9kbQs=;
 b=mThE+3Z2eZOZ3aWXtoyMPjPDt5njCx0U8RGKVsSgj0zeJjn54JlG8U8ZKc71qSjZwtdn
 43mfFnppsM9f4HdbjMA0XwMKRkOjqjU10PE1ycB+MpmU5C9277UMOlaQ/y0S9FQsxrqV
 kZWNw82AvfWVYfYyraIki9jPOIQyI3tpGiSKQvkkZboKXukfeHqIHT40gVg9TeDsayDt
 CaWYXcmNcaM305EApGEJDSAscCiYSJJUP0jJyRD1C/3RfFDU+zoPN/SYt8LLsx5Fsjm5
 dz7UfHrcm5KqUlnwcYGycJwXIWQY6EfQpyYPsxcfcWP5i0yPNVVT2rGXjpKiSjXBaGFP Rw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxeng0gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:33:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:33:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:33:08 -0700
Received: from NN-LT0044.marvell.com (NN-LT0044.marvell.com [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id 886663F703F;
        Mon, 20 Jul 2020 11:33:06 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
Subject: [PATCH v3 net-next 08/13] net: atlantic: enable ipv6 support for TCP LSO and UDP GSO
Date:   Mon, 20 Jul 2020 21:32:39 +0300
Message-ID: <20200720183244.10029-9-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200720183244.10029-1-mstarovoitov@marvell.com>
References: <20200720183244.10029-1-mstarovoitov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>

This patch enables ipv6 support for TCP LSO and UDP GSO.
The code itself (aq_nic_map_skb) was ready for this after udp gso feature,
but corresponding NETIF_F_TSO6 wasn't enabled.

We now have tested both tcp and udp v6 GSO, and enabling them safely.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c           | 2 +-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index d72f40259715..c6b0981c8751 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -371,7 +371,7 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 	self->ndev->features = aq_hw_caps->hw_features;
 	self->ndev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
 				     NETIF_F_RXHASH | NETIF_F_SG |
-				     NETIF_F_LRO | NETIF_F_TSO;
+				     NETIF_F_LRO | NETIF_F_TSO | NETIF_F_TSO6;
 	self->ndev->gso_partial_features = NETIF_F_GSO_UDP_L4;
 	self->ndev->priv_flags = aq_hw_caps->hw_priv_flags;
 	self->ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 97672ff142a8..51c8962b7a0e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -40,6 +40,7 @@
 			NETIF_F_RXHASH |  \
 			NETIF_F_SG |      \
 			NETIF_F_TSO |     \
+			NETIF_F_TSO6 |    \
 			NETIF_F_LRO |     \
 			NETIF_F_NTUPLE |  \
 			NETIF_F_HW_VLAN_CTAG_FILTER | \
-- 
2.25.1

