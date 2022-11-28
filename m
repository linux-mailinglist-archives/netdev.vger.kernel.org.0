Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4889063AB2C
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiK1OiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiK1OiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:38:18 -0500
Received: from DM4PR02CU001-vft-obe.outbound.protection.outlook.com (mail-centralusazon11022015.outbound.protection.outlook.com [52.101.63.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BFF1B9EE;
        Mon, 28 Nov 2022 06:38:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kj/CVDtPQUMoYSDy2Kwb7f9nZ6ezVleuTVcEFiLLmDGvS4VRe04cEUV0XLpgsfZlBeSSyOoTMWMJXgneeNvk0lel7Cd/UWeC7kXem1RsyaMAG81p6QYy1zgWA2oUN7WVWrJj5BxI/Md7eUYsn2HZ0SIHl9nxUxRLev4uR1vTpmaoIhzlyp28x9CbX+I6N3rA+uy6nfMepsT+6qLZAkZ7/58y9b3pMkGXUCYqAtIDLD3S1MlP54d0aPG9V7P1BB2bmonp+AGyszXdpgO1ziYPgvJrukCBhhkFXUMxgaTBW506M/uZPWUZb8mPh2cC7tdn5wZxt1VrRFo1l1ShxOIDrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wEPElbwwo7aM/Q4upC9DLpUlOLaXiawULEVKqi6VnIY=;
 b=fuMUtXT1KdCETMGWDA5NbYH8Gr1Ed1qvQJ3JuMx5pY2zlpqK1yrwS4mXyWGcvCJCEv0+nxSQfR0Zonq4VXmnZ666in2YD+eJgfxf/RKhGYoaMy6TlZh9HXFGR1RgmLczLua+eJwLcmlIvpixx/LMbFNZAH/lytAsgVbojwRdw/iZDW6/WhBbV5xySwEgTD3BZKt8rlizvZGTXokMymm5rVL136YLX8G8rFxa/bNvqKCarZ7gE1/K9QNCn8A1B0/Lb8M/uVmTVCzopNlraKUIROEvm+u1jauaP/W1QwrCOVBsKVTB9JJLk/Dw39g1jDUUPoCtknZvP9LDIwGIhW5zNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEPElbwwo7aM/Q4upC9DLpUlOLaXiawULEVKqi6VnIY=;
 b=DVt9vAhEF9kvwZ6ql2ZLh3HA4SfYTU5awSRdDoECofAbaI0ieq9b5QddNK+Al7njmAx3dXK7c9/kRsHS+6ffZ7i+r4qqLoKR9mVr3l5D1SislKf2NaIVW13eSA69RvPrDi4pS5hFxbJRcXQ6y8RFXAM9eB99E9oKQN96F0YIHzY=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DS7PR21MB3150.namprd21.prod.outlook.com (2603:10b6:8:7a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Mon, 28 Nov
 2022 14:38:11 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%6]) with mapi id 15.20.5880.008; Mon, 28 Nov 2022
 14:38:11 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
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
Subject: RE: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Thread-Topic: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Thread-Index: AQHY+es2O4adbWIH8UyWtCwRyUnUyq5JgOOAgAHDpcCAAEhFgIAAJ7oQgAjDHRA=
Date:   Mon, 28 Nov 2022 14:38:11 +0000
Message-ID: <BYAPR21MB1688AF2F106CDC14E4F97DB4D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
 <Y3uTK3rBV6eXSJnC@zn.tnic>
 <BYAPR21MB16886AF404739449CA467B1AD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y31Kqacbp9R5A1PF@zn.tnic>
 <BYAPR21MB16886FF8B35F51964A515CD5D70C9@BYAPR21MB1688.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB16886FF8B35F51964A515CD5D70C9@BYAPR21MB1688.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=fd4d8306-d27a-476f-b22e-64e344b7a1f4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-23T00:40:28Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DS7PR21MB3150:EE_
x-ms-office365-filtering-correlation-id: d46f1bb9-e382-43e2-9d2b-08dad14e2cc8
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8E/wAocLWRn+lMV+NwCagvaEeS1mR4UqCfGDAF00Os7M4tym4AMqt23kpo74GH59NwVaJ3mrw42UIvzy9RoUq0TM4YVMTuJV7FWGVteOq1gb5KzZy7mumjr7odl5ihNNix9PlcoVUBANvbdgd4VnFaZ1cU3BTbOfXV+8Ht8Kc+5V4KpY5HOoDz2pn2s1aCVABKn8Ebx+bZGEyvBPDgtnHuPnxNMPCj+aI9WLY+Y1RjQpCAhGDF8abZJwZJUh7iguQJUKBC1OzATu4vzkZymyv94LVIY2Eq5ab25pv+vM5AtElFyeu0WJ/ZRM/PM7PEtMOiO3/OiOjiCT5MzWr78Lcj/j7ONVj9zKBHGZRemkul0zvGg/CUi6pi34j7eHLh0/SU9LzR/qSmZ90N3LqbpZqfqvfm8VEV1t4gpzhu2xKtF9R+gK8r9rZvxcUSf5QZQqKJkzSJza2nu9qeW1Kt2R77/Xw+Gh/b8i8JcUfVyPlB9QFVE9chiSUCgTmTldx1URLa7J6cFnS9YbejHeJdypqGBHxSn59pg8Mlcfpcae+UhGQ/A3QKF86Ba7cdJewg7TfQlJqOCjZpciyiyDG9McaoahyO5oUfS6shfgeHuwg6DYDhFM2J18jiH0PGUo6B/K/qstCdsn4jBX5Xmrc4GQrZDH5m49HQUi7isT4XeFh/ulF/I3z54RmD31Lw/LrAQTcUZ86iGsIpV0LTGh251WvjNl40+5+bq7FXjnKS8IO8ivItlnQ45xip8lAKuyFxXx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(86362001)(186003)(55016003)(33656002)(316002)(41300700001)(54906003)(66446008)(66946007)(66476007)(76116006)(66556008)(83380400001)(64756008)(71200400001)(110136005)(26005)(8676002)(7696005)(9686003)(5660300002)(6506007)(4326008)(10290500003)(478600001)(38070700005)(52536014)(82960400001)(82950400001)(7406005)(7416002)(8936002)(122000001)(38100700002)(2906002)(66899015)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DogLl3ZtNzuXAbb62R+EyqJS23fmOd/ICheAcUk82NWXEgVJ0lj6MUBi7N7r?=
 =?us-ascii?Q?CqJWZdTd8opeqncuOMIQmKjjGv+eTInPulUzxWrdcAV+9wbQ2qZyDpsllZW7?=
 =?us-ascii?Q?Kqa25EEh867nAXDsvjuuEE0h05U9RXbVTCeIMCNBenHfob8Lejj+mJ+mzflW?=
 =?us-ascii?Q?k1QC4MF2ksXgZinKfIUfUnbjIJwneyuDb5pGFsVBPp+WStpmnFT1bJlYFnur?=
 =?us-ascii?Q?QCPK5BS4OQpbewHd2Q+7n5m3z8lGu9vl9cAatH1Br1h+SZDxZEIu5q2pa/tm?=
 =?us-ascii?Q?fxUVJFao/UZLg3Jhu77T0tqKnARRxeXRQgIi3hXWa1tCOl5rUXBi7q2p34uw?=
 =?us-ascii?Q?jjrt/R3fbapKqGm4zJ6NLj1R4pmDhrXIHpjSFAoC90tPEvKtM9wyNpoTr+6q?=
 =?us-ascii?Q?1OeewWXxyZ95JpA/AdpoaFm1P4ObhweiCryVp3vS7pDJ+eFMyUmrdegkIXwz?=
 =?us-ascii?Q?yc/z4atVeKneCwFT6DW9yRRnO5iWTEkhCD4DWnIKKHVig9+DpzG5iP6GX38r?=
 =?us-ascii?Q?G/0Er9vfdBYdwa/psNgQRVjKjox6g7JT8kwqNcpNXdv3wxdNOmwmEHkDvXzp?=
 =?us-ascii?Q?ItHoNXXJSOWGCse36Ga2X3t7P/O1a0tlQm/ZZlY3B8DLbs2XYlIT8Ccz96Qc?=
 =?us-ascii?Q?p0HNnxk6NW7LT5aJFOnhAlFBbpIFVn3huVzFuyLuo2udglCUlMPZL4uBTwod?=
 =?us-ascii?Q?rtBYcsxpTs7gWtCvemDZZBAe1BR9WbEjnUQUY0Rg0/29UPt7/mrXI2aGbj/X?=
 =?us-ascii?Q?pa+jUuxycpyCnggjNVHK+/h+fyuG4YbdDQu1OBbpQsGfDUcD4h2xuhHwOEh5?=
 =?us-ascii?Q?njeST6854blgwHNoVxqRzaxzK79jTzt82MXJSqF1cU8mILmBEfgiC7GhdN75?=
 =?us-ascii?Q?LIo6cG7bzt7KYnajzHZRUr+Xkf/0Hn98SroUbiUQXIgoy/azqxg/C/YA5csH?=
 =?us-ascii?Q?cTkRzhDvGPGUUPgNwtEbrbOQ4035az3S+m8fReJ85TPyD7RZ+RHkLQQ0rKuD?=
 =?us-ascii?Q?wABm4kXSXYAaGM90Cyql6PVrdvNPLeSr2qbDE3mP9Qmez2nxWaG71eVYsgmV?=
 =?us-ascii?Q?AMSU5Z0hWDK7Uqju9KNpXKGK72Xi6k5fKkKozuehqMyrUzTgMsz66AT0SvHF?=
 =?us-ascii?Q?zeckifTls6ZS2vhqqQgSP1+MtoLsBETPS6l/y8u6diGHtpjC9sbWc6v7mCL3?=
 =?us-ascii?Q?Tyf7l8rD9MHjNt/QUpolLmFBCA1bFbM+3xdNapsse2822jCxkqFYJzvzIx4C?=
 =?us-ascii?Q?qh18h1sLCL6UrTTI63e93nGFn0WNBLHBLSzbnW2WZJ607XCnb9a6Ak9+v3eW?=
 =?us-ascii?Q?zPCUrRGG5WQxphIDgxaKg2Q7VjKrNSuvJX35eLNOsDV6332VlIKRnLI3ha5V?=
 =?us-ascii?Q?SlxdwKk0xtluwSVVtuZSDN0XdQxsNtgm26ByiUndmzHbL/OxrlYuzwBi0Lfx?=
 =?us-ascii?Q?4VzONb55N3BFvFELhKq/5YoJC5je9oWrIIzYTgJbu+WjEZQtUoRIV109fuIT?=
 =?us-ascii?Q?pVHlb+ByrjcWQY68tz3F8P3J/2Mu4PDPD+dxK5Tt+3zGFXwnDngVchu5kaqe?=
 =?us-ascii?Q?VSm0WMnlidV7KH2pnKMQJyfwoa5wJ1QSlEp8zRJV1ILZ29ZufRpVRgkn0kHd?=
 =?us-ascii?Q?ug=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d46f1bb9-e382-43e2-9d2b-08dad14e2cc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 14:38:11.4876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yTlebIbIPy8l8kyjfsAu4DU1E4i91IFlgH4L9urU14kpuu3grXA8u6Ag9FlINXi8CJgVACHDk8FYsNyQ9p/HY7QszDikGQAqAB6+/u1XEVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3150
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Kelley (LINUX) <mikelley@microsoft.com> Sent: Tuesday, Novemb=
er 22, 2022 4:59 PM
>=20
> From: Borislav Petkov <bp@alien8.de> Sent: Tuesday, November 22, 2022 2:1=
8 PM
> >
> > On Tue, Nov 22, 2022 at 06:22:46PM +0000, Michael Kelley (LINUX) wrote:
> > > I think the core problem here is the naming and meaning of
> > > CC_VENDOR_HYPERV. The name was created originally when the
> > > Hyper-V vTOM handling code was a lot of special cases.   With the
> > > changes in this patch series that make the vTOM functionality more
> > > mainstream, the name would be better as CC_VENDOR_AMD_VTOM.
> >
> > No, if CC_VENDOR_HYPERV means different things depending on what kind o=
f
> > guests you're doing, then you should not use a CC_VENDOR at all.
>=20
> Agreed.   My proposal is to drop CC_VENDOR_HYPERV entirely.
> Replace it with CC_VENDOR_AMD_VTOM (or something like that) that
> is set *only* by Linux guests that are running on AMD SEV-SNP processors
> and using the vTOM scheme instead of the AMD C-bit scheme.
>=20
> >
> > > vTOM is part of the AMD SEV-SNP spec, and it's a different way of
> > > doing the encryption from the "C-bit" based approach. As much as
> > > possible, I'm trying to not make it be Hyper-V specific, though
> > > currently we have N=3D1 for hypervisors that offer the vTOM option, s=
o
> > > it's a little hard to generalize.
> >
> > Actually, it is very simple to generalize: vTOM and the paravisor and
> > VMPL are all part of the effort to support unenlightened, unmodified
> > guests with SNP.
> >
> > So, if KVM wants to run Windows NT 4.0 guests as SNP guests, then it
> > probably would need the same contraptions.
>=20
> Yes, agreed.  My point about generalization is that Hyper-V is the only
> actual implementation today.  Edge cases, like whether the IO-APIC is
> accessed as encrypted or as decrypted don't have a pattern yet.  But
> that's not a blocker.  Such cases can be resolved or special-cased later
> when/if N > 1.
>=20
> >
> > > With the thinking oriented that way, a Linux guest on Hyper-V using
> > > TDX will run with CC_VENDOR_INTEL.  A Linux guest on Hyper-V that
> > > is fully enlightened to use the "C-bit" will run with CC_VENDOR_AMD.
> >
> > Right.
>=20
> Good. We're in agreement.  :-)
>=20
> >
> > > Dexuan Cui just posted a patch set for initial TDX support on Hyper-V=
,
> > > and I think that runs with CC_VENDOR_INTEL (Dexuan -- correct me if
> > > I'm wrong about that -- I haven't reviewed your patches yet).
>=20
> I confirmed with Dexuan that his new patch set for TDX guests on Hyper-V
> has the guest running with CC_VENDOR_INTEL, which is what we want.
>=20
> > > Tianyu Lan
> > > has a patch set out for Hyper-V guests using the "C-bit".  That patch=
 set
> > > still uses CC_VENDOR_HYPERV.  Tianyu and I need to work through
> > > whether his patch set can run with CC_VENDOR_AMD like everyone
> > > else using the "C-bit" approach.
>=20
> I haven't followed up with Tianyu yet.
>=20
> >
> > So I'm not sure the vendor is the right approach here. I guess we need
> > to specify the *type* of guest being supported.
>=20
> Yes, calling it the "vendor" turns out to not quite be right because in
> the AMD case, the technology/architecture/scheme/"type" (or
> whatever you want to call it) is not 1:1 with the vendor.   Intel has jus=
t
> one (TDX) while AMD has two (C-bit and vTOM).   "vendor" is just a label,
> but we should get the label right to avoid future confusion.  The key poi=
nt
> is that we'll have three top-level types:
>=20
> * TDX
> * AMD with C-bit  (and this has some sub-types)
> * AMD with vTOM
>=20
> The CC_ATTR_* values are then derived from the "type".
>=20
> >
> > > Yes, the polarity of the AMD vTOM bit matches the polarity of the
> > > TDX GPA.SHARED bit, and is the opposite polarity of the AMD "C-bit".
> > > I'll add a comment to that effect.
> > >
> > > Anyway, that's where I think this should go. Does it make sense?
> > > Other thoughts?
> >
> > I think all that polarity doesn't matter as long as we abstract it away
> > with, "mark encrypted" and "mark decrypted".
>=20
> Agreed.
>

Boris --

Any further comment on this patch?  I think we're agreement.  For
this patch series I propose to change the symbol "CC_VENDOR_HYPERV"
to "CC_VENDOR_AMD_VTOM" and the function name
hyperv_cc_platform_has() to amd_vtom_cc_platform_has().  There's
no functionality change vs. the current version of this patch.  The naming
changes just make clear that the scope is only for the AMD vTOM encryption
scheme.

As discussed, the concept "vendor" isn't quite right either, but let's not
add that change to this patch series.  I can follow with a separate patch
to change symbols with "vendor" or "VENDOR" to something else, which
will probably require some discussion as to what that something else
should be.

Michael
