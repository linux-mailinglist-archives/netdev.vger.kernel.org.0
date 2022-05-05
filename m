Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDDB51C50C
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381919AbiEEQ02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234298AbiEEQ0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:26:17 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2072.outbound.protection.outlook.com [40.107.21.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281EE5BE51
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:22:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmaDOqjR+onU4SUOlDIqqe2Jd/1HYM0jj9TkvonahwwMUsdw8N9wo1LNR2KQjoU5hLEKGkDsUtjRIR+fQwxwPxrhRzH1EfGDegV4Di1lqj0AzYjnekehqreZIGHzwX2PYsDky9F5BqRqTIjzcBCnnO1+kfCSBXu1VbS2zlIbjf3lxtVoLbK+N9MGH0/ddZ+ODAbfdMbCV+BZkVl83+BT9qPZunA9HEc1E29hBryUrMnxdXa63Ezd4SMlvYz8e4N8LmrcKAKE/++0zhVC+pZwC9gm3AkcKd9qqrL1h0gAgAciYm0hPjfIR9RV3r5xpe/xRDfLoCDY4z9xybCE67K6Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ADfvzDYmytdsZ1Ia+IbXMz7DyqSmAB6TIMMvHiI3aZE=;
 b=botuPUeLrlf+cNkrh0RP/tBsORgG7iPDAaT4De/YwVl78BtNoLIqxPMqhWf8EwRAdNVyOgkehUAfFExzO1jiuVyTyyA5Rzs8HRxdJhmJMFF25lO7dqukQJ1SHAMTlbLPOBpt0LmZKeFXkxv5qF0rH3mtZvSj1bR1EY7AaBtU1E88Aa+lDyFRMmwljeWzQtvPQk2Ge72rD0tCtGg94/dFuwaujOImtFxofRbFx//FyouP2moOMhLBAlpKw8paEPkmGDlpbecht5J7DdjgXIbccE0H1ArcDt9QL/y4Nve4ByLk+GdbjbK7TxjJ3jv0qlp7XF48zFit5hRnga6qD+SEEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADfvzDYmytdsZ1Ia+IbXMz7DyqSmAB6TIMMvHiI3aZE=;
 b=kcYXTfEd5X0L0R2rEArg59hsnpr0PplwlmcMDspYOo+D8oQS7/NDk+E11Tgq/3yr29BYv9kVOtIcpxjzaeoCL7GEsaADec/6KBAh7PUJOy1q0G1LSHc77ndrXhQsvKXIh2SmHIsUiYxWALpt9qH1huMblPGLliJkztlFW4D8Zcs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5522.eurprd04.prod.outlook.com (2603:10a6:208:116::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 16:22:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 16:22:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 4/4] net: dsa: delete dsa_port_walk_{fdbs,mdbs}
Date:   Thu,  5 May 2022 19:22:13 +0300
Message-Id: <20220505162213.307684-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220505162213.307684-1-vladimir.oltean@nxp.com>
References: <20220505162213.307684-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0021.eurprd03.prod.outlook.com
 (2603:10a6:208:14::34) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3314344f-740b-4f04-7182-08da2eb375bd
X-MS-TrafficTypeDiagnostic: AM0PR04MB5522:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB55226E613CC2B9E1E491D838E0C29@AM0PR04MB5522.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UB5xFMOtuEcMbIusqTUES4Y+NOpNpoMY8A7FsWOntSiAeROTv5Atag/3pLUKnrh/+mpTQac6UEOl3HcDZqdm+OFLio4ZfU6aLd/sXtab9zb1Hf3GZzE/8bvQZ8g/8a8fwMrV6bv1VcgJHV1BjK2aVOICO9OShS9iip5cHjt4a74wfMRA0PbFYzGYTU7XOBY3d1FvIeWtMaxWtEeNG7kFd1LB3YNv4USjlNDLZqCQ86MYsWKdXol9CPDaXwZ8TNldcFVRL1vnrNa2eUnwhblhzRSzr4PF6RkI6BLmYEQVkb3xFlL4iNBuVIXsfOvYxW9pCkE2rks/l8ynaV781N3QGxjRdMlRT0SBOunEKe+cS0g2US75+hW8e75k/ffWF4sa8nKv8Ng+5uhZzFuUq8giTclgqUS+tjvCGJ3SN0yQ3GJ8DIPCjskeyvYXU4LUQ2AlFMvBwrfAXGJUIna51//w6bYNAU8FeefTjNiz2hWa4MqIYfprSdd8FR2dGPGEq8TfXKofFj1tPFI6IMwm/wSuBC58/p+fp4siuluvGbj5PfxT9HeLvC4xZdtLKsVaJX/y3KTlqhjhG/0YHieqQcvYvU9FAWx4LPtDR3XjdvlbhgvyOE4UyURSFfLZNJPypx1rSSQwgRSq9F/PijSkHmt5nCDDXDal1zUH8jajNz0a5TEEXRwe4lQf0CPgrltvxyLCUiSSYuAcVPFoVsuR4ETXhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(5660300002)(7416002)(508600001)(8936002)(6506007)(6916009)(2616005)(52116002)(54906003)(186003)(6666004)(6512007)(26005)(36756003)(6486002)(44832011)(83380400001)(66946007)(4326008)(8676002)(66476007)(86362001)(66556008)(1076003)(2906002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PTJIVo3yxBgA2CVSbZMpgrViD1+ReN731IbfSu8OHWeE9tvDYp0z448R3oKU?=
 =?us-ascii?Q?oMUIWVAU2qcXJ40OVkU8bJWB8/RS8fKGCAHtoArbQY78qssNYCzNIY+NcqmM?=
 =?us-ascii?Q?QXEFjULUpG1YQU9U6apMeVAV0bANH2E8RdgCpS8eIeONWgUXIthsXzh5Im2g?=
 =?us-ascii?Q?5zYWekgN25wi5FJU+kLkwntuLfEyJZPKlU9QY+vgq5BrDmriMz1vwYTo2w24?=
 =?us-ascii?Q?wfbd1n1orq1FcpV01gser9tMRu4JpsugihCdTQ3C09LoZG9fXrLGWl0XqsiM?=
 =?us-ascii?Q?eIlHI3LuCXPwCMhHV7/rcJa1xEZmhdSIdbhCoWdT5dnZhtRB/XILoQB0FFqC?=
 =?us-ascii?Q?dVLxqTdw1Sv0tzu1uQJKmT+s3EIi7SkrcLmiYtPs1fzJcO1Fs7enehb5KdcE?=
 =?us-ascii?Q?TCo4vxZNUTrjdHe6g6ZXczmQI7DtDdvUncXgYAZXR/3Y3DtleiNe5las4sU4?=
 =?us-ascii?Q?BR6TRjkbcf76SAnqGzXioyWE1GBg98OqYcsAgqaUztcxzJclO068y2TgILpd?=
 =?us-ascii?Q?Y20vBWj0Qr3HeJYN6KcGgvfVU2cpg1XeqGb8eIG9ZOzsoa7OjrqMF9hJEz6I?=
 =?us-ascii?Q?fnYnq3KmwsRqShdfsqMOZxHZghvMMfSkFY3yf9hjWwB1UDaMOaJAwulCK1qC?=
 =?us-ascii?Q?vscW/M19bnGIfcxThLKsrYYIjfUJquD0PAnFiTYDXIAmzKlONXYU4jZah80+?=
 =?us-ascii?Q?1Wb7fnYjNS0Hryr1AKeEwNjeVeDFBbusBl4zsYiRBWn966R9Hcny9TZPBylJ?=
 =?us-ascii?Q?J4ocFv9ewaLCJa/hZ8krb+NrvUkNAq61R9ItfhnFjAe7RgJ7Acxcz/lGdJmo?=
 =?us-ascii?Q?Co1B5+7MRDUyjMGJWTyFFYbInnDRNJ9rMBmD7dp77fCd4D7e2AkqjGpJPn7R?=
 =?us-ascii?Q?+5MhSUJz0Cf8qOd8QgGYvj80IjwdU3zuXybPEwa4Cji6Kn2xakfcbl/EiWK9?=
 =?us-ascii?Q?Li84r1jPh045E0GRscx7D8YVfx0JmMaMyaDXCbqZ0UWQd9msCU6CjzT3jmTx?=
 =?us-ascii?Q?/AR91WT6XGiBg+c7+rqEtOFd2WwqyHJnq6/knp7Kyduw3e6vRqSznLPnKnim?=
 =?us-ascii?Q?NegC/QkSx32XUX22or7vMmp8XKU2/x6YMV88QyndK0gSgfyERHa+Fg+DStw9?=
 =?us-ascii?Q?7OxO92g51YxDYfLSOs3LsJe+1syCXtQQHtsy9T89CUc1KHSYfPxjYa6qqg7d?=
 =?us-ascii?Q?4oOjm9F3m2BRGt6qp88EC37qlpqFMLUqcB5qG++++3Su6p9h6dHjDxZHMKKc?=
 =?us-ascii?Q?ufXc01MM8I7UuGOah3ezIMWqnRteRZK9zSNNMOobaBHvpP+118dqsTCYMbLb?=
 =?us-ascii?Q?Zu2O+VV0seabNlMEOtUYqD8Lg8U1c7wy6cXyYNOXIsXN2Crpg07P7EFXwPZ5?=
 =?us-ascii?Q?10U+3hxqKyb5h6tiuSkxkIjYlWSY8mebeo0iJzPeV/PfJH9bIWAkB8itISF/?=
 =?us-ascii?Q?jvMyexZJZlhXvvvvjnIopEOingxF1nkgmMk0K7vLow05ngs7rfLSHAyw7jGQ?=
 =?us-ascii?Q?sgJSEaI3I+5hHbageolARGJX67NUoUxD9XKN9Ok7FpYn60bQZchppnNZBNAr?=
 =?us-ascii?Q?1EpJAKmU84ODdPnQkx1HZ8PhsJCBoC9Lrck9Ayz7ebVffX7Lpc3b7oXvlv8y?=
 =?us-ascii?Q?KoCqin3HJIwbvVgYr+NaQ49QzBBUP9o5Cexk8LLq0EIh0LNKCbNEd0rJHZvG?=
 =?us-ascii?Q?cQfDxBSD6NT0Ht7Z094+xiB9+7dZD9l/HbVkhTpztq/4babc8rYl4cf/ibef?=
 =?us-ascii?Q?Ub8vz4rbmRCC618VJLTkuGZXhwetDb4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3314344f-740b-4f04-7182-08da2eb375bd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 16:22:33.7750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DSoV3fkzE6Qtiuv6azH837yZ+RhMT9KwhESv7adLMC77foT9z0t1bQMjSOoPViwo6xmPdfWTosRxQbsWF6PlEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5522
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the users of these functions are gone, delete them before they gain
new ones.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  6 ------
 net/dsa/dsa.c     | 40 ----------------------------------------
 2 files changed, 46 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 934958fda962..efd33956df37 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1239,12 +1239,6 @@ struct dsa_switch_driver {
 
 struct net_device *dsa_dev_to_net_device(struct device *dev);
 
-typedef int dsa_fdb_walk_cb_t(struct dsa_switch *ds, int port,
-			      const unsigned char *addr, u16 vid,
-			      struct dsa_db db);
-
-int dsa_port_walk_fdbs(struct dsa_switch *ds, int port, dsa_fdb_walk_cb_t cb);
-int dsa_port_walk_mdbs(struct dsa_switch *ds, int port, dsa_fdb_walk_cb_t cb);
 bool dsa_fdb_present_in_other_db(struct dsa_switch *ds, int port,
 				 const unsigned char *addr, u16 vid,
 				 struct dsa_db db);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 0c6ae32742ec..be7b320cda76 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -458,46 +458,6 @@ struct dsa_port *dsa_port_from_netdev(struct net_device *netdev)
 }
 EXPORT_SYMBOL_GPL(dsa_port_from_netdev);
 
-int dsa_port_walk_fdbs(struct dsa_switch *ds, int port, dsa_fdb_walk_cb_t cb)
-{
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	struct dsa_mac_addr *a;
-	int err = 0;
-
-	mutex_lock(&dp->addr_lists_lock);
-
-	list_for_each_entry(a, &dp->fdbs, list) {
-		err = cb(ds, port, a->addr, a->vid, a->db);
-		if (err)
-			break;
-	}
-
-	mutex_unlock(&dp->addr_lists_lock);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(dsa_port_walk_fdbs);
-
-int dsa_port_walk_mdbs(struct dsa_switch *ds, int port, dsa_fdb_walk_cb_t cb)
-{
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	struct dsa_mac_addr *a;
-	int err = 0;
-
-	mutex_lock(&dp->addr_lists_lock);
-
-	list_for_each_entry(a, &dp->mdbs, list) {
-		err = cb(ds, port, a->addr, a->vid, a->db);
-		if (err)
-			break;
-	}
-
-	mutex_unlock(&dp->addr_lists_lock);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(dsa_port_walk_mdbs);
-
 bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b)
 {
 	if (a->type != b->type)
-- 
2.25.1

