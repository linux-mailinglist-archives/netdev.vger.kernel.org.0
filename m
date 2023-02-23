Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C666A11C7
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 22:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjBWVQA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Feb 2023 16:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBWVP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 16:15:59 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021024.outbound.protection.outlook.com [52.101.57.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4FD227B7;
        Thu, 23 Feb 2023 13:15:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzrR64Il7nL7//ADrAtTARdLRhcEiw9g5L+KS/sEPDtgn+9u1gMoSBFP2e4MMpE2zbJFy/HAiitM9KcKoKH2tNVzEJBN16tXUgtXTsjRpITuLskQBubrpOFKIR7+bhMwfHVe9KaTW9a4rRjpxd7hwBGg6TdXTa52iv+z2zjLN3uHlJXRQg4v5pZC6KZAahUmwZhVR0u46I/a00Y/CBIC6IYQJBizIVjmgYTqCSVz+6+nCt/3vrCThELP7zvgZ4BVKPy8xMLQwq4FHglWFytH3ZTcliKHaOI3zC/Vwy8p5OHwFe4OpXaDOxhwLBmTZEJefK19ZL0yL7Rwtfp1H5QBbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaZwr/sJn0XSdmExK3isHEe7tbv0uUPDIhq1GK0VGsE=;
 b=ith1TKILzOpEbl0m/LYu8baVgVAE7Ax38jMbAYjCrr/8QKyVDvzbQjjLK/gnF3NkFF8087fMZTgc956gq6WubMTnML/LCQowZ+e3/loHmHyozkrO7QXIzc/7GBmudrdUrlJQuhbIIDtxwaW78gqmeTuLYveXz+btv7itCjsMB2kErO8s39+UCSDn1cuK5VRDnavtghd5mczUDzy08/rW2WyiLb42xOrNfrXmu1fa8XaOYZC+rR06vXDXdXz3jdN2VfjdGcyEJQVUrusWHCgTa4XqIwtM/UXhY4c6gPAz0VYRL2Q3aj0HpRF7YuEf/+M+RH/DK57ppOxQJZx3KixNNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DS7PR21MB3431.namprd21.prod.outlook.com (2603:10b6:8:90::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.10; Thu, 23 Feb
 2023 21:15:54 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a%5]) with mapi id 15.20.6156.005; Thu, 23 Feb 2023
 21:15:54 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Dave Hansen <dave.hansen@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
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
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAeE2AIABk95AgAGmoACAAAYigIAAAicAgAAHCQCAAAYXAIAADqWAgAAB8ICAAAP2cIAAK2uAgBQ2PACAAAQygIAAAMUwgAAGfYCAAAFlIA==
Date:   Thu, 23 Feb 2023 21:15:54 +0000
Message-ID: <BYAPR21MB1688452212CF8E1B97D8826DD7AB9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <BYAPR21MB16882083E84F20B906E2C847D7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aczIbbQm/ZNunZ@zn.tnic> <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
 <Y+auMQ88In7NEc30@google.com> <Y+av0SVUHBLCVdWE@google.com>
 <BYAPR21MB168864EF662ABC67B19654CCD7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+bXjxUtSf71E5SS@google.com>
 <e15a1d20-5014-d704-d747-01069b5f4c88@intel.com>
 <e517d9dd-c1a2-92f6-6b4b-c77d9ea47546@intel.com>
 <BYAPR21MB168836495869ABB4E3D61D61D7AB9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y/fVoc4C5BNI+i7l@google.com>
In-Reply-To: <Y/fVoc4C5BNI+i7l@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d7a4ac8b-aa0d-4ab2-96b4-9526de0ce7e9;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-23T21:12:44Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DS7PR21MB3431:EE_
x-ms-office365-filtering-correlation-id: 9d604ad3-61a3-46f4-c87b-08db15e3260c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6+96bSTZk1ooZcq910Rg+b2hZ6HkfORvaUgpgEQTNK3UucO2SnVzZhXLBelKJyKXnorLFimWNXaT/FhMVJ32keoSpb+BM/E4PVQ3UrwlDQ+SLXP4/X/s3T63M4Lzq7GV3GbwScP8ZE8nPxAZzz4oKGi8vwRXFhUYpOrB027U+UINgKVwhYQy1o2po/QEgrCdDmxHfJ+YilEMvaZpj1ITOfUgBi06HztXUAoLbSDOnqHbtvamccdr8e/oWcMvAx/K8T5jCHEvgZnnZJEeFjupEXZCT9M5fSMUw3+g15B9HAVgz9aRuriBUpUd0u5NyuXNVODhdMDe+mps7EjkVexWRrlIYwY+n3GPy8TVgPVkXLBBNbu5Ruc24ppExc/8msqpJBQ+U0vdcnOuYgHnfDEY9ZqnViGe6wOMMxcaY00JA4hQGmT72pDaM6KG7L35pnqINTDhr/8YrvX2qlkv99600QAOB+ig+6YocUgr6GpCq/vaHyB25s7xfV9dYImY1N/jpvaxVCTGnRMOyfxb2bO47JEl8nNemdXO6F18MqBKjhavK/skBsqPQN68TKUbGib8FnmQLUtDQcmjKY2ey1GSnG++oVnLOZeVDZ3izpYL7rhM4CR8qwB4jOtaZnJw4apFBZh/vu4sekEZiVkAqBqjnUKLOlK1sIViaofL6+m8NTvEkodEE/ov7nGehK7W2CikRO+bXiDCyrBDrdPkdDi/6dbCYhZij7cEq3O9xY1tf94iwpgoW9D1Z8LHLHbWGEB9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(346002)(396003)(376002)(451199018)(2906002)(38070700005)(7406005)(7416002)(8936002)(8990500004)(86362001)(33656002)(54906003)(5660300002)(52536014)(41300700001)(316002)(82960400001)(38100700002)(82950400001)(122000001)(10290500003)(478600001)(55016003)(71200400001)(53546011)(66476007)(66556008)(64756008)(76116006)(6916009)(66446008)(66946007)(8676002)(4326008)(26005)(9686003)(186003)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SIeRg0/fqo1mZH5sPa3e89Wm01IkSeXD4RC0c7dJuY7aQDUnhJDU5ibMdxHK?=
 =?us-ascii?Q?PFOC8aGUF1wPEc4ayXL/CB5irt9uQgSh/f233ZK81TKbHNr9H62dC9LNKkbJ?=
 =?us-ascii?Q?jrvJNihuE6OUDes/7R8OeqKzSjJzs2PyFDFOaECQtoMLNoOYVQwIo0RAZvhm?=
 =?us-ascii?Q?ibSrp7DYwhkZ3YAi7ESliv0cUcXRvgv9iwpAJFbn76tsvesZUpHntVeRLG33?=
 =?us-ascii?Q?0wXUQQTlvJ9HJ/LUxIeP9JqejJ+y3LRMUlWN7duEbicOEM2mJI9/hgNB3Pmb?=
 =?us-ascii?Q?o/SwD2F8Shc2lU8JE1xURic4gJFO0sLB6FmHy0JOCE4z4JlLa2ZQ88cWgUts?=
 =?us-ascii?Q?vet7s69qr679Vpxxa0s9VqVhklMRTpy4d7o2yQrZfc/mKbfuD5Ip47f2bptQ?=
 =?us-ascii?Q?tRFdF8t6Weq12Qeq8c7bk9KjSbdt7ZqZgkRysAnsiNEaw8jsmKSy6hN0hI13?=
 =?us-ascii?Q?xvRV5/jsZdORYfQMgWyEgh1EGryyCTgzlmYUPjjz6Dv7XMpIJMxIAtanz1NW?=
 =?us-ascii?Q?i1H3/qcG53smzkImYsGs4+lcMpagu9g7KWWPGNB59vfySQwYXFrjEJ0Gc65E?=
 =?us-ascii?Q?+UAZuq3mj8yxkQ6s/YEQTyYKvPMBNYKssugFEs0txRsEdmQlldD4/A9jG99K?=
 =?us-ascii?Q?CgzjEHhtv7Ry7umoGQiL+FozGUamXGAa0/4o2BhE2uz7nsDLeKoH3dKnrGhC?=
 =?us-ascii?Q?M9JnA2jEH6WC2lLbGOad76712MlvQPDjVzm0UvIgfKXhPWURU4rbRZTLSIWO?=
 =?us-ascii?Q?/xV7z7ytphfdUemQRBP5b/FZOgiKWZdkEOFVaQGiLcXMGP8fTWAC93Gf56Jt?=
 =?us-ascii?Q?bcFC7+3etCe89GcmU6XDq1xbJ3fGaY7W/tNvIybf5BiaY37ya+CyOVleOy3I?=
 =?us-ascii?Q?2gO8THxxAHjW/mG61IywwJHgakjkpHBXJ9Y+wG0iuk7MvI3BAyGgQ7TifHOO?=
 =?us-ascii?Q?UyaCS6+EMRXGWPIZ81gkFkUhPv0NoqlBkm38lRceo0OePG14oNRiG19ybqB1?=
 =?us-ascii?Q?6EdxVILhDgH6e6JNqB9Y5oSB8SKUpX6xxhS51nP7iSsVH08dUD+n8Pvh+5BP?=
 =?us-ascii?Q?NLfRW+MwB8wP5U2bpBRffhRREve46mc++o5wr2G1ktgfq7ZutbXBKd8hjdc/?=
 =?us-ascii?Q?xmGVTvuYrjdlmskjY1SNCi4zow5pLXnFE7r+NANL6blX5KFSKdy0H/toUPxq?=
 =?us-ascii?Q?T8t8MMlTvBa5O0TlIrYzaVteZLntom4DFQ5ypkpylRHzc0PlmFuS8ScRd8tm?=
 =?us-ascii?Q?g4/wsRKPGwtjYArUNfVEuFPHhT3Fs5tGL4VGP1nh2qFzUxR7ju4+5bJ5wkcM?=
 =?us-ascii?Q?rZ4gX/KDrc2KlkyG19I/UW1TA+jh1xetFnSTDYLYHbbCbPvno42GsLjBQI8n?=
 =?us-ascii?Q?JTbJB8gi6YBV2YOkQOO7mNqJdqYZOuSMzE4KWlLPY6/kHfL5aizQDVMBaKyn?=
 =?us-ascii?Q?GUID+kiWQutGRKTrl97Ezlr2Cq04ydly/MD7OEpLwYtL2LoxNic1RK4h021j?=
 =?us-ascii?Q?bAxYA/GMo9CCMcZLXjQarIoZ/oaMEYpYUDs24jX4SutUIPFDRJClAYfWRuXY?=
 =?us-ascii?Q?Tk74JJCVGXZ3Ydm9U+IwyzOy4ET8oRwHkN3kaGrxys31mOo5ceavMyZnFk1+?=
 =?us-ascii?Q?+w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d604ad3-61a3-46f4-c87b-08db15e3260c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 21:15:54.2551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z2Zd9UNzI3Iuru3opSo3Q4d8cgg+qoWpFHhn7ZJ/u2xnsOlAiFh6b0O85yo+w2MP3/4ZctH8b8FJ+6yT5NXcx3zsb63mwSc/PXZdlRMtodk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3431
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Christopherson <seanjc@google.com> Sent: Thursday, February 23, 2023 1:08 PM
> 
> On Thu, Feb 23, 2023, Michael Kelley (LINUX) wrote:
> > From: Dave Hansen <dave.hansen@intel.com> Sent: Thursday, February 23, 2023
> 12:42 PM
> > >
> > > On 2/23/23 12:26, Dave Hansen wrote:
> > > >> +       if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
> > > >> +               /*
> > > >> +               * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
> > > >> +               * bits, just like normal ioremap():
> > > >> +               */
> > > >> +               if (x86_platform.hyper.is_private_mmio(phys))
> > > >> +                       flags = pgprot_encrypted(flags);
> > > >> +               else
> > > >> +                       flags = pgprot_decrypted(flags);
> > > >> +       }
> > > ...
> > > > It does seem a bit odd that there's a new CC_ATTR_GUEST_MEM_ENCRYPT
> > > > check wrapping this whole thing.  I guess the trip through
> > > > pgprot_decrypted() is harmless on normal platforms, though.
> > >
> > > Yeah, that's _really_ odd.  Sean, were you trying to optimize away the
> > > indirect call or something?
> 
> No, my thought was simply to require platforms that support GUEST_MEM_ENCRYPT
> to
> implement x86_platform.hyper.is_private_mmio, e.g. to avoid having to check if
> is_private_mmio is NULL, to explicit document that non-Hyper-V encrypted guests
> don't (yet) support private MMIO, and to add a bit of documentation around the
> {de,en}crypted logic.
> 
> > > I would just expect the Hyper-V/vTOM code to leave
> > > x86_platform.hyper.is_private_mmio alone unless it *knows* the platform has
> > > private MMIO *and* CC_ATTR_GUEST_MEM_ENCRYPT.
> >
> > Agreed.
> >
> > >
> > > Is there ever a case where CC_ATTR_GUEST_MEM_ENCRYPT==0 and he
> > > Hyper-V/vTOM code would need to set x86_platform.hyper.is_private_mmio?
> >
> > There's no such case.
> >
> > I agree that gating with CC_ATTR_GUEST_MEM_ENCRYPT isn't really necessary.
> > Current upstream code always does the pgprot_decrypted(), and as you said,
> > that's a no-op on platforms with no memory encryption.
> 
> Right, but since is_private_mmio can be NULL, unless I'm missing something we'll
> need an extra check no matter what, i.e. the alternative would be
> 
> 	if (x86_platform.hyper.is_private_mmio &&
> 	    x86_platform.hyper.is_private_mmio(phys))
> 		flags = pgprot_encrypted(flags);
> 	else
> 		flags = pgprot_decrypted(flags);
> 
> I have no objection to that approach.  It does have the advantage of not needing
> an indirect call for encrypted guests that don't support private MMIO, though
> I can't imagine this code is performance sensitive.

Or statically set a default stub function for is_private_mmio() that returns "false".
Then there's no need to check for NULL, and only platforms that want to use it
have to code anything.  Several other entries in x86_platform have such defaults.

Michael
