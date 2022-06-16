Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFB254E206
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 15:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbiFPNe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 09:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiFPNe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 09:34:28 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C259C1DA65
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 06:34:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5YifpUTYHjS1khkkqxQhr++XJg3ShDZu3jz3vHfggn389YBOyRH7MV7iL7Mb+VGNilz13xtQT/aAKyEJI2w/7qZ/DBLtR4HwyecAHDHCQFszDwZix0WYkcP3VUI0YDTQSy2h4Q3kO1i3TU6jOFEvynmMiDN2G3OiI+FjSVzw3U7ICxigh08HbzbGgflSuxRiuGUTSyrzTKFnQXsuW2aLsSxN8ITQCLX2RSA5MXB35ss6K50GABzxBpm6y72yw9rrrxqq8gFiHCi2KTmeK/din+aE1SMVF5HnsbM8KlI+YUbRgyB20kuLyhB8izekifppI1MPrJyLU8bYfEqaD71dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCQ1iIXTe1b5UwFpU25twiAqfis8zYJg8ABp5IM9u6s=;
 b=MizofL384Q346rOPmf3ZNApbvW414XBi1GmnunyXoTNTeuXr2jjoBPZJrCJkaYlNpEG1VNo3tOOCpPNnqMI4BzeXmDUy5TAC4lPId5LSZ7j/oK7KykXcgoTOsl4hp1TBirVWKmoevoeq0ZwwI/SEDzgdoysozCGytYjpteGo8JAHlO930/sX/NjnOwrvIgWqnczgvvU84B/yhOhzp1jn/OzDucV+axKSDbOcC10yzgXctdCZLH33fYKnHy7KdnhmApDdgIoy7YARtzxR5VH8hrZqsMdpyvUQyUqFffxX/GRAY8mx2Oeozij+TtH86wzYTQC80GtcfW8653NCCTumhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCQ1iIXTe1b5UwFpU25twiAqfis8zYJg8ABp5IM9u6s=;
 b=jA+TO5HRhItDhMIsmPzegS3pAbkUAsgpJVirrTOHlvE+vYgUxFqIofcKwXqYQxBsrY7aa3yTfBd3BzrBmBlT/Vj5k65MzO7Adbls4cbAkIhVNs4miOLmtunX9GZmQ74C/EURmMuMhJYb49H/Qt3mbQsHBf2Pssqig0SA1TgMPRA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by PH7PR13MB5596.namprd13.prod.outlook.com (2603:10b6:510:131::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.13; Thu, 16 Jun
 2022 13:34:24 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::2969:19af:7d52:6e33]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::2969:19af:7d52:6e33%8]) with mapi id 15.20.5373.009; Thu, 16 Jun 2022
 13:34:24 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: add support for .get_pauseparam()
Date:   Thu, 16 Jun 2022 15:33:57 +0200
Message-Id: <20220616133358.135305-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0013.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::18) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19992d25-dd94-4f50-0fb4-08da4f9ced6f
X-MS-TrafficTypeDiagnostic: PH7PR13MB5596:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB5596DC6245E053EDC639A6A8E8AC9@PH7PR13MB5596.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ICru9Hq41fUPz1y5wbzsvP2GobEsQl9L9KZwyYTmeSNOFdMB4xXLq7D6GGku5JzJc532FU6fy9OjF1jMFgn9NFTrR8p+LX/wAEVfXaBqRjxvnz4VKa2XDz2w3L5lkv0xXOlhDOLr5YffB5ftKf/739JePt4A/B3NOxoXQAkV22Re9Y5MxL06unRWCsw5QtirrAH6UlTPwuL/huoN6vV6dupyG8a1NAMyO/jWT5gCNhslF3fA/g8sR59++Ng7tB8HNbWJhh/S8574SWxK2mkauBdBN1rWiM+sAudLIox6s9fOn3UM9RIX7baSKocfNdgq6eZRY5u+D75aqVCScESr95VBiM5h4AcoeC4ZHnizqcluY6vFfyjHKxqmyN3R874/jO1BBhdingk1sCviWKFcR1yoazqmNHXDoDCQcsqnqzyjBOEzsxAQFW6rzR/AbMgNTYYjDgdYP7S5xAM2mFP6r/DbLZ/KW3LEsRJhbzZIwiqEZ3HyyMVcbkb/+07AnoDeO2zY0Pl53Nu5R3w43Siov6oG3vLioqvvqAefi7jHwKj4J0I4gs6LptgD/1mqn4ZJa6tfOuNcHK+hb6vzkiugd4zjIWghsjkptaOJZwX3zzZ2CGf+er878EA0wQMjouu+J9qTcnsT5j5B5q1gXtgmJAaanYapQyPMv9jTdWjwpep5lHk8wglGuFeXP7x+IpsBMM358N8gPq0Y1vHTEeXK+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(39840400004)(366004)(44832011)(52116002)(8676002)(316002)(2906002)(38100700002)(36756003)(6506007)(4326008)(6666004)(6512007)(508600001)(54906003)(86362001)(6486002)(110136005)(5660300002)(107886003)(41300700001)(186003)(1076003)(66556008)(2616005)(66946007)(66476007)(8936002)(142923001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h/vynORJgEhPgqz5J4+mFpqzAwVstsKLXFqAWuD/JKsBQH6qyX5eocDijSvT?=
 =?us-ascii?Q?A4CY2Id6J3dwvIG+m3YdfFs+q2yyuVGomYm2VCf0ngUeCHtm/RiYSFB5nPzG?=
 =?us-ascii?Q?rH/8KCQ9rBoE1CjbYRU91QOyplQYzCjT3351TjaItJ4FpJRJ9bL5P5ikAl7I?=
 =?us-ascii?Q?l0JJPPSdBAUCobAqZ/0/2HCscMvoGaNEZor+DsyBwU4VZQqcDBp7JEk+59m3?=
 =?us-ascii?Q?JPB4usZNBPfMwDSh8rG3q1S9KRiVz8lX6vluDuvMs8o3wpLWaNteQU6DeNKT?=
 =?us-ascii?Q?RLaq16qeLELuh1+armpHyLOdlIFnp4dOZONhJymkpxuPNbogRAUnZhbTYXZC?=
 =?us-ascii?Q?DHogCKx8KwokJpoYKipCKfyfaTHElGVAxuW6QtMun8+w+4VdyNP9J/KmnqiP?=
 =?us-ascii?Q?flGZeVIEDeb6GepfJVjf2i1MN2LSK7xM1nCjF2U/3iTVyRe2kDqU0Rr2DfQx?=
 =?us-ascii?Q?uzv9TJUZmAwyFnV2/G1q6O7cfew+O5L/TDlethl664RjKrfWS16+Vvjoq3ur?=
 =?us-ascii?Q?Omb23u/K/0H4o4GQS9N8zmJdi7erV2Z48+EbiQqRAbbadk2Lisr8DgBQSDAy?=
 =?us-ascii?Q?oYaJH1nn5+CqfOED4OeVVk/Ux2qM6Rj/J+cEHB7VE8GX+nLyYy67XcrIhIcl?=
 =?us-ascii?Q?ZdXden0i1I+aMk4/gunJ665maUJMdHZ8ppUhYTaMd/zOoDxKH29n2VPQY2Q8?=
 =?us-ascii?Q?8g8gonvl7BmUlMVI+XuBPWt7XgCc+GgCo342kCkaTUOJw2gL8xM8Jhw8JxXg?=
 =?us-ascii?Q?E2WI+lp/gnjbNPYzVGqfulD189AUqtQBgSy06OWQSLsGMUGuwyTkzS5ra57h?=
 =?us-ascii?Q?OW/L7yc24PeUSW8oA4kjAXMfyjvkgJkgcWbD5I2d8dePzVXaH2FS4gqUuFpt?=
 =?us-ascii?Q?C+Ou+zHy6pRGJqKsHwwFjuB3xJMHa8LgS/wIA6WdaQAghnzTiNZwLOHpC7Zz?=
 =?us-ascii?Q?ZWLKHCXvHVYDVVp/VjAoR73fJKjY17dfLrMY9lahI3HBXO2k4lbSJuy7knAy?=
 =?us-ascii?Q?MB/lVBSP6UPxJg/ll0bkrK4HGKYcUdsYHFiZI7dcCb1hmPEtosWkgWs1cT4k?=
 =?us-ascii?Q?ztuGMAW5XIAlkJiW8C5N5pcRrjcaVvjXI8PB9gJusftDgURvu8uz+JYvDJ/Z?=
 =?us-ascii?Q?/UNnMIQkn2/LdX4jThacBkVCmzYbHkCKY8SI5Y8OnzfFcz9GefzM+NTpm17f?=
 =?us-ascii?Q?6+bgrPsbEKokaOqCpmg5PJX8MIPyhzv3URV1BKUEe10TgpoygAZgCH8OF4CR?=
 =?us-ascii?Q?RpE7Ws/gpP1Bl5kc4tyoYOssdamW3y1EB7grADqjtp2bsztbtdNXS6GgqHOy?=
 =?us-ascii?Q?9MiuQ/R8Ax2TD0uAh0YT1W0jLU+PlA6I695jP3oHEGGEFDnGd+I8i2+X7Sj7?=
 =?us-ascii?Q?/chan6LosEf+KAXdWHC4LQVdTKG6JQzXYEOYzrbdXjlZKPvpN8koAaTQ9Cba?=
 =?us-ascii?Q?ebUSAQFTGZ/HFysla1wtmVWt6zATmId91svSwi+vID0Q2omvaxLmoOVB75tT?=
 =?us-ascii?Q?f4Fby50f94ydxE0KaFTC0b9tZJfi6Eyi18HTZznmb0Q9AGwh2TNCdDT6zVeX?=
 =?us-ascii?Q?56WMNAWChtzx15RZGzWtXzjBr2durWqe1jrazrEuI3z+BIFB8sifcvASgyhq?=
 =?us-ascii?Q?dF6lxb6JWmZtzhMWZmqRbEpnkRK1kEUQ+kiH+6BEuQrH8lufuc2fyl2gEC6Z?=
 =?us-ascii?Q?Q9zexI/eAdN8Hu/s/BrzyQVMQEc54L+SAonYjTt3o8stfC9MVbq1zdaLMLDh?=
 =?us-ascii?Q?aqez0KExWX0gao80BKES9s0PSQdhQ2kkwXDUlLevVhGCbERdI5szEAPys5hs?=
X-MS-Exchange-AntiSpam-MessageData-1: PBH5l1BAsglH2WSz8ABIlay/7q+oOf0rIlM=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19992d25-dd94-4f50-0fb4-08da4f9ced6f
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 13:34:24.4879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q1SLQD5djlnWKb1eW0KH0stKC/wwDMHFNFYj7t1MgcoAOHs2Drxc0mFbgFZL0phNNd3If3L9EbspKKohKkV6ITLUeT6A72OPFxdUAUwWkUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5596
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Show correct pause frame parameters for nfp. These parameters cannot
be configured, so .set_pauseparam() is not implemented. With this
change:

 #ethtool --show-pause enp1s0np0
 Pause parameters for enp1s0np0:
 Autonegotiate:  off
 RX:             on
 TX:             on

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index df0afd271a21..15e9cf71a8e2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1460,6 +1460,23 @@ static int nfp_net_set_channels(struct net_device *netdev,
 	return nfp_net_set_num_rings(nn, total_rx, total_tx);
 }
 
+static void nfp_port_get_pauseparam(struct net_device *netdev,
+				    struct ethtool_pauseparam *pause)
+{
+	struct nfp_eth_table_port *eth_port;
+	struct nfp_port *port;
+
+	port = nfp_port_from_netdev(netdev);
+	eth_port = nfp_port_get_eth_port(port);
+	if (!eth_port)
+		return;
+
+	/* Currently pause frame support is fixed */
+	pause->autoneg = AUTONEG_DISABLE;
+	pause->rx_pause = 1;
+	pause->tx_pause = 1;
+}
+
 static const struct ethtool_ops nfp_net_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
@@ -1492,6 +1509,7 @@ static const struct ethtool_ops nfp_net_ethtool_ops = {
 	.set_link_ksettings	= nfp_net_set_link_ksettings,
 	.get_fecparam		= nfp_port_get_fecparam,
 	.set_fecparam		= nfp_port_set_fecparam,
+	.get_pauseparam		= nfp_port_get_pauseparam,
 };
 
 const struct ethtool_ops nfp_port_ethtool_ops = {
@@ -1509,6 +1527,7 @@ const struct ethtool_ops nfp_port_ethtool_ops = {
 	.set_link_ksettings	= nfp_net_set_link_ksettings,
 	.get_fecparam		= nfp_port_get_fecparam,
 	.set_fecparam		= nfp_port_set_fecparam,
+	.get_pauseparam		= nfp_port_get_pauseparam,
 };
 
 void nfp_net_set_ethtool_ops(struct net_device *netdev)
-- 
2.30.2

