Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE4F3E5AC7
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240697AbhHJNOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:14:43 -0400
Received: from mail-db8eur05on2062.outbound.protection.outlook.com ([40.107.20.62]:47684
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230214AbhHJNOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:14:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoJ8YTc9u7BoB5yx/Tn4oJEAMSBLmNUuVonYAYK5XtXl9551QKu9qsyUGaoEl6/cSA1Lx1wjDthsPqI49xRLWLKH7tiMy6z1pHkaIqzD6yj18E7KyDGzNXGPf7nshkdRSZhDKD0+/Pg+li8IASUlpT7Zs8YJ+MS61x9lKkF3uVab1PfNwhO52cxM/1J1qyE0mXIahFdNI6loI6LGHtnAQmtUCxHwBT2wUZKflm9LKIUP+A+B11sghnTxs4xJROV4wUPw4lOBQRRIGntEVQSVepQpGmmcGW0ID4DeEZLCQvvcRHjtcW+C5arIJWpX9f3SmIeCkgK+I50uom5xhTNg5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNZl6XSzGgUtL/ePSF5Tq3HvWLd4UBy+Re3fnf6JLv0=;
 b=npEtqWvmg3A9kf5sRNExZ3U6IP0eXQ3RtK+/IXedUdkaAvB/7UPguGcK3gk+m3seI/B8ea109/v9l2jVYI+lnS06GEaJmRzFtY1MjXAhLHftbr/HlE3OC1WgvSy1NTZsz9LZHg1m7T6S2Gas6RKMQtN8+Kt/qwiTtNjeLGqnEvH+Oi8JvOz3b8eyzsqEGsDLGNBmi/W4csNYBVvVlFECeg5T/9H7o8rTu5/lWPW0sgeqBdo6POmqaBEOB/XdG2B6QYfZt/oxeh5y+FP2w/DEdXGYAQLrcGiTLCmS11jSpL5flTkt5uTR/IMbOvpw4aKy5nl0RtRcGxETsD5YaQOuOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNZl6XSzGgUtL/ePSF5Tq3HvWLd4UBy+Re3fnf6JLv0=;
 b=shwrD3p+CTdUd5tDO81+t4FPgO6Ls2B8S0PmPQvDheDr/rzwdL1PXbaQDwFW5dA+u3TxYHRF65cg80jLrYUsF2Jjp/bMvCMK4+n7f0aHlzNuckEvBsWvz1inJlT2k7HYNOkKaogTGoTRRHkoXhV5KJGR1QJNlefGQtoXrYmtCOw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6013.eurprd04.prod.outlook.com (2603:10a6:803:cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 13:14:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 13:14:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
Subject: [PATCH v2 net-next 0/4] DSA tagger helpers
Date:   Tue, 10 Aug 2021 16:13:52 +0300
Message-Id: <20210810131356.1655069-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0228.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0228.eurprd02.prod.outlook.com (2603:10a6:20b:28f::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Tue, 10 Aug 2021 13:14:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eeb72c42-169c-4db7-f36e-08d95c00c025
X-MS-TrafficTypeDiagnostic: VI1PR04MB6013:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6013AB57060C896DDFA9D486E0F79@VI1PR04MB6013.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BSmcFp7XBis1xC37NI+XyCWzjMd7RvrlfIEmOxPT+TwLZ2DjlKM5fL14cW8XEpyiXLv1dcyaiizE6A+W56R8M2FfUIzq55v+tpaffPULrwkbdHY30cRHXFtOMcPWVUIgqc/5ySXIWYDVkp9twnHNYRa9ff42pwhJ/D5UOM1nVhyFVMl+wAg4/ZounDf8baEzyfkZddQyaImFQ2CuXjg/IUAVkFi8+TFiUhNDKluDSmMmKofVAIV4a4UekK5vSL2zlYKOkpVzgXwPfvcc0XezLL+hBEPcqc7/u1kuUsFSModEXxte/hfDxffU6AHbRROUsqaVfkDyHNKN6L0WM5sugSrt5JDMDmG7MPKjPBP5WitpzG24OgMj0shfbNibZzua7KhaV2kQQ3syyaIKOO6POlq6s1ItOI1W8o7YsV+56rPxk2U+yhYdmomra/3aRHKJt+B0VVn3JBQIRG27KUt5RySUCK7EQ7AN1LW5IwCEAtVLpJY8PHZc33sTJcvX4ZTe5NYtzB+GiUpR8NxX84Le5RiZZqvLCGHyb89UCH/A1vE2wyiJnP1ljQ76CZ7awaSohjPFCQ8FtPlwvF9hdZRJJX9LOQ18UKpBvqTpMmsNb79nvYO11pLJW/ieMoZGEG+MYR33AqneQyTQl8HgDxeIYyCD5PRyB5Aw93EofJXDRZl8dR3YewB66kgqEqO9J+7OAmGXJoMiBn2bNbs6q1EuRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(52116002)(2906002)(6506007)(956004)(2616005)(36756003)(316002)(7416002)(26005)(86362001)(5660300002)(44832011)(1076003)(4326008)(6512007)(6486002)(478600001)(110136005)(54906003)(186003)(38350700002)(38100700002)(6666004)(66946007)(66476007)(8936002)(66556008)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o5OiMy/DPUhkip/jGMF3dnRMHCp3QEJ6neCYvGwGMVBR8oFVMj7lxpqMvEsZ?=
 =?us-ascii?Q?/8Zq5Kd4ufHoPxzKKfj05iAVgaIo7sEiyYhkSjW45sxKCtBiX0DaZ/E0cRgL?=
 =?us-ascii?Q?USBwSYbg4A4LjiX418OpHsBTgszD2Xc8wzjt06g/b1pnVfDTaDLgUf3cgcLP?=
 =?us-ascii?Q?NhVg3PswTeZUm7y80yeFyTC5OCutHH8qCg2fnpEcqtC0EY+1eh9jWMh8/QS6?=
 =?us-ascii?Q?WJsyHxDaeZlucpdI5Mf6pOPeXDTEpY4rkklnvW4wYNJVtCyg+RvW8MljOcaC?=
 =?us-ascii?Q?4fprSC2bNdd5rZtIsSBX7CfyISIbpT7iir/hqBDdjzeWJyk0lIJkU0iWa5oa?=
 =?us-ascii?Q?Lc2OdPZiH2hcOatIDucNaGplMAaBfiUqKWRGkB7JBt/kzj24eEZYn/29W9Dg?=
 =?us-ascii?Q?p0t3SV3R1OD8WmEVk2u6mvKqhY/ARmJjr+ABgElpVvt3fAK9kpX6WM3cBW5n?=
 =?us-ascii?Q?XdqOolSfvtn3BAEjD0X2ZF13ry65zBFin5LAfKI2Vo3A9/rKuOgktbw8sT6b?=
 =?us-ascii?Q?EM5sWH6J/fyZcyOo4JP8vbGwQvId1pUhTUGVukCPxAb+fy0IcaT+0Kpl5O/G?=
 =?us-ascii?Q?QuTy0s2kw+urm/bcJNSwxp3+x1W0Sf7R85YJcbHcQ8MRRsjbuB61cGE9nKxK?=
 =?us-ascii?Q?MCCETpG+0QPDlwhEGwHZ1haTvjF8232Jz46NhwIuiT83zpPN4VhzFvSOoVMP?=
 =?us-ascii?Q?MnncYfAmjkzGZwDk2qNjocRBRONLgVftlkz/VZDmCUc2xcdfvk16N6yE8mlV?=
 =?us-ascii?Q?ItRZ/7lG4HDEEoFtlz623xushpjD6p+HSbsLB9mNR5TrZWXYlIUNSabCr5qv?=
 =?us-ascii?Q?GQ8spJwG/eR9XWvddwvYArybNS+teV9vy6Ls1qQQXk5hQeFRVAfSTyfUHy64?=
 =?us-ascii?Q?p+DQGw1jZD1nxWrQS4BB1EQPFzj6X5MFCRU+924pg22fixBUlINiHixbry0x?=
 =?us-ascii?Q?Ct1bNBg3bND+r9oR67peOf6KIfpA1Vhwh3MP0NkEGAxI4UYKBl1m0uwz6H1/?=
 =?us-ascii?Q?w7ofhs716Ooc1xYrUhRq2hpiAB91WSwTK1eaORRImikcNyEUVXwkaho9ws0H?=
 =?us-ascii?Q?1i3KgzJjHiv/rvVIZsPrWTyDhOVhDpa4OmcEuvgsZVQBPudw1lor985A9Jky?=
 =?us-ascii?Q?N71SuPVC7DjibDMF5F2y5eF+ughsFD3gH/wJxPTyAo8H/YSKLPqh9A9zCtRO?=
 =?us-ascii?Q?ZxJRHfLWDmP/ReCrOT9vm2gj1n3y/UrlHfMi89k9FTLFsUivRhYZl3R4Iiq2?=
 =?us-ascii?Q?cRv2IkAOiWqPb2tyJmyWcIS9O1ayIa6oo+gASijG6CN8i9GEz73O/RWAXQJV?=
 =?us-ascii?Q?AosW3b+8SGPESJ+Ffl0vGEKB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb72c42-169c-4db7-f36e-08d95c00c025
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 13:14:14.5042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sx5HeEIxk4VXUH4Ib3iOwEoKbNaXbYfbK2u5UQL3pWKfpXV/NMA7O4NQw62+VqHggoRGKXTclIr1d5jIAjC4kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6013
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of this series is to minimize the use of memmove and skb->data
in the DSA tagging protocol drivers. Unfiltered access to this level of
information is not very friendly to drive-by contributors, and sometimes
is also not the easiest to review.

For starters, I have converted the most common form of DSA tagging
protocols: the DSA headers which are placed where the EtherType is.

The helper functions introduced by this series are:
- dsa_alloc_etype_header
- dsa_strip_etype_header
- dsa_etype_header_pos_rx
- dsa_etype_header_pos_tx

This series is just a resend as non-RFC of v1.

Vladimir Oltean (4):
  net: dsa: create a helper that strips EtherType DSA headers on RX
  net: dsa: create a helper which allocates space for EtherType DSA
    headers
  net: dsa: create a helper for locating EtherType DSA headers on RX
  net: dsa: create a helper for locating EtherType DSA headers on TX

 net/dsa/dsa_priv.h    | 78 +++++++++++++++++++++++++++++++++++++++++++
 net/dsa/tag_brcm.c    | 16 +++------
 net/dsa/tag_dsa.c     | 20 +++++------
 net/dsa/tag_lan9303.c | 18 ++++------
 net/dsa/tag_mtk.c     | 14 +++-----
 net/dsa/tag_qca.c     | 13 +++-----
 net/dsa/tag_rtl4_a.c  | 16 +++------
 net/dsa/tag_sja1105.c | 25 +++++---------
 8 files changed, 119 insertions(+), 81 deletions(-)

-- 
2.25.1

