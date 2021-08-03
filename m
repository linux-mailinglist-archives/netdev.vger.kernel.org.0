Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4084E3DF063
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbhHCOgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:36:51 -0400
Received: from mail-eopbgr140071.outbound.protection.outlook.com ([40.107.14.71]:65006
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236421AbhHCOgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 10:36:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnnDNm+36zee99EDaZ5y9w1rZxsXYpLvOGFqV31BQ+C9L55CiXn0KJ6LpszSZz32tmtOh9UBNWeaEmb+V2Xn5a9YB+5PrcmZq0G6dUKm2oAjc/rIDbsJyl/we+32jtWSN3LSAP4ZSnLmwEeZwJCbLXtHawuilnrrYgYqjexORXgBml2f3fomXJh7Yj3Hm0duWGVjYTiav7YuIG/ItTTriQVWeRrVL94u79ntzjcyuJ4bvbkF/gC11fSdaKsir5/C6uZT9pTxw4o3oHU8/zjI3/dKqEQbgS2DfxUndBQYqr6EGP8fLipbABzSIh8eP/RF2HFnNOW5LcTY+93RTYyNeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CIInQFhUIvGc9Fp/wsZr+6F94nSrzs2toRlY80F5hE=;
 b=isHZYYCHt7W7+LPQKsKJsLrUkbrSMAr06G5S9Bfzfjbwekwrz6jmEHNegm0v3NLgclUMSV2u1jdPpGC5R/FLDi2Kjz2twE0xbUpFno/AYisZsWPrviEbx+8InGsi0FwZvzVYlvX2prib4+YBEp5sONl85PmzIKpf3NWwRE8eqmikI3dkBH2dlzvhKak2fP+tGg6d4jYEDQ/eoef9bjeD363w99ByuJbdVr3LchdFbKy8jZQUhiT1PL5ueawbH+0V/JHFPL73i42BwKwB7yz2697KIwXc80seSVZ/QxCdZrUJe3UaCPzm8Q2ePi4JKdLmhBaDwkh5CJIAFfHuRwVr4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CIInQFhUIvGc9Fp/wsZr+6F94nSrzs2toRlY80F5hE=;
 b=TdNpMqCvPK1mP8/hSBj/kPSIzETcm+P3+iwpr06VKgRq9pdGOWOIJWlsUK3mMlh6L3ixf+MViej326MEMy87gt8KB/SuDWIhiH8s+0ODxqtawEvrvkYZAKCjHVu9JswgmbOrti56AsdpKq829yZi3wRB/M77nlQ83UkR1klZC1Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3968.eurprd04.prod.outlook.com (2603:10a6:803:3d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Tue, 3 Aug
 2021 14:36:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 14:36:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH net-next 0/2] Convert switchdev_bridge_port_{,un}offload to notifiers
Date:   Tue,  3 Aug 2021 17:36:22 +0300
Message-Id: <20210803143624.1135002-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 14:36:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbc1ca38-fdb6-4c25-4114-08d9568c193b
X-MS-TrafficTypeDiagnostic: VI1PR04MB3968:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3968A38260C2DA89ADEE0D33E0F09@VI1PR04MB3968.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yJlqWq8X5l/UeoaQLmzs/Yc0lG3OU9GVZJLJuWPAda3V7/s2I75JYMVQTkuuinRgX8OdxoP9BfcsvZihKVFxaL/j/mNihaL4YBQvP5pT0aebwAn6PGgyf7LEc02Cj5S5kWLOUFGFKIABblX2Q55ZPaqSEu30Y3AfhKAWwrPtduzWjcJZ2gepVb4pctLhJLNJRRKoYskG+hTLWrZTHPZuGutU9cgdxO1m40ovW7XXn2UAJOyd1rpBAC+ER+SOhHzj7qiDpwCX3oFkFJZ9Q8YbvbGtjbvSSJtKsufZjC90aPiYUemD1HdA+q+mDw9oPtfUq1KG8b0HzdvujSSqpTbRvGy2OjXeLH6EYtjjeIP40sfAnzNeouxhoaCGGDkXyuRO9dEm55ZzU+7x5KHzLMmgbOde2GNSTvrKUJNKS7Jo9VXul3Ic7aMdM/x/LTzX1rzhVFJyvKWoPjQ4E8MN/azP/QBjF4E50ysZt1krPM/Es0ghOOAj4YEdfk3eqozhrJVgIiul9fJOaixt7fBEvMKT5+YnT6zz8+pTJwqQanBibIGJeXzQTMEHz2oFBsaWPgdnsEbdV5sI66ADf8mufVGQ0+R2AdfXdPrt3jiU3OpgOKRYolWaqXgl+YmPqGoxvgVeo1LBKNS38NG/h1mxNII3FElar247vJsU+zPKco4AL/uoQT19PezqGYZQQ8aZctPUZJa7vUKP/UpFR0GG4Xp/QA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(83380400001)(8676002)(54906003)(8936002)(6506007)(186003)(316002)(6666004)(5660300002)(38100700002)(38350700002)(110136005)(6486002)(26005)(52116002)(7416002)(2906002)(956004)(2616005)(1076003)(44832011)(66476007)(66556008)(4326008)(86362001)(36756003)(478600001)(66946007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bs4zXQXhxvaKA3Jm4muQAaou7CtUSpHWTBYUgtg1B7rhVsDlESUrKRMEBnwe?=
 =?us-ascii?Q?ZGXCeU72KVKb2wBe+iaRohW5K9Mt8XRTEbwpjtOQ3E+aTZyq3AoZxYO9vVf3?=
 =?us-ascii?Q?EIso5EFhHJ6blgTRuyFIwAurB7XnCERPgbl4sr05LutobpKxekQZl5Ci0Kqt?=
 =?us-ascii?Q?EcxOv3mweQ5l0ksZB2/b2Mz23gOzUs26VZh1u2AO/gVED+OwPA+HkwSUahZd?=
 =?us-ascii?Q?v0nfpzxYH2MDqtOs8G4zGQE/TccX2bJirnLn84vR0FRFGlfEc/pPh6iadOp7?=
 =?us-ascii?Q?edsn+b/DT2R+vABm+zSpmtqFtwuDug8j2AhBj6Jt84vFE/GK6jTf8nEiX/IS?=
 =?us-ascii?Q?UU9X0M426Ez0q8m+/A/foFbIHOpUo/nuKFMnptV9V60uLQlGzJDo0n/yw7oi?=
 =?us-ascii?Q?iHciFC3iIzYlha7p0RTYdeCn8T64QwLItAGYElF5lo+HBZKEof9ajP5Vj1W+?=
 =?us-ascii?Q?zlYYwTs09nUHWWigfXzkk/KboQ84CaF05wUFS+BnfdC7IrvkfdPsx/qedVdk?=
 =?us-ascii?Q?CdeGsJyjMu3sdwat8prWipjhCCMlUDfavFBGp3PgV3tOktm7YOKVbMmRweOX?=
 =?us-ascii?Q?bH1/RAMUfq8alsKlbKbcrYg3ZfiVmskE/XylwVQbgo0ioPcFV74yXkaPlgS/?=
 =?us-ascii?Q?QgfveR9Bocj9/vbnFKvizvAg4XrzZQnEkIROw1qjrol/jWGIF1rvQLjHJwZM?=
 =?us-ascii?Q?u6WbQe4805W6QbaaYcYuvD35wPa+KE8S6WTJUMniMhvJiA1AXPhvAkojrHsM?=
 =?us-ascii?Q?G5DOBKYuIn/AqXwmkwpgxg4kpUEpBskDGfvSTCJow5zVJWvZvfi/+TNCOjoG?=
 =?us-ascii?Q?p7SvlzCz+xwNzy19cDU5NbMSWkN156oOS/OXJDvtSHRzwoXuc/fzJQnRGA2M?=
 =?us-ascii?Q?Gc7jFXFvxfpYqxWL7svCvEkFyPnPfmbNlEC3XaQt8NS7Zje3rEQ5iEmGhK3+?=
 =?us-ascii?Q?+ZEWsXpjD3ruFj10qS/fOQg/BXiPs0jztn+OrEwyHCF/CNbMh+xdzXUAM5nv?=
 =?us-ascii?Q?73xFb4ANjrSGrczLOWIgA6amS/x9TL3Hk56acXdZ2hL1iuMLmnT8eTOM5fH5?=
 =?us-ascii?Q?vrzyE67Po3AmT8JEkLwbPvyUCveABaekUnt+s2zlk9vXWQsbg2Q0/oOjS9Ad?=
 =?us-ascii?Q?SWyP4a8++hWV63SUvrqy0iS7pC2ZNM5JsnwDJ9m1GQQ6Abroud24ddj/uMkL?=
 =?us-ascii?Q?ucXyFPV1iE5m/v3rlhFVHm8t+8llJenLSvMNDSqPcTgEy+fx1t25JUVmNYK/?=
 =?us-ascii?Q?Q/pMI+LGOBKutVACfXnQaRuRtsrg7RumoZtixPU6+jIcZFvTNwY80FSCwxhM?=
 =?us-ascii?Q?G9NW+eMio7XwGWSPd7FC43+s?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc1ca38-fdb6-4c25-4114-08d9568c193b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 14:36:37.0538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ILEwdmlivjoD8e1YG7sMIyDWvjyr1Gezj++9eQdZzfaaFDUGiVxmXe/J5qHn1RnBfZ2edA80LqP8J+JOeUkDFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The introduction of the explicit switchdev bridge port offloading API
has introduced dependency regressions between switchdev drivers and the
bridge, with some drivers where switchdev support was optional before
being now compiled as a module when the bridge is a module, or worse.

This patch makes the switchdev bridge port offload/unoffload events
visible on the blocking notifier call chain, so that the bridge can
indirectly do something when those events happen, without the driver
explicitly calling a symbol exported by the bridge driver.

Vladimir Oltean (2):
  net: make switchdev_bridge_port_{,unoffload} loosely coupled with the
    bridge
  Revert "net: build all switchdev drivers as modules when the bridge is
    a module"

 drivers/net/ethernet/microchip/sparx5/Kconfig |  1 -
 drivers/net/ethernet/ti/Kconfig               |  2 -
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  2 +-
 include/linux/if_bridge.h                     | 35 -------------
 include/net/switchdev.h                       | 46 +++++++++++++++++
 net/bridge/br.c                               | 51 ++++++++++++++++++-
 net/bridge/br_private.h                       | 30 +++++++++++
 net/bridge/br_switchdev.c                     | 36 ++++---------
 net/switchdev/switchdev.c                     | 48 +++++++++++++++++
 10 files changed, 185 insertions(+), 68 deletions(-)

-- 
2.25.1

