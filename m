Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB895B4B13
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 03:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiIKBHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 21:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiIKBHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 21:07:50 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2074.outbound.protection.outlook.com [40.107.104.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1430C4CA37;
        Sat, 10 Sep 2022 18:07:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mi6/+z7eysZ9Pa+WRs/aJ4RDfoJ1CzN3Ixgh6eLpUB2uRBhm3NA2myLD1vXyG8AxVsmMGwlefkIN51kbjks5TTVnLuY9zkVRSQCtAxz9mMPmAGCkSZEV4Qo0qXYrUWZtLDJXe4hPyCrrkjnR5LxgEN4Dd2UqBT8GH8SwilC9HLQ6zUT0ODgBV5mFgo56XRKTIRorg8hGKzrCx7VdU+oQGx4avGxhGXjqM8F3sFB7lqo++0hU+Ca69ycNbd4p2dzmpTM+IpEaKZl8pO4CgqT3ewCEHHS0ydAY5BamMkoEA5Crp7+woZyN+NhbwXN2hNAXKKz15KBZHBYcuJ3tUF3Z7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+A4/dkzSXUwCMg9f4YqC+L6y2HytbZn3abmRU3tTtWg=;
 b=f+lYR1MMIKlrOM0Esi22obdZPnrds2I0maAfMNtc2gC2K9w0jUZJS8Ej3oNeDe4rv/SI7OwvaTA4BUEmkOHxVK+kDGYrrYGrJNlj1IXAiYajNEumbHSK3O9CgiqzSPHQqifsQUq1JDOvNTsIwkNtSzcMRURMUrmPAl9EDZR5YrkxuD7vXSkmXwhSxhG9RDHyQFhhxoUQEHYeUAJ/Ee3HfZ2yIa94ain0ZCxtPgg8nk6IkUCaXBFK+6oPOvyYLLMHGI5nuENQomD09LwkbAeeV91UDhecH4XqxSk2SFgYfr/Hoo4DGplRhJ2aGZ8GIk8z4BbNBN2ytz3dQ+BiuZhgpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+A4/dkzSXUwCMg9f4YqC+L6y2HytbZn3abmRU3tTtWg=;
 b=Tj6oYcv033f+XcpKF8GknWXWBf5FveNzTs3ESRc/LgwnvKPnlbKNlyUnyDnFBbtwOrg2jux1vxUc/mB1aYGGYzlJKvYKoat8dh0oz+lKO3hqgkvA2STUH1ZI7ZEprJvsmif56adRrT+tOKF0hZqobNHygX8fBewQVs6AhrCS8C0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7739.eurprd04.prod.outlook.com (2603:10a6:10:1eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 01:07:48 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292%5]) with mapi id 15.20.5612.020; Sun, 11 Sep 2022
 01:07:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
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
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 net-next 01/10] net: introduce iterators over synced hw addresses
Date:   Sun, 11 Sep 2022 04:06:57 +0300
Message-Id: <20220911010706.2137967-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
References: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0129.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::31) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|DBBPR04MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: 52ebf5b7-4c60-4dff-2442-08da93920a84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5mGtS3iPEW2byMu6qbH6d36OGBGHtdMY9ABaStsuJWW4rGQYZLUp6HWJXxtA/hoXRSybq8+lYbYdpxxi30ULi9fDqTfN5AB1dUq/DwfNy9gM87qKLrCsQgkBXvd5kthtiYVr/mjg9d4er2CkGLLEsBbB4elqEIi2YAVrAQRLRhXmM2RMxICAVc6Op9+6/vLyCyoEu14O1YZWjJUsB+6YK5aECse5A6XYzsygwTNpk9K+KoP+cLeaSLpmiG25MRmGk0U9iSYRXA8Qun9Lb8sBCjxyFofEWensezdWlO4etq7UDzlmF534UhaApl9cmkHcZn3cpJmBfl6x4X1LfvK9E2/yjlaHjI5+zq/tgHjjP590mgmuSwiTGLGY7lmxyx5w/HCdk4jvjPHCEgbif52aprjtYgzBV2u3C5p8zB9zRrLJ+zApvtwNT75rdIFiv0PReQ27zgbUOL3q0MmegKbrDr0qgIGffH15y8vhYXO+4K/bFV2EMfJyAUE7HghmQiw/Oj3ULLQe5ke6EzEwjwKjNNPt03TRlmPF/3mPrWjwgTjXTadMQVAG8ll+cNmYfgzAECuIe7x/++vAyxHxOb19UVuICAk/6raKOH0M+44ezfHqpOx8+L199CuBBgLxuB62YvdLnjY37L77Glk6MUY9IKmOe/CHL5a+h6DonCe85yiqe0KUm1QkeWsuEi/nemK+xRBPJP43DRqZ7P86D1PUxo5Sp789KE0ho10Grv93bEqswhuNTtLQvY4mc6Tkhgmv6d94f8zSWrwyssZzyMuFog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(38100700002)(38350700002)(2906002)(44832011)(83380400001)(2616005)(186003)(1076003)(316002)(66476007)(66556008)(4326008)(8936002)(66946007)(8676002)(54906003)(6916009)(36756003)(7416002)(5660300002)(478600001)(41300700001)(52116002)(6486002)(26005)(6512007)(86362001)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i4SAk8gUBqPefSMxfGNPOsWDtU4ujqWJfZbi6QbOGzPPZT0GKqio3VriSr1T?=
 =?us-ascii?Q?WBeVj69H7/7vn5OoWrRBEkIxAAizocg/ZxE9tPtepQyov7GOMjIBIpsxDRmh?=
 =?us-ascii?Q?TJ8d/OJ0d6kMbg9kybafLUJHAFzaOMd2MPzHqyqpz5RgmJISY28eFuhmxXkm?=
 =?us-ascii?Q?sie+21N5gt258UzpjAueQwGg2y4Fqz0uQPj5OxUMKyqn/+fZhE59MR7xBabD?=
 =?us-ascii?Q?raCLeXUjgR8xCG8mALUi63/OMBmkgAEuDoC9FhLfkahxrAfP9fwKmaGTx9S9?=
 =?us-ascii?Q?cSTeBrIh43vT6iCaQ0k2IKU1+9YdX420brYdrTFgvtSbPBnpCsq6y1FnTlAj?=
 =?us-ascii?Q?J8dMIBCbZaxphfBnfelcW2jMzrosuLLZ2UNqFFl4v0GwcLhhxHGtjKenBsql?=
 =?us-ascii?Q?BU69EYbOg8sccsDiosj2TxsCBMzDHcFYj43unMA8+jFOv4kFNAnIuRz1dNhu?=
 =?us-ascii?Q?G34cB89BTKUnNkI/9pSQA2Epi9UJDfvOkqJdrcHQA8UEEO1VYWONoIxuP6wF?=
 =?us-ascii?Q?boYnCgRuVlEYWlFeT3Q1sP+1Z3lZtCnMpjtvU/mISnRhKzfVObLYVfExRfu+?=
 =?us-ascii?Q?Ftt/1gHO4efsiFc5qtfcMjJh+uka7C6sSI97dCWxbmPkRxIXwynqtZhTHgZB?=
 =?us-ascii?Q?WIuof7ZcTXShHJOKuApew7wh2r6dgjRxtkPPZTni3gxsCiyy+/4ktSg+M8Qy?=
 =?us-ascii?Q?1UfWtnVfqb61IJmsH/NpJuIAodFPQS6bhkUN0Ylu7KaSa66aTppNqMJtiW77?=
 =?us-ascii?Q?Sz00nISGKEXjjJ34a2F1KOYnO2uipi6DQOEbVWIbE9QWYIL0s5UyX8smJb8b?=
 =?us-ascii?Q?mK/flAeDoJf52xe6eHZDx15Q7++bryhL9HjOPZIYnrjXbLnRtrOMSiMOJU30?=
 =?us-ascii?Q?a31IWbjxh0B/kvWLKct2tl+xgapiAwFixJ6lzUwCP9ScL+Y7zm1gvsbxoL1f?=
 =?us-ascii?Q?N8ZxuOayvS6KpUAxMOaIMX7AoMX0N4bvH/4X434aGnOdSooyxgK+kwoBfEO3?=
 =?us-ascii?Q?uXPEipBsOUM/QRfbYq/WJ5/EZincV4BFeP41JvvofH6Eo/e4+TSb05Rs9H0g?=
 =?us-ascii?Q?hqm7eCo2JistFhzSjekY6wImhCfOK1ZrcukJ9NKidbSf132gSY3F1TmB4+5B?=
 =?us-ascii?Q?TNVRdWBDQlGXVoG8aH4/d5LVEV8ethnh0UZcvEPbIzOP9szElu2TZsoK6bj1?=
 =?us-ascii?Q?7cj1Bf9J6OBHdTEtw/jRNMj2UAbGuGDEBWTEf/WfFBbw9F3jV71bRK7esodo?=
 =?us-ascii?Q?7GubkSBr5iaj8X7msdajfLJwUpXrIvbenqOV/wpFlgiRAL2L/8dETPoG3Mot?=
 =?us-ascii?Q?dBhJLeoMF/LpZ8GqN7hmrNWPIq2JWCtefBPaDYM39i3D5/ROFyXpqNWh6V87?=
 =?us-ascii?Q?gdP4KMRXnAxC6fDoerXzAcIlLRAepyXGS83Fw4JcsMXOaoRhiApzxUmuBSsS?=
 =?us-ascii?Q?Pr3mveeQzsCDZxN+GbZXU2nQSdu3iMbro7H577UNfJhX5xRh3cZo1BeGj59z?=
 =?us-ascii?Q?uJmnP9qlIgw3K1RaRutmNyT+EDc96xDDw8rJu3ATX6noLEXBVSUVFNNkCxwT?=
 =?us-ascii?Q?koOmemEbAuX1N7Cfo2bwruADMW3drBMs+UhdcFl4VZPH5Ky+5b9HOWoGtk3V?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ebf5b7-4c60-4dff-2442-08da93920a84
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 01:07:47.8693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Baf8pCoxqEc7z3tpNsjeaG0kg1TDSXVAd+V9CkLaaUqVKxb+nADo7n0vSmlQGXuG4xDWz2hO11c3xUv1Oio9KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some network drivers use __dev_mc_sync()/__dev_uc_sync() and therefore
program the hardware only with addresses with a non-zero sync_cnt.

Some of the above drivers also need to save/restore the address
filtering lists when certain events happen, and they need to walk
through the struct net_device :: uc and struct net_device :: mc lists.
But these lists contain unsynced addresses too.

To keep the appearance of an elementary form of data encapsulation,
provide iterators through these lists that only look at entries with a
non-zero sync_cnt, instead of filtering entries out from device drivers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

 include/linux/netdevice.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f0068c1ff1df..9f42fc871c3b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -253,11 +253,17 @@ struct netdev_hw_addr_list {
 #define netdev_uc_empty(dev) netdev_hw_addr_list_empty(&(dev)->uc)
 #define netdev_for_each_uc_addr(ha, dev) \
 	netdev_hw_addr_list_for_each(ha, &(dev)->uc)
+#define netdev_for_each_synced_uc_addr(_ha, _dev) \
+	netdev_for_each_uc_addr((_ha), (_dev)) \
+		if ((_ha)->sync_cnt)
 
 #define netdev_mc_count(dev) netdev_hw_addr_list_count(&(dev)->mc)
 #define netdev_mc_empty(dev) netdev_hw_addr_list_empty(&(dev)->mc)
 #define netdev_for_each_mc_addr(ha, dev) \
 	netdev_hw_addr_list_for_each(ha, &(dev)->mc)
+#define netdev_for_each_synced_mc_addr(_ha, _dev) \
+	netdev_for_each_mc_addr((_ha), (_dev)) \
+		if ((_ha)->sync_cnt)
 
 struct hh_cache {
 	unsigned int	hh_len;
-- 
2.34.1

