Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE816E68CA
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbjDRP7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 11:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjDRP7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 11:59:47 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on20628.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe12::628])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFC0E40;
        Tue, 18 Apr 2023 08:59:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUYovfm9I5QEZxEsakTEMqhrgz44WFQEb6C+dCejlB+5IVCeUisgqW2tMD1XeFXB/kkNQ8C1tVFLlmgA1N24MNHbU3XeRBoTZTtL5gWMELtfZ3u4wt6Wsh/O0IRQF+cNF0GqIhcnyCYv7BlqJtv5Hf/NDVGLC8rY+/gfajP+J0yYLTu+RFBPb0Dg7TEJdqPBIEpB3b7phCV2tXGqd0X+2ng5i696p5AuWCnAT5MA1KE0NazuODLGlp3Z0w/RDb6gMgiJXI65zHSH+2YdpMC96RVZam0fglJmNdbETvdQkW/bZWlFQPvDaqw79K9zyl5nbas+ZxPgvU3BdU6aZN8kPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIE5MC3JDvBtov+GVA64V3kJKYZxPb0Umu2mK4UsGOI=;
 b=YBP9j9LMPwYN6ieOjaAohZ3UJ2+nWT0YlGETrQyH3Mv0bU1FRoE0fRCLFxIXWj+HZGUVPnZZbvbAQNnrD2Peexhrsxa2ScSCwerD788dqp4PFqZnirVS1AnII7Eo0eoYhyrErjS/Af9BomNzfqaAzAzPO2rpqtjTHzaR/reli+ztFHIJCMDIogILV8gbs96rluJIevYyx08IeohSWgqLvepsc0gwgXbsO9micEY3jwNIjg/SohFvNwZQH4kf5FNFVSKgjP3TxBOZbU1S2HlPPGh+MH8X1/1LigbFfjLnMrBkO5f6s7XjwuXkNyGNqkWIZ6gN4sh1dLxQsbb1JzvkHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIE5MC3JDvBtov+GVA64V3kJKYZxPb0Umu2mK4UsGOI=;
 b=FI48v2y7CIgwe+Rk5rIwqGdBVy5oaG6SUsPRNy0jflsPYsjQklCLhVgsJioudE2qhynh9gFtHhE+dZEgBgRV14Cy9eWs1xe0f+dJINtn1ZwuyCnkRbJooqZEXA44C1DvFyCNn2DsTaoqXwgaCKX+xlZZfiDJrj0o8UaJzNVE+Os=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB7024.eurprd04.prod.outlook.com (2603:10a6:800:124::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 15:59:30 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 15:59:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net] net: bridge: switchdev: don't notify FDB entries with "master dynamic"
Date:   Tue, 18 Apr 2023 18:59:02 +0300
Message-Id: <20230418155902.898627-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB7024:EE_
X-MS-Office365-Filtering-Correlation-Id: f2565b12-426c-46ce-1881-08db4025e496
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bgE8laYMe2IpRlsu93xvMTEkWh0KPwu5uptZqdT+5IJiLddPkkcphAIbCMZyRnjDYPdZwFxWqF8jyEtzpOXjlq2FfjTe8P5KIIuL8XpirEc+XQpOF7e85ravnyxYUaJ/VbJ8cQfZe6dCfihO+lGyBCcA0B21NWJCyTkvkejioi5Z1RzpmTR+tlKuZiGCsPVPlfgop2frqTB2XepHm/HtyRo52dnY78EaVE5gMicK7suwTaSuY7Bcq0/F6kUidmAUjknAdJoziPBq30vekdiLC89J3FRaZHvrks8UPqlYtkOEoKG99Rj0Flc/93d4m/GlPvjC57txnu3tqJZpZBccJnyvrt//eSsKuF0kLGbOE85WI9wdnJhpMibAnKGRko1/WgZDxRFgbZKISmU/YiN8vmY3o65M8Owo4ZVevA59FbneaPPNWlaymtNpN6YGJYF1Xy1UNzVNcFXc4zkIPo8R6YNANoxmdfy9nr55wlp6Uu9bnB3YxzGmnBVMWKXSRIz5KC1gAjuttJan6LDwU7vZrzTabMlafIsceJYqBsNoeDH9LAxMidg07qp/ZRjii9YXCEH8Rhn2x9PO0Vwaa38VUaQybVBbnorIEGrhFa4LqVxEdawXxAruFHiP1IjNPt0wCj2EW3AwfqjOOuCaCBUBcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199021)(7416002)(5660300002)(44832011)(86362001)(2616005)(6512007)(83380400001)(966005)(1076003)(26005)(6506007)(38100700002)(38350700002)(8676002)(186003)(8936002)(478600001)(54906003)(6666004)(6486002)(316002)(52116002)(41300700001)(36756003)(66476007)(66556008)(4326008)(6916009)(66946007)(2906002)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/YB5oQ5cUjf+lfTgwpQBML5oYEcULyHU/Fbr+Y5i4d4iYzkCgYMaA3hdJ5Ek?=
 =?us-ascii?Q?r98MMNEJGvUH6fa+dZQv3sog51+kn/YuPWKHE/EZCKSwj4Bk5mEneEMDfX0Q?=
 =?us-ascii?Q?nZpNJdtZPh1GN3kFytV01Qovto6y9smzW1yiGHLvpeeiNB0SaS2QpJVYmBof?=
 =?us-ascii?Q?68hwErWu6FTFmygVnPjZwyz0ldBQ3KO0HDIVU5WHQONk/gaTzi/yNthlAz8L?=
 =?us-ascii?Q?5RAjsyvRrAFxS6RFYMLTzPr+fIS0q58hF4EtwYzMnM+QF+wOtn8ABH4qxqHb?=
 =?us-ascii?Q?rhYz5xBQCeo3NgN2G/ufpgVB0qKyC3cSR4NULxNqnkVFzwtfxVTN7UVDPDgC?=
 =?us-ascii?Q?eGUVvClqkLru164cJAdjEdtvsvoWpoo3GVSFRcbogDrIf0CuE9PWgNuI3oTk?=
 =?us-ascii?Q?IcVFY9RDpDCRMRKJf5oiNgt4MbLR4O3sSmkhJYLsGVe6Sh3WAm2GNKyxy0WV?=
 =?us-ascii?Q?l5aKhXy/7j4YTuSf5Ad0tY/qJTSZNPedDa1MAA0mKyg6l3VPrWRJMOxLQPfL?=
 =?us-ascii?Q?t36faJv78K+uC2oTCxQ+A0c5UsVDndcFMxqRgvhaERAkPjgePnQkhXFlZc8E?=
 =?us-ascii?Q?GWq6RYwhT/mdjaWi0V2h/NEQta5wsYlNjqYav2kuYIfVz42WekQCKXmSl3eA?=
 =?us-ascii?Q?irJk27TdmpL0uV0QSI70K2i6cOymaMWiyfJWmrN2lnKn57FmJEBjQKZfsGw/?=
 =?us-ascii?Q?P7yO1okDaF2UUi+CZEKkQOGiQ6CtvrjY4Uk9EI+KwZWymhfTYAIGC2YXAjQM?=
 =?us-ascii?Q?V/8JV6KAH0Gk4wozaTFx69CHpecprttd801+kr+RmW102JHodZil00w+HieN?=
 =?us-ascii?Q?c3qL8aoD1h3wdnw+LuJNYVEC+Lir9IgNktNqXQSMkCkDtJcJWba/Ve9QTYrH?=
 =?us-ascii?Q?RCUnDh4/NwKfex5olmwQh//iOoQzdkNYnuRcZbnkkI89N74qA9dohTP3hJS3?=
 =?us-ascii?Q?XdV/Gp/k9FCfFkcbyIYzzAw3QbaXpbR4Csj4Xl1dNtXVRuLdaQOWJovk80og?=
 =?us-ascii?Q?HtZXSBFgQ2ROgzwpaDeh6Ite0pvXazfZmBvkNkf6IBnP5A+vNVRRXdTMu3ql?=
 =?us-ascii?Q?JQIxAnDmGBjwnyyAhGmCIwJZekblCaTzAqCKg48orJRY8YIQe12QE9Kdyykd?=
 =?us-ascii?Q?EtgrYtkAlGKdtiPcnLwszPSDX+ho6OlK7Ue7Kl6gwGYW1+88pCqst9ja0rrc?=
 =?us-ascii?Q?88M0mS8e8dwC7B4yi96z9IPQnPQClIqQj4xBbUqKX6uidrxZ/tkj3vgTZBOe?=
 =?us-ascii?Q?8h9E4v8sZlrlI1buEp1bSJz4tfZfE8lvrll3vE4jrCywU9/NdyJ1XzjihO+j?=
 =?us-ascii?Q?+psMtvk80H/UzvYMScG6ZbOXtxUk1CH5+qJ/HbYZ40HZPfUo/5hGo61pqY+2?=
 =?us-ascii?Q?obg8ku0ljXMfQlk5sCkL+9Bvfb7uF/aa4OMF1fLIbni4GtRvBEcpcS/ZV2uk?=
 =?us-ascii?Q?kDcn9ooT+JptVC9mVNxfRqTsiBzhswCcH/De2RkofrE5TPK0/EjrdR9b1lUf?=
 =?us-ascii?Q?7204BRo4AgfryVLj6vPbBwiNUFLF0WWwQMIbVlklVIH76Z55Z3tZ9y7zhJB0?=
 =?us-ascii?Q?qHSGRgWaDU3Hg6vB0+/2nJ5Ceba228ovISBVxnFckr3ukX8CLXQSh4u/3ebj?=
 =?us-ascii?Q?+g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2565b12-426c-46ce-1881-08db4025e496
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 15:59:29.8354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q1akqEanKdZYtCsjQIFvAJf2/Hmycqz2T+9ot+dYAiKSmUyRmT32uOvSXllUvhK/acpmHk5rGXGiXFS0tjNXFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7024
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a structural problem in switchdev, where the flag bits in
struct switchdev_notifier_fdb_info (added_by_user, is_local etc) only
represent a simplified / denatured view of what's in struct
net_bridge_fdb_entry :: flags (BR_FDB_ADDED_BY_USER, BR_FDB_LOCAL etc).
Each time we want to pass more information about struct
net_bridge_fdb_entry :: flags to struct switchdev_notifier_fdb_info
(here, BR_FDB_STATIC), we find that FDB entries were already notified to
switchdev with no regard to this flag, and thus, switchdev drivers had
no indication whether the notified entries were static or not.

For example, this command:

ip link add br0 type bridge && ip link set swp0 master br0
bridge fdb add dev swp0 00:01:02:03:04:05 master dynamic

has never worked as intended with switchdev. It causes a struct
net_bridge_fdb_entry to be passed to br_switchdev_fdb_notify() which has
a single flag set: BR_FDB_ADDED_BY_USER.

This is further passed to the switchdev notifier chain, where interested
drivers have no choice but to assume this is a static (does not age) and
sticky (does not migrate) FDB entry. So currently, all drivers offload
it to hardware as such, as can be seen below ("offload" is set).

bridge fdb get 00:01:02:03:04:05 dev swp0 master
00:01:02:03:04:05 dev swp0 offload master br0

The software FDB entry expires $ageing_time centiseconds after the
kernel last sees a packet with this MAC SA, and the bridge notifies its
deletion as well, so it eventually disappears from hardware too.

This is a problem, because it is actually desirable to start offloading
"master dynamic" FDB entries correctly - they should expire $ageing_time
centiseconds after the *hardware* port last sees a packet with this
MAC SA - and this is how the current incorrect behavior was discovered.
With an offloaded data plane, it can be expected that software only sees
exception path packets, so an otherwise active dynamic FDB entry would
be aged out by software sooner than it should.

With the change in place, these FDB entries are no longer offloaded:

bridge fdb get 00:01:02:03:04:05 dev swp0 master
00:01:02:03:04:05 dev swp0 master br0

and this also constitutes a better way (assuming a backport to stable
kernels) for user space to determine whether the kernel has the
capability of doing something sane with these or not.

As opposed to "master dynamic" FDB entries, on the current behavior of
which no one currently depends on (which can be deduced from the lack of
kselftests), Ido Schimmel explains that entries with the "extern_learn"
flag (BR_FDB_ADDED_BY_EXT_LEARN) should still be notified to switchdev,
since the spectrum driver listens to them (and this is kind of okay,
because although they are treated identically to "static", they are
expected to not age, and to roam).

Fixes: 6b26b51b1d13 ("net: bridge: Add support for notifying devices about FDB add/del")
Link: https://lore.kernel.org/netdev/20230327115206.jk5q5l753aoelwus@skbuf/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
v1->v2: let extern_learn entries still pass through to switchdev
v1 at:
https://lore.kernel.org/netdev/20230410204951.1359485-1-vladimir.oltean@nxp.com/

 net/bridge/br_switchdev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index de18e9c1d7a7..ba95c4d74a60 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -148,6 +148,17 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 	if (test_bit(BR_FDB_LOCKED, &fdb->flags))
 		return;
 
+	/* Entries with these flags were created using ndm_state == NUD_REACHABLE,
+	 * ndm_flags == NTF_MASTER( | NTF_STICKY), ext_flags == 0 by something
+	 * equivalent to 'bridge fdb add ... master dynamic (sticky)'.
+	 * Drivers don't know how to deal with these, so don't notify them to
+	 * avoid confusing them.
+	 */
+	if (test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags) &&
+	    !test_bit(BR_FDB_STATIC, &fdb->flags) &&
+	    !test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
+		return;
+
 	br_switchdev_fdb_populate(br, &item, fdb, NULL);
 
 	switch (type) {
-- 
2.34.1

