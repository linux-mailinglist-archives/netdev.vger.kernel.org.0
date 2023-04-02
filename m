Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7D36D37DE
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjDBMia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjDBMiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:38:22 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2073.outbound.protection.outlook.com [40.107.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0232D93D1
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:38:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aq4gxwSRDKUTjy6TrH562GdwpFyl9n/IXXXd8JeWjoPaFZoqirZZjjIkpLdWxE8T9qgB4bHrXRLVO0BQ9q0/VYmhU9140dlrRsNA533e43IVXSZPweMtuAI9gsypyeoN0FU2IhGcM+Q1XwlPbAPSvy4aObEh5i061DFrIXCCd5wCF28XkEqaHIqJNUR/cETRkKq7kJQNIPPyu8+8mGa8WH3rpAdVwOs+tX/ml9MaIN0ZY8frcwLXojCW8KwKZ7D40dvTHvMjPUhG69Y5U/1vAWBryLGPBvu6+b8qhCdpxTJuJjqOSanzhgYcf37cWwW5WVJiJLvaPFdcwKk/l5rAPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eL+cB0v/0Xkp/smxgdxzoKE4eevSxBe37gUKT5xBW6s=;
 b=jGnJTeiccx2UUkfubVBXVFoKZ3r9XujR6uhH1xGujp3lmxNRAMw22cxaxg4Lm5rUF5dq2NCi3WnpVRrl4MvdkdW2l8k1YAH6KCfLpRIbxp1gStcdQlrQtp/0ZQwurqu/O7CDLODXWbgU0uhcgGIaZO/F8NvQx8A/uSRE3uIGJRBRab5SvbsIe9wsoVZyaz9at9HoS7gptVdR4pGo8XPaLqL5JQou40qBQ6JUV2dHLjnXI3wZstXbaiFnxZjQlgt6EcxjI0D0ia3j6kLrLpM9idbPm+pRFGHJhQ4NmxN9EAroQ+l0zZ0pZJiUy8EktnzFFlu9JYuWV8C8eFzftzr1RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eL+cB0v/0Xkp/smxgdxzoKE4eevSxBe37gUKT5xBW6s=;
 b=ZbJKx18kSBds8lX4OBkPpjKcrKiXS1AqA1w9m7ejr+iTpPUH2R6/pRbabxmM6Px+bjBnsiZ+gSKVcvjq/XIu1cPaIuzgZ4CncZKOuRkbu6bzfnC3hU4MIiIZRuX4VFDoC4SIJ2WaC3sRcoTpWI61f7btHmx8jm/zz25wibcCcCc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB10052.eurprd04.prod.outlook.com (2603:10a6:800:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Sun, 2 Apr
 2023 12:38:14 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sun, 2 Apr 2023
 12:38:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: [PATCH net-next 6/7] net: dsa: make dsa_port_supports_hwtstamp() construct a fake ifreq
Date:   Sun,  2 Apr 2023 15:37:54 +0300
Message-Id: <20230402123755.2592507-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB10052:EE_
X-MS-Office365-Filtering-Correlation-Id: 3268e623-e5fd-4f1a-1da1-08db33772085
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k2RvZoYo2s5mHS+mHT9MGx/54BB/w/0bvMrB1G2XLTBN84oOI4K1YexK+5eyezlICcZxJVUfRW8iAv6SI+kPs+lGJdTvPlcmp39VZMwFfaSFlnea0RO+K8shg5EOj9Xc54snGNPIHhSjbt2wmr6pQKPIroAKBAPPJentn3GUbdxX89Fqem2uveetjBZkoW4t3KW9RFovJLz39appmF2JyMrQeohUSyAv9vZ3QwtbcTcHV/oJVWV/+CZGjkRRJkB2vBbFdnp6jRsyYXdhDiGoqoWEvINlVetHUp2xMA7Y65iH+NBGzmBnZ5p/kQzdnb7DAgFJt1QA7NkkCkphc7X/V4IQ5lt4WVsu/dR8PT+rbC5Cqx/nWjQbqHYTTlX5kNPOh9DlxFnnGa85tSWK9XYSS5e0Ahh6vdLwYdq2EtuRpOrAyw/5dPLwddngP2SLlj9fwzpmEpQ/7YlGclqRQ52a+RVfPnkvUKJFaZkij3niQJO3DMqr5zEe5uE059zvva9NIUglnZYdyv/AuSFxuXw1HQGuYh+OVqG6RSkna55J6oLGJfDneArxmHHe9slquTyE8Gi6te63QhfYlE6hXNscKkRYrQOS6N3BmYOPjFEVIu9ZKS4XXAt9PVH04d4XkBHD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(451199021)(66476007)(86362001)(36756003)(83380400001)(52116002)(41300700001)(316002)(66946007)(54906003)(6486002)(4326008)(66556008)(6916009)(8676002)(478600001)(7416002)(5660300002)(44832011)(2906002)(38100700002)(38350700002)(186003)(6506007)(6666004)(1076003)(26005)(6512007)(2616005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+0Tu+gUoKUkGxCxep/b+mhQ7iAwA8i8A9Gof3okTos0j1NrVpwMG5i17dMdr?=
 =?us-ascii?Q?3oYE0SSbGs79+SMMmhXf0oj7Cc7EPdl0gAiiM+3P/P3prdu4z2ko2cvynls/?=
 =?us-ascii?Q?lpbYHkaeZNbc54dWtTqpUBxTjAVj+nfLFRsN7BedyH642KgpFQYm2WiSVQav?=
 =?us-ascii?Q?r/OKLbH9C2lT7CkCRFdHU0HfIjjOPxa+NblzSMPZYUwLnxrB//MeGIWkZS/R?=
 =?us-ascii?Q?lCzogtOszKJNziQuuRmk82FQhgYDv+h0HHrv1VH0Qy6HcAjHzTjVusbzU9Eg?=
 =?us-ascii?Q?H9QcpPmc1slXeJsCPKM0oIONzjY3Idr98BB2WVi9i9b+nSGRgW6OKzsSEFug?=
 =?us-ascii?Q?kzQMRMb/3w5bYpvFkdKy5JUN0OdK5kKcnBbMvQkvhlK05YDNKUa2TvjIzJU/?=
 =?us-ascii?Q?VIfyTSNWg/tWwQ6Lc5E7xmE4kOACLl6qgLB+BL2cEPn1TpUThxeXGl7ZGOjq?=
 =?us-ascii?Q?pCqEiMHteuWvGaiA+tm3I4SGLp9cUo+99v+ri5qeANzoeFspqeVC0BllK54P?=
 =?us-ascii?Q?BKxwML7S9e0fpJQuk5g2niMEfMrr6m4PJ3nWvMj2EjDDlnE6H2fEEY7phrq5?=
 =?us-ascii?Q?2Cno4y1T6ETGd0t9O40dMikPzL0eyAHxK+tUqS7rOn0vNRXQOkEzdDAFuodB?=
 =?us-ascii?Q?FUJ0PkSHXDMgqSufh0ee+ZmDBp+/O48u8w2hj9o0E2OaOfFMCaXF/4nrqTW1?=
 =?us-ascii?Q?CemJUTG2jpX+fEKBaKR4RtcQ4KK/hlEtkwhlKpW00+W7TGJEW/BE6LYQZ+Dg?=
 =?us-ascii?Q?N/od8N5maYPh8nh1qVVJODvn8DPEjzl9X036K/n20r59lUFg73CAbmAKICJM?=
 =?us-ascii?Q?6sYDto/qJ6SS9vF8wHw2wKqAsL58lomqjopTYkBPykrV71mSqKLVmv9RDIOp?=
 =?us-ascii?Q?nYhQRguBhUm598sNS713C7bqCXyfUJDCZI2uquNzqV4SQJ22UqZX6NC9yC34?=
 =?us-ascii?Q?UKRcYVGuPJdberKw5b2smbtgtQMICmCEwyEyLR6CX/uw2p89+8bg4BhDKSvY?=
 =?us-ascii?Q?ZGIQq/QhPJ2jOde86KngMffWEhZHfwtB5vS/yC8l7fYa5fQID7XDl1a/cfGs?=
 =?us-ascii?Q?/MmG6c2fnVN+JQ8hYj3ede9QMtuKLaVkWs7VXwmjoHlh3wrSqmu5Wr3aXb6F?=
 =?us-ascii?Q?teUNKFtabmQycCQxevVqQ8s5DNkIY5Gn1axJWtTx/4oAYm9jf+p6Sp5LX5IR?=
 =?us-ascii?Q?74KB7GZrwI6o5Dv44zgdawLMP0Ux8At/ahtEy00I1HS646k10iVQsafJ45Es?=
 =?us-ascii?Q?Ugx0a3KA3ufstMiTU1BxrRsu732bL5NgKebykSjgjX3zphxoVymMv1AndUXw?=
 =?us-ascii?Q?RggE33y2HIjElISaVNzbF6pLrQU/x1JG9Pr4DBnvMJf/J+DNIiTf6/WNMSAL?=
 =?us-ascii?Q?bJgr9dZDSZ7k77y1fHFElf6/2O5wMSPtojpUiTYSNMspHKKWExMyfGXIYfS1?=
 =?us-ascii?Q?B4f5Q1YSKt5m21hOiXTi4avEHMhrUSE4GMujLaMD+dwDaAsGY3Jfi8ZPzshu?=
 =?us-ascii?Q?C5MwBfZEffo/u5kurMwpjXD325iWI8mXl2u5NjJPA5KxoXRuU0fNV/ACJYlf?=
 =?us-ascii?Q?O9uf76UVh1o38iOZtI9me6MSLyP4t18mEZkhIgRzlzNRm8j0netDsxes4Lo6?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3268e623-e5fd-4f1a-1da1-08db33772085
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 12:38:14.4365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EXy5+lYznoTqp/d/rpyN/1NikJh8owuxOduY0LbY69tNXL3aLI8a/WJokHjad09vlaWXaE9uEDKZLfFSzpTiFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB10052
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dsa_master_ioctl() is in the process of getting converted to a different
API, where we won't have access to a struct ifreq * anymore, but rather,
to a struct kernel_hwtstamp_config.

Since ds->ops->port_hwtstamp_get() still uses struct ifreq *, this
creates a difficult situation where we have to make up such a dummy
pointer.

The conversion is a bit messy, because it forces a "good" implementation
of ds->ops->port_hwtstamp_get() to return -EFAULT in copy_to_user()
because of the NULL ifr->ifr_data pointer. However, it works, and it is
only a transient step until ds->ops->port_hwtstamp_get() gets converted
to the new API which passes struct kernel_hwtstamp_config and does not
call copy_to_user().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/master.c |  2 +-
 net/dsa/port.c   | 10 ++++++----
 net/dsa/port.h   |  2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 22d3f16b0e6d..e397641382ca 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -212,7 +212,7 @@ static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		 * switch in the tree that is PTP capable.
 		 */
 		list_for_each_entry(dp, &dst->ports, list)
-			if (dsa_port_supports_hwtstamp(dp, ifr))
+			if (dsa_port_supports_hwtstamp(dp))
 				return -EBUSY;
 		break;
 	}
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 15cee17769e9..71ba30538411 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -114,19 +114,21 @@ static bool dsa_port_can_configure_learning(struct dsa_port *dp)
 	return !err;
 }
 
-bool dsa_port_supports_hwtstamp(struct dsa_port *dp, struct ifreq *ifr)
+bool dsa_port_supports_hwtstamp(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
+	struct ifreq ifr = {};
 	int err;
 
 	if (!ds->ops->port_hwtstamp_get || !ds->ops->port_hwtstamp_set)
 		return false;
 
 	/* "See through" shim implementations of the "get" method.
-	 * This will clobber the ifreq structure, but we will either return an
-	 * error, or the master will overwrite it with proper values.
+	 * Since we can't cook up a complete ioctl request structure, this will
+	 * fail in copy_to_user() with -EFAULT, which hopefully is enough to
+	 * detect a valid implementation.
 	 */
-	err = ds->ops->port_hwtstamp_get(ds, dp->index, ifr);
+	err = ds->ops->port_hwtstamp_get(ds, dp->index, &ifr);
 	return err != -EOPNOTSUPP;
 }
 
diff --git a/net/dsa/port.h b/net/dsa/port.h
index 9c218660d223..dc812512fd0e 100644
--- a/net/dsa/port.h
+++ b/net/dsa/port.h
@@ -15,7 +15,7 @@ struct switchdev_obj_port_mdb;
 struct switchdev_vlan_msti;
 struct phy_device;
 
-bool dsa_port_supports_hwtstamp(struct dsa_port *dp, struct ifreq *ifr);
+bool dsa_port_supports_hwtstamp(struct dsa_port *dp);
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops);
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
-- 
2.34.1

