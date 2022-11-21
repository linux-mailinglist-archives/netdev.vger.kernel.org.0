Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20896329C8
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 17:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiKUQk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 11:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKUQkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 11:40:22 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11020018.outbound.protection.outlook.com [52.101.51.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90044DA8;
        Mon, 21 Nov 2022 08:40:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6gcadftCyRGNRce8/KyUr2t+aX1F6k1E3b8MnbRtwmC4lvQ5MERgLv98eD14xGIwCdKTYf9iKuvinFO85USdi457TX9TO05TeVxiKlA0Ltvyab2q/d+50wWrHyxWI6VPRbENPJh2NiAz/+dBJ3zNYag2XZYqotktSHWyNR/u0Y43Geik/J4AzsdfqSnZ2woiKtXFZwPxLIsiFI8p8ztL8czx13TJX4g9h0TPpFuFWDsd7choJ+atNVEuW+ONPZMlfDhzAYKBGIbDZC098O93RP90SHQn+/qYl4nOBkt4HLXuoWRj7/Dsy9EA0Pwanv9u0BSs1jVXgN5IirlxiJxtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZ0r5o58DjGxyj1tpXl67yh7PbN7L+2IXpYlNzNRwoE=;
 b=WWsiT+aVzjek8y1yMVK4hDjxlLfo4PIOuY4jcW9AsfTZkt5tYJuxtfAVbmcp68a0YWhekWVtBRgSaYEEiafyzNuHSDlS8TyE0rJ6lDIAcpA24x/AEE1OuHBei62UbUsZl9KHfBet2m1ZjLtjhOiVfodczIJE6uZnwJi2+utfwy88tw4MQrAJJCtuelzIVOniXZTbHBJe9VtmdcVUNOd2qFwZAc8/hG6QahPd0blHHByfeOC2BEhYJ6pJIo3yLhlcVopuLltYtxUHzDvmqM7KGnOP3XHP7fo//jMDo6RzQiHVN0zZpBSfFhFm8TI05X8Z9yt84gVIk/D4LfHIyLfn4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZ0r5o58DjGxyj1tpXl67yh7PbN7L+2IXpYlNzNRwoE=;
 b=L5ghO+94lukGvzk1hiUUNzh1Q37tsWjeTV/V3GuJgm/ArYR+bCLiYhr9t7wvQUlDHhB1m3Mz2beNex5+UKaB2SgZntFTO+NFtgDae+74ARllwe5L2rUvYsE89RRab1rdQwZiVXzI3b4SrSCAIHeSbdiiPvOWG5ZZ6vq/4bJQ7dE=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by CH2PR21MB1445.namprd21.prod.outlook.com (2603:10b6:610:8d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.1; Mon, 21 Nov
 2022 16:40:16 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%5]) with mapi id 15.20.5880.001; Mon, 21 Nov 2022
 16:40:16 +0000
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
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
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
        "Williams, Dan J" <dan.j.williams@intel.com>,
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
Subject: RE: [Patch v3 01/14] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
Thread-Topic: [Patch v3 01/14] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
Thread-Index: AQHY+esrEByVeSYqBke7qvqW2Lryi65JZ64AgAAvazA=
Date:   Mon, 21 Nov 2022 16:40:16 +0000
Message-ID: <BYAPR21MB168871875A5D58698273E914D70A9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-2-git-send-email-mikelley@microsoft.com>
 <Y3t+BipyGPUV3q8F@zn.tnic>
In-Reply-To: <Y3t+BipyGPUV3q8F@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ea3446ce-dab2-4f43-930f-c20e1e21c575;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-21T16:22:37Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|CH2PR21MB1445:EE_
x-ms-office365-filtering-correlation-id: 91ca6400-fbc4-4994-9f0e-08dacbdf11db
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bUY0ro6lnMMIbpWX/WvoYrkWARVyD+XZcMRFxdbrzcYmErAJn5EdBv99aSys4wPMbaJAal31siLwRgaX5qlPTdrn5f5IFH0Sy/2jO0ITWv8xAGubj6MorSnOv09roY+qV96kVVySPlfGtnNhtAqFJNvuprrn1t9LKV/bOpiPHRqCkpGgt+9NFNxnU+WJ1fg1owTHYXIyWw3vo2FXRYoPto3adOAa1SYhu2nFkBfk9joQqzAewa6kilRL3OMdYUMk5LR5ZifHzvqQpo4YVgVcoIfb9ED4axdBntQsPC/OVeX7H7F3M/35L8uGnwPSS9E7Pia/i9OyhOJcVhKQjN63U6A3Jbc39XBA00xzZJPDS0z0cxXVt9SlVh0xhMELP/oAtkddybQ3iMbPsHhsViOmu9kfQlYYKjRyUvWSxYF2eyDeOyknrdFsxp/8yAeQWF/MsztvkB9FRdur2zBKIqif+ojD2lT0eU+kzXtl4zQHn2aIUsbCCiLr622l41C9zkC4h/y5hmPR2f+D3pDnEbCFJLS+bhlo/7+KPq1h/Bkiksij6Blom558sV4MmC10EQiJZ0O34xmIh+ENW407L9OOgnaIhfxn5ZHNl1tGSxKRSvqsG3ysJJBNIV1Lb4pcBoj2IJrynJNRGKGXhUgaWqwMiMI/IETttNS9eGjMmuIENteOJdv5xXCWc5J7iqJXqLMkR0DvWZq7hPtCSl7PevJsdazfeC3dpubVDfqX8fJ4w+E+0ZwQFGH3mEr9+WG8L9tLRc1CJz3DmjGUXDk86LVj6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199015)(33656002)(38070700005)(86362001)(66556008)(7696005)(55016003)(5660300002)(7406005)(7416002)(2906002)(26005)(8990500004)(9686003)(186003)(38100700002)(83380400001)(82950400001)(82960400001)(122000001)(66446008)(966005)(10290500003)(71200400001)(6916009)(66476007)(64756008)(41300700001)(76116006)(54906003)(6506007)(316002)(52536014)(8936002)(478600001)(4326008)(8676002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?juBdVuO9WxVax3yPAg9AJSGqkCI1J2j72ahiURMdBNhQkyXH0ZYuVLU/TvJ9?=
 =?us-ascii?Q?Qqh4w/aNfeJruD6DW/TUHAdJV7vfrPgk8ZNiRRnrfAvdr4jVDVSkr6GmwbM7?=
 =?us-ascii?Q?QQMbALDbHUMHSqs2YTXRlouAsEwJXbZwZyb4ic9stXcU2vgmcdP/MisuXdbd?=
 =?us-ascii?Q?Bqpu2AU8SWZH+QdfKpKZBdh68x56YKjWVA6trlOUWOjzOcsFznCh6Jpd32tq?=
 =?us-ascii?Q?e+TNRj+t0yr2JMtp4DVWuV6hIEpaIj+rcNklcmC5YSVb8LtKjIRDXqFT/A9z?=
 =?us-ascii?Q?bwTkkSzW8f7CURZvbR4PvtkWfpNoT6OmmsBCp6dbpBFgdiUvTlKgXx8QHquO?=
 =?us-ascii?Q?5RMAL+WRGZxdShdDkDbqkEZ1dMw4L6lIChTuFKnLtNG5rLjgeJKPxsNmcahw?=
 =?us-ascii?Q?A05JFXXg6HajyEyvvM0g2Fj7IbB3Zaf21Br5FWRrvf2UI0WO6acPI+5d0oSE?=
 =?us-ascii?Q?XlfZFNS28hK0NT7LAVBWridyNmwynFuRzK5lDgOzY2ISi829R2+JD0EmQSV+?=
 =?us-ascii?Q?QxC2et7Gua29/GjAhQMgkiSnNw2PZSeCg8j5MmEZdH2hiZeQGF9rr9xljEJx?=
 =?us-ascii?Q?CBB65+dqa5ZMyWSMXAQW/z0UNFIiraexcQ3w+U9w1fZWmqNYsLKd53qftchx?=
 =?us-ascii?Q?wfw0qtvPO6rHfcc4BgRRgu/NioG7qzfZpSuY9OVeUq9+IMWase+DHmF6DK91?=
 =?us-ascii?Q?fJsWp2j/4NrLWTpqHyA8PHWBBzQGdEIHgJcjlR5efYjF5CdKARPT78Y6T1tB?=
 =?us-ascii?Q?4a3jiXzuUbjmDy5EZiLs/sj6//TGQMYlPGxcLKGK4PFnFh2kW7t8cWNoKvCA?=
 =?us-ascii?Q?/YvhD5QyVdXxqF4BuukCTn/8ke+I+LkYw+hrHie2c9kts2fAFZrsuSZ0eNLl?=
 =?us-ascii?Q?jDgJlCqTy+bPIfZWVdPXPrM4xZHOU7eT0fEL5BD5BCIbXIAufvMGPljpgAUC?=
 =?us-ascii?Q?j++A7kRbk3RZ7tug4JrIVYgoqu5WM38Gz/Vhbi6F36B3vtj4DvngU9U2BriD?=
 =?us-ascii?Q?4nGLB9mIxqbaS9ZatS2R0nGoxwnyDLE3BFj7DQC+L0MossvPdAouGn5mA3EI?=
 =?us-ascii?Q?Uo3YfXj6ryOqBO4p8VnWHupmtyMIJXpWQ/51gyS8bYWVEJudi6SDsaQnYfUb?=
 =?us-ascii?Q?sZ0Amtwl3qk3ul3mLOqq04FiWiu43yOhTAWXS1EW+oaOg9yd6u7PK/RGnbAB?=
 =?us-ascii?Q?UFqW8I4eatSkzzO3nZxXWJ1faVxEz/JGVvBs8ukYpWRuRp8l0NM/yyF5VGA+?=
 =?us-ascii?Q?k1i1awsiBEsprZHXTxfeDbxf2if+TycZDMbR7ICUCXB2JBwwQbn3L57qHSlH?=
 =?us-ascii?Q?fw8oXvHVLu7ws+gZQ921saY6wdBfB+j1iogDclzPSzsj7IRFWHNPa7o5TzqE?=
 =?us-ascii?Q?PpuntQcdLP+37O7uw95+kGwsAh38+by1mzDDRralFP/SrtjWjanaUz7TmIxe?=
 =?us-ascii?Q?vxAc75xD3tDROGjBQS09gpAbnis2QrlWzIGr45U31UNT7pnIQVTFJW0h10iO?=
 =?us-ascii?Q?6sdCW5uB3Dp1NimVPNHeUhltwiltTqrtjT6+M9dGZ4bgKcJj6L3YesQWxtSG?=
 =?us-ascii?Q?1lFRkxMpgPBH6YLCPpJes+wQzEt2imXD0aS444WcJZR3K1tb08eZVtrkWe86?=
 =?us-ascii?Q?dA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ca6400-fbc4-4994-9f0e-08dacbdf11db
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 16:40:16.3629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CY4DXEAGCpJVdExDrDMHCtYHkfCPPCanMNViuTLjr2j6Qiah9CIHEh5NNazTqhXe9WnnqC5ibTc4Y/N3tywbNRlAMtj8RL64+uwYaG9xSlg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1445
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Monday, November 21, 2022 5:33 A=
M
>=20
> On Wed, Nov 16, 2022 at 10:41:24AM -0800, Michael Kelley wrote:
> > Current code re-calculates the size after aligning the starting and
> > ending physical addresses on a page boundary. But the re-calculation
> > also embeds the masking of high order bits that exceed the size of
> > the physical address space (via PHYSICAL_PAGE_MASK). If the masking
> > removes any high order bits, the size calculation results in a huge
> > value that is likely to immediately fail.
> >
> > Fix this by re-calculating the page-aligned size first. Then mask any
> > high order bits using PHYSICAL_PAGE_MASK.
> >
> > Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> > ---
> >  arch/x86/mm/ioremap.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> > index 78c5bc6..6453fba 100644
> > --- a/arch/x86/mm/ioremap.c
> > +++ b/arch/x86/mm/ioremap.c
> > @@ -217,9 +217,15 @@ static void __ioremap_check_mem(resource_size_t ad=
dr,
> unsigned long size,
> >  	 * Mappings have to be page-aligned
> >  	 */
> >  	offset =3D phys_addr & ~PAGE_MASK;
> > -	phys_addr &=3D PHYSICAL_PAGE_MASK;
> > +	phys_addr &=3D PAGE_MASK;
> >  	size =3D PAGE_ALIGN(last_addr+1) - phys_addr;
> >
> > +	/*
> > +	 * Mask out any bits not part of the actual physical
> > +	 * address, like memory encryption bits.
> > +	 */
> > +	phys_addr &=3D PHYSICAL_PAGE_MASK;
> > +
> >  	retval =3D memtype_reserve(phys_addr, (u64)phys_addr + size,
> >  						pcm, &new_pcm);
> >  	if (retval) {
> > --
>=20
> This looks like a fix to me that needs to go to independently to stable.
> And it would need a Fixes tag.
>=20
> /me does some git archeology...
>=20
> I guess this one:
>=20
> ffa71f33a820 ("x86, ioremap: Fix incorrect physical address handling in P=
AE mode")
>=20
> should be old enough so that it goes to all relevant stable kernels...
>=20
> Hmm?
>=20

As discussed in a parallel thread [1], the incorrect code here doesn't have
any real impact in already released Linux kernels.  It only affects the
transition that my patch series implements to change the way vTOM
is handled.

I don't know what the tradeoffs are for backporting a fix that doesn't solv=
e
a real problem vs. just letting it be.  Every backport carries some overhea=
d
in the process and there's always a non-zero risk of breaking something.
I've leaned away from adding the "Fixes:" tag in such cases.  But if it's b=
etter
to go ahead and add the "Fixes:" tag for what's only a theoretical problem,
I'm OK with doing so.

Michael

[1] https://lkml.org/lkml/2022/11/11/1348

