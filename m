Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5FB5984F1
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245386AbiHRNyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245381AbiHRNxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:53:35 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6429FE0
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:53:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7IbiBCOT7W46teScVwoaJi8jFeG5XThVFu/KrGsmX78yJFgWEpHuuS67vTlZaA5O0FhPmpr7mDsioPmOtZBZPNdwHfLvIRmyImw1dpMxePawhoTIWuyLllKbRawnSc9wcPsTKW28/UQkywwA5sUyQLlFCHC2AB9tadBtV6ryWXlSJaB3PkNPBuYyukvfWela2A6IEagl+FtyWi/u5DEIqZ4IJQbKPQ/Pd7Wj7QDHBLsQ7OaM7e9+8XyTQT2gu87d5QYXPs1/UMPI5D8Wh1kZjHXxLU24tXyz4DqdrQqs03ID8h2no8OTktkL446p/mOvDdhL4zPMPEBdD6rgv0tTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dUjCyFpeIZYBiQH5sIUai3XDgoeKanWGVF18vG6jzss=;
 b=ESER0/4P9B/wVZbeR2TMv8bSXHrhSa/1MG+fvQ4mSjR3TCe3t4SdYRYLaCmGtANf1LteIMbOHgEyaYJUnMX5WL7detKS4oPc5cIjNNvzGHgBmLrEAMotWhh0tH51D2HC6xbIicv+jIlCbDrdwwDl49Ck99n+n0Zti5kXsugg7BNP8QUOdarfSwfCkimxqBATt0QdOxYd9mcgXRoE17ykJxZDJ0jcBknXQtj1b3+0bsmsUtB9+C3QEs1a02sV1BlsqToK7tDq4Q8LXcLvI9x6Efl4/0ENhxOVjG76Tmlk+RaYYBnmRe3N5Hv4k/LMdCkzTFBK5GPINa8G8GDkugudEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUjCyFpeIZYBiQH5sIUai3XDgoeKanWGVF18vG6jzss=;
 b=jECysypVJRC5vum2BpCmJPXoOuNtYF/zkpH/rbHjSfXvqkTlBFd1sV+F8a/A6M45Et/q4WBlWpG16X+XyCzVbtm7XRlHCVUJEOGWZFAwlPk7YqTcFE9WlaFmEJNsyOeulsRZh1wa2PfWq7vVUcLlqHphxks0oOaEMSAuOnMr7AI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6088.eurprd04.prod.outlook.com (2603:10a6:20b:b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 13:53:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 13:53:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v2 net-next 1/9] net: dsa: walk through all changeupper notifier functions
Date:   Thu, 18 Aug 2022 16:52:48 +0300
Message-Id: <20220818135256.2763602-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9f67736-c4fa-4db1-f924-08da8120fca7
X-MS-TrafficTypeDiagnostic: AM6PR04MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xzk9mqgnbuD/YKPmtYIKj1z+Ayl/npGrTft5Sth9d93rAusMNiNfIccso7OpgcOtlz7TkFCt8NcgTlifD2miQ55p5JAfbdf1riObsii4LprTlSSLO8fgbwz/MW1V2zA0yB8JqaJWXx2i/kveaAs6XEdYz0aMFI0OEDB1xmOaMWgNCkjUUigamqaqwOS7e0zT7oetqagvWGCvs2FP6YZ0OI1p7m3GpgrV8f8ORFskuMy+gKiUudTdUulqVJ0CfHQdUxbOavii/aZPnaW9up6vmgvkTbdEddS+9Q1MkElupOe0c/L3lgmpqgT02clkOLsxCLkX9LwVn+wEbjSaplSH3nf72MBWnDRYvukzqVbPkQqlgwInciNx+7sMpMFbbKy2gvdSBZRZs9yTWsWsIrs4/zmxqRN5FT0NZ3qRVhZVeZpuqHJzHj2H68itnVLVJm9jtp5GFDLhpSQio7NLekKMBXPGFES9IM5ZLKdXiqhw6rEmQKLjfo2byIXCmGodkOg+XKSpqiQjUlTAQK+oorCCZ/rjKW4Uy+hEUdp9vSPcGrD1wn0B4Nmtj4ClN//z4cnYRlAGdCqNH6Wv6dSic5qcXiKOMLccnmDgrjIESe2PSoXDf9NLy2XmsWc45h7vxmZ0sdECOgO9O59kt2i6FOkjfkFo+AhCmBc+pk9tE7ElDTzrNKArG+84IY5QyuPn0fP8/nd/PWrQR9FiNIg2EsdqABepUZVm2mufxgMmOP3MXEPNCSOpJyGhi5zcWxAs+TbI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(66476007)(5660300002)(6916009)(4326008)(54906003)(66556008)(316002)(2906002)(44832011)(8936002)(38100700002)(66946007)(8676002)(38350700002)(7416002)(36756003)(478600001)(6506007)(52116002)(6666004)(83380400001)(6486002)(26005)(186003)(2616005)(6512007)(41300700001)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qnG3EvkZqcLZJb9o/XorRirJ1n7KAoW2vXNPau5dFqznOrnQPIvfCLj/Lxcl?=
 =?us-ascii?Q?yEmC20v7Wb83wjBD44uQgA8pxDbqIkseFS+WMsXX+JMFfUZNK3KqmxYJzP0D?=
 =?us-ascii?Q?LoftLjxVvA3iwy5ykeGlNPEfqkDLW5ID+abjvppc4a8eh0ggYTLx2euAtFrb?=
 =?us-ascii?Q?FKpqeA6kYTtQ6GCL9pSzLeyRxnaH7XFvxgjXF/b/uyZqw0ipmP2G9du7wtvM?=
 =?us-ascii?Q?rXhPi3D7tspiFb84q9WmYjk7TPjAzHeSE7K5b8eKrtU66WIdjIwPZUs5muaI?=
 =?us-ascii?Q?KVvKS9WWGCWV1zwglqFg1zUEpokiaaMN7gkdfYGTj5jI8yoduiyWg9OsAn85?=
 =?us-ascii?Q?7DDskjL7VwCZYbaZoqW7b/1/612dCIF1q+Y67Ok1F7MPKgSzZYn6H8FMMM9g?=
 =?us-ascii?Q?muK9r9TISIuTy23Kltyz3RMHqpn99u9RgZ6SWGGEyh1L27n6JKX0MoQoqo48?=
 =?us-ascii?Q?PHem3zZ7gm9mor1lDpNsMf8ftzhLnpONWPjpZSFyETfE7fi4GZsIP8TYohiT?=
 =?us-ascii?Q?szquV5pTJiSQthfAF3KXVR9Q0rt8h8ih8DDrp3TKHu2ffEWTvrS/902Tu5h2?=
 =?us-ascii?Q?x3pfAoxtQIbB8jQc4wtb7YimL/YkaefyJywcgKVT+YFOZjhUKIAlL3E1f/+R?=
 =?us-ascii?Q?gF4DbJnXSe1R0C/318TZOL0I2EK5FkUeuGawR6K9sRMEPsLv0d8wdvcuO6x5?=
 =?us-ascii?Q?zNwiCigOsxgKbxhoZzvxHigE1D6i3vWQZwko+W4QrnVzfQe0Q/K5MVqzADwI?=
 =?us-ascii?Q?1wzAbMz64f9PkLHXLIqW3c/rAoGEdum608jTGM7JwBCrndk03jQXicpHNeJb?=
 =?us-ascii?Q?U3tcYCj7cBkdRDW/uT07oU/OiHGfdS5uYbRt4Q8zmRgVqnASNH5yq29VsLa6?=
 =?us-ascii?Q?lAuKqD1Lx39Y5d/8oHAEN/FJO8XG44HrGu4+BaA/D0kSX8Jpk02n1cbTWXEe?=
 =?us-ascii?Q?ZjrBRyyvxCNWKzkRws/4BEUhp+tgPH8SZlcqQZ5Qdo5tE1glNpk/jw7BkvPc?=
 =?us-ascii?Q?J89WUysavqG5wb1aWu1YCioAc3+PdJTiRLeRFnQCHhYdhce2DS0yNAGMmjnz?=
 =?us-ascii?Q?PROQzjWQkIBAmn+24ZkhXSj2tBYV4Bx/0m3MxaAh9AVcNB6OfpXqYks785Fe?=
 =?us-ascii?Q?WGOIhXb+yAFirGurxF+d1og/bOtiCveHJtAyUaMzA+b6PBvvUzVfivWfN5WA?=
 =?us-ascii?Q?e9od19XvOyhFS1MyEnNcFCtTngC/neYSlKNPI2oMpIMIGgc/7NX3+94ojWq2?=
 =?us-ascii?Q?a8h1TWj/l5XYNY3je6yS3sQm8nhrJE2Je1CAtNv4A8eP3au9RF4oD2NBiw+M?=
 =?us-ascii?Q?QoOC4RFR6AG1AENdYbgjpao/lixmNUi6+r1QkqKFu9P7l3Q/O9dzX7VmNw3S?=
 =?us-ascii?Q?K9i5TIxkVsPNwIo47cE0HzkCNAMqHhco1OTjCl13ixfUepd4p5LSnSCpNKCT?=
 =?us-ascii?Q?NwNL0xjkyvafmuwRWjmIttdZusAcC6wl8iU4tWBx13Q6spF1rma8s1ypET9j?=
 =?us-ascii?Q?Garl0Tg+7tuU9loUmSPI5UPHZuGcznM2GqyXBZYbbs79UC4BNPZ0ThBOyvdC?=
 =?us-ascii?Q?5FQy1MaPFarZcnqbzxwk/2ijBcEIxdneUnwktO/WnB6Y8WQRxFDknDBTrs+d?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9f67736-c4fa-4db1-f924-08da8120fca7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:53:10.5712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D9m+kyaWl41SWaPEeYd7LAqAex4I9HQnd+3BDa59JYMUES1XuGsZ4hoKardQIaqBd7LvJIzi2nfxI/CLelhfEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6088
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Traditionally, DSA has had a single netdev notifier handling function
for each device type.

For the sake of code cleanliness, we would like to introduce more
handling functions which do one thing, but the conditions for entering
these functions start to overlap. Example: a handling function which
tracks whether any bridges contain both DSA and non-DSA interfaces.
Either this is placed before dsa_slave_changeupper(), case in which it
will prevent that function from executing, or we place it after
dsa_slave_changeupper(), case in which we will prevent it from
executing. The other alternative is to ignore errors from the new
handling function (not ideal).

To support this usage, we need to change the pattern. In the new model,
we enter all notifier handling sub-functions, and exit with NOTIFY_DONE
if there is nothing to do. This allows the sub-functions to be
relatively free-form and independent from each other.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

 net/dsa/slave.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ad6a6663feeb..2f0400a696fc 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2476,6 +2476,9 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	struct netlink_ext_ack *extack;
 	int err = NOTIFY_DONE;
 
+	if (!dsa_slave_dev_check(dev))
+		return err;
+
 	extack = netdev_notifier_info_to_extack(&info->info);
 
 	if (netif_is_bridge_master(info->upper_dev)) {
@@ -2531,6 +2534,9 @@ static int dsa_slave_prechangeupper(struct net_device *dev,
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
+	if (!dsa_slave_dev_check(dev))
+		return NOTIFY_DONE;
+
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
 		dsa_port_pre_bridge_leave(dp, info->upper_dev);
 	else if (netif_is_lag_master(info->upper_dev) && !info->linking)
@@ -2551,6 +2557,9 @@ dsa_slave_lag_changeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 	struct dsa_port *dp;
 
+	if (!netif_is_lag_master(dev))
+		return err;
+
 	netdev_for_each_lower_dev(dev, lower, iter) {
 		if (!dsa_slave_dev_check(lower))
 			continue;
@@ -2580,6 +2589,9 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 	struct dsa_port *dp;
 
+	if (!netif_is_lag_master(dev))
+		return err;
+
 	netdev_for_each_lower_dev(dev, lower, iter) {
 		if (!dsa_slave_dev_check(lower))
 			continue;
@@ -2701,22 +2713,29 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (err != NOTIFY_DONE)
 			return err;
 
-		if (dsa_slave_dev_check(dev))
-			return dsa_slave_prechangeupper(dev, ptr);
+		err = dsa_slave_prechangeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
-		if (netif_is_lag_master(dev))
-			return dsa_slave_lag_prechangeupper(dev, ptr);
+		err = dsa_slave_lag_prechangeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
 		break;
 	}
-	case NETDEV_CHANGEUPPER:
-		if (dsa_slave_dev_check(dev))
-			return dsa_slave_changeupper(dev, ptr);
+	case NETDEV_CHANGEUPPER: {
+		int err;
+
+		err = dsa_slave_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
-		if (netif_is_lag_master(dev))
-			return dsa_slave_lag_changeupper(dev, ptr);
+		err = dsa_slave_lag_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
 		break;
+	}
 	case NETDEV_CHANGELOWERSTATE: {
 		struct netdev_notifier_changelowerstate_info *info = ptr;
 		struct dsa_port *dp;
-- 
2.34.1

