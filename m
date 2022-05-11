Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D92F522FE7
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbiEKJvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbiEKJvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:51:10 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60077.outbound.protection.outlook.com [40.107.6.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A006324
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:50:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asdSrvCWb92uipQPwOSVghgM9AGAssm0KetNIDPeAueSKmULW7bJu48F49CzePw4Ft3npTQMU9XLXKBVru+98yu9Srvub96IXw3T6ql7UBnho15PH2FLyu1dqjZUsjO34ZkvCJZBGt9n+ZzmVyoW6PhYOM6i0um8qNzN/UfmdEi+xpwPbIGIDTdJfm7a5+oOXcEd6GaPPDQwcB3OZuDnq2iUvncHeiDR+10f2sLDYlIVlIjz6c3rhm2jz2OEkBNwoTWiDVyqe9yrhohQSaYcG3GPh0RmzrERnuM+0sWLnb3GSQ8SyNOz4x3uABYhfJzNFOG+kj5xACz9tQszuecz9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IsIjrbNRHEv0QMzHJoekyaYHsZORoM247/IutFo4WIM=;
 b=VSDY0OfA1cwfcRlX7zNOVxiMvIkYGtyHqXw2UdjOPUYIW1wXJjlPapQOnoHOR3n3aK81driuaal4fvOEq3xDtZAdAhsr7gYeK3TH5BB9ZeGGEab8hw8RByUkJXT083I6eoqhEX/2gr6YiiQjvD5dBMr3HcVD5nuD+APAGP6Q4aJo6lovqF4MaDJTvqhi5oT2yNduCUR9xmndOU+KpafXB2aeM48XJDw8FwbpTAvaYBwJOnP+j2FZmTXOP4qyT6CySJ/7TjlScTML9JmMW9nwzBL2eVpqyrCNQQh5FaWGu5FlBIv0ts25huAbKZglXI4oQ9AJJMnBFxCRxrnnCjz/FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IsIjrbNRHEv0QMzHJoekyaYHsZORoM247/IutFo4WIM=;
 b=PAEvPDUV7mPtew1qpCDLxXJ9MjwbmvuuW3b7hPuBe4yTnvn+7ifVl1DHdhqXmlkOaEGABq6TtQUGucGXaX2rTxUdsq3z5bfbGUBIWONvI8tWdgRZnfMsVrUQ2LdnJbEv1Exg8x3m4A5/6Jd2ygXG4hQX5zWh17BAX3Jh1msvwjc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4964.eurprd04.prod.outlook.com (2603:10a6:208:c8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 09:50:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 09:50:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH v2 net-next 5/8] net: dsa: felix: manage host flooding using a specific driver callback
Date:   Wed, 11 May 2022 12:50:17 +0300
Message-Id: <20220511095020.562461-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511095020.562461-1-vladimir.oltean@nxp.com>
References: <20220511095020.562461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0158.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c33311eb-d566-40a3-31fc-08da3333b69d
X-MS-TrafficTypeDiagnostic: AM0PR04MB4964:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB4964390AFBFE435B6F7ED053E0C89@AM0PR04MB4964.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CVsxwcZ/uzhnSNVyzA3J1GQMtzlRZUz/Av9o75T657OffNWkUFj3IJr1A0gsc1FNUv2TQ8w7/r2lO2vpaefj8996OS5oCFuGpTZhldsNtTC9v8Z58P9UO5BUBCi9hcCxRZrRNnEtFTH7MD/rYMFEm63ZjX1XxB/FpcPYT7aAF+Ck+fjHnRzoO6qUHBAqHv3b+D48dVRTvujQABY+fs/Arxhk+ee2UorIcPHBWprGm4Ga6YcqToVsvizDsFT0xcGL6E3VgBuhYi/77icBgL6XEq6i0+GcIQPi4PL5KU1NMfxjfetvq1mV32rIsp1yChCWxkvURfBvPYGEorXv8/LkYRsp4tGc1Ewo0585HKjWPZrV+xHoD9gJwsPPNGYU8gxVnyEV5pMuKDK5OADf4h5T1EQXdz7IGQe7JiaIkQtcZiWUgKz1MRnBPkazDNBJHd3jAkzjzUVhWO/cQ+Tuxx81/SAlhCAaBNoPBNzGWqSHgwID45Wdgxhlu8ImPQsAYwmEAvBo41Eq1mqXhGkT8iAVoIzaMlF2AOqHZOq/decsMXfPneU+ArR461dELolnIPv2EFAcbW7ZPgN05No5ggRGuoNyPPmEcEG9VseHDkc4+hIXwtVE6d/aDsieLt0mcaTNUkvOmWyEXwjMa7UNPVk2Zk+3oisIXFEpB+K9izhDCmf5M7Wr70VJqbzJkL2ec2Gxn+C6NAKTVr4jC0lLzabisQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(54906003)(38350700002)(66946007)(6916009)(508600001)(66476007)(8676002)(66556008)(186003)(1076003)(316002)(83380400001)(36756003)(2906002)(44832011)(86362001)(6512007)(5660300002)(2616005)(7416002)(8936002)(6486002)(6666004)(4326008)(6506007)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L0/6cSv7Pjtp82z9Iztas9nNNVp6RVzQ2vN+5PAGCqgh69jD31wAo3ZP6GX+?=
 =?us-ascii?Q?hdmo8M7ENpbFq6tOk1tTCfRRf8gZwAQ4EGL+biQffhIBg7Zf58bCYjqqVGdO?=
 =?us-ascii?Q?ij261aivUy1hZPMR/CkL9tWMh7RSyJXrOjz7dylss+iyeLe8uBO2SznUQAuv?=
 =?us-ascii?Q?xzZiQRhUuRVeyngNu9CPh/lADipBQC8Fv0CjimJbuBEOTbUUk6AbUEel4Dy7?=
 =?us-ascii?Q?AChbua3x2UM730KUKxtrY8g4mrdD5KTupxLMnTM/0BGmAwayvIyQH+N9ncxu?=
 =?us-ascii?Q?gL6mQZbfpf80HYoEKO+jIUJ5mFpPUDoDXRTwcrxXd0qcw+Ah5TkVSIABGV9D?=
 =?us-ascii?Q?uG52L5xm85WUt1y/NqBMWxDOa2UvU/vmJuDqi8vg49O7L4j6SHfvgZFC4ibn?=
 =?us-ascii?Q?P31gGib2qrhuzbjEjDlPC+0uZG+xuiflWFtvPJYVC5LqUe+wPjl4zz4EfPsM?=
 =?us-ascii?Q?F8pyMSJ1nga43ZWrRcZQrrClRYxrcPiWWJiP1h7YRUofvUvp5Mjsvx/r72fq?=
 =?us-ascii?Q?D6Gv1tnHbEt8cSawEth9lrvQdoKPLRPflikTG3yFQ9gyXrU49qgD/p2PV4Z3?=
 =?us-ascii?Q?QenuJ+zpEMukX7Esl69kbAK5Gdf7E/GuVSM6/eSSq6THqeXzIhSnwVIdB3O6?=
 =?us-ascii?Q?0ekRWrZKN+4a+yuiph5tCoIAIV/7YqFuChSS/cpueknZRrQgM3SkiE+wbLg7?=
 =?us-ascii?Q?WBVzj4+qBTu2NPAfWuagcdsnld74mznuJsU0gz1d5D3YcyFyKdyNcGjYZ9il?=
 =?us-ascii?Q?tLHjTvVYg1ZfzpbeEaf1KwdhLvQtk7ytQXYueTNTqw0DVxDD7dvhBdbkc2bD?=
 =?us-ascii?Q?3vdu46n0qqp7amFr4/BA/78Zw58EgrRdfxFcaJvM4RqE5nfQvDflkT2khJUb?=
 =?us-ascii?Q?/Bql/0ymJs1dEyRUh/SeAJ1fx6qgpYCNGyX05wXT+1GTSvXg0iWxR2zT1Ud6?=
 =?us-ascii?Q?WaLU2S4f2g1IKJBtOesstyzzop53pMs06TRapPWtZ86IDcjCsF4eeyrFmDc5?=
 =?us-ascii?Q?mij0BqGNYSrPb9TyJ6J3q1R5Hzg1zNPljyuPohYABwsNjqFwXzzvlpUohgV4?=
 =?us-ascii?Q?VLlrK13BPL5LdjyVOz/UNITEhbIHUJKlt3tVCCnvR5Twq6Nt3I1V4gsgAqmc?=
 =?us-ascii?Q?20V/NDprfyMpUemufLt0jncg8niK00BozuCwko1LZ81ZacYDkw2gnUVgDiFX?=
 =?us-ascii?Q?JWHDtPhO78jeryyVTDyyy6tNx47YAJDQHBAaCgXFX0gppW8LEyGRhHUe+AlN?=
 =?us-ascii?Q?KbUtDDjLPhaA97Ib2FWpuouO/Qghhk11VgV1/SGv16KghzGg3J9UmVPmvZVq?=
 =?us-ascii?Q?axYEoCxusjiJUNuGpG5yj7J7SLZj9+QnTjSMRPNmCsR3IflMc5hh1XNec7Gs?=
 =?us-ascii?Q?5xfssqYO1sWmGat64mYJS3nGgCbY/lzPfkR8MikEnkVdJkZlrD7umc7lYjqZ?=
 =?us-ascii?Q?VVgEtF0WOGCMkC7ehKTcvgQt36WSndJoWqeCQmRE2K+mCPKgRAJwqLF+5slQ?=
 =?us-ascii?Q?AYLbqqzzG7i/O4wjUzM4jeUwmuZ6NmiMAOhRy14TH6qG5nuufrkNYodpandZ?=
 =?us-ascii?Q?mlDsj77o2+o1djChTKOe9aUYRBYgcJzXdV8Rbd/JBKrb7XG24WKNImU3TY2C?=
 =?us-ascii?Q?MEXlFhE+qPZ/Hz4e8B9YrVS1F6P/AS46Wmiqo9VARi6nUHkPL9aWXiMmJz70?=
 =?us-ascii?Q?u1Kmx67+XGkZH6JqS8LEzld56R7BGyUZNNuJtdI84JQyrAnGnejQFCqYGzdO?=
 =?us-ascii?Q?r7zhDgLYJh6oYw/8jEMvrXQ2+d/BiQo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33311eb-d566-40a3-31fc-08da3333b69d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:50:42.8637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nyRCt/BKgH2erfT65uRDaPcoHih3CXfb+Bw9tljOx1v0MEmdNPkdXEIuu0q2m/4VZFFgxfyYLt+iBgyld2Hg1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4964
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the time - commit 7569459a52c9 ("net: dsa: manage flooding on the CPU
ports") - not introducing a dedicated switch callback for host flooding
made sense, because for the only user, the felix driver, there was
nothing different to do for the CPU port than set the flood flags on the
CPU port just like on any other bridge port.

There are 2 reasons why this approach is not good enough, however.

(1) Other drivers, like sja1105, support configuring flooding as a
    function of {ingress port, egress port}, whereas the DSA
    ->port_bridge_flags() function only operates on an egress port.
    So with that driver we'd have useless host flooding from user ports
    which don't need it.

(2) Even with the felix driver, support for multiple CPU ports makes it
    difficult to piggyback on ->port_bridge_flags(). The way in which
    the felix driver is going to support host-filtered addresses with
    multiple CPU ports is that it will direct these addresses towards
    both CPU ports (in a sort of multicast fashion), then restrict the
    forwarding to only one of the two using the forwarding masks.
    Consequently, flooding will also be enabled towards both CPU ports.
    However, ->port_bridge_flags() gets passed the index of a single CPU
    port, and that leaves the flood settings out of sync between the 2
    CPU ports.

This is to say, it's better to have a specific driver method for host
flooding, which takes the user port as argument. This solves problem (1)
by allowing the driver to do different things for different user ports,
and problem (2) by abstracting the operation and letting the driver do
whatever, rather than explicitly making the DSA core point to the CPU
port it thinks needs to be touched.

This new method also creates a problem, which is that cross-chip setups
are not handled. However I don't have hardware right now where I can
test what is the proper thing to do, and there isn't hardware compatible
with multi-switch trees that supports host flooding. So it remains a
problem to be tackled in the future.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix.c | 32 ++++++++++++++++++++++++++++++
 drivers/net/dsa/ocelot/felix.h |  2 ++
 include/net/dsa.h              |  2 ++
 net/dsa/dsa_priv.h             |  1 +
 net/dsa/port.c                 |  8 ++++++++
 net/dsa/slave.c                | 36 ++++++----------------------------
 6 files changed, 51 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 59221d838a45..6b67ab4e05ab 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -634,6 +634,37 @@ static enum dsa_tag_protocol felix_get_tag_protocol(struct dsa_switch *ds,
 	return felix->tag_proto;
 }
 
+static void felix_port_set_host_flood(struct dsa_switch *ds, int port,
+				      bool uc, bool mc)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	unsigned long mask, val;
+
+	if (uc)
+		felix->host_flood_uc_mask |= BIT(port);
+	else
+		felix->host_flood_uc_mask &= ~BIT(port);
+
+	if (mc)
+		felix->host_flood_mc_mask |= BIT(port);
+	else
+		felix->host_flood_mc_mask &= ~BIT(port);
+
+	if (felix->tag_proto == DSA_TAG_PROTO_OCELOT_8021Q)
+		mask = dsa_cpu_ports(ds);
+	else
+		mask = BIT(ocelot->num_phys_ports);
+
+	val = (felix->host_flood_uc_mask) ? mask : 0;
+	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_UC);
+
+	val = (felix->host_flood_mc_mask) ? mask : 0;
+	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MC);
+	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MCIPV6);
+}
+
 static int felix_set_ageing_time(struct dsa_switch *ds,
 				 unsigned int ageing_time)
 {
@@ -1876,6 +1907,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_get_dscp_prio		= felix_port_get_dscp_prio,
 	.port_add_dscp_prio		= felix_port_add_dscp_prio,
 	.port_del_dscp_prio		= felix_port_del_dscp_prio,
+	.port_set_host_flood		= felix_port_set_host_flood,
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index a5e570826773..b34bde43f11b 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -72,6 +72,8 @@ struct felix {
 	resource_size_t			imdio_base;
 	enum dsa_tag_protocol		tag_proto;
 	struct kthread_worker		*xmit_worker;
+	unsigned long			host_flood_uc_mask;
+	unsigned long			host_flood_mc_mask;
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 76257a9f0e1b..cfb287b0d311 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -978,6 +978,8 @@ struct dsa_switch_ops {
 	int	(*port_bridge_flags)(struct dsa_switch *ds, int port,
 				     struct switchdev_brport_flags flags,
 				     struct netlink_ext_ack *extack);
+	void	(*port_set_host_flood)(struct dsa_switch *ds, int port,
+				       bool uc, bool mc);
 
 	/*
 	 * VLAN support
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7c9abd5a0ab9..d9722e49864b 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -291,6 +291,7 @@ int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
 void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
 void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast);
+void dsa_port_set_host_flood(struct dsa_port *dp, bool uc, bool mc);
 
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 075a8db536c6..e1bc41654e35 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -920,6 +920,14 @@ int dsa_port_bridge_flags(struct dsa_port *dp,
 	return 0;
 }
 
+void dsa_port_set_host_flood(struct dsa_port *dp, bool uc, bool mc)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->port_set_host_flood)
+		ds->ops->port_set_host_flood(ds, dp->index, uc, mc);
+}
+
 int dsa_port_vlan_msti(struct dsa_port *dp,
 		       const struct switchdev_vlan_msti *msti)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5ee0aced9410..801a5d445833 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -262,37 +262,13 @@ static int dsa_slave_close(struct net_device *dev)
 	return 0;
 }
 
-/* Keep flooding enabled towards this port's CPU port as long as it serves at
- * least one port in the tree that requires it.
- */
-static void dsa_port_manage_cpu_flood(struct dsa_port *dp)
+static void dsa_slave_manage_host_flood(struct net_device *dev)
 {
-	struct switchdev_brport_flags flags = {
-		.mask = BR_FLOOD | BR_MCAST_FLOOD,
-	};
-	struct dsa_switch_tree *dst = dp->ds->dst;
-	struct dsa_port *cpu_dp = dp->cpu_dp;
-	struct dsa_port *other_dp;
-	int err;
-
-	list_for_each_entry(other_dp, &dst->ports, list) {
-		if (!dsa_port_is_user(other_dp))
-			continue;
-
-		if (other_dp->cpu_dp != cpu_dp)
-			continue;
-
-		if (other_dp->slave->flags & IFF_ALLMULTI)
-			flags.val |= BR_MCAST_FLOOD;
-		if (other_dp->slave->flags & IFF_PROMISC)
-			flags.val |= BR_FLOOD | BR_MCAST_FLOOD;
-	}
-
-	err = dsa_port_pre_bridge_flags(dp, flags, NULL);
-	if (err)
-		return;
+	bool mc = dev->flags & (IFF_PROMISC | IFF_ALLMULTI);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	bool uc = dev->flags & IFF_PROMISC;
 
-	dsa_port_bridge_flags(cpu_dp, flags, NULL);
+	dsa_port_set_host_flood(dp, uc, mc);
 }
 
 static void dsa_slave_change_rx_flags(struct net_device *dev, int change)
@@ -310,7 +286,7 @@ static void dsa_slave_change_rx_flags(struct net_device *dev, int change)
 
 	if (dsa_switch_supports_uc_filtering(ds) &&
 	    dsa_switch_supports_mc_filtering(ds))
-		dsa_port_manage_cpu_flood(dp);
+		dsa_slave_manage_host_flood(dev);
 }
 
 static void dsa_slave_set_rx_mode(struct net_device *dev)
-- 
2.25.1

