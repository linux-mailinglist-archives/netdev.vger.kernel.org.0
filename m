Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D134E4CBF5B
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbiCCOCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbiCCOCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:02:30 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80058.outbound.protection.outlook.com [40.107.8.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2857964BC9
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:01:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSqdMYqRYQy6TTOqv/MfCvE+etoxE37UUAfaNg3sshDYc0aXgEJ9rqsMMqqztRqogw9qE+V+kQ55X8BUlcmFvJM2Cb9y5fxFb5Czu++aMz0cjvoujQfQsBb4EFG019EwEC9jBTw0cae/ac1/+0vyeaON2s4Qnc4vC4nx0PCPtv52oLofNCg61NFMIFu0oU0E8IW5Y5+XwvKP9lkgyy1AwCJlB6EL7K+xPZTj20Cmjlwc7xnVA7RlCOs5lm9DjptzHP45muqTG7JCPoEYsSAiCl3M1QHg56Ra0eZRrnkJ7Py4243ZcNqM8yVsPwg/yB636LDOhPdmRcN3Z4hfYlwoTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6VzGsC7tJQbCrrpmRVuPeCew7ZVSipVafakrnKjnZs=;
 b=SmXKkZsSPZg1lWoQqeKy6YBP/P2F+5tg7EPkIKkrhX+Ng6RD0iqRagP+aIN1aE9LdSXfERgO8g6Kjpww4adKRJt32wGxodqRWzP+Qvo+VwwiC2QH3i4lnnmfvRiAaczX1KulbKjaBc9sCm8MTIg2j7XAkEE6VSgUkh0Z9Odzg2yqEOA0oS44ZmNLx7GVHor08e2o9AnpdEFGgXSVmBaVOiB76yYHHIP/92aUm5cP4//9KkMyMQMVBzK/h/dJdZ9IkMQB1IsaNQOtS/M7nLSTaucgQK87FjlVwolzU5DPQVvHnpogeSzJ0qrxsCiuo3Dp7hF54Z1eJ4vCVnIejIYZmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6VzGsC7tJQbCrrpmRVuPeCew7ZVSipVafakrnKjnZs=;
 b=J/rwMbpLuYwZk7XTCEtWrWdwJWqjnGN2VrwUvKkvebEg5zsThHf2JodlC3IkYVN4P2a0IhITpkGxvkSd7B0XMaupdG6vLtPsz0lULQ51o/8b4Tu2jq/XsjAFLNRctpfOrdfu1sWIbQcuPlEqdfc54tR7h5vG23k0DErsVxGMtLw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8879.eurprd04.prod.outlook.com (2603:10a6:102:20e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 14:01:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 14:01:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/7] Cleanups for ocelot/felix drivers
Date:   Thu,  3 Mar 2022 16:01:19 +0200
Message-Id: <20220303140126.1815356-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:803:64::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d839d8c9-e1a9-4db3-b986-08d9fd1e5803
X-MS-TrafficTypeDiagnostic: PAXPR04MB8879:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB88795ACD5B56285076732A7CE0049@PAXPR04MB8879.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jjp/nPFlHehB4Tvpese+9dCEowaCOm7PZhbo/mm/SAb4qTTaNbtRfWOffItyZICZQzfUMKMQFDtvuV18TjMnquyL6z0l+xmcMTagxDS0oa2j7zsNSScuuEDdo4mM1NKLwIE0Z/tltY9VAMeTS+JhjJTVzc6SDSo0nUV1IaGbs4NW4IU0gnNt4VHaIUPLVXQ/GSgy1daWckitFbfWoKIrmRMqFMbEZSyMPl+jbP6MgvV/aIhOjtEK2iKDTS0Q+umPjFgGKTfnta1VdNozSo41mAWBl3V4mrPzE/7H8QPAZdwzPryTJD2S0He3amsLuIGdY6fVXPvsrI75J8t9j79T/XGS05L0AxJ1iGdJ2369FuynHto23lzuWUnkKMS5+7vZE384pKpBS1s3X1czcBiTqEGoI9jnLENlfkIsTwgBAKRI6XHBu10JcbKQ9j3QSDKtgwjyyTiaq44Z3EDuM9UrNhOi+uQHounar7z6qj7yvOAUbL8SZn+u8Yu1po/txI8a4AwjcH044pkPNnc+8ZAIp5wuWPTdypTcWxgNwC8ID1r+fZF6dSdciLLbzsUvu7XcnPJu6XoELCE3HB4JCvwVj3PVptsUnwCmVA6IuUqvTIWcCyK6uRaJPKSPpyDCM8kmNRDBBB1r1SjJ5Ks7mKjXwYozjkDXVBT19rRqecYL5vhUkh8p5URXKbC2m6bxOaOIzzVbi9SDvWVCJWlqpXqtnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4744005)(7416002)(186003)(26005)(6916009)(316002)(54906003)(8936002)(2616005)(66556008)(52116002)(6666004)(6512007)(66946007)(66476007)(5660300002)(44832011)(4326008)(6506007)(8676002)(1076003)(508600001)(86362001)(6486002)(83380400001)(2906002)(38100700002)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mf9zwH9QxAcRYBN4Ds5FZmr7BFa1aUzr2oqyq3uBu2L4+nRkJ8bpk6y7xjWH?=
 =?us-ascii?Q?8CgTJlMTMmog5Jw67Vj3r///RWjjNLczrg9zAJKlGyLCCVSqZdrLSYmxO1zr?=
 =?us-ascii?Q?/ewBhw8IJ3lop1t5MZMJkmqy4nmz0GZkmDtRhdNSnCNDjzIiWAEJJ/rP1jPF?=
 =?us-ascii?Q?3gpGzjC1Y1RfWTACoTIJXpdhwMDWyNfrqtHjjO3KAZoe0O4Z51x2L+FTkCfd?=
 =?us-ascii?Q?Br4ezuL1QtOcRrisJfUY9NBF+IBoBMCWtTKsQx5A1u8z1BA0g4sCOWq1dHTg?=
 =?us-ascii?Q?fqNC40ofwMfMov909aodPQOw8u6AM9iHx0WEM5de1PqSTuD/+yQPWEbFR3BT?=
 =?us-ascii?Q?Skcu6OJ4zuQhWxO/dvzi29cviqIka1CikZ2bNvqxcDOB+LSsja0I328Y8bn6?=
 =?us-ascii?Q?3mm583ftD1YrBATIG7V+sfE/TUyoJkNF3Thnjx0ezJ4HtbMjgD111Smob2Fp?=
 =?us-ascii?Q?qkoWEaTpr4yfVKbry5CK/beliM125Zfmcem29YKNZtVlK8wHwLIymHn+Eh6D?=
 =?us-ascii?Q?MULQw2ofQFvY+/2fS8rxMCjhhpZXX6HVF6bd9qHHQi6F4VNykZWwv7N9sMCU?=
 =?us-ascii?Q?/3/qLPdkTqJ4Y+aXytn+C4U20bze6h9BBZyRz6RI15XGJlgWLxBp5TwxwIr6?=
 =?us-ascii?Q?3T3r/+aC7T+WVO5kKw18pOUBAAWS3UORzYwWd0zrupETd84BRb/ulbn85HHD?=
 =?us-ascii?Q?QzR0t6R/M3vdVus0Bd5J9m8NCwHbisnls8FJJvXKEyZnwzSY43hU7uUdJrPo?=
 =?us-ascii?Q?23FxPM/ISf6HbaDE56yMrR1uKZStoAdMmbq1qZxru1bXkcWevYUGCkENuWig?=
 =?us-ascii?Q?J8Alq5ilNsaEBIo/cdk4ngng0ENSx1lsxkLw7Nz/d/orgkwwI2E5PRq/jtr/?=
 =?us-ascii?Q?Wkmsy9J3L4ZDmwy/Z6J4jeon7nQc87OmAroMYs5y4m/mTgMsdcko/gRA6prP?=
 =?us-ascii?Q?5UvN0V6jhaRU9sZ9Ai1DL3POo9wjrMzI3sFRI+eTkdVXKAkjmGX4XodCR4U1?=
 =?us-ascii?Q?DJxUS/Pw6/T7bCYRxuP6/I2YsL5hdm3eTpsJrTIVWhvUdARMD//eIYkcaRe/?=
 =?us-ascii?Q?9hg98yIZPwtWu9ov5LPBBgUqy7YzoHbVZleevQT6e1wORUTaaAOad9OJTaf8?=
 =?us-ascii?Q?hcUu/a/BKC6hkfVKK3KuftZW4DAsqp5nlDMUlD9KBfC7jt41eXJ+RTLCl5HJ?=
 =?us-ascii?Q?EEiYuWcbvisEDmsAzlgCJlUhSVRX2q1C4UTpXKVVykDbdhh8zV5/XRYDxMia?=
 =?us-ascii?Q?85PxBmaOvEBLOKIBGYRDCPugM0WiA7Wpc7JY9ARRqYTRMXiXWTX73CFMi5bz?=
 =?us-ascii?Q?iKyGrPX4wErrNA6QZxyY78Z3CIEwoGNu201akt5h6jTxdq3nRulu58eToFCd?=
 =?us-ascii?Q?UdXaPFd6cJRlqIq7R4gF4LVKyza5XrFJdkp0CTmuuCnC1d1mtcaSNZ0ZF4ra?=
 =?us-ascii?Q?L2W93J3YvF4zBedQHyL6TGZfAhtMZ/t4t3vwrMknfpJhS84dtdsAAO1wgO7P?=
 =?us-ascii?Q?UUGz8KNOIGtfrfq23bUtZM2bG1PKwOyUvNFqiSKLnkpcFPCQM6hbdItxig4J?=
 =?us-ascii?Q?OWLxPc8ObwW6jeRR9/E+YgFBQrlDAyzShYpsYAayxpdY0Dot0rd1u2yOwCBk?=
 =?us-ascii?Q?R/Oh7CE7xl8fhHns8fJvsgY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d839d8c9-e1a9-4db3-b986-08d9fd1e5803
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 14:01:41.9464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: giIc4n0qyuwss0Z8n0e3kdWzF7eUN7d2n/niUqTHfcu/2BOTfo96ErxmV/ckrYYVTyHF77s4L4pyg9AAZmeD2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8879
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is an assorted collection of minor cleanups brought to
the felix DSA driver and ocelot switch library.

Vladimir Oltean (7):
  net: mscc: ocelot: use list_for_each_entry in
    ocelot_vcap_block_remove_filter
  net: mscc: ocelot: use pretty names for IPPROTO_UDP and IPPROTO_TCP
  net: dsa: felix: remove ocelot->npi assignment from
    felix_8021q_cpu_port_init
  net: dsa: felix: drop the ptp_type argument from felix_check_xtr_pkt()
  net: dsa: felix: initialize "err" to 0 in felix_check_xtr_pkt()
  net: dsa: felix: print error message in felix_check_xtr_pkt()
  net: dsa: felix: remove redundant assignment in
    felix_8021q_cpu_port_deinit

 drivers/net/dsa/ocelot/felix.c          | 17 ++++++++---------
 drivers/net/ethernet/mscc/ocelot_vcap.c | 12 +++++-------
 2 files changed, 13 insertions(+), 16 deletions(-)

-- 
2.25.1

