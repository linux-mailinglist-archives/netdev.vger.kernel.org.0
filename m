Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D66B6C5A97
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjCVXjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjCVXjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:39:02 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2054.outbound.protection.outlook.com [40.107.7.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3498F30B09;
        Wed, 22 Mar 2023 16:38:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPptFGKBDP5J5zHuGBTCaT876idcJIxtpd2vLwIhPQBgPLzX505VGMvpBpSz/jsBC4FQ8SIVhARiA09T/xN7XIOU45qGoyvboBujwrTfFMrboZ88uZ04vtPp8Mt5SpsVs/+taPe5KJ6wwP+MBPU0nNF7rLbW8HqYcR0tdruf2P6/oyL8iBtjtHC1A3Gm+BuFmnZcqUXT8tcD1LWa0msKyYesk6pZSfJXg5Uwgwu1pZztQEVHcatwYzKE5jJJ/tLUVQeacrUb235JaFy1TfwQClKQDbjftUItetN+9jgA5N9uLnBExJue6Q6auL+iC2UU88BtxNavyQtCmOgx+J4L5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iuG7JlOYD8k6GsNacoQTqp2qO6qIQjDuTf13A154WU4=;
 b=RjU7YMTyZ0Tey5a0qsI2khLqYsX87BaAbHL83sCQpbGyX7Zei1QpWma5oOVeweIGUhXMor/30TkbLJ5wP5vPMbhCDShxXn2AvCWPZCYqZVjXy5YsVMskibOT74qlbUv/TSZUOPUujNq34v27T8MP5m6yzwjmY8KqlaH+lF4qAuMhx6/Mjh1Fg+oCz7mvwXutXliLZrbbD0L8wQo67pCb3gkIcFyrKVQtQr7liXOXY8qDlcvl6gzHy6ZrTF2gOmPxa6uEq/VVgYeQIjMCLRD5EkEXQlvCT5U14okG/U3yrQPVm4PuKjsEIVP2AB72UshGX6GX8ETRE6O2gONRi/pwKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iuG7JlOYD8k6GsNacoQTqp2qO6qIQjDuTf13A154WU4=;
 b=FOTgz6Fik5DoJzkWwqWVgoov3hN/HL56clNFRd6cSdTCX4yCguivfWfx4+B0soCsELya4o/ZReZ+YX8M+GMHE48fa8rPtwS0sQ2ROZ43s2zeL4NXg0Ri8rBnOsn2FQQXzJBT7srFadc2GTTTPBVGty56COdkLlRZmil9Q0eVry0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7263.eurprd04.prod.outlook.com (2603:10a6:800:1af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 23:38:41 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Wed, 22 Mar 2023
 23:38:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/9] net: dsa: tag_sja1105: replace skb_mac_header() with vlan_eth_hdr()
Date:   Thu, 23 Mar 2023 01:38:21 +0200
Message-Id: <20230322233823.1806736-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 50fc0560-2364-4c5b-647f-08db2b2e917b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W7Fs1D/A8ljPzOIGbqok/JAP8/PTarfw95xO2kbpaVhphu7DS8O6aECsHYC5GQLoYzsudRdn6ofTitjiGAmDn/LV1kL1TqFUW/GuKqDUfI3I4QY6Ze41k0BYIV2nR/ovTK/U63AT7z/ldIUN411RU+31Oor5BdOsUKRlRawELmB8rnKgrOUbJBaILK/L23nhQhuHfFNmoODdzITg3labBqreoLVr5E1qw/j2xjuUK+J652C1U3uLI27RVZDuGf/2jkVraflvXoZ0PKG+QJ11ZxTPiTu8ew8KLj37KZyD8kgriR6DF4O/V/0SzF7IoYhf2rw8zQQwUUy+FtWPyvd+x/WKlQvYZovEI01wOJc91MP79OPJzm6MJOK2YnEPKUVjCMA7Oj7QL9yDdx3vzDTeLIKsM0AGDh937vjqIQNXVMWe8nM0Ujk9Tvwk79K+wmssUsmBsImprEZ7gkdxm3iLU4Ea04EOehYa02IL1iUzPUHuD+WfV7BFTQuPmIOGISgzHlZXr37SHBgTMeW6M4oJ4Hzk2oJWVJIfUu41UmgRy6prjncUb/qpn1sn2h5kRzU0R5rnp7AFToBz0klSK37yd0tPzHOCUWaGBr8wku1WSAzd27VtcvJkOzEk7AUjtckVw5QnzTFLbRFmKJhp30cF0nZoDWsGuyyW3vg2TYi95LgPUAqeg355wsHxVLCX0aPOVFQsvNvU/0OGzydT9och3n8X1qceiX8mtSrqGagwJ+PptlRD3f+MLiDK7r5DjbU8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199018)(54906003)(66556008)(6486002)(6916009)(316002)(66476007)(8676002)(66946007)(478600001)(6666004)(4326008)(52116002)(41300700001)(6506007)(1076003)(6512007)(26005)(66899018)(8936002)(186003)(4744005)(44832011)(5660300002)(2906002)(2616005)(36756003)(83380400001)(38100700002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M9hSRw6z7hqpmuGVB21ws40W2rBM9DHJT9Kkoxyz1aAxHqAsNninjobNYrRR?=
 =?us-ascii?Q?PIyWTLiGx6FeW5RdLE2nzs6qAA3ZYHKuRYC6RB/he4CNZGXNi93mij8kIJy1?=
 =?us-ascii?Q?8y5Axw93V8UEdYaQhNwCwznX7/YSZvgXRREYlK4xev9Ch495XfbO0TerG/H6?=
 =?us-ascii?Q?GNLR426WxwaOI/TBXEOweuMjmf3qbZqDbLi9FnluOcTmXaiGDB8/gJ1Qh68b?=
 =?us-ascii?Q?wNnZeoNsTwrRn5tacorqgi4xN+mllDvejqEtLJEIq7xIqiezVQDjYKAjlzyo?=
 =?us-ascii?Q?W7MKWrybca4dxufA1QMjsNjRSYZhQYCFHvAKukNuwfX3jkUPNWF0JCY273j9?=
 =?us-ascii?Q?ldDWrQcoR1H/OUZGftJZLIumrxEJj7yrmqWyBkdEj/r+1ju13+iqm+TIthAp?=
 =?us-ascii?Q?+GwjzWqUBY4HmpeyGe1Vf7ghrMTLHTChGmiHjcKYWIeWf0dtvbXPNd44ioMS?=
 =?us-ascii?Q?AxMCSnBQXctykEhlzd1iuh30Iqy3COLn5F9lw9QTawR/FSxdQZF2SESe1Zzl?=
 =?us-ascii?Q?VQnI4LS2iWJcdJ83Eo32Oe2JzOfYmGN/QGhazFQ2nRuwAcV4JP8JB0qVJyOx?=
 =?us-ascii?Q?vlPSgvoXBjpkeEKTCTfTcBzzrWK2+FaLQh09S9PAekGDt6ucw8kMWs36sb7I?=
 =?us-ascii?Q?D78beWTr0W5KvKUaM8aMO8ND0hq0uyGzihujcyvM13+PeJvZMMh8Y2h+O9+J?=
 =?us-ascii?Q?C0XqsnwsuFHpGRsae42CPA+C1dJMrbQJ4LRjZY2UJRg1by5aT9By1FLeqdY9?=
 =?us-ascii?Q?fknQKHJfl7z0zktYLOEoiBqrZD/zzgTPXoXLQCz7QtrbYn6XO6Ghe+uP3ZsX?=
 =?us-ascii?Q?rV0gsoJvbFfu8lfm7BBdi3LHZonS/uHY0pbs2FAIGM9EOdJjfuZ9EJ13C/JA?=
 =?us-ascii?Q?OHpnGo0eYV2ZxQ+2pylPNNvtG7AtlXfoERj1Hv5FXGL6NXdevLjYnuN5ujwH?=
 =?us-ascii?Q?5hK1w72kksqmzUQPFsyHhhTWRBy5xWL9I0u780esan6Ig6P2q3B1/lDNOc/U?=
 =?us-ascii?Q?rBj8u151iNwdriJRkyn0xhEqDMQ7T8ystGEyJ+NKgZr3sXM/TXMva/AW+TC8?=
 =?us-ascii?Q?+wLR31U48Im8EKDFhPKRWU/mVPNGU0R3NMc9cKZo2H4ldG6Nl4OfN9JiMisi?=
 =?us-ascii?Q?8toY63lGK8zBJ6b6jCfi//uutJPtl+VZPuwRdvhP5gZ8CwtSxxDEYyAEBoSr?=
 =?us-ascii?Q?oacOb94E4NWNTJbA6CQlq4PjPLRxFmtd1cgfbwV7+yZj3nZVDWK3MlQuQoUQ?=
 =?us-ascii?Q?BlLmuPsdrAXCYnqcNAfk0fEKPPYp2GLu+wQyz5cbOxNBr8kdnLsIEo3ojSro?=
 =?us-ascii?Q?VpCgk8Ne7DwXZKt91QvtB8ANlMIlRxc9SnZdCnYIizEd5ItvufTgZxCue1rh?=
 =?us-ascii?Q?Ix9fLKZbM+1lJlW3K7UMK91FGcA9j0jPu9p+6Hcpi826IyAHbCGBWWwprkty?=
 =?us-ascii?Q?7/8gdgn8yIgYd4EMeijbNbpHopeMFhJdOWY0Dlx3OW8EwmO9LLBl80LuTf/q?=
 =?us-ascii?Q?Omy+CsJrThC0V0dDkRfg0r4AO4qUR+EHGe6lws5sAhIdZmryegn89ErcodBP?=
 =?us-ascii?Q?voZ/zvCllhIQmUS258FWxaJmDYFPdzABAgdwva1W1lQunTy7t4O3HyTVnpc+?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50fc0560-2364-4c5b-647f-08db2b2e917b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 23:38:41.4048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACP8B4TclMQtcZpgPfz2vtkRS+hOheFa5wQBlC9yPvmFg9WYFVcyQvjH45FOcz61NapoD8ABI/lM20qusezpJQ==
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

This is a cosmetic patch which consolidates the code to use the helper
function offered by if_vlan.h.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_sja1105.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index a7ca97b7ac9e..a5f3b73da417 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -516,7 +516,7 @@ static bool sja1110_skb_has_inband_control_extension(const struct sk_buff *skb)
 static void sja1105_vlan_rcv(struct sk_buff *skb, int *source_port,
 			     int *switch_id, int *vbid, u16 *vid)
 {
-	struct vlan_ethhdr *hdr = (struct vlan_ethhdr *)skb_mac_header(skb);
+	struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
 	u16 vlan_tci;
 
 	if (skb_vlan_tag_present(skb))
-- 
2.34.1

