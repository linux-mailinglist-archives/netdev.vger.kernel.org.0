Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27BF56BF623
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 00:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCQXTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 19:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjCQXTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 19:19:24 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2073.outbound.protection.outlook.com [40.107.8.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861E338B61;
        Fri, 17 Mar 2023 16:19:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2IWzfJlf6L6JGuvCFRKUpPOJ7jQ51kGXE4WipEB+edwAz7zcsXS6kNYDojVlXGLBlN+PC/GutiFm2v9RQ/M3V/47ZIAwnrfabhk4a4dg1AuqYTI177gSJsZDidcnfkSPeFenKlVuvr/cNFPej3/ZHT/BV8I9NxTPMSTm2IU8asl8ajiT0IUXPBFiTsgdycWFKVVg3qwtUQrcSrZMDzQrQ0DkRWoh74TC96DLbr5jc8rc+0ZVJmE1icOenlaPi1IcUG9I8pR4aFvQSjN3ccqRttNndAOyLkmJN2YJyDNU57vmGfY/tXKY6JWTYRhUWjhVs5SOLQ8o/TyztAm1Ef3Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMjd6R2pZyzIHcwcMIC3BAJMd5mkMB99JcnWgLCzOhM=;
 b=aKSwyWyayYUjOZX57vWHKK9M2o2m8aW1pzbl7gXDFzb0lca3aqEm0v/LjnAJTXoSSCKIRbZm0FFQgqd/toJsC5jcU1a/K+w4ej3WtElYj6MwlGwsklVvDgaIqkpLWaScToQXfKBqRuTMea1MvaivbXvtH2WEVe93QJiD2kJ6PHlv6Id373DSQQ5SY96/Z2gYQ+bwEbkdBYfhWXAhEcl8EopSBVc9iGBKvlX0SoEnptdpDQVn4bBI9bUnTX99h48Y49wwF3p4dAfEcetik2Oa+eRpD8RzIi2k2dO5Q6qzucx5sGMJfF9hj+aPogI9rUiXZO2/Rhae7TMruMNCvWUELQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMjd6R2pZyzIHcwcMIC3BAJMd5mkMB99JcnWgLCzOhM=;
 b=CuaxcU/Sia914X8qgzj79QEHGAaL1ZNyeCub0R2TEvxxYd6yhcckDNca+sfq2QKVR5MgGhqOCD9BQMoPGaap0jmHzBtEHjrZfNSfCVvdj4cOumj37IQLbT7LwtAtgI+a0iZvIerxDMJ+FbFg0dzSbWFvuOafOQ1UxBOkxsLgLkg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB9143.eurprd04.prod.outlook.com (2603:10a6:20b:44a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 23:19:19 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.036; Fri, 17 Mar 2023
 23:19:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: dsa: report rx_bytes unadjusted for ETH_HLEN
Date:   Sat, 18 Mar 2023 01:19:00 +0200
Message-Id: <20230317231900.3944446-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0074.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB9143:EE_
X-MS-Office365-Filtering-Correlation-Id: 95288b5c-9533-4358-f048-08db273e08bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l9B1YXV1fV+1C9kem7Io4334CtBM941hn6OPhlvROE23VY0n9E5mj+4zX3uDjvWQ1P4cynAxEevvX/vw1Ve0CTzlGpEXatxsCC+5GQthcuxRlMePwISH1WLfVuPB2W9DWVtGNM5Y0JQ5YXb3Fi2ICAAUtGmSM6EJ8R0rpBoNn/XLZj406Ngjd+BPuGm55Q2p2pz7AWUuKDZxTzjXw4JF5jeq9L8P2+VHZLgv6HWQxV0jynrHWpvNsd4Kiug1f1no/UVhTfYE+/1Ivhg7K/56HVmMLydtlQ7byBMXGFv+t/Atxx6G8VS4yH7wsAmnxNoMiEn6EYtz6z2lU2s69kDbakad57e7W1s0YNIeAjOP5NRvKK9obPN5ngp/4MBKQ7pY0nZYLPmkvRKN8x9ZoAS4GgP3PLtgezJoLBJzvAJeHLhKckA5EBNm/6PNgAMdAtqYv5SLJZ9LSQf1QI6IuILpUAnM+6Sf1xzmTpdjGdXYPIAxihDUEMCujm7cKPjDH9nGapWvt530YeNIRoULS9EL6X+q2zHAsd0+sTTCQUw/WNQwgx9AcgUX2wf6WEtteXjZOakAzsjVnQ/UkqwiBgoLEbIkiVz9YCN1DPyPoGSNs/OQo6j1ovUEnkA8o45amoWGMzWdvQpkwKNBDmx0t1QjWXPVSxOA4bqlqSOEmvEBwJE4McZg0iaGAtaPTmbLhJ8vYrLIkRr8TYLmcYKbDFg7JQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199018)(41300700001)(66946007)(66476007)(66556008)(6916009)(4326008)(8676002)(5660300002)(38350700002)(38100700002)(44832011)(8936002)(2906002)(2616005)(52116002)(6486002)(36756003)(6506007)(26005)(6512007)(1076003)(186003)(6666004)(316002)(478600001)(54906003)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2WVMVshIAGDFT5qnsTnjd1zBCwsbx/dw/+HlajkzjFdxOzaCsSKC34Mty7Dd?=
 =?us-ascii?Q?ZbUW8zzyFAw6was5djdFoLfJPRyjpLOxOFt/uab6LPhKYnkfBfGuAQQa7oJo?=
 =?us-ascii?Q?ErvHLyVVsT6pHuSe5jJ8jzrYVy1dbFvKrwAcVt5LBfXcPKjVrducspggVULy?=
 =?us-ascii?Q?LSVxeJ7O2bxb7vVnXk9pBXFDMHyxGTZqpfOZRRr8OrjC1NyucIPnNdJLNbTB?=
 =?us-ascii?Q?SuixXaP559fl4UcjZ0y/kcnBmwoikoFAEKchEZHq3vFc823bNNFP61VgLbRo?=
 =?us-ascii?Q?WDARcT3V1tamEMPDWvtSiYwcR/5/nHPrENIX2yXqrqIRx/sFqLYPCMXac0zq?=
 =?us-ascii?Q?wkaf2iSLDKyJuBD8HQdIuzX9t0LeZHaUnrz6Y1bBWqvPFVqrYeK2ndvCcahV?=
 =?us-ascii?Q?4fH/TGbPYUepHfi0lEMkEqOuqwlikGMwiofToyQw8NsTQSBWeruSJ15McWQ9?=
 =?us-ascii?Q?TsCpQCRKTF6VVIRiZHkWlqN1FErGT1U6BKdP0w6w10sfiDGbCHIRpqUbSlcE?=
 =?us-ascii?Q?9B8K1UXBt8GV9dJtM+5E0xVFlseYK7MIpMpLM6JLvVUaEXlOEAAxmqCKGVWI?=
 =?us-ascii?Q?qfxaoTYAaQaBbKPqcQTH74IgjzgtS+i+wnsnYeKJKVR8d25rWE3R/665qm6v?=
 =?us-ascii?Q?S5h78FQIfF77RPfj90DJ01lDBKkyjA08s8t18TnOeuUO0AasWJiqU/sN2XEf?=
 =?us-ascii?Q?P21zquh1mbNV1zXTDUFQtq7cAlJTqKwgAqdTrw5QvI7VG0vWLgFtlZ5/C0zS?=
 =?us-ascii?Q?qFVFNX4wisTfXX6zRfbd9/1WVp84G2ogqCJ8akLwS0zn8NBZKfMQgHiPdApJ?=
 =?us-ascii?Q?3mic22fBhqbXs/ClgTH76kJNTa5D1pkxt5BCLCU9Q9WMj1fMfbw1cJfgGweX?=
 =?us-ascii?Q?Zm8nmnF2F2S80CJEGUlNyH/xUqG2/+nZtmqzweLcYg+DC74Et5dCJqV4fdd6?=
 =?us-ascii?Q?Qc0XgRnCd4BNRXSPymRnSokBzkZtcl5q4t7a7f577OgJslnOKG80Wa1A8qMF?=
 =?us-ascii?Q?8F86uElr6hPvkazfEfgyODr5ZUnRbkt9/dTCoDrs0i2+CLH6SULn508TrMtP?=
 =?us-ascii?Q?Sme8YtHM7u+iJ6zj2MadX7/ocUNo38XVCGM6yKXn1N6hbcpU8zxemiRcdlBV?=
 =?us-ascii?Q?zD0RiazLP0Hn5SvTBxXZABf0smCBwShLtmUvpD+Q4BqaRKPCWRavyh31z8ID?=
 =?us-ascii?Q?Uac+sRWxjy86xUzLzDt92Ov8CnrvXu3wE+mVthMA5KYV4ZNIZOZR30ybMVXO?=
 =?us-ascii?Q?t2wUyYMIXdMYa/P1pxxyiV+T18ht4myfiFz/6J13EyL/rMm9ITpb7FmTG/1e?=
 =?us-ascii?Q?l3AoDEQWLu38JuIWtcYeL2usi2z4k3KyQODaMTvZv7QPgjG7aoHwtTV2YTHV?=
 =?us-ascii?Q?PeETenmuQr2D4YbRHQcsvaXV+OpmbY7AfXpLHRV2rpH+Yp18HKXqekw2Xw+G?=
 =?us-ascii?Q?tussOkaXgKxdHCZ+EPNXKp6lCjgozgoRKB3mJaonA1zHDKnDNVaESeaGXGF0?=
 =?us-ascii?Q?vADzK5iUdTAtbbQr9C9ZKQ3yfN1YaSkvn3zC5Ag+1DI/G5qVf5YJsyCwidUm?=
 =?us-ascii?Q?VBnFDn9/sGKXdHCBV3irsjzISal6ka0gUTFISPTC8OqF4yupxFXJDE3ky3LK?=
 =?us-ascii?Q?CQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95288b5c-9533-4358-f048-08db273e08bd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 23:19:19.4459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8/RKq42+izCJF6sXXnrzT82LyQVmfwm5zudSJV2W1xq+NN7jX4Y23o/UiJRlbIyop0e32vCe39cytiWApjlR+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9143
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We collect the software statistics counters for RX bytes (reported to
/proc/net/dev and to ethtool -S $dev | grep 'rx_bytes: ") at a time when
skb->len has already been adjusted by the eth_type_trans() ->
skb_pull_inline(skb, ETH_HLEN) call to exclude the L2 header.

This means that when connecting 2 DSA interfaces back to back and
sending 1 packet with length 100, the sending interface will report
tx_bytes as incrementing by 100, and the receiving interface will report
rx_bytes as incrementing by 86.

Since accounting for that in scripts is quirky and is something that
would be DSA-specific behavior (requiring users to know that they are
running on a DSA interface in the first place), the proposal is that we
treat it as a bug and fix it.

This design bug has always existed in DSA, according to my analysis:
commit 91da11f870f0 ("net: Distributed Switch Architecture protocol
support") also updates skb->dev->stats.rx_bytes += skb->len after the
eth_type_trans() call. Technically, prior to Florian's commit
a86d8becc3f0 ("net: dsa: Factor bottom tag receive functions"), each and
every vendor-specific tagging protocol driver open-coded the same bug,
until the buggy code was consolidated into something resembling what can
be seen now. So each and every driver should have its own Fixes: tag,
because of their different histories until the convergence point.
I'm not going to do that, for the sake of simplicity, but just blame the
oldest appearance of buggy code.

There are 2 ways to fix the problem. One is the obvious way, and the
other is how I ended up doing it. Obvious would have been to move
dev_sw_netstats_rx_add() one line above eth_type_trans(), and below
skb_push(skb, ETH_HLEN). But DSA processing is not as simple as that.
We count the bytes after removing everything DSA-related from the
packet, to emulate what the packet's length was, on the wire, when the
user port received it.

When eth_type_trans() executes, dsa_untag_bridge_pvid() has not run yet,
so in case the switch driver requests this behavior - commit
412a1526d067 ("net: dsa: untag the bridge pvid from rx skbs") has the
details - the obvious variant of the fix wouldn't have worked, because
the positioning there would have also counted the not-yet-stripped VLAN
header length, something which is absent from the packet as seen on the
wire (there it may be untagged, whereas software will see it as
PVID-tagged).

Fixes: f613ed665bb3 ("net: dsa: Add support for 64-bit statistics")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag.c b/net/dsa/tag.c
index b2fba1a003ce..5105a5ff58fa 100644
--- a/net/dsa/tag.c
+++ b/net/dsa/tag.c
@@ -114,7 +114,7 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 		skb = nskb;
 	}
 
-	dev_sw_netstats_rx_add(skb->dev, skb->len);
+	dev_sw_netstats_rx_add(skb->dev, skb->len + ETH_HLEN);
 
 	if (dsa_skb_defer_rx_timestamp(p, skb))
 		return 0;
-- 
2.34.1

