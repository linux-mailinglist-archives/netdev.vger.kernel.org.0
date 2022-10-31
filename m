Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A53613E44
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 20:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJaTca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 15:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiJaTc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 15:32:28 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022019.outbound.protection.outlook.com [40.93.200.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E937F12611;
        Mon, 31 Oct 2022 12:32:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Efb1+Q4kpKRWKsAVwikgsqBQ0WTlKPfROJIukHiEEiSC9hN72R/8BdmBAR0tz4uAnuLXdTkn8yen5W1qk14h6Z+Eps7QjThL1+vxEBAQ3mrfuR+lpICI+HB4vq9ajM/GwTH9KZ2AJSWpionyruUDSHEQJSdQSdVtzAil6Oen9Q6+vRi3HV07Aobo+z5T6UNMfioWE8dOVaaBCgZQzs9hWOpGDFdM5I7PiovJwVv+a+KK2hY+u5bEiKJGCmKopmGCRr4jwRDM41fbtw8sp6K3Uhu3HAUuUTgRAoOtzRQG7diGr8+WYcyn/HxI0U+AQ9Tn520/5593wlwOjd83qGsUPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WoJd3NwrOihWxFfI8MgAYV7mg4ZYLNMP7f4gcqaYU6Q=;
 b=VhQktHXMS2zqzEfV/9Vkq51wzRA+1FrYvKtE/sfR2ulGLro/ZbwHX83r+u1Gc0CCXfq/8OBoKNdkwc3LJCel2KkIRwojk+dxlgg00Vy8UhkOuVhTWTBR3deJQyGl8p/xvzKzpWk0IyGNNeLQ00Vm9AL2K53bx/MpzbloUg7ttW9va/FkzdS3W6ITbRqlCdAvXsr/8KB6TPlvCLaN4xGfnNxNFIarpyLgTqSVix/8c3Jv14e1RBgJkWZO234je79r/u3AOuWZY5e+4Tr7FQoFpZz+3+R/lsr9SmSDj+prQl+usPNfGWruKXk1jTzbj7r5igKeaHRgI//HQaKXgdje/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoJd3NwrOihWxFfI8MgAYV7mg4ZYLNMP7f4gcqaYU6Q=;
 b=E8FSwbpi9fc/OuyE9NhzESNLQN9HpbEgIywix9Ds68Q76CfC/NxF1+r5o+6Z6ELj1ho0+WpqauCnI3LXistqrdrhz2n/1XLWngldTVRcm1Zya0kSrIcVGg9Fpd8NHlVtP4F7uuy6odMvAISMc55G+Gu811AibFsKwb5gTFs+oS0=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by DM4PR21MB3392.namprd21.prod.outlook.com (2603:10b6:8:6c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.9; Mon, 31 Oct
 2022 19:32:24 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::4496:4f7b:c8d9:4621]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::4496:4f7b:c8d9:4621%7]) with mapi id 15.20.5813.000; Mon, 31 Oct 2022
 19:32:24 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
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
Subject: RE: [Patch v9 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v9 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHY5al6hxN6sUEdtEG9iC3l/s+gkK4kFzmAgAA3TbA=
Date:   Mon, 31 Oct 2022 19:32:24 +0000
Message-ID: <PH7PR21MB3263C4980C0A8AF204B68F1FCE379@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1666396889-31288-1-git-send-email-longli@linuxonhyperv.com>
 <1666396889-31288-13-git-send-email-longli@linuxonhyperv.com>
 <Y1wO27F3OVqre/iM@nvidia.com>
In-Reply-To: <Y1wO27F3OVqre/iM@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9d8eee8a-ea90-4ebd-81f3-8aeb544eb11b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-28T20:36:15Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|DM4PR21MB3392:EE_
x-ms-office365-filtering-correlation-id: 176c0f99-f6c8-4f18-4412-08dabb76a341
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YGt3ItiwZ6DiX+fANWXQarshUaGRLE7cUpOX7myVJT/2RAj92rPXOOiCi6SyMMt9Pq/hh46/12l66JnaMXHMzzmROQ0MkfdZunw3hM9IzDCar8+q2J8ZFFx84nodpFscMJ5nh1VwbFRO8JrxDA92NTMrdB7PsBMbW3Behkf67zJHzUsnlax24JFqSC5RVTi7VpzRyanm8JaKgoYPj2U6RzzTirJ2PQcrgWpiCsEsqMqIsZbz3JdDX50a2UxIZaYlakXVA7YcOXkc8m05IKl7mqfb9YB751xbFpB7UeTJ8mvy+Nb72LC4IFBkCH03aFTKQLEODYJqGnn4YiH6WJ+B16tSQzYrQPfhN9Kw7pWRRF2wfuPOhUG1wOczpzZSpTnQVewurtjoxv4IUvKp0SacJr6b723229Q24aD5LtfBkQwrWzf5wEzTiMN55H+J9l53vuVLGyI19TCOe1WonvjRtml/ejaBf/f07Oo/DYMDEocmOlrHb2pKPUQWO61QTGlggv3VqXwHdXFw0SAJRhf5fLNoFmaGxLgTf6KwjX290dr6O2Ij5Fiep2f3RPXIj+QzQFraX43neIgMOGX/H69FEV4ZPrNtv6vkaog4wduy90Qv3z6EL2EcO8setDXtNpOxSHsui3/5Wm8m8PxxzhuXWjHCfViRezblwzZPDSpvspPoOkLLvaLcBbyy7ZBbdtpngHmQF3WM7Jsp73C0jRZToWythCT0kuI/lZAg4BgT3FbG0svaMRerhWFszJ2HaFoVjaom0XtQqWUcnJTBxL4nb/10+USZBczrQDWXDLE9DrzI7SKfvd2Sn48F2dNaoFqB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(47530400004)(451199015)(186003)(7416002)(38070700005)(71200400001)(478600001)(316002)(10290500003)(64756008)(52536014)(6916009)(82950400001)(54906003)(82960400001)(8990500004)(83380400001)(4326008)(66556008)(8936002)(7696005)(66476007)(8676002)(6506007)(66446008)(66946007)(33656002)(41300700001)(122000001)(5660300002)(2906002)(38100700002)(55016003)(26005)(9686003)(86362001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?th0ilbhmFz7LS899/uBMptYPXpa+djSvYGfnHgi0bz9cIBzt3DxNC1pBv9ZZ?=
 =?us-ascii?Q?on1Whz8eOmnbwM8Wk97NxI6Gn5LY+CKf3qOUNjPhc4gQ31mIry0/EWx39RAr?=
 =?us-ascii?Q?qsClMkDZA1tqdSmnJwK5yRyByCk6KWu1EQqQWvrtnWMD3tRR5Qzkzo8TWuNu?=
 =?us-ascii?Q?R9t2vngRPo4V9TsIkGOEgG7n2h90dkShE48NE9o4iELPPBffeLodpInU5tB9?=
 =?us-ascii?Q?V3u3pBD3cWx8yLQ03wxW/jMKgSiBNgvYNfpNcd5FHGzSDYDfKXwog/llUcjb?=
 =?us-ascii?Q?sFpmfsVEsEjdJLN3GSpPqQPGNkGuGz7xv1YosJ8qFoOQbI1gl2tuhZT8XAQK?=
 =?us-ascii?Q?vdi/vp0bHLqTTqQB/8vhlUVBMe9dbgV8DhtjYdDmafX3+zr+/8DSp9NO3Z9a?=
 =?us-ascii?Q?svc02VZczyow0OcFQxybhzdUK32ua8jnkvNCq+5yp3MRPjNCAdTNBlZ6Z4DP?=
 =?us-ascii?Q?eFg/XjLyvI3mZeJ+VDFvM4CsXEiSY9SUiqvy+OfnhbrYN3p2ZrIQCDSUBBE0?=
 =?us-ascii?Q?3NkT6SfxEc+Qry6jO/VQ/DcUUUPCOYVBnkW5H4R7T0L+M7xessuHeiwY3K/M?=
 =?us-ascii?Q?1L4yumclA6f7NIZKSqSjjg1aQbknQzzCeXwk4p/ocmqtmwQKkf7G8fhULmjd?=
 =?us-ascii?Q?I/YecI+KtVo+rNsiuURHdFJ51Z3DsQKz3R2J8TuiKitanPiac7Syj9TWV0Zr?=
 =?us-ascii?Q?VYn37KVF+TxL/rpYkPRki0X8VIoEsqiuiyF4wkfm+8mCS6jf3Hy5Q+dIj4hf?=
 =?us-ascii?Q?ZBhlkztp0Surrk/X3cHI6fIff210Fs+Oxt3odtb/hwmsSN9g8pIrUP88/Y42?=
 =?us-ascii?Q?sfTicfJ51J4m9iaXUeu6Dm0sH1aC0fVwzynDN1IIRmlImYezkgVqFETjNGAD?=
 =?us-ascii?Q?t05DTDyZcoSBL6BfgqI5q13kemYsgISZhTRRgFN/sHsVv3uWJ/7x0QYQwcue?=
 =?us-ascii?Q?JCUGLNXwqdTtZDuKJhBS0BzCeNRwPtrpvQjekCIKckXDDU8QOyQgnxFdM507?=
 =?us-ascii?Q?ZaLOMlWsCu7kAfQjgI0q4STdTu1TeQUO2gU++AGhThKJU+p9E4Q3vFNMfqBV?=
 =?us-ascii?Q?misU9eefTdcGplAJgsKNen9Mq/fropAZV13nVLuWRKOs6c+kubgoMQ5dpGDW?=
 =?us-ascii?Q?RrwX4OqPkxX3vE6QilUuKZmypmK1iRL3cKGlnLV8uCaP8/efsBFz4u2I5GoB?=
 =?us-ascii?Q?EJALoR10lOAgUdkgBxoMJSslCmnINFvM7jycktgNoYBFbtzQoUHfqFsopAE0?=
 =?us-ascii?Q?yjrzo+9cOrtTxwBjvcVQQdkVR2djjOMUf1AvkLd3UX2koHLpsj2+J5cGlXTz?=
 =?us-ascii?Q?Cd5+wP7QZjzOcTqAoENa2PCQLZx0kFYM5CSCvvRcLUjKJ7naRH/sz6LfOmi3?=
 =?us-ascii?Q?kGnGAwtGgTpzItbJZo1yTUcN/BbJolwz8GuUL7kCdArwk+k6w4cjk6XPIRjr?=
 =?us-ascii?Q?mcnz71XhWCtsShTufKlZhdJPiG7iXEPk4QZb1UsmBDloDKAGbPB/7zaYENe8?=
 =?us-ascii?Q?LB6aFOAvAdbAgCsh5C+5GR+MiC3hhiweuQG6X64S/eoWziOL79HV7WCCfKkj?=
 =?us-ascii?Q?Wj3GPUNZHzegogg6oPqkVyG4XrMw6+rfr6WfuYbe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 176c0f99-f6c8-4f18-4412-08dabb76a341
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 19:32:24.5688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lUO7yxGO9GbiN2TIu49/2EziHd2lwxSsM6syspLdo+SLlyDbtWceKoEh9RPRmsgYOtxOynQ9jh8bHpCe41NdZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3392
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct
> ib_umem *umem,
> > +				 mana_handle_t *gdma_region)
> > +{
> > +	struct gdma_dma_region_add_pages_req *add_req =3D NULL;
> > +	struct gdma_create_dma_region_resp create_resp =3D {};
> > +	struct gdma_create_dma_region_req *create_req;
> > +	size_t num_pages_cur, num_pages_to_handle;
> > +	unsigned int create_req_msg_size;
> > +	struct hw_channel_context *hwc;
> > +	struct ib_block_iter biter;
> > +	size_t max_pgs_create_cmd;
> > +	struct gdma_context *gc;
> > +	size_t num_pages_total;
> > +	struct gdma_dev *mdev;
> > +	unsigned long page_sz;
> > +	void *request_buf;
> > +	unsigned int i;
> > +	int err;
> > +
> > +	mdev =3D dev->gdma_dev;
> > +	gc =3D mdev->gdma_context;
> > +	hwc =3D gc->hwc.driver_data;
> > +
> > +	/* Hardware requires dma region to align to chosen page size */
> > +	page_sz =3D ib_umem_find_best_pgsz(umem, PAGE_SZ_BM, 0);
>=20
> Does your HW support arbitary MR offsets in the IOVA?

Yes, the HW supports arbitrary MR offsets. I'm checking with hardware guys =
to confirm.

>=20
> struct ib_mr *mana_ib_reg_user_mr(struct ib_pd *ibpd, u64 start, u64
> length,
> 				  u64 iova, int access_flags,
> 				  struct ib_udata *udata)
> {
> [..]
>=20
> 	err =3D mana_ib_gd_create_dma_region(dev, mr-
> >umem,&dma_region_handle);
>   ..
> 	mr_params.gva.virtual_address =3D iova;
>=20
> Eg if I set iova to 1 and length to PAGE_SIZE and pass in a umem which is=
 fully
> page aligned, will the HW work, or will it DMA to the wrong locations?
>=20
> All other RDMA HW requires passing iova to the
> ib_umem_find_best_pgsz() specifically to reject/adjust the misalignment o=
f
> the IOVA relative to the selected pagesize.
>=20
> > +	__rdma_umem_block_iter_start(&biter, umem, page_sz);
> > +
> > +	for (i =3D 0; i < num_pages_to_handle; ++i) {
> > +		dma_addr_t cur_addr;
> > +
> > +		__rdma_block_iter_next(&biter);
> > +		cur_addr =3D rdma_block_iter_dma_address(&biter);
> > +
> > +		create_req->page_addr_list[i] =3D cur_addr;
> > +	}
>=20
> This loop is still a mess, why can you not write it as I said for v6?
>=20
>  Usually the way these loops are structured is to fill the array and  the=
n check
> for fullness, trigger an action to drain the array, and  reset the indexe=
s back
> to the start.
>=20
> so do the usual
>=20
>  rdma_umem_for_each_dma_block() {
>    page_addr_list[tail++] =3D rdma_block_iter_dma_address(&biter);
>    if (tail >=3D num_pages_to_handle) {
>       mana_gd_send_request()
>       reset buffer
>       tail =3D 0
>    }
>   }
>=20
>  if (tail)
>       mana_gd_send_request()

I tried to recode this section; the new code looks like the following.=20
It's 30 lines longer than the previous version.

The difficulty is that there are two PF messages involved: the 1st one is
for creating the initial pages, the 2nd (and subsequent) ones are for addin=
g
more pages. So going through the page sequence as seen from the hardware
side makes it shorter.

What do you think of this version?=20

static int
mana_ib_gd_first_dma_region(struct mana_ib_dev *dev,
                            struct gdma_context *gc,
                            struct gdma_create_dma_region_req *create_req,
                            size_t num_pages, mana_handle_t *gdma_region)
{
        struct gdma_create_dma_region_resp create_resp =3D {};
        unsigned int create_req_msg_size;
        int err;

        create_req_msg_size =3D
                struct_size(create_req, page_addr_list, num_pages);
        create_req->page_addr_list_len =3D num_pages;

        err =3D mana_gd_send_request(gc, create_req_msg_size, create_req,
                                   sizeof(create_resp), &create_resp);
        if (err || create_resp.hdr.status) {
                ibdev_dbg(&dev->ib_dev,
                          "Failed to create DMA region: %d, 0x%x\n",
                          err, create_resp.hdr.status);
                if (!err)
                        err =3D -EPROTO;

                return err;
        }

        *gdma_region =3D create_resp.dma_region_handle;
        ibdev_dbg(&dev->ib_dev, "Created DMA region handle 0x%llx\n",
                  *gdma_region);

        return 0;
}

static int mana_ib_gd_add_dma_region(struct mana_ib_dev *dev,
                                     struct gdma_context *gc,
                                     struct gdma_dma_region_add_pages_req *=
add_req,
                                     unsigned int num_pages, u32 expected_s=
tatus)
{
        unsigned int add_req_msg_size =3D
                struct_size(add_req, page_addr_list, num_pages);
        struct gdma_general_resp add_resp =3D {};
        int err;

        mana_gd_init_req_hdr(&add_req->hdr, GDMA_DMA_REGION_ADD_PAGES,
                             add_req_msg_size, sizeof(add_resp));
        add_req->page_addr_list_len =3D num_pages;

        err =3D mana_gd_send_request(gc, add_req_msg_size, add_req,
                                   sizeof(add_resp), &add_resp);
        if (err || add_resp.hdr.status !=3D expected_status) {
                ibdev_dbg(&dev->ib_dev,
                          "Failed to create DMA region: %d, 0x%x\n",
                          err, add_resp.hdr.status);

                if (!err)
                        err =3D -EPROTO;

                return err;
        }

        return 0;
}

int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem *u=
mem,
                                 mana_handle_t *gdma_region)
{
        struct gdma_dma_region_add_pages_req *add_req =3D NULL;
        size_t num_pages_processed =3D 0, num_pages_to_handle;
        struct gdma_create_dma_region_resp create_resp =3D {};
        struct gdma_create_dma_region_req *create_req;
        unsigned int create_req_msg_size;
        struct hw_channel_context *hwc;
        size_t max_pgs_create_cmd;
        size_t max_pgs_add_cmd;
        struct ib_block_iter biter;
        struct gdma_context *gc;
        size_t num_pages_total;
        struct gdma_dev *mdev;
        unsigned long page_sz;
        unsigned int tail =3D 0;
        u64 *page_addr_list;
        void *request_buf;
        int err;

        mdev =3D dev->gdma_dev;
        gc =3D mdev->gdma_context;
        hwc =3D gc->hwc.driver_data;

        /* Hardware requires dma region to align to chosen page size */
        page_sz =3D ib_umem_find_best_pgsz(umem, PAGE_SZ_BM, 0);
        if (!page_sz) {
                ibdev_dbg(&dev->ib_dev, "failed to find page size.\n");
                return -ENOMEM;
        }
        num_pages_total =3D ib_umem_num_dma_blocks(umem, page_sz);

        max_pgs_create_cmd =3D
                (hwc->max_req_msg_size - sizeof(*create_req)) / sizeof(u64)=
;
        num_pages_to_handle =3D
                min_t(size_t, num_pages_total, max_pgs_create_cmd);
        create_req_msg_size =3D
                struct_size(create_req, page_addr_list, num_pages_to_handle=
);

        request_buf =3D kzalloc(hwc->max_req_msg_size, GFP_KERNEL);
        if (!request_buf)
                return -ENOMEM;

        create_req =3D request_buf;
        mana_gd_init_req_hdr(&create_req->hdr, GDMA_CREATE_DMA_REGION,
                             create_req_msg_size, sizeof(create_resp));

        create_req->length =3D umem->length;
        create_req->offset_in_page =3D umem->address & (page_sz - 1);
        create_req->gdma_page_type =3D order_base_2(page_sz) - PAGE_SHIFT;
        create_req->page_count =3D num_pages_total;

        ibdev_dbg(&dev->ib_dev, "size_dma_region %lu num_pages_total %lu\n"=
,
                  umem->length, num_pages_total);

        ibdev_dbg(&dev->ib_dev, "page_sz %lu offset_in_page %u\n",
                  page_sz, create_req->offset_in_page);

        ibdev_dbg(&dev->ib_dev, "num_pages_to_handle %lu, gdma_page_type %u=
",
                  num_pages_to_handle, create_req->gdma_page_type);

        add_req =3D request_buf;
        max_pgs_add_cmd =3D
                        (hwc->max_req_msg_size - sizeof(*add_req)) /
                        sizeof(u64);

        page_addr_list =3D create_req->page_addr_list;
        rdma_umem_for_each_dma_block(umem, &biter, page_sz) {
                page_addr_list[tail++] =3D rdma_block_iter_dma_address(&bit=
er);
                if (tail >=3D num_pages_to_handle) {
                        u32 expected_s =3D 0;

                        if (num_pages_processed &&
                            num_pages_processed + num_pages_to_handle <
                                num_pages_total) {
                                /* Status indicating more pages are needed =
*/
                                expected_s =3D GDMA_STATUS_MORE_ENTRIES;
                        }

                        if (!num_pages_processed) {
                                /* First message */
                                err =3D mana_ib_gd_first_dma_region(dev, gc=
,
                                                                  create_re=
q,
                                                                  tail,
                                                                  gdma_regi=
on);
                                if (err)
                                        goto out;

                                page_addr_list =3D add_req->page_addr_list;
                        } else {
                                err =3D mana_ib_gd_add_dma_region(dev, gc,
                                                                add_req, ta=
il,
                                                                expected_s)=
;
                                if (err) {
                                        tail =3D 0;
                                        break;
                                }
                        }

                        num_pages_processed +=3D tail;

                        /* Prepare to send ADD_PAGE requests */
                        num_pages_to_handle =3D
                                min_t(size_t,
                                      num_pages_total - num_pages_processed=
,
                                      max_pgs_add_cmd);

                        tail =3D 0;
                }
        }

        if (tail) {
                if (!num_pages_processed) {
                        err =3D mana_ib_gd_first_dma_region(dev, gc, create=
_req,
                                                          tail, gdma_region=
);
                        if (err)
                                goto out;
                } else {
                        err =3D mana_ib_gd_add_dma_region(dev, gc, add_req,
                                                        tail, 0);
                }
        }

        if (err)
                mana_ib_gd_destroy_dma_region(dev, create_resp.dma_region_h=
andle);

out:
        kfree(request_buf);
        return err;
}
