Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44DA6763A5
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 05:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjAUEK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 23:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjAUEK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 23:10:27 -0500
Received: from DM6FTOPR00CU001-vft-obe.outbound.protection.outlook.com (mail-cusazon11020016.outbound.protection.outlook.com [52.101.61.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1602C6AC97;
        Fri, 20 Jan 2023 20:10:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2xsINtbGix14NGb8FSyhEYjCbAyFyDzE0oJcbz7o3djwV5Q06qCuR2OCfMdXD2tNU/JsrCxlnx4q+cK6oyZrFQMGJdBnRYEoP+yjYGWaybd5qlsVKMloBqKb0Xiwmo90Y0hRc3VkIcKBnCQStXoXn/1C8KeNX43dEsptIF2L9YRg5f+qHX75EuTnomI0qw/OiPSu6XKPvEsP2x4WJPOAQ4VkJGTGxHqCTt2JP2xOWcLzAeQDlo1BPmPjeWKELxcvp0qdCAkI8dRqMQ0drX0cXME5HsQNj5i1/6aO/RQyyMap6aJVYOeI//Fx5BdxempC8AuX9FceCDpbfPth5l9mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VY3CrOWypNFbpmUAYPR2E5XqNhoPHNTgdl8mm3kru0o=;
 b=CqjT93FS2/O9ia7LeCbHjKyQf+qk+daOGhfCdkvphFDKMzCeXK/j+2vH3L9Px8fmG9PNkqsBw2FAteWcYybo3wYa15twQi4zwA3hlbKvqoMMavY90vkS+1E0BVOCdsmLU43IJGbkhPZtb2W7sRZ58USg1M96f3ScOt6OvesaNvvy7euFHO1laH4YSmhC5JssZQyb7cUwtiNZa+vJ3OO7QV2LN5rQAgkdjLxIuSEyD3DslKhGqLW3/eL7Ylp9H+0OCFO53pYcwhlNZEjH3LKMbRC8I0bjPs65h/kpm4fD4dMGuSV51zdCxrFZW8ZEVt0pHWSredR+Rgk2ovxJa+hznA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VY3CrOWypNFbpmUAYPR2E5XqNhoPHNTgdl8mm3kru0o=;
 b=LYXI99xYQjD+iLcbMkEKZyGG506/04+NCqQrWiVQZ5DvynfT83KxBMm7ztun8WD99kIf4jUOKrAWvn45SW/v/pMG36pYL+YTMi013QNuw0k1nsKFpRnU2Q5ExWFPYIm4J79tpN6Lb/c1n1vsduvUY/mjvxKcoftN4okBFG9eXPo=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by PH7PR21MB3879.namprd21.prod.outlook.com (2603:10b6:510:242::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.8; Sat, 21 Jan
 2023 04:10:23 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e%9]) with mapi id 15.20.6043.008; Sat, 21 Jan 2023
 04:10:23 +0000
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
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafA=
Date:   Sat, 21 Jan 2023 04:10:23 +0000
Message-ID: <BYAPR21MB168897DBA98E91B72B4087E1D7CA9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
 <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
 <Y8r2TjW/R3jymmqT@zn.tnic>
In-Reply-To: <Y8r2TjW/R3jymmqT@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f61f949b-413f-43f3-a3a3-5fe2fe2522ea;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-20T21:28:12Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|PH7PR21MB3879:EE_
x-ms-office365-filtering-correlation-id: d1840588-0cc9-4406-1890-08dafb656b13
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dZtwbFF+2rzliQ9MmUfy8MO8yWaRUfBXqrHe9UAd70V9EFr8teQPNCTGjKIDumt3MLvPSY5CdD3GW8Ab97ToZGCTI1rYMxrs37J7Y1oGsdVS7eWqVIZFoszYOmkCe2JYBUFUl11ei5BZBkhzlz3TxT+OOEZ36gNYKzUJGwlEi3hkMcRzAZu1YSuH2NkeMsPmPKiJ4R76U8ID/VAeObXj1qp1PGHgBK1qq6NPGTuh5zZ9kzePINPoC12uYfhcX1cVHcdFxl29WJR3gpGpjcwiJeQlM4s1IjzaFQjOoFDLUOW2DyPZsPUpyV3UkzPIlBPi/4vy/yHruDhhUamTiu7b6kxWKrNpjjYWJP1QjwLL3Rw238JxIbZrsFmZPq4tjmZh1mbPX9ferRXOE4m3VABDjdqOPUqhfLxwp/WdgC3OgWkR+NY8Zc8/Cff4XPL9OGwx3d4fh5Z2hZBwGt00v+TLWpNRy1w0rRaefIGTzQfuMXOS8zTN54kwPC/9JBLZzHT8XsUyC4oeaDOCzxDxmlGH5gFZKoef7NQNeTSSNOfyedtDMUT3H5j77OCG0K+dKwamrLUeOThpbChFRQkZNm7VHz+HDKrfuBCCbli2cbqFckL/z/EBUKvm5EjcN0Ed2GrM1KM0O9CY3eFhKBcxKn+2uQdqjVv0Jxxd9pzv8L6nkR341RHsSGK2kqditBFSrCdnHN8wNK5DM3LUWY37gvdqIsmH14K5UqGy6jNUP6Ic62e+TUXCEF+rmlp8HDCWD7YT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(451199015)(2906002)(478600001)(8990500004)(6506007)(55016003)(66476007)(26005)(9686003)(186003)(41300700001)(6916009)(66556008)(82950400001)(64756008)(66446008)(82960400001)(38100700002)(54906003)(122000001)(316002)(76116006)(8676002)(4326008)(66946007)(71200400001)(86362001)(83380400001)(7416002)(8936002)(7406005)(52536014)(10290500003)(7696005)(5660300002)(38070700005)(66899015)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w08aoKG9MpdVPnTDOSmULY56F0NPLyojvNgTWdBpMbH0bSHFGF+CHv19PDiI?=
 =?us-ascii?Q?KVLQ+XCO8vKZhwqGwDje9KUYYj+tCf8V4V7YcvLrNzXbEHJYhnFhn4oeDPuK?=
 =?us-ascii?Q?X7Mgw0HvQJIzPGgOR/DvsM6bqTkdImcs0GUoUxx3pRW2OIpPk7Jh3ITB+I9E?=
 =?us-ascii?Q?L1oiXTxYP7FZorjvAL7WVlXKzIt9Y2S0kbSTIdU4aiQXN8H0Zhw7spGfbszz?=
 =?us-ascii?Q?x2AyLRuKo164/2Mvzu4EHYYHKkH1jLQlyZEsW/6DSxVhqoG3BVPbxF4ky71K?=
 =?us-ascii?Q?BJIhqkDtpGGcwhpLYLXC9+U/qBOGJME0mbErtV8lOKWwfxRX7r4tSW66V8Ra?=
 =?us-ascii?Q?1pyqrV+CSEHKyt6UdOs29by8DV6c2GSHfjfooiBjkX+iI7iUNf/OR1lIP7q2?=
 =?us-ascii?Q?nQENIESArVSzNbposHUA8EttswFTRn2Ri+4A8ye59zwO99v3KHFyKadyXypE?=
 =?us-ascii?Q?EIKhoM3jeqlGwmquZ4RfxNz5ei5mI6Rh1zwTciwXbMvt88P6vsVpoP2Brk22?=
 =?us-ascii?Q?6eYDQzrET1S8hnUNk5awDj08XLJzga4mJH/w/UTjivRv42vKr6qSKctO/w0J?=
 =?us-ascii?Q?/tFuqIQEfM0asjdfMC3mzkBY/q9MBde4V42aLkQUYHGK1cfIJ+kG7UG0knOf?=
 =?us-ascii?Q?Kc1cQ0HO6foBxmZc2MX6NblcXc8teLuyl4HHYkccqCQlcSX+es1hgkd2Y64x?=
 =?us-ascii?Q?bilH6YDBjTgq73bCUKV/OX1nMtOotgIn0ZUQ9i9VpQ61Jw4HYgJOr9mm5b/w?=
 =?us-ascii?Q?jYnhIJ2iCeTSvh5DN2nhNBRqfQ0yOQV9tXzV4eFs5pXq4GfrkMW/e4GGavHq?=
 =?us-ascii?Q?thS5vHPFYGqr5YBZhPxax3OHLIHOfzGlp+NK++8KKBuk/mv6AxKde86Mc68z?=
 =?us-ascii?Q?yKG8C9as2IxbCvaemPSCVLki6BFvgKrLi/Vpo8BlwEym7r/JHrfCBPwzNqnv?=
 =?us-ascii?Q?JUiF94mMhBLBqpcjOHf8DcbXdaO8dAgbzGXXOz/1omPpJP04f4sXPh6OG70b?=
 =?us-ascii?Q?gCzprTkgbeKn8osZDXPyfFAyVoNhVnO9aIgAgn0CgUCVl3HwTFyS2kZpmtu+?=
 =?us-ascii?Q?S04tih4WMNnS2hM056XT+nt88XXnZr6EFrk2398xnegW5g/uqhn+RReDGvGT?=
 =?us-ascii?Q?haaM6C0y2yZyn4Xkbhibyr0aishRxvessL3Y+9+KbNJNYdXU28MTq8MAGAmW?=
 =?us-ascii?Q?UWd2O1V7rbfEa8OFN0032n173W4WgZWLigusJc9FXlpNyv6JO9SvAXE8uDMt?=
 =?us-ascii?Q?L8c+bFS8RDhhNcOl/U4BWCUP3aWc73/+Zxr8MW6DqHvHVlEHlytj0prwhzEt?=
 =?us-ascii?Q?34ICr4ofC3nGa2QAiuHjeU4zABf5ERU0lkJCYRhbjcG/BWsn7q90ZC0uZl5u?=
 =?us-ascii?Q?IGf1Yv4Xxjx34rcIU+HuFDiuEbn9fR5Zr50Y391Gcul8mhbT0Wiyc4lIbM6i?=
 =?us-ascii?Q?GoR4JMgQ0u5P/IREnepMPdaofvmF4z8yOUn3OUlgRrmLwERSuHerx4RQFLr8?=
 =?us-ascii?Q?648DiUO/fERNRxF4r7NKj15wghYGVM1fxWpbbQpA3kXQdKmkzyGDBsIfTX/u?=
 =?us-ascii?Q?Q7kGjeezkjPlmHZ4aVZ1T98afOiqpmM/Tw/O5tUOLO/pi9/YJphb++sYqEDw?=
 =?us-ascii?Q?tg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1840588-0cc9-4406-1890-08dafb656b13
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2023 04:10:23.2403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aalF5HgECv8MPoGurR6MIj4d7D2ieqqBO9mNa4U8EeRF2o6vPE4TkUPlNuxUwLbKHg0ChOr/5fkgLcTsdibwRHZIQkZfoqlAyC6xCeaJBXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3879
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Friday, January 20, 2023 12:15 P=
M
>=20
> On Thu, Jan 12, 2023 at 01:42:25PM -0800, Michael Kelley wrote:
> > In a AMD SEV-SNP VM using vTOM, devices in MMIO space may be provided b=
y
> > the paravisor and need to be mapped as encrypted.  Provide a function
> > for the hypervisor to specify the address range for such devices.
> > In __ioremap_caller(), map addresses in this range as encrypted.
> >
> > Only a single range is supported. If multiple devices need to be
> > mapped encrypted, the paravisor must place them within the single
> > contiguous range.
>=20
> This already is starting to sound insufficient and hacky. And it also mak=
es
> CC_ATTR_ACCESS_IOAPIC_ENCRYPTED insufficient either.
>=20
> So, the situation we have is, we're a SEV-SNP VM using vTOM. Which means,
> MSR_AMD64_SEV[3] =3D 1. Or SEV_FEATURES[1], alternatively - same thing.
>=20
> That MSR cannot be intercepted by the HV and we use it extensively in Lin=
ux when
> it runs as a SEV-* guest. And I had asked this before, during review, but=
 why
> aren't you checking this bit above when you wanna do vTOM-specific work?

Per the commit message for 009767dbf42a, it's not safe to read MSR_AMD64_SE=
V
on all implementations of AMD processors.  CC_ATTR_ACCESS_IOAPIC_ENCRYPTED
is used in io_apic_set_fixmap(), which is called on all Intel/AMD systems w=
ithout
any qualifications.   Even if rdmsrl_safe() works at this point in boot, I'=
m a little
leery of reading a new MSR in a path that essentially every x86 bare-metal =
system
or VM takes during boot.  Or am I being overly paranoid about old processor
models or hypervisor versions potentially doing something weird?

But in any case, the whole point of cc_platform_has() is to provide a level=
 of
abstraction from the hardware registers, and it's fully safe to use on ever=
y x86
bare-metal system or VM.  And while I don't anticipate it now, maybe there'=
s
some future scheme where a paravisor-like entity could be used with Intel
TDX.  It seems like using a cc_platform_has() abstraction is better than di=
rectly
accessing the MSR.

>=20
> Because then you can do that check and
>=20
> 1. map the IO-APIC encrypted
> 2. map MMIO space of devices from the driver encrypted too
> 3. ...

My resolution of the TPM driver issue is admittedly a work-around.   I thin=
k
of it as temporary in anticipation of future implementations of PCIe TDISP
hardware, which allows PCI devices to DMA directly into guest encrypted
memory.  TDISP also places the device's BAR values in an encrypted portion
of the GPA space. Assuming TDISP hardware comes along in the next couple
of years, Linux will need a robust way to deal with a mix of PCI devices
being in unencrypted and encrypted GPA space.  I don't know how a
specific device will be mapped correctly, but I hope it can happen in the
generic PCI code, and not by modifying each device driver.  It's probably
premature to build that robust mechanism now, but when it comes, my
work-around would be replaced.
=20
With all that in mind, I don't want to modify the TPM driver to special-cas=
e
its MMIO space being encrypted.  FWIW, the TPM driver today uses
devm_ioremap_resource() to do the mapping, which defaults to mapping
decrypted except for the exceptions implemented in __ioremap_caller().
There's no devm_* option for specifying encrypted.  Handling decrypted
vs. encrypted in the driver would require extending the driver API to
provide an "encrypted" option, and that seems like going in the wrong
long-term direction.

Finally, I would have liked to handle the IO-APIC and the vTPM the same
way.  But the IO-APIC doesn't use the normal ioremap_* functions because
it's done early in boot via the fixmap.  I didn't see a reasonable way to
unify them.

Anyway, that's my thoughts.  I'm certainly open if someone has a better
way to do it.

Michael

>=20
> and so on.
>=20
> And you won't need those other, not as nice things...
>=20
> Hmmm.
