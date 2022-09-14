Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E97C5B8BF3
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiINPeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiINPdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:33:49 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2084.outbound.protection.outlook.com [40.107.22.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EDC48CAB;
        Wed, 14 Sep 2022 08:33:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCLrEMoYAqaMfuy/4SjiXc7RyKWKqBEp7gBp6sJARovPyH687fmeZWFdZ45bVXG6atREm/dSJtU/fxdlyRXDIUzE+2Fxt9wO8W35/txEQwHNJGbdbo7I/Znk+SnmMSE0TbhXwrSvHzfE84shsaH1L59SD6y5DFhGkOPm3Pb81CN6BAtYCd7c2ZPJw1w6AcdvydACGhCUrRoVrVbQy+1BlBa+1Tq6YTJOQ1DE2O2IOEVC9bE5A9+172JFrZvuSACT2FM8tPzcpy6H68RAcGWYh13ZgFyJGiy1M6yBqY32RSTXvUnmC0DW8z42niZT5AGJMN/cAM/X427xdhS1OEQ3Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b76fAstQe6EFJB6AJYHBY64PgMrJOQ07MepdbHeT2I8=;
 b=ms9Vgkaw6wzHOywGlyv8L6HoP+mdxwvuT5hToBAEdS/y9S9pqHhBvd+b/hPl2LBfIPycQWzfaOMFRhLOupkK1zyVtwiysOZUxvV7J+KhRBRaf0YWKu1N9/kbxgVF+LncDq971i2jmv1aQgjJHRNO7JWSdnDcLbJogJhDJ1Ijtrg/uymafWt3GL8i0/yaGZ9UmnA0iyEiBERhbTxWl0Q36u0QztkboctEjBhylTDXvMiXhcmo6WwKKRaPApL2GXXlzMVu5DgkIk7Z8HHYcDB3P0G0EIR+GkfkloCNuaLenVYOMv8djpRpL5TCRcCzho8sr2YqtkaPRLlxK/J1R7mWqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b76fAstQe6EFJB6AJYHBY64PgMrJOQ07MepdbHeT2I8=;
 b=MqQ79xMZBgOFfWZujl43Eo12eSrqQh4+VyljlmSsYUG/v65szk3Oz5i9TFQh1MXZpsARIiX85zqYDJgq7x4+/qTCrJ1zM8UZTZqZHAmrMgXIpcAXaxFVcTYdI9S6J2oG4nvwQ+n08X7icgb7CjOme7CzkuHa8Zkyq/iEDaD1FAo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8949.eurprd04.prod.outlook.com (2603:10a6:10:2e0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:33:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:33:46 +0000
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
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/13] net: dsa: hellcreek: deny tc-taprio changes to per-tc max SDU
Date:   Wed, 14 Sep 2022 18:32:58 +0300
Message-Id: <20220914153303.1792444-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c89729c-ebba-4534-0d8b-08da9666836d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aNRiJTmWVvmJz3XorAbqDFmqHhHSsh9NazMYf7WgMBjoJmCfiynDEpJ2mD6YbpQWCi4zqasAz8HJooHZkW2Et1fn7+XH8e1HbcL9ADkjS59VXJMu3hj0a3axhacseV8e0CH1a39qu16F0HnF78JZUUd7fermwNjRrleyCdY7GstT0SxzPMUw2D6XB5Z1idPFmkJhtptboaJVELPCoxrxGeUuaXpoIlKz2ASCmOyFQp29rPyEA+kYOVdPj2vToHqCGvfq3jofqTUKii+WGv7jLcqoZRPDX9EX1g3vinTSk2cWHQNl+oTf/wazm/kQnXiEmg0DWUCvEauv7/wVtNnAmSkfcby2YJXX7jp5wWfg6dWHKPVfsFW40oivRrYq0lDHMG3pL4PlL/rOg0Wi0t0y0Fhq9+QNb/FD9862C2NCv2246H5kONDYf4feIKzbmIGJ2m94IzZ89EZjdJ6mTFfdFUAM3YyK3AEmnwDZqoiSWMCMufjp8mnzD8+tY5D5Wm1QhUeLfEZyL/eH1ajmVsrA/M8XpH7xx6a7d2HG8Icv6I8rBD9x/b4ThnQscdrPmhXMeO6KWBDVwNlZNePPdhzE7vxUqjIJGZiwOfu6cNwg/F1nzWf3zICwEuqpuBnRgw93oIYpgN0ODJUEzRbqPTZ8tvkiW4Mhwq8Q23gWGuvEv3ev66BgvtX9Zn887jK1Kabwk9ESx4Niln7Lp+B0LS1A/0MzbnP0yp6G1/pEn8z5HW1JafbdMYffdhT9oXxEvvXblHun5871pLeIn506gXPREQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(6512007)(2616005)(52116002)(66476007)(44832011)(4326008)(41300700001)(66946007)(316002)(26005)(8936002)(2906002)(36756003)(6916009)(54906003)(6666004)(86362001)(38350700002)(1076003)(38100700002)(5660300002)(6486002)(186003)(66556008)(7416002)(478600001)(83380400001)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BwNqCMWdREHgLmqsHu8sUW5DTkUHg9iZZFk1exTqnFVey6ngauG4U0QymXhA?=
 =?us-ascii?Q?j6KVTikdd4XTGNOB4i02zb0vzoZMtLwifxRZJPzkouAIrZKAD76oSCLgjaVS?=
 =?us-ascii?Q?C311c3Jdc9Fuo7joOHMOcq+dB90VXylwAyjmeCzS8nVNBQQesnh8+XcsdxN8?=
 =?us-ascii?Q?qyJT0oKQfphCMxQDvZXqb/4xY+rbLtJupIJ0f6QFtYjuir1m1uG+yeWM/1xF?=
 =?us-ascii?Q?QCyJMm8XWpgmBQR7uOcog5qrJr5aOQjfnPnNw1HhGMw/fhIOiKoLh8KQrI9l?=
 =?us-ascii?Q?jYJXRo/P6MintlpaxrY85lAYzgVFhxkL92qLGVJCLm0kVyRz6TYHdTRw0TWD?=
 =?us-ascii?Q?cR+wxXMJZnMLLTLlx9FdfnWVglInkeQ6JjLYw08rVCREmaRj7QAaV4kxJ/lK?=
 =?us-ascii?Q?KSA2hCVVpqRhfV2o8Lc+7e+62wB3MUpQ7nTg6fOPLetjHBbhjveRC466l8Yx?=
 =?us-ascii?Q?x8M3X3fYO5nHHj4dKv93Tw7d6g4j1eVL+QolNzjhUal2QEQzkCDpZxCgiS0E?=
 =?us-ascii?Q?V682z/OSqgH4w14drYJxynFjRkbIJKcAUDXioKtIOwLborkZOG6wHHyvnPX0?=
 =?us-ascii?Q?jxmoko3OmrisuF2Kv07nn+j6RdeiheoPE/hPvq3hBEoN8oFNTh6rcFat0cEl?=
 =?us-ascii?Q?pHyaEv5TVLzCP/aRp2JlsZ6MWhlJ/Bg0+ytrHQYf9kS+gYF31WROJJq0SoNM?=
 =?us-ascii?Q?mb+lg/yNqwqmwDYjw6NTsX9io1sMElePKs7KocEha4rrETnXiXA4tOAfVail?=
 =?us-ascii?Q?g9bqNkA9esxu6+tXa+4/1oAAlGdIwg+POmXQCUKI8Y844+NmNIb0fIGoCLp9?=
 =?us-ascii?Q?QJ9j85IPxtMBzWGQ5/PITIal6SOP3+vBzQFXEaA0aOKmiGGBlK6lRGvLjLX+?=
 =?us-ascii?Q?nIhwbNYQcti5ZwyfqL033K28W60QOIHBa3hPD5Lt5DQY7M5nBGgZlv5il3dq?=
 =?us-ascii?Q?onPI3Uy/Yqv+ftdinmxcPWqsZuqQLjqxHKi+I49wXS0Shao/3IszkETb/Adn?=
 =?us-ascii?Q?7Rn7M2ajn0dhFkGCb0IhqiL4Cut5b3MbDPTl2cBFSqZtdeRlVTFjgQpnBPSo?=
 =?us-ascii?Q?1HjDlsssSUUkc9i0R0CPoRCRrkGuPwVtREf60iyqS2OOnO+0hbHQEhDfzq9E?=
 =?us-ascii?Q?RbCHMZhhgIGW8n2p0R4f4u82qyUfkXYOyg6zE4Ep96A4kOkOZnfg/LPEDNaz?=
 =?us-ascii?Q?hH0NRH2sWmVg5MtxVQPxE/ufyxHA6Vjs4AJAxSvju7lGiLy5yvEDliHsUtjV?=
 =?us-ascii?Q?ZyN/VTdtPli7pxfjvanaYAcBbZKRLhdmeJQi6n2QbpV1AyAN+z0wAKX1EgUJ?=
 =?us-ascii?Q?LTLSvS81yW2GNlrLZaw8GFGdV9N48xYro2btTtB9kqfReTWvJ8rOmIUBNfc6?=
 =?us-ascii?Q?kwOxHkgxciUJDdXPNCb1wCQKMZAXga76DzTQw3j2TwkZGjIQOfiBaQYG5rKT?=
 =?us-ascii?Q?cXEXPmO36EeT+SnxvrSeMntnKDmwSqas+53goiB+pv8J6kCYiQvkTcEOIeV6?=
 =?us-ascii?Q?CW8XB3U6n6T2ywrzV5+vtPv457169NZ1tsNB9m84RW52mh3q6OOofwCjB/eF?=
 =?us-ascii?Q?QwQ0YXUFPTAFDKp0if5Jk7iBHpNwIM2Su1MzliPWsS5jGY3cZ0koTTJZ3frm?=
 =?us-ascii?Q?ug=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c89729c-ebba-4534-0d8b-08da9666836d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:33:46.6045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jj74PkJU6+TgVX2Cef1KTaTRg2tt9uWlCCB+pEGMdh9MLWn2ZDoxQvFWx1FtyeFjfvJ9G0C2yQ0U0J12jj69DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8949
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/dsa/hirschmann/hellcreek.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index ea8bbfce0f1f..8ef7816627b6 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1814,10 +1814,15 @@ static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
 {
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct hellcreek *hellcreek = ds->priv;
+	int tc;
 
 	if (type != TC_SETUP_QDISC_TAPRIO)
 		return -EOPNOTSUPP;
 
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		if (taprio->max_sdu[tc])
+			return -EOPNOTSUPP;
+
 	if (!hellcreek_validate_schedule(hellcreek, taprio))
 		return -EOPNOTSUPP;
 
-- 
2.34.1

