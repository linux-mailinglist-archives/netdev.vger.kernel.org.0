Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D2B52AC01
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 21:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352748AbiEQTc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 15:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235529AbiEQTcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 15:32:55 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020026.outbound.protection.outlook.com [52.101.61.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29928517D5;
        Tue, 17 May 2022 12:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIiKUjTOu32gy7JOy8TuhFBhL+L16VoLu1cMG46vpqXO86MA29bAlQWinBaPAgRu0aPXH9KUki4O2VRjGZ6/ku6O6coCjB+l/XZSsf9Sfs/TzMorPY8Z/t+0W0+oH0vLUxxmhzZmwwzOJ/r7AkSB4bJ2knVA+ar+4IaO1cS2I0VrYG7grlUe54QXSynfT1F2t+65pUqSexZ5B3ASAkHJnFRh6LTtDHcl8xeId2L1MVDR5+/bgVbqRxeZm9/KsFQ/Sd9nsqYyXKcf7s4e05SSjt1rhkkEix3o9BlZoKTertigRQHaQgj5vqSj7gFkyf87fHQaZ/l0FTy1fHhS6D6m5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4XFqTsL8Hwa0BBhevkeYlSVMoCEjh5PHEquVs/gEuEY=;
 b=HDzBHorO4+A6nCIi6OZQqc1yp8noy2TRj/uMbnYteOxBHNvNwGi5gpZkBH5du/1UomhMrUQP/TxNg9/X5mBCWi4cHhTbX2eVxq5g54O1culPU1LJckCOcPQOyiT0Simt5od8c0SqnqETHkmWDYoX038/yJqloBDPIGQi0J2OnzbHbTA/R069Ec8LV9pwE0Q/gWpEWCQvstl4Srmk5d2r1j2QCAMXlwe3SFgw4pK4VCBTXLM9Ak9xnJB+hrSqfvXQbJ3IQE2QF7nAy8coy0zqni8AFYVsRgeh1pdWblmCWaYdF3kv8YyCGTXTx10cvqMb140u+sPKFQTlgca7L8vRxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4XFqTsL8Hwa0BBhevkeYlSVMoCEjh5PHEquVs/gEuEY=;
 b=KpBFPEVaADhZT8tB3mm9Hk7i8T6OFsDgEBZ6SRmueuraAMiGfQi9BuvmRDunIrVsOt6Qe65MWkqLHRo00aJNlM++5up+zBSXM4a6e0SlfE/YUNKpuvLVicPUrqadrsC+c/47j388a954/105RqnWTQ+QOcqGvZYT0vlvxuO+S6A=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by MN2PR21MB1213.namprd21.prod.outlook.com (2603:10b6:208:3a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.3; Tue, 17 May
 2022 19:32:52 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd%5]) with mapi id 15.20.5293.001; Tue, 17 May 2022
 19:32:52 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
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
Thread-Index: AQHYac0t/cR6HA52CUOHz8pr+lzroa0jKeeAgABLXKA=
Date:   Tue, 17 May 2022 19:32:51 +0000
Message-ID: <PH7PR21MB3263EFA8F624F681C3B57636CECE9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
 <1652778276-2986-6-git-send-email-longli@linuxonhyperv.com>
 <20220517145949.GH63055@ziepe.ca>
In-Reply-To: <20220517145949.GH63055@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1358c63f-1a97-434b-92bb-14782d87ec98;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-17T19:29:31Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a00229f0-655c-4c19-77cc-08da383c08a6
x-ms-traffictypediagnostic: MN2PR21MB1213:EE_
x-microsoft-antispam-prvs: <MN2PR21MB1213A84CDC2017D049592BF7CECE9@MN2PR21MB1213.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DB1HCGxERiOlm6Ld8LVPjtbnvjZrf3H74NQtvfV5DDnKFSHHahKolu0GQx03mWftcO00UFPh9Axpqygmx1NR84oueeJ/nkG4nK3zKj8HBuoBhmQe7x09/6iO29UBHLit/Q7rfKE2T2//lc/y0okC9vAOk6WCaWh6JYUiZ41PlU2d50kNddm1KTHGyN+K3Qp/OrJNdkibArMTa1KhCMdASGHJ8zpS6IheO1PIb5RZom3Ulhma+/gxppF1kRQLtvv+4kojcfIq9oJejTne9R3FhUFwj9eW4rRnsdmK050sKY4FqP7QuXrA8acJ6zaTqxOZ4H7OellQcC1gX0tiarOa2B+P54YePn3MlJAPgRAzh/vM6BQIqOwETFfzyoW9zcyi6ohw+jperPfqYfUxIWOS3N1CCP6Oqq4euIJyS6hkjNLM7N7k268RgjfhjQItYRPWRwxM6YGBs9hqxsR5+/FhxW9nhLNKwUdT0QjFfbiLNMjJDzWhH660x9ZFk1/e9ixOs99S4T3BWGrNEp6SV62gRZtnKSFoi0ntUMrntLUjNaDZNlz0P69A2fjlmMB1g6JgUjMkxyfh2lA4fLfGRr5kzXYyvEz3JBdz2z9rOXYozPYXv5wONmwM8N/+TGZ961fyTY0T2Y8mkX4zPE8Ovl/uSuuEr/dRs5yhLtSBb5j50QVYJkvnkdDTl+WvULfX7L3Qz+RHM7q/LiWaP+MweAVlNGnCskp5zS8Lq/yCI56tQAFM9n56mDorzyszn3mYk6DC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(26005)(4744005)(66476007)(9686003)(5660300002)(6506007)(10290500003)(8990500004)(66946007)(66556008)(64756008)(7416002)(66446008)(4326008)(8676002)(76116006)(8936002)(33656002)(186003)(7696005)(2906002)(86362001)(55016003)(508600001)(71200400001)(52536014)(38070700005)(38100700002)(54906003)(6916009)(82950400001)(82960400001)(122000001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A1FENbN/N7Ty3+Ps5dDboXz6cFtvaqQaRKZDo4RUrstRdbdpIPkf8ANPg7eJ?=
 =?us-ascii?Q?GzEnodxrMpiIRYSFZ6RiNXU+V3tbTzx7+1sCbmtHQpereda0cJbWw5/fJiXs?=
 =?us-ascii?Q?o5jb7cEwkjWngM7z1Ur34GceIs2n1b3iO2h1aWnSIgeShVKoF8u5nDURPyYB?=
 =?us-ascii?Q?YYT3HXNI10qJ60ci8/h6zMwdYHS6ljhGroWFcvfFSSFKA+lvMaQZPruk+I4U?=
 =?us-ascii?Q?bkOzfcrdWGT9oUdNgS/6np5YlYVJYRYVR4QtpEw8+S9X5cGXeZdIGqbdhzFW?=
 =?us-ascii?Q?g8RQbT1Qf3ZEGkqTGN7BelPePCwBRbrM9m2yf5SeSvWkpzNErCqPPKwu5Egf?=
 =?us-ascii?Q?cSM1kT3XxdRO291y81OYK0p4QzaSVa5797+QMuEQmSFdrVEETH7o+119FNM3?=
 =?us-ascii?Q?/YG+dBYrIg6jAdDvQu7SehU1zc0faFi8klKTQmEFjweQ7+1PjBnEIw2zCugl?=
 =?us-ascii?Q?m27GUWqIS4o3AA4rAxY39Szs0TjTw2GDQrfmqOckE/2w/zBvjFa0dmyOCq+9?=
 =?us-ascii?Q?ZxvcHzBlzl4C0aR63TG0bm/J5jZq4aoW2u8QIwgRKwXvJfftGPEN1HuJJVon?=
 =?us-ascii?Q?lCu07pYPAhuqryGmsiMzJzuGVVmsEtISNvt7EH0K9P5rUHIGzWODXXG9C8oG?=
 =?us-ascii?Q?cAtoqSaslKF846DCDmUp7YucG3OPtMxg8CwWYirU/g989OjEy2X9K1hjF4sY?=
 =?us-ascii?Q?v6qH3SyljTrKzSP2t7Rw/5TrzBmWBb7yqPh/hnaO0LAGB0A658o8CNs7tY7H?=
 =?us-ascii?Q?3ao5+7uYYCKmEywpxdEzpSoc3zDKO1yVsKBkMm958/PqvDKJTfK5D66uXeha?=
 =?us-ascii?Q?dasMjHKiQeswUDf4QP8vdpT/K2Pto9u19sI0YHl2vc1EDpOnDyC8i9p7eJ9N?=
 =?us-ascii?Q?RPHlZlqc4ozq+bVRjVgy7PA/2iigxpjLcwaJuJ5niHlTq5B7KT/96+fxzGJ7?=
 =?us-ascii?Q?R+KDaZNgYGD1CPdHT5uBl5HT69upD4ziv2vbk20bfFXC4yRzhEGMsdYDLlr5?=
 =?us-ascii?Q?2IURs1wVqZKdbBEEIIefYsDthrD+dBI4dgs+wfWdST6Zsa81FRffybcHK9HA?=
 =?us-ascii?Q?skcYfM5oCEKoTyfFqZw+UjUZhE0f+WsaOZkQJucLf2nVh8RBQxkLHm+HhatC?=
 =?us-ascii?Q?9sdh9eK1jdi1vkqVry/JQSoOoK1tvfRz8tkHDOtmQSKiLN4j7pfy1pRtwQzL?=
 =?us-ascii?Q?kBPh+01d/3c2aL0fTN5NwM0yOFE6Oz/Zyi+eAaELeoAcfE24fI0FEfXqFxFu?=
 =?us-ascii?Q?+PoBvSIAvuEjJZAleXZ8e+EV3CWbkH6EK9TZ7zW6xhjc9tAsjV7ZE+0s0U/Y?=
 =?us-ascii?Q?sYmEoPytMrbXs/QGZw86I/0SjpvXHBZRSmwYqczepL3T67TaJ8u4vKXo4djo?=
 =?us-ascii?Q?d8zM8u6GEsFA3WJ48i/qAJ/KZOLq1IQg+leKwwifn6yu73wpaqmAdZ53EDyC?=
 =?us-ascii?Q?oEMY3+5Uq+iCPXowkQ3573NY+4xapTFt4UuRleQdEnOILsZpqCafgxymHuuS?=
 =?us-ascii?Q?YK0st0xxdEaNdwJqMA8FNZKK2MnUJVWDjL90I6c0l6wr1X+AkN38vmWMV5tQ?=
 =?us-ascii?Q?X4pn2+G7oSv5/7g+fUxL6hbLX+Nt0HXu99iW3THWgx2kL0miZEgznVjlUnqc?=
 =?us-ascii?Q?j3CPqyOSzAyPYzNI9+Mkb48C2i3K+l8J2zRR+aDpt0ZKnNPZHLG+giZMig/P?=
 =?us-ascii?Q?/qW/HAH7uace3xkCZu33gRiAdCTthegXjh+mkMy+pOIkC4lspIJgvymlksPb?=
 =?us-ascii?Q?rV7zAS03gQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a00229f0-655c-4c19-77cc-08da383c08a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2022 19:32:51.9767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u3U3piyxN6dIZMtaocJylW4eGUMWBT2JgBvxghgf0aVKeTLKcBDskEEB7J7Jw3+C8rHK9Mwwn9f1XwV0bXYMcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1213
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
> On Tue, May 17, 2022 at 02:04:29AM -0700, longli@linuxonhyperv.com wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > The system chooses default 64K page size if the device does not
> > specify the max page size the device can handle for DMA. This do not
> > work well when device is registering large chunk of memory in that a
> > large page size is more efficient.
> >
> > Set it to the maximum hardware supported page size.
>=20
> For RDMA devices this should be set to the largest segment size an ib_sge=
 can
> take in when posting work. It should not be the page size of MR. 2M is a =
weird
> number for that, are you sure it is right?

Yes, this is the maximum page size used in hardware page tables.

Long

>=20
> Jason
