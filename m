Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF06673869
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjASM2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjASM15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:27:57 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2048.outbound.protection.outlook.com [40.107.22.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF5A30F6;
        Thu, 19 Jan 2023 04:27:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emq5pwh5p8HxxfREvf2+tnsecM6hDCpLLrvAlNm1xX4XwlHz7mYUOXQR/3hd7p39kCjI/fUNfvIuvlpXMRwtqwlb0KJcXerDVy8pXohrJH24tpqU7+gEZ96mt3Fl04gjU6xxblVoWni4NUPcTG/jHhp6Ie3p6nXAUYr7oFIvENNJRyVX/OXT4/4CCiyjzmPazhMz6PfTvzYRuvfFkUxqqIkGh+MD3mFqTEs9bRekPTSdu61lYbNWC/zPAeE+X5bzJ17Ev9Lo7AK9Xlbd2Ixlqx+x/xXluCCn02kh3vpUk6h6nKgb9BfbedSNuAmwfcGUu+lvI+Clih3U2EhsDeSiMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EmwtzsimrUpAYTUJuD7a8JjWi88RitxXhPAn9lcrmwo=;
 b=KZHHKKmKyh3x7vqyEDNHhNUvTcALrQUi3kkLLM13+dCHau9MzdVMoWMNBo4i6g5oIL6sC7Ixzzlz30bDDWnUKr7zfrTiO7amQO8ycwiu/7CtAZ7emRoccREF1qG6Fzw/W+abuHGbC/DxRlrf+ygACgq8R7edF6xtE/wbIl7s6ILcuspIwkGoVDjjNgXgDqoXSzGmg5c4DS7eshuSR4AhpMwLDYnG8qYerQNNOHZ2T2L2sPYIBYQDSTLb9fYQMo0FGiDLJWca1nPYXLAIaKfdo0NkieFVBaLKFeW1fN1bsMcaa4/gbEzcagtkuJ+MtVW1cL/1/vP64b9nXzu8ScSSng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmwtzsimrUpAYTUJuD7a8JjWi88RitxXhPAn9lcrmwo=;
 b=Ufl5jHbelljaGFxaKCPrNMJQxZ/xwx3h0Kh3sMlKafnLfl6OLWoi/QpfWGN6Vz+cx/vlvoUtqCk3KnjGYHWkeTkpo/Ib2qQC2qJWMs4T/QdAmpV/QjcXdxlhIcOLrFrzRwLSkZ9JfuNeIfKKvgwe80E/gGvp82IFOyicj5GlDZ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8206.eurprd04.prod.outlook.com (2603:10a6:102:1cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 12:27:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 12:27:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v4 net-next 05/12] docs: ethtool: document ETHTOOL_A_STATS_SRC and ETHTOOL_A_PAUSE_STATS_SRC
Date:   Thu, 19 Jan 2023 14:26:57 +0200
Message-Id: <20230119122705.73054-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119122705.73054-1-vladimir.oltean@nxp.com>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8206:EE_
X-MS-Office365-Filtering-Correlation-Id: 47cc8fe3-4b82-40c2-329d-08dafa18938c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2d960woHa8e0r+gkvkUJ9dOUgRvtMzmSu6n+b5+kTu6CKGRV6q14kpkNaoplf6htpuKuxWKcnOJgbj5NJlfhuZD/j9r0YeChIn/M9+pdkDMULeZLiU1t/Si2FESKEaICqqaIX7becup67XigZQptTuehnKzeSykVUhbj8HqhCO++FObPXujZk/k7oDcFkQvfELLeNvr7lIbKFwE/hVYaexLssbMe3Sntt7rxDTJbii4yyIn3iFq1SOCEngfvnQs4PCs9wsKBQmR9h9IO2XLtqNIY1wEePwfT76W2aEx90eebiDoqbASBs9VF7rbGqsW2xKjZBAwIz8tmYu3G2s7n8MNnk4Rh0jIr2gtMpEdZR+8664ZjghFafW9V8hyQoHbFz8DAfNxEjFzSJSApQSdBl/v9kxE1Ok7BJi8gHrl49+h6GVBnBSkY237oKGO26Y9PvHKrFpaRo22a7n69qrm6SBgRP4qWB51M+O9vnqWfT5J/Op5rHVY8lWAltujavM9YupfR6mHS0wTExbtKoaOtGZ1p9Pr/hMyKD+yYha7FehiqcZwryiGKgLXJaQjGTBH0hzG1S4fO1Quw0pB8qTPiywJHq64XswW7hZuHxB0bZvT5sxHTF7UXtlkEqD44v3dLK0F88bcctLvh/ILPVmpTN1MhLAufNTPwCh70b8ELl5MRXCjMgOB0uMuyFHf0v9UWxmTo5Onq1mfCy0V4uTlcSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199015)(6506007)(86362001)(44832011)(66556008)(7416002)(5660300002)(8936002)(2906002)(66476007)(66946007)(38350700002)(38100700002)(316002)(19627235002)(6666004)(52116002)(54906003)(4326008)(36756003)(478600001)(6486002)(6916009)(41300700001)(8676002)(186003)(1076003)(6512007)(83380400001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QcB/IxpckiZ9hUavNYQ9yJuOEWHRSeb+rsY+wim3+W44AqxdQrb72hDx9+sF?=
 =?us-ascii?Q?uapIweudQemnE9MJPVT44Usa936xxBwHO/kPeYnYp/1GoPSpmgPtlPdICciS?=
 =?us-ascii?Q?y9bIlCOLjN2oZ2ifv9DYN3Xz3+DbClpZpyMHE9qFxEiSsTzOTy+0BAX5+fWN?=
 =?us-ascii?Q?buykXD9/DWEj+T8qAED7kWgBBb/EJGtdwYfb6tEt6dAsz+RO1nU2m1azCGXs?=
 =?us-ascii?Q?0csy/uji1IEnFICpVoDLEHDPslkPX+SDngqfiZXonI/NlvpsdzblMGksCzrl?=
 =?us-ascii?Q?bIAFTv9vIejH5oWApSVnJV0cZi2O+2gbNyY2RuMpg7Vo3b2nZR2Q524xDEk4?=
 =?us-ascii?Q?RvJoi+3cNQLuPo/VLRs6wUpfEIXw/GOjHrzaYYGpPlsusblqCEmlOdKmhHst?=
 =?us-ascii?Q?IKSRe22lL8HFoxIUP9Dh6/E3MUZVmevB7VniOwo1PoV5nRvX3r8jqxz6gOeu?=
 =?us-ascii?Q?uOU8/oBAbG7v3NdqUiJxOK1hyPUzjMKMeKYBN3zYVQWUnreA7g47pWbwdm/6?=
 =?us-ascii?Q?xvrQ83AOl2F4zXIAz5zTcaiy5HMHpzyzCX9zD6OW1rZ8ELfp3JOS/+HS5KAz?=
 =?us-ascii?Q?MhxunHzITJSRS7il8v+3gkiGxNZBWWyI1PJWg6MDiH6PxYBRB/TNm4ORZwnC?=
 =?us-ascii?Q?0G2JPTxrXlb5qYCgLurgNP54duyluuO1CX67CVDe01FwJ7GRlqwLBZTf5vnZ?=
 =?us-ascii?Q?2WZX89Wm9JTY9TaagrVFaNi0Fsf/V+VfSyyD2IztcW349ysoWOEp4WEfu4h9?=
 =?us-ascii?Q?jgzmXPfT6ygmA8O+XWF4nxVsPFbcx5rAD5dPFzRSuNVM2mKVa3D6Ri9FUenj?=
 =?us-ascii?Q?8eTdevRJnpiSQiMMBZLNVWtGFXiMq1TUUlL3zviCavHxi8LZp1Cbd7P1PM/w?=
 =?us-ascii?Q?7wleImmGMU9T7sLVo+PmXFpq+qmD6NnVC+t2Uw4vGBeNSYljaEvAhpUZs5Mm?=
 =?us-ascii?Q?ZNasvsS9nhNZZr45t8wSD7pMkyQy2Tq05MVaxiKXy813EuBUxnz9wlSLolQd?=
 =?us-ascii?Q?Zkkzkx3Ktpzzx7llzIgWa+IN59Hh3B41aaqw1aqrwlax6zeUOdw83zunkW2z?=
 =?us-ascii?Q?yzdZ5ghGeQph8ngcdHrpx42U1j84fAPPCcQqozxeSUBR5w6BTWfqtZPVyfMH?=
 =?us-ascii?Q?iOjwnVUdaPzhhadpjElmTYRnlK4wM8+EH/+HOdmqo1xir0kU/u8pBBCwAblB?=
 =?us-ascii?Q?nrnuxFTW1xCH4X3UstKgo82gMXHHWi3ZFg8jeHesp+L/jkzSRGxYRFgmAH/k?=
 =?us-ascii?Q?UMhgT+HlIuqlz7ydyOogjiDYLFl4l+jRWwW9/KAmjBgxUqtZAudpbVIusOFJ?=
 =?us-ascii?Q?wAAVZRxrEnJjaTdSEozmdMYwE0SzX9iiNKL3SUQvnyfS7yiSogK72FgJztEo?=
 =?us-ascii?Q?iOkiyMYV9rhlawaqV185cdoMh6qyx9BOcXXg+PPaljCCYmvFgJrp4ynR1lo+?=
 =?us-ascii?Q?xyqLOzvUiBJuFUR4+HCwNYs6ld9Lm4cfsaJ9hKS5ce9E1DKNFit+LeOMeAL/?=
 =?us-ascii?Q?qCkuuFOR+xR9BKxmdPqULFb4RD6iB1VOtaSZLacN8WI3ir8xjwU0ySowjlg0?=
 =?us-ascii?Q?L9ZTj+KvXrtTPunZWBuHf9MjSOnPKq3Ro9mkHp4SJ8GO8c03LzzL0//+IoZ2?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47cc8fe3-4b82-40c2-329d-08dafa18938c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:27:49.0912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mODGoi8VR6w4PUokAAQ0sH8YDgnB2HIoh8UXdClIGqhptY6SAXiGJ2EGg/ZlVrjN/CUyqRSD0Abqv18m82XWXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8206
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two new netlink attributes were added to PAUSE_GET and STATS_GET and
their replies. Document them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4: none
v2->v3:
- adapt to renaming of constants
- add a single kernel-doc reference to enum ethtool_mac_stats_src
  (second one gives warning apparently)
v1->v2: patch is new

 Documentation/networking/ethtool-netlink.rst | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 31413535dce5..1626e863eec9 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1092,8 +1092,18 @@ Request contents:
 
   =====================================  ======  ==========================
   ``ETHTOOL_A_PAUSE_HEADER``             nested  request header
+  ``ETHTOOL_A_PAUSE_STATS_SRC``          u32     source of statistics
   =====================================  ======  ==========================
 
+``ETHTOOL_A_PAUSE_STATS_SRC`` is optional. It takes values from:
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_mac_stats_src
+
+If absent from the request, stats will be provided with
+an ``ETHTOOL_A_PAUSE_STATS_SRC`` attribute in the response equal to
+``ETHTOOL_MAC_STATS_SRC_AGGREGATE``.
+
 Kernel response contents:
 
   =====================================  ======  ==========================
@@ -1508,6 +1518,7 @@ Request contents:
 
   =======================================  ======  ==========================
   ``ETHTOOL_A_STATS_HEADER``               nested  request header
+  ``ETHTOOL_A_STATS_SRC``                  u32     source of statistics
   ``ETHTOOL_A_STATS_GROUPS``               bitset  requested groups of stats
   =======================================  ======  ==========================
 
@@ -1516,6 +1527,8 @@ Kernel response contents:
  +-----------------------------------+--------+--------------------------------+
  | ``ETHTOOL_A_STATS_HEADER``        | nested | reply header                   |
  +-----------------------------------+--------+--------------------------------+
+ | ``ETHTOOL_A_STATS_SRC``           | u32    | source of statistics           |
+ +-----------------------------------+--------+--------------------------------+
  | ``ETHTOOL_A_STATS_GRP``           | nested | one or more group of stats     |
  +-+---------------------------------+--------+--------------------------------+
  | | ``ETHTOOL_A_STATS_GRP_ID``      | u32    | group ID - ``ETHTOOL_STATS_*`` |
@@ -1577,6 +1590,11 @@ Low and high bounds are inclusive, for example:
  etherStatsPkts512to1023Octets 512  1023
  ============================= ==== ====
 
+``ETHTOOL_A_STATS_SRC`` is optional. Similar to ``PAUSE_GET``, it takes values
+from ``enum ethtool_mac_stats_src``. If absent from the request, stats will be
+provided with an ``ETHTOOL_A_STATS_SRC`` attribute in the response equal to
+``ETHTOOL_MAC_STATS_SRC_AGGREGATE``.
+
 PHC_VCLOCKS_GET
 ===============
 
-- 
2.34.1

