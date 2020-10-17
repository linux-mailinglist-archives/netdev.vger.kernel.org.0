Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5214D2914BE
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439596AbgJQVgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:36:39 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:7653
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439570AbgJQVgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exjhjDVxjkDQi8PsFXYlh3WPVeH/r2MVKeSm6oOr0CBi9oXEPyqPnPl1o2aOLFXYzfyoFy8gpHcrT6XLahCftAB4zhoIkk4gbTQBr9HwsQFmwW1Wh2R8e+HQJ2vpifz8ZfJgJtbh9VwrWRnHu/Pt9h1jc/8J/mjZ3RN7g2Q3yNWvfGXsiOBxIfhwswwAuDRrTtrkDhum4AJQNHyNc0ahOn7af1UsBscex6TSH6d1KV7lRlKICg4PotrjzfOY2//2FyrnLmxykSosq8rjm9FH+/uXf+B4XDaz6kdwMqCkv9iQdb5LmJf3bvSW6pv9sqsIMeRN4qZPR/shccTvyk8F+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UT91n9fa+yStoPqcJ8y92Te4wmINBo9cqaq4utJolQE=;
 b=ARvLX2k3g+r7b0PPnJI9PxeFPLipaDIUrotxcjRFGapmLyvBC4UcoKoUZ3qLaL9ooF5F1KlSDktSv02eVz1kYOyuUEouYUR3fSW6P6x+lEnUcL67M+49nySlPhmIkReDh9jxD6rVukgzSVRjySL3QdCWAVTbRrjXvVVolnWDnQPvH/ArxIoENeCYWwuNlOmFn8ZZsaVtumHZfSY4Y610l0ireEQ4ZfLOWam4h3j5pK4nuDG+QTh2bR1k+B3MEd8VWCLuphIHyZb7+heh1WoaQ8Pexp2KZGfZ9eH7PEJjC/t7XPvBtEcbV8hA5LfB4Q+Q9uS+SRqv00WIeM436bXorg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UT91n9fa+yStoPqcJ8y92Te4wmINBo9cqaq4utJolQE=;
 b=k/eLKw99RwAixiLK+LrUOEwqUsOWBtZpYkfS/kLIMMSJf3WwPYOBNjetIaY+BstNd0/K6+gduh4bKxirq9lBN0XLMF1zzZ9xF8KlRXFyK89iJh5GT2UWFR6cVpekczYDWqWFAXpS20u99IyFh66vC8gSXMgknfOPvboPlGVOyfo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 21:36:34 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 21:36:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 00/13] Generic TX reallocation for DSA
Date:   Sun, 18 Oct 2020 00:35:58 +0300
Message-Id: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: VI1P195CA0091.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by VI1P195CA0091.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:59::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 21:36:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a80a1551-4b02-49f3-2c14-08d872e4b7d7
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB58545EC5F8C2D83D7D57D137E0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1gGcjvZmiL2E+3AAo9rDYfDJiAI4NYufMLNwKQ7O4S3JL8xlm+x58B30BQaU6z588lA5hdLMHu+4uxNUAMLhGpa+OIEPo2KoJg2iV6xyl4zU5JRXbNrse/E4sIqPH0W7li1Sj+FYAwTntH/w8LxbsY0x7GFMjnHGlbNnphx/UaYLi8cN9uN++7sD0CMTOADkoyLlSPeeX+0g+wI1+CBKeVIyapxCxXcq57ybb+49R0tQCoHnX6RQi2JUYuPESyM7pPkIzkbJolzAUciu4SL4k8PSiuZ4fkLYuJzPqV+ow2SZYvFIQo5c5R4M5TmkyeTpopM7ftYJ8BQVR2p1ZFkCHnP0nORUQx+M1tuBb1x7JruIK2Cq5G0eE0l9o7Hvyri2U0KlyeCV8IVwWSr6JOBLr20QRnQ58nK7Kd9XCZqEMRElCzMyTyoYl42PbXhLEDRe1GX8+wqGWaqJiID67SDm4NYLIgnxhLMYE92MzK0CXZM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(966005)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JKD84zephSvg589pksitI/Y3nBi7896678G4twUl4svKkWpzsFniGSRT5WpgAlLcRTV0mLG+o0J0cc5W0xfER2qdqymLbW/PPKGmSPSSwA2HJvs1FEVjKoXaIEgh2FEo+jOFKTRDzcsLTpAkiSApq0nsM9DjSEERhHR6mStZwgugntAGtBXJHR1hizuGZIhZ5k45p/yNw7BITAzB9ns8lxGVarJBoBYOe3/tZfiP7EkzRpngbWIlA1gQn0I+9VNKWNqbPTRMjU5klmipQf8BJT+OgAV3VxakDT4T9b+3UAbmTYzC9v/zuz2fI2RqmZY6m3tlxCKCnHXfjVJr6cvsvHBzS9jJVcUAO/9MtwsdLeOzvisfweaqgQ1QxkKESjImjTsWal79SJuqJNtyQ0rnlBsTZ/VGKqs2WV7ZKUtuzkNIQ8ypwkFcNszMDsJS8g1QK/JLNQP3duqEnhY35o2PFS2XrwlCaqUMOwulib2zq6pd5Q3+4YUVNb3C0ejzvYYweBs4dgNKV2kjQZdU1BCHPqCVUuVKCH3M3uRyjMwuocAaQfe3NkofajgQUKj9H1+kgWUSjh77CswnpuzCiaGe5K3eWt2rtd2eNx0ZdEO5ihJi8NtTcMaaF7Q3vJhdeXoyepY9G1UqP98VNwWAqSIrMg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a80a1551-4b02-49f3-2c14-08d872e4b7d7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:33.8345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O/j+fjHjvsSfH2B+DyJ7xzBtMNBDXnMkCEMdl9ivR6XgoB5/UUR1yZ9Sn2iRPuBK6Qwj/Swx+VpwDPxTJGfjeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
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
is the protocol overhead it incurs. So why not just perform the
reallocation centrally, which also has the benefit of being able to
introduce a common ethtool statistics counter for number of TX reallocs.
With the latter, performance issues due to this particular reason are
easy to track down.

Christian Eggers (2):
  net: dsa: tag_ksz: don't allocate additional memory for
    padding/tagging
  net: dsa: trailer: don't allocate additional memory for
    padding/tagging

Vladimir Oltean (11):
  net: dsa: add plumbing for custom netdev statistics
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

 net/dsa/dsa_priv.h    |  9 ++++++
 net/dsa/slave.c       | 68 ++++++++++++++++++++++++++++++++++++++--
 net/dsa/tag_ar9331.c  |  3 --
 net/dsa/tag_brcm.c    |  3 --
 net/dsa/tag_dsa.c     |  5 ---
 net/dsa/tag_edsa.c    |  4 ---
 net/dsa/tag_gswip.c   |  4 ---
 net/dsa/tag_ksz.c     | 73 ++++++-------------------------------------
 net/dsa/tag_lan9303.c |  9 ------
 net/dsa/tag_mtk.c     |  3 --
 net/dsa/tag_ocelot.c  |  7 -----
 net/dsa/tag_qca.c     |  3 --
 net/dsa/tag_trailer.c | 31 ++----------------
 13 files changed, 85 insertions(+), 137 deletions(-)

-- 
2.25.1

