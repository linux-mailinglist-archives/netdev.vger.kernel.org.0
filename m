Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89DD4846C1
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbiADROt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:14:49 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234491AbiADROg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6tusRhg7BgjXIdYmtOKUysQC0oJ0Dg5spbx85/nCZzUdc7f6cFNsGeGVVOtkUojnc9MnOzufo86XdQYvjyYA6IW7EOphNL8fcHGqrO3ceBgXQiCEoQ6lGcy8WU3VUzhENbAvlTP3MG8R35uSnI2A0nm79T3emsBXdeLfVD3N6kaZhPCfGtAsIdX09quMskwPR48KKDJN8pgxdNatgJBQC8aRQF7M9tldenukiGc3Fp/9M5ifqFWIMiH6OhXJ0wAaYCc2q09yI12KwsqEb1YKi2RNmFP3yZiJSpLwp+JNTrb+H/p2c1IG82IE6Tmqk3lVB+bVLrXxA06cLHdI/8HAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=URzNKK/JSdU7+cX/+G7LH8i/dpCeT6qWvk8k52pJB+A=;
 b=D9Hbn0/A0M8bwBqyf9Wmns3/G+HJjf/WVrX5eg6RQ84qRkv0qdwBqgyKYzXpZE+Ser84oVEtQYxncAWiMMPW/M4RFLiYdhrxwb/oxC0Qs6003eoxFamcK5wgM5Wc7X5qG/L7P8zjDG1czrF3ph4ud6ExsaPeU75MqHmQrW7LW7vf/sEa0K5bp2zELwFZsFO7bb2tTkWXr3DvkowJPigp9qFIRvI/ARIsPzJeTmj97MycfYMwh75ySIRA1MPRpUjjuVaO0WlI+5w3tmSm6ixb6TJe5Y2obekwaH6euyL8JRjuY45KwJkA3SXZy7eIiTTRMsA/FWQ21Zo+xCa6OxFtjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URzNKK/JSdU7+cX/+G7LH8i/dpCeT6qWvk8k52pJB+A=;
 b=biCUvZURfzwPPHRV3SE4N1Af4QSLhGYJqGn6+zXUWy+6GrZfAams+8+hYXNhKs3i39c+Rad3DFtuOYWH2+HLZ6V+nRaG7NhmUTDCMvhj8h8PDUiKE6/bE5YsbV6SBFC6NYuE/qpoOf/Zp4oAcXzU7UFPjl4zpiiLbWJVPvXuZ8k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 02/15] net: dsa: merge rtnl_lock sections in dsa_slave_create
Date:   Tue,  4 Jan 2022 19:14:00 +0200
Message-Id: <20220104171413.2293847-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 26bc477b-9b5a-4ae0-9519-08d9cfa5ac88
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104B477F2B99CA93DB8920BE04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hnt1F1fbZxWshwhGAf4AQDuHVMEbISjThaFbEHTAJJIvE/R3oYqAIpGv5sLTEvUqvo+rl14T4ExX4SDQ5075exXFpYwYgejcbc2JvvE7I2cWRhfoNvoZacqKQo0S44Sz5Expc7zryOo09UwDgutFIkT3YYOeya5xqt/kLbs7dwK68+8ULzIyBNJOrQB+Na4Qs+Wyrd9OEfYA8VHDI86arY3Tp4zsYcXkCNOTCm0GERajlmM0sQJ2qkGHxUqaZpXfHN1dsFdKzvMsO6AxQIEMf+Vfh/LQKnBezZ2aRTv7++FhBiHD1I1Ltj9HPeruypnSHX6IDDhUnaj/rmM+C/sttEHUQV2wYDg2Gapj8cvRbNdR6EIKtKqNPX5KxvZICIEOdK+6gJQ8uv01k1AkO0OvYc21LoJ5k0BY+z69EsJiJHCa9cx8j+Rkp+n91Si5pJ0KsKYhJiIERxXiJOv1JuGZ1rTvZsUJ0uny1zrYjL99a+Hy4+1Hi+QkidEDMBJLw1TMmFCXIihsxPkFi2Z0iKG9ltAsB7nNRqqi292+PpUMr9qQrMnLv+oA4wL6PFiqN3rv+M/OVSpxxFGtJu8JRbuj3xlC9MJxrr/sHgDPBRnB5JSdAjiyR7Z+gZ8GE29y+qocSFUJHMt60q1YEiEHgGAm0AwkL0ACM4qnlgPX3z+QZIZ1l12WV3EGehUydzWlvmYaqe/HsHeLHKtOjlRbsbhfNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(4744005)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VbB+4Yn769IvCOvMoQV4HcY1COmXKpvJtC4znFcVnse3s5GZm+v7DPB23uw8?=
 =?us-ascii?Q?E0pTRm9V4PKL4IYiSxN3RC+mPijO4f10kLTLlOIQ31d7CQF2AA5sMYrwzh3Y?=
 =?us-ascii?Q?A8v/35LI0fX0QRH9vGEdE+NJrdpXuJpL0WL0+9Grcpa/mx8dJAaQ/QFpk/cx?=
 =?us-ascii?Q?mmO2E9lfONhEwYAqDa4trs5T1EiEKzO1AK3x+qXODvSBaHK8YQVIObG/2j4G?=
 =?us-ascii?Q?HpQ8CW5xtr9JoFhVRuB5B9RedvvCByTcARXIUu/YitrQD7qlyOZJ6jLZZkZm?=
 =?us-ascii?Q?xKCkiH7LxBr+6SHcDl04r8VkgLnDWT8l2PJKe/H/wE1UzzmCMlVhD6tL0dD4?=
 =?us-ascii?Q?4BBv3R8xjmLMN8KfSlYg5PfLm0XnZnH1rbqempHQpUMkSl86e+WPqvvvVyjN?=
 =?us-ascii?Q?vkNCZBAhzsv/2Tbebzqlkrp0SbzgW9MBUy2ylChlQmy2JA2J5xyygUwVPEBw?=
 =?us-ascii?Q?7v6W0NmTj4p2OHNrRnwbElroyl43hMkjLloHiLteQJ54UZlARnr5/rEspv0U?=
 =?us-ascii?Q?RcKDuP1aibNV3EyUzmhpNZeUaBr9LgPfRnDNH3avW27LHhEE+sxEGpE2hXFG?=
 =?us-ascii?Q?D67TYfRIfxRqPpyp6vpz0kwP6NZtoSx7vq1CYmjwagpQjSKMTkt5blS+cWIJ?=
 =?us-ascii?Q?Xq15MJVX5dNJ4IvEB6QpiJezUvpvJgiLwppEIDQBfGW7lehu2KfrXaqoORka?=
 =?us-ascii?Q?B/AWkEYv6yxpqL9i+fZDxDQxaLlIzX6apklm5XxKYGYEuM5Tohm/ntXvK4/x?=
 =?us-ascii?Q?Hwa9iDL+voRvexxWW0UjYNolvzcxFOj25N2Fl913dgpBV3PimiMWsjtcPgQT?=
 =?us-ascii?Q?EbcVZ/oRj9exCzdo4TXGoFzSmbqnj+gvp03M8SMbvROz91T7xR5qotDqeFXv?=
 =?us-ascii?Q?9iwu6uBLrj8Hl615PhcElMlLt/tyrI08tBIA9x5HKHJH+g72nE6mEbUEIhj/?=
 =?us-ascii?Q?xKd0ywI7DhUaE3IlzjrUNz2+z/uQf2pDvfqAHHl7iwN3iRUhW2/FL7u37jsC?=
 =?us-ascii?Q?EmQm7hGKHF1LES/M5mfczoqSDzah6H+KOWro1MFt8GHCH6vEUPu4dAQ0Dtbh?=
 =?us-ascii?Q?sTiVanhturnCf7n7Dll2SHuiN7Sao9TqsUxN0OWHvVR4baZPDHUoF7E/Kk73?=
 =?us-ascii?Q?QwwnKXdEoKS3cFtSYgN/BGP3hgKaQJVwmcpDx3XkzDGq/2sOwKAV30E2NxiV?=
 =?us-ascii?Q?u+tkFXZ8ShzLSpaVOyJGjfmYnP8a4Un0Kuu0rLefZbf8LO9sxGeSOmyVCbjH?=
 =?us-ascii?Q?7VIdqTj2tjRPMYyF0M3xioow+aSrNSqxTckE0Ik9B/lCYvahCwxxewU2J0Ww?=
 =?us-ascii?Q?cQM1aCL2FuqSdxAvWDgVBXL9hfu+ViBcIIOADnkdu4L9N0CimJGDJESM8wzz?=
 =?us-ascii?Q?8yNqstc3DHIuO2rW6TdfVcm1VVu1ZA9raAbP42XHGcbw8uAPj1o7kWK/RH43?=
 =?us-ascii?Q?XNtcmNquBkmnJE5d+E9TDRomLbdu5mXi69oe4MURmPr6dL2lxH8tnTYk1M5Q?=
 =?us-ascii?Q?pRSoEFvXXsuZ3JmT3tD/O2sc45JYm8TU5rIgIGUb0klCDlvOrYo9COD83wR0?=
 =?us-ascii?Q?y1BHHmndjwbQ975qFwA5oAO1as2fs6P7RNfF1p6lsibVnKuQRlf0enScm0HZ?=
 =?us-ascii?Q?PQV6lpmFnZtu1OcVYNMCtTY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26bc477b-9b5a-4ae0-9519-08d9cfa5ac88
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:32.2852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urJBWgq2XaFkW3CJ6/RauJOQLHLomhmD7ydtI2LNyE+oW2ZTOPH50CwY34SaStyRWzYEjoeDzqCABNkD+yXM1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently dsa_slave_create() has two sequences of rtnl_lock/rtnl_unlock
in a row. Remove the rtnl_unlock() and rtnl_lock() in between, such that
the operation can execute slighly faster.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 88bcdba92fa7..22241afcac81 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2022,14 +2022,12 @@ int dsa_slave_create(struct dsa_port *port)
 	}
 
 	rtnl_lock();
+
 	ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
-	rtnl_unlock();
 	if (ret && ret != -EOPNOTSUPP)
 		dev_warn(ds->dev, "nonfatal error %d setting MTU to %d on port %d\n",
 			 ret, ETH_DATA_LEN, port->index);
 
-	rtnl_lock();
-
 	ret = register_netdevice(slave_dev);
 	if (ret) {
 		netdev_err(master, "error %d registering interface %s\n",
-- 
2.25.1

