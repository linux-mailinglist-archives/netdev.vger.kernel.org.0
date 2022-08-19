Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D1B59A3AA
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349413AbiHSSCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350274AbiHSSCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:02:01 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70089.outbound.protection.outlook.com [40.107.7.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C31F2712
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:48:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8/AY4Zgrq65IgIqzZbmXHJUjbOncUq4rqg0gYEVzYAVVF2bKCjfS50ZTOYrv9QSR9xuHJEtk9kv2EUbfkW6GjtxaTGbBuyrjNLdWmFCFFIc6rSldfepYZCbYQ51TtUBy3FSJtVtGJgylrDzhcEqUk0EFCQvIqxaVXXeRUtHBDmjKZS1yVQVMbX9rE/BitN6+Ph2qPXzCVAf7AvJZ8R1a1yv1UcH44oizMILW0GhJU7Gbt4cEFf6InttIWJjOVlSAmNXKO4TrvK/2oHQLwLNYkTjT+cBFyTl+F2QSCyyeEtUct8+XQA/GTdOGJ0pXKR8A539+d0L/jAYGA5LlhTRfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vEge5vfEUKjucwDekXMM2rzOdLKjagX0Tuw9H8qeP3k=;
 b=GUxZRUISRWU8WpclRgcSeuTfg5C0yLPuBpMNoswICQYU8+KJu52qlpXTco3/C6AsLv93FxWJ9LqTqQiMLOXW4+RUs6DfU0kiuHvwW8KuY3TQ094yIdtgPN5JtuAHz6dQoP0e9W4HFXWtO10lE1O975qphtnr6juN5qvjInEfJmiE6T9ByhtopXvS+0FoumInhtt3vlWVZ2KIcRMOK4n2qtBrQd/1XXqIhsBXODes5Ct4sNHuNF79ebD9PClqEONuLcZBaWRZzTI2/uEUAveZFkJlHzHK5XY2FnhdLq7exxAM7ph6JxgAavxLnqIf+6NTo3KMzylQVCnpQw0v9mKYzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEge5vfEUKjucwDekXMM2rzOdLKjagX0Tuw9H8qeP3k=;
 b=mBa1cibiqiwNG6bCdv8jQj3MWhtHug9BF51EowwY2TatB4Y7PF/fb6MhxszMSXcuNZUiqkvLZGj3FnYMUYLYaivNxavhSPfaLH/TeRto+10BY1qqd0f/fPi0/qfljiv4gBqrqiOJ3j6120kN3pQMRDlh6oKfbplVRGlcoqfMh7I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by GV1PR04MB9088.eurprd04.prod.outlook.com (2603:10a6:150:23::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 19 Aug
 2022 17:48:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 17:48:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v3 net-next 0/9] DSA changes for multiple CPU ports (part 3)
Date:   Fri, 19 Aug 2022 20:48:11 +0300
Message-Id: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0044.eurprd05.prod.outlook.com
 (2603:10a6:200:68::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49836879-00cc-477b-2094-08da820b073d
X-MS-TrafficTypeDiagnostic: GV1PR04MB9088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TghyhIfc0ujnRcOmeU6nwdtzglwGzjkEePrSP5KB82BpVr4tj+FwmHJTiWB1uag06O/KV7dFo52w6QLmrrFLbyCKSR4r+319YQwMSkrRk9Y2G+e6619sbpzae8lFxShA1LFRceqwlRjdBkypya7KvNzXFrXFDlL5l96b1btzQkDT8yZnI26pEnW07hAvinfQNgZrh20UkaFlQpHbXHGzlCELOaUAz5074OD5vI3V1gexbN3GGWVHb4HojtO98Df6NGwVZDSTz4N3WKzvMRZHaR6LP4lPNjINxXLM8faMFukKDE9VBkWXn0g18e/ObAyRiHXq0aS7B0rWtdSap4jhswgnZ5u+z6VYLdzHg0e0yCBh35xpAOmiCeZIGGeheSTXt/ArpQrtvgvG37Sdt2lY08SXtJAzZ49jNctS3Fd2T+Egf/nvzo+PolJfRXw8AMhlPb/4PYCcWQ4wKDcUqfnaPkrbA2P3P2eNj1grm1m0fxe0mI2WEMKdSetKZLgcr3DMTml1Bt8TOSg3V3f87rMAusZuDtddYleL5eJXSdUfwqZE1jiUsONGtMAnyGfoq8R0vJoMToEHJuhiePGgCU9PU6QmiJdlmyKV5U1uKrWyrS9EYBbhmT5+XeW+tWsadr2aGjxqxvix2P6FxJGBWqJ74mAtIErNmudnJ1TDJ7ODlO5ZMz7mJs3fSE09YgeRGlnsk75zfqjD87WaLDtiN/jEYP+x50iCAJzcXMJO9yx6IuTkqvR9P/hLxQN2dnA8+uJQZk2QUCj7RWZBSVqBU34IpsuBVSIicxH9wLjW7gQgAZ7xAl2dKpyUY9ht22lejwqLYydXvY5pZF7BfpDHjXl28Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(2906002)(2616005)(6916009)(186003)(1076003)(54906003)(316002)(83380400001)(38350700002)(38100700002)(4326008)(66946007)(66556008)(66476007)(8676002)(966005)(36756003)(6486002)(478600001)(26005)(86362001)(41300700001)(8936002)(6666004)(6512007)(6506007)(52116002)(5660300002)(7416002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D3aKo/vMGDdkxWj7vSaiRl+j8HxAmIggE3TxFcxO1tFLeDdswCDZbTn3yAsF?=
 =?us-ascii?Q?EV0d9YG8KegOD4AVrU8OYqdBMFJkRpBPslyjYtYIwzA2lfvudL/qUlrrfcTS?=
 =?us-ascii?Q?EBnHfqSynTrEjGc9fGtcbSd0jKGunm9+zIezLVYkzdIBca8I7/Ms/daHwN+W?=
 =?us-ascii?Q?VCxG8NJQQGvm9RTMLLn0mOyMI3Cno0xFn1jarfwcJTjHrnsfnodOrsjo+PyP?=
 =?us-ascii?Q?2eUV/sFXHzb+fZvL39k7tg6nH2M6eOTmy0hi1a+rz+MXV4SPYo2FiE3XMNwQ?=
 =?us-ascii?Q?FumtDGGluBHpbHUYgDxC+uhzT8sz8aocpy+jpcMFBidU/KQtIivSalIUDp2m?=
 =?us-ascii?Q?i3mo8z4sD8pb6F71Db2pcoFQZXHWxLYJGIB8rJFqClCQQldUdoSHTCm657X/?=
 =?us-ascii?Q?oExb9mXJQKcrZ+3gxlXhS2SjdkCRUdk0pLGEV+k3I0MDVTAvMlk8q/i9Ud4l?=
 =?us-ascii?Q?kVNv/63SfaHx6ZgkpTrVqVfh3heSOwzsKvUKWIvnTT2ynjI9dwPhm7W3ZQFD?=
 =?us-ascii?Q?H7yVA40BOFSAB9/F/Sy8zKoqZj1uAUQr2AfzTx3ORZevsnt5O0qNEk7DfN1A?=
 =?us-ascii?Q?qLMZxQl0RCIkuvQI8YPo0/MmbysLDy75BwlorDtiI3b3rQPHe/ONyPHLAhKM?=
 =?us-ascii?Q?LdES+OjsWQAcxCaPMJ5OuOqiawU5oxpHMvO9MUACmoTSfrKjCBZuudKMNUFv?=
 =?us-ascii?Q?pYd1LHg5Z5Ae6X22t1hbpWsLea9Uky0Q6N1Hh92cDXiSwFN/K25LCUkqZATz?=
 =?us-ascii?Q?QlWq7v/oP1Rp61Bd3MEeujiZjOwmrdd5i3JKeVWKmAGwUY3K9QcvtKtRjECQ?=
 =?us-ascii?Q?eoLyfzWz9w6Ad1yvCKFY8CjaH3qwS+WEkuCgZwkJC72B4dnCDoz2zdLAV2pM?=
 =?us-ascii?Q?EBhUhMR4r6Sn5ukOUFXXIBQrY/TNQyW6ZOCPo1ZIrfmYbn3jJhx2qC+/VsFQ?=
 =?us-ascii?Q?omVJCD1V8zcumnPw8ERpStPWUr6EoxIEBBRTe+nSQnVjzEBQ3r1dk/ZtQxDX?=
 =?us-ascii?Q?Wcz6aSrk/Nh7CwFYyYvVosdsi35MsZ3pLYyiPYpHkC4hp7hOYWjo+LZI9prN?=
 =?us-ascii?Q?izTAh75x0Dx8p9NPpMTJNlR1jeHkeSLAYp5GJrgKug902x2hljQEF9D8scVH?=
 =?us-ascii?Q?SU3IaaWGSyOFXN0SFGpCGmVJh7Iii37E9npTyYAQCSIfIkkJCLs4Sj5sWdvy?=
 =?us-ascii?Q?oQBcL0uYS36hpRlC4gE7RYVHYZrx2CMy1K30AIMG+IpArSbqoVkbb4KOVbVQ?=
 =?us-ascii?Q?t2ablsMOE/8s6qmwITu83SL5OmbJuna95Ap7ATbypo36sc3PxfRPOjFDTFt8?=
 =?us-ascii?Q?MJbMaasYx9rh7YtevNeuPizn06kESxT87VMrGFDm77ghpFxjQzWtPNQt03a3?=
 =?us-ascii?Q?wLU3O/vn5dFfPuKeipme5r7pkDNMkyT/nCxRAYUntF8S9fUF2Cz2hU17alx/?=
 =?us-ascii?Q?Omn7IUCOBrHFMMc0GWdtUuaKAmPd54OrwGP7IRadfcrUBbQ9KnN4zeFT1Rog?=
 =?us-ascii?Q?rXt5aOB8NlCPftVMsXhA3iDGOygunIZ/DYs+q+dBFdVMxvLCfs8pYcf3pGyW?=
 =?us-ascii?Q?Rdk9JoJlOONV0UN/H9r1PKzy926mOh/zIOg3+F7OY2Yl7ETxexLJBNwb8eER?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49836879-00cc-477b-2094-08da820b073d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 17:48:30.5762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EmGsnoz6Kt3ILlwb19EUvM5woSdM5/kwvaLiMhnwAYj8x0cBWP4wECaBBUOVXkKhJdwSDmoFI108JBjQRUsZsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9088
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
and part 2:
https://patchwork.kernel.org/project/netdevbpf/cover/20220521213743.2735445-1-vladimir.oltean@nxp.com/
will know that I am trying to enable the second internal port pair from
the NXP LS1028A Felix switch for DSA-tagged traffic via "ocelot-8021q".
This series represents part 3 of that effort.

Covered here are some preparations in DSA for handling multiple DSA
masters:
- when changing the tagging protocol via sysfs
- when the masters go down
as well as preparation for monitoring the upper devices of a DSA master
(to support DSA masters under a LAG).

There are also 2 small preparations for the ocelot driver, for the case
where multiple tag_8021q CPU ports are used in a LAG. Both those changes
have to do with PGID forwarding domains.

Compared to v1, the patches were trimmed down to just another
preparation stage, and the UAPI changes were pushed further out to part 4.
https://patchwork.kernel.org/project/netdevbpf/cover/20220523104256.3556016-1-olteanv@gmail.com/

Compared to v2, I had to export a symbol I forgot to
(ocelot_port_teardown_dsa_8021q_cpu), to avoid a build breakage when the
felix and seville drivers are built as modules.

Vladimir Oltean (9):
  net: dsa: walk through all changeupper notifier functions
  net: dsa: don't stop at NOTIFY_OK when calling
    ds->ops->port_prechangeupper
  net: bridge: move DSA master bridging restriction to DSA
  net: dsa: existing DSA masters cannot join upper interfaces
  net: dsa: only bring down user ports assigned to a given DSA master
  net: dsa: all DSA masters must be down when changing the tagging
    protocol
  net: dsa: use dsa_tree_for_each_cpu_port in
    dsa_tree_{setup,teardown}_master
  net: mscc: ocelot: set up tag_8021q CPU ports independent of user port
    affinity
  net: mscc: ocelot: adjust forwarding domain for CPU ports in a LAG

 drivers/net/dsa/ocelot/felix.c     |   6 ++
 drivers/net/ethernet/mscc/ocelot.c |  83 ++++++++++++--------
 include/net/dsa.h                  |   4 +
 include/soc/mscc/ocelot.h          |   2 +
 net/bridge/br_if.c                 |  20 -----
 net/dsa/dsa2.c                     |  56 ++++++--------
 net/dsa/dsa_priv.h                 |   1 -
 net/dsa/master.c                   |   2 +-
 net/dsa/slave.c                    | 119 ++++++++++++++++++++++++++---
 9 files changed, 197 insertions(+), 96 deletions(-)

-- 
2.34.1

