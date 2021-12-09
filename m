Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2879246F4DF
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 21:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhLIU27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 15:28:59 -0500
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com ([104.47.57.173]:20288
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229850AbhLIU25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 15:28:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0PHMvKlAM/BnQMEo1u49VdFEJx/WuLG1BTPRsLUaVk+EuHMSf0d3Qnnu2+TblevfYCn2dPFA5o7sHUAaiRIPSFdZEYpIKfWqQr19ZM0N/wG+EppVtLq7CTWa24WeXz8pxN2Gp911wEtcDIzFxtYPAFTdKrcLleRTlx/8pCvovel/C+i0rvG1KeFHXMfCGjpaNqeqvLyw0NjXlGj0pH1MU/IPjIH7ZmNhGcbcrLGjUukAN3hVXMJyF9MzJa0d5rsLdDKR+yLdyN8Q+nDeldUKKSwY0eR8tuw+OX4olZnoqZPVd9CVM+k4JcM+FQN89noie3BYfgNzc0SnGJgKS+g2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2GInL2fbY9LM/yDScvF5EnyIC8c4u858vss0k9RZHQ=;
 b=O6C2xdpBSNj2y0zXJ0a5tJBOW1j84HsllcZAursGyyLR6HDKs1GRxzt3U3u967bbdx6FWYY3B2ZgZLL614cE72ygfc7U3JQgjlG87y+IsewTspjzGKQVyiAmtJghlKYpAxJOiGE/XCQT9Jxy5uGlOH9EkQDAw9X1fvdFaUjZy9wFe7n68njaUn/nOI+KvjHYZLhe9JH2yrf/zvxiwsobKFzQZiK3yNG+ZsAgifIdBvtv7KuJwIaU14TmjgBv30weF4F6bL/dFlg8CH3iDsGsuEriWf7vBtOSyOb665Cxsw7iTE/3b5Plzv1qsNmwXWTArh1FxStfjFAmgEiLIACZhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2GInL2fbY9LM/yDScvF5EnyIC8c4u858vss0k9RZHQ=;
 b=h4ttG+Gkx4QPU7OYF9U8RdL9/XtNtsKGaVjZ9jILtSKSc3bIshJV5vSlLDXrpx/47MqTxa7CcBl6/9OHOkDgejxJJsRdOPYQ3a17TUlqDkhzCWXjyGn4tkYpFxbwwVO4H58FWXeTLmTWLXbqJZMgXnneqpgRCxwK6mqBfKEEG3E=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by PH0PR21MB1960.namprd21.prod.outlook.com (2603:10b6:510:8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.25; Thu, 9 Dec
 2021 20:09:19 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e9ea:fc3b:df77:af3e]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e9ea:fc3b:df77:af3e%8]) with mapi id 15.20.4801.007; Thu, 9 Dec 2021
 20:09:19 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
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
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
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
Subject: RE: [PATCH V6 3/5] hyper-v: Enable swiotlb bounce buffer for
 Isolation VM
Thread-Topic: [PATCH V6 3/5] hyper-v: Enable swiotlb bounce buffer for
 Isolation VM
Thread-Index: AQHX6z/mlYtshOhm/UO21xPyGwUfQ6wqlr9A
Date:   Thu, 9 Dec 2021 20:09:18 +0000
Message-ID: <MWHPR21MB159359667085776793988EACD7709@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211207075602.2452-1-ltykernel@gmail.com>
 <20211207075602.2452-4-ltykernel@gmail.com>
In-Reply-To: <20211207075602.2452-4-ltykernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=fb6518fb-4c13-42df-b79a-b4c6d0836b6e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-09T19:54:49Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25d976b4-8563-45f3-3a5b-08d9bb4fc898
x-ms-traffictypediagnostic: PH0PR21MB1960:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PH0PR21MB19601DEE7C3B7CBACCEF6AD0D7709@PH0PR21MB1960.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rYD+MWM5lt6cwQz9Fg8XHqLH7LZzvc7JFYFY2R4gqWXz8bSuIHR0+ju9NYeUOTi25f7M7cVVr/QATpZqDSuS6qNem2lrgIIdeUh8FQPh+zoZvbXNYLxd++VtQ+z+ko0mx5IPUE8IMfkjec3Qq7efudoXjSv+mcWRGAtGn1n8YbHiuz5TAS6L1OIAFEDaiTtnqKqMeIyB77IiKSjQpFaEkvWup0I4j9t43kw7EW4dpC4ICeN7NcaqWunfPFk/LxdYmoneZzeZSZDnfksHgDRhcXxloTMkwl5aOJ6V+7QfIHDT+SMdi094SHOyAIWObpJrLPTCyU3REv5abgKLZ/7XkGZknq9wXoE6QsxzvWDVVF4WCUB6z8cBxwnNGCRkuaw25qB6DcPh+orb8tBHCLHOqot87Cy6D5gjg5ZGFNaOColK9BIIBRzXHaU6fri2grLCWfhyPEFVe6uoh1N476CMM0kuoPXR9MpY32v9arO961RUdzB1QcfVdPkbZk7h1Rei0CGgazLkJqOBQgN5TAZuG54pdgwl1DcTcc4US8OE1hrhB71v2hXFZ9ZtIPG1iJLuypjOsogDe7+v0oCDbgKEsD/ITliRWZkxtmkg6p4PBIQqpOZdvvxzs6NYAr+OxDfBYQaOviAE4gIkHuqNFnfXNdxJXt/B+dKMI2k9gXKKwWWJTmecpe2MhisoYeBTWAl6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(66476007)(66946007)(8936002)(316002)(4326008)(54906003)(8676002)(921005)(110136005)(66556008)(64756008)(52536014)(66446008)(86362001)(82950400001)(82960400001)(38070700005)(9686003)(55016003)(7406005)(83380400001)(71200400001)(33656002)(2906002)(8990500004)(26005)(6506007)(7416002)(10290500003)(5660300002)(7696005)(508600001)(122000001)(38100700002)(186003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: RT7JgHiVD8NG8Kr6fBi9zPiBXBP0l8tU9vJjjMj7s7prIcTej/TdjPEBmrxQbDamGpbXfzBFJE3C3rmlsSTArNUayWmwnhYwb8ePp0G7cO4IYlUWCnUVjUBKj8CN85WcWzNlPRVV6fNJG4khuaTEoXwnSzT2GrDBJCIXrerCWnxhP3IJR9JQuTcr8RN5XhfsEcc+Hnza59YvEFBM1ZdFYk0qs3utWKoq9EfGK9vOhH2LlBvBDBOgpFdPAOJyjQRsOfC7qbCK37CoWeRFwQxZh4vNG2IMAceV6R5vxuAPCT9K2NsPKTnVG7Cgov/cmDmLLerBnx1qAr1HdU057xOJX7ODPJX3pAYBj0HxibF63965LuuneJ+ejfDGFtv/rcIRnaNF5hNsGmwTy/ffEk9n5qxmfyTLMwzD6EqX2ijxrkniXfFRNVHSx35T6LIYetCIK8NiUfPVbELjw8EszB5LtLGTrB19KcqiDVayG9+TWRE8jsEOQM1uoRIv1TZA0Bdf
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d976b4-8563-45f3-3a5b-08d9bb4fc898
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 20:09:18.9916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m1xKY2RabmeS2pVUkIU4uDbnLiqbkvQGBaLLjrMTAuQk9AKLG9i/WyGVA6lnyklUmCF4x0sCBIjuy36JLJ0UuIXt8Rw16gls0i/c30y2MCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1960
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, December 6, 2021 11:56=
 PM
>=20
> hyperv Isolation VM requires bounce buffer support to copy
> data from/to encrypted memory and so enable swiotlb force
> mode to use swiotlb bounce buffer for DMA transaction.
>=20
> In Isolation VM with AMD SEV, the bounce buffer needs to be
> accessed via extra address space which is above shared_gpa_boundary
> (E.G 39 bit address line) reported by Hyper-V CPUID ISOLATION_CONFIG.
> The access physical address will be original physical address +
> shared_gpa_boundary. The shared_gpa_boundary in the AMD SEV SNP
> spec is called virtual top of memory(vTOM). Memory addresses below
> vTOM are automatically treated as private while memory above
> vTOM is treated as shared.
>=20
> Swiotlb bounce buffer code calls set_memory_decrypted()
> to mark bounce buffer visible to host and map it in extra
> address space via memremap. Populate the shared_gpa_boundary
> (vTOM) via swiotlb_unencrypted_base variable.
>=20
> The map function memremap() can't work in the early place
> (e.g ms_hyperv_init_platform()) and so call swiotlb_update_mem_
> attributes() in the hyperv_init().
>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v4:
> 	* Remove Hyper-V IOMMU IOMMU_INIT_FINISH related functions
> 	  and set SWIOTLB_FORCE and swiotlb_unencrypted_base in the
> 	  ms_hyperv_init_platform(). Call swiotlb_update_mem_attributes()
> 	  in the hyperv_init().
>=20
> Change since v3:
> 	* Add comment in pci-swiotlb-xen.c to explain why add
> 	  dependency between hyperv_swiotlb_detect() and pci_
> 	  xen_swiotlb_detect().
> 	* Return directly when fails to allocate Hyper-V swiotlb
> 	  buffer in the hyperv_iommu_swiotlb_init().
> ---
>  arch/x86/hyperv/hv_init.c      | 10 ++++++++++
>  arch/x86/kernel/cpu/mshyperv.c | 11 ++++++++++-
>  include/linux/hyperv.h         |  8 ++++++++
>  3 files changed, 28 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index 24f4a06ac46a..9e18a280f89d 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -28,6 +28,7 @@
>  #include <linux/syscore_ops.h>
>  #include <clocksource/hyperv_timer.h>
>  #include <linux/highmem.h>
> +#include <linux/swiotlb.h>
>=20
>  int hyperv_init_cpuhp;
>  u64 hv_current_partition_id =3D ~0ull;
> @@ -502,6 +503,15 @@ void __init hyperv_init(void)
>=20
>  	/* Query the VMs extended capability once, so that it can be cached. */
>  	hv_query_ext_cap(0);
> +
> +	/*
> +	 * Swiotlb bounce buffer needs to be mapped in extra address
> +	 * space. Map function doesn't work in the early place and so
> +	 * call swiotlb_update_mem_attributes() here.
> +	 */
> +	if (hv_is_isolation_supported())
> +		swiotlb_update_mem_attributes();
> +
>  	return;
>=20
>  clean_guest_os_id:
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyper=
v.c
> index 4794b716ec79..baf3a0873552 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -18,6 +18,7 @@
>  #include <linux/kexec.h>
>  #include <linux/i8253.h>
>  #include <linux/random.h>
> +#include <linux/swiotlb.h>
>  #include <asm/processor.h>
>  #include <asm/hypervisor.h>
>  #include <asm/hyperv-tlfs.h>
> @@ -319,8 +320,16 @@ static void __init ms_hyperv_init_platform(void)
>  		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
>  			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
>=20
> -		if (hv_get_isolation_type() =3D=3D HV_ISOLATION_TYPE_SNP)
> +		if (hv_get_isolation_type() =3D=3D HV_ISOLATION_TYPE_SNP) {
>  			static_branch_enable(&isolation_type_snp);
> +			swiotlb_unencrypted_base =3D ms_hyperv.shared_gpa_boundary;
> +		}
> +
> +		/*
> +		 * Enable swiotlb force mode in Isolation VM to
> +		 * use swiotlb bounce buffer for dma transaction.
> +		 */
> +		swiotlb_force =3D SWIOTLB_FORCE;

I'm good with this approach that directly updates the swiotlb settings here
rather than in IOMMU initialization code.  It's a lot more straightforward.

However, there's an issue if building for X86_32 without PAE, in that the=20
swiotlb module may not be built, resulting in compile and link errors.  The
swiotlb.h file needs to be updated to provide a stub function for
swiotlb_update_mem_attributes().   swiotlb_unencrypted_base probably
needs wrapper functions to get/set it, which can be stubs when=20
CONFIG_SWIOTLB is not set.  swiotlb_force is a bit of a mess in that it alr=
eady
has a stub definition that assumes it will only be read, and not set.  A bi=
t of
thinking will be needed to sort that out.

>  	}
>=20
>  	if (hv_max_functions_eax >=3D HYPERV_CPUID_NESTED_FEATURES) {
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index b823311eac79..1f037e114dc8 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1726,6 +1726,14 @@ int hyperv_write_cfg_blk(struct pci_dev *dev, void=
 *buf, unsigned int len,
>  int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
>  				void (*block_invalidate)(void *context,
>  							 u64 block_mask));
> +#if IS_ENABLED(CONFIG_HYPERV)
> +int __init hyperv_swiotlb_detect(void);
> +#else
> +static inline int __init hyperv_swiotlb_detect(void)
> +{
> +	return 0;
> +}
> +#endif

I don't think hyperv_swiotlb_detect() is used any longer, so this change
should be dropped.

>=20
>  struct hyperv_pci_block_ops {
>  	int (*read_block)(struct pci_dev *dev, void *buf, unsigned int buf_len,
> --
> 2.25.1

