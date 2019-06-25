Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF145585C
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfFYUEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:04:14 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:4702
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726393AbfFYUEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 16:04:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CsdCdiJO+pHsc1eJ3dApby8/H9x/BcSYn24k4wJDQZw=;
 b=HqE85HsrpzZL1WM26a+aj2Ni0N9GMZDEu2YGkVGUMEwlzxXONasvh5CAOb1ZpOb/skvqWNRKD3ukq+uBqECjjTx5BqLtbJrHxfRjqVPjc7Vk4dad8gudgQD/sOp0WUefXjD7JejAw1QNTmQS9OF7axPchlaZReZcEyLhG2pTvnc=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB6525.eurprd05.prod.outlook.com (20.179.26.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Tue, 25 Jun 2019 20:04:08 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 20:04:08 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Michal Kalderon <michal.kalderon@marvell.com>
CC:     "ariel.elior@marvell.com" <ariel.elior@marvell.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 rdma-next 2/3] RDMA/qedr: Add doorbell overflow
 recovery support
Thread-Topic: [PATCH v4 rdma-next 2/3] RDMA/qedr: Add doorbell overflow
 recovery support
Thread-Index: AQHVK5EleJHZu3WXtUqklh5HNdMtxQ==
Date:   Tue, 25 Jun 2019 20:04:08 +0000
Message-ID: <20190625200404.GA17378@mellanox.com>
References: <20190624102809.8793-1-michal.kalderon@marvell.com>
 <20190624102809.8793-3-michal.kalderon@marvell.com>
In-Reply-To: <20190624102809.8793-3-michal.kalderon@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR07CA0025.eurprd07.prod.outlook.com
 (2603:10a6:205:1::38) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [66.187.232.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56fe609a-35b9-4642-f38a-08d6f9a847fc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6525;
x-ms-traffictypediagnostic: VI1PR05MB6525:
x-microsoft-antispam-prvs: <VI1PR05MB65257983FBD75A415F307DFFCFE30@VI1PR05MB6525.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(39860400002)(396003)(376002)(189003)(199004)(3846002)(446003)(6116002)(68736007)(6436002)(11346002)(2616005)(386003)(486006)(99286004)(6916009)(6246003)(1076003)(102836004)(256004)(52116002)(6506007)(76176011)(476003)(14444005)(26005)(73956011)(66556008)(64756008)(66446008)(14454004)(66476007)(316002)(36756003)(66946007)(5660300002)(54906003)(8676002)(33656002)(7736002)(4326008)(71190400001)(71200400001)(25786009)(478600001)(66066001)(8936002)(186003)(81166006)(81156014)(6512007)(86362001)(2906002)(53936002)(305945005)(229853002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6525;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vS7xszmCDRU+EDYu0amcE2DRoraklyJNQkNbFyPGw3RMbUew9FZRvivIPQU66BvYlDsZ2jrdI9Vzahm2HC1Iij80/rfmZW9x5QlNtjzjo0zOfkBTDGU1IjbbixSJXLR9DptCQKEd6qkqJIj027ZiJLGo48nUtE5XEgrnUYFOFd3ErsPLN9ld5WMBzdftXLI/XHtzbQCyip6qJb92ZTHb0Yf90V0ZpTqs2K816jOx9O8zxO5r4r+QFLqwgAw4zgO4rTQTYhatxdXZ5ttWrnmLQU03psY5B0tzHAcFncrOo2+1vBH0PRvLo9Quq4WlP8oBZJKAcF7wPVUc4408LUSMV5+gkCmPfuFstTpHYJUMrdmz6lwahJy4e8K/dJFtEXXpEkqdAW9hrgOmBnuvZqNdQXwqX+IIeaY5NJSjWS21NyI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <78478FDD0C3D784E8B2F45758E4C374E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56fe609a-35b9-4642-f38a-08d6f9a847fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 20:04:08.1532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6525
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 01:28:08PM +0300, Michal Kalderon wrote:

> +/* Map the kernel doorbell recovery memory entry */
> +int qedr_mmap_db_rec(struct vm_area_struct *vma)
> +{
> +	unsigned long len =3D vma->vm_end - vma->vm_start;
> +
> +	return remap_pfn_range(vma, vma->vm_start,
> +			       vma->vm_pgoff,
> +			       len, vma->vm_page_prot);
> +}
> +
>  int qedr_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
>  {
>  	struct qedr_ucontext *ucontext =3D get_qedr_ucontext(context);
> @@ -390,6 +446,8 @@ int qedr_mmap(struct ib_ucontext *context, struct vm_=
area_struct *vma)
>  	unsigned long phys_addr =3D vma->vm_pgoff << PAGE_SHIFT;
>  	unsigned long len =3D (vma->vm_end - vma->vm_start);
>  	unsigned long dpi_start;
> +	struct qedr_mm *mm;
> +	int rc;
> =20
>  	dpi_start =3D dev->db_phys_addr + (ucontext->dpi * ucontext->dpi_size);
> =20
> @@ -405,29 +463,28 @@ int qedr_mmap(struct ib_ucontext *context, struct v=
m_area_struct *vma)
>  		return -EINVAL;
>  	}
> =20
> -	if (!qedr_search_mmap(ucontext, phys_addr, len)) {
> -		DP_ERR(dev, "failed mmap, vm_pgoff=3D0x%lx is not authorized\n",
> +	mm =3D qedr_remove_mmap(ucontext, phys_addr, len);
> +	if (!mm) {
> +		DP_ERR(dev, "failed to remove mmap, vm_pgoff=3D0x%lx\n",
>  		       vma->vm_pgoff);
>  		return -EINVAL;
>  =09

This is so gross, please follow the pattern other drivers use for
managing the mmap cookie

In fact I am sick of seeing drivers wrongly re-implement this, so you
now get the job to make some proper core helpers to manage mmap
cookies for drivers.

The EFA driver is probably the best example, I suggest you move that
code to a common file in ib-core and use it here instead of redoing
yet again another broken version.

siw has another copy of basically the same thing.

> +static int qedr_init_user_db_rec(struct ib_udata *udata,
> +				 struct qedr_dev *dev, struct qedr_userq *q,
> +				 bool requires_db_rec)
> +{
> +	struct qedr_ucontext *uctx =3D
> +		rdma_udata_to_drv_context(udata, struct qedr_ucontext,
> +					  ibucontext);
> +
> +	/* Aborting for non doorbell userqueue (SRQ) or non-supporting lib */
> +	if (requires_db_rec =3D=3D 0 || !uctx->db_rec)
> +		return 0;
> +
> +	/* Allocate a page for doorbell recovery, add to mmap ) */
> +	q->db_rec_data =3D (void *)get_zeroed_page(GFP_KERNEL);

Pages obtained by get_zeroed_page shuld not be inserted by
remap_pfn_range, those cases need to use vm_insert_page instead.

>  struct qedr_alloc_ucontext_resp {
>  	__aligned_u64 db_pa;
> @@ -74,6 +83,7 @@ struct qedr_create_cq_uresp {
>  	__u32 db_offset;
>  	__u16 icid;
>  	__u16 reserved;
> +	__u64 db_rec_addr;
>  };

All uapi u64s need to be __aligned_u64 in this file.

> +/* doorbell recovery entry allocated and populated by userspace doorbell=
ing
> + * entities and mapped to kernel. Kernel uses this to register doorbell
> + * information with doorbell drop recovery mechanism.
> + */
> +struct qedr_user_db_rec {
> +	__aligned_u64 db_data; /* doorbell data */
> +};

like this one :\

Jason
