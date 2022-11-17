Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E9B62E456
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 19:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240443AbiKQSeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 13:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240675AbiKQSdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 13:33:54 -0500
Received: from DM6PR05CU003-vft-obe.outbound.protection.outlook.com (mail-centralusazon11023022.outbound.protection.outlook.com [52.101.64.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E5D78D62;
        Thu, 17 Nov 2022 10:33:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpjUycVHuKMLzVJhxDXZx9YuMaVX67wN4JEAaHzgbgCE6cmEBUIEceolFJekUWOAurnMQ36D6lzd4w2yenNOSl9EmpkCvAVb/FrntR+5m+LKuhEwh9pAMSp/d+3VqbP+PR/+xChDL7cJ+GqSDdLtWRyiW5g4PPbJOqhw2oVij+djIsUvYlWDzlYVMOIr7QEk6lJZLaxwU8yJfyTRCetPC1Q8DZCo/zJ301cQEhZ8oyU2No+ioSNWVDBtyX/PoTHANlUbkV2fapb2fq/TBRD47n/BsUj/o7fcDMYZJMOFRRaegDv9dFL/4HRLjSUzC8uF5rBR2ASvIkOYTixXCInIUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZIidbewj+GjPACfxjGxcb/Kruvp3FbnxkMbhe/TQSk=;
 b=dWGzfYEbUC2UXdnfbLeP5G93irxRdzNF5ALBe2QadLmvFyiKUoBXJquURu8Vqx56SINtyQ2aFhoi5i/CmsiL6urp0JuIglKOTR8U/6YK/g0y7li5V2kY3goguYqw9NS8Yk4yrAyTPAHySj8pueoQJNzsGujcaeIf+t+/t5SIPK282s5H6lX6L+Fcuq7GGLEpsj5mnC5V5XLwCWKdO1Z/yxrZ7mizGQz50t6V59XFpu+jlMkSNiRQs59PXF+VEHlHR7/wQK9Dz84z3/ZI5FR1YkqjunkUomirjTj4qCVDmRRg47w3B8PfNzD5a2J5VKO4qgSa9yD5EtZbFlPZd3IlBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZIidbewj+GjPACfxjGxcb/Kruvp3FbnxkMbhe/TQSk=;
 b=SfrW7nesL2NV9WBXsu3XOBufN10+hEIbzFUT83xUGGcNB4zDfdJlaFuKrGHjz2Oukg/gpzpBPrxkIhn3hpkI6iYEKCHnNWl2pe3/dlrHUgCiJKEQqRXW+Io38YeKAWU3oUsttk2wlKQTMcV6wGItm+DYhcg3Jowq2GFGqNia7fQ=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by BL1PR21MB3042.namprd21.prod.outlook.com (2603:10b6:208:386::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.8; Thu, 17 Nov
 2022 18:33:20 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::b523:98a7:98c2:e3e6]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::b523:98a7:98c2:e3e6%5]) with mapi id 15.20.5857.005; Thu, 17 Nov 2022
 18:33:20 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
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
Thread-Index: AQHY+es8rsTbKuvRY0+UE5hOo2QPoq5Db8+g
Date:   Thu, 17 Nov 2022 18:33:20 +0000
Message-ID: <PH7PR21MB31163EE3E83D6A0DDE83A13ECA069@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-14-git-send-email-mikelley@microsoft.com>
In-Reply-To: <1668624097-14884-14-git-send-email-mikelley@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=00faa51b-4819-41a9-84f8-9620f95ed350;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-17T18:24:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|BL1PR21MB3042:EE_
x-ms-office365-filtering-correlation-id: c6f4ec15-e19f-4c8e-9918-08dac8ca339a
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A1W4LpoWIn/uN4Wq5nSiVnUEpellMGnSdxgOBOs5oVHRgl+mCAgy38nSm+Fx3Xzr7BC+avRn2IU97bW6DsceQy7ALTcbASE7lHs35o25/2j8h6e8W6lzWDUfUZB6BAZF+Tb3Nza+f8MedDWuQDmXH/08x5Io50fKJ+/xOJ6hln53KldP+CZVugpSubLkb1PB3sfYIFhIHBa/AFj4VKT/0sFoKq9LX/k1AcAzPGAvrqsoXdjasA9vOKZGUNAMhwI08RER4WTdWNQGAHQ0rdMM72T5w01tCMjtVVbi2t0WKEYAs+s0GcpxEqmKP+wGRxzMfrewJ9nlE5l0Ym3IP9UJu59omAH3E/r+cVMB9elWFp21t4rqoXjH88m8YHpUEpZ9b13f7zzODe/V2/vGY2jYQ9wqCCnUv0Qt5/K9+UTT5tLkr3Jsmh4SCfoOVIyAbCha2zzQd4c/1kEgO/JeUebQTZQThuJrIwjOPzqW6b+osCYJ0g6A0vfD6XKNk/yCk2xZMTLQqnqiXt+RGp0kuQh1hMP9bNfyuZKoIixNa3xIZR14qDyOu1dhcRIcMef4OXtWqg3UF0jdEYiXUDjOLLZSrFoj/w3ojvHqcfqxODUyvRJ1G5wBfSYfQeKgwxk2Gr5Vs+RnpDnRECJNKIhn3yMni/Qf0r5GY0V46bt+kwg9rzyuDuZBeV1bU9F4+27AAvbDQLzAsJU4pDLKApjeAXpT1WdtrGqCB8OpbmH0FQ2Z7RRdj4K7pimNiwfHFntghXugdKhemOPUT1V8sjLuThpJzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199015)(53546011)(6506007)(7696005)(8990500004)(82950400001)(82960400001)(71200400001)(478600001)(38100700002)(83380400001)(38070700005)(2906002)(122000001)(921005)(26005)(9686003)(64756008)(186003)(66446008)(33656002)(8676002)(66476007)(66556008)(66946007)(76116006)(110136005)(86362001)(316002)(55016003)(8936002)(10290500003)(52536014)(41300700001)(7406005)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zAiobwBQum0MFnKDXGcxMmPZ6iX9nqT5EbBLWYnm15ZJ70RVP0lrqmv6hAs3?=
 =?us-ascii?Q?4iLV4vu8g4sTHmmkU55EQvSrMQC6n+rbFINPkhDog91klKBPAti9L8d1yrUX?=
 =?us-ascii?Q?jzo7xHYAcxjBANK8mvaNV/pAEHtyCzK7UoourRf5Dg5aD9pQOHt0Q0IFJrz0?=
 =?us-ascii?Q?V/l+6n2TqfFNebLe6MHZj187W9P6SITKEcCSxeKeW1Lm+xSd9nnqwkl4W/OK?=
 =?us-ascii?Q?7vmlXOZARfpl18tD0MZT3xZK4m+9Jvo3x1/FFfOAsiVK376bW9CmxIB8YbUg?=
 =?us-ascii?Q?CsvXYHRLtuyMkrNAKp0R5XhDtEXR+HI9CCfLipVSEefbyqKLwpevJY5HYBmF?=
 =?us-ascii?Q?FfcBUk2ZDarB0XjPOJlUjka/VCElESTuurf70BS2D0nN5zv3Kc4OkL4YH0kY?=
 =?us-ascii?Q?/wEwdLK2bZyw5Iqe555Rl23y7kWBGmjv2QEtg4U4ufTATeAkQyNE18OrHtre?=
 =?us-ascii?Q?FQZcqUxwMdnkb1zR/nLuu+AT+yJjgfOHg+pzFIq70oachoveZQxBNzc+5HHo?=
 =?us-ascii?Q?DPEneZz2U3OZGgV4lCW669dljq7tbB0Of6acrJFV7cOAYYs8LIa0l3qxmO74?=
 =?us-ascii?Q?QTmNLVs2jWu4lZGN+dGFmTa9PmuQtV9fXeURtBs8tt7Jxnf7AEPDNm/BsOKH?=
 =?us-ascii?Q?bYxPywnOOkyd2OsGw8lPiW0hU6q7ffU+Ayh5P3lW9c9NyCcLLx80gZ7tXa0Y?=
 =?us-ascii?Q?W0vA5c/dURbezYhFx41AuErCtDwWB7IDloeMc04pRpXhNdvR/gJ+GKV7srwk?=
 =?us-ascii?Q?/ynpbcB6QkvJrDkKZGJI2qjxKZDFndp2xLVR6DmvWUZ6UlWliitspVmzZ9Ck?=
 =?us-ascii?Q?+31AcEoh8pLnioZh6YLjw/qhcbEH7NyzskqRmYRsrmCBcTQ2Ql0KNXwFFzak?=
 =?us-ascii?Q?STXjDVtgp6Hm8zYZ2/i0mxyXD94xxHZMJXvI9kWHEENeOR59EatDOHr3UnAo?=
 =?us-ascii?Q?bj5EDUB4Rn6o9MpBMsoKcI+UeXHeCP0sqsW3QnL+M997cT6sVdtnFw3R7FYC?=
 =?us-ascii?Q?91pT4KVfARKWtrVKHMirRwEm+wQVTxZjbkXlLUzlZNNoRtJzTDNh+f1MFOlw?=
 =?us-ascii?Q?4IXXI9J7RYjhU9MR/YiZZUHvXyBps0pjUaTMuuBSuJhetQbBiIb7Jj4VOpeU?=
 =?us-ascii?Q?7qBjTmpKlBcnhKKVs9sTS2m9mO2DiKSdqMoUaHLDBG+w+MrY+rKGvcXBgkcR?=
 =?us-ascii?Q?tjwSlbhTxpZqlY8uWI7prIjCnLjd4XfainSJsQcyzs2ZasI8LSedZYvFJwWn?=
 =?us-ascii?Q?srY7NVrZBIaxgj0FfUHFOe1FA8iftqg94wxTcCoPpEqB+c73H8ihIYmRaWVY?=
 =?us-ascii?Q?Lb1nnXSs7xDWnymZMd9HPhbxEycdO77CBpzP6z7DWqfu2AGtQsl9ty+zqgWN?=
 =?us-ascii?Q?7FxwookP+8CLVeLful2bPns78+WfnbC3jUgNV4S7Xb/d6UumJomrscIs/m+r?=
 =?us-ascii?Q?aMMT12gGaGFr34gtn434CffW4V71/nUZorcPN09cJ2gDdpudz0FM1bQgC5Fy?=
 =?us-ascii?Q?3JKpMEIISsTFmW/JxBGUQhPMhNuvxNbWk5HtxnkGHzlvsCxD0+VwOEi+NrwT?=
 =?us-ascii?Q?4Ic8jViT8S8PkemqSHHQahzuNIpconfxoOf8YCBz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f4ec15-e19f-4c8e-9918-08dac8ca339a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 18:33:20.0596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JvCAilDyLTK4oG5WoLliLx7wQScx5oMR7oPvcaVZxjWWdcyXGZfOj0UCvpmhpkCnhYrtWdV8PmnNDvj3no/ihw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3042
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Sent: Wednesday, November 16, 2022 1:42 PM
> To: hpa@zytor.com; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> <decui@microsoft.com>; luto@kernel.org; peterz@infradead.org;
> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; lpieralisi@kernel.org; robh@kernel.org; kw@linux.com;
> bhelgaas@google.com; arnd@arndb.de; hch@infradead.org;
> m.szyprowski@samsung.com; robin.murphy@arm.com;
> thomas.lendacky@amd.com; brijesh.singh@amd.com; tglx@linutronix.de;
> mingo@redhat.com; bp@alien8.de; dave.hansen@linux.intel.com; Tianyu Lan
> <Tianyu.Lan@microsoft.com>; kirill.shutemov@linux.intel.com;
> sathyanarayanan.kuppuswamy@linux.intel.com; ak@linux.intel.com;
> isaku.yamahata@intel.com; Williams, Dan J <dan.j.williams@intel.com>;
> jane.chu@oracle.com; seanjc@google.com; tony.luck@intel.com;
> x86@kernel.org; linux-kernel@vger.kernel.org; linux-hyperv@vger.kernel.or=
g;
> netdev@vger.kernel.org; linux-pci@vger.kernel.org; linux-
> arch@vger.kernel.org; iommu@lists.linux.dev
> Cc: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Subject: [Patch v3 13/14] PCI: hv: Add hypercalls to read/write MMIO spac=
e
>=20
> To support PCI pass-thru devices in Confidential VMs, Hyper-V
> has added hypercalls to read and write MMIO space. Add the
> appropriate definitions to hyperv-tlfs.h and implement
> functions to make the hypercalls. These functions are used
> in a subsequent patch.
>=20
> Co-developed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

One question - Will you put the document in patch 0 directly into some plac=
e of
the src tree?


