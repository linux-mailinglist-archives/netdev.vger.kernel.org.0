Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27BF96E9F74
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbjDTW4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbjDTW4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:56:17 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0847A3C3A;
        Thu, 20 Apr 2023 15:56:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOQpLtZynJDPy1WCdGkRiowHi05ap6q6YQCk7wTdBCOSZPrziwEaDxOVj08qv3DDyNX8MFRW52hMC2EhiBirAEg6BjobaCuSDEBdPACHPq1EJ6W3NzGxQg83kfzaCFSs1Uf3GCYgnYdzCdxSfSaiSRHbGlkhpabpDsVr0Va1r43VVKt0OQ0Wf0LtD+5kZhu209TYgPczxuSsy47cKm3JY7TJhcqn+1WI9aOmEFYdXo++ecyciyv7tf6yRq5GTd0Dg8WDzGjfNTmV0iM8Wml3GIVbmyJMtjd5vufl96iUJYuoLSicoij1zSKeOam+QrtXBHF/ydnU20WYQtftlZlLBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4DwvKhPtyrnRR8jBdwjW0fZZSak3WUxISQHdv84nq1U=;
 b=fjov1F46DwHR+1gstS3H0IjAHDS19MP/eOs8xm0Q05fGiEoLCsLeubYBDAqEI+kZbJ/U7/SV9+kyhgV4l1rLk0CPiQfIS0aE6yOpl0PBRUrqNA4pFUl4KjC+L+rctoNFYowQsIfppLvWqDq/ZlX70icPTYyZaMdX3vwXI92p3QagFjjvX42qwxQT3szHXtrqaiKnWJRV4XULxJvvRXtQJ2gJvZg+5ON0SRiDUJmLAX7KtTMC6WIz/pBe72QqOd+GsETb6jFJ6nN3fyhColEC5o1vvnejs+Kp7o8//aXQwKB6kGiwBsrV70uVuAxX6/p6LH/YW76hsmzSGVFpxXhX/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DwvKhPtyrnRR8jBdwjW0fZZSak3WUxISQHdv84nq1U=;
 b=XRJhc8CdT2eu5oNAQJWsWII3t+xC+ZP1e98xlZv7DSNV2IsptLBB894JarWRHkYoqSMC6qKFR5wYXrUPCJq5NlcjbJxA7YvbyaGmgNAPMfz+bKXHJws9USC1CEviWlPMeDsEU6PGECqPsyG5/i7W5NC4bEDbcF8Gbl7tVNR3qkY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GV1PR04MB9213.eurprd04.prod.outlook.com (2603:10a6:150:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 22:56:12 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 22:56:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH v2 net-next 0/9] Remove skb_mac_header() dependency in DSA xmit path
Date:   Fri, 21 Apr 2023 01:55:52 +0300
Message-Id: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0088.eurprd03.prod.outlook.com
 (2603:10a6:208:69::29) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GV1PR04MB9213:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bb9aceb-f42b-42d1-36fc-08db41f2700f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nB51siPNo4Vo93ZkLNr1cC4WhCMBHEuS5tiSkdym0lryQ1nuKv1hFVlY4IvnuZ5AsyEbTqysR6ftvmziBKZ/+9N0wbopTFEEZRf60H9su9a9ViExi5QG/CHeVwYs2l2VHROaF7fFrKlonqxIBdTfrxENAmFRh2fERxg4sFtFo+folfseo+a0JZv7ElQkY+limTnS/WEj0YzjaDNPJDhS/+DdAjl2B48e2lspYWrNwQzLTKqsp5F7bTKpKhdfaOcEu1Gv99s+zIKYq+3sKaPX5p9fEsY8BiSeb0w8fAfMxnwpc7kVLbRtZbMg+rBvTL/Rw7O8Sw1uscIvmg9m34KtAaH27i1t6yUMo86THRtx1aX8PQv+hB72E3qElcU94sWUpysD0liwAFjE9tcnYZ/mchWTZFfiPqk9JJT+BQSt/rgYUnf9ufVgAOPu95NNO4jvug4v21VRXDvm1X8VAe4h/0hsNilFo/r1+gmTmsp/6EaEoUQQqn0lEIdHccvtxRGJfDdvpHErCAxovH3YgAY6/jzLZHq6hEBmI/MSNtL9V8VviuXJXJ5O0LxsR1j9SJ9/94FMtngO4AqqzhtT8I126QtSatiDwT6/YDhjnFK03y/gTNSRVC5bJ3L1IlvXYWqilVo1KVO1nqEYpVVCzeK8MA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(2906002)(38350700002)(38100700002)(86362001)(66899021)(478600001)(54906003)(316002)(41300700001)(66476007)(66946007)(66556008)(6916009)(4326008)(26005)(1076003)(6506007)(6512007)(966005)(6666004)(6486002)(52116002)(186003)(36756003)(8936002)(8676002)(83380400001)(5660300002)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ve94UxeB0xCY0yfWC5jK8T8QmLhhMPzx+29QUk9jNUyVfAL+Waox9Naz4e1N?=
 =?us-ascii?Q?d0n7xbWeltLWwDj80wGqyAwtcrMwkM+1zy9rGMJAD8nCJliWEEHsDz5reLrB?=
 =?us-ascii?Q?+U0wJecYSUw5lNHVmsagcLpEsbuKkefFLV2U4JHdMMcgkgsHjTotylZMsOFf?=
 =?us-ascii?Q?BKsWzBsZsqUee42Vo5gx0sNzKRs1zVQ7sfT9khcnjt8D/F4ebTMM9AQMSZZM?=
 =?us-ascii?Q?J0Ri7BAk4WauDFTKm1o5q+YvLw8Cz7vQeDBCfI2wxJmR4v+Wf9VSP9Qup4jm?=
 =?us-ascii?Q?vTiP7JaTnIDzPSaL2VkJvppDINFmqGsUue9Dt6tPb5+2RLEAaOCe5HCrshTd?=
 =?us-ascii?Q?Sfnneox0ZFVdCsNZ2FF5GReMPs6SQaGWDWKCiiL0thBbVdc1NmwMqRUVSDtT?=
 =?us-ascii?Q?DpwDmLeJC+msZFJf4F6l48Krze1YepESPiizNg7KFdcOzEvG6I7gjfvPRNU6?=
 =?us-ascii?Q?nbBq45TgitSDUFCn0l7vACnJKp3aqhMHS88XYT+yvuB8jZwhet4SuSIyD3lK?=
 =?us-ascii?Q?qL/79ssDfxb5QT4kFaZ6jbF+l9G9XMCdMFY6/fHtB+WHnR25A7VhP4ulC6GN?=
 =?us-ascii?Q?aQpFOYOO4k225v8kqnVHGdZorIsKWLnrGF3e6oXA4EnVeZ9f/obY05urtRL8?=
 =?us-ascii?Q?DlAadqrb9pSllFffKFTzaFsP8+470mSg44OFwceSfH+ty1NFcxoV7O5Q3Kbl?=
 =?us-ascii?Q?qi1IV7RFH/YLWUoSJpHWxY7vSNBDGTpmnQQBb2dsojeHadt076/7HQ1bUShp?=
 =?us-ascii?Q?VcVAlvr1gUeiLHSoFlNoxv5vRXDQ+Xm1XVnsohEg9nWwb5jL7qowiAZGZSjU?=
 =?us-ascii?Q?rNlBK+AUN5hIgWNKvwrCd9cpsLsd0dhUKUD0clzbBuql4BoguCOdlFwkkIp6?=
 =?us-ascii?Q?Yze/arjm23k12sxea6/n4NgISbV54FlDRYqWJLCSH7+4k7rHls6BG/smFdtO?=
 =?us-ascii?Q?N7zBGV6vQ+Vh1mGeoUP106wG00m1hoMIIS9Qbw2tY56NUOJq3c0mIKzJEklT?=
 =?us-ascii?Q?FR7J4/r0w/iX1bghDAaFUAlMA3YThbAbctFhTSLLXW9CSN113A0OFwK/6XG8?=
 =?us-ascii?Q?5HQZM5zjn7gpYoEngMbspFvmCD/34I3AvTNn3sn1/dv3gr9a4YC0iXVyAWxC?=
 =?us-ascii?Q?FYS+P42hb0h5u9SPsuY9JvlEWHJk90W4/6Z3WvaVo69L5PcGKjB+K2GU3MDl?=
 =?us-ascii?Q?ZRwHc4ZfCCG2ZHC1r18W2wtD3SKSMvQh2X3fCIthnDjhv73t846C3IIF/4K4?=
 =?us-ascii?Q?NAYPFTxpYixffWcn4xdu8oil2+BpDpDinQHNztPswFSmNzFBXekiESXcpvCH?=
 =?us-ascii?Q?FfBIGf8CypAj7Tn6uMiZdoXtdLwJPIt6p4bI3BHed3dkLXvxeo7PPZ7LHAX1?=
 =?us-ascii?Q?fTXhTJYhBdLrOH6OqecXCt30xsWLhK0D3FwNhKmXDlsMQvMNg3JFZIqu47mr?=
 =?us-ascii?Q?anwc6geS7GSQPSoaT9yRhKHAcbYDofaGQVCcYvOopHo1sUn6f9jxP2G5dkWS?=
 =?us-ascii?Q?PuC2iXH+MEn8mlUrY0VobsKqe+s0+lONqyxQVIkWZpNGuF+0fs7mNSBrknoN?=
 =?us-ascii?Q?J5JMCkvDsqriwokuHOMb5CNeXLkCrzssxY9ZSkoFUlI9idATr/QZcdsHKKNM?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb9aceb-f42b-42d1-36fc-08db41f2700f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 22:56:12.2606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CMJXnxAnMlzZtLUhxzJZauSTAQsw5uO1+z2MaiqEpSfy92zAosX913gYg6aRKpe06s4pKx5UBGk3+JTPaFPWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9213
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Another potential caller of __skb_vlan_pop() on xmit (and therefore
also of skb_mac_header()) is tcf_vlan_act(), but I haven't had the time
to investigate that (enough to submit changes other than what's here).

v1->v2:
- 09/09: document the vlan_tci argument of vlan_remove_tag() in the kdoc

v1 at:
https://lore.kernel.org/netdev/20230322233823.1806736-1-vladimir.oltean@nxp.com/

Cc: Madalin Bucur <madalin.bucur@nxp.com>

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
 include/linux/if_vlan.h                       | 36 +++++++++++++++++--
 net/batman-adv/soft-interface.c               |  2 +-
 net/core/skbuff.c                             |  8 +----
 net/dsa/tag.h                                 |  2 +-
 net/dsa/tag_8021q.c                           |  4 +--
 net/dsa/tag_ksz.c                             | 18 +++++-----
 net/dsa/tag_ocelot.c                          |  4 +--
 net/dsa/tag_sja1105.c                         |  4 +--
 19 files changed, 66 insertions(+), 51 deletions(-)

-- 
2.34.1

