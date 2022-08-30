Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526D45A6E08
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbiH3UBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 16:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiH3UA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 16:00:56 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2063.outbound.protection.outlook.com [40.107.20.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1301A27B35;
        Tue, 30 Aug 2022 13:00:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oq8Oo9nud9ifiIvPpWPm2ir4qbkoQVBnBialKczxd/xgUiNgVi+z1AE+VQMjo0Xc+lnARxgJGYP09vLxGHy6QEUl4bnyYnb9AhV6QgncSD1R27A70dwGgiibCxxQNJP7HDrQi3EjlmxrnKDwiLSDd7lGJjamZoDD+HceXXKSxpqqKoe8/FOVZOgRZW6OmdPkmxxvgBNaxbfvvO3aN3FQXMTGqyuRY5JQ+rtUhj6xoRM0CNNE6APK8wZ6krfyogMZ2Ncl2I4RLUG2YG1wGIRgzUQHXntSx4sxwsfJAAk45sKLBabmj8jb2rUsJ09wkNs2+zxouLqOWWTCjKDpVFCMjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJ+5l8ZVZIfOaR90pE2Y7Vd0lgUj26CMFgln7XGVys4=;
 b=nb7MOyO8jCoYhkIJkSaCs8OOLOll4zGsZJa4ziaHTB9+8VMSW2GtPzAooCBnMx+4Jq/aSss5DL60M32+h9ycqqmN8QJEsRETNV+NN+NnBLvAioSJCwrCJ46xZEO9X6nqe5RRQm2WZdOQLaMVdar4wzuqIoxkRySqtR1ZnR/n+n0vXwB+nl3MCpFqX7nyq47OxSmaOnzVvZyvyxo9gljuvzspcyjSnzPTcBpgwBsPf+8FsNntopZdsy5VbCVM+nSFny1pH4JfP+X0ZHtpUaBtdDpcXgYHdtJqIGN7RdxXb8bKdBf1F7u4oD3iqp41HSITyQDNiY0JvplKe7iMTSdjSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJ+5l8ZVZIfOaR90pE2Y7Vd0lgUj26CMFgln7XGVys4=;
 b=JYVaUUDj4qIDg5U37Hm5hCe3rRtYAmM/hiACajr3FgCfLYjUG/TTVOt6+DyCo8nGJkoXUsj02az8NBrBwy0Xrd+piq4wZQ8KmVcnhrJQ+Hdlzx+ohw9f7fN7MgbN6Zacj+USX0buYSzgTkvZ8N+RgE4eU6VgS4oIu3OkSkBsus8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 20:00:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Tue, 30 Aug 2022
 20:00:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next 9/9] net: dsa: felix: add support for changing DSA master
Date:   Tue, 30 Aug 2022 22:59:32 +0300
Message-Id: <20220830195932.683432-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830195932.683432-1-vladimir.oltean@nxp.com>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42e427b7-ec6d-4dce-eb04-08da8ac236ed
X-MS-TrafficTypeDiagnostic: VI1PR04MB6270:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KKT8a3AkH9CuulDVqDo2AiiRGb6VvjK4KVA0cHYKmAIHc+NjB0X8BWcHzd0Qe6wdHJDr560sxRQDCgmw9lHsu7PUXm+MkpkqTc0AoWSVacr4EuvA/exvNbDmXCgxpCwj5ORK5VDi9svGo//hscCKBFBBuW//odNpHOMyPkT/zC582ur/0MHHm/kjy+LnwIgIE8gYqgRAw7kI+CeuATtrvXsp2Ki2gmkSwybsmhN9Z9HDlD1SCulCBvvxAiY1xztaRasfKSuRY6109k/GqWKJ/55A23LPagk7kkXiQnZS4WcK8C8FrTwWQF2t6CsAxTdvfUVevuMhW4+ln4EEP5VeN/EEXde53bPrToAry6kuFR7GYw0ZckeEN0sDdC4aRdJW/KeBkmQfpslfIBFhHUR3g77MSn8lHIjBmEWICfj2GJ1vmaRGrfg0X46r5hRUpjITvohfOeWz5ReNvYY4Xib0hMesu+mEfyhmxV3RhnFWALhotCp1VTfppLU4/Sr4UBET1+5ym6/iSZtHr4UHiOak/v3TX0x8sWVxj/Zokiy1lYeJNLOCDEYrRYzUak2qtxZOkmW3G7KSp+OSYxI1ER489fVaoHFoVCyBehcJrMSKbA33jvtgJBzKvhPBAjODbxROEhChwPzS3NM3egEAwmcZNx2UnsXrTOlJJ5XX7wPNYxu4XBmPfdnNaVB8Ooh9Qp+v2U6sRAH19aai4qDZ53cS+szboYQitG1+6WE+oHUo8mNupQpdreGsDwMPjZ3JxhAX6ktSqjvvmgopB2YM0b+OJVmRepFpznWeLeaSguHYFZ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(41300700001)(66476007)(6486002)(8676002)(4326008)(66946007)(478600001)(66556008)(52116002)(2906002)(83380400001)(44832011)(26005)(5660300002)(6506007)(6512007)(7416002)(6666004)(30864003)(8936002)(2616005)(316002)(86362001)(6916009)(54906003)(36756003)(38350700002)(1076003)(38100700002)(186003)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/axK7oufvu/BAhq8hk1T5CvPbdkQtra4F0vX63ceCirq9+700fy6ndSEhhzX?=
 =?us-ascii?Q?acJ5uC1jiz9yojJzASSw6xBtcEAdCTeRmIZojzXigg4VArIGZp15J5w3SOsU?=
 =?us-ascii?Q?PGwAkR0msuCGa1bqz7F9SnA2dg2/npfFIanJVC0IXhcyPx4t34NfW5vVRJxf?=
 =?us-ascii?Q?AJA96gpN9GmJRso5eF0g7tBgSuQ6DPfWJmPihkM7wdRa09Q2SZIsSU1rJCW0?=
 =?us-ascii?Q?BMpa1TK2P8L80IMOUlEzdTAbR6Mj5l3b+ZRerjIj4lGmwW/A2r3P53GJCaJ0?=
 =?us-ascii?Q?eZUNVSEd6ZUngfAnttFN7dz3vYqeQA9seW2k8aD3ZL51jNwPh1pHhzIfD0QU?=
 =?us-ascii?Q?rs1IGYtC2WK7Ib2xSi1Uzsq7TIIKhstZBxtfTc2a6ERE/XTpSnYfX/QeoHxk?=
 =?us-ascii?Q?sDssqr+F/Zb4hbVJNdqtUu4x8wgg+8izw9MpmnOOVLnPbpoSAdponTAFu8YU?=
 =?us-ascii?Q?kPODDWjcjQjL6pdFw+WJ2uXZmGkyADhgFwHERB6n7g31Pg81BImdAPbs3p10?=
 =?us-ascii?Q?bzwuB9shI4oqn20BD5RjviyjMmb4sY7TB7zkn1lxk9gg4aF6aaVZ1i0gHakz?=
 =?us-ascii?Q?IPjXhCkxQ1MHAUQmihbOPZVgnivJH/lb9Q8AqnKnbtM5ynxmA2Bfh+8/W2hv?=
 =?us-ascii?Q?vTxSaW286hHcmFOjUQYJVc03z0+3ODswahQNQXY5p0wmF8ji/m5iziQprxZi?=
 =?us-ascii?Q?5jfxt56ExTDGP/l8uoJnwC58o1uFSD3jtZE7RQsOuHtOPVvRIdcwtq10fBox?=
 =?us-ascii?Q?17tsR+gPSwUB3W4cC3LcaMRRuq8UI7m7Rh/m8AUTaYShK+4G6FK6150dDVxP?=
 =?us-ascii?Q?Nyf2EyU7iGDlSkcqBZb+dRkkdWNICWKd9nRGFHLiMb3hdLp5z4gBOyofToAs?=
 =?us-ascii?Q?5YxCwp5Pe69liP9pgTkvTH4etd4TSHeOdt1H93VM00J6w0bH7+71+DwpWK0e?=
 =?us-ascii?Q?fNF0lDmQvrIoWdm1KiuH3DA0P9qFTkw4uG9i/AcizxGK9mws/z0A0Gueaboz?=
 =?us-ascii?Q?V6rMaTtFwyCtbMUx4cpAJgEY27LHVN0rNSK6ND3r3Ciio17RrgYKxApUb7/l?=
 =?us-ascii?Q?RQIzrPMMuHg9KENnVHyFsUqkctSkb2T41Ey4StA4FI0q0onET2oIVio6BKYk?=
 =?us-ascii?Q?oYzcj5fu39HLx8AZW8EaXeW/ef/+aDmPr3hBZT87Waev4ykpluAtd3XbIMf7?=
 =?us-ascii?Q?RlafuFD032FytV5Otx8qkZqiotNRaMwEczv3yQjz28sTcVsDBcYuWbaUEA60?=
 =?us-ascii?Q?kkcYiFXL075EVAo/d590jrfH7enNDZaleshlz7Z5dMOYO09ir3+I3ycMS2+H?=
 =?us-ascii?Q?zaGh5qahPHlNCM+Y2VxNL2V5jE+1Vm+CM94lXwzDFxnmOMHnVFI1usWs/k+j?=
 =?us-ascii?Q?1diD3EBHm3H03rUckh3DrDQBgSWqdD+4mci7BjPzHkoYiIck20H62Kg6CMn4?=
 =?us-ascii?Q?n9FbM1vVcWzKcqJjZlOEkMxbr5KPoO9uJOVWqpVuNgewlH9iCX0cjdwhKMQI?=
 =?us-ascii?Q?Lbzosi/27kMl/829d/NPKuD7YA3SYbgzUP2Wo777pvDHvDxLju55MwzlTwGY?=
 =?us-ascii?Q?IYS0FOiAISooJpjmks+w173hsGqyOnNlNQICwG/ingAMmcqqX+SCOR2MHvv7?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e427b7-ec6d-4dce-eb04-08da8ac236ed
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 19:59:57.8227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TQrMaqKO/hj6iVNdfhs6VNVCSX+QmM22jjcGRNvzZDDQAcfNcyfvqttnL8rbW16/vBvfs2bCuvEfxSwjPhjg9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changing the DSA master means different things depending on the tagging
protocol in use.

For NPI mode ("ocelot" and "seville"), there is a single port which can
be configured as NPI, but DSA only permits changing the CPU port
affinity of user ports one by one. So changing a user port to a
different NPI port globally changes what the NPI port is, and breaks the
user ports still using the old one.

To address this while still permitting the change of the NPI port,
require that the user ports which are still affine to the old NPI port
are down, and cannot be brought up until they are all affine to the same
NPI port.

The tag_8021q mode ("ocelot-8021q") is more flexible, in that each user
port can be freely assigned to one CPU port or to the other. This works
by filtering host addresses towards both tag_8021q CPU ports, and then
restricting the forwarding from a certain user port only to one of the
two tag_8021q CPU ports.

Additionally, the 2 tag_8021q CPU ports can be placed in a LAG. This
works by enabling forwarding via PGID_SRC from a certain user port
towards the logical port ID containing both tag_8021q CPU ports, but
then restricting forwarding per packet, via the LAG hash codes in
PGID_AGGR, to either one or the other.

When we change the DSA master to a LAG device, DSA guarantees us that
the LAG has at least one lower interface as a physical DSA master.
But DSA masters can come and go as lowers of that LAG, and
ds->ops->port_change_master() will not get called, because the DSA
master is still the same (the LAG). So we need to hook into the
ds->ops->port_lag_{join,leave} calls on the CPU ports and update the
logical port ID of the LAG that user ports are assigned to.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     | 117 ++++++++++++++++++++++++++++-
 drivers/net/dsa/ocelot/felix.h     |   3 +
 drivers/net/ethernet/mscc/ocelot.c |   3 +-
 include/soc/mscc/ocelot.h          |   1 +
 4 files changed, 121 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index ee19ed96f284..bf9efb4aec6b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -42,6 +42,25 @@ static struct net_device *felix_classify_db(struct dsa_db db)
 	}
 }
 
+static int felix_cpu_port_for_master(struct dsa_switch *ds,
+				     struct net_device *master)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct dsa_port *cpu_dp;
+	int lag;
+
+	if (netif_is_lag_master(master)) {
+		mutex_lock(&ocelot->fwd_domain_lock);
+		lag = ocelot_bond_get_id(ocelot, master);
+		mutex_unlock(&ocelot->fwd_domain_lock);
+
+		return lag;
+	}
+
+	cpu_dp = master->dsa_ptr;
+	return cpu_dp->index;
+}
+
 /* Set up VCAP ES0 rules for pushing a tag_8021q VLAN towards the CPU such that
  * the tagger can perform RX source port identification.
  */
@@ -422,6 +441,39 @@ static unsigned long felix_tag_npi_get_host_fwd_mask(struct dsa_switch *ds)
 	return BIT(ocelot->num_phys_ports);
 }
 
+static int felix_tag_npi_change_master(struct dsa_switch *ds, int port,
+				       struct net_device *master,
+				       struct netlink_ext_ack *extack)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
+	struct ocelot *ocelot = ds->priv;
+
+	if (netif_is_lag_master(master)) {
+		NL_SET_ERR_MSG_MOD(extack, "LAG DSA master only supported using ocelot-8021q");
+		return -EOPNOTSUPP;
+	}
+
+	/* Changing the NPI port breaks user ports still assigned to the old
+	 * one, so only allow it while they're down, and don't allow them to
+	 * come back up until they're all changed to the new one.
+	 */
+	dsa_switch_for_each_user_port(other_dp, ds) {
+		struct net_device *slave = other_dp->slave;
+
+		if (other_dp != dp && (slave->flags & IFF_UP) &&
+		    dsa_port_to_master(other_dp) != master) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Cannot change while old master still has users");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	felix_npi_port_deinit(ocelot, ocelot->npi);
+	felix_npi_port_init(ocelot, felix_cpu_port_for_master(ds, master));
+
+	return 0;
+}
+
 /* Alternatively to using the NPI functionality, that same hardware MAC
  * connected internally to the enetc or fman DSA master can be configured to
  * use the software-defined tag_8021q frame format. As far as the hardware is
@@ -433,6 +485,7 @@ static const struct felix_tag_proto_ops felix_tag_npi_proto_ops = {
 	.setup			= felix_tag_npi_setup,
 	.teardown		= felix_tag_npi_teardown,
 	.get_host_fwd_mask	= felix_tag_npi_get_host_fwd_mask,
+	.change_master		= felix_tag_npi_change_master,
 };
 
 static int felix_tag_8021q_setup(struct dsa_switch *ds)
@@ -507,10 +560,24 @@ static unsigned long felix_tag_8021q_get_host_fwd_mask(struct dsa_switch *ds)
 	return dsa_cpu_ports(ds);
 }
 
+static int felix_tag_8021q_change_master(struct dsa_switch *ds, int port,
+					 struct net_device *master,
+					 struct netlink_ext_ack *extack)
+{
+	int cpu = felix_cpu_port_for_master(ds, master);
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_unassign_dsa_8021q_cpu(ocelot, port);
+	ocelot_port_assign_dsa_8021q_cpu(ocelot, port, cpu);
+
+	return felix_update_trapping_destinations(ds, true);
+}
+
 static const struct felix_tag_proto_ops felix_tag_8021q_proto_ops = {
 	.setup			= felix_tag_8021q_setup,
 	.teardown		= felix_tag_8021q_teardown,
 	.get_host_fwd_mask	= felix_tag_8021q_get_host_fwd_mask,
+	.change_master		= felix_tag_8021q_change_master,
 };
 
 static void felix_set_host_flood(struct dsa_switch *ds, unsigned long mask,
@@ -673,6 +740,16 @@ static void felix_port_set_host_flood(struct dsa_switch *ds, int port,
 			     !!felix->host_flood_mc_mask, true);
 }
 
+static int felix_port_change_master(struct dsa_switch *ds, int port,
+				    struct net_device *master,
+				    struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	return felix->tag_proto_ops->change_master(ds, port, master, extack);
+}
+
 static int felix_set_ageing_time(struct dsa_switch *ds,
 				 unsigned int ageing_time)
 {
@@ -864,8 +941,17 @@ static int felix_lag_join(struct dsa_switch *ds, int port,
 			  struct netdev_lag_upper_info *info)
 {
 	struct ocelot *ocelot = ds->priv;
+	int err;
 
-	return ocelot_port_lag_join(ocelot, port, lag.dev, info);
+	err = ocelot_port_lag_join(ocelot, port, lag.dev, info);
+	if (err)
+		return err;
+
+	/* Update the logical LAG port that serves as tag_8021q CPU port */
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
+	return felix_port_change_master(ds, port, lag.dev, NULL);
 }
 
 static int felix_lag_leave(struct dsa_switch *ds, int port,
@@ -875,7 +961,11 @@ static int felix_lag_leave(struct dsa_switch *ds, int port,
 
 	ocelot_port_lag_leave(ocelot, port, lag.dev);
 
-	return 0;
+	/* Update the logical LAG port that serves as tag_8021q CPU port */
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
+	return felix_port_change_master(ds, port, lag.dev, NULL);
 }
 
 static int felix_lag_change(struct dsa_switch *ds, int port)
@@ -1013,6 +1103,27 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 		felix->info->port_sched_speed_set(ocelot, port, speed);
 }
 
+static int felix_port_enable(struct dsa_switch *ds, int port,
+			     struct phy_device *phydev)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct ocelot *ocelot = ds->priv;
+
+	if (!dsa_port_is_user(dp))
+		return 0;
+
+	if (ocelot->npi >= 0) {
+		struct net_device *master = dsa_port_to_master(dp);
+
+		if (felix_cpu_port_for_master(ds, master) != ocelot->npi) {
+			dev_err(ds->dev, "Multiple masters are not allowed\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static void felix_port_qos_map_init(struct ocelot *ocelot, int port)
 {
 	int i;
@@ -1857,6 +1968,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.phylink_mac_select_pcs		= felix_phylink_mac_select_pcs,
 	.phylink_mac_link_down		= felix_phylink_mac_link_down,
 	.phylink_mac_link_up		= felix_phylink_mac_link_up,
+	.port_enable			= felix_port_enable,
 	.port_fast_age			= felix_port_fast_age,
 	.port_fdb_dump			= felix_fdb_dump,
 	.port_fdb_add			= felix_fdb_add,
@@ -1912,6 +2024,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_add_dscp_prio		= felix_port_add_dscp_prio,
 	.port_del_dscp_prio		= felix_port_del_dscp_prio,
 	.port_set_host_flood		= felix_port_set_host_flood,
+	.port_change_master		= felix_port_change_master,
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index deb8dde1fc19..e4fd5eef57a0 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -71,6 +71,9 @@ struct felix_tag_proto_ops {
 	int (*setup)(struct dsa_switch *ds);
 	void (*teardown)(struct dsa_switch *ds);
 	unsigned long (*get_host_fwd_mask)(struct dsa_switch *ds);
+	int (*change_master)(struct dsa_switch *ds, int port,
+			     struct net_device *master,
+			     struct netlink_ext_ack *extack);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index dddaffdaad9a..9ffe5db90281 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2054,7 +2054,7 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 /* The logical port number of a LAG is equal to the lowest numbered physical
  * port ID present in that LAG. It may change if that port ever leaves the LAG.
  */
-static int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
+int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
 {
 	int bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
@@ -2063,6 +2063,7 @@ static int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
 
 	return __ffs(bond_mask);
 }
+EXPORT_SYMBOL_GPL(ocelot_bond_get_id);
 
 /* Returns the mask of user ports assigned to this DSA tag_8021q CPU port.
  * Note that when CPU ports are in a LAG, the user ports are assigned to the
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2a7e18ee5577..e90ba089d5ba 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1105,6 +1105,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond);
 void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active);
+int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond);
 
 int ocelot_devlink_sb_register(struct ocelot *ocelot);
 void ocelot_devlink_sb_unregister(struct ocelot *ocelot);
-- 
2.34.1

