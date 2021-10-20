Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A99434982
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 12:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhJTK6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:58:50 -0400
Received: from mail-eopbgr130077.outbound.protection.outlook.com ([40.107.13.77]:17730
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230111AbhJTK6o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 06:58:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MW2CqRYe2Gv55pydH6ehZfmKkepFs87g9/oXCz3ie6L7HB9EAviTcv5gQI5GXZFfUWSS180miqca0ijm+9wGvmh167CjnqHOK910feiqytpl8u1KO0cyU9dzcZ8LitF/P7aNxp95dbykBcf7TzZtZgpaYkSBXmzOl+1bZQAIzT8VA+nllrlcOn4zsbdlfh9SPJx/OKL00ltkYlmsp9+hUUFjPSc4699qwFwLYaQyZs727+lEh56Kuaa+JY0Mg22jGO2f2S3kYzzseJUVnLgcrhVniuhuA8pCbgMyKU9UpllGVL3ep5btJdDYCGW9wy6apFJzmXMUtNtEUVxiGrsyFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9VNW8VB/tlbumN9kxnzvQpspBfLlFO8yD7+DyEfywI=;
 b=i7BDUgMxkSKqejWOs4RjNWz1hdj6+HwnG6W6j5hmPP88h+0ToWaME/TSB6OZuRmlCprh4uAuh1pyK5kP/3EWOqNs0G5JtdP68SgyEhh2xtMyT967OF2AMuQoLBFdvC1EU2tNW00rDi3+d4vmfGuJdoPVixgGPLHKD8KjfjXivRsb5/hRxfT49K4WZKaSHkwR1pMmardTLAP8jPNhp599A9WvNPOsB2YA6xhhOGpkI7CeIGPLv2arHrvwxvJda8P2xf5wL8U1p27pstRq/caC4YN8ZGKP20cdN0CegBNrrTqDGQuGPE5CC8MblF0JpgJkOY/FXFrA7tiDqGB4KYDuUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9VNW8VB/tlbumN9kxnzvQpspBfLlFO8yD7+DyEfywI=;
 b=dsVUsDjwrwjR4wBOJXzTrIUerTeku92aAwq1ZVV1NhfTf2amn311mF+DRdi46oZZomftBjfJEVmsTjjgtLntjikB+TLcRXuxgnOgSNwGbeI86lw8JaphSVGotGq1gdOMpdJnXmmIL67ntCqnY1Nq2tWnGSKRCXNd6bi/nuebZY4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6702.eurprd04.prod.outlook.com (2603:10a6:803:123::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 10:56:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 10:56:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 4/5] net: mscc: ocelot: add the local station MAC addresses in VID 0
Date:   Wed, 20 Oct 2021 13:56:01 +0300
Message-Id: <20211020105602.770329-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020105602.770329-1-vladimir.oltean@nxp.com>
References: <20211020105602.770329-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0111.eurprd05.prod.outlook.com
 (2603:10a6:207:2::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR05CA0111.eurprd05.prod.outlook.com (2603:10a6:207:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 10:56:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5481053-99fd-4807-533f-08d993b84444
X-MS-TrafficTypeDiagnostic: VE1PR04MB6702:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6702DCC46467662F0ECAB9EDE0BE9@VE1PR04MB6702.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B6vA7PtwHKIzbuOOtYlrw9wIkuw+Rs21fQ6MmUFwIXBHMqJwu637eOVRAnGUCiFjIyZrvdgdkUtSpiWEHQSYoRTub6iYSg+XiWPDAxHq0HXHiks4UGKAI4tjX224BmHzV+pbjD1ouwuF319/bnTBoM7dARHf8SolMzoH72cZkP+bHo/Xs+CWskrVsdD5lE51E+fdRTUZEB1Y1bfqc3SXX3x5tmV9YiQfb+u5/lu9Wa3+rm9YVwkpmmX/Qxs9TCjdrks088tqsebSCD9xyDD6Mym182YkmxVuU1o4wvKfsko03WTCeW7NjLRYQNwav3CP/Z3X1j0U4n47TEt9I4fys3ez2e+c6DS7FmceggYnovFNccEQJ7QB9+58sbMASYdO8vqa2wNR1KeEmBp+c7p0tS9fehIiQ6fXqbFsVODUCr8en/jU2aBRF4YtN0epH3cPBmbMbCrBIjtr5UkSuElsq0btVRh2CsCa5zfntoE5UpdAKKF8YWWliOGNJQDxJqAJVQo6ABjGtgwliemaHPeCF/TJYfJyUu3j52rUGGtKToHdr1ekAH4EcxNiJ6TMe81TQ2XBZMOGMPkFTP5otmI/pWeof1PRoDO2UE5Hn0efPqlvVrQ7/bBKuqWSvymip2ymC1pvqc6iUW5WaQAy7IUwQCOxWrbFsWjD/TA5fc4PFT/9tmvgg3EWpkhnD3Fr493NwZ9Uw9jbfediV9UdgN93BQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(5660300002)(8676002)(1076003)(26005)(38100700002)(52116002)(83380400001)(54906003)(316002)(86362001)(4326008)(186003)(8936002)(66946007)(6666004)(6636002)(66476007)(110136005)(508600001)(44832011)(2906002)(956004)(66556008)(6506007)(2616005)(38350700002)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W6T2Br7BiBNKqpuln2X85T6eFG4c+RTLb3VL1MgsDl8haNRysW/ldmDWZXQj?=
 =?us-ascii?Q?LvSk+iTenqlRnBsGBFIoZnPDMnvGSv8rJFdXsdSXFgYT3ZDSUUTA9WZLE+ow?=
 =?us-ascii?Q?B0ZK/XQk8bWXzcRyP8pr/lyel0c5Uz6+fM1XdHF0FS99d1GzuPlCkX/lQb3x?=
 =?us-ascii?Q?gmOLEMxIKyEPgIlX8z2b3BflhUWUaRe5FvKeKgj5jaUNYbVCl97NW6hSYaX7?=
 =?us-ascii?Q?IZlnkbcQ1tyyWBqZ21Vobw2PylU6OsisOXcVzXPKtGj/EEVnS8wBXH1ZeHwP?=
 =?us-ascii?Q?plvfTXZzZdlVuYNzXOS3s4ezCfjOSzZxlPt3UqQjO8MycPh08/LlvT2MJVkY?=
 =?us-ascii?Q?WZ+oWllOcvMvtQtFbVhg6mFTKP7uBRld/MXub/hPqp0Dfh4b16moNpoZXEp9?=
 =?us-ascii?Q?LV56ltyU3iYKU83KsWotr9IC5a92kq67yjDZO5WzEWtAeJFOMeNUrjvqXkP2?=
 =?us-ascii?Q?GosrTjdpdMN449ElY9WL/w2E399OloocHLWoJdLfl9l5LzzeGDvKb+d0J45b?=
 =?us-ascii?Q?0EVUI8AuM7Ct7wXtJ19vBBusfv/k1yIh/422Tn+f1I/UtF50n1gmXdujfo7k?=
 =?us-ascii?Q?CgJgHlMR17UHbECWoSkSPR0y1McTts8LjyHoIodtS2pQrolEkGX85tlYYcZK?=
 =?us-ascii?Q?1BWt8lPU3eQn4QbIXfEUbUd3dZgtRe3iYh9dHA3JWGzX2fc81XaJPqYDns4V?=
 =?us-ascii?Q?qnTNCisQCNVYDKQRiAwGTIJ1QmyOgQEqhys+ZuTWbsEcFTftTyaNZ4ISGr5P?=
 =?us-ascii?Q?aDc0EA/uv2rtxLrXV5uaovrfNOxAMgOsfXWjkHStr5dUSKDjJgvud5ReKlS6?=
 =?us-ascii?Q?CwFbNx38ojrsp7cRDO94W2YUT/AWt0dJMuE0cQX6euh/R26Eb1ijzEzzITfO?=
 =?us-ascii?Q?FqQMtLD4TA5bWLA78MMaISo9wuob/pKxoSyDtKXemAd7Iw3oAghZcLsja5EQ?=
 =?us-ascii?Q?aXh3w32CE0RFkZhoZfIVu6t7kCOMTYiwXV/MZKot8QXKDeWHuGuZAmnEXl4F?=
 =?us-ascii?Q?OWIYFYCkJAEMsLtUlEB5W8SaAY54HnS6ufn44Phtd9UojNbDh62HOgGII6ph?=
 =?us-ascii?Q?pl/cnyjV4N5fRLnfmzRcFUflHtQnQW5zj89NQ5YKwU8d6hcDtpjNZhTLDKto?=
 =?us-ascii?Q?S3ayJb37tonmrL3k8TproNOFTw9jKxOgsq18fn+2a9B6kABC++vi+kiHYJPi?=
 =?us-ascii?Q?b//Yu9Jbf00gfinjWVewTL3WOKUQvYeFMLEFdl4+OgW5xqK8CtdNq8ml5M0j?=
 =?us-ascii?Q?M793N6f6yUO/zIkts0cTN2fP/JQQAOqqc9QVSUKo9QacogDpDdVEEo+qaUNj?=
 =?us-ascii?Q?G0cqmFRcXu3LdXJn6NPSAseQ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5481053-99fd-4807-533f-08d993b84444
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 10:56:27.9579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: upy573fb9i6EeUSiw24gy/Q0JQej6vFWW4wmIbbROKQOpDdgav0Z2H4kcEDq64POL8WUKHeY9NI0cvxOJH+tiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6702
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot switchdev driver does not include the CPU port in the list of
flooding destinations for unknown traffic, instead that traffic is
supposed to match FDB entries to reach the CPU.

The addresses it installs are:
(a) the station MAC address, in ocelot_probe_port() and later during
    runtime in ocelot_port_set_mac_address(). These are the VLAN-unaware
    addresses. The VLAN-aware addresses are in ocelot_vlan_vid_add().
(b) multicast addresses added with dev_mc_add() (not bridge host MDB
    entries) in ocelot_mc_sync()

So we can see that the logic is slightly buggy ever since the initial
commit a556c76adc05 ("net: mscc: Add initial Ocelot switch support").
This is because, when ocelot_probe_port() runs, the port pvid is 0.
Then we join a VLAN-aware bridge, the pvid becomes 1, we call
ocelot_port_set_mac_address(), this learns the new MAC address in VID 1
(also fails to forget the old one, since it thinks it's in VID 1, but
that's not so important). Then when we leave the VLAN-aware bridge,
outside world is unable to ping our new MAC address because it isn't
learned in VID 0, the VLAN-unaware pvid.

[ note: this is strictly based on static analysis, I don't have hardware
  to test. But there are also many more corner cases ]

The basic idea is that we should have a separation of concerns, and the
FDB entries used for standalone operation should be managed by the
driver, and the FDB entries used by the bridging service should be
managed by the bridge. So the standalone and VLAN-unaware bridge FDB
entries should not follow the bridge PVID, because that will only be
active when the bridge is VLAN-aware. So since the port pvid is
coincidentally zero during probe time, just make those entries
statically go to VID 0.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c     | 11 ++++++-----
 drivers/net/ethernet/mscc/ocelot.h     |  1 +
 drivers/net/ethernet/mscc/ocelot_net.c | 12 ++++++------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index bc033e62be97..30aa99a95005 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -268,7 +268,7 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 	ocelot_port->pvid_vlan = pvid_vlan;
 
 	if (!ocelot_port->vlan_aware)
-		pvid_vlan.vid = 0;
+		pvid_vlan.vid = OCELOT_VLAN_UNAWARE_PVID;
 
 	ocelot_rmw_gix(ocelot,
 		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid_vlan.vid),
@@ -501,7 +501,7 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 	 * traffic.  It is added automatically if 8021q module is loaded, but
 	 * we can't rely on it since module may be not loaded.
 	 */
-	ocelot_vlant_set_mask(ocelot, 0, all_ports);
+	ocelot_vlant_set_mask(ocelot, OCELOT_VLAN_UNAWARE_PVID, all_ports);
 
 	/* Set vlan ingress filter mask to all ports but the CPU port by
 	 * default.
@@ -2194,9 +2194,10 @@ static void ocelot_cpu_port_init(struct ocelot *ocelot)
 			    OCELOT_TAG_PREFIX_NONE);
 
 	/* Configure the CPU port to be VLAN aware */
-	ocelot_write_gix(ocelot, ANA_PORT_VLAN_CFG_VLAN_VID(0) |
-				 ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
-				 ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1),
+	ocelot_write_gix(ocelot,
+			 ANA_PORT_VLAN_CFG_VLAN_VID(OCELOT_VLAN_UNAWARE_PVID) |
+			 ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
+			 ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1),
 			 ANA_PORT_VLAN_CFG, cpu);
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 1952d6a1b98a..e43da09b8f91 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -25,6 +25,7 @@
 #include "ocelot_rew.h"
 #include "ocelot_qs.h"
 
+#define OCELOT_VLAN_UNAWARE_PVID 0
 #define OCELOT_BUFFER_CELL_SZ 60
 
 #define OCELOT_STATS_CHECK_DELAY (2 * HZ)
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index affa9649f490..e3fc4548f642 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -418,7 +418,7 @@ static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
 	 * with VLAN filtering feature. We need to keep it to receive
 	 * untagged traffic.
 	 */
-	if (vid == 0)
+	if (vid == OCELOT_VLAN_UNAWARE_PVID)
 		return 0;
 
 	ret = ocelot_vlan_del(ocelot, port, vid);
@@ -553,7 +553,7 @@ static int ocelot_mc_unsync(struct net_device *dev, const unsigned char *addr)
 	struct ocelot_mact_work_ctx w;
 
 	ether_addr_copy(w.forget.addr, addr);
-	w.forget.vid = ocelot_port->pvid_vlan.vid;
+	w.forget.vid = OCELOT_VLAN_UNAWARE_PVID;
 	w.type = OCELOT_MACT_FORGET;
 
 	return ocelot_enqueue_mact_action(ocelot, &w);
@@ -567,7 +567,7 @@ static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
 	struct ocelot_mact_work_ctx w;
 
 	ether_addr_copy(w.learn.addr, addr);
-	w.learn.vid = ocelot_port->pvid_vlan.vid;
+	w.learn.vid = OCELOT_VLAN_UNAWARE_PVID;
 	w.learn.pgid = PGID_CPU;
 	w.learn.entry_type = ENTRYTYPE_LOCKED;
 	w.type = OCELOT_MACT_LEARN;
@@ -602,9 +602,9 @@ static int ocelot_port_set_mac_address(struct net_device *dev, void *p)
 
 	/* Learn the new net device MAC address in the mac table. */
 	ocelot_mact_learn(ocelot, PGID_CPU, addr->sa_data,
-			  ocelot_port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
+			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
 	/* Then forget the previous one. */
-	ocelot_mact_forget(ocelot, dev->dev_addr, ocelot_port->pvid_vlan.vid);
+	ocelot_mact_forget(ocelot, dev->dev_addr, OCELOT_VLAN_UNAWARE_PVID);
 
 	eth_hw_addr_set(dev, addr->sa_data);
 	return 0;
@@ -1707,7 +1707,7 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 
 	eth_hw_addr_gen(dev, ocelot->base_mac, port);
 	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr,
-			  ocelot_port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
+			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
 
 	ocelot_init_port(ocelot, port);
 
-- 
2.25.1

