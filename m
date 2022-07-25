Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80E95805A5
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbiGYUba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbiGYUb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:31:29 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60055.outbound.protection.outlook.com [40.107.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C4726FF
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:31:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXtoOuj5+OwO5+p3N5EtamOMxB+2VrTSPpnNCywOehvneWJj8cGLdPTKCHWtU+uejDjeYXCk6zMe7g4w0Xgh9i8Oz8Zob/KwxAwRDzLPfrfDhEBO6FX0kdHCgxjfLE7O0rLMOovjNqPPlURcawWumBbMTHXOdhAQlvGMY16NpEF59xNesMdpGnqmmQ81isqHcxeRWIploP41i5zAzZd5Q7P8qvQM9rVlSvvRusL1bgcuPSehXHGHC+2q2o4iXg4+2bubiLV4nL0yVl7UVqM/IEyqZSRbV+aRzCucJf99CS9kK7Ln9yE8AKDd162hgqNqPw2Nalynz80p+Z7z0JD6Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4tQSar1pikfe3gzS1sstUmv34os5KlH5a5Nvdl3knA=;
 b=bcsd8kBwmJlgj2Ds5D29zLduBe+z2UTfVAI1FbMo05t8PxUOMocVGSzXPKtIDDINxJ42am+U0TQhYicDM5IuZl2NzDOGewgtHuPgiyPjbPzZ2kh+2fV0+fXPERJOo7aMezdHTzLzAGMQ30df9UXQn04OaP2MO+/PVYaP6cWEa+qiQ80DxSyMMLMp4h6o/Epl8boRjsoZ4spLLbunTykzFfzYM9D0MsR/Wf59JhzHCaqcL3ceZ3xWfB5o+iaMg64yBjQhaF2SXxXzFbONtKXumZAOilmVJtFMyO8DctznaSNoRc09jV2wm4oQMrgSUrs1f7mFE3zgnP670ceaAO5k9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4tQSar1pikfe3gzS1sstUmv34os5KlH5a5Nvdl3knA=;
 b=Ehhe6RSJCTvGe60M+OlU0I1dXKNPiF7x0OivBTe6NvgzQqkexIIhoi3Yfu5IYRTvXoaB2E8G8G1SnuFWaE3RCKVHidy9p7VsPY+B8WQHQx77Iplo85xz9WKPctGTBHVShJ/T1TRrmpQm/NYw0LKFRJSrLwxUG+yJwntUeMYgFXI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5322.eurprd04.prod.outlook.com (2603:10a6:10:1f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 20:31:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5458.019; Mon, 25 Jul 2022
 20:31:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH net] net: dsa: fix bonding with ARP monitoring by updating
 trans_start manually
Thread-Topic: [PATCH net] net: dsa: fix bonding with ARP monitoring by
 updating trans_start manually
Thread-Index: AQHYmKJbDVvU92lcVkqDHlTGpm7yu62AHOkAgAAD6oCAAAF5gIAAAb0AgAAIHwCAANLpgIAAqJ0AgA3yEoA=
Date:   Mon, 25 Jul 2022 20:31:25 +0000
Message-ID: <20220725203125.kaxokkhyrb4aerp5@skbuf>
References: <20220715232641.952532-1-vladimir.oltean@nxp.com>
 <20220715170042.4e6e2a32@kernel.org> <20220716001443.aooyf5kpbpfjzqgn@skbuf>
 <20220715171959.22e118d7@kernel.org> <20220716002612.rd6ir65njzc2g3cc@skbuf>
 <20220715175516.6770c863@kernel.org> <20220716133009.eaqthcfyz4bcbjbd@skbuf>
 <20220716163338.189738a4@kernel.org>
In-Reply-To: <20220716163338.189738a4@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7712151-f295-462e-e5e4-08da6e7ca583
x-ms-traffictypediagnostic: DB7PR04MB5322:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r9vE0Sfze+gJrls1LtPL+J7icrFIlK5touGYfX8EP/uJkgYlCXkXndLRAhuafQY8VB1zUnpuiIhEt+nl7GLU/k/YHcRQfSjW1c7wS+fvFjb0F4HeM7SUdpCzhI5SmbDKY0RyFxHgP6oAJdM+wR55czlrdhZGPBwT4SazBIhmXu5yQYac/zh9wqBgCR5xpfDZFtJuMNDdFqCDqINmfiZ32bZLHcesV75PMsCcQHjd039drTUr3STzP2AkO/HvlEfmk6Y8c+8n6RVzzrWa3Uh8ZZv1dthXJ1JRUQGCuq2O7IaSEPhV8L/0LURllH9cJxwQcL1XVIVr50yr6z8dVHsW1y2OXBrWihgsz+NWHjYr5zyXZixVAaDv/1qzl12bDhUuWeGmTmK8NvvpohHThXN+Ng02GkejGV3sj6Ee8D9TFlIAR/Npu2j+mM2IE3Jkuw2AFEXGenrCuhR0O/k/KqWWLPqN0OQG1KcUUHmrKXnj0TjWFKZqwDwcVyraItV1d7F/qhu/jqyzSOxJUmrnbD8Ua8FPQxAHZYeTHLagX+9N9ZfyCXsD58NMU198UMMSmOvNo8uAnPGbnd0iPjYmyP/iOsi2AhvBn3hKZKM25ZL9jnGd+DrLUcaVBQdbm/6u/XDKU1EcbikX+qu5lXkJwP5f4J+x/DRtCFLYV0q74Z4Mf4D0GY8//pXWJNaEUzVN+9ucqhcu5xBwyKmbNSFe7WIIvM2IIHVVPGgwSnskfPfJPDtCgFo1k3SH0xvsiPxyRLHgz4sB8JMhj6qbLBBLwlkpS3k/9RTXxWRNKpQzSy0ourc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(376002)(39860400002)(396003)(366004)(136003)(54906003)(66556008)(76116006)(66946007)(26005)(4326008)(66476007)(83380400001)(8676002)(44832011)(6916009)(64756008)(6486002)(1076003)(9686003)(8936002)(71200400001)(478600001)(91956017)(316002)(7416002)(2906002)(6506007)(66446008)(86362001)(5660300002)(41300700001)(38100700002)(186003)(33716001)(122000001)(38070700005)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ueFDpcpdJXnx7pc34myUDokjXzFgI50Emd9S3o/IzrSnHwedsDfBV49FO+th?=
 =?us-ascii?Q?bNRufPjSLaWnesrSSIUTEGLEpf9n+3LF4gOnEerwYykgAK1qiYOGnCPl7o3f?=
 =?us-ascii?Q?Qt/UIyCWpcULTwR3WxXIfsk3EfbByf8mbDv/fIK+6eRj12IJkAeu65b1vH1c?=
 =?us-ascii?Q?hxbnwucng75A1rqMZOrFvgPdryALXIhO+BagNJLVBiA3BlJZfLZksvM9NcuA?=
 =?us-ascii?Q?dMBYWXFNUK9PY6fGes5VcGeLXzwoGVRyXMy4Lv1CcC09uHhilMMnkyGYIHUB?=
 =?us-ascii?Q?jOG3Z8biPwpRUykvZku7ILjE8citesOirUvklhaeVywuYRhQHCtB7X4i7DpD?=
 =?us-ascii?Q?4DTurn30syyo5S60irho6rt5BjXhoDx5WkqqvEtXkICUtBO6GC1n0QrDgEZc?=
 =?us-ascii?Q?Nfl7Pmzn/uzET57Hqo/FhAFKnKQ0gohHq4m4eqfZF5psNpxFRGeitkXJWeqj?=
 =?us-ascii?Q?9ullYHVf870XpLbmzVdrhFpno+yAJzKWZMywgA5uGoXjSBj/FnspHElzA/Jm?=
 =?us-ascii?Q?9BbJ6bQYvLbCeMeUCmDe9JTs53qUwyZRvMaZ9I0MRa4cvd1lyPLsEJWpIo7I?=
 =?us-ascii?Q?tCTY4TeY62ZawN/x7iyg3EglUT0kdjur6+7Fbl1Ij5eEZx3kRXyeVc460k6w?=
 =?us-ascii?Q?LLa+vOXBXkJB6o7+lq05GSJntbJxokn3xChOA0kBQAwpLkZnvGng1W/APcYM?=
 =?us-ascii?Q?6uDS/BkmdjxUtyx2GZUOJA8F+l0Nyh2uKeBOkYoUgWY9z44NMBeJi2u7c+TK?=
 =?us-ascii?Q?Mg5+3bOAdZCgHLPL66qvHodJB2JBiPzTZMvO0doMc2tpr+LwYikjD3JkZNcU?=
 =?us-ascii?Q?uYhNI7ZkUQwU9qSSQYI3ChteH8o4JZImGntaClkfTR1Rhb9GrIBlk3yScHM5?=
 =?us-ascii?Q?aWbGAACU4PEv4YcYoGzTgsmVBLAlZw3ZC8lELWPSxqGtM/2tSq/ytPCE8SLC?=
 =?us-ascii?Q?W4d2p5dGAP15s7qfisAXpIhYLCJ1e2UG26iJHET14BybIJ2LfrVermyRlkPU?=
 =?us-ascii?Q?VyA/xcUAnuT5Bj6fjenimoaWvtRc6R31VeMQA3ovvi6Jugf/SWAlLBend3ue?=
 =?us-ascii?Q?LyC7IAKIkRoUnqxzzQVwwLuJLtNG654Z7g0atQbNDU9n00FiFiBySsGIEr2S?=
 =?us-ascii?Q?5mQ/krJQhvDlZqJxFo7XZsEnPQCk7OIxKmUd9fHMzLU7eY3pPkVtWjDfvXAi?=
 =?us-ascii?Q?bb7Dv7HprehbDeVUd4aLMJSQVH6xIHzmBobf3SL4APb3I+qLXhvLVOdQEN/k?=
 =?us-ascii?Q?ErhTxSyX3IjRnOahFW4McGfUqotIjcePc18aiDqdXut/V6U7AePSUwgkB5N/?=
 =?us-ascii?Q?YTORor80KCK9jgudOE/n6iamCDPStPy1qhwjmFmw/TdMyFv6qZjaCa+1RdPw?=
 =?us-ascii?Q?bYIb/f+E+iP3eUmyjxVebBk02mNybKGR1aftB8IMZwgZBW7tyzFTOjtrxdwl?=
 =?us-ascii?Q?AWsM/eCR1TYe5XYAlijBTyU+vgoW8r2QfLzrS+iESAcp6zNF2nWN4+OE6Oyu?=
 =?us-ascii?Q?QklROporgUFfufoXXQyajf47wVOHjsrrpTWtLa0vG9vje4wQIfU5hCcye/Zk?=
 =?us-ascii?Q?Rzm0vY+NEteGIjwWhCEjKlugQ+vDcSuTKFiyduxjfdWzU8iY0xpAiJzv0iu9?=
 =?us-ascii?Q?Og=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4DDDA725C275BC4AB5B621B9A0389443@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7712151-f295-462e-e5e4-08da6e7ca583
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 20:31:25.7762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iy/t8UMRCFUgYIcrZ9nAR7QRsNI9Wu5mGqr+Niu3CNQgkVifg0SMp+RzmqQINyZLGwEtgradKdTNY343Hu7KqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5322
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Sat, Jul 16, 2022 at 04:33:38PM -0700, Jakub Kicinski wrote:
> On Sat, 16 Jul 2022 13:30:10 +0000 Vladimir Oltean wrote:
> > I would need some assistance from Jay or other people more familiar wit=
h
> > bonding to do that. I'm not exactly clear which packets the bonding
> > driver wants to check they have been transmitted in the last interval:
> > ARP packets? any packets?
>=20
> And why - stack has queued a packet to the driver, how is that useful
> to assess the fact that the link is up? Can bonding check instead
> whether any queue is running? Or maybe the whole thing is just a remnant
> of times before the centralized watchdog tx and should be dropped?

Yes, indeed, why? I don't know.

> > With DSA and switchdev drivers in general,
> > they have an offloaded forwarding path as well, so expect that what you
> > get through ndo_get_stats64 may also report packets which egressed a
> > physical port but weren't originated by the network stack.
> > I simply don't know what is a viable substitute for dev_trans_start()
> > because I don't understand very well what it intends to capture.
>=20
> Looking thru the code I stumbled on the implementation of
> dev_trans_start() - it already takes care of some upper devices.
> Adding DSA handling there would offend my sensibilities slightly
> less, if you want to do that. At least it's not on the fast path.

How are your sensibilities feeling about this change?

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index cc6eabee2830..b844eb0bde7e 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -427,20 +427,43 @@ void __qdisc_run(struct Qdisc *q)
=20
 unsigned long dev_trans_start(struct net_device *dev)
 {
+	struct net_device *lower;
+	struct list_head *iter;
 	unsigned long val, res;
+	bool have_lowers;
 	unsigned int i;
=20
-	if (is_vlan_dev(dev))
-		dev =3D vlan_dev_real_dev(dev);
-	else if (netif_is_macvlan(dev))
-		dev =3D macvlan_dev_real_dev(dev);
+	rcu_read_lock();
+
+	/* Stacked network interfaces usually have NETIF_F_LLTX so
+	 * netdev_start_xmit() -> txq_trans_update() fails to do anything,
+	 * because they don't lock the TX queue. However, layers such as the
+	 * bonding arp monitor may still use dev_trans_start() on slave
+	 * interfaces such as vlan, macvlan, DSA (or potentially stacked
+	 * combinations of the above). In this case, walk the adjacency lists
+	 * all the way down, hoping that the lower-most device won't have
+	 * NETIF_F_LLTX.
+	 */
+	do {
+		have_lowers =3D false;
+
+		netdev_for_each_lower_dev(dev, lower, iter) {
+			have_lowers =3D true;
+			dev =3D lower;
+			break;
+		}
+	} while (have_lowers);
+
 	res =3D READ_ONCE(netdev_get_tx_queue(dev, 0)->trans_start);
+
 	for (i =3D 1; i < dev->num_tx_queues; i++) {
 		val =3D READ_ONCE(netdev_get_tx_queue(dev, i)->trans_start);
 		if (val && time_after(val, res))
 			res =3D val;
 	}
=20
+	rcu_read_unlock();
+
 	return res;
 }
 EXPORT_SYMBOL(dev_trans_start);=
