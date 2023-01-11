Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F746655C1
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjAKIMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbjAKIL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:11:58 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD4C5F82
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:11:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZyhNyeRWBWqIUpIHwFGPENu7qrE9gXph3uc/nTpdrWTZAB2gj5RQu6ckx79GM2ksCNuggwZiD0SRiNL+/zV3Cjrgf01pwTUrNsEqQg6jP2niKs3sGhjRqJ3VBwrDjJPaP2TiotoC7rb86mhaJhnbrUjyG1VBvgnbqISOPKhoNQQsqiLicWt4yM6wDDcnLvt5PLnsdSSFXArnN2tU2xn/03p/kJaV9bK8i4CXuyEV29dVBxxCRpIZN3mKUsiE06YShHosyDBOl+g6IVN1hpRmJTYPGvh/8tSAAuXGs/GyeKQQhIyhlyL1dpXPpDDGohoooBbG4pToqnCPTu2+txefag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFWdUIk+RrKw1LZ1pyI8ZYwzmIrr9n10EnUwq7EYIow=;
 b=P+bXLr/Q3PYQxPgFhTeYpj7QYpxbHHOtKiEuBiNBlk1BLS3JkG6okmk236qjDPVhvbo59MqZ07TJCiE27Bopl3K4BTtBjMuUCFO9y6x160dDoBt/NVYJfznFsr98gBH9TG/uZa4QBRQtd3ahzzOcZk/frU1pC9A+VmpG3xjQsmQgk0PhRwQhCMLqX/X4zcfbmfUKZbaellZJYsYNa33IREAyije3mU/aN3Ou70S4Y1sSaA/1WvTX/UD8BofvPeUH4+HofjQpD54BZqXM1b0qjSlS78cvmI/tcQrq96uC90r7yS7PgMcz0tzFLMJ2Edbx9osHomXK6P4fCPMPq3c2gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFWdUIk+RrKw1LZ1pyI8ZYwzmIrr9n10EnUwq7EYIow=;
 b=gjfHqCnZFOrZOdx/DoFTAReXkNDZASfFskIh4RZKvIYjInRb5gG+nq69a/GQvWokR1TYuYfRaXgBUxZ2lp9OrhSQXwK0La9ge9QoUUgbK679m/CTRSpf+Xj+WLpgVtrVeMxe75L4/s2FgtyMH2FTAOSzW13TrrHLFPlX2kwtA2nAZWXNf6GqfoqBl2HROubUH/0SV8+Rp8FPxxE4rdaxw8qkqD8hrI8Cyu7jogysgIJzmDSvyEzuKzUnij2P/xyKIgz3YPhxUR1PtQgct87qLGBGjASbhp6QzOYSrn2TpFg3rG/7YxXwmEDtCgFD+jFTws45U93vGLAy2FMdmGL2qg==
Received: from MW4PR04CA0042.namprd04.prod.outlook.com (2603:10b6:303:6a::17)
 by DM8PR12MB5413.namprd12.prod.outlook.com (2603:10b6:8:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13; Wed, 11 Jan 2023 08:11:56 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::5f) by MW4PR04CA0042.outlook.office365.com
 (2603:10b6:303:6a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Wed, 11 Jan 2023 08:11:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Wed, 11 Jan 2023 08:11:55 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 11 Jan
 2023 00:11:45 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 11 Jan
 2023 00:11:45 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 11 Jan
 2023 00:11:42 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v8 2/2] macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump
Date:   Wed, 11 Jan 2023 10:11:12 +0200
Message-ID: <20230111081112.21067-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230111081112.21067-1-ehakim@nvidia.com>
References: <20230111081112.21067-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT034:EE_|DM8PR12MB5413:EE_
X-MS-Office365-Filtering-Correlation-Id: cf8a5175-5327-44f9-b9cb-08daf3ab8126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QdQFFahnZCax/Meb4igxL79FsTVxRgpKgTr6x21d5H8g30Mhyrv6v6SkJLebLNbySWqUMOOYlvRW9xnnDNFgLCB1tnM/VCxmDWRKsAXHHpLcRDTT3B5P2I0Sy0XDTnOUZ9h/ob7JV5IF+P9Q+IF9aXPVd6ucFmcI+ipXnhDurGHdWVkh26CdcT2NV4Pg3UvSQvjfjA/dVqrEA5HMk/8Qea5C+WIpKmaO2OrHzlKUb1qb2yV81zKRaejKjRCFuYns4Q6THRbdYI3K2u0HfEIbtpz6BaKhHf4VzVytss3Plwsw6eNhngS12CAi8NPmyLDAZZ3/Ic62nUvSt4yT4TUbLVzcfaUIdCtLLEksp/XLXxy2mMeZk7r9xbvuaXts7lOVsnvdK+rDksKT1UreBafOHnoo13OAOZKZX2F6vFekBfw3iLADYoVjjWddmu7POlLsijt58z7Hx1CdnoE+MI+kWvnyPqMhc62LgCcHhE/5iprSQpGIDniS0Ef6GU6wD7DRyA116icN3NF7q1vFmVuxnIIGUFmNW0pN7qxcM2Z8D0uNr+XrlgmAzlpWOK6zILNLAWJrq8krAvabMIf9lglFaTd+XspQk3P0hUs4qLZX91SCoqv0V3rp2TWLrToAPD14FjSSbKv+fBLXMpKWjctBi/I/GdZWxFGnUoVHkrbKReSNoVAC5NcvCJmPLqfFQCskOh05S8M/TQ/+KMqi5Pqopg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(36756003)(7636003)(82740400003)(70586007)(6916009)(336012)(8676002)(70206006)(4326008)(86362001)(82310400005)(40460700003)(26005)(186003)(2616005)(356005)(1076003)(316002)(40480700001)(478600001)(7696005)(54906003)(5660300002)(107886003)(2906002)(6666004)(2876002)(41300700001)(8936002)(47076005)(426003)(83380400001)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 08:11:55.7008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8a5175-5327-44f9-b9cb-08daf3ab8126
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5413
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Support dumping offload netlink attribute in macsec's device
attributes dump.
Change macsec_get_size to consider the offload attribute in
the calculations of the required room for dumping the device
netlink attributes.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V1 -> V2: Update commit message
 drivers/net/macsec.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 31f8627d6a1d..41e1054c6f26 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4246,16 +4246,22 @@ static size_t macsec_get_size(const struct net_device *dev)
 		nla_total_size(1) + /* IFLA_MACSEC_SCB */
 		nla_total_size(1) + /* IFLA_MACSEC_REPLAY_PROTECT */
 		nla_total_size(1) + /* IFLA_MACSEC_VALIDATION */
+		nla_total_size(1) + /* IFLA_MACSEC_OFFLOAD */
 		0;
 }
 
 static int macsec_fill_info(struct sk_buff *skb,
 			    const struct net_device *dev)
 {
-	struct macsec_secy *secy = &macsec_priv(dev)->secy;
-	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
+	struct macsec_tx_sc *tx_sc;
+	struct macsec_dev *macsec;
+	struct macsec_secy *secy;
 	u64 csid;
 
+	macsec = macsec_priv(dev);
+	secy = &macsec->secy;
+	tx_sc = &secy->tx_sc;
+
 	switch (secy->key_len) {
 	case MACSEC_GCM_AES_128_SAK_LEN:
 		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_128 : MACSEC_DEFAULT_CIPHER_ID;
@@ -4280,6 +4286,7 @@ static int macsec_fill_info(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_MACSEC_SCB, tx_sc->scb) ||
 	    nla_put_u8(skb, IFLA_MACSEC_REPLAY_PROTECT, secy->replay_protect) ||
 	    nla_put_u8(skb, IFLA_MACSEC_VALIDATION, secy->validate_frames) ||
+	    nla_put_u8(skb, IFLA_MACSEC_OFFLOAD, macsec->offload) ||
 	    0)
 		goto nla_put_failure;
 
-- 
2.21.3

