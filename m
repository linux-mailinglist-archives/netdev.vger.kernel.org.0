Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A904681A3
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383944AbhLDBEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:04:31 -0500
Received: from mail-dm6nam11on2113.outbound.protection.outlook.com ([40.107.223.113]:36640
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344497AbhLDBE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 20:04:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2KT9dflixZll5EdlOsuu21tEtGNXa+8+DyveyqEWeZTHawA3UC64OlVlmo3idzyEOwj1IeyKDsQbjR9yjZBacqWWnR+o5afk5g2gAeKZ1LhEodfxyMTHphO4FUHUMtoui7MPJiFjIexQhI5Z1NhT49xCLKemmb0cx9w6hlArUDhaMIuU7mJkhXAg5P4ZT3FVJIlbe+fhMZqnTE43HDOoFWh+VRdJSqNuqOR9ax+dAh1oyqhuctXDPXYS2FC3gzh7b6vZmLfRqHzqKRuTFMxZNY1Vegv1pVuib7ZP9uZpY+0/NJhXf4L3ZRW3QPfzCty6GPTb9NL7iM6RmsVyX8Qpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJwU620m9Mk1MhNQMo+vsDMwLygJjLul3SUyg4NOc2U=;
 b=l9sAAY2IlPA2j+xfcr8lKvJliUak+dFBYvML2qxstrWIU9tsigppC4ZIjl0LdY+SEI6rXdEKtSMxHHXfOcVbYNAjGTI5g0yg3t0VJYE/86KvPN+3XybLRtErq8IIPAqk7Gji959rUtLr7BVnpBQdsC6Fx10uoppItwJC7pHd8aYkcqYmBjG1nUJcG4Nsowr5K+3LZim06I9g6+877g7Y/mPQ+NHUpLqFQ8yTJ5RfYK5UXdk/4ywCxKfr5QEUb8rAIr7b9MzjPPnyh9ab5/ECvdbHEeu7jzS0HuaQ4+n2boZYMcxuQQDBiWJ8jKzd0bM32C888mcz/Elb5Qv2EocJqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJwU620m9Mk1MhNQMo+vsDMwLygJjLul3SUyg4NOc2U=;
 b=rLs1xmXc+u+dQ5fAxlO0nVbH/6eDOfWlmUaZZCytZQCYsfonvGo5Qr/MJIymE8CTjqAwbZdicx5uPFuPmSSa9Q36v9gULb0BjB6n6cFibxtPabkITy936538+g5Vd+humqioVnEvONeUyk/xtYaDkjKzsEY4spvMywow3021v3g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5701.namprd10.prod.outlook.com
 (2603:10b6:303:18b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Sat, 4 Dec
 2021 01:01:02 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.028; Sat, 4 Dec 2021
 01:01:02 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 net-next 0/5] prepare ocelot for external interface control
Date:   Fri,  3 Dec 2021 17:00:45 -0800
Message-Id: <20211204010050.1013718-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:300:4b::30) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR02CA0020.namprd02.prod.outlook.com (2603:10b6:300:4b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Sat, 4 Dec 2021 01:01:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6da3fbfd-af7a-4637-96ee-08d9b6c18ad9
X-MS-TrafficTypeDiagnostic: MW4PR10MB5701:
X-Microsoft-Antispam-PRVS: <MW4PR10MB5701D505BADE758C36CC773EA46B9@MW4PR10MB5701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wMB9jrJjHE+la+8KFjCprXGi83YH/9/vmPXB9PPu34BLgXDeu7NTnk5d+d/T7t6v43KIUMhiGL9Dq3f2IkK6dJ51MVSo9RH+f3dg34DDtsVr35BtkNl7OfHqXe1UJSNHchJu5advOdgX+itxtG5dR8QsKys+0/L17HtLeuX9sgSGlBm6RVdAeTfXenacWV+HPdAk1kRSmWD9ZL7Dd1Anq8RzlFZY4ccHk1F0aChulFPlmuk/jmJz3fG3BJ8anFoIXzOZX9c6IN1ycr26tGFsCsjsj7kdb/LJX/zEy0YsKh0U6xMH2HFXf/RNYlBKVV5KsGAx+Ftco1rhD38j6IGPGZhFksi4fyBZw7tUKYox3VbkVG/9ixbMtSpRZqAkiyeUBqctQouTqGC7MoR6HNeJxb/rH9AA7BGOWK1vXolMd7kQ3/cgT3KKm2zaQ6+TIeU1imZsMuhmvqavOYqmsTxogrVV8cZYq97xAmTPgx/vfajXa2MsLHKyEYsDtnSpq8J7E566q/Bbc3eNKyDILkNfuo/0mfmyuzjY1lkElLXH22T7h6hEqxg0yeWY3zcrzmRbQzu27OIthpsjXa/87mdf+04WZz98vatM9ummTZeJGfFxREteqw5DATlOonbpXotTQThlCP6/rfhMjATnFLAyb5z5Lg4dXwiC7jikuyuR4hTSuBc2GWBaaSBkfsC1Zf2r9Vbm4WeqKQra2VjnxaD7VQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39830400003)(376002)(346002)(5660300002)(7416002)(6666004)(83380400001)(6512007)(2906002)(8936002)(66946007)(6486002)(66556008)(1076003)(66476007)(316002)(186003)(8676002)(4326008)(54906003)(36756003)(86362001)(38100700002)(44832011)(956004)(52116002)(508600001)(26005)(38350700002)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HJHiCX2zHO/6h0XpgG9+9U3AIef3t8+cUTJIlemAx+e396IC2YYbbv58w3EB?=
 =?us-ascii?Q?ZQ1OuupxhuI1A6MHHZRl/VrL8wlM0fPtn9ZfsDIOOBeIOR4+plfOfu1umEG1?=
 =?us-ascii?Q?03ZjgC3MWej+lwSLlx7IjOyLvRi1aXDO5e+88HyWmJ2wk5xyJ2oz7aUKBJrZ?=
 =?us-ascii?Q?M9iJipDrftC7UEpGf2OTavxp4X950XdXRPO5vXgNcF6C/TG9ZECND1so5X3A?=
 =?us-ascii?Q?s48GTS/pIfIit1CWW/DEvuNvO1itdzGnafGb7g9EBp/Cj1RqroLA0VOWecjD?=
 =?us-ascii?Q?ClHUadIwk3Uh1a+jcvL/QmZp3k5PX8BK+fTTg/dH01F8iXVP1VgmJjXvEytf?=
 =?us-ascii?Q?XLivEepwMmsmZrw4oXDq8lG6ub6tfPV0+lQ8iwECwwhL5153Ubgkk9ymTF+s?=
 =?us-ascii?Q?o6UsHU6g9Iu7vowH9sLYibeK4jzigXdqbX1PaV9+OLcgeg425PFffR7rLk+R?=
 =?us-ascii?Q?U7DKejWN1z3pr+FVA2nJRGodQEGEn42rnbPdJGUTOWnZxcpnuol63LqkOHDx?=
 =?us-ascii?Q?gDEO8YQ/2EGqlc+YP5NisSZRrsFjtG6taWKSK4DF1RU0HRnulBTlM6iMZTT5?=
 =?us-ascii?Q?7eZyxYqSdvE6kmIGPNqJt4Q9/5PxBRf9cO9IjucLWkLhxsszD9ST243MhyAV?=
 =?us-ascii?Q?Lhfjhr7136PSUphZkYdypB4vf8m8RkeS6SeWEY1PY7CgDw7jwPQP2YacKoRf?=
 =?us-ascii?Q?SUd6nXdYRNK60V1Mtilv0RH2JQ1UGKM+IhJZz3E7hVu+SkPdLglVY1n4GvwS?=
 =?us-ascii?Q?qq69Bj39ltIU0uLTu3zsSy2hO1qd8v6Iqv9kuwo/muT8PS71w9Vm3uc/TI2U?=
 =?us-ascii?Q?g231/h35iiyiDbL2QqHKk3wu5WoZCu0fUskz18oBaLZOnzENcGDHMBe/KSUl?=
 =?us-ascii?Q?u4XBYTx6okwFAKVcpPauUlClcIeoZybrgSo7wNgBFu+oYY8dTBewaM5Tz0yz?=
 =?us-ascii?Q?CGFsCQPoaEPLjKStfwpWz9ugxdO9bkK6qo8khWMC+MMDMxJNbUkfaJWaPsq3?=
 =?us-ascii?Q?HyrNFeChz/YSEuIu5FJKvtQnMUyVWbPIEIKvHiVEeSSB8VFXGVyD39suefe+?=
 =?us-ascii?Q?KXj0jF3wpiSiMSjtsyciwKIdk22G5Xn43sMMU8/iUxjnHx6dVScEf/hpHhWq?=
 =?us-ascii?Q?mIKcqG3aXafGlRA8UGlkThCAaMYpU6LKnBdhJZTovbBqG1xgoAQdRdTbZQ+p?=
 =?us-ascii?Q?UzyS9cne9gxsrq28T7tBCC7PFTTOkh0cX0GG1CZUoZppLxiuVX/s4tVdS3LC?=
 =?us-ascii?Q?yAbqLqd4G5UrC6ct4oeWwHxUUJvCMGTamWTQzTvY5fiCkZeXt5ZLZT1Vj+VK?=
 =?us-ascii?Q?0/EAZkZfNVcnKgzWbYkknSlmPlkCUK+0Phl3uZYDCpjSb3hl6DAgc0iDXN1+?=
 =?us-ascii?Q?ZnRdISNhUp51GOxX+7K5BOLjEQ7tU1/8P32EBUNqIM8nZ+8jM9Cr7Wr7KTJw?=
 =?us-ascii?Q?hTaEj1XSiiJHyFLRc5T9g5B3gOPxoF8egxjkZJp+JQ/aNxFTaVyDC4+51D0/?=
 =?us-ascii?Q?8f3oKttawACfInN9yKIP/6t4P5okDc+a2vVTVSX2yxwG6nz9f/IwsECGQGOR?=
 =?us-ascii?Q?p2kYhlv5rIOwaQ0AUyTrImcLaJCuk+q5f1yYEruzbqKEIUH1QO/kHUGemi7Z?=
 =?us-ascii?Q?lMWcHJ5Oam489Vuo7nn2S5Hfp3IdwbWi4BjYmLQ5kC517oAwAr75fUTHvxEj?=
 =?us-ascii?Q?ESLDhfCiLUwbqD6D4eAHnFd6e2U=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6da3fbfd-af7a-4637-96ee-08d9b6c18ad9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 01:01:02.5774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P4F4iRwnIEL2gAwYSuA7g7hdThKwa6tp/VZ+CqZ3Usg5tjZ56WP1QkGMxA5PljsBUuuuXifhCvVBPIpDWwCMxI+EvvIWcVAKc1pbLakMK3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is derived from an attempt to include external control
for a VSC751[1234] chip via SPI. That patch set has grown large and is
getting unwieldy for reviewers and the developers... me.

I'm breaking out the changes from that patch set. Some are trivial 
  net: dsa: ocelot: remove unnecessary pci_bar variables
  net: dsa: ocelot: felix: Remove requirement for PCS in felix devices

some are required for SPI
  net: dsa: ocelot: felix: add interface for custom regmaps

and some are just to expose code to be shared
  net: mscc: ocelot: split register definitions to a separate file
  net: mscc: ocelot: expose ocelot wm functions


The entirety of this patch set should have essentially no impact on the
system performance.

v1 -> v2
    * Removed the per-device-per-port quirks for Felix. Might be
    completely unnecessary.
    * Fixed the renaming issue for vec7514_regs. It includes the
    Reported-by kernel test robot by way of git b4... If that isn't the
    right thing to do in this instance, let me know :-)


Colin Foster (5):
  net: dsa: ocelot: remove unnecessary pci_bar variables
  net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
  net: dsa: ocelot: felix: add interface for custom regmaps
  net: mscc: ocelot: split register definitions to a separate file
  net: mscc: ocelot: expose ocelot wm functions

 drivers/net/dsa/ocelot/felix.c             |   6 +-
 drivers/net/dsa/ocelot/felix.h             |   4 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  11 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   1 +
 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot_devlink.c |  31 ++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 548 +--------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 522 ++++++++++++++++++++
 include/soc/mscc/ocelot.h                  |   5 +
 include/soc/mscc/vsc7514_regs.h            |  27 +
 10 files changed, 609 insertions(+), 549 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/vsc7514_regs.c
 create mode 100644 include/soc/mscc/vsc7514_regs.h

-- 
2.25.1

