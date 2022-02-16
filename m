Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A6C4B8B82
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbiBPOd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:33:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbiBPOdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:33:23 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00AE16FDCF
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZs0gV8iav0Ph6XnpClP/fERYSPIxzUCKelpEXNQHR1cRDBkR6Y6mWTy8SKIcaWehsak4BOIrC8kc9y97W1ijATwYhxJYznr2kswaCeRZbG1jyxIbMOgiUWpAnw5uBIFpIktR42E5stCjeGAtFNOi34n9mDg+4PeohGIny95jZLckF/YJ0z7bSyT4rXEzoikctqcY384T4U05H03syZwXq7XTLvgk7XkooQCiJrAoZMPQ9z/dnIqHZZQPvIS+G5ydrSnqtd+GddyAux/3YwzhON9fay+Lmanq/XJYV8fJUzSx6vqUh11n4wLDkBpGxO1qnyT4Azqsqa/8ejWUfYhbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FnLi+M/+HLRFxj99w7B0mCG7XD16qZfaEyq56LVD1o4=;
 b=XnSLpCDsM1OIUWNkaEy0yKeKr8p9juxPdmpDBy6zukaB+HnZ6LS2SAgW+PlLSy9XnVCFKhFBbIYu0ltk8QgFw/2DMKDjUNnpLy4VGEtMi4Eij4f0yvxa9s2B7QyTfEhN6M1bS4RGeBKHiVwkqpzPGPJkCjKQE03YerJwKhsE3sTYrzuxe14IyazJy0jiMeoIwveUpiQEi0bTK7aMSVrXi+Ub3ui66VlDGYV3vaJG7/CYcHmMMSMixaAr9b/OoZtWVBxFGpWjLdTJlgQzTLqFaBsmLIl2Ukh0aR3F0FyNGeJg5wP88AfxAYLApT+CugjeXjRoTvwnuytus5GwfHbnEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FnLi+M/+HLRFxj99w7B0mCG7XD16qZfaEyq56LVD1o4=;
 b=ZlU6KDaQEzdredto4Q6E+qAmpREBLHnzlZbBBvWV6AkefQLMOPwmVJ6ikaFFKIUVM/ZfMebLYFzSlOjHSvXtbOCHlE1r+BI9R8hM1mxm/Pzr9APvq1sQMDgbsoBHCFkWsDISgvviFyYGOsSPOTIPpo9wooUXITaeZ2WO3jBceDA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:32:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 14:32:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 09/11] net: dsa: felix: remove dead code in felix_setup_mmio_filtering()
Date:   Wed, 16 Feb 2022 16:30:12 +0200
Message-Id: <20220216143014.2603461-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
References: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:208:be::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a69b3f13-d93e-4a08-1b21-08d9f159338a
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6815613717CC364B5FDC65F3E0359@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uB+5dOfn7BBA1BrkB+lEqS1a0iAUzaDxVqcdf8uVXaRSMhlNKbBL8kLtYjLuS3BY/1acUC592O/nxBiW93UzcQ79DesmojVKeU+nENtSw6tFDKCRj6cbF3yhiXdSfSYATxI267aadWOeiyL6HJtrkfBQfkd93a1rR3ZcebvUTlzupH8PTFhxp2C8WXT8/gryg8DcpNR/TKuJ2R+Rwl+0d/dTcU/FDBWHX+CrY/HFeFd5TKZoaHTJzW8Kb3KyNOhfcUNhZRdkflpJTFxO6+EgYhbvSar2gaDzzgr8QVzk1PwZanrn1oIDuoGEKagWiaiczL120jVjC6oBH0bWcwHv17EXxBi2ZDjrutS6FtIANNENP5Epgv/EpGpqhJewZX6E3Fh68A6fiTGHV0H2AwYJBtyGiHki/WRy3MKmTibqDXjo+VTs8cXLdMFZXlQOsbZgALlsNON4VmhEflzvcPBmbONNEHwS2+zx0RlVGRsuIMOqqRFsNyN23EhmP2Rjw7NLky/0j10nI3Bk4BRBtExykMboAuqnkOxLWpDJ4yme8J0RwyNdepYIG8DT89lDRVBPAMM7eqfZgaeBq+eexW8sPRzcZn7eGNEgMMrt7LwEze/WxOt+e5g6+2eLlOXITJbA79/nfuh8NXntb0qhY8qh8zE3AGMsBdllVareygGg8hGA0Ck0LLONjwltwOZqRTHopFRj7dXkFCQ1xgUHylWWog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8936002)(36756003)(5660300002)(44832011)(26005)(6916009)(7416002)(316002)(83380400001)(2616005)(186003)(6512007)(1076003)(6666004)(52116002)(66946007)(38350700002)(38100700002)(4326008)(2906002)(8676002)(66556008)(66476007)(86362001)(508600001)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3WhSs6aIxQvJZt542MyxNoWTLq1noxTVBXPJn0Wjr6RzitfVIZVq+wph6GYm?=
 =?us-ascii?Q?6azpWLIxp7XI9LN0MzNfAgiz4sI9tsjUBnsrORTHW5UrLJBYIrdXHeHV26aq?=
 =?us-ascii?Q?bj/pUELBFbyLt+wkTi+iE24YYhqmjroQLzMVIcZ3C8mGa/LDPWin8JZ77Der?=
 =?us-ascii?Q?0EYe1OlUzQ73XpDYcYjrKBcqRyL0vM+IHW+5H+H41qM/JkFcSXLcktqbNSHd?=
 =?us-ascii?Q?EK/Rmh3coNllqkIyZl7dPbclBec0EemOUrkVKYcdEmP7FkhVz4+mw+f/n6m8?=
 =?us-ascii?Q?9Wc7u6iYU//04ByOGkXNQNF9QVpLHyGIuvJ6lFJGdQut/9GOkPbpJJDGcvQl?=
 =?us-ascii?Q?rWX0WmHoy9qltBelVdJ1z27V75Pw7KIi8YErZDb8Y0ZhfUKzrQPBUtfEPkj6?=
 =?us-ascii?Q?a0ypj0VmJaZcTp/8anqHuwg5e6wg90eUebT43mechOmiJcpGE8x2iNQBepBz?=
 =?us-ascii?Q?7DkC489m8rUB4VrDfvMLTA9CobyNmtpfVt3J0TBCBHw5keIJ9qu/96UL+M7w?=
 =?us-ascii?Q?2TUG4/pbD+NWD1Lzga7yDAIEt9DjACMtmtU54D6pI457VZVOsNp8xMkZig1j?=
 =?us-ascii?Q?52WIjyytjNl/pg6zTpjohjL7OH2FoZtao+AIWF/NmdY/LpG3cfshhSr3+d2U?=
 =?us-ascii?Q?4rWnV5KyJGEY6GpvbvGG/UUR6Uqlpb3aBdfNwC3fMv2Fc6dGOMqWt/9aMKut?=
 =?us-ascii?Q?HndDAm7ltVigIJAWc8+43wEepQAAEonz7NEmzqvN5Hp9diVijnJYr2XVDg45?=
 =?us-ascii?Q?w4MLdRup5V6+hxOhADeneHKWFXGt8GDGKj9U3ccf0l/o73lrKn8C+LCU2tyg?=
 =?us-ascii?Q?Mt1fykAYflSZy41W34lmBqxUr/rZxTqfxFzNweYf9f0EdACMPnq4r1moSBdJ?=
 =?us-ascii?Q?slIhoWzrlOHkrWf5LB20KkDJWbappeAXJsxsd00Ju35r73PM1ADUrtalNq6P?=
 =?us-ascii?Q?zB0EN2Y9oTtsIhhFFJ1QAcLMY8bk9d7qOz7K2pI/rFTmWt9udg4Hr++BZFYm?=
 =?us-ascii?Q?MPjJf3BcEizueUhGIIgXTOMepZERDTbE86Vzz7j1pk7UFGJD0QUTZ5uIfgXi?=
 =?us-ascii?Q?y9zln8Siqq4xurlbsD91nZCk+48hcvQqoHmQadr0mDer3hAfTBMCxp/5kVDv?=
 =?us-ascii?Q?18Xf/vHgOCnHLBU8UJezf+SRRdo3lg/iDxnFPoP/+EURhL1rL605pdpoab4g?=
 =?us-ascii?Q?SnveCddieDay+I8c+Z1hLBgH9K9DFmgQ6prRXmUOe/XKIXwsbTJCIvHYen+w?=
 =?us-ascii?Q?d+Am9RfI1NVoRUeLRuVgkHFc1vG3edwLAdXM4Ptek+bLaYnerGA6v336mZQJ?=
 =?us-ascii?Q?RMK2y8q19HBPDegXpmfU+AQ+g/tZ2fwAwtUnfybmzDYB3zmfzz/vAe9xGTYt?=
 =?us-ascii?Q?uf15LRxJmqviBfwZBu3w+v8ROiSfQq53DLOAlI17n1MkYGRixXZKBqCACPqV?=
 =?us-ascii?Q?k40O+gd2eZ6ku8i43+Pj1DkILZJmXRmIF7MWPCGEGW31jc7+Fc83J0iglruJ?=
 =?us-ascii?Q?VgqMhFyk/VCrizW0LAe9LsrtFK7Qw1K9g+dW9o/7GhsVJqc26yshl8d0Lnt6?=
 =?us-ascii?Q?G2hpWHMJxnZijbuB7fEsV4Klnk+IwqzPb5ggHx2hl5CzdzuYjtRQBhTH5vk9?=
 =?us-ascii?Q?zpjs9G7tF2kqMrH6OytYB4g=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a69b3f13-d93e-4a08-1b21-08d9f159338a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:32:47.0583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NmnkACvEAvjh911gG7j1JiQX8JChgJiZEgWWF/140x3dBW7DrI0sL+ONW8mqAtqY6n3H2hqIioP03UyQCzWHFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There has been some controversy related to the sanity check that a CPU
port exists, and commit e8b1d7698038 ("net: dsa: felix: Fix memory leak
in felix_setup_mmio_filtering") even "corrected" an apparent memory leak
as static analysis tools see it.

However, the check is completely dead code, since the earliest point at
which felix_setup_mmio_filtering() can be called is:

felix_pci_probe
-> dsa_register_switch
   -> dsa_switch_probe
      -> dsa_tree_setup
         -> dsa_tree_setup_cpu_ports
            -> dsa_tree_setup_default_cpu
               -> contains the "DSA: tree %d has no CPU port\n" check
         -> dsa_tree_setup_master
            -> dsa_master_setup
               -> sysfs_create_group(&dev->dev.kobj, &dsa_group);
                  -> makes tagging_store() callable
                     -> dsa_tree_change_tag_proto
                        -> dsa_tree_notify
                           -> dsa_switch_event
                              -> dsa_switch_change_tag_proto
                                 -> ds->ops->change_tag_protocol
                                    -> felix_change_tag_protocol
                                       -> felix_set_tag_protocol
                                          -> felix_setup_tag_8021q
                                             -> felix_setup_mmio_filtering
                                                -> breaks at first CPU port

So probing would have failed earlier if there wasn't any CPU port
defined.

To avoid all confusion, delete the dead code and replace it with a
comment.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 549c41a0ebe0..f0ac26ac1585 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -296,11 +296,9 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 		break;
 	}
 
-	if (cpu < 0) {
-		kfree(tagging_rule);
-		kfree(redirect_rule);
-		return -EINVAL;
-	}
+	/* We are sure that "cpu" was found, otherwise
+	 * dsa_tree_setup_default_cpu() would have failed earlier.
+	 */
 
 	tagging_rule->key_type = OCELOT_VCAP_KEY_ETYPE;
 	*(__be16 *)tagging_rule->key.etype.etype.value = htons(ETH_P_1588);
-- 
2.25.1

