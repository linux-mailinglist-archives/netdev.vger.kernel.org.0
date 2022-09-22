Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FB05E5D5D
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 10:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiIVIXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 04:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiIVIXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 04:23:50 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020014.outbound.protection.outlook.com [52.101.61.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782D7CD1E2;
        Thu, 22 Sep 2022 01:23:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ke9j4tr4u5b1hdoJw24iNXX+q4W3PHUNZ2Z0IQFVENDkgNPP1W/NEfxI6Fs6t6x81g9QMWrWpbidIHZs6JqK+8VP+aO0T0PBmsyg0PF4pHY3XCQ0iw71+ArLLlpW75uRh7B5FFbwJed2txPovslgRUkiw80RWV2LA9LsxS7ldD6Zx4mdgcD5By9+l1iLQVvL+9NhXymTm0Rvv3Yq1O5xXcylS3INfOJqx0lCO2Rf3VmG7v0RIc3IX8P2+ORsd0ijVbiyVj23NeqYgrea7aWUVvHhaYvHdputSQR795b6lNPXBHJVxFu8HvnO8QXSk5YqK+gWnwP76lWWrIc3Bu+M/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61eMyt7cFzs88hxFsSgURbbm6vkUpPwd6Q1mmkUXZ6g=;
 b=iGxvyJher2DK2CpGa6MIMQ81EAOJUa9cDyyHqAVsT4WJopneMmmwYOj0wzzCP3Tn8AWoNGf0EC+z7/Bln2QLg4a8A8VWJUnou1LZms3/52KUuJqPwAG879bpXeph4nFcvFotYobkof0cyVpin8soPLWikI0O8XtqArtmb03AumbC055di8YkLnBzo3CnuzFKMBXjUFJE+JRtmB9EimrNf+8NfnXj1/rXRikDghp7AX7aQHiofe2EMpPcAg82o+ers4FZaH0CqLPqj2xjtf8413ncoH2XmJjKavV2Vt2m0H2ffGicsDTbJddIQzy38NUKl7WGHzjXBoF5E7f9dVnwLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61eMyt7cFzs88hxFsSgURbbm6vkUpPwd6Q1mmkUXZ6g=;
 b=XrkLH8StE/gDvaCZtgj5q4OAKZ06Q3bO4PeNXgQDfwLxu1KOccWXJGBQPHrke/NZHVno/eCzg+1sQR0B3hjV0dUbShhNJd63ZNhtzACPCvLX41f6gxaAZqDzvjrb+tcp/8FuM7r/QOzIpGboZAzeeGxyAYxZjUnPaeUoW5RVVPY=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by PH0PR21MB2063.namprd21.prod.outlook.com (2603:10b6:510:a9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.9; Thu, 22 Sep
 2022 08:23:45 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::ce6d:5482:f64f:2ce6]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::ce6d:5482:f64f:2ce6%7]) with mapi id 15.20.5676.004; Thu, 22 Sep 2022
 08:23:45 +0000
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
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v6 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v6 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHYzVi1rl2GvOblR0qql1cMBRcleq3qLSgAgAA5HHA=
Date:   Thu, 22 Sep 2022 08:23:45 +0000
Message-ID: <PH7PR21MB32631DFB5A4C05DC0B870802CE4E9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1663723352-598-1-git-send-email-longli@linuxonhyperv.com>
 <1663723352-598-13-git-send-email-longli@linuxonhyperv.com>
 <YytRDgWDsFYY6rV/@ziepe.ca>
In-Reply-To: <YytRDgWDsFYY6rV/@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0c5b1988-569d-4938-bf00-1b7833cb2fee;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-21T21:24:06Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|PH0PR21MB2063:EE_
x-ms-office365-filtering-correlation-id: 60adffbb-6f58-46c7-c07b-08da9c73c450
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: csVVTFB4o1eeFGjixD2DuOuYBjMcVs2iC6mgNSjvqVjx0/jzh3snrbMIaQr69wXSXv6bDEbZh+stNMjJRr9ZS9D/FTeUA3s+efEuJQjLidv+jgC/IPEZpVhzibKuIYFKGnI4cFbpRmCcGyVlzwEEl3CUwtCkugTu5x2T52nwunnuu3MHi8TLt4RLA7IjnIHeFM1+1qIXjtWjimtlh+O18ZRd7AzTKF6Zq7mbx/GIiau/dEr9TZta71HdBMMfS7UOvLhfZZ5zAaruoOr0ACyKm5imawI6hkdaff67ayyPh33bTm+MjP5oQcTvuTqne0MAEAYIX1iF4au2Mx1sFtr655AkGITzJOVL8n1ezGDWWlDj965CHg2MrItZrnpVZ4SL27jVFmyuCxs6pcT6gxdttl/7/GVplI0oYqDBEWvUDykuX5Nq3BSEXkKbsA7Q+nw4EjXP5Z1Of9tEZ27H6JnJ16AFppBFdnbd4JM66L2q7TuHkMkEeHpnCTxBZSnP0WdDcWIN9sOLQieb6x/cyMUfKYVqe7OIjjb3x9mfBhsOi9+jZ+g9NKUerBRq9ROUSrCswCazYHae6+f8dW5JghyggsXpSVU2Kuaha7w9Bh5JHI921iRMd98hOllHGivlMBqeAWPCHiuDzoiLam+2xnB+rhe6/nXjgxJ7zwT5PruZgTghKOu4vp2TICVEB7VOJVdjTQ1usRvf/mLXaMcolpDR/GzwryxBKzGtXDJ9qBL65AdtseNW57ZbUGuOjEPagDBP2MgnA5opYmiuviYI4z1ouEE5rRPcAWffy9mGZGK5xnKIolj0B4qUIFKQ+J5feF2769MSQkly5l2N3M99rJbNXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(39860400002)(346002)(136003)(47530400004)(451199015)(8676002)(8990500004)(4326008)(5660300002)(52536014)(2906002)(66899012)(41300700001)(71200400001)(33656002)(26005)(6506007)(9686003)(7696005)(38100700002)(64756008)(66476007)(66946007)(66556008)(66446008)(76116006)(8936002)(7416002)(30864003)(86362001)(316002)(6916009)(10290500003)(54906003)(38070700005)(478600001)(82960400001)(82950400001)(122000001)(83380400001)(55016003)(186003)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ijrs/y3KYGsNhBepxT79oywhb5Sg3GcRwaJlqZEPftboAXNuEcAiWdX3iu40?=
 =?us-ascii?Q?fYSTgmRYQwQpAJVpj4bGUqhii6jx1HEMQGbivqF9oLIM2U51H6Hj5/mxBjlX?=
 =?us-ascii?Q?u8au/IR2euGt5cMEBRYUHyGXG5oln9TIRxQ9FAdW6YiSHoRV9wv2hUJ8ccII?=
 =?us-ascii?Q?Nrl7uVskNd+C4+eu2NrivR8vZCs1VG6pNCTe+3zXdq9Lovi0bOFF//Quz0YZ?=
 =?us-ascii?Q?rGxn54tzSYnks7O1TgVWBR+d8XrUIlG/8AMfK2l5RNPkw+ZnEE3FpfyFIUVh?=
 =?us-ascii?Q?ZjqDT/v2fVHWQFEBX+phrvZ8pDA0MwwLLvtRFGa4HQPHZS3DgOZcDL7hDYGV?=
 =?us-ascii?Q?f1hprE50arMFLRfvmigLp7LMg6t6DofrATdVxZk3tiNLtQ8WQIiG7Y66mvDv?=
 =?us-ascii?Q?l8rCdEtU64wXJlUPxUSOO6G3o0/f0xhCqZojYc+3TCPvV1G7aJXFAMkZBoOj?=
 =?us-ascii?Q?exrLu5JjllphmcNTAe96ZqLK1972xIyx0c/zm0Vw/o9NwoR3XAEq/YkKBk1+?=
 =?us-ascii?Q?vkvQKmfc2d5xC57JZJLzyGNizgi3j+FBOUQF70zT2fCrFM17o2ZqggL17Aee?=
 =?us-ascii?Q?m1Xk9F1Dc+050FYi26cMRQ+sGmI2d+lsGT/zDxxK8cGCw9t4O1KZTODH6Fs7?=
 =?us-ascii?Q?VcRBObmbKz3U4bh/Rb8njYBhCxg6NxIdkM7yt6q80v5iEeF0hpYNDiJwWc9n?=
 =?us-ascii?Q?ekFBRwx4EdMew2tWGRAFZaXGcSDCQfFpYiw1fp3vjRe+FciorY5vMR4Q1Jy9?=
 =?us-ascii?Q?hU4XjORZhQCSyGd8K7T18ap8JQQJWT0UzbC5YnxtkSA+I0d+vPFgskD3SoO0?=
 =?us-ascii?Q?b8gidMM5xH1ZHfOoz4tAkEmGNcjOCghjpz2YJqW3uolX8ijd4VpAFumnudjR?=
 =?us-ascii?Q?lj6ps0g6xo3EoSfxg3dpnh/+qCQ2Qa81iTxjlHSLV0KLBGa0EVzclKq6zN1D?=
 =?us-ascii?Q?M8ZUAIMpvmH/92lHUDcPU2LHYwY+k/GtvL0+9IMZPzIR/ndEOwDtrvdfK5/n?=
 =?us-ascii?Q?t+Yaoo6l9sCS4NGoZO/Qm0pcg6QucYma12xIXJjx43O62z5tJZYzJTW4mhR9?=
 =?us-ascii?Q?UPuMP4mLBT/6Ox9FSgGtij1bznXTcuq9XYrP8jgdAx9bsfzvh4FjMlnPW2hR?=
 =?us-ascii?Q?ZbfHTloSIcqdMpubU6zxeJcFmb9g3XlH84gbS/wVHtFw/iyyqbOxr5MjUBzO?=
 =?us-ascii?Q?073VjoCygAMyvOAC3ya2iUlg8JRt05gbP2dn0KBi2NmJkw+B1zLzBs7WKC0p?=
 =?us-ascii?Q?j4bRP928ZTvrtMTY3vctf2aontDVFtLrcayNKk9bByy4u+u75uQN5K1rYmpf?=
 =?us-ascii?Q?jHkVWL9eK/GWDsmWPXU05VIqwijLt9nRdpvsYIGpw1ZH+LNKJWz/V20O9mTw?=
 =?us-ascii?Q?pN/SXyKqOAJ4kansChSv7JGCj7Lf2Pbdkh3QT8Igz3X4ar155C+YYwlvhMqw?=
 =?us-ascii?Q?34dSdOSBZysl+dWOehGAXLbmWrEygbTNk+ha8ODNDemQaQxbey3ZMbohb3gZ?=
 =?us-ascii?Q?AZVHR4sgbSQoNg2aU/3iReyxoQIDSi6ez2CnNWwn4ci0KB9C8YlpYIqG5bWZ?=
 =?us-ascii?Q?eGZa3LikfYBvIvjfgO/6f9A2/jr0ymWSR7DP/cPx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60adffbb-6f58-46c7-c07b-08da9c73c450
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 08:23:45.4989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: weaw3xh3sUH7Gc83jLx76JTZ47bkv1XjWgJ1ZuBEEkORvPLLuyiJz2K/uKIU1iA8S4iSc2y9v4aUb7grmnGsVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB2063
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [Patch v6 12/12] RDMA/mana_ib: Add a driver for Microsoft
> Azure Network Adapter
>=20
> On Tue, Sep 20, 2022 at 06:22:32PM -0700, longli@linuxonhyperv.com wrote:
> > +int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr
> *attr,
> > +		      struct ib_udata *udata)
> > +{
> > +	struct mana_ib_cq *cq =3D container_of(ibcq, struct mana_ib_cq, ibcq)=
;
> > +	struct ib_device *ibdev =3D ibcq->device;
> > +	struct mana_ib_create_cq ucmd =3D {};
> > +	struct mana_ib_dev *mdev;
> > +	int err;
> > +
> > +	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
>=20
> Stylistically these container_of's are usually in the definitions section=
, at least
> pick a form and stick to it consistently.

I will review all the other occurrences for consistency. I'm trying to use =
the "reverse Christmas tree" for definitions, so putting "mdev =3D" in a se=
parate line.

>=20
> > +	if (udata->inlen < sizeof(ucmd))
> > +		return -EINVAL;
> > +
> > +	err =3D ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata-
> >inlen));
> > +	if (err) {
> > +		ibdev_dbg(ibdev,
> > +			  "Failed to copy from udata for create cq, %d\n", err);
>=20
> > +		return -EFAULT;
> > +	}
> > +
> > +	if (attr->cqe > MAX_SEND_BUFFERS_PER_QUEUE) {
> > +		ibdev_dbg(ibdev, "CQE %d exceeding limit\n", attr->cqe);
> > +		return -EINVAL;
> > +	}
> > +
> > +	cq->cqe =3D attr->cqe;
> > +	cq->umem =3D ib_umem_get(ibdev, ucmd.buf_addr, cq->cqe *
> COMP_ENTRY_SIZE,
> > +			       IB_ACCESS_LOCAL_WRITE);
> > +	if (IS_ERR(cq->umem)) {
> > +		err =3D PTR_ERR(cq->umem);
> > +		ibdev_dbg(ibdev, "Failed to get umem for create cq,
> err %d\n",
> > +			  err);
> > +		return err;
> > +	}
> > +
> > +	err =3D mana_ib_gd_create_dma_region(mdev, cq->umem, &cq-
> >gdma_region,
> > +					   PAGE_SIZE);
> > +	if (err) {
> > +		ibdev_err(ibdev,
> > +			  "Failed to create dma region for create cq, %d\n",
> > +			  err);
>=20
> Prints on userspace paths are not allowed, this should be dbg. There are
> many other cases like this, please fix them all. This driver may have too=
 many
> dbg prints too, not every failure if should have a print :(

Will fix those.

>=20
> > +	ibdev_dbg(ibdev,
> > +		  "mana_ib_gd_create_dma_region ret %d gdma_region
> 0x%llx\n",
> > +		  err, cq->gdma_region);
> > +
> > +	/* The CQ ID is not known at this time
> > +	 * The ID is generated at create_qp
> > +	 */
>=20
> Wrong comment style, rdma uses the leading empty blank line for some
> reason
>=20
>  /*
>   * The CQ ID is not known at this time. The ID is generated at create_qp=
.
>   */

Will fix all the comments.

>=20
> > +static void mana_ib_remove(struct auxiliary_device *adev) {
> > +	struct mana_ib_dev *dev =3D dev_get_drvdata(&adev->dev);
> > +
> > +	ib_unregister_device(&dev->ib_dev);
> > +	ib_dealloc_device(&dev->ib_dev);
> > +}
> > +
> > +static const struct auxiliary_device_id mana_id_table[] =3D {
> > +	{
> > +		.name =3D "mana.rdma",
> > +	},
> > +	{},
> > +};
> > +
> > +MODULE_DEVICE_TABLE(auxiliary, mana_id_table);
> > +
> > +static struct auxiliary_driver mana_driver =3D {
> > +	.name =3D "rdma",
> > +	.probe =3D mana_ib_probe,
> > +	.remove =3D mana_ib_remove,
> > +	.id_table =3D mana_id_table,
> > +};
> > +
> > +static int __init mana_ib_init(void)
> > +{
> > +	auxiliary_driver_register(&mana_driver);
> > +
> > +	return 0;
> > +}
> > +
> > +static void __exit mana_ib_cleanup(void) {
> > +	auxiliary_driver_unregister(&mana_driver);
> > +}
> > +
>=20
> All this is just module_auxiliary_driver()

Will fix this.

>=20
> > +	mutex_lock(&pd->vport_mutex);
> > +
> > +	pd->vport_use_count++;
> > +	if (pd->vport_use_count > 1) {
> > +		ibdev_dbg(&dev->ib_dev,
> > +			  "Skip as this PD is already configured vport\n");
> > +		mutex_unlock(&pd->vport_mutex);
>=20
> This leaves vport_use_count elevated.

This is intentional. The code will call mana_ib_uncfg_vport() (which decrea=
ses vport_use_count ) when destroying the QP.

>=20
> > +		return 0;
> > +int mana_ib_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata) {
> > +	struct mana_ib_pd *pd =3D container_of(ibpd, struct mana_ib_pd,
> ibpd);
> > +	struct ib_device *ibdev =3D ibpd->device;
> > +	struct mana_ib_dev *dev;
> > +
> > +	dev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> > +	return mana_ib_gd_destroy_pd(dev, pd->pd_handle);
>=20
> This is the only place that calls mana_ib_gd_destroy_pd(), don't have a
> spaghetti of functions calling single other functions like this, just inl=
ine it.
>=20
> Also it shouldn't have been non-static, please check everything that
> everything non-static actually has an out-of-file user.

Will fix those.

>=20
> > +void mana_ib_dealloc_ucontext(struct ib_ucontext *ibcontext) {
> > +	struct mana_ib_ucontext *mana_ucontext =3D
> > +		container_of(ibcontext, struct mana_ib_ucontext,
> ibucontext);
> > +	struct ib_device *ibdev =3D ibcontext->device;
> > +	struct mana_ib_dev *mdev;
> > +	struct gdma_context *gc;
> > +	int ret;
> > +
> > +	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> > +	gc =3D mdev->gdma_dev->gdma_context;
> > +
> > +	ret =3D mana_gd_destroy_doorbell_page(gc, mana_ucontext-
> >doorbell);
> > +	if (ret)
> > +		ibdev_err(ibdev, "Failed to destroy doorbell page %d\n", ret);
>=20
> This already printing on error
>=20
> And again, why is this driver split up so strangely?
> mana_gd_destroy_doorbell_page() is an RDMA function, it is only called by
> the RDMA code, why is it located under drivers/net/ethernet?
>=20
> I do not want an RDMA driver in drivers/net/ethernet.

Will move this function (and mana_gd_allocate_doorbell_page) to the RDMA dr=
iver.

>=20
>=20
> > +}
> > +
> > +int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct
> ib_umem *umem,
> > +				 mana_handle_t *gdma_region, u64 page_sz)
> {
> > +	size_t num_pages_total =3D ib_umem_num_dma_blocks(umem,
> page_sz);
> > +	struct gdma_dma_region_add_pages_req *add_req =3D NULL;
> > +	struct gdma_create_dma_region_resp create_resp =3D {};
> > +	struct gdma_create_dma_region_req *create_req;
> > +	size_t num_pages_cur, num_pages_to_handle;
> > +	unsigned int create_req_msg_size;
> > +	struct hw_channel_context *hwc;
> > +	struct ib_block_iter biter;
> > +	size_t max_pgs_create_cmd;
> > +	struct gdma_context *gc;
> > +	struct gdma_dev *mdev;
> > +	unsigned int i;
> > +	int err;
> > +
> > +	mdev =3D dev->gdma_dev;
> > +	gc =3D mdev->gdma_context;
> > +	hwc =3D gc->hwc.driver_data;
> > +	max_pgs_create_cmd =3D
> > +		(hwc->max_req_msg_size - sizeof(*create_req)) /
> sizeof(u64);
> > +
> > +	num_pages_to_handle =3D
> > +		min_t(size_t, num_pages_total, max_pgs_create_cmd);
> > +	create_req_msg_size =3D
> > +		struct_size(create_req, page_addr_list,
> num_pages_to_handle);
> > +
> > +	create_req =3D kzalloc(create_req_msg_size, GFP_KERNEL);
> > +	if (!create_req)
>=20
> Is this a multi-order allocation, I can't tell how big max_req_msg_size i=
s?
>=20
> This design seems to repeat the mistakes we made in mlx5, the low levels =
of
> the driver already has memory allocated - why not get a pointer to that
> memory here and directly fill the message buffer instead of all this allo=
cation
> and memory copying?

max_req_msg_size is 4k bytes (one page). I think this allocation is still n=
ecessary as we don't have a buffer for this request. But we should be able =
to reuse this buffer for subsequent commands (details below).

> > +	ibdev_dbg(&dev->ib_dev,
> > +		  "size_dma_region %lu num_pages_total %lu, "
> > +		  "page_sz 0x%llx offset_in_page %u\n",
> > +		  umem->length, num_pages_total, page_sz,
> > +		  create_req->offset_in_page);
> > +
> > +	ibdev_dbg(&dev->ib_dev, "num_pages_to_handle %lu,
> gdma_page_type %u",
> > +		  num_pages_to_handle, create_req->gdma_page_type);
> > +
> > +	__rdma_umem_block_iter_start(&biter, umem, page_sz);
>=20
> > +	for (i =3D 0; i < num_pages_to_handle; ++i) {
> > +		dma_addr_t cur_addr;
> > +
> > +		__rdma_block_iter_next(&biter);
> > +		cur_addr =3D rdma_block_iter_dma_address(&biter);
> > +
> > +		create_req->page_addr_list[i] =3D cur_addr;
> > +
> > +		ibdev_dbg(&dev->ib_dev, "page num %u cur_addr 0x%llx\n",
> i,
> > +			  cur_addr);
>=20
> Please get rid of the worthless debugging code, actually test your driver=
 with
> EBUG enabled and ensure it is usuable. Printing thousands of lines of gar=
bage
> is not OK. Especially when what should have been a
> 1 line loop body is expended into a big block just to have a worthless de=
bug
> statement.

Will remove those debugging code.

>=20
>=20
> > +	if (num_pages_cur < num_pages_total) {
> > +		unsigned int add_req_msg_size;
> > +		size_t max_pgs_add_cmd =3D
> > +			(hwc->max_req_msg_size - sizeof(*add_req)) /
> > +			sizeof(u64);
> > +
> > +		num_pages_to_handle =3D
> > +			min_t(size_t, num_pages_total - num_pages_cur,
> > +			      max_pgs_add_cmd);
> > +
> > +		/* Calculate the max num of pages that will be handled */
> > +		add_req_msg_size =3D struct_size(add_req, page_addr_list,
> > +					       num_pages_to_handle);
> > +
> > +		add_req =3D kmalloc(add_req_msg_size, GFP_KERNEL);
>=20
> And allocating every loop iteration seems like overkill, why not just reu=
se the
> large buffer that create_req allocated?
>=20
> Usually the way these loops are structured is to fill the array and then =
check
> for fullness, trigger an action to drain the array, and reset the indexes=
 back to
> the start.

I will reuse the command buffer allocated earlier as you suggested.

>=20
> > +int mana_ib_gd_create_pd(struct mana_ib_dev *dev, u64 *pd_handle,
> u32 *pd_id,
> > +			 enum gdma_pd_flags flags)
> > +{
> > +	struct gdma_dev *mdev =3D dev->gdma_dev;
> > +	struct gdma_create_pd_resp resp =3D {};
> > +	struct gdma_create_pd_req req =3D {};
> > +	struct gdma_context *gc;
> > +	int err;
> > +
> > +	gc =3D mdev->gdma_context;
> > +
> > +	mana_gd_init_req_hdr(&req.hdr, GDMA_CREATE_PD, sizeof(req),
> > +			     sizeof(resp));
> > +
> > +	req.flags =3D flags;
> > +	err =3D mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp),
> > +&resp);
> > +
> > +	if (err || resp.hdr.status) {
> > +		ibdev_err(&dev->ib_dev,
> > +			  "Failed to get pd_id err %d status %u\n", err,
> > +			  resp.hdr.status);
> > +		if (!err)
> > +			err =3D -EPROTO;
>=20
> This pattern is repeated everywhere, you should fix
> mana_gd_send_request() to return EPROTO.

This pattern is also used all over in the ethernet driver. Since this patch=
 series is for the RDMA driver, can we make a separate patch to refactor th=
e code in mana_gd_send_request()? This can minimize the code changes to the=
 ethernet driver in this patch series.

>=20
> > +		return err;
> > +	}
> > +
> > +	*pd_handle =3D resp.pd_handle;
> > +	*pd_id =3D resp.pd_id;
> > +	ibdev_dbg(&dev->ib_dev, "pd_handle 0x%llx pd_id %d\n",
> *pd_handle,
> > +		  *pd_id);
> > +
> > +	return 0;
> > +}
> > +
> > +int mana_ib_gd_destroy_pd(struct mana_ib_dev *dev, u64 pd_handle) {
> > +	struct gdma_dev *mdev =3D dev->gdma_dev;
> > +	struct gdma_destory_pd_resp resp =3D {};
> > +	struct gdma_destroy_pd_req req =3D {};
> > +	struct gdma_context *gc;
> > +	int err;
> > +
> > +	gc =3D mdev->gdma_context;
>=20
> Why the local for a variable that is used once?

Will refactoring the code.

>=20
> > +int mana_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct
> > +*vma) {
> > +	struct mana_ib_ucontext *mana_ucontext =3D
> > +		container_of(ibcontext, struct mana_ib_ucontext,
> ibucontext);
> > +	struct ib_device *ibdev =3D ibcontext->device;
> > +	struct mana_ib_dev *mdev;
> > +	struct gdma_context *gc;
> > +	phys_addr_t pfn;
> > +	pgprot_t prot;
> > +	int ret;
> > +
> > +	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> > +	gc =3D mdev->gdma_dev->gdma_context;
> > +
> > +	if (vma->vm_pgoff !=3D 0) {
> > +		ibdev_err(ibdev, "Unexpected vm_pgoff %lu\n", vma-
> >vm_pgoff);
> > +		return -EINVAL;
>=20
> More user triggerable printing
>=20
> > +int mana_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata) {
> > +	struct mana_ib_mr *mr =3D container_of(ibmr, struct mana_ib_mr,
> ibmr);
> > +	struct ib_device *ibdev =3D ibmr->device;
> > +	struct mana_ib_dev *dev;
> > +	int err;
> > +
> > +	dev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> > +
> > +	err =3D mana_ib_gd_destroy_mr(dev, mr->mr_handle);
> > +	if (err)
> > +		return err;
>=20
> mana_ib_gd_destroy_mr() is only ever called here, why is it in main.c?

Will move it and mana_ib_gd_create_mr to mr.c

>=20
> > +static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
> > +				 struct ib_qp_init_attr *attr,
> > +				 struct ib_udata *udata)
> > +{
> > +	struct mana_ib_qp *qp =3D container_of(ibqp, struct mana_ib_qp,
> ibqp);
> > +	struct mana_ib_dev *mdev =3D
> > +		container_of(pd->device, struct mana_ib_dev, ib_dev);
> > +	struct ib_rwq_ind_table *ind_tbl =3D attr->rwq_ind_tbl;
> > +	struct mana_ib_create_qp_rss_resp resp =3D {};
> > +	struct mana_ib_create_qp_rss ucmd =3D {};
> > +	struct gdma_dev *gd =3D mdev->gdma_dev;
> > +	mana_handle_t *mana_ind_table;
> > +	struct mana_port_context *mpc;
> > +	struct mana_context *mc;
> > +	struct net_device *ndev;
> > +	struct mana_ib_cq *cq;
> > +	struct mana_ib_wq *wq;
> > +	struct ib_cq *ibcq;
> > +	struct ib_wq *ibwq;
> > +	int i =3D 0, ret;
> > +	u32 port;
> > +
> > +	mc =3D gd->driver_data;
> > +
> > +	if (udata->inlen < sizeof(ucmd))
> > +		return -EINVAL;
> > +
> > +	ret =3D ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata-
> >inlen));
> > +	if (ret) {
> > +		ibdev_dbg(&mdev->ib_dev,
> > +			  "Failed copy from udata for create rss-qp, err %d\n",
> > +			  ret);
> > +		return -EFAULT;
> > +	}
> > +
> > +	if (attr->cap.max_recv_wr > MAX_SEND_BUFFERS_PER_QUEUE) {
> > +		ibdev_dbg(&mdev->ib_dev,
> > +			  "Requested max_recv_wr %d exceeding limit.\n",
> > +			  attr->cap.max_recv_wr);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (attr->cap.max_recv_sge > MAX_RX_WQE_SGL_ENTRIES) {
> > +		ibdev_dbg(&mdev->ib_dev,
> > +			  "Requested max_recv_sge %d exceeding limit.\n",
> > +			  attr->cap.max_recv_sge);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (ucmd.rx_hash_function !=3D MANA_IB_RX_HASH_FUNC_TOEPLITZ)
> {
> > +		ibdev_dbg(&mdev->ib_dev,
> > +			  "RX Hash function is not supported, %d\n",
> > +			  ucmd.rx_hash_function);
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* IB ports start with 1, MANA start with 0 */
> > +	port =3D ucmd.port;
> > +	if (port < 1 || port > mc->num_ports) {
> > +		ibdev_dbg(&mdev->ib_dev, "Invalid port %u in creating
> qp\n",
> > +			  port);
> > +		return -EINVAL;
> > +	}
> > +	ndev =3D mc->ports[port - 1];
> > +	mpc =3D netdev_priv(ndev);
> > +
> > +	ibdev_dbg(&mdev->ib_dev, "rx_hash_function %d port %d\n",
> > +		  ucmd.rx_hash_function, port);
> > +
> > +	mana_ind_table =3D kzalloc(sizeof(mana_handle_t) *
> > +					 (1 << ind_tbl->log_ind_tbl_size),
> > +				 GFP_KERNEL);
>=20
> Should be careful about maths overflow on this calculation.

Will add a check.

>=20
> > +	ibdev_dbg(&mdev->ib_dev, "ucmd sq_buf_addr 0x%llx port %u\n",
> > +		  ucmd.sq_buf_addr, ucmd.port);
> > +
> > +	umem =3D ib_umem_get(ibpd->device, ucmd.sq_buf_addr,
> ucmd.sq_buf_size,
> > +			   IB_ACCESS_LOCAL_WRITE);
> > +	if (IS_ERR(umem)) {
> > +		err =3D PTR_ERR(umem);
> > +		ibdev_dbg(&mdev->ib_dev,
> > +			  "Failed to get umem for create qp-raw, err %d\n",
> > +			  err);
> > +		goto err_free_vport;
> > +	}
> > +	qp->sq_umem =3D umem;
> > +
> > +	err =3D mana_ib_gd_create_dma_region(mdev, qp->sq_umem,
> > +					   &qp->sq_gdma_region, PAGE_SIZE);
> > +	if (err) {
>=20
> All these cases that process a page list have to call
> ib_umem_find_best_XXX()!
>=20
> It does important validation against hostile user input, including checki=
ng the
> critical iova.
>=20
> You have missed that the user can request that an unaligned umem be
> created and this creates a starting offset from the first page that must =
be
> honored in HW, or there will be weird memory corruption. Since it looks l=
ike
> this HW doesn't support a starting page offset this should call
> ib_umem_find_best_pgsz() with a SZ_4K and a 0 iova. Also never use
> PAGE_SIZE to describe a HW limitation.

Thank you, will fix this.

>=20
> There is alot of repeated code here, it would do well to have a wrapper
> function consolidating this pattern.

Will factor the code.

Thanks,
Long
