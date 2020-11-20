Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C6B2B9F36
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgKTAZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:25:03 -0500
Received: from outbound-ip24a.ess.barracuda.com ([209.222.82.206]:51990 "EHLO
        outbound-ip24a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726324AbgKTAZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 19:25:03 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173]) by mx6.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 20 Nov 2020 00:24:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eo9DSOJi6wcOnggecLOQZUSnoRBwT6wZGfviloVAVw24Dupi4MdcwgE/XCz87btWMcRwRWQsIXqhj8l4059oxxIx9QMeS665LAlkWioOIX6rKKv0h9EuMA4czPa2yFP/moqdCAH702OKNMGRjkLesUYLZSxKUchAU1UZxpPwWRyk72ix7mc5SpwRH8/1SJEPXLUYEQVdBjbDdBZXudzSYYJPCBxr6HF0W63q6beRkGklfZme/ZR1XkaxaGVflJ6ysjT7uXGiW68EyUUSXQWXDmNmXnavNjHMI1S+yULqIzWRd1bHzeEzGpvcGp1v/tcHyQs5uivGaYqzaVdm1DwQrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nV9XeP5SME9Szbo3AF4i+Xl8CFND9DXojnVHKX2D1lQ=;
 b=nI9ZDW89FKsBfA1LxVZmahnPKn+Kx6hYJU+Sd5Oe2LehvG5pV6UWzBG7aGBtYfNVTYVqf59TdJHCeMRkFnw7062k1L/Sn5akFJteWzQYEkh0V2nssGTn6BYdtlQWW3mOnleqHHrfs4HErGyJhnjqsTqWGh3JVoWTCFFrZjMlAMu32vFCNnLKmY7XysIzNUfaEKzUCY1cZ2nIHc4bTByZmLoyKj3owNhGIXAX7Z1CCzvhAEB6SoLkRymGkssfIhtkBPD7C8VfOk39UcZ0VaGPnuFbi8V2zXZGyZBLQ9xqAfrduM3YkZp7oqlYsoPnM2arLhSgGCbblS+YAX4xSCViEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nV9XeP5SME9Szbo3AF4i+Xl8CFND9DXojnVHKX2D1lQ=;
 b=kIkunU5TIVTnPYGSXAfS7rUl+as9ws8r1Y04mQcHU5/oHW5Xk+lJHelqRqmdBoZIWjWlAQqDZz6c4QwnNEptUx302w0WF2Mnn0AfQ/lbJHZK6MnG2Lf5F/sJPtPZGjeyGq9uaS6UVI9jTZUlgPumKF5O4vN0pS+vfefzZDd8PqM=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by BL0PR10MB3443.namprd10.prod.outlook.com (2603:10b6:208:74::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Fri, 20 Nov
 2020 00:24:39 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%9]) with mapi id 15.20.3564.028; Fri, 20 Nov 2020
 00:24:39 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     lkp@intel.com
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, vivien.didelot@gmail.com
Subject: [PATCH v10 0/4] Add support for mv88e6393x family of Marvell
Date:   Fri, 20 Nov 2020 10:24:11 +1000
Message-Id: <cover.1605830552.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <202011200314.9VHqJ9Lm-lkp@intel.com>
References: <202011200314.9VHqJ9Lm-lkp@intel.com>
Content-Type: text/plain
X-Originating-IP: [14.200.39.236]
X-ClientProxiedBy: SYBPR01CA0025.ausprd01.prod.outlook.com
 (2603:10c6:10:4::13) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (14.200.39.236) by SYBPR01CA0025.ausprd01.prod.outlook.com (2603:10c6:10:4::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 00:24:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ccf152d-4faf-4979-56e7-08d88ceaaabf
X-MS-TrafficTypeDiagnostic: BL0PR10MB3443:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB3443BF87818FEB2CD386839595FF0@BL0PR10MB3443.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2k+GNQvuR7QkohxL/1aOTO3ZQ7dEcqJu61Xk8ozvTZGH0aTLy73kZ4iGtYHjAfPFkeLMojVpF0Gt9aeJCYnw9+wyVTOb9EJhhVpC+ULP1p6eySbNSTooWLLM2y20IgDtbTcax0c3rk7HhkZD+Ib7jvyumti2A1DfqEmFAR6NfyxF3nurI0ELiKpxI3vgJ8PdRmuKF7muCzCcXANfoRTIwc9srSGP6Xr/ZapzQpvOuZvckjA27aENDPV/Zgk2/gjfoe5aeTtDgKEBdeMKGEEhL/rSVccVfkSfkkYuLwFtlxcADgSvgskF67FnDTnH3i5TkUYhE3osIgp2YSVz0NsyvfV6cH57Pan/Pch05vGMmJ6nvG7z0HiKGj77/9jkIzWQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(366004)(396003)(136003)(36756003)(6512007)(7416002)(5660300002)(6666004)(6916009)(6486002)(4326008)(4744005)(66556008)(66476007)(478600001)(66946007)(8676002)(8936002)(86362001)(316002)(2616005)(956004)(44832011)(2906002)(6506007)(69590400008)(16526019)(186003)(52116002)(83380400001)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: /3wHbaUYwLeGb/ozpi+F6Pd/aUgGANZ0DFe0AU3a6q/TQGeXF80yOHA3oHfMp7I1ZphE3lnI6V+HFACP2iTIVAZjiKFM3bF9+JcB36q0kn3IEEabYPhdMP4Xh222yrdIfMh1SldQTd3393SIZkk8Ok4CoYyW1wM1acs1UxA7JDd01VcTKDSPSjkExkem2FfH4mVgTZR535zfcpCZ3jh66+zBrWwjVPzsiFYfzRlOdugQObhNo6KmGr+J3ToPtT2nKi2+tXVs6px9ux4NcLajQgkbaKgYHqKlc0UgqpkQ9QYAVillZoPXXdLImXJG3yimEYcHOcqVpxJHiZfU0hZnvbPDmC+9YOYIy4qMpwtxQkLWkBuDWZho8M8zEoUeC6HfOC3euDSjVdOfe+znd07SsXGCugADvPbfqznlvl/b9bFAU6llw1yl2wvZBXHGtOjanLBnyXpBASlKYP/zm4nTyjUlJS6MDHfh7Ba68mCpQLE03Ymwp/XlUobRRd0nu+uhuYFIYLDb+4C/0hBTZwKMF0i+UY9IiJ1WNX0wvng3wJ7Anp7lPKWkT9iZEpD2zGSPADQPjtjQ2SJBYIbEUhtoHfBSXMDWcWWrpo/Mz7AaN+5ZveYQ6mEqwvBVgh1lvosLXiKSq90ZvVK6VxazMreL8/xB7xCobNRzULykFzPhqKJghxHO8OwaR3fndeHQ/P4Tid1Of+wHCcjFXrqou4Wdzu0tr59xIMXW7cho9eMtbb88UDzPPewjgcCjvg4QGyYsxRJKT37TJFFU1426F8byzBiqFiJfp3RRQtynr2Be/FuQij6jRzGuwJejivVjdsa3SQwnnpIqxifyciOZnCT0rSYSQNP3CTMUAJXPhpX6v/iveHF4Ob1oL9GU03VRlkcKaVyAa5/qfqjr/HswKugf7g==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ccf152d-4faf-4979-56e7-08d88ceaaabf
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 00:24:39.2208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3P9izK8HVgrf0GjoEVgVjgBo+yy1mKuvUECLbQ0oUG+MTi5s9ZndaXVeRE8Y7nxSyoURIfqBelJZH8onCINEvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3443
X-BESS-ID: 1605831880-893010-23782-640-1
X-BESS-VER: 2019.1_20201120.0004
X-BESS-Apparent-Source-IP: 104.47.59.173
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228307 [from 
        cloudscan14-219.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, MSGID_FROM_MTA_HEADER
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updated patchset after fixing a warning.

Pavana Sharma (4):
  dt-bindings: net: Add 5GBASER phy interface mode
  net: phy: Add 5GBASER interface mode
  net: dsa: mv88e6xxx: Change serdes lane parameter from  u8 type to int
  net: dsa: mv88e6xxx: Add support for mv88e6393x family  of Marvell

 .../bindings/net/ethernet-controller.yaml     |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 164 +++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |  20 +-
 drivers/net/dsa/mv88e6xxx/global1.h           |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h           |   8 +
 drivers/net/dsa/mv88e6xxx/port.c              | 240 +++++++++++++-
 drivers/net/dsa/mv88e6xxx/port.h              |  43 ++-
 drivers/net/dsa/mv88e6xxx/serdes.c            | 298 +++++++++++++++---
 drivers/net/dsa/mv88e6xxx/serdes.h            |  93 ++++--
 include/linux/phy.h                           |   5 +
 10 files changed, 783 insertions(+), 92 deletions(-)

-- 
2.17.1

