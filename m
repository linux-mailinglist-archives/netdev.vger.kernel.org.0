Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3946B8A28
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjCNFPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCNFPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:15:06 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2075.outbound.protection.outlook.com [40.107.95.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9B492245;
        Mon, 13 Mar 2023 22:15:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmjwz9kVRceKW0UScgLTeUocnAMkw4TlVctarXqHxvhRY9QkDTUVg5oZyjNkfvm+vZ83nRNrw3CTnuuNHGzXxe0VR+0yUo9ppQUCCxeaTpJ8Bu4ABmZKWwZ7vUCRkURD7cRL4dsKwtNZ1z6cbqunG7NOhufJ7/UnGlZ1OyhkN5Lf9V0ioyBX+hU/ruAEKXa7RvFKjVKmnxC0/VfL+jBSqp7mA7fPwECsiA/W2lvvnSI2jylsb7oMVjKbgBaOHQAw6yyynW8UmDF32gH4hKf6qlPfTlV9hMDYsU1ks/pWLqVnj/23QpdZlzcWW6AdVRmTygiyrNUswtuEE8XpsyJXWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8KTUa3VpBkrSYTcw3zBe+0vTYuvyjAUqLW2Y8wYQADY=;
 b=DN4d1N588W9AsfPkAQl2WrL7N9Zif02tYZic+W5unC00WVScOLnrLXEbKbH5/yS3DggaetmWxlD6opeM7EbyJee15WWto/gw4obBNwH98kaHZ8lbKc7d/M/zj0etRPyt8Y8d2RTeHFa2GlsHUgSN8N/A1xLNeEzyL4zriTI+r2woenrdhK6OxHtvGPohiraj7qqx+QtcQWRROBTpRot3x6cXlPYjBpwpowDQfEFR8DjQzHAMJY8W/pTJpyYj5UZ/0saMYR8BTVW7KrZjOhV/epvoRZ4ajfyWx5Ap9KRcPbje9ugdmAPftA0wg2wqHGJYh0XH6nY/Uqd/8Ofnyh25Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KTUa3VpBkrSYTcw3zBe+0vTYuvyjAUqLW2Y8wYQADY=;
 b=0u+1tX2Wu3HEOwQbC1dftqcdauTZtZxZkWwIHwTEWV34rSrMTDvfBY33+AWcBZz5QRr6hvh25uvJ59vnwCYF3bcjj9C0VBzqYqlOEgHqEhemIz1TnRpJZlweeBGPkot71QcNOvofpkR8icredYwTOIKnm21sB1MQXBdyfkCm9zs=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by PH8PR12MB6793.namprd12.prod.outlook.com (2603:10b6:510:1c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 05:15:01 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::8709:da90:3d87:cdb2]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::8709:da90:3d87:cdb2%7]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 05:15:01 +0000
From:   "Katakam, Harini" <harini.katakam@amd.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Jonas Suhr Christensen <jsc@umbraculum.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        huangjunxian <huangjunxian6@hisilicon.com>,
        Wang Qing <wangqing@vivo.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Esben Haabendal <esben@geanix.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Neeli, Srinivas" <srinivas.neeli@amd.com>
Subject: RE: [PATCH net v2 1/2] net: ll_temac: Fix DMA resources leak
Thread-Topic: [PATCH net v2 1/2] net: ll_temac: Fix DMA resources leak
Thread-Index: AQHZOZ4bIaLXD56kTU6BDUgiXUw8vK7DWxGAgAACc4CAAHb+AIA1bdoAgAADVwCAAK4eMA==
Date:   Tue, 14 Mar 2023 05:15:01 +0000
Message-ID: <BYAPR12MB47736214A6B4AAF524752A8B9EBE9@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20230205201130.11303-1-jsc@umbraculum.org>
        <20230205201130.11303-2-jsc@umbraculum.org>
        <5314e0ba3a728787299ca46a60b0a2da5e8ab23a.camel@redhat.com>
        <135b671b1b76978fb147d5fee1e1b922e2c61f26.camel@redhat.com>
        <20230207104204.200da48a@kernel.org>
        <bd639016-8a9c-4479-83b4-32306ad734ac@app.fastmail.com>
 <20230313114858.54828dda@kernel.org>
In-Reply-To: <20230313114858.54828dda@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4773:EE_|PH8PR12MB6793:EE_
x-ms-office365-filtering-correlation-id: 6c674a75-d2c7-485b-c42f-08db244b0fe1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s7n0YybX7sGABdy2OLThvkYDR9HmPDmmvsC6JeSw2K0vwTPW9DNM3ifGP5JEu6WM46t0Vi7wKzaskw4iAiUa5CaSBxVMJlOe/TJZflHHJh3MOAYunYOkmuG7+NsG8K+8JRH7dkuevsNjL5I88SKy0OreJLj+XklbhZnOBFsABtYiFwHux08cHoAY/kpo+i0Ah+kogs7/qlZZl9c9r8u6Vy7AeRzIfgNVsfJVgmR1V3dcTp+PF2+mwVzoJHPfMTJQmPQRSwZzz6YmLmQY/2sMSGXMHX7qJoS5DLHA6S8KRFlugb7ALykbfjshGedT3EkMjDODRxEkgNsI4ty43cBtqYVy3ZNSPecGrsNbxj6Tpqz/CUEIW2I+IyrTKeVsPleBuNzXsLCuOEhHKra303z+IiS1D1LMissKE30W70bhswHCqMhvUSRvua4MYV5FDPHPV5IGUZV505VteZ4GRwnO1ONXwHMjCRLD9G3yJ6bd0Wwy5/nxTPOGR27vHzQTBqZ4Se91yXT65L1/wkJ6I6bAcupJTptnJoR8g5+1smsgTHjQsecNjfZHv3FXSUu2/f8+WCsVpjM7HiJoM99RzZm3xIYtQnY54PW/JX27E5uFvW4tB5fNzT0T3PMnEhoWlVpZzim1b2vhdTRNJvQmxIdh+dGVOTNll4khzPwA6c8vec+c4PNRFr09sLc1FiGMyfH3N8zocxLTEvyRnMDxXamI7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199018)(33656002)(110136005)(316002)(83380400001)(54906003)(55016003)(26005)(71200400001)(7696005)(6506007)(478600001)(53546011)(9686003)(186003)(8936002)(52536014)(5660300002)(7416002)(41300700001)(38070700005)(2906002)(86362001)(64756008)(66446008)(66476007)(66556008)(4326008)(8676002)(66946007)(76116006)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vIPgAbsGWDbM/vByqejG1dOJfCoHlFGWrsvJqMrGilMl3W+79g+OnYNmHIVt?=
 =?us-ascii?Q?kV7q1xSlfRcvr1VfNVMgGm7PltzGBYPJd8Q478atm47KbsXxpY1vR04YXWiv?=
 =?us-ascii?Q?SzufYTkoMPsCZnN269Tjd8mUKzDG3QfxIkAzlgu9zVBIPAqpx2VFI9xaqBUr?=
 =?us-ascii?Q?lKAbia3kzFYds7dV2sKpLft/iJGQ8lQS/3zcRhuIhOigLKz4IRnJJbQALPKA?=
 =?us-ascii?Q?PXM/3KseUDcmpjj7LOzjGyrBkE9q0FuCIdhGNyIQHB7ghEZBssguaq5WAkrb?=
 =?us-ascii?Q?WmzkMwRRVMd18WVmJhR/QT+ypIm/eSSom3ZORXCbAtM+0OprAfs9TBqrp7vr?=
 =?us-ascii?Q?pnA2UbZjzO19J+xNvQ9tDroZpS6Wxb52KpJasdMUvy+mxWMJThQRYr7zn+/9?=
 =?us-ascii?Q?gBiylQJYBMFry3W7OMzfkLzfOfQRZ8WZc3t6YNvjThtAMjkzYBPiNf2kOslX?=
 =?us-ascii?Q?ciKv5KwWemQ3szFPIf9HuMFegWFa62pcArVkL4+CyAOn7nObuO9zxw0wjm+N?=
 =?us-ascii?Q?F7T5PMw42aGIio0AU+hwUWJufUwvkWSlYmxZwjVi1hFBejws+W/TXGewbrew?=
 =?us-ascii?Q?ztVs/PxeFmy2rTzt/FccnckilpmGRZ03L3E0iadorDKnR/d9Wig8CMY0ORzL?=
 =?us-ascii?Q?JVlT2VtrsHnFxeFQx8a/ZerdOhK1X6NsK3uOhVmdEOTdE3Gsv0Xmev6+I+I2?=
 =?us-ascii?Q?q3OqVTG89oJhiRTY9GPjo8kWZN5Ckt355xWOJsleVIo152+GvcdxA7AzaQns?=
 =?us-ascii?Q?fu6IMVseVRXVRjhOXrYrxLX8zQ2quvGzbcToDyRmAlrNzit0/SgW4aWbyU4s?=
 =?us-ascii?Q?QD4cdvcqhztA+tW4p3R3xkg2nr8SAF10wmacpRiyXllhYXKLCEiYjFGrtAn5?=
 =?us-ascii?Q?1z1hhqEmdUctV8T9vkkwAT1BbE023/obCt8dBcdxTy77LZzAqesKq6Wk8Blm?=
 =?us-ascii?Q?8hvl4LfOvQ9M3HQ0HSjhCGncHWFqrnLs5Wk+aPGEJ1SHydgZvypZEspNMKJm?=
 =?us-ascii?Q?wcqSc9fCraA46JCPSivemEjA8obrYD7triM46ma48D5WeHnAiDCiV3YrahPz?=
 =?us-ascii?Q?Q2wq9+yyotVhGAWmpbLhNsBClQxUmPe4HeKcNHzlPVI748fOojt2Lpk+mynL?=
 =?us-ascii?Q?xxLwV6L0cW0FMn1vU6rON6En6eKXlVRAhuwDMpkH6xKrMY95/mHcfBYuZlqD?=
 =?us-ascii?Q?Z7zu44yRK08kbjLJ3jP1HdclYDBtt8sTwXQGF7/en2Bq3NUvv+7OYirvktrb?=
 =?us-ascii?Q?j7lD7vn59TPpHX52K8Mu5wFxg1fn03/yEUO95+rWjaHS2ku66qpJtmj8E9vb?=
 =?us-ascii?Q?uFDsiTZRUVaBkTkze5l4o1pXKlLDV7s20arfyK9D1TVPg9tOzMkZg9c6O9Qs?=
 =?us-ascii?Q?gnX/NY+2sBGkZ8oFIIOi8X7v+DjSlJ8W4xxmwb4E0nNSSAnLtqOTvb9J6v/U?=
 =?us-ascii?Q?CYTiIkAEGUElif4VSX1G4lYxCqxdDfJ6kPSrDkynn8n2N7qag97YufmHW5ss?=
 =?us-ascii?Q?4o3Cah5aDKmnv/W/n2VsBPEASGTc3bw1F0Z6iWjAJwCNXIrWukwdvirk37YL?=
 =?us-ascii?Q?pSZPfsSD/dS5T23Sks8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c674a75-d2c7-485b-c42f-08db244b0fe1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 05:15:01.0189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Rb/+RBgJYV/5FFCY76YyzUbx4hfqSbBvk95YykCsPw2CDUuIcJ57+Y7ysOXaMnU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6793
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Jonas,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, March 14, 2023 12:19 AM
> To: Jonas Suhr Christensen <jsc@umbraculum.org>; Katakam, Harini
> <harini.katakam@amd.com>
> Cc: Paolo Abeni <pabeni@redhat.com>; netdev@vger.kernel.org; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Michal Simek <michal.simek@xilinx.com>; Haoyue Xu
> <xuhaoyue1@hisilicon.com>; huangjunxian <huangjunxian6@hisilicon.com>;
> Wang Qing <wangqing@vivo.com>; Yang Yingliang
> <yangyingliang@huawei.com>; Esben Haabendal <esben@geanix.com>;
> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net v2 1/2] net: ll_temac: Fix DMA resources leak
>=20
> On Mon, 13 Mar 2023 19:37:00 +0100 Jonas Suhr Christensen wrote:
> > On Tue, Feb 7, 2023, at 19:42, Jakub Kicinski wrote:
> > > On Tue, 07 Feb 2023 12:36:11 +0100 Paolo Abeni wrote:
> > >> You can either try change to phys type to __be32 (likely not
> > >> suitable for -net and possibly can introduce even more warnings
> > >> elsewhere)
> > >
> > > FWIW that seems like the best option to me as well. Let's ignore the
> > > sparse warning for v3 and try to switch phys to __be32 in a separate
> > > patch for net-next. No point adding force casts just to have to
> > > remove them a week later, given how prevalent the problem is.
> > >
> > >> or explicitly cast the argument.
> >
> > I no longer have access to the hardware, so I'm not rewriting the
> > batch. Feel free to take ownership of it and fix what's needed.
>=20
> Ack.
>=20
> Harini, are you the designated maintainer for this driver? Could you add =
a
> MAINTAINERS entry for it? I don't see one right now.
> And possibly pick up these patches / fix the problem, if you have the cyc=
les?

Sure, Srinivas (cced) will pick up this series and send a v3.
I'll get back on the state of this IP/driver for the maintainers list. Will=
 include
that patch in the beginning of the series as well.

Regards,
Harini
