Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF5C2D2A5B
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbgLHMKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:10:03 -0500
Received: from mail-db8eur05on2068.outbound.protection.outlook.com ([40.107.20.68]:47712
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729306AbgLHMKC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:10:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VR9YLiBKBd+MqVaFtfPm8g/eIffkZZw4t32OexTq28FtBHJmbEH4y6LWDB3lxnz0PfijCOYGH169cTToykCUbMav//yxx6F+zsOCMVK5Wu5qEuBE29ciSx9KEwyVnTdQBIsw3Q+OugQJdmp5OY57WUT/P3z2Cuaar2ihpl2cseBMoLHotC1uj+PzAiLiNg6GNePPqAJtgkDxT9+xA31GmXvkDLxmksM9VyXwGmcyK2+6QFyhLOKyduHNwpastTbMWOTQUVr/lbxWtmY1/FBnXjaHAWK+7L+E7U14tdwbGjmmu8Sn7s4dGcfTdqL6M88HUmj6uHplUx/wo/CFEX4UjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJiFJi3lm9kXPI+NVL8+GW24sAQhlq0Kx0pJ2EBbUHM=;
 b=ZRzKNpH68Cv1gUCAyOnatdcTCD+T7wXr+bzYTOgjlU1zFBuke7H0TeHfj7CM2ZjB5kdu0XBiy5yy1bIYL0ynVl5TfGaALbDWVkH/J7nyvhBXJGuhMKQ3uOsVYbJ+VdLOXgi/dnEDNmQsQc5VqDsOmv8AdEg7MdUiiwskfhQDqB5upMfKVaQ8Svben0cpz+xoLZ3U18QZqMSbrIwg/OqP4vmQuWuYzGoQE97aIfmvZ3lZKiqiIMk2eCAFKqZo6FnOt0rj4Ui3QajWBD/5xzndpM9uKJRtr7xnvUkQbsBCM7D8kTDKuMijD0SNtSeJoIV6ArUN5ZnsaG8ntHaBbyl3sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJiFJi3lm9kXPI+NVL8+GW24sAQhlq0Kx0pJ2EBbUHM=;
 b=K2URbb08TTG8KZTvwqCi02q6TrB04xX8Kt6zLQ4hHCThhH2EJD+e3RWUOYyt8Ba9np7RkBh5W222zDroTZwDBizMUbcEQioHprrl9x6dXFRGUyWYh6lh53p37MGTQxHOiN9A7QgjbYix4ONveIVgg6o30pR8p2RSZMwnzVNL1Q4=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5853.eurprd04.prod.outlook.com (2603:10a6:803:e3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Tue, 8 Dec
 2020 12:08:42 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [RFC PATCH net-next 16/16] net: dsa: ocelot: tell DSA that we can offload link aggregation
Date:   Tue,  8 Dec 2020 14:08:02 +0200
Message-Id: <20201208120802.1268708-17-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM9P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::21) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d1fffa9e-ad94-4d9e-80f2-08d89b720164
X-MS-TrafficTypeDiagnostic: VI1PR04MB5853:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB58532F78CE587FDD616404D3E0CD0@VI1PR04MB5853.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hsstPPbFFYZdv1A6w5QJMkvMkA/E9jYb0QbOTqDyB6nQD08Eh0jDdjILRQlxT/3sVXIFNaP8a/lt8uX0uH3HP+4vkxdWHlLV4XpNdd5WPLNC+EuI4YP1kbtr4s8cVUhk9ZUC2Dhv5QMdwJdaaNM1Eweo0e/XL++QdNAPJ8QKR/XYXLt3rX77v1XmGMDMI8p2+oFz5VYmwrIxYXNpYvFRW2XLT62/zq3QNW5M3ioF1RhUsKdsIvxQ/8APLa09K2mwTDNYxKZIxazAo1CDsBrfZHiDhyhKzTGGoALtXH+5lG1C6awEnxs4tQFWknavREitAt2hx5SgGk3uFy+dKogTTNvNbIpkRoUAaqqBN91kv+9SbAjfJC08My4ySWZT1EJw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(52116002)(6512007)(44832011)(4744005)(6666004)(54906003)(186003)(26005)(6506007)(2906002)(5660300002)(86362001)(16526019)(8676002)(66556008)(4326008)(36756003)(8936002)(6916009)(956004)(498600001)(66476007)(69590400008)(6486002)(2616005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9fHK4XrK/tty3V4KZCp6k+noMA+B/3xqBbkNeGtCXcejIjRz/yMdPpsw7xNs?=
 =?us-ascii?Q?n4Pp2HVeG0nRscuAD5PoHfMnM3CrQD8d9m3iOLa5pe72nSgI8za9F4hTQCv7?=
 =?us-ascii?Q?ths+5CXFWjCellzMpE7hs0xeA/M7+HwVrPODpzjahiQF93ZrpzDa+K1D7qLu?=
 =?us-ascii?Q?sRD62W+f3naIOvUJhifRqoxUG3bR8b77TAdwWZTA4jP7NFh6oHFyD+QefnJJ?=
 =?us-ascii?Q?p1VdJLy1qP4Ol0q4+87AKl8z/HXnZ5aZrrGLqDBUAPFhdsXug3g9Kj9ykgz/?=
 =?us-ascii?Q?b5E90uHJVrgmwaaYcsPuYaZbWOFRSBiRl3q0Zc5ljQgx3oWxRB/BFRc34UzS?=
 =?us-ascii?Q?s3N7TuR+Mphip4mV1L/kISu5Er9MdjzQ+LSqXlry9v3MKDSeWQACz76Jtubt?=
 =?us-ascii?Q?pmh7PQdthlmIodrPriMYvBAIFgJVwo6u4u7N76x2EMDR1VyKDux76j8afFzV?=
 =?us-ascii?Q?5012Iqvoj9lbDiO3PPZ1x5unbHxXnmFVJFzMNHo7ixPSzjlDVO9Bvr1EwUSn?=
 =?us-ascii?Q?lbsl+HvOHdT4WuvHKngr4kkJRPmqfkGj30rdlNJA0DG7iaojLNNu1Gvf80bd?=
 =?us-ascii?Q?ZMF0ZC9atkDsItg5Ahj5ufqi/8fDTq+wMflkqq4HQ82foNS5T59h0F0D2625?=
 =?us-ascii?Q?SYTsNR/8gOiB60nx8MApwqU3x58DDFE825clbQzAevcV8FhSJy0VZYM1qKn7?=
 =?us-ascii?Q?LYJKb3bBCxXkmPO8blqchoY9X8wjlNZSlPEdIs6BfvoKsansY+BBF3Oa2dFd?=
 =?us-ascii?Q?GqWm7lNDFTFr+9/lyGVbnlN6f8CDmvSaocWmu/Cq5Iy4aYhVYnkJrcLDfjd/?=
 =?us-ascii?Q?nOFmYKe5MaoEwn60+O47MuqkMr9g+Tx6SqQhWTVPiWHPxeAp2fJlLlMQEL3I?=
 =?us-ascii?Q?u/sHqiH/eRWIo68R8XvViYbS2nQXMmGRHDlisoQPXFepDkg9wWbaCJocYEeR?=
 =?us-ascii?Q?A0Cx4kBBR/BlEPW36nphNuCzxVbHQe31hfz4dkEMmSaGwOLzZsyQ2ZMldIVz?=
 =?us-ascii?Q?Ogxd?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1fffa9e-ad94-4d9e-80f2-08d89b720164
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:42.7784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qm2ASgYJZqg7tKeGC112WDU4LU1nF1cyQ1SXLnriGVw/LJT4T22lJLKdxJPJVDi5oCWy7v+I46U+hrJRbMfQyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5853
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For preallocation purposes, we need to specify the maximum number of
individual bonding/team devices that we can offload, which in our case
is equal to the number of physical interfaces.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 53ed182fac12..ad73aaa4457c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -653,6 +653,7 @@ static int felix_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 	ds->configure_vlan_while_not_filtering = true;
+	ds->num_lags = ds->num_ports;
 
 	return 0;
 }
-- 
2.25.1

