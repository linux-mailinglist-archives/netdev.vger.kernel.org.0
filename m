Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BCC4B3129
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 00:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240958AbiBKXO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 18:14:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBKXO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 18:14:28 -0500
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40060.outbound.protection.outlook.com [40.107.4.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CD0D62
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 15:14:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfS7xSqm5HyU1YDpiqT4jQUEfS6ncswCSmuq7ITTS3n3eOC1cnc29lk6QoKpdoxFk0AdKmsKEc8eZc+r1AXsQUocMwM7F1UOPgeE+xCI2N1mPFIP0CFw00bafH8VVuBdzuTBxQmK0hAUA/550i/DGdZWgomru/Xhj2uS9LuF7ZvW4Ty5fpveD7Wk34Vn4cAcgPLFzJBaKdjpDdqXiMQArkDDrKXWS09dqYvhFppCGE0SdGYBBcG3cIKhc50TEIn58k2lwyF/DYPon0VRSPBsCRtYUlCCXDJj7ZmsLa4xgVTbBpGBGQ/w/vpflliVZe/H5pTcNPCCfKZnCZwET6zmHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=naI3vySKOzM5zPXbdC9PkIEbzGB409p1cWea6yFGd2k=;
 b=OcBgW3oN7TiWG72mESnFfhLU71qsRhc6hyvaZy3tu2oepJag2l3sHlNP27kyfCZOG3F2Tah9M3PWckoJIOoi5+TwVlQBL64/4JOrsuMm1CTIThCqVRcF/t8M2VyOjOjh18JGJ7uVMy2y1JZdap6iyFX9L1a+kCPyYPdqMvQlJwW5+KmaQRUv/axTP9znWb6fi2mSquzgo0vC1ULEBScfVHLXPndFUaERB+qeOXzwLj8tGif16AXGK9tHaGBZGHAWRsOpGMOpDXmhyFFMKFVvK34IHyvgR2muI3mSqoUDUKWVb6EtGiXoVS1gGZFNdNYa3iqQ7I8b+9nD2yOg3Q0kxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=naI3vySKOzM5zPXbdC9PkIEbzGB409p1cWea6yFGd2k=;
 b=EtpKT3MDjOOQdpBexxLJWnoicmakrjf2YEWPi4PR87L0ec2meMsvzb2vjgHs2LJq09tPENjaSUQbOst81P1Yu7rtB1fh5x1s5/7CL9mhMVVf+W/NgIHkdwBHHvxCqD/Ei0IIvSaJIP7Pega8WTtxSaAd4ww3kv10e1pwnhpMQsw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4544.eurprd04.prod.outlook.com (2603:10a6:803:6f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 11 Feb
 2022 23:14:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 11 Feb 2022
 23:14:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Jiri Pirko <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v2 net-next 11/12] net: dsa: support FDB events on
 offloaded LAG interfaces
Thread-Topic: [PATCH v2 net-next 11/12] net: dsa: support FDB events on
 offloaded LAG interfaces
Thread-Index: AQHYHn0QHdyaINedZUeP2/pMfH7WM6yO+ksAgAAC7oA=
Date:   Fri, 11 Feb 2022 23:14:22 +0000
Message-ID: <20220211231421.erqojnturtnmtfvo@skbuf>
References: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
 <20220210125201.2859463-12-vladimir.oltean@nxp.com>
 <20220211150352.548530ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220211150352.548530ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6435857-0db3-4d85-3bdc-08d9edb43d98
x-ms-traffictypediagnostic: VI1PR04MB4544:EE_
x-microsoft-antispam-prvs: <VI1PR04MB45447242A94519C9BDB340AFE0309@VI1PR04MB4544.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q5kce2xUxmF9GvWxGdyLi8+0gc7F/l/OC6OZ7BwGqlL9rAgwv6PzQIDc9M7qhdMXxSdG7e4laJtxiKc4rVMrgeU3hXabLHYMn3roCRAPlBgrRTpEG19Zv2fiBSwiymX/b4pIMRihWZGJo3TlAZiCF8v92y6tPvUrImv/jfbP5DN2rC/prhnv1VZkmK5G4nwC8fFOqWJa4oOlC4C05tapk5a9K/rK2iAA1mjlM+14qDxgE6OENaVrXc6CgWfcOnwYbh78ts5tngnlmc1I8yWiq+R/MYiyDA+sU3DMMkFgRa4Ili5IiIW0eq9o+LU+WgqIWFSji3IYQurH4LTM3qmTBHr7//PNyNbjhiG0jTi+Pb7Tvvlb6wNzimy/zKGyUXkW2ZdOL2Bir+IajFOg83o9x7OHvsQyGhS7sgjeZlrwjS41AFPgKFqZAgEQmLMEHqboJhUvOjOSCr8oDHAwiAcjbffHV2h65ygSHmzGRydbBVp0dNMO02KO3KyYIJOFq5hIUlUUaw4GzBYw5az9uAAIv0b8ItF2FTVjA9Jarjche7kPru2PcdDQSP3nhw6TDgMucFGx+hgB3rw6BdZIxLFNQpLn7UqWakkbg9Q4notLralynBntrLEU2zCpLtkyoUDEmOPSuauuM3gfKr+3TnliHayj3z29Js+Q4kW7SE0bH2NMM3sKZP5F40B15uzg1IH4Lomu1WmbsHnmeqW+I1Io2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(7416002)(83380400001)(8936002)(6916009)(66946007)(54906003)(316002)(64756008)(4326008)(66476007)(66446008)(8676002)(33716001)(76116006)(26005)(1076003)(86362001)(5660300002)(186003)(6512007)(66556008)(3716004)(2906002)(38100700002)(9686003)(44832011)(508600001)(6486002)(6506007)(71200400001)(38070700005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2W5nuiaypgIkAVcHyWs+YpB9Qq6CgwZk+2LBL7Yqzy3D6e7v1EN9gFG4FQP9?=
 =?us-ascii?Q?7er5mtFQFbfa5jrPjQNxyYvOdbfnb3FSZ0za54Rk1HEnG5BJiBULKZ2ZckQR?=
 =?us-ascii?Q?tSyux+6Rv1uA+M6nyxw0aWV5Kwc8AX2GHGZGDf/ehaaI8wLRZxpm4BG2cB5T?=
 =?us-ascii?Q?DAv6BoJPmuY47trrr78bmKJexO+yni1v4w/+5+nd3VN/snM39IVtd7gGZ2m7?=
 =?us-ascii?Q?kJALsYcxFqWWRg7bunWegPUSt7yErxhtoiriPyWBY7SbVV203/mdDwWHke6E?=
 =?us-ascii?Q?oekcjy4OGbHBDlwkDm0eI6eaXDc32Ss9tH/Mlz5JMBuA2kYE9xoBISTV3V4Q?=
 =?us-ascii?Q?1gVdJAVtIgUjX0UeJ6dBDZjYjfYm8s8bI53Lk1flukoleHVNXxEv5XkgCNp2?=
 =?us-ascii?Q?PWdP9QFkdtwrFz/7VBJg3FJNida4UlZ/S4Z2xJDT7MC86SjZ6MvS3AtqCn3R?=
 =?us-ascii?Q?/PCDRgVD/OjEIxGbCqFMZuuOorZiLwcJvH7hY8KH5qraYSrsQpL0SepK6oZS?=
 =?us-ascii?Q?r2MDjgz3Dkwp8Fa51iuZYFDi/NjVNx/w1XHW1dperTmL/jEt+U/8WPA4PxER?=
 =?us-ascii?Q?o/fH+WM1T+vQsPPQrmhvPOM/YIAaV3hd1m+GNdFuL6adG7Iv4hu0yDRy5GR7?=
 =?us-ascii?Q?k39/2Hz0LPgsEGZxDcNQf2fny+opqb7Vy1DAyK6G/Kk4GiC6ts1A6TAm2s6i?=
 =?us-ascii?Q?pPgzTRGfN2ckLHkLBW0AhwMws/1BMJ+ATdxT0JJbA1C6T8rTozLuBme4tPKC?=
 =?us-ascii?Q?3Hh9QXMAFaK5cLknZKV+Haz8vjGwZqXtB4IFeDK1p4kU+rs3DDxcmHFMtrmg?=
 =?us-ascii?Q?6sonU7q3d6gCUZXRtbGhqKDrHq1LxsyCXsxPr9Mt2ukH6jG/wu4TkztyDnx3?=
 =?us-ascii?Q?5qg7LhWwpYrMxFpnCZigs98OPdM362bBnSJC0/IgYViwnrYHZE1vzS6WOOdq?=
 =?us-ascii?Q?VZLanB8nrermT8Q7d/kGkmi+kIoAgxIFlbbp6U3y2ntfsB5aOtfH2Ga1TucC?=
 =?us-ascii?Q?thhwvGODV6aevkT3xH5/QwUHZwhltCXpJhmBeh5lX8RLDYGs57AiikQT5wOc?=
 =?us-ascii?Q?c6k+653ecvRM68wDiLx0Iu77G9RzBZt0gN3pIlDTQaaLbpee0obegNSd2aJH?=
 =?us-ascii?Q?pZxcdQ1UCIheHMkZoI0xALSf8hoAOZ0LVbarcfm7KA96m9+lB6e54tcv+RLF?=
 =?us-ascii?Q?wUmQd59PcT5LWPJ/X8FEoKssowrOhDu7dJCe9BVqJkSlwP45nh5dfWzAe38s?=
 =?us-ascii?Q?4ak/cwkQVHnZ1WnlQNu/hCMTOd/dgTS5/DWDPVmeoaR9s5xvPcMWIHxjKqN4?=
 =?us-ascii?Q?LHdVka6GHy5bg/3JumtCHrPfLSL++iBq3hR6gITejhNE9gt2MuIi9/28TekC?=
 =?us-ascii?Q?YsjrYW8KZn0sPCZIiv5PGXkJ9OrdqbSDPdDpzXDkoCWdwIHDW6Ozm2I1AJ15?=
 =?us-ascii?Q?awiXRwqJKmQhGNI/uebe/7iEqdvbe10PW1KWwCcaI6AKVCY3lRQf3c2kNvSn?=
 =?us-ascii?Q?mVBBvLo1OBmlUk+cnpt7HtZQFUJu0Qvy6oHn4xC4FR2kETz8B4zw43hHpLrW?=
 =?us-ascii?Q?aeg3D6spNarOpn/uSFSdG9UD258CSau+JgLPUdboGvISFTHpw0ayRtuCWOX2?=
 =?us-ascii?Q?T6+URc41MklB6+L9Ay8Amb4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2561C0E4EC7A324BBB333B5FD4D7C761@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6435857-0db3-4d85-3bdc-08d9edb43d98
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 23:14:22.9794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SNWeDBqop25m2I3quOeO4ngnFyGmFfVPnwDVGTB0JgFS+TeWSITrTcYWanhrRrx+ABIL/5URWI9rSicHcb2QHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4544
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 03:03:52PM -0800, Jakub Kicinski wrote:
> On Thu, 10 Feb 2022 14:52:00 +0200 Vladimir Oltean wrote:
> > +static int
> > +dsa_lag_fdb_event(struct net_device *lag_dev, struct net_device *orig_=
dev,
> > +		  unsigned long event, const void *ctx,
> > +		  const struct switchdev_notifier_fdb_info *fdb_info)
> > +{
> > +	struct dsa_switchdev_event_work *switchdev_work;
> > +	bool host_addr =3D fdb_info->is_local;
> > +	struct net_device *slave;
> > +	struct dsa_switch *ds;
> > +	struct dsa_port *dp;
> > +
> > +	/* Skip dynamic FDB entries, since the physical ports beneath the LAG
> > +	 * should have learned it too.
> > +	 */
> > +	if (netif_is_lag_master(orig_dev) &&
> > +	    switchdev_fdb_is_dynamically_learned(fdb_info))
> > +		return 0;
> > +
> > +	/* FDB entries learned by the software bridge should be installed as
> > +	 * host addresses only if the driver requests assisted learning.
> > +	 */
> > +	if (switchdev_fdb_is_dynamically_learned(fdb_info) &&
> > +	    !ds->assisted_learning_on_cpu_port)
> > +		return 0;
> > +
> > +	/* Get a handle to any DSA interface beneath the LAG */
> > +	slave =3D switchdev_lower_dev_find(lag_dev, dsa_slave_dev_check,
> > +					 dsa_foreign_dev_check);
> > +	dp =3D dsa_slave_to_port(slave);
> > +	ds =3D dp->ds;
>=20
> clang says:
>=20
> net/dsa/slave.c:2650:7: warning: variable 'ds' is uninitialized when used=
 here [-Wuninitialized]
>            !ds->assisted_learning_on_cpu_port)
>             ^~
>=20
> It also suggests:
>=20
> net/dsa/slave.c:2636:23: note: initialize the variable 'ds' to silence th=
is warning
>        struct dsa_switch *ds;
>                             ^
>                              =3D NULL
>=20
> but that's perhaps for comedic purposes.

Yes, that's "how not to fix a bug".

In this case the second "if" condition needs to be moved past the "ds =3D .=
.."
assignment.

The reason why I didn't get a dereference of an invalid pointer during
my testing is that I didn't test bridging between a DSA-offloaded LAG
and a foreign (non-DSA) interface - that's the kind of dynamic FDB entry
that check is for.

I saw that the patches aren't active in patchwork anymore and I have
this already fixed, but I'd wait for some feedback until I resend.
Maybe I'll resend on Monday or so.=
