Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E285572CAC
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 06:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiGMEjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 00:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiGMEjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 00:39:22 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021026.outbound.protection.outlook.com [52.101.57.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EB4B8509;
        Tue, 12 Jul 2022 21:39:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qg8m5Cjl8JvzGoepNJUEbre5Oh/2cTesFGqMmDooHIsBKm1b1YkhWNuOEwmMAmOtNEO9j4S7l9NuWy9rN+jgj07uq9gKNN3XZaBZeZx3LMgYc3iMdHB02JvIV8yGMqA64cbxOV+Co8QuCBawTzbpY72hTEeT9mMuFjYr2MxgM4ZkO/NVvzAqgh1Jf0fJihuKPX+LudYJ5YxltEbcPu0i23cBrLAWymVKAuZEEy7DkcbrKrO8JMZhQbJMgdOLQTG/ruS9KXS8jlVKTXEhisFNt1GgTGr1Dn8eP06efWM/oEaY9hpPaW2IITDCqGwLm5bCwmCfQXy44adarYRAMYXE2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Nl4zVeVrl5G2SeidDcUao3HHL6aqbSYX0HfJxUSyUc=;
 b=F80dfH6880UzejZJZGxqhTkYj52MhbX0EvmtpWJwf2xie4JyWlvgaf79fG2fk3uWc95butkhoqhf0xoGeFtbym/6gAo6OYLaqcf3ydN1u3ur0/oiFYjrp8qCgLucv63YpYcYGpBni/mQcFK2yAPBOCen9klF0ftOYqJmvlMPhTo9crjzLBHBDsx7wy/3gK0o/FisyI6TM5VUjQ+nm2ydkcwmRtv1odeg55uBqAwi4gcwAUnVqHn5Jly5/fJLfWCh/y7+VOOJIfnsVnRntnJD1pfe+zy8mHhJt4diHsKhdUm4zxwqoch6I7+CO/b6o7uanjLWK06FHugDNOI0ww5xZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Nl4zVeVrl5G2SeidDcUao3HHL6aqbSYX0HfJxUSyUc=;
 b=iBigtKWPMTUd2sfrKVIpYTuNsE0mjSa8gxUiLTv0+PgMntTD3mvc1tO7lRZnYR6gjDeVo816q9OSDoLCy1O9s9k8BP3p2z8ceyyhlJBaleual+vAGaFyNoZXbN9PipGmkXEoxvswvmwQ0FweF2twrX/9zvFf6T6NHxGJBvS0vFE=
Received: from BL1PR21MB3283.namprd21.prod.outlook.com (2603:10b6:208:39b::8)
 by SA0PR21MB1948.namprd21.prod.outlook.com (2603:10b6:806:ea::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.5; Wed, 13 Jul
 2022 04:39:15 +0000
Received: from BL1PR21MB3283.namprd21.prod.outlook.com
 ([fe80::b1e4:5093:ad3b:fdcb]) by BL1PR21MB3283.namprd21.prod.outlook.com
 ([fe80::b1e4:5093:ad3b:fdcb%5]) with mapi id 15.20.5458.005; Wed, 13 Jul 2022
 04:39:14 +0000
From:   Ajay Sharma <sharmaajay@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>
Subject: RE: [Patch v4 06/12] net: mana: Define data structures for protection
 domain and memory registration
Thread-Topic: [Patch v4 06/12] net: mana: Define data structures for
 protection domain and memory registration
Thread-Index: AQHYlMWe6Mjt5DPo/EWUPCCAswsmA617uekQ
Date:   Wed, 13 Jul 2022 04:39:14 +0000
Message-ID: <BL1PR21MB3283DDCF92E59105F9D40330D6899@BL1PR21MB3283.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-7-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB13276E8879F455D06318118EBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
In-Reply-To: <SN6PR2101MB13276E8879F455D06318118EBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b2f59ba0-0f91-467d-abb8-8c0490284381;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-09T23:40:16Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8904befd-8231-4f23-5357-08da6489a3b8
x-ms-traffictypediagnostic: SA0PR21MB1948:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p1ZFaQqa0gtEOJx8tD0nR2PJhHrqgUDNe9+YNPrPg5C7YEU2QI8vATe9NsmofYCD3XrlcfLd+hd8+aJOB7zbc7RxJHg/hfLxDwb3DKDnn+hpVbb14UYWQMEhqHlpq3rZWAlGIcuPunTNITTsxpPI27n/JfQzLszR3OhMmAIz6Ml8/Il1F/TJvYgw4BYWL+7roBOKEKvgTPfElIWK/hOi84gkob6JCU+EW8sHyFEr7sSCHC1S/60/vcGYjFTnIC846Ot5+gnn7BGD3yzirjiAMEDndpWzFsM9jM3LQykoMK02+sJJtSbocCMmMRPql8n2+t8UcyGdqonJEzTr/ApZLtkOImdopyfJyhbebvSX4JjamUN7Aq3XTGZ4VCK2VV/sPvqugggrjWEVrQlS+TV8/l4bzw7jjnvOPg4f48M54bmqs08fUNsfiI8wnNwqPGIKSO0INDFnDc5XC9vtsMe9w4MDjd0MnEUWE2ZtfZ0JAsnV0AR0q4FQ6RKKd63oFvugZBCtRTlL10wf/xxIfI4yf2ZUWWSUi0kkpIC9OsmqRmMgrfWMvsngi4bohqaFpPZMe0mvAv/GcolgAstkJTHQP+jfoxKB1joPvGtLuo1TafMXW9ZVS6HTdQ78hY3D3ezVDdqpT7HkbnHi/mRvv0U7z9+PHPjWVuC6lgE8/d43pexHiJgZ12Nz9QSw1OvY3VuA5ceGzPa7abM1kprIlm8/QvkfqM4NA9sWmHHfr+KfH/yYdFQrLobRcMCHJZWx4on/pgDqpQFr0crYjIPq8VEMUV1oaG1937G3KafZQlUzLKRrP0T29OBbTAmV/4/wKU1J9GMhCpozFMylNqt3hdYSgZ5mNVnJJ25YExcbRaOne4gqPpQ0T+CvVCZ/xKUgBkbA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR21MB3283.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(451199009)(921005)(2906002)(82950400001)(82960400001)(38070700005)(122000001)(8990500004)(33656002)(478600001)(186003)(83380400001)(55016003)(8676002)(4326008)(86362001)(316002)(76116006)(107886003)(54906003)(52536014)(5660300002)(8936002)(64756008)(66446008)(66476007)(66556008)(66946007)(7416002)(53546011)(110136005)(10290500003)(71200400001)(7696005)(6506007)(38100700002)(9686003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Lm3lanp7g5A0KZlp5VOyhG7Lq8r+Bmm7Zv7p8fkkpGb4E85AkK03lNuGcQhX?=
 =?us-ascii?Q?gNC2yUbp1N2JpjhqpAJg4BQpuPKsFf5VxmW5ab3Dq+gaiiZkWvnTa5HPuSeO?=
 =?us-ascii?Q?TrR3uXnUB2ITEOvly330BVMDVRGPa8FLCAEMqBIOOxa8jsUvFFTJ85u5Xvby?=
 =?us-ascii?Q?D1WwlzCD9im/hVqqMz0rYxNjRjJOPpM2OJkuaFwV2y2noCKZulTIiL/YwOvI?=
 =?us-ascii?Q?6/LPsYLcnuH+wq+Q7fEPeOkrhs2Lapsr1sfvsu5KGK+NKXMXqb9QxEjhit6V?=
 =?us-ascii?Q?3fXuQ/JTbRG9rsrV9VTGWxzEK48V0qPRFYsolC4W1f2h6ubB27cs8h/lO1kV?=
 =?us-ascii?Q?fWOZX63LVMKe6wesbT2YMpLNE9/0/EbMPgg1rUQew86q3nD7c0m+HN9/87l5?=
 =?us-ascii?Q?N67jOZB1PK7wL/TPBpsFEdyhoOJNXsStuwAXLNQljNkS7ISbNHjCQhF/qlXw?=
 =?us-ascii?Q?LLPP04HCqqkpXul+Mh4Fx5kK93gftqeCT965IN9NeXu2s1YyeHnLJN+pkDwH?=
 =?us-ascii?Q?3yhq0vBzLfo1iqe2BuAzvi5Vu5N87iIICQcxekhbS4xhCYr7RwwzPibUdrAh?=
 =?us-ascii?Q?zXX7Pb2p9T9QfJ2VkcpgRmmjLqDTml6rsftBtRi3Z4CPiGsAb4t0xvy2jbRG?=
 =?us-ascii?Q?QX5728/ajjB6yk8YLlYaM6mcJ3cCKW/0GPaKkygTocFbKcbwGucmOOHWqk8S?=
 =?us-ascii?Q?svzhl3IKX00OQd1v7OYnvURLzdB9DQxpF9aMjWDuSR+yj8i1r2W6RQjWGQrB?=
 =?us-ascii?Q?C9LlqoG00K2+lUsCTrHE4hZUzqfaiAfaNemCN89r/MH/s4Sm/OT4Wil8u2h4?=
 =?us-ascii?Q?fYPR92xLwAJrMQoZWn7Adrveo30BLpAF1nP8CnLboefnSCiOsdIq80rlEo9y?=
 =?us-ascii?Q?s0twblw8fRqvGQC7n3i76ES7FL/QxCpnIm2eBxfLv7rQJYBKogYmntJeKAPM?=
 =?us-ascii?Q?vfCWM4g3Fm0w5M5T7shf/U/SdhCwOVMSBGdgHZb4KG9AOaYbfIfNy/PYI3/j?=
 =?us-ascii?Q?c7O0/pdrSjNPnlWAK/n2q/JAsJUf2wY/UjFV2XoPEwx7MycG3Cu+yK33Jwl6?=
 =?us-ascii?Q?QB/V8GD2KwVBpLsjKEU0NO4VYVjufNHyw3jff/cKGmW6y5k4x6JKgDDCydPd?=
 =?us-ascii?Q?RgYpX6a3Vo2tE8grC6KxsM0e9arxOqs+zduLHY0EkdkJ5eL5CzO6N3uT2iQw?=
 =?us-ascii?Q?2gxKqUfXahW18qhkFAQ82c0Uj49q+5NXwbkt+ZuRFyGwnzazjoe3wa0CLBII?=
 =?us-ascii?Q?MrVrsNHv0hDi3S0w+zQ4S+ukTGa0en6PnwvmOWT9uRJ/GZA/RO3czRWSu8gc?=
 =?us-ascii?Q?6j/zPPdfT+t7UEIpQMmngmJEkGJu1vaI+B+5UHmrHvQDiwbY4Iz6wGlonNtz?=
 =?us-ascii?Q?sUMNJX4FlsyrjHCEQ9DncSKRjQzrFKXMqakGvO6VbQmAS4N5aSKDteJi8dvS?=
 =?us-ascii?Q?HrsgLBz7t0R79an2oI1CmM0m7c7L8YG8z3QNwfof6maCNK0orNVYqho8aA1A?=
 =?us-ascii?Q?WFXl9OloDH6j1jHtPYlSTgDn1nUr4X/jiEJ+76OAChYP+lgPN//A3tfOpMnw?=
 =?us-ascii?Q?NDTnuq1K+9Daq2Zi+xzP2Xl1y+3/ZuRjTd+ENFJS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR21MB3283.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8904befd-8231-4f23-5357-08da6489a3b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 04:39:14.6097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eo1vM16ZNbM2ZwQpySdqxL4denOXG+jvuJL+KuzFc5RgEoDuRhDuUMtonFlM7UFUcRKD57XOXUtJTdV/hcFXZK7LDxF++b4ptup/muhVZIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR21MB1948
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see inline.

-----Original Message-----
From: Dexuan Cui <decui@microsoft.com>=20
Sent: Sunday, July 10, 2022 8:29 PM
To: Long Li <longli@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Haiy=
ang Zhang <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.c=
om>; Wei Liu <wei.liu@kernel.org>; David S. Miller <davem@davemloft.net>; J=
akub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Jason Gun=
thorpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>; edumazet@google.c=
om; shiraz.saleem@intel.com; Ajay Sharma <sharmaajay@microsoft.com>
Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger=
.kernel.org; linux-rdma@vger.kernel.org
Subject: RE: [Patch v4 06/12] net: mana: Define data structures for protect=
ion domain and memory registration

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Wednesday, June 15, 2022 7:07 PM
>=20
> The MANA hardware support protection domain and memory registration=20
> for
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
These are not used in this patch. They're used in the 12th patch for the fi=
rst time. Can we move these to that patch?

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

The new name is longer. When one starts to read the code for the first time=
, I feel that "dma_region_handle" might be confusing as it's similar to "dm=
a_handle" (which is the DMA address returned by dma_alloc_coherent()). "dma=
_region_handle" is an integer rather than a memory address.=20

You use the new name probably because there is a "mr_handle "
in the 12 patch. I prefer the old name, though the new name is also ok to m=
e. If you decide to use the new name, it would be great if this patch could=
 split into two patches: one for the renaming only, and the other for the r=
eal changes.

>  #define REGISTER_ATB_MST_MKEY_LOWER_SIZE 8 @@ -599,7 +605,7 @@ struct=20
> gdma_create_queue_req {
>  	u32 reserved1;
>  	u32 pdid;
>  	u32 doolbell_id;
> -	u64 gdma_region;
> +	gdma_obj_handle_t gdma_region;
If we decide to use the new name "dma_region_handle", should we change the =
field/param names in the below structs and functions as well (this may not =
be a complete list)?
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
> +	GDMA_ACCESS_FLAG_REMOTE_ATOMIC =3D (1 << 4), };
It would be better to use BIT_ULL(0), BIT_ULL(1), etc.
Agreed, updated in the new patch.

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
> @@ -671,9 +699,114 @@ struct gdma_dma_region_add_pages_req {  struct=20
> gdma_destroy_dma_region_req {
>  	struct gdma_req_hdr hdr;
>=20
> -	u64 gdma_region;
> +	gdma_obj_handle_t dma_region_handle;
>  }; /* HW DATA */
>=20
> +enum gdma_pd_flags {
> +	GDMA_PD_FLAG_ALLOW_GPA_MR =3D (1 << 0),
> +	GDMA_PD_FLAG_ALLOW_FMR_MR =3D (1 << 1), };
Use BIT_ULL(0), BIT_ULL(1) ?
Agreed and updated the patch

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
Done.
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
This is union and so the biggest element is aligned to word. I feel since t=
his is not passed to the hw it should be fine.

According to my test, sizeof(struct gdma_create_mr_params) is 40 bytes, mea=
ning the compiler adds two "hidden" fields:

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

We'll run into trouble some day if the Linux VF driver or the host PF drive=
r adds something like __attribute__((packed)).

Can we work with the host team to improve the definition? If it's hard/impo=
ssible to change the PF driver side definition, both sides should at least =
explicitly define the two hidden fields as reserved fields.

BTW, can we assume the size of "enum" is 4 bytes? I prefer using u32 explic=
itly when a struct is used to talk to the PF driver or the device.

If we decide to use "enum", I suggest we add BUILD_BUG_ON(sizeof(struct gdm=
a_create_mr_params) !=3D 40) to make sure the assumptin is true.

BTW, Haiyang added "/* HW DATA */ " to other definitions, e.g. gdma_create_=
queue_resp. Can you please add the same comment for consistency?

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
Can we use the same order of "gva; gpa" used in struct gdma_create_mr_param=
s?
Done, although it shouldn't matter in union case.

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
Can we move these to that patch or at least move these defines to before th=
e 12th patch?

