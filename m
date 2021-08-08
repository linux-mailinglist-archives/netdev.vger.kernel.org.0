Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB4B3E3AD2
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 16:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhHHOgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 10:36:13 -0400
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:17029
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229923AbhHHOgM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 10:36:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lV5HtFPY1IUGA4viviVwvhaNM9nQiEMyINe/74jO1tDwqBPvMyUpe2bWCU6z6Ix+8Du6Bob9Pcbzv7xfqZ/xkhxXkAEn8eMSonjrn/32qvks+VNTK16+JeQUFQAlbT1NXBWViy3LWflA+I48iQTq6PrJfsY6l6u9B+AKkZ2uNT+M7j0oMDNggiRTgeRLLVnyAZHs6gXrkrV8tr6JJRQ0e28EjNzUCrd475sI+dMSYupezjY1t14xF9NFPThTsgftGVgAggJIH/Bvm8SPv6/2cV0TBkUDFUcT+G8n16YXcPzzyfTijzwwGtAAtrZ4oDmEKO7aA7zvr/q7gkU6KwUwyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1qdmwu4GjhU74QReJnB6ln+Ys7GkslluCZ3FTHTThc=;
 b=HnJhVOW5CH6Gl741AMOk/jr67cGesdQcnSGj5R79pTbS4ijs1qdxTs09Zy0T/+V7E5OTgNi5YvSIxraP2K/ZO2DCvQwcXUdhpHLmgh/y8vlfufM9myltyq2YCN0oWFu5RWH56KCoyegM9gDfGjZz8L2r/BZSGDFYl+Gk5aoZWPhhShv6LVDCL5d7t9xGZOWvlT+TmZkw6qW4qm3AqfPC2AatqSw84G7eIJwa+Ix53vdiou+LntWUqOdVHkh6E5/mr5hdZZgpSFFCm4XHH48kFGBcQmf++PFOihFBmHVWDhH/bzBQ7U//QqHHQXBIT/pgPfSi3AajWIqd+3W/LA8KUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1qdmwu4GjhU74QReJnB6ln+Ys7GkslluCZ3FTHTThc=;
 b=O0jpJFd3dSNTBosWdzWdLGbe+evux/peHEVZ4hQxAQpA1v3Dy6ExyhNr1puiHEMQNnt6EVGNBqKrGI5CsCcREaI8TlKDFXFioB4TGJnS1WAn6hioH7CP18tAVlGRt+LntXP6C47Y8g8xE35MD8usHwLppEFSVPMKInmyngjj5wg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2301.eurprd04.prod.outlook.com (2603:10a6:800:2e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Sun, 8 Aug
 2021 14:35:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 14:35:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/5] net: dsa: don't fast age bridge ports with learning turned off
Date:   Sun,  8 Aug 2021 17:35:24 +0300
Message-Id: <20210808143527.4041242-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210808143527.4041242-1-vladimir.oltean@nxp.com>
References: <20210808143527.4041242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0003.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0601CA0003.eurprd06.prod.outlook.com (2603:10a6:800:1e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Sun, 8 Aug 2021 14:35:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7144838-e507-410e-f5aa-08d95a79d0e1
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2301:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2301879C9D73DFCC8EC6B920E0F59@VI1PR0401MB2301.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZcuyVhX3IvfsdrajfmYkG+o0dpMD9sSWjssrjg4101M/gqyX+ukAPy4kYNjeqEt2/v1+0F5OFsL5UMk4dmgWTQm4U/m25nfAPkgv2H/uCAnRouAJONXx2rhbdL5ZwgpzJPJKWfOtF2z6wq6CygVJtCIw2rn0rgtY5GH/kQI5VVxymWugSYaBzBDUBbp3B9zNZXGsCM2WIvhHTz7qv6CFYmlJVYMWTXugiCoswXBD/e9nFioL7G2yZ1lP1ER2CvWEJSe79owt+tPbpLF3YTB6UPNJ3dzuc4+SeKJmN912ya0bAuljc3mHh+3KVVGWB0G6vFL2JA8kgTSt1CsDud436TD3m+IGCg3jgG5i0CALDss0DfyzcI2II2kAYexTY8Idnp1KRi0ZlB6qOwO1FuQD9DDtUgLu/dTFMs+epbxf63N46dxAzB5/iHl5YSAdVHnudns0IlUBergCXPbk/61HcEZLiTlQUuZPJmXzY+G1TuJXDc5LMoI8zSCaFNTasBMaPfLnXjrpd1cf3bNsER8IFInPqIn3zSZH6POfG6QKOpAM70+0Iz9txlXZdVYOTBB/CxNsyECgblhyiKkQ7RzHKURzJgNJmXixOJQq18/jEik1ByaYUObDSgHnylZeC91VJ8RATw9YrJCDwbNFFReut+GRTgM4b0sWq0s09lBfyo52HkAM3fW3kdqoOoqFw0tSz7nq3+SiNqUdkcLS/6hJ9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(8676002)(6486002)(6512007)(956004)(2616005)(44832011)(4326008)(6506007)(186003)(2906002)(1076003)(38350700002)(38100700002)(26005)(52116002)(66556008)(66946007)(66476007)(8936002)(83380400001)(6666004)(110136005)(54906003)(5660300002)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RGf6kv/++BGN0BAqyPqSxKBltK8+DjbdDRU/4fOZTYQPVnJqsUoBIEJukYGt?=
 =?us-ascii?Q?H+w/K5s6jzr8QsdnBAuuhr9lRlOjgKHvppc2uOI0XQFzhtI+h99jI9CiHc7q?=
 =?us-ascii?Q?QxWdSsf3j8SvYM4u8CEmbqwHq1ov5DxHcMuAtpjavXt2IhKyVP9+jdqw1r+w?=
 =?us-ascii?Q?+rRFnFHHy/s9EkzSNd9aJE5FCmJgQ3RTGvKo7ZbA+BEn4+wYCA72LzHUAkUN?=
 =?us-ascii?Q?knLcEhwaydxUYpTwv/a6TaBZHEEZj9vO2hU1YJxJIpEkggvt09sb9f+lg1tf?=
 =?us-ascii?Q?70qsgkXstaEWfP92SbgpZda5xjrNnR58D4hmoZHEAeQOJR+1PQD1xDqYQ60+?=
 =?us-ascii?Q?Xh0vtkFarKF5qqmJxBI/26SFDhvyj6bmRdON6hQl7GOCrQUcm8PlSylHMIuP?=
 =?us-ascii?Q?gMX1cecR/6RYWsQiHQ5CrsbMOrp5EnHsPtV/rOBTadmB/i1TeOR/yBrxXTcy?=
 =?us-ascii?Q?LJjzjoexRGz2pIbRmULtPpJNeoRttR7a2y48zUy+LLVad8ky4EQN+pKh2TfN?=
 =?us-ascii?Q?AZfhTqywZabjmvrkrsngsZfGcjWNp6g2cxKRgdCWChkn2muK04Z4NJM4g2ph?=
 =?us-ascii?Q?3eglC1CsxO4/xUeDKyeAg11bR+ip/zIyc0bXadQagwTMG5S1J9cGxNv3IEL3?=
 =?us-ascii?Q?yaJvDNDk1aZlERMMN13CZE+Hpnt7Vo2ALF0CqRQ6gOyyaHXhX2wq7IxhmDVE?=
 =?us-ascii?Q?07XYpitAUTRJNlu68ivLSILV9BgRlbsCvyyrAy88mb7hPbkPLFVvObjwqS4k?=
 =?us-ascii?Q?lHY2Zcu242mLcTu4I3xr65LaKstVX9ckihpVYTPrQu/0p4uq6QzvZXw69l6n?=
 =?us-ascii?Q?wbZfr6FjG4woR66loW5o6sHD1DLhFlRTOrKSrLv4q3pxQW2bhuTFuPHieWTe?=
 =?us-ascii?Q?JTRXGliVMkeioUB8p1dW7/BT5lVheYpgTOOY+BgbXX8RuRnDi23bwXyTGgVx?=
 =?us-ascii?Q?3W9+0bUlsRQSOpnNXeoljiWVFX+KmkYpeBY0UphGCuftUZIxFLQeb/sVKz6P?=
 =?us-ascii?Q?p93jz/x0dsnG7/S48oRCkcEfbjyHW/tvRMgELw9LAAhXFnvzm9Ew9vVKu24r?=
 =?us-ascii?Q?egPXEABqTUJYMx7KvSND8hPpfOlENrnUbLyUgbGUOIb/z42eBXJJne0tfTdt?=
 =?us-ascii?Q?BhG6BLhdFruZ+4/QkJllc6nnVFzoFRkNBcaopTeac/MRqlQwYXmjgxrnJ0Mn?=
 =?us-ascii?Q?TyvZNLX98O3gyqvh02XQX5xhamHjz4Z1vOmXGUCZx3qnqIEl12ITWeInZAlq?=
 =?us-ascii?Q?JgW3K38Ovvnb1gggVp9V2QDbGSRc3pGsPRUxbbg7d3QSTRvdtwvOl9zIhyLv?=
 =?us-ascii?Q?omXzRd6S/mfQsGNS5nsq/TO3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7144838-e507-410e-f5aa-08d95a79d0e1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 14:35:49.2767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3/n6xdZlvwG5dG14rgDcuXmWIFXyAwu4cPmJRs9dH0jdV4QNZUOKCvU0hIVrIZxeVccIYhpCeLfSosTZu/IPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On topology changes, stations that were dynamically learned on ports
that are no longer part of the active topology must be flushed - this is
described by clause "17.11 Updating learned station location information"
of IEEE 802.1D-2004.

However, when address learning on the bridge port is turned off in the
first place, there is nothing to flush, so skip a potentially expensive
operation.

We can finally do this now since DSA is aware of the learning state of
its bridged ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index d6a35a03acd6..a4c8d19a76e2 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -50,7 +50,7 @@ int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 
 	ds->ops->port_stp_state_set(ds, port, state);
 
-	if (do_fast_age) {
+	if (do_fast_age && dp->learning) {
 		/* Fast age FDB entries or flush appropriate forwarding database
 		 * for the given port, if we are moving it from Learning or
 		 * Forwarding state, to Disabled or Blocking or Listening state.
-- 
2.25.1

