Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B31666031
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbjAKQSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbjAKQRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:37 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2080.outbound.protection.outlook.com [40.107.247.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1831DF10;
        Wed, 11 Jan 2023 08:17:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OluN8MMnqrnL/x1ov4vyanC2VUu9axCxVpiT3A46XCD0vlXSNEj859SFG0qz08lyqJkwwx0tU6S/cRO2WCAhRxP+nc6H5Rc9CKcVJzHUu5o5jqjLH40HycUvOdpUnJwACLJXxmSo5YEF+V7cp+m20x4IbwXzb3q8kaXzkT9JPy6jKSa8j1wEIOz1FBQcX4+ZYMU9v06SdgwXe6e4npYEtB3GqqSqznV1VC7ljeu3lPfCCn/3H7e7npZ1fs2txG92d2LQa7LoTei85MUOIId/3+0Ok3hBDkVh6A9mWsdFuf6zQ3kkbGqOT6kKS6hhEYLjUOo57/Irc6y/l40qTb/qfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyQA46oB9Nuwxm78aAlK8CAGOcobwYp/BmmaMYYxMH4=;
 b=VMZdvP+hPfkmO85kTbrI0O8NFQMBlI/rtzM8YWO2xl4YZNnzDELUMEgwNO037/+CRH6NniQThzVuxzftuwiJy/dLR2iUnqN3v1UCXJa3LvJn/01iy5FhfaICxVPPBQoTJJ80Vv3jMzCHRdFixAlpSZ/SVeobfu/7kPq9CIKomwpFrciSKwldQeTr52gjvc0WTJcbUyqcSCWXRc27OCE7OIArU/RQcX9fXS8euVJ+wwxXqja1GV9Z3/HmVYeubD9HTFgI66urxi4Uf12JRWJkqOBl2Tehp+GrcZKhf+IOjBWbjUP6iKleftAGbAlksvKaEiG4DA9Xpxm0ePM2EjNZWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyQA46oB9Nuwxm78aAlK8CAGOcobwYp/BmmaMYYxMH4=;
 b=l/z6uhjwzp5tbXQ4tLQtUtjftLP7cqN/BwFaEUhtr63xfyyvgY8XxeOZdsMWTohY1Qy0/TfxQ5famIVRmzENg9F7tssNnLsw7daXLT5frRlwgcgoJMEvvZ+It7RPRT3iG2qj9JsC7Go8L3EeTu7H1//q+E44UqeA1E6S7j1Yj9I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8462.eurprd04.prod.outlook.com (2603:10a6:10:2cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 16:17:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:17:21 +0000
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
Subject: [PATCH v2 net-next 03/12] docs: ethtool-netlink: document interface for MAC Merge layer
Date:   Wed, 11 Jan 2023 18:16:57 +0200
Message-Id: <20230111161706.1465242-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8462:EE_
X-MS-Office365-Filtering-Correlation-Id: dee1bc98-0e1a-42d5-913a-08daf3ef50fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QWrsJowkyv0jegM0DMRfXrKuPEEdFqXSrQQZcZ8pwexLGgEn+YXBsM+PsAbLFuzs3QZyjNKP+ToGToEG9QShJn5Nz2IScsV8ToRN8ILftuODUhsd5TN1ARgHpMf2IgUSSDJ6WElp3SyGGpRbdgw3cUHGyRgXKl+f52fDhW18hbvVIVeUQtkVHyEZOyWoDN4/S9wVN+sCoV7HyjsJwIP8F+lZAM2sQY3omOZKPY+AmX52Vg6kOuPFiwOVz6tvxcrfx2+0sShR+Ye28nq0HnmaNCrcy22gPHYUFIJUvtJguLS1q6a7u3O70aP7sJwjWxKglCu/0Joo5EnyD5S8CMGTjSno3vZsiIQ/mVJnoXDfND0KhvNj86FBvlJ6ps8TaHJrNeBRhLTlYQgnalddTbOJ52+x/Fzku6zYBxjVcvGW7XsVZsXBnIW1Cbo1WJkeHXqUnGGV8DVugrGsjSn5CLbTk01z+1C3r9gLR309VjrPVfxJPTij4LBG1q9INYRcMlGe8o+aGbV/ossq9SqJvuHnWT9XonQVEbrWTACqHwEz1tV+IPLkN6Ty9LoIBtVAWyrs7xO88k6oPc7HjVgzsBqdWOyJABwhD47pneSnvrpGN3afnK6EJVwDtUfg3ag6Sm+hhcTE+7SACyPZGPwJI+TgD3KUb+2tadv+E+AzTKy2ZPGo0yXWIQM8npdhT0oOfaza
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(36756003)(26005)(186003)(8936002)(6666004)(6512007)(6486002)(6506007)(1076003)(2616005)(66946007)(5660300002)(66476007)(66556008)(52116002)(7416002)(6916009)(316002)(4326008)(86362001)(41300700001)(38100700002)(38350700002)(478600001)(54906003)(8676002)(83380400001)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B7TbzZXX8smKVmcg0rQzADLtIuIITpUKKZLeNcrswxI9+BON4F/0Qdxvh+RZ?=
 =?us-ascii?Q?lO4rRT5iCNIVWyNrqgK4AlDs43OqIPEZjdsPCrNSwJBRY3SvcgEBKtCTWrLP?=
 =?us-ascii?Q?U4aP20oUltRoXwxxgj+GezgK9ZKWKRWscfxODKlaitb6y3GJEborSAvXrlwR?=
 =?us-ascii?Q?7zBj7vNz8Rw11tGaeHsS2LCqsmQ3eOx8zhppVPalnVnAd91eLyhex+eMxT7K?=
 =?us-ascii?Q?WC03QaiBHa2D/kjK/+bE2WrMunWzcueGDqFoRhrSa4CxEnJ26qvhdNjXccSG?=
 =?us-ascii?Q?RxfLMSz4HKlyKL7nb5LgZXwl3qFn997PpJFhjIgT1u7iQfbvjf/Pyy7CekBF?=
 =?us-ascii?Q?kqPZ8+FBpH3V/Hahci9ONywnQYKCBOLaoMxAudARTqQWQBBYnn/U9A9Z9m1z?=
 =?us-ascii?Q?TVzkuMyVgXuySf+05mIPgIAXKuQ2CqlsDOwBdAg8gEhFrSeJVMVvvxWKHTaX?=
 =?us-ascii?Q?sZqsstVRdFKElVnCDUEwaDl++AG8gMfpHWe1iqO5OCUkiZ3WEr0OilKtBx69?=
 =?us-ascii?Q?wx5vgzLnVTALCh2g7P4Dk99MrbaAnN9TIKPAYH5sRWLO1nvQFpgduukLG7iR?=
 =?us-ascii?Q?9ji4VP/5QnvNc0wdaKoJ5bmf+S5HselJpkVXoIZ4dMJ1ZjUaGTq2nfXWBubW?=
 =?us-ascii?Q?YRtOMn0+U6qRPvBKju1YApi9W6AxrdnadFH2Gk/SAezTVD5VLurHBmF0+V4C?=
 =?us-ascii?Q?vsqKsZKV95uVkRLpfJB7IqVBSHRPl/D+gtKKDeRweprx3lHZcgH43Ydy8hVd?=
 =?us-ascii?Q?DzTavSjjuE5wDzbSEA3T0JBDAN6d8o4k6xuUF6M0y6Qwz0OoyskF1wDpNB2L?=
 =?us-ascii?Q?H48bs8W47mOp1PK3ql0JlCbKaJWVhjn2+XBiY82GKbR5zlXpK41umRKSuBo0?=
 =?us-ascii?Q?40WhLJBpm+RT0YwG9cxoIx+wbaPyttIGoDGRCfS0732d7vbb9NbjMjHGpFzp?=
 =?us-ascii?Q?BNEFXjmfPlGRNh6yzkLw0g+4nBwGzZDNaDkAuUXQ7nxcSSrrcYXS0HgiT1oB?=
 =?us-ascii?Q?t1H1YtjiAvPT73LI3TJsaex355uwSOAn07wuJAHASEWQZTa7roPdQ7CzTRlD?=
 =?us-ascii?Q?4M9INc9Xw/9hSc18UPCITasKmC7YLw3Roj/zyykkedwqCOn8s0gTFtTzS7PS?=
 =?us-ascii?Q?nKUSj/XlmmRp7sgKEB2OHa2HacWW4O2BBrQ3o4VXuDk37r4x7DWACA0mqA52?=
 =?us-ascii?Q?Zl2Bw9YtGicWPHtsFFG5uUY13SMaZE489rp+dod/8ziZtV/A6pXoXhZcsnZc?=
 =?us-ascii?Q?w7s6KzUj+uIOjCM1cT0SijM8SeWKNfj0m4os1TqHcmQqnya/I8qrnYSfAHJz?=
 =?us-ascii?Q?ZIWgiRhaUGjX2oO3RGvQvDikL6F8K3ISOLTn+pxMftH/idpxnIvR+r+2dE8s?=
 =?us-ascii?Q?ob02Bn3oMQoJj3d6lruHJJg0RTEILg/nEAXuEk76sloRpfRJgjGjZHa33vpo?=
 =?us-ascii?Q?sX5PjHa0GKhoLS+7VddoVaHrKpNBZSOQxBKqxd/AuRY62VnoU0TrSIPFvegB?=
 =?us-ascii?Q?xg7Pg5RoTscg71svbikBIZ5wFBHKD3TY/xWzZyPKTdWD3YlITgkAKQ4y9Vul?=
 =?us-ascii?Q?3iW/8YClf7whG1IG26S+bepT/+P0gR1L72iV2hzuZ/FgRD7jqorNq9j7jQaK?=
 =?us-ascii?Q?4w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dee1bc98-0e1a-42d5-913a-08daf3ef50fa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:17:21.0021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b4VAPOkfEwACYs7v+jmnzhtSU0HB345gJ3BBgASMOvvkwHBWEqRGZaunYKuBiap6MOxcRiDw6wfE4CDwHTwoTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8462
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
v1->v2: patch is new

 Documentation/networking/ethtool-netlink.rst | 103 +++++++++++++++++++
 Documentation/networking/statistics.rst      |   1 +
 2 files changed, 104 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index f10f8eb44255..490c2280ce4f 100644
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
@@ -1716,6 +1719,104 @@ being used. Current supported options are toeplitz, xor or crc32.
 ETHTOOL_A_RSS_INDIR attribute returns RSS indrection table where each byte
 indicates queue number.
 
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
+  ================================  ======  ===================================
+  ``ETHTOOL_A_MM_HEADER``           Nested  request header
+
+  ``ETHTOOL_A_MM_SUPPORTED``        Bool    set if device supports the MM layer
+
+  ``ETHTOOL_A_MM_PMAC_ENABLED``     Bool    set if RX of preemptible and SMD-V
+                                            frames is enabled
+
+  ``ETHTOOL_A_MM_TX_ENABLED``       Bool    set if TX of preemptible frames is
+                                            administratively enabled (might be
+                                            inactive if verification failed)
+
+  ``ETHTOOL_A_MM_TX_ACTIVE``        Bool    set if TX of preemptible frames is
+                                            operationally enabled
+
+  ``ETHTOOL_A_MM_ADD_FRAG_SIZE``    U32     minimum size of transmitted
+                                            non-final fragments, in octets
+
+  ``ETHTOOL_A_MM_VERIFY_ENABLED``   Bool    set if TX of SMD-V frames is
+                                            administratively enabled (TX will
+                                            not take place when port is not up)
+
+  ``ETHTOOL_A_MM_VERIFY_STATUS``    U8      state of the Verify function
+
+  ``ETHTOOL_A_MM_VERIFY_TIME``      U32     delay between verification attempts
+
+  ``ETHTOOL_A_MM_MAX_VERIFY_TIME``  U32     maximum interval supported by
+                                            device
+
+  ``ETHTOOL_A_MM_STATS``            Nested  IEEE 802.3-2018 subclause 30.14.1
+                                            oMACMergeEntity statistics counters
+
+  ================================  ======  ===================================
+
+If ``ETHTOOL_A_MM_SUPPORTED`` is reported as false, the other netlink
+attributes will be absent.
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
+  ======================================  ======  ==========================
+  ``ETHTOOL_A_MM_VERIFY_TIME``            u32     see MM_GET description
+  ``ETHTOOL_A_MM_VERIFY_ENABLED``         bool    see MM_GET description
+  ``ETHTOOL_A_MM_TX_ENABLED``             bool    see MM_GET description
+  ``ETHTOOL_A_MM_PMAC_ENABLED``           bool    see MM_GET description
+  ``ETHTOOL_A_MM_ADD_FRAG_SIZE``          u32     see MM_GET description
+  ======================================  ======  ==========================
+
+The attributes are propagated to the driver through the following structure:
+
+.. kernel-doc:: include/linux/ethtool.h
+    :identifiers: ethtool_mm_cfg
+
 Request translation
 ===================
 
@@ -1817,4 +1918,6 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_PHC_VCLOCKS_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_GET``
   n/a                                 ``ETHTOOL_MSG_MODULE_SET``
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

