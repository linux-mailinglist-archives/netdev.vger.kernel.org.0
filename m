Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CD0585002
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 14:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbiG2MQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 08:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiG2MQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 08:16:44 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C7732B92;
        Fri, 29 Jul 2022 05:16:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTVZCaS7S6uKoXi2ISYGF1kF0npw5sIA7vNWUldm4e5X06WoTczcSIb1cTN+KB1KPJGD7/M/XEE7z3ojEXbhnRU2/ZcGur+nskko3EBJm6Uj1mLzxeBCOrxYqr6/XAsp5/Y24YzhIfzH2jxwXIvqRM5/SWtyG0NG/JLnZJrIKdzLyopK2653eW2ibJc1AJkIC8E1O192JQ8TJm6jlYCYaPL3Uh/TluOrbCCLkC0k1Vr3j77bDZTrgUHaCbBfHXCYCTUOUOJ2ilELsoR51Bq+Im75Q84T5K2iKrI3cDUTeFy2dpT+pjXd7hhB5rLFljw/+sZy/a74eZc2c4siN+8eJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c7Is1/P5iSzOHojzpemVU3/+eIyO/rs4A886hWOLR0A=;
 b=CvKOHfc8C10H2BLguebA2KzalB35peOjYRWJLNFVVIktVjPACJXJyqstHzNGqljE5gYqCTIt8rF7QiMIF6W2n01Ob8K8uHeIX5xAl6A5DASAWmt/D3y3a56FNMo0+J8ilM92WSQlG7VAoG9UvyxTQNjDqql3TP1c6ub+jMvxHAlCwIVvRTqqzy0grpNraMtwgLtvJE6fq9KnuthZUHGiKD1cfKPfYkqMKQ6QkpxDeYbeDF65lwA1ltfxPIchY4uC9Vhyz1kWzvbO0frx2VKacOQRDskf4cP2hyMrRJzieuIztH5BzWQCDE0VpOczwfiQFu4KLdpqGqr9Md5jhMhx+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7Is1/P5iSzOHojzpemVU3/+eIyO/rs4A886hWOLR0A=;
 b=kUoESqK5OD7LZ5R5Q+EL/6evmXzb42Ev4baV82OjzN0qPA8zKHxHQ5rDgX2bW219p51fGtii6ZO5snVZ1ueMKpVeFKVdYcZKpQ8GZSPHzxTgfV4krZwJjmkVmwZQ85sNPoFxlG0iKl+oYIUuUlxDPafKhoQ38fnJT3H0jrkwbzE=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by CY4PR12MB1894.namprd12.prod.outlook.com (2603:10b6:903:128::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Fri, 29 Jul
 2022 12:16:39 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4%3]) with mapi id 15.20.5482.012; Fri, 29 Jul 2022
 12:16:39 +0000
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
Thread-Index: AQHYnaLjy2AcewErSEyspw5q+NWPga2NwKqAgAFZDXCAAD4PgIABo9kwgARNpXA=
Date:   Fri, 29 Jul 2022 12:16:39 +0000
Message-ID: <MN0PR12MB59535036A5EA7F7EE488FC56B7999@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1658477520-13551-3-git-send-email-radhey.shyam.pandey@amd.com>
 <Yt15J6fO5j9jxFxp@lunn.ch>
 <MN0PR12MB59537FD82D25E5B6BE17D1B6B7959@MN0PR12MB5953.namprd12.prod.outlook.com>
 <Yt7OqU9LXl4SDqYx@lunn.ch>
 <MN0PR12MB5953571B73BE19D01BCF12D4B7949@MN0PR12MB5953.namprd12.prod.outlook.com>
In-Reply-To: <MN0PR12MB5953571B73BE19D01BCF12D4B7949@MN0PR12MB5953.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36345716-5fb6-4ee8-c462-08da715c3098
x-ms-traffictypediagnostic: CY4PR12MB1894:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7p/9gd9qRYkLNw9y2fufq1yHRr5JxSJWIJ16x8QSanqI1Ywt0l+3W7B7Cj+iq7McJOE5Fc5claWUk6X0FShSHZovZcXHc4Kyd/SmUUPCH9UhCMyJbtpLMT/PsKCaR9EatOhZ29LLCdTC+Ua1DcypWxhqNj7POm/AeyxhlEFb0O/Ag2XCojoaNt3sLhQZ5LQ6f7eBd3z0suATMLYmyiTkJCtN9SS1A6vf7lDAFA4r46jDcx3VGZ4t+M1PDJtdKoV5w287MqRInKMzYs9RynqCpFUugCkSIbzl2jI23MNasIKYg0FmMOAC1Op9nA8MjHozds9NqRkr4LAC9MsjuqiL1uVDa2EtBy2UUGOHCAEeFVxW3/AEOGuplcyFkdrDNs1RurjCk9H24RxYecp/ZpGoRsO7vkhcOQAv+C807Q7Em5MITCkok3hnZCPLRMTLXavXAHyZUx9X/sKPwHF8hYjczcNzCmNtACzHIzGA1bJe3XonuuQPuGc5zreBizDNWltpyDShLDb5Z9FCzacVt5SXUjXB97BV+zF3frGaoNhCo33j2Ftsr2a1WaHOuNEg+MdHsVwbwoj1P1PXNaLmcs1JHvBM8S14Z/El6MHes2ZsnsjDKN2C59MkFBiIzfrhpSJwvPsVfcIO1eiRoe2SF5poWCIL16wsi4AOO0E4w9wwImXLrBc1nQWobqi26cOQVSFZTmuaNJiDEl59cOupJfTwF9IhM7C3EIaFpH48LsDy/cMW7x7+I/gQgOu1i3w0UecvS4uaKp6ZYcuK5HSGtcSpTyM3EFI2iS1rBd6Uf9M7TLOzR696bLtv13KOxQuVD4Dd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(122000001)(86362001)(64756008)(83380400001)(186003)(38100700002)(9686003)(7416002)(6916009)(52536014)(478600001)(5660300002)(55016003)(316002)(76116006)(8936002)(71200400001)(66556008)(4326008)(38070700005)(53546011)(66476007)(26005)(2906002)(54906003)(41300700001)(7696005)(8676002)(66446008)(66946007)(33656002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?noYQZ2AawUd8OHjnSQzTFJohE1EsDWtZDU4aBKXSU36DAoxr3xMUb0b8JOdz?=
 =?us-ascii?Q?PBxNPiFdPCJwfXzQVqEeVnihJTXhXvvpV34IbKgCIfZ/zCfF3WRC1kgYnJ9X?=
 =?us-ascii?Q?8vOI/ciQgYKz9upq+3luDRH6xY1KAtpnvxh4y1/iTvqLZzYXY6rl3MAEM3Ln?=
 =?us-ascii?Q?Sw01IHHH1xJf61MbycVhGfvtEwNiyDOiFYsjW8kFt1BLzp22CNhBn+imcg7k?=
 =?us-ascii?Q?++BOlRHR2De3PRfGAwkLk598PDTR4bkH8w+A09fBa+ESSxc5F1KiqJBnCmlo?=
 =?us-ascii?Q?g1x/2Wm871FK+K5dgaxTQOLAAmE99bLyQTjDbiPLN63gB28mv7+vqaG33Rct?=
 =?us-ascii?Q?w9mUu1hCf3EvkK6L6ZGjBWEjZmzjcrziELCIuFiy/YTz97yiXiN1VlCIA+Ze?=
 =?us-ascii?Q?uVWkf2TrG3Y2lW8zgLrb6kIxh9QqXO5WqLwSRA8EL00xmArWIhYvb1mCYHxC?=
 =?us-ascii?Q?K/oqlzcd6tkwfdP1294rSkDv3htQWuqLhCDZktmg6J42zPL/MouRQ0a5O5si?=
 =?us-ascii?Q?eNEqqZfQzieWoIXRmiftBSdJlT1eVQ1XQJmJuQwKngP6HlW8Ftn/xo0dgXKo?=
 =?us-ascii?Q?Q4MyP0UgGbekl0mP33ijm8CpPMnXk0WXtFfF69pZ/OQzVu6kfCni1uH5wDJJ?=
 =?us-ascii?Q?3gnn5vD4KOY/qV2IMgAvekTbt08o0lk3FjZXH0cv2a7lKrhwl5NctsBfj3sU?=
 =?us-ascii?Q?Arcc7gSSburGmwhGWlgY1gNUvZu8Qfl1+ObrTN7l4vfsOvKrKTqDVmN1sNFZ?=
 =?us-ascii?Q?cNK9Bw7ZPz9JGp2ec3FckxGuxIlugtV13aXdQjizmE+lqDcECrpiPHfbM2Z9?=
 =?us-ascii?Q?VbkF/gM4UbUn6zDvMCihEJFohhYYmaAU1ISoxJ7A9lEAmGtDS+r7dtUQ1jSP?=
 =?us-ascii?Q?WP4tNJ8fb2/JAHv+v4jkOX+DEXYra5W6y3zoxblhu8IGyhlORIT5XhgI8RSo?=
 =?us-ascii?Q?sVA72YgTJGQI84/JOAoYDhD3kzELo1RbNHIQ/vdV2RzsCvq+5MxVtsp5fhme?=
 =?us-ascii?Q?xSYtKmD9VMeYDUyLtzFxtzRPw6FJFN/1SdcIzsHMMmrPVDnWjqn7l4fzCG/r?=
 =?us-ascii?Q?sxltXASQ+yMNdnYFnGBGU8jXDSz4U+nnagfgho/88rZRHywzTwG6XinSqEkY?=
 =?us-ascii?Q?V6osqVBhmUkZsF5QOrdGgABHJZNFS1E4A4tyl07Yynz9ZiPjz5MtK4gwq0wE?=
 =?us-ascii?Q?XuOgCAwZopGfs1jScm683Iq10NEH5piUut0GbT1s5LA10MnkiynnNit3vpi2?=
 =?us-ascii?Q?6jnaDLn+DzsugN/X4UnIumO27F552TzfRmV1aVEmfpcCI6WXgqmIl9UFCMcg?=
 =?us-ascii?Q?NYx9mXUj2zTnT4AClNmfTW+kRXdhLMcQNyGF+E79Iifcu3IVOWYdbia0JzsG?=
 =?us-ascii?Q?R5gXX2TsOqAWRn3pS/mp33rttoDoyBk1DDGSPTVzth2Az1TDqHuABLGlbmwK?=
 =?us-ascii?Q?WJjtnmiSbjY3KF3Hhq/xravPPryNbwG4gIF1EJf4/NSriM66ksE2VK4/sh2D?=
 =?us-ascii?Q?OkCAEQffcxddsHqiT9RVzg7XzFzw4pZKZUyFlHRA8ahkcYDpM5wnGnR20Ipo?=
 =?us-ascii?Q?s4C0qXraCrMyJv7M8NU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36345716-5fb6-4ee8-c462-08da715c3098
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 12:16:39.2438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HrpajDpX8TmSL8AojHdTT0HHNNzZtSXxk6pZVNQ39Mepdm316DJKUXvEax1XVBFO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1894
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
> From: Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> Sent: Wednesday, July 27, 2022 12:18 AM
> To: Andrew Lunn <andrew@lunn.ch>
> Cc: michal.simek@xilinx.com; nicolas.ferre@microchip.com;
> claudiu.beznea@microchip.com; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> gregkh@linuxfoundation.org; ronak.jain@xilinx.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; git@xilinx.com; git (AMD-Xilinx) <git@amd.com>
> Subject: RE: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
> configuration support
>=20
>=20
>=20
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Monday, July 25, 2022 10:41 PM
> > To: Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> > Cc: michal.simek@xilinx.com; nicolas.ferre@microchip.com;
> > claudiu.beznea@microchip.com; davem@davemloft.net;
> > edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> > gregkh@linuxfoundation.org; ronak.jain@xilinx.com; linux-arm-
> > kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> > netdev@vger.kernel.org; git@xilinx.com; git (AMD-Xilinx) <git@amd.com>
> > Subject: Re: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
> > configuration support
> >
> > On Mon, Jul 25, 2022 at 02:34:51PM +0000, Pandey, Radhey Shyam wrote:
> > > > -----Original Message-----
> > > > From: Andrew Lunn <andrew@lunn.ch>
> > > > Sent: Sunday, July 24, 2022 10:24 PM
> > > > To: Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> > > > Cc: michal.simek@xilinx.com; nicolas.ferre@microchip.com;
> > > > claudiu.beznea@microchip.com; davem@davemloft.net;
> > > > edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> > > > gregkh@linuxfoundation.org; ronak.jain@xilinx.com; linux-arm-
> > > > kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> > > > netdev@vger.kernel.org; git@xilinx.com; git (AMD-Xilinx)
> > > > <git@amd.com>
> > > > Subject: Re: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII
> > > > dynamic configuration support
> > > >
> > > > > +		ret =3D of_property_read_u32_array(pdev-
> >dev.of_node,
> > > > "power-domains",
> > > > > +						 pm_info,
> > > > ARRAY_SIZE(pm_info));
> > > > > +		if (ret < 0) {
> > > > > +			dev_err(&pdev->dev, "Failed to read power
> > > > management information\n");
> > > > > +			return ret;
> > > > > +		}
> > > > > +		ret =3D zynqmp_pm_set_gem_config(pm_info[1],
> > > > GEM_CONFIG_FIXED, 0);
> > > > > +		if (ret < 0)
> > > > > +			return ret;
> > > > > +
> > > >
> > > > Documentation/devicetree/bindings/net/cdns,macb.yaml says:
> > > >
> > > >   power-domains:
> > > >     maxItems: 1
> > > >
> > > > Yet you are using pm_info[1]?
> > >
> > > >From power-domain description - It's a phandle and PM domain
> > > specifier as defined by bindings of the power controller specified
> > > by phandle.
> > >
> > > I assume the numbers of cells is specified by "#power-domain-cells":
> > > Power-domain-cell is set to 1 in this case.
> > >
> > > arch/arm64/boot/dts/xilinx/zynqmp.dtsi
> > > #power-domain-cells =3D <1>;
> > > power-domains =3D <&zynqmp_firmware PD_ETH_0>;
> > >
> > > Please let me know your thoughts.
> >
> > Ah, so you ignore the phandle value, and just use the PD_ETH_0?
> >
> > How robust is this? What if somebody specified a different power domain=
?
>=20
> Some background - init_reset_optional() fn is implemented for three
> platforms i.e., zynqmp, versal, MPFS.
>=20
> zynqmp_pm_set_gem_config API expect first argument as GEM node id so,
> power-domain DT property is passed to get node ID.
>=20
> However, power-domain property is read only if underlying firmware
> supports configuration of GEM secure space. It's only true for zynqmp SGM=
II
> case and for zynqmp power domain is fixed.
> In addition to it there is an error handling in power-domain property par=
sing.
> Hope this answers the question.

Please let me know the implementation looks fine or needs any modification?
