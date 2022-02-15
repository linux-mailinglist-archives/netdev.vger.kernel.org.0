Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D3B4B68DC
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 11:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbiBOKKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 05:10:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiBOKKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 05:10:30 -0500
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00051.outbound.protection.outlook.com [40.107.0.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D134C8878B
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 02:10:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAJsinQloR84msk8uTONhFIuDRHwKuqvOMVZli9/3m0E4Pg04yw+vA3ujnaJW5B+oY91quSQhCO0pjDpzXYkpRkevufQOnCIqNoghiW0y8nIAEfEV9Mx6/c4ZkuuBeao/0U+0qiEybiHB4ms+cFe7xfUpx1oFSdOsCA+s/XddatJXf1ZLnWepooJxuE7rRxmwzTg2HyOcNplIjrRVSzAVqjun/+AaAHoEvlAU1gQxJMRmdudNQfEpOvY0GsgjZCFmhrwr0ihTnlQgqNJMMo0D0mkRO3Mc6tCpb0aGCjNki33eGzaHXHaxkOrDEISCRMRLaUDN1fz+tYubR4Ji+A7Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jWKRrW59n8yvSAHSkY/zGG3Y+1kej8EkQLp3tfNlfoM=;
 b=Knx97gdkiCnOJ1icsgcIhjrMSdQiQpDp3CpQpHCGeI6IJ+dx9tOy9litxoJHoSK9De67qLUP8O5ZHuJHDcmoCrS4P71TwfrunBI41qVbTXMvXP7WjxAlwOn/HRLCZNHWsw1KTzwFP12usz3BobS1uKbJSFr/G+iBS/99QhyqHPSSa9M6qzjwCdN6u6mI7Yvy+OqTsJoJUc1BXBwTlqTAlpAEYUlNRKMFYqGeSz0wVo3vaUVKkDuWVn255pp+rjHOunP9pTnAU3nB76Iu5pP/09akvSsJa1KGPmZPmTqJmZmboaESRjRIru/Lp2QR7JXVXdIDFZYci+8iX58/N5zkWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWKRrW59n8yvSAHSkY/zGG3Y+1kej8EkQLp3tfNlfoM=;
 b=lrgJwB3P3ogJEGvBXSuCCyZ2MDhtR274N5Zuh9KQzFVcpHHx+59VaZaz06vFXtCm3kG2bcBeQ4A2BlZ0i74YSr8UCjEIoZkr3i5Dzczor0YRGj2EbMakc9/slKmTRDAjZo0Polxcj52fn8EINsXq1AqI9Mn9lC1zJQa82MgxeMk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3309.eurprd04.prod.outlook.com (2603:10a6:802:3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 10:10:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 10:10:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Thread-Topic: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Thread-Index: AQHYIfsSmRmY0oOnV0uNWER612b7d6yUT04AgAAQq4CAAASGgA==
Date:   Tue, 15 Feb 2022 10:10:18 +0000
Message-ID: <20220215101017.iug7kfzzmmov6f7b@skbuf>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
 <20220214233111.1586715-2-vladimir.oltean@nxp.com>
 <bcb8c699-4abc-d458-a694-d975398f1c57@nvidia.com>
 <20220215095405.d2cy6rjd2faj3az2@skbuf>
In-Reply-To: <20220215095405.d2cy6rjd2faj3az2@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6d5ad48-a35a-43ff-4efd-08d9f06b5e43
x-ms-traffictypediagnostic: VI1PR04MB3309:EE_
x-microsoft-antispam-prvs: <VI1PR04MB33099B6CB34C7CBA43396867E0349@VI1PR04MB3309.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: og28ODD9eysnbDpgvGM3nHls/13ijQEfYpMnR4XgosHQTguBT3WJUQ4pSMlZUztAfDIwDrF1w1p0NNhM0/Lg6ceQogBK7KzjVDL13onv+qvCTeEMPtfINbo13k2q3Zk6lxEFYTm7Rov3QjgnXeJ4FzOjlZkl2833V1S9tHxdkxrwFttavSuptmoNMb1YUIZ90QgXAG//ptmw22hL9DtKrBKFSmBfGAwM0gBcDTIB5cCGKM9ZcrEujj8getnxN0uFOI8L1DDMMNqq/1TtEY5DDdf9VOYe+o5p857jeYCVH9VvRhYh0FVTHLDS/ErUKxKW775vE0NpzaJM1zc0aMqZ0GdEMjtMy2Yig8risRu9a2cINiDFWPb7/L6CnKGxcSCdSVvUxlH1e3olBpKvpQEUMYMS3Xuk2ijX5G2ojuvbf1xslhX9LzQPRNvwYwFhY7cihTg1G7MRqD2EghfYX0LBhWIt/nfNoUiFLzuQnlLsSB7JiQUrvj8+FutpOl1DbRJA6pDUzBH4/M2m3jICgKm/RbqYtDptm5w4xtscYGNPPb/L3g3i1n1Qq69fL/8/0V3eDT4UW/B9tl4suygmYDQsyI8V0Zvd0Su8U1JGJdXBVFl5C6frd/AvYUrX8TbHT8qXnN/3rkFa97JTlZ8DD/ICcJnfreYARoHUo/iSvelou808U+/qbhqiBWeymkdK6+GZN2pNIbAOuf0YFFio3EK24w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(7416002)(122000001)(5660300002)(33716001)(6506007)(38070700005)(38100700002)(316002)(54906003)(6916009)(44832011)(6486002)(4326008)(66446008)(1076003)(6512007)(8936002)(66946007)(91956017)(64756008)(508600001)(8676002)(186003)(26005)(9686003)(86362001)(76116006)(2906002)(71200400001)(66556008)(66476007)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Re/gpd4j3aCS2uAKB6rjNTnVxmQzUOw6q1gfzM70zlJV1Pal2L8ZTdHq0rai?=
 =?us-ascii?Q?dc978B6zzEXUYOdRVMAyfb9YNwF9DOxLSxLO8wUpLcMyv6RMUdBT3KQnqm+t?=
 =?us-ascii?Q?WN95Zk8C4wXMG3YxrPpb8nRop9JVVpxU3mXbIAxkUgLQkJCTiKp+V6f7V5Ez?=
 =?us-ascii?Q?ZMqDTtnLQ3kxW06DZziY1nruqyWoQCL3/zInNRFVfs6cpAR/FU6zXQPhT9Nh?=
 =?us-ascii?Q?+ZLvpEzC+LLhiKJPx56yvGOkW4oh+DFcWTou+9FSwnbU3ikDXO2kbgtSOG0S?=
 =?us-ascii?Q?cIPSxP4fyPOW91suBVdNwm+TRk5Xgj/qgmim2ic9qhowCQTS8ynkq9NSLXqj?=
 =?us-ascii?Q?mSW69nOQpyv7QyxPqaG973x3RfXTKUD4gvRBayLWqXC6lxajkwiHfIUy6FmI?=
 =?us-ascii?Q?F0+wE6rKMNaIu8FLS2Rohg6swRtwly+Et3ZLJzwZ4sOkOj9ToPOxJP3hU+1r?=
 =?us-ascii?Q?lc+fPI3TouRGe10czXnnDwo2jLC183T6vtEYlDoDKSSwdm/9PQUR1TW0gJ6z?=
 =?us-ascii?Q?Vql11QJuRIeNUqusRy1I6/D5R1Bf58oP5tkuIhh/VABlJ9n1XcroEU/qahyu?=
 =?us-ascii?Q?YorGVIcHGOw8gsiIz1j997b571AoIAV2vOm+5eTrJlx5uMxMiTS8nltKyOec?=
 =?us-ascii?Q?Aat4JWUbSZ7Mie1hQfyKbwsQBFXpo8GJCd45ixk8HIEdMKhYP63JnCZfCOst?=
 =?us-ascii?Q?5HSa69WzWYOmxy/pf2dZfzpdWEYOB5WBfK/nUsmmqbdrE61B3AClBoxo1xs2?=
 =?us-ascii?Q?I9KLxgsIwAbW/Fws69NdTaXbr+aqB9Q0H1HrymmL7ruO/jldMhMn07rG6Y6G?=
 =?us-ascii?Q?5sGdbxCn8K9oJbS7bZYGibBlEnBJ4iuc4JooVgV/O15Lm8UpMAH5V/nNHDOo?=
 =?us-ascii?Q?th2FlP2+PfpJAf+0jPzk1WErsX0voOlxqnxlCwjIhg5gdUVumRvb7ZuW15Mg?=
 =?us-ascii?Q?Z5beUdjCW0sAmogB1B8cgaDDHxanEZt9Ux5+pip5QJ108GKICO2O2rE8ThC8?=
 =?us-ascii?Q?CrHFmf2CE0i4W0XA5BvQPGdQ+HcFioF56U+OttEiDLAllG1E02dCj71MOhRq?=
 =?us-ascii?Q?tlgsZFGZ7O1vQU+BH/r/ehm1tIcp7/fmqtoCL07GPGCFd2wdyLmRFWLxG12W?=
 =?us-ascii?Q?AHTgql4Tpsjgcumdcrp0vrIcFispr2bq+KpHk/RgRccNAEYlavgpP3gSsPDj?=
 =?us-ascii?Q?Bk7dSiIktpnFwfQdQZMFN0E76krdL3sAKcs/eNFEx4DFfQ4bfC2Ua3gVImID?=
 =?us-ascii?Q?wKnGpROqsvHoMTCJyMsqLZlqliCNQOEXr5H0ZX0vLxgenHDdIUkfVTUAV449?=
 =?us-ascii?Q?pttzKrL9T+kkjcsgBzh87FrYnCvCIFyg8v3KI3JbBzhXuuv5gLfzmFQMHELB?=
 =?us-ascii?Q?W6k9w8tRk7e5KvxqGEvt5tbMTP+wiO3CvYZu87bDaxJRLC34hMeXSrQ1yTI8?=
 =?us-ascii?Q?bBVtJxIw2OP5GtaVWYkjIXXbeZmIUmm/Ce5nHecv9HjdTd/yBA8y7GafFTor?=
 =?us-ascii?Q?Y13z+pdbdN9xdLe0AxyE6RFpjnjzLwOgwenRoh9z3IimrOTvCJlBWDYKPwS3?=
 =?us-ascii?Q?VkOLXBMrY7oP8NpNkfrjX7r03rpOzTr4MNWEdCY/he+qX1kVvwm1D/vpAhES?=
 =?us-ascii?Q?mqtFy3RjroRETYym5ojJvcvu6hqERayFWSnD1qBXpD4q?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A19C24D7E5A9674B974E3E3D58B5EF5C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d5ad48-a35a-43ff-4efd-08d9f06b5e43
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 10:10:18.2022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d9lQU9ZI4UF5jJm9A9WfgPOMHe9/2vs5tv7xAHq81w4jUq0Q2K8yroxMlQwiReLideEh2+fCzjrP8yFHXHFEHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3309
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 11:54:05AM +0200, Vladimir Oltean wrote:
> On Tue, Feb 15, 2022 at 10:54:26AM +0200, Nikolay Aleksandrov wrote:
> > > +/* return true if anything will change as a result of __vlan_add_fla=
gs,
> > > + * false otherwise
> > > + */
> > > +static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16=
 flags)
> > > +{
> > > +	struct net_bridge_vlan_group *vg;
> > > +	u16 old_flags =3D v->flags;
> > > +	bool pvid_changed;
> > > =20
> > > -	return ret || !!(old_flags ^ v->flags);
> > > +	if (br_vlan_is_master(v))
> > > +		vg =3D br_vlan_group(v->br);
> > > +	else
> > > +		vg =3D nbp_vlan_group(v->port);
> > > +
> > > +	if (flags & BRIDGE_VLAN_INFO_PVID)
> > > +		pvid_changed =3D (vg->pvid =3D=3D v->vid);
> > > +	else
> > > +		pvid_changed =3D (vg->pvid !=3D v->vid);
> > > +
> > > +	return pvid_changed || !!(old_flags ^ v->flags);
> > >  }
> >=20
> > These two have to depend on each other, otherwise it's error-prone and
> > surely in the future someone will forget to update both.
> > How about add a "commit" argument to __vlan_add_flags and possibly rena=
me
> > it to __vlan_update_flags, then add 2 small helpers like __vlan_update_=
flags_precommit
> > with commit =3D=3D false and __vlan_update_flags_commit with commit =3D=
=3D true.
> > Or some other naming, the point is to always use the same flow and chec=
ks
> > when updating the flags to make sure people don't forget.
>=20
> You want to squash __vlan_flags_would_change() and __vlan_add_flags()
> into a single function? But "would_change" returns bool, and "add"
> returns void.

Plus, we have call paths that would bypass the "prepare" stage and jump
to commit, and for good reason. Do we want to change those as well, or
what would be the benefit?=
