Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA9E6E5F83
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjDRLP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjDRLPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:15:22 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544A2189;
        Tue, 18 Apr 2023 04:15:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2OcQLi4GCxsJfWZ9ysy9TGPydyOi72PiBmgKV1gOTEg2r1FLyo7k/FpfIzuwXB7cOTIxJkhbVtWnKUUWlC+z5j4anA7n6tLBh+2b/Pinowi8+soa0R5ANOVFQGAv2RxUocLtWaHZVWY/dQz3tf+skDGbIyNUO0DrE9LqWph7MnBxwe38A2ypi40AebvDh6DAD93msLPOOHsfxC6eD4ZgRtv4t2pclUxNRa0+S9aF1Jp1Pha3KwZHTkq1rTWoh+IKuJSL4KQult27rS6kmr7DQ44TWFDU/UpNAb4VsYDTMBtxkOjfEaGN8G5/dElT4t+4loagJDOwvjXoSjiIJHsnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jvyICuPSzwJikGzzhP1t3R1NSkSUN3eLcXTcjy/KZaU=;
 b=L/4psWEdDJIK1MYxeQ3l5CdXai/n7RFIJtjEh1j2qKlBxmXK9WrHnRZVl9Ysid1S6UQAmJNQc7Te0RZFnhCiadSju5BPMESTt6z7YgBlX2gvY9MHqhSTtrVKe80UIrOT79dnOk0tP/Vgu/CVG16zzIxBsFDMKvaSXNTAOYWiZj0h76HndDG5cHZOiTjZTvp3x3swpjoRYOhp2tq3rBOn7WGWNO4oKzJS/G0TPpMaa7ui0bbYo0C47EF8rnGM2JDLJMlAmdmVGkrPnLKePH/DQklZdUlz7I00t1ityuj3pqc+RxYR3d/aqvfPIpO+FasxsV+aaTB1xE/tvxoCVZV4+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvyICuPSzwJikGzzhP1t3R1NSkSUN3eLcXTcjy/KZaU=;
 b=fUrkH6Jk5gATRFfDuQv1RKyZIM4XSd4SJ2dg3a6tjJfXudxrtxuUZhNtHrK38JHLpg39MW9oWe5snXpMNyeMuE43/YgIFdOjjhYnWsgZe+kUnnYfMYBwfSqEZCH/8CdHBzaT5um5nILrEVh58xOdhgFw+6NyQ2o/Ce4ceR5LRac=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8659.eurprd04.prod.outlook.com (2603:10a6:20b:42a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:15:18 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:15:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 2/9] net: enetc: report mm tx-active based on tx-enabled and verify-status
Date:   Tue, 18 Apr 2023 14:14:52 +0300
Message-Id: <20230418111459.811553-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418111459.811553-1-vladimir.oltean@nxp.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0152.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8659:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dac5699-580b-4669-ce6e-08db3ffe3118
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u/DFxF6TT1xP1R2jJJGYfNVQ0+L/nVKou9LQ6rMOn5jQBa5sgtIPPNjxl4QLDxOSnyFWwzJnqKeVVnnduza4eUHfS1T6oPhbw7eJZHu+A+318usmSpkMAHs5H9frkJzXHlN9Gre6XRUZYXoFiHH4JG556otChkYySzpMAGgYzpkgXJfFVHpM996uBKwU9gTvbybNSATdf/SP+puTOMtqW622iM7OH3JePquicaDYLN74KMh5FOe78xmhhw25tAmTccRiOh6B/n6b+OJd63kuuHoaEBur6bkSY9E8+mj7Mbzg6r1gF7xO19L03sVwZ3Eh9GtYt0FO3d7/+Zknkn7ec5jV+LVxR8kzBo3ZJJ7zPj70m4zaNfBQy7hyO2nK7ot5/xXG9aJxJBrWtTpXPhVQvP6wTIeC8M7E4MFDWfvC7UcjPVtN46e+XZV7c0ptJs7IjPaQ8Qm90drM+i7t0vVSu8oncHJ0kAO1cSIYTynQ0gs7ovBHTkzcB489tR3YPD8SXbFOAXwwbdl0Xsb2PjaRn9Y4GvRwDVEel8ykQvPgcvcCsUSjGOxHggYV3FkAhFEsZ0ZkWfKYwTXufuZMhEnDD5ttF9YrxIYkYFtrLKoMkesRRbQLIb4UxCI4RgWDZqMG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(6666004)(6486002)(478600001)(86362001)(2616005)(36756003)(26005)(83380400001)(6512007)(1076003)(6506007)(186003)(38100700002)(38350700002)(52116002)(66556008)(66946007)(66476007)(316002)(2906002)(4326008)(6916009)(8936002)(5660300002)(8676002)(7416002)(44832011)(15650500001)(41300700001)(66899021)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KZThwevfQRpZ1CFcReeuT49+cu/ig748KKXqhPJEHAz1/1T+DsP30Ou9mdEr?=
 =?us-ascii?Q?DmM2+MP57knvg8arjLm1yT2L5E65n97b/HZnlh9UIaDduzE3XN3QUiMaP6zk?=
 =?us-ascii?Q?x86wlUGQaR1B4/z5vmg/ds+fGbQBTkni2RzM1M8stVbeshmvoBxXQFZ4aX3Z?=
 =?us-ascii?Q?f/6rWdjZCsxj009VMyL6I6uxy+9xnxL3wt0lqNGNb2nCMmWlySpxyu/VgF94?=
 =?us-ascii?Q?Q0nQuvHp1f2hp7ek8Q/yVA6vNOC8f061Emb38mkcL3lv8Cv8L6HlWB/8GiW5?=
 =?us-ascii?Q?6cnazEZ45EHdTtEsy1CP/u0vd2IXNQFFP2EhwLaI2reRhpYW2g4urwzKjNww?=
 =?us-ascii?Q?2SHM8aoypx2fyh0DW5GwsA/p9nETnCi18uZe/RdiCIe4VyD7KaWpTEL8MzYt?=
 =?us-ascii?Q?SZuD5XDZ8WOIzL6F1zk6WCNhsqB2OsCpIuhY1Oaw9W8Rb0bdlio+As1w7s+3?=
 =?us-ascii?Q?ehw7/CtHE73eYoVhMM1KOBf6kkq6YtAHg+47GN1YR8IJU0xKAHjcBCibBqnN?=
 =?us-ascii?Q?TT6m6XcUtenSrkdzQJFK+8g3Y9jjOo5u1PoXR+3WXL0ZJSgq85E+qNzobUit?=
 =?us-ascii?Q?O7HYkW2JfWsaj8zYtoor7nDm1fStuECYCE2iYlF2rbba/Nq9rLx7GtA8pSdP?=
 =?us-ascii?Q?4mz90Lj4LFhVM6awyAr3/IAAxuv2fdVqj81nqysFanp+TD225AznIzZEqXpU?=
 =?us-ascii?Q?vixpYYQ9l1ANeL5o4RsQc3ooXbSLUPbmla3kAl4gSGQGGZq4AsfOf9Iu3G8h?=
 =?us-ascii?Q?cgXCYmfCVToi6lhRgoHclgyt++jeQdBLq8jEFUZCbJFJBdfZD2tKd3n/osKn?=
 =?us-ascii?Q?o7TOHB8qUMjzcCYAYygD5EDHC96H+qheKnPEAEEm4a5Q8s/haziKAAuhw0Mk?=
 =?us-ascii?Q?9a6XTneHeDIqu9Gih1gMP1xv7NbkcGWxXSY/ynY81JffxHfWWF+9JAix8G4G?=
 =?us-ascii?Q?Dm2sLDLs03R2UY5gcLo1OkPdQOC0apg2azKDfusqXk4PGyT8ONlIUOCuo2MM?=
 =?us-ascii?Q?aRhhpYoc68PNj1jjmydzQbe9mPU4VWQdprKHrAOWvpTg+8UZ0BcjLtKFMii5?=
 =?us-ascii?Q?FbfDTlOwG7AMl+BPLaz96nbguOkeOIYUO2GKkyAMbQrEg7uTtB8tW7tMMEGF?=
 =?us-ascii?Q?XgPbCnlkQZaXiFYdn9TfAgYmPDeprr/Ph69tl50AxiJkqeW2YzE51ZWBJSi1?=
 =?us-ascii?Q?xjoEgWwgrSge0mUqABh6afy0ix5mZVs5gjb+OvQ5whK2Zgp5yWwGyug82VQ0?=
 =?us-ascii?Q?oYfqIa/yrL2bXKYUGh6zJ3eZhQ6YGQJ44oZ9x2gNRUH42Fi8fthd6f1WSC8u?=
 =?us-ascii?Q?mIgrRdEbcFA3/27vxery5F5+wv67fm7ZZcty3MrVN8tuZNwsWXp1RdXnH3V4?=
 =?us-ascii?Q?YIGDKXxYWdcClApjObgrQnEcBDMJhMMCzYJNTXMbjfXBX6BJ3/E4rNY6ldUt?=
 =?us-ascii?Q?6ol8EaMTyY+rqgscYSHkPdZbprQxFjKSxH2Z7b4f6iB3X+ox+YNJDPtCKZj/?=
 =?us-ascii?Q?xynzbSRLeONGIGGV5X1FL/kaOEl6w7bQ97UntL7Fa9OKYvcnKNjK7niICAU0?=
 =?us-ascii?Q?fVbjD7MB7C86Vu153AdxjQ0wATPXrY7j4V2ttSA29c6r4idn92Kf51mDH3Vn?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dac5699-580b-4669-ce6e-08db3ffe3118
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:15:18.2846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aAZTS0LrpoKxmvZ926KlD8v5N7d1EO916H2FzCPEgEt9AL4LFmbrUbw5jCHdg3XEnNsivgpAoPiOvSgXymEwHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MMCSR register contains 2 fields with overlapping meaning:

- LPA (Local preemption active):
This read-only status bit indicates whether preemption is active for
this port. This bit will be set if preemption is both enabled and has
completed the verification process.
- TXSTS (Merge status):
This read-only status field provides the state of the MAC Merge sublayer
transmit status as defined in IEEE Std 802.3-2018 Clause 99.
00 Transmit preemption is inactive
01 Transmit preemption is active
10 Reserved
11 Reserved

However none of these 2 fields offer reliable reporting to software.

When connecting ENETC to a link partner which is not capable of Frame
Preemption, the expectation is that ENETC's verification should fail
(VSTS=4) and its MM TX direction should be inactive (LPA=0, TXSTS=00)
even though the MM TX is enabled (ME=1). But surprise, the LPA bit of
MMCSR stays set even if VSTS=4 and ME=1.

OTOH, the TXSTS field has the opposite problem. I cannot get its value
to change from 0, even when connecting to a link partner capable of
frame preemption, which does respond to its verification frames (ME=1
and VSTS=3, "SUCCEEDED").

The only option with such buggy hardware seems to be to reimplement the
formula for calculating tx-active in software, which is for tx-enabled
to be true, and for the verify-status to be either SUCCEEDED, or
DISABLED.

Without reliable tx-active reporting, we have no good indication when
to commit the preemptible traffic classes to hardware, which makes it
possible (but not desirable) to send preemptible traffic to a link
partner incapable of receiving it. However, currently we do not have the
logic to wait for TX to be active yet, so the impact is limited.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index ee1ea71fe79e..deb674752851 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -976,7 +976,9 @@ static int enetc_get_mm(struct net_device *ndev, struct ethtool_mm_state *state)
 	lafs = ENETC_MMCSR_GET_LAFS(val);
 	state->rx_min_frag_size = ethtool_mm_frag_size_add_to_min(lafs);
 	state->tx_enabled = !!(val & ENETC_MMCSR_LPE); /* mirror of MMCSR_ME */
-	state->tx_active = !!(val & ENETC_MMCSR_LPA);
+	state->tx_active = state->tx_enabled &&
+			   (state->verify_status == ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED ||
+			    state->verify_status == ETHTOOL_MM_VERIFY_STATUS_DISABLED);
 	state->verify_enabled = !(val & ENETC_MMCSR_VDIS);
 	state->verify_time = ENETC_MMCSR_GET_VT(val);
 	/* A verifyTime of 128 ms would exceed the 7 bit width
-- 
2.34.1

