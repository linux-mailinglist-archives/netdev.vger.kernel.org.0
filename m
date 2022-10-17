Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B57601396
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 18:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiJQQhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 12:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiJQQhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 12:37:52 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BC3642EE;
        Mon, 17 Oct 2022 09:37:50 -0700 (PDT)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HEZqSs005529;
        Mon, 17 Oct 2022 12:37:27 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3k7ss5x98j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 12:37:27 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 29HGbQpp065466
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Oct 2022 12:37:26 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Mon, 17 Oct
 2022 12:37:25 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Mon, 17 Oct 2022 12:37:25 -0400
Received: from tachici-Precision-5530.ad.analog.com ([10.48.65.138])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 29HGb5dl014472;
        Mon, 17 Oct 2022 12:37:08 -0400
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
Subject: [net-next] net: ethernet: adi: adin1110: Fix SPI transfers
Date:   Mon, 17 Oct 2022 19:37:03 +0300
Message-ID: <20221017163703.190018-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: oCt2BoqxKqX7Bc9_m3cvvAm3Fjx6Vee8
X-Proofpoint-GUID: oCt2BoqxKqX7Bc9_m3cvvAm3Fjx6Vee8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_13,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210170096
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to use more than one SPI transfer for reads.
Use only one from now as ADIN1110/2111 does not tolerate
CS changes during reads.

The BCM2711/2708 SPI controllers worked fine, but the NXP
IMX8MM could not keep CS lowered during SPI bursts.

This change aims to make the ADIN1110/2111 driver compatible
with both SPI controllers, without any loss of bandwidth/other
capabilities.

Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/ethernet/adi/adin1110.c | 37 +++++++++++++----------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 1744d623999d..086aa9c96b31 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -196,7 +196,7 @@ static int adin1110_read_reg(struct adin1110_priv *priv, u16 reg, u32 *val)
 {
 	u32 header_len = ADIN1110_RD_HEADER_LEN;
 	u32 read_len = ADIN1110_REG_LEN;
-	struct spi_transfer t[2] = {0};
+	struct spi_transfer t = {0};
 	int ret;
 
 	priv->data[0] = ADIN1110_CD | FIELD_GET(GENMASK(12, 8), reg);
@@ -209,17 +209,15 @@ static int adin1110_read_reg(struct adin1110_priv *priv, u16 reg, u32 *val)
 		header_len++;
 	}
 
-	t[0].tx_buf = &priv->data[0];
-	t[0].len = header_len;
-
 	if (priv->append_crc)
 		read_len++;
 
 	memset(&priv->data[header_len], 0, read_len);
-	t[1].rx_buf = &priv->data[header_len];
-	t[1].len = read_len;
+	t.tx_buf = &priv->data[0];
+	t.rx_buf = &priv->data[0];
+	t.len = read_len + header_len;
 
-	ret = spi_sync_transfer(priv->spidev, t, 2);
+	ret = spi_sync_transfer(priv->spidev, &t, 1);
 	if (ret)
 		return ret;
 
@@ -296,7 +294,7 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 {
 	struct adin1110_priv *priv = port_priv->priv;
 	u32 header_len = ADIN1110_RD_HEADER_LEN;
-	struct spi_transfer t[2] = {0};
+	struct spi_transfer t;
 	u32 frame_size_no_fcs;
 	struct sk_buff *rxb;
 	u32 frame_size;
@@ -327,12 +325,7 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 		return ret;
 
 	frame_size_no_fcs = frame_size - ADIN1110_FRAME_HEADER_LEN - ADIN1110_FEC_LEN;
-
-	rxb = netdev_alloc_skb(port_priv->netdev, round_len);
-	if (!rxb)
-		return -ENOMEM;
-
-	memset(priv->data, 0, round_len + ADIN1110_RD_HEADER_LEN);
+	memset(priv->data, 0, ADIN1110_RD_HEADER_LEN);
 
 	priv->data[0] = ADIN1110_CD | FIELD_GET(GENMASK(12, 8), reg);
 	priv->data[1] = FIELD_GET(GENMASK(7, 0), reg);
@@ -342,21 +335,23 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 		header_len++;
 	}
 
-	skb_put(rxb, frame_size_no_fcs + ADIN1110_FRAME_HEADER_LEN);
+	rxb = netdev_alloc_skb(port_priv->netdev, round_len + header_len);
+	if (!rxb)
+		return -ENOMEM;
 
-	t[0].tx_buf = &priv->data[0];
-	t[0].len = header_len;
+	skb_put(rxb, frame_size_no_fcs + header_len + ADIN1110_FRAME_HEADER_LEN);
 
-	t[1].rx_buf = &rxb->data[0];
-	t[1].len = round_len;
+	t.tx_buf = &priv->data[0];
+	t.rx_buf = &rxb->data[0];
+	t.len = header_len + round_len;
 
-	ret = spi_sync_transfer(priv->spidev, t, 2);
+	ret = spi_sync_transfer(priv->spidev, &t, 1);
 	if (ret) {
 		kfree_skb(rxb);
 		return ret;
 	}
 
-	skb_pull(rxb, ADIN1110_FRAME_HEADER_LEN);
+	skb_pull(rxb, header_len + ADIN1110_FRAME_HEADER_LEN);
 	rxb->protocol = eth_type_trans(rxb, port_priv->netdev);
 
 	if ((port_priv->flags & IFF_ALLMULTI && rxb->pkt_type == PACKET_MULTICAST) ||
-- 
2.34.1

