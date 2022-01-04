Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F014846C9
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbiADRPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:15:02 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235560AbiADROn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEDudDnxHsqGWny9pVKhnKGEKx/30dRMtYDdD8KfHk53CBnIbT+/aICuABFA6ILEMDL2prKKjXIo7Yg1ktCeDCx22j+j3RK5Kcfy1IVrDlZ3qQyAMMu4pHzF2UjMdNhCcfbn5CL3gsR97s26Oqz9FoYTrMf8g7OgfQO/Z7wrEM88mlwOhihJoP/wkPWjTx1De2yOjVhzBf2tSQBa/Czxnk+twsY9znRn6OIp1iZU4zCTsjwSkXH9rzG6IeXt+kv/6+y3PCZNc4UsLgNyb+p2XOll635Jcga4/0SbQANANBG47Yp0F/37mYUhc+iZkgVf4YdA/0CxmkoSRnA2c1Qxlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZPMTKyZaWhnzT8T/b+FyyuwxuT/r+Fxoyhrc/77PkA=;
 b=kxVQEHD5S6xSET/cer6SJHXSxEYfasaVSKv30J5r3cY4cRgkVP6Qay02KPknfTtCp78BncyYZOFkCJBnjsHhROuIuujGCNNGgfdN6ITXz29Qo4XOGi0Y9ABJVCNq5EOMZhc2hKucv2aXZNiZnroFGMbZ/Sv7FCTfSW/BPBkCAjfOyC/B2cL3WqPeCi43f/UfDHOB+ockNu4Ujlw0HfJoZZXTtUbG1lyucvjtK0QqsgfGuxdko1grVGSjOy5tr/a+an7SLryGX1lQTHPGmzSAIJJ4hqUIcaNqpJ5pG1znF9i+MkvQ0GonY8Dpep+1DWOqykdRvXOsxys0Wup9SO/r8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZPMTKyZaWhnzT8T/b+FyyuwxuT/r+Fxoyhrc/77PkA=;
 b=UGqpEW2vEJ7pG2LXqzcZby/LbIBmjWsmFt6AmaiPTSyb90gr9BlUaArBULxgNtwvymMClXsCf3SZtMK1j4ok4jsFUA+0PVPkK5D3Pr1nUlIkU5EXsXhFXK46fftUE9PQ2vrcGFSJ9hCS3oBYkm3VPm9HCeYB39GbbtMjLyf/+dg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 09/15] net: dsa: move dsa_port :: stp_state near dsa_port :: mac
Date:   Tue,  4 Jan 2022 19:14:07 +0200
Message-Id: <20220104171413.2293847-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
References: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0192.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa9476db-c141-4d48-a50c-08d9cfa5b057
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB71045A373303D731BC9ED36AE04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9t56exlxz4ElCuUe+iiO2CzXt9ZeRqFSGJCx7+EB0rJ3iISLWTWpZ1CGg9A84r+R1j5M/7HvAferuCT7fus5ShLr1IGpjLqg1zly7FY3YQdxtXJRj/lDtgsKU8E/lSYfZFEfsHZtfq1exXlIICnVLUUIpEUac2GAVT3OS0C2DHWmvNwIx8xu9LdMqq4KQAJEpatPKTNiSRi4dLytx+9xunBsFpsyOjL51QwfBtInsPQjafOgqeC3qJW/0AnArysZD2nkXvBFLUXs4z3IAyytwvgDkhKq2eJNALwiP2lZjJJW5grHatSn3zGqTJsNbDJlBYueziE5o7fr77mlNYA/KXz6tuD7BIBrTENM/71h1jMArSvqFyvhdlO3KfadfWsFLGBLEZtgnNs22FebDCBiPhWdtbXA28HkL78uwkL29nNcGubpNeeVMjK0heUec7TrPgKS/FK7QkuONXXnXY5U3z4IHGxxV/0l5oXSLTHzhk8CWDLEeTCah6iDyQeSW3YR9hKO2beFpYEtZCjJQ+C+HgcDiGqib3c+DrOmRtDy4F76S4S3y+/QsoAXaouEl7h6f49C8MSsHxWke2LWFvSySuz6Wgi+iiExwjUdt42BZ+MwrMZdZOYj3UIQsSqo5F2otGJ8frToLQtrPbv2n6gTxsFMjVZUR9n6Ntr7nGPcBaKu1F2Op2o03HFt0fgSG2JO31bEmQR+ULDCZT7KrdU+5q4spQ0FggyxYjfhEEVXVYI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UtUUMhxsXI+/wSErIGNjbkZUwBWvDBWyeKP5Tjh8lSa+hLQhs2aS02/wjba3?=
 =?us-ascii?Q?t3jSDZRfgjhljHkVj5e44dSsbjqQaMl6v5F2cQ7FIUl8Ws5tca280A5COAz1?=
 =?us-ascii?Q?jtVuPPbJqCJnqBltUhpP6ZiYNuP+X6pgN76UkBfPWF2s7GeF6XkkKnzaKZBs?=
 =?us-ascii?Q?sI+ByM/oTohuSnKeII/p4kJYcLaCWABUZdqtgEQtZch6SX80+xpeUDLmQWaT?=
 =?us-ascii?Q?ZDHKq8z9j9R8lgsI05RdpzFq6mpKbbP/hXuE5swq9uZZlVP0E9Ag2nnxeab6?=
 =?us-ascii?Q?mrmNF3gWI3+GGlEmXJKX5RXZ2dFbPP4VQBvWFQjj2m0o1IjLKxVVsO5RjJ9K?=
 =?us-ascii?Q?t8aMahxHvbE4LF+G5V0c5N7ODYIuOuuIaWcELDbEVZ+R4ZYaUbb96rjRS77Y?=
 =?us-ascii?Q?pvjHmippGWZzTk3opgjzrlrXDNb3feKE9Fknt2xu4TIXi9pcjGE0vsmjy1P4?=
 =?us-ascii?Q?RnXbH98SMW1KH7+h+2YT/irdlxTlqOlQPlte4z7Z/RQdTlDUFxY+3vHsEGxh?=
 =?us-ascii?Q?erbd3oLHNLMl+l8gYjrVub80f4gu5hYzwdUYzhbDPR1vfQbuAAiIgDoW/nr0?=
 =?us-ascii?Q?MyIzhAosE57951a6CI13kXyuqceU25Arsy3l5cp+dvUZ7m5ooyWypgQGjZ1Y?=
 =?us-ascii?Q?qz6NDCR6pQ+Z1Z4zTj1Jyum+0qtRHYMeF+qVY1Nkr/SeKWukNf8+ZNl81qqE?=
 =?us-ascii?Q?UBiWilWXVBfphV/X7/vzdWkJd+Kh70xwnq8uL85guwKbZJau/vo4dfCMcbe1?=
 =?us-ascii?Q?yoXKyev5ija/MsYvP6CybEASLmFY9sYFpO4y2cWCq4TnZlKV5BgE+fC4c0jg?=
 =?us-ascii?Q?qhlu1tNss5fiiDpW4M1Nmf2weRGK2hj/xUseUBQtj1N8GzJWE0qolC+XZUTh?=
 =?us-ascii?Q?v4mQ8L94kNZN9HmNZl0eyf1Fzz/cc9oWyd3lBfGB2UK8umtYtfpuQKc23htM?=
 =?us-ascii?Q?LQVTalbeoJDjwVANfAF1tkg1xNtfkNft2JG8BGKpsHofjAogi0H30O7Bkp7c?=
 =?us-ascii?Q?22XpUbS/WgMSN41uJwR/ofPxUDN0Thxy8Qk9q6awRW+9n1U5XLLMz0321+RR?=
 =?us-ascii?Q?CqEHRY/eYkumheh9cI4QFQNP3RiaidpvQ9jClaEQJZ3fN31G9JRCbrtZIo2E?=
 =?us-ascii?Q?xK6ro44IF31m19WoeFs3gGt4JENdOlYGk9yQ/fVlHA4HDXR7pV/bi3FNruwO?=
 =?us-ascii?Q?V7DQdQ7HQpj3jLxzEcMU8THCcQsZ0b3glCPCJogtGJ+aj6I8GCPm1hysOxAO?=
 =?us-ascii?Q?E1ef+CtZP/WFF/fwq21wSiTFEc7kR0Yo9sHOuSqO3eKCBaa9Sx7e8+ObRIIL?=
 =?us-ascii?Q?78cIN+jpNjKUuBsMQtREmyy2i6c2SdD+b3nX/qYYdwlvqHoDiD/lVUON3ZUY?=
 =?us-ascii?Q?iOFiZcu7y7mVMuNVOVgIuNDj2Ag52TMMAJV/EjWGj9jF+5BOfQk0m73wPpVU?=
 =?us-ascii?Q?DNYpAvPEHzfFOrZjK/wsAgp+C00eB2LvUQGv38v3ALNUMn/1eL/n2874CcR5?=
 =?us-ascii?Q?Yw06UZDBMDqwCK2mWSMcI7/aDMsxEr1ITuGiAmKFtDb0DzC35bU4C8HAZtFK?=
 =?us-ascii?Q?Fp+bHPIQ/dbdMAx3mBb72vnbJV5HY+br+ewvtWtx8UMVQe5EfAQ8AhKcfCSD?=
 =?us-ascii?Q?TMRrvT6nAzf7bevV0Cnu6wQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa9476db-c141-4d48-a50c-08d9cfa5b057
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:38.6598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +50BLb/TEy6MTg/+C01egY6x0LCbK8ikEsK3diARMVQPxeLb/cdqYHmdl0wFOHMcLwRopnRGeOrlCJW0o2kTIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC address of a port is 6 octets in size, and this creates a 2
octet hole after it. There are some other u8 members of struct dsa_port
that we can put in that hole. One such member is the stp_state.

Before:

pahole -C dsa_port net/dsa/slave.o
struct dsa_port {
        union {
                struct net_device * master;              /*     0     8 */
                struct net_device * slave;               /*     0     8 */
        };                                               /*     0     8 */
        const struct dsa_device_ops  * tag_ops;          /*     8     8 */
        struct dsa_switch_tree *   dst;                  /*    16     8 */
        struct sk_buff *           (*rcv)(struct sk_buff *, struct net_device *); /*    24     8 */
        enum {
                DSA_PORT_TYPE_UNUSED = 0,
                DSA_PORT_TYPE_CPU    = 1,
                DSA_PORT_TYPE_DSA    = 2,
                DSA_PORT_TYPE_USER   = 3,
        } type;                                          /*    32     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_switch *        ds;                   /*    40     8 */
        unsigned int               index;                /*    48     4 */

        /* XXX 4 bytes hole, try to pack */

        const char  *              name;                 /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct dsa_port *          cpu_dp;               /*    64     8 */
        u8                         mac[6];               /*    72     6 */

        /* XXX 2 bytes hole, try to pack */

        struct device_node *       dn;                   /*    80     8 */
        unsigned int               ageing_time;          /*    88     4 */
        bool                       vlan_filtering;       /*    92     1 */
        bool                       learning;             /*    93     1 */
        u8                         stp_state;            /*    94     1 */

        /* XXX 1 byte hole, try to pack */

        struct dsa_bridge *        bridge;               /*    96     8 */
        struct devlink_port        devlink_port;         /*   104   288 */
        /* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
        bool                       devlink_port_setup;   /*   392     1 */

        /* XXX 7 bytes hole, try to pack */

        struct phylink *           pl;                   /*   400     8 */
        struct phylink_config      pl_config;            /*   408    40 */
        /* --- cacheline 7 boundary (448 bytes) --- */
        struct net_device *        lag_dev;              /*   448     8 */
        bool                       lag_tx_enabled;       /*   456     1 */

        /* XXX 7 bytes hole, try to pack */

        struct net_device *        hsr_dev;              /*   464     8 */
        struct list_head           list;                 /*   472    16 */
        const struct ethtool_ops  * orig_ethtool_ops;    /*   488     8 */
        const struct dsa_netdevice_ops  * netdev_ops;    /*   496     8 */
        struct mutex               addr_lists_lock;      /*   504    32 */
        /* --- cacheline 8 boundary (512 bytes) was 24 bytes ago --- */
        struct list_head           fdbs;                 /*   536    16 */
        struct list_head           mdbs;                 /*   552    16 */
        bool                       setup;                /*   568     1 */

        /* size: 576, cachelines: 9, members: 30 */
        /* sum members: 544, holes: 6, sum holes: 25 */
        /* padding: 7 */
};

After:

pahole -C dsa_port net/dsa/slave.o
struct dsa_port {
        union {
                struct net_device * master;              /*     0     8 */
                struct net_device * slave;               /*     0     8 */
        };                                               /*     0     8 */
        const struct dsa_device_ops  * tag_ops;          /*     8     8 */
        struct dsa_switch_tree *   dst;                  /*    16     8 */
        struct sk_buff *           (*rcv)(struct sk_buff *, struct net_device *); /*    24     8 */
        enum {
                DSA_PORT_TYPE_UNUSED = 0,
                DSA_PORT_TYPE_CPU    = 1,
                DSA_PORT_TYPE_DSA    = 2,
                DSA_PORT_TYPE_USER   = 3,
        } type;                                          /*    32     4 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_switch *        ds;                   /*    40     8 */
        unsigned int               index;                /*    48     4 */

        /* XXX 4 bytes hole, try to pack */

        const char  *              name;                 /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct dsa_port *          cpu_dp;               /*    64     8 */
        u8                         mac[6];               /*    72     6 */
        u8                         stp_state;            /*    78     1 */

        /* XXX 1 byte hole, try to pack */

        struct device_node *       dn;                   /*    80     8 */
        unsigned int               ageing_time;          /*    88     4 */
        bool                       vlan_filtering;       /*    92     1 */
        bool                       learning;             /*    93     1 */

        /* XXX 2 bytes hole, try to pack */

        struct dsa_bridge *        bridge;               /*    96     8 */
        struct devlink_port        devlink_port;         /*   104   288 */
        /* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
        bool                       devlink_port_setup;   /*   392     1 */

        /* XXX 7 bytes hole, try to pack */

        struct phylink *           pl;                   /*   400     8 */
        struct phylink_config      pl_config;            /*   408    40 */
        /* --- cacheline 7 boundary (448 bytes) --- */
        struct net_device *        lag_dev;              /*   448     8 */
        bool                       lag_tx_enabled;       /*   456     1 */

        /* XXX 7 bytes hole, try to pack */

        struct net_device *        hsr_dev;              /*   464     8 */
        struct list_head           list;                 /*   472    16 */
        const struct ethtool_ops  * orig_ethtool_ops;    /*   488     8 */
        const struct dsa_netdevice_ops  * netdev_ops;    /*   496     8 */
        struct mutex               addr_lists_lock;      /*   504    32 */
        /* --- cacheline 8 boundary (512 bytes) was 24 bytes ago --- */
        struct list_head           fdbs;                 /*   536    16 */
        struct list_head           mdbs;                 /*   552    16 */
        bool                       setup;                /*   568     1 */

        /* size: 576, cachelines: 9, members: 30 */
        /* sum members: 544, holes: 6, sum holes: 25 */
        /* padding: 7 */
};

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f16959444ae1..8878f9ce251b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -258,12 +258,14 @@ struct dsa_port {
 	const char		*name;
 	struct dsa_port		*cpu_dp;
 	u8			mac[ETH_ALEN];
+
+	u8			stp_state;
+
 	struct device_node	*dn;
 	unsigned int		ageing_time;
 	bool			vlan_filtering;
 	/* Managed by DSA on user ports and by drivers on CPU and DSA ports */
 	bool			learning;
-	u8			stp_state;
 	struct dsa_bridge	*bridge;
 	struct devlink_port	devlink_port;
 	bool			devlink_port_setup;
-- 
2.25.1

