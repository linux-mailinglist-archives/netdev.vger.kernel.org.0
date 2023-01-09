Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9571C663084
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237412AbjAITgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235113AbjAITgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:36:06 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021024.outbound.protection.outlook.com [52.101.62.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A40813E86;
        Mon,  9 Jan 2023 11:36:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOZuhrR6qwIH7Bd03aQWlIV37e1KKO0HQR6a1BndSx/JReexgCdsGDdPHDUuaz2a8W3A1qTWJb7z+M47DgsJes03faHtrNykDgnK7D+9BaFUcA18i0gjYOafjOBXNC71EUlzOCReCcuZLx+HzYSwe+AIFEQM5P84yeNyxtAs20RXHcZmDEXxba2J0tHMP3z5S9UsuxdedeHi8RsCPlHhy445ii05t+ABNj9oL+mbkmVpZNm8RvqdYG7jVA3sfSTACzOpu18TkXkFY7sUwaQtMg8T2UN6CqLReuKLPLodKBjrwziJAECKVNrPdVuzovadDNauGqwmJgsFB5tD4CK0dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rKwGbHkpfh+kAYji03QJ6gfDgY2sCsnw9h9SxrHCnIA=;
 b=lTfYfGGsD2oLfIaKOEyRsw8qUduw4ZXVCY+twOSJUpGzvvjcDOmkEnsaQWUFnYtilxoZ0H+oztbfJDyQzK07LJ8qfjYBg3/crEFgfA6pjaCwEaDlOGUGpF1AUNHbUQ1xHU7rirWpEFR5A7piD167y3XIJD4Ms+8kWXZWmzYRejctaWFajmSSvmIkIQelNGJNDxedCXmRTTdZDkFpv6uGqZI1OiVXO5Q6PeUObLX1lB3y5W9wqJYAjpIPr5inRkQFNLSoL6/twcEPoU6Zc2LbCzx1v78iVREpWoVph+sMU9aC/w7XjwzKmNgzDIu5J6RhGzcv6nKkaoLVhG0nKc3gCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKwGbHkpfh+kAYji03QJ6gfDgY2sCsnw9h9SxrHCnIA=;
 b=QM6YAbgYVUnPA1GAbeslW4xi0MiEgxmwAhJy4P1ibHtlvvekvALcqEU1WDxHv/mOV6I5OkGLD1wy/FepT3w1HnC52WeaTXNBBsEL/ia1r2mUdrTm5B+PAlo7FtmAvm4eCiwOyxIKh0fr58s281rnJShIGp/A9/JP1vxRudGJRd4=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by BL0PR2101MB1315.namprd21.prod.outlook.com (2603:10b6:208:92::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.3; Mon, 9 Jan
 2023 19:35:59 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::db1a:4e71:c688:b7b1]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::db1a:4e71:c688:b7b1%5]) with mapi id 15.20.6002.009; Mon, 9 Jan 2023
 19:35:59 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Borislav Petkov <bp@alien8.de>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>
CC:     "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
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
Subject: RE: [Patch v4 00/13] Add PCI pass-thru support to Hyper-V
 Confidential VMs
Thread-Topic: [Patch v4 00/13] Add PCI pass-thru support to Hyper-V
 Confidential VMs
Thread-Index: AQHZBf6ls2gwLvksLUmfTrf9E/uLCq6WqY8AgAAIE8A=
Date:   Mon, 9 Jan 2023 19:35:58 +0000
Message-ID: <BYAPR21MB16885201D61623BB10FC3781D7FE9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <Y7xhLCgCq0MOsqxH@zn.tnic>
In-Reply-To: <Y7xhLCgCq0MOsqxH@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=84513292-8bf1-459f-9556-a2b04d0fd18e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-09T19:16:01Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|BL0PR2101MB1315:EE_
x-ms-office365-filtering-correlation-id: 6e1e22d7-cbeb-469e-1c52-08daf278bbf8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: spGrd7nMba52+F67MwX913ZxhAjZCOseGSDLTDjYU9SgCPhPeifTMFs3v4pPxsyDTv8Wbah6h0k7f/4IwhYzX4k9hfg3DM2kS9v1HjyvIzTK7MNUfYxB7bba7PWS6SHFkNbfJxRCgJvHgIfati5s2CjXSSoc+gJAvMLppHk8P5H8NNAZhO5QteabMW/hBG8ehq1U1gnHQYba3KxuInVortYi9JgvCsuty9rkC+cNptYOjxdAI1L2O+UPGClU91BZ6qoZXkdPSCG24uCMhBOw+33rx488HP7GoeBE0Qz2KEdmbjuvWBSfIs/zf5EwAQAFSv37RlkT7awNMBXJkqcRTkQb8e43Em77z0zQswrTwi1/0lA/FoTCQpSdCpe55+B5IWnQSedi7fO/8Z5QcbTkgLv5WoQ91PbWjpX4oCAAQuSjLa3zLq2ZnIiL/AuxB3HOsjHJj71cAHWDLXuz9ER8VK3L4kzvvw8XIFrm7eSXmp9/ggZcDJly4ehTqpZwY2mN5BL42cvdS2e8Hk+c8t8DPzwiXkI7iO5iIoItN4WH8Y8i73K8Ok2ouuZj9MQIw2FgSet/rRkanjLEqvJGLTQZ3PuL9SmuPgkAy25L/KUN/FPlBdWSQARYDIgjzQrbMcuuP0pvI5PtO/KTTldu8E3n1LBnf8eDUhDsauIxWHqGBiSB4Hy//Rd3XQN6FJt/Ci/fw48J1oyc4uQPT96STE651HIh0sftHxY1YKj72wdSVcSEmjFRCtagcHLyBVl/r3eJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199015)(33656002)(38070700005)(2906002)(82960400001)(82950400001)(52536014)(7416002)(7406005)(8936002)(8990500004)(5660300002)(41300700001)(122000001)(86362001)(10290500003)(7696005)(71200400001)(110136005)(54906003)(26005)(186003)(55016003)(38100700002)(6506007)(478600001)(66446008)(66946007)(8676002)(64756008)(316002)(66476007)(4326008)(76116006)(66556008)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3G1XjJWyZBTpG4HUbjimPjaz2LDGr0f3nHSjCsSNRn8TvZAKOFuLPr3OZ87H?=
 =?us-ascii?Q?Hygduoq2EuqErq+9+UsWQ9OQVMUPhfp7sGaT2NNUFKfvRvztUWb5P6095PTp?=
 =?us-ascii?Q?bT7z2IGyxPT3YOQ41EEj6EGVujrYguLa0im0aruIZOE3ECkL4lg6E0h+D51S?=
 =?us-ascii?Q?HbzlomrjYFe4BiFUwNr/dObzEbaCj8S0OYhPEKG3WnV8eK/lF18MBRKeThlh?=
 =?us-ascii?Q?kaAo7BQWmx/qucayA/Rtq7A1PImjgWbULV4zcxNbgiMSV/Q4DoLcaQGCPnjI?=
 =?us-ascii?Q?Q55EtTOlNPnOEy1CrMd1xETOYEQCJTeWyEksMaWwz5dMX8iDgEXdg1ak/PDK?=
 =?us-ascii?Q?nEvyMt+L/uwmQtThdk+KE2wjqB+T0ILroCNFJECobt+VwG/7vH97bQCXjmv+?=
 =?us-ascii?Q?TUovQBuk1wr1Tl6rzOFPe7EAZbuDYWp96kZIvzShNJK4t9gNtkIjb4tryL2Q?=
 =?us-ascii?Q?OyQpB9Tvrbc7m4v7zsc+kxEQ15uYnkorIrp+lNEBW3c7ZByXVWJAbnTdaAFB?=
 =?us-ascii?Q?mTA21BC/OQkk7skVat1LM4vdndWI8RdSkR1T/rQDHpvJDhZuq4rA/AVnwaqE?=
 =?us-ascii?Q?V0K2KSMz9ZQx8/yTxYBoGrqY7RtPsOyDL8uKTOubr/8GrjXRbOWEUp99E9Zt?=
 =?us-ascii?Q?arLWlKcDlv125PimErhzl8BGaq4RJwMKKeQ7Ig4Q98erpEqq8vH7yV97VKBL?=
 =?us-ascii?Q?RhV4X7F26FzmKL7Y/v/YloXbrAbjuM1l5o5OhS2mc+3tL/7wyBANHl4vTqJB?=
 =?us-ascii?Q?Q5EvItpAwb4XczQl4tLi/8gH+d852xxNMK65JOVEPS6Un8sDuEi9detI2gxf?=
 =?us-ascii?Q?t/NHhrF/85WcrqeR6AFPXS0GUfTNF/FpdDqaEmvOgczTvoxhbIkSkzKPlymB?=
 =?us-ascii?Q?EW0wtyiPIV2oIKgmPADsjmXtdTbeRWX8iAj4hAuQDswI90acswwG+0bYR/5/?=
 =?us-ascii?Q?DPj+SUf0twLqIpoa28b1Xa0Kx13i6gK47Aez/xoqEaLOvLvHAfOvNGsX3+go?=
 =?us-ascii?Q?TQ5sPvgnzyDwUuqzft2D7dkRiUKRw6eAvL3/enCqOYbi/1hZT5ISDFtXGLRD?=
 =?us-ascii?Q?+edpRmHcrV3l0T494FaXwUBuYDflAYN036X8J6TEWBmg/+Y50hHMgAfRb0+j?=
 =?us-ascii?Q?Y8povfpb8ZDeoYsZuqVkxkUT6bk4A6ftpQ/kefNv0HoPGVkQ1WynmuAsbbEy?=
 =?us-ascii?Q?cjoxpR0XL5cMt78Dkv3BsBm0jRhtWVUqtQrADS/RBBCW0B+mFCPndjffdJmi?=
 =?us-ascii?Q?qsjF2Dg61tP7LzXZCE65ytQZfgrm4U+5uh7eSD/R8PYunFnSQsyOJeuwlTT1?=
 =?us-ascii?Q?Y+2RCgObnD4zjJtiuRMLDfsQMO9cUo9EWNxIUqNhg7oOHxVBj/ygEWXV6QFE?=
 =?us-ascii?Q?Dm4V82EwMDoU5sx5gFgqAVXuo1bhxVP+dRXnNSlHU6STpTd5UDmMDlMjJkAm?=
 =?us-ascii?Q?S0FskOpevn9lUEKGigBu5l7rx6k3mpJgIM9ppyjH7abQLMbT8xNRadao1I+E?=
 =?us-ascii?Q?V5o4TF5fSk7xf2ZoW6pWpXZ7zork3Q6CjP2ptwq7PKN/t8rAgpi1bLKhUZ72?=
 =?us-ascii?Q?3gFyAxdos6fbEZMiQE+HgTjCV2CDgybSWe/POPhqIXJ/dxaycJuxPw6gw+FX?=
 =?us-ascii?Q?qw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e1e22d7-cbeb-469e-1c52-08daf278bbf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 19:35:58.9787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ki9f1piHY3bBfGuF2kuQ0NXiH9quLpw9JSfS26Z1vtR2DXwWZWDwo82tMW2IsVtOXqFE7D2l0RyGO0BHAUMDtbW3SJASqIKVGyxZI82hITA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1315
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Monday, January 9, 2023 10:47 AM
>=20
> On Thu, Dec 01, 2022 at 07:30:18PM -0800, Michael Kelley wrote:
> > This patch series adds support for PCI pass-thru devices to Hyper-V
> > Confidential VMs (also called "Isolation VMs"). But in preparation, it
> > first changes how private (encrypted) vs. shared (decrypted) memory is
> > handled in Hyper-V SEV-SNP guest VMs. The new approach builds on the
> > confidential computing (coco) mechanisms introduced in the 5.19 kernel
> > for TDX support and significantly reduces the amount of Hyper-V specifi=
c
> > code. Furthermore, with this new approach a proposed RFC patch set for
> > generic DMA layer functionality[1] is no longer necessary.
>=20
> In any case, this is starting to get ready - how do we merge this?
>=20
> I apply the x86 bits and give Wei an immutable branch to add the rest of =
the
> HyperV stuff ontop?
>=20
> --
> Regards/Gruss,
>     Boris.
>=20

I'll let Wei respond on handling the merging.

I'll spin a v5 in a few days.  Changes will be:
* Address your comments

* Use PAGE_KERNEL in the arch independent Hyper-V code instead of
   PAGE_KERNEL_NOENC.  PAGE_KERNEL_NOENC doesn't exist for ARM64, so
   it causes compile errors when building for ARM64.  Using PAGE_KERNEL mea=
ns
   getting sme_me_mask when on x86, but that value will be zero for vTOM VM=
s.

* Fix a problem with the virtual TPM device getting mapped decrypted.  Like
   the IOAPIC, the vTPM is provided by the paravisor, and needs to be mappe=
d
   encrypted.   My thinking is to allow hypervisor initialization code to s=
pecify
   a guest physical address range to be treated as encrypted, and add a che=
ck against
   that range in __ioremap_check_other(), similar to what is done for EFI m=
emory.
   Thoughts?  I don't want to change the vTPM driver, and the devm_* interf=
aces
   it uses don't provide an option to map encrypted anyway.  But I'm open t=
o
   other ideas.

Thanks for the review!

Michael
