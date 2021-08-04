Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D703E0283
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238502AbhHDNzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:55:39 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:28896
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238488AbhHDNzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:55:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hI0GTJHlXIxOlvxr3CwNtA6sfOpz/AZAriutJbEYvXtGE4ay9mxX1p986d2DxRgZ5oH41B+dYCIz03SdOkbUb3UHN/JD/KyKApYd/u9Fx8p9eH4MMcCSRiUo9+cMPHV2geMaMrgSNXOWUp4hOj4ox39+fYKjvxiCWNLS10xWhC5dz0/6vMJDvf7QwtusN/GzFEbuUC44jNgVC+85vp7MYBlBfUkMjJ8hRzbvuBq1DPfPMaRn9gR6pWnxYDJxNfs2Gt3EAIrUjCwKYrQFGCHWqUHIp5NV91I3MvH6sw3oelOiG2yx9QHQLIG1xbx0au3HFbM1hVKHtdbAxFNT9zHsAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xv8psI/5kz8emCRqcS+SdgKVUIb5qDFIY0g5PQAGfMo=;
 b=IZFYsRMOEuvgYFapiSvyyq6kGDWhwCml2Ke9zRZ+UoVq/bG9PD7GKD7dkK9kp9+ID3lVBA7XX7wP1rGGvt+kQ4mXREFFntYTL4wAUKjLEMfisbgI+t3IOb55kheUvW7SjIvMpZ6PRrSqi3dW8f5W7fGYXHFiNWaEiujBvwHQJJ/pYEp/gwSkyI/dT7yVR+dnVVwrcgZqydmXiDUjMd9Gh6ixQ4Z2hlADQ1MUWiAPRCKEOmYeBlNndDfoiUpcJCD/O870wm4IUxStio/90SohutD+2yXAT88JxM61+1DgQB5DVog5TzHAktszCr0WpuEcpTQSfK+KlEA5E9Hi9teDyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xv8psI/5kz8emCRqcS+SdgKVUIb5qDFIY0g5PQAGfMo=;
 b=LW8+bgWx0NoNCvNnFw2iudFHcKG25FC0Sgo1Alkimpftd0LfhcBc8ZwSLT89Y5O4Yh245qTbjmg4K3uTlsvjCLWsAI4febDJDZJdBTJ70colRTUTi01Da7juvz1JxGB7auDAZAtWeeygHVaeUUMwHJpT6EJD4L2v3oIeMteBEXo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 13:55:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:55:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 6/8] net: dsa: sja1105: increase MTU to account for VLAN header on DSA ports
Date:   Wed,  4 Aug 2021 16:54:34 +0300
Message-Id: <20210804135436.1741856-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
References: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0155.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR01CA0155.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 13:55:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d427bd64-1d90-473b-4e73-08d9574f7b20
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2687374E71028B2643EFDCD9E0F19@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DT2VcfJHlQtGNoaln77xNrPUdpuUkqv1qk/cEg56xOkPS5LNOdW2g9S96JmrTWX38Tf0mpRvCwGQPgBXcKSYV16IBnnRmH6OkGkqsh3/QFhAM2hqnDqzZiA3etaARrfNQ0jE0QhNNbk3CbR7Kd0+3wIaIiB3VC6BYqDcpPkrTSHSy5aqgr/oRV6RPtYrrjxA5x2+GBgmReLpSnWdZKaZGXfZN1Gc23OaTwezQ5cXNX/ryH140X5PlLqzUDxif5gK6AmYDOzmICHb3Hv6UHeIWaaX7mKJXlBcnIhVl1Y2+b+bbJNRu/LHcEqbNC+nj7tg9jMmcRc0aoyndnVfqhdo14lqAdSfM6VClAr0uSWYiA3dpVj6JOnAt6+DqoFxOLkC8Iz7uJhqU/z8kyPMjxP66AgFU7T4BQA08p3iyltcW2nuwGEaGJ3kHcdCZMOUXNsko2zgg0E7v52/lBvyR3SrKIdTToZG32aOLIwq37HV/VX71wJViCJokZ68IQIgJivT/NwJ4QM+alXh8vPgp/jONlDyUFadybLnWCLJu1MDyZhsqn9qz99HZ2C1B0wZFUvswbfi5Xk5bZcFJvcEfTpN9ILs1KTNjQ0G0QUAWTgPUKXUtJCNnizzBHbaoW5VypSATa1cXV4m6iVoL8UAyaxuCXw7s07RIXNJb2pSiWms5+kY3m8Jg+QOig3OQdu70j95XUR71W8qW7BeQwOnXA3PbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(6666004)(6486002)(5660300002)(478600001)(66946007)(1076003)(66476007)(15650500001)(4326008)(66556008)(54906003)(26005)(44832011)(38350700002)(86362001)(2616005)(52116002)(8676002)(6506007)(2906002)(36756003)(110136005)(83380400001)(38100700002)(956004)(6512007)(316002)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3f5soSLopc544VgatZlKG/JDIimonlEyB27Jma7vD8h9Yk7dCOZeZ+VlttoG?=
 =?us-ascii?Q?jD9qdxoge0QFDKrfNcj7Aa1drCaNk14MdF8RmJlLkbWlctg/wEZxS+dHX7qH?=
 =?us-ascii?Q?bjqsUoFC9nRWvi71UPYHRLONtbc9UoV+aaPRJ7kxVnyXqPjZZlLCIBiK3gxY?=
 =?us-ascii?Q?39g8hFVaGh4I0bgAfkbGev+CZBMsBLPX1gArBMHQbShg7JVu7NMBsn32kVF3?=
 =?us-ascii?Q?q/HEoBaGeiaZysb7UTMr5y5iomKpjjkL23bE7ck1qbmNopvJgPr3OqXwNKIW?=
 =?us-ascii?Q?dc8jL6I0WfnAraiAe4SoOPDe+ogaQdt67MrvOs4dH6kk5sdL4BalxNc3b6tq?=
 =?us-ascii?Q?uz3RCKdxw0jfSn4vSrSUie2EdbUiMtKQuysOXqAgJveloy7Hsf6nV7+afztk?=
 =?us-ascii?Q?JJFK4+PVu33voZsQMoZ6ii8KtpooVYCAmTlgD4qoA/XAp2bgJS63uhAX2tsL?=
 =?us-ascii?Q?7Z2v0vnfWDsdZjXuuLLr+z0anOAXOxdvKRvosae2h34NC/U3K48Iu0xZbOrX?=
 =?us-ascii?Q?CIVzTYihT0Ycl/frvmNiaz/ML/liEt6rKJMdQx9CT7UrB6m9pgBmrNFAKRgR?=
 =?us-ascii?Q?8RjWc19LipfAC1ztdgw/ILg6IS2C9ZfHFBKgKruf992V/Cb0r8YPe3Qle6o4?=
 =?us-ascii?Q?BiB9IhVMuiqpEuYF0kp79WFBNWHkZaF0CawNLHpZJppEmWPh8LhUhUbxuz4u?=
 =?us-ascii?Q?JLiedvypY6gGBK3VJA34ddathyAqO5J62ZEZQPlbtnFbSmh+j2PbekwekxeN?=
 =?us-ascii?Q?xq//AYCz2fQSBRPyIhuaj+Fl4cbdBMZ3jvIqc1AtIlFjc5SdhSEFCKlx+w+N?=
 =?us-ascii?Q?IG6QSv8xOj1qIvjnshbzznp9Z0AFPRpDIT/1jQc29YWUc1JYKq9bblCOJ6jD?=
 =?us-ascii?Q?DYrA3PVoDApSH/9kg0UlH+bb63EpIYd5kLxS2v48PkpvaiewQ1MBLDxJcvAR?=
 =?us-ascii?Q?57CMsvIVMz47owVu7eDN519yI0MfcM83OP+1xbI7/QfzS/vkS8mcOF0rUwli?=
 =?us-ascii?Q?rek+uLIQo4CXUUGv1g+y+4S1iptVThaG/rlmSEv2dmOXUyvxcdWtuDA8o6GY?=
 =?us-ascii?Q?AM33H+m0DeUhXl+/A/PKu9J85jd94fVWUa7uFFZV+ygkT/1iVVQhSY/0mCGx?=
 =?us-ascii?Q?Qk+UwAwR1rvUUWRNTPCvbR6Ed+XoyOl/ZydytE09U1XR0n+80HnSmYrcY53a?=
 =?us-ascii?Q?9nsvzkW16fVyCmiYnwEGjByxDKIIhYEnHWEuzNAxFdBB0bX0zD5OK/5YzOWl?=
 =?us-ascii?Q?3sYMXydeNZJbzydPWlzSK1DYfREQPcrv13PNyMmizkDY7ckLZi5HHRujKJzJ?=
 =?us-ascii?Q?MAPUqiPHCJyp7UE+B5qlaI36?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d427bd64-1d90-473b-4e73-08d9574f7b20
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:55:13.1162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: utbzvMeQIdubcI1qE0RZcc6+PMSHwh+ZPFRXKPJG3On8ER/jNoQqoa9WG74nG2WI+UooeqSIgRXBgqxUfGOlMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since all packets are transmitted as VLAN-tagged over a DSA link (this
VLAN tag represents the tag_8021q header), we need to increase the MTU
of these interfaces to account for the possibility that we are already
transporting a user-visible VLAN header.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d1d4d956cae8..fffcaef6b148 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -982,7 +982,7 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 	for (port = 0; port < ds->num_ports; port++) {
 		int mtu = VLAN_ETH_FRAME_LEN + ETH_FCS_LEN;
 
-		if (dsa_is_cpu_port(priv->ds, port))
+		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
 			mtu += VLAN_HLEN;
 
 		policing[port].smax = 65535; /* Burst size in bytes */
@@ -2664,7 +2664,7 @@ static int sja1105_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 
 	new_mtu += VLAN_ETH_HLEN + ETH_FCS_LEN;
 
-	if (dsa_is_cpu_port(ds, port))
+	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
 		new_mtu += VLAN_HLEN;
 
 	policing = priv->static_config.tables[BLK_IDX_L2_POLICING].entries;
-- 
2.25.1

