Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEED687598
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbjBBFv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbjBBFvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:51:05 -0500
Received: from DM6FTOPR00CU001-vft-obe.outbound.protection.outlook.com (mail-cusazon11020016.outbound.protection.outlook.com [52.101.61.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392517FA31;
        Wed,  1 Feb 2023 21:49:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nN9WjH/3CPmW5LxFemwsvfM6WRglvagAmVJ3woHqIoPM1k/ogaJ8K/JI7DcDPfKU9DxA44cy/vubqJE7f29UhVMKoZn7rj9J6y9o68rlsyMTaxprsUDeT2uWHP5pJDZjtl9RoM/s4rU8AmYlkownPe26S9//3INdONgU8VLkUOHM1Lthd+pHGhPHYFrhBNeKAppBpr96XcTulX0q5dc4NuriWLkDWF0yh3DeN6hHOl2X9nUBTw+Gcb/ecsAWsVzEpBOvNhKYUWmzqiDMnc7Y/Es7Kh47aVdcvws5XpRzhPwZJe0fPcbMrKTdeiim0/DpR7uCh1M9wX29ZGHc3GFkZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pMRZikwCsO7+tY0C+N/mimJHAK1TJSjB4qB8tY1pZXE=;
 b=kaUwS6c716EmMGntfGYg6fdisC+n6tg8CSt7MnkSfO4APgvq8WG+lWsRhYP2YtlOwRe7A5jEvz6rFv/oSnummiRbMjVLcxypOP1QqtyyYlWkXWNRlELSLTRyACwLuECWFT+NmGTuFUlj716U+WAzKrYGXWKaemLoshIrEpajMNoIVTC2JfPKYJT9/+VMJvPUqBWb9EDex2fyEtA6N/okA7NxXqw6vUQjkhTqyAmMMoVQ/nGTceN32l0FpYc8326q0JBaQSFbGoUZ6uqv611QTeLyLy+l7+SIPBGnnrx4AUG8TzTjqCNle1DN7RaD+xPBYpZa8SPESxhSGDEwEh2gAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMRZikwCsO7+tY0C+N/mimJHAK1TJSjB4qB8tY1pZXE=;
 b=Y7ggHAsF982z8+2GuKA4crTWEjh6WbVoAZzfTpR47K0jkH82O5mMgRlAfjOlwPRH3TjAsLWKd044gZVIozrzXM2icgwTtlkj8XVt0wo1s3HWp29OzJ7rpxBlXdtKTyCOIbgv0V4GFY5X/xECTl7uL+zg8WiZTRKK0iI/5leTLEc=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by PH0PR21MB2061.namprd21.prod.outlook.com (2603:10b6:510:b4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.7; Thu, 2 Feb
 2023 05:49:45 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e%7]) with mapi id 15.20.6086.007; Thu, 2 Feb 2023
 05:49:45 +0000
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
Subject: RE: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Thread-Topic: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQ
Date:   Thu, 2 Feb 2023 05:49:44 +0000
Message-ID: <BYAPR21MB16883BB6178DDEEA10FD1F1CD7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
 <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
 <Y8r2TjW/R3jymmqT@zn.tnic>
 <BYAPR21MB168897DBA98E91B72B4087E1D7CA9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y9FC7Dpzr5Uge/Mi@zn.tnic>
In-Reply-To: <Y9FC7Dpzr5Uge/Mi@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=38b182b8-3eac-4720-aa72-b1b0d2224396;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-02T05:22:11Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|PH0PR21MB2061:EE_
x-ms-office365-filtering-correlation-id: 5bbebc35-5613-4b60-4563-08db04e14945
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X+WawCPX9JOlY4bKQdj9uDVvp0xMoHuUzYyKVn5cVB9qVMxESzJym7w7A7LsB5M+Bh00BrRa09gE+CVLIK8T7rUTVU502Hf+Gzbr3JlGymsH1alPne42Aztq7SEjarx6aD7Y0l2UvC2FPAukXcfxN2mJvOSdp+VbsCRKy5wouO6kJu+5bAWhvIoVa2Ir9bWBcZjTjp4TBO3RM5fJGBXt1SrazCqiMSEegmjO2axm5Rg7GbVVrYk7IGVUBgfwbxXCgJFtvg9mq8Lrl+8MgDuMbzDRxh8j0rJEF6FFyE7JO3D8hM6P/XURCv/DsRQnIzFOnFhA//5xs+ib2oSZnJRSEvklK0AwwQhOVq6d55Mqzzlmn7lzTu6cIqOea6ZdZ1mjYwihieOHbSF70AI2IrC98UsUXXRZHIoVOBIzUC2xelrvhsqM+t8NYf1tRAL0RWP4QUqJ0fCY+xGJGiDsUsZLgS6MTUUiDJi/i+780pDgekSNmAZaGkzqZ36bTWmRTXW+rTRH9nS49U6TV6XYEhadxemYmv4rvrX8kPL4oJaASQEobn3o6spvYjolynHDkX41eYjZ6VjNMEAup6KWroJ5T1itcS+9VfdzlUV9fgevHoVWrtCAogTYsdFPvjjuOurO53BqYRVZDbsl0O/PsWsfBJkweuKWMMYjgCYYHV+suZB3jimlXIzY7cCE28wIVqC3td1LNfd+zV1rxsKgomtoZCveQn+cO67OJjEVaTaVpXqYXiqp6E1aZcfzVQFF6M7b
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(451199018)(66899018)(83380400001)(54906003)(316002)(8990500004)(33656002)(2906002)(38100700002)(122000001)(82960400001)(82950400001)(7696005)(10290500003)(6506007)(8676002)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(478600001)(71200400001)(26005)(186003)(9686003)(8936002)(55016003)(86362001)(41300700001)(52536014)(38070700005)(4326008)(6916009)(7406005)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SQRz+3WVlBTnlwH+90Fsz2j7nV0sditH1C+u5VihsdfqXmiYLZ5IUfhsgE2Q?=
 =?us-ascii?Q?rSCmFK16jpEViZj+kvJZPkAGYlDHUJ9NP0KNSjJP1xI5MKjBGxfOGY9jqXon?=
 =?us-ascii?Q?ueBIXFHHBhDOe568vh3I3ZqxaQ8LC2t+ERDxQpzeSyuVh+UAl2jhjBcENRuG?=
 =?us-ascii?Q?v+3OVdTY4OD9+z9Cf+SPeneHkLWABRpjLtDxDqFcQnRS3YTjZOKHCskQ71Y9?=
 =?us-ascii?Q?gfTHz1d/9hfrvqSeNo0prC2sL7PE3lC0sOXEBsN4cGS9P9GEG3gobJ60vt6d?=
 =?us-ascii?Q?1C/PZfDLhO5Xii0PxGu3sgA1/b51w7SQjsidjXZ/7Kat3/YBiATY4qRtJWCS?=
 =?us-ascii?Q?RzV1yyrOu3ktWXuJLmrxkx4+WR3qvBpbVqYpTufebzwRqXjiw3Q9VOQ2nybL?=
 =?us-ascii?Q?UiLAieMnGnReUCK990k5Q7y5p4qqhLDsnFwRESKqW+KhnuMG5OYZ62aKnheF?=
 =?us-ascii?Q?wo8Q+jfr7Et3iKABXT6sdJFGIfRCpuobDs5KXT08yJZV2mFyzwIps1DhGG19?=
 =?us-ascii?Q?3T++zcPKSTP9RdCALbQGB7eUbMlRRh4T9aPHRCXO9v3sJ8ww0vGJrJsjzhZn?=
 =?us-ascii?Q?tNu9OAjNHTrT32Abv4XLKa68tqb93NAKxTpOa61ZOHmCeXGm2d0n5mV0Tp1A?=
 =?us-ascii?Q?ODiCSu7sgmdyP1eXUk9Ysmk7EiaCV6MbQeu/E8mYcjmiVzCd5U962WqvPVyV?=
 =?us-ascii?Q?hZxd68NUzlNPoNk0cYXqlq5VGd3P9YKTeIAyLXLhq5q6yGMbsK6b8WAbVmoH?=
 =?us-ascii?Q?xJQnC/eSBLVUSIi7rUNTsHSqwRQH/oz+enJqbRpl3jY/UGY9grlfvePJRW+G?=
 =?us-ascii?Q?HNDTZ+b9WtZyAQpWACI/7kppAk2dHpJcVRpoB/JEywTgJ3CqVAodBeMaW0FE?=
 =?us-ascii?Q?lp1th0dFCURCFDspdFMPcXhVXaPUFEuvcFA3e8xeWmHlhky744VcTNyrqxZw?=
 =?us-ascii?Q?3PDEtb4QWASM8w8mqY4GgoK4apeaAAapx0Yv+FTHiemUTJq8b2QCxReBokof?=
 =?us-ascii?Q?TIZ6XYSoStYIrEE0ZVHbaja2uJ4CzeFs0Me8/W6Afdc500bXvblL4BNfR9xi?=
 =?us-ascii?Q?yVVfYZf9qUkvF/wVQMA9ZxLqoUpjuthG38WY6WJEANam2+xi8MMvOUx9Itqf?=
 =?us-ascii?Q?OVhmPhPaeVsDZsov9JHDXGTKVorjcyNVfM6dHD4q51EC/FJoZNS0ZL5h3OYm?=
 =?us-ascii?Q?1ZHmOD2hLtbXim2bvWCglCiPVcxzxdwQ0xboprgg42bFFVcwbf5SSxPRegDj?=
 =?us-ascii?Q?JIlxPtdZY5K0gyRImx2r0ZKAXYaeRkR7MS3LbsLZnPQo+++pQQ5z+bA+3/sW?=
 =?us-ascii?Q?gerbxlvGSL1H1MvPhWS30JeODiqO83SFdT264DrwB79Y55Zwn0JTkkucgr/f?=
 =?us-ascii?Q?1Tk5WA7g6VaP20an40pIA51CxjPOUxHI5oPHV7ZmR9LOLndPEHF6MkFyHjlE?=
 =?us-ascii?Q?/qccgdMxIwcTbuiHiCzqJXjFgt+0VBckY13xUEr7jW4e/brQwDU9RDE0zPae?=
 =?us-ascii?Q?syU/Vac9tL3z0d+RmCKSXh+VYHg+211dcQriy+ZUBwtuw/iycuSgzrhmc1sw?=
 =?us-ascii?Q?d9XfczRrfhyLmrb61nTnPgg95aK8wPCCv1N/4kY1AkJpbP6Tz1kq5QuA0ud9?=
 =?us-ascii?Q?vg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bbebc35-5613-4b60-4563-08db04e14945
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 05:49:44.6330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0YzANXLlMSi5aDye5sXdAR4yjoa1tu+vYvUs7ufbumNBJp4nk4Fs+cf2rb69410JJI6EnZSs4/R+HlEW4mrzTEExDjEa8XjY11pFq/2obDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB2061
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Wednesday, January 25, 2023 6:56=
 AM
>=20
> On Sat, Jan 21, 2023 at 04:10:23AM +0000, Michael Kelley (LINUX) wrote:

[snip]

>=20
> > But in any case, the whole point of cc_platform_has() is to provide a l=
evel of
> > abstraction from the hardware registers, and it's fully safe to use on =
every x86
> > bare-metal system or VM.  And while I don't anticipate it now, maybe th=
ere's
> > some future scheme where a paravisor-like entity could be used with Int=
el
> > TDX.  It seems like using a cc_platform_has() abstraction is better tha=
n directly
> > accessing the MSR.
>=20
> That's fine but we're talking about this particular implementation and th=
at is
> vTOM-like with the address space split. If TDX does address space split l=
ater,
> we can accomodate it too. (Although I think they are not interested in th=
is).
>=20
> And if you really want to use cc_platform_has(), we could do
>=20
> 	cc_platform_has(CC_ADDRESS_SPACE_SPLIT_ON_A_PARAVISOR)
>=20
> or something with a better name.

I do think it makes sense to use the cc_platform_has() abstraction.  It's
then a question of agreeing on how to name the attribute.  We've
discussed various approaches in different versions of this patch series:

v1 & v2:  CC_ATTR_HAS_PARAVISOR
v3:  CC_ATTR_EMULATED_IOAPIC
v4 & v5:  CC_ATTR_ACCESS_IOAPIC_ENCRYPTED

I could do:
1.  CC_ATTR_PARAVISOR_SPLIT_ADDRESS_SPACE, which is similar to
    what I had for v1 & v2.   At the time, somebody commented that
    this might be a bit too general.
2.  Keep CC_ATTR_ACCESS_IOAPIC_ENCRYPTED and add
    CC_ATTR_ACCESS_TPM_ENCRYPTED, which would decouple them
3.  CC_ATTR_ACCESS_IOAPIC_AND_TPM_ENCRYPTED, which is very
    narrow and specific.

I have weak preference for #1 above, but I could go with any of them.
What's your preference?

> > My resolution of the TPM driver issue is admittedly a work-around.   I =
think
> > of it as temporary in anticipation of future implementations of PCIe TD=
ISP
> > hardware, which allows PCI devices to DMA directly into guest encrypted
> > memory.
>=20
> Yap, that sounds real nice.
>=20
> > TDISP also places the device's BAR values in an encrypted portion
> > of the GPA space. Assuming TDISP hardware comes along in the next coupl=
e
> > of years, Linux will need a robust way to deal with a mix of PCI device=
s
> > being in unencrypted and encrypted GPA space.  I don't know how a
> > specific device will be mapped correctly, but I hope it can happen in t=
he
> > generic PCI code, and not by modifying each device driver.
>=20
> I guess those devices would advertize that capability somehow so that cod=
e can
> query it and act accordingly.
>=20
> > It's probably premature to build that robust mechanism now, but when it=
 comes,
> > my work-around would be replaced.
>=20
> It would be replaced if it doesn't have any users. By the looks of it, it=
'll
> soon grow others and then good luck removing it.
>=20
> > With all that in mind, I don't want to modify the TPM driver to special=
-case
> > its MMIO space being encrypted.  FWIW, the TPM driver today uses
> > devm_ioremap_resource() to do the mapping, which defaults to mapping
> > decrypted except for the exceptions implemented in __ioremap_caller().
> > There's no devm_* option for specifying encrypted.
>=20
> You mean, it is hard to add a DEVM_IOREMAP_ENCRYPTED type which will have
> __devm_ioremap() call ioremap_encrypted()?
>=20
> Or define a IORESOURCE_ENCRYPTED and pass it through the ioresource flags=
?
>=20
> Why is that TPM driver so precious that it can be touched and the arch co=
de
> would have to accept hacks?
>=20
> > Handling decrypted vs. encrypted in the driver would require extending =
the
> > driver API to provide an "encrypted" option, and that seems like going =
in the
> > wrong long-term direction.
>=20
> Sorry, I can't follow here.
>=20

For v6 of the patch series, I've coded devm_ioremap_resource_enc() to call
__devm_ioremap(), which then calls ioremap_encrypted().  I've updated the
TPM driver to use cc_platform_has() with whatever attribute name we agree
on to decide between devm_ioremap_resource_enc() and
devm_ioremap_resource().

If this approach is OK with the TPM driver maintainers, I'm good with it.
More robust handling of a mix of encrypted and decrypted devices can get
sorted out later.

Michael
