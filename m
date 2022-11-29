Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB8663C426
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 16:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbiK2PuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 10:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbiK2Pt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 10:49:57 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westus2azon11020018.outbound.protection.outlook.com [52.101.46.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248CB65E53;
        Tue, 29 Nov 2022 07:49:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLzfl4AWcXJ0ltlEwFTp3nIw/AqAeDYBiJeiaETCW1qBe3qkf9itMSmAU1HKifvNsYAkCvbB/W2J2fifI92IyeCkzHWiUyq/HU8FMJiSK/JSmO/GXHDOQY5m3+BBmygIx6LVqjMswNGne8qDXimqc4Rq6ui5aotSRPTdzTAQNSKApfalapcesqBktu6nP6zW6fRvKqeGAUTCyIEe4bIu/qks5k8h65CiBxBv6AT1hrajIryhQfyraSCWDpY4t5w7GFrfcBebpgZw5ktcypB0rhgmVDMIiG3sRmsP6zv64HvbKIHQccYnftxS4lKLhWRdJ4Nu8kYP+ALd3GODYPm/ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sJ4X800mvg4TiRfgc+sMBtN7Lxh++JlTz8FiNwWbgJA=;
 b=cOaRIdmJvd+cbxeNfBlK9g1BDC7nS54Rgc3jysWikCcDPEV0wOKX6UMSIu5RJNfvVruRH4nEH7YTb4XndcSJep43Js/1/YrX/wJDuCA3ZWqvgCfmF1HMBNTy6vEvCHThM1fccekJIngYk1uTC3K0GoFMJwxPx7IfvalNcqXuW2HvYxWIbNqG5PirJXx+L87kNIam88dP5fdZxBBFDsfmkVYtnAG/c4r6s2GGjb6eV3vrtsbURiu9i4rm5q302r7UhHnP7WJ4E2aPyVvqMw3nzvD1QIlTDQfhiU5pxphz0IBz80ELPjWi/6gM9Z7fk4/8H4PFc3U2vkp51QoJdRL4yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJ4X800mvg4TiRfgc+sMBtN7Lxh++JlTz8FiNwWbgJA=;
 b=ha7rHO4zzcUWTy7yQvPhaBcPUCykDQY1lxUM74MQDMm22npZYTamKa93bihkGtKM+D+2UOSZCwVfqBosPOE4+mgOGUQpXKHQhpV89YfoRurCIjIY7Dc/OHpJyH7H62tFSNocud5nnKNZ/rTLiY73X2dv6y9shA66eB3b0EXyDpg=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by IA1PR21MB3403.namprd21.prod.outlook.com (2603:10b6:208:3e0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Tue, 29 Nov
 2022 15:49:06 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%6]) with mapi id 15.20.5880.008; Tue, 29 Nov 2022
 15:49:06 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Borislav Petkov <bp@alien8.de>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
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
Thread-Index: AQHY+es2O4adbWIH8UyWtCwRyUnUyq5JgOOAgAHDpcCAAEhFgIAAJ7oQgAjDHRCAACLagIAAALfwgAANigCAAAHQEIAAKJ+AgABUTmCAAIE5AIAAb5XA
Date:   Tue, 29 Nov 2022 15:49:06 +0000
Message-ID: <BYAPR21MB1688D73FBBF41B6E21265DA3D7129@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <BYAPR21MB16886AF404739449CA467B1AD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y31Kqacbp9R5A1PF@zn.tnic>
 <BYAPR21MB16886FF8B35F51964A515CD5D70C9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <BYAPR21MB1688AF2F106CDC14E4F97DB4D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Ti4UTBRGmbi0hD@zn.tnic>
 <BYAPR21MB1688466C7766148C6B3B4684D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Tu1tx6E1CfnrJi@zn.tnic>
 <BYAPR21MB1688BCC5DF4636DBF4DEA525D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4USb2niHHicZLCY@zn.tnic>
 <BYAPR21MB16886FF5A63334994476B6ADD7129@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4XFjqEATqOgEnR6@zn.tnic>
In-Reply-To: <Y4XFjqEATqOgEnR6@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e946155d-384f-4667-ad6e-0a63b4eabec4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-29T15:20:07Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|IA1PR21MB3403:EE_
x-ms-office365-filtering-correlation-id: b8d43859-3b88-494d-706e-08dad2213f5b
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jnpmE68QYdjSkXKSg5eaVA3mYIE22EPckfvvEcOu+jTVVQdJwR58UwLDqNYAriKnTQBsNMlRlQ3OybOHRW47qjuM9VdbRCshPbygFpifrrfXsPbmcdQSfh0p2/SlmH6Aaf4/J9oLHxXIv2l4de5RU0HGHXNypjGBxAjqvkxpszTDAmwO2CqGysdDJ14aaT5idnp61n3wmC7HfXtgJlGW6Y7jUTbYXcp2L0vocwvVf6FN1mlzHDBfPLx0v9RkMBbCj/chhpEfjbIzaoma+PhqluqA3+wQF/dhGSAxUOL9VE+fgwMK3LQX1/g2RXsKi0H2+6Xc8zBuNsk8Du/OFHohQXbiy6AKyO32m1nAgoYj18XkzFKklhmmUl9sJWI7bceKjkx1DA+/reO+JVTE+NTeJufRIXiNJOPcQARN/b20w2Kppyxw1PLMU3H21/gKaF5sb5NiQrc+iXxpzDAtC0gXvsccoK7t21UNK8a+citM/5C+85V/juCCa6mS0BMNbz53EnF0mtdq4Dz307TiacpgNqelQQuFgA+LHm4aOedVrBh0NDxJXd2CEjubrxA2yzwONZzlRczr8PdJhQsaaWstm6b5gV6UxPqfq5zb0H0XNNPWT3eZ4rxUkKR/rHHAeKRjX0eUNDeSqbi3d+PjlYGZQdxpF0Jnw8lIrCYi4rlaiECwUrithRovaDBQaLEcLHXcuMxCQJEGueLegtGI7RLMzbdQiT/OTjwUUXgZ5t6yqSr0itH/SUsnFL2pMLg6abEr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(316002)(478600001)(76116006)(66946007)(2906002)(110136005)(54906003)(8990500004)(71200400001)(10290500003)(38100700002)(83380400001)(82960400001)(55016003)(122000001)(82950400001)(33656002)(26005)(6506007)(9686003)(86362001)(7696005)(186003)(38070700005)(52536014)(8936002)(5660300002)(7406005)(7416002)(41300700001)(64756008)(66899015)(4326008)(66476007)(8676002)(66446008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j18vLpPqVBSe+/qxAIWKyRseRr/ZHW0bC1xHzSerUUj0rFoXbFn/lVCHvP3/?=
 =?us-ascii?Q?yXmC24UCscL9SsUszuATDJe+YzjXLy20ATnes2tk0HzZFm1Vwo+veBIwerht?=
 =?us-ascii?Q?hJ7Akiz2tKiqiIj++ymzpWvHlTaTvxef8SVPOkcZ14joVMkJdlNe3v8cmq+x?=
 =?us-ascii?Q?2TTLwz0XRXBYSeW1ZodkI4CfTlwskFT2hlS8vVQEt/OgM6DHmpenBkOYUEgA?=
 =?us-ascii?Q?vK3ZqTa5E/wBiMNuClgRmJLzl863ib3OzIG0+ZYTCuMD9hLgXCK6eJifIypJ?=
 =?us-ascii?Q?br8il1p3K19oXBnb74qBxexm0ixt3iLT9eSYDkPPAacJY5PNM0o+l51ehROn?=
 =?us-ascii?Q?NyvENBePGRtIzwO+Jpe5L4fHgxnQ1/E2pkKiDooj2ccf8U9OV39o2D4wDMzI?=
 =?us-ascii?Q?tzbUV4XZ+iG496Li0SiCsyS0t5iKO+Ug6dWB6PdZ1dKJrtCB4TxKNNcSRQsg?=
 =?us-ascii?Q?97AFYpnxOCwFK4y+8h9tJghdTF/fQNHqShYXMzZzEgukPBedbOb/WmdXPTJn?=
 =?us-ascii?Q?u3MkAVAxuiZFn4HENDG/aHUYWGZuq7lsPV77lO8zQ/DXZoDk7bmfCPvMQt6e?=
 =?us-ascii?Q?sW9PbhBKTKNwPBb2/InkYH0vzuHjNqkuOGh2Zmrc5BixNrxti/YD9Ork+Z91?=
 =?us-ascii?Q?1tkF2D06rIM8mrirolLsMNmhw0SWNFubPdGp1GxoVMU05ARSbnPUX0lcRYUX?=
 =?us-ascii?Q?HTyPcvZT2hEdYH6mK52hjppQVlpciRrqcKfP1b7YXgEuFJ4ydHOpHaOD6ZoP?=
 =?us-ascii?Q?Z29N6MwWp9SRCnaWVRPU/X/MKd0vgGWkPxGKYenWxvAFksRERfZ931EcCAiw?=
 =?us-ascii?Q?er+8YiQQ8SMvM7gR1lziT26x8OKQKgBU47U0BRZn9CQ6fBzYdiQyaQ9m0SUM?=
 =?us-ascii?Q?3Nwzl1J2cpNMgc8jZnov8jJCSa1jazFiLqpWMCVuZve8dYl0Dt/k7CD90hIh?=
 =?us-ascii?Q?Mz9NamAeNCxXXav7o8ZJY33D+0WP6oGXGaNHTzazyqzQc47K+2a5io8EWB2b?=
 =?us-ascii?Q?61N76bMFdeoHToo0tofODna4RGNDpUlKM/ykqy2LSorx6sjt+5uJbWJt6Yrx?=
 =?us-ascii?Q?yzgLrfWfZR82ScPnq0ehsUW2jPsC3wckSIRJtTQ0RHyq/hQTDmmLEDSohA+1?=
 =?us-ascii?Q?zqag+OVHctw1F7X/l7mNGSDXnG7qvpPiKIqmNZf5Czh5299kGo3eihe1CsN2?=
 =?us-ascii?Q?Iv4uZ/OGwIShNRgx6rfsDujiI2MVcfyKlOhAO6whUt2FOmD4V6c17McWE0Oa?=
 =?us-ascii?Q?aCRLHnSbZK+LXGO+rGIufet6lkLJeeEWhgRHzjWD4VyCGmMCLYQYaO69Ka+4?=
 =?us-ascii?Q?9P1H/lyJF5D+6qpz+KPtn3krjjRz+nvU+f1WGuLYsaF04dTZx5trK1du7MZ7?=
 =?us-ascii?Q?CaeceCqnoX9hrAb41+s7PxCuD6BhszYz0vkIAfZLmVRgqJVksdh1yJIaA9Sb?=
 =?us-ascii?Q?9sV2TsHot6bCH1owqRviABuHIrzxBkKtzSCBmZIiSGvyyyD9O+6tWXGyitW3?=
 =?us-ascii?Q?J6ZMWXmAsxCb2VySSPstvFkanbt4q5YP4tHnHA/UHwPvSnY/NzSNAFiEswM2?=
 =?us-ascii?Q?gcHi7BmH9NSHbg+NX7RTYWMGgU/wf/g8e+P9ku8piVF9Q/TcTY151mfgUdMW?=
 =?us-ascii?Q?og=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d43859-3b88-494d-706e-08dad2213f5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 15:49:06.4744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: do0o844QRueXe4JJgsmRyJM35yDAMaBN1UvXTrJYU0fpA7mOdJXX/hI4XHDKAa5QoMbI/JxMsTq10wuRoAY4A9GZYNg8T4mFo1vBC/RnapU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3403
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Tuesday, November 29, 2022 12:41=
 AM
>=20
> On Tue, Nov 29, 2022 at 01:15:39AM +0000, Michael Kelley (LINUX) wrote:
> > So that's why I'm suggesting CC_VENDOR_AMD_VTOM.
>=20
> There's no CC_VENDOR_AMD_VTOM. How many times do I need to explain this?!
> CC_VENDOR is well the CC vendor - not some special case.

Let's back up half a step.  We have CC_VENDOR_INTEL and
CC_VENDOR_AMD because that's a convenient way to identify
two fairly different schemes for doing guest encryption.  The
schemes have some things in common, but the details are pretty
different.  Tagging the schemes based on the vendor makes sense
because the schemes were independently developed by each
processor vendor.

But it turns out that AMD really has two fairly different schemes:
the C-bit scheme and the vTOM scheme.  The details of these
two AMD schemes are pretty different.  vTOM is *not* just a minor
option on the C-bit scheme.  It's an either/or -- a guest VM is either
doing the C-bit scheme or the vTOM scheme, not some combination.
Linux code in coco/core.c could choose to treat C-bit and vTOM as
two sub-schemes under CC_VENDOR_AMD, but that makes the
code a bit messy because we end up with "if" statements to figure
out whether to do things the C-bit way or the vTOM way.  The
difference in the C-bit way and the vTOM way is not Hyper-V
specific.  Any hypervisor running on an AMD processor can make
the same choice to offer C-bit VMs or vTOM VMs.

Or we could model the two AMD schemes as two different vendors,
which is what I'm suggesting.  Doing so recognizes that the two schemes
are fairly disjoint, and it makes the code cleaner.

Tom Lendacky -- any thoughts on this question from AMD's
standpoint?  =20

>=20
> IOW, the goal here is for generic SNP functionality to be the same for
> *all* SNP guests. We won't do the AMD's version of vTOM enablement,
> Hyper-V's version of vTOM enablement and so on. It must be a single
> vTOM feature which works on *all* hypervisors as vTOM is a generic SNP
> feature - not Hyper-V feature.

Yes, there's only one version of vTOM enablement -- the AMD version.

But the broader AMD SNP functionality is bifurcated:  there's the
C-bit scheme and the vTOM scheme.  The question is how Linux code
should model those two different schemes.  I'm suggesting that things
are cleaner conceptually and in the code if we model the two different
AMD schemes as two different vendors.

Michael

>=20
> > Of course, when you go from N=3D1 hypervisors (i.e., KVM) to N=3D2 (KVM
> > and Hyper-V, you find some places where incorrect assumptions were
> > made or some generalizations are needed. Dexuan Cui's patch set for
> > TDX support is fixing those places that he has encountered. But with
> > those fixes, the TDX support will JustWork(tm) for Linux guests on
> > Hyper-V.
>=20
> That sounds like the right direction to take.
>=20
> > I haven't gone deeply into the situation with AMD C-bit support on
> > Hyper-V. Tianyu Lan's set of patches for that support is a bit bigger,
> > and I'm planning to look closely to understand whether it's also just
> > fixing incorrect assumptions and such, or whether they really are
> > some differences with Hyper-V. If there are differences, I want to
> > understand why.
>=20
> You and me too. So I guess we should look at Tianyu's set first.
>=20
