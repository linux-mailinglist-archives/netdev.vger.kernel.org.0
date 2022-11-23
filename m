Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B975B634BE1
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 01:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbiKWA7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 19:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbiKWA7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 19:59:04 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westus2azon11020027.outbound.protection.outlook.com [52.101.46.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3773DC75B5;
        Tue, 22 Nov 2022 16:59:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfWU+egp/2rA/XbQfSVku53Ss+PUQxuh1uQypldsfrldpJlPv+xwxp7kp1CLJG03avGyD1+9RpJ3QWrFeROS/p48nKDfKM3Z22rK+4aMDgXFxd6tY9rt/gn9hMf8tER7GmYt3E5IIji+vbmJmhynMF22FxBfnwTPBsOPMNB/OVWC4M0klmlib510LGSfmsDxbFI1x1u6djFvxuGZUhOWuDDVg5t/2PuD1J/EeuAZgzceUkJUuI3gMA6yRj37HmDAri2nwHW7F4w+FEdN0uuH9OArAX9L+E4dFBlbwtaOu4N5LgnaJAW2YMhCZVoGmGI0qG4UnDUG4fIYRy2yW9fbzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXR+ZT1qAU0qhPQdw/Z1PKwejImDz/G/M2AZkPZFlq4=;
 b=W/RB8druWL/0rm1vAcpLOVG9HfAv18ZrDbgFG8ZgrlyHPCUoktjPFOiWcOA+yOKxtqJLhB2itsid7KsYPaJAp5xcy622j+mulQ+pSRdAL89mMXxCoTu3Qa//A9F6ouMhuJ1eF6mhWrCJf4eKtVRgG2hQEO8fNP4Pnvr0hkGdZGxxxTR+5fnbRnEUylu0MlUI1QMwM1ZMC11DRrCzHIuceVGJqbGyE8sawpDkeZfF9QH1oXD4h0WOGS1ivX5dhbhEJfmJwr2Gkj74bG82EHuKEwXdMI+w7b1YtsmAzoEMk8Ii/2WqtcaHs5BsyNVl9ZeIS2TTrTE+IT8nV501iX2esQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXR+ZT1qAU0qhPQdw/Z1PKwejImDz/G/M2AZkPZFlq4=;
 b=VMbMElFUNVQ+2WLIoyefHI+xP5oJlYaZ+8gutiOJ2Rb+4wcThhT4u5KdhblYgVZHe/aQO6QEQQnL/TUZJscSMwOujxWKLoNDjSx/Gh1C9jH0NGD4lw+PkKN8hjGrvMrL8PItkojX+HXP07NX/ePn5z3YDKlU1U7yCfNaW8+/zXI=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MW4PR21MB1908.namprd21.prod.outlook.com (2603:10b6:303:7b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.2; Wed, 23 Nov
 2022 00:59:00 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%4]) with mapi id 15.20.5880.002; Wed, 23 Nov 2022
 00:59:00 +0000
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
Subject: RE: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Thread-Topic: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Thread-Index: AQHY+es2O4adbWIH8UyWtCwRyUnUyq5JgOOAgAHDpcCAAEhFgIAAJ7oQ
Date:   Wed, 23 Nov 2022 00:59:00 +0000
Message-ID: <BYAPR21MB16886FF8B35F51964A515CD5D70C9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
 <Y3uTK3rBV6eXSJnC@zn.tnic>
 <BYAPR21MB16886AF404739449CA467B1AD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y31Kqacbp9R5A1PF@zn.tnic>
In-Reply-To: <Y31Kqacbp9R5A1PF@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=fd4d8306-d27a-476f-b22e-64e344b7a1f4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-23T00:40:28Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MW4PR21MB1908:EE_
x-ms-office365-filtering-correlation-id: fa6b4a9c-0b6b-4202-a5b6-08daccede867
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xGQNPY0oUM8EwhRxDncl3kjtYoaBjbfkCgKOmPRILFuPUyw5ejgh/N2qlXoG4WNPzW9uZ6WFnrDc75PCH0A0jgi6oouHrtilZ9wxwcCkDbAoIa8HXcEeUvl2i8MZwNcxfDbrHMzyGpysCmnYEs9N3N9rpe5HfwjjNiDYhP0TE1HsonD7fWDbRUvsed5ZE0shDCQT9vPYgTEGGVirUsE5S98K9457ZcT3IfpVszB+NTqNG3zsQ1p+JAPl7kB/liM8bpt5ojPcL2lJT75QuMXVegRte70Yf6m3psMs48LHMZLKotHtvmWzO+9Toswpr2+zzqkK2eiFhmC1g5MkqbUqCp9/eh/hU0TGKmQJTG+LTF17FGqe9EvwLyzQTsArjvbVfZiDNZY2C+JsOw9WHIcLPfeyrxokjk+QUES9pl3OrA0ncVPauo4ImEZYC+KulDVEtTe6N02kQXRDMgXXu+1RxGXXQH4+HhAbLI0Sk9VxVZ8SSViILrq2X8fgzEqYqc3whL9lKi3bUZWSsZ91bZFpG7ktAmR+npwJUGYMDBpSBT1FbOWvQhOmHRP51iNT2EwEls484t0bGKnETYLZ8JTKJMywtqvTmL9L8eK1g6iqdySF7YfP6H+gtyzW8cH3F/h/yE1rkyf6I0k4vWXGxfnoaGLhYkad/l1hYSL0iGo8cUYLggVocVyyaXB52kfURkVClOzrhP1IGjg4TchNaM3FEE6Nn6+Al/EtkyyBDCbjxpFrDG/Ng2dljYi/O0q/K6GS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199015)(66899015)(33656002)(82960400001)(2906002)(8936002)(52536014)(8676002)(38070700005)(7406005)(7416002)(82950400001)(83380400001)(122000001)(86362001)(38100700002)(54906003)(316002)(6916009)(10290500003)(186003)(76116006)(4326008)(478600001)(5660300002)(66946007)(66556008)(66476007)(66446008)(64756008)(55016003)(7696005)(41300700001)(26005)(6506007)(71200400001)(9686003)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aWUxCvdQTp1dso9jZEg5tpBbY1VulWPalFnKENjo8IB4JFe0WDjLMW2RCF9u?=
 =?us-ascii?Q?CG3U/doxvxP+5fT/xf1+iAV9m8nYAlHXSqg6t2MBf5LuvJAsCMYPgaLZPdK8?=
 =?us-ascii?Q?7xaREsQs/KvVHvxWcbU3xE9RgPdaohAyR7lECiCGCYrmDi+xOjjjEGIEGITE?=
 =?us-ascii?Q?BiqIs4QF/LuzkDZ4/vt0zovbKM+6+pp+8C9uI2rIXtzlAoUpzbXQn7demZdM?=
 =?us-ascii?Q?4+VnbLpQrxDbOTptS4+qi9gD3/93eYdmm2Tsr0xs69vi0xvEJo81KOY0sxm2?=
 =?us-ascii?Q?64rShLh27ph8DMMiM4DuNRrCL3uPKzvNFVNqnpKtrSL5cGxkUr44bn0suTDC?=
 =?us-ascii?Q?DtF2jC+y1M0D/Scy3XnpZkFH6SpQmi5+S8MG+5lYf147fQG4jdwalqhBxuEn?=
 =?us-ascii?Q?oQ32Jr1tQEcfu8KO4w1GDS/KkzTWVp0YbVfoJaXZ4QkGjLQuVV+MvRF8CVHN?=
 =?us-ascii?Q?b5j8UaRfpkYg9QCUJNQ7G/n104LGjv1/6elWhM45EsABqSsKNbG954hpGOgm?=
 =?us-ascii?Q?eFDZanUuXvm52YVSEN5HQLmoZ81Wz0aADLPbr6TSoNnW1mjwEWmV9Zu4qmvG?=
 =?us-ascii?Q?CM9UxNUIi/2BaOGeY1WwTFkvYPVBLWlQlHdVOa5ERuA6d04eHjjJVpDf7xFF?=
 =?us-ascii?Q?meiDgt8BryjAWq7V5SZgDt2ehG5eVNI7LEsSjGgbN9qq2ekhfdq89pu6GfGJ?=
 =?us-ascii?Q?ROp56gJhzOAXLzSGtt0OQH5kCx9zP4OAP72cfrgJlB9qY/ZOXIRjv71F5E+z?=
 =?us-ascii?Q?0GgMshRRk4FQ9Eu0UNy/oI02zp1kKj2DSLV2ybRxPKdDHFmEJqs6vlmjEc6q?=
 =?us-ascii?Q?pIi3+VlJ/Rayo3VbIh0arMiWjhhUQJ179QtUwbi7BgCSHcDItou8vqDXdEki?=
 =?us-ascii?Q?M7TEjNc0rZ24257YaWdlDbsI+xeKZRL9uwidJYXN48r6lD/3PtJt7NM6McIK?=
 =?us-ascii?Q?k6VJBmhdjN9retMckC930wrqX+t1wHR1G3x6ImTVhc23RQAEykknojTlJ4cf?=
 =?us-ascii?Q?ZaQRZhmXTJrJaCvZimZwUvIwJiK0w144vGvxv5hByx00dBCS429xMxzSUfqy?=
 =?us-ascii?Q?brbyV0y4G2roGpbK1/eg/GT5A7Rgs+T11BfMKZyLHC+e1hc7XdeMqXvmQGws?=
 =?us-ascii?Q?NuffGEC/CiBXgvCKujlBNV2tOXrSO/0gkemrrIRsZQjenrx758fJ7Lxon5g4?=
 =?us-ascii?Q?vX+tWUCBGrlZ4aVHP2vGwv9duug8/M2OAmwDWTQzj7dCmJxH5e1PK7Shx8D2?=
 =?us-ascii?Q?adnfLdglH3v+H+IxoSeh/uzV8HkrNw03/0uVBkz8IEpGuHDZfpJL9RePwhFZ?=
 =?us-ascii?Q?JqrDUTvda9lgd+vapacgK28347gh7TiDI7j0/pN9FL0nJNCjH0VFzh3E+V94?=
 =?us-ascii?Q?+eliv/6g1SKvbeTVVLh9g/2By3wws1ubCcBPMy4MvYa7lx9Vv7hddaBibpaW?=
 =?us-ascii?Q?TeWF5NMI2IPWM4x1wv75OvKrX15A7SFR5RR1n5raryYU/nU+HOnf63XPAN6F?=
 =?us-ascii?Q?XvDq+D3Tk562OZZzh7+ddSUinp+MKF+kJEgXrp0Z3oTwD8tZWRb4PdrHboJp?=
 =?us-ascii?Q?dYsSpFpWSFyAk3BSYmuHZes8IR6m9bDFr2zIcdqtelT41KA4Wk9mTVpe2qIY?=
 =?us-ascii?Q?Rw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa6b4a9c-0b6b-4202-a5b6-08daccede867
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 00:59:00.4456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i+J9hYyrrvNbvqxjQ5aIklchHmjSRi3CvQbgwn96hvf9zsqxNGQqvVzPWKls8cDYzUukw8QxQgPHcMlLB4lYlbwC2O+PKZROrbzZhaNlqbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1908
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Tuesday, November 22, 2022 2:18 =
PM
>=20
> On Tue, Nov 22, 2022 at 06:22:46PM +0000, Michael Kelley (LINUX) wrote:
> > I think the core problem here is the naming and meaning of
> > CC_VENDOR_HYPERV. The name was created originally when the
> > Hyper-V vTOM handling code was a lot of special cases.   With the
> > changes in this patch series that make the vTOM functionality more
> > mainstream, the name would be better as CC_VENDOR_AMD_VTOM.
>=20
> No, if CC_VENDOR_HYPERV means different things depending on what kind of
> guests you're doing, then you should not use a CC_VENDOR at all.

Agreed.   My proposal is to drop CC_VENDOR_HYPERV entirely.
Replace it with CC_VENDOR_AMD_VTOM (or something like that) that
is set *only* by Linux guests that are running on AMD SEV-SNP processors
and using the vTOM scheme instead of the AMD C-bit scheme.

>=20
> > vTOM is part of the AMD SEV-SNP spec, and it's a different way of
> > doing the encryption from the "C-bit" based approach. As much as
> > possible, I'm trying to not make it be Hyper-V specific, though
> > currently we have N=3D1 for hypervisors that offer the vTOM option, so
> > it's a little hard to generalize.
>=20
> Actually, it is very simple to generalize: vTOM and the paravisor and
> VMPL are all part of the effort to support unenlightened, unmodified
> guests with SNP.
>=20
> So, if KVM wants to run Windows NT 4.0 guests as SNP guests, then it
> probably would need the same contraptions.

Yes, agreed.  My point about generalization is that Hyper-V is the only
actual implementation today.  Edge cases, like whether the IO-APIC is
accessed as encrypted or as decrypted don't have a pattern yet.  But
that's not a blocker.  Such cases can be resolved or special-cased later
when/if N > 1.

>=20
> > With the thinking oriented that way, a Linux guest on Hyper-V using
> > TDX will run with CC_VENDOR_INTEL.  A Linux guest on Hyper-V that
> > is fully enlightened to use the "C-bit" will run with CC_VENDOR_AMD.
>=20
> Right.

Good. We're in agreement.  :-)

>=20
> > Dexuan Cui just posted a patch set for initial TDX support on Hyper-V,
> > and I think that runs with CC_VENDOR_INTEL (Dexuan -- correct me if
> > I'm wrong about that -- I haven't reviewed your patches yet).

I confirmed with Dexuan that his new patch set for TDX guests on Hyper-V
has the guest running with CC_VENDOR_INTEL, which is what we want.

> > Tianyu Lan
> > has a patch set out for Hyper-V guests using the "C-bit".  That patch s=
et
> > still uses CC_VENDOR_HYPERV.  Tianyu and I need to work through
> > whether his patch set can run with CC_VENDOR_AMD like everyone
> > else using the "C-bit" approach.

I haven't followed up with Tianyu yet.

>=20
> So I'm not sure the vendor is the right approach here. I guess we need
> to specify the *type* of guest being supported.

Yes, calling it the "vendor" turns out to not quite be right because in
the AMD case, the technology/architecture/scheme/"type" (or
whatever you want to call it) is not 1:1 with the vendor.   Intel has just
one (TDX) while AMD has two (C-bit and vTOM).   "vendor" is just a label,
but we should get the label right to avoid future confusion.  The key point
is that we'll have three top-level types:

* TDX
* AMD with C-bit  (and this has some sub-types)
* AMD with vTOM

The CC_ATTR_* values are then derived from the "type".

>=20
> > Yes, the polarity of the AMD vTOM bit matches the polarity of the
> > TDX GPA.SHARED bit, and is the opposite polarity of the AMD "C-bit".
> > I'll add a comment to that effect.
> >
> > Anyway, that's where I think this should go. Does it make sense?
> > Other thoughts?
>=20
> I think all that polarity doesn't matter as long as we abstract it away
> with, "mark encrypted" and "mark decrypted".

Agreed.

Michael
