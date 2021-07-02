Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B923B3B9F9A
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 13:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhGBLTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 07:19:11 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:33958 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231243AbhGBLTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 07:19:09 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2A1DB46714;
        Fri,  2 Jul 2021 11:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1625224594; x=1627038995; bh=7PRkOUmpvHL6RX21jbCBQkSilwZr69tmWwd
        u5xDqvCY=; b=Wb7tiosFvTnGm+m2+EpMxcDMn5WeeGoMefg7SPxDfIBcde89+VK
        RxkRg3VcpAOLBlAC1DmxtLoV+KjhrHfm84w7pKU18aIqU2IIW5uiEs8eirQhZl5P
        RnRnS+7Vu2u04V2wxupczb7jKVqJ3nxVm0DYd70sr/5XKNsvVofx3GV8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id C-YEhGs4-mcS; Fri,  2 Jul 2021 14:16:34 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D4C2E4676F;
        Fri,  2 Jul 2021 14:16:33 +0300 (MSK)
Received: from localhost.yadro.com (10.199.0.133) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 2 Jul
 2021 14:16:29 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>
Subject: [PATCH 1/2] net/ncsi: add NCSI Intel OEM command to keep PHY up
Date:   Fri, 2 Jul 2021 14:25:18 +0300
Message-ID: <20210702112519.76385-2-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210702112519.76385-1-i.mikhaylov@yadro.com>
References: <20210702112519.76385-1-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.133]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows to keep PHY link up and prevents any channel resets during
the host load. On BMC it prevents channel reconfiguration:

eth1: NCSI: No channel with link found, configuring channel 0

which brings problem with BMC accessibility.

It is KEEP_PHY_LINK_UP option(Veto bit) in i210 datasheet which
blocks PHY reset and power state changes.

Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
---
 net/ncsi/Kconfig       |  6 ++++++
 net/ncsi/internal.h    |  5 +++++
 net/ncsi/ncsi-manage.c | 48 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/net/ncsi/Kconfig b/net/ncsi/Kconfig
index 93309081f5a4..ea1dd32b6b1f 100644
--- a/net/ncsi/Kconfig
+++ b/net/ncsi/Kconfig
@@ -17,3 +17,9 @@ config NCSI_OEM_CMD_GET_MAC
 	help
 	  This allows to get MAC address from NCSI firmware and set them back to
 		controller.
+config NCSI_OEM_CMD_KEEP_PHY
+	bool "Keep PHY Link up"
+	depends on NET_NCSI
+	help
+	  This allows to keep PHY link up and prevents any channel resets during
+	  the host load.
diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index 49031f804276..0a232f3eb343 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -78,6 +78,9 @@ enum {
 /* OEM Vendor Manufacture ID */
 #define NCSI_OEM_MFR_MLX_ID             0x8119
 #define NCSI_OEM_MFR_BCM_ID             0x113d
+#define NCSI_OEM_MFR_INL_ID             0x157
+/* Intel specific OEM command */
+#define NCSI_OEM_INL_CMD_KEEP_PHY       0x20   /* CMD ID for Keep PHY up */
 /* Broadcom specific OEM Command */
 #define NCSI_OEM_BCM_CMD_GMA            0x01   /* CMD ID for Get MAC */
 /* Mellanox specific OEM Command */
@@ -86,6 +89,7 @@ enum {
 #define NCSI_OEM_MLX_CMD_SMAF           0x01   /* CMD ID for Set MC Affinity */
 #define NCSI_OEM_MLX_CMD_SMAF_PARAM     0x07   /* Parameter for SMAF         */
 /* OEM Command payload lengths*/
+#define NCSI_OEM_INL_CMD_KEEP_PHY_LEN   7
 #define NCSI_OEM_BCM_CMD_GMA_LEN        12
 #define NCSI_OEM_MLX_CMD_GMA_LEN        8
 #define NCSI_OEM_MLX_CMD_SMAF_LEN        60
@@ -270,6 +274,7 @@ enum {
 	ncsi_dev_state_probe_channel,
 	ncsi_dev_state_probe_mlx_gma,
 	ncsi_dev_state_probe_mlx_smaf,
+	ncsi_dev_state_probe_keep_phy,
 	ncsi_dev_state_probe_cis,
 	ncsi_dev_state_probe_gvi,
 	ncsi_dev_state_probe_gc,
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index ffff8da707b8..d78cca2a2b26 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -689,6 +689,37 @@ static int set_one_vid(struct ncsi_dev_priv *ndp, struct ncsi_channel *nc,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
+
+static int ncsi_oem_keep_phy_inl(struct ncsi_cmd_arg *nca)
+{
+	unsigned char data[NCSI_OEM_INL_CMD_KEEP_PHY_LEN];
+	int ret = 0;
+
+	nca->payload = NCSI_OEM_INL_CMD_KEEP_PHY_LEN;
+
+	memset(data, 0, NCSI_OEM_INL_CMD_KEEP_PHY_LEN);
+	*(unsigned int *)data = ntohl(NCSI_OEM_MFR_INL_ID);
+
+	/* Predefined data */
+	data[4] = NCSI_OEM_INL_CMD_KEEP_PHY;
+	data[5] = 0x0;
+
+	/* PHY Link up attribute */
+	data[6] = 0x1;
+
+	nca->data = data;
+
+	ret = ncsi_xmit_cmd(nca);
+	if (ret)
+		netdev_err(nca->ndp->ndev.dev,
+			   "NCSI: Failed to transmit cmd 0x%x during configure\n",
+			   nca->type);
+	return ret;
+}
+
+#endif
+
 #if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
 
 /* NCSI OEM Command APIs */
@@ -1350,8 +1381,25 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 		    ndp->mlx_multi_host)
 			nd->state = ncsi_dev_state_probe_mlx_gma;
 
+		if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY))
+			nd->state = ncsi_dev_state_probe_keep_phy;
+
 		schedule_work(&ndp->work);
 		break;
+#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
+	case ncsi_dev_state_probe_keep_phy:
+		ndp->pending_req_num = 1;
+
+		nca.type = NCSI_PKT_CMD_OEM;
+		nca.package = ndp->active_package->id;
+		nca.channel = 0;
+		ret = ncsi_oem_keep_phy_inl(&nca);
+		if (ret)
+			goto error;
+
+		nd->state = ncsi_dev_state_probe_cis;
+		break;
+#endif /* CONFIG_NCSI_OEM_CMD_KEEP_PHY */
 #if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
 	case ncsi_dev_state_probe_mlx_gma:
 		ndp->pending_req_num = 1;
-- 
2.31.1

