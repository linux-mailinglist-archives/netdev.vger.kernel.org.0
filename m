Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359615819EE
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 20:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239627AbiGZSsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 14:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239612AbiGZSsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 14:48:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB28333426;
        Tue, 26 Jul 2022 11:48:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNcd5SmdlokHE6G3hUmF8jKMA//o/6i3PzRTvb7I+oIzlXwNtSoOjyKdozAWj7vh3sThg8bqbTD56CxiRTApENy9kOJOh+NV5wPImh8OExL0tNo4VTBNW70BDWAqT25It2UYnq+n2xlC1ugm2z6tOjRwLfsoj38c2kxQ9hvEhyDMokjvlmDUSV5H1ltVn6Xu+c1GgW5BxghkBZwJVOTQoWG4sKuJEynKkDwy5hzXyZTDWr3zi4WXEnAEPb8y8gwpI4mnQeVfQgF2PdTXVsyoA0vGzheqrhyvjnas0m8gZB4kzmUcgBBM8hCQYlP43osEKdpnrL25OA/jTDZlXw0ZeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOUHPpHGp7ZoTZ2onw2eDPF3UeWYs2p8oW3yJFCZpCM=;
 b=WJ4uKHMwPlZ4K4jiK7Hk3QjRLd5SZsW+qzLhpkEkamgLZNbbYbuv7rD3X89liM+GJkOiXoPeW8Qopecive6qaZkfMBwSX+ceBmI32c8Vep4VAlYIuxriqqfc97Vgy6LiOVo2dg1UxH/yRFeG+rLSHqL6DIjrA9CmS5Vn0EmFTjHNJkHcN+Zgq+zAkwewsc4N4P2hXuw+kgseVQ2YRmPuJSScl9fVwj/AAInPkBgdDBYGA0KpU9V9PSiDSTPQeuyjXMsqW+XW8DyPnvgzHiEdNPMSgUtkuIEqBcODPj+lOCqMiIcwJXO9gkm2+yrPozSrlbL7dKAdIeaH27LY3jNoaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOUHPpHGp7ZoTZ2onw2eDPF3UeWYs2p8oW3yJFCZpCM=;
 b=aCI72wKe81kxO+u2xZHaoJajtDhuueGQh7jSTnfujvQsD0p8emTdU4xT4IfOWi6HWv4fwLLP4r4RkM0jjc4CyfVBsy1068EMjZs4MBrA5N6zLyxRHe5MhuT7lyiSGx56+cjKnVG7WK5Mf/ZSIa8poRcjHGx4zqt+qV48bkfiqV8=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by DS7PR12MB5720.namprd12.prod.outlook.com (2603:10b6:8:73::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Tue, 26 Jul
 2022 18:48:08 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4%3]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 18:48:08 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ronak.jain@xilinx.com" <ronak.jain@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "git@xilinx.com" <git@xilinx.com>, "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Topic: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Index: AQHYnaLjy2AcewErSEyspw5q+NWPga2NwKqAgAFZDXCAAD4PgIABo9kw
Date:   Tue, 26 Jul 2022 18:48:08 +0000
Message-ID: <MN0PR12MB5953571B73BE19D01BCF12D4B7949@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1658477520-13551-3-git-send-email-radhey.shyam.pandey@amd.com>
 <Yt15J6fO5j9jxFxp@lunn.ch>
 <MN0PR12MB59537FD82D25E5B6BE17D1B6B7959@MN0PR12MB5953.namprd12.prod.outlook.com>
 <Yt7OqU9LXl4SDqYx@lunn.ch>
In-Reply-To: <Yt7OqU9LXl4SDqYx@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c529e3c4-7364-4bc0-3795-08da6f376210
x-ms-traffictypediagnostic: DS7PR12MB5720:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nJ7UiWmwLbDH2Z8wbA2xRWAvs3OfM+Wm8IVlsvKuOl/Da/WfLfhbK4exD/uOPcT53/f2yhJPXa/nXW4XjLCANOY9ex+8mwV3WOg2mbRWnvXHAVMUFUw/T1mDdyeNGFb2DDQnIkHvTnqc0j+R++lDeUwnKEqObA9bqozUMZZ3a11Mt69sIQ1XoxsMh3tIBKOJmBLHDn3afQVUt6gx36JTTAhO1b+ctVIMymj5Nc9Ccnk+B4Mt6vT6KQmiMU2jkFOV5h+Z2uTQRiHLLHb9M2EO7AdpIm51N2PK20vSvLBoEnlkRvIMj2JMz7TQUjLP59w3bK/gc2h8XwVTYFoiLpNrmiKPk8YdS1DBxRU6RrYWT8KyRt4EPBYX8gQ8o3pvp5v/Cc1/NcqY2mbTPrGjWUMuHyqfUg7skJcZo7yQO8kr6sYPBz2Rsyi7IG0mfTTjwTBw41/utNe1wJbw4SekLsUeNwg11EkwBgjWMvDJfNCVycCgLQNur5lcwCgodDtHRgR+vDLyF4UqHSxNmv3II5y4zV6/NEzpUJafTq1HgBsS1lt4Uav82PgeBOjB21fevVh0uGToNzSD5JP8tkirfw1djTidvE9X3T44LMBehBMkmX+6qKScO+y3DqaAqgkMbSbynsbCXDXolc1LqYVWmRlfb3tj+JR6jLXCQCixupxteLs7/iM2BwgqESBL/yKTjpKrJhv7z6swe92ixIPdSx1/itlqJt1cWC2/Y5+4I5zXy9hp+P9WfnyzhuLqhY5wvLBfvphpiP0tmQZc10bcM5DazGJY87ZWD2pA8YLKsGlqjqCnwteGFbdbrrw73HtABN1a
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(54906003)(122000001)(316002)(6916009)(38070700005)(66446008)(64756008)(38100700002)(8676002)(66946007)(76116006)(66476007)(4326008)(66556008)(55016003)(2906002)(7696005)(9686003)(53546011)(71200400001)(6506007)(86362001)(41300700001)(83380400001)(478600001)(52536014)(33656002)(8936002)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qyj7q1B/lW0DIz9w7sS5/3iK+xJnCnUv+Y4bPz1ugvlko9lVupsRPyN2Yvvp?=
 =?us-ascii?Q?dSa7/dtcvVW8nklZm7TAA6Vi4b5OBCU1z97Xezopx3oAgMmj8NzAoIMegVoa?=
 =?us-ascii?Q?fifftSp6Xz8zUJxCL9hMk7ehz+5jdtUYQ9H8xu33xJ/1VYpXMBA9P7NUdSFz?=
 =?us-ascii?Q?F+yjkzCKEsr5daXXe3FJfYPJnTII5/SSJo0mASNsYyZFAPYfFMBPZgbdsDAg?=
 =?us-ascii?Q?Y6Ij/hsdOQhD69mVy76R8aC+8Jn15F1jnab2JfD7SQe242iUDOGmXhMyF/Xy?=
 =?us-ascii?Q?cANJYcUVfRfkwTV931zJhUjKE/uG4DDOhXdVoNR4Pm1JkWUyv4eaiRrWvcGE?=
 =?us-ascii?Q?9U9ObfjcOilxJzs5SZWZ2gTfw/KdQNXVaasTC9kt5NzWM4anZSPRRcMBjh6V?=
 =?us-ascii?Q?CZAlNduPsc81c5NnW5zBKzg3qzMBL/CZNXpX9Ln/eBxPSvv6ZRkcJilDPaqr?=
 =?us-ascii?Q?iy7aku9LOsNgDnG6Y+RICBsKNb7hCDYX3SGpqgKLWl31CjYiKSMteciuWqZj?=
 =?us-ascii?Q?ZPWvP6h6D5E0BlnIziOddN6q7IlioRy7gU30NBhKWQ11Z4YlEuyjD9FiTTbE?=
 =?us-ascii?Q?A5ObyhkRQRXnZvmehLK8ndZPaFeEUv+U8unolFxli8AxW5e3dDwUzkNdMywg?=
 =?us-ascii?Q?rPFPwIu6F3f/6J1F+e3W86U5CCgNnWRLFzlOfWiJ7E+E7IJls06g5jnZvRn5?=
 =?us-ascii?Q?lnncl6n3o13vAt8UytBaPMyM/33DHEZPx6pzw58mfGcRGSnRFZGvMxgXraXu?=
 =?us-ascii?Q?Epm2HuNd7cBMbl4l7ExwIRfeV+a9AaKGnhgb9ydgfk0xmWepxa1WU+rZGkID?=
 =?us-ascii?Q?PN2IAw50rpvXpkGPg8Cp2sBTVaI3bv1OdIGONxWAo3mDCcUY27RTtV2SiidW?=
 =?us-ascii?Q?LkxfRU/o4bYlrx7tvXIPzBHMYgtyrwFWrmLOAuDBsWt3UNIu3ds+aFxE8OkC?=
 =?us-ascii?Q?3NttX+NQM6hGfo9H2jytcQVpdXk0JWqzBqargf8Vd0TNwlFez+ZJAYxlbtWA?=
 =?us-ascii?Q?ztUxx35bjeLbVhlI8zR5ORDpdg+QCVxSEYt1Z+kb7P4YEnDc6gf3Tj6cCTbq?=
 =?us-ascii?Q?VhKbI5BJfVySkzRzf96uIZpTIdwyp4tKSIBfNHXXj2ozMU8zIFM/Lwe0ByTo?=
 =?us-ascii?Q?MTHqa/rb3CY/77eMDImSZ0ebWr0ltR5oguf/4f6ccgAVc0HkQkTCTS+Xe8px?=
 =?us-ascii?Q?oPTgZOYLLXBl9wbU7puWZmH1ANgBjG3OnM/pylUeA1LVwL8dDbxzNEJdNnu9?=
 =?us-ascii?Q?KkDVF7ShCO1iEEyzEVjhTGKB67cdDA7HFW0FcCbkz1mqot/KQ5ml73HjMiRY?=
 =?us-ascii?Q?jXgxiSGOzOqFyjWAzjFrSMl88o1ZuaNgbyBSfpsZk3qj8LAZ0628OEn+eXTh?=
 =?us-ascii?Q?NbbgtL1QNeA6b2ff7eB5hDMj02NsLzFn7AlNj/sR7/R96rlYLkIrh3618xMh?=
 =?us-ascii?Q?OoqPAIfPKvJoGB4/UZD1RHz+Ik5/SIq0XusvoU/PiOHxzBxGejiSRfras2XA?=
 =?us-ascii?Q?I3KXmg/jckKI9RLWv2sd6yckdDWAZSKE8MuxyEziUfAZsX9PFB6x3Qe4NTds?=
 =?us-ascii?Q?nXp9qZVYWb7VJ7d7/vqeyZ4/6mdQP82r/LFaXouT6DFWwjZG6ShFRbN/Kcxy?=
 =?us-ascii?Q?FMpUytcA9jCNSZRgbXWSJww=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c529e3c4-7364-4bc0-3795-08da6f376210
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 18:48:08.5147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J/K+JP0r6rQ0sVu1lDLWChxD2D7un0ZaORG7gj7sEa/xx59NC3hh/cBnzE3GmwG9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5720
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, July 25, 2022 10:41 PM
> To: Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> Cc: michal.simek@xilinx.com; nicolas.ferre@microchip.com;
> claudiu.beznea@microchip.com; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> gregkh@linuxfoundation.org; ronak.jain@xilinx.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; git@xilinx.com; git (AMD-Xilinx) <git@amd.com>
> Subject: Re: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
> configuration support
>=20
> On Mon, Jul 25, 2022 at 02:34:51PM +0000, Pandey, Radhey Shyam wrote:
> > > -----Original Message-----
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Sent: Sunday, July 24, 2022 10:24 PM
> > > To: Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> > > Cc: michal.simek@xilinx.com; nicolas.ferre@microchip.com;
> > > claudiu.beznea@microchip.com; davem@davemloft.net;
> > > edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> > > gregkh@linuxfoundation.org; ronak.jain@xilinx.com; linux-arm-
> > > kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> > > netdev@vger.kernel.org; git@xilinx.com; git (AMD-Xilinx)
> > > <git@amd.com>
> > > Subject: Re: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII
> > > dynamic configuration support
> > >
> > > > +		ret =3D of_property_read_u32_array(pdev->dev.of_node,
> > > "power-domains",
> > > > +						 pm_info,
> > > ARRAY_SIZE(pm_info));
> > > > +		if (ret < 0) {
> > > > +			dev_err(&pdev->dev, "Failed to read power
> > > management information\n");
> > > > +			return ret;
> > > > +		}
> > > > +		ret =3D zynqmp_pm_set_gem_config(pm_info[1],
> > > GEM_CONFIG_FIXED, 0);
> > > > +		if (ret < 0)
> > > > +			return ret;
> > > > +
> > >
> > > Documentation/devicetree/bindings/net/cdns,macb.yaml says:
> > >
> > >   power-domains:
> > >     maxItems: 1
> > >
> > > Yet you are using pm_info[1]?
> >
> > >From power-domain description - It's a phandle and PM domain
> > specifier as defined by bindings of the power controller specified by
> > phandle.
> >
> > I assume the numbers of cells is specified by "#power-domain-cells":
> > Power-domain-cell is set to 1 in this case.
> >
> > arch/arm64/boot/dts/xilinx/zynqmp.dtsi
> > #power-domain-cells =3D <1>;
> > power-domains =3D <&zynqmp_firmware PD_ETH_0>;
> >
> > Please let me know your thoughts.
>=20
> Ah, so you ignore the phandle value, and just use the PD_ETH_0?
>=20
> How robust is this? What if somebody specified a different power domain?

Some background - init_reset_optional() fn is implemented
for three platforms i.e., zynqmp, versal, MPFS.

zynqmp_pm_set_gem_config API expect first argument as GEM node id
so, power-domain DT property is passed to get node ID.

However, power-domain property is read only if underlying firmware=20
supports configuration of GEM secure space. It's only true for=20
zynqmp SGMII case and for zynqmp power domain is fixed.
In addition to it there is an error handling in power-domain=20
property parsing. Hope this answers the question.

>=20
> 	Andrew
