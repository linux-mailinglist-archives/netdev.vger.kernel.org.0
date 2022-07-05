Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8975675CD
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 19:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiGERcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 13:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbiGERcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 13:32:05 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2087FE5A
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 10:32:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggwvaGc7Gv+imtBbxb5N2VZyoEuQxn7E1OLNizkd/5vVgUey0FlOsvMrQXlrB+utpRBt4OYzcDU6XJyqShfGJcEy/6sTKG666C8mcac0bPMSAHdRXbDg0oGJ7t+d+OoSWHIX5waHC//sMX6trb92P53GwmU0lQfwuWF6SQxj2R/S8h+zLEPRIbi8KhQEdpTWw4hBfUbXFvoz3O2zE/7SLCPVAWGttOGlCUPE+01LE2moDAXZAT6GPdWLAlhMjDxOVU3pJhMlWs6eMjx/YBb80ZPH3/wXZQLbc425nyTuRMP6Ma4D5b9aGAg+Umnb8II+jn/WYrI5MSVIMKcZCLNPrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJGXx4t1n4yCFfAiuOxQaY8JNWf9IT6XSw+MErEvM0o=;
 b=V9jjWMymZRaA1On/BLaPAsSzZTC5oh4meqQJ62uRkPUajaS0lbTTSScwKor6ZqtOc+7clbMiudPS+AIBztNFUoCCUB5u8eXyPsRUeLLeOSYD9IqAWgOzYDRnEgtPeCz/yESq+/4K5SabctkC0Mv3ZNfcSCL9aLGLG+rQWt8kMB2F6+hBCClHjkF5rMrim5uds6auZ9rCXHpBZO6+eH2MTNreClg5IDTE147j/xseEq4Cw+PR0fYCvxbbocNXjRkzeN/SDCurPibUbaCjDgV2v8hLmUZfp1s0c7S42Xq5yH0tkkzKDAUy53wMcK42I5//wAuDyGWTphebRF7TY/MhyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJGXx4t1n4yCFfAiuOxQaY8JNWf9IT6XSw+MErEvM0o=;
 b=stqtbczjpciJ4Tl8ExWH0QQQ4JyLMRYtsJFstOvjMfRB1ivxg458sAwEZs0dbJpnG1dQ2aff4Lu2fQ+eF6IL5AgkuQEMB0VZiPaENFZED1k8cAs7D6biqHYdi8fZCh788P0/dk2WByLDg5ArYlZdUK2GcTtwiRw/+kiXDmfnTJE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4251.eurprd04.prod.outlook.com (2603:10a6:5:28::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Tue, 5 Jul
 2022 17:32:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 17:32:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC PATCH net-next 0/3] Delete ds->configure_vlan_while_not_filtering
Date:   Tue,  5 Jul 2022 20:31:11 +0300
Message-Id: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8c55c0f-bedc-4f56-fd53-08da5eac45e7
X-MS-TrafficTypeDiagnostic: DB7PR04MB4251:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lUE2/rfWGT/UGBqw5+jtyB1peEFQPpxnI5GCxhrNgeTA4Vaj1OiY7+rbD+qqQD+YuVlWQAKH401sHdG1DHWU1JWrRJlwT7LNZO+pFyI3++yiUI4Zojf/6htlGumbpMCDmzFecwv8zWNEx6leKnp26cEInM1sZ9g6Kl/aRjuxJNZCK0mI5JeNIlVHTsLwv2wG4miUVeYqegmtY7HDdu0nHvK1QYQOT9ONxfBfm6osvUoeVJD2LWM7Nkt1EFrFv8Rk3NpLTbLgU8KLF3DRDOAQdy1SM9rhXXqVXyqtdEeiMSIAfryR8BEtmMeWHzy3dqYLYEchTDYhwYUt4d95pdqZ4v3nov3NOOyPc3UDbJJD2Zr9txUIAAlg86qKm428mMGcOUexTZ4Cme08euKh++5Yc+fq+IhRB0TEq/9NIQ05VDZRfo1RWV/LlBf6B9Zduk2lUFG3nsKT/9U0KGPHoOfV6D5szmg53PEnNJKkQ00jonMT26xqKY6UJsae0qPEiWtSEQZmSgJarJjTdz1w9yY9IlWE5VFlBOurn5uDNfzuUrkuyYZO0nfsWYXlE7xgNd9f+Kuf+rL9GTcmbamHr9gfDvku1JAqutQA/bk6lynKd62YEHdBAsnVvvxMzFzLP/pr5CtxovwofwYgjH4TSFGTu73mFwVrqObGyxYcSnKdx+RYwRvoqZu9bo8LtxeNDwnvjxW1K9LCx4nMhE49hmnq0TrLHdH7T1pYx59SKlO4pXN06dLGot1Mtlwi+2SDF+im+v/RY0gdCEP/CdZxwirqPJDifte4fwHnRgXvxmSMG3HKdVCEhAgdXZaXcdUE8reqH6V8JXr7lfNplPU5IlbT/8pE0gd93tJJ2SoFsoA8DJMIKxp0KGr6sAQBfe5uvhVy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(8676002)(4326008)(66946007)(66556008)(1076003)(478600001)(66476007)(6486002)(186003)(6666004)(52116002)(6506007)(41300700001)(2616005)(54906003)(6916009)(83380400001)(316002)(26005)(966005)(86362001)(6512007)(2906002)(38100700002)(38350700002)(36756003)(8936002)(7416002)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z0Ju6HHLKKKqtJEJKcTYy+SVVT5YZAXnZkc0Hldko4e4WfnyrWn/098uLvxB?=
 =?us-ascii?Q?NJaJEzJ6OgAEHDasZU/hHE1f/MbSM0zb1Pc4HmzKjunhqWiVyNIdHZqEBEm+?=
 =?us-ascii?Q?QrZQA3oQeZqrp+I9Y8cUHROb3ZGnq2HuR4mPC2tBXS8CAZWxB9+wzOE4zAjF?=
 =?us-ascii?Q?87BtMraPo+GYtfva8gwMkXDEMz461/rnJDpxsIIymvI3mo0Vd4dH9zwTHA4K?=
 =?us-ascii?Q?LXcaU+5CVWFolOxnoVGuQu9HTilsJcTo6uT/hyWJ/GoJG7KUX7gdHrI4zGuf?=
 =?us-ascii?Q?YfdoupBDkmrxQFrMNCGCkUL8sBf0b9mb+7j47J83wtgeWoEWW50YyUwYw4A6?=
 =?us-ascii?Q?hvOykBhl0jBmouekpphjg0esL61nXFJzr5gJraZJGaH6bsgr4YVNEqs/G1QG?=
 =?us-ascii?Q?iKHjkNyXyUvxk5CYOfO95ekPV1mmuaOg0A9R/2p46CkaojZ5mrsfEjCQVmuU?=
 =?us-ascii?Q?D0VZkbwOYq6hgQGNtG/BVYBU14Fb/ZDtZy6ZBzaUOLL+TlPWiA4QuokHtil4?=
 =?us-ascii?Q?HrjLbGNQfCaSurknLblZIY1u8Lulbitn6iybvYK2BmcDh2QO83IUx+NOLuuY?=
 =?us-ascii?Q?fxG/fq3BfRMfOeH+mSWpgYBmQiOgG47ZNkuSIXtkKkEKtZlT+Ql3/ix/3N/w?=
 =?us-ascii?Q?NC4dAutnt4dxCFlo8ZMZgn6dlIjpG3cIMKnoLfsEMjPmDxpYDCJ36C+9F77/?=
 =?us-ascii?Q?KxMaggU6fDuGOFILjaCYjOMlLO8FZiv2bWVAJOVBUbCvcQHhMw7/R2zMQbx4?=
 =?us-ascii?Q?/a3RCIgNPX/z6PlMUXksIgBhMqIgiBKegqAeEcRuhvqVni8U/hVpDk4KSU6U?=
 =?us-ascii?Q?2950qJ1mtxyf/mm4IpgkRu+d+mNeLQO/7H7ciHXiNl6wRRXPfEsyPWih/eAJ?=
 =?us-ascii?Q?ww5eOp6ECs/6TpY/+zkTF7WLKAY1eJSyOFEmdFdTQtj+gJ4YjBckz2khv0KE?=
 =?us-ascii?Q?CAC3m2zbULhtX5IkNBsLfA9DZ+4vdSudEGiUoXxLg7Uos9wlG5Ep5vQOF01q?=
 =?us-ascii?Q?QWJyZSm8PktbU4xig65Vazv+d/yvNZFNl66eMZOB/jTEEO3GQojGv366Q8pK?=
 =?us-ascii?Q?8FfY21/Jm1+2CTjZ4EK4vgId6Zuq8J8fJIhe1jaINla9TXM8fne+8h5y8iaf?=
 =?us-ascii?Q?G1QzH+xnbbxygESFiC231IBor4WN/QEekoUzsgYSoh4f9NMyfQHdSvf680/J?=
 =?us-ascii?Q?k1EYXhTTidOiqLMhphwLc6nJeqcPhXC3FrGJzZE3p5Nxb7qHsRnfZV5+0RWH?=
 =?us-ascii?Q?tD7ta8T5oBAuTIZdjZUCQvSYD4q4vgUbtdaatk7IHBgDiH0GClYrQ8wPwXmN?=
 =?us-ascii?Q?LYcuam+VZBtGnB1GBafo2/K2F4knx1rips00BXe4QdgJ7CNpt1EV9hVExV7+?=
 =?us-ascii?Q?DKXg4rcJBGUuYgK+rFknxKxflbetwwCpiPWkmsCInjbV0W4efKp3kmqdM4YO?=
 =?us-ascii?Q?isoGBiRvyGiOinTusPlOCnJps/QCwzBFhdWRcQtgan6fsfP2DgaIe/Tg7IcT?=
 =?us-ascii?Q?k8vLM2ea5P8bsiMtYaIA1mzumrNRIN35JaK8OFJoAgRetJsbR9rB3FEapHD7?=
 =?us-ascii?Q?/JG8Z7Zkb+ofS5lZ0m6uiOtU1+fam6GH93v6fk9RC+2tyDa1hInXixCQQSBe?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8c55c0f-bedc-4f56-fd53-08da5eac45e7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 17:32:02.8751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 33Ykm7q8OXyBBFFLNBw3DdoNUJUShqR4LG0vTvj+Ol91jfl94StMfymj5LIeZFCuAONbEjHp/ePt/JEtCFg4lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4251
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even though this isn't documented explicitly, we have told driver
writers on different occasions (mainly during review) that
ds->configure_vlan_while_not_filtering is an option which ideally should
not exist, is opt-in, that we should work towards deleting it, and new
drivers should not opt into it.

However, what seems to be happening is that new drivers still seem to be
able to slip through the cracks and get introduced with the VLAN
skipping legacy behavior.

Such is the case of the Microchip LAN937x, which was merged in v15,
after being taken over by Arun Ramadoss from Prasanna Vengateshan.
https://patchwork.kernel.org/project/netdevbpf/cover/20220701144652.10526-1-arun.ramadoss@microchip.com/

I had asked Prasanna to remove the deprecated option from existing KSZ
drivers:
https://patchwork.kernel.org/project/netdevbpf/patch/20210723173108.459770-11-prasanna.vengateshan@microchip.com/#24351125
and yet somehow, how we are in the situation that after Arun's KSZ
driver refactoring to use more common code, the quirks are common too,
including ds->configure_vlan_while_not_filtering being inherited by the
new LAN937x driver.

Maybe the problem was that I wasn't specific enough about what should be
done to move forward, so this patch set attempts to be a more concrete
step. I've created a selftest that captures what I believe to be the
essence of the workaround, and I'd like to ask maintainers with access
to KSZ and to GSWIP hardware to test it and to propose fixes.

Vladimir Oltean (3):
  selftests: forwarding: add a vlan_deletion test to bridge_vlan_unaware
  net: dsa: ar9331: remove ds->configure_vlan_while_not_filtering
  net: dsa: never skip VLAN configuration

 drivers/net/dsa/lantiq_gswip.c                |  2 --
 drivers/net/dsa/microchip/ksz_common.c        |  2 --
 drivers/net/dsa/qca/ar9331.c                  |  2 --
 include/net/dsa.h                             |  7 ------
 net/dsa/dsa2.c                                |  2 --
 net/dsa/dsa_priv.h                            |  1 -
 net/dsa/port.c                                | 14 -----------
 net/dsa/slave.c                               | 22 +---------------
 .../net/forwarding/bridge_vlan_unaware.sh     | 25 ++++++++++++++++---
 9 files changed, 23 insertions(+), 54 deletions(-)

-- 
2.25.1

