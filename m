Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C495E7FE2
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiIWQeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbiIWQds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:33:48 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60063.outbound.protection.outlook.com [40.107.6.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45343143291;
        Fri, 23 Sep 2022 09:33:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/3TumIs2HGBqcJLxlRaP7bLOHNFwFS2kRswLb6aQnmkMb4O9z4CHGwFhwD+Cra9Q5/BBWjbqjSsv5ULr41Y4UIEA1HQw4s7DQzvh8BNpHgBsrROX8WYXqsDNSzuzx0dtVeWmFPYl+EijHRZcscwFFsrv87r4iFD/cPWJmAxR+Y18VTFSQ+nOCK+zsq/SkGpQDwBPa9gXUN4HiI9pbtmJ5grp7r/0dm521goHsuTgXWRTRLEDHhqjTzyMehKwlrAbRr/t9BB8MkGpv+GLjj6YdNcEgW3OYNv/mjyO5dwYZ9yUyxFci7Pm5KfM/Z7Kdmv/YH+2qbLaUQVAljIR+IhFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TfYGQB86xdKIbx/pdqoAH4P0uYpNwcIp19SBSo2oYUU=;
 b=YKqFauXbSO1NnkOUDl2Ib4L/P+GH+KEtnu7doBA2iAHV/ZuRtWbuzgKYRZK3hkrZITwxU3saWpXDcxIYKsRgAPAbTzpNdMKfJlSPRCk+VMtoSAtEOhq6FFxHzIUgLuGcObpKwsvw9z2KxkGenMrzoK2sQVm4ifL3NW1KPkq9VNuVDhicfXjNdzrRVuypl4I7eTfnN1p0QBgD+y5sH6WMJjBuFTy1VjQA5F5FXXFn9SuJyTkASHAzLl8Wp28GfN/35Soh8m5/5+RW6cWNkC4dPW8D6Eab3bHMBatdRquZCBw4oIEymKOUaCEBKNerjyYEt37M8w3PfjD1H1+wc2FwhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfYGQB86xdKIbx/pdqoAH4P0uYpNwcIp19SBSo2oYUU=;
 b=Rn0VcFH/1MulZeDCJn2PghO8BcSHX4praq1xZoVm5kB8aG8TIL/2PxVWBBFsg+B/Qy10vb3eDYo0EJhJDg7/0+YPgLDZbW3TNgDTnQyqs/8+sHDZ500XiQ9So06rS1pG/bBqZgMtt48ynJVKhoZ/0Q7qlHRMO3R1s6FqwRPUBgM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7023.eurprd04.prod.outlook.com (2603:10a6:800:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 16:33:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:33:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 07/12] net: dsa: sja1105: deny tc-taprio changes to per-tc max SDU
Date:   Fri, 23 Sep 2022 19:33:05 +0300
Message-Id: <20220923163310.3192733-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: d442722d-9d1a-4b5c-e78d-08da9d816093
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9SitFuDSQIRWAAdWT3uaHND+KHiCPl93oVJ9AxF4Lcvw9G/a3GQSCC+JqQTAyFcni4WjyaukJZuP7IJEC60Rj+Y9lNEBo0jHGR8iZrmqZ6iHK83lWiAMnPoHyPSD0rJT0/S1qH7wFTj1NkcJ7B8DJdnBIpO6v2xmIQ6UXl8mXC2j/Lb+M3UBUBfxjvibJJ4FhbGg3XJMQoWLegOPxc6LSKSKR5+dfSzHLqzSRZ0NOoypCsK47+QREvg/TAbTLijuQqIi3eLrGzB6BPr1qbmThu36k16EDAA/6JLsTioJExJz/FhKHRJuy19Dw31FjWcQJdR+ieExuoVmuyxRjF42UtmFhvqFWGVRSFTNLj+ovWWjuR1UlAEEdZsz1BcFml/2er9pJDvKhi6S3++0Bo8yW+VidycLnEgFquMufqLhBOxNe+Py+HAcgImjWMFu7T9CFoFFqxoxtp5bp14BGni9NzhK9Tpi3V169WjV5PlE+gXHZkPQhjHXIu+5dvBxslDNj6QQaBupBzZcL/oMFPUqybliIDYEMN6uWVrSSUGhsUKQLYx6GB/OXJK04Kb/VHZn0oPYUMrOdrjYs6uCRzPXgMEGuKG5853eYea5JeJgEoLm+osKGtDOH7leAKLhrwRhpPJ3HTe33mzyEU5JuAR6WAc8NL/9YrB503S6CiPL18T5bxCBOCG+jV+HWq/fdvRSx7UygE4SyhsDfykJjL29HcOWUniaRnPjAbZzVXf6BwTGXTTZLQPDV/VUY86+L/3NBUu17spFzM1pC4uv+lf4dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(6486002)(54906003)(4326008)(66556008)(66946007)(6512007)(6506007)(8936002)(66476007)(41300700001)(6666004)(26005)(7416002)(44832011)(8676002)(316002)(5660300002)(36756003)(6916009)(186003)(2906002)(2616005)(86362001)(52116002)(83380400001)(38350700002)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mdp9B6vuBHFVWyiMT+o98J5D/ZjyuyOC+rml8g9x/0kV39MQJQip8o4J16xX?=
 =?us-ascii?Q?7ZkQWlMNhvk3ynzZRR9d+8rA2v5Ca5jiY5285LfRFFBuH0FNADeLThIlVR9g?=
 =?us-ascii?Q?jnRPo3FMiF6ym1L5UCSvlk8nRa7pRusFSbS0TWlii1mb0frE6LVUjpyrRbP+?=
 =?us-ascii?Q?tMj+sGOwE6iFcBfsyPjrPobAV+DGzFKcQSkB7k3I4qjXkQmiy/qCQQHHL1RS?=
 =?us-ascii?Q?Tl1DoaubAcA5oYi+u5IYE9pcEcuVBPBNKBW+B7TbbVifIV8buGRO1q+uUqr4?=
 =?us-ascii?Q?R6SweDMpLxZs2fcALhw2sqKlk/4pT+RZOJuMnDK0zhb/SIrN32VhtSMtYP6I?=
 =?us-ascii?Q?6h8GwMtLJWyZBNqlPkf3GP9n/CChSfOjgiMHeXfTeKXWFDAj/B+Kw+RInaig?=
 =?us-ascii?Q?ma2UFArNqbzv/dAIN5Qc7oyY8Vhxu8B0t1sV8DpTUlhBbBgVCG3F5oVZhBeh?=
 =?us-ascii?Q?YUpGEnaK12BoqqCT3hDyWQtA78Tti5VYrz3StkoR/glrNVt6xYnaVVVmhptQ?=
 =?us-ascii?Q?pfkRHpAYajY5QjQp9XifNMGKtlR2zHAXeoQ/HxD9kfnipKTqXWdurcq2nBDz?=
 =?us-ascii?Q?Pk2t/ZIsSVFUeflqgduWQ1Yn5CZkRCEHW22dq4RqDLK9s/qkzqyaTI4QTaiq?=
 =?us-ascii?Q?m8rOz2vMz2FYYLfC2sFlInI/B8FhlF4bP6OXzZp0tqe/yQHzuJxS6dBJ5E/R?=
 =?us-ascii?Q?hhWz956CySAseuN07FpKbTRUkJER5g7r0P28y9pkyTG56KuPYDYuIMlhkjZa?=
 =?us-ascii?Q?/PDtRH53OkkELPIr4r0Ryzy99ltir2e+i4pwJlnp9dCfBzLUqKzZpiDZFXJE?=
 =?us-ascii?Q?CFAepXL3xAdb8Hqj3CK5Rg022RQ826jjnfFkd34vvRSknBrfhUfMPQGVPKjZ?=
 =?us-ascii?Q?i+DwoHgk6YjHRfRVo95J6OIbkIjzNo87d4TLnB+jC7uW2ixCxi9ZfG9OqqfP?=
 =?us-ascii?Q?aax6xrRm9CtPgNRA3OCSACaM5dAyqCBxXXawFpQhEcWuuO7YgKK/LoD+nyox?=
 =?us-ascii?Q?Kb+D14UTKzRyuXbDMJ66RvOBIUHysGn4qXluXdcVv3YzpQ/AfE3T8jhssKsA?=
 =?us-ascii?Q?0X+lRs3CHg87iJzZuRZyYlxsIF4xaKmDIJhcqxrqPDYqTKxMIefIOdOxM4gW?=
 =?us-ascii?Q?hIyOj0mglc4s6M0m6mpBAC2mdPrFKwmc76IJjBlynkSDJJiTEeZSQqj6RUlx?=
 =?us-ascii?Q?rD/37U2Z7Yt3bD2tNyS9QTNvSOR+g7oqS6Ciqne7mtszfDZIZc1O/rcqoJkg?=
 =?us-ascii?Q?zxvyVDMYbWqaW1A9pw6bIEUTRMPdR63DJDa6O1Q2nIlNPISl31UFzOEQ7X/g?=
 =?us-ascii?Q?WGhL3DoViveRm/ZVV5D87SfsPb0K/ZWiXKN/bjDJ/YPnxgWp1r+OPxqbYJvM?=
 =?us-ascii?Q?tZM2LQYo64NexH/JzIj/kjy/ocm7wu9CdKGWQze8c5jx7Lytcu9wFOgC+Cb5?=
 =?us-ascii?Q?7Pf0IPlAoF5FHr0DM1zqVgV9V5qc3/5YqaJ0SwEgGSiHJ87NhfWzWxyPwM1H?=
 =?us-ascii?Q?lrsvOuFu/KreDxRILjv49tzLTctJlnXRKPf9S00B3rS3nIpKgLPmWJrlzMP7?=
 =?us-ascii?Q?JGLDTEXYmBEPCmGeZ+Htg/pa1p6rapoC/zTBFLPW/kJonvzN4tQpMUiFHQZq?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d442722d-9d1a-4b5c-e78d-08da9d816093
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:33:42.4869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nWE7ybO5DnvfsyCjZtY/ZvAyFXy0VzjuhfzGfRd0GcCi7iNY5eFrwaVjwyoHl7nXxjsGxJuI/bqgvxAZWyKCBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the driver does not act upon the max_sdu argument (which it
should, in full offload mode), deny any other values except the default
all-zeroes, which means that all traffic classes should use the same MTU
as the port itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/sja1105/sja1105_tas.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
index e6153848a950..607f4714fb01 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.c
+++ b/drivers/net/dsa/sja1105/sja1105_tas.c
@@ -511,7 +511,7 @@ int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_tas_data *tas_data = &priv->tas_data;
-	int other_port, rc, i;
+	int other_port, rc, i, tc;
 
 	/* Can't change an already configured port (must delete qdisc first).
 	 * Can't delete the qdisc from an unconfigured port.
@@ -519,6 +519,10 @@ int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
 	if (!!tas_data->offload[port] == admin->enable)
 		return -EINVAL;
 
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		if (admin->max_sdu[tc])
+			return -EOPNOTSUPP;
+
 	if (!admin->enable) {
 		taprio_offload_free(tas_data->offload[port]);
 		tas_data->offload[port] = NULL;
-- 
2.34.1

