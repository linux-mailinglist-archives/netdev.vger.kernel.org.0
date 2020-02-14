Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7623415DB4D
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgBNPpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:45:15 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18710 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728859AbgBNPpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:45:15 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EFjDj6006473;
        Fri, 14 Feb 2020 07:45:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=di6Hv4e59r8r4+2skzMzvwmt4utcrm8Vqeh5+QX1izA=;
 b=n+oC9GxDqV/h49vQz075RJG5qALzdZJ3gLrUh1M7yFe6IR0TBgeaNoojrZfLVjXuUSRl
 3u/z2IuZ7B8kL8rhGJDG7bkMR8WrIb1Kdc1Je5a8mqiYzVdlk2Ex4rMmWYZxEXPzVR7Y
 VHdENCZNEDw0QNZuPEYUPPd/QyVccV4zDc5PHKTEkM1/DOv4u/TbbhUYKApFwty16kmb
 HnhOz+7E5cEAvreobCxNHlar3G/njSwp19qj5S5D3iGN+P75gDKu+Kv/To80c/YMgxl4
 ji+VcB8c6eh+/tKn90Nw336se1w/u1l1pkrKlIBns/HdZocTc2m73FKke41xP+m1XnMV mQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5k3pam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:45:13 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:45:11 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:45:10 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:45:10 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 9D49C3F7040;
        Fri, 14 Feb 2020 07:45:08 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <dbogdanov@marvell.com>, <pbelous@marvell.com>,
        <ndanilov@marvell.com>, <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>
Subject: [PATCH net 1/8] net: atlantic: checksum compat issue
Date:   Fri, 14 Feb 2020 18:44:51 +0300
Message-ID: <939bf1ed13ccb33afd08f80264ef10d8d3f463e1.1580299250.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1580299250.git.irusskikh@marvell.com>
References: <cover.1580299250.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dbezrukov@marvell.com>

Yet another checksum offload compatibility issue was found.

The known issue is that AQC HW marks tcp packets with 0xFFFF checksum
as invalid (1). This is workarounded in driver, passing all the suspicious
packets up to the stack for further csum validation.

Another HW problem (2) is that it hides invalid csum of LRO aggregated
packets inside of the individual descriptors. That was workarounded
by forced scan of all LRO descriptors for checksum errors.

However the scan logic was joint for both LRO and multi-descriptor
packets (jumbos). And this causes the issue.

We have to drop LRO packets with the detected bad checksum
because of (2), but we have to pass jumbo packets to stack because of (1).

When using windows tcp partner with jumbo frames but with LSO disabled
driver discards such frames as bad checksummed. But only LRO frames
should be dropped, not jumbos.

On such a configurations tcp stream have a chance of drops and stucks.

(1) 76f254d4afe2 ("net: aquantia: tcp checksum 0xffff being handled incorrectly")
(2) d08b9a0a3ebd ("net: aquantia: do not pass lro session with invalid tcp checksum")

Fixes: d08b9a0a3ebd ("net: aquantia: do not pass lro session with invalid tcp checksum")
Signed-off-by: Dmitry Bezrukov <dbezrukov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c          | 3 ++-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h          | 3 ++-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 5 +++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 951d86f8b66e..6941999ae845 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -351,7 +351,8 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 				err = 0;
 				goto err_exit;
 			}
-			if (buff->is_error || buff->is_cso_err) {
+			if (buff->is_error ||
+			    (buff->is_lro && buff->is_cso_err)) {
 				buff_ = buff;
 				do {
 					next_ = buff_->next,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
index 991e4d31b094..2c96f20f6289 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -78,7 +78,8 @@ struct __packed aq_ring_buff_s {
 			u32 is_cleaned:1;
 			u32 is_error:1;
 			u32 is_vlan:1;
-			u32 rsvd3:4;
+			u32 is_lro:1;
+			u32 rsvd3:3;
 			u16 eop_index;
 			u16 rsvd4;
 		};
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index ec041f78d063..5784da26f868 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -823,6 +823,8 @@ static int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s *self,
 			}
 		}
 
+		buff->is_lro = !!(HW_ATL_B0_RXD_WB_STAT2_RSCCNT &
+				  rxd_wb->status);
 		if (HW_ATL_B0_RXD_WB_STAT2_EOP & rxd_wb->status) {
 			buff->len = rxd_wb->pkt_len %
 				AQ_CFG_RX_FRAME_MAX;
@@ -835,8 +837,7 @@ static int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s *self,
 				rxd_wb->pkt_len > AQ_CFG_RX_FRAME_MAX ?
 				AQ_CFG_RX_FRAME_MAX : rxd_wb->pkt_len;
 
-			if (HW_ATL_B0_RXD_WB_STAT2_RSCCNT &
-				rxd_wb->status) {
+			if (buff->is_lro) {
 				/* LRO */
 				buff->next = rxd_wb->next_desc_ptr;
 				++ring->stats.rx.lro_packets;
-- 
2.17.1

