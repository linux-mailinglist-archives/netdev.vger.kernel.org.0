Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA5F674065
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjASR6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjASR6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:58:10 -0500
Received: from DM6FTOPR00CU001-vft-obe.outbound.protection.outlook.com (mail-cusazon11020025.outbound.protection.outlook.com [52.101.61.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2315D90845;
        Thu, 19 Jan 2023 09:58:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhWvpi1LogqDdiQkwPQ0C2ws/kTi/Y6GoVgrKFPWXsx0f6jeNTeaopbsPbhs2grdebweqPGTflGy+vH8T5nGgLsyVMmE9eBIDKzpqrM5xDU6BOzXzpNEVqdCx7BTiyT7wV8IQnCYoYL0EO4WoRjC+xldmRsKoqwG8fVyK/wQEqHKkfbADcvtLSVSNanfKGx5AXEhkS+6/yj69oIOiHZDTz4JC+XapvcGtE1CpLG3eEFe64BqxJSOLyuNdw4xIbyNWYkEE8WmwmFz/+wf7vGpcDFdgzw2n+95XFFFTxYRAYTQMLakCqM/b2B379r5jEkLErTyEJlcS0Xtz/rLvuOdpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qh3rgYYm5wrfvbeCfMfz2kTKIwu/ZzgJqo5/ap+J8KE=;
 b=au3R/pcv+zjsp0dUJ1TkVRfGuh8kTiAxfskTeX2wIsFdunFdsfYyxjkohwVHTLlSDisRqQo/WiH8NMOMmb4qG5cRvF8m9l1twAksq/otAr4NyMI5d5xfAid6yldb/5r4U0gRaHBeJnkvsA0CB59fn4dBO2FEr/iThWyxSi7GwxGvldHxtnJaARtWWIHItkvNb0lOHE770lAeDFsVMwY0WHLJ8gpsf7U735vOmB/KaRcv2XhKS9DwK+AInOfZCjAn1oBCDiweDYP8H20UTKJbiafmPLTvmLEX35jkUWe85Bvjg7NUfsmuhOIYuz/s9d8aK66nkl7WboGsS7+0hiNxnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qh3rgYYm5wrfvbeCfMfz2kTKIwu/ZzgJqo5/ap+J8KE=;
 b=jtC6vQLFU+VeysdHCnOvj0HKXL1UtlTs2MAQsWDbg2Auzjuzj7qyE+ytLBHkMdGslOhHBXMIAJ6kZtv5z07J6yNRY0k1JIYJsi6fesJgOceADnqOvuNHGUXj3pajOfVTuRvhaFP26fUcgvJPE1V8h8Z83QBpVxO8ZBdgbc0MWGM=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by PH0PR21MB1307.namprd21.prod.outlook.com (2603:10b6:510:10f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.6; Thu, 19 Jan
 2023 17:58:04 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::c14e:c8f3:c27a:af3d]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::c14e:c8f3:c27a:af3d%5]) with mapi id 15.20.6043.006; Thu, 19 Jan 2023
 17:58:04 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Wei Liu <wei.liu@kernel.org>, Borislav Petkov <bp@alien8.de>
CC:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
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
Thread-Index: AQHZJo6ylykThdLA10Cb0ddOjSIUP66mEVyA
Date:   Thu, 19 Jan 2023 17:58:04 +0000
Message-ID: <SA1PR21MB1335741F74F96320304708ABBFC49@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <Y7xhLCgCq0MOsqxH@zn.tnic> <Y8ATN9mPCx6P4vB6@liuwe-devbox-debian-v2>
In-Reply-To: <Y8ATN9mPCx6P4vB6@liuwe-devbox-debian-v2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=fc23ee3d-dbbd-4be7-a57e-3d8eafff84ee;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-19T17:55:37Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|PH0PR21MB1307:EE_
x-ms-office365-filtering-correlation-id: 9de61f5c-8972-4658-cc19-08dafa46b677
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FZHi9QmgPin/xFR71mhCHN7Oj9nbl5XBbalBuzSWAgNK3Wiw0wYiNC7O0X7LfUczsnW6n0j/soQ5lmAt60TCobwIsAZCMW4jIrWtM33vBdatfyy2nt+X3gSwMOY75KTQQ4f2qb3ju1yDe+LdCA75D5uAQ8Udep/Hs+qoxTa8KftmyMACt5EhV/ZCIiR4ITPWbiVwq/5KIX0VH5T65StuVWuKPY1timAJRIfSq2CuAgTs/xbYktBYsvjT//KRp4uetJGzEi+XZXk+1dZ86Cp1d3hdFLa4f6CHE276qMLM5nS026sdS53a6zu2wi7WD8MxsfEhToXi3AxjRmIf37y0TiVxM/erVy7OzkMLr3uk3hcnGyEQr3DHbj3EciHJGz1aYArJ1+e81G+hzgaiXck5k5XXon5PqZ03ac+OS47pjhkmd0shcIAI9rDAnwKHOPxj5fGb8Nw3tM7ykTXYy6gA2e9IMS4WF87FOf4tO84T1pifWbflQW6XNbST3Usyvy0sCm3OUhT1+PNwyrRHjaoY+Jek8Iuk/4xcCssI9FMICWTE6TFisSUTihmakot2A6BgM2feQPEr3OS6rmNFc+6syRo/0Hu1bpDU+Lb/MJ67t59ioDi738JnNZMrAOM1y6tSrUfzWjFJADo2UbrGtljIxEWqKsv3/1epZRtVOVM5SF1YmNaHaefLWNLaHt97zpBAj/RKg3Ff4x2aLjDR17faelrCtZoooJwtziN8ItnGYolIbg4O7VeWMH9/FLDE5ZfS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(451199015)(76116006)(86362001)(53546011)(8990500004)(6506007)(478600001)(7696005)(71200400001)(316002)(33656002)(122000001)(8936002)(52536014)(5660300002)(82960400001)(26005)(7406005)(66476007)(66556008)(66946007)(7416002)(38100700002)(82950400001)(66446008)(8676002)(64756008)(4326008)(41300700001)(9686003)(186003)(10290500003)(38070700005)(55016003)(2906002)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y+XGiOEGgGLcg4yLuPNnY3wiYEFYJSe8JJIhAdyGPt4dcTabFb+WI8hMdZFX?=
 =?us-ascii?Q?jqvaOlOJCMTiOamYBO55+sEFOb6BeARSVZgpHbaQK19Y/IIHuZvBf4aNNt3Z?=
 =?us-ascii?Q?KMvXQpQ+Dr3VFf89brcp5m3gSVUg0SbCZqXJktNhvce+OXqPi7su0kr9JxeX?=
 =?us-ascii?Q?FW1seyy4Op9FZeJwhRiUspJYTEspaNC0WFCmzKVVKk89xw7kzIex9Nty3rCx?=
 =?us-ascii?Q?xmtK6MzKQj+pQ7hO8107SGjsiHmLgnDHFg1KkpgII7Ms4fkerYKAUw9ScfhO?=
 =?us-ascii?Q?flR1lkRYW2UmXVsDJD4HS+24yVzIfcqqejzMwX7S+pRs1eI1xQ0TGei9czyf?=
 =?us-ascii?Q?T7R2tHEqFuwrc1HpavVUMmyqle2N0NQsTWoJBjtrkDF3l4ht+P8BUczwOdOu?=
 =?us-ascii?Q?7c1B92hN8edOYcxEZOxQ6s99PBoqXJLRvr0GQBO+BWbcztOrgt9VIwpHCKPL?=
 =?us-ascii?Q?T3R/4x6DaP4sUQpB8j6G33B8ItVp7BBYNO3EN7SDqZ3V9pyzyR0aA+F8oJOV?=
 =?us-ascii?Q?DUMVsl7gXSoUZTc9wkZIbAaKgz5kW8DP7tH2t6ACZaa0YGgOrOPjhTMSC3CL?=
 =?us-ascii?Q?qO2H00wgf5bhWR2BScv7FFwnlecaqKX7E8Bs5DjKwrYh7GJmvQOg3AhBJqJX?=
 =?us-ascii?Q?AcX75zyyiBg0yJdvxmsbxywZPeAm3ppkqFtf/65d6cHNtFinLwgRhus0oiQB?=
 =?us-ascii?Q?6PRV9NN0EzljxA26HZGSxehVGqaigJOnmwDWHb4c/cDftCrHYBZjSWfVzjNF?=
 =?us-ascii?Q?LtnbPFuB5KcaXgGug8yBcaW/bzVOM17YNmQ8CCQ07TuqB4L5wO84rFSdjM8u?=
 =?us-ascii?Q?Sg/S0/TgxrsV+33OQ1Me0KjM0xGISpoLx2cBIeOVybfhH6AQfhrqZS78Ed71?=
 =?us-ascii?Q?DTh9nGktp5vJJsKk+TzAtkElpfqRTg+RO/S/T4yPVxK5jNOG3RlBQi25VI9q?=
 =?us-ascii?Q?w0N9kPdlPrV0RsW/SCTPC5K3N4iHd4XftTxKV52m5JgQknoS3VOYEVyZXm4p?=
 =?us-ascii?Q?OTI+AynhX5gSvvBiCzspTHcaOgsh6egygBYrQmjV6vkCu7Rk7y/cC/kpXvkC?=
 =?us-ascii?Q?kj27/EwbnX1hd3LIpx5Rnh6K1QUwi0EnPMuqaUwPxQ6fFDFfCJx3fLNjdA9N?=
 =?us-ascii?Q?xpsHIreC8z+Y5c8/b8Yvo6Q/j0oR8EGQDuuwBHQUeJLerQ+5QUQCr6RTtLfn?=
 =?us-ascii?Q?k+yBm/9OABRbDLpVADatozWlDTwrrEBrHzZPmCsZbA23px9ZF5y9A4EAS9xq?=
 =?us-ascii?Q?47cW0b9tr9nZYvCP4Mh50Hk123Abf3YKeuzikG4uVqqvKTKni9cGo8HOX4HU?=
 =?us-ascii?Q?keKVqJLQfthYb3y0DS1LH7OnCRmskOL42g7zolMuY3ViHein54aLAHPBy5jy?=
 =?us-ascii?Q?qTccVhgA9Lg61SK96TTMYHEgP/xrzK/NDU8DGrz0FXNqTUxNE0mm5wbudcxd?=
 =?us-ascii?Q?4kvNIbiXIM9OKVmj5YeAErGMTsTr5U6zUJTgAkn9bKM0X8JcJktMh2GIuwM+?=
 =?us-ascii?Q?oQYW8OVhhNrbf7OQzQ6xvRYC9z8ABUClGy1TRMAquSRULWC1d+VbkBZ6ZUZ7?=
 =?us-ascii?Q?seveoEHx67CUH6SXVO8EVKgd2IgXvMPm27dLyjJJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de61f5c-8972-4658-cc19-08dafa46b677
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 17:58:04.1836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fwK6BMLa+gCDHAcC3b7RjEjtCcuVZtH2eYxGDagbANUsOdWRWzBa6kjigsVBV3Oczg5+vPBqYF2lMaoXF2xPAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1307
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Wei Liu <wei.liu@kernel.org>
> Sent: Thursday, January 12, 2023 6:04 AM
> To: Borislav Petkov <bp@alien8.de>
> [...]
> On Mon, Jan 09, 2023 at 07:47:08PM +0100, Borislav Petkov wrote:
> > On Thu, Dec 01, 2022 at 07:30:18PM -0800, Michael Kelley wrote:
> > > This patch series adds support for PCI pass-thru devices to Hyper-V
> > > Confidential VMs (also called "Isolation VMs"). But in preparation, i=
t
> > > first changes how private (encrypted) vs. shared (decrypted) memory i=
s
> > > handled in Hyper-V SEV-SNP guest VMs. The new approach builds on the
> > > confidential computing (coco) mechanisms introduced in the 5.19 kerne=
l
> > > for TDX support and significantly reduces the amount of Hyper-V speci=
fic
> > > code. Furthermore, with this new approach a proposed RFC patch set fo=
r
> > > generic DMA layer functionality[1] is no longer necessary.
> >
> > In any case, this is starting to get ready - how do we merge this?
> >
> > I apply the x86 bits and give Wei an immutable branch to add the rest o=
f the
> > HyperV stuff ontop?
>=20
> I can take all the patches if that's easier for you. I don't think
> anyone else is depending on the x86 patches in this series.
>=20
> Giving me an immutable branch works too.
>=20
> Thanks,
> Wei.
> > --
> > Regards/Gruss,
> >     Boris.

Hi Boris, Wei, any news on this?
