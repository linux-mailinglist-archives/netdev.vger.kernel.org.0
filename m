Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0647863438C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbiKVSWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbiKVSWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:22:52 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022025.outbound.protection.outlook.com [40.93.200.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865AEDE9E;
        Tue, 22 Nov 2022 10:22:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUncvLcxzH4ks6zOMwYKwOCzv5JNQeVTrCEmj71jbA9BqlcdsOD0+7F6gTJZjx8UadUBrdlqeYPjmI641mSkSWPC4V2L4pind9dyW92ER/CzDSHEyCCBmO6qqS/pwC1SW5ixIeQtrJwqfeF4OY52+7aLoCJSg69D+ekXs8FXI2gh/Fj/SJ64A/t9a2jzQJFeeiKC0Svf3T1zFKbRgwv2NlVeZmH9JwgxzDRZHLIL99NUC4BKJNIsuriVugrC9YmM04Zjlr5J2v3ZhOfq5/S6rilKSLgZKcGLngqwpu5xvVfWHTpm8AWLlROICvwRDQnECZkljrW/fc4i3F4dZZqpRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fEEQisAgbH7UlS0jYB6FIFUJHtuTTdkaZVcMFRu/xS0=;
 b=QCc9KRTRFColzNqkmfJy9UBoGBCdH6EN4Y4+D2YElmjSPox1XLp6PxiJfexwSdOO2wwf8+aYUwX6LPzJFx1qZJjTHGcsrkxT6Oy1Clc++ux6R2cdna13gTb+X4DZuPTDMg8LEi2BuPw3EW8Lz4ZqH5KigdyMyTn8UMioQbGvL2pMNXwk/UOKVoIp3TJPwN9q0HydWEqi7u1DcQKlkYtWO0IRvrNTfdVmx2hLKLryIO5N1Ag5ksiiRIXx/KKJu6DFfN+eoHxYP2E5HcUxbN3jg4bGpJ6quQYbcIYmniJIH/LCw/LflQGlWRSVoCnzU0lm4E8smSWe0ST0+gHukNA+WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEEQisAgbH7UlS0jYB6FIFUJHtuTTdkaZVcMFRu/xS0=;
 b=ZM1T3VWHXBOG7j1P7Nq4VyDPujHBRc69At0U3qSfpLmCLog+gTU805wJfWktqFXzvJXU/pTesxzGtOQM9GAkraR/7QQZr9K1UszkANuUwXQe6akbpivMbItktD4rbHSfDAc/r8r4QEzXxW1ykTH/CKNuQXb/dC7/Ae7CiXwHDxY=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MN0PR21MB3361.namprd21.prod.outlook.com (2603:10b6:208:381::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.8; Tue, 22 Nov
 2022 18:22:47 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%4]) with mapi id 15.20.5880.002; Tue, 22 Nov 2022
 18:22:47 +0000
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
Thread-Index: AQHY+es2O4adbWIH8UyWtCwRyUnUyq5JgOOAgAHDpcA=
Date:   Tue, 22 Nov 2022 18:22:46 +0000
Message-ID: <BYAPR21MB16886AF404739449CA467B1AD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
 <Y3uTK3rBV6eXSJnC@zn.tnic>
In-Reply-To: <Y3uTK3rBV6eXSJnC@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=eb4fe2b8-7043-4cc6-88fd-5a1cd8cde127;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-22T17:59:37Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MN0PR21MB3361:EE_
x-ms-office365-filtering-correlation-id: a2d72cfe-5ce3-49f8-ae00-08daccb68e52
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bpo0Z72+LcINVPfJAz4hcnt195sS0cxiYMKJyY1uf0Ywzd2FH6uKHGX2jSkWgAge8OVxvOIdy6wvVX564Z/xOCszY/1h1hLMgIV/Ug2XSfkFVn3OVzaUJHbVgOU66StJrstjOL8VPVBoRtHLsAWSmtPa9Mxq3i2dZFQCgU8YPw9dvFcfRTgIU/J6tEnAgFMOcU1F1b1EbSuP88lY4tl8NUZ0p65O3vhM0R2G4sKPVfKWno08QRhP1ld1zH+EvNBqo9GiJQc4zWatnitNxQYW5kFIAGi2GXK/qEhTeaennuK3LGUGZX/MimSe8KXGVMsJKCyql4ZZG9nP5YiFUck+bSiL/Q1YdjZ77jx1efZwXj6orxSmHHmM1bC2rhOkQKUD1gi29xmjd9PgdK/HFWxbKt8OJdKdkSCBGIj1IelmYCQOzgpINfAV0DNpvtifdoOL+BV0L3m2Iko/wdPUB533d+MIm9pJGC0/byKmKCD7TDQHy6munKOG7uQEA8WA1bEvt2StmmzpOdqKgWiBQ+AHtc4gakNzEg79g91rr3TMZNwdH8yF1Z0kv3VOKU+3vBLgV8ipVCSWNztnm9PBKJoV4vsaxILWtfsGhmwetG3QiPN11AVD/uKHnoizXd4hg/T5P197bU8l/rBGMbHSwNdJOZJtnaooI9JbW04iJndnK2cfAYCcrZmsi4Jl2Pze2CoLbasFPNUSAUOloP8i4kJYr/eJw0oq2hHwMnK0sQa1m4fgAFzWTNQA0qBwdi57oRrk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199015)(8990500004)(33656002)(66899015)(38070700005)(86362001)(2906002)(55016003)(7406005)(5660300002)(7416002)(83380400001)(26005)(186003)(82960400001)(82950400001)(38100700002)(122000001)(9686003)(10290500003)(71200400001)(6506007)(6916009)(66476007)(54906003)(66556008)(52536014)(41300700001)(316002)(66946007)(66446008)(8936002)(478600001)(76116006)(64756008)(4326008)(8676002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yjWBYxlk9itc1WzQ5NVjVz3heNxkIe5IySx62yej/Q5fTi1pTZ6jgCdQSwuL?=
 =?us-ascii?Q?sM2jncbKjtBmhyVxFXanUsrQJ6u5Qj95iN2s3w5fMmtBGLjVHOq4Arg7Nhl6?=
 =?us-ascii?Q?PFjHApi0h3jxdwxDZNPYi+Mbmu3ljisbSQOJKh6NxozaB5LvbvFY+XlEIyNs?=
 =?us-ascii?Q?2J9/JP1ku1RZ0lyS51o2sGWpqiT9ki1zkjCNgjvtdHT7r9SSRDHNCrAHqZFD?=
 =?us-ascii?Q?pQ+Pb73CbtX+SFvGcs4zjqFD594a3i+T8HkdNOhibsOUGcoIgF3exSCuaJZG?=
 =?us-ascii?Q?5kv/Xi2IMYdihjA6/wmYi6nHaueaqgcGEIfzS3SncC0yrilSSja9lsiwwZMH?=
 =?us-ascii?Q?yd7NNB3b8dXuu48Xpf1mH51S8y7klghs8lUifWfGXRjs60m3rdsyDi5jILmd?=
 =?us-ascii?Q?hd0Mjfn/RQRxbrmnu6EvLRjR8bo+RjnrVRJGttyqdzZFeZqdbCXKWJIuELKu?=
 =?us-ascii?Q?bV5zZtNZWtdMLKCRiRTFWTNqQYUKCY9djB+c3yY1eLnJMmgjV4QVAA/XNrII?=
 =?us-ascii?Q?wKVGioN0WBuaSFJFTwGVCf3DDJIxtCGhsywpQvHJbbJ2a49y89v4DNultx5/?=
 =?us-ascii?Q?z71YdvhlFUW6W5rCcfGsNr3Y3pZhRTIkJX/ZOE4anmsvc+CBQZjROdf1jwnP?=
 =?us-ascii?Q?PL9vUPl2yzPUgQK7WTtXRN42g3zRIS+4bT97vBf8M2qPbDLlvoQOCnsToQdR?=
 =?us-ascii?Q?ohOmPaGJSSIq3DkzsiTY5g9Ximj5pGuokbnuPl8kgf67M9l/wDGWJXXf2MVN?=
 =?us-ascii?Q?RaNXARbxOmOZudBXrpU2UUBVKTdQ92XrEPvRPeuBdX2Kn0Njv63oCneY913d?=
 =?us-ascii?Q?as/OEyJFiXD30hQe8HkAu/WsE98YDCpoAlw2IV54Kp1iPuTbGfiGU76FTyVR?=
 =?us-ascii?Q?ptJ8E3ebNcKAvGv6WkZQbXGFjAVnfD+XVbNrVikx4xb3bqQDMiX0/rwcSRp+?=
 =?us-ascii?Q?m1/VZQR8z1fykziVgngQt28ThL4fTKLsr+zyQThkBg3iqw36Gn4zOBHxtcT8?=
 =?us-ascii?Q?vTiajaUwCCrlhuQkTijLwZrOjX1pTBXbhmbdZVmftnby1NPxAYTCzXW5llU9?=
 =?us-ascii?Q?6YwuFp+/cqKScBsdWi6PELI+nFGhTGhzXBrl9c7jRAIs01E7VkBaonul4tDW?=
 =?us-ascii?Q?dWsoyS+NLrJA8wtxsxEKIdFWLytGbvRmnU0T9S0JuWNtYhICl5n/t/7JSl3Z?=
 =?us-ascii?Q?a2+muYbxGDPq/qUq7J9BYZaQVsIfCk/mU0bikdQfNhEqUwAI7EUO/m7xnvBW?=
 =?us-ascii?Q?1HCZkHs+AxmdSPBygP4KBqOrlWyS2qLl+v+DGxxxCE+HArkt+v7PGwgSirtB?=
 =?us-ascii?Q?P3PhHCWVseR1jktSMyil56K28ZRBPh4N8oBOUAymaQ5MBf0BaMBSRUQKZtD/?=
 =?us-ascii?Q?syFgZUWy2DE+oVEXeNJUcok7Fl8pz5BnKSHtxPhKN96dJn7P1JNAtEXHs8k1?=
 =?us-ascii?Q?yaiBPTc1U/62HXboVTcRTJFOEENMeQLVs0cTKLcieu2wbsL4EYsamTC1FgMC?=
 =?us-ascii?Q?ZNCtbNbtXNHGP9skWZMkah2wwlqtSUyJ9z+rCWsvIXx/C/MEqxBKi9mD1nZF?=
 =?us-ascii?Q?iTkTglrNiQZUEEuj+9tJ9tisEA1fHN8GfnZaPAxOywhrAMbh8U7JvuguSLGk?=
 =?us-ascii?Q?wg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d72cfe-5ce3-49f8-ae00-08daccb68e52
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 18:22:46.9775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bInvd3AFuRyPhamN1KmSYEB1mxnrLlBR4LDAEPYBT7eUZvFScHMNWZDs/SlJxTAyu3POiseqWsMNT3JBssW/iTo4+FqihXoGqxn//MdAcjk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3361
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Monday, November 21, 2022 7:03 A=
M
>=20
> On Wed, Nov 16, 2022 at 10:41:30AM -0800, Michael Kelley wrote:
> ...
>=20
> > @@ -108,6 +115,7 @@ u64 cc_mkenc(u64 val)
> >  	switch (vendor) {
> >  	case CC_VENDOR_AMD:
> >  		return val | cc_mask;
> > +	case CC_VENDOR_HYPERV:
> >  	case CC_VENDOR_INTEL:
> >  		return val & ~cc_mask;
> >  	default:
> > @@ -121,6 +129,7 @@ u64 cc_mkdec(u64 val)
> >  	switch (vendor) {
> >  	case CC_VENDOR_AMD:
> >  		return val & ~cc_mask;
> > +	case CC_VENDOR_HYPERV:
> >  	case CC_VENDOR_INTEL:
> >  		return val | cc_mask;
> >  	default:
>=20
> Uuuh, this needs a BIG FAT COMMENT.
>=20
> You're running on SNP and yet the enc/dec meaning is flipped. And that's
> because of vTOM.
>=20
> What happens if you have other types of SNP-based VMs on HyperV? The
> isolation VMs thing? Or is that the same?
>=20
> What happens when you do TDX guests with HyperV?
>=20
> This becomes wrong then.
>=20
> I think you need a more finer-grained check here in the sense of "is it
> a HyperV guest using a paravisor and vTOM is enabled" or so.
>=20
> Otherwise, I like the removal of the HyperV-specific checks ofc.
>=20

I think the core problem here is the naming and meaning of
CC_VENDOR_HYPERV. The name was created originally when the
Hyper-V vTOM handling code was a lot of special cases.   With the
changes in this patch series that make the vTOM functionality more
mainstream, the name would be better as CC_VENDOR_AMD_VTOM.
vTOM is part of the AMD SEV-SNP spec, and it's a different way of
doing the encryption from the "C-bit" based approach.  As much as
possible, I'm trying to not make it be Hyper-V specific, though currently
we have N=3D1 for hypervisors that offer the vTOM option, so it's a little
hard to generalize.

With the thinking oriented that way, a Linux guest on Hyper-V using
TDX will run with CC_VENDOR_INTEL.  A Linux guest on Hyper-V that
is fully enlightened to use the "C-bit" will run with CC_VENDOR_AMD.

Dexuan Cui just posted a patch set for initial TDX support on Hyper-V,
and I think that runs with CC_VENDOR_INTEL (Dexuan -- correct me if
I'm wrong about that -- I haven't reviewed your patches yet).  Tianyu Lan
has a patch set out for Hyper-V guests using the "C-bit".  That patch set
still uses CC_VENDOR_HYPERV.  Tianyu and I need to work through
whether his patch set can run with CC_VENDOR_AMD like everyone
else using the "C-bit" approach.

Yes, the polarity of the AMD vTOM bit matches the polarity of the
TDX GPA.SHARED bit, and is the opposite polarity of the AMD "C-bit".
I'll add a comment to that effect.

Anyway, that's where I think this should go. Does it make sense?
Other thoughts?

Michael
