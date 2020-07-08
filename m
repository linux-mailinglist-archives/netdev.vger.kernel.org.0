Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54772189F5
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 16:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbgGHOSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 10:18:01 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63318 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729468AbgGHOSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 10:18:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 068EFu9J014410;
        Wed, 8 Jul 2020 07:17:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=D6nmSWfWy5bSBQT2UH7xqHuqon/tMiiTzK5HS5iA6VQ=;
 b=xL8tvX5YfJC3U0OwoLSMyiLLY+M0SGwUYHxDpBdPL4Sp1PlDwDdz6GHDvHo2bNuId+L5
 ZKtpaougK0tSWtAGbfBpRXPjWj2gh4QtSHrwSpU8qblh0lzI9nEoeVqvmN+hC9GBMHmS
 nzguzueEQ/zzjXH/NQ4L09+FqSua45fnqEWM2PJ4Fbkfr/fvTwY7qTwqTof11aEacEqx
 z6yhSZyOzlu+7HsQmnGyE3UYulb7IHtZBgN5hE95ELIHalyT8gRls6b5GajUucdxWA7W
 C9A/e3auaeLQzdrVoLl3qG+E16lZq2zQMAwmKWLcZIS6f9BtyiOTHs1x0SOix11mF7eT EQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 322s9ng6a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 07:17:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 8 Jul
 2020 07:17:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 8 Jul 2020 07:17:54 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 6388F3F703F;
        Wed,  8 Jul 2020 07:17:51 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>,
        Egor Pomozov <epomozov@marvell.com>,
        "Sergey Samoilenko" <sergey.samoilenko@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: atlantic: fix ip dst and ipv6 address filters
Date:   Wed, 8 Jul 2020 17:17:10 +0300
Message-ID: <20200708141710.758-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_13:2020-07-08,2020-07-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch fixes ip dst and ipv6 address filters.
There were 2 mistakes in the code, which led to the issue:
* invalid register was used for ipv4 dst address;
* incorrect write order of dwords for ipv6 addresses.

Fixes: 23e7a718a49b ("net: aquantia: add rx-flow filter definitions")
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c    | 4 ++--
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index 3c8e8047ea1e..d775b23025c1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -1700,7 +1700,7 @@ void hw_atl_rpfl3l4_ipv6_src_addr_set(struct aq_hw_s *aq_hw, u8 location,
 	for (i = 0; i < 4; ++i)
 		aq_hw_write_reg(aq_hw,
 				HW_ATL_RPF_L3_SRCA_ADR(location + i),
-				ipv6_src[i]);
+				ipv6_src[3 - i]);
 }
 
 void hw_atl_rpfl3l4_ipv6_dest_addr_set(struct aq_hw_s *aq_hw, u8 location,
@@ -1711,7 +1711,7 @@ void hw_atl_rpfl3l4_ipv6_dest_addr_set(struct aq_hw_s *aq_hw, u8 location,
 	for (i = 0; i < 4; ++i)
 		aq_hw_write_reg(aq_hw,
 				HW_ATL_RPF_L3_DSTA_ADR(location + i),
-				ipv6_dest[i]);
+				ipv6_dest[3 - i]);
 }
 
 u32 hw_atl_sem_ram_get(struct aq_hw_s *self)
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
index 06220792daf1..7430ff025134 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
@@ -1360,7 +1360,7 @@
  */
 
  /* Register address for bitfield pif_rpf_l3_da0_i[31:0] */
-#define HW_ATL_RPF_L3_DSTA_ADR(filter) (0x000053B0 + (filter) * 0x4)
+#define HW_ATL_RPF_L3_DSTA_ADR(filter) (0x000053D0 + (filter) * 0x4)
 /* Bitmask for bitfield l3_da0[1F:0] */
 #define HW_ATL_RPF_L3_DSTA_MSK 0xFFFFFFFFu
 /* Inverted bitmask for bitfield l3_da0[1F:0] */
-- 
2.25.1

