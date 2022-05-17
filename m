Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6A552AC6F
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 22:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352825AbiEQUFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 16:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiEQUFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 16:05:02 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021014.outbound.protection.outlook.com [52.101.62.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E8B4CD72;
        Tue, 17 May 2022 13:05:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXNcfK5UhVagrLHwf+5NqZzkMqF9LHfjq3RkL0VXXb3aYr3SjkcXprIFcp+sFTF4aXxBg8EPxMMTuHMwdQNiwX9nVl+zC9UUUPPCsOsb6IfnYaCT3KR+bFGhk9k8yLl51QGMA7YWF/4y4qzCA7UqkyT55IkuXF9av/i1fG25a4h//qFgZVHRCqOzqhMWfKHPuz+xdWrIalphTNmYbRknCQSKEmXQ6dAd/nLgK8L8n3UGB+LfFQ1qOEOG4gSr2tLZgIASoKQsBWq1px1J+aJP9APEgq93+PCkB8Gb0wzCvsYkZMxL8gGZFgrUcCbpbJPq9XnR/GXUnzmBgOfBy/Rt2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPj3h5l3b7NrOHjIxV4KlUTdukkZZ1gEItGthhouI9g=;
 b=ND+v3jzZbAAJKs3ioeMedLN2b2Oni74tGFa6u2xKqwV5Ps6Bct64UJWVFY2yxEaKjs1N9zaQ5fMa73W+QozIbhcHHHA/U+UFeZlp1UUxQTSuMYS95aTmG/zLDJKK1WOy4mrXLpZVQYGKrgcwsGxt+CaqkzlDDOvnIdMc/k2lZsJRKp8b3COk2WcU+ePhCXQhXHOA2Jcs44VUX9zQNIbowuFoKBGaYfAbk+wNpvo6HHT4AXNd3YBA09cu9cnCyXREr0eHaK8gMJ5CU7hhchI1G3tAwZoG/ij6UB252gUcHbaj6zTBZEl+IBurnNdx3cIjnlE3cCuxoGCFD0Z5PWCybg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPj3h5l3b7NrOHjIxV4KlUTdukkZZ1gEItGthhouI9g=;
 b=Dgsr4A+zo/pE5ayxBYGeS1Ob977SkypTvedWTn3WgmFnz8TZamnR2Gsx7WgVRmN6cXxQ6tYfv4V7Fm2E8MqYVz/xOI5RX7WbDkL5MeaUjATgAi7Tk7E4nSg0CrT6JHq4DMMkeQe5Gp+K8Bs4nYudcwD1dT2720SseEwfDofQPWA=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by PH0PR21MB1325.namprd21.prod.outlook.com (2603:10b6:510:100::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.4; Tue, 17 May
 2022 20:04:59 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd%5]) with mapi id 15.20.5293.001; Tue, 17 May 2022
 20:04:59 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH 05/12] net: mana: Set the DMA device max page size
Thread-Topic: [PATCH 05/12] net: mana: Set the DMA device max page size
Thread-Index: AQHYac0t/cR6HA52CUOHz8pr+lzroa0jKeeAgABLXKCAAAGZgIAABm1Q
Date:   Tue, 17 May 2022 20:04:58 +0000
Message-ID: <PH7PR21MB3263C44368F02B8AF8521C4ACECE9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
 <1652778276-2986-6-git-send-email-longli@linuxonhyperv.com>
 <20220517145949.GH63055@ziepe.ca>
 <PH7PR21MB3263EFA8F624F681C3B57636CECE9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220517193515.GN63055@ziepe.ca>
In-Reply-To: <20220517193515.GN63055@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4bf42b8a-14fe-4f3c-b03d-934d35a74fda;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-17T19:58:14Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d21814b8-6558-4460-11ae-08da38408530
x-ms-traffictypediagnostic: PH0PR21MB1325:EE_
x-microsoft-antispam-prvs: <PH0PR21MB1325E2C7E81E6AFDD29B56A0CECE9@PH0PR21MB1325.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dv18cSiXF1PuSv8BMDJXKMXUVDpkNdu/tMSLj/X99c0FQJLg9Hu0MDYA4QKhRUV+cLkaIc/rFSXQmeMbQE8y4Uj8MW4nEFG8ZKDFWrVBsiEQ+eIwTYEgVQUKtiKW5MYgP6me0R82nJoD2Px49WwBdOmi4DIKAPWK+OpgJnUCKVSEohQrcG5uhVnTrldHBuWF40jd+iH1jMlMoxYD0d5toTPSdrsFOZr00V/U84NPABUjrgG+v1dQHwE+EBMUTVwKEElqLovVknKscE2DmpsQFdCSKULCLY5IBHkizfv1j57jcTmZUZ9u207sOvr99F77u8ACYh5zyo30Q8yUvDEAolSlwt7USEe4vMjQN5DwMPRfBuYlDu0GII3GVsuha0DsDfCModypN6RvgLY1bpRsPi+Ahr5x15z3Wd99bCINK3L+LvXqVKgaTxYuqRhCpsRtm9snzkUMc4uV3XibXUIJx8tmfBUzZtdms17w7KO8tdJude5ZOkHLVmj3un8yqC64sMZAC0le8fi3uh69ZGnpTrfJk0aXhLoQ+gqmFCIjwQUvOhC4r6/dCnOfZATEkFFEvgRlAxT4oKDMx1K7do5PHzZ8osDJL8yQ1+yr0t7srlsrAUnvI1h+Zj48PWlnmmlrhNTwk1tMdLoh/SYZoCP62nVN2HTA6BGY56s2az120ZlZ/DoKv3+j+ga4nsUylHxLjlIIL8tYVgyUOb8LiU123URX+9DQIYxLPJ4WmOwUF62xXH/Fj2IKEHKYMnaUhE5h
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(66476007)(38100700002)(7696005)(64756008)(66946007)(8676002)(66556008)(4326008)(76116006)(66446008)(186003)(6506007)(55016003)(6636002)(10290500003)(71200400001)(54906003)(110136005)(316002)(82960400001)(86362001)(5660300002)(122000001)(8936002)(7416002)(52536014)(38070700005)(82950400001)(2906002)(33656002)(9686003)(508600001)(26005)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3m8er5bA7Wpxbb8u7onFA71AYTxBVvvrQmR6P43ZwU8NH9ToTVF/YfQ+tsH1?=
 =?us-ascii?Q?9tFjGX9Yoiviu5ntJwH1/d05FgMloWxI/MyVR+cMrPBn5grFqd5TlyMdkw0D?=
 =?us-ascii?Q?Rnghf96Rq/qcXHwQluZ43tPH2vrN5ptZShP8a/GNKgSkERGfrwvEsBsJNmqN?=
 =?us-ascii?Q?ccR/9hsfT2P6IDt89rYIEQ77HODq5jTHtYS4wFeUN6Z57vLF8oXqa48i4ghh?=
 =?us-ascii?Q?6yJm/FDBrVqV3PHzbzzpZdkjXNEGTAnA3Pl319H1V7w/HPxjoNKbyzRdRZaZ?=
 =?us-ascii?Q?OU6U2S+mK2ng43HAv5GjLrFcetpt5GQ30BoHHzGuexvOlE35h3F/h3bRe7nj?=
 =?us-ascii?Q?INit/CQnU73ogasWr0TaepHmf4dsmyo8wLtNvD19PodfkyhBh4doZDOZ8F0n?=
 =?us-ascii?Q?ctDgqlnl+YgxTLEWeHC5lZ0Rb5Tb+EA2bg2sVa+uR4E+yXsb99NMwSfukx9T?=
 =?us-ascii?Q?HeqmcJBHV0vRqAkfQ3yBG2ixW6hnsFgpGriirsPZGfZVztD2txe2gf8Q7B6H?=
 =?us-ascii?Q?pYSb0K0yhSO4+eS8ZOZBp9yyW3LKj+a9TdfgIMkWA3MEUoAWYoyPXlyrkfke?=
 =?us-ascii?Q?9bEftNX9IqnBFHtGgjgm3QgnmGlTlT2tyTXFxDwJK4p4qT8FOy0pc1kQS+C0?=
 =?us-ascii?Q?/eugY4uTWnoy525/VoIcSfSl4l4ZQoA6r1EkaDX4rQTIJ4gLpc2DhjzY+maa?=
 =?us-ascii?Q?CuoUizOxGdbqdDztlopwNGomJCW+GpwdRjL4uURuVKaKqZwyV9ehz7HzHqNF?=
 =?us-ascii?Q?78hxgiZ+NPefAolNzLb/3tM55hPgJSfKnq25nWUKOdmo8wipDt2ejHuakman?=
 =?us-ascii?Q?ooUt+Clta7foS6q4rAnlYVUx2KWURpwvnz2ArBxFG3IgUM8+iuA97c6ly1HT?=
 =?us-ascii?Q?bIL1RVxx36fevnoh/C2pyjazZ1AUUVbYWy0q+6kLd22wm+sWelklxTzix9cT?=
 =?us-ascii?Q?bBIIBOz9fGbzOXv54a0+TgjrI+eAUrIqbWacPn/YbS52+W5KCY//iYMImD0y?=
 =?us-ascii?Q?gOhR2tC3egglJkPEQlUOXgIEEe0R6+0FQhGrYyB5PGkZc83kMX5pPRNWlEBb?=
 =?us-ascii?Q?yhVnGRV/zM2D9aIZKGaGGQWpaiTxrJ9vvMZiBrVuNRyOI2MboP2gkScnhuwI?=
 =?us-ascii?Q?BJkJL7FXaOq5z9Xp2Z79hasPgAM9dQHDmZGDdpwGbyuOrJngd1FOVG5vooEz?=
 =?us-ascii?Q?c7eF6o4LZdZdbMvHHWXSDlCo64WZt9KxKsfbTz8bHtG6K7w9nk++EgVh3E5r?=
 =?us-ascii?Q?LlhmaDainArU0nnuTmpc1nTZqcDKGj3n6s4+RN67Z2YL+kEokkZypzglPc6b?=
 =?us-ascii?Q?WJvSInGWymZTRR2IGdqaDCM+Hd1H2AxN+L6ufLNlmOqmXQvu3/H9WzP2lpIs?=
 =?us-ascii?Q?b7ICcbVtD0BsgBtMzmmk1RCzqpQfjS3Z1mqVG0q0hk+Fd5X0zgNaz9YaQzF8?=
 =?us-ascii?Q?KLMXLVKZNsnoO8lFel1JYRh7qLXKtFcsEdOPatOAJQWWtMWrMMD3GYJf2Y3e?=
 =?us-ascii?Q?3z/riOgTMcoFWPsBIFqokygp7XCuUbJLHzVsPoFtJIp6Pe3yEqlSjQ5x2Zb+?=
 =?us-ascii?Q?qzacI8arxZ+TBT3h1d8jlE97N/tH/Fo0RbWfVWAWAGGZ8n7TDiY6pGKJogto?=
 =?us-ascii?Q?RSY9lvxH7DJ3hx1zl6kWQPbKxUk71fNblRsE1Pn0mJhGDn+pk/YRk0kTYQFf?=
 =?us-ascii?Q?zaQjDXb04Nj4ZcbWGdUH1dw5jmjGfndsFSXJnZj51nEoqRAHl7tEBy081nty?=
 =?us-ascii?Q?THSLhZntvA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21814b8-6558-4460-11ae-08da38408530
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2022 20:04:58.9129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nfGo9dQ6M7KFckk4prXO3f+/nHxBD6GxhFLZeSwlqxFycjNQgFwVWqJb0l2fPTLZBzM0oiZTKyxiKaJ4XJojxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1325
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 05/12] net: mana: Set the DMA device max page size
>=20
> On Tue, May 17, 2022 at 07:32:51PM +0000, Long Li wrote:
> > > Subject: Re: [PATCH 05/12] net: mana: Set the DMA device max page
> > > size
> > >
> > > On Tue, May 17, 2022 at 02:04:29AM -0700, longli@linuxonhyperv.com
> wrote:
> > > > From: Long Li <longli@microsoft.com>
> > > >
> > > > The system chooses default 64K page size if the device does not
> > > > specify the max page size the device can handle for DMA. This do
> > > > not work well when device is registering large chunk of memory in
> > > > that a large page size is more efficient.
> > > >
> > > > Set it to the maximum hardware supported page size.
> > >
> > > For RDMA devices this should be set to the largest segment size an
> > > ib_sge can take in when posting work. It should not be the page size
> > > of MR. 2M is a weird number for that, are you sure it is right?
> >
> > Yes, this is the maximum page size used in hardware page tables.
>=20
> As I said, it should be the size of the sge in the WQE, not the "hardware=
 page
> tables"

This driver uses the following code to figure out the largest page size for=
 memory registration with hardware:

page_sz =3D ib_umem_find_best_pgsz(mr->umem, PAGE_SZ_BM, iova);

In this function, mr->umem is created with ib_dma_max_seg_size() as its max=
 segment size when creating its sgtable.

The purpose of setting DMA page size to 2M is to make sure this function re=
turns the largest possible MR size that the hardware can take. Otherwise, t=
his function will return 64k: the default DMA size.

Long

>=20
> Jason
