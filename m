Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924625B4B1E
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 03:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiIKBJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 21:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiIKBIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 21:08:52 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2087.outbound.protection.outlook.com [40.107.104.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D54D4E878;
        Sat, 10 Sep 2022 18:08:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYsxQ7aruYvLPgvPRB8ZvFktJ7Kl+iowDP8mfBwGFcbvsjoiNRGB0Qscw38x+/juMad/mUkCVOH/OkSA+0CsbEYwSMln+iojAGEoFe9kRS/xwty+lbtJjxuHMA2MPqF63hQwbk5Lvomq6VXbKR8Lfg1GXLCdXsaO9dAAEdQNJ95qtkVTnNJD350ejldnRopC1Cg8X2U+06FYBWthjqetcSD+J2lzqSqhaFnBDrFCMgthAU3gFjaaPq2qY87WF23J03SAGXrZLyzPPB52Q4QbaPTtHro8ohVgUeV7R57SZDzcMtHJvCo1ZbRU8uildcPW4pCRHTwa6Nm2ZipzUnFkww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lN56njuhXSOm/RvKWISxOOnP8OekVWnKRXEckX0eef8=;
 b=cF5IuD5NyY2qlZmYZc6BXMqaoAoR5XastqKSASZ1ltGRJh3eEsazeVKCKzmp6S2ZaL7EvsNaLkPvLxH0JMHCPJf8iJ1cyn9sKIFz4C6rPJ0SP0/9WHK+XKK3Nwy+VfYz+UkTcikI47I/XAPug1t7J2JJEy6KAcIdRz01xXY9/VDhQr3Gplp9aPsRomnOuBg8dpBHTpm7SWt46zame00ii+rI9gtjOTpHxEcib6iL5RhRgQpUbllS4Qd8bJZuRue6iOxXPrzt3FQIG0JDvntZVGy1AZdFGCSWyYa7EbvPtURbaPhsgcr2o2pwyvxW3atlAUEkRm+daKf81R0rouZlvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lN56njuhXSOm/RvKWISxOOnP8OekVWnKRXEckX0eef8=;
 b=s43uiw76/1kb6AS6j9PkRDVUFjmW5rBwFmpbX4wBApAqbK1D63HwSjXSDYU9H6yNeCRJo8H6Xa9rHyf4wnVRi7c5puiumjhFb7mYGf7WzDazEMepsjsQhbTXdAMVlgiLjOuoFfWrU1ZcvDo0pesOUHI1hTBWcqeW5zY0E2hZyRI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7739.eurprd04.prod.outlook.com (2603:10a6:10:1eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 01:07:58 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292%5]) with mapi id 15.20.5612.020; Sun, 11 Sep 2022
 01:07:58 +0000
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
Subject: [PATCH v2 net-next 06/10] net: dsa: suppress device links to LAG DSA masters
Date:   Sun, 11 Sep 2022 04:07:02 +0300
Message-Id: <20220911010706.2137967-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 595a4252-7d14-4876-3427-08da939210a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7iPeFrCDmHy+YebxOpEPNlFwQPOV93tyi5LC3uH3UOIcm7nkpXmIH+VVmQxqf5zcPTtXF1fuGnOnJsCg1E5wvZQRTPWQG2y4qJoNFmj4448XNgRPMB/vQtgmbRDEkMNMC9kSXY8EzjK/rrZXysWeppJ1BG52SRQDjcOsNYbor5ImIma74skbLxQ+9j+DDKFAPjLb/SyL+OvNdMDA/qJzHxNg9dsElZadvNy4JvUQY29W6NjXDzGy96tocZ0QBhFks2VCvoxHCSvsX2mfiAt7kfgK/HiL/t145y2BjU24b6JwcF9VNMOEShrKEbek7x6fEhK+aVaewgj05bv0dzkmGyVLTqa4/4Vud0p82gM5ZfRx/4j6dMtkB9IWp/O1ByJ5G/Twb6dg84yvAsiI0ccxTNsoQDxHK4PfyxJ0okThbJvnjAXWGprRt2hSmOQlOWEbkKPkgMMtsyHCy502WMSMuENgt4Zo/bRNJR6GvFJR4sp06q9/7J/W26+BusGHNq00VSwZN0T2eIqwbobmTbCrA8UpfsLBZwhAFgj8rDr06Gn4CbHjtku3YVy4gxgoUgPwLaDFCD8IoXFQvbkBL/bq28/W7atJdyl2pQratVn5MI+9Y2KuDaA2Qa4AUF5kt59XAgZ9L+Ob8eFhsesUWPXEZnBK8eVR014Y3UIB5qFClfopynlHdAMwznDYpzyHEayIa7ZPhzQJoM/wju2YE0HLlSJKIHpBFKmoxmyEwKUN7VS0EtU/0bu169/oVhPaRHm84Vvc305eRtlL2S+eNmBYiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(38100700002)(38350700002)(2906002)(44832011)(83380400001)(2616005)(186003)(1076003)(316002)(66476007)(66556008)(4326008)(8936002)(66946007)(8676002)(54906003)(6916009)(36756003)(7416002)(5660300002)(478600001)(41300700001)(52116002)(6486002)(26005)(6512007)(86362001)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XHYwQDr4DXlvEaFCzC90yEJ73cWTqqBlXQWoRsr8uHTSrXA4HCDg7oFmN2DI?=
 =?us-ascii?Q?PtJ4tJEQiIRN8AixEtDR/KUF1Jdkic4U0dkWgQcwUKA/WNPmNXGaliKS3tQK?=
 =?us-ascii?Q?L4RKUqlIeRYcL8PQnHxHEWX7KlIWlRDNwVOdBT8PTcMgaVzoZ6M5WqiJm0W8?=
 =?us-ascii?Q?LA2/tvV4QvXEP+Vm1LKOpImCs1sY1KvG9qwbzzwtHW2Qq3a/1Ly4vmSZwMey?=
 =?us-ascii?Q?9yryybTCVvvza7pCwiiINtAuaad7shFQK4mwcp7jc1WTOy8KUzMdlQTzbfF0?=
 =?us-ascii?Q?rEIDcZMbUs/963PMHa/kbfSD92fcOpywl5k3BI3e31Z/bx4Cycq4OytNMUc2?=
 =?us-ascii?Q?3CaeW/noVtb9P5osrJphqF0TLb+aADMXQKE5j7yZiAbgIXfS/9E6m54gPcnP?=
 =?us-ascii?Q?p/3DRGolgAuxGUxiqkFFQqeCRfH/vw0xAqm6PJijwS2sYv0exHjieTfMTKgk?=
 =?us-ascii?Q?FZHQLaoE6F9QbsYcTbPCR+MXOWfIw0DAdYa1Wes/87YeTmabKyWzjQkn5Q4l?=
 =?us-ascii?Q?hlKWjtoJyAVFS+K3GwEKS2cpK0aWTGPOuc/OwHGM/z1bWg8Jg5bJo9Q5L6Tk?=
 =?us-ascii?Q?UbSUhU+ludxyANAufKO/aiwIG05/y+PnQRMmv/pKPSPjaZS60GW3qZ8p+r1k?=
 =?us-ascii?Q?7NCcAq9LOvM/xLkFYd7AxddYH34nf7y8OZCJe5bOoDhKpohLWFuSWrNDDRxr?=
 =?us-ascii?Q?TqkN17mhDZL81FSIiw+LE0FeTk57+hNzPiipkBgdsweCj15m6YTUneX6/QoR?=
 =?us-ascii?Q?pacqD2G9EyYglnEZoXlCpdA0xxlrNcwAYwLuP4swETYb0WTUqJH/SB+Y8Zu8?=
 =?us-ascii?Q?0Q+CZINjBysLtSdalBi8UYaX/iZdlbcK0goYGtKRh+YoWvLrkZLTmI4r7yaN?=
 =?us-ascii?Q?qVudgZGoEbWoMuPAl8ouG4EpodecgGlPI7EyQxi/tyIS04G0+FPN4KacNn1V?=
 =?us-ascii?Q?F0UK228IzYFg8GH1hzSz3TF9DEU2PTthZWOUxJyt6gjT88oC2OViQ/JGzJTx?=
 =?us-ascii?Q?Z1zEwVj8fGEnjp2j1pFLfO+B+PM/YGjnCZGZXoOdOOg78Oevvwx+ZGm4UGcu?=
 =?us-ascii?Q?BHqarvMahT6UX+WVg9iXcx4OlizuW6Gyi9Nk/myDCNPxj+nisQFUIycqh5mJ?=
 =?us-ascii?Q?9p2GVT7Dt/Lj7WfFzsw3dktyZgDd/gp8eyQechj6B4ZLu2IRrbVj69ODFK6m?=
 =?us-ascii?Q?SXUrHRpFrSePJdpXvEIystfE1T+7Oym75rQIF3A8SnYW8epiOR+Fd+ipYUaM?=
 =?us-ascii?Q?DNlnPuWgN4NIPCxbopf29zCTRgaY52MeCsXEjFVkUwSGWhwuLssNrcQYiABs?=
 =?us-ascii?Q?qbHsK2+5dFlL8Sj22fevlNdcT5KKwZk9EfSWkRHI34WI4mkucMNmBetwZx88?=
 =?us-ascii?Q?Cpgv0Kabrnf+6HNb6GfFYM24IEIkhUU+e4EbJIPhDzIt05CMqoXwp/BJFIed?=
 =?us-ascii?Q?Pd9zm7vS/6QBPftP2PafuR+4SOWZQP0xa6mR1OzBNPxQZ+rJ57Wjj0E1NfNF?=
 =?us-ascii?Q?HfqIwoikvNucdktrRYZfuy9jgVdnpLbkMDFHCCF6Ds9qXo9+meYYQaL9cOXT?=
 =?us-ascii?Q?6OIpsZ81iC2xBhXcy50vixMl70dYnVJiLo3r2zsasIVAQe5iuIMOmbwGvfej?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 595a4252-7d14-4876-3427-08da939210a7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 01:07:58.2122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OmTxahTO6Jk1AgeVEBdA0jT1g3hAtWZcAtJ2G4JXB9QxBNcbJ5Sc6siK8cj27ZZXhDZp7IsdbFrd6x6tS7Ggeg==
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

These don't work (print a harmless error about the operation failing)
and make little sense to have anyway, because when a LAG DSA master goes
away, we will introduce logic to move our CPU port back to the first
physical DSA master. So suppress these device links in preparation for
adding support for LAG DSA masters.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/dsa/master.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 99d773b24223..2176c14b97a8 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -364,12 +364,14 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 	mtu = ETH_DATA_LEN + dsa_tag_protocol_overhead(tag_ops);
 
 	/* The DSA master must use SET_NETDEV_DEV for this to work. */
-	consumer_link = device_link_add(ds->dev, dev->dev.parent,
-					DL_FLAG_AUTOREMOVE_CONSUMER);
-	if (!consumer_link)
-		netdev_err(dev,
-			   "Failed to create a device link to DSA switch %s\n",
-			   dev_name(ds->dev));
+	if (!netif_is_lag_master(dev)) {
+		consumer_link = device_link_add(ds->dev, dev->dev.parent,
+						DL_FLAG_AUTOREMOVE_CONSUMER);
+		if (!consumer_link)
+			netdev_err(dev,
+				   "Failed to create a device link to DSA switch %s\n",
+				   dev_name(ds->dev));
+	}
 
 	/* The switch driver may not implement ->port_change_mtu(), case in
 	 * which dsa_slave_change_mtu() will not update the master MTU either,
-- 
2.34.1

