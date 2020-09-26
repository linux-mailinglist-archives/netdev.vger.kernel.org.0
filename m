Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A523B279B62
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgIZRbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:31:24 -0400
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:62990
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgIZRbY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:31:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D72oodkQRskMkdHbW0XFWGKT8trc1nShQ+O/mF0//DLvw8FToa5HfOyYFzOKjlw9MY1X3eNktpOmcjdU+y9Ztux9YxZjaFufzg/Ve+1xk7k4fmm3uEfGcTl8rCeHMtRvfHy6+iLUOJxV0ZUBuZ6WgPNQmMi2A6lG+mHjGDtxvXx+g1wVDU71JwXYmPCjE5bsk8a3Hp6eZwFuPh7lc/gmBNSnfjYgiP3ULundy1zHgEDEpB665og+yd7MtOUWlb+XY2TpzDxiU8jy5s6k8IStMWLlJd0IVdlWd6DjTfy1y+MDSX2yOPfby1uVX0j2vTlCcFwjlswLux8als46njFklQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qom0f6CrtykjKUPVl5Gja++UmrlWBsYU83LSbhSJ4dI=;
 b=XNh3/ga+gHQUBkaYNx+F8G+hOAPVEGuqr1DTqI2VLetZsq3qUyAiA/0zRqJ3RoWttS27azD28zpHJCAQ+8xrPkzswYGpylBU5eudtRS02xE/je6s+x5lSpQ9G+Lz7elX2gLARaPshqpli/g/bkVdycxv1J/vUarcPJAwlrkA4hY0KqGQEZX9n7rv0N19x7OjEvk545KLcH2hqoygxaBwJR+qYzZBiyg0TSC+NMlonFW4UgxMJkn1ZfOrIj2oBPcoIhnceKe3tbmKB8EpcaqBV1xweLqFYSMNqt7jiPXzAwvF/7UrVG+ZYA74oyiwRAW3BFGC1Y+jZ8J1QPlrkNTEHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qom0f6CrtykjKUPVl5Gja++UmrlWBsYU83LSbhSJ4dI=;
 b=a8Q0KucqJjZdofA+4wea3JSQnDEhDgz+aJrHBsBa8dQUc2TUNVzH/aQvmcaEQIYZR8m5LxzprZMTf8AQzxp9kbpKeLgJ8h8/6cIzRFQaq/x81iYnGtxSIcA3jAHCsczTSjdM1sXZ+65QTcJGSc38im8xshFcaOYzYrqP8PVEDQY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:20 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 00/16] Generic adjustment for flow dissector in DSA
Date:   Sat, 26 Sep 2020 20:30:52 +0300
Message-Id: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0095.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::36) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:19 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 399345db-9138-46c6-ffa5-08d86241fb33
X-MS-TrafficTypeDiagnostic: VE1PR04MB6640:
X-Microsoft-Antispam-PRVS: <VE1PR04MB66404FEBB5B4984114B3A078E0370@VE1PR04MB6640.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m2d7vvPTzMysfwGFUtKsgOKLFG3t2S7OoxPANJXXUIWfiUhhZFTaDsqM01CDj/Kq0omoxVPEYgUu697Wk007JAbRCbeLgzsRtADqcJVnUcfhD4rIV5M/a2tMqVG7BSVpTta60xdn9BknYZ9VhM4IC5dvgZ9qmCyL6LszJkoK2QPxbzqM/x49oeb4046o2jVkoNIKBl94CDENpQgY78OrXpP66vmzNtiSuYhWgNzbZm5buXcD/U2uZ+hPBqUiCTHAbJCgJ3r3zTYDCffeNe2TzDzIgE87AsCG+P1A6RgUkOfZAwTC1/4QsHL8w/Zl9VIKtIsHoiamBeFYI/WZc0BWlgMOmscIEv0zwkDWFJhSvJ7PDEMwt9O4rPwuvsvHhwTxXJhfgby7NDLl5qsv+9n/DQ0+b/FUJN6ILUsLRCi/0O43BIcWfNC/mLRRQBptKvDDSz6bNmJr9inacgvNTJcirhlTLXRJEJgD5FB5JVbX4RjVV0K9AtjQ8Xn0qFhOvSWz6DsVql2iFyidpbcrBJ2Htkc2WiUnSsCUIxOBi4XXpGs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(956004)(8936002)(1076003)(6486002)(4326008)(5660300002)(52116002)(26005)(6506007)(66556008)(66476007)(2906002)(8676002)(36756003)(6666004)(44832011)(66946007)(316002)(16526019)(186003)(2616005)(478600001)(966005)(83380400001)(86362001)(6512007)(69590400008)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: v5DwrTDtg2+ERUXFZe3e4lojMgmt40+8dbz0v5QV93tRS7ioDktyj5YpoEIt4A1pv1xolWuqyVCkTpmKDa+4ug9XDlqgaOJOy8sq9AQzuvLX0XaeFCbwqZBqB9+0ZN1fuGrJsGPZffCVMJhMDPbGfw+KFK90is6SCQnY7qiFUgBJpAvHDmL+X3oRMhWYpHaCi5sHZYwD3YMZPkvMWf7w+c/k87bgkXg4wnNoavYbhgPw8dNGjCAIr/IHTt7TwUqmlGSDUX7PMJ1DY79wdmMx4EXYMa1XDc7wXYZLgZg000Vz3zZSw04BIL0I8VteNkxzf5Zgq9eqJ7MjlQVszv03pwr3zwpyGgwE34OVfwlnrGH6y97kfO/16TtVhSzcrB24lBTXmhKukWRqzLC9B6W3UYH4Wrv/okbR0KYvwbBsV7ymT6hBjhIcQOcOxK9drkKeE1GUiJNumItz+kttm8U+HUtQDW6bh3uvzsyLBAjDvyqw2wgYmXx1U873EaMjZWDm/qeOlm/EJ4uApKDaRDXm+24n8UsuciBKkVl+ncAyUQMXioMDi+LSinGHJz7DwE7YZdKRbCReYZLwwoPce2CAOW8FVwR58m4Mkcody6E/Y1g6slGMzP8opdUedCtLT59a505dqT555KSLI0miXcwDCg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399345db-9138-46c6-ffa5-08d86241fb33
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:20.2538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wwY/ybzhgaE+wRTKCEp2C9TBfmroOZvPjHzjWGicnNKQMp3rJYcjCAas1rdUoo5NvYIPeweT+3y9X1tH+iuRMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the v2 of a series initially submitted in May:
https://www.spinics.net/lists/netdev/msg651866.html

The end goal is to get rid of the unintuitive code for the flow
dissector that currently exists in the taggers. It can all be replaced
by a single, common function.

Some background work needs to be done for that. Especially the ocelot
driver poses some problems, since it has a different tag length between
RX and TX, and I didn't want to make DSA aware of that, since I could
instead make the tag lengths equal.

Vladimir Oltean (16):
  net: mscc: ocelot: move NPI port configuration to DSA
  net: dsa: allow drivers to request promiscuous mode on master
  net: dsa: sja1105: request promiscuous mode for master
  net: dsa: tag_ocelot: use a short prefix on both ingress and egress
  net: dsa: make the .flow_dissect tagger callback return void
  net: dsa: add a generic procedure for the flow dissector
  net: dsa: tag_ar8331: use generic flow dissector procedure
  net: dsa: tag_brcm: use generic flow dissector procedure
  net: dsa: tag_dsa: use the generic flow dissector procedure
  net: dsa: tag_edsa: use the generic flow dissector procedure
  net: dsa: tag_lan9303: use the generic flow dissector procedure
  net: dsa: tag_mtk: use the generic flow dissector procedure
  net: dsa: tag_ocelot: use the generic flow dissector procedure
  net: dsa: tag_qca: use the generic flow dissector procedure
  net: dsa: tag_sja1105: use the generic flow dissector procedure
  net: dsa: tag_rtl4_a: use the generic flow dissector procedure

 drivers/net/dsa/ocelot/felix.c             | 32 ++++++++++++++---
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 13 +++++--
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 13 +++++--
 drivers/net/dsa/sja1105/sja1105_main.c     |  3 ++
 drivers/net/ethernet/mscc/ocelot.c         | 40 ++++------------------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  7 ++--
 include/net/dsa.h                          | 11 ++++--
 include/soc/mscc/ocelot.h                  |  4 +--
 net/core/flow_dissector.c                  |  4 +--
 net/dsa/dsa.c                              | 25 ++++++++++++++
 net/dsa/dsa_priv.h                         |  2 ++
 net/dsa/master.c                           | 21 +++++++++++-
 net/dsa/tag_ar9331.c                       |  1 +
 net/dsa/tag_brcm.c                         | 37 ++++++++------------
 net/dsa/tag_dsa.c                          | 10 +-----
 net/dsa/tag_edsa.c                         | 10 +-----
 net/dsa/tag_lan9303.c                      |  1 +
 net/dsa/tag_mtk.c                          | 11 +-----
 net/dsa/tag_ocelot.c                       | 20 +++++++----
 net/dsa/tag_qca.c                          | 11 +-----
 net/dsa/tag_rtl4_a.c                       | 12 +------
 net/dsa/tag_sja1105.c                      | 11 ++++++
 22 files changed, 164 insertions(+), 135 deletions(-)

-- 
2.25.1

