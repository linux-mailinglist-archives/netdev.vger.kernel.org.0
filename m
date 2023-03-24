Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DF86C8607
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjCXTgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCXTgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:36:10 -0400
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020024.outbound.protection.outlook.com [52.101.56.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F13A113DD;
        Fri, 24 Mar 2023 12:36:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b01eemSnzmLWThId8/8MrFQZ4iXN5mdTHMWt0LmOD1Dz/zebQkCXvT4ep8p++WRrtfMKDKqNLmicAzMv1qGqxdNJzoY4GLI8IcTJfrt/0P9KEPCHOg1TKks3FFQuMrvLsp2mGJWi9BuUS+CuEKcLw6uMFL6skUz2UVO0hAkoHU5zj3dZhFiXSRFOisJ2LrH3CLMQslLd+cauBLsphVGtkmyEwQttARixjbdU/gjsjmERHL8XHvQV0/KlWFT6W0p13KYhRO8u4GA01Z5vDHXMd4+1TooxZ5m411+8lmeBhnPQXMw7r77fCHgjGTfevTYRIA0+T+As6BKpgGLVpJh3xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDGktV/ukM4Jriu1Ok/G7+JogUFeDYEDG5cKFavPA2U=;
 b=gTkZsDnh4Gh1EArkgLxikRjwg+kQLX1y6LcPRQERangG9qcK5cdD3tnmn6KvYUJRkA3MBAZ/xPvb2uVAIz8WyccKaBh5oxLZ9s0F2ZvEWzppauCpXIz+Nlgd3JL9MrRCxvVm9cQOejsC2sSPwiTHUgDs4YshTtyV4YaZ3gcE7ljiipc8n+JFpHpfAjw8FabAERzePP2Akt1Yd8TOOKTWixrse8f9ONubIn27ESwik4q1CsfrBHGn/K+/UZZAwCDSDYg4SZKiwzK8NCvEhXi+S1/+xcD3x8YdyBi5BSQL+a07LxtNLEkpvjMrVb/06ZyYDeBIZpKUXi7SMXzekL3tnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDGktV/ukM4Jriu1Ok/G7+JogUFeDYEDG5cKFavPA2U=;
 b=alNd8iNwPbZTLoA1lTztBM4l2WXoQpEVLmKU5LpzmRt03jM0rIOGf6H5eXEEqbEYnrewJvfVBx4cBHx27jyug43cyXXmtReRfptVtVZdVgo3/Xa070oAAmfi+wUEOPbaT1U80qzkn7dLrU879DAqReI9alRVE7USau7rdCSke6g=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by PH0PR21MB1878.namprd21.prod.outlook.com (2603:10b6:510:15::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.9; Fri, 24 Mar
 2023 19:36:03 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6254.007; Fri, 24 Mar 2023
 19:36:03 +0000
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
Thread-Index: AQHZUjCyCpporLk3zkiXtyclH/4N+K8DmEQAgAAZtaCAAFnoAIAAAQEAgARphwCAAbV9AIAANy4g
Date:   Fri, 24 Mar 2023 19:36:02 +0000
Message-ID: <BYAPR21MB16886692DF02269DE1D0C4A5D7849@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
 <1678329614-3482-7-git-send-email-mikelley@microsoft.com>
 <20230320112258.GCZBhCEpNAIk0rUDnx@fat_crate.local>
 <BYAPR21MB16880C855EDB5AD3AECA473DD7809@BYAPR21MB1688.namprd21.prod.outlook.com>
 <20230320181646.GAZBijDiAckZ9WOmhU@fat_crate.local>
 <BYAPR21MB1688DF161ACE142DEA721DA1D7809@BYAPR21MB1688.namprd21.prod.outlook.com>
 <20230323134306.GEZBxXahNkFIx1vyzN@fat_crate.local>
 <20230324154856.GDZB3GaHG/3L0Q1x47@fat_crate.local>
In-Reply-To: <20230324154856.GDZB3GaHG/3L0Q1x47@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ef61c53a-5ae8-40e5-8d3f-b3f53d1eeaa2;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-24T19:06:25Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|PH0PR21MB1878:EE_
x-ms-office365-filtering-correlation-id: caab2737-0fc3-4157-0007-08db2c9f00f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3dsdnjaYP0NdDzIs2fEif3GCLIB+pJsU1qjtLJpJedity07loCmrTA63Hf7dgUv87ZJbZF4LJjz9JxZKYf75AvqYR1iwIUzJFNqlhx32VzU/GwuGIUZ/5uXLOts9f4HakdiIgdSq45lUWKMyEhvtxKa2kY/J63zYlCUrgJj42pI7vdk9SM0ED4JbC3xvieuLxjZiShVnehdzTFAUy30fMaH73ocg+8PfrsSoYUHkUfsm+e732h/0xYGo3Qp1EKvXklbiu5DQWn2OqVjD09Ui3nr5EO95eAAesgRZiQHOJ1nz4IE0FiIYgT+VzKKiyRtH4rnAxG6mH94zeEj9Cee7YNGDmRtXWMe/ylR10iOr8b2mZFnzvuaoO5eSfxqbvBe9DBonf7Aspdp+Pa7Y+UOElPpnGn+QKj29cmeaacrjAQ8p39+NkvuV6PZ1M4wka/ZoczjKcJhkcwiMUZOZuBz5e/E21PRkKxtjFQK5i148RLIWkuHb/1C7hsbiY4MxL3RJPEZ6iVpn6GHznOGjYj5EqoApqX/TON+ZH3LUnPFOEBZb6PvEk9Ei5c7H1KyrM3sKmeMLEzy0NB4BeD6cjZHIs9IntgUZEwJNFVBjtlpzFRACAnolus21k2y80U7Cj9uf1sar7PD/u9Rektb0EnJuPN/g0iwetftqBLE7NZ2U2YU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199021)(54906003)(66556008)(41300700001)(316002)(66446008)(478600001)(83380400001)(5660300002)(52536014)(71200400001)(8936002)(64756008)(38070700005)(8676002)(76116006)(6506007)(186003)(9686003)(26005)(66946007)(66476007)(4326008)(6916009)(86362001)(2906002)(8990500004)(33656002)(10290500003)(55016003)(122000001)(82950400001)(82960400001)(7416002)(7406005)(38100700002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Kll+VudfSD9o7VSlutyQlAJHSrBBd+EuZ2lcTraDCCWR4MjGPgFDVDu1xK0f?=
 =?us-ascii?Q?WRNO7GzT4Vy3udY0fFwIGmsfalNfg+ZUY5+Ji2EI0zP/bVKNC9uHNJhsQ0DS?=
 =?us-ascii?Q?C28yuM67+MtW619gmhkBM3FqWy3XIwLmBTAWO02/jluvj0+KHLJvXDRHmVxC?=
 =?us-ascii?Q?JtmLpgNzt1f87nItnOZkc1HgcsGofEEuyR19Mvf3MLZooeQo4pBIr6upDgfZ?=
 =?us-ascii?Q?Uuq90DCOpIT7yZgakXv6ab33TVr9cnS2FpQuYHcZ55MxXiqMnHcbDrUnWu7N?=
 =?us-ascii?Q?CAbPQWU7vbgk5LJiN6uZIWxCgef2zM35vNXIj9MNnINTK8B6jvl8aNFb0oSz?=
 =?us-ascii?Q?Vnngg4mxZSkC8/g47aWUfgM1PtFfFkCt9JotHrwk3ezvgYdgaGI6tHINa51C?=
 =?us-ascii?Q?r46tvpBgIwzvY8Pv/odYobaMv0FxpYl2KNcNhgBWSpWoI9VpWr4d+mE8oG0V?=
 =?us-ascii?Q?lRttxcntXoh5nltErbwQI7igSZcJRzGrULi+ZKsRyapJZb8UVq964qZQTekR?=
 =?us-ascii?Q?vBxRZ2yL0JP1GxSucSm2PX/OLWLwIpxbeiKKPU+2IVA1D/vsBgUaLIxpEQML?=
 =?us-ascii?Q?nLCqzAAVKHviT84CS7SsiHtQRA9IqzGAt1ii9GQxfLtB8FRlzFfN5fcwriD8?=
 =?us-ascii?Q?3kbf5OaKoUKGuCmcKLo4WR/jJyt3Mb+JYhCxlg/RGb9Kk+X3Xvon5aqBfBxL?=
 =?us-ascii?Q?s9xpx6xnv033IkVyVrwBPKlO5UIrRlUujzZtBDPrBaY+Dn0cgsdFPhEs+yXf?=
 =?us-ascii?Q?e4z1ocDG2Iqp7UOTH+jZZ58PMz1GSw0J4bWdPLpFHre7gApuqXb/Jnam99Ut?=
 =?us-ascii?Q?G5UIAJot7DvtFEisd5l8HBZRJ1HiCKHV+Qunfub4gn3GCtQXVMk10yM+kM3S?=
 =?us-ascii?Q?1+vpMV3fUHiTtvthD9p1SWbEuQSOjQ0lfYwq132BIh2idSDc43Qpkzd+d1IU?=
 =?us-ascii?Q?kBWT0/XN4Jo5lb53nKDmLk/EGiEps0y6njLS+YVnE8Z9XbjBCFscCCmUbhkA?=
 =?us-ascii?Q?/sl6acs1iih7nzC4xaTh0cqxsJnCKPMI5pkinZPFqH/X/tKjR1FpN1icFfPf?=
 =?us-ascii?Q?UGrY7PYsYf0aKtZSjZH0V/CBoGQBvZW4nLogubYxKKq3bTXOoKy3PfT5uVdt?=
 =?us-ascii?Q?dnZ7WvYKJvpiN4SBnIUjRFVmc5LdAuTsPPu1WSr3KllDInE7uweqkUjgAKf5?=
 =?us-ascii?Q?ilnjaRJ4z74ceNaqmaEfnJVNsLI0Tl4ZAUAdfyD/Z8IrX3OGDcyKi6zlw3QS?=
 =?us-ascii?Q?EfdnB6HHpNPyzRASq3z44IJCy/NtDHXNQxeVZhEXk92F3Vhuyl7DpmJk7MdH?=
 =?us-ascii?Q?EwvMgUHN0jBhSWj7a8v9iM/Ljygzz9yotvHgH+A3MCsLCrTkGXqa/mBeshJr?=
 =?us-ascii?Q?ImyyNIifVTgDnVNCKDz7B3mymCH2bSgTha8m7f6S2mr+ZVYYUaA9tI7Pm+xJ?=
 =?us-ascii?Q?7MxZGunEFxBG24XoSjrwLmlnKkQTuqQbs/2/0bC7AhPZpcEU/BxAkoA+LC97?=
 =?us-ascii?Q?cL2WfeKTXVbGKRABmkgnqTT+ro9WNeHFTgyruX3Xlap2yOTXCSMtPwdS4Hb/?=
 =?us-ascii?Q?4n8Xxh9QCPGNMJsf4A6o93d2Ha7yCmnJyGJ1E41+bvgP30aXqCNl/dPwOygR?=
 =?us-ascii?Q?tQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caab2737-0fc3-4157-0007-08db2c9f00f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2023 19:36:02.9833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zYglYJdZV9QJ3d1dKIkAaVFVOy2AOBrUoiafX3uCHFxciDTkrsbYtwMuKxK3O9BTuoFWVmenzzYhUwj1Yr52qb8XX9Rcq0AAFOYq9Say+ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1878
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Friday, March 24, 2023 8:49 AM
>=20
> On Thu, Mar 23, 2023 at 02:43:06PM +0100, Borislav Petkov wrote:
> > Ok, lemme queue 1-2,4-6 as previously mentioned.
>=20
> With first six applied:
>=20
> arch/x86/coco/core.c:123:7: error: use of undeclared identifier 'sev_stat=
us'
>                 if (sev_status & MSR_AMD64_SNP_VTOM)
>                     ^
> arch/x86/coco/core.c:139:7: error: use of undeclared identifier 'sev_stat=
us'
>                 if (sev_status & MSR_AMD64_SNP_VTOM)
>                     ^
> 2 errors generated.
> make[3]: *** [scripts/Makefile.build:252: arch/x86/coco/core.o] Error 1
> make[2]: *** [scripts/Makefile.build:494: arch/x86/coco] Error 2
> make[1]: *** [scripts/Makefile.build:494: arch/x86] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [Makefile:2025: .] Error 2
>=20
> compiler is:
>=20
> Debian clang version 14.0.6-2
> Target: x86_64-pc-linux-gnu
> Thread model: posix
> InstalledDir: /usr/bin
>=20
> .config is attached.
>=20

OK, I see what went wrong.  I had tested with CONFIG_AMD_MEM_ENCRYPT=3Dn
and didn't see any compile problems.  It turns out in my test, arch/x86/coc=
o/core.c
wasn't built at all because I did not also have TDX configured, so I didn't=
 see
any errors.  But with CONFIG_INTEL_TDX_GUEST=3Dy, coco/core.c gets built, a=
nd
the error with undefined sev_status pops out.

The straightforward fix is somewhat ugly.  That's to put #ifdef
CONFIG_AMD_MEM_ENCRYPT around the entire CC_VENDOR_AMD
case in cc_mkenc() and in cc_mkdec().  Or put it just around the test of
sev_status.

Perhaps a cleaner way would be to have a "vendor_subtype" variable
declared in arch/x86/coco/core.c and tested instead of sev_status.
That subtype variable would be set from hv_vtom_init(), maybe via
a separate accessor function.  But didn't I recently see a patch that
makes the existing "vendor" variable no longer static?   In that case
just setting vendor_subtype without the accessor function may be
OK.

What's your preference Boris?  I can spin a v7 of the patch series
that fixes this, and that squashes the last two patches of the series
per Lorenz Pieralisi's comments.

Michael
