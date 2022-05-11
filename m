Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC245236D9
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244273AbiEKPOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbiEKPOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:14:47 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2056.outbound.protection.outlook.com [40.107.20.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0E462111
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:14:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWFbnNf8EE+3gca60QcWFaEOWLWc4NFxJAEfwa3Ez3Jg0wnhoKeFfMhtedDiNRlHViBYXc7TxcbxdLuHNhMKI3B8qD09J5cbipsJyQDjQVkJEaInZDrcDZIOAQ5Ep1uUdNqrYnJgkmS1JRZMo8uroJT/Cm9mbuFWrtyGexV4La58hvtZ/2HHMXEVkkNH01yTy85x61wi3uIfHrVJm075gQMqG5UuWJkJ6MVswpixxTLErVjNi5UUUQI2X7WuoXQZ0Rl479fvH4yM69VcjP8w6S3Fqkd0KOcd9LjwRuaffIvNLXQY5d3dGCk6Lir4pTe+InVx/ot80EM6iBWOd0fsag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/4HwvND6P1/hLEu7p5RqcXxWhuQ0w//ASR2+ExbfOE=;
 b=VH+1KP7ikjZAwKKwBc0Xs45V6aRDavV+XZppPSy7FIoMn0oQZSeECKuYreE95Q1CYynDqsiZ8tPyVefoK0c43CrJK4AMWogQykcWv68xQeIxjwmBFdJX+TQcV92W8+T17qdz54riFmxwJhvs8vlv/dSVxtm8eni+qQVDkH/63ozq4efqR3IxoywD1KuREa4w8KXRunMUqEKsF0NTpAUXZ48n4Crb03LRlkO9y2dC35Ywl35Mdb+CKz1bbnj4Y37i19WXzA4uBNnrtUlvvyXpIHjipyazuKhzFYnYc34ociq2H7w1UVBXDcCR3ENxa2NZ03SHeVFFqPcnP0A4iHo72w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/4HwvND6P1/hLEu7p5RqcXxWhuQ0w//ASR2+ExbfOE=;
 b=FMwaslZwRDpTyJmPzhaeJHMIzjnWYeBSdtMKn0SRUa6m/HoioTyrFrjGeCNfAvqbSEAjlOapVwKF9H+FcZTVPOz/Jkkx7xG+SZdyrs3c+m/UNqEdXeg+x3dqIlLDXVEmIYzwU/6FepHnwLuTTJQtWj1AuGAkMpvrpu4u2rmNydw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7755.eurprd04.prod.outlook.com (2603:10a6:10:1e7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 15:14:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 15:14:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/5] Simplifications for Broadcom and Realtek DSA taggers
Date:   Wed, 11 May 2022 18:14:26 +0300
Message-Id: <20220511151431.780120-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7522340-c216-477a-cdff-08da3360f9be
X-MS-TrafficTypeDiagnostic: DBBPR04MB7755:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB775558B78207494BED4EF759E0C89@DBBPR04MB7755.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fW6BKfYhv0wb7ShNwoVQF3bidRGUladDqANmiCYqlFvZ5J+I+C9QDBbHsxojUs8665lhgeG8ZzF8F0YtKBq/ktHrRwKJ5SiOTY/Cz3PHQ877RwcxG2R5Nf7/NqLIsDs4UI11Lw5Z1+Mdo9ODLtRfd05+sLLqkbXRA+fKatrT4aC75wGBAQpr5Msb8TXwTOAqsCV57ujLiMGBkmFr87wDNA4gS5orO1Vm5ntY6J+D+hFQdbzT6qylY/4PVLw2N+uNBcPBYM3FQFr3VPuWQLDFrQhkYcpFxodq/Xh79vIXMkDdR4gyJqt1NDmuCDUB7jNIxi+We3PT6MsGSBEiLtnMqo32Pv9oPG+Sb6CghPs0U6yF0JZFt4uQStTGu2j56HF4JV7/lK6/Jp3m3z4q2686lT7tUPov9yam+w4PmV3uJ2Ti7Ew0Y/G9Ffe9zjrbWkeK7oP9V1IsSYd5W6guZ2YQ9Lu/wt4ebgGwQ0210N13NI5u7XmvcDlKQYlQLidBfsz35t5HJsvVyOjtoWyd4WAT/BlnGieADazo4IN29Pnm9JU16u3Bh4+dOvVzQ8WAkOT3MZvzmO9Xw4zY7xQh28MT+4gtk/zVPfidgTsog8O9aux3XSkFXXxy51ong6aD0HtyyfqmHI7cNFLimyXfpI3D7m4nXbxoAlxGuWDEC/07q2OmvmQxY5+0IpwMiqKJFmI8t37qXKgnGq6DYGWcOBB0Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(66946007)(66476007)(83380400001)(8676002)(2616005)(66556008)(186003)(1076003)(6486002)(86362001)(4326008)(6512007)(26005)(6666004)(316002)(54906003)(6506007)(52116002)(6916009)(36756003)(2906002)(44832011)(4744005)(7416002)(5660300002)(38100700002)(38350700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a5IuYaDMlNyGLv7CoSjmOaxKtSg56w24s8+avDK/JGGFK+n7oqVLS8FXlhe4?=
 =?us-ascii?Q?q1oT2OFbdrHPG78pLuGLNpGEgHDfz/VF/1tSdKcrQPU84aIdYaY8cfZm+W7L?=
 =?us-ascii?Q?DTKhCMzmu5NWu3V10IGOtc9RtF1pVu2JhThiecbVBnrcI78KD63soXe6Eqp3?=
 =?us-ascii?Q?oMvwY60lqRB6Oj1yXtOds2bTOzceVzfp+cYEli9T243NP79wZVW/HpaNK+XZ?=
 =?us-ascii?Q?12R3kH6GuBxwl0SPC+TaWWvZDkW5B8SIe9xjGJZhUc+C8gSiKe1fizboES6X?=
 =?us-ascii?Q?9VQNRbeaHgE+g4uw4F9prfJvCMZb5JZephE/3WRg8tmTdo3GpEsdPHFZWofG?=
 =?us-ascii?Q?903N/hMmVgbF5SIjpZLLMhYgDa80/SvO+w1Zndh6JZBUqTpvxuxzUq27S1DR?=
 =?us-ascii?Q?lC/eVApKkbnbrkaaQvpb+nHxIBlRo39ulCdhCQSaN8pzIJhCtN1gYPAbYAxO?=
 =?us-ascii?Q?0ljaWdAFdE6ATIxX+VngCVppEKe3asOdw1BjEynmfVgfHdd1fUA77hy96WUi?=
 =?us-ascii?Q?D3z3/2u+c7DHfok+w8n2I9wo0xD8UeaU6XqWuwADFkjbf4GvK3ZbdmJmnvsB?=
 =?us-ascii?Q?JkLlNwtJSGKU6+P8zhsAE4g7ZiC177oTIFRwvJtuEbpozkVJ1l56+eVT9/fq?=
 =?us-ascii?Q?oYbsRvrucOTAlEPXigbQ2PCy+4tMinLMdWtV0POHpESegEYuUqRHIPI8vpfT?=
 =?us-ascii?Q?zEvOZp8VQHqf8HNbAJ68re3lBc9qKRHdIyZdVyhGMBcut/Q85YxQ/NBgLWvx?=
 =?us-ascii?Q?AVYgkcw/VimIzKMe0pd2TSQytIJubw1KSRfUKDBERf0XtC15FKGlve8Z3Lxh?=
 =?us-ascii?Q?dKTVj8lN+aZiFcbflPtZqF0MCDHoMZ4o7E7Ou6hSxR6g6d2tOAHrrUynMh3t?=
 =?us-ascii?Q?p7cYNju77wFTBIXksPhIUKkyANGZFx9b93Uv7uj1cl/Ng5OWVA9NjSjg2v3b?=
 =?us-ascii?Q?zLSrqqQXs6P5IJww+qWyByu3fLsE+cthm5A2zobvbojnovh0er6+uetIztLa?=
 =?us-ascii?Q?GYnz/rVAuGyq+fApBwmaqvdxtuyqGHDZmim+9kn2p4DWu5HXo/L7lG/BTVsG?=
 =?us-ascii?Q?AS/L9aWBHc0RV0eSfqWJr4bgCDGj1OEkpTl4B9x4Sx5DCSZsCAr7Cm9p/5bO?=
 =?us-ascii?Q?Khya1pE8RoxmEIphZnSNbkqSHXHfp010NqMMQx/921S55Ins/oGqbzO4qaUv?=
 =?us-ascii?Q?Q9+4DQqixDXQU7lRNWyunsGRlYnwAclbPF00XdGtEoVuT1QD7xtHOMecVjoJ?=
 =?us-ascii?Q?1/NGfEoaa/Dzrvnf4PX4SiKhAArKEmX+B5sdYi3ONb97EV4NlQuS11/IJEzP?=
 =?us-ascii?Q?Kuh5fu+Sr83jbtGni50Wyq1HjFsygQLlj9hoKRI0VelDqtNic/GNP5AY76Ye?=
 =?us-ascii?Q?Iu2k+y9JM+udYIixLJhT42GcpNABlFcwGPbwGdevEIvIbv5pTcsK1yfcu24c?=
 =?us-ascii?Q?zQoumkPfhsLsRuUt/PoqUE0PGmhUKVpX6XXYXHk08cK8IHlrRwtVuvLzCf7u?=
 =?us-ascii?Q?vxmSsqbu57zu5y62EZp0vxiTiWwR2+QRPchm00DkBO2hV48R22qBNGYBbUiu?=
 =?us-ascii?Q?ds4DWMDRAvslHEOlC/LdGwr2Fk6eDzgOpYczZd+zRjpLZ80OE9LI++RY6o9w?=
 =?us-ascii?Q?oCcWk3KBvdwroQWRszL6eNBRyV1ErK2r/U5ILjFtf8Sa0AIRh0JTGLabacIT?=
 =?us-ascii?Q?1KOPciuMTv21QgnnSdW46VC8ZhOmfd7IydCgWUz0g8WCxcP8QqEheoybeTa3?=
 =?us-ascii?Q?rZBCPWqOC0Dj2YEquFuG50rg3Ki85r8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7522340-c216-477a-cdff-08da3360f9be
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 15:14:42.8285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xbCQS9AJDnOPLgh7Jqt33wNrrBDcNJKt9IB7n+aujwVRGTKyWL4N8kWLXT30tJ4TjgDLwY4OBDzSj17ePg+Tkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7755
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains the removal of some "if" conditions from the TX hot
path in tag_brcm and tag_rtl4_a. This is made possible by the fact that
the DSA core has previously checked that memory allocations are not
necessary, so there is nothing that can fail.

Vladimir Oltean (5):
  net: dsa: tag_rtl4_a: __skb_put_padto() can never fail
  net: dsa: tag_brcm: do not account for tag length twice when padding
  net: dsa: tag_brcm: __skb_put_padto() can never fail
  net: dsa: tag_brcm: eliminate conditional based on offset from
    brcm_tag_xmit_ll
  net: dsa: tag_brcm: use dsa_etype_header_pos_tx for legacy tag

 net/dsa/tag_brcm.c   | 51 +++++++++++++++++++-------------------------
 net/dsa/tag_rtl4_a.c |  4 +---
 2 files changed, 23 insertions(+), 32 deletions(-)

-- 
2.25.1

