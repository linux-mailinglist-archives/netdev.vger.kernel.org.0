Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FE643CE9D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhJ0QYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:24:00 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:57505
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233877AbhJ0QX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 12:23:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjX5L0L4JGL6gn8t1t7lNblihpJqmV5V/NJhI2KNn3hY+s6K/KTldQ/a9163iMOyWtuXiqrVLUmMOqNslcb8TBtWJw1tZF9S5Hfn3Rhjo6rIPM5qSmtxKlL2ZRzBvyy7UHABfk1OGNPITUxY4cNCsfKrPedubrKLH7/9rJXj12ai8Ixbn+lR3RBbJlIT5gl7bLWU+ALb6EC+8qPSK9fHuKdOPt7b0qA9zuBjGWqiAHeRrUxENGmF6RAtpXGAQmwnpVFadGEqhYfcrr/2SutCTFvl9Hv9UuHV1tsSKpPhmAUqyTOiEAwOHQ0subFZ9WoCItNjCm8geBl/uAQIxzjcrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIXyMHEOnVLClOYb1VqD6EDIWXL49j79jqBQkkcQ+M4=;
 b=SWgelPtGX0Uqw/8fM/equL0e1EviViCNWWbFjtHuY0+3VXICdSelqfUCPmp3L8ByIbd5wRx/FHmILSMrJ7JHm1ZL2pVr6EM4xYgDVtXAzP0ymdPt9sJvjjIacD5g+Wjwja8gOWuTljBGW4oMc/nmCs76vMm5ElQQM26sWajMpKpQs1pw7Q/ig3ltsbu99HRJdnZkjRN2QbsCYOVzcJw0QW+Wi1STmGAe8SF6av1Qar53uFCpnYHGYHdaGe8LiINALm1zB4d84zpElIDHuWj23Il1mZwA7NYP1luMpZLQxgYl/7WzlG73Nqd/Judg0nKjXVyfe22wztVUKMBQwG1wgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZIXyMHEOnVLClOYb1VqD6EDIWXL49j79jqBQkkcQ+M4=;
 b=EOqmmeComZzW+RD1orT7Umw9zaYR7GStWs5v46EQ3d6u0GFXJbQ9FA8lBJPIbSUdlrE+2ep847M72aShceBvGeV2EuILxcW40oJRVOS10sgdvdVtsGpcpb/Z4bmieoi+h6pfG/GRqZxv6metKJuwiVGxFIGrYEILWBzoP6lS4PA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6014.eurprd04.prod.outlook.com (2603:10a6:803:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 16:21:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 16:21:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/5] net: bridge: provide shim definition for br_vlan_flags
Date:   Wed, 27 Oct 2021 19:21:15 +0300
Message-Id: <20211027162119.2496321-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0057.eurprd05.prod.outlook.com
 (2603:10a6:200:68::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.175.102) by AM4PR0501CA0057.eurprd05.prod.outlook.com (2603:10a6:200:68::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 16:21:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3a17382-7486-42b6-f19b-08d99965d59b
X-MS-TrafficTypeDiagnostic: VI1PR04MB6014:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6014BF1CB2ABAE7378A54320E0859@VI1PR04MB6014.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Id8qhKd3MQsSll83zqGD37xzvyHyNgexPfSO6w4C6DKYDh7Quzo0dbLhKS8rU1xXuqdcWYxfCxQWiwcA5ZdSnEujAFVhtYHv67E03ul3rw9BJCiITItePd0gfPjky91NK3sshmhyyiSJnJ74rULGSpcFTCFgRR6VKw6p2HDRRIU87zxRXqSko6Bte7mhxHrHLjrIJodTXTv79S6kS3Frdy+yHSjgWztfE8rjmoIFuXQCDniLlth3ZAtiuKLFsGsIrNqZPXygx1JUq47VJwftyugOpvt6or0Miq7qUvARHXtXGNwip6rJm+WwEQralYPUSIeneXd8gEA0I5rWeXnL3qcDo6kpXc8vHmOTxmW4kBB2QtL7+EZAp0P43itV9q8Brn+N8yR+Tbiovjw0T0kfqy41felNuA0lLUKCi3Qp3mlxujHrDYi2EDsQZN6WLT/Lye1hPKHvGDg3nGc3CWepEAnIinkerRsSV2MsaPalh5EYJ2QxZC/6jGNb+5fRst3renoveAv4rhl8cIEaAc2Jwg1N2cfGDXj9HMIMs9KZLf2Fl1KBYtzSjw3DdUmTId7SWC2t+9pf44oCeEFX98wZKIGSUDAzuwb0O2RlPqtl/Sl/ag0AJmWMx8bwsYbl8S1UgvyvWng9w5a5NvevMKi1eoyVDKE/j11NnzIhF/1grxCMaIJznbEr+A60raJ/nwYCKnT9RqiElfVnheG5noVw+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(66476007)(52116002)(6506007)(2616005)(316002)(86362001)(4744005)(6512007)(83380400001)(508600001)(26005)(6916009)(4326008)(8676002)(66556008)(66946007)(5660300002)(8936002)(186003)(38100700002)(36756003)(54906003)(2906002)(38350700002)(6486002)(956004)(1076003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z6YHTIhEpkPuvsZWuatYh+ysJUL65/LhWpZMlND18O/3hjVcqmABeGs1CJJ7?=
 =?us-ascii?Q?lV5X0CfQ19++BvITXyqUCOHCWGAg0wC2U8AGmmHkrI+UNdxa3Yi0+1r4fT4b?=
 =?us-ascii?Q?5qju/Ss9+GMldHxrbxPlBINGqv4wK/OiVA83aiMhZjXsHmtmHRb0Ak1a1TDM?=
 =?us-ascii?Q?Qts/LIQHUJCsW8yIleKWlo860sSk3mC+ZxHnOuoIwdTimhLPmUF+gOoDUcGq?=
 =?us-ascii?Q?t3yLpJi62CGwDf7QXGuE2N2hzcbwaovLdHzVDCNEOasZMoeyA+TvNlpQZYcd?=
 =?us-ascii?Q?fIshNiEKrpKcXx5vJPMzQ4mKxo00zPcDuI1Nx/kttRapIzhY7BMgv8uDSZ+i?=
 =?us-ascii?Q?NV5qPA1ax1NTgio5HXU+fISisO+PZhAQWq5sh+RJFMaINLzRTFU1zWgAgJXB?=
 =?us-ascii?Q?L5P4Rt3LkSbAurTy9yo5nixRJLTsycLchMEPeZQ2xzE9aR5jrKIbKQwexJDI?=
 =?us-ascii?Q?e0WzaPa+67e0Z7XucjkCwGi9u/pWlZDuKC/UifcmmvBVGhplEEi9l3ZZ40O+?=
 =?us-ascii?Q?ORcDbBxx+gfHMp3PzBvxekeVIyCYjkus9+/hCMe1GTEL/7GUYpz+0aU6QYyk?=
 =?us-ascii?Q?TTuk3z8df+551qsjnPhtpPi/skLZF1n5C1j/J08+ShmymWLpDBzTbHwr+wcZ?=
 =?us-ascii?Q?7w9mpO5T2fp39rm/IPUQWlpI38s4enstWlnD1HXGOUYsKAYdp/bfikPDifgQ?=
 =?us-ascii?Q?ig8nySrt996RVNUq6Y4GNJ0tkmcRNsa4I/EENXfhaX7oWzhoGE4irF543bIC?=
 =?us-ascii?Q?M0QHCqlZpEvBYvFdoK6tL2YRlQ71eRDyuXxC53rPhPUNOPAt+x59GkTPV8zD?=
 =?us-ascii?Q?No1Z+XmFBzAvY5QwCabahsH3TGJ7hqJwSwqHeSkj2QCE1qyRREUGH71ff/yu?=
 =?us-ascii?Q?R2l1UZlThyep1i1XHoixmkx4RX9sr9uHBjKmb4b9akMRr5YFoO30KuCfHisA?=
 =?us-ascii?Q?e7NRYXISWQ1+MzxjyOTniEmA4xbtlvwJasifCHsYKyl5woIpk3o9ERQQZ02u?=
 =?us-ascii?Q?kBeYzQYF6At5DyFwN2uILHf6SKn6Ift5UybJ/hTl5js8HbiwI7aUtpcgK/k9?=
 =?us-ascii?Q?cjbVaUMWA0jTCRz22aLc42grPFvJk9QOhbj/Q0NDtlxkV1avyzzSGs/ukoy5?=
 =?us-ascii?Q?tcdlz6b1msL2upKKLh8VraDBhqD98OLiAHe4qMiTHth6W8ZuEYn15aqSFH2B?=
 =?us-ascii?Q?DIhMR/eyxrD2gQhPWfne4ZMobqGzZj0gb8Nz1PMaSMXyu5K2HjR+Kk0sjJ/L?=
 =?us-ascii?Q?TQuDCOuGO3htvEBkVBZWvd6VTS8OfKsLpwlnEZBPKYeqJ7/QzF82I5yI/JX+?=
 =?us-ascii?Q?CphK5Y0VdyTFGYAEeDAoEnqpcTjVM5LeyP76HZ6HVW6seb9k5dJHGmHkOrPj?=
 =?us-ascii?Q?p6QCIJTumlNy+mcIa7jR8xwFNaEkaVUA6+wWeeRfqvE6xkasXtq0l7UZOL4J?=
 =?us-ascii?Q?zCm851NQV1GvpCRH2C9G7/ovTUl6SUSpPVgEEpMr9Tu7FEnF0fYbkTl9G7sM?=
 =?us-ascii?Q?5m5MYMh3OyN3/4JTdAflyDuBIVBQcoZDWmWtsOQiJ/ryiZ2VeM2hyJZC+EA1?=
 =?us-ascii?Q?hQuOrcNfXLo6J0IeBntWnxYMFU8nX8p2oP+/ZizEIR8d5iJ6bKFcjsOpMu96?=
 =?us-ascii?Q?QSjZE7xo+GIVRJDlrYWSBdg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3a17382-7486-42b6-f19b-08d99965d59b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 16:21:30.5828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6TXh8IcDc2F9v1GmDAerqF3YFcRizk3nvcq35fFslSBKGX2OUWy/rhDG+oZAM2bA6LWboRU+CeHuqxRtzhBlfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6014
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_vlan_replay() needs this, and we're preparing to move it to
br_switchdev.c, which will be compiled regardless of whether or not
CONFIG_BRIDGE_VLAN_FILTERING is enabled.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_private.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 3c9327628060..cc31c3fe1e02 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1708,6 +1708,11 @@ static inline bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
 	return true;
 }
 
+static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16 pvid)
+{
+	return 0;
+}
+
 static inline int br_vlan_replay(struct net_device *br_dev,
 				 struct net_device *dev, const void *ctx,
 				 bool adding, struct notifier_block *nb,
-- 
2.25.1

