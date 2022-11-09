Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488A662241F
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 07:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiKIGvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 01:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiKIGvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 01:51:31 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2133.outbound.protection.outlook.com [40.107.243.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBA817423
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 22:51:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UrBrENIosPja88K9kr9u6m7RGspsq1S4/Z16Obap06qGVFnHGpTpxOe4PRBl5NDlg9gHzHryZ3aGJj0jRrE7M6YU0W7UIeYlmYL/yE4FA1tberdf209483/syLt4bafxXv3YMtZcJRoL2ibbWwriawaVH4okgHfMGFEVS9nRB49Zprnpi8Nkt69MqL2ZUihufxDHEGGUTgY1DeCO3bgqjSSAvnxn6kU668Awa2Y1u0B+Hfjxrg5j7uVdiqz1Tjn+frTGmdVHKY5WFRsYVuz6ru+4WenNllbg0Gr7CLjIKnY4VeDWvav85CtDdu9KRTxGe72sugeOjsTyNLhu4fGm9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/nAana8x/guuBGCLvnkgA4RXYJ2WDRYszjuJ6sA+/U=;
 b=Qqk82AceFsRtO0RNlupewuYgdPfG+45dgCihdkUv84oY0JkVVV3CfR2o+3QViyDd0s1NG9MOuBX1RGt/LJA13DCdoyQtcafwDVDTVAWZiZsxFiWbkmLZNshHOSHvYxgOvnuKw0YoDjokcCWtxR+U11+ULPYJC7LK3imEcEayj9jOBXo8e5P9BvcUALzyToIaHUCZO7X+vm1wM0KNy10QsGZf8dvWDLIdb9t/ZLcW2SlU71FCTd6m4XDZZWIVMkatN6NDN3XBtW1o9jUV8SyVflChbAxU8OB1qx8vT5JjpQFSB4EB+4Shg1QBfKnEZYl0km8n+nM+Z3Qw0Pj8lAxToA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/nAana8x/guuBGCLvnkgA4RXYJ2WDRYszjuJ6sA+/U=;
 b=gufPhAuPyzz/LSStzsQwl829yOo7unQ1Xm48YsD1g+Np4rXArhh/9EE56gzTvho78bAiH0wmno8g6ZQNAeExP9Uga2de4Kz3m68A6cHDJEPoDG9IFH8OWKZFzc5U3GLjxwDGMot0eLPiP2ORL7uisBUe7DahtGnT6THDE91mgO4=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by PH0PR13MB5793.namprd13.prod.outlook.com (2603:10b6:510:11c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.17; Wed, 9 Nov
 2022 06:51:25 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%9]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 06:51:25 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Chengtian Liu <chengtian.liu@corigine.com>,
        HuanHuan Wang <huanhuan.wang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Thread-Topic: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Thread-Index: AQHY7eGMPasXy6hiXkqW0Y9zNHZbuK4zBIsAgAA10pCAADY4gIAA1XVggAEiC4CAAMbS0A==
Date:   Wed, 9 Nov 2022 06:51:25 +0000
Message-ID: <DM6PR13MB3705AB165EB57281A6447076FC3E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221101110248.423966-4-simon.horman@corigine.com> <Y2iiNMxr3IeDgIaA@unreal>
 <DM6PR13MB3705DADE119F1895CA27EF9DFC3C9@DM6PR13MB3705.namprd13.prod.outlook.com>
 <Y2j81dBpMXrNqPER@unreal>
 <DM6PR13MB3705D1657D48FD6C31753E04FC3F9@DM6PR13MB3705.namprd13.prod.outlook.com>
 <Y2qjM0fWLJffS/BB@unreal>
In-Reply-To: <Y2qjM0fWLJffS/BB@unreal>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|PH0PR13MB5793:EE_
x-ms-office365-filtering-correlation-id: 6baf69af-9345-4695-466a-08dac21ed20e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HKmt9TtawUA2zlQmRxeOr6lYhq2Kf0YD+bvE8/5I7TRNt1O98S4FE1GwvbTQaVPVB8FlubAszG/aCxuwBZKQvPh8J2YZjQ1MG6t2yO2tr/evDgpfG+9UniG4L8R/3QfgCnlyKLxH7LOcygbARw3hkTLXMTa+JtOLoTKIfbWjxKn43ATejiLMhNG8fXjFDm2P+1PRt/ZkBCVFsfNO1zPFP958Gp7gKg+Dz9h+Xxi9HgWbqJFzQXrsdrKj95XL/EvZXC+vLjOhoEXh8r/jT10TGLgUXIpuPehNBSzS9CizCPiVTxO6tbdjaXkdg2rDOdOzQQlhOAVWTW/9bNW7D0Iexqx8YYPd0nr0W9bZIPxEOGnyhGQf9gd1BbF6dt8hEsLvZJM2ygEXfjBt0lJyW1q6bM/CmHpHudtIyBNrEI2DKFPlrHjUNqE3n04tR4SpJoqfLTtD04AY9hBhIzrQqnaJOic8dhUU9UhcW2yMc4gPg0iiE2gO5VEexL+1EZF+qMOUjfGm7IS9o+MJgurqfqXrn+agisvX958WAxPVTNBe/Dx7t+i2js8lWnUnULydOHYR4LUXAIKwJivQ72sv0jei4LBv+UOjxeWbJ3R7dpnlDMRQHXdadV/d5+/fLaRj8Dcjx+xZbOyOCA9OVNsI5ylb4amz/3SVlDFkaDg6o31WXxcaHPOqp39Sd988uMdK8JRHIS35n6MJK7nR4SZ6Z/CZOaSlyscf1Quv5oxrOGAv6YfIDIE5y/E2B9AKyqOa9AXmyadfLg7YsghuUnwrSsm+ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39830400003)(376002)(366004)(396003)(346002)(451199015)(66946007)(478600001)(71200400001)(6506007)(122000001)(33656002)(38100700002)(186003)(66446008)(107886003)(2906002)(38070700005)(44832011)(6916009)(9686003)(54906003)(55016003)(52536014)(8936002)(41300700001)(5660300002)(86362001)(8676002)(7696005)(66556008)(66476007)(26005)(316002)(4326008)(76116006)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JvRR/uoAQW3AmUhOypoiOnsLwExHEVZ9rZvw08KCse58Loov9XD5Mx4dNt4l?=
 =?us-ascii?Q?7omV4wRBnhW76kksTMxTOZE7szH98c5lC0CuAdD/p4MKh9KA0NlBEpTkn0J4?=
 =?us-ascii?Q?X+qYzJs9HpvtQdQPogX9YlHIuGNmLFnYoKfOCxIJzzZ6chD8lqMNaO4xII8G?=
 =?us-ascii?Q?f/k3T+id+e9EtBYHVpjtLCDZpfIpFMYX+XbwPC1Hkj+sMDX0tGSigmotiRr1?=
 =?us-ascii?Q?TvwYffZ7a8R2cfW1ItFnlmnoYRHjia96wkBNB4jUjJ9AkeL1+YsyW3s7XjEi?=
 =?us-ascii?Q?ezEW3mUrtdU8J+YCyS/29v+yc02tSqIzWiegHb66Q8bvmCuAuFSQWlvbGGP/?=
 =?us-ascii?Q?jHmJrJDmdl7g8O0lmSs3kPGhhRkiKRPJpl5cOUBjN8RzQuT7LkdkhGCHwq0W?=
 =?us-ascii?Q?Ok5idbzG4Pg0yLE32+nF4PiyX0MeTKVctrhTVochk06Wu8BudqR/Yucbon3X?=
 =?us-ascii?Q?gdS90HE8nlUe1G/hURWsjin3FEECs7OS7trnpTdgG03bh6kfneUMjUDYPqQs?=
 =?us-ascii?Q?mGmmMbalyuFIXSVxe4ANRpFoE+BSMNCRGi2dUlhKiLAvCKM8tppzxChdO23z?=
 =?us-ascii?Q?b6vJOah4iinBLQmkOvYP4f+6Z1Z1c68mo0sAnwDURKIGe1mIBrXkKqguSXDG?=
 =?us-ascii?Q?ol7XB6TW+uTMu7IwIR3PSlseHL7Cs8S90RUjqpAkNz4OIFLEkX7YTn7JTU/g?=
 =?us-ascii?Q?FZF/Q0G1Ie9FLi5+yzRBGvb0c6tmnrq+hV49NT+htSnkN+4XKci6kgtq/pb+?=
 =?us-ascii?Q?XO5SPI0KnAyfbfJ9Cz11BEk5LG4zz4Ff509QZEreUnDOcyEOPJIA6bNVx21m?=
 =?us-ascii?Q?NQdi6Udn+XLiEnDmaUW/rAdKNetwLvP/9L0DNSRqgLrqIjkDFyOSj0FuA2kR?=
 =?us-ascii?Q?0pCHqbFA1XfyVHYEDkpi1bO6AjK2BEkIlGy+lJ08Yqa6MTYNzQzMPmz8qZS6?=
 =?us-ascii?Q?7zrL+JN6MToHa4lqQhylK7lEZkCjixnmsYr1c3G95+bTFX18kpvUwHlZ20IB?=
 =?us-ascii?Q?C9AJQA2bRV8dVKtplQ+zUOSrdfcRQqIuIhyqJDP5ZjU6AWrwxlo8lY4C+tIq?=
 =?us-ascii?Q?8dFwxh//orJ7drmIise6K0oWl29pyqa9XAMXAD5sbK727COv/hWYoI0YeS3l?=
 =?us-ascii?Q?u0ccui8Cp214NBCCojWIMJfoNa3RyhkIQUI5l+95/HBvy2XrPCaW300qXAlt?=
 =?us-ascii?Q?cvaRSFYsF1mwDlRt9H/4BhBe8sf8UJcp+87B09y0bvLYb0goo/yttxfYVTu3?=
 =?us-ascii?Q?us8DRewHuKxB8ZS24N2QAk/gFHqQAu068TCf0w9PAPmTsn10vZviF7ZFdTZq?=
 =?us-ascii?Q?1v8/Aa9opP6BxWNTZG9WSKubSstNg6xwQugveiujtcLerXxvtVsh0d43d02H?=
 =?us-ascii?Q?a02ISI8liM2b5Ma2NgepZHPMB+e2NrK9hE1melAnQ8E6qGSTRD3cSwmy/E0b?=
 =?us-ascii?Q?255OfW+7hDEpl7zmwk3mwVlkmooCO/Lkr5A99OQQGNQ610Ixys2x9qpSr59B?=
 =?us-ascii?Q?FwkCfxyPNEMFjApAn6lrrvZC+8uprcxvh3T1kBbmivz48PQIkonKuZTW4vDa?=
 =?us-ascii?Q?/9jZVWprbvf8R6nIPjob+JVaJ0RAPa+vezyPUkb4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6baf69af-9345-4695-466a-08dac21ed20e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 06:51:25.4679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: afnZREQKIO/0ck9BPO7cVkoDeJ/PrKtaFegV8Eo1/R16pLqJhpjEWnMPjAnWu59Qv9zfkMsjeyWwZ1xa6Mr+GiS/pA4AIoYfZv4O1GADjC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5793
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Nov 2022 20:42:59 +0200, Leon Romanovsky wrote:
> On Tue, Nov 08, 2022 at 01:28:20AM +0000, Yinjun Zhang wrote:
> > On Mon, 7 Nov 2022 14:40:53 +0200, Leon Romanovsky wrote:
> > > On Mon, Nov 07, 2022 at 09:46:46AM +0000, Yinjun Zhang wrote:
> > > > On Mon, 7 Nov 2022 08:14:12 +0200, Leon Romanovsky wrote:
> > > > <...>
> > > > > > +
> > > > > > +	/* General */
> > > > > > +	switch (x->props.mode) {
> > > > > > +	case XFRM_MODE_TUNNEL:
> > > > > > +		cfg->ctrl_word.mode =3D NFP_IPSEC_PROTMODE_TUNNEL;
> > > > > > +		break;
> > > > > > +	case XFRM_MODE_TRANSPORT:
> > > > > > +		cfg->ctrl_word.mode =3D NFP_IPSEC_PROTMODE_TRANSPORT;
> > > > > > +		break;
> > > > >
> > > > > Why is it important for IPsec crypto? The HW logic must be the sa=
me for
> > > > > all modes. There are no differences between transport and tunnel.
> > > >
> > > > As I mentioned above, it's differentiated in HW to support more fea=
tures.
> > >
> > > You are adding crypto offload, so please don't try to sneak "more" fe=
atures.
> > >
> >
> > No sneaking, just have to conform to the design of HW, so that things a=
re not
> > messed up.
>=20
> So what is the answer to my question above "Why is it important for IPsec=
 crypto?"?

It indeed doesn't affect the functionality with crypto-only while no protoc=
ol involved,
just some statistics is related since different modes go into different pat=
hs in HW.=20

>=20
> Thanks
