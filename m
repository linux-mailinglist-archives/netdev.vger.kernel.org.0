Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A831692620
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbjBJTPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBJTPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:15:46 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021017.outbound.protection.outlook.com [52.101.57.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8B4795C1;
        Fri, 10 Feb 2023 11:15:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKnPjgcfgFIS4usaP/bXXm48PwnhtwDv5ptoNErOkhxdD6anR4jY3IkqIwxkQu5fXRjGjS31siODPrxPcQXh7p54gBArEvghTRyRNvOhzybmyz+bdwxA04mfWL74OsbQyl9xo280vJZ9F4CGD8tDbVCQ/8v0cxhS+94iCVqS3oIqi0Vl53zregeszq2FdAcuUPPw+5h9k1J7YhzC/S9IRLOz02ea1rPRbhG62NV8KD5S8mZzmZhecMM2yW+iwTnfotgw4GqlP8kqRrfqqHCv+VeIeuY+yRCzhFOeUFBoaiZjXzrwxUfZ0zHnncZqwLHCY0c27TvlxrNJREZBRZTqOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6VGEA3gJGkUGJLnMKN3p8t2xZe4vCbmL6A/sRIDyOYM=;
 b=LP4IgrrGwme9cMon3w+ETRM9JoNweDz9nf8vhomT71svBeX8b2Qy86BQioKEwAkae38P8ypHYfK61HX7+ayoDn/RrUrWyDzLpKaGLG9UtCpHotctztOIwDqJ985dpiFDZaAYpvkTTC94bqsQ/vXKwP58myhk2Y98Z3uuWFGbG+l2fCUrvlVZ5t+3wOAx0ligm4BDqL7ZNprmo6JrOCYIs+UeVtWrFGj4cQIAEdfhjDbFk+NeVrSLoShpnoM4o5tn1l507NZLy/M1KSFdAUcB/el/SmTifwBiWl4B2dDr5a1AKf7jXtCbVjR4rTeJNcQNKitVWBF+jwKexEi6B8FSNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VGEA3gJGkUGJLnMKN3p8t2xZe4vCbmL6A/sRIDyOYM=;
 b=S0Sl+MR4GRkkjfQUlPKkm/+eW6LyIaut1D7LwV8RDyxYgJiJyV/ZXX0icv/IuBcszKwW7ba9P1Pvq+EoU2hrwo34BpyELV71EscjlgkB9yVBn80DMiE/3wwOGEiYtkbIRHX6P9q0K0ANCuvXVm+JNIsUOOhOEOiKrjjrqSY3PD4=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SA1PR21MB3809.namprd21.prod.outlook.com (2603:10b6:806:2b5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 19:15:41 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf%8]) with mapi id 15.20.6111.007; Fri, 10 Feb 2023
 19:15:41 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
CC:     Dave Hansen <dave.hansen@intel.com>,
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
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAeE2AIABk95AgAGmoACAAAYigIAAAicA
Date:   Fri, 10 Feb 2023 19:15:41 +0000
Message-ID: <BYAPR21MB16882083E84F20B906E2C847D7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
 <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
 <Y8r2TjW/R3jymmqT@zn.tnic>
 <BYAPR21MB168897DBA98E91B72B4087E1D7CA9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y9FC7Dpzr5Uge/Mi@zn.tnic>
 <BYAPR21MB16883BB6178DDEEA10FD1F1CD7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+JG9+zdSwZlz6FU@zn.tnic> <4216dea6-d899-aecb-2207-caa2ae7db0e3@intel.com>
 <BYAPR21MB16886D92828BA2CA8D47FEA4D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aP8rHr6H3LIf/c@google.com> <Y+aVFxrE6a6b37XN@zn.tnic>
In-Reply-To: <Y+aVFxrE6a6b37XN@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b8cd3fdd-adb5-4795-b086-31d93fedf621;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-10T19:11:33Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SA1PR21MB3809:EE_
x-ms-office365-filtering-correlation-id: 83e293b0-3609-4e29-ec95-08db0b9b3380
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5yMs1kTFKKRB4R/TvHyabCqeM/E7Ci9UmueP+fW8MyK7CPAGddDwpuABU0hfFCCHcCbe8/Aa0ERr6VEUibD/cQPrAbTfpzDX46zIfbaRzIa6olYRqObjibCDlNpf8FGhsf4CFz/D8cR6/1gyjFPA9VFQK6WbGStxKTP1oTxwb/csiR/tSnf1r0Sa9h1/fgDWIGnA3e0WideMTFMrBsZoImo+6oVaukzc0qPViVilPZIAgJanfUbbmrNGuQVkisXbbFcCIkHxVH7UQ85AKH+gKeJv69ksN7PDFnRsFx25iC+T4uOZgb84B0SD1Ety1zA985O0noqRUvuBnv7G5x8Xq6aBHC7IXSSiETuqHlocwKuYETwC8Rlzwp8mhw5iAMk6Hb59fVjuw8yx5Zl1G7ClsT2Y6WRgVdowaeIclhARt8fnoI3/bYKdyXr3L1T1LS/ptFuoQrpZsAACX0H+vqFTUskmtbYNK5OlMYJv/SP4A3bZ6Oy0MaEN53iYMSrt0l1YbOKjtdBdA2TISzZTGWagyLOgRRqZUzrei+uU3U9Aipim2FQi/YkwID/wYvnohEUPsZUxVwThwNfvsgYRZtruA5aKwZsxL4caa6dtFZfPZU8nTwyL91SL6hvGJgTVTCXB57Az/x8PYoMmW+wj+dv2hTK2juCJRX26zdPlhASQO897A7zgjeHLxeEkz/1Z0rwZ7/6l3M2FVRjXt0VAxoM25+YA5Eq5ti+T7tJx1Id6LaRgAYeJJvEnqxFvxNfCxSaa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(451199018)(83380400001)(66556008)(66476007)(66946007)(66446008)(316002)(54906003)(52536014)(7406005)(5660300002)(8936002)(7416002)(4326008)(41300700001)(8676002)(64756008)(76116006)(478600001)(9686003)(6506007)(186003)(10290500003)(110136005)(7696005)(71200400001)(38070700005)(33656002)(55016003)(86362001)(2906002)(38100700002)(82950400001)(82960400001)(8990500004)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZciE22rtbpTDwdgNWrQeqccnmo2hdjVa/mbM7i75vUE3MCwxd8DOMdQZz1J7?=
 =?us-ascii?Q?Ndvuhzq0FDxrOayP8qDSnJ6i9wH2iTsyburbbjMsf5rv/z5uDI74LtmuqdsS?=
 =?us-ascii?Q?Wr8ZvcO/zncxnsNeZ9O+d5mMLuOC+ehwAaZQd7nCc9HKITtXEbiYJ5k5khHm?=
 =?us-ascii?Q?RQzB2OdLs20hwsyD0zXuTj/3EZK19JokMo8tpo5JJVExn0orc79Xfd5fir16?=
 =?us-ascii?Q?j5di7ssYVi83xE5ls2xOoL3r2pqUEy4yAKD4yyk/kynsPq4eqOrRoPp5YMAl?=
 =?us-ascii?Q?JHzEyHAl1AoqnX6h23IbeCcPlAyrz4edLK/t3q/2XoLJBimM+6HGeIAg7HAR?=
 =?us-ascii?Q?YlUB9lt1QQn0gianuD6h5Lug2CDFtPKvD4SmrRaqC3tpmXYjU6rWyKhDi6xv?=
 =?us-ascii?Q?WJAhuAkDR+tr6WYVmDXMZZgRAlu5Q3G5EnanzjK8tR4hQHz1DGw7x/ZMtiV1?=
 =?us-ascii?Q?u+hm3S2eVTLjzenYvZYXDDcFbd/cybtZmXihRccGL+1G2oO7Jpe8LKgrrYym?=
 =?us-ascii?Q?XbWImRpzfY1xhAc9wQZW0k8EGBdfZLS1LGHwj2RDF1+On+9SrG8Q99DzVmsl?=
 =?us-ascii?Q?sEiLpzlrXHNhoAUuMe3MYzDtsw71lDWB0qlrE6A93VQF/5E8wSlyvVuAU9Nu?=
 =?us-ascii?Q?HIN3ZCvk4mUsmzXjRvoR0q5KccNZk19QT/a96k28l9lS26xCHZdMBUXA5jn8?=
 =?us-ascii?Q?frHt9YdKzA5W45Kq7N6/Qik3ykDA//pvnTtecEdSOP9eZXKvHvwnGxFX6tgy?=
 =?us-ascii?Q?7jeGJcWDLhfpNJPD64TUR3ASaU8WYLFrrGHN9L3+kieuz214QLgCInCEPGaQ?=
 =?us-ascii?Q?lDraAO1MWWvtokfLLpAYC0hg9YnflDj011FT3D3O3rpZQb4UfTOMKZAxZYqv?=
 =?us-ascii?Q?6NlKGDg55fic291mC4gCSzCkEMZ7Gq8mXV5i2nJr3gs4hvw70Ptd9zbkqkXD?=
 =?us-ascii?Q?MaNCCAxjZinY5LyYXRAf9WnH1xJKS9DT8Rvg9G33hTDQXDgnS4ITd6ty+v8m?=
 =?us-ascii?Q?p80EFuRZor6fG0UUtKNvA+ImrDJZYGyLaDuHBeRg9xDMYrnhl60GitNNC4YC?=
 =?us-ascii?Q?9moh+WNguAj+Vid9u2VZFtmiwYDsOx0T0zFhmTC0fRHNm98mfbDb5UGfPSwt?=
 =?us-ascii?Q?i0NT98+RyjIlbmf9AVvIoOLbclAzhrkwZsjo0fBClykHiquiLQENqJnaN9Xl?=
 =?us-ascii?Q?iHJ0BP379S6jplwH2yKpinOT2m/DEM3BTt5qyRBaeGLYSWDVNz2HSXcCq2CB?=
 =?us-ascii?Q?tyBuZkTUv7UM4nQSTz5td5Ah6K3/caQX0ktgDuA3pKBhvO1Z9DjNbtJbpZP1?=
 =?us-ascii?Q?KSTJCyoIfR7WXgyU2DrBtjI0lkP7E8okHXH4Red2LP1NQAKcavNDVtt70Hdq?=
 =?us-ascii?Q?3EIchFNEqrkWbE+ugj/LLwBpT3iEmQ4/Jko9hgfJxPuyKY9csxOg/Vu+YCvu?=
 =?us-ascii?Q?P0YFlQ4eFN3bIT9o4rmR5xJm2/sPVxXAvozLmkB4zXiHGdN0TsN8s1voRUPl?=
 =?us-ascii?Q?B5v3qr2UVoznHH90kqsPoKzc9tb0M64IOcADilsRpsssq6fAOYa3ZHYc3HxU?=
 =?us-ascii?Q?CxQghLwAZ1chnyt5E80vG3p55JpI5hUuZ0nikiSOk2Vac6hjzUKDHsmBK4iM?=
 =?us-ascii?Q?BbC0VjZ93iSCDafamWTG8STkNp9t/0EHIT4h5EoLL0/f2H9xJzLODiDVXbHd?=
 =?us-ascii?Q?iWogeQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83e293b0-3609-4e29-ec95-08db0b9b3380
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 19:15:41.4355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u2pOf0GGRzSDKeQhqxpXLKo+ZZNyRpVnP63DaT+4DWLuEZt8ooWooPXDUVxiuuI7fk+W1zus2W5LRxpyvKd4Tzk7ZZZed3O2ZCbgjx46HVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB3809
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Friday, February 10, 2023 11:04 =
AM
>=20
> On Fri, Feb 10, 2023 at 06:41:54PM +0000, Sean Christopherson wrote:
> > Anyways, tying things back to the actual code being discussed, I vote a=
gainst
> > CC_ATTR_PARAVISOR.  Being able to trust device emulation is not unique =
to a
> > paravisor.  A single flag also makes too many assumptions about what is=
 trusted
> > and thus should be accessed encrypted.
>=20
> I'm not crazy about the alternative either: one flag per access type:
> IO APIC, vTPM, and soon.
>

FWIW, I don't think the list of devices to be accessed encrypted is likely
to grow significantly.  Is one or two more possible?  Perhaps.  Does it
become a list of ten?  I doubt it.

One approach is to go with the individual device attributes for now.
If the list does grow significantly, there will probably be patterns
or groupings that we can't discern now.  We could restructure into
larger buckets at that point based on those patterns/groupings.

Michael

>=20
> Soon this will become an unmaintainable zoo of different guest types
> people want the kernel to support. I don't think I want that madness in
> kernel proper.
>=20
