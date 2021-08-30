Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D843FBA9F
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbhH3RIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:08:49 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:56456 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238017AbhH3RIp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 13:08:45 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1E6284CF4A;
        Mon, 30 Aug 2021 17:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1630343265; x=1632157666; bh=2h047rfaOj1MGJZrxOPxoaksc1Dn2qfXP4g
        y91MuslI=; b=NwsKxXesdy592Icr9XUG2Mo8SPjDrBoNIoaPB4Smgc0473/3bRP
        7OZucCj47p6jJEjrEHMr4VEMKx4Xqj8NK76O+VpOVFu8kGPgmlkxy1pqbQff8fQk
        rNl0sissXXhHryUpi/AK5/OFgiWqSaUpoS7BV6OItBuX+qaidZ4vxH94=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EuhzAMjsnGTg; Mon, 30 Aug 2021 20:07:45 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8453E4CF28;
        Mon, 30 Aug 2021 20:07:45 +0300 (MSK)
Received: from fedora.mshome.net (10.199.0.170) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 30
 Aug 2021 20:07:39 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>, Brad Ho <Brad_Ho@phoenix.com>,
        Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 1/1] net/ncsi: add get MAC address command to get Intel i210 MAC address
Date:   Mon, 30 Aug 2021 20:18:06 +0300
Message-ID: <20210830171806.119857-2-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830171806.119857-1-i.mikhaylov@yadro.com>
References: <20210830171806.119857-1-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.170]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds OEM Intel GMA command and response handler for it.

Signed-off-by: Brad Ho <Brad_Ho@phoenix.com>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
---
 net/ncsi/internal.h    |  3 +++
 net/ncsi/ncsi-manage.c | 25 ++++++++++++++++++++++++-
 net/ncsi/ncsi-pkt.h    |  6 ++++++
 net/ncsi/ncsi-rsp.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index 0b6cfd3b31e0..03757e76bb6b 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -80,6 +80,7 @@ enum {
 #define NCSI_OEM_MFR_BCM_ID             0x113d
 #define NCSI_OEM_MFR_INTEL_ID           0x157
 /* Intel specific OEM command */
+#define NCSI_OEM_INTEL_CMD_GMA          0x06   /* CMD ID for Get MAC */
 #define NCSI_OEM_INTEL_CMD_KEEP_PHY     0x20   /* CMD ID for Keep PHY up */
 /* Broadcom specific OEM Command */
 #define NCSI_OEM_BCM_CMD_GMA            0x01   /* CMD ID for Get MAC */
@@ -89,6 +90,7 @@ enum {
 #define NCSI_OEM_MLX_CMD_SMAF           0x01   /* CMD ID for Set MC Affinity */
 #define NCSI_OEM_MLX_CMD_SMAF_PARAM     0x07   /* Parameter for SMAF         */
 /* OEM Command payload lengths*/
+#define NCSI_OEM_INTEL_CMD_GMA_LEN      5
 #define NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN 7
 #define NCSI_OEM_BCM_CMD_GMA_LEN        12
 #define NCSI_OEM_MLX_CMD_GMA_LEN        8
@@ -99,6 +101,7 @@ enum {
 /* Mac address offset in OEM response */
 #define BCM_MAC_ADDR_OFFSET             28
 #define MLX_MAC_ADDR_OFFSET             8
+#define INTEL_MAC_ADDR_OFFSET           1
 
 
 struct ncsi_channel_version {
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index 89c7742cd72e..7121ce2a47c0 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -795,13 +795,36 @@ static int ncsi_oem_smaf_mlx(struct ncsi_cmd_arg *nca)
 	return ret;
 }
 
+static int ncsi_oem_gma_handler_intel(struct ncsi_cmd_arg *nca)
+{
+	unsigned char data[NCSI_OEM_INTEL_CMD_GMA_LEN];
+	int ret = 0;
+
+	nca->payload = NCSI_OEM_INTEL_CMD_GMA_LEN;
+
+	memset(data, 0, NCSI_OEM_INTEL_CMD_GMA_LEN);
+	*(unsigned int *)data = ntohl((__force __be32)NCSI_OEM_MFR_INTEL_ID);
+	data[4] = NCSI_OEM_INTEL_CMD_GMA;
+
+	nca->data = data;
+
+	ret = ncsi_xmit_cmd(nca);
+	if (ret)
+		netdev_err(nca->ndp->ndev.dev,
+			   "NCSI: Failed to transmit cmd 0x%x during configure\n",
+			   nca->type);
+
+	return ret;
+}
+
 /* OEM Command handlers initialization */
 static struct ncsi_oem_gma_handler {
 	unsigned int	mfr_id;
 	int		(*handler)(struct ncsi_cmd_arg *nca);
 } ncsi_oem_gma_handlers[] = {
 	{ NCSI_OEM_MFR_BCM_ID, ncsi_oem_gma_handler_bcm },
-	{ NCSI_OEM_MFR_MLX_ID, ncsi_oem_gma_handler_mlx }
+	{ NCSI_OEM_MFR_MLX_ID, ncsi_oem_gma_handler_mlx },
+	{ NCSI_OEM_MFR_INTEL_ID, ncsi_oem_gma_handler_intel }
 };
 
 static int ncsi_gma_handler(struct ncsi_cmd_arg *nca, unsigned int mf_id)
diff --git a/net/ncsi/ncsi-pkt.h b/net/ncsi/ncsi-pkt.h
index 80938b338fee..ba66c7dc3a21 100644
--- a/net/ncsi/ncsi-pkt.h
+++ b/net/ncsi/ncsi-pkt.h
@@ -178,6 +178,12 @@ struct ncsi_rsp_oem_bcm_pkt {
 	unsigned char           data[];      /* Cmd specific Data */
 };
 
+/* Intel Response Data */
+struct ncsi_rsp_oem_intel_pkt {
+	unsigned char           cmd;         /* OEM Command ID    */
+	unsigned char           data[];      /* Cmd specific Data */
+};
+
 /* Get Link Status */
 struct ncsi_rsp_gls_pkt {
 	struct ncsi_rsp_pkt_hdr rsp;        /* Response header   */
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index d48374894817..6447a09932f5 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -699,9 +699,51 @@ static int ncsi_rsp_handler_oem_bcm(struct ncsi_request *nr)
 	return 0;
 }
 
+/* Response handler for Intel command Get Mac Address */
+static int ncsi_rsp_handler_oem_intel_gma(struct ncsi_request *nr)
+{
+	struct ncsi_dev_priv *ndp = nr->ndp;
+	struct net_device *ndev = ndp->ndev.dev;
+	const struct net_device_ops *ops = ndev->netdev_ops;
+	struct ncsi_rsp_oem_pkt *rsp;
+	struct sockaddr saddr;
+	int ret = 0;
+
+	/* Get the response header */
+	rsp = (struct ncsi_rsp_oem_pkt *)skb_network_header(nr->rsp);
+
+	saddr.sa_family = ndev->type;
+	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	memcpy(saddr.sa_data, &rsp->data[INTEL_MAC_ADDR_OFFSET], ETH_ALEN);
+	/* Increase mac address by 1 for BMC's address */
+	eth_addr_inc((u8 *)saddr.sa_data);
+	if (!is_valid_ether_addr((const u8 *)saddr.sa_data))
+		return -ENXIO;
+
+	/* Set the flag for GMA command which should only be called once */
+	ndp->gma_flag = 1;
+
+	ret = ops->ndo_set_mac_address(ndev, &saddr);
+	if (ret < 0)
+		netdev_warn(ndev,
+			    "NCSI: 'Writing mac address to device failed\n");
+
+	return ret;
+}
+
 /* Response handler for Intel card */
 static int ncsi_rsp_handler_oem_intel(struct ncsi_request *nr)
 {
+	struct ncsi_rsp_oem_intel_pkt *intel;
+	struct ncsi_rsp_oem_pkt *rsp;
+
+	/* Get the response header */
+	rsp = (struct ncsi_rsp_oem_pkt *)skb_network_header(nr->rsp);
+	intel = (struct ncsi_rsp_oem_intel_pkt *)(rsp->data);
+
+	if (intel->cmd == NCSI_OEM_INTEL_CMD_GMA)
+		return ncsi_rsp_handler_oem_intel_gma(nr);
+
 	return 0;
 }
 
-- 
2.31.1

