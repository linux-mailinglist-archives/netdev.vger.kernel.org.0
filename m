Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504A56C136C
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjCTNbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjCTNa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:30:59 -0400
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020024.outbound.protection.outlook.com [52.101.56.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393EA1BCB;
        Mon, 20 Mar 2023 06:30:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E978qk5CmKSqkRNgKRhdzz/V2kRKVrrbiHvmFiir+DuzOt+qehAeR/+ryfrAsXeC8iaaAx+yGzrRfyy1sMUqdj4GiefP4+fTAUL0iA72t63d9eUP/L0LsG5cqiD3vdcBxuEMSOFhjb/K8CxHBNU3S3s7wpaIuSQHefXQTg6k3VtBWc84RkftEWNWoMf/3EAr4tTvaKLhufdE5EMNQRHwJLGyczVfDVcSjFN87kzwuSMHX/7ECrJFXkZNxm6Qy+x+JET10hS0F9WEmDz/xJ+y68Axi+PrQy55hF2LlcPeJWmIH5R5VgAPStM/uKBE9FJFcnY4lp3bzzUmJn3DliLS1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TqPfkVU1Z3cTdNLJ2/XVRDN5WVte0PWLryl3qeVQHxo=;
 b=QcN5AmuA/KwE7h4WRriS9VWaxLOGKheADQrJ4GEziNbhZbbbgiDC/6P5FbAqa7NW3RzU5IGsgSz5AXEebHEm8trt2aybojliLFyarZ7M5uy/WA0f1BeWQvR3EVQBvALgGEd0EqTvLffuuBl96yzLGctcf1Ct/6BlvE5qJeNz4Xhx6SJc4TGkl5qASNi0dPhlkv+af2re5PeG1GwO2MntcQMNXSXQ8g04JQ6RemoKRiKdSmumwPeszloHP0uNjSDQuONGZcGCBKG3YoPuDfL2maxI6YgSmA7PEZQYyBB8QwFFs6fyYep/zBX04D+7piF5w1wtWN2qd/u+UDF7rfbPSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TqPfkVU1Z3cTdNLJ2/XVRDN5WVte0PWLryl3qeVQHxo=;
 b=R/+Y0q+ZdadGMhj2DRatIJTl0bbHnksqQ0mwU0REXq6GQ45XIQpqdvcSETvsJOoYU4DJ4Uv/3iZ3nQSpjm4mJsBes2F6WLdPJGkGGnuaQqkWAc31xLgjLgzklPgKgAcrfIRz0FA3rpsLewr7mkWX7yXLfWh0UE3JNwVksnPsKK4=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by LV2PR21MB3159.namprd21.prod.outlook.com (2603:10b6:408:173::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.0; Mon, 20 Mar
 2023 13:30:55 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6254.002; Mon, 20 Mar 2023
 13:30:55 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: RE: [PATCH v6 06/13] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Thread-Topic: [PATCH v6 06/13] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Thread-Index: AQHZUjCyCpporLk3zkiXtyclH/4N+K8DmEQAgAAZtaA=
Date:   Mon, 20 Mar 2023 13:30:54 +0000
Message-ID: <BYAPR21MB16880C855EDB5AD3AECA473DD7809@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
 <1678329614-3482-7-git-send-email-mikelley@microsoft.com>
 <20230320112258.GCZBhCEpNAIk0rUDnx@fat_crate.local>
In-Reply-To: <20230320112258.GCZBhCEpNAIk0rUDnx@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9d82544f-ccad-4d86-88a4-fe10e66b08d8;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-20T12:54:58Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|LV2PR21MB3159:EE_
x-ms-office365-filtering-correlation-id: 6cc952f9-0f4b-4fb5-c42b-08db2947551b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vLtgLkQae6vHAXm9LUnMMVO1+HX9hGm59wzY7OltME0DItdtcK25uOTzJR4Ul3LmCMTyXvj0rgtCcnqbO9tLHr/jwjndO4acbZNENM1vA1Qi77oWwzNVXprU4flqsgtBtoZeHuWSB1g1uey5dCKK98v6i/Tv8oo/XHeyQUaxGvnkYjthm3soeSAgUox4qURaLcHN8MxqVdbXgaC7P3DfKbXLpjFwG5nWrQ/2ucb5UvJPED6cXqqNrhOo8tykjtACtg/P+T+PZ1W98E/EInqvLZjbV7Gt2Dkl8RdGdpRGw+A+AsaBBvsuhgizjLzAf5zKuHh/CL5Gr/PhzF4vL4ao8Bk0tC1KQXewiY3P0UaGiPoO/a4B8LCBY2AYsZs6PvfYsD7RXX16N7xhI9SbfSKclZbXKSuHuaFPnjtwEpLSP9Tl7xzFAqViq5ohDXSPhe9giFgYu3W6I/SqSEbQd7DaKgRNlILsnsExz8dUMI356dmB6naZIj2VRGQsut9X901GXID39LX/Rlfz9LVLNOOBRkynoZrHOx7evGRgQ577tBlag/Gu4hJCTSUAI9ntBi0+mvfE8uhjXM2FNzdZzChUjUf2FrqJIFqViMDGjuv3uUA/3dsEcpjQuEyC3RGlENEOp10EP7DwnDtzAOB7Dp67bu7Z2okmhx4LRQKgxykUX1DmY1ZI7lQKJGqS1CL+i2pcetowlIQ+gXZamgNQNbsbsCrIQkOf6BeHKLqmtG4GxJQnJejKWvLc9QdSKv9sBDAu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(451199018)(8990500004)(55016003)(86362001)(186003)(33656002)(26005)(9686003)(6506007)(82950400001)(7696005)(478600001)(10290500003)(122000001)(38100700002)(71200400001)(82960400001)(66556008)(64756008)(66446008)(41300700001)(8936002)(6916009)(66476007)(52536014)(2906002)(7416002)(7406005)(38070700005)(5660300002)(54906003)(8676002)(76116006)(66946007)(4326008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?q9KXbJrxiQ38g1rTeKcRgmPikgphFa0oFTqoODN/qgAus8EGP4e874PET3BM?=
 =?us-ascii?Q?nYwBuxnFiyDefdeHqS4bcFyQZF2sI1zab0a28PXY5M8uiPOZq4o9mEAQ4s3v?=
 =?us-ascii?Q?TrZ95sJhtalXMGv7YUISa+PZCmdKY8dWysujc3sg91ujViTAm0OZfqy006Fp?=
 =?us-ascii?Q?2SBo5B/mg2p1uEdck9hBOiAL3PgQyg5RRt/+GcMHFwPM+AwqwS8P26IfNWvz?=
 =?us-ascii?Q?PINB+c9QeRu0rZ17qZlXbH/gkJ83dEvc6DDDubmxcNZMuScdXcLacYj/V/Hk?=
 =?us-ascii?Q?JyCjlhlKEli03Cv3kj0l9frVnkx+9uie7gqbKNejEOnylOUsqXAdhPQgsq9M?=
 =?us-ascii?Q?5L1WVEB/qq0KsSiDR9JwM/aks1wBZ8QDN5Qn5ubVEJpZSxDCST8upheT0tpt?=
 =?us-ascii?Q?sFW+kN+lCOLY7rzE2Lm3z5aeO5TZJTV4qloQaOjJ45anp9q717uIyFMQudQg?=
 =?us-ascii?Q?cwimvxrUU/WUuqqf3OQFnVlXbtFThYqdcBeZWd96t2N+tVxKKzMavgTMi1xc?=
 =?us-ascii?Q?FO/vqcSuGjnGIP208YepWLcy+//eXRG7fsYbzxejoWCjmm+tgtrD6U23/98k?=
 =?us-ascii?Q?g7QuCNdttnodz3qC59KetFYqjO1q7zEyIOYrS3sFUuSJY+vu0MzQnP+EHpwX?=
 =?us-ascii?Q?tbGJ4rbJx8fQKEQEBzyDaIrbWcw6ftmtoViYteadQmXLYF0Nagy1/jOacyXw?=
 =?us-ascii?Q?RxGIVeYZw5gWKmdUkDGPK5mpPmbduzXrXDCPDKyzpAscRBnI3C9abLVHFH6a?=
 =?us-ascii?Q?FBfnY8m2QSFuuCHK4JR3FO3BUFZg8tmIUOJmi3iB5N0WxJnor22Z6f1DdNO1?=
 =?us-ascii?Q?SK4malUV9Usc420sIZbbOANiYDU8bzYjLfUQtouAwdp9HfZrix+yjLi4uJOl?=
 =?us-ascii?Q?6i/H3IyztOS1BePEj55hIsUx/yz6STYS1pzW/QkyJRvK0eb4HyiGnXYhnQcq?=
 =?us-ascii?Q?0NNUsIowEsGRHlV5B2XDJJeuvKeK18O2t2MJMRUozIMf/3bREwLR/MXa0qtu?=
 =?us-ascii?Q?QwNS/QmfVVJxOSnFb1iNj6447v9mx0/fvlI5OCGqi6jdD4N6nXTB/TkjKbfE?=
 =?us-ascii?Q?zZrnOi7ykykLJ3dgh/WK/J0jL+vudxlWDulSUSLAb3grsZWObUwC8CItIv8B?=
 =?us-ascii?Q?KAUs9L767goORLaBusYTJ21L2rWKUky3ypbmMDGaJNDH6hv87OyJlOygigJi?=
 =?us-ascii?Q?TDBgBbV2A0IhWdg/qW4bLzCjFPAfYyBbVsLP9xW7xJk27SCFWjjWIvRd8bUt?=
 =?us-ascii?Q?Cjh6nCYNGPtTLWUd8upDwCAxu4AC774zRuh253IjMZ5hyDPqStlGB/tUfbQA?=
 =?us-ascii?Q?7xgCSmEk7OXiOzfYbaOSEwfOXeUe4wRp/vYTTSwOapJJWUc8NLndAfFjnvWB?=
 =?us-ascii?Q?NMRNgNuvynFt/TdQ064c3QPxZ0KnCy5oABUeIf4eHN+neaewf2Z8jGqjIXEY?=
 =?us-ascii?Q?RCfJfaezhVhkhz7NmswfGBJX3yMl5Cv1JlgYenIwPqSkEgLS4Ejbb2xYWVrA?=
 =?us-ascii?Q?tv+riHeu57ba68MyhkNggDb50smTp4i4aCcss05JNjSn9j/K2YJDfUGAU1pt?=
 =?us-ascii?Q?0QtR0DjR8P0epCtRoT/mSymr9yGBiqrSyBJvqKh8hRiDCNEJOX3MQ8NH1FoC?=
 =?us-ascii?Q?8Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cc952f9-0f4b-4fb5-c42b-08db2947551b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 13:30:54.9900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 64I4tTJuKXoqigGSixYGbkpFDh6XgQuMx4rNMzqXurtak/28oOiRYfFHf1yKcEPWD830SXTk1Ryyv09Ii3Fzza3vfGW0/65BKqUJXYDX9MQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3159
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Monday, March 20, 2023 4:23 AM
>=20
> On Wed, Mar 08, 2023 at 06:40:07PM -0800, Michael Kelley wrote:
> > diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> > index 49b44f8..d1c3306 100644
> > --- a/arch/x86/coco/core.c
> > +++ b/arch/x86/coco/core.c
> > @@ -88,8 +106,6 @@ bool cc_platform_has(enum cc_attr attr)
> >  		return amd_cc_platform_has(attr);
> >  	case CC_VENDOR_INTEL:
> >  		return intel_cc_platform_has(attr);
> > -	case CC_VENDOR_HYPERV:
> > -		return hyperv_cc_platform_has(attr);
> >  	default:
> >  		return false;
> >  	}
> > @@ -103,11 +119,14 @@ u64 cc_mkenc(u64 val)
> >  	 * encryption status of the page.
> >  	 *
> >  	 * - for AMD, bit *set* means the page is encrypted
> > -	 * - for Intel *clear* means encrypted.
> > +	 * - for AMD with vTOM and for Intel, *clear* means encrypted
> >  	 */
> >  	switch (vendor) {
> >  	case CC_VENDOR_AMD:
> > -		return val | cc_mask;
> > +		if (sev_status & MSR_AMD64_SNP_VTOM)
> > +			return val & ~cc_mask;
>=20
> This is silly. It should simply be:
>=20
> 		if (sev_status & MSR_AMD64_SNP_VTOM)
> 			return val;
>=20

To be clear, cc_mask contains the vTOM bit.  It's not zero.  See the
call to cc_set_mask() further down below.  My code makes sure the
vTOM bit is *not* set for the encrypted case, just like the
CC_VENDOR_INTEL code below does for the TDX SHARED bit.

>=20
> > +		else
> > +			return val | cc_mask;
> >  	case CC_VENDOR_INTEL:
> >  		return val & ~cc_mask;
> >  	default:
> > @@ -120,7 +139,10 @@ u64 cc_mkdec(u64 val)
> >  	/* See comment in cc_mkenc() */
> >  	switch (vendor) {
> >  	case CC_VENDOR_AMD:
> > -		return val & ~cc_mask;
> > +		if (sev_status & MSR_AMD64_SNP_VTOM)
> > +			return val | cc_mask;
>=20
> So if you set the C-bit, that doesn't make it decrypted on AMD. cc_mask
> on VTOM is 0 so why even bother?

cc_mask is *not* zero in the vTOM case.  It contains the vTOM bit.
The C-bit is not used or set in the vTOM case.

>=20
> Same as the above.
>=20
> > +		else
> > +			return val & ~cc_mask;
> >  	case CC_VENDOR_INTEL:
> >  		return val | cc_mask;
> >  	default:
>=20
> ...
>=20
> > +void __init hv_vtom_init(void)
> > +{
> > +	/*
> > +	 * By design, a VM using vTOM doesn't see the SEV setting,
> > +	 * so SEV initialization is bypassed and sev_status isn't set.
> > +	 * Set it here to indicate a vTOM VM.
> > +	 */
>=20
> This looks like a hack. The SEV status MSR cannot be intercepted so the
> guest should see vTOM. How are you running vTOM without setting it even u=
p?!
>=20

In a vTOM VM, CPUID leaf 0x8000001f is filtered so it does *not* return
Bit 1 (SEV) as set.  Consequently, sme_enable() does not read MSR_AMD64_SEV
and does not populate sev_status.  The Linux boot sequence proceeds as if
SEV-SNP (and any other memory encryption) is *not* enabled, which is the
whole point of vTOM mode.  The tricky SME/SEV code for setting the C-bit,
getting the kernel encrypted, etc. is not needed or wanted because the
hardware already encrypts all memory by default.  The bootloader runs
with memory encrypted, it loads the kernel into encrypted memory, and
so forth.

sev_status is used here only to communicate to cc_platform_has() and
cc_mkenc() and cc_mkdec() that we're in vTOM mode.  If using sev_status
to communicate is confusing, this could just as easily be some new global
variable, and sev_status could be left as all zeros.

Michael

> > +	sev_status =3D MSR_AMD64_SNP_VTOM;
> > +	cc_set_vendor(CC_VENDOR_AMD);
> > +	cc_set_mask(ms_hyperv.shared_gpa_boundary);
> > +	physical_mask &=3D ms_hyperv.shared_gpa_boundary - 1;
> > +
> > +	x86_platform.hyper.is_private_mmio =3D hv_is_private_mmio;
> > +	x86_platform.guest.enc_cache_flush_required =3D hv_vtom_cache_flush_r=
equired;
> > +	x86_platform.guest.enc_tlb_flush_required =3D hv_vtom_tlb_flush_requi=
red;
> > +	x86_platform.guest.enc_status_change_finish =3D hv_vtom_set_host_visi=
bility;
> > +}
> > +
> > +#endif /* CONFIG_AMD_MEM_ENCRYPT */
