Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE0D658F03
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiL2QZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbiL2QZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:25:22 -0500
Received: from MW2PR02CU001-vft-obe.outbound.protection.outlook.com (mail-westus2azon11022026.outbound.protection.outlook.com [52.101.48.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DE413EB7;
        Thu, 29 Dec 2022 08:25:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7HDFs5jr/awpktY58I2b+pqQBVLnpTxBbyarP2QQJOxbzy4uI7SPaoQf6N4P0C9VdNd6iKN52O2Dcw2cAs9nRWVusFGdZP4J5CKWuJxvk+tjgnsSc2oVHf7BPhXnUL3FncI8K3a0s6JsaUiOdaWod5j5rPKM2jNIZdzsES7cDfgKdua/+BV49697bgZ852twFAiJmzP4HDmfNYz7XYobRMDP57ClbdK6ZeozXW83P6oCd/AhyOjpg5zKHqwTIvwj00MimfwJ7MNIda2GxWqhVKerLTCUFyq1enrCRheKLeuJ6+VCUO5EXs08vAAbCj6m6ULeCapk/xS2VReitJ9gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zaeQZIA1zl/ZQc0FJjOxS7Mzz9xOdQZb7dUVyPtNQvk=;
 b=Qdx2IyLvZtOxaCCnupL0ntZtrHPfnDRjRjY0/HYtlkEkYxcrRYtdrUSlIQPl6rxTCFRk7+cXsvUnvROUMcsCgRnxnTCs0K/Toruxm8HZFy7NNsu/TsdN34jyiSZF2Cm8jb2+A1pZjq+bwxErfiFFi4DGRnXQx3Tqx1SuujKTScHhJPCCupXQg0UZGKm+0pqm/6PQN5Y1RwYFW2pyyoY8VlZf9FZNQbsyS3OYLvmm9umC4htTcRhsMQPWMBKkkI9WIGcJ25PWw83eBWIyQTDwrcDetsneFzyDUPV1AlilhvsY5QTHF8/UHMtW2ZCXjFx9gA7Pg9zXejX/pQ65hfH6KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zaeQZIA1zl/ZQc0FJjOxS7Mzz9xOdQZb7dUVyPtNQvk=;
 b=YTEeWaYlO2EVgoRXOdyXARrPXYgtr8Hyt9CgwVvKQs4KAJ2B0JORJvIuC5aMBY2rAyBSENSeKe6VXKty1I3MLTJqyY4Si9e3ViyHiGTndl2URxdBCGrIzf9uogN4yhZNGbFlzEbb45aTA82cBAcfU+Jfx4YTZx9XIqHLii97FOs=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by BL1PR21MB3355.namprd21.prod.outlook.com (2603:10b6:208:39f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.7; Thu, 29 Dec
 2022 16:25:17 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::db1a:4e71:c688:b7b1]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::db1a:4e71:c688:b7b1%7]) with mapi id 15.20.5986.007; Thu, 29 Dec 2022
 16:25:16 +0000
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
Subject: RE: [Patch v4 04/13] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Thread-Topic: [Patch v4 04/13] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Thread-Index: AQHZBf6qXxv12SnI/0WwIL+HXSylNa6E8yMAgAA/XSA=
Date:   Thu, 29 Dec 2022 16:25:16 +0000
Message-ID: <BYAPR21MB16884038F7EE406322181C58D7F39@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <1669951831-4180-5-git-send-email-mikelley@microsoft.com>
 <Y62FbJ1rZ6TVUgml@zn.tnic>
In-Reply-To: <Y62FbJ1rZ6TVUgml@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=05d70819-cd30-4435-acaa-8b6d27fe6b05;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-12-29T16:04:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|BL1PR21MB3355:EE_
x-ms-office365-filtering-correlation-id: 08c797d6-59b8-4123-4791-08dae9b9450e
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0nkRmpapAP/9R+4a6SBXjK83bIX+GX1Tat6nbf4/KuQpAmv1MZp4GtG7a3Iu9YqO6xfiyIx0G2SeQqaLmXfvK29UYIW9aoFm6Kt4GsMdEHeK5938bvueMBNvT6AdfLkliFeAkR35QX86cgyk7ZUvnZciI5M7oPpTLfyYVZTEdmSp/c7ka7M+0xua11qks9pvHSURprYpAt077qrrlLroGasQqQtc0xesOmRs4DSsQ5GAx8HzoXjaGNInlnTBwT6UBro7XRD8phs2ru3WaLAvqsZvGiS9f4wZ8SI9qSCLUdJAP2PwNkIw5Rj+8KxnTb503TP9LQXfcrzMksIKhSkw+vHWtEQPF9SCrXtvU9gs+t7cG7wBXn2tY/oytwM90dgEwIaML4dlUd6D4eu+yRalvWkq0JG14BMP7/z3iML131H4bXM7rixzdLwCG3iw9oUxkkURObiOmdWI+4pWOG0Sm2aSkm3Yrjzj9s1piPMD5q2r29YPf3mGuWLSmxbOfNlLmVv6vM+kR16J00wY5vAmtOsi9LSrBuq3V+iK/P/9PoHXwFmgxYeRd64OxWrVBKr4i8KCvUHf5vfIE6a2xJesNnkUzLMSUdi3J/jaPUVIKlFSePSpJXOTz3zSABHZ23pIxOxPBjKNKyV2Aa8wGKRAE9oMAcxKh9QnfJVaGEzg9J95wgHTxIzrBVsB9Y/ez7K2s2nynoNE4N+x946FSsM1PdBOyJglB+Bm1O3UQL8bQ0obOtJMgaN+M4h73+40gxr6GaNtG/zuUfXUoPRDDQ5Yl4MW2ZNjXXg5lIM8MAYuEVvUAU4D5tNk+NK13aIcodWj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199015)(7416002)(2906002)(54906003)(10290500003)(6916009)(33656002)(7406005)(316002)(38070700005)(478600001)(966005)(82950400001)(9686003)(186003)(26005)(6506007)(122000001)(38100700002)(82960400001)(7696005)(71200400001)(55016003)(86362001)(64756008)(8676002)(66446008)(66476007)(66556008)(4326008)(8936002)(52536014)(41300700001)(8990500004)(76116006)(5660300002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8iqGPqiULrH4mNKxv+mRyeRW5T4uL3bPXO3r08ZjZl+ozduWpokW3CQzFf3y?=
 =?us-ascii?Q?kkuE5qtdd5QRMG2LVGFc8L0kabIcCmdw1vxR4PKNQO4ZV3uOgzvJQAx35gvF?=
 =?us-ascii?Q?LJ5RoRPSB3uswcb8ZsORrKak+8UxzLUwjIh6Q+kuCXVKBupitXoCfFpjHgFh?=
 =?us-ascii?Q?8PFeDhHKCkLZcZikoCXhiszVvPKGBFoVh9bfATPDvMTzhTzK3SAenou69I+F?=
 =?us-ascii?Q?mWI6z23eZk9KdJVTt499NqbZB9DGZFy7Y2GD8ZFhq6N9Lyf4nC73r8c6G96S?=
 =?us-ascii?Q?1zAx4H5DiUnaxGhWFB4QlUJonmCpW5OYngqnsa8B+JV1w4iUdQ50s38TuhGz?=
 =?us-ascii?Q?zjdCjwuqk3r3VWbV1Z+NJNEwW9qZDjDmlbhECIwptFn4ZsxJm4qM0xSOEnMK?=
 =?us-ascii?Q?byTksoaOo9z7ihGjnSXXcVweJ5o9LPOo1U/QPMF1nLopW9ypuRm52RvDYlaw?=
 =?us-ascii?Q?MKVWEs19L/xeQxH+YPqYmWS94jLcHffhu+pQWeoKZYhLdJ7Uzf2GCGR40G0d?=
 =?us-ascii?Q?dfMuoVJhffLOaqIkRKBjBnoFnez9/4QNRnpIs7ZcY1DWKkAKPmLFjOvQ2jtX?=
 =?us-ascii?Q?zeyhvV0TWtSBwCmZDbBGYH0/jew05j3dB94IHGvMAUYeSnoz9uayAlVM+Gid?=
 =?us-ascii?Q?TH9OgnxTQWnHwpc/wE2vktv9u45wdcDQgNuMXhYGXkiY8l6yBZzTBKmz9qxi?=
 =?us-ascii?Q?+P9FPCFOPiQ0MVkiZmg1bOxq14oE9GABYo5lH8bxrbKZMfiueye6Olmb8fUX?=
 =?us-ascii?Q?np/YK1TrvINdRXOCepfHWoad7Ii6iBVKGAbeynrVBy1SzcVtlBkTucpzpXpT?=
 =?us-ascii?Q?w7aXt8HU/g04DHDoDAWa5fyVFruA6M+8QNams4pMluCzkwZMp5zXliO3lPI4?=
 =?us-ascii?Q?7jlI9OpG86M0ppQ9zcshqNwwqOS0D7ibGz5YRJS61MGI5Ju0yY9WOD+9Htdc?=
 =?us-ascii?Q?eOWBw7Q4WsbDyf7ytuLKxbeJf4J5LJx+PB49ys/40nEJ+9PCWUNM0VnxATkj?=
 =?us-ascii?Q?3l/wuQ+SvPhgiqQC+DeMFJKTvHqIsP2nwUIMh0Hvpf+fg6rtallXqM+kBhKy?=
 =?us-ascii?Q?1q6M8gXdOHgDUH845SAHY8GYIfotbTo3a003UekEW0JAMCchxyPCQus0mdCY?=
 =?us-ascii?Q?cCni79fHss1QZUVL8A4fqNFxrhZ1ifnp0ccGiFHQegRxIm6QGDCU0BMwQTlF?=
 =?us-ascii?Q?nFyXxdZveannmVGnp03l7OJlJpWbRpS8RLO/ARc1eOqkyPst3D42WCNDLZkJ?=
 =?us-ascii?Q?O9mPeCN1CrWiHoRlFsp1A95RnZG/rlXplVl5mrHV8GAMk15LFaEtiLRJ1I8N?=
 =?us-ascii?Q?6hTXsHyF8Ga2RgHPfcSmC7rsTrP7XjxVC1P+KnAn9bGfr1I9rQXVFoUsRw4X?=
 =?us-ascii?Q?dcF0NCwldgtLmKxAUcBo5nMlIwQxtBNbVKP8nblGQvBxyXbU4KSvmK4uwuj3?=
 =?us-ascii?Q?L7HjHyq2xRt6FuH4aBOG/ef7OnKWbStr0JXxJ3QRIbVT77Z4p+fDlHIlQuEK?=
 =?us-ascii?Q?1lDRiysIXqNSPWTmWsz5j3uAwzY5y+S+fr2HZMTFgow4wpDMaiYbyVlpRkY5?=
 =?us-ascii?Q?Rt8rGsSUdm71XnPjrQCS9evL2M776MhMTlSQN8GLkRarZ4QMGPqEwhp7eOxZ?=
 =?us-ascii?Q?Bw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c797d6-59b8-4123-4791-08dae9b9450e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2022 16:25:16.2975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ERmIITzF1+DsbHy66+laiCVWrUnjR/Uy8ESccwh+bT7cNA8HvFb0jO/ZP9927b/K5sh5apphKmZ61my3rzhBhOzrIbsFHwDJQxLYf6fxhNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3355
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Thursday, December 29, 2022 4:18=
 AM
>=20
> On Thu, Dec 01, 2022 at 07:30:22PM -0800, Michael Kelley wrote:
> > Current code in sme_postprocess_startup() decrypts the bss_decrypted
> > section when sme_me_mask is non-zero.  But code in
> > mem_encrypt_free_decrypted_mem() re-encrypts the unused portion based
> > on CC_ATTR_MEM_ENCRYPT.  In a Hyper-V guest VM using vTOM, these
> > conditions are not equivalent as sme_me_mask is always zero when
> > using vTOM.  Consequently, mem_encrypt_free_decrypted_mem() attempts
> > to re-encrypt memory that was never decrypted.
> >
> > Fix this in mem_encrypt_free_decrypted_mem() by conditioning the
> > re-encryption on the same test for non-zero sme_me_mask.  Hyper-V
> > guests using vTOM don't need the bss_decrypted section to be
> > decrypted, so skipping the decryption/re-encryption doesn't cause
> > a problem.
>=20
> Lemme simplify the formulations a bit:
>=20
> "sme_postprocess_startup() decrypts the bss_decrypted ection when me_mask
> sme_is non-zero.
>=20
> mem_encrypt_free_decrypted_mem() re-encrypts the unused portion based on
> CC_ATTR_MEM_ENCRYPT.
>=20
> In a Hyper-V guest VM using vTOM, these conditions are not equivalent
> as sme_me_mask is always zero when using vTOM. Consequently,
> mem_encrypt_free_decrypted_mem() attempts to re-encrypt memory that was
> never decrypted.
>=20
> So check sme_me_mask in mem_encrypt_free_decrypted_mem() too.
>=20
> Hyper-V guests using vTOM don't need the bss_decrypted section to be
> decrypted, so skipping the decryption/re-encryption doesn't cause a
> problem."

Work for me.  I'll pick up the new wording in v5.

>=20
> > Fixes: e9d1d2bb75b2 ("treewide: Replace the use of mem_encrypt_active()=
 with
> cc_platform_has()")
>=20
> So when you say Fixes - this is an issue only for vTOM-using VMs and
> before yours, there were none. And yours needs more enablement than just
> this patch.
>=20
> So does this one really need to be backported to stable@?
>=20
> I'm asking because there's AI which will pick it up based on this Fixes
> tag up but that AI is still not that smart to replace us all. :-)
>=20

I'm ambivalent on the backport to stable.  One might argue that older
kernel versions are conceptually wrong in using different conditions for
the decryption and re-encryption.  But as you said, they aren't broken
from a practical standpoint because sme_me_mask and
CC_ATTR_MEM_ENCRYPT are equivalent prior to my patch set.  However,
the email thread with Sathyanarayanan Kuppuswamy, Tom Lendacky,
and Dexuan Cui concluded that a Fixes: tag is appropriate.   See
https://lore.kernel.org/lkml/fbf2cdcc-4ff7-b466-a6af-7a147f3bc94d@amd.com/
and
https://lore.kernel.org/lkml/BYAPR21MB1688A31ED795ED1B5ACB6D26D7099@BYAPR21=
MB1688.namprd21.prod.outlook.com/

Michael
