Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214E22A20F5
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgKATQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:16:58 -0500
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:47874
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726790AbgKATQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:16:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYzlv1FOiHGKwL0eJDabaC5xpM6QejfAdwC9QL1lERi4b0vXKifEzvSlICS36UvbO+g6s0e0c6VbhPST/CifWynhH1I0JFzkq7F1e8RJ/grEoE0b/tezAGv8ZsOcNOK1p5UXzwlKvYyhHh7GFJMbDbC7Zpcrr8lLo3dq8rd88hZrcDJPfD2YyQBDMWQilrBrSJbii6HLOYe0WP014tGnIjCSYg90EGTDAGyryLupDbjZv/sOgpBvQl99NjJfvQFTLkcyRQ7LQDtZAUh5L38zHBFcxRpWXSmYMrcOIbVKzYHj672JtmCI+eJI9gosMIs2AthuN8QMO+FkH0ijvTyrBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bzcFwyDZMO9/bEJVxBLxqlAb9aV1mYGlqy1kXRuI0o=;
 b=c556WhfmuUVBj1SgHswg+zDycquib0A+b3xZTieTbkP5qT5vWlyjyGa1Ffk0AV2017srV388JsEQEUsjzKv6aFkt1GFEsAHlk1qHCMSpNMm7AeRBa81KXllyce2BFxmoWPHg+NCLHhZ6RZcB2k1Fc4gv3hL/gGnotjVhBKcIJGEUW5PzjSiy2lPlRV7ly73hkBtDH5cutsipxIo0F/O5RTsZ4A2uO3PthzK/JvSAh33eNNBok7sv7fmxHRLE8O7eg4Ez/ROORiPcv64oMlsfGzOsvwYmPubYer3dJSVmbPaHHV3Ws6WqP94PmhHU408W4JVqUQZadSe2gAKJKRufaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bzcFwyDZMO9/bEJVxBLxqlAb9aV1mYGlqy1kXRuI0o=;
 b=eGsBjRr4RIedf+rOOJBA6Dfb2RKNJ4mgt41As3kmLtAy/dZpuQdpDmMOEfJVpeAloB77l5xWlhvys2ufiKyfu9y18oGZAyJynwWYs1C2CphMaXZKDVCS7c2tm3Yw90hFVuAg7gWojab47/JGcE6z5bdnaw/T/CVRcO1hqMwJmlI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 19:16:52 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sun, 1 Nov 2020
 19:16:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 net-next 00/12] Generic TX reallocation for DSA
Date:   Sun,  1 Nov 2020 21:16:08 +0200
Message-Id: <20201101191620.589272-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR0401CA0001.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::11) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR0401CA0001.eurprd04.prod.outlook.com (2603:10a6:800:4a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sun, 1 Nov 2020 19:16:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a02c6423-fe44-49d9-2579-08d87e9ab071
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB286115F47099DE75DA43C200E0130@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SRAOb37/WAIJWXJ7SIUTTIyHjGo8ZuAwyi7FgVNopi8qFHBKaGMgsgTg8JNoSAlUtui9sHwECxJelNG969kD7oogpeyYlY9E8q7EESiqHi/s37POMLonlpYszEwgRBEZIjtCWFVd+TrxfeWykssUX5X03uj9cYBKFU4WY32kOUkEs8vQ8UJb3nSOyXVRCa9N8xiuTYDtdTKRGCInJfW8oDKygYikjMrynAFah6eLWI1S5Xsax07Xq5D6PejqL3B9OMtue3gYPYaI1u9bnX1LazNcaHWU0NF6MEZd2E8S5t45/J0FbEJE/mABKcecrh5tqUg4pFInMMeJNBbEVsONHg6dU9++3nr1XT0u4A52emo+v9ymWS1rFs65LdlRFBNAuGXJdi52hm22mzAzE9gnccK1s+m3yWzO04lzOd70HmcR0zY9b6DDAN+3IioYsPshxJ1XppHH2UiiDdoV+jpXaYqwYouG4xWPkwEvgmw77S0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(2906002)(8936002)(16526019)(6916009)(186003)(6506007)(86362001)(2616005)(8676002)(26005)(36756003)(66556008)(956004)(66946007)(5660300002)(478600001)(66476007)(6486002)(6666004)(966005)(52116002)(6512007)(4326008)(1076003)(83380400001)(44832011)(69590400008)(54906003)(316002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 12eS1zSAnCMW+kHt7EBl4kDkkpxN2dPGzlXMhQ4pvMw4gmnA8m32lOeoIRkCMkOGKhlp4fwVQwM0GcYsBZ/PeBaoQW2KPNuCeVEPyqNcNqHErQfFSdTlepxW6s4ujbehZm6zvCc125Ftk9hIkb4pIML0P6etzyC4sZdw6r+Npb6S/kkATve8oMQxih4X7jVhe5uIqQAhulPv1uf7MxTTi7vIPBCnw9qleVDrHy4UZ8BoLblRNkE2Ns2D7rCggIGO3+c1aFcoOX1fora1jsqq3Rhp1Js5aJ8J/EY8bx9XgugViRhDXpXR65tNoo5FDzzl1/1w7s0/DO0eVm5wMAWZmyfd+cDW3F3HEFpoCb9ByMTUN2Y1Bp91bWiTf7WpUd2ybBPdhHqHQWr0Co+3tVab3PpR/7Gl3N8Q25B99ejvIF+POOrUBw8g6q1zLIuXh5Pl1Z9d0Ld4ZhJ5+oRJJ5/bzAfHvyn1W9BYga9GFts7v4hi5Nhf3LCVpQbwKlSOf9/ykoY9ACFUJBIqMV+4sN31OUKylNMQDrtl9skpw+9+XYQ1qZkW7ixorujVd6J0owmWmb3hza+GsqvTsf49DyNAEhvFn6+3LcmbWQ8cXfcJICYWQkbVJRxov0+2LLBtfL5t9UX4Mv4hdfPK7z/XSvhZew==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a02c6423-fe44-49d9-2579-08d87e9ab071
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2020 19:16:52.5312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FGDQmjgcnPlSlgtQlCpGaR8s6FaoMF9VtcV6Jyovn6ci5ur6tFRmFYhFE+kbYWDZQLMlkEJmuKqwieZF+uhvNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian has reported buggy usage of skb_put() in tag_ksz.c, which is
only triggerable in real life using his not-yet-published patches for
IEEE 1588 timestamping on Micrel KSZ switches.

The concrete problem there is that the driver can end up calling
skb_put() and exceed the end of the skb data area, because even though
it had reallocated the frame once before, it hadn't reallocated it large
enough. Christian explained it in more detail here:

https://lore.kernel.org/netdev/20201014161719.30289-1-ceggers@arri.de/
https://lore.kernel.org/netdev/20201016200226.23994-1-ceggers@arri.de/

But actually there's a bigger problem, which is that some taggers which
get more rarely tested tend to do some shenanigans which are uncaught
for the longest time, and in the meanwhile, their code gets copy-pasted
into other taggers, creating a mess. For example, the tail tagging
driver for Marvell 88E6060 currently reallocates _every_single_frame_ on
TX. Is that an obvious indication that nobody is using it? Sure. Is it a
good model to follow when developing a new tail tagging driver? No.

DSA has all the information it needs in order to simplify the job of a
tagger on TX. It knows whether it's a normal or a tail tagger, and what
is the protocol overhead it incurs. So this series performs the
reallocation centrally.

Changes in v3:
- Use dev_kfree_skb_any due to potential hardirq context in xmit path.

Changes in v2:
- Dropped the tx_realloc counters for now, since the patch was pretty
  controversial and I lack the time at the moment to introduce new UAPI
  for that.
- Do padding for tail taggers irrespective of whether they need to
  reallocate the skb or not.

Christian Eggers (2):
  net: dsa: tag_ksz: don't allocate additional memory for
    padding/tagging
  net: dsa: trailer: don't allocate additional memory for
    padding/tagging

Vladimir Oltean (10):
  net: dsa: implement a central TX reallocation procedure
  net: dsa: tag_qca: let DSA core deal with TX reallocation
  net: dsa: tag_ocelot: let DSA core deal with TX reallocation
  net: dsa: tag_mtk: let DSA core deal with TX reallocation
  net: dsa: tag_lan9303: let DSA core deal with TX reallocation
  net: dsa: tag_edsa: let DSA core deal with TX reallocation
  net: dsa: tag_brcm: let DSA core deal with TX reallocation
  net: dsa: tag_dsa: let DSA core deal with TX reallocation
  net: dsa: tag_gswip: let DSA core deal with TX reallocation
  net: dsa: tag_ar9331: let DSA core deal with TX reallocation

 net/dsa/slave.c       | 45 ++++++++++++++++++++++++++
 net/dsa/tag_ar9331.c  |  3 --
 net/dsa/tag_brcm.c    |  3 --
 net/dsa/tag_dsa.c     |  5 ---
 net/dsa/tag_edsa.c    |  4 ---
 net/dsa/tag_gswip.c   |  5 ---
 net/dsa/tag_ksz.c     | 73 ++++++-------------------------------------
 net/dsa/tag_lan9303.c |  9 ------
 net/dsa/tag_mtk.c     |  3 --
 net/dsa/tag_ocelot.c  |  7 -----
 net/dsa/tag_qca.c     |  3 --
 net/dsa/tag_trailer.c | 31 ++----------------
 12 files changed, 56 insertions(+), 135 deletions(-)

-- 
2.25.1

