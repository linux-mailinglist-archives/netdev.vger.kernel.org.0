Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89206C5A8C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjCVXil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCVXik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:38:40 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2048.outbound.protection.outlook.com [40.107.8.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B941BEC;
        Wed, 22 Mar 2023 16:38:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPIIYwOFnDN0A+CiUN/IgkG6epTEt8HtAeN2oImorpkOaVh/KlUFKRUozRLtbYqC6NvYNDJ1lCJhXyAe3RAVlqmDfC34Hx0WMcbAgQpLpCjOC1dMaBJdAwazF86rPpcNqcysSMqbY5VBB8Py+k9uA/wnRkaxODFsZFHesV2nobwsvpULBWZuDFGIA2GCKYEWzBZbUYVr/NMvHrgIpooQI5qATcf2Jcs7W/c9lm9jA1Ja2hd+n2+HhqBoxq0NIzqZvhwUEtpE57OU21XuPa5+FZL6zNNppF/UdfoWDgFHnpbIo4LYRIn0JiivQzvEeoOds+Y1TcjnidLVfJ5m1/tl9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4fKhcZfCMLLveCAk918+GtZQmbtiq/knicrR1Yr0DIs=;
 b=IV6caY4Rw0MUu2WaHjizz4biR4KUps0nGwn4sQNc2CaEbeQzj5qlB+qRViEaW7I9vke4mrYGy2v8jmS2cQBuCEGGYDpT28g06jJXpc5hqgu7Hx/rD3vzseSl+FKiKR2hOED91JyePcWZ3O4K6fbpn6/Dv9PaqxVZ0dd6ySWnbwMiKhWQn6h5QNDh6sDaqGRK7tM/cmPGyhm4N151ycaglDOrniZS3KShqpYim2uD4gQ6t7wFmLHmsQBHaiiIRT2kohzvjsQArVFZDQ9sGLUryE/WK2kWk6eBAuAUNuixQpWjH299aNXt0/5etELlEtfuSrhkqcP3ATSKF5MsiQA/eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fKhcZfCMLLveCAk918+GtZQmbtiq/knicrR1Yr0DIs=;
 b=hDRm/DknAZevELjvYVt1Mb4lEFWmQipprsxL5hF/D9knWS+LFymzOG+rm2hJUtQQflF6QzJJW1Ta8cgTyCocqrg/aJMsntQK69/+zkEZ//FAAyQQ7+THpzAIZJ4UV74mHBq/kVUPmMoA+8G8/B9D8U5mi3Kn7fQSaOLNzX7TRgA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7263.eurprd04.prod.outlook.com (2603:10a6:800:1af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 23:38:36 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Wed, 22 Mar 2023
 23:38:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/9] Remove skb_mac_header() dependency in DSA xmit path
Date:   Thu, 23 Mar 2023 01:38:14 +0200
Message-Id: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: c5e051aa-376f-46a7-5cc9-08db2b2e8e3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g9JRoxo/L0DwXRFhoiFs5lPsiJl13FQrK6NGdPj1bkb4cb6WjHt8r+qFGS1cD+2QATBvxG2Grc2qv+wlOoWOX4PyEN1mAd/w32ViUYkNv17ltmqsLtflHWOjpxr68jPNN6v2ka8R4iN7Ui0WuDSciWkrllKx1qxVFosqf1oLyFQM8vmZWbPxUdzFT8lwkMVG1SmhgHNlygGaYQmSBxrozDqBF8JmJMxytLzP2Bj47DrkbE0JBsxWqcncYH3gmoJYOUjM5jqQHkqiW6s4OTlRXRp9yUm2B0atkrGaPSk8wdUOHgGrAfxxbKfrHCam8VvlQZjsE4ibdSW6zC/7pHjMwmgf1YjE/UuahjEnZ7Zgo91Igr6l4Jcez1v1OrA9NydhDgfqS1R4SB5VG2BEuXpbhw51URPn1KnLhmFw1TKvPrJXcut9VxWQ6VNIOY6uAaagCXOuFtI/J3hHR7bQEZD9MYJo/VfdNw3FZ0jsFzqVf+xlCYrYA6M44Q99fjkHrF3/iBuEVWt5I2I4MmQ4dneLXECiBRwUrMxKe3HrnYmXNN4TcNuAgh2lYDrYF2JxJkhJ/PR5xtAuWnhqezlP+rE+6OJCzXXxm3BmUDEf4nQQ34a3mN4vu76is4C9PlpYq4kxpxxpTNrtravMN1zmRW05fxbELe8Xnadb1gdZnyWoyIRrNENM3kPnDIC7+0UWH3SXIBochia1NE25wmf46ViYrut6lHbIFshVDVf3UEOk2+w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199018)(54906003)(66556008)(6486002)(6916009)(316002)(66476007)(8676002)(966005)(66946007)(478600001)(6666004)(4326008)(52116002)(41300700001)(6506007)(1076003)(6512007)(26005)(66899018)(8936002)(186003)(44832011)(5660300002)(2906002)(2616005)(36756003)(83380400001)(38100700002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3YX6KYhnuAWwfVIs6gp8gBJQ64/Y1oPbkJOTSZmPkv7e6sR6SesJv/BvmmyC?=
 =?us-ascii?Q?YGNJZvlblbmj8FbtasIXSKCTFD5JJsHqKZNkdCJ7V1+wR1247jm88MxuaczH?=
 =?us-ascii?Q?L+dRr2RJSd4O27ZC7MS+Uxq54KnebcGMkVq0b4DbFK39AvnBOY+bdhOAUgLa?=
 =?us-ascii?Q?xLVRjoDT95vU9cTZ7OMWUu+rWyCm1uiU4KsoxSLvAGs4vnM5z4M1fgclhNMT?=
 =?us-ascii?Q?rkb5V4dY0B11wujtxxFpwde4tLm1b1yGtjUrA/L/l1JvjLAzTIt9mQfCzisT?=
 =?us-ascii?Q?6IP2GMNxcr3Yrgus7+3cNjPVM8o1qqqFTr1EZmPY7Gm0jSkQkCwfeFO9CvAb?=
 =?us-ascii?Q?5R/q7xY51rtWEVJ0iVuLqC8zgQ+X8x42ouzBZ4FZqZXSeycrrxR5+iqlfqe2?=
 =?us-ascii?Q?sGXwkzg9jNvxwZBlDXZ+JYoA6D7gW7fcgcOBI4B4fp0tfkdE0Zm1oDuQz02e?=
 =?us-ascii?Q?DPTpkZ0eg9kAHHtV216Sbty/zEUTSIrPFrzUcxZCDUVmCUCrE2XlAFZ4bneI?=
 =?us-ascii?Q?zOGe+lW15yZ0k11MS1M/usSGlPGe3Y+sYrsTUiEy+BUFdWV/MmG1jadzOgSX?=
 =?us-ascii?Q?MpCyCoFPyqTDI1+Yb0VXaiQBO2Tiipc6NGN3dCXFwky4DCpoj7fU7TI3RMgz?=
 =?us-ascii?Q?SzA8jXX0WLeogywsSMjoNE1NFUslc+uqvHYsD64RNA9tFzZDx+tXQDrqSgok?=
 =?us-ascii?Q?vYggTi5AmQ5B6nVBVT+/K84aUsCciLgTcMJ9Lsg7+HAhemfpAAC/ziWFFOUe?=
 =?us-ascii?Q?C+7BrZiFpOhIQUrt+ViN4JnG6v5IWqlIMD/zqDfdAsOwv4Zwig/jPB6rvjzx?=
 =?us-ascii?Q?7TdzbBywl2G2LuS1/80P4olon5+v/+x4gSJVaM4jxb5spF+jB5XkDSyDn58z?=
 =?us-ascii?Q?/LqC1MXcr6lU5UODDZkNi2wKOqKCdzjrKA8mjho0x6W/BqtBoD0pvfudPFie?=
 =?us-ascii?Q?GcqWBpGcgYYaenHdl0FITpqCgXtoBeOtjCZZxWLsyKXTCP9uWDyTmvPEvhsx?=
 =?us-ascii?Q?B9LmaUj0JX3sKkeLae4yByPSFiblvSO3TFQuJFT8QI5Cywv5INTQd22JVuFq?=
 =?us-ascii?Q?kg71DsFAVAFA1Y7lYRYJWmJSaPR2ny77Td8hA0ttFv9kIL8nSzxuozqLMj1H?=
 =?us-ascii?Q?cZItmz/liFhVMK5EAzo0T+CnliIpPKpo9esLz3b9NtEajdhXpQlvkeKVQa9T?=
 =?us-ascii?Q?YeXHhbIxpMh/7SnhdUdKqO2mqXkkCszOtqILGyvkWAf8ZBQgiIlHFJeB1bl2?=
 =?us-ascii?Q?tdRt4X+fuP4mb6pTPt8OQUpfxso5cx8rMqPQJMFhXrFa456J4TkEsvCclzTV?=
 =?us-ascii?Q?D8wQEv/Rg07744+eUh5giAaETUl4zy3EMpku8JzuruMjcbZh3X/khz+T0aIg?=
 =?us-ascii?Q?edyN9DVLDKkH456uEp/NVYKOXbooEni55+Rnr/ctkO+gmnZE5BlVG/vuYkGG?=
 =?us-ascii?Q?Z1bRxWvMmhuE6LpiFSfG3amdLRxbLZ6ssLnxDcXgHh59Rfi6hGMAByQ3IO4P?=
 =?us-ascii?Q?5fBuwFCjKiqw3a5T1ZjFfaYF4600iw4iI8vPTNpfv8l7uqR8yjBQf0jdecYN?=
 =?us-ascii?Q?HlrbHods+AtEZ3mCqyr9pAA7MHKnUry4FIcOHjSy1ECK9w5wzdn8iyExv2ep?=
 =?us-ascii?Q?dg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e051aa-376f-46a7-5cc9-08db2b2e8e3b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 23:38:36.0614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V7KOQOri9AVhRd7PCGTnxbbfp2lCEjQ8gmnXkhgNZkbALbyerULz7lXc8qPeT6k6FbMzzWqDQg9eGvZSfB/b+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7263
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric started working on removing skb_mac_header() assumptions from the
networking xmit path, and I offered to help for DSA:
https://lore.kernel.org/netdev/20230321164519.1286357-1-edumazet@google.com/

The majority of this patch set is a straightforward replacement of
skb_mac_header() with skb->data (hidden either behind skb_eth_hdr(), or
behind skb_vlan_eth_hdr()). The only patch which is more "interesting"
is 9/9.

tcf_vlan_act() is also a potential caller of __skb_vlan_pop() on xmit,
through skb_vlan_pop(), but I haven't actually managed to convince this
veth setup to not use vlan hwaccel tags, so I couldn't test my
assumptions:

ip link add veth0 type veth peer name veth1

ip netns add ns0
ip link set veth1 netns ns0 && ip -n ns0 link set veth1 up
ip link set veth0 up

ethtool -K veth0 rx-vlan-offload off tx-vlan-offload off
ip netns exec ns0 ethtool -K veth1 rx-vlan-offload off tx-vlan-offload off

tc qdisc add dev veth0 clsact
tc -n ns0 qdisc add dev veth1 clsact
tc filter add dev veth0 egress protocol 802.1Q flower vlan_id 3 action vlan pop
tc filter add dev veth0 ingress protocol all matchall action vlan push id 3

ip link add link veth0 name veth0.3 type vlan id 3
ip link set veth0.3 up

ip -n ns0 addr add 192.168.100.2/24 dev veth1
ip addr add 192.168.100.1/24 dev veth0.3

I'm likely going to need to resend this, but I'm not able to come up
with something better for today, so posting this at least for a
preliminary view.

Vladimir Oltean (9):
  net: vlan: don't adjust MAC header in __vlan_insert_inner_tag() unless
    set
  net: vlan: introduce skb_vlan_eth_hdr()
  net: dpaa: avoid one skb_reset_mac_header() in dpaa_enable_tx_csum()
  net: dsa: tag_ocelot: do not rely on skb_mac_header() for VLAN xmit
  net: dsa: tag_ksz: do not rely on skb_mac_header() in TX paths
  net: dsa: tag_sja1105: don't rely on skb_mac_header() in TX paths
  net: dsa: tag_sja1105: replace skb_mac_header() with vlan_eth_hdr()
  net: dsa: update TX path comments to not mention skb_mac_header()
  net: dsa: tag_ocelot: call only the relevant portion of
    __skb_vlan_pop() on TX

 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  3 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  9 ++---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_io.c    |  4 +--
 drivers/net/ethernet/sfc/tx_tso.c             |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  7 ++--
 drivers/staging/gdm724x/gdm_lte.c             |  4 +--
 include/linux/if_vlan.h                       | 35 +++++++++++++++++--
 net/batman-adv/soft-interface.c               |  2 +-
 net/core/skbuff.c                             |  8 +----
 net/dsa/tag.h                                 |  2 +-
 net/dsa/tag_8021q.c                           |  4 +--
 net/dsa/tag_ksz.c                             | 18 +++++-----
 net/dsa/tag_ocelot.c                          |  4 +--
 net/dsa/tag_sja1105.c                         |  4 +--
 19 files changed, 65 insertions(+), 51 deletions(-)

-- 
2.34.1

