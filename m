Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463D4485358
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbiAENS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:18:27 -0500
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:24383
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236649AbiAENSY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 08:18:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oL5X5Juofas3kP1ztD9swL3syk2nxF/mlwqbaP/zWbP+4x9+KgpK9FArbPVhImsDQj4D0d0sxbYyIFcPqIt1qAcJj+7cJJaCK9ZoF1ua7TRSz9a6cJ4Q+acm8F1JvzTEWnX70ewChcYOWzZaI5pEypbcqSohtJTbWnO590QJQOXo9nsC301+c0qkKCVbMb4WbHGYeOnDzap2CBNACNfa3ALiDLhUkOmqP+uAsysopfr0xj6ymxZXV5kSy0qu7OOAmNpJ4DXIzmT6DR4GzbmZmeI8nldftt9iLqd9fGbGGQDNhfAbzE9KxzGls3QWi+eM3H/V6kPpdDMFrs1HPIaMXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/SvYTyaMx06Ige6807lV20kKrSHZqdx66WAPEkao57o=;
 b=fM6LdP1SbnkESapR0J8JurX8qDE2T/Eb4r+YAIcrlxA3sE6BswZ3Cz76tab/S77UIj5UZzae5jC/O0UyRgfc9Daj20PpkFhhWJyG/98PEHAPchNs5jaD1OMuoWBcpx+BigMZThM7Zr+Yipm6P5i3BHclu7Vn7E+qu3vakJf42kidD6BB2Ssrmex/IQNxjxQWqEoSFXvYv7YNE2bCMWwp7ZkIMKRHp7DpdmbcYSTaiMb6I9jIQSjt5Inmh97g1iqRp4r+2zC+uVxHuFiNAMm3gpOm1YCsKW1rcGnMK6ujl94YziCebE9Zv+BIyfjEk74fYqjlUjz/3adE0QW1rK65ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SvYTyaMx06Ige6807lV20kKrSHZqdx66WAPEkao57o=;
 b=aN7BuZjqc6IDQrTLQFR59tluEhocfU70hKe83GPY46D9I1of17prydROK57GZMPLBHQQBS8WyRKFKPuWpn5qlysGhRfRp8/OvOUTSGqoOenHdBMeIOy+BhRihcAzbJb1W+NcNG6l9vjhzkerxN+l1psBbLHeRlkLgBNHWpulNCM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 13:18:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 13:18:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v2 net-next 0/3] DSA cross-chip notifier cleanup
Date:   Wed,  5 Jan 2022 15:18:10 +0200
Message-Id: <20220105131813.2647558-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0106.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc6985bc-7e51-4ee0-1e7c-08d9d04dd951
X-MS-TrafficTypeDiagnostic: VI1PR04MB6942:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB694268AF8336DF8A3C61FA28E04B9@VI1PR04MB6942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dOLBiTgDZkQsbQ5zxTYV3dvgsOVo3PN4lnD/CI+xf51hcMGCs8AlcAG7UbYRtjtmbwlBd5PNBCIu/AAOX6aO69F1N48zsaTi+ZBckxqrXqgs6atQw9erBgJrbfjDn2fOlSGmQaJjFCZbBRewNrU2/ksOfbsSkKwikRnJaxCta++QFBkTFIG1J/CIOaHV68IslK/ubQ1o5J8JbDYbl9SN0NUi6xdMqZzHzEM8gjxdjteza6qG+1DmSffvb+vZM6E6iO5gLjxyqa+HJFm2A2cRpDvR32y8DmAZ9nGxHjltqyqEUxJ63TFkxvp/E/pbw+Ahv7nhC3ed8cvSNnhJXFjYbNzXrMPyd6BrAOzE1edOJIxKhO1nLc6A/mNyxV8ySZOqybV+qZJ3ExbE3FY98GHZn1eGjQyryqro5G00CDo0Q6ShRezLb6BPKS69uqFmIuS5UYhWndzgpIARNl7YU9ITXpPmH+q2bYMDzy/Yef52qTBmQDp0QkFIZGzFfjAkK6l6j8JS0j9+WD3l7XFLjVxVhv3GYR0qtdWW226V9tS+QgDTsMFr8a2msKEk0fSYZHr0lLJWwhq0yGPVIZKC2BfhBzWxYBVqcF98oiB7UG0lgQN84gGFxaiMsRymskL98J1Rqt0tPJ0RtaqkhM98XM474Ulitta79HJqE3PShX/QYiXqHIpE0OoOLXwfrC3nqgqXyxKeFQdfiIW/pP/NzHH3oQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(8936002)(6512007)(83380400001)(508600001)(2616005)(6506007)(36756003)(5660300002)(38100700002)(38350700002)(1076003)(6666004)(4326008)(44832011)(316002)(66476007)(66556008)(66946007)(86362001)(186003)(26005)(8676002)(6916009)(2906002)(54906003)(6486002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u2Qu8sZHdb1jAAgGs1VB33cjf75r7UEd/tg3otAfE1GywIj/bURr9VMrecaK?=
 =?us-ascii?Q?CcIHS5DuaYnlZAwqI8aO3qHBxlrA8ne6yukEizU5crsldNJ1ABWGT38Qv/r6?=
 =?us-ascii?Q?hxBUHfgZ0LlkBeCk4+vcwhT4gWIaW1rRkKSTqcEJZbIsRmdWdB9NKwkzy0UP?=
 =?us-ascii?Q?wSXkNigUxPWjKacoUT+nV09vVBPQnR263iam/EUAaDmKXDlasADd4ExMn4Af?=
 =?us-ascii?Q?g+l/giGick2DX5vwuNmlYep8nyCYRh0wNrA0wm2PWmu5z+S6KS5QQudi1xC2?=
 =?us-ascii?Q?hMtWSiyRiWVp+xERxRFeHMkZevR7FD8zwTK33izGoJ9vjb6Ag90K6O4EEa0C?=
 =?us-ascii?Q?L03S7aQ1g3ph3/OKfnYUu4PSFfEYnM1Q6gDOX/j2bSbIi2GspyrbsjoAxYgD?=
 =?us-ascii?Q?5+xGwEezZvRCedsJ14kK/L89innGrUA6dnAh00WnI6mFDkaOZnFc0r5t12AT?=
 =?us-ascii?Q?18BHuGk6WMWVDk9Yw5N0JaBGDID6rV3xC8Ybjll+jkuoevTkcxrCJy4tcf8E?=
 =?us-ascii?Q?rESNcKWn7YNgoiM7r2bhSyvhisHrD8j9T8/NvXDRGU5adE3NtaOkA7zj9pXQ?=
 =?us-ascii?Q?T0z/PHOHR7th61j0w5xasiwWUpOCHJDToj9G2refIZsNqRGBpMYJgQN3l1WA?=
 =?us-ascii?Q?n1KLl9NkQ111hKoOhB+6/9ovAA3d7m8ciCnPvrBcKOYMKeyfk2g0/x4X/jtT?=
 =?us-ascii?Q?1VxMIURcSxSrclJqrmecPNJjfX/7W329bF8FlhxfSp3ORTBzNfn3Q0xxvUcy?=
 =?us-ascii?Q?fZDAaB2S1CWcY9GijU7oiLSeB2LGNsa19Fho0cs1d6tr+Dus6Se99Ho798Dy?=
 =?us-ascii?Q?jQaRM5SMieSXNokz1WTsfu8evKQAlqc9bfx8Y8YPWVYK29MTI7b9rEPJhu9m?=
 =?us-ascii?Q?5PXs/8ZZ4p9kmzwONvXRSQP7LjplKA+UPP3IT28SfhxsfeCpiYm0W3Yr/3Jh?=
 =?us-ascii?Q?O7Q2o2hB2PwSwQkwXDg+bWwMBh1In/47J61vLRI24e5NcE8LIjD/tEIYK58X?=
 =?us-ascii?Q?L1UqyXrz+2AxpDDAX6nC6rrO6ed/qz+KDi6ldPpTrDyAy9KwBXcucDx2L99g?=
 =?us-ascii?Q?cwoBMWKwtRk773OC709D7PEbXZxtxIFBvkqANoLYHrebF1lNonWMhTqE9ayT?=
 =?us-ascii?Q?roqf7QEV7Aq0XKJofDGZEEAx1/umMm4FlaQmNbB4xWcPNqwhLY3lQQyXilXm?=
 =?us-ascii?Q?wWRojyeBQJNhKxUdLeVJlCreFpQf/oah1+vPEkxZgFmOb1yIdYpvLY94DtR1?=
 =?us-ascii?Q?MrhE7HcRv+5TKQqabxtCHxycBaqk8MWYq9G4Ssj4WhG0urBXOcFURyf7iTxx?=
 =?us-ascii?Q?ECbapYfF3Z6JbPKnTS/JqR3ypy6x+bq0PlNkmYUwM3AW5530FCmBuAYoBFKO?=
 =?us-ascii?Q?2IKcQ+6Xjju6u3iYK3WLso+fKWix+bo8S8dGd+fW/yoh92V0NUcBvKB8h6+z?=
 =?us-ascii?Q?amp80+CTdTF3F2GfC4vIlpudJ5lfjd5tM/PTgr+C8BmYIkMGRwbKNY4H44ba?=
 =?us-ascii?Q?hddCFgtOshl/87FohJ+U5+BXhXenk05Ds9vo76qbZhQfaHhAWXMvS47UrV9T?=
 =?us-ascii?Q?81qjD9XBecgfJLhPJI9/RzpiylxQrAU0wK7KLm7NGPUfRGYSujMd5meBj7MI?=
 =?us-ascii?Q?5g8OM5bPogZ3Mowg2diT4QE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc6985bc-7e51-4ee0-1e7c-08d9d04dd951
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:18:22.9166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dXCZOlNn0gC8Yb8XeoPddRRKW8e+eCJqdb4llSypz4ePlrbuRQccBtTYy88S5cBjtce0oMJXufOY0c0xSjeYYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series deletes the no-op cross-chip notifier support for MRP and
HSR, features which were introduced relatively recently and did not get
full review at the time. The new code is functionally equivalent, but
simpler.

Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: George McCollister <george.mccollister@gmail.com>

Vladimir Oltean (3):
  net: dsa: fix incorrect function pointer check for MRP ring roles
  net: dsa: remove cross-chip support for MRP
  net: dsa: remove cross-chip support for HSR

 net/dsa/dsa_priv.h | 27 --------------
 net/dsa/port.c     | 73 +++++++++++++++++---------------------
 net/dsa/switch.c   | 88 ----------------------------------------------
 3 files changed, 33 insertions(+), 155 deletions(-)

-- 
2.25.1

