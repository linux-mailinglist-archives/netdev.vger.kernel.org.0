Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EA8644CAC
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiLFTyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiLFTyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:54:09 -0500
Received: from BL0PR02CU005-vft-obe.outbound.protection.outlook.com (mail-eastusazon11022018.outbound.protection.outlook.com [52.101.53.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C312E9E1;
        Tue,  6 Dec 2022 11:54:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nytSyHFdbWw3FtWTKxzZ6k0TsBBdFvv8oSVjmfAIxIsnHE/y0HmlC5wQbzOa6/CZ7ii5Lssl5A+Py8Gow6Na5+/0r86pDUm3WwlaZU9Jaf0KTsiEbBvUm1nPmuirQwzgYx/Rv0rIVvPATpQtCD7O51ZoMjUKKE1Ew+fMgAY2OjylCXcv1JHS9vQ5YxsJQXmGaaNs1cXaEvTHzUA2NEqYUJPZuKDzMRSJgmYkjBW0KWV0C229OoYlKBpm0sD+gexbSR8ODSggc5YmajFqbA9YbLHSSvzegXinGf4flzvo3JXnJo+Elb82jFb97BGxTyUQQ2nwwlCYVhWWz4JaBE00Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBUaysaja1iOteqIwEFgoVoTwNwApBRVKhwHiCKxdAk=;
 b=eP3pJVFznbPGi4yCnCbumylRoQM2A0ZRRhbP/N4E4OzPXg6PCgRPrvhEpZ8Z+RzEF+vYi/wEPWOrzNkAxzzhRCK8hXeDE2TQLbYSZCf7cx2IFy+dmSKB5Wspo6XLOv6LL69iQt9+1uzaLR3T0Xq7S0OoVQtDTX5ZZecAKdqXIiyxagB76AUD1MdF00fZzDNqvD6sC8ln+ggDi5tZ8N5GTGwJEHsnSPfaEvfoJS9GxlKZaaS1e7DElj0i5+ivj4APsU0doy3RQ6th+srsK44G2KOMuGpPS3XEXWTJaaL3Za380U9nNPvyCE3g72TA3M+5fYtKqAG/mSM7Yxp5j23MTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBUaysaja1iOteqIwEFgoVoTwNwApBRVKhwHiCKxdAk=;
 b=WPStJjU8hHm9F/iA4yYhtrcsW8qSLIOKb7xZSNePItXrV0Gg9Josd8tlI8H5abgqS64bwH9Xls7qTVvRlCAw3y6oCHnLnd9TqM5JZraRKRecbdecgjDJIcycoS9CchgBDFogoSKOYKGaSd+R08E5tA3F3ICqvc7YhBJ3MrC/Eko=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SJ1PR21MB3675.namprd21.prod.outlook.com (2603:10b6:a03:451::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.4; Tue, 6 Dec
 2022 19:54:03 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%5]) with mapi id 15.20.5924.004; Tue, 6 Dec 2022
 19:54:03 +0000
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
Subject: RE: [Patch v4 01/13] x86/ioapic: Gate decrypted mapping on
 cc_platform_has() attribute
Thread-Topic: [Patch v4 01/13] x86/ioapic: Gate decrypted mapping on
 cc_platform_has() attribute
Thread-Index: AQHZBf6m1tvwNL7mx0Ck5dxxQ1BDw65hREcAgAAIgaA=
Date:   Tue, 6 Dec 2022 19:54:02 +0000
Message-ID: <BYAPR21MB16882C3F39AB321A53BA4129D71B9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <1669951831-4180-2-git-send-email-mikelley@microsoft.com>
 <Y4+WjB/asSvxXW/t@zn.tnic>
In-Reply-To: <Y4+WjB/asSvxXW/t@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1dc6a1af-ab62-46c2-831d-627e9cc8b76b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-12-06T19:53:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SJ1PR21MB3675:EE_
x-ms-office365-filtering-correlation-id: b17006e5-a30e-487b-decc-08dad7c3a002
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dXXW0nXp23dDoVmciNbFI7+q/C+jMrqcjTtbHcw3E1QX4t5qVz5aekG8Yy47gbJCnnsAjmf6Jw3KIMFpMOGe/Y163FGeGN5Afj0gUV8OcO2vRJxKSTfWGSTE3y5FAfNj/ecgl90+m/aztkg4Xs1PiEoxzLw2X8Ad63+wNlIYLASTqm37kPA0n2VrEFTevPnkZ05N7hgJnewYK09xdBghlZKRge33KdL10tD+I6P2KQDvms4wIrSLbeqIsmaRt2pwC4BdFBxVQU+9lTGiXvo8xmfNKSOjmlNbLDzd0yx+eji3l/xjrBbbeRYB+Zq/1ZEFZo2rVs3Rj9HeW3alwvoM6pxQHFL+BD5spYE1SLk09zSIvl3GmjlfSeN6RYWLhEa0naCyPIaFdijZSUgt4h14Ig/JAER0XG3fkuBn+R08eRGuCNBuOpC3tMgm6e0/4nZBIztz4a4peqwojfi+l+WhHtiGDXI9hBishE3i73TZVBzigvL3LrUE3/se1pZ04Rkf51mobalKsw6b9AzBBHS3qhFoU3ymYVQe3ZJs0T2vulNt0YinXj3R6rQfzKRyVx7dXYo5He4AmLuF9r6V6MIk7MTPr9ijb/4Kib2351sGmKHPmKefJmcsNJDzvQZhzy56VCRhg4eDNiDJdTCd/HAbFf2Q3yM+i4CNqcL9oPdAqmm1yqEMAW7L6cA2hmhKe3xBZQeUAK635ejyKgfn9liPCbMCTEIbKWF6Jlw4IGRErooNLkHferisATe5tc7bkd9N
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(316002)(2906002)(4744005)(66556008)(7696005)(6916009)(66946007)(66476007)(52536014)(54906003)(64756008)(76116006)(186003)(66446008)(71200400001)(33656002)(10290500003)(9686003)(8936002)(8676002)(4326008)(26005)(478600001)(8990500004)(7406005)(41300700001)(5660300002)(7416002)(82960400001)(86362001)(6506007)(83380400001)(38070700005)(82950400001)(38100700002)(55016003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BN9yvzdWb2FZe2Klv3YLQftqlVNn6UNz66TJRDWrOGR5tuVgG3mKOk/9yj68?=
 =?us-ascii?Q?1rd14i2dYEmXuIrjGsqhcmuCtHqrHaSLCdRk03J3GQ92uRVMMszoBFr11BLq?=
 =?us-ascii?Q?HUN8gwii56ZsSJ4Xck82HDQs5BWWrRPNXtXDOPkUIUZgReDXUslMHMWNgu8y?=
 =?us-ascii?Q?dGQklAmJ4+CyjVgMCnhwjXHYjvlZlOYFw0I2xaBBdKlkWp6fZyEnKprCNmS/?=
 =?us-ascii?Q?Lln3EcZo4SOmcpXaq8qsiwGjG84yzBZq5HuFNcuymPdmA6dHBqdmiOqtl33y?=
 =?us-ascii?Q?/rf3tG9lER2KvjFQEun/7M82aK8jVTJStO3JGLcsW516XRgwviBlUCY1cZEE?=
 =?us-ascii?Q?mZqp9Va9Me77rBOpFkYc8VAef8e67rmZgOlCOd4JIVeRkRi84SVE1Z32rL8y?=
 =?us-ascii?Q?s8S+JnG7D8O7rEDAUU3muJ8cLgnlzojKENZ/IFk3jC/QKHLu2oByuzAOSV2T?=
 =?us-ascii?Q?kO3UdYlgCuRnsOprz8Tob8Prcs/CqCOe03wjL1O71N/1qsovjlRZMiwji8nd?=
 =?us-ascii?Q?k4Vp1hl1D2rHK57/gllkBHxTsYL//snto/aWEeXgOTuorYB8iOFto9TWh14o?=
 =?us-ascii?Q?v8uhXIxRd4l2ZAr80QbQy4IB61La2bkKMv/8Dw6wKlM+Arci5wOIJAU6zZtg?=
 =?us-ascii?Q?bUf23UH5WMaT58GLLe66dIqc2z1HrePYslMp78x8m5v6DGU9zMMwEWROtb5a?=
 =?us-ascii?Q?qQJHurgyLrdYcPSCA/mF+rthL+IHIHtkJImcnq+m9f/bx+yZ6kh7Ch97XJXN?=
 =?us-ascii?Q?AUAOaBxESrYQWGPVWjUJkS/LezHqyWocRuv8pfibaBkJJd8uDcVZtRO6d+I2?=
 =?us-ascii?Q?fGNFOvCFyltG5NiGLWH9oAzeurXzahkHdtclOAEmkSQrt7fh67FQs/nGPVhw?=
 =?us-ascii?Q?orTD714BjY+wOcfWWf3Sa3cwnjJfMbQECwPn8mgHlk9ha789LTgHsLiIl5uN?=
 =?us-ascii?Q?1ujsVX6syxeFv6zEWphdsXmVnH3k+5H5l9mgFTDpRQ82FCXwresTf10tn2pM?=
 =?us-ascii?Q?WvcqYeXUm2hqAjXTD34G3xSOLhw8c+cQcxKGCHhj3RpVbcz27AB+zHOLLNd7?=
 =?us-ascii?Q?2PZBN2ciaZLMrw/saiMnDT77iBIcrJM4EXDU1Zdc7TKWGOvGjMQuZl0yPic4?=
 =?us-ascii?Q?pxNozJfPeibHLilZ7C3Zw8AjR6SPi/pITC8ofmLAW1GKU2purKhyXYNmCmoB?=
 =?us-ascii?Q?yTvwy7gBE99BEQdECP/kSE+YNT0960JQ8udjzJ/QNWKpNpsl0PuYA8moG3RD?=
 =?us-ascii?Q?aq9beDVppdyYym+fCtamlnR/AlkYKlgQD0T47Shf7dI9CvbB14nkNjCEQpwL?=
 =?us-ascii?Q?8EKd34yTSKQthD66WjbogrjrANOusedoCq/84pAQTW4kGh81SveTKBxu4cIn?=
 =?us-ascii?Q?sMSxRgWw8UkUcqVs0FHx5Uhs6jYMKooAsYjYpGk8Rc+apY1fpkdHI91zOq02?=
 =?us-ascii?Q?PT4A5tbBSTZG/N1T6MV3xHh0uEekdnByciHefMa1scuiAVCzF65i8TeaeiRD?=
 =?us-ascii?Q?eIW+rWyFO7oFWdeRd/COzpRIvpV+FoSJswzBuRyUCPGeEexjz7Za2aGgWAfm?=
 =?us-ascii?Q?hIIUpgIItE0lMRZXL6W84cUK06hVSU6K9tJmI+6eOMVhNTltPLmRexUcrN+c?=
 =?us-ascii?Q?sA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b17006e5-a30e-487b-decc-08dad7c3a002
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 19:54:02.8858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AGfn2S4UUMNxoV+AGsm35po4acpxtooW8syVFS126wsaL/wyXJhfBzMp4XE1EUkA+hxUWYZAp3oKViT0V5NBKb/CACuzxATrT1UJj+dy0Mg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3675
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Tuesday, December 6, 2022 11:23 =
AM
>=20
> On Thu, Dec 01, 2022 at 07:30:19PM -0800, Michael Kelley wrote:
> > Current code always maps the IO-APIC as shared (decrypted) in a
> > confidential VM. But Hyper-V guest VMs on AMD SEV-SNP with vTOM
> > enabled use a paravisor running in VMPL0 to emulate the IO-APIC.
> > In such a case, the IO-APIC must be accessed as private (encrypted).
>=20
> Lemme see I understand this correctly:
>=20
> the paravisor is emulating the IO-APIC in the lower range of the address
> space, under the vTOM which is accessed encrypted.
>=20
> That's why you need to access it encrypted in the guest.
>=20
> Close?
>=20

Exactly correct.

Michael
