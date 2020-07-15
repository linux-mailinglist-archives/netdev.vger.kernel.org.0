Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C66221199
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgGOPtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:49:16 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8124 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726715AbgGOPtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:49:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FFejf2017387;
        Wed, 15 Jul 2020 08:49:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=VHjAWX0Kinr3NunoqHpev+OawVrjp1HuqFupLVbCx7g=;
 b=vG0TPeRNaUcrYVQ6yMGedlJJ46xlW1IQxG123KGEKJmVGLFnAMZgFpy7qmhysJPKjZW/
 1EN0gupK/mW5cnU3Pd/kL2XStLebv+/WUK1L8CseeDWk7jI8Yh+NQg1c+fyQPQKAg6/R
 69x6S11ThF+OuwsyhgGM8t/Lr+EaIVd4o84sqi5WZfsBjJWvNI89jjiob6oYZ5jJY9vq
 Tbl+6IstmtAA/ZI//BEX0LExgDAVsQGMN/0bpnTBsCoVWIOv5KstbyrMy8I+GH16TYXI
 wn4Qld5d2AE4H1i+VoAqEKLy79slPjICBXGgYocTBriE6Ox+ME97NW6GWqdhXkf2/tL9 Hw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmhudnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 08:49:10 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 08:49:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 08:49:09 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 6BE6A3F7041;
        Wed, 15 Jul 2020 08:49:07 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 05/10] net: atlantic: enable ipv6 support for TCP LSO and UDP GSO
Date:   Wed, 15 Jul 2020 18:48:37 +0300
Message-ID: <20200715154842.305-6-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715154842.305-1-irusskikh@marvell.com>
References: <20200715154842.305-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 45d99c1a9635..9ca04d738aba 100644
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

