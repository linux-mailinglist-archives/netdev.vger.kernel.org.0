Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A79279C24
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbgIZTdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:04 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:17545
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730184AbgIZTdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRPleHNgGEj14d6yP1dwg85PxP+pQs9wPJkf8MH9toShcsZiPTlAOD4xp2/MhwiDd1fV7JwsXnwFfJ2lk2ZaFC98BoxxBpSrvkV4a0lfcJXt29pQuBCnhae44Tszz+A39NYrjJbl6qX85wnfrmet3rxN8ZXGEl72LA7tpUJhVzbdYpw8OTtMXjpiL/lKOwzwdzOar8OOBPOLtVHtL8dN3Z2GYstrxSEnnA4Js21UIXgKPmOnKUsP0WXW+Y1WAciCqzaXKSdPlAFWhf457l6b8WAT1JdPNNbrsSkyTG0xU1vev1HESoqL3OBIe3drC3dWs28abAov0OIW8K8IHwISqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sX01MZMHKQo9yxwe1hZB2a6hAfRrSeEXVMi8paYam/w=;
 b=j0W6H/gocM0uGtHq3E8tnSt/S5iLdLYLrRFPet3SFzB7yxSFVC1JNnBt6QWkaP1xJIaynh1v3A4zWAZ+tK94AKsyBoiTz9eKTW8jLVpHVWk9whGJcnB7uOkSt/WlviRkUZ+llQfKO+IdLKXLF6wr3lybYX37xXX1SlVHIMrWhy42WubS8ORfPDCldsh9DbGBcWSCFFE21lSHQECtQ0Hhdew+oO6WvyhSCHrUydfJ+fK1BMmj8r1i804Zyp9iIzv9z/DcrXDBwNiBH7Yxtt2XvMM9OusyUIbwnTeJHjxcmtmqxpWJUIHWUhWRrfU9UkN1CotJPxgIYd8fXfm7EygLog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sX01MZMHKQo9yxwe1hZB2a6hAfRrSeEXVMi8paYam/w=;
 b=ru8OraVLAOBuBbtL8GKp9JFh9CIfj1HbrDfQg29eq5SlDSkkI7gfNPgAAZndZPPdFHYUEpqGzLjjhPa/+hD6eQcusknllDXL3DARgot45niTaEtctfu7bgfKbr4rsNtVQM0zWSapUDjr2C9jW/Q+HxnylY+CEtra4P2W48pTbxE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:32:58 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:32:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v3 net-next 00/15] Generic adjustment for flow dissector in DSA
Date:   Sat, 26 Sep 2020 22:32:00 +0300
Message-Id: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::27) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:32:57 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fe9ec9f3-d2ac-4fd4-89fc-08d86252f90d
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB52958426057FF2FFCFD6E433E0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TAQ1f/5/4C1vU/yVOAdPYPQM9FgHVTes94v+y7HoVIVkhtfLv2cVWaedsDTsph2ZSUdUG12wXQ89EskXAbzl14vFoJ32u+vQTCY62RzF3ZMJWD1Rc+mRY1DV8hsdKZZfXT/ksUfQZrab9OqEQ4dNQ4tRCxSiwlFfAvSIY+QhEfskOtdxgR+t0Lyx4ecm8GnRtfXXv8HMNFWtIV54STNJtdj39lPW9KMxwbq3GTgbVGD4RT6hYXVC/DyDCnYvRXHGtOYyVq0taENj0f+dXasU75YnidecpF28qqCViyGuJrwJqQWmt3IcnDi82GFGz1mqLQ7HGHaL8wjAMb3q6ZDVNpkhJEvCOj0ENGirrVHN6h5V37lyZvhnxd5ej/mDjFvn5OlWDGAT+JrRbW4QiEtzlf3eJUdtkpT8KdmRg3Yk3tllLSNEiSAAlaOHLTaZtZW/aTK4NUx9nN0l3WwIk4num5padoI8468+vnIPEtfGF5aXpispNlc9kIxwSz2IF3VLZjEgUpIh4GJQcjhIZ6/O4q5qpGIcOtKubXcMMsfj/2I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(966005)(86362001)(8936002)(1076003)(83380400001)(4326008)(69590400008)(66946007)(6666004)(316002)(5660300002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6uozUHSYF6qjAsWfO6lzMvYaBLCku5bUXwPmVqOWS9uI4yPtXoxBiOO8YtmFKh34dP3iVFClZrHhQKa+ZJK+WxxZGSCHy2ojomHj0zodwbrjZocHA66lA1xco2Aci+vWgrF6NMj9HO4lEzirajv0qjDhk6i7C6LBqRYJxrQ10QRCzxiSSnUmlT20aGIWqD4FFk43bQ5YNcOyIi9BNInLTdgk0mBu8HER+nrKoq6mO/T1H0XN38MBcelDa/pT8EbyRCadGLoJm2hPTz2NoK0P47G7w/YdNL0IJ2QqHIIZXvoj0tV6lgVoFruM+c4oeCO6yLcuxJeWO+PvMB/sNir9uGgMpY9uBLt416hoqTNRWkET6D4BMLNYGdxsdhqeg6bqbs5L2BhrXGSQ/cGvi8H6rfeiyMBL/BAoZ3WHtDcTirfma0DCAB/Zz3Wu9rhn4xXOJPs0Y5DGtXTEfQ8o5lHxYzMYnH4905E2f0UOPCnjBY4l5DG5mhu2nANmV1QuGppEbx3E8sSxIXiWH2r3h9FbvyXEW3MbZRsyB1cxIbDzK3F94z0W9oQePslx/0/vekEv6mF3YDfBdRpmwkgB16HDf8MI7CP346jTIoGSB7KfEFzA0TD/JAI63ApSTk8ZekvK8h8Xn7ms7wAe2As3BBnDog==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe9ec9f3-d2ac-4fd4-89fc-08d86252f90d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:32:58.0688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z+ZRSgxBSfuxO/s+8G0Q7jkzBvyJPg3v2M5wDa8HzNDznj0SU4qlNiGXRlLYTO8HHC/zvYSLyvBWu3QCklIV5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
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

Changes in v3:
- Added an optimization (08/15) that makes the generic case not need to
  call the .flow_dissect function pointer. Basically .flow_dissect now
  currently only exists for sja1105.
- Moved the .promisc_on_master property to the tagger structure.
- Added the .tail_tag property to the tagger structure.
- Disabled "suppresscc = all" from my .gitconfig.

Vladimir Oltean (15):
  net: mscc: ocelot: move NPI port configuration to DSA
  net: dsa: allow drivers to request promiscuous mode on master
  net: dsa: tag_sja1105: request promiscuous mode for master
  net: dsa: tag_ocelot: use a short prefix on both ingress and egress
  net: dsa: make the .flow_dissect tagger callback return void
  net: dsa: add a generic procedure for the flow dissector
  net: dsa: point out the tail taggers
  net: flow_dissector: avoid indirect call to DSA .flow_dissect for
    generic case
  net: dsa: tag_brcm: use generic flow dissector procedure
  net: dsa: tag_dsa: use the generic flow dissector procedure
  net: dsa: tag_edsa: use the generic flow dissector procedure
  net: dsa: tag_mtk: use the generic flow dissector procedure
  net: dsa: tag_qca: use the generic flow dissector procedure
  net: dsa: tag_sja1105: use a custom flow dissector procedure
  net: dsa: tag_rtl4_a: use the generic flow dissector procedure

 drivers/net/dsa/ocelot/felix.c             | 31 ++++++++++++++---
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 13 +++++--
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 13 +++++--
 drivers/net/ethernet/mscc/ocelot.c         | 40 ++++------------------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  7 ++--
 include/net/dsa.h                          | 37 ++++++++++++++++++--
 include/soc/mscc/ocelot.h                  |  4 +--
 net/core/flow_dissector.c                  | 10 ++++--
 net/dsa/master.c                           | 20 ++++++++++-
 net/dsa/tag_brcm.c                         | 35 +++++++------------
 net/dsa/tag_dsa.c                          |  9 -----
 net/dsa/tag_edsa.c                         |  9 -----
 net/dsa/tag_ksz.c                          |  1 +
 net/dsa/tag_mtk.c                          | 10 ------
 net/dsa/tag_ocelot.c                       | 20 +++++++----
 net/dsa/tag_qca.c                          | 10 ------
 net/dsa/tag_rtl4_a.c                       | 11 ------
 net/dsa/tag_sja1105.c                      | 12 +++++++
 net/dsa/tag_trailer.c                      |  1 +
 19 files changed, 158 insertions(+), 135 deletions(-)

-- 
2.25.1

