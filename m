Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60B421D52F
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbgGMLnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:43:05 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8336 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729668AbgGMLnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:43:03 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DBefjp024231;
        Mon, 13 Jul 2020 04:43:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=ajr1HUrg36fytDsqRsQ5IPheEX2ndtmE8O7Wm/6FaVg=;
 b=Fj+25xE2u/ygSngP51T2m6GzPBHIXnugMl9qaL4LHPuToW7gVY3xxj3QiLHaw2Me1MXt
 +rDXxJPspRPUHjnRss+ltCnKFyXk9Yd+RcWE6kp6jBQde+5ht0+UWgPiYqegTTYwFaRc
 anjD7AbCGDhEMX79kconrzm1puenbfKQgVRkndLAvfLrbgiTFnd3lm576OosQCenIfO0
 +yPAQg+V2JFD4DvAeFRUe0MROWxFGo4Gff7FF+xuogQaFY3tJBvY7SccjkVNBEQYSm38
 D5IXDvJ50Wg5MCy6zRdSEjovLmbDarsGF6RxXuV6lod2VRarTUMEEp+XDNG1xNo13Fgq /A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asn76mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Jul 2020 04:43:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 04:43:01 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 04:42:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Jul 2020 04:43:00 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.6.200.41])
        by maili.marvell.com (Postfix) with ESMTP id 6E1EE3F7040;
        Mon, 13 Jul 2020 04:42:57 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 05/10] net: atlantic: enable ipv6 support for TCP LSO and UDP GSO
Date:   Mon, 13 Jul 2020 14:42:28 +0300
Message-ID: <20200713114233.436-6-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713114233.436-1-irusskikh@marvell.com>
References: <20200713114233.436-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_10:2020-07-13,2020-07-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables ipv6 support for TCP LSO and UDP GSO.
The code itself (aq_nic_map_skb) was ready for this after udp gso feature,
but corresponding NETIF_F_TSO6 wasn't enabled.

We now have tested both tcp and udp v6 GSO, and enabling them safely.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c           | 2 +-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index f4c0aa818916..c47b8cb20bc3 100644
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
2.17.1

