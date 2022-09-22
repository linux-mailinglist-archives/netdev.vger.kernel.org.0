Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C785E59CB
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiIVEBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiIVEBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:01:21 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA87ABD5C;
        Wed, 21 Sep 2022 21:01:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfzSe4ytVZn/eSCpSBb0yAVy9WMnqUIg2SDVRSBPdKiswd50VJaxIkUpBLXaS3oFnosfUKwSZPcGQDNTk1dUgih6EscefPqJtwbWXpG6PWj2Ls3ZDdVCUqp7b6Ah4YI9xTXspQtIpYIy4vVPUrAp0VhhiLS5yvvFwCzvzQ3AI/Ywg+crwlwxZqtybjMglO6HsPPF2zrAdfKDKt52aPi+I7CFW+/koSRGWdIHtCwOKFhKqcLEIFic97ddfHXS7/ZhenOigzpljv4WAn9WFTNoJ/RR9q3bWzfOsEGA6cfQjJXPaVg3pkZ/Mz0bnbjdTUm9UgAWoRyfav5Li7KNTOqMPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8iyaZuIxTSg8OafM+duo7JoUFHHVXaLqQJx58Ld5ss=;
 b=C6csy2xZzuAVoOxulmMKk0qeNfSuTLsZbKFLWFXHqcdbR5C3++CoENL+m0MFyS8GSxXM5+9lw0sQ+U6dGjxBUFRmg81kpQkAB/5Dvd8PD1IM1o2qFoOpObsCDTdzJnJBj5M0yiqdElRIdrGnoppWPSDnYkPgFfyYjsHvJxRKuBYZx3cz2lRYg7OqiLI/eN3eWLiX7dOjo/ip1LLLjm4D5M56rcyZCBbTL9ubSyPdlLol1wbnFjP6rSBlsTCoCmHPrF//wa4OXalo2uYWFraTUEzZiR/okEVqZsd11C//vYJ82FfT02d3xG0y/rvz2vFMHmZKQx0Y1J/u2sq8qj9uTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8iyaZuIxTSg8OafM+duo7JoUFHHVXaLqQJx58Ld5ss=;
 b=tvZAu5UQkC0HD1dWzSRvAKP6WlikG54FCbZmZxk+JiDYWmXZZf+xHyAwSD1JdHww651M6Kexbn6D2OEhGGcekzkOwxmOvnwo0sGzQ+H5FZD54Se5axGQg6tjVXBSDVeR4jc6HKcStorcUZzY4QXQouF8nMS2PACfdxmBBpU44ZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN0PR10MB5158.namprd10.prod.outlook.com (2603:10b6:408:120::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 04:01:16 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:16 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 00/14] add support for the the vsc7512 internal copper phys
Date:   Wed, 21 Sep 2022 21:00:48 -0700
Message-Id: <20220922040102.1554459-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|BN0PR10MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: f1363fa9-4d34-4d55-5a06-08da9c4f18e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6M2xF9EQvETmH+8sqaKgN8Lz/pSoO1zmrrcKqviV+/4k1wtE6eGvfFPgxp8BaHkQEFjOA21gq3WMK7y54kCDc+D6lgnyD5foozHkC29YRrym8OZpDsdwhaGc3bQhPnMBI0IhhAIVrsV5sQiajWhGdsAInP2D7iKTTexafMYI4IM7ptsBHNHNuaTXfzkEW2r6EkaMZLD0mNs+8nV6G55rhVjyQxWu88Wj+17MB2KBdZVjB5VYAvhOwkul0pxBObT1iXl9V1AV1/LKmE2U8qV3HjvrUHzG2tMe5vkoyQ/qy5cMvJFERSapNnIVrvBVLp15Jz1+aX/y/qfpVWlx4KJ7ozYM454kAMu0PC3Dvfybum7DIf+cGWWLHWhNnLCEtnmatyqZ9/WCDnCi+2kHp8fD2KZQNtYKMhK/zwfJww+T8BEp5N3mLZJ8UqpSB6EIUvOxs38k2dKnRTpA9HA/stO2qF6735aYRcqo5lTxBaGoZBRp4Vn1K9Gc07HqW2ziTnQJwZ5GmgHNqTc3Gywk1MZex3MhAuuxVAo1Wa6nQy52GK7b7ehrRbzL1hYrkKHzN2zk0og7AdL4VPcK9LYh++vyFRktSlz/XO8o8EdIrCsYbR7fSUdKPafw5ULT1zmHd0lSt3rfRCaEKmGn0Ba25Va0mA8FtNxYBJoJRclsPiS31Dnl1CLeHZ5OOzb+SllmCK3bEaFoXyxsPeSvQbbTmqgOXffO5o0rGdwSlm/MkUWS9/paSmpA1beutam5knbzljbR2VdUuUf9mVcdnbD4iH1CKQ3WvzU9WvLX8TVljAhPyS0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(6666004)(36756003)(41300700001)(8936002)(44832011)(26005)(6512007)(7416002)(6506007)(5660300002)(316002)(478600001)(54906003)(6486002)(38100700002)(8676002)(66476007)(66556008)(38350700002)(4326008)(66946007)(83380400001)(966005)(52116002)(1076003)(186003)(2616005)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LgLWHbOC1MZImdX6L+De0wu61oQstD4KFEC0EH0/gjIbqUR31E34LS5kXSDj?=
 =?us-ascii?Q?Fj03uZmp/l4of57WLgPKeua3NvsyUCTMVmk6BDL2wm4W6i1xpl2Y3ADUhxhg?=
 =?us-ascii?Q?i17zrXKueTGC5VfyOe+1RQOhD47Qoi7UG8VNW+Xc6s7oUStn+k/xDurY/4yo?=
 =?us-ascii?Q?RUK+/4rmXNUO4pRqAf0EeNzPPMEj+6Gxo7MySJ8Lxvq2HKAE0w5HKje+w3HF?=
 =?us-ascii?Q?k0G8E3Lv58GLU0ATKLDKgIYrpwfoaZGATJvi8r7hhsi1PdHeh7p1XBmqjupM?=
 =?us-ascii?Q?TSicKqPKvg7lGwmDvf4y4VKQhbT1qQ1bebpnrq5SeoRmbpHdFzQSLOlBFYgP?=
 =?us-ascii?Q?lJD+q2xYSXTtVlDqgyfwrxC/U8CaJlrS5uRwK7tNtBOuHOGT3KKf56e6YvlV?=
 =?us-ascii?Q?VjoOfemNXOmcPAvM7D2imEDVO6iQMR+lTpx7RHgJLBoWfV/YSYev1REhEhyl?=
 =?us-ascii?Q?DcDZB7z9U4hW+Z6zGG6pVZbZbWxUJmyUEguT7wGoOBRjKL4/RiFh+6OoNAhZ?=
 =?us-ascii?Q?UbphrVqYQD8Rt+gED/VqSgCX7P14CQKj3gy9IfRiYgBoHB/0PhTx9zmupvZV?=
 =?us-ascii?Q?44URSaQ5rsB3xYNpTDM5R961v1rtiLuIqhaggHQyVw7kTBpwa9aKD8QaW36f?=
 =?us-ascii?Q?zeW+BS+EFjRBfBv/VbvFdozlgA4fce6a4L5CYuGmY51PvZaqHqx40FGGb0QS?=
 =?us-ascii?Q?d/z7Ah42o7WfRqCqfL7qm6eXTkcIaFUQl447BbxINqEJXsPh7vhXX2e7Mxib?=
 =?us-ascii?Q?lCJGATOSr/FYWAujF42CPGX1hbW3laplFC0i28xOipc9s6H+w6nTA7QK85N0?=
 =?us-ascii?Q?jGPodBA9r6vC3RuZuKNkD+gakatLhFP8cOr9p1LV2rKn6q5helUmMdS0TvsD?=
 =?us-ascii?Q?i3saSg8ZeQPIuiG09kX3+NwhYVCxwPjqZ/5Vy6Ry8yRPLAzLQhscb8H6dLhv?=
 =?us-ascii?Q?1Rt+MpV5F01/TFmmnO0LO5fdUbAH2Qz7b7Mgln4wqRmBQIgwCedF9QrfzSyo?=
 =?us-ascii?Q?/CuJmPuEnRJiYetK6SD3syFN55j+25AS7LtOsFT4P1cwIm7Zya2YzfbmFtaY?=
 =?us-ascii?Q?XOah7Cy9UR+BoPOcenpz6J3fMiBe26/8vPM8HRat30c6DTmvS0n7TE82cxm6?=
 =?us-ascii?Q?x8BckbzsZMjRHf+EsOwEP9Vdb3dmwSHmLzXfeD6u7JXbSLMk9akRxSla+g7j?=
 =?us-ascii?Q?mXFC47fPtIOVmyRCv9ZAgSg90SKkUMCn5+ji8X2b/8mYlab7eYpWf8lD3srR?=
 =?us-ascii?Q?OCJDNzEUYsD9b7FjinaMWQm3d1k192B4sDrfN2eRsxDOdsbXxknYWh2CV+wM?=
 =?us-ascii?Q?YqUW3mj9nGOKE5TRmjovt3GsD+ZthYIJEFcJvuLWnRUSXZ647It6J+abkBRG?=
 =?us-ascii?Q?ijpV/Wmf3VmbNNmT8XpabnxnFFFwIOFTIyOSOeNVhw/BJnwldutM7EEUT99u?=
 =?us-ascii?Q?uoWP8FXrjmnpKoWHtsgk62pvic88IGvCYOHzjf0KP3k7q0xRW+5CcvSBxpih?=
 =?us-ascii?Q?U3vX4va00m37Bs+e7sNVgTR0H2tEV3a2+p7LseNjS45pWvxJlMhmiTJTeJ53?=
 =?us-ascii?Q?3mVOzkvsgLv4k8fpe2lc0mBr7qWg1TCHujLJ3bRR9UVR9JFRuKaJBfsxsLC8?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1363fa9-4d34-4d55-5a06-08da9c4f18e6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:16.2164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x4b/KIjm6wjE1pfh1WLCzLpErhoSxJtC7xSJD/VaFzZtmwoOwh+OQAkM25GxJR6MLhomjMxwU9j1gdJL6ck8o9Uoix1XicaoJ6ZBRSDQUes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is a continuation to add support for the VSC7512:
https://patchwork.kernel.org/project/netdevbpf/list/?series=674168&state=*

That series added the framework and initial functionality for the
VSC7512 chip. Several of these patches grew during the initial
development of the framework, which is why v1 will include changelogs.
It was during v9 of that original MFD patch set that these were dropped.

With that out of the way, the VSC7512 is mainly a subset of the VSC7514
chip. The 7512 lacks an internal MIPS processor, but otherwise many of
the register definitions are identical. That is why several of these
patches are simply to expose common resources from
drivers/net/ethernet/mscc/*.

This patch only adds support for the first four ports (swp0-swp3). The
remaining ports require more significant changes to the felix driver,
and will be handled in the future.


v2
    * Utilize common ocelot_reset routine (new patch 5, modified patch 13)
    * Change init_regmap() routine to be string-based (new patch 8)
    * Split patches where necessary (patches 9 and 14)
    * Add documentation (patch 12) and MAINTAINERS (patch 13)
    * Upgrade to PATCH status

v1 (from RFC v8 suggested above):
    * Utilize the MFD framework for creating regmaps, as well as
      dev_get_regmap() (patches 7 and 8 of this series)

Colin Foster (14):
  net: mscc: ocelot: expose ocelot wm functions
  net: mscc: ocelot: expose regfield definition to be used by other
    drivers
  net: mscc: ocelot: expose stats layout definition to be used by other
    drivers
  net: mscc: ocelot: expose vcap_props structure
  net: mscc: ocelot: expose ocelot_reset routine
  net: dsa: felix: add configurable device quirks
  net: dsa: felix: populate mac_capabilities for all ports
  net: dsa: felix: update init_regmap to be string-based
  pinctrl: ocelot: avoid macro redefinition
  mfd: ocelot: prepend resource size macros to be 32-bit
  mfd: ocelot: add regmaps for ocelot_ext
  dt-bindings: net: dsa: ocelot: add ocelot-ext documentation
  net: dsa: ocelot: add external ocelot switch control
  mfd: ocelot: add external ocelot switch control

 .../bindings/net/dsa/mscc,ocelot.yaml         |  58 ++++++
 MAINTAINERS                                   |   1 +
 drivers/mfd/ocelot-core.c                     |  98 ++++++++-
 drivers/net/dsa/ocelot/Kconfig                |  19 ++
 drivers/net/dsa/ocelot/Makefile               |   5 +
 drivers/net/dsa/ocelot/felix.c                |  69 +++++--
 drivers/net/dsa/ocelot/felix.h                |   5 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   3 +-
 drivers/net/dsa/ocelot/ocelot_ext.c           | 194 ++++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c      |   3 +-
 drivers/net/ethernet/mscc/ocelot.c            |  48 ++++-
 drivers/net/ethernet/mscc/ocelot_devlink.c    |  31 +++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 181 +---------------
 drivers/net/ethernet/mscc/vsc7514_regs.c      | 108 ++++++++++
 drivers/pinctrl/pinctrl-ocelot.c              |   1 +
 include/linux/mfd/ocelot.h                    |   5 +
 include/soc/mscc/ocelot.h                     |   6 +
 include/soc/mscc/vsc7514_regs.h               |   6 +
 18 files changed, 637 insertions(+), 204 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

-- 
2.25.1
