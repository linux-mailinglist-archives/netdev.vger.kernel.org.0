Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263A36C897E
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 01:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjCYAEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 20:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCYAEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 20:04:41 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021017.outbound.protection.outlook.com [52.101.62.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2061715A;
        Fri, 24 Mar 2023 17:04:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6FPTq15irbtAb7JNecQtZGazpDMMBBa+sXhS4S7ApJ6mRz7FA62I5hsjP3CjOcEv35gDPv3EjW5lgdksu7QGJvqjumGMgKSJv0wu4pdLnb1xbXH6vCRoyZiL152EU8W6KXAv7oiEKON4y7XACpcc83ItZx8E8aaglAoW8YBKLgByNoFwJsiO6Ba2zxE2QPJNVpSuXam43oc0HB+Yx5lq/RCQJf54IY6GeHNmzS8T8TAbQQukH5bi6SLsCM6tMlyR7Nxk27qBecBWn5G+NQiN7GJlHVW6e1iBisgSmFWVLidSs2XuNDpFcAhu/AN4eRsjTHc3CMdyZq+S0LaKraWdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jfci8pp1Hfgw5vSwglBoG0x2UKZCerRWF6iM0BjwaLk=;
 b=OfbphJr/u39egSYHlRw3iiiRB4xs8fy75ZgUPLETUUZX5+Qeg810s5O4L6owwM+jq6n9UElh+1vaJZVScGCBtukOo3cLbe0IcBntFdugkSQVz9qLwGPh1LVlmW0N/3rXuSvQXWrrUheE1SGHdKSc4HXojuuLD/U3dxy4MZycmFOiFdTf/8XmJn0pXzknUGCox6VZeeSuiBGf5Kv1zr21HX3yWk3O2ooglN2e4Fwoadrlr2T+qG6K0hqjk8v/wiogRG6OCflRyyarZJt/ijlqD2UE0jJtco3r6mo5A1aA0aD95pESyY3cvSdXkdVQLPMavLcClLjWrwhBWeItBGB1gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfci8pp1Hfgw5vSwglBoG0x2UKZCerRWF6iM0BjwaLk=;
 b=a1WzO8JD5kdo+tXXk6kI2obA6xaz69gc6982cLvKhITguWpBjX/ASvT6ux7vvo/P1RINzk9/BQAu8k1VQrKxxPbeaROA28Kq2zHJe38LBM+mc3GVpz4XycLXvcjKXfN58TGY4ifWnzkvGOu4mPdqZl5PCH9TwotetNnmk0W6NSQ=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by CH2PR21MB1384.namprd21.prod.outlook.com (2603:10b6:610:8c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.9; Sat, 25 Mar
 2023 00:04:30 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6254.007; Sat, 25 Mar 2023
 00:04:29 +0000
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
Thread-Index: AQHZUjCyCpporLk3zkiXtyclH/4N+K8DmEQAgAAZtaCAAFnoAIAAAQEAgARphwCAAbV9AIAANy4ggABRbhA=
Date:   Sat, 25 Mar 2023 00:04:28 +0000
Message-ID: <BYAPR21MB1688B457CDC6B6B405FDD099D7859@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
 <1678329614-3482-7-git-send-email-mikelley@microsoft.com>
 <20230320112258.GCZBhCEpNAIk0rUDnx@fat_crate.local>
 <BYAPR21MB16880C855EDB5AD3AECA473DD7809@BYAPR21MB1688.namprd21.prod.outlook.com>
 <20230320181646.GAZBijDiAckZ9WOmhU@fat_crate.local>
 <BYAPR21MB1688DF161ACE142DEA721DA1D7809@BYAPR21MB1688.namprd21.prod.outlook.com>
 <20230323134306.GEZBxXahNkFIx1vyzN@fat_crate.local>
 <20230324154856.GDZB3GaHG/3L0Q1x47@fat_crate.local>
 <BYAPR21MB16886692DF02269DE1D0C4A5D7849@BYAPR21MB1688.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB16886692DF02269DE1D0C4A5D7849@BYAPR21MB1688.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ef61c53a-5ae8-40e5-8d3f-b3f53d1eeaa2;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-24T19:06:25Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|CH2PR21MB1384:EE_
x-ms-office365-filtering-correlation-id: 3134f1fd-28aa-419e-3a31-08db2cc480cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yWBcxYXukNqBEvyrtJyG1npqtwOZdfdrQLJgQs43Kxf5eXDZ01fGLsH89h5yPdrBefvFkT+UzkENJpE0MgZuGaKtJNi6DB3iiYDTNvTCQI0BG7dfb5y7g/XBp4hM/1uTQU2QIAhoMZPD1qc/bgG9A1D755lW0hb7Fkh2ttMLojYx7BAPCU5I5rWuPJm39JyO3XkGBgVV7dZVx8DzX1ngsuLpKtTdHmjnEczZc65Pqr2S5X1w1s40hE8gD+mnmwPzvhTMRctEavSZjRR0FGDd25TQ2/OBlY/iwsn3zeKtDcfy7XP0wwnv7ZardNg+WBuAOaCwbX0GvvQq5W8sHu/hLdYnkvS7SiZmRxGSjNFyf9l980uTuuSsEMRYzekwsu0NXMQEnfVzyn61uyZRk65rzvk0Ld8yKYoCQZcCl/U2LoBgsHFJ85u1noDzhEuaD4N+y6oJbktEC6BGYQoBWkNW508TxQ8mcLuS69JZUTtLzBM4H9xB0KDqEIo8Rq4TXHB5zD2soM8t6RiSTZwxY54yCuQ7tx7oZwkXrZYVuKtmdW4VkT3YiOre1q5GHXQyXe9h0QQfk+6OmMoYFWFbqH8CkjSScpLg8nguqlH5slO+GS15DzzS6g/+n9Y4OTxsVCSh0gR6q/rrdNnIjh00hIN1aENaO54WFokY6LDGSoToeU4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199021)(66476007)(33656002)(8676002)(66946007)(4326008)(41300700001)(86362001)(186003)(5660300002)(76116006)(8936002)(26005)(122000001)(10290500003)(6506007)(38070700005)(9686003)(55016003)(316002)(110136005)(2906002)(8990500004)(66446008)(38100700002)(52536014)(83380400001)(71200400001)(7416002)(7406005)(7696005)(82950400001)(478600001)(64756008)(66556008)(54906003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wg+4rG8Ll2rSY+wtqnYg9hiou8jpSMhSBHffsUJPKpSRpRhl2FY0uYbBww7s?=
 =?us-ascii?Q?u5v+kE42qTdTTsxXbK6kQ+xTDiAOAf2CkNAQgZ6qw5zk/5NEf9vhwnSqzV/1?=
 =?us-ascii?Q?1CVLOqXKCiOSRSlSI/xnfvmE6jzQhK5UwubRUiy5RFiLLPo1kJ9Tby0CmXG/?=
 =?us-ascii?Q?BD0hZKGtSrqeRvyIDMnODZSTyvzDgBY+EQUI4Wlp1I5jMiShHVN19EoPtH7W?=
 =?us-ascii?Q?q/SZJ+uaKO5VWXlKRww8/NKxICLbrOEj31/lJUBKYDNr4lcedowO4iTEOQsg?=
 =?us-ascii?Q?z3pWXUkrvOqxBeyPf+Lnbhb/ncGl+f9B/bO6XDdn7juWizEaDYvlmFzQ8kYz?=
 =?us-ascii?Q?xR4EdeJXQLTDG7aodM6Zz3UHvJjKswTtn9NmCzXLzf8/qes/cPx0r8TVnBId?=
 =?us-ascii?Q?tq4tRYpOQowhZOlJIhUBcrEBQ/TXm+swR/eCZPH43j/ApjWvqbL2WXfZAwuo?=
 =?us-ascii?Q?jNfiOpvgR868gcmLhHjrDrpM3hTjeiyxHysUZ2d1cs+0Hdre+le/LDTNsj3p?=
 =?us-ascii?Q?cEudHUXODt82hndcubl4SAcfQrvQGz2fRZnzxfKz0kBVwDvV72aiTuaquJTd?=
 =?us-ascii?Q?v2iPbm/TCRGgHMrOnx2AlN/gJ90V/MyiklBvz4GxepB6rbdTT43uXf7yqtEG?=
 =?us-ascii?Q?Yg4F2JQ+bUyuuGHWFQLzzSzazE+gSv6PG5OZJss3CeEu8riAjVw4kTSfdSBc?=
 =?us-ascii?Q?ThUAAziCoh+CQJMaDAMImfX/3bl5qMeUBwZxtPek2fH/INJJ3QaMmsbygPaw?=
 =?us-ascii?Q?i8S81+WOfCgPJVsonYDhDbCIdZ+w1shbOzbonyEb/FmFPOIhu958KROnLyki?=
 =?us-ascii?Q?dSsukNEEhBkWypLuvn73EFs4eqIFbWNsADdA5Ka3j+azR/gEIPRBJbiwUBSa?=
 =?us-ascii?Q?59c6YBQLkHKnB7pXBfpAYR+1uYbeIr74/s4+n5qmqhiJvd6KF1Jpgd0F00Yn?=
 =?us-ascii?Q?v8/pfo5V+Cf0lpCdvLR0UcmgBvl/NuCwCioMkHsfR1uGmDZiZ019JWE9Aa+t?=
 =?us-ascii?Q?p77p1QlzoGtAbwP3jm0Ou4HNGu+0C/b98mpjUUD69/bWP7dHYe+MeZNeH5cM?=
 =?us-ascii?Q?Xt/yjU8przdJoLsViTF1eB6M5FpHlnKLIdH6idIRbrzrh2aufEM1uKN23aaH?=
 =?us-ascii?Q?ePuxYHzybYcZ0/Gx0oXsK95Vfv1L4lDBF29LbzLoL4wsl46KPpb8dHZ6MPkl?=
 =?us-ascii?Q?ciHbY0k0vsvSDutwdFd7Ojb7qmWxQnHdWeuYOCiYGoEYxb9ra9N2/WW5nt0v?=
 =?us-ascii?Q?6Qq0WbvazuRdlbM2eQEY4BIg20DAQys1FAf+R/pobhGZWY/z5YtvA8Ogz419?=
 =?us-ascii?Q?5aqmJNKrIMCA6XlvvNmT9EiQc8h5bpW+Lk6TrK1qZcz+QEvp6rgkVl3GSp2O?=
 =?us-ascii?Q?ysPvB+Nt9K3jHIpurS+aCvxRSbESDybmzAj3NRnjwLiICpcwXVuRzcxngtZG?=
 =?us-ascii?Q?oh9ku/2QCVc3999LC6DBG0x8/YuCftKwMjVX8HCPBankvFhrpP28RYsAsrXr?=
 =?us-ascii?Q?HhW8fbwB9rk3SwPIhUGP9ekiCF/Nc/WXMZPvp4Lz+RLe5frMrngJAm/RRQrq?=
 =?us-ascii?Q?Kuw6xR7azwbKDHP1vVOIV3ou/lcz2U6QP/DZpfpO2eulXq92nCAcj2notbsP?=
 =?us-ascii?Q?tA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3134f1fd-28aa-419e-3a31-08db2cc480cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2023 00:04:28.8882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b3Az3CjHWBHegYBzPSsXbm1Pq+8/GTPhEmiKj2dTnXaSsik2NVfWpIAj3Xek5G9KiWjOWY+4GmdbFEg73GV1NVDZ99g8KCs21/YDsxYaX/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1384
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Kelley (LINUX) <mikelley@microsoft.com>
>=20
> From: Borislav Petkov <bp@alien8.de> Sent: Friday, March 24, 2023 8:49 AM
> >
> > On Thu, Mar 23, 2023 at 02:43:06PM +0100, Borislav Petkov wrote:
> > > Ok, lemme queue 1-2,4-6 as previously mentioned.
> >
> > With first six applied:
> >
> > arch/x86/coco/core.c:123:7: error: use of undeclared identifier 'sev_st=
atus'
> >                 if (sev_status & MSR_AMD64_SNP_VTOM)
> >                     ^
> > arch/x86/coco/core.c:139:7: error: use of undeclared identifier 'sev_st=
atus'
> >                 if (sev_status & MSR_AMD64_SNP_VTOM)
> >                     ^
> > 2 errors generated.
> > make[3]: *** [scripts/Makefile.build:252: arch/x86/coco/core.o] Error 1
> > make[2]: *** [scripts/Makefile.build:494: arch/x86/coco] Error 2
> > make[1]: *** [scripts/Makefile.build:494: arch/x86] Error 2
> > make[1]: *** Waiting for unfinished jobs....
> > make: *** [Makefile:2025: .] Error 2
> >
> > compiler is:
> >
> > Debian clang version 14.0.6-2
> > Target: x86_64-pc-linux-gnu
> > Thread model: posix
> > InstalledDir: /usr/bin
> >
> > .config is attached.
> >
>=20
> OK, I see what went wrong.  I had tested with CONFIG_AMD_MEM_ENCRYPT=3Dn
> and didn't see any compile problems.  It turns out in my test, arch/x86/c=
oco/core.c
> wasn't built at all because I did not also have TDX configured, so I didn=
't see
> any errors.  But with CONFIG_INTEL_TDX_GUEST=3Dy, coco/core.c gets built,=
 and
> the error with undefined sev_status pops out.
>=20
> The straightforward fix is somewhat ugly.  That's to put #ifdef
> CONFIG_AMD_MEM_ENCRYPT around the entire CC_VENDOR_AMD
> case in cc_mkenc() and in cc_mkdec().  Or put it just around the test of
> sev_status.
>=20
> Perhaps a cleaner way would be to have a "vendor_subtype" variable
> declared in arch/x86/coco/core.c and tested instead of sev_status.
> That subtype variable would be set from hv_vtom_init(), maybe via
> a separate accessor function.  But didn't I recently see a patch that
> makes the existing "vendor" variable no longer static?   In that case
> just setting vendor_subtype without the accessor function may be
> OK.
>=20
> What's your preference Boris?  I can spin a v7 of the patch series
> that fixes this, and that squashes the last two patches of the series
> per Lorenz Pieralisi's comments.
>=20

Actually, a pretty clean approach is to #define sev_status 0ULL in
the #else /* !CONFIG_AMD_MEM_ENCRYPT */ half of
arch/x86/include/asm/mem_encrypt.h.   That's where the existing
extern statement is, and  sme_me_mask is already handled that way.

I'll respin the patch set with that approach.

Michael
