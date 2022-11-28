Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A16C63AE3C
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 17:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiK1Q7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 11:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiK1Q7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 11:59:36 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2117.outbound.protection.outlook.com [40.107.92.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32E7221;
        Mon, 28 Nov 2022 08:59:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5wmV4TTv1IHEQbscLAViiEAdhISWwEyI7G3T8wYBi01GQQwCF0vNeVVxn9j1JrdzpmWvqFvkKvh6HKroU0/wOlv5ztluNqkvsh8iXXQi3KnCuY4SA0OdC/kfpIX1HXlrP6wdLRjJkrpphqLX/7kTzpfU8PZ2cXTI4ErNgvvStaKD/4RDNJwWHk+naaS6M1enWdEmWVdEiFltXALnkTRtNyOL5A3AdEXTlqIWwKKty/zp17oLgkyNXRbdKwajGRnJFlM0FgnTCTPi1IzVghYWC/aIzimh/Qco2GxgnyW1w8gPRoWAJpiQz9xv4DtVEAzBVUyJH3255OCoMU3TIJcWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2CGhaj39sGDdV2j7/KMluDll2Qz2xqfA707G5yV0C4=;
 b=b3GmTdJZF/9arQ/wtEEEAZFI6UDbNqPw5xKkUNnle1krfDXMk9hSX8QhEW4Hq29ZT0a46oEumMcRjSwr73XaLOrXA07EqFqQDD9w5QxsLtq2UkiU93OyGooCXelbLVsL02NE13fTkV+ZQfP+uBkWpN2P8H2UPJZqFjwdo6Mjw6ZuQUL/VVo8eSAQg99QZRIPdCI+uJUdWGbRmlWXNc9pEi36ZK7/MV7zrqFrVoMEglE5Xs0RTAS0NPSN2Twj6AaYx88zyFGHWiT3kZ951l0g1wS0UG5wQmnSAGPdUtNdikLawd8smnvs52tVpZZ64SMzK9/oEuDtBeb3JZwCfOMumQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2CGhaj39sGDdV2j7/KMluDll2Qz2xqfA707G5yV0C4=;
 b=YoxCsELRkLckFno0U4HvrQgFVjQL1rUB2opMRYiqq5r9JDOecf8lXd8cLvDsLBds/l+WoAFQOvxwVDq9aWBscseiRRnYJrZJ6ghpRKN00R78T/taw/f4fkpggS47V4TQrGv3P9OB/e6T7Phef+Mnhyu8iJnw4SfsKMTokObsyzM=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SJ1PR21MB3553.namprd21.prod.outlook.com (2603:10b6:a03:453::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.4; Mon, 28 Nov
 2022 16:59:27 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%6]) with mapi id 15.20.5880.008; Mon, 28 Nov 2022
 16:59:27 +0000
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
Thread-Index: AQHY+es2O4adbWIH8UyWtCwRyUnUyq5JgOOAgAHDpcCAAEhFgIAAJ7oQgAjDHRCAACLagIAAALfw
Date:   Mon, 28 Nov 2022 16:59:27 +0000
Message-ID: <BYAPR21MB1688466C7766148C6B3B4684D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
 <Y3uTK3rBV6eXSJnC@zn.tnic>
 <BYAPR21MB16886AF404739449CA467B1AD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y31Kqacbp9R5A1PF@zn.tnic>
 <BYAPR21MB16886FF8B35F51964A515CD5D70C9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <BYAPR21MB1688AF2F106CDC14E4F97DB4D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Ti4UTBRGmbi0hD@zn.tnic>
In-Reply-To: <Y4Ti4UTBRGmbi0hD@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4176f919-ddf7-4f49-89fb-37a83cc50a1e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-28T16:36:10Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SJ1PR21MB3553:EE_
x-ms-office365-filtering-correlation-id: 9e2fc197-a42f-4a8c-1286-08dad161e8d9
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LQ3tO71qrzcp/uoGrpS9FpuCZ6InOOcMW+qm5q/ObpKKyZU53qFt3Vv2U33KhU1abPYeMXSJ9xFNZqYJ/IMHFw5Oz5y2tMcWycPdyODAPzKMJR65cZQcgd9wiDeg8SByUKdPpOz/5cX2AE0lWg40k8hIcjcDxtqUw4wY1bNIOPsmFLpVM1uFhunuOGmdOKVGtCrdeRzecJTAO5w+kmg5BI5vcqC1jaHDNX4pwCJIjUHyyd2x/YqqGy1aPLP9s+/0jdZnfi/jkjY/7+5gzIqmYOpSwIO919YzVGmAqnJfheoioITRPpG9UGVeJDgmecZQQb99HFnCbwQNXBC8/wjYCDmBxjqjllQ4U+pJt8rtZrYU8W1hDbR8Av4dM28NMhY4gMWhQEY50VOr8o9w1E4BLC7kLGxUFymZ4SzeqBhnU0IEPGiimZjsPHmDOrmmv4k5s4oXMVxfLfkythbkIdzsGgu7on1FqPR8j/PXNC4Jr9gya8q8z1GlQT26BVvwstX5rS59tz1KJ0kXAlzn7K8SwYYVDrLBB31MTR/jVlMv40Oaz65vTQveKHgOeLGPpkVHmz0Q74mLNeSlz+GCXWkEtaqCQbx/4/G3Nn9k0K59ydbbgSfYFnznxGAsT8/XyaWhazb3NASDDDCHJpdcxJSgTfti2an4HFAJ3AS7Mk/l6Pl2c9QhvSBw/yA75wAfuJskWfgPHknZQN1CcmQvKMHGvs8Mk5iyL5HIhK90tqFKS/SlzckeikV9hzjJDhQYjORl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(451199015)(2906002)(8990500004)(82960400001)(82950400001)(4326008)(86362001)(52536014)(66946007)(76116006)(66446008)(66556008)(66476007)(64756008)(33656002)(5660300002)(41300700001)(8936002)(7406005)(8676002)(7416002)(38070700005)(316002)(54906003)(6916009)(55016003)(478600001)(38100700002)(83380400001)(6506007)(7696005)(26005)(122000001)(9686003)(186003)(10290500003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kx9GeKb6ewmwn8XNC8SNX9tjilAKnrfD65jpAynZ4OlSQVMmcdqNtSsj9u3P?=
 =?us-ascii?Q?PB/ztmfrXsPLILpmb3eLQ/VjeJkmJgVFd9EU7gjdGgtmK7+fYcUjjVbA7RdR?=
 =?us-ascii?Q?3ltSqA/xvPUTrBv1iAOo/B0yEHpY1QVIVybJqaCszCoJyRTwn9/5IGTlG9Rs?=
 =?us-ascii?Q?R66rTz1kWrLWTcrZJVFdtX4hGfgoNbdF389hReFkxxHMf9VbtRlOYhOSNjx2?=
 =?us-ascii?Q?Bogbw3l1euFMvpqsR3Z1MpKoGR6HED1CcxBg3in7GiT/nYs5V/ue9+bByKv5?=
 =?us-ascii?Q?21msfe1zWBLhLotialMJXkGdn6kkhmI0rlzcVpWt5LOamMV4Vz5TQQJePAo4?=
 =?us-ascii?Q?E0ilZvMuIjkoE/TmHJxH281VRhg6fnSLqEj1ED2ddD541BMQVDmG0726zcRl?=
 =?us-ascii?Q?MxXOEqkgzXSL/BCdcpj4n37wFETZHk98e3u01WCpRqBoE3eKGC2w7t5PAJ0e?=
 =?us-ascii?Q?6HOX+zuRhshS04l/71pSOKQj3NhhDocGLhRF8TNzOntElTw7QkgFDv+j1QUh?=
 =?us-ascii?Q?QWHDPqnS+lPXR1LQAE3zVKfya0G2ScUVo49wCvyegGnRuH7Jnpcef0QeW6oR?=
 =?us-ascii?Q?WwcDMvcdkPrNtl260qewLfb6Pvt7fdTgnJJqw1ewsqHLyQtuU0qhpKcmTM1z?=
 =?us-ascii?Q?YF5//3oVQ2kPCE/NeQiZNhfCPIYzCUIGZH6dRtE32PqqJsJNZE1RIPMv6Q/E?=
 =?us-ascii?Q?ztSVYSV18vU9/Ft/8XzauQd4WnMXBcSm5UZQNSwuCervz2o+Nf5ddOZ58yZZ?=
 =?us-ascii?Q?q9ec5FRRlXKZ7StzcCuvGf3flgXWILt8WdTuOHeh5RgYWKE/R/G1mIJwi5xm?=
 =?us-ascii?Q?jJnCSMvEZrxQWM7CcZ8RoZE41ehzyMvpN8BtiB/6qc//3aq+HICtACcGMwGx?=
 =?us-ascii?Q?WiAXc1WfyuALikB5Ds5tQh1zrWt6jftg+wFI42kWXqp2aJFZeO1qC2Wxq0L0?=
 =?us-ascii?Q?fRWw3B6Y4eae4fdXRuJJ45EXLejaYPcF2ApH4ZAowm4o0CkRj6eXO4J6Ykii?=
 =?us-ascii?Q?2nPiQ2nECzuJgNjyynxsIdo4UwPFZom34Rwl1bMs73T7jPiJJ+pROyzP5bEr?=
 =?us-ascii?Q?DUk23SzVPtCxRvuaXb266sglD6TxTdxc+eAbN4mQVyfS2iVXDOz2zSTzdHoR?=
 =?us-ascii?Q?YcO33Tf5E9bYsUIn68kEtr3bX8sqbbZL2Xcl6XV4ucLtPUctik6CxsCWJdsW?=
 =?us-ascii?Q?S+nXj0T2uPtpEtqgvPZP1YC9KwHV0UjqwuV3z93hxbiNXVlFXh+1VUy0K8Pt?=
 =?us-ascii?Q?x012t8OJ45DkggthprqQNfDAx09CTfbdkoruSYxTgujiOzh2wE9BS3AXkvlv?=
 =?us-ascii?Q?uPRNKto8lE50zVUAXA5/6jb/CMKM72KBZQM17jaswUUdzkaquoBI+liXlxS6?=
 =?us-ascii?Q?QwYOqp5OtbF1hxo7J4yZF3dsb/LH3cFpbGslm/ODfcvclt8O2Vibv9TBFILj?=
 =?us-ascii?Q?zg6NKBQWIb5Y3IRqiDOaPEG4TE1vEpoEzSXEv37QbrTK0DuJjhS0n66jHPoK?=
 =?us-ascii?Q?BcmPg8UQds6LjvkY1ajK937/U8NlkL67Zb9Korny50NAMv+b6OXAPp/gvaF8?=
 =?us-ascii?Q?709OBoymEPDkd6m3L9wCTW3mxG3rcgsjNb8GfK61y7RdetdeMqfDtzHXHf9e?=
 =?us-ascii?Q?SA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e2fc197-a42f-4a8c-1286-08dad161e8d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 16:59:27.4294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RaQmnIrdvU7ksnUDrqTx3lDCUlE+AX73NeLcBXtPPMbvUqYA5Z3HonZfTrnM41eMXH7zDX9IdXBvxd70+de3Xy/bTXYr5YBmpKwtm/Wyg+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3553
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Monday, November 28, 2022 8:34 A=
M
>=20
> On Mon, Nov 28, 2022 at 02:38:11PM +0000, Michael Kelley (LINUX) wrote:
> > Any further comment on this patch?  I think we're agreement.  For
> > this patch series I propose to change the symbol "CC_VENDOR_HYPERV"
> > to "CC_VENDOR_AMD_VTOM" and the function name
> > hyperv_cc_platform_has() to amd_vtom_cc_platform_has().
>=20
> That doesn't sound optimal to me.
>=20
> So, let's clarify things first: those Isolation VMs - are they going to
> be the paravisors?

No.  The paravisor exists in another layer (VMPL 0 in the AMD vTOM
architecture) that isn't visible to the Linux guest.  The paravisor is
a separate code base that isn't currently open source.  All code
in this patch series is code that runs in the Linux guest.

From an encryption standpoint, the Linux guest sees the following:

1) Guest memory is encrypted by default
2) The Linux guest must set the vTOM flag in a PTE to access a page
as unencrypted.
3) The Linux guest must explicitly notify the hypervisor to change a
page from private (encrypted) to shared (decrypted), and vice versa.

>=20
> I don't see any other option because the unmodified guest must be some
> old windoze....

What Windows guests do isn't really relevant.  Again, the code in this patc=
h
series all runs directly in the Linux guest, not the paravisor.  And the Li=
nux
guest isn't unmodified.  We've added changes to understand vTOM and
the need to communicate with the hypervisor about page changes
between private and shared.  But there are other changes for a fully
enlightened guest that we don't have to make when using AMD vTOM,
because the paravisor transparently (to the guest -- Linux or Windows)
handles those issues.

>=20
> So, if they're going to be that, then I guess this should be called
>=20
> 	CC_ATTR_PARAVISOR
>=20
> to denote that it is a thin layer of virt gunk between an unmodified
> guest and a hypervisor.

No, the code is this patch series is not that at all.  It's not code that i=
s
part of the paravisor.  It's Linux guest code that understands it is runnin=
g
in an environment where AMD vTOM is the encryption scheme, which is
different from the AMD C-bit encryption scheme.

>=20
> And if TDX wants to do that too later, then they can use that flag too.
>=20

Again, no.  What I have proposed as CC_VENDOR_AMD_VTOM is
specific to AMD's virtual-Top-of-Memory architecture.  The TDX
architecture doesn't really have a way to use a paravisor.

To summarize, the code in this patch series is about a 3rd encryption
scheme that is used by the guest.  It is completely parallel to the AMD
C-bit encryption scheme and the Intel TDX encryption scheme.   With
the AMD vTOM scheme, there is a paravisor that transparently emulates
some things for the guest so there are fewer code changes needed in the
guest, but this patch series is not about that paravisor code.

Michael
