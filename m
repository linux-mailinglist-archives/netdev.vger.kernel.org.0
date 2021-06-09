Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488C13A18FC
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbhFIPS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:18:28 -0400
Received: from mail-am6eur05on2097.outbound.protection.outlook.com ([40.107.22.97]:56865
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232675AbhFIPSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 11:18:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SR2WGTHVcUncGwV3STlWX0N/ldHI3HyDy8MEzp7GUoM7JrSH9j4vmZuMf9U92hVM+EMwisa22ADxcQQlyJ2zzhvBvAQuUBoTXb7WTe94DJe3TNWRpDR0sWWdYzObqLberhWN2uI/WylCRaMCAQUd/9p+49UtsyHKMuh/YNEyUfS5SBKjmFYEa49Q1zga9UVW6MvtqeDcG4TcrHjoC2s+SfTeTY+nhbhWPOW3+ZXcFLBfPIegMk3ned2I9NpfFoDczjx9nLLWFvEHnU+Q4IWHFPn66Wq82SslO99ZVwDP4y1Tw6gK0iFxFRSQU5FEcG9PXXtHLEFOhXq+TlSxyTn0LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xz4cOmQjWmISz+mSyas4RCVzgLuV4pdl108ZTtK7Nkw=;
 b=IooNIaZL+Yywdft3w4iyzlQ6BTT6HE9FiLs5CGM4ZXWrlken+OYd37BLblAcciZYWuGqWcVKni+5gFfIna02eUAXJyrsnfF7OcppG4UoTI6ylwGmOxocoC0agIdjliXYcgIIhQ/LTaOOkzQfv+VGeRAZTxf7nWSaAT70u8IeoXkegR4ump078Us06HVwk9BG1krNqIL9at1U6XyAFFtT2qvB92ZXbw9CpRIbb2wFW443xmBqPkgdKeV/gz9UUTDl+g4qJUSAmgfAHs99g9sNVRtum3gXylUKDWVWlnPE6mmDeu4ZpSr3+Kvr6GQmN9tqbof5WTUHWQkzA88WJEtwKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xz4cOmQjWmISz+mSyas4RCVzgLuV4pdl108ZTtK7Nkw=;
 b=kNuwnhUQ+inSe6t+iesnUhKZyrWL8F+B/XWJI497WXwqY+3YhN3DUPGI8/JJ9aBYd+5XAxQcOkCc3aUP9/OxcDy0zHr2Ml8E/ekK/iQWN9oi62STfVPcHfyWJq+P+pziKUqtgVRVyWPjPQt7sykdokF0xy2pGC/GaVOKDu3xiLA=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1427.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 15:16:22 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 15:16:22 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/11] net: core: devlink: add dropped stats traps field
Date:   Wed,  9 Jun 2021 18:15:52 +0300
Message-Id: <20210609151602.29004-3-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0092.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::33) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0092.eurprd06.prod.outlook.com (2603:10a6:208:fa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 15:16:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ac541c5-be9f-4f00-78d1-08d92b598a14
X-MS-TrafficTypeDiagnostic: AM9P190MB1427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB14275D9F4488B97EB01023EDE4369@AM9P190MB1427.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IWf8cNA4e4l2YSg7o7Ss34l4ngSAwvN2Dha91/Usxp/m7EGHzHGSRNs7G2IeTuM/lfAhC0f/+08SXVGyiYE7Yd6xirIKmNnbhpr6u91SC6b5qR1O6s3TFz+H6Ac60b+5gZFtqx0nFceehSu/Pp3HZ+g6NEWl+XR2R4nCuTVfNSYWCu2u7/G6gX0kkPofh6ZFCv1v1Rp/41gjbR3W7KdF57OyFAYT3jwtcbPT0TZFIE1Ht7d08CfLwb/5IgePwQObwDksNVOU66tv7zRfja9SxnaG9aUo2r23jWB+BLEcTqXZBgPC0PNlyCOoXgus6ZL/Bg/0nFduneLly4JOm47zron2G1m4ng5sV4iKlceAeC+ZZlyHvxcWkce3VwSBcn9z4QKsKEt3364c6fKzhn1SngcFREmNN2HSgBYyXenSs52dwnt3BhFsqDyZ3T+9SElk7QaAUSYZcRu1hdsNu6qkJA08W1DnTBEMVFWstQ62+kI0uSnIwgmPs44YdKlNJxGOWoPmMYGRnXFuL80pKtRFMZo6YXw2olUqKyrzYC/0muxA+t4D8KLaCOlNBjQq0uGat6ypAfSUDk4iil1GtrYTBxnAD+GoQqprvW/SnfHA5h247T9GAPl24mPoXhPqBiyXGabRXnAxp4s0ZirZdt636xTy8DQYHeq7KVrCBjrZQ1I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39830400003)(366004)(83380400001)(956004)(52116002)(2906002)(1076003)(186003)(66556008)(66946007)(16526019)(6506007)(2616005)(6486002)(6666004)(26005)(66476007)(38350700002)(8676002)(36756003)(86362001)(4326008)(5660300002)(478600001)(44832011)(6512007)(38100700002)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IP9GkVbFswhugKw6GRid0qIKt95fBVB2FClzwlzsw87l4TOCVkH9uZSZn7gs?=
 =?us-ascii?Q?o6B7gFyLG0mPs+SH6ofmnmwcAHf3CrXIR6YWbZrGYSyoKN1cUR3s/HuspqDz?=
 =?us-ascii?Q?q0G1FOiKLVHBIVRTfwMSw2vHyc1igOM/CAIis+z6krA6SyUj6x9TX9H8R0QU?=
 =?us-ascii?Q?Svczb72+BepZegfwaIZsWGCdybIQisfsj7+EH2/Odwc0bRQjwpnXXUO+BL43?=
 =?us-ascii?Q?4MFb48tBiofQ1htZjBCsOBiMdHQ7kkGNquJjJAigUpvBjRQOqDLkQy2JnrT4?=
 =?us-ascii?Q?U7o37s2PUWFIQUfm0QH0X7csg+TiFU0ZaZe4bueRHF2V1rDaLm3EVrsjAhuM?=
 =?us-ascii?Q?i3NMzKgegJGcTQDmDFbucHONFzd4Lh6cX8e3DbLTzLyAIuPXQ2Q46FZQ8VLl?=
 =?us-ascii?Q?Wf5RiHpLXQQWMy4riz1LHGaoH+LTnP63ZtepZLPuGQHwKqr3z/LSSYAzbEqb?=
 =?us-ascii?Q?KyPThfAd9Te7pxP6cisaGq8X3PVcrsqiD0+61i86GK++E8wbUzV5HxMUoCy5?=
 =?us-ascii?Q?68en4xlyvOhBOxYGmwr3nBeThShTXJtkwlvrYT2+fdFmYdw/vNB/8Ecg83kp?=
 =?us-ascii?Q?uY8Uxr7j8iOhQVjoQo8vXrwTffd/RALqpw1UmO0W3Zpr5TPJOBslC3oaVwU4?=
 =?us-ascii?Q?BBQbztncAhiRtp81txNeXaQsEXNzbtuzDdNxC6z2wT/DJleUODHaIclgXyZf?=
 =?us-ascii?Q?mLeRmXMyeVTeK6BeK1iAaMy+kT/AahqXq/QEUbA1/dFwQ1lUU/lvapzr9KYH?=
 =?us-ascii?Q?y1dd3NrPNqHwRIi6y5m/0r8dDqdTHfe9CPYrHfnlsx5yCKtPmsKGsebc3pzE?=
 =?us-ascii?Q?tHNEb4rQLDWdZ6H4kw+FxlbnuSJzXu8PbjK6W5j1E+foj+CM6gkjn4t8DuaD?=
 =?us-ascii?Q?hxHXyoplwZn7wcNpv++enf+XgEqx18YLaKSpruPZ7qXpdKO+K/JmN3CZr/d9?=
 =?us-ascii?Q?f3iOs0xJ51tcMOoig1IopGpFRcLaNyDPd5GVNzzdtmVaeMTAs0/pBmGjTzXZ?=
 =?us-ascii?Q?xp44D9ufTunK3qHQlZXD2ts7v8fX9R4xJDPkgoVra6BpXLVKGtlRAN5oBmWK?=
 =?us-ascii?Q?V8RdewFvZZbDn3yPaSvdjqsDJwKdNk6XinXG8aIh/65EVSHkDXXZHNkISp2L?=
 =?us-ascii?Q?MiRp9MQdQqD2EL3P/HfyZ8XfqJjex1B5fSmuDq/t6X57gmHKTTz6hFLPiA0x?=
 =?us-ascii?Q?O0SfM+4PSFzl1u3Ma6d6kxPg9Cjh3/Ouv0DJKOBznkbfW5jqsWSoRkgbbNCQ?=
 =?us-ascii?Q?BW/qTtqI6NAAlENFraS4V/8+nx8ZbxEHMuBGRY6UHnbsK5UXWn1329fqfiSB?=
 =?us-ascii?Q?aNamIIZuh9CyLrdpQQtTk9vG?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac541c5-be9f-4f00-78d1-08d92b598a14
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 15:16:21.9382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p+DDstqZZ5W+I3mnky1+PoxLizl3H61NUK3Rq5DCPKdQk7wCT34F8Crxc9OPbXvAJefYG43SInTBWnQqx9GgZAaomeNnFwcBdqtKxT3Ha2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever query statistics is issued for trap, devlink subsystem
would also fill-in statistics 'dropped' field. This field indicates
the number of packets HW dropped and failed to report to the device driver,
and thus - to the devlink subsystem itself.
In case if device driver didn't register callback for hard drop
statistics querying, 'dropped' field will be omitted and not filled.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 include/net/devlink.h | 10 ++++++++
 net/core/devlink.c    | 53 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8def0f7365da..b8c6bac067a6 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1326,6 +1326,16 @@ struct devlink_ops {
 				     const struct devlink_trap_group *group,
 				     enum devlink_trap_action action,
 				     struct netlink_ext_ack *extack);
+	/**
+	 * @trap_drop_counter_get: Trap drop counter get function.
+	 *
+	 * Should be used by device drivers to report number of packets
+	 * that have been dropped, and cannot be passed to the devlink
+	 * subsystem by the underlying device.
+	 */
+	int (*trap_drop_counter_get)(struct devlink *devlink,
+				     const struct devlink_trap *trap,
+				     u64 *p_drops);
 	/**
 	 * @trap_policer_init: Trap policer initialization function.
 	 *
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e43ffc1891a4..2baf8720bb48 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6995,8 +6995,9 @@ static void devlink_trap_stats_read(struct devlink_stats __percpu *trap_stats,
 	}
 }
 
-static int devlink_trap_stats_put(struct sk_buff *msg,
-				  struct devlink_stats __percpu *trap_stats)
+static int
+devlink_trap_group_stats_put(struct sk_buff *msg,
+			     struct devlink_stats __percpu *trap_stats)
 {
 	struct devlink_stats stats;
 	struct nlattr *attr;
@@ -7024,6 +7025,50 @@ static int devlink_trap_stats_put(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static int devlink_trap_stats_put(struct sk_buff *msg, struct devlink *devlink,
+				  const struct devlink_trap_item *trap_item)
+{
+	struct devlink_stats stats;
+	struct nlattr *attr;
+	u64 drops = 0;
+	int err;
+
+	if (devlink->ops->trap_drop_counter_get) {
+		err = devlink->ops->trap_drop_counter_get(devlink,
+							  trap_item->trap,
+							  &drops);
+		if (err)
+			return err;
+	}
+
+	devlink_trap_stats_read(trap_item->stats, &stats);
+
+	attr = nla_nest_start(msg, DEVLINK_ATTR_STATS);
+	if (!attr)
+		return -EMSGSIZE;
+
+	if (devlink->ops->trap_drop_counter_get &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_DROPPED, drops,
+			      DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_PACKETS,
+			      stats.rx_packets, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_BYTES,
+			      stats.rx_bytes, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, attr);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, attr);
+	return -EMSGSIZE;
+}
+
 static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 				const struct devlink_trap_item *trap_item,
 				enum devlink_command cmd, u32 portid, u32 seq,
@@ -7061,7 +7106,7 @@ static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto nla_put_failure;
 
-	err = devlink_trap_stats_put(msg, trap_item->stats);
+	err = devlink_trap_stats_put(msg, devlink, trap_item);
 	if (err)
 		goto nla_put_failure;
 
@@ -7278,7 +7323,7 @@ devlink_nl_trap_group_fill(struct sk_buff *msg, struct devlink *devlink,
 			group_item->policer_item->policer->id))
 		goto nla_put_failure;
 
-	err = devlink_trap_stats_put(msg, group_item->stats);
+	err = devlink_trap_group_stats_put(msg, group_item->stats);
 	if (err)
 		goto nla_put_failure;
 
-- 
2.17.1

