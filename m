Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDFE69CAC6
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjBTMYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbjBTMYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:24:01 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2056.outbound.protection.outlook.com [40.107.105.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD321814E;
        Mon, 20 Feb 2023 04:23:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVB/lkz7kyFuib5CxBPmjFB+I7IrPeduiJqyLi80F3aCaSiR17IErG4TieCE4ftvmnuWnszjhjc0CchXGl5nt+/BEIQLOVBx2E6i/Iu0LgzZjsep+oH+H5dmanioT2UosMvOQ94JOHi50Wy7SZ+aGI2Vghr1oUbF/cLHBauAbs6V5MA2vEikYrqaCLRfQZBUpVGc1p/d4KW5NCI634thqvIBr63lU4j8nQmQQigkjejEZ2uXwrfoag/yir++cvp0+eB1eOFvDhyoUy2wro0CwWqLuyeFlaEZgPtlGr725D3pvviRkwVXWmCjbT3PM728FKp0PDsHxUi+51ZbIG1MJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HrOGSjADdNGnCxvTN6zOO/6ulh5BCUN1mw5+cZI5gn8=;
 b=k8B8CBYz5t0ZkUdcKKByTIdBEnoTGFvOMgryLt9gq2rVrt+WgpRIWYslhNapGrFfECb7brKIAeFRN3nfE0GT9Lvv+RC3pebUlKgFlgN4bp9dDha6onZI0FfxzdCuAJX1g8aCprsXbrKSVXBNit3+L2ZWHXmEzuXDrbVwvUXuQL/2swcJBHNalmRl+3RwE7Tqd8Tzp5KPDNw6hHGczs/CZ9vyoUsdq8OMN9s0ZpKeZQrAn+1E5fgWr7/ORVda3947vvj1YHu7bJVMIDiWr3pv+V6yirCIO1hzHnUK2+3HzK1q3xGqO/icFF1aRvJFPOml0bmILE9LJ6QERX3VkV9Q3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HrOGSjADdNGnCxvTN6zOO/6ulh5BCUN1mw5+cZI5gn8=;
 b=LeePMcEUy9v7mfqkxoGUJEhEWPj0XH3uGdq5QNOA6bgWeB5HMuJEZCyvts/FULFdAtxSyoIX2CT6fpYlBdUM03v35dX4GPXkBN/xiEvzan4mJZC0p4e3fla4LWyr8ePXPGLrYK7dnG52RPnfjjwXD8/eBecJWSH3wkl9j923c10=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7725.eurprd04.prod.outlook.com (2603:10a6:102:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 12:23:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 12:23:58 +0000
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
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v3 net-next 01/13] net: ethtool: fix __ethtool_dev_mm_supported() implementation
Date:   Mon, 20 Feb 2023 14:23:31 +0200
Message-Id: <20230220122343.1156614-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 53a6edba-8f10-46d0-701e-08db133d571d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ryd/cK3upBN7ykMEltpHUvYF9wvBlUD55QAmdlDHi0pIYn0bGgEIHCkSdMeBEZmiAQ++hZ5Je1qtF41Uz0a0uAe4qgGJeukeOTo2BETMykqgGQ6iMRXVTMczO67hSuqt89NOqENpNdSgkZ7UYIq+4xUhX8WbFf2cPViYbopSThSBWhn63BLl8mulyzlmK8fKfmI1GlCJ/gxON/ngPRwiwmzRjF9L6Ke1+spEB7/dqxoW7ax+yIUu/aKuXR73ZJfLj+6B5jqneTSGj6szt/eaP5s2sv8plOt6678Dx7cVFZivmwaD6gACBhpFK1TFhRQJ2otdJi9uPpA91mo6I9O0kz3bpd5wim/mXtfkMT+CPuxJo1btAhUPeVwnflvJlRqbJE4qu0/scKrSBAl1EgGkm9cXHAgA6Qmgxph4jcG2Kw0b5ZrLPb/bOEEVhILkDtJ05vS1XyvGVv3BQ+1zq96KN528nX6F0T41py5k1jU8GTf/zhTUPUdd4/cUCg8MyGQDnn1y8GdPRj1sftoVZ+daALcUoDoLOuaRF3605oe0V2oM3lCvnW7PgcG8akEjn2pMEa8izGamtK10Pq9jsLqjSy8sHpcOqzhB30jPIPkvG8bQ4o6DlrMX5D5mAvVHV3qkWCVvzMBhtbgScgkJ+wRd3IA4taFdOxXppmigWz3gxHqsBLPWVv3emyKW0ME0F7hHM5MZRe0GV3JNcPlRjrM0Yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8676002)(6916009)(4326008)(66556008)(316002)(6486002)(66476007)(54906003)(66946007)(7416002)(966005)(52116002)(8936002)(5660300002)(41300700001)(86362001)(36756003)(478600001)(38100700002)(1076003)(38350700002)(6506007)(26005)(186003)(6512007)(6666004)(2616005)(4744005)(2906002)(44832011)(83380400001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wJNyBMhjZREkWqtX+qUQOR1LriCGaY8ZEZi0J/KwRMVEAhTr0gRBm4MXDfP3?=
 =?us-ascii?Q?j4ZyD3nSLPNV6P3ktYmSY4KYHklJZ3EeJ7+/7irg9AnWBzxw6YrwUUxwMmIv?=
 =?us-ascii?Q?gwlmo+/R4UydIERuFBswI2fIRbXjIbB4OnmUUfitMEAYMbuSHnyfdOX8jnWV?=
 =?us-ascii?Q?SMKyL4Ru8RY3e+i94VRKdNopMQ826Vg6f349YWz/TYhOrYfK7bvDD8yQpPFq?=
 =?us-ascii?Q?ofvx2lmduQqePFkvMT5ceElu9UBvjYh13SXLLlInATFaG2ptDySLarzhIQro?=
 =?us-ascii?Q?ehDXeT/YHHInOG71U9+3ScKbC7fezmsUVDhUSpUgFFOMg0rF4BkhLgb4X48S?=
 =?us-ascii?Q?ohidbVnmAJVWh8vXWc9F+4AUSWnyseWt108hf1vQscwNZVzNmWPtSYxAss7b?=
 =?us-ascii?Q?EYLg58BMAkdbKSDbka+0+K1AOIJKoX/In06dzeqVJBT7o2hi+Q3vtfj8WvTd?=
 =?us-ascii?Q?zEPByJCEmswkKiFZvGd7GMjkdW8PjAkIkqflWiPHpsMLmUugdNXcDAAM1tvR?=
 =?us-ascii?Q?5pzeTxdwnOt5CRhb69TqG6iWgfezx4HPdcSqei4oQesfJHbnsCa3CBo1MBap?=
 =?us-ascii?Q?fApChn81MUi2Gu6pelRLMI7xDsloOvKTLagubCLzFwXzgwBaauGpjAa3JjuA?=
 =?us-ascii?Q?J9OsDrJLTFBTKOsfq6BO2Ih/whSv8z6a2w3ajkpLapbvMcNGk0hKa4Ii8Vaw?=
 =?us-ascii?Q?Rc72GzPd/APZGSDg5l1nF34aaZB6LNjU368sQkb0QeqoBVSG/gjYF/toVWIN?=
 =?us-ascii?Q?dLr0XNiWh+LARr3hnNXww7AqdOPjEM/1HDEfWF7oJGqhQ5uG16qPCbOBrvNX?=
 =?us-ascii?Q?17TWdnjINvXLkr5SDMgyHYV3B4kz6eg4G0qSgnqK4GWAo7uh+1YTHe1CGyvt?=
 =?us-ascii?Q?xUWGXPfJqwuyu2Q2puPEm4um/OfMMRAkKcbmVxIozLwnWor3thfl3hdKkXqF?=
 =?us-ascii?Q?DEGXeV6q8RaC2xJ0qbYnfEpgr1Eb7y/PR+/YomP2lujnTV07CE9y2RZfW+hM?=
 =?us-ascii?Q?4wC+VXLU/1l8GY08W+AisT1PshLOqSaecLPvppsrVAnBHzwlD08xlGGwXJBn?=
 =?us-ascii?Q?S/ILgsJlxDBi1FkxozoWRzqNabAJoGak/Vvn/BCG7NPH03OHuud+E79g/PAO?=
 =?us-ascii?Q?wPzKyUTmMhozkHkSF455Yr3+dqxGphcEw9D5RsTIGEyDRrbsatNbOYisShEy?=
 =?us-ascii?Q?P2fAn0bXOFEyibA0k9/vMR1bexL2p7aejwTS9d6w9qZHTb3sgRS7wbUeKilj?=
 =?us-ascii?Q?MgkK7ZHQSJXyLoMrXxmn2+GSf2uAVmYDQS1x1bQODE1r8osKTzstVw4ReyIF?=
 =?us-ascii?Q?jMDzRkEPUjmQfRtLpI7BiRUG6+VsQXQh33L+recfwnPFF7rVPbEskxKIr9SX?=
 =?us-ascii?Q?shFAYE3IeYAVnLne4jupOCr7R4nN/CLSa4Sn+Egm3sDzwoe6D/mdL4iJgplB?=
 =?us-ascii?Q?uToyojpzj0njL03WerSKrocDKfdXpHD1JPSR+xVbBaQP0G5XKgisBffidiUj?=
 =?us-ascii?Q?/JKVgM0G1M+i8HUZy7QEz7eqmRsN+e/CZkW29iKiIZFXdMhrl3OHCSeiK/Ys?=
 =?us-ascii?Q?bMa9Q3uOjyAqgm25YFT1tYVPUHqAacol0SPFKqsfO03g5fKP2lUSnW7vqOnJ?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a6edba-8f10-46d0-701e-08db133d571d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 12:23:58.2286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GuetE4Y7WrY9/KFB6CZaT8IlOlhy+JC1vxoOKwzKqQryvIIKkKofn8AFgWYPSkSJnffbUFDXLKKBoAzuzFG2TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7725
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC Merge layer is supported when ops->get_mm() returns 0.
The implementation was changed during review, and in this process, a bug
was introduced.

Link: https://lore.kernel.org/netdev/20230111161706.1465242-5-vladimir.oltean@nxp.com/
Fixes: 04692c9020b7 ("net: ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
---
v2->v3: change link from patchwork to lore
v1->v2: none

 net/ethtool/mm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index e612856eed8c..fce3cc2734f9 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -247,5 +247,5 @@ bool __ethtool_dev_mm_supported(struct net_device *dev)
 	if (ops && ops->get_mm)
 		ret = ops->get_mm(dev, &state);
 
-	return !!ret;
+	return !ret;
 }
-- 
2.34.1

