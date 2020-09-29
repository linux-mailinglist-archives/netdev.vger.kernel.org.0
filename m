Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA05C27DBFC
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgI2W2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:28:03 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:36622
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728041AbgI2W2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:28:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idNAohVxKA5d9g6XUOk2Of+WnErqSq6nZmN6xHXXjNp1rQRPmDx226npjfKfZTM2RL8mnDqcSRSKlbJuefZldBRAeYHiIoD0aA2S6CVMZcPryQ5K6eqyxR45m0Se9ZZW13H56j5XQlFUbSgNm8hKLR8dbBwp3F1MknPwj86uPuB0p+pdW5qdoDjsrEohIGFcK0ymFR0dkKDb8q9R/eJTftzq3dJlsHu4wNnbJXU9gWTI9wQK9qCtp2uyh1jhMbuH1wppKMWPaZD2YHrQUzn0HSmiqhe82Jr0fr5+1n0WTLjtVCOZs8Wey0CnRKzum0tqHWW6pb9yS6DdbGfSq6hmKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dz2P61+bQ87ZaL8AAvxrcSnlu2s0cwRBb81w/Z/TS9o=;
 b=cnZg9caZ8Ooo2rXGdPpJn4iy+Ay8jRvaugR+CQU/2W5GOcxkgi76qTrOtqmVmQDRGEAZuKrJCF/grHL4Q7Nqw3CAjWyVbNefN23LADL2t9+LcJdK31ADhdDSvv+E57iiXdaAGlfnDQL2DRMKxS5H8GiL8MB4HAxwADjdqMERS8QOHy78vnm3CxO0q52rBmn5cBwoydpBm1Y7gvbQ/U7PGDkKvvh+cIvO3Qnzhvb8tla5TSmkfeMG0O2H6i3LtlFmoaakNsInEgcYpFX5Hr+F6UKHqH6BPu/IMZwGZf7LT8L66MF4SaSbfs3aXvAhXtTMdjdtXktImqgtQeFozHjCxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dz2P61+bQ87ZaL8AAvxrcSnlu2s0cwRBb81w/Z/TS9o=;
 b=Wp0SZVGjlVtimpJsKKoh/aot1yaUX0EDHoIJSqdCgsSM6fB1OLrUFfBXzIuM9dKrDQoZqVWfaaTgehCNqd7Q296GWOTbH5xikLqL1pf7ZV447Hpue2l3O2q53Qw1nOLQB4lXLKcHyjMY9bQ6tq78GLOC3Q0n4M52vgAje9egjj8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:27:54 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:27:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 00/13] HW support for VCAP IS1 and ES0 in mscc_ocelot
Date:   Wed, 30 Sep 2020 01:27:20 +0300
Message-Id: <20200929222733.770926-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM0PR06CA0126.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::31) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:27:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 90a1db73-e0cd-4981-e902-08d864c6e894
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2797811BACB98E3D2CD93E5DE0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KzcMIKZLXXjIhX24EfuqjdER/R+bxR6M+j2uisibZp9BY+y8idGi0Xj10vV0FMMng0rkP71kWME94EOG+azpBRVdOUxP6ajdUXVJQ2K3P8PIgqV+lwcDV/PFJuZmqsoA9IdURVSi6EU6rFKxOlZlzf1zXMfgpV+dLREUJZiI2aMQLyrHg4deh2N53wXwtEI7W9ER3oVux6k8HfMKR67OG22eROCOh5UQJf+zr9yt53ND0tWOdIHVJP20xzvQEYX9fUSs1RUP7ldkME/6XvM2eWzYpW3mKMJZmk+xqpxkNCeTFFfzmzD5YTwDvd+d/1fp5AEsZQcMO7TYLqranW4h57wBDsmXgWYijCI3s/7g1uqHcZdFpJ7B/tduEoaqmAdaNu3LAetRV5HYpuETXXtNdm6xdwNF6us7NC+IwBl7YLvjS5Nb3gC7/S5lTLUm0C2OkljmF46gxU50B0gcNybg1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(6916009)(86362001)(66476007)(6486002)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(966005)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: W9dU27GSzXyo1XmKFmfvsQrdxYfAPIJ1wB/e0bSPX589i9nb3Rmb7SeU5k9GTzQsl7LpTiNpms0QvVg6KRaGtoST/5n0qBR/1pP55pf/LQldMaBxolZglCtuPrD7Ht7DkznzmYpDewSk4PMiVyUiriTVKxLfqSdJvo1FsnytOZ2MCqekv56ZrWT73ootszqlTYeGAGO2Q+vjoi5d8eEvXedOH9B2xRzT3bsZrJMQl8bkNkFkU55UEE0RvHgxsotVYxetd7T63AxjAbkgDhX6SJG4eXSj9nlttsMQfKVR/HM/4W5ei31gvPAMy5kRpcrEWbOdCW7m7NrIT522ottZbTXmzJ3EzltpaSkeh0ZFBHnkyeEX8Wn9P3e+/+7DjVFsBQIOHIvSwztTCC0psdQuvt3BQHz9WGS7y7aNGdetkLk7f9WbNja6WplqvWzS2x1rbt3X2rfCNnPc3IZWOEK2n2x5GhInNkPAyoFLpcFLnoHMDG2boIhg2ztLLmnK72W1Ct8NOMFvV6aCNMnMmUuBOdmzLMkPiAlSREy3EmpjzGLl+3qQoXgWiLgCBUfeahb7vwjDxGrCMx9RaLMGPiPlPJVShMS+DlUNAFFhxqvq6seNkaP/eQ0bTa3yoHBkA62ClGEsWf+lVJb/Za+4d1+M9g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a1db73-e0cd-4981-e902-08d864c6e894
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:27:54.4598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLXA52NW0+EIUzLg8eaZ86uJ7PLrQ6SSDeGFRb2pm8rOL4cZhAw/re+eUTEICUzHMh/6aAGZWpEkS0EegcYQ0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patches from RFC series "Offload tc-flower to mscc_ocelot switch
using VCAP chains" have been split into 2:
https://patchwork.ozlabs.org/project/netdev/list/?series=204810&state=*

This is the boring part, that deals with the prerequisites, and not with
tc-flower integration. Apart from the initialization of some hardware
blocks, which at this point still don't do anything, no new
functionality is introduced.

- Key and action field offsets are defined for the supported switches.
- VCAP properties are added to the driver for the new TCAM blocks. But
  instead of adding them manually as was done for IS2, which is error
  prone, the driver is refactored to read these parameters from
  hardware, which is possible.
- Some improvements regarding the processing of struct ocelot_vcap_filter.
- Extending the code to be compatible with full and quarter keys.

This series was tested, along with other patches not yet submitted, on
the Felix and Seville switches.

Vladimir Oltean (11):
  net: mscc: ocelot: introduce a new ocelot_target_{read,write} API
  net: mscc: ocelot: generalize existing code for VCAP
  net: mscc: ocelot: add definitions for VCAP IS1 keys, actions and
    target
  net: mscc: ocelot: add definitions for VCAP ES0 keys, actions and
    target
  net: mscc: ocelot: automatically detect VCAP constants
  net: mscc: ocelot: remove unneeded VCAP parameters for IS2
  net: mscc: ocelot: parse flower action before key
  net: mscc: ocelot: rename variable 'count' in vcap_data_offset_get()
  net: mscc: ocelot: rename variable 'cnt' in vcap_data_offset_get()
  net: mscc: ocelot: add a new ocelot_vcap_block_find_filter_by_id
    function
  net: mscc: ocelot: look up the filters in flower_stats() and
    flower_destroy()

Xiaoliang Yang (2):
  net: mscc: ocelot: return error if VCAP filter is not found
  net: mscc: ocelot: calculate vcap offsets correctly for full and
    quarter entries

 arch/mips/boot/dts/mscc/ocelot.dtsi        |   4 +-
 drivers/net/dsa/ocelot/felix.c             |   2 -
 drivers/net/dsa/ocelot/felix.h             |   4 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 192 ++++++-
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 193 +++++++-
 drivers/net/ethernet/mscc/ocelot.c         |   1 +
 drivers/net/ethernet/mscc/ocelot_flower.c  |  42 +-
 drivers/net/ethernet/mscc/ocelot_io.c      |  17 +
 drivers/net/ethernet/mscc/ocelot_s2.h      |  64 ---
 drivers/net/ethernet/mscc/ocelot_vcap.c    | 550 +++++++++++++--------
 drivers/net/ethernet/mscc/ocelot_vcap.h    |   3 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 184 ++++++-
 include/soc/mscc/ocelot.h                  |  59 ++-
 include/soc/mscc/ocelot_vcap.h             | 202 +++++++-
 14 files changed, 1140 insertions(+), 377 deletions(-)
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_s2.h

-- 
2.25.1

