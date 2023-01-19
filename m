Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16E9673868
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjASM2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjASM15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:27:57 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2079.outbound.protection.outlook.com [40.107.14.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D801BE7;
        Thu, 19 Jan 2023 04:27:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMQCE4O4K3A8FW17opQEeYO0tfuQO+NqFUHKyYF7gPU2mDlTiM1OMbQbzPcNMcbtCn7aKNClY7xAxILW9f6Y+PCqnzzlymWFl4gTC9lRIT8+NVPm0oXiNDMUPj0cal1CHH0uUue1FkBioMM/NOmOElYL8RNF2UDtbXXBm6Y7shf8bPt9b320vxrItdQZGVmspRiEtV0jVgDp7keWAuR5sdKjnx1ZUd5evHvQoQtnU8uE6OLroI4MJwnctmfuoFoJQDBXNVK7M8k4hWPYiM+WBFjPO1jxY5/LeyTsPXbkAVLuz+/rQ9dRS965ywB6OkXWY50wWsOXHQsXdHILrzLPag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NxZXkwtN/X96R3TMw9KkdVjlgbAtG4c9L0u/i8kgzRM=;
 b=I7K+Q3F642eXt7TTPjS0zdewa5LkuZCJOldEEMv5qzNuxQZ62o3UPuu7A/n7iDBsZ5D/cXpLK4TaYnH+5eNFnhTmJEa2f/3Xonsob/aFC/tPPtZDRc2eqfW83WsbZcyVd33SRnRh/2Rs1JTVqbNDJE3+zD95xLo4bkaUdhojmvM3bvSJwF6O3NNQ0kwhXjHSSu1gjQjoEpZcTbd0Oc/fbP7JOcXM7/q2qJZzRUbfTB6LOXzI68z9FtJYf9rB/VoEtvDT6JchAMMIRHW5RTQ+Y+iZlIRfNCnKlAMeRiHm1fpm9iBtpFAa7IUjC2lkzXMFYA+b5UN+1vag9mWaadUnSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxZXkwtN/X96R3TMw9KkdVjlgbAtG4c9L0u/i8kgzRM=;
 b=MOg8DsPxZYmW2l5QkZOyu4U2Z1SfsmmmXIYIcHtgWFvoOUpgkXP1R9kXWrpQf6uShPNOdUgga0b4OewlPadaWMJ1STCoEeb1xm54GL6g/MzvlGqrNR/MY04RGP9jaqzSnI78WRae9K3VxOR+Dp9SUj2flGGFag+vk3SQnUDyH3Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9376.eurprd04.prod.outlook.com (2603:10a6:102:2b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 12:27:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 12:27:45 +0000
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
Subject: [PATCH v4 net-next 03/12] docs: ethtool-netlink: document interface for MAC Merge layer
Date:   Thu, 19 Jan 2023 14:26:55 +0200
Message-Id: <20230119122705.73054-4-vladimir.oltean@nxp.com>
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
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9376:EE_
X-MS-Office365-Filtering-Correlation-Id: f620746b-f85d-42ca-aa41-08dafa18910f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u/DcpD0cFddEfSRRndlbtZ/biux/FkUe1aNcqK15c22omi1XvsZXanh4xhZS5G8dAk0/J6rvIWEEDhOuEQSiICQmF6AunbFWItR4t+uXOfwcnpkRD+JRdUtgMd91ZXBnKX7rS7RPVGcGtGuTaInaY7PK15DFpWM3mU/VVOHm2XCzFwVkMYh2TRgSky2ZjPCMCWUtAB9lSa62DSwKJmLUg9XR7o2s8d3L4DYLkRMGtcnSolwZ6EGMDAnF12mrg2xRQfYDuz3RnZhOTnAtD/f6OeuU+wK6yb4FcC+iNiJJqQHsxxgKtr32f7zyZTrNK/baTwg6ipxrUNEknN3YRngwkccfRjOEYepDzxX4/nSRgDxeSgguVFjuSBpFeS+wGHGEKiGlZjjSxlIhkr9ackj2T53QBeyZRQN+WP3qymEoLwWxV/C8tI/YA5WPHq23irlL/Mg4ldjP1URE3ARrrrkyTjvyUO5Aw91vFgUo0z2Amry6xvYN2rAG4JfOmKjEQO8By4Y0o5H9EIHOI0bFhGmz7g4HX0ObVR0gvXN8J426nDFbU90144cEmfad3/upXi43mbik91QekmhooPDbM4uGAwy6LBeQisKkou40jD/D2Twci1G4cVWzpaHZhgu1hrUtS5XUtDkr1/Xji2jtozrKFm2NxnDlyxHSLDGglStBba9ZDCkTYvFf/K5Q0Ag79G3iJOmgpUxkIlE8DANxp0bZXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(6506007)(66946007)(66476007)(44832011)(66556008)(7416002)(8936002)(5660300002)(2906002)(38350700002)(38100700002)(316002)(6666004)(54906003)(52116002)(86362001)(36756003)(4326008)(6486002)(478600001)(6916009)(41300700001)(8676002)(26005)(1076003)(6512007)(186003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p4t/hMFblKtxqPTp3yyJ+tY3qfL2A5QkwBY+WLvPfevxeu8sC+qmQ2rHduSP?=
 =?us-ascii?Q?J4rig7iC9djTaLlCyzm3uN3rGXanMJ2JOJLboVIvrENSEJrJO+gzMU7KghK9?=
 =?us-ascii?Q?BePtwkJK4ngaPc8G3QyNQtT0PuiYOHoadgM9Kqvex+/ANpbJkHb4Kfks3kst?=
 =?us-ascii?Q?yIQEq2GdOMD4HECiLsv3SRAyssmUzJpdQEKU8QPVcEhDblCC9mWB3iUVE6BW?=
 =?us-ascii?Q?Onc4LmWWDt9CwaH7KIMmxYqviXlMjlQcDJDY77Xl1tf+QcFE/H6AU6GfRm6a?=
 =?us-ascii?Q?GbbCUnDp0wB1TmeJwPLpJZkgVzFSn0zQfriHCOk8e/7epmhgk6cXAT7Ip4gk?=
 =?us-ascii?Q?ynLhs+k2K+/P0Eg/HwHXY5iZ7hSYtOrvFD+eYsDQJTdlrWLmIadH3oKziFxE?=
 =?us-ascii?Q?wXnI5+weuTByIBVgFjF2nrD7E/PjlYoZAzzKVesQX8Qhq2emx5otdxctlbpp?=
 =?us-ascii?Q?Wd2tanPsbRnwNrz2Cm59kOi/INt20orBnAKVjSN1HM/IvZ3Wai01PL2dnTTD?=
 =?us-ascii?Q?7nWT01yztfxS/c3wl55daIXgvGGaPNXgctj3CrsJ8CwI1Url92DOrcgD1tuq?=
 =?us-ascii?Q?elMpsTpW/1o3NGWPCwa1tmSKo87WUM4FM/XV53+rEKXOaPlSlNWAWN29p857?=
 =?us-ascii?Q?JAkQf9UaKdlM/13Q6egd16baOQ8oybvltU+DkqcUtIKExu8Ho/11s87pxTg7?=
 =?us-ascii?Q?3BrIDRfdFtH9fYVe15yQOjHG9sBkELDBeZvjFRn42X72XMQkLCR8cj31uL5O?=
 =?us-ascii?Q?C5GbGjY93vtSXE56O59KL8KkmBYmq5vmB86J/bKzMgWS8gDzyKDk0z1j44Tq?=
 =?us-ascii?Q?+j7SKbZhteK3J145MY4N3vksC8nWyUoHCeZi8QDi209r3XAhDQn2IA5TSOdP?=
 =?us-ascii?Q?UMDvqL/YoP4i1TXDcNY62Plq6ov3gn8hoU9L4t1nOxQR6OjGLGW2PvBncN5/?=
 =?us-ascii?Q?P1C9lCGdDbjfHAO88uiQ8VvlU3mvBp9YEqD6LvQa3/uN++K3rFXWnel153CC?=
 =?us-ascii?Q?odk1N5HCzNxx7CTdhrAtzdvxF7fYDorDtlIcrk0bllXBolu05VhQLffW6rNr?=
 =?us-ascii?Q?iYCyguR7agXdw6gPZLbyklB3bQchK4BXZ6EFrAiG2mlLsoXy9lf23MMaJrAl?=
 =?us-ascii?Q?q2Rf/RzVhvP+WTB6Z+3SCtclWDd9rfQ8mxMcoPrQnQn89wQTXAElH56G+f8m?=
 =?us-ascii?Q?dzahnI9YJcSa+hyryTAwDDnDUHZ/1Wv77CjYEqs+gOtbzqQi5/7eWpIh83tu?=
 =?us-ascii?Q?VVlHLeGlHwMHLpBHFYoc5w2QjFAArtJhrQhN8NBG2QFVa29yBiZR1huZmr0s?=
 =?us-ascii?Q?N9pHLG7hfRVcuAbVJjoiAF6nMOhaADHQlFJM4r3SdTmX9eGdSV6nqRziUeE+?=
 =?us-ascii?Q?x5lb23Do2CjDWWcN5LacXle4WPG1vtBPItisC3dBojiJonjgfZT3cy7ECIvK?=
 =?us-ascii?Q?POxo6Zwm+4VBaNyOoMe69Ndxk7Cv3RbfxCmtNSh4Stf9BJ5xpcWWLi/wUvTv?=
 =?us-ascii?Q?dlASlQJNwZYd/ibwnTTvOMDFgox/QkydajitamVRyqPAPXgc8VbMVCVWyKvh?=
 =?us-ascii?Q?+eKjVHTBbTIdtM7yhgc8b+otghDQddFbwWMDWALxRI6GJXgGzx7yeDUgyP+S?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f620746b-f85d-42ca-aa41-08dafa18910f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:27:44.8884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/cMz6HcywOEQVB0JHx0UXfJR9NU17iZM18kdD2PKcbD4QAnCfncmg42V4Ds6kq45T4muupRATxfT8GucdI++w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9376
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Show details about the structures passed back and forth related to MAC
Merge layer configuration, state and statistics. The rendered htmldocs
will be much more verbose due to the kerneldoc references.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4: none
v2->v3:
- reformat tables
- delete obsolete netlink attributes and document new ones
v1->v2: patch is new

 Documentation/networking/ethtool-netlink.rst | 89 ++++++++++++++++++++
 Documentation/networking/statistics.rst      |  1 +
 2 files changed, 90 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d345f5df248e..31413535dce5 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -223,6 +223,8 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PSE_SET``               set PSE parameters
   ``ETHTOOL_MSG_PSE_GET``               get PSE parameters
   ``ETHTOOL_MSG_RSS_GET``               get RSS settings
+  ``ETHTOOL_MSG_MM_GET``                get MAC merge layer state
+  ``ETHTOOL_MSG_MM_SET``                set MAC merge layer parameters
   ===================================== =================================
 
 Kernel to userspace:
@@ -265,6 +267,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
   ``ETHTOOL_MSG_PSE_GET_REPLY``            PSE parameters
   ``ETHTOOL_MSG_RSS_GET_REPLY``            RSS settings
+  ``ETHTOOL_MSG_MM_GET_REPLY``             MAC merge layer status
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1868,6 +1871,90 @@ When set, the ``ETHTOOL_A_PLCA_STATUS`` attribute indicates whether the node is
 detecting the presence of the BEACON on the network. This flag is
 corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.2 aPLCAStatus.
 
+MM_GET
+======
+
+Retrieve 802.3 MAC Merge parameters.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_MM_HEADER``               nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  =================================  ======  ===================================
+  ``ETHTOOL_A_MM_HEADER``            nested  request header
+  ``ETHTOOL_A_MM_PMAC_ENABLED``      bool    set if RX of preemptible and SMD-V
+                                             frames is enabled
+  ``ETHTOOL_A_MM_TX_ENABLED``        bool    set if TX of preemptible frames is
+                                             administratively enabled (might be
+                                             inactive if verification failed)
+  ``ETHTOOL_A_MM_TX_ACTIVE``         bool    set if TX of preemptible frames is
+                                             operationally enabled
+  ``ETHTOOL_A_MM_TX_MIN_FRAG_SIZE``  u32     minimum size of transmitted
+                                             non-final fragments, in octets
+  ``ETHTOOL_A_MM_RX_MIN_FRAG_SIZE``  u32     minimum size of received non-final
+                                             fragments, in octets
+  ``ETHTOOL_A_MM_VERIFY_ENABLED``    bool    set if TX of SMD-V frames is
+                                             administratively enabled
+  ``ETHTOOL_A_MM_VERIFY_STATUS``     u8      state of the verification function
+  ``ETHTOOL_A_MM_VERIFY_TIME``       u32     delay between verification attempts
+  ``ETHTOOL_A_MM_MAX_VERIFY_TIME```  u32     maximum verification interval
+                                             supported by device
+  ``ETHTOOL_A_MM_STATS``             nested  IEEE 802.3-2018 subclause 30.14.1
+                                             oMACMergeEntity statistics counters
+  =================================  ======  ===================================
+
+The attributes are populated by the device driver through the following
+structure:
+
+.. kernel-doc:: include/linux/ethtool.h
+    :identifiers: ethtool_mm_state
+
+The ``ETHTOOL_A_MM_VERIFY_STATUS`` will report one of the values from
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_mm_verify_status
+
+If ``ETHTOOL_A_MM_VERIFY_ENABLED`` was passed as false in the ``MM_SET``
+command, ``ETHTOOL_A_MM_VERIFY_STATUS`` will report either
+``ETHTOOL_MM_VERIFY_STATUS_INITIAL`` or ``ETHTOOL_MM_VERIFY_STATUS_DISABLED``,
+otherwise it should report one of the other states.
+
+It is recommended that drivers start with the pMAC disabled, and enable it upon
+user space request. It is also recommended that user space does not depend upon
+the default values from ``ETHTOOL_MSG_MM_GET`` requests.
+
+``ETHTOOL_A_MM_STATS`` are reported if ``ETHTOOL_FLAG_STATS`` was set in
+``ETHTOOL_A_HEADER_FLAGS``. The attribute will be empty if driver did not
+report any statistics. Drivers fill in the statistics in the following
+structure:
+
+.. kernel-doc:: include/linux/ethtool.h
+    :identifiers: ethtool_mm_stats
+
+MM_SET
+======
+
+Modifies the configuration of the 802.3 MAC Merge layer.
+
+Request contents:
+
+  =================================  ======  ==========================
+  ``ETHTOOL_A_MM_VERIFY_TIME``       u32     see MM_GET description
+  ``ETHTOOL_A_MM_VERIFY_ENABLED``    bool    see MM_GET description
+  ``ETHTOOL_A_MM_TX_ENABLED``        bool    see MM_GET description
+  ``ETHTOOL_A_MM_PMAC_ENABLED``      bool    see MM_GET description
+  ``ETHTOOL_A_MM_TX_MIN_FRAG_SIZE``  u32     see MM_GET description
+  =================================  ======  ==========================
+
+The attributes are propagated to the driver through the following structure:
+
+.. kernel-doc:: include/linux/ethtool.h
+    :identifiers: ethtool_mm_cfg
+
 Request translation
 ===================
 
@@ -1972,4 +2059,6 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_PLCA_GET_CFG``
   n/a                                 ``ETHTOOL_MSG_PLCA_SET_CFG``
   n/a                                 ``ETHTOOL_MSG_PLCA_GET_STATUS``
+  n/a                                 ``ETHTOOL_MSG_MM_GET``
+  n/a                                 ``ETHTOOL_MSG_MM_SET``
   =================================== =====================================
diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
index c9aeb70dafa2..551b3cc29a41 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -171,6 +171,7 @@ statistics are supported in the following commands:
 
   - `ETHTOOL_MSG_PAUSE_GET`
   - `ETHTOOL_MSG_FEC_GET`
+  - `ETHTOOL_MSG_MM_GET`
 
 debugfs
 -------
-- 
2.34.1

