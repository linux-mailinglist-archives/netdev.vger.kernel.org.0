Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B909252B227
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiERGOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiERGOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:14:30 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazlp170100000.outbound.protection.outlook.com [IPv6:2a01:111:f403:c111::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5D64D9E7;
        Tue, 17 May 2022 23:14:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDGCUjYHeVl3zC+m9LnkjOb0qLa4afitdCJshIsIezW6RwPpsdc3RtR58NR9n0Ytb7O5BAppMlSSqHSORwFsyLeN85N6j2IcM9ieVTGL/YkELw48foC+2arM+ZdfewE63iJZaUGBAfS7wNU7T03UiIQ2GmbRE/nLNFi4/kZYfWXHQk3lGegqMRak7nlHWI0E++glQam7B0lIJ57eC25DPh6qlpEeSWzYvj1x601RN40+1MIut+U3956AwlSX4+UVYQy+oDGfqRQML6TPyTchYjwzEiuvfvP63gS1oyD1yhsf31YgyIB/bTXJVQBirYlvmleJ7Q4P3mNs7VKY77je8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6MYFygRsH+rbiDd0hkmJYkZ91EFGnYJDzRFk9TihjaA=;
 b=d0v8vT/7oU8Kx+t9zxzP6krM7BdQfZbLhVI+qZeuU8FQcU/CnY7pJow16dvyk+vMxhsolXsQ6NyrWLRGZnymBTEPtHLEAxdTPGqVYuAMZBnIZ4iMElDBz/+jjh1vUyimv6V99qJPqkQzGI+YwF4WWDaYFujsOACvkG3ZsRaEZlFzCfTn0ZjPEhuXIH8bKVVz7F5xLVn0kO/TgsDcbcGs9redwrbuGqExROOs0OnP1iut767XH1yRfDrCe5jI0eQnqsbecejdy7+ycVDeyHbKWopqVoMGB4RGDw28thK238ibiYfSFBsdx4NGqUkGDWvrGUze/wkC8dL2qQtCL33w0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6MYFygRsH+rbiDd0hkmJYkZ91EFGnYJDzRFk9TihjaA=;
 b=CGhhn9gzAwJqOI7x8peehaA3PlZDMwDSoo66hqJwDnU4Nsg4a2CZDURnYS5pFZpam5BHKGjjfsARNpxne009kAHMdzjuY6EUKPhNPt6qF9JyZD7hxIAP+yb6iv9OUySZA/8qrdjX+vQsKZffyrKppCpapuRfzak1KHeEhMAP+Ro=
Received: from BL1PR21MB3283.namprd21.prod.outlook.com (2603:10b6:208:39b::8)
 by LV2PR21MB3252.namprd21.prod.outlook.com (2603:10b6:408:172::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.5; Wed, 18 May
 2022 05:59:00 +0000
Received: from BL1PR21MB3283.namprd21.prod.outlook.com
 ([fe80::e0d1:ed2f:325a:8393]) by BL1PR21MB3283.namprd21.prod.outlook.com
 ([fe80::e0d1:ed2f:325a:8393%9]) with mapi id 15.20.5273.005; Wed, 18 May 2022
 05:59:00 +0000
From:   Ajay Sharma <sharmaajay@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Long Li <longli@microsoft.com>
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
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>
Subject: RE: [EXTERNAL] Re: [PATCH 05/12] net: mana: Set the DMA device max
 page size
Thread-Topic: [EXTERNAL] Re: [PATCH 05/12] net: mana: Set the DMA device max
 page size
Thread-Index: AQHYac0t/cR6HA52CUOHz8pr+lzroa0jKeeAgABLXKCAAAGZgIAABm1QgABEpQCAAFjD8A==
Date:   Wed, 18 May 2022 05:59:00 +0000
Message-ID: <BL1PR21MB3283790E8270ED6C639AAB0DD6D19@BL1PR21MB3283.namprd21.prod.outlook.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
 <1652778276-2986-6-git-send-email-longli@linuxonhyperv.com>
 <20220517145949.GH63055@ziepe.ca>
 <PH7PR21MB3263EFA8F624F681C3B57636CECE9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220517193515.GN63055@ziepe.ca>
 <PH7PR21MB3263C44368F02B8AF8521C4ACECE9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220518000356.GO63055@ziepe.ca>
In-Reply-To: <20220518000356.GO63055@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=101d5414-e489-41f6-83e8-238ce5201743;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-18T05:21:38Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82f2c23e-42f2-4902-479b-08da3893813c
x-ms-traffictypediagnostic: LV2PR21MB3252:EE_
x-microsoft-antispam-prvs: <LV2PR21MB32525A0672ABEE6A8774A713D6D19@LV2PR21MB3252.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xbGXHN367BPdShIz9RzJEC377nzSa3ylbHilFlxcNwoUKHwsBTOXa4uyoD5hoIoO5uifX9u6WLP0Q41N8YgQ/NuVkqb1xCyyipGUGoVy6MZhcnkoJfbS5czC2T48Br1V6spPxOhfaU/BafMWOD0ClqxgimFndLemX2VBiUpJJLJhK6N+BNYnGykALYIn1JYA15S98GL+c+R37fpZ3VwVDOEwgnPXSST8eUixSO3lJ/E7h5h3i05cbVaMcrbHAwOJzjaBrh+P2u3mTMXdFOQpevyeKVluuCJzWiURY6GJoGFe24A+VUeldhFTBi+9T0DlIMpYxKKK0QGP6FfEfpymkffnmBRhk+88xwtL93Gnq9v1ZE6jVhr+1OwPgBL2rVA7cq50r5WE3GLWozRjyiWP7VKQGwuNoepoUVdQVURFEYVg91HQ9KRswq5mxMAaBRFiS+f8goOqqDYP6cTj18HGWLd5+3lXhaqRFKtM1Wl0IUgBjD/gLCPEWrtko8GU1Ll1j9XO+HYvbd6F4IdcbHOSFNx3O0/O/EO5W8qRACt5NeS8HIXMk5VfJReKRqs3yGGqdaypBPWc+zr8GkWe7N2OYAlCrTphCdOWmBvAd0vbNs4ht55WszAcbeOQYoUiQA1R3vz9cG/k5RMCP5pKuNZdOM4guzg1/1wOe8LJsYXoVP+pq1VOJnQiD3wH44R35X7wFo/UYAf/bofkYOIKpi+qjzUvmigtmER8CZx7oftOJWhEOFyDm97rcHS2lB4FMUHD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR21MB3283.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(6636002)(7416002)(110136005)(38100700002)(186003)(2906002)(316002)(8990500004)(54906003)(38070700005)(966005)(55016003)(7696005)(53546011)(8936002)(52536014)(5660300002)(33656002)(107886003)(4326008)(9686003)(83380400001)(6506007)(82950400001)(71200400001)(8676002)(10290500003)(508600001)(82960400001)(122000001)(66556008)(64756008)(66446008)(66476007)(76116006)(66946007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I/Jtonvd9nLxCEKDYR5fJuh6/1LDl6/PN1P9JP00+8ueTbdgiRFyb3JzuoiA?=
 =?us-ascii?Q?QZ0xHG/2QBblkk5Jh3vc0UgEXpECYVwxV+pKOVQ9XOUASwbcejUNG/u23YWg?=
 =?us-ascii?Q?tTmFB9ISH8RoskAKWuKR2HpbGbKARDutNggtDCjTZBeG9o5OMLqjKSn6s++p?=
 =?us-ascii?Q?uvb0fdbS4S4tgd4XJ9pc60y43YFHoWaBLjoN3AVeX/bQIbCIRNOjkKet141B?=
 =?us-ascii?Q?VhHPuQkN2drQ5inXIRaDBL+oTVKxu8QC3fy4oiKhifkHYQPWfikEVVrb/RcK?=
 =?us-ascii?Q?ZvDEkitieJ3yyHxP4QBEm2OlKtWt6fLX2tHbp9nDnmrNUUuFgy8fGiH92msd?=
 =?us-ascii?Q?0htTiswfIojPiDDDXcOror+eQgc8aiw1VSyb3VbyO0lD6kNNBc2O38jhcYgB?=
 =?us-ascii?Q?tIcoh42vTdxEFx39s7CItfGYXHBRZOUvsuJ6D1F/CIp7UPDp9YowiLV0FNc0?=
 =?us-ascii?Q?CF/JJdSnQHtnloff3w7qHkEaJtWYyMWg1J12KwwQKZOtRgebn9wW+5Kaeqwn?=
 =?us-ascii?Q?wWcXkucQdoTYoo7cLwT4TzCLBLsQ+iHkGwxfvesQLQeMyWxkiO5GsXlvn70c?=
 =?us-ascii?Q?xLjqgXKDFUZGFEg6K3pRyBW3Xak34V+QRkOTv19ulB9JSYu23RvSjgueQg56?=
 =?us-ascii?Q?nzmpRlQWIvwVeIX2MK06pHH1BeNKU7WqaNj7SNAcDFtZR1oAJDhgX0+DN8/e?=
 =?us-ascii?Q?9M8p7+tryM718pQGFysN4uBgiS7bJx7XzEm0Pc6h3BpXY3dROdRUw/5wsPkr?=
 =?us-ascii?Q?ggEerdFrusnRzmIy8f14K+uFqUc/c9r1R1pUDBgc0x29WZPqXzUx5MVeMEqR?=
 =?us-ascii?Q?au7uxgCOp674xz1CYaWFHMDsJCMMpkO23qHpc39pVsrRhQoU1PHGpNMiB9r/?=
 =?us-ascii?Q?hEukJPbdjqJtppCzzdbRUvc0SZnm/IBDgQ/lnLrnSWasAg2hdQOwG8Y9+paS?=
 =?us-ascii?Q?L8qGutXIbj5W1jUnoj7y0/jcSVZNqLF/3Jae3uvRRKgLWIfYP8qgBo5nQXvU?=
 =?us-ascii?Q?bVJivw7L8tHtbfg/Y8LQGH1cdNhehWb3maXEjh1Cqqm+CgEosqQHWeqtIfLr?=
 =?us-ascii?Q?TySe7zNb3OSw8SCHM9oNcOL0Bcsj1I5H7tOKSVRMcPI2ugxk40BajUUvzRcM?=
 =?us-ascii?Q?NSDWXFD9JPZV/7BOQX7TfOn989HVxnaw7vJQAOeBfKyftR3+w8WQukLKL8LW?=
 =?us-ascii?Q?zPDZK/RiGRQvVY73m4YSQpUOUxC2KzFKsvQ+Vqh+vEcNbmRqwDph1N4M2G5p?=
 =?us-ascii?Q?uyd8EzXih+VCwhfPJJxU6hfYIT0QX3dsCO1+zQSYHCi2MBFKM/hd59IYIugX?=
 =?us-ascii?Q?JXJmUIeSgufGyEWIGf+ZPR4VhcfcpMvKRKjPFXAdTma0kpFxSljxzM5nwsMa?=
 =?us-ascii?Q?d5Aao7NRKyxBOSq4M3TFC12JXPcsXTbpuitdOlZqRg5MuxvKgvJg6aj9b8pa?=
 =?us-ascii?Q?F/N1dt9TJ0gu4ole2sXHOVFsEmMHs3rCF5vJs1gf5OzYUkG04ExX1+XUUB90?=
 =?us-ascii?Q?ZrbL3tZV1ClX1mnGXcbDETevdJVqOeIduRFfdugcehD5ltgM7QWHLGi9Mlbw?=
 =?us-ascii?Q?rSnmXYtRmHQ9ecBSjEeIccIt4KaqEERiiRIARrTKkkCs2ktXpKkGSSrTtR92?=
 =?us-ascii?Q?gqsxqQIzSCafmLUrGlw78gV7F6pyyoo70kLmmVdeRHqfqAGM9q9mTcIRNozv?=
 =?us-ascii?Q?fKNyJThmKLYW3VZTVpPjm082Pi83LfEE7wa/FiU7hELWHqMk8BUk4t3nTGyx?=
 =?us-ascii?Q?OBhRWZrGWA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR21MB3283.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f2c23e-42f2-4902-479b-08da3893813c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 05:59:00.5205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z4BXomu9S+lO/0fk2jpEiWZi+yi/mDhoWxEN/P9EImxVcMOq9h+jWMy4rxKIqV6gbp+jJBRxTgDTfDbJYV9gkFddZJVYB1qVz2PpQVCR17c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3252
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Long.=20
Hello Jason,
I am the author of the patch.
To your comment below :=20
" As I've already said, you are supposed to set the value that limits to ib=
_sge and *NOT* the value that is related to ib_umem_find_best_pgsz. It is u=
sually 2G because the ib_sge's typically work on a 32 bit length."

The ib_sge is limited by the __sg_alloc_table_from_pages() which uses ib_dm=
a_max_seg_size() which is what is set by the eth driver using dma_set_max_s=
eg_size() . Currently our hw does not support PTEs larger than 2M.=20

So ib_umem_find_best_pgsz()  takes as an input PG_SZ_BITMAP .  The bitmap h=
as all the bits set for the page sizes supported by the HW.

#define PAGE_SZ_BM (SZ_4K | SZ_8K | SZ_16K | SZ_32K | SZ_64K | SZ_128K \
		    | SZ_256K | SZ_512K | SZ_1M | SZ_2M)

 Are you suggesting we are too restrictive in the bitmap  we are passing ? =
or that we should not set this bitmap let the function choose default ?

Regards,
Ajay

-----Original Message-----
From: Jason Gunthorpe <jgg@ziepe.ca>=20
Sent: Tuesday, May 17, 2022 5:04 PM
To: Long Li <longli@microsoft.com>
Cc: Ajay Sharma <sharmaajay@microsoft.com>; KY Srinivasan <kys@microsoft.co=
m>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@mic=
rosoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui <decui@microsoft.com>=
; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; =
Paolo Abeni <pabeni@redhat.com>; Leon Romanovsky <leon@kernel.org>; linux-h=
yperv@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org=
; linux-rdma@vger.kernel.org
Subject: [EXTERNAL] Re: [PATCH 05/12] net: mana: Set the DMA device max pag=
e size

[You don't often get email from jgg@ziepe.ca. Learn why this is important a=
t https://aka.ms/LearnAboutSenderIdentification.]

On Tue, May 17, 2022 at 08:04:58PM +0000, Long Li wrote:
> > Subject: Re: [PATCH 05/12] net: mana: Set the DMA device max page=20
> > size
> >
> > On Tue, May 17, 2022 at 07:32:51PM +0000, Long Li wrote:
> > > > Subject: Re: [PATCH 05/12] net: mana: Set the DMA device max=20
> > > > page size
> > > >
> > > > On Tue, May 17, 2022 at 02:04:29AM -0700,=20
> > > > longli@linuxonhyperv.com
> > wrote:
> > > > > From: Long Li <longli@microsoft.com>
> > > > >
> > > > > The system chooses default 64K page size if the device does=20
> > > > > not specify the max page size the device can handle for DMA.=20
> > > > > This do not work well when device is registering large chunk=20
> > > > > of memory in that a large page size is more efficient.
> > > > >
> > > > > Set it to the maximum hardware supported page size.
> > > >
> > > > For RDMA devices this should be set to the largest segment size=20
> > > > an ib_sge can take in when posting work. It should not be the=20
> > > > page size of MR. 2M is a weird number for that, are you sure it is =
right?
> > >
> > > Yes, this is the maximum page size used in hardware page tables.
> >
> > As I said, it should be the size of the sge in the WQE, not the=20
> > "hardware page tables"
>
> This driver uses the following code to figure out the largest page=20
> size for memory registration with hardware:
>
> page_sz =3D ib_umem_find_best_pgsz(mr->umem, PAGE_SZ_BM, iova);
>
> In this function, mr->umem is created with ib_dma_max_seg_size() as=20
> its max segment size when creating its sgtable.
>
> The purpose of setting DMA page size to 2M is to make sure this=20
> function returns the largest possible MR size that the hardware can=20
> take. Otherwise, this function will return 64k: the default DMA size.

As I've already said, you are supposed to set the value that limits to ib_s=
ge and *NOT* the value that is related to ib_umem_find_best_pgsz. It is usu=
ally 2G because the ib_sge's typically work on a 32 bit length.

Jason
