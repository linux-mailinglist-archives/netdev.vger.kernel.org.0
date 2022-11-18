Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5152C62EC05
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 03:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbiKRCio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 21:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiKRCim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 21:38:42 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022022.outbound.protection.outlook.com [52.101.53.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9438A5654F;
        Thu, 17 Nov 2022 18:38:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=he0qQqTUrbh6IZj04vIcoM62l1uwC2DaUiH4Fyc4Jph9QqSjsoQ43MP43K9z6SBvYN7i8yKEU8k0TYusv7maARn77VadiTJOxfAcrwoCiNH6eKTmyS6EHMf8QAXD8XHitL1JA+C/LFar0exmoITdX+2tLPwNUspfeHQu0DqaOQgnha7dnWvBwMJGMucVM7gtGufKcHZ5dJfR0G2o8OtRs+3h7FJ3+dYv0cbrInfvbJbVuHtSY92OkSzFXk0AYR6ecarw1akOwO2SdQaCDTOY7hhrSI8X6oun4FYGc+lz6O6pdoFEl89rvZ49b52NZ2xZkN3i0KFJUFj6V+JTyC+hrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2gfMW8ZH9IBILwVNuN77Ad+r5kOwsiKMN66VFi2LRkQ=;
 b=S6JRypr9fJMXwmCcCxJ3cx3vNdDDM6BRZECU0/Fzat+Y+oOkdgbCZ+LalLA0wBw7Q4q6mfB0P328LKYJcvk26RltDF2exPMBrBUT8y2JRfAyJjLWmtY29elhwfDEWBjRaWScPOEDQX6SV7IO7tLoCMBMqnFfUth3ldT8dHhmiLoJbauH5O17mJ+BIvxVJne1TI5I20fO5QaAczIXB3ogOm52RcMB/mBHkV8rT/B7p4GiGerOk0rvf0IODzHQ8taxi0WnabVJXOfQ6X5wt6zQef07LaN3jUBQXB3mIvUv2u6SVQgK2370PdrdrDifg/+iyWyVO1zcHK/zUAxzX9FhOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gfMW8ZH9IBILwVNuN77Ad+r5kOwsiKMN66VFi2LRkQ=;
 b=c2G7Y2MCOajtTNrB/Gz6q05hSJQeRZvXEeMzEcuw+/HjxiS6ty8fpUVXKZrDD/B9RFE732/p6EnAYvq5aCXya9reuCBwOvUHPKNO1q4DHeEs7C6skByJ5bXTSWlFaTnf3ysU+d/sxFY+sJ2e/AjxH3lLqePu/C0DZGaR4xLaAMo=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DM4PR21MB3705.namprd21.prod.outlook.com (2603:10b6:8:a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.6; Fri, 18 Nov
 2022 02:38:37 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%4]) with mapi id 15.20.5857.008; Fri, 18 Nov 2022
 02:38:37 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
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
        "bp@alien8.de" <bp@alien8.de>,
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
Subject: RE: [Patch v3 13/14] PCI: hv: Add hypercalls to read/write MMIO space
Thread-Topic: [Patch v3 13/14] PCI: hv: Add hypercalls to read/write MMIO
 space
Thread-Index: AQHY+es8ed4NTpMKIkC2HrScaVa/VK5DcksAgACGFMA=
Date:   Fri, 18 Nov 2022 02:38:37 +0000
Message-ID: <BYAPR21MB1688F5BD503C0DE2D6E8C726D7099@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-14-git-send-email-mikelley@microsoft.com>
 <PH7PR21MB31163EE3E83D6A0DDE83A13ECA069@PH7PR21MB3116.namprd21.prod.outlook.com>
In-Reply-To: <PH7PR21MB31163EE3E83D6A0DDE83A13ECA069@PH7PR21MB3116.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=00faa51b-4819-41a9-84f8-9620f95ed350;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-17T18:24:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DM4PR21MB3705:EE_
x-ms-office365-filtering-correlation-id: 6499f49a-f5fd-4128-c043-08dac90dff06
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fSBQ4XBZKKT6LcYSVbn8qJYSxu9zwb7yfgbbEIbOJvz7BOSMR/CSspSZBseCPpog6K8r9i54Ziw+DNePQjxjFkRrFoUHCiBiiIUIXhgt60My5B4vieJ8nHLxvUY0IomXed08WKqVH54Vt9oUegKNsLToRG8t7O+4yYZ8/2lpaIV8WKsvFN0Ju+DAFztu5iAxf6IB7MCC1LgVIteZ9cT73I+DzUYskSLonls5tIaLVEZTyZo7CG7bKVsMbBz6CZQnLHa5s7gOwZ2rG8qXz6aq28lePCtVVAcTdHIcxiaPza8uCwyX5m3UlCLORIaZC+K0+vU6K0Tl4u83B5pUDuCULTKaqr6GcI7F8wqMkyIftjfIRcn288ozcrFA1RB8Fwrht3OtxA/C5lyrMzc4szyeKK+4XPOARbJFIepLOxAGMfgWYxd7HSCf43hZUUGuCKQS10le0vE1soMfTJqvyPgJ1GxycDaebmvZdFLV63LM0jHU7o0MBYTlXBRa5R0PwEPLkPV01Z0IPspZycs8Skkth55wkoZxZ6VVz0y0j0tLbkS7B0t6q/DKfN2u7K5S7lGKL4O/4NxAVRrp0Ql9lIEjDOsUo3jM8X/8IvzIv0oaRxJGCI0b2Maze3YURyqDrkyjm24tJxT4kfcV8Mhxf20DOGYZ5j/1a+jtgF9iePVK/qqQ+GrPotthYwkdmQ1TkjnNDZF5zJA7qEaA6YMAIcH1iiGZhICWtXN2gc+P8Wl/4jc5QEE8MiVnsYKboer6pRqrv5P/uMAiRd6i7XgdR+0oFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199015)(478600001)(71200400001)(7696005)(6506007)(110136005)(10290500003)(316002)(26005)(9686003)(76116006)(41300700001)(66446008)(66556008)(64756008)(66476007)(66946007)(8676002)(55016003)(8936002)(7416002)(7406005)(5660300002)(38100700002)(83380400001)(52536014)(186003)(38070700005)(921005)(2906002)(82960400001)(82950400001)(33656002)(8990500004)(86362001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M49pB6PkuxczDHneR3D5GUwc40q9ZGnG/yEdUUqqhlaeXTi5s3CzX19tRGGd?=
 =?us-ascii?Q?ghd/ZgCPQ7nxX88gsxeWm9tc8MgSeutn0ng60LJ3GiaI6p6ULXnyIybHdQpt?=
 =?us-ascii?Q?XTnZeaGMrl7S47+AqtXuKI23DKS7pEAkPp9+DCFiFXCbrpRMSVCjiYrvmHvQ?=
 =?us-ascii?Q?HgRP2vrf7hlQqKBp4xqkCbctRj4rDLZIY5e2W2L63HL0MhyMqRSoxco7pZ9M?=
 =?us-ascii?Q?rphuY4qOP6RoRSIddOfoM8UtaNJkqAPi/Phz/IB+te0dyhXThOSQila8e5HZ?=
 =?us-ascii?Q?GQ9uc8j98URxq9+zsng+/1BhpUrcVNWJLiIAzO0F0TN4Ghgo8JWC6eeVK+ET?=
 =?us-ascii?Q?g9wL+/nLo8+KCd7P5QLj8AxUTqo8dVJ0eiobl4XxC5WZcAyB1oxPIw9yqQs0?=
 =?us-ascii?Q?FcorOUVtD12sV/3QXM1VIKjOum/3mnZBdrXK95QYBVzFxQ4RPz+mSav4jy1R?=
 =?us-ascii?Q?QfAvQS3CGJ267mYVyxduhs/X4URO4Qzd1p47M0ijU9JFuJuN87uJ2vWW8kDy?=
 =?us-ascii?Q?X9xRgxURMmmiV9MtPmghTeeXSwRZ4w8L/mIWzqnBaetQQuHuQK1W/9hEq+UN?=
 =?us-ascii?Q?XrWI3ZvU6DuZSz+WTnhmbSkpKO/0tdS+6V6ryOEK8bf1F8aoAJcFIRJ0MGCu?=
 =?us-ascii?Q?S4tqhmnkN2Z5/MBVDOqLD2eFbOybHeoDXSMfTHD3fuvmW+r/0856rOUfj9tk?=
 =?us-ascii?Q?r+j/1RKlG6PxaqU1geP3+aDwaaC17oIMhC06lFOjV/B1Q5kZKuN0clPwnjSs?=
 =?us-ascii?Q?aiu3b1cwqfDRPUqa6SZd0lhoruPiEm/J2wei8/mug9liL6BTWe5tT0ySVzsH?=
 =?us-ascii?Q?/6YESOHpKbGsRVcrRkzPMI2zTtMxjNiznM2TKuaz7Z8VC9PMk39VY2P3eZ8l?=
 =?us-ascii?Q?8DDrTKT1r4F3qY8ETvn+mso/jubGMl/Q4QbqcurqXGGYMkF68HhZA7GeR6ku?=
 =?us-ascii?Q?V5282HnqsPEDbtYerrX53i/o7/KPF0sE4AMmpQIMkRy/OEOBfiU5/j7bML+8?=
 =?us-ascii?Q?wTdZeOMW9KW+myPb0QTX9Btkh+ZpYNquvsBFMwTDv2rbqW5SBEAUmzjZ6NR9?=
 =?us-ascii?Q?YxpyOxYBEuCo/1aEVK+C1KES+UCI3CgHcs+tyJ0w9gsQOgX74TAluRlP6AlP?=
 =?us-ascii?Q?g58PUa2ne8wii1u68grQO8c0+VfKEEiUVdegrWLG1UtSBkoyF85uflbOsBdL?=
 =?us-ascii?Q?EZvKeKnASAiq+rscJGNd4p+lhFWezQXPRnxSSdNvnvfRFkZU4XvS6k4YRmkm?=
 =?us-ascii?Q?YQsB7j31sPGnMm7cC5q6dFVwhL2CS9KNz0At+LOuYOaaaS9uMbK87u7V6cP+?=
 =?us-ascii?Q?mg+HSf8kkLaewG089LgpNvFiyLtM9ogLqMvdJTrm1Mp7w7PVVILEoUdxzFnk?=
 =?us-ascii?Q?JcDn9P/Cu8vIf4E9pDoobLUiB/UHpL87VeVzCrDY4RlgMgEtmhd6C8v9nQGD?=
 =?us-ascii?Q?GVvr6OPYPMMW3CmiTqxKWkAhcdLDUd1c1LP8T5znwjGi7DOKPdZgE92AUAWP?=
 =?us-ascii?Q?EMgQkOslRcda0JNSmQOcie5lWwZ3R/eWLhd+FmUPxTuwuXf9g1Y28oMqODol?=
 =?us-ascii?Q?xErzVd4qP0w69lEVU3++sctCNbrjiH8hcg0esxroubeEsIEBuQHSkqBBQ6Kk?=
 =?us-ascii?Q?Dg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6499f49a-f5fd-4128-c043-08dac90dff06
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 02:38:37.6111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eo0NFnoiDAv7oR4O5qlyq4nGl9qDauY5Q6rsvXE6clBL0+O6/kOpqmYcoYITviyMSlfos0jAkOtlh3nrZfLktlXmGBH04hp3QayOYWMlhKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3705
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Thursday, November 17, 2=
022 10:33 AM
> >=20
> > From: Michael Kelley (LINUX) <mikelley@microsoft.com> Sent: Wednesday, =
November 16, 2022 1:42 PM
> >
> > To support PCI pass-thru devices in Confidential VMs, Hyper-V
> > has added hypercalls to read and write MMIO space. Add the
> > appropriate definitions to hyperv-tlfs.h and implement
> > functions to make the hypercalls. These functions are used
> > in a subsequent patch.
> >
> > Co-developed-by: Dexuan Cui <decui@microsoft.com>
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> > ---
>=20
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
>=20
> One question - Will you put the document in patch 0 directly into some pl=
ace of
> the src tree?
>=20

Not directly.  Patch 0 is supposed to be a summary of a patch set, and it d=
oesn't
have a place in the 'git' repo, though it will live on in the email archive=
s.  But the
details are captured in the individual patch commit messages, particularly =
in
Patch 7 for this series.

Separately, I want to add Confidential VMs as a topic in the Hyper-V docume=
ntation
under Documentation/virt/hyperv.  I'll do that once our work related to con=
fidential
computing is relatively stable.

Michael
