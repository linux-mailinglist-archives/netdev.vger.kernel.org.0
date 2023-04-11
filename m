Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A286DE355
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjDKSC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDKSCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:02:25 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C63A526F;
        Tue, 11 Apr 2023 11:02:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXmJ5ZJefObgBj1AwQeTnzsyBG8VY8q7ddVFvxZAWecup3jcXqwUFrqLvPXMuJhlyoU6szgBcei+ODx2JMxwmfUFdvD5oF+EMihtyUJOvhk+t7RbzmgOj/9yA4DgCcAXdqRJxXJWE1Pj8kJFO+TKg6gHeq6RtZxPw1vFRDJtPtXZyIIOPnx2gbqCSQP51W14O4AU7kytrF6MGdZS1gVfvGk8/fmJfhekPItd+ZgO5G0C+zioHodLdIuyixCgVa+MgY2QL0gFVMbBZFxsaIZVreFtoFT0QL3LjIfu623SRyq/CUcFtSZKbbSXwBz5tDUyHj8qPfSw37J6c5T7cqD0nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRlHOmwW41YQtyFWjVl/V+zXFVnDXS5/0/VJAR9BzIw=;
 b=jyqyz7Gl+ioPz1ZxuNJccEiXvuY3rlwTxBSY6UDhegOYPaeggxwA5Abi8it020/jXFDoitnoOrfH/5oM+WNd5zdWOBuY+GOpBi6p5p3oukD2Tq7x6KRRZaMBFJsXduNn4LVnTlMPDheJTTTytI5VGHFNfqPAK8NrCz5LXpqwk2OheduNPpJEFH89+J3VWQRpeswiBSeViei0XtD8NzD8z7JECVjumGmYgK7cgDz5QQNqi2QrkfTn+2pSpGa84QBsjguSzzFi6mr4bjQ8PJXsrZuFWJsfLUmxZkRSeFuYZbHi91bNYa9UUZ4tSJokhqM59l7Um+huJzDplgWiTxxafg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRlHOmwW41YQtyFWjVl/V+zXFVnDXS5/0/VJAR9BzIw=;
 b=EvMN4h+PWU5brElmIQ9ksemIY94bNvDU6YXAoOVg89M6S3/RQwjdA377ADMwe1apN2vrSBrNUwFB0cKllR6ZbDjNMVHkY6hqy1G7lH6Lzf9gMHxQ1nMzAiB9T9hlySPjb+2snF9Jds6jKGm0BAPgxjJ0II4831QXC6wN9IrevPo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7829.eurprd04.prod.outlook.com (2603:10a6:20b:2a7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:02:22 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 11 Apr 2023
 18:02:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 1/9] net: ethtool: create and export ethtool_dev_mm_supported()
Date:   Tue, 11 Apr 2023 21:01:49 +0300
Message-Id: <20230411180157.1850527-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
References: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: 10fa4c78-6e62-4990-3aaa-08db3ab6e5f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vnuzg3ydmXXqLu3v4ppNRBCyoewPv+o4v88/FDOuQZi0/Ebf2TeHAVUSeYmsess/klwVjpvNwUEqYmixyAndn5MewneROkvJjl7uRgWb+1teq7/IV/RkKostltYZybKmedEaNbB0U7ICFEuDOZIDPRDaQn+5mFcp5h7F5rN2bPGYVOCbZFJdGNB57SYGadPqoNstlH3KOYL+UsQQIM0MG4c96QktoIb0MVz+I7yCgBOJBSYKsxmxMEzHuG4DDg8/wu4AvyPI0PYhPxqV8UL8ulGm9DZq0zjjgtc7DkKGlir27Tuwiqj3cB+XEkH9zliqFGwpG0a+YO9tiS8OQsNjIoEGntpFHhx3i7hMnI0NWaZtuXG8+CPlaATRPyt1yVbpw4mOCcKz4nIJqudUet4EzuH9dTgs1VxmNirR3I2aSMMsqNB1EHcnsWp9MjqRGsgc7s8EVyBfqcqwMKq2WJ2A2SmX8FOIvasMdKR5fbjDK4fTkrqRySlbszI7QQgj5Ypt2mxaqbOM3ThoHAMv7YbUpxykFVKe9httY9zP0HRlv8Pnf/HNKvVVXlVgJ5KtQ5IdiF/UKjPczoOOiQLb9mQtm1AH0XOVf+ZYoq+C/MQMcWLurAHbulF1bp+FEL8Tk3l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(41300700001)(478600001)(86362001)(316002)(54906003)(8676002)(52116002)(6916009)(66946007)(66556008)(4326008)(66476007)(8936002)(6486002)(5660300002)(7416002)(44832011)(2616005)(186003)(36756003)(38100700002)(38350700002)(26005)(6506007)(6512007)(1076003)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fyyNJr6CU2r9/NxK+40OXFSC2Sy2Zp2EwnlkwfgQppuoxUfsLEbW98wMhYv+?=
 =?us-ascii?Q?eiLdGDyeLjyCjHLdSzA+YXz1QW+Pgw35UurSi44WuwONTdYpWHgBghZ7ZNpa?=
 =?us-ascii?Q?v78zNEBEtEvyn+4AmyGdnx2J3j2Ztmezwd5k0ZsBtahaR1oitouS+sQryEuj?=
 =?us-ascii?Q?HqUtivo4jqbbFIewwZ8V0h4Ku5anFS13CuGzjTXZgWId3cHFAqRb9NfsgcHc?=
 =?us-ascii?Q?rBvAZPezZw//i9WzU6r6689B3y6moN2E/wXzJwkBM5Ii1Oc/0ifsj+BtTse0?=
 =?us-ascii?Q?9JIHVltFaebCL0bJKZT8dF42ickrwWPmCTHyn6c2xOj2BE9UeqKC4OwNDAmD?=
 =?us-ascii?Q?FkkOjSv0TvROCHVVuJE0pP5+HvEAsQBFchOLsY/sg+hbKOCTGxapv3jTShe0?=
 =?us-ascii?Q?jtfA3tnXu/JIckfuMWzg0YRvAEJORu5RCJmn2gjqx7SDrJ8K5qdExMgss6a3?=
 =?us-ascii?Q?yDnHiwhRKdriXGYUXDTn7Er4WIB6ZjaobIYxX+/at3PJe768q5KhEXxVzSI5?=
 =?us-ascii?Q?lOqML+tMlvbz0JTRFunmCxCHQEc5bEkoCLzJ6aJzEoxxRJQ8i8UfZV659OcY?=
 =?us-ascii?Q?gvR7jbJyMb7m6p06CC75PwSmPWjesnLiUxRCOBQ3CisXepWDA+g5WmcFpORs?=
 =?us-ascii?Q?zFJLl92tkmyadDzudIOR63vAPJJitQfnt2aQAJlbG9gLg/zyNPsccKpcDwQ5?=
 =?us-ascii?Q?ta0YdP5FM/UzcpAn1TjRHd8YqGCFL9DO7Xf2m0a96ZuZlN909ZpOZp6nq05j?=
 =?us-ascii?Q?I9tSsLASFCm9VSKEfY3MuN4BzX3jalt/auNG93pGfrSXct60F8lxjEqy6Z25?=
 =?us-ascii?Q?7Qk9af2kpmWclnBDy8SHhO28AJ6nWG19A5ncotAP5+RkldtcI48449MqRVDC?=
 =?us-ascii?Q?A3fBB5UVHEMUynzah30tbP2pMFnpq9AS2vSL0TUgJLF28pXTamQaQBzcfiJL?=
 =?us-ascii?Q?D8fE20Wwkk4IYV6VWDBNLnlr+V6Tn9zopPZrEkLuHmMpICGEOz+PJKd3KueA?=
 =?us-ascii?Q?KSZBkc1/eY3gpbJ8G0gvrZSH1w81JXV4w6LCoVAyh7WLZIAbX5ylvQaW9658?=
 =?us-ascii?Q?IwDW4ZrW8kC8kuw1VjMIczL63UJd0gFF96XiXrPLuDM8oR6Snk2lUyFjww4z?=
 =?us-ascii?Q?FwRStOmNnuaLO9JEiaiOfUlXIayv1poIW43f31xm8aAdsrUaZ5zs21v0C5Aa?=
 =?us-ascii?Q?A2FvB2TcplfAEjmTxDKrG4EWALYk63r6a2WdSPQIUqbPPAa+amhapTu+c224?=
 =?us-ascii?Q?B+0uUkxmPZu7ysg5Yimj+BCI3DkxOkNhQmx8iK348vfJMD2i0mDB+UYyIfNV?=
 =?us-ascii?Q?vMk/mFlo/BGWQbUFkbD0uuwqESrChtLSrPCSgDZqLxsySKXhGRxzyAbwK2E9?=
 =?us-ascii?Q?03Wh/EqjkwOTDU4Mr622BhCG4lUurNndrhoK09Ajye0f06bVhChutpLpM78z?=
 =?us-ascii?Q?BBnyo6zfy89N9j70ui2Vz/u4J4e+u3g2mAfi2d4kZYtR/pzXAVN88PHdxs+8?=
 =?us-ascii?Q?QzVjJ1RXQ/g8QfJsTv/K0Bf0RHhHob6Ta7Vaws7NAHhprGLfKXrFhHU4PuwR?=
 =?us-ascii?Q?vZh0Emy+Ijf6tqDIv/LL4zNOoMjIB38WdrWrUqVu7vh0K6KeRN+Czh+ds/IZ?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10fa4c78-6e62-4990-3aaa-08db3ab6e5f3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:02:22.1630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KNH8aGfC4NQ8qyhWto9Zxuj+IzSASPJYOWap8pQS+Nl1GWr6zA8gq/fh5vpzfAGIUHASTWyWhmLtNvHWtFc1Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7829
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a wrapper over __ethtool_dev_mm_supported() which also calls
ethnl_ops_begin() and ethnl_ops_complete(). It can be used by other code
layers, such as tc, to make sure that preemptible TCs are supported
(this is true if an underlying MAC Merge layer exists).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v2->v5: none
v1->v2:
- don't touch net/sched/sch_mqprio.c in this patch
- add missing EXPORT_SYMBOL_GPL(ethtool_dev_mm_supported)

 include/linux/ethtool_netlink.h |  6 ++++++
 net/ethtool/mm.c                | 23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 17003b385756..fae0dfb9a9c8 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -39,6 +39,7 @@ void ethtool_aggregate_pause_stats(struct net_device *dev,
 				   struct ethtool_pause_stats *pause_stats);
 void ethtool_aggregate_rmon_stats(struct net_device *dev,
 				  struct ethtool_rmon_stats *rmon_stats);
+bool ethtool_dev_mm_supported(struct net_device *dev);
 
 #else
 static inline int ethnl_cable_test_alloc(struct phy_device *phydev, u8 cmd)
@@ -112,5 +113,10 @@ ethtool_aggregate_rmon_stats(struct net_device *dev,
 {
 }
 
+static inline bool ethtool_dev_mm_supported(struct net_device *dev)
+{
+	return false;
+}
+
 #endif /* IS_ENABLED(CONFIG_ETHTOOL_NETLINK) */
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index fce3cc2734f9..e00d7d5cea7e 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -249,3 +249,26 @@ bool __ethtool_dev_mm_supported(struct net_device *dev)
 
 	return !ret;
 }
+
+bool ethtool_dev_mm_supported(struct net_device *dev)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	bool supported;
+	int ret;
+
+	ASSERT_RTNL();
+
+	if (!ops)
+		return false;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return false;
+
+	supported = __ethtool_dev_mm_supported(dev);
+
+	ethnl_ops_complete(dev);
+
+	return supported;
+}
+EXPORT_SYMBOL_GPL(ethtool_dev_mm_supported);
-- 
2.34.1

