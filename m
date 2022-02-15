Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6534B7906
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbiBOUrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 15:47:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244165AbiBOUrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 15:47:48 -0500
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40046.outbound.protection.outlook.com [40.107.4.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D540D5FBF
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 12:47:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1lEE8Mhv6f5x6b1+ctUacOguSOmlMz4CxP7V1TWxoDMU32/bz8zc3feWXNagnFrBwYtUn5tJFsFYWynCfC0Tcmi4WE34LW5ply6bQUVo2NUy8io5QJSv43GVjY1Nx5CmFTDi9PaOi87LWXPREoiKSv+tHqkbJ6ld0ruyhabWRtIxmEGnpjg+vmx/U8pcz2iJshFFueuF3+9RLxCo1LcnwTiNVAxf0R1yStdnrhOAoAxQ+s4FHcJOlBtjy3ab04q/KjEk5WcbEDh3drgKCTUSzN24+StEZNcTqrDHEqkvsgHsi3yAK9WFHs+FqUzew6bJawfe+Y9snXKwHurXT7kFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m4pIsR5Lx4rPRUCeoS1vRNUEdiaCEItEsaPZHJMLxS8=;
 b=Wd4/XhanOVe8dz7pYu3mo5NJmD+Hzn5/EHDopgp0h08Z69Ys30VQ1g6dRDDFyY5ikak4IGP6GOlX8yXKepxQWsFxJv/3vlSR8UXodbNBK/8kmnIlVAeCNxLAM00P8lWSKdV13Y8Upf1gJxzkX4c9/rmuJoNH5zfi1rSynyc6rcKQzzBzJPZioeEuu0cmBzHWPjQsmye6zOKW5HtCw26gZ3vfePm0GT7txcJSY8j0CBh18M27MNxj+sgKaS5y9R628XqYGIVIm0uzprVt4PQxGkKrZtxD1HMz9N5jK+UORyEGJNZ/owgcwJOIV6T5mRFzctJzRG7y24jta+pOL/9QIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4pIsR5Lx4rPRUCeoS1vRNUEdiaCEItEsaPZHJMLxS8=;
 b=nQfBGjIZbGoj1N4rQz7VlfiAwenO1vXhZLHBYzpKVzj+agE97Kyc2qPZYbqLz35CZcXwkpVwlv53F7VVQGK3MLjX86qLFUAXnV5W63Ymhoj4aiAa+NlH/9HMoHCFjc4NHeeKYaKqs9wMYhh50ahRFfrIFggIdsCNmuttuanCJ8k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8702.eurprd04.prod.outlook.com (2603:10a6:102:21d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Tue, 15 Feb
 2022 20:47:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 20:47:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mans Rullgard <mans@mansr.com>
Subject: [PATCH net-next] net: dsa: tag_8021q: only call skb_push/skb_pull around __skb_vlan_pop
Date:   Tue, 15 Feb 2022 22:47:22 +0200
Message-Id: <20220215204722.2134816-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0185.eurprd09.prod.outlook.com
 (2603:10a6:800:120::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 166d3e0e-960b-49c6-072c-08d9f0c46464
X-MS-TrafficTypeDiagnostic: PAXPR04MB8702:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB870274F0CCA37A50A0BAADE0E0349@PAXPR04MB8702.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jpq8B7P768G3KDq2qXU3D8VGm2gconb0BCZMtVWM0C0BJuH8thJJiSVi7NoAL7CyP6B+D/wq0QmO/QuEIqrI4YBK/yRf8It2dpZ8zGuL5kwBqShKemCMwjrWBYdcvhmNJm1iuCZwXSes4m5GNlMU4KdGBK4LVf6c/PX3BaULK3yKUOBprWoVNX9QZWaaZS03sa8sbOAwe10CYSAB+QTHQ3UHYxLkB6ovUF2zWgX0uT3zJMQILdRw/8wyy+9mO2hhguZuyz2Ue+Bfyc8ltg/wGQ1YCE7BCc/7HtacVV9ormEdv0G8UaWckgyuqRjPgM8Jm8blMntI69XLwgJJOloxiSKyYSysiF2j/k1JrbsoFHXExN+ncomGqUoYPpn2Td1VTE+k6pJimVzSD1+brO39UZEIg0vgomce0Dftb7PRYD5D6kqBtw1DMwxbhAI7a6f/CwH39NbBwkT46FJ/R5dY2Od9ArMrS7wRID8zyP/obDftan6XquqI9WPb/ucjYJq9aP6nG48FG8XFI5KYUjX9LEoqgoazOwbm4CzSW5DrCbgRYVfqEu//G0oMJCnFXlbewVYCYl8L/wZJvU2tueCKxVlR/YS7az2m05PKVIo4JJ01FKDTi1LmmrK2VSdhmtFosU9eWfophT5fakp3gmBkb+3zqw/7kwyYtcFDnpj0W9Bl/V29IWOc5a4gmkU+rb1QVzpYd3aC5k22L4Pj7OCVkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(508600001)(36756003)(54906003)(38350700002)(38100700002)(186003)(6486002)(6916009)(26005)(66946007)(8936002)(4326008)(8676002)(83380400001)(44832011)(66556008)(52116002)(66476007)(2906002)(6512007)(4744005)(86362001)(6666004)(2616005)(5660300002)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+WPLI03bNBF7akl2dv2pTFEToQu7W7QN8BvkLPWUv1/QsiFmREo/WSi605YA?=
 =?us-ascii?Q?Q8rMyrIu/ZuXqx9Wlagtq/3g+yeruQi9FQOKtEeJ0uvconYKo3/uL/ruLhu2?=
 =?us-ascii?Q?Ji2Fb9xcoARLjIU5AiGNqOO9AT6G6ZzEiOFMiYKLDpaquBoB/mqYYi05paT8?=
 =?us-ascii?Q?WNytfh5NcQ/vHF2XjUYWetf3w9WDllLH0kwJH5zqxji7gF7MbWhyIDgsw9RK?=
 =?us-ascii?Q?XGc9L0PUybKeABLwAKpZzCM5Aembu93wUKkOdJkU6kngHV6zo+zRDgzQ4eCT?=
 =?us-ascii?Q?CS4/YuTpRAPd5Dlz5kFm0EaXLtDdLJ9JfjPQzhImFrOoqvtD32RloQklBYvY?=
 =?us-ascii?Q?+2Ef9fWd2QQQxgAJq9ax3d1Ct8+MkVFp30mbYlvgg2Rw4eSn7fvcMdufC1x6?=
 =?us-ascii?Q?f0IN4AbBs1CnPVc0Nq3NHyOkywcCmWGsU42zWadGGRasKY/J1dSS23P0XPn2?=
 =?us-ascii?Q?6ynJ3haiyP6i7r8l9kVQG9E9wLHHJjGkp5YSLiQo6LIjeF2USKKNVHSH95E+?=
 =?us-ascii?Q?M2nGECRCtNe6tV1ofxOPKvZ/U+lO3Iv32V483jiwf/tl6kWLTVHq186RHrVB?=
 =?us-ascii?Q?j4P2JmpLhaEnCE7vPLOrt0xyxT2TGjbiZYBzGILEflGgv5Hx6DiMPSwVkSp4?=
 =?us-ascii?Q?HMW+2MZOKrwJmc6VCGqUg0LsvMVpYX5D1PB9ZnDzpJU+vfhGrmepul8D7Otw?=
 =?us-ascii?Q?/KyCrOVPSAhebMeNUAFyfvcvst91D6LFlTbhsFVqM5giZPXkWY4DwY4cO+Oh?=
 =?us-ascii?Q?76ghULpdgwvZNUR7g/yHDlP5szLINs1xcbdMdBIcoaC6/BMvgCcGMxO2dfAu?=
 =?us-ascii?Q?Ii3aF3Ye+S9AmAKiXmaymvpHrg66w9MGW66eIAPJ034LeQGqF1IyIjLWKcvz?=
 =?us-ascii?Q?8qvOuu6I9mGaSOq8YPSBPiXYJoMjLmpl5S0FvHrFGEizH66ubvSoHDOhhGj2?=
 =?us-ascii?Q?3jrFmEms7QXCMIch8HY/MNO5CBX/lqvC6UgD/I9HKFsor/QDJnDAUYTKEa44?=
 =?us-ascii?Q?WLeBhJrp8uPuuHoys3dKbag+gXSuAH2ej4gk4VIv0bhr9wbwDCbSO9hGmasw?=
 =?us-ascii?Q?xSK5JrRRiuOlZKpWJbJQps1vQanWhjYXv8WOir0Ur8YpYVcYhN6vSbBcMN85?=
 =?us-ascii?Q?agLIAhCvmsheItAZsREDIGiq8XpulhI+wiYj0T8sIjR/bDByU9gwgvCJQ4h5?=
 =?us-ascii?Q?pj5DulUt6v0auPNW3gAg3p1W77GiMBYwvP9mdIohaxa52R5+haYfXTIGel7u?=
 =?us-ascii?Q?zq+SobmXRKSS21NS6wvjzuLtImmsWC/cIZbjDOZTKINLtnSN/rTeZNnnZVEF?=
 =?us-ascii?Q?13jsPIU0t2wWqDF91yq+KCbAbRCVVdtcvjO5H29rXqkAVxUxh9KcUKAmPnTX?=
 =?us-ascii?Q?YZJWmz/qV6N0Q/6gIolusHo4dqkQSC6hj/zgxRFt0VKWDjPSygy7nS1Ql+72?=
 =?us-ascii?Q?2gwuFwdcdzCtKlt4mRodGPqRbyJjawrir842wa4UoOO6ZZbDlQb3j1+EHIM2?=
 =?us-ascii?Q?yIVyCQ9UBjyiRhM9r3SUFqTbzGFwqxMjrFRA1PlZ8LJRX2uY1qiTLzZcQ89A?=
 =?us-ascii?Q?wfeQZbXElH7/A/HdiT5P1UFehPJtnkJMjGA8S+vSDHwhSNI2uyoDjhYGkS7p?=
 =?us-ascii?Q?ueEhF+G2CaIlOcyK8aeu6Gc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 166d3e0e-960b-49c6-072c-08d9f0c46464
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 20:47:34.1293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I3SbsFER2cLK0jtdNvSwuD/0IpyGQgMFl4yV9sD6n7Va7FUYyC8HUheJuRf14p3SPTCGA1jZolXWxALPljdNhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8702
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__skb_vlan_pop() needs skb->data to point at the mac_header, while
skb_vlan_tag_present() and skb_vlan_tag_get() don't, because they don't
look at skb->data at all.

So we can avoid uselessly moving around skb->data for the case where the
VLAN tag was offloaded by the DSA master.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_8021q.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 27712a81c967..114f663332d0 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -577,14 +577,14 @@ void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id)
 {
 	u16 vid, tci;
 
-	skb_push_rcsum(skb, ETH_HLEN);
 	if (skb_vlan_tag_present(skb)) {
 		tci = skb_vlan_tag_get(skb);
 		__vlan_hwaccel_clear_tag(skb);
 	} else {
+		skb_push_rcsum(skb, ETH_HLEN);
 		__skb_vlan_pop(skb, &tci);
+		skb_pull_rcsum(skb, ETH_HLEN);
 	}
-	skb_pull_rcsum(skb, ETH_HLEN);
 
 	vid = tci & VLAN_VID_MASK;
 
-- 
2.25.1

