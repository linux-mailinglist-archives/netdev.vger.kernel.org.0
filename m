Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72322658EBB
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiL2QCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiL2QCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:02:41 -0500
Received: from DM4PR02CU001-vft-obe.outbound.protection.outlook.com (mail-centralusazon11022021.outbound.protection.outlook.com [52.101.63.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BF1105;
        Thu, 29 Dec 2022 08:02:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+qYX0T5biM5sdMxqMDMgnZq7C9yaM0wPN0Gtsh9ZX0qst6CYo6KgPO3cP1ubRjGzwDKVMGAG4LfejTGqvr27SSZpDrzhTalYSp42xpmUKR++uMuwZwEFuggzZbm4Ts/laLUHV8IUm2PX0lT2gfi56zoFjpCxJQc73x54CGuaIF0kcjnKn/TzVSaYFvvWGtbOEmZiXHUDrLe0y/4bkW5mKJR8fK7Lq+Xi5YromeJdxOdbyK2SKxjJGGYzaZ0UZgdMOUN1VakwMZfSiv1JOga1A9RT2srxiPzbFNV1NWM5WNvqTWWs6GO0Abfw6y7VVHmPaHbCK6Z03IVkcPVjmhOlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F3xblPf/xPRA4QkhTNhWoPPQH2sdQTsvux/iRz5pmjY=;
 b=Ew9ELRnEs1k/iAiC6lSfm6zVsqqDPzRIrVC6gz40Co9mZB7OJfAmys/nsI3eCnQrnaWHQk6selMPE9+WnVkt7X7U7hUyNj06xjHDqrlnz2ovbje2b5lYBs762QyW45NISNq/wDNMG5jNlK2GL+bmDbdX6yGFcqOoiS/Ql27QesnaDfoXmQP6ELearPJVrnPiS8LLC9f6wwKgXjXFRDEUIJmfQQHLuLIflZyvtTudy+RjYxtQ7puahOl27cwiBI7MeeP2rU42VMwiokrdiCKWr7F0YyPawN0456IUgCiv6+C7Z8032PrYyTOSqLun7j39ux1LzPptPXQBJRTQKmpeCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3xblPf/xPRA4QkhTNhWoPPQH2sdQTsvux/iRz5pmjY=;
 b=OWiWyy2pKk8Dxmte6mwxezP6D2BDI0qd/5sFVXQANDEJg+f7ep8o4mXjAF3lledrXuSpOaUCABQ8tlyAHOKNWpBp0ggfoyGMBYWvJSFmAY9D4xNi5/CDUatTbak07sgFMXBO2toalEYe6gOgM/TBa17u3zb0K6sfl3qTlk6zWjQ=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DS7PR21MB3341.namprd21.prod.outlook.com (2603:10b6:8:80::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.7; Thu, 29 Dec
 2022 16:02:30 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::db1a:4e71:c688:b7b1]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::db1a:4e71:c688:b7b1%7]) with mapi id 15.20.5986.007; Thu, 29 Dec 2022
 16:02:29 +0000
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
Thread-Index: AQHZBf6m1tvwNL7mx0Ck5dxxQ1BDw65hREcAgAAIgaCAI5uKgIAASOVg
Date:   Thu, 29 Dec 2022 16:02:28 +0000
Message-ID: <BYAPR21MB16888C40CD4A3E25A897FC51D7F39@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <1669951831-4180-2-git-send-email-mikelley@microsoft.com>
 <Y4+WjB/asSvxXW/t@zn.tnic>
 <BYAPR21MB16882C3F39AB321A53BA4129D71B9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y618Wf6tAVpXo/qm@zn.tnic>
In-Reply-To: <Y618Wf6tAVpXo/qm@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d4cb4b59-a671-4cca-993c-6b4b82388ad3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-12-29T15:59:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DS7PR21MB3341:EE_
x-ms-office365-filtering-correlation-id: 832b6a92-4ba5-4993-ccfe-08dae9b61614
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: voLrYCWuFgmV36YMdtNv/BmVj/dCPzkTq2t1OqaMrZFDol4zsnWNdpawfOOqs1+K9fAu6d0+cbhcKHRu1X6YZqDt4ua0Q1hHVsh/fBEqEGcod0MxtL3rLWmvSvs4kghQPXGzVZQzzLiFGJtZcOVUN4P7CyEHvYfzulNA8rY3trh/F6HdghT4tOWsjLB18HVJBYO7H+8Ne6WM3Exm0AMpVc3hxCHm70eaVMEhjjV3EeZB7m6SZ4azNk9xaXtqU/fT4I+w3OhpjrF/A3Nder8/7qoUnR9LYmMnalRtOe5dn9yvAgu+s1Xinw1PNiitDQGE7Y+xnr27BEakNH39OHm11ip8wYBgZHxu9Bno8Ea2Xr73oZ4Io6xTcFRI7B/TQEJz8GLn+QfH4y/aBIOspAQQcP0Kw/GbnTZaY40epuXIrXQzK6lU/dbIO90l7nIWx6CDbP2VTZ/0TizhggGdbEKTgwR6aVmMXWcWk0ZbIBTC6a/ajQgnbPSTrpPtJ60Gy7kcmRZlo7GNvyysZ6M6894iLzENJF1/5BbeFRXmFk6LwYZOYkX9Gswfh0YjZGg10zxS0OIEwbpXsDuF3Ld+vLIh2/noe8K7pyu5YKxc/0sYpNbneMeV54P98QgTk0jcDo0gyUgw/lOSjaS6zdFvkedC1AjpMgVY0JnaFbyg9/m015osvdNsIQEAiUqNRy7gfywT38lKP1JjXwHYGW6M7TBjgeKwH+kIUCeFBPLYnHqM0ul19uoSEcMnFWYJk8ser7Tf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199015)(82960400001)(38100700002)(122000001)(82950400001)(33656002)(38070700005)(66556008)(64756008)(86362001)(66476007)(76116006)(66946007)(41300700001)(66446008)(8676002)(4326008)(54906003)(6916009)(10290500003)(55016003)(8990500004)(316002)(2906002)(5660300002)(52536014)(8936002)(7416002)(4744005)(9686003)(83380400001)(7406005)(478600001)(71200400001)(6506007)(26005)(186003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PBHdM61V+Yf1AyuR0YeMWELJh64G7KlC3H8U0DEMRp8b/3kW4BSrrlitO+YL?=
 =?us-ascii?Q?x7eUpeHNrsNDrmkNuuYjRa4sDjSmsOQByit6CagZUPby99c7snEYJIsSkuU+?=
 =?us-ascii?Q?qC6rwJRyIC+D8OoqR/urac6qloBo4iIItX1Xc7z78SqfJHskzxdVfIEurRGH?=
 =?us-ascii?Q?MIm6dbF/48h8B778/531UNKpJXRyACubDsk7uVGsWy88R3Hex3k/bANJaAsn?=
 =?us-ascii?Q?oLEXTV+I1Qyun8dfFQwLOK4W+cvVhkxfmKsg8wtXBhfGSfhOlurm4qTNkXSA?=
 =?us-ascii?Q?pkvP5yL8sEY6PcrvnaeZIFItuiwezutB3j1WjiXPYTLaI6wHei4X5ZxCsacE?=
 =?us-ascii?Q?hUkfi4TN64J4952sMNI7DiXtm/kWCH+EPilRd9iZl/eJHSrGmTKjlnRHFAqz?=
 =?us-ascii?Q?t/Isvjws214TjDdrizVuVtuFdaaIbKIUrevgMDuFmWjO9JYvRZ5zDKhZ9Od2?=
 =?us-ascii?Q?bTk6fhiU6vvDXKrxwY/U2V9AbS0SAp2Oo0Le73WVwaT6KCMvnS/0HKBL39xF?=
 =?us-ascii?Q?NBfKf//4gp4jgGxW/vFYvYiamznLT6hJb3Ftf1tcP6algVAzfMMuCCP43XPX?=
 =?us-ascii?Q?RBq97pke5Ai7x/DwKhsw0e8wXK+owz7/+xg4fo3VYmxKKZWfxGN0iBb+R/Qc?=
 =?us-ascii?Q?ARTbTs6C+hPfaj1JZkzvqNs67pqk/nWwGEp41RWiiL47F9OrGwjDYe/6rvzU?=
 =?us-ascii?Q?y3c3vJK28TKK7OqQNKfSgkv5JOTrXJFkF+AOZLrvSiFrVB+fapSwYwza7lJU?=
 =?us-ascii?Q?uWrmOidOW3Xl7HOt5K1i6EuA698Orcis6wVJmcwgZl8IfgOVmJtb86PKQagg?=
 =?us-ascii?Q?zvDZClOqenmZK2u9n0n2T5zgfIi5I9hQX4XtdxvNinHLVyg97jsvS+CoN8v5?=
 =?us-ascii?Q?NndCgsF88quHb5kAOxRH/XHrl70+M4hKzK1u2nvqeF4vLnksfuNnNGUFtlko?=
 =?us-ascii?Q?IqBq0RJ6OGexmumvxYdb81+qZkVsXdDo29BZIepquTEkARWOdfbKHm0gAKWK?=
 =?us-ascii?Q?RAm4/H6afdwmaMmnUUGtiyyxJ02Qf9MUubmi7enr3pNlBrVgG6SPPgzWEP3h?=
 =?us-ascii?Q?AJtX+Wy3WcT3suCG1bgN1vQTtu2uFLy/u6JV/uYOFq5S5khkbAiTtZ0SOpt3?=
 =?us-ascii?Q?Mdb6RASiqW4zcfgyLnzH3HZAZydrQqENxk7b9WqLLdTR0WoFy+weKdjHfqRq?=
 =?us-ascii?Q?YpmPDNLe+UvAItscCj9Mxhq8GGX+XZsESyI1eHYifVj2J229pImvKUFH0506?=
 =?us-ascii?Q?i8aUD4LDOQY+h/SikRhxHgHXJsmn0crZjUP7isVmGcc1dRXLWyoL7ezMVyiX?=
 =?us-ascii?Q?UmpExpz17FdI6tef2yqE29InVPWt7Ha1+rgspYYbtMbRb2m5PMOs+zW14kY3?=
 =?us-ascii?Q?vc4znr/twevts7g79pweuH86VIULBquFbT+pxjcwmh1gFqZj28Fbx0usWO1r?=
 =?us-ascii?Q?ph2gEde3BGXfkIDMa6BMM8brAfIq73NWiWfuPJH/2x6hmiCgwlEZllvDZAzX?=
 =?us-ascii?Q?mZLxC3b/2qYmU4C934OzBZHSISki0VLOOqyk08dQ3zPStq8DnW6U7wD5tgQS?=
 =?us-ascii?Q?yzaCbmxbRUZbyQ88genbKZVhHtVXSvzbJOINwLlrVFO9ThMfW5qd/3s8JgVI?=
 =?us-ascii?Q?8A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 832b6a92-4ba5-4993-ccfe-08dae9b61614
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2022 16:02:28.9659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RYK0MFx9m8ztT3QRgQ/+4Xct8fNgfoklGmnkmZBqtN6xTOrOGTOJlseOfuGpLIm+d7Um0Ips2t0NbklPt7KF37ynYYM28MpLv2CqTN7beA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3341
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Thursday, December 29, 2022 3:39=
 AM
>=20
> On Tue, Dec 06, 2022 at 07:54:02PM +0000, Michael Kelley (LINUX) wrote:
> > Exactly correct.
>=20
> Ok, thanks.
>=20
> Let's put that in the commit message and get rid of the "subsequent
> patch" wording as patch order in git is ambiguous.
>=20
> IOW, something like this:
>=20
>     Current code always maps the IO-APIC as shared (decrypted) in a
>     confidential VM. But Hyper-V guest VMs on AMD SEV-SNP with vTOM enabl=
ed
>     use a paravisor running in VMPL0 to emulate the IO-APIC.
>=20
>     In such a case, the IO-APIC must be accessed as private (encrypted)
>     because the paravisor emulates the IO-APIC in the lower half of the v=
TOM
>     where all accesses must be encrypted.
>=20
>     Add a new CC attribute which determines how the IO-APIC MMIO mapping
>     should be established depending on the platform the kernel is running=
 on
>     as a guest.
>
=20
Works for me.  I'll adopt this wording in v5.

Michael
