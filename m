Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A135B4B12
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 03:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiIKBHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 21:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiIKBHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 21:07:50 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60085.outbound.protection.outlook.com [40.107.6.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97B54CA2B;
        Sat, 10 Sep 2022 18:07:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0RYnzItLG7ApiYJza7E2ZqRTWcnU2cRLtOWH1BkNMg6+hmbExNkhZZ27TGeUPTC73vHTXJAVlqjEu0kvx8tNcIBinJbdNNX9BEJLIexXI0ad9aw99nkjTWvyHaM9jR2vC6MazV83EiUmo13vv9Upiw8FDXnUI8xLNpka7oEal1uhezMCWVh2gmWc0KFugwm3pzCUYdALCiIYCI87Cu6YAVhVs3QuNA50GYtLAaBCLFMh3KsCGpVFVrAvUIsLcPXGWRufMB4lKBQIKLN8cSOSdpYrn1G5v36GvjsFLq/dhyNCBMyfq1Myhcpq6lvuU6WtyR+jx+elGSQjXmnaSAgEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKfpzzzfj3tD03E+SgXGN3VmUYB7G4fQO4IbxqL3C64=;
 b=g16KVwpKi/HFW7khU2UNcQMK5T52ygXzkY4vgjbjzElYzUhFLASjnh0a0sMfW7A8+bco82nMtLO9rvdTyvSbYpf2O3PI07hKSuHHhg+BMGCNB9SjBLL8lxSnMQfGKKKCG6ED4+fektEWNbGFcBzLJF6P7vK+Z3gZLYCKqMKchWeuQKnkY/NL009HQfKbZ6JgKvskH6vAd3LuqS0ejE2qR4J647WEZbR+ZnA7aWB7hQ/hW4Ym4It1h7+CW+SLtVWBCdAylfPk8yuNdtvGUHCvDuOjzhHts+OaAbtjEmiYo5sb8rvLRnVxYj3Xw64yP/u3pa2qnFgev76QgzlobTP7tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKfpzzzfj3tD03E+SgXGN3VmUYB7G4fQO4IbxqL3C64=;
 b=pZK3clE5cweX4PNlH6HrLwzhV8yt1ALlnCf/N6+PNXiarjOCEVE3ZxC/J8bpxkosIv423uV8XzWEXfSVUZPCizy3F7XBAUBBBQIRMs5wdB0Hu9C9R0KQLe2phhyJb+2uSlTOS/v8FSOaPtJxcVm5KatVSCLnAYAfKKbW+PvE5AY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB7022.eurprd04.prod.outlook.com (2603:10a6:800:126::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 01:07:46 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292%5]) with mapi id 15.20.5612.020; Sun, 11 Sep 2022
 01:07:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 net-next 00/10] DSA changes for multiple CPU ports (part 4)
Date:   Sun, 11 Sep 2022 04:06:56 +0300
Message-Id: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0129.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::31) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|VI1PR04MB7022:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d180b76-0fee-405c-3864-08da9392094e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q0S3kOcuNVX4g+AL8OjAmvf6CAuRoSofI0gf+MC2AeocwYOolEkFcYZpxjEQftPR/EtlfkbRMTZH4g0el8PSe+Az+T3UjfA8ttD5lkOLx0KUCjS7xvKhqpJL5SPTW/OuqqFk8074EGiXIO0Paf5F2UukufqE5GZC7Zs6Exj1fqRVcrcpYBh1TmMwvADYGta9qaASlN0cE37y6dE3e24PUCLCHU5h37gG6Gvhrz0fgJEJT75G/vkRh4ZjKm4Sjt0DCm/t8WiV26VEzqyOTfGRTqocXSTYj98DwljkHsr+cZDdZ1ad51F2K0jX4rdncLuN2v1srNlE58ntJK8ZTLpSfGC2seVN5CbAndT0hn3+aQgO0etyAac/TxvCuMtFjfpgDsR102jD0JGBAxTeU0tF7ng/yeRqgDPx5JPC56+xVolr8L0vXk6flUq34TUOGQCxJ22n0bTJOrP11f8DmC2c58i9HFzo+X/oHbZeAou0wICgHXIBSfQEda/IQrXqeK2SuXEGVw1XS/seLAZiUAF/vGDUpRL2M91kGPm0AVxwni9IziUbuvGphrGOTvsDCtBXVSEMAkzdyDClzodvGtTEHGyAhb6U6pAcxzmAk4H9wUo70QAoMmBo4NHT7Dccq9AGGnhz6Wx2Sj2uFCyRpVv4B43xCP3e4AuCQwBe+v2v0ZWI4mjivaiwlQikSKXsrBGtDfsIAa9b6841X3/7ACT9x7EDsdFswn2FeocNSp2DGO/cZbvoT7Cl1wH1mlbbpG3wWso6O7MIJDBufaqGWx/wGkwyQo0kEjfpdYwBLeKcziQoBfjVpIiMrl5dyb8gxq3wwT9seR7wkAMxnVydft3o6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(136003)(39850400004)(346002)(366004)(26005)(7416002)(6512007)(38350700002)(38100700002)(66556008)(4326008)(5660300002)(86362001)(66476007)(66946007)(8676002)(44832011)(8936002)(6506007)(6916009)(316002)(966005)(2616005)(6486002)(6666004)(36756003)(54906003)(2906002)(1076003)(186003)(478600001)(52116002)(83380400001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l5bao8L2pR0BRa6VR1ulLfD40q/Ora+lMNLeEe2cknbTgjrZX1Q3IRrAJKci?=
 =?us-ascii?Q?dXEcTSXKiu0Oz7m3jR5g6UUifKHgVsxLact/+PQid9AcaUA1bgHB5WpusIAZ?=
 =?us-ascii?Q?4EDYimDFeZwzKgcIBIGXIrsbrTTruxiFAoWhdULNeKMTxLob72MSF3NBmH3V?=
 =?us-ascii?Q?kU9yN/qkO2y4De4Uvqck4myNpCuNlaATr3DdhP4LdkkEnkqXsbm9TPfej5Z+?=
 =?us-ascii?Q?a94iRK5Co1IaDfUJlBVpBiIjQsZNYeX3BtIaohVfYVHLNG9OxzsWN7uqF5HE?=
 =?us-ascii?Q?9z62vQvxXWz/eQnXLfvlzTbG+sOegsWhBy5z5rmr7QBKrCNY+OanMwqm9otV?=
 =?us-ascii?Q?ntosgCcspBTvX9Md5md7YGBkq29kkMsOXvMA8ZLkJnjxYXr2nyfOiEK/dM8G?=
 =?us-ascii?Q?g75KccwK7z4pAG0sVRIeLMRBJUtex0IFGBtGa85hC4/q8124gB45vXA3mIh9?=
 =?us-ascii?Q?f6DFB+mThUbymjDVp9ek2d7dGlfZZ9794Anw75/rsju/ylET0bNSZ5TC5PFs?=
 =?us-ascii?Q?Li7fLb5Th8nkxJ6mqoP8IV8Iy+dYVEfwv1g3uIxv7NzrsMLNF2+blz5m11jG?=
 =?us-ascii?Q?yXudKs6RqJAJ5RzAsmC50XM+8P42/vjbGfNe5n+Fja35qydxkEXfouDnKI8X?=
 =?us-ascii?Q?4w5Al0PggSHp4nr+kJ7gW2rm+q87g36p503ogjQRgGj4nKU0tZl2v93yTSY5?=
 =?us-ascii?Q?4LVbKfSwd+nJw5KsK/tr9FAGvXVOvfCCygrbAo2t3aljPEMluoZw9GQYZ+F8?=
 =?us-ascii?Q?XR9r0GfcjzcIQhe2Q9FeEMlM+lNUP9getwHo38f8/MYfbbpA45Vo7kUIj4HQ?=
 =?us-ascii?Q?02aZTE0WW6T/A8q2KZPOrKzQy5j9h2mQJ/NY0crNh92cmZc56gQkHj1FnAtY?=
 =?us-ascii?Q?Y0H8X67X9QGSmn3+cbaD27qJGdnh5ztJlz3+RztJN+gPHu6BQGcjHFqu9LFe?=
 =?us-ascii?Q?fsjPZyJFgQoLuGDCACkcERppFHC1t+MQqOtAQ85zgHCOGJJS9KrTeDSAPyDj?=
 =?us-ascii?Q?FbZZAOlnUw0hMmMDUx2EBgofsoikBveuUvpiJE2Dr6HySeu4LEKk2pKSzy9+?=
 =?us-ascii?Q?UBfN0wnIFPwoRgpxvlIoU+tugMSzs/7eAyEYgZUNc9/BXjzHn52byaBy9FFW?=
 =?us-ascii?Q?OEWx0qSHyAMfHPtsLO95sh5g+f/vg63JC9pcUzwzNzojfVE9DLNh7aUT4Rfb?=
 =?us-ascii?Q?0OmMOvJ+Bxm/Svc3nmr7lSKTbPWiu1q+KH5NeMV9SZHAuQjplD3yY3+E/Ssu?=
 =?us-ascii?Q?U+ppB5O1Wjq6uVwte0TOy65OxBQjwR0BGssg/AgUPl8IVT64nwCcoWzgW2Vq?=
 =?us-ascii?Q?rdC1KDUyL99tvDKm8GDvBTsILeCGk78NUQYYJdnY69iMIhwxEvn37Am2d0oZ?=
 =?us-ascii?Q?Cv7d5vI7e+8eX9kE8Zb90CQEvopxmWJDhdebAGtejML9ewFiDozj2afh4Cq/?=
 =?us-ascii?Q?B8Qm1rAW4zBFDLBz2JS3mp0zCgk2kCUrg5uRTmccc5nJC3X2D47jxUR95kZv?=
 =?us-ascii?Q?GIXYXUSjt0qhVVnj3V0KabHe0rstkuZIEmiM9J9q+mrefu/Fp4mA4Uz8YxOf?=
 =?us-ascii?Q?h7AWddQvnHRfB4fEZrzWGjnD77GBo8iDoSloCOME9omyhZwvJ3482j5eghUf?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d180b76-0fee-405c-3864-08da9392094e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 01:07:45.8382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uz0KWD5ilrVcbS96ZrbJePPXijNSEfg0EqaOV1kKDO+PdeUK77YyOO731Af9Nm9x1YlH8Be0/Y/G7vnBF2F0xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7022
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Those who have been following part 1:
https://patchwork.kernel.org/project/netdevbpf/cover/20220511095020.562461-1-vladimir.oltean@nxp.com/
part 2:
https://patchwork.kernel.org/project/netdevbpf/cover/20220521213743.2735445-1-vladimir.oltean@nxp.com/
and part 3:
https://patchwork.kernel.org/project/netdevbpf/cover/20220819174820.3585002-1-vladimir.oltean@nxp.com/
will know that I am trying to enable the second internal port pair from
the NXP LS1028A Felix switch for DSA-tagged traffic via "ocelot-8021q".

This series represents the final part of that effort. We have:

- the introduction of new UAPI in the form of IFLA_DSA_MASTER, the
  iproute2 patch for which is here:
  https://patchwork.kernel.org/project/netdevbpf/patch/20220904190025.813574-1-vladimir.oltean@nxp.com/

- preparation for LAG DSA masters in terms of suppressing some
  operations for masters in the DSA core that simply don't make sense
  when those masters are a bonding/team interface

- handling all the net device events that occur between DSA and a
  LAG DSA master, including migration to a different DSA master when the
  current master joins a LAG, or the LAG gets destroyed

- updating documentation

- adding an implementation for NXP LS1028A, where things are insanely
  complicated due to hardware limitations. We have 2 tagging protocols:

  * the native "ocelot" protocol (NPI port mode). This does not support
    CPU ports in a LAG, and supports a single DSA master. The DSA master
    can be changed between eno2 (2.5G) and eno3 (1G), but all ports must
    be down during the changing process, and user ports assigned to the
    old DSA master will refuse to come up if the user requests that
    during a "transient" state.

  * the "ocelot-8021q" software-defined protocol, where the Ethernet
    ports connected to the CPU are not actually "god mode" ports as far
    as the hardware is concerned. So here, static assignment between
    user and CPU ports is possible by editing the PGID_SRC masks for
    the port-based forwarding matrix, and "CPU ports in a LAG" simply
    means "a LAG like any other".

The series was regression-tested on LS1028A using the local_termination.sh
kselftest, in most of the possible operating modes and tagging protocols.
I have not done a detailed performance evaluation yet, but using LAG, is
possible to exceed the termination bandwidth of a single CPU port in an
iperf3 test with multiple senders and multiple receivers.

Changes in v2:
- remove unused variable in dsa_port_assign_master
- add restriction that LAG slaves must be DSA masters of the same switch
  tree
- move DSA master eligibility restriction earlier, from
  dsa_master_lag_setup() to dsa_master_prechangeupper_sanity_check()
- set master_setup = true in dsa_master_lag_setup(), so that
  dsa_master_teardown() would actually get called
- new patch to propagate extack to ds->ops->port_lag_join()
- don't overwrite extack in dsa_master_lag_setup() if
  dsa_port_lag_join() provided a more specific one
- add restriction that interfaces which aren't DSA masters cannot join a
  LAG DSA master
- provide alternate description of how to put CPU ports in a LAG
- pass extack to felix_port_change_master() from felix_lag_join()

v1 at:
https://patchwork.kernel.org/project/netdevbpf/cover/20220830195932.683432-1-vladimir.oltean@nxp.com/

Previous (older) RFC at:
https://lore.kernel.org/netdev/20220523104256.3556016-1-olteanv@gmail.com/

Vladimir Oltean (10):
  net: introduce iterators over synced hw addresses
  net: dsa: introduce dsa_port_get_master()
  net: dsa: allow the DSA master to be seen and changed through
    rtnetlink
  net: dsa: don't keep track of admin/oper state on LAG DSA masters
  net: dsa: suppress appending ethtool stats to LAG DSA masters
  net: dsa: suppress device links to LAG DSA masters
  net: dsa: propagate extack to port_lag_join
  net: dsa: allow masters to join a LAG
  docs: net: dsa: update information about multiple CPU ports
  net: dsa: felix: add support for changing DSA master

 .../networking/dsa/configuration.rst          |  96 +++++
 Documentation/networking/dsa/dsa.rst          |  38 +-
 drivers/net/dsa/bcm_sf2.c                     |   4 +-
 drivers/net/dsa/bcm_sf2_cfp.c                 |   4 +-
 drivers/net/dsa/lan9303-core.c                |   4 +-
 drivers/net/dsa/mv88e6xxx/chip.c              |  27 +-
 drivers/net/dsa/ocelot/felix.c                | 121 +++++-
 drivers/net/dsa/ocelot/felix.h                |   3 +
 drivers/net/dsa/qca/qca8k-common.c            |  23 +-
 drivers/net/dsa/qca/qca8k.h                   |   3 +-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |   2 +-
 drivers/net/ethernet/mscc/ocelot.c            |  11 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |   7 +-
 include/linux/netdevice.h                     |   6 +
 include/net/dsa.h                             |  31 +-
 include/soc/mscc/ocelot.h                     |   4 +-
 include/uapi/linux/if_link.h                  |  10 +
 net/dsa/Makefile                              |  10 +-
 net/dsa/dsa.c                                 |   9 +
 net/dsa/dsa2.c                                |  34 +-
 net/dsa/dsa_priv.h                            |  18 +-
 net/dsa/master.c                              |  72 +++-
 net/dsa/netlink.c                             |  62 +++
 net/dsa/port.c                                | 160 +++++++-
 net/dsa/slave.c                               | 362 +++++++++++++++++-
 net/dsa/switch.c                              |  26 +-
 net/dsa/tag_8021q.c                           |   4 +-
 27 files changed, 1064 insertions(+), 87 deletions(-)
 create mode 100644 net/dsa/netlink.c

-- 
2.34.1

