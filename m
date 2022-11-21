Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4566F632E5D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiKUVCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiKUVCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:02:17 -0500
Received: from DM6PR05CU003-vft-obe.outbound.protection.outlook.com (mail-centralusazon11023017.outbound.protection.outlook.com [52.101.64.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACC8CEBAD;
        Mon, 21 Nov 2022 13:02:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDufm3Qz6gVKsJ6KGneWSK4UdiezMA50/gDy8GxBYBJJeWjoiszo/a7ylWYR8G46Ug26SPwKhNMkOo5rIbyq0w+gNAs8V8SUt3HluQpCpxQh453xGNkzCIYTeHmSUtOx22WrZX4lE9jrN4D0rIJfo1dRB3PXJNlpeYVNAeHl0cA/Y2glWa06CYaHH2LkOPek3w89LFut9UEWJo74Omquar53FTrOSqV+/gnHntKVgOFpHKvjQY+HAVoyR4wA5iVCmj5482ocJq2hrF3EMYvPnDPNyQQgm5CuLVWidjLP5qD6wvgorQZgLcym5NIc/fkqPCFRbQ81qaFNGSSf4NNLBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZNpHnw1fceO2VhRqoa/BuX739uPx6LJmuKB3BoBULE=;
 b=cV7hgwpf4LzQ8S3y8RtCtDKX9XSHuOQqkKx9JotmeKp/wC2mVahJvWQ9QCd32sKzsWAqiVmNTM/klZcFrcCNn/M4tIT5w9ibFRb2iu+hg9rwzNvyVk2gannxPpbx6QMcLCQwuRnHwWm73zWYPbFpVo7KT+xicaGF4cX5tpOo/R8MIV9nhVdntLmzgtR2bkJRRjn5UfUtBYhsvqJO4Du+oIqRGqphrUn/goqBnLKwiQlxHg1Ts7uNUWSNUyZ1MfJgHVt2kBDl4FFiT8bOb0ijMRpPxp43GXDq7cS3Vm2ekgSBVcb3n5kZ38HrTRZwGTwnU2/3eGYo3rTRb+3w8U4WMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZNpHnw1fceO2VhRqoa/BuX739uPx6LJmuKB3BoBULE=;
 b=Zgjm75tHPCXHKj7sKZXiQ5vSRBD3QQHZq54PuUQFbVlWctUS8RtrQp2vDZkjmjBOQ+YsGkvFyNfo3gOEqsGmDGTaqNyLw5qshZBs6b0E2qqhd6774HQ+nbciAmnSuREfgmn4EsLroeBX4x4sdwg4oUib2GAo7G2GaNhUwkXbNzY=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by LV2PR21MB3399.namprd21.prod.outlook.com (2603:10b6:408:17d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.1; Mon, 21 Nov
 2022 21:02:12 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%5]) with mapi id 15.20.5880.001; Mon, 21 Nov 2022
 21:02:11 +0000
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
Subject: RE: [Patch v3 01/14] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
Thread-Topic: [Patch v3 01/14] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
Thread-Index: AQHY+esrEByVeSYqBke7qvqW2Lryi65JZ64AgAAvazCAADiYAIAAFO9g
Date:   Mon, 21 Nov 2022 21:02:11 +0000
Message-ID: <BYAPR21MB1688B18DD7FC0AFEBB945F41D70A9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-2-git-send-email-mikelley@microsoft.com>
 <Y3t+BipyGPUV3q8F@zn.tnic>
 <BYAPR21MB168871875A5D58698273E914D70A9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y3vVRnAZmDCyQ3Wo@zn.tnic>
In-Reply-To: <Y3vVRnAZmDCyQ3Wo@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=47fe171c-a5e5-4cd6-ac4d-319bcfe7c996;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-21T21:00:05Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|LV2PR21MB3399:EE_
x-ms-office365-filtering-correlation-id: d0922e19-061c-4900-3a33-08dacc03a8d5
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 012BqO5Ft8oNhUQPcwjG9yDMr1UU+gtmMLehi95z9HrUDaoeOXuXP3fMVmHTT1xLIm1ty9WLcgGXFr1WnEFLySF1EktfbEkB7I0FJyGV869XROf22NHNNdGPxoTX9WSu4HSJUCSOjzPs3uR1TIVvHJfFCx025vIAbhM39OMC5YWT2zmv+QbIn6zkh6ttbnO17r22KujWgUO5zUu71IGsRBL3RQvK7FMf82eGcUQ/wXyGtZrE5lgt796QqjPYd+IVwSadjWjJOvIAmA0QRfRcxdpnFqBUK+XmdMk5YWDSWH2vAdYQl1a5qy29rFXb+wVV+7n1c/us6TV/AobStXx8HGgJbAS6m9NQFD1Cxb7dAab6dg8CWiBPAtsY3jeNHsKpVhjn4PrPZE2BKPGtODMVH9QkR6n21VOW03QnfSwPGa5ya/91E4kd5WmYmh2TP54aYbh1GrPC5GT9ONTB3HySpURELeTM+zaP2gCwV3ACEGJmtmc1+SE7WlL4SN8QaXIGIR0fkHcnC6j7RHl+CldgA0Uxvzoa/QwEJ8t0uVR64ihwsC0zvCDDyNGizMFlOfvJ68C9zQvdnHysCfcvso7dRIhD3NQMJzKlvVLhg72SxTSHKN1OiG+IcZhg/d8h5RUDEae82Q1rU9Yqj4S8GJwsU1urynF5YmRK6Mme2lCOLhmn0IcxlSKJhNeqXtvHhoKJxfhk1o25X4NPd98nM8x4uvX/EFlJnyohIaigMdxahEBSaxFXsPjntcl8tk2J+oGW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199015)(83380400001)(33656002)(2906002)(186003)(316002)(5660300002)(38070700005)(7416002)(7406005)(52536014)(82950400001)(82960400001)(55016003)(8936002)(71200400001)(4326008)(8676002)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(86362001)(122000001)(38100700002)(41300700001)(8990500004)(10290500003)(54906003)(6916009)(26005)(9686003)(7696005)(478600001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?D6UuYXFm2Xw4Hb9NMJKV+Oe+ZTywxLGN/dE3y25KKquDwhaZqSpZTmdMbNom?=
 =?us-ascii?Q?5iZplHhs+5uecD+1NKBv7XOovcUPq9EV250ofld7uImFiQvkNkVAg5+4OBCf?=
 =?us-ascii?Q?ipZsxkqC2FV8UHLZAtJ0g2SbLYZBIdAlbXno4erC6v9IaUoQjefAh0/KdFAY?=
 =?us-ascii?Q?KRaJyAHkKv/mhqWK6xUGSa+pGAvJ5nh6+MNPP2HSq4dZDt+cUsxKIyySGV9e?=
 =?us-ascii?Q?Fij0VRKhFy63liTLEOCTEgT908s2hp/Dtd4no/UFUtDo4ehebCcuI+RWBDii?=
 =?us-ascii?Q?O40VbBFWn37o2GvHbOYykPpSawwspAsCv8YVrPWyuuq5Ay/m+QPVqR1muxtF?=
 =?us-ascii?Q?WvSoEqMl/gTgFHdG4hb8mub6tHB/726FrzGvGmXxNlsPgszqzifi1URpcjWn?=
 =?us-ascii?Q?A7xdrIDXfk0Zs4CxW1Zikf0UjAUGxuwVqi3UYDSF8QBGXIs5i3nyKRtukkRJ?=
 =?us-ascii?Q?y+bSG8LFBC7NgJuTE3BII77qCtUQc4LHbD95aiD6XJzsar6nYtIMrcA83ave?=
 =?us-ascii?Q?YjuTrocz5Efje1NurhzQ2Ajkjt+HrY8U3DoHxilBdmw/gZfaq0V54rEyGNP0?=
 =?us-ascii?Q?wutcTYeAbKL+RTYEgONN25BuDDwss8YgPCsm8MDdf8VTloRPt7XvQOeP8rsg?=
 =?us-ascii?Q?0gvLHP4vb6N73MZzfx4mk55fq7heWbJpvjLX6E3XRFxnCOoPxfy9vIL9oiNw?=
 =?us-ascii?Q?vMZqXb7uNOHhVFEFUBfyZOV5HJJFKX2F1rObmuuVShwjMPiSQYu6A59WvBrZ?=
 =?us-ascii?Q?+G7AAWzeDPJ/lC1+YmLidaMJEdSgNo7BrZQrX0shtop3zm8GUKnjbpuAflCH?=
 =?us-ascii?Q?XXcVC9sZc7PTYQwyE4SvZblcRZju5KYhNrBpoJl/8c+Sn+fb8NzGhVbAZs++?=
 =?us-ascii?Q?iTFdYQfOeeeIfeJXmcSDuH7l342vVHMsW1G1hcG7ICQKJIMha+KqMZAOuOup?=
 =?us-ascii?Q?qM4XFFzMIZLQljNfpOamoNV8dWiblj4e3W2KagunnlffmMOGj2nZ3kHqoCBM?=
 =?us-ascii?Q?hw/E1TmEPz9Bp85FVVxP8fqHgRelBv3D69a3fBcGZqcK0yvBO05cnfkXzEgi?=
 =?us-ascii?Q?u30UZsB1SXj2RhSI+bDWeWuW2hzbpgMgPZrmfNV8oFzdvtfjFmkUK40drWjP?=
 =?us-ascii?Q?9IXEYDCcYgqkSPDASa4sg28zkPkupEwd0RvcQX1SPeNzk/dDd1jrwWQQExci?=
 =?us-ascii?Q?5i2q+pbnSix1fJTx8DqkRhCNQESOcda6wLjT42EgsGvbLCG0XOkmJ75kYZ0s?=
 =?us-ascii?Q?15IHRqaXT1sxkdw3vImBXN/FUGF0JuoP9qX6SPxx5/89thEq6hNm53DFe0JZ?=
 =?us-ascii?Q?FeeRB/Jl7tosQ8aWNxs7u8ydExF0Ex9HIjQ00BAoKfKd74OEXP6QPC83/a70?=
 =?us-ascii?Q?C5wTsDfMCKmo6hnMGRIUZYZcm2PP/Ji94RPDaHdeAUARMeHN3qLp8/Yd+GKE?=
 =?us-ascii?Q?TX0mNzivMTPXyVcvCKVmwYfVFppLvJkZvwDl6vkq+RhWMWxFz6TLCdLXouR2?=
 =?us-ascii?Q?URdO06sHP3aW+lD7ZpXssQdUR+/gbgSPmffBwUzmjlvJqW3vnHVkUp/hw359?=
 =?us-ascii?Q?MQTIEgE6nLnFSjxFP7WzMfW4RW7pCvQtfgeFf6wcLR+cyuPdZ68MvNyDiDjI?=
 =?us-ascii?Q?hw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0922e19-061c-4900-3a33-08dacc03a8d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 21:02:11.5236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GSgsiKap3thHoI5kriJ09AcCb54y3uSeklmgpx2bz0cm2GQo5CUeiC0Kkod4KbTPQYMX6sNC8QXJi5tnVxMa9LNH1rsadVqH3vXNqaJre60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3399
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Monday, November 21, 2022 11:45 =
AM
>=20
> On Mon, Nov 21, 2022 at 04:40:16PM +0000, Michael Kelley (LINUX) wrote:
> > As discussed in a parallel thread [1], the incorrect code here doesn't =
have
> > any real impact in already released Linux kernels.  It only affects the
> > transition that my patch series implements to change the way vTOM
> > is handled.
>=20
> Are you sure?
>=20
> PHYSICAL_PAGE_MASK is controlled by __PHYSICAL_MASK which is determined
> by CONFIG_DYNAMIC_PHYSICAL_MASK and __PHYSICAL_MASK_SHIFT which all
> differ depending on configurations and also dynamic.
>=20
> It is probably still ok, in probably all possible cases even though I
> wouldn't bet on it.
>=20
> And this fix is simple and all clear so lemme ask it differently: what
> would be any downsides in backporting it to stable, just in case?

None

>=20
> > I don't know what the tradeoffs are for backporting a fix that doesn't =
solve
> > a real problem vs. just letting it be.  Every backport carries some ove=
rhead
> > in the process
>=20
> Have you seen the deluge of stable fixes? :-)
>=20
> > and there's always a non-zero risk of breaking something.
>=20
> I don't see how this one would cause any breakage...
>=20
> > I've leaned away from adding the "Fixes:" tag in such cases. But if
> > it's better to go ahead and add the "Fixes:" tag for what's only a
> > theoretical problem, I'm OK with doing so.
>=20
> I think this is a good to have fix anyway as it is Obviously
> Correct(tm).
>=20
> Unless you have any reservations you haven't shared yet...
>=20

No reservations.   I'll add the "Fixes:" tag.

Michael
