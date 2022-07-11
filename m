Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DA956D280
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiGKB3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiGKB3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:29:12 -0400
X-Greylist: delayed 918 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 10 Jul 2022 18:29:10 PDT
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.56.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26A162F6;
        Sun, 10 Jul 2022 18:29:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P854yvhEAmGGxacXkETRIrYU28zrxR+y+5L5g6mWTIj3fN14vqDtll+Ul6uFXuTGqE/+itt6jAUluXZ3w68XM2CgfkIBp8J5rcMD3M/QDuKWXV71N7Ix/P5ImBz+i0Kzw+0jTMPOvf5D3qNldf4DTXGGljbYhulOA7Ui0WMRiHEvHmVYac1dIGAgVRTlNHdx03NlurhyJ5i1GJy0rVc57+aNqkl6cp9EJq1Cv6CA7q6o+Q+ei3bCEeZ6K+Y8JbXJDLkvk2FG7lPwcEhdmCuoP9p9nS8F8IE2+1ASEHqBzTGipWpv3IuFLJoWdMF3w7ehbIfGexAA0h/aMVQyoHrcrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rfyvglgLFyAScwZyVRsOAMKMn85ka6MmQhFBOPcqcZY=;
 b=gZq0MVkQJxjZrB38lTXw5mB80WuWEO1LArCONuNMeS3Z+TSTKjeN9yXfsVmmH5DvZAem6W9zkEs7CQLtjeXCj082Qn9dr70S+y2XT6AIEW91uGzrWfL03AUKgoRhmz/8HI704Uij3dQDyXXxI2LwtjLNfuDFLG4V6ysjwTPj7HnMGO2cK8PySNYoo11Eqaq7MC/ORHCqCxKTFY2JjUPpeqYcAhanQz4Ab923IFGUwU9EqU37q79ZoaVI5BrrM++9C3r6j4avzTlE2Cc8sDTZwmDp2+qlShucbST3pYM9sMTt3oABlz93ACqdHH8n/wdefK2h85eSyzI7YSiEW+f0oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfyvglgLFyAScwZyVRsOAMKMn85ka6MmQhFBOPcqcZY=;
 b=NyYGTb422amN3VCqa2TVceQMM1I7ks9H9ExJWwQc4hQkbJrzBDaPQpviQ+9QJPcIt9ch+T1hts0GUP1DERQm8P6ngXeXqMjoUjnEeqGWWf8VK2AIIDEm2/Qwq3w7Qu1jpMqh4/h7yvbBCWR3++58wW5ThoUaaKRNbakUoHudZIQ=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by SA0PR21MB1882.namprd21.prod.outlook.com
 (2603:10b6:806:d8::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.4; Mon, 11 Jul
 2022 01:29:08 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.003; Mon, 11 Jul 2022
 01:29:08 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 06/12] net: mana: Define data structures for protection
 domain and memory registration
Thread-Topic: [Patch v4 06/12] net: mana: Define data structures for
 protection domain and memory registration
Thread-Index: AQHYgSXZ61KmVR7xZES2DK7HXoNYta122DDw
Date:   Mon, 11 Jul 2022 01:29:08 +0000
Message-ID: <SN6PR2101MB13276E8879F455D06318118EBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-7-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1655345240-26411-7-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b2f59ba0-0f91-467d-abb8-8c0490284381;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-09T23:40:16Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2b62f9f-6db1-4c64-7fff-08da62dcc031
x-ms-traffictypediagnostic: SA0PR21MB1882:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DsAEXYjS1YZ9joTLWV68CIcVsRI1W8FRZaVVDQfQs5Db5ldLbuvPCDH3J+0t/8KrgdfPeS+pzbra7csP+q4oxItIwhRL6unpk4DtBTMcZ8Hg5+p3N7akoSMcwJnx0KTZt5AKf6e62aj1IP5DQ3rYtBZaiSfHzaexOaIklp/+E00TWJX7DtSN18MLRHBeUDmPCjhcIxIBFrzXz/q4T9u2hIMyaM3i8sNALjd4kqa7z1uyxk84i984o3o79A7iDi9mUYKOiEWrgrAxKobLCa8k5oeMUBfisRNt4aRFMqcQi+TwPv6eDOCV1khHZ3RUsoFl3cTIjPc0KQnIY5dbAAUEM3ZGnCQMB4jwFQCq74QUEBaewX3SsRbvVSKCiaAg49k8MMipw6sayA4KPchPfc7bxs/qXaE1q3xkqZhLIVT6m8JN0jqf+XX5zy1/E4cS7gthSvPY8sWHDN81gRVL0vClc388VxnWDQrRW7kp7mXjfwbXMFAnWH6l4zA4mo4mLffBvZmUz9yd7X3KmWB62B/h74vpqPX1I6+VKXyZfsUrzMPypQ34VbLesFFBLzC0iUT8KH4TZJHSImA8vZ30eO4X+8kxmj7nxg53jBsMRO8rVEDGsH1K3v1amlf1H30/qvIUjKXx4A9TE125w9KydIoiVMtwH+7Rk1VlnKIhXbf1xKTqiJth8Ib9wlDaVORVbjj8Mxad1qGFzBpNb9rGb00gyYLb7SojqqT3sRP0g+tsyti8OEhJOjtix6VT2wmm1Td1QEnqE+1Bc/lNXSwIX4bUf5Izp94JJIpZ3kuTs2vmnZAQ/gq4lTGTM+T9lCVidH4QBQ+NRyGZumu6PjSpUwlzvGeGwD/HxvbdPY+yk4V6xgcNkBphnQIpBrOqef2gFOqO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(376002)(396003)(366004)(451199009)(52536014)(478600001)(110136005)(10290500003)(71200400001)(66946007)(2906002)(8676002)(64756008)(66476007)(41300700001)(76116006)(4326008)(66556008)(66446008)(7416002)(5660300002)(83380400001)(54906003)(316002)(8936002)(6636002)(7696005)(6506007)(8990500004)(33656002)(26005)(186003)(9686003)(82950400001)(38070700005)(86362001)(122000001)(82960400001)(55016003)(921005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Mtjkp94vce2z7n662cbeGS83/Pb9xDU2P+Kdb7UZxzwzs4IpSh+x6N7q1VPo?=
 =?us-ascii?Q?KOBMbP5y9RwbBWDZjhhRekjtbUDIlfFFYoM6nZrXlNtwPSf0YiSSomYL5KOZ?=
 =?us-ascii?Q?q6azhxs3ipVjoqcWYEHp1b+8UG1YFKjm/0E1ddVdW4qPELsKd+bw67kVfBlI?=
 =?us-ascii?Q?yIzHQdTadQn64SWxXEficop0MkM7IrkyVYZCYRoLR7F9pPFCNsXoI4SGY2y9?=
 =?us-ascii?Q?3VpWvzO1uooV71RRpVjKbZwIGEYwSzEyMY7U+wmOsJYGVR10P1FWDJxLaX5T?=
 =?us-ascii?Q?rh4hfGED/cvuKB6qk0xIoBdIzLml5c4F0tPGsZzrtwnoSf97LvpKohQX/QsG?=
 =?us-ascii?Q?Hu0yHwKuJ4TokKa3W5PhuA//rAt1BVChnxgw7NqgUllDSglWniY6uteN0oI6?=
 =?us-ascii?Q?Hx02XUG1VCcUh7Icag7w5wiVCIds1XaSAIP05Z2e2r/cb0EpDk3ZeE4XYJds?=
 =?us-ascii?Q?2qKRtCXTDlYuYAPOQiWY3IfyiBGZChj1zAzdFKbs2RFqTP52ia903nOv2Gmv?=
 =?us-ascii?Q?G0eqls5TvJK9T12CbmXn1bWN41YA8ug5LkbXXEEW1tGVkrOrj+gOMCjZLC4O?=
 =?us-ascii?Q?m7ZLiU/ShE+C2d+TTi/rGG8P6c63/YxOQPD/PIEifE2SqnkdCjXLtPizF7uS?=
 =?us-ascii?Q?LOZe8+d4pOsEBfeAxX7o4S22Y/EgiRtpDpE9hXC7H49/VmKsIZr/PrOaIR+6?=
 =?us-ascii?Q?+xeqv2x3Kus7z+/agg20TK80YKhx9WB2BjP0Xi7ana0uO0wVUyTaIforvSt9?=
 =?us-ascii?Q?kyHISOmn4fZTxTdjXjlzkPkyhvOZULKhT4i32cycGzpemeJnwG7Y40hXNIpN?=
 =?us-ascii?Q?yXWux/BA++L3tLwalMLxgW1SnvKsy6d34BADkP7DviOl91ckewIC9AUDScZ1?=
 =?us-ascii?Q?zv8ejD9Yc/Ec+H8aTtTUYw2qVbcBMlW8YiLYnGsnBi47QANB9mhQLeUK60Gz?=
 =?us-ascii?Q?fPAMtybFEekhdcT0LehVsTnQpLWrnmGBXiqp/5tBSiLF2jIFVEqP2tpcbW4v?=
 =?us-ascii?Q?LA3sloUr6/nZsqZg4Wn1nnopf3dlqoMxVo1KGrmdrHltVatReFTOGw2RHrwX?=
 =?us-ascii?Q?3S7QefJRKmw+nQDGtKyxsHpENYpaOWWWdEz3MpYwInktKtUgEY5s8jGjRwAt?=
 =?us-ascii?Q?AihKsv0jz31+37X2dq2jqOwkMBzokIUg1jCCtq3SYn/q4xyC83V8tkks0DiB?=
 =?us-ascii?Q?tSN2ChpN9oi/4eNwmxfyK5KtmZ5Sw8xlnAqjrKHo9uiG9hGcLMz29IYsrjPg?=
 =?us-ascii?Q?7+ibaMKO4p7aZ9fwwdwR1HjbFTzyIOHn8+UVI7WCoJxfxyPksUsnjJzUAsZb?=
 =?us-ascii?Q?xKWOYZjo9UfX5x/vfwAPKvZlAR3DkHnDJxTn/qBMh+vsv8U3T0YrBMyKw3Kb?=
 =?us-ascii?Q?FunyPRr77aTy9FCpwEqwiyUqP04dsQhGM0DzYRM4qv7IiX3lk+5Jyl79Yr1w?=
 =?us-ascii?Q?lM2ql1Ax+uJ2O9MHedm1kvPEBqNiUW0YdTdayFmrbyi9YCAF6LG1AKA7Lq1L?=
 =?us-ascii?Q?Lmwb64Fvd7oDbhMJYnKAYKftzGlGiHcWzDKVRMtk09STR0Apdnw2e4w/m9q+?=
 =?us-ascii?Q?qbG4YWT+ZeV4t0xq6RPBMX1+Tp+SgWK01mAY6XCn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b62f9f-6db1-4c64-7fff-08da62dcc031
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 01:29:08.2518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uxv3Ib64cpXTylU5FAuwJYo8hW1TcoGupSrg3iFOgjEF2dXESU4kemkJgvKVYuSQ/XeTSWLutz0nyRAsQXj7mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR21MB1882
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Wednesday, June 15, 2022 7:07 PM
>=20
> The MANA hardware support protection domain and memory registration for
s/support/supports
=20
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h
> b/drivers/net/ethernet/microsoft/mana/gdma.h
> index f945755760dc..b1bec8ab5695 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma.h
> +++ b/drivers/net/ethernet/microsoft/mana/gdma.h
> @@ -27,6 +27,10 @@ enum gdma_request_type {
>  	GDMA_CREATE_DMA_REGION		=3D 25,
>  	GDMA_DMA_REGION_ADD_PAGES	=3D 26,
>  	GDMA_DESTROY_DMA_REGION		=3D 27,
> +	GDMA_CREATE_PD			=3D 29,
> +	GDMA_DESTROY_PD			=3D 30,
> +	GDMA_CREATE_MR			=3D 31,
> +	GDMA_DESTROY_MR			=3D 32,
These are not used in this patch. They're used in the 12th=20
patch for the first time. Can we move these to that patch?

>  #define GDMA_RESOURCE_DOORBELL_PAGE	27
> @@ -59,6 +63,8 @@ enum {
>  	GDMA_DEVICE_MANA	=3D 2,
>  };
>=20
> +typedef u64 gdma_obj_handle_t;
> +
>  struct gdma_resource {
>  	/* Protect the bitmap */
>  	spinlock_t lock;
> @@ -192,7 +198,7 @@ struct gdma_mem_info {
>  	u64 length;
>=20
>  	/* Allocated by the PF driver */
> -	u64 gdma_region;
> +	gdma_obj_handle_t dma_region_handle;
The old name "gdma_region" is shorter and it has "gdma"
rather than "dma".=20

The new name is longer. When one starts to read the code for
the first time, I feel that "dma_region_handle" might be confusing
as it's similar to "dma_handle" (which is the DMA address returned
by dma_alloc_coherent()). "dma_region_handle" is an integer
rather than a memory address.=20

You use the new name probably because there is a "mr_handle "
in the 12 patch. I prefer the old name, though the new name is
also ok to me. If you decide to use the new name, it would be
great if this patch could split into two patches: one for the
renaming only, and the other for the real changes.

>  #define REGISTER_ATB_MST_MKEY_LOWER_SIZE 8
> @@ -599,7 +605,7 @@ struct gdma_create_queue_req {
>  	u32 reserved1;
>  	u32 pdid;
>  	u32 doolbell_id;
> -	u64 gdma_region;
> +	gdma_obj_handle_t gdma_region;
If we decide to use the new name "dma_region_handle", should
we change the field/param names in the below structs and
functions as well (this may not be a complete list)?
  struct mana_ib_wq
  struct mana_ib_cq
  mana_ib_gd_create_dma_region
  mana_ib_gd_destroy_dma_region

>  	u32 reserved2;
>  	u32 queue_size;
>  	u32 log2_throttle_limit;
> @@ -626,6 +632,28 @@ struct gdma_disable_queue_req {
>  	u32 alloc_res_id_on_creation;
>  }; /* HW DATA */
>=20
> +enum atb_page_size {
> +	ATB_PAGE_SIZE_4K,
> +	ATB_PAGE_SIZE_8K,
> +	ATB_PAGE_SIZE_16K,
> +	ATB_PAGE_SIZE_32K,
> +	ATB_PAGE_SIZE_64K,
> +	ATB_PAGE_SIZE_128K,
> +	ATB_PAGE_SIZE_256K,
> +	ATB_PAGE_SIZE_512K,
> +	ATB_PAGE_SIZE_1M,
> +	ATB_PAGE_SIZE_2M,
> +	ATB_PAGE_SIZE_MAX,
> +};
> +
> +enum gdma_mr_access_flags {
> +	GDMA_ACCESS_FLAG_LOCAL_READ =3D (1 << 0),
> +	GDMA_ACCESS_FLAG_LOCAL_WRITE =3D (1 << 1),
> +	GDMA_ACCESS_FLAG_REMOTE_READ =3D (1 << 2),
> +	GDMA_ACCESS_FLAG_REMOTE_WRITE =3D (1 << 3),
> +	GDMA_ACCESS_FLAG_REMOTE_ATOMIC =3D (1 << 4),
> +};
It would be better to use BIT_ULL(0), BIT_ULL(1), etc.

>  /* GDMA_CREATE_DMA_REGION */
>  struct gdma_create_dma_region_req {
>  	struct gdma_req_hdr hdr;
> @@ -652,14 +680,14 @@ struct gdma_create_dma_region_req {
>=20
>  struct gdma_create_dma_region_resp {
>  	struct gdma_resp_hdr hdr;
> -	u64 gdma_region;
> +	gdma_obj_handle_t dma_region_handle;
>  }; /* HW DATA */
>=20
>  /* GDMA_DMA_REGION_ADD_PAGES */
>  struct gdma_dma_region_add_pages_req {
>  	struct gdma_req_hdr hdr;
>=20
> -	u64 gdma_region;
> +	gdma_obj_handle_t dma_region_handle;
>=20
>  	u32 page_addr_list_len;
>  	u32 reserved3;
> @@ -671,9 +699,114 @@ struct gdma_dma_region_add_pages_req {
>  struct gdma_destroy_dma_region_req {
>  	struct gdma_req_hdr hdr;
>=20
> -	u64 gdma_region;
> +	gdma_obj_handle_t dma_region_handle;
>  }; /* HW DATA */
>=20
> +enum gdma_pd_flags {
> +	GDMA_PD_FLAG_ALLOW_GPA_MR =3D (1 << 0),
> +	GDMA_PD_FLAG_ALLOW_FMR_MR =3D (1 << 1),
> +};
Use BIT_ULL(0), BIT_ULL(1) ?

> +struct gdma_create_pd_req {
> +	struct gdma_req_hdr hdr;
> +	enum gdma_pd_flags flags;
> +	u32 reserved;
> +};
> +
> +struct gdma_create_pd_resp {
> +	struct gdma_resp_hdr hdr;
> +	gdma_obj_handle_t pd_handle;
> +	u32 pd_id;
> +	u32 reserved;
> +};
> +
> +struct gdma_destroy_pd_req {
> +	struct gdma_req_hdr hdr;
> +	gdma_obj_handle_t pd_handle;
> +};
> +
> +struct gdma_destory_pd_resp {
> +	struct gdma_resp_hdr hdr;
> +};
> +
> +enum gdma_mr_type {
> +	/* Guest Physical Address - MRs of this type allow access
> +	 * to any DMA-mapped memory using bus-logical address
> +	 */
> +	GDMA_MR_TYPE_GPA =3D 1,
> +
> +	/* Guest Virtual Address - MRs of this type allow access
> +	 * to memory mapped by PTEs associated with this MR using a virtual
> +	 * address that is set up in the MST
> +	 */
> +	GDMA_MR_TYPE_GVA,
> +
> +	/* Fast Memory Register - Like GVA but the MR is initially put in the
> +	 * FREE state (as opposed to Valid), and the specified number of
> +	 * PTEs are reserved for future fast memory reservations.
> +	 */
> +	GDMA_MR_TYPE_FMR,
> +};
> +
> +struct gdma_create_mr_params {
> +	gdma_obj_handle_t pd_handle;
> +	enum gdma_mr_type mr_type;
> +	union {
> +		struct {
> +			gdma_obj_handle_t dma_region_handle;
> +			u64 virtual_address;
> +			enum gdma_mr_access_flags access_flags;
> +		} gva;
Add an empty line to make it more readable?

> +		struct {
> +			enum gdma_mr_access_flags access_flags;
> +		} gpa;
Add an empty line?

> +		struct {
> +			enum atb_page_size page_size;
> +			u32  reserved_pte_count;
> +		} fmr;
> +	};
> +};

The definition of struct gdma_create_mr_params is not naturally aligned.
This can potenially cause issues.

According to my test, sizeof(struct gdma_create_mr_params) is 40 bytes,
meaning the compiler adds two "hidden" fields:

struct gdma_create_mr_params {
        gdma_obj_handle_t pd_handle;                        // offset =3D 0
        enum gdma_mr_type mr_type;                        // offset =3D 8
+       u32 hidden_field_a;
        union {                                            // offset =3D 0x=
10
                struct {
                        gdma_obj_handle_t dma_region_handle;   // offset =
=3D0x10
                        u64 virtual_address;                    // offset =
=3D0x18
                        enum gdma_mr_access_flags access_flags;  // offset =
=3D0x20
+                       u32 hidden_field_b;
                } gva;

We'll run into trouble some day if the Linux VF driver or the host PF
driver adds something like __attribute__((packed)).

Can we work with the host team to improve the definition? If it's
hard/impossible to change the PF driver side definition, both sides
should at least explicitly define the two hidden fields as reserved fields.

BTW, can we assume the size of "enum" is 4 bytes? I prefer using u32
explicitly when a struct is used to talk to the PF driver or the device.

If we decide to use "enum", I suggest we add=20
BUILD_BUG_ON(sizeof(struct gdma_create_mr_params) !=3D 40)
to make sure the assumptin is true.

BTW, Haiyang added "/* HW DATA */ " to other definitions,=20
e.g. gdma_create_queue_resp. Can you please add the same comment
for consistency?

> +struct gdma_create_mr_request {
> +	struct gdma_req_hdr hdr;
> +	gdma_obj_handle_t pd_handle;
> +	enum gdma_mr_type mr_type;
> +	u32 reserved;
> +
> +	union {
> +		struct {
> +			enum gdma_mr_access_flags access_flags;
> +		} gpa;
> +
> +		struct {
> +			gdma_obj_handle_t dma_region_handle;
> +			u64 virtual_address;
> +			enum gdma_mr_access_flags access_flags;

Similarly, there is a hidden u32 field here. We should explicitly define it=
.

> +		} gva;
Can we use the same order of "gva; gpa" used in
struct gdma_create_mr_params?

> +		struct {
> +			enum atb_page_size page_size;
> +			u32 reserved_pte_count;
> +		} fmr;
> +	};
> +};

Add BUILD_BUG_ON(sizeof(struct gdma_create_mr_request) !=3D 80) ?
Add /* HW DATA */ ?

> +struct gdma_create_mr_response {
> +	struct gdma_resp_hdr hdr;
> +	gdma_obj_handle_t mr_handle;
> +	u32 lkey;
> +	u32 rkey;
> +};
> +
> +struct gdma_destroy_mr_request {
> +	struct gdma_req_hdr hdr;
> +	gdma_obj_handle_t mr_handle;
> +};
> +
> +struct gdma_destroy_mr_response {
> +	struct gdma_resp_hdr hdr;
> +};
> +

None of the new defines are really used in this patch:

+enum atb_page_size {
+enum gdma_mr_access_flags {
+enum gdma_pd_flags {
+struct gdma_create_pd_req {
+struct gdma_create_pd_resp {
+struct gdma_destroy_pd_req {
+struct gdma_destory_pd_resp {
+enum gdma_mr_type {
+struct gdma_create_mr_params {
+struct gdma_create_mr_request {
+struct gdma_create_mr_response {
+struct gdma_destroy_mr_request {
+struct gdma_destroy_mr_response

The new defines are used in the 12th patch for the first time.
Can we move these to that patch or at least move these defines
to before the 12th patch?

