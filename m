Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD47469293C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 22:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbjBJV1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 16:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbjBJV1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 16:27:44 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021016.outbound.protection.outlook.com [52.101.62.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58555795D0;
        Fri, 10 Feb 2023 13:27:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aannOtSVEN+OzRg3Exdou/W0wK2sbMhU9lliGpQpmjWzz9YVHXvG0klTkqN40TE/0opvXWIQycYahhBxRBAdWRDlP/m4JIdVel8g9JRQByRTWCvAEF3sr/QZQBE+sBGKOyhIjeP2he7+fLZJ/O0Gml2ffJkCQHRzK2rRq6yhssjqpi/HXDWXaPfhFP31npg2JIcCZENqB80RIHBbIGLs8fGprEEAvs6nzGvwHZZGzue2B/YXXOG7WgyYephJqCmLLulL5Nuafoab85lNHwQJOnnfods+U8lLVv1H5upHi4sXT3BZxTGPA/1Hua898Iz7X7qrzjhFpmIuoPry2A7Zhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pk+AoBmMH5XCy5knv29mHITAVgMWtoAdtaEneu9MGT4=;
 b=LvobbMsTdTiPfLUPNYEdaV3fmtrg4Y2GeItny+fhzKMrzZ4zTFALWBld4ohj+mEmhxJ5S8YHObaCGarOO3m6XY+2Fs6yEPZzV1IOLI9fks1r3Z6MVKN4JW7tMOuKlL2l9hWsZYgtpI++0IEPXhDk9lBlJgA/NN2naqklD/qzHa5UtycPRvE2BvRaZP8yaZzOgkx38WuwiwcGFmUE3Jpc2nip56PsIHEAPuirqArYTkYBsiLIFWnAaD6fyRbKYHtXqKKb+FobhKgVVZIKEB5PsIHw6hUx9/go2/wBVNDURmNtiTREgDAWiYH4xoufkFOJZmY0vLACOXdrkoi46wFXHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pk+AoBmMH5XCy5knv29mHITAVgMWtoAdtaEneu9MGT4=;
 b=Mdo1bqK4lV20frpo57LsKlF0NTuvWMEU/CvkKxCDx3oYR3eHDPrA1lgmc0dy0WvXTvgBNPUapwST1+WzstrHvjjv31m+1IjMoZ47Sg6epXTyzfxVa1zAe43TqrSGpLxNHYnEnlFYNFi9+wZJr2ztGsDqkxZuKM/pk2PL4hf3fQ4=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MN0PR21MB3315.namprd21.prod.outlook.com (2603:10b6:208:380::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.5; Fri, 10 Feb
 2023 21:27:39 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf%8]) with mapi id 15.20.6111.007; Fri, 10 Feb 2023
 21:27:39 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Borislav Petkov <bp@alien8.de>
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
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: RE: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Thread-Topic: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAeE2AIABk95AgAGmoACAAAYigIAAAicAgAAHCQCAAAYXAIAADqWAgAAB8ICAAAP2cA==
Date:   Fri, 10 Feb 2023 21:27:39 +0000
Message-ID: <BYAPR21MB168864EF662ABC67B19654CCD7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <BYAPR21MB16883BB6178DDEEA10FD1F1CD7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+JG9+zdSwZlz6FU@zn.tnic> <4216dea6-d899-aecb-2207-caa2ae7db0e3@intel.com>
 <BYAPR21MB16886D92828BA2CA8D47FEA4D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aP8rHr6H3LIf/c@google.com> <Y+aVFxrE6a6b37XN@zn.tnic>
 <BYAPR21MB16882083E84F20B906E2C847D7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aczIbbQm/ZNunZ@zn.tnic> <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
 <Y+auMQ88In7NEc30@google.com> <Y+av0SVUHBLCVdWE@google.com>
In-Reply-To: <Y+av0SVUHBLCVdWE@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c514952f-93f3-40ea-b685-9055b55c8779;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-10T21:12:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MN0PR21MB3315:EE_
x-ms-office365-filtering-correlation-id: 4e6e6559-2bcb-4a74-9651-08db0bada318
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JGX7phlCg0OxUHdE4vOCvKT617iILug3taCOkFKyNDCuS6mxScikYk4loJMt3hYR2b7iCwcML8iD5MGs1YXHcd905lRA1OMJENpgqAcizQV5s87hfmVsN+z/4gNrUQNH4dr5BGGkOTuE2XsT/uWxG2dXXNb1veWw5rhH4zepNBRl0DOZpsc8iXqvC6RyYCrpZPnIvM35tVeOH8lMzBln6wn4sl62L0J/tllsfiuHRD+ZlL1byWMt+EqsW3iHnD3IWyBa4/Qp31DPTrndFrTM4H1P/tqAKaxCBX77zhNHzynZoKsj02cVqYOc6r0petdNqdSQJZsVETfW9Mb9qZzCSlLO7MKIjhuJm9lvWG8fSlW8z6kMnW4uTvW+H/HtdoP+PQ9MEJ6CyWwxrBWCTpNMfYn4oAXC5bDXs50zDE+XD1JaJ7ja8lWyi3viP4tn9F/HZfZNE+WNN4l3yqOpB+SnJ5QtiXJ8PmxofNehT4v8ieSIL/y+RLDZydBsliZZq8z5LOjfL7Be2YiT4mRxMzKfU9tpHTuOCb4pv86cXeP1MIy6E5+i1nty4yO1ufbyn40PdDjFRg+wYI4H08WvjH2sRR2qr7mEXtL0gKzDi/V8fi5aM64lYQC0f+MZN8lKRqw10a+zaSHIqom+D/Q4jA6hfDV/pgkGsCDDzmwZP7ahkmtTLXgxJ8nqVqudIOBJUydlsoTTpun0w1a+3szCq/hSn7jpTn2p2zCD7cLsmQNFcTXPmhDgwlhOWAv/jVmP5pRp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199018)(66556008)(55016003)(54906003)(71200400001)(110136005)(53546011)(8676002)(10290500003)(6506007)(9686003)(478600001)(186003)(52536014)(7416002)(2906002)(5660300002)(7406005)(41300700001)(8936002)(8990500004)(316002)(4326008)(7696005)(66446008)(64756008)(66476007)(38100700002)(76116006)(86362001)(66946007)(83380400001)(38070700005)(82950400001)(122000001)(82960400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?12x27VS4EzLmYhQypa/sjPPQVws26J964E7PTV3gIJD8IO8Wd0lVHP+OG4Z6?=
 =?us-ascii?Q?9w93PiUKBKJntJgOnzcpS+cpMFZ6koitnUfH3MdQF4njDUbd9PkvxWjCXErq?=
 =?us-ascii?Q?F/wE5o8EhHw/57u54cfVgnhxxrZ7Ch/pa2J4WAphhv3JP+6AXNTi9LNn7u4m?=
 =?us-ascii?Q?EAno07lDp2UgMpsqyTr0/Tp0z5LJM7AGdLVNq/JJ/G1zP4cvtp8njFinp2BW?=
 =?us-ascii?Q?jK+zzrt8E98rRBbXDy44SivOY2yHZQUkpBfQe2s5bxsNE2ndqr7ANS5gsHSc?=
 =?us-ascii?Q?keYjhpLuiwbLERJXu3wq7i4j92TlhderRMFQ1fQsilhhG2CkbcFPJVYoFGnR?=
 =?us-ascii?Q?UxRIDaaSuSzzxxd/8Kf1KL3mGdgbBD0M0uHFcAJrprVGDElNPQ2Vae8Fta5S?=
 =?us-ascii?Q?lQGVbFXZfHl54sbnV1ybW0DElakX2+QkPpeZJWPRj4lnNwmJQoQqkEJE7HsK?=
 =?us-ascii?Q?1naIRiS5351QyLZyxLUcM3mYXFDxbxdZ0aTvZolmlMu1ksfP8+IH+B7bRPPJ?=
 =?us-ascii?Q?1xEOJ8TlljLZRRXEIwxEllFIlQ5S7NXpG5a4h06dKNYfC40AryuB/O2hV4Eb?=
 =?us-ascii?Q?5oRDpenWz3HTWueGU9DCtHLzdRitCKdFee/nsBKHkklJrkyT3POKarMjtfK3?=
 =?us-ascii?Q?YLhN2DwGWHB7gtXwADQRxPXHbwIr1eb+17hVTcceT6jpVsOW8wRo3mmmZqZm?=
 =?us-ascii?Q?B5bOSxQnSqiaTQQiTh2TFV63ZyrAoLybI/u69k01wb3vtbok8FPBkVmrRp6a?=
 =?us-ascii?Q?datCFg3DvMWX7V4QFSU2AUVlNt+v4qRV+iuqS/xR5ATyidkqGM7yqA2yF/yb?=
 =?us-ascii?Q?gBrm7hwdCbERUWzFy4H4p6hiZ2a4MMx5ED7W4nUS4j2k9Lhf7SU/QD/JLF61?=
 =?us-ascii?Q?lHQk7SKxv3hpl5woKEnh/KTN1dh4GRCD1inSWm6AG9QYaVPY2kMkmZIhxgl1?=
 =?us-ascii?Q?ObR+3u/pM1yo3NEYVg5bw+Y7AMitau8g0saVqXfFqX8EGb4Bhp9UDxH2q/Xt?=
 =?us-ascii?Q?OvaUOqdooJGUMg3yqhJ/o7jXnZK67XsOcHyYJhTYr82GHTWGdO0CdOCZftWn?=
 =?us-ascii?Q?muMV8fmzMB7/3rL3pTNPUKKIzJilHSYcaXbE12p3W/n04BNrWtYi5scSBiGv?=
 =?us-ascii?Q?M+onpT3TWiJFHAzl1sGeZAXg6LvOHBGTO4YvXhQ5bUI5+Uw9O/isFPsEFIbT?=
 =?us-ascii?Q?1RnrNw/pWUFWY94TUUSGJ4RnUxfv0gHCZZGUINoLFaVXYhMrE/qay4WmRBzG?=
 =?us-ascii?Q?rZuENcVny3E5XzkRmDxjk56nZ+tvgY66ZVOz9ezd7TwPxOKooZ883O8eVPuW?=
 =?us-ascii?Q?+Q4OswBjts8J8J4S1B49WJSKGqQ4bsrWHkL/NOdwY2wXRGVGfpdUhQLzUf98?=
 =?us-ascii?Q?13S2WIoqbRmmb5/Xi/vEiklohvL8IrcPcYiKgQx/wDOdXeLeQLnPyhJe8l2H?=
 =?us-ascii?Q?rAcioY7SPOacYrqyrVPX3a5ahuXUyGsqtnaApEND8DbHptsjsPLJ2K+0A3lC?=
 =?us-ascii?Q?wOrBMA9v2GQ8+Xw1j3h/9IojC1GFhSLHUbHUtZtUpKylWU09746BQUwZ2B1Y?=
 =?us-ascii?Q?6NoaMrFgtCMBpjKv8rEetYtcVqpgk64Cbc+PsuiywtMVmWOve6MsTPoa0q0+?=
 =?us-ascii?Q?heol4kCHPmDpjE6SeUd0pJVFPAj6duiaOYRIF5gbenk5X2CNto5PebGya66Y?=
 =?us-ascii?Q?v7zssA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e6e6559-2bcb-4a74-9651-08db0bada318
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 21:27:39.6289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GPpUCIXzJ2ExrXKFLwWqc0bqOVi6nSF1shRvpYlsL/Ph7SDZQQzs9iqRC4wKnzPv4K2Tivd4A7qZmoMXJxHXwTeYWuS51ZH9ofmKP9xxGWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3315
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Christopherson <seanjc@google.com> Sent: Friday, February 10, 20=
23 12:58 PM
>=20
> On Fri, Feb 10, 2023, Sean Christopherson wrote:
> > On Fri, Feb 10, 2023, Dave Hansen wrote:
> > > On 2/10/23 11:36, Borislav Petkov wrote:
> > > >> One approach is to go with the individual device attributes for no=
w.>> If the list
> does grow significantly, there will probably be patterns
> > > >> or groupings that we can't discern now.  We could restructure into
> > > >> larger buckets at that point based on those patterns/groupings.
> > > > There's a reason the word "platform" is in cc_platform_has(). Initi=
ally
> > > > we wanted to distinguish attributes of the different platforms. So =
even
> > > > if y'all don't like CC_ATTR_PARAVISOR, that is what distinguishes t=
his
> > > > platform and it *is* one platform.
> > > >
> > > > So call it CC_ATTR_SEV_VTOM as it uses that technology or whatever.=
 But
> > > > call it like the platform, not to mean "I need this functionality".
> > >
> > > I can live with that.  There's already a CC_ATTR_GUEST_SEV_SNP, so it
> > > would at least not be too much of a break from what we already have.
> >
> > I'm fine with CC_ATTR_SEV_VTOM, assuming the proposal is to have someth=
ing like:
> >
> > 	static inline bool is_address_range_private(resource_size_t addr)
> > 	{
> > 		if (cc_platform_has(CC_ATTR_SEV_VTOM))
> > 			return is_address_below_vtom(addr);
> >
> > 		return false;
> > 	}
> >
> > i.e. not have SEV_VTOM mean "I/O APIC and vTPM are private".  Though I =
don't see
> > the point in making it SEV vTOM specific or using a flag.  Despite what=
 any of us
> > think about TDX paravisors, it's completely doable within the confines =
of TDX to
> > have an emulated device reside in the private address space.  E.g. why =
not
> > something like this?
> >
> > 	static inline bool is_address_range_private(resource_size_t addr)
> > 	{
> > 		return addr < cc_platform_private_end;
> > 	}
> >
> > where SEV fills in "cc_platform_private_end" when vTOM is enabled, and =
TDX does
> > the same.  Or wrap cc_platform_private_end in a helper, etc.
>=20
> Gah, forgot that the intent with TDX is to enumerate devices in their leg=
acy
> address spaces.  So a TDX guest couldn't do this by default, but if/when =
Hyper-V
> or some other hypervisor moves I/O APIC, vTPM, etc... into the TCB, the c=
ommon
> code would just work and only the hypervisor-specific paravirt code would=
 need
> to change.
>=20
> Probably need a more specific name than is_address_range_private() though=
, e.g.
> is_mmio_address_range_private()?

Maybe I'm not understanding what you are proposing, but in an SEV-SNP
VM using vTOM, devices like the IO-APIC and TPM live at their usual guest
physical addresses.  The question is whether the kernel virtual mapping
should be set up with encryption enabled or disabled.   That question can't
be answered by looking at the device's address.  Whether to map a particula=
r
device with encryption enabled really is a property of the "platform" becau=
se
it depends on whether the paravisor is emulating the device.  Having the
paravisor emulate the device does not change its guest physical address.

While there's a duality, it's better to think of the vTOM bit as the
"encryption" flag in the PTE rather than part of the guest physical address=
.
A key part of this patch series is about making that shift in how the vTOM
bit is treated.  With the change, the vTOM bit is treated pretty much the
same as the TDX SHARED flag.

Michael


