Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F027C3DEB14
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbhHCKkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:40:01 -0400
Received: from mail-dm6nam11on2117.outbound.protection.outlook.com ([40.107.223.117]:26368
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235341AbhHCKkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 06:40:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqzQSPnSEcCgAm6kORqT1Hf9JrnfNZL5PPRjud2uAC7mhXinytpcz4rGP4NSJfWLGSWw26+61QAbOAm6+cJoUEbj0/n9k82EgTtYSS+LKNpMJcRwddp7iNVNADtYLNVr0ZykjtRgicgJgDJXslszPbzEd28LZmeA2zzvWPHgZq3pKghkHEyGR2iO5QjUDwB7Caf62AgYoIXgTi792P18SGPLP2XgInAJcQTGJvquKDhJ6tlPWdNUACTu7HjG/wEbAl8SoR2p0gRHDCTP5pX0Ri1uTTr7Eid26/FR1QKVLmTAEZKGUTCsiGO02pvp+3dMAtzWEUny0PiaOu/3D3rIGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEbjiJaaOCNxh59xY4uak9aKU8LLDN/TnRIvVkDreog=;
 b=MaH/X++dbRDhIhaOENdXMUs5ZRODSM4E/vFlNr4ZAnSR/08c6ZIePIRF+Y6q/fYad07MVtxg1vNSQPCmSAfPL9tMy4m5/iZdwhY7tyAeL2/1YK0+GRoY/6ePr0BOYkQ/Y8EIWpynsNl/VWzjel2U4pLxSwtqGGWNe1zcIfPZraXfVygZWHpPN3+huuHDP02joN8VFTju4hQG2k7YPEsYgWLE/aTkHWobJK3zlZRmaUnKbZcL39MHtODS+OOoTTdQVz0I/aRpNQt4fkkVnKPR8zCROfIkGLOaOLqgaB2LNfljJ9G6Ff9ewJDLMXTKirYhq2+SptZdqf7JV0HPPdgKJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEbjiJaaOCNxh59xY4uak9aKU8LLDN/TnRIvVkDreog=;
 b=H88rxBU/0SW/UszYjYfbz+Ix+bCd+QWuYmZyXbLG3ACkX03nVDrTg2xNaLUDhIycnB7eQWv9/PqCTr+bxEemr70BcvU8rM6mPoV7RGukvIhs7T1aSGA1edR6kXdCc8rvUS/zjvX6miLW7zhs5tj/WwIzI8YNbuwCr/0OhWLecxE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5051.namprd13.prod.outlook.com (2603:10b6:510:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.14; Tue, 3 Aug
 2021 10:39:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Tue, 3 Aug 2021
 10:39:48 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: update ethtool reporting of pauseframe control
Date:   Tue,  3 Aug 2021 12:39:11 +0200
Message-Id: <20210803103911.22639-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::44) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR01CA0103.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 3 Aug 2021 10:39:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62d3319c-ad24-464b-e9cb-08d9566b0427
X-MS-TrafficTypeDiagnostic: PH0PR13MB5051:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB50513108F34D4197ED1EF812E8F09@PH0PR13MB5051.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tWBANJ6oKjmwY6CMPcj3AokC1Ud7pIsz/Cd/5bPu6uIfW45ISWcbcQjJ7bTqhkqFph+pIWELXTqZkDplcZCqSVSXgppeYc3+FEjDtj3Sx6mY55sHBJQOIrs5F4Vfi5bdhvNUKksuI1vbkG+E7iednVcjwcizmIcTj4tTCipREdhQjzfEP+JyNGasW1nlyPDTqwRBkEkLeYrccgHbL1KggpU+4+hz8krG1UqMcfVXT4wBW+JDz0PqxofBBg2vP0ete7ByC8E3u34DhzGmiZUhw60KdJOrWYtn9KmFzaBVrsuNIjlh+r/pBTsCm4mPHXBFzPSps+PbjlzsoZTcLnOlhFF7Y2Lw/1eK9x1TLZkZVAbca7Vig9rU0jYyC64bEYBonZi4cWqTzIv9ExgwdymrO29RuUajBUH/rJ8ss/tU62Imf7+paAZZurFh62FL86jPnZSxhARjlThIfFnbvEYmwkvWmOxwnJ/pVtRgKBQsFY8OQxDlIFVktr/NYSvVWUFZlYIJcAMGaIXfnzimR15xAqMNk0qZ6fSWsTh9P11EFQZJWZMuNDqkJZXlAyUHtBBQLoGC/rUO2C5k1/wCIR6JhB76UWJBJYfzECBiDfhzkguDzpHbXmahiYOVJ4O85gt9G5N+mHJ60L5AiZqyFzyrxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(366004)(39830400003)(136003)(8936002)(186003)(5660300002)(2616005)(8676002)(36756003)(6486002)(44832011)(54906003)(110136005)(4326008)(316002)(1076003)(38100700002)(52116002)(2906002)(6666004)(66946007)(66476007)(86362001)(107886003)(66556008)(478600001)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A7pMV6KXH88MuES8sQLNn+/aSjC+FNMxFbGrAP2uTAebimPLVKYypJOdbcLu?=
 =?us-ascii?Q?wXSyWtpRRxHD8LzTHquCDtm+815ILuQ4VORC/r2V7FRJLml/QzTjjAPa4ghg?=
 =?us-ascii?Q?kfJXa6XMiW7Zv3/ytpTLNjiuEsngGAfb9rumNOUX9s3cZFyPEZgBsykqgB4X?=
 =?us-ascii?Q?42vgi6dslpr0jijUckojwTjzoZCciIUwxFakWvu1G2h4kZMHqLnbz87WdJqQ?=
 =?us-ascii?Q?Zv276goB8rIofd4xLJvUjUqSgTO7KhcbAYVgjH30oI5Oj4zUMg3ZcuRBOk3U?=
 =?us-ascii?Q?k8XbpJq4qVrGgaOR6FNNmUq7qTGHqAAW8oefLZ1UcZ/vfHCp90MEqe81kg7i?=
 =?us-ascii?Q?2O+jj0CPonxY+2NkpHhkpZ9gpNzfa4HNzYUBzkoPpjGfoPn2lJmLEDAgvhMh?=
 =?us-ascii?Q?u1sJWxh8QokQiOZpnYaDFBtJVG2SgyCuYg29vwxFha3zYUdExEz4O6JmxDZq?=
 =?us-ascii?Q?9fZVO2lVDeoHnFjf3iiis4fllP0de4/PEnaJjRbFycJp7rqXDvqHsD4bRqGV?=
 =?us-ascii?Q?IM3Pl6MRdAMdbATYpubR2K3gQjLW2c1oklqcPTZuWGT3SGyY04tWdsQEkvzZ?=
 =?us-ascii?Q?//U9q5J6sqwe3LSD6ZYxAWgCDHYv23/CG5qksMhO8gK3W5vkBLiutC3FVj/e?=
 =?us-ascii?Q?za70JbyBzNpRuguPV/u7860hWc9uKAe1H3ESLhwv+Bp5vMZnVYl+oRP8Hpfb?=
 =?us-ascii?Q?7jLuPjTgUBWibO2Z3nyX1jys9AWbNXHLPv4FKj8n6QO8MGZt3F4OOc9pcC6H?=
 =?us-ascii?Q?jmEokY+uIfmLamCREH8vzI+fLiMXyhKjvm9f75/BTrkAxa5sfhmYGoXnOKFS?=
 =?us-ascii?Q?kHQzfq5oX/Ghz/IZJsy3nIWZiSmGfSH/IetbVfhK0nC9eier2uOUq63XIPsS?=
 =?us-ascii?Q?7egIHmhuS9GGXHJqV5j5kYw8mbBFLClG4zlIgCPRtlW5XMKLcnJv8CJLvNge?=
 =?us-ascii?Q?74sQg/+S7VNpg+5KCoBnlZcPUnHenFg0QSMuRnRui7JsRDmcNfgScsd/V27p?=
 =?us-ascii?Q?qcumv6RtHcwPlNX19OL1TpRVGjRvGW+RJL7uZu19KZ/oOsXi3sH2qi685wji?=
 =?us-ascii?Q?yELcsnHSIquT+5XsvHAUjK97XQS9gpRZgsa3P9qdzcPYLxh5fwyqlEHopYmJ?=
 =?us-ascii?Q?Y57nSvw7jUcK+I0bt+valQB4rhFbcio3Z8qoQn4jKO21kwVKuP6GZqV7N4gG?=
 =?us-ascii?Q?6pU/7eyNfhXewIij52UmU7aDRmCHl2z9mr4t/K2FlfjtfbPI1Db57giFdIYr?=
 =?us-ascii?Q?1DkuZg45jka3EQB3uUT8HOtjhsXPvAVNe1FylE9FlYaVEHlw1/rAvNnZQWRL?=
 =?us-ascii?Q?fRxf1/vOJbgzaDPq1cTgC61H+ByS8uQVmHzDNrsRDC9V9GKs9KjWYh2FwSVR?=
 =?us-ascii?Q?S7p52WP4H0u7tS2QW1ue1Ah+rvsa?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62d3319c-ad24-464b-e9cb-08d9566b0427
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 10:39:48.3896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oKRftDzLYwuUE2zm7Is6Pr3lsmWQ5z+JwQKo2ipGcwUE27Pp/5HUsAKgcByZJ1V7mIAnCq87vImD43rgz332DQKATKMGT4dwZCxlJnAcJzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fei Qin <fei.qin@corigine.com>

Pauseframe control is set to symmetric mode by default on the NFP.
Pause frames can not be configured through ethtool now, but ethtool can
report the supported mode.

Fixes: 265aeb511bd5 ("nfp: add support for .get_link_ksettings()")
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 1b482446536d..8803faadd302 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -286,6 +286,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 
 	/* Init to unknowns */
 	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
+	ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
 	cmd->base.port = PORT_OTHER;
 	cmd->base.speed = SPEED_UNKNOWN;
 	cmd->base.duplex = DUPLEX_UNKNOWN;
-- 
2.20.1

