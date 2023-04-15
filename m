Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A516E31D1
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 16:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjDOOZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 10:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDOOZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 10:25:33 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021018.outbound.protection.outlook.com [52.101.57.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4446249EA;
        Sat, 15 Apr 2023 07:25:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehxGJRya95KyoF9kxYMJjyGL3yOuPIb2Pl7zGHcnI59zhszI+WuAYkK5zz+CezE6wAkgWJE5m08UxWm2egylXKWovJXEMzrnR4uHpbqdUw1Ddm/rcV4LYTo3FqPNjpfJ+Uv7uqR8INMCT1LUaLj+HouDlL19fmNmitQDb21va99/tenO95OopDkAA0zty3NFflk4Xbwvn48qGqZfQwaVrJr10Reu1GYuH4t3zphR4ZEzYmzmC7devfVGLhItZSiTEsm1amSkIAeDOAOvRZDHFuSQmiUIbUFvxLpFXq0JOjpMHF0OcjqyVeL+kemgLG3EnfhmYZmwiSNkiJuhZvOzGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+T6EjHz9bFJeys8VpYPn0Yc5OCPeWQTs/ZIjC5Y3CY=;
 b=es2yQI5jYd2BaviuWtKC4EtG5Fk7z4wAppDnUpU4zFm3bHuEDL7AERy0wDNowmSpRBZsFKbkvXi0ymKGPU9F7V8bImuJ/O/zmd9OFGrO7wNAvsS/kngp/CW9P2De7bzs/w2x01mzQfFOyaTOJyhUG84erLGE28tGCt48upm4W04rlByecIDqj6VV3TFanZpZRxvCnw+ZVIMORcH/q9tAjq0A9YiVfzu0Q/kp7lev5Ch7M7o4luaE6pRRQ7NDVzfsN+tSi1ltQHjY2EEnQRbDC2Qxza9hZ1LDkWrlOTnNkxk4rYeCy0+4eVqmdd2NixeAH9dHr3Tjh2LEw6IZ3ClQUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+T6EjHz9bFJeys8VpYPn0Yc5OCPeWQTs/ZIjC5Y3CY=;
 b=RjgUWjjwqgkU3voWvsRmy5Lv85nhhRQajXAC03Rrq3ILILppFYLDkXCmM/UHTaeTUXlZ43J8ed6GjZvb9fTZa5hI0Aouq2wxLArO51fk34vcCOwUSzKEw5T2xaGyvl/ASUvQtsLftR/JBT02hliL32ClhuaMw8146C1h5Ibe120=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by BL0PR2101MB1348.namprd21.prod.outlook.com (2603:10b6:208:92::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.1; Sat, 15 Apr
 2023 14:25:29 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5d8d:b97a:1064:cc65]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5d8d:b97a:1064:cc65%6]) with mapi id 15.20.6340.001; Sat, 15 Apr 2023
 14:25:29 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V3,net-next, 3/4] net: mana: Enable RX path to handle
 various MTU sizes
Thread-Topic: [PATCH V3,net-next, 3/4] net: mana: Enable RX path to handle
 various MTU sizes
Thread-Index: AQHZbYQwnFQeBoPFWkmXBOV6OTjsn68roqYAgADK5IA=
Date:   Sat, 15 Apr 2023 14:25:29 +0000
Message-ID: <PH7PR21MB3116023068CFA8D600FA5B18CA9E9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
        <1681334163-31084-4-git-send-email-haiyangz@microsoft.com>
 <20230414190608.3c21f44f@kernel.org>
In-Reply-To: <20230414190608.3c21f44f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8e8173a7-fe88-4944-8b5b-dd08e47c614a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-15T14:12:17Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|BL0PR2101MB1348:EE_
x-ms-office365-filtering-correlation-id: e748ac2a-f250-4049-a4c2-08db3dbd4359
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TGG0m9oO0UtU1yoGxSKvHlVhS66Tfetz9j7UnskFIe3rRHMAW3eqBJWsnmcbLAaknr9ITwp7js0BpuU6dBVF1M0+6wIXngh+RiBVWb83+g4OBmbocmXawIiyJT37WeX1jpiRMPKOvU3GmXv8nO8WaL4edamW9QSCYqixvBI5rBIqnJQTH95ZLIAxPtGmW4cc/nW+5k1P2tKQZPR/wDCeF+JP+P3+9mR415610rAqWjLgJoR/s3xnS1+TPTWv+hD5JDDPDY+MbWB0X8i5rTdTLz/VTkSydvlXMiUYB9GDUWmdy5kvXIDX4XsTeLR3+GGX0PUZ+OujODRNgVaC0DRautKpVjBaZ4PfeWm773vwDUWGN0DQyT2PmDa3FlXtfWEC3oF9G113PqlRkT2b5x3EmRSpbDbWQEFeZ5iNoe9+jkOMO0Hoe8IzTulZH2DSg7GIYLr1lJgLKPnnPTjdyaeecanKZhORb38jkCm2WbBBlKFQiXCMYQF+yIebZgK75os9C/1RUN/CvcPZr+bLM9aA3tfpz7wWOv8UPJNvG9yAqsPU26GKDw9tC/NowvyIIDuyvEbsGpVHM898ZgUt5yIQOEyzpPqx2Wf9O+Q6oEhSL46Eb1LAEwB1fAJiidrKumtY9kCaaCg+MFIJfNl5pQRFzuloMrpmOWbHfEL7qA2IiuQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199021)(478600001)(10290500003)(71200400001)(38100700002)(8936002)(8676002)(316002)(786003)(41300700001)(82960400001)(82950400001)(6916009)(4326008)(64756008)(55016003)(66476007)(66446008)(76116006)(66946007)(66556008)(122000001)(54906003)(8990500004)(186003)(2906002)(38070700005)(53546011)(6506007)(26005)(9686003)(86362001)(83380400001)(33656002)(5660300002)(52536014)(7696005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K4PkFqscrBbRda2uB2ftd4NfLBkXBabFd3fc7LeiEKFSVY+PHX31d2ZTNCmj?=
 =?us-ascii?Q?UGZZaYNuqQ96B25KhRQHGKM1bdn5Yo/I8j9fLHZ1O2FsmauPmMvYwEVQoXdi?=
 =?us-ascii?Q?FC4UX4/oWPzxFNj5lvdpAJZpwrqykT6cp6rLtoI17aNsLywMp1RUDAiesiZf?=
 =?us-ascii?Q?GjQ+VtoBTPqzdv9RsOb/+ZB23TFehvmNMc4kvzDRPx+BMJ74IZfAN5HTUb8a?=
 =?us-ascii?Q?4bL0zb5yC0uHf+Oa8WQxCuZBtYPIMwt8DAvK4S+LmbGq0rzgDeJEom/wLx2P?=
 =?us-ascii?Q?wQII/llSo30uGLtQGDa6rqjQ1FlSO4OsWPBGwhqapnM1GZG5l5NmM/xEpEa1?=
 =?us-ascii?Q?I8ji2QiKMGA4/ldP3fXzJt90tGC17Art+5A+aHeE0mfzJvLnY/JMHs2EDa7P?=
 =?us-ascii?Q?UKdORBAlr4Ob5oaT6qIgHaMwU1JsxRFlc5v0OGlS2T4+U5RJb1dGqbfCH4ye?=
 =?us-ascii?Q?NuiQbR5LkcTzXf66d3JVFHjzDuea6AalhOkl4p7OIlJ+5TvZuFQmGTa7XUEu?=
 =?us-ascii?Q?LAgwlct3jrNx6BhYmhhrUJ05lEKs6LiAySNNMVyHW6GdKQFAnVpmVcxIZpuM?=
 =?us-ascii?Q?PXgcYXeY/tUsRKesoVe34idxuxd3ocvKumAEw1b0ewVuRq9dwXAoalNB2+1M?=
 =?us-ascii?Q?wjFqQgUePl3fqKmo+xcjNtb6nlCNOm/PA1jEQ1vWbKwwI8jNMyj8MXBZUn0W?=
 =?us-ascii?Q?EoKspB8SJYQldGuo8SQ5oneLohGdbZ0jG1kXDnUplKYsLrAgZGfdFD+ILgbU?=
 =?us-ascii?Q?bySIhAcaiGONhzy0XSDi2IbVUsyFN7gdmyZdFqw9eShO46XXuvVMzOXhHC8G?=
 =?us-ascii?Q?EOw7TVUyhAm0XJaYtq00XbPk+B0ykz4l7c1mbCFvllYDNwBw33AnUzlpZCs+?=
 =?us-ascii?Q?PJ5zXHBpdGS88uMJBNjA+Jq+sQSZC2stQ/NMvUiE9RuuE5oT7ymbxSkblWda?=
 =?us-ascii?Q?IHobLIum7wjLJOIf/3o/jkB81Occc6OAx9tvqJ77TTwwuJeoVoevDrogf9kx?=
 =?us-ascii?Q?nxrZd7g/O8Bo43KjARlCQ5TA6YiBXRVr53QctdYVEaLAiwgkdGzsxAFaMbyZ?=
 =?us-ascii?Q?cfZvOY3YRbBbda6jcfa7RreBBA23GQIA+qxPPMXt4Y61kbGBeT8lBgsci1AL?=
 =?us-ascii?Q?GqVH/Z5zk8D6Ht3h1CAlx3bfQshVj4VlQ02v/MUY8Exo9ySr7K6+tFOXLxCn?=
 =?us-ascii?Q?nQ318ZGjnkdJg0Iijgiahqyw0leYflbdRLE/svNt/UhHt8wjFNKHc3YjRw/3?=
 =?us-ascii?Q?CHWVnsAOiCnL/fiVWUpc+R50SAWyvJXKwdGr5rmZWMt3mt+DIw0scgBRNRGf?=
 =?us-ascii?Q?FF8Ee23aeCWTQKCK+/RyxCY21i7VcKAEprxGM0J6/W/VR7InCHzj56bUfRqg?=
 =?us-ascii?Q?MJ/ZT5/oOfXxMHhmZKz/ib9X/Mh2zOrbdz9yD7s7/bDhAHg1GddlQEuub/5m?=
 =?us-ascii?Q?KKL9VdsJ6uGXleIuE5w4qSzJTZFtCo9lFEa+IZEuhO9VU1PktwZU/SFjNlTL?=
 =?us-ascii?Q?ZPLpk8kr9HxJ1VBrBtWRPFBQ1+t6qPipq+Cw0u1qTdncmtbufJ/FE+C/Anbm?=
 =?us-ascii?Q?+fYo/F0NwTleAUNByUKd55TJIHMA9Sp5Ei9FDQBN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e748ac2a-f250-4049-a4c2-08db3dbd4359
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2023 14:25:29.0820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eZwYYATDuLav0VM25ujFsw1jbtDVOjumPPHj+lI16v6Y0zAyvB6ISAdtZEkXnC26Z3PkRgn1xSvPIPKsuVYlQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1348
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, April 14, 2023 10:06 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> pabeni@redhat.com; leon@kernel.org; Long Li <longli@microsoft.com>;
> ssengar@linux.microsoft.com; linux-rdma@vger.kernel.org;
> daniel@iogearbox.net; john.fastabend@gmail.com; bpf@vger.kernel.org;
> ast@kernel.org; Ajay Sharma <sharmaajay@microsoft.com>;
> hawk@kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V3,net-next, 3/4] net: mana: Enable RX path to handle
> various MTU sizes
>=20
> On Wed, 12 Apr 2023 14:16:02 -0700 Haiyang Zhang wrote:
> > +	} else if (rxq->alloc_size > PAGE_SIZE) {
> > +		if (is_napi)
> > +			va =3D napi_alloc_frag(rxq->alloc_size);
>=20
> Allocating frag larger than a page is not safe.

 I saw other drivers doing this - use napi_alloc_frag for size bigger than =
a page.
And it returns compound page. Why it's not safe? Should we use other alloca=
tor
when need compound pages?

> Frag allocator falls back to allocating single pages, doesn't it?

Actually I checked it. Compound page is still returned for size smaller tha=
n PAGE_SIZE,
so I used single page allocation for that.

Thanks,
- Haiyang

