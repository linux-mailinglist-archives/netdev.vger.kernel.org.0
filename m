Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACDE3DC1DC
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 02:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbhGaAOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 20:14:51 -0400
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:60521
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234727AbhGaAOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 20:14:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pq3lh0uDuNsRyWH4Wag43xHS3MRWd7hRtogCgdsR4ju81B/Gxe+w4z1VnUi4JhybcmO9tAXtnmhiM2HNReuVlDkQlJTEONhLfZbDwvKz6Y/0pfB1G4VN4UD/rFzDnmpo4xXK477ttQJlaW4Os4mCSbm6vIkh7GV7WgfnoVZekQVzjqr0wnouZbCvtow21tDjNDVYc/vEVB5NKaGhtWjx2Ii9nB3izXk+psQwv5GG2JPRdm4KxtlW70DRX/3iGgjxDcX9EaC+7EVLiwrNuTU+xlrFmtRG+mrM+fkGXfafnYhqlrphNgmlSyf2D2ReIfoU/7w4GtXtf+WTsNFYTNMlVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcOFhEPsvg61cKJjoPdXo2mBE7caCRAhVYleZBMGrUM=;
 b=iavtJEako20GtfbDQ9Ez1OUln92UQlNQ8yqdfrZP+VJ4wag4F3KrSiCjT9R+gTUKXDNCbfwvYPllVgT+pC/HyTvaB6hUvlxqpnlNMapZo2roKcRczMLMlJ+Lxu09yNPai2eC5DOsX8yj0JI9HNwDJGOXPH8wOtsWH8HzxWVIZVXb2AHwH56PlYx5NXSJOuaPnFdTt/QEd2WmtP0ZtEP3ZBBT/3McktZztwf+1K7Bs7hvak9LDWnRHmkWDz6M/4/4yzh+uACov4bQ0wFx7BoUGr4ecFBVcJFQOBJ1wsheYb3U3jpGZ8GP67LctJ1Av+qDwGSpt8jIVfkNOQze6tW6Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcOFhEPsvg61cKJjoPdXo2mBE7caCRAhVYleZBMGrUM=;
 b=mxmGCmRdHp5pIQ/G5YaAp+DwM3uipHRs7cLPkBU0uB7mVljQzAtentMEFRbuMwt6SisscJwIO/9WNOiband96E2TAaq1ah3227Foo2+196xF/zLJ8bnviYpN/yvP8SBib7WGLeAxSj6ueJs7k15+CCX0UvW2S+MfedOU7FGpv3o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Sat, 31 Jul
 2021 00:14:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 00:14:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH net-next 09/10] net: dsa: sja1105: enable address learning on cascade ports
Date:   Sat, 31 Jul 2021 03:14:07 +0300
Message-Id: <20210731001408.1882772-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
References: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0161.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR02CA0161.eurprd02.prod.outlook.com (2603:10a6:20b:28d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Sat, 31 Jul 2021 00:14:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90a98c2d-ea8e-40e2-dd7d-08d953b82996
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:
X-Microsoft-Antispam-PRVS: <VE1PR04MB651170C5F5263327CEAA6ACFE0ED9@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7JxKy0mxZCKdE+vuSrtkykt226KGHxPaDbf96Oo/l0eELKa5t5v8Naz9PfKTo8S6i9HWru8DalrYEXZN8u1wlu2SsKJFATr3OsUCY5PyLGOB/91U7+cKmIG21XVQADOQArJBCy5w8qk5kVZvbAU2/YiInIGh72Eek9tPZSPupOnQSfwK8cPDficwF2h6dIv00PHnzguZIvljcl5cvraSMo2BA1rS8O7+i0HXBHlEmTmua1bxn88K96uhH+IWr9BEWHODPUTPxjVyXyUDqqKNWur8zWtgS+IKoZgurgxP/IdOp/NtbvzxDP8X+G/8SyC5IYFJyJUm21S3IA+qxkdtBaFFy8MucbmgRe+z4+ayPS1n701UwtRkZg3IUP4B+bau1qkuRzY4etM/RuJhbdHyGhbL//ExrDlLVCojlC3Kc+qHc/A3L+6oXUdXmD6vPKfUwKQNAFCfO7YtEx8uTI9LXISyjA8ChZdoIEf1HiNLDIXMadpXe8a9QHcM4xiI9ETBPDoxDJSDA7A3I2u8dvXQTXA5/8y5dfk7PILS7EucHcYnvci1dW6V/gYLJIXli7Ks7dMymeghyZ8Wyh4C7MSsEqGcd2EPu55fvT1+9T0baNloufQd2Igm862nyA4fVpd7ey7V5GAa23iJTJBQ+RumdjKT+WE+aEv9ifWL2kDTgDDIesC5o6j6Nqc0jzkLPUX7Ww4+yA857dsGC/XpjIasAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(8936002)(6486002)(6506007)(52116002)(6512007)(508600001)(66946007)(66476007)(4326008)(66556008)(956004)(5660300002)(36756003)(44832011)(38100700002)(38350700002)(83380400001)(54906003)(2906002)(8676002)(6666004)(1076003)(110136005)(2616005)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4sB+DGFlqFC3gpV9cLAVucw8jg8T6X/JMZ5nL5bmV5JAqXssV/0YefvSIHdd?=
 =?us-ascii?Q?O24gKSCKZWvPIN01JrVNpt3ZhP4yoiTbTEpytUHqqEWk0d12Rq+/1i0zRV3S?=
 =?us-ascii?Q?W8tPNpVT/F6qz4w5uaM8txs0TSXbqUDVmdEEkrMiZYFWfSMu8hett59gVFxg?=
 =?us-ascii?Q?AjVLgzDW/po89o0c5HkLLi6QBIzLjjY10IVYMZe99822RUtsrJiGUeoY1t0V?=
 =?us-ascii?Q?dOaf7dQPmhliquFhyHQjsSbDuheARAqk61qhr0W+oxw9Zm+32OkpUFqgRizw?=
 =?us-ascii?Q?tp1g0K/D0UAdSuM3IqWEhPS3dHKPFlcOTj1KQF9zVaA7M9kwuEXhkfzQBuey?=
 =?us-ascii?Q?naZD4SleaUlkCi/+dmWRnNM4qGbE6xRuohCUzlFimonkLku6MTLwnb4Q+aec?=
 =?us-ascii?Q?Se+xRcVC+IsjXiUcF6UZRXZ6qVdnttfkVspbCQOMOnUyITzJR+e6YMSR2cs/?=
 =?us-ascii?Q?+FCgODctSNXgu/1oQSUxhvtFK6QM3c30A7iKFwowMYwkqLAEw3Rauvf214uk?=
 =?us-ascii?Q?zJ2tHD7aO2sfx2yWO+PIrbFSRnZ6MOdEUDZXwTwj/5B+jPA174rgxeHWNMXg?=
 =?us-ascii?Q?9qaFh1tpFBL0HKCDaqIdY7dAY0bdNrb2mAqWZEtMQoGiB9gwHV7zTMGs/tLA?=
 =?us-ascii?Q?o0GsoYsy5LWTwYxsworo5XA0aOQOctU5v/8CMCgrR8vPgbBwSwH5Zw002I0Z?=
 =?us-ascii?Q?eaoJN822ZEBHKahVj/gCjINFDQ4EVXSleuTDHfHCSTjs+8YE6sp5M9qbB8uj?=
 =?us-ascii?Q?by1w77z259pAdxufhY3W5JXofGyIG2dajdE8cXQjx1KC9Q9kmI1beuIjmfl8?=
 =?us-ascii?Q?PaMWJYP7xyeOotPmerbQrLuZ6e8hzJrLlHiuTQB1a8fE1EmA5e/L4PAYc57a?=
 =?us-ascii?Q?dlSsCwxqFsYrXfVY5CX1ZCq8zahzPmdEETSyihZO6Thi/IdS0pF/O6d20qu+?=
 =?us-ascii?Q?HWA/s1uBSUkLJMaY8JS7HV6bBywfoRin+bO4vTaHH/lFdJIy0cHHzc3Slv7E?=
 =?us-ascii?Q?uKrqZRuC3kZ10rtes4CjrohmMgpQ/DtrJ81zIjnltaeZKdQyo0bZQ+nDgwnN?=
 =?us-ascii?Q?E/GemBzRi5+A6ATnr5J2TpAhk+fg/S9SZ+0exyeVZIbgBfKsiw3xP6yhEjcx?=
 =?us-ascii?Q?2N8GWQ7RWAi/p6LdIdayLwXslixr1xG9ykYC/7Gh1DAHh4V/uQ+xOf8BrLn/?=
 =?us-ascii?Q?6U1/egLdbwy9eyyYvhR+xf7Aqv6CCCrqBlx8gvlY0jUMbwrPcm/X4cwj975y?=
 =?us-ascii?Q?rm7aLx8ugeCGqG9DD+FAhnkhpY61XYmw+pO3Gt8m6QMXgQV+22nosJcMxCBU?=
 =?us-ascii?Q?PAOoi3hAFIGI61b0P8FYNqcr?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a98c2d-ea8e-40e2-dd7d-08d953b82996
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 00:14:28.7885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxrZ+eLwJCA8POSCLQ9lLPMhUl/5T0ait/3IuwZpfLLZz3TkIRBF8JRPwVd6ROEkFYbnj4dWTF9HGDjHs9hcAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, address learning is disabled on DSA ports, which means that a
packet received over a DSA port from a cross-chip switch will be flooded
to unrelated ports.

It is desirable to eliminate that, but for that we need a breakdown of
the possibilities for the sja1105 driver. A DSA port can be:

- a downstream-facing cascade port. This is simple because it will
  always receive packets from a downstream switch, and there should be
  no other route to reach that downstream switch in the first place,
  which means it should be safe to learn that MAC address towards that
  switch.

- an upstream-facing cascade port. This receives packets either:
  * autonomously forwarded by an upstream switch (and therefore these
    packets belong to the data plane of a bridge, so address learning
    should be ok), or
  * injected from the CPU. This deserves further discussion, as normally,
    an upstream-facing cascade port is no different than the CPU port
    itself. But with "H" topologies (a DSA link towards a switch that
    has its own CPU port), these are more "laterally-facing" cascade
    ports than they are "upstream-facing". Here, there is a risk that
    the port might learn the host addresses on the wrong port (on the
    DSA port instead of on its own CPU port), but this is solved by
    DSA's RX filtering infrastructure, which installs the host addresses
    as static FDB entries on the CPU port of all switches in a "H" tree.
    So even if there will be an attempt from the switch to migrate the
    FDB entry from the CPU port to the laterally-facing cascade port, it
    will fail to do that, because the FDB entry that already exists is
    static and cannot migrate. So address learning should be safe for
    this configuration too.

Ok, so what about other MAC addresses coming from the host, not
necessarily the bridge local FDB entries? What about MAC addresses
dynamically learned on foreign interfaces, isn't there a risk that
cascade ports will learn these entries dynamically when they are
supposed to be delivered towards the CPU port? Well, that is correct,
and this is why we also need to enable the assisted learning feature, to
snoop for these addresses and write them to hardware as static FDB
entries towards the CPU, to make the switch's learning process on the
cascade ports ineffective for them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2bca922d7b8c..6e0b67228d68 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -208,9 +208,13 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 		mac[i] = default_mac;
 
 		/* Let sja1105_bridge_stp_state_set() keep address learning
-		 * enabled for the CPU port.
+		 * enabled for the DSA ports. CPU ports use software-assisted
+		 * learning to ensure that only FDB entries belonging to the
+		 * bridge are learned, and that they are learned towards all
+		 * CPU ports in a cross-chip topology if multiple CPU ports
+		 * exist.
 		 */
-		if (dsa_is_cpu_port(ds, i))
+		if (dsa_is_dsa_port(ds, i))
 			priv->learn_ena |= BIT(i);
 	}
 
@@ -2530,6 +2534,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 	ds->num_tx_queues = SJA1105_NUM_TC;
 
 	ds->mtu_enforcement_ingress = true;
+	ds->assisted_learning_on_cpu_port = true;
 
 	rc = sja1105_devlink_setup(ds);
 	if (rc < 0)
-- 
2.25.1

