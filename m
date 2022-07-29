Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6AC4585515
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 20:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiG2So2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 14:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiG2So0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 14:44:26 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020017.outbound.protection.outlook.com [52.101.61.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A9F7F513;
        Fri, 29 Jul 2022 11:44:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3ynTzwboR+E+LMTNaWO4wPvZ7OznJrUgA7tgowYGAxcQjS3i3MzryYAEL3nZnyxe1HF8POwo3WZp+H6TVKIm/TeujWyr7CXu/HT/QUZuZ0vpVs5JPymr0NWUM9Is/JsNlSlN9b3Lj/ScixZnVrS7T6iOZpzDmxF7OdzR2+Yr9TnTGqNccP7UI6PY+LJxI8lzqCvZ2TOb55DkoaC0t0tVkrc8/Ip2YH654gJ3RMu/nmYtOww9m1LjlYUfRxy5510WUVN3LS95xVFCL9Tz0EviXBr7mPPcIzUZCxV4eXXBIpEnQZkBCxevIIQvaGOemzVqeFZgPZkY1MHEnQb6WnS1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRvlP5s9RxCqf2MO5D1RppVCu9lG9i9Ab1skoKKjE30=;
 b=LMVJLsdPZyAcc98i0udQgz5xhFxrbtMSrdkE23gmzJd+3bhCW88uZpDCZyKW69zKae05xTjTzIZ3nAUU/z5TBR5kqIFDO+g2NoOWD63TCMPgZBC/jlz+pAttA/shg7bfXuyDuelMYbR1rHmgONrQqaRQhpEKhX2S85wsQ8jAQy6e02MUsjI+SwzYk4DhWrFR8iFpGuNsPvwSn5qWsRs+jqKnI4uZ12t+MY3hjTJfrSIrjlV/I0aAxeWoSjrT/JYRHbusfO3ynekP3A2IZF8UkSixIDMpd9NyJSKkrmALADenLLCeK8YGlIFK8UH4dJIXFcIpkmWw73W8wQWaFhkZxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRvlP5s9RxCqf2MO5D1RppVCu9lG9i9Ab1skoKKjE30=;
 b=fwszDbuT/0Q6I7tE9YC/naftcP5qNqi8IKsUSfefBPw1aMajVKdCJgmAdIKF/fyp6Tqdj13QnkfgPHdWo59+NnRp/QAvilBiqUws5cU15dDgWOGO/58VzFsKsxbz9nyQnV/gcVKaye28+PMW1GVWTfKMjJzg4ufRo9HxN7ZXM0o=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by MN0PR21MB3169.namprd21.prod.outlook.com (2603:10b6:208:379::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.5; Fri, 29 Jul
 2022 18:44:22 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a%5]) with mapi id 15.20.5504.009; Fri, 29 Jul 2022
 18:44:22 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Thread-Topic: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Thread-Index: AQHYgSXY1SrlgLfyyEyOddi806gORa14hJeAgAK137CADOflgIAABSdwgAD1agCAADIx8IAADwKAgAcIraA=
Date:   Fri, 29 Jul 2022 18:44:22 +0000
Message-ID: <PH7PR21MB326304834D36451E7609D102CE999@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-4-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB13272044B91D6E37F7F5124FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
 <PH7PR21MB3263F08C111C5D06C99CC32ACE869@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220720234209.GP5049@ziepe.ca>
 <PH7PR21MB3263F5FD2FA4BA6669C21509CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220721143858.GV5049@ziepe.ca>
 <PH7PR21MB326339501D9CA5ABE69F8AE9CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220721183219.GA6833@ziepe.ca>
In-Reply-To: <20220721183219.GA6833@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=74ab7557-5af1-4a50-b017-91bc471b2ac4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-26T05:57:11Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a346957-ffa4-453e-0442-08da71925a65
x-ms-traffictypediagnostic: MN0PR21MB3169:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nmT+LoNF3/tKcbLDO4idrCcevxCZoBcrTJc8LcKUZxq6bsbE5XlMn48mqvtHeVG6Z3x8N75ybWE2qFcCzgeW53gYoIlHYOzEDiKzz4bATsVOjXkCk/gjWC9UMUL23OnMGvUwlBSpTQXsMSjlHv+xjgZnzWsJxneB/23akLeMBNZR3pi8ZL7aTgJHOzjmPNTn0MOXtZaKlmYHKrJEj7W1zn5do8yQk9Vo7RdWeMHeAcUyAUty7J0CDTpihPMlA8zKjH04CHbvAkL1mHSM/G/dvwRrXTNKYx3B9e6q8Tch6ocB9kv64jGSNaytvKa9NAjCxq9dZC2Z1RfVcXrtpDNljimDTBY8xC/v/dAM1KhGgXm4W6LqRAWlBbBZNirmcebaBjXsEI1MPcwuPWwY4bZVgVTD/F6SWwOtawwoKsH3VWa1sOpztCWx6FvMkw8XoHZurpNGJmsWIswcTL031dsnlSFGZEl2RHozZxIL07DKVuIQP35cMBhhdg6UIrxFOq1M+7e6el19RHpZrt8H5FK1WwiGnftBcntfb+kC9BnGZnkuPqsaQs4h9nO5a9Y8vhVTvGZZ1dSLWS/e3LNLUydDkXRG7b130XG0amjJGqPvnsHO2VLOFjjhJaXIdh7Tfuv9GkY1JBszVbUWsAVTKDCq4BcnP0SuKvfw0L3JAilXHtx1IJ/jRyUJBvYBdy8rROO4kZ+RI6vlDmFLVNMgNTGqnDsmR0jXUZsb9vc77kNReG6ESKMfNGEM6JNstTJ+OhiSKSJ7tUusItkUvHGeh+KC87vOTINH7K5q3gy445mg2LQNB8FXu2m82CS0OKF3mDe/tPxue4VUmb6UjxBJa0cLSpqS00dm9zLQhGwpKxaSWl2G4Ke4OzhBwZxtXK/Mas/a
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199009)(83380400001)(2906002)(41300700001)(478600001)(7416002)(82950400001)(82960400001)(8676002)(38070700005)(33656002)(26005)(71200400001)(5660300002)(86362001)(122000001)(38100700002)(186003)(6506007)(7696005)(10290500003)(8990500004)(66476007)(52536014)(66446008)(55016003)(4326008)(66556008)(64756008)(9686003)(54906003)(6916009)(66946007)(316002)(8936002)(76116006)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WKiNjwWIZ5mRZLVwXExEEY1GRqAXS+zSB9R+fKzE20A/lxKKkmr8xuhAQnN6?=
 =?us-ascii?Q?gnsOW95kZP3d7+ikNzhNZHnUbt5jlJQvujLqp9JGF89Vur5dSpV1z3FofiVt?=
 =?us-ascii?Q?fSrPljTtgLmPIXVo3x09ETUdh+OpVqirc2jt3RbKdegAsNkDqS0LvYIQakmo?=
 =?us-ascii?Q?r/VKvTEhE3e5n9SbOt/L7XWLqpWsl03YN20c1imLC/bMMpSu7FCviGb3mTx4?=
 =?us-ascii?Q?wQ4SrGCtImtmQQnmKGriKcPF6CpArEp7zv4s4k+OmaAYO5TYi5QoXzUrFGjJ?=
 =?us-ascii?Q?ti1C/giN50EX0yIRiHLW3WS556/C2zot9AuupzcT07Q4u8EBHQe4Xt4qsskN?=
 =?us-ascii?Q?fgEv58WEX5p0fumTg3oWVBGA/aiMLF8Gm9e3bWmldhGXEt7zmy75k86bXYTG?=
 =?us-ascii?Q?4GIOdUvuFUv6/BvD2oji6XcJD47gb8+QLrk09A3ILKpPaiTTyAtdbUPnYlgO?=
 =?us-ascii?Q?gj5mvU8CxkfwaGH7R+tB9zR4R2uaHhyr6aKn3SxWnKvxmsfptoMDTDwDfg/J?=
 =?us-ascii?Q?Y80NKZGTjRTZKkt9er0RFRTZBNn4r+K9EDsVzBo6M1W2MMRE0RkVG/EJehL0?=
 =?us-ascii?Q?7jZeOPkPsUo2hikGlonhK+DaDHK/+C7iDg7s07MIcg8vZWxzVjpYgekf9MVA?=
 =?us-ascii?Q?Oc7EIikEyafRSsN5zg2ar8IfpDl4au0vjijCQrEPlcZOeTFow6c6tnXV8wac?=
 =?us-ascii?Q?zc5PvvQw+9JyZSWgs11gMwM6efmvAhN0kqhWy9pEcNyotsVN/5khPd+cvSts?=
 =?us-ascii?Q?vTj3VMJmGzG27CAGumpM4zxcg2KefhlPIc+ChfhSUGNowRNn4ktlgukbvXrH?=
 =?us-ascii?Q?yb8r0dFy4OmOJlg+Qx6sCgqFv4uTdZnqEUs62lVLQWi7Nzd3hpwQ4nTdYi19?=
 =?us-ascii?Q?DEwDDcIesxY2vfG0rAcEDHtvUorTrsnfKtyoqHryiojaCeqIo+Y+X+G20zv4?=
 =?us-ascii?Q?8y0vGGZjAQs3w7KX7CD8/t+4+C6/FdLvATwSNKl+D4r3AmSbgXhInO+jVqFc?=
 =?us-ascii?Q?1iLYs0wcAxh7R7zkaKPYKZPCYX/0YSsyAapghCBe035QOPpgsOhu/gIbQavj?=
 =?us-ascii?Q?K2iByte3Ls9te7JH1nVKFD4HoT1Ja6TH9cW+NNRLChAKAFtHIArG588t2ZEX?=
 =?us-ascii?Q?0/dAquNN8cNhccm3BSfMjoHiiluRgAMNUVfSSEODgc+NN6mJdzB7nn9eOfBg?=
 =?us-ascii?Q?Fp/qPOjUmwHX5DrUfemxRbSHHqZG46nuHDoab9L3O12oA8e1NHgHjm39jYk9?=
 =?us-ascii?Q?qGrLX06zsxBTUfH1uJ368T4FfWobzqOcYKPbv9Gnd+HRt+Ob1AfVAHyzf1pO?=
 =?us-ascii?Q?vc5+XSfghDCDQkM5wsH99Isb6XTaAhrl8TNh0ki+HDSiwFfGzqQGXSgqu6Xh?=
 =?us-ascii?Q?+T7y0VWYzzfuIgYPOh5RoLvn6YG6xZ6/qN9HPY5P9jbnTgSeKrVOayTSsJB0?=
 =?us-ascii?Q?5daOmS6XifIfhOFhBQlo9xBe0y6gzq5SF8vy6DZ3RkZfOdYylaQUzgIxzzO6?=
 =?us-ascii?Q?ywcqOejVtIcxN5Sg3196VK76+mD20RPYeDHVcmpz/jEtoJhTWi8OWa2d0XpC?=
 =?us-ascii?Q?tjy4GEypOwdRZrsjIplt+B4kGefUby+6DVhUV6HH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a346957-ffa4-453e-0442-08da71925a65
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 18:44:22.1610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P6/dOJIssugP+0D5GWXszYynDe6S86mxzJKRjFBk177dguk/azMKg9hRuCaCrpX4Zg7gQvdqJ1wv4mrV9Bv1oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3169
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [Patch v4 03/12] net: mana: Handle vport sharing between dev=
ices
>=20
> On Thu, Jul 21, 2022 at 05:58:39PM +0000, Long Li wrote:
> > > > "vport" is a hardware resource that can either be used by an
> > > > Ethernet device, or an RDMA device. But it can't be used by both
> > > > at the same time. The "vport" is associated with a protection
> > > > domain and doorbell, it's programmed in the hardware. Outgoing
> > > > traffic is enforced on this vport based on how it is programmed.
> > >
> > > Sure, but how is the users problem to "get this configured right"
> > > and what exactly is the user supposed to do?
> > >
> > > I would expect the allocation of HW resources to be completely
> > > transparent to the user. Why is it not?
> > >
> >
> > In the hardware, RDMA RAW_QP shares the same hardware resource (in
> > this case, the vPort in hardware table) with the ethernet NIC. When an
> > RDMA user creates a RAW_QP, we can't just shut down the ethernet. The
> > user is required to make sure the ethernet is not in used when he
> > creates this QP type.
>=20
> You haven't answered my question - how is the user supposed to achieve th=
is?

The user needs to configure the network interface so the kernel will not us=
e it when the user creates a RAW QP on this port.

This can be done via system configuration to not bring this interface onlin=
e on system boot, or equivalently doing "ifconfig xxx down" to make the int=
erface down when creating a RAW QP on this port.

>=20
> And now I also want to know why the ethernet device and rdma device can e=
ven
> be loaded together if they cannot share the physical port?
> Exclusivity is not a sharing model that any driver today implements.
>=20

This physical port limitation only applies to the RAW QP. For RC QP, the ha=
rdware doesn't have this limitation. The user can create RC QPs on a physic=
al port up to the hardware limits independent of the Ethernet usage on the =
same port.

For Ethernet usage, the hardware supports only one active user on a physica=
l port. The driver checks on the port usage before programming the hardware=
 when creating the RAW QP. Because the RDMA driver doesn't know in advance =
which QP type the user will create, it exposes the device with all its port=
s. The user may not be able to create RAW QP on a port if this port is alre=
ady in used by the kernel.

As a comparison, Mellanox NICs can expose both Ethernet and RDMA RAW_QP on =
the same physical port to software. They can work at the same time, but wit=
h some "quirks". The RDMA RAW_QP can preempt/interfere Ethernet traffic und=
er certain conditions commonly used by DPDK (a heavy user of RAW_QP).

Here are two scenarios that a Mellanox NIC port works on both Ethernet and =
RAW_QP.

Scenario 1: The Ethernet loses TCP connection.
1. User A runs a program listing on a TCP port, accepts an incoming TCP con=
nection and is communicating with the remote peer over this TCP connection.
2. User B creates an RDMA RAW_QP on the same port on the device.
3. As soon as the RAW_QP is created, the program in 1 can't send/receive da=
ta over this TCP connection. After some period of inactivity, the TCP conne=
ction terminates.

Please note that this may also pose a security risk. User B with RAW_QP can=
 potentially hijack this TCP connection from the kernel by framing the corr=
ect Ethernet packets and send over this QP to trick the remote peer, making=
 it believe it's User A.

Scenario 2: The Ethernet port state changes after RDMA RAW_QP is used on th=
e port.
1. User uses "ifconfig ethx down" on the NIC, intending to make it offline
2. User creates a RDMA RAW_QP on the same port on the device.
3. User destroys this RAW_QP.
4. The ethx device in 1 reports carrier state in step 2, in many Linux dist=
ributions this makes it online without user interaction. "ifconfig ethx" sh=
ows its state changes to "up".

The two activities on Ethernet and on RDMA RAW_QP should not happen concurr=
ently and the user either gets unexpected behavior (Scenario 1) or the user=
 needs to explicitly serialize the use (Scenario 2). In this sense, I think=
 MANA is not materially different to how the Mellanox NICs implement the RA=
W_QP. IMHO, it's better to have the user explicitly decide whether to use E=
thernet or RDMA RAW_QP on a specific port.

Long
