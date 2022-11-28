Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F2163B0D7
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiK1SNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbiK1SNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:13:20 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2123.outbound.protection.outlook.com [40.107.223.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191B661776;
        Mon, 28 Nov 2022 09:55:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyijFl4DCJlx1X9yJ1a9lqUCV87VQtxADMA1Opi2PrjbnGEWeXFzSWfuQpigGWbzMAypwcnhiWhQMM+847Y8E4K7Jiis4gUv/QW42Ht77Zb9bRqYP50jEDnwa9VtaHEuVvbcc7cmapP7LGVQCNV5DvYfrnbJyGyYCVc3ewzYQlxYXaKGWGaLC1U/u3FqUHKV7scadpwCwjm62aQHlQuPub2dRp9ot4LNYbxw7K5g1w2B55F2uv7otxV+tkBOepXFrhWUUBpyS3U2mTGlAOBI4p+5fTYFyHA4YXu4VDNgRLds/HOjRF3sPHT3SHZoi61c/4PvlidXhRvk0dQARy0Mzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZt157AVu0UU8Xii48dq5NXW5NR2Rrm7ClkH8MI0fkw=;
 b=Zei0ggoI0GBLG/KWm/xCzQ4cZnB40qAn83VfwM3itHy09sfIa+3zwcIWEM9W51yNZJusgaDGiatO8PepOOnWZkl/vHRGsPu4nAwIkBMmmaqwjc4Ha732sSBG9M54nCHCouV8EELI/8/dUalYwCTRgSHEDebzIUeR9G84SNMnuzYyk5TEn90ZWpaFH1tdSpM3yOvhPVFryFAKZcl1iFTwBRKV7HZiA7vFnkIxKoOgei78Zgd9XsJ+ntfpzb9xtTai7lK0oWJJ9eZjM7rbp/JMwII99UfpxXWRLekSpY3NjkiFKfrfIoE6Y28SLhh4AsfYA3iSCMIaiMa7vbm1Zkc/Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZt157AVu0UU8Xii48dq5NXW5NR2Rrm7ClkH8MI0fkw=;
 b=XJgFFw+BfXUTOWAPmpKiebwr7awXGXizGyF+WSQsBMTOuQHn0AMsafg6BLHALa9Zj71mou3Oy7VoO+Y2OqmrPqKOClm8cJvUTnkcgd2mXX0YPObZLQicEo55YlV9N67m+B8dmw7cSXIkQMgTaOAYGh8dND9+4Gl6IuLv04nl9us=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by IA1PR21MB3401.namprd21.prod.outlook.com (2603:10b6:208:3e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Mon, 28 Nov
 2022 17:55:11 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%6]) with mapi id 15.20.5880.008; Mon, 28 Nov 2022
 17:55:11 +0000
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
Thread-Index: AQHY+es2O4adbWIH8UyWtCwRyUnUyq5JgOOAgAHDpcCAAEhFgIAAJ7oQgAjDHRCAACLagIAAALfwgAANigCAAAHQEA==
Date:   Mon, 28 Nov 2022 17:55:11 +0000
Message-ID: <BYAPR21MB1688BCC5DF4636DBF4DEA525D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
 <Y3uTK3rBV6eXSJnC@zn.tnic>
 <BYAPR21MB16886AF404739449CA467B1AD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y31Kqacbp9R5A1PF@zn.tnic>
 <BYAPR21MB16886FF8B35F51964A515CD5D70C9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <BYAPR21MB1688AF2F106CDC14E4F97DB4D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Ti4UTBRGmbi0hD@zn.tnic>
 <BYAPR21MB1688466C7766148C6B3B4684D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Tu1tx6E1CfnrJi@zn.tnic>
In-Reply-To: <Y4Tu1tx6E1CfnrJi@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9b9758f3-9d09-4647-8da9-ef2639e3b5bd;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-28T17:31:07Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|IA1PR21MB3401:EE_
x-ms-office365-filtering-correlation-id: 77eca875-7ea3-4d5e-a8c5-08dad169b1c9
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gVPmxIKOJS/TQRaopT8JnlLUqTM+szRqRjOUhJI2Sbp8/dKs5LbEycKTVR3hGGuxAA8QLAN2XdiY0lPIxZtpxjLdScrrqMznsSOLjZOWdaM3MVhUn5b8FMM6gDfi18TeTqw2FtueSPQbzWo4ks7ik9Ct/I/uc/3vOoqXXKLjdgrRRKbCxyEcdI2McUvQpPoM/qErs9c2hjMNDWlO47b3SY4K8PaAG1rqm23CI4+blRJ9b74KKHGzN86QF2wKoeVnkGM5mXUJ21pJ9e2Fcws3+qzVlF/kjGkYhMrezAjAaNWGgZtfOcFyRc7xmsiGdjgFzquapc4sm05lvcXPLvA80v8X+uJ6saHDsj1DyS/AduHYuPnHfwWa2r2OaN39f9WDR5qhU/nWTqAbw5IjRFwlIS1n/8M9p4nVv5JcYLQmxdruYQacZ8TNUrk5T2HlVjZbF++EgmgM294CkGextZTi4W8ulgKRVRQ2v5iAAL9yQWA/GPCyCIBHzNrXNNWmKpxkNLz6pPWPB3HRIQ5Q3etHQlwrmyPSSEYlrPfmmvhVsp5AQyzGZ1cAlJErf8YF+FVEnc9kot8vFHxEeHOi2d1+YTHpf3lAt5RI/Vw6e2qwyJbwkfE3qNQ1klAjuE01vHdSjurzrB04f0fu25J+U2+HHlbyHspcn+o2NzfUSCeI8o/Ozbe1DfIon+dF7/FEuIB+Gi4XMyIUnv89thtEVyHxnvByqZ9xjRcahQjm6+KJmTrThN/0L+keTB8tc26EHqHevQmJk6Sw0pNxKS+gJEHYX/awA8d6/ahOP67hEDiKfdtXrBr/DfZKD7jtnG7hQv3Z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199015)(5660300002)(7406005)(7416002)(41300700001)(52536014)(8936002)(66899015)(4326008)(66476007)(64756008)(66446008)(66556008)(8676002)(966005)(54906003)(6916009)(8990500004)(71200400001)(10290500003)(76116006)(316002)(478600001)(66946007)(2906002)(86362001)(7696005)(9686003)(6506007)(26005)(33656002)(38070700005)(186003)(83380400001)(38100700002)(82960400001)(82950400001)(122000001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N/MShVtR8njTthfFNMCdqawvkp80ynmJWNYthUn7H3Ni6t84oPTKRAcPU3Ev?=
 =?us-ascii?Q?2WCoRS+rxZWcO3oJsiFm394zOmWRyKKQkB8wwfOhF9g3/Nu/lG5bMngIbrbo?=
 =?us-ascii?Q?dcTIElFhp9ffmQ5NBNfwYHykDQEbzCCXf0G5p0nNOgurgEEer5g11wiE5vja?=
 =?us-ascii?Q?N+zOHHEc8r9VHgwTS+oWbv7W4tWNrUx/pUmrZIkWNpIc1Fw2NULCa11mNN5+?=
 =?us-ascii?Q?zq7aimufZyudtj2y/ekhK+D6R/hnuBlZ5CPOD0xwVTO3SRlKmivuD8cE8JdJ?=
 =?us-ascii?Q?OGqLtoV7hKcI4/0q16ZyT5lDm8RMJC5JvYS5mSfwX2wXeb491vYHuzIu/tPn?=
 =?us-ascii?Q?5bzNKMhVESspjT+aU5sP873nbVNMrC73ORZ57iKmiJh0b6rDPPo+IhN+42FW?=
 =?us-ascii?Q?emrLVvGCaWk8jaNJg4Zltbz9CV/tSbZa+6m54EkzbXKU6C0lfhpCYx1jtXGD?=
 =?us-ascii?Q?XT8rQiXiITGFuPdEscj1mepwy5sf958BhAVRqu/ryXfmD5OU+eaHTUHUtLRd?=
 =?us-ascii?Q?f4RxH+FJ3bW2I84vq+YqovBJ+WwoOLCMsMMkV08S2/0g9qlNxalRhbonI9FL?=
 =?us-ascii?Q?AyJoagYc0oSLaynNVAD2qb/rjwW4JxqOkPlBXE7Hi8O4Bnl06vzod8azNHYE?=
 =?us-ascii?Q?XzQZdv9pk7JPzrR0D2lJ4zfhxjUGTaDRihhqiz2H6mix3+3i6AWIfpbe9/jX?=
 =?us-ascii?Q?zzq0XpdxtIQl0er8nVBoi7D3gy3SJccJ8t0E6qDWYRXXCff81OFp33yE8vDi?=
 =?us-ascii?Q?Tw5QUKtrU+Ox6MIk4TGSAQA6ZLzqTn4ZTP4mqgbdbJY62SGHBlMZ1GJWcl44?=
 =?us-ascii?Q?XbMa6T2e85viT8AD/BVhyjc3YvWoyU9to0xo2jz5+xZUuHBpVFIVl/JN5eIp?=
 =?us-ascii?Q?jTLIZ0t2vzkUp9RjUAgOLHjWdQPGiGY8ZwAdjcSgwn9Drxuaj4WLbTrmT3ua?=
 =?us-ascii?Q?Dij3XQTttreGsF+Y+ov54dKKwIqK2pmqmBbPhOhB8l9wEnyVDg/FYAGVQPSn?=
 =?us-ascii?Q?5Lkt8dHWFRIaRrEmA08jCqqwjhyJ1UrSC5s+e8AbxTqdOos6AENLrWmzvH/L?=
 =?us-ascii?Q?1a12iAr7kMdfF3/OUal0YRGY4P39qFF/Y+cZjhX1xHXiTcXkv2/26AJ7v1s8?=
 =?us-ascii?Q?O/1/NOto1XxkqojMrevctd4MOw9uSWRoxo8DvT0znA9S6zUI4teTIJ9iJnM+?=
 =?us-ascii?Q?nJ1q7h/E8b7KslN6YP8rDHP662Sz1EHthCGcWO0pqWJE/9NXFkSIFHqKtFIZ?=
 =?us-ascii?Q?VYEGh1syxb2o7nEvUlEyj2Bhw08GW4F+PMEnVmbgyJAIW9WdGihzz/j9kPOj?=
 =?us-ascii?Q?mWtSbsr9fbZ5y/4lViidaQqrHCcCFsShVzbFaxY4KfGqvs1GCYuS835S3vrM?=
 =?us-ascii?Q?skbYJee5Qte3pouLmE3YguO2h4U/Aoql+n0VbEqvffijo1tC3zPE6EOHURri?=
 =?us-ascii?Q?4xANcjb5UOIKSSoPiWW1jaD/a2OJ/uFB0OoOLihuKYUxuNUDNHyDVWp7yZCK?=
 =?us-ascii?Q?1C57dOPg7wplRoDUXjWdDcbrvftOrNKz8XU8FOPLuCjwePxDvnX3soAfuMYu?=
 =?us-ascii?Q?Fc71qZzw7AsAPIrraYkwFC2xabZ8nBrbgoLkIagKvPlL/D2WI/IN6DSOPg52?=
 =?us-ascii?Q?KQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77eca875-7ea3-4d5e-a8c5-08dad169b1c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 17:55:11.0744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hYxU3hQD6A86w9ouE1FqdeZe6tQHqmB5x5D+IpEcQOcE9e/C6IyVz9Wv2CzgGodLxOZN8H0+YAEmzXMwjQ2/RDmFSgBSE+ngCdyrhn5Lvpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3401
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Monday, November 28, 2022 9:25 A=
M
>=20
> On Mon, Nov 28, 2022 at 04:59:27PM +0000, Michael Kelley (LINUX) wrote:
> > 2) The Linux guest must set the vTOM flag in a PTE to access a page
> > as unencrypted.
>=20
> What exactly do you call the "vTOM flag in the PTE"?
>=20
> I see this here:
>=20
> "When bit 1 (vTOM) of SEV_FEATURES is set in the VMSA of an SNP-active
> VM, the VIRTUAL_TOM field is used to determine the C-bit for data
> accesses instead of the guest page table contents. All data accesses
> below VIRTUAL_TOM are accessed with an effective C-bit of 1 and all
> addresses at or above VIRTUAL_TOM are accessed with an effective C-bit
> of 0."
>=20
> Now you say
>=20
> "vTOM is the dividing line where the uppermost bit of the physical
> address space is set; e.g., with 47 bits of guest physical address
> space, vTOM is 0x40000000000 (bit 46 is set)."
>=20
> So on your guests, is VIRTUAL_TOM =3D=3D 0x400000000000?
>=20
> Btw, that 0x4000.. does not have bit 46 set but bit 42. Bit 46 set is
>=20
> 	0x400000000000
>=20
> which means one more '0' at the end.

Yeah, looks like I dropped a '0' in my comment text.  Will fix.

>=20
> So before we discuss this further, let's agree on the basics first.
>=20
> > What Windows guests do isn't really relevant.  Again, the code in this =
patch
> > series all runs directly in the Linux guest, not the paravisor.  And th=
e Linux
> > guest isn't unmodified.  We've added changes to understand vTOM and
> > the need to communicate with the hypervisor about page changes
> > between private and shared.  But there are other changes for a fully
> > enlightened guest that we don't have to make when using AMD vTOM,
> > because the paravisor transparently (to the guest -- Linux or Windows)
> > handles those issues.
>=20
> So this is some other type of guest you wanna run.
>=20
> Where is the documentation of that thing?
>=20
> I'd like to know what exactly it is going to use in the kernel.

Standard Linux is the guest.  It's fully functional for running general
Purpose workloads that want "confidential computing" where guest
memory is encrypted and the data in the guest is not visible to the
host hypervisor.  It's a standard Linux kernel.  I'm not sure what you
mean by "some other type of guest".

>=20
> > Again, no.  What I have proposed as CC_VENDOR_AMD_VTOM is
>=20
> There's no vendor AMD_VTOM!
>=20
> We did the vendor thing to denote Intel or AMD wrt to confidential
> computing.

But vendor AMD effectively offers two different encryption schemes that
could be seen by the guest VM.  The hypervisor chooses which scheme a
particular guest will see.  Hyper-V has chosen to present the vTOM scheme
to guest VMs, including normal Linux and Windows guests, that have been
modestly updated to understand vTOM.

>=20
> Now you're coming up with something special. It can't be HYPERV because
> Hyper-V does other types of confidential solutions too, apparently.

In the future, Hyper-V may also choose to present original AMD C-bit scheme
in some guest VMs, depending on the use case.  And it will present the Inte=
l
TDX scheme when running on that hardware.

>=20
> Now before this goes any further I'd like for "something special" to be
> defined properly and not just be a one-off Hyper-V thing.
>=20
> > specific to AMD's virtual-Top-of-Memory architecture.  The TDX
> > architecture doesn't really have a way to use a paravisor.
> >
> > To summarize, the code in this patch series is about a 3rd encryption
> > scheme that is used by the guest.
>=20
> Yes, can that third thing be used by other hypervisors or is this
> Hyper-V special?

This third thing is part of the AMD SEV-SNP architecture and could be used
by any hypervisor.

>=20
> > It is completely parallel to the AMD C-bit encryption scheme and
> > the Intel TDX encryption scheme. With the AMD vTOM scheme, there is
> > a paravisor that transparently emulates some things for the guest
> > so there are fewer code changes needed in the guest, but this patch
> > series is not about that paravisor code.
>=20
> Would other hypervisors want to support such a scheme?
>=20
> Is this architecture documented somewhere? If so, where?

The AMD vTOM scheme is documented in the AMD SEV-SNP
architecture specs.

>=20
> What would it mean for the kernel to support it.

The Linux kernel running as a guest already supports it, at least when
running on Hyper-V.   The code went into the 5.15 kernel [1][2] about
a year ago.  But that code is more Hyper-V specific than is desirable.=20
This patch set makes the AMD vTOM support more parallel to the Intel
TDX and AMD C-bit support.

To my knowledge, KVM does not support the AMD vTOM scheme.
Someone from AMD may have a better sense whether adding that
support is likely in the future.

[1] https://lore.kernel.org/all/20211025122116.264793-1-ltykernel@gmail.com=
/
[2] https://lore.kernel.org/all/20211213071407.314309-1-ltykernel@gmail.com=
/

Michael
