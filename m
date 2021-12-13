Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E453047328C
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241288AbhLMQ4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:56:51 -0500
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com ([104.47.57.177]:18764
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241224AbhLMQ4o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 11:56:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UB+OrO2PBs9yc8JKNKwgjXfFBf7EofDbtU4bgabdcEf+wtRZMJjOWDhsAwi3j6QrMbXZsT4UEzf3dMxUMrh+YA1QbSFSeph6AfHVwsCdWD1/yuPlNXwOdPCkSomwZ70IdAgsjYPPNzDcQm99jBequrwI8/Obv/cn1K1NHNXpaKel4mYtWwM/y3PHu7QIrtWuB8uhVL+EBRy89DU9Cf/JNGzM4elE3AoRe0DT9M8ZqL7DWYrAnIT2GCbflbI5Vt3FPWWkvRU7gG+RMSnJ/2QYGuhLF+Drw9kzRd7H8fUNFGcCbs2HB8YJsQ9sspYKWZ1tC7/qxndRnN3xuw1Hkh7fHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vowl/On6xbtDSDaqK1juomqGWTRu6Mu3TLXtVf4Gvyo=;
 b=HbzNJbFBr5Q8Hra+iJRj+yDrengr/APRFaBVbXMG/CPAiNaAISPvYcWLNlKjyB/oJ8YIzRVPXyyCtzfB1MPRyMROb7ZNEfd/+GcgQmJxzGmErXmdDapNSK8E8Tu68TF5p+ZzlDtyyFSm2HjunRhSe0eLT43HYbdyNb+MoI5QBqXGNFsqUnjBiLsNMb1zWVn+i7FxMAa1yG+7HQeUnZMd6D8Gfblug3knoCbHVFyzL8gzqhnMozgqL5w1dUa6VprKwWhp8By/GIPYT0MgRw3jiwhN256NxvwgSnWEq7go0MaQTAv5SZfqYzFQmZVFvAHVmC/4eDmJfYrMQ/Io9DD6fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vowl/On6xbtDSDaqK1juomqGWTRu6Mu3TLXtVf4Gvyo=;
 b=fV34wNcOuBnlgZlE6+bnwNA8eZEfiXGRhp7J0dgbfGnWD361vPqVhkrNJ02Rl4jtksilPMSKC1wO/odxXtvU1UZu9stznKha3S8ng7yGVR6Q4s3EsO8HlHxFzzrvDkyWDMJorNh9YFhpyBtOfK/Ng6Dq+XaNK8Qk69e4CNf10CU=
Received: from MN2PR21MB1295.namprd21.prod.outlook.com (2603:10b6:208:3e::25)
 by BN7PR21MB1732.namprd21.prod.outlook.com (2603:10b6:406:ad::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.6; Mon, 13 Dec
 2021 16:56:30 +0000
Received: from MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::8c70:eedb:b406:726]) by MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::8c70:eedb:b406:726%8]) with mapi id 15.20.4801.010; Mon, 13 Dec 2021
 16:56:30 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>, "joro@8bytes.org" <joro@8bytes.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V7 5/5] net: netvsc: Add Isolation VM support for netvsc
 driver
Thread-Topic: [PATCH V7 5/5] net: netvsc: Add Isolation VM support for netvsc
 driver
Thread-Index: AQHX7/EWMl5F6LxDHkely1IHtTPBiqwwpHUA
Date:   Mon, 13 Dec 2021 16:56:30 +0000
Message-ID: <MN2PR21MB129599B0242599704B82433CCA749@MN2PR21MB1295.namprd21.prod.outlook.com>
References: <20211213071407.314309-1-ltykernel@gmail.com>
 <20211213071407.314309-6-ltykernel@gmail.com>
In-Reply-To: <20211213071407.314309-6-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9e602df1-03ad-49c5-a979-13134afc720b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-13T16:55:02Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc92fa70-e668-4fae-a26a-08d9be598307
x-ms-traffictypediagnostic: BN7PR21MB1732:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BN7PR21MB17327513C01A52B61B1D0D78CA749@BN7PR21MB1732.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k5s/T/hDITtzZI4lkN4MoVemWYBhlmTOTi9rC5TkIA37tI4klodhR6zG/k33GgD/ikHRmyHyTFoGOCwniEy55lCgC+bsEq/NC/Y+JX9bu09TKn4RDyoHTF8X/gAnmNajdm8xKs14V5yTt04uWEVmT6Y2BhUDZRiwN0K25qDiXpFfScMwqLPq6iJwaVB7atRACHxsJCC8I6/Pwyy7spWlyTqNGvs6Iz2gkS88TH7te7MGRa85hOv/Ey7KGAK7Wok16ZfcJ8puHGbKB41AEBqN/mEMv2zNchm3yDKtq/gbJM0ONSm+bqSsiC1lMRMxo8ZGEcLneHex/VzhJuPGS4dpVcn+UFyqXFQIGnopSDQ+YKyhT9P6iSfsRREOjTJFX/iU3HZ6uIUbNBve0Q/6X5rO6mDhQ/zu9u/PMGtYYVFx3qrLWNDGd84rXgQizZ4f9Izr50CJWCMI0q04Jwvd0QtQ97qK8Dvz38j48pBCeoT5Q2153vNX6NJ474lDYXLX3NepkQWK/LH+Z5aLMamx9kbNf9e7kHwzZRt9ndrGdFHWDH/2WPFlBDufqn6/CKUA/zsD6ale24AKk9MWdOv6cRMba9ulOIxGfetQVQCOf6ZThBlbkS6/HZlhaBbenmO4/lhJKmi3R2tVy0GXCJk3zLY0K2/GOoK2QVoVs5QWHOK3gko0CADbLtu2IPKrMoJJnGCFEBdg/SxjWy7CGVncAmObHuA4DU7lvxLAPqYcEolbW7LjDBRY/cLB/q5VHeShPpSNtHqFrJzP2dz2T92+/nVgCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1295.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(38100700002)(55016003)(110136005)(8676002)(83380400001)(8936002)(5660300002)(6636002)(66446008)(64756008)(66556008)(66476007)(4326008)(52536014)(7416002)(76116006)(66946007)(54906003)(7406005)(2906002)(122000001)(9686003)(10290500003)(71200400001)(508600001)(8990500004)(26005)(186003)(921005)(38070700005)(82950400001)(53546011)(6506007)(33656002)(7696005)(86362001)(82960400001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TwaKfmUanuDMbus0Exj7pzUSUTcPeIWuciUoqDU+xdw4VStLBtK6oA81Cf+y?=
 =?us-ascii?Q?CCNa1nQ1DihkHk57k1EHixgUJJsbcAfFfWDU8RETtaUlr1YjZ2ZNr+sXJ3qp?=
 =?us-ascii?Q?s+1ya3Wj0CUQFOnFPEnZkbF0pqKvkCm99GeaX8RzVsQlsuzu7gvw2zUJt5om?=
 =?us-ascii?Q?yzt7gSyi4BqUvbyPfMXvGz38nGT8gLSs3H0Ae7RDGcwQfy88FZeBcHuisf66?=
 =?us-ascii?Q?zb/OyClA8hPUzDtf9fwNY+OTuWyxb6AQNMKN6ilRQjz3FcnkuuSfkFBTPke5?=
 =?us-ascii?Q?22xmq26BsOBdxrYcM4Cbz/F/dhAr9PZsvboFtsnHronWPDWv8ndS9ZABGrPy?=
 =?us-ascii?Q?mR8DXn1CXNF+AU3FzWnF+OZwfiAuyDN7uUN+GbMwQoC9hNcuB2D1SJfW7LBz?=
 =?us-ascii?Q?zriv/bHzhyRdIj0U+TIKkOKKikBFzdpLDuYCplUzP6lXxfBsQ16iKc/v90zh?=
 =?us-ascii?Q?hWg/sVTxbK55vza+MnseoHsreYpCNxnrSmsa4wXKk2fNyaAhPwzz3hUEbdis?=
 =?us-ascii?Q?+pX8XD84Ev/FjsdRGoyW622c9l56QobMN29BbJuGHCW33Lfds3rrJt0Kb2Eb?=
 =?us-ascii?Q?5owNrYp7s/sQmONqj5dzhNCjydomH397QHr6iIxvNbL8uukowLeXh71fTGEM?=
 =?us-ascii?Q?DPTYIvPsMZLc+i5itl3YWQEBY/Jtu0CluW/+ItNxcGsrOswL0Rc2YNkedjYJ?=
 =?us-ascii?Q?N67dthzXNeA/XpaZlH8wQe2ZTm+w+3mcPgInL4AuYc2CDjrrxFW6In92Hac2?=
 =?us-ascii?Q?SMA8hxSj41CN6s7G1ElrNBoYJIMUTJKvBfXFljzrXvEgnDvQkw8FHgjnm5rd?=
 =?us-ascii?Q?vtEdcjKdaO85Je/qWKKeIoAz+kC2AlB4SOakWtSa9j5mdkYVzDW8J9ri5B+5?=
 =?us-ascii?Q?SFOzSj1CKOn1TQ54Rmd2wG4y58t27QE4c/I5Xh8/+0Vzhx3xqTGo5JwHU/QZ?=
 =?us-ascii?Q?OVS0HwPwxMnnbZW8igAgeCKAxwhUkg35gLeDFFMraasSJrBd2uLrDh/oQJln?=
 =?us-ascii?Q?PSxLQEXCTM6+J9kI/qjSyXO0gGn4IwsIZz+sFczeABG9G8eu6DfjF+hHSUil?=
 =?us-ascii?Q?Yd+Y2IJa4CZR60D8KTY0qhtksO/cQ/Ms1pFpmKbvI2T1Ev/88QLHQJFOpjiQ?=
 =?us-ascii?Q?lGGG2ZqBpZkR2ckG0kWT145UspIdorHi+JERAfIfCZZved8hc3NlpAPWhlxV?=
 =?us-ascii?Q?wCKiOcDugmI2WW02Jztp3rbilTevg8DugybDY8p0NKiPHePZuDZZ0XN+9trK?=
 =?us-ascii?Q?5uOOkjwLVyzeSELbreqREc3bxlX1dwqInCsRU6inofeWtsbkESEUP4EHDtmc?=
 =?us-ascii?Q?Ps80hAFyxUvTp993WAQRO81JC+UdRf9X8OfC+bvOsRXbHHQ1UiLKKnpPL8Mn?=
 =?us-ascii?Q?F5w3nCsEw+sD8FfqOgZb5JwvKBbbLe+97ikpiLbrCIV5fCj5JLcUi05Y3mLU?=
 =?us-ascii?Q?vWAelqncvrq2efWGNyqLxREWMhuIY+QFdsCaUuAqZzwFOV5fPLSECQssT9++?=
 =?us-ascii?Q?GLZdmZ2VUHc3j19i00LcfTU7fpdcFIJcbDe9O9gipCSF7F6OiBFWZEXO1bd9?=
 =?us-ascii?Q?QtFoO2rh34/EYmQjR73yg7U/fx6j3SDuG4VoxZEvH9LvtlbEfi/hWBzkKJ/K?=
 =?us-ascii?Q?Jg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1295.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc92fa70-e668-4fae-a26a-08d9be598307
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 16:56:30.7618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B/9za8DDfD2vda/khn+g0NK/zy3hzMZ29hJwT3Z7l8EWuo76RhQ+mI6qE5hm9XbGWM3u4sCcVUizTvN/OF2k1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR21MB1732
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Tianyu Lan <ltykernel@gmail.com>
> Sent: Monday, December 13, 2021 2:14 AM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.=
com>; Stephen
> Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Dexuan Cui <decui=
@microsoft.com>;
> tglx@linutronix.de; mingo@redhat.com; bp@alien8.de; dave.hansen@linux.int=
el.com;
> x86@kernel.org; hpa@zytor.com; davem@davemloft.net; kuba@kernel.org; jejb=
@linux.ibm.com;
> martin.petersen@oracle.com; arnd@arndb.de; hch@infradead.org; m.szyprowsk=
i@samsung.com;
> robin.murphy@arm.com; thomas.lendacky@amd.com; Tianyu Lan <Tianyu.Lan@mic=
rosoft.com>;
> Michael Kelley (LINUX) <mikelley@microsoft.com>
> Cc: iommu@lists.linux-foundation.org; linux-arch@vger.kernel.org; linux-
> hyperv@vger.kernel.org; linux-kernel@vger.kernel.org; linux-scsi@vger.ker=
nel.org;
> netdev@vger.kernel.org; vkuznets <vkuznets@redhat.com>; brijesh.singh@amd=
.com;
> konrad.wilk@oracle.com; hch@lst.de; joro@8bytes.org; parri.andrea@gmail.c=
om;
> dave.hansen@intel.com
> Subject: [PATCH V7 5/5] net: netvsc: Add Isolation VM support for netvsc =
driver
>=20
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>=20
> In Isolation VM, all shared memory with host needs to mark visible
> to host via hvcall. vmbus_establish_gpadl() has already done it for
> netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
> pagebuffer() stills need to be handled. Use DMA API to map/umap
> these memory during sending/receiving packet and Hyper-V swiotlb
> bounce buffer dma address will be returned. The swiotlb bounce buffer
> has been masked to be visible to host during boot up.
>=20
> rx/tx ring buffer is allocated via vzalloc() and they need to be
> mapped into unencrypted address space(above vTOM) before sharing
> with host and accessing. Add hv_map/unmap_memory() to map/umap rx
> /tx ring buffer.
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v3:
>        * Replace HV_HYP_PAGE_SIZE with PAGE_SIZE and virt_to_hvpfn()
>          with vmalloc_to_pfn() in the hv_map_memory()
>=20
> Change since v2:
>        * Add hv_map/unmap_memory() to map/umap rx/tx ring buffer.
> ---
>  arch/x86/hyperv/ivm.c             |  28 ++++++
>  drivers/hv/hv_common.c            |  11 +++
>  drivers/net/hyperv/hyperv_net.h   |   5 ++
>  drivers/net/hyperv/netvsc.c       | 136 +++++++++++++++++++++++++++++-
>  drivers/net/hyperv/netvsc_drv.c   |   1 +
>  drivers/net/hyperv/rndis_filter.c |   2 +
>  include/asm-generic/mshyperv.h    |   2 +
>  include/linux/hyperv.h            |   5 ++
>  8 files changed, 187 insertions(+), 3 deletions(-)
>=20

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
