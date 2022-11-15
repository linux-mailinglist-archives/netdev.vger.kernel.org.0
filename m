Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0410E628F1D
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 02:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiKOBTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 20:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiKOBTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 20:19:00 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70075.outbound.protection.outlook.com [40.107.7.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B2AB59
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 17:18:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipf2O7tEGoKvRxSbhmJCXIVQSV8ZpKiuhEh3mil3OwFoNK/06Rc+u1D22n17dvzzTuC5Qlli3vuIvIQSM5BL8gzPIz/HQvXxdhV2qftoC9vX7lyjPXoQXRG7qOGc85BZv6S+qdJFaEN7eJs3OC+ibNEzV0LnkBztOjdhzJCiq4E7LKW/qU8DmRJCUFqaYjjP5bhWM0aqkU7kPdyEBhJ9E9ti1KMCTrel2Qlsv/xC4Dtpu5uEph8OvPHH2hJ7t8BSj49IcS+o0Q0EKYibb2PZj+DkK7g1GJbKLZmGj3qB3laHTumFMyrNXyBDfs4eiRxWb+bqJj7BF5QvibFU7KULSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uKMSeKN+Y19qUc7zM3oaqeWufFiLR0HEdI++SeuJMzM=;
 b=KczdurmgudVYrG4VJMBx7ZWwswJVrfx2Rbs+kX8fcLaGLrn4y6GFTC1v+lHrv+6mKBjw32i8SuK4uLvKF82VZ+WwYf9m0etx8EuOhlL4Q/EYg5ff9UceRKMjz/pzI4jmNawEB8rOPTZ1/0MTl1SYqghgdInms0mM2cuC0cgLVjOqLxP7/NKC2717o8esY98Ik7lTiuweBqkjWfZnTunII4nqZcrv/QHjYYyxxktONVhrUcTm7bGOimqiV3YzJUetKBeEsmpea8SwxL4DbZ5t4oFoLnQT/vet1xYBK35Uvr7YbFzeGbJA2WOmOJJzF1gOch4kB/t1K+1okleikEEBGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKMSeKN+Y19qUc7zM3oaqeWufFiLR0HEdI++SeuJMzM=;
 b=QNGpXC4kpo4uygwZfyr6MEZcUqRZZ3CAw8ej83LHVopLgTla0mu3U6ctXnIJAVMimQkfg1uDXDIEbHyWf2qsbGfzjZ1kcrf2mAO652+6ymFwS1uFcs1xMBgP1g+P/zE5gXzysb0B0KvNKRyNApB6QPqRM3SXSwgrwMi/jZWpZOw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 01:18:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 01:18:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Walle <michael@walle.cc>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [PATCH v2 net-next 0/6] Autoload DSA tagging driver when dynamically changing protocol
Date:   Tue, 15 Nov 2022 03:18:41 +0200
Message-Id: <20221115011847.2843127-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7815:EE_
X-MS-Office365-Filtering-Correlation-Id: d3934ca6-79f9-4b80-bb61-08dac6a75e29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rIIMbFH8k9F/w+ldMyMMyPJuBIkqPfV4NYV/OSW9Y+Hr2ssQ/slX0uPfZUYujeuZ5IqHA+TyBVL5CqjJ4/Rik+scGTDM/2bGMY7zjgpfWRrEsXlXfTU3MYewaY+/l6RLHfi5SG88ErG4oGD4SapxlZH9UJEcztcb4mog0S+rIheEZqZpNy3nBdHjhQdW0kf/3aif4e+FihShbDq4h+Y2svgIQuYgZPjasl0M8/uOKFYkmkC2bXHp3GVq2/9GrPDczC9iCLBDf1P1xqt+kTyLql6mPiz/xkpmYEU4pyrJtp6igUUU4aSlS2tvJJph1BwXSI76p5TCFvXWuzmMIl5JZxGFJ9xi03GRbbZaASkTxxmdYaY8aModmNQoXpjsYgPpo+dPVBh5RA7HnrNZQmzmIKwpFxKw03Z2i1EQ1Nz2QdAIGoiFaNFIDIqFU5ir4q3Jfa+3tFa4A/+sDfeW7AkYiN0mpKQfwq/kGi3EqrShvZH++jOtACsr/1Frse5Wlx5ohOLx0WuSg7EEjcaFS1zFFJuQBPLxLl7bdaGJ0Ygy9gOu13Q9dJaFzvCu4jZ6JHDw2X9hEonF2RMrpHJ+v33kwbOQA1iuFg4u/LNFh+zcak4mz47UkmFzwin5e1MLJEClO5kOgVId0M32PSiP3GRVLcWX6LLhM+X1FtOIuVeZJxRSdGEbM3zGFsluWhSdcCCAjVLpeQcYabEwyc2nhcDK/nLRMzrzwJTOV67zc4e9/OxxauoQdpCxudSig+bu4mcnAQheFGcK+1cZtDeZ/EbvyWYzjf8y1Elko8Uiab0ZKL/xt2xiz9CxOJWEDIKyB3zCklMbSjibBVfnwNM47XytIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199015)(66556008)(86362001)(316002)(6916009)(4326008)(7416002)(8936002)(8676002)(36756003)(5660300002)(41300700001)(44832011)(66946007)(66476007)(2616005)(6512007)(38350700002)(54906003)(38100700002)(478600001)(186003)(83380400001)(6486002)(966005)(26005)(6506007)(52116002)(6666004)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bq9owjyJ18nOHWOMzfHQDpKGap5sioNtlbbz3uTSPKYE3yUEZuwC9unXD1mP?=
 =?us-ascii?Q?J8Hd4h9BFdCpeJKm100LIJoSjPTz40rkzr3T6dANbmli9icX392IPwZzjuNF?=
 =?us-ascii?Q?BS+ZHeOD7npqvmNkYbwPQk9UuuOsBiKW8HN3iyR1GClr0ACsOWKxzPStv6UA?=
 =?us-ascii?Q?c9a+VdNFL3b8/nt1TqLxXn1AwL8j5rd4cWeJ+R0s2H95X4ToAm4N3phR3X2H?=
 =?us-ascii?Q?dfduROBXtEbkLXbFV7OKga9yUxSRYu6loM0B98tKjFhJWHtM7cGJR61G57Tx?=
 =?us-ascii?Q?ll4+bx9w6L1no6qxHSYQE3LHh4Gg499BFAwLtKSe18LB2oAVyowtsJuwVVzS?=
 =?us-ascii?Q?DTc8JH2Xq3AVvS41ohFGPw9pkVoThcUwWZkIRTSNivThzMpm0PAM1/nNJ7W3?=
 =?us-ascii?Q?qnKNkWNdNu2nxElUVcJvgipwDIdndJ+Muje+FT/GAiyVGV8T9h7hJhk69KB3?=
 =?us-ascii?Q?POaVW6AAKQhjiF9lBbOJZUSAc4iugxiuwYd7pJRXa/lrrQEbDoMfZ6sVZQtP?=
 =?us-ascii?Q?YN/EQgSz8T+A9K6FXAhWJJNujwLdT6fTSiYf3IJHTcnFvc65JOBuoVLpt1dG?=
 =?us-ascii?Q?ZXwE/E7Zyoj0Tcui2RGfB12K4XkcYRKlvUpW0Fy8xVeQmfmrpxnxiCI6Z7+L?=
 =?us-ascii?Q?z17Ngp48AvUJ9T+SZdtfE6wl77RSZ3yhcKtcp7SwNvtdmTd1cBA1c0/mYe4L?=
 =?us-ascii?Q?UCN/wqp59zrmAKa3hNXEUuaLkTWRE7YNmMqwTL+cY2Ba92XIRcMuu+IrBW0Y?=
 =?us-ascii?Q?hhU6MOjgMw1oo6Y1wCbtrPjCBQrAPwrt3P5TK2l5iaUb48l2AcSA+IDgjRXf?=
 =?us-ascii?Q?PTi2pQjPgdRG+Btx3qvVhkFibXSvAIu1eT5hHEMA2uhSJYVUMuH6mIbmrj48?=
 =?us-ascii?Q?a0HLhgBw2lEe2VY1X/W9yPlDVJ5fVn4olEFDV4Sj6fmgXy+kHvrf2vJN8Pz4?=
 =?us-ascii?Q?1Ftv9tAUh1FdYsSLuv2KLiUMMbD3rHTXZvc2jjQylovc21i38zF+ABfCIsfb?=
 =?us-ascii?Q?UaHcE/tJ9GVahu/lZK4JNHKMBI/L8SPIptnUjzq72olhSj/PxhKTEyizaX9j?=
 =?us-ascii?Q?zbT2uTHhLcMmn5ZTAEoVvztCnEj3XwDTOnYKKlWqDy4Z+5GrsSR22zf/fTsS?=
 =?us-ascii?Q?//WcPPbQamuPb3M4ji8tgUjjkIHe6G06ZpvIcq3GuKQ9Wukjul7k6ZdtMUnV?=
 =?us-ascii?Q?3QMJznZariqlCIHL9br8h6dc3Vf03e2CaX/LTSKwbEWuFhQsa1Ur5bHJsXzM?=
 =?us-ascii?Q?EdXlmYqPE7TO9iNQziHUDZ40ebSSZrxCCxXWMRuMTmwO4LMh8nphd2y7QiUW?=
 =?us-ascii?Q?YQ+6qtPJg7hG357E51+rAGQDr5TQdAMLctxwQKHYBhLc/gS6PDlZnwBynqUR?=
 =?us-ascii?Q?A16UlZN19kaQGr5N6H/p0ISbMP4SzhyyaSJUxF6/l1gn+UBCW0oYxZPUktdG?=
 =?us-ascii?Q?7abzFNUf8V7kWE2vE6XNlJrJOcA1q7EQ6DJyeep+IR8bbebziUagwNN1nTNb?=
 =?us-ascii?Q?AJgfKI00tgBNEAMZB6ek6GiC5pmIb4zhNhRqqxu6dvOO3CNas5wXvRSaLa8t?=
 =?us-ascii?Q?8IlyJFLcMsZE4ZwcAO3y/p4/8jiVJhmB23i6C8k5GloM8yUmtkjgFcZPPRl0?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3934ca6-79f9-4b80-bb61-08dac6a75e29
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 01:18:57.0165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cNVCjeqJebSEAjzg/UtBkKexyg2qsbTFlZ5TG1SuwWLXYiK+y+TzMJs+MalXfE+aWBdEtX4cp+F34lBwByVjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1->v2:
- fix module auto-loading when changing tag protocol via sysfs
  (don't pass sysfs-formatted string with '\n' to request_module())
- change modalias format from "dsa_tag-21" to "dsa_tag:id-21".
- move some private DSA helpers to net/dsa/dsa_priv.h.

v1 at:
https://patchwork.kernel.org/project/netdevbpf/list/?series=689585

This patch set solves the issue reported by Michael and Heiko here:
https://lore.kernel.org/lkml/20221027113248.420216-1-michael@walle.cc/
making full use of Michael's suggestion of having two modaliases: one
gets used for loading the tagging protocol when it's the default one
reported by the switch driver, the other gets loaded at user's request,
by name.

  # modinfo tag_ocelot
  filename:       /lib/modules/6.1.0-rc4+/kernel/net/dsa/tag_ocelot.ko
  license:        GPL v2
  alias:          dsa_tag:seville
  alias:          dsa_tag:id-21
  alias:          dsa_tag:ocelot
  alias:          dsa_tag:id-15
  depends:        dsa_core
  intree:         Y
  name:           tag_ocelot
  vermagic:       6.1.0-rc4+ SMP preempt mod_unload modversions aarch64

Tested on NXP LS1028A-RDB with the following device tree addition:

&mscc_felix_port4 {
	dsa-tag-protocol = "ocelot-8021q";
};

&mscc_felix_port5 {
	dsa-tag-protocol = "ocelot-8021q";
};

CONFIG_NET_DSA and everything that depends on it is built as module.
Everything auto-loads, and "cat /sys/class/net/eno2/dsa/tagging" shows
"ocelot-8021q". Traffic works as well. Furthermore, "echo ocelot-8021q"
into the aforementioned sysfs file now auto-loads the driver for it.

Vladimir Oltean (6):
  net: dsa: stop exposing tag proto module helpers to the world
  net: dsa: rename tagging protocol driver modalias
  net: dsa: provide a second modalias to tag proto drivers based on
    their name
  net: dsa: strip sysfs "tagging" string of trailing newline
  net: dsa: rename dsa_tag_driver_get() to dsa_tag_driver_get_by_id()
  net: dsa: autoload tag driver module on tagging protocol change

 include/net/dsa.h          | 70 ---------------------------------
 net/dsa/dsa.c              | 10 +++--
 net/dsa/dsa2.c             |  4 +-
 net/dsa/dsa_priv.h         | 79 +++++++++++++++++++++++++++++++++++++-
 net/dsa/master.c           | 15 +++++++-
 net/dsa/tag_ar9331.c       |  6 ++-
 net/dsa/tag_brcm.c         | 16 +++++---
 net/dsa/tag_dsa.c          | 11 ++++--
 net/dsa/tag_gswip.c        |  6 ++-
 net/dsa/tag_hellcreek.c    |  6 ++-
 net/dsa/tag_ksz.c          | 21 ++++++----
 net/dsa/tag_lan9303.c      |  6 ++-
 net/dsa/tag_mtk.c          |  6 ++-
 net/dsa/tag_ocelot.c       | 11 ++++--
 net/dsa/tag_ocelot_8021q.c |  6 ++-
 net/dsa/tag_qca.c          |  6 ++-
 net/dsa/tag_rtl4_a.c       |  6 ++-
 net/dsa/tag_rtl8_4.c       |  7 +++-
 net/dsa/tag_rzn1_a5psw.c   |  6 ++-
 net/dsa/tag_sja1105.c      | 11 ++++--
 net/dsa/tag_trailer.c      |  6 ++-
 net/dsa/tag_xrs700x.c      |  6 ++-
 22 files changed, 191 insertions(+), 130 deletions(-)

-- 
2.34.1

