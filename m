Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2DF3BFA16
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 14:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbhGHMai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 08:30:38 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:45006 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231126AbhGHMah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 08:30:37 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 3051F49E44;
        Thu,  8 Jul 2021 12:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1625747273; x=1627561674; bh=vK96Sc7MNGUkW8R4Eq+yIewGLHOFKMnjDyv
        qwGbS51s=; b=t7Jwd2X0qcTmF6cEfkt+UCjbb6s4kg16gqeDEe9e1BeWzKutVR4
        frTxLgvoFAhWvUEu1Vx7XbGWlEfQvWXjAY0Qn1c7a+ED6JbBA8e+FvvWLJoN3JzE
        42nZ02t515wPkjxfBpVViN0xrY/s/B26Fy1rYxOyH4nL0jO37Z10EDbM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2flJR5XKGTo4; Thu,  8 Jul 2021 15:27:53 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 0089D49F48;
        Thu,  8 Jul 2021 15:18:27 +0300 (MSK)
Received: from fedora.mshome.net (10.199.0.196) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 8 Jul
 2021 15:18:25 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>
Subject: [PATCH v2 1/3] net/ncsi: fix restricted cast warning of sparse
Date:   Thu, 8 Jul 2021 15:27:52 +0300
Message-ID: <20210708122754.555846-2-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210708122754.555846-1-i.mikhaylov@yadro.com>
References: <20210708122754.555846-1-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.196]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports:
net/ncsi/ncsi-rsp.c:406:24: warning: cast to restricted __be32
net/ncsi/ncsi-manage.c:732:33: warning: cast to restricted __be32
net/ncsi/ncsi-manage.c:756:25: warning: cast to restricted __be32
net/ncsi/ncsi-manage.c:779:25: warning: cast to restricted __be32

Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
---
 net/ncsi/ncsi-manage.c | 6 +++---
 net/ncsi/ncsi-rsp.c    | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index ca04b6df1341..42b54a3da2e6 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -700,7 +700,7 @@ static int ncsi_oem_gma_handler_bcm(struct ncsi_cmd_arg *nca)
 	nca->payload = NCSI_OEM_BCM_CMD_GMA_LEN;
 
 	memset(data, 0, NCSI_OEM_BCM_CMD_GMA_LEN);
-	*(unsigned int *)data = ntohl(NCSI_OEM_MFR_BCM_ID);
+	*(unsigned int *)data = ntohl((__force __be32)NCSI_OEM_MFR_BCM_ID);
 	data[5] = NCSI_OEM_BCM_CMD_GMA;
 
 	nca->data = data;
@@ -724,7 +724,7 @@ static int ncsi_oem_gma_handler_mlx(struct ncsi_cmd_arg *nca)
 	nca->payload = NCSI_OEM_MLX_CMD_GMA_LEN;
 
 	memset(&u, 0, sizeof(u));
-	u.data_u32[0] = ntohl(NCSI_OEM_MFR_MLX_ID);
+	u.data_u32[0] = ntohl((__force __be32)NCSI_OEM_MFR_MLX_ID);
 	u.data_u8[5] = NCSI_OEM_MLX_CMD_GMA;
 	u.data_u8[6] = NCSI_OEM_MLX_CMD_GMA_PARAM;
 
@@ -747,7 +747,7 @@ static int ncsi_oem_smaf_mlx(struct ncsi_cmd_arg *nca)
 	int ret = 0;
 
 	memset(&u, 0, sizeof(u));
-	u.data_u32[0] = ntohl(NCSI_OEM_MFR_MLX_ID);
+	u.data_u32[0] = ntohl((__force __be32)NCSI_OEM_MFR_MLX_ID);
 	u.data_u8[5] = NCSI_OEM_MLX_CMD_SMAF;
 	u.data_u8[6] = NCSI_OEM_MLX_CMD_SMAF_PARAM;
 	memcpy(&u.data_u8[MLX_SMAF_MAC_ADDR_OFFSET],
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 888ccc2d4e34..04bc50be5c01 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -403,7 +403,7 @@ static int ncsi_rsp_handler_ev(struct ncsi_request *nr)
 	/* Update to VLAN mode */
 	cmd = (struct ncsi_cmd_ev_pkt *)skb_network_header(nr->cmd);
 	ncm->enable = 1;
-	ncm->data[0] = ntohl(cmd->mode);
+	ncm->data[0] = ntohl((__force __be32)cmd->mode);
 
 	return 0;
 }
-- 
2.31.1

