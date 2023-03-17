Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F43F6BF12E
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjCQSzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjCQSzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:55:01 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF7F38006;
        Fri, 17 Mar 2023 11:54:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqUR7yDhyfaQBCOCpzeyGv2NNcDUUJGiZwsuiMNV/fbeT4CidSpz3IFR1khWEaL4e8t/LatkMSy6WcoftYO/WJZSYOBpDwfwdPj50EptFBGeAMV9Mhu7G/q3Hh0pGjMpSrNMDh/9IkuGGTwqcbLarvjM3yY8srF2kHhEtjRNjw9nyFLxW3YaJ1YzcgariqpRkDeAInpQhyXg1cciWo4S8Yb8ZIkLbI3UCYPHd8XFt2a3IrTp7Nkk63TJswyhXZw83UYgGFwMpNxDrbFvnIsv0zy7DQiwfNkPkPxlamyLsDQzhLl1jxiu6i6d9hdStOE4mOJl1njhMD0SHEtkwv8MjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ECnQlW8CcTHfw9R2rNPzg6MoANDLlmn6PgI5oEwVaAY=;
 b=grXGE5eWSJN5gKKcwrDprvlWtOrdS2CqIR161sl0eIVzfuHBCTBhefJfi48FN+u695hHjy3SNAYAEGCal2jakpTsG6Soo49pfvzWaTzf/eZXrkPnTbmBN8Pe8rrdspHM5NW0OeGjSKgbhOIRlJA4YrNhFjlvGmNWunMgjksjXogVYNiYWDYGEiFQSIQFus37Q8pto3hCRx6b+J5m1PoaRnMsDAdpyytCqfOx8ZdUyhTpPDV2x9VxwEZfdcJf0+6SicVMao8DMlZRYD74X+Z/XlgE/lUrfIoTe8z0vTO4IuPuP2XXrZ7oMY7SglOysdp8KxDtWZDENSqRk2K+wiXgrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECnQlW8CcTHfw9R2rNPzg6MoANDLlmn6PgI5oEwVaAY=;
 b=hc1ds+WRlUUze2JUY3z9TnLY8cr+eyn0VQ8LCfyq5q/fvAGdQh4BMf9OOyIHu+MQk0dNor+/TGEFM6IWZNFpg2yyWIrvoTaTXfDhZ4j8WRCdWarC9skJv67tN+dlMrDakCTVA0zwrrVledk8eOWFtGgFB5XO7GvdxOYs0DRjEgA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB5289.namprd10.prod.outlook.com
 (2603:10b6:610:d8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 18:54:37 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 18:54:36 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [PATCH v2 net-next 6/9] net: dsa: felix: attempt to initialize internal hsio plls
Date:   Fri, 17 Mar 2023 11:54:12 -0700
Message-Id: <20230317185415.2000564-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317185415.2000564-1-colin.foster@in-advantage.com>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH0PR10MB5289:EE_
X-MS-Office365-Filtering-Correlation-Id: e92919cb-43d7-4821-62ea-08db27190e08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JwBlKbUGTTQPxoQX6hMes8RAQZlmOgZYNindHCYWIdcTOcb6bYNjH6cUlCSvLvQBZPomq74o2raUhzrk1co9Sf9Cs7ps657sK1D7Q1WTPEm7/vYmzRaNZFMX6wskhuPLBF8gLTjVO24c1xKlFHBvcTfGdIk6LUitTT0J1piKVVCN2Q8Ggrc3XnQcc42AzaAEC4TRYncDw/WmEhx9TPIfRoUMxAa7JzCWg9PP0E5KWM6JxG1BcKgSuJ4xHKiRx9SEasz9HBnBqXa4vfZm81aj2E/p/7g9q4q4q/yxrzBxRy6Yu/bSbcpLMxKe04sbkQ4bno/rMT8sRjdGRQM6dQzgHcPqAhFsj4roIDGc6hgmvLTFJwGqU/qRbAsWMa3znvh4xWK9qyfa3y1o61XM1M+G7hwOR82Vjj/yNdBMtnbVGHrgcEXD1wTKUt4vquI1J4S4+LDgetcocZ5IjdyivkVW1fM6SMAVOp/B6JZyYP9NGJ8HgkK+xRn+GhUnulsV/kcVFt/UJxz2X9JbHWJVEG727B76P36qOr/4AiliMHkBFil9GYG2uZm8NEorWAxlxCkyajVV8n/QH8Nq8++r9gPMnG7LslJi4OECA9okd8IYqKdiHRsbqO5SQkQLlCE3QbZZw4x4W/mATpDawaPpoSsPPFUnSR3F+v9/eBr3Lvx/VrINdw304IvzZGJ1xLxaPY5/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(366004)(376002)(136003)(39840400004)(451199018)(44832011)(41300700001)(4744005)(8936002)(5660300002)(2906002)(7416002)(86362001)(36756003)(38100700002)(38350700002)(478600001)(52116002)(8676002)(6666004)(66946007)(6486002)(66556008)(66476007)(1076003)(4326008)(54906003)(316002)(6506007)(26005)(2616005)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kRFKAQkUjTJYM2vK/OX986sjTzg4WktmKhWrEZXL7uPOsEZNKi2vzvUvNhWU?=
 =?us-ascii?Q?kyhviZHuuqJSuoMKTohyI/Vjv9sLBYxY79zFSnfmduAF+9LRminN8qCani98?=
 =?us-ascii?Q?HG3F/9x3VuXOc9c5HpCj3fm6IsqmnqLL47Row2tFkMUWQ0WAfhHAJBwUDfiz?=
 =?us-ascii?Q?NOnhydJTsu+4INU7UsOkZlHDZOj/2XX1LI0hYsyUWN1HiUREDTWUI/w4oiOW?=
 =?us-ascii?Q?+5jWvb0YiplttfHrgYXAAOc/uymjgZJUUvkscC8ri12lSKL3uUDOTw0U4bix?=
 =?us-ascii?Q?aFQcCNJg0+9AlBc9/J/78ECXjv05o3UpDwRrh+SFtJjM4yaHv9+b3lU4q9yt?=
 =?us-ascii?Q?eUfGEneBHRG6YDitJFOFZNmgEOM8nLFN9mpPgDPfau/fsXX3ICbwaJvo2w9x?=
 =?us-ascii?Q?JisQTBTIZZOBtgyJ0iKW9sGao60wgjSTIRC8yElH3nluGdXvkJPqmIKnSpM3?=
 =?us-ascii?Q?yeGYS0O53/XtZobcGxBK+ZDFKK7DZhHFsFnl5vywV7fBunnDr5SoDZSirCzi?=
 =?us-ascii?Q?1StsU/KkJxa5AAdQoeTMKAjLl5a3KrcTyWByqllOzg6pyIwr12BIkPFyCoHq?=
 =?us-ascii?Q?UFIuXp7tvFwRDAbKw5ROH/Pd4Jdhj4QFH7b+cbNwhfvXU84XJhivO5jEgX1g?=
 =?us-ascii?Q?U5+bIwYEBLUcVjMrsp3ufn+8fx8PCjQYv3cyL8BOqTDTHBI+4/F0hugTCSpu?=
 =?us-ascii?Q?vLk1qCZQ3XaAeWl04c+P/EIqNGi9nwgyBcOGa8ToJzyFSJsibMMU+OmCqN9F?=
 =?us-ascii?Q?PFLh6LmGnTCqmn4CqHHsEpvWm5IhqP0dtCV5HOZBJuM4zsTy5j6oCKSFkWBh?=
 =?us-ascii?Q?dcg+Wf9bjb4dFQCBEpJocnE1EEz64D0Xtn/yniVOm05vMdzEimhhyr8rs9TA?=
 =?us-ascii?Q?Ol29ypzucbNl1NgKNdSz8yzNAN5A2H7/OqfH3gVJ7Q+Ns7wSo7q/0P/ScZRB?=
 =?us-ascii?Q?WYxeZmQUaLmjCi9DuMwks6GNpZqxgr2+ZgrnqeFBu3NP5coAKdpdADUO++e5?=
 =?us-ascii?Q?NYEfngMiqSYGc2pbjmoJDXACtxwy0FNKHH4b/qtMpoXTezJWw9apzbZXnmYv?=
 =?us-ascii?Q?Vs6XcyJDD2tZyJ87MMJcbrXMxJcY6M9TVkVRPsyPtWe/qm5eau2/Ngbswquk?=
 =?us-ascii?Q?34rla/FlD/GjgYjRw5QscEMAQ3rksDLYHSenaBg/eb0uxRbQlDJFl0jGY12m?=
 =?us-ascii?Q?OQKZQuibbwr0pUsKiKqIGNaDrk55BblnO1HF+fXFNU0nf56hEU56Z40ppB5I?=
 =?us-ascii?Q?N5U0xKi/CDNl8MzWYSSWhzaDDN9LgIGbIK0tppoWk+CPDW9Skf+QE66NSFvN?=
 =?us-ascii?Q?M9G2deMPu1yYDXtHwKK+n6w2UYBfUE8miRy7Nm+lftHz1T8LNYzYB+/G7Tvt?=
 =?us-ascii?Q?AB2UEfUxMGGyt0sZ+BXA9obtVWadj2SlIlED+0qfYiUS0AevYKI8ZoKy76ex?=
 =?us-ascii?Q?INla/pUezZ7G8CjuGqDRmvnHOv9rctGND6o/DWhE22NO+i1hEBNDwLTt/wCe?=
 =?us-ascii?Q?eT+hpk83R8IIkzKi9mkGaGNynPOYxauimucfMbvvoxLsin5m6nb5ZAAvjUaO?=
 =?us-ascii?Q?FLwdZ11SwpzlAzlkrC4LdRPbn74+FSJlBWQvMvKK9i70B3Ri01NAMOoHFlPj?=
 =?us-ascii?Q?zhV6Rt3VQXLEfvuWgmjPurA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e92919cb-43d7-4821-62ea-08db27190e08
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:54:36.9122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FUJXuHienEuo99Q1MjFR5RbEaS79XOAwAqc4a5m4khQmg2hUaF7s6wEYCigZN3bfaUbikqnpnvnWBvn6MFRI8CVrmG/UwFokt5bxiZV99bI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5289
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VSC7512 and VSC7514 have internal PLLs that can be used to control
different peripherals. Initialize these high speed I/O (HSIO) PLLs when
they exist, so that dependent peripherals like QSGMII can function.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v1 -> v2
    * No change

---
 drivers/net/dsa/ocelot/felix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d4cc9e60f369..21dcb9cadc12 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1555,6 +1555,9 @@ static int felix_setup(struct dsa_switch *ds)
 	if (err)
 		return err;
 
+	if (ocelot->targets[HSIO])
+		ocelot_pll5_init(ocelot);
+
 	err = ocelot_init(ocelot);
 	if (err)
 		goto out_mdiobus_free;
-- 
2.25.1

