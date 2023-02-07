Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6953F68E171
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 20:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbjBGTsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 14:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjBGTsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 14:48:11 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021021.outbound.protection.outlook.com [52.101.57.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DEA22016;
        Tue,  7 Feb 2023 11:48:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dR8VhauMsEf8hH33fJl4SMSudjzBEZ6j8e5+NTwalmjb0BNasvTa949mH9UvowAq67PL0R4wfH2uzyGAnFNdVh/jAyH67/KXlqhvTF+SM+tFSqbmDjtUmxY7eqQFQ19gwIrc8z0AwItouiVXVJrIOZjXURjudQOsnUBKTrllx59CGchCYyy/+qOmlqe5Sxxhr03n1sbvtJTrj9FLQ9OcIYyXAZuBPPCEtFYdYb5UwQEnk1L7S34MhP2CdqutvIYHq2tu7L0Md69NTr04f269pazczYihTHFQT3aMiOx53noVyNh0y3QHkNYCxVC44Eye7rIMEacfVETZsw54xag63w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trHQTW68aFqGFKPycJercF34RXNMX7lCzs1j04/gGT4=;
 b=EUUKDDTPjK0FvYOwQQ0OBjxd4vXjqSt1ODVSjVoKTJ42PlgHz0dgxbzhDc1N5mPYFw/cJ3NK98c0v3BTXMvWePezNcPc8pJFVgNLiTiMjczYA8LmiwwSz339GIj4aD6nVHwfgkx0WWCmx+KGlPgVE3SbvpZ92j7ruRTSkKDLHusoN2yx35ssybktQzFW8x0YxprowdrMWLtnlyARacozf8Fx11I5v8c/UoI/dIxpe+rttXi6wdy/EujHSIykg3WATSFlhk610X3CVVt3gv49oExNT2B4E5hhLKvxL7LjIWRIgpe6Upjv5BQKFY5+oB0ys+D8E770oiTMkQymuZhwUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trHQTW68aFqGFKPycJercF34RXNMX7lCzs1j04/gGT4=;
 b=IJWT8vPCtLVsGf1QQMlws3HN+JwFmxquXlyWDo6odvwi6/yLXEtee3zxp4Qq7cblhYSQrVZe+DHOAoO8gJome6iYmBAYNKXOdF8C1HQgZ6LcUU8ZfG8O9oT2GksMHbQJxap0/4mcKBxreXE0oTCprveWIRzm/YazgWU5KrVutMA=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DS7PR21MB3340.namprd21.prod.outlook.com (2603:10b6:8:7f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.1; Tue, 7 Feb
 2023 19:48:07 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf%8]) with mapi id 15.20.6111.002; Tue, 7 Feb 2023
 19:48:06 +0000
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
        "seanjc@google.com" <seanjc@google.com>,
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
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAGgMUIAACvuAgAACa5A=
Date:   Tue, 7 Feb 2023 19:48:06 +0000
Message-ID: <BYAPR21MB1688608129815E4F90B9CAA3D7DB9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
 <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
 <Y8r2TjW/R3jymmqT@zn.tnic>
 <BYAPR21MB168897DBA98E91B72B4087E1D7CA9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y9FC7Dpzr5Uge/Mi@zn.tnic>
 <BYAPR21MB16883BB6178DDEEA10FD1F1CD7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+JG9+zdSwZlz6FU@zn.tnic>
 <BYAPR21MB1688A80B91CC4957D938191ED7DB9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+KndbrS1/1i0IFd@zn.tnic>
In-Reply-To: <Y+KndbrS1/1i0IFd@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=28683558-a762-444d-ade7-bb3e7b108450;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-07T19:41:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DS7PR21MB3340:EE_
x-ms-office365-filtering-correlation-id: 8f75a37d-7287-4f45-add6-08db09443bb7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WoFmhY8FCTC66rX3mpaI51n4OvPdN4jLg18lUvaSMrcy27rwNGvwTvor1ofzZpB1Z0Judxe4Ba/nyY6w1d1eizOlV73tmhC+8SiXI0rASJj6p03t1asItdcYS25G3b7a1bSho4P6NZDE6VDnAqia7duGOAUiLkZyVhDYEfyK5EWAN3RbwrqKhtsq5k6+PWmoSmmH3BnrgxWn3a0H6rqio1TsHGVpwPIDOvT6aSr0GHZptYXZkTGwpIWmm2s/Q8stdmwgLx872nlO/+Fo6TryWvOGHKMe7uUVVPnXec+Y4ULQ7UFBVmmwzdyzvxuniNsGE/CN5BWQwCtFu7Fv0BWSWTchQlHwGbP8MCiDbvNGEBXDkAxv9QXhWopuk7K46wVkEqwnabW51mo49sggicmP1i7aFW+p/ry5nFw+zu8UEg823xHY1N9ZFU/QN2APMOBNsxuQlbs0eqA06QLhJJm3UyIHozeRntci+31i2NT06kDOH1MAW7/nD4ohdPxn8BYb1sJXja4efSMuGDns0mSZzOm4GbzlNpE8PBKsal2tkcaf3NKhRVaEqAh6uUw0zSfsHskKCP8L2G70Y37QQHiRoTaBGQlBshM+SA6LU9+7PVmjGMpwkp5/+lNmLQmSIdCbV0+yetGZtw8g1YXrSam/Nfn9SF3cssMGyjyq9AfMRB8wL63nM55M46FsWb7+Bw61lwGbYN/pXeJwc6/N0gDnTbPX5tT0y3djY1X7t/kG08LrdFJGVAbNq9DyFWDj/SOJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199018)(66556008)(71200400001)(38070700005)(86362001)(64756008)(8676002)(6916009)(66946007)(66446008)(66476007)(38100700002)(82950400001)(4326008)(10290500003)(33656002)(41300700001)(76116006)(82960400001)(122000001)(316002)(54906003)(7406005)(8936002)(55016003)(4744005)(7416002)(5660300002)(52536014)(9686003)(26005)(7696005)(186003)(6506007)(2906002)(478600001)(8990500004)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Kwy3YVmQFDkyzzrxuOxWnrYpNaJ1weKGZttfuA+LglXOkcLAyDNt3agrJrRt?=
 =?us-ascii?Q?aHXxJtp1kGSHlRcMHm5JRvo6J0R8SrZQQHBf/da1aNe+ahkdgwLCQQYdrS05?=
 =?us-ascii?Q?il+qi/bNZoVz8lcO3Olji0MiNVdRPUt+zypTU+gwC/a/11rsmXFmu/qSsdsH?=
 =?us-ascii?Q?PQ/hdaDIvBznE5WHbqMofq5WULidzs1jtp/SweDH0LmB+dR+Zl5RfKBk8Zxm?=
 =?us-ascii?Q?eETDjPJhRYwPMl6gO3KoYE0UR1yTW/XNuY5oy8QeD9sh7Y2Cl/2GXW1LXZ+i?=
 =?us-ascii?Q?+GskgsyZnSYyO8JKdPzunKKpeIQyrieA0e7HyGczlo3uFDn6U8IaqcnNmUVo?=
 =?us-ascii?Q?zGKwrh9kDwOkoX12NmePT1rSp2IKeOzXvvOP1GWgyGTj9czQEPvT60S3OLhd?=
 =?us-ascii?Q?QAT311Uc1lSwcMWfChIAqiRgWKcoDg0IlTi5X/yNWE+9f/FQakOCnIDee7s+?=
 =?us-ascii?Q?JkNRW6nL3Gn8RZnb5eBuDmd9bh5EEQJaArF2mxZ/U2DKV7lttNgfllk3WL4B?=
 =?us-ascii?Q?IRVhLwT90sNczVoQL95VFMhYeXfH6moAr+wFLPGoPQGUVweKtTr1FatLKi2h?=
 =?us-ascii?Q?wvbhZ9R4bi5YjvuCrKVkPxqb9dv6Yz1jpDyR903nIkNcFGuKw0f8R6Ka2Sfj?=
 =?us-ascii?Q?N56M/XcT6w8P/5E4XtQpjoJ7t/z8NAHjkncCXHDYZyY523rYH465h6xwXmxC?=
 =?us-ascii?Q?e9iEKwvmt2ALE1dLUPCGsmAR6ZIkzVFfB7UDqaLZV0DJdzwC/5x9uEetn186?=
 =?us-ascii?Q?F630umPDcGTL/1mCVUPI7qgDrL200+26YWpA/sJ6gcKEWdeFD2mmeIYXzrff?=
 =?us-ascii?Q?omx8giaPsWp/iige6jsUEw+0boNETGE6EJeSetNRuyNhbeTitQtIy88+h7eN?=
 =?us-ascii?Q?9q3it60eyj+TYYS4PyxVk23XfgsS60BlQ877u8liIiEUfMZr3ffyP4DXvv6d?=
 =?us-ascii?Q?DINGoUn4K0aUP9JFcsQsNBn75H1DXPMxA5OM5mIyS9vxjgdnnupRi258yPHp?=
 =?us-ascii?Q?OFa5iPxlk6ZC8Y32i7Er+LEdQcti1ockFi1Zk/nvMnKh4zLsOXX0dgpYq1wZ?=
 =?us-ascii?Q?C7zfygIZR+xn4igcJjxPHILjwpuYK8X8KGu/FLpQ2i9jsCldYRh+m9CKZ1qy?=
 =?us-ascii?Q?JtpDyAi3YsdIx0Tru1nukSyYwFh27AWLchMla/BJHWVEUfZ9JFLVtogamdvZ?=
 =?us-ascii?Q?NMMybsl+RD+L9J6IkFxZrnE4zQBHgDz09uZj7GyEVexmgbzwpjb/t3ZBbawQ?=
 =?us-ascii?Q?KtNEexxbYj+lO+PJLmHRLrNtt82n8gKEGI4OB3laxnoycRLmQVC5YY1nMF4Q?=
 =?us-ascii?Q?f5tgJQnRkdLqdeogAuFSSA0/Hk4iNKc1KsbAugW0OitICEoTLOqoLkqR00hE?=
 =?us-ascii?Q?zWvU0YI/KhPGeibVdnjDjug+VvvjFd0jqM4WV4O9KqvWfUHrVN4KbLVzCJpC?=
 =?us-ascii?Q?vkGSxuonvOFEq2JSKcxXhxS25YuIzQGRRsh18gdqgtd41lHsdpm5TWzsvqsi?=
 =?us-ascii?Q?783Y+1O9OkBQs9DhYxIZfJD2g6u31eOnsdV9AGxDYiC1HqowjCbjOEWkFiwy?=
 =?us-ascii?Q?wFWh5Dr8WMuVwk1sRF3gpm7OYU5u21tJQgfY3IGt+Y3sko0z165wUW1dXUo3?=
 =?us-ascii?Q?mg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f75a37d-7287-4f45-add6-08db09443bb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 19:48:06.7220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l5/YH+Mnf/3uJxDockhbTPCV9bMYJ+tBnb/F4SBlc+QiQw7nXW16lp4Qq4mtinisQGbGXGZUn+7Mxp/v4EYrmf8Fwj0JYv4A+RT4XlV17gY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3340
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Tuesday, February 7, 2023 11:33 =
AM
>=20
> On Tue, Feb 07, 2023 at 07:01:25PM +0000, Michael Kelley (LINUX) wrote:
> > Unless there are objections, I'll go with CC_ATTR_PARAVISOR_DEVICES,
>=20
> What does "DEVICES" mean in this context?
>=20
> You need to think about !virt people too who are already confused by the
> word "paravisor". :-)
>=20

Maybe I misunderstood your previous comment about "Either 1".   We can
avoid "PARAVISOR" entirely by going with two attributes:

CC_ATTR_ACCESS_IOAPIC_ENCRYPTED
CC_ATTR_ACCESS_TPM_ENCRYPTED

These are much more specific, and relatively short, and having two allows
decoupling the handling of the IO-APIC and TPM.  Combining into the single

CC_ATTR_ACCESS_IOAPIC_AND_TPM_ENCRYPTED

also works but is longer.

Capturing the full meaning in the string names is probably impossible.
Referring to the comment for the definition will be required for a full
understanding.

Michael



