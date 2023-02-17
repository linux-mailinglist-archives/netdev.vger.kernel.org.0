Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1440969A58D
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 07:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBQGRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 01:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjBQGRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 01:17:01 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021027.outbound.protection.outlook.com [52.101.57.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D30F4AFE6;
        Thu, 16 Feb 2023 22:17:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDB+7fF12nIRE/RZU0hE6xu1kSQx0K5Sg7RNueMVFug2+dm8oX5iQ7JWtvKtTrnZo/g4Wox2O1q8GA9kODST+AU+2wWQ0qUsPjcELL1kvDSINjQx9N5S5UWwI1M9WkEigZK0L7UUBW3wbV9e669kaVSpNLrx9HWQ9vJ+tyUtJWqnkiDOvleB6w69KZLFqGUQoLiVUaer6KpM/cfAD42B2+c5TVqYuczOeFOvJhhu86RVqGTznebwCppI4p1evOLJYA+HE1jqYQKjmyJQQQGFTWuRT+lFZTEm7zkOKfSzHovDufy9JJzZs3CpMBIDNAVX3jrSHyz48N4uLa/u7wIbzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FhXzVCNugP1tEBluz9qCyJI41Z1HUdzk52mytVUIt6o=;
 b=YAknVMBszEAyE6Gwcmr+EqA6WVM+KATMDYwbhPDgM76pd7Y2De69qXEX66ijgjEO9c1v9cK2AnXlprv1cfuM3NtB80DofdcOhXy2/qV19ddHoyxMF5IDckSFpK3OJ9yMONZy744QVCBbCz43zV8d71L/xc77ZzvhoCMmP3Gb3JiHYS9zklf92aH5ggX8vYHuHld9De0SaxGQ+0hbtRx6ieHMA3cxng3cLI6fJD4P0f7yyM29FYx0ucJiSS/1XxJk32FFThkZe7O1DfwsCO+yuYkv95Od4EiF++QUPMweB/uudJtPRqtYyEM0RzZ3FTG/5JMqUNRVDuE5KjNRtzbSAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhXzVCNugP1tEBluz9qCyJI41Z1HUdzk52mytVUIt6o=;
 b=fT5iy2EfDnUuyKnlQygCVuTxgZmFD9LwP50dxN3AD+WB6R2oGhXBiqALEpCcBRw0IWU1l/sikeN3nr4i1WXXffJ9tJMJq9njKjB9+WD0D/8DMyjT2QzwS7lr6iO5T3A+SIJXSO6E450SVK+qzZX+K8WxS/mdpbEgBAn1gHyY4zE=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SJ0PR21MB1869.namprd21.prod.outlook.com (2603:10b6:a03:2a2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.6; Fri, 17 Feb
 2023 06:16:56 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a%7]) with mapi id 15.20.6134.012; Fri, 17 Feb 2023
 06:16:56 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
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
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAeE2AIABk95AgAGmoACAAAYigIAAAicAgAAHCQCAAAYXAIAADqWAgAAB8ICAAAP2cIAAK2uAgAjCToCAACg1IIAAE3gAgAC0MPA=
Date:   Fri, 17 Feb 2023 06:16:56 +0000
Message-ID: <BYAPR21MB16880EC9C85EC9343F9AF178D7A19@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <Y+aVFxrE6a6b37XN@zn.tnic>
 <BYAPR21MB16882083E84F20B906E2C847D7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aczIbbQm/ZNunZ@zn.tnic> <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
 <Y+auMQ88In7NEc30@google.com> <Y+av0SVUHBLCVdWE@google.com>
 <BYAPR21MB168864EF662ABC67B19654CCD7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+bXjxUtSf71E5SS@google.com> <Y+4wiyepKU8IEr48@zn.tnic>
 <BYAPR21MB168853FD0676CCACF7C249B0D7A09@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+5immKTXCsjSysx@zn.tnic>
In-Reply-To: <Y+5immKTXCsjSysx@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6d81780f-893d-4a9a-bf7e-bcfaf137ed86;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-17T03:51:28Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SJ0PR21MB1869:EE_
x-ms-office365-filtering-correlation-id: 2bbad1d7-93a6-46fc-92b4-08db10ae9214
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nlyiDAm7HTfsVbRVHniWeUM2xs4mcBolUijuP5PAtnzCT8l2UDI6FF6BA5o7HRtNw2ycb9id1zd/L2rdb/pcgw1Ey2yCY6eJCA25NBK6NBwf74BNQ9+txpl05cISYHJQGF2M6y099A9AdeGDkJsydON+mzMEevdrmQEiA71QVD8LMhGqEM28xDfLifVuUYewLbM6rq1kYqHzFlBWY+faT3+7+TeOdMbBlP4G5jDDdtEtqDSKUE9FZCESUgSQ6wUh0s2Sp7tM2w4Jc8jpLvrhwOpymMXUAK0R3TdiMu3M5AK22QbD/7vuQlz51cp/mYzOjT5kYJ1OmWONME3y0uCFLjomrE5p4qo324jpW/MvboxuSCoDniqtTKfloOLvt09Rl0omPaOGysk2c00QIRVIra4c/1QiUEd+sgQyNtC+07yu0nvtM8kLKXlrAKI6lqGQKrXTznFHCeTavQLSsQFgmk2JUe/Hix5HSgeaSWgo3lrxNEtyrIZqAl5SHmbS11516RCF5raP0TpfB+elapjWwcKiwuPcFIfY0yNSUYRD6LPkWnhVWbLHTd26R8RBXbqmQbxeUuyWVCWnaFTY+C3wHUHF+1KDar3HxaxTI3yrJmN3tmDGkeWH5FUdMPilHDO51/QsELx33ZHEQJoDs/2gzK7e42hjzDLbSS+pk9LEOuq5z17gfm8Hys2LyVmHhcznd75dB1KDMRfgN17AWmdgMg8c5ZBxWfGNRtV4cGb0ZHOJi8KMHiFTaG/Qj+m3xagn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199018)(9686003)(186003)(4326008)(7416002)(7406005)(10290500003)(7696005)(71200400001)(54906003)(316002)(478600001)(6506007)(76116006)(6916009)(66946007)(41300700001)(8676002)(66476007)(52536014)(2906002)(83380400001)(8936002)(66556008)(5660300002)(66446008)(38100700002)(64756008)(82960400001)(122000001)(82950400001)(86362001)(55016003)(8990500004)(33656002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Xzd7yxUMAJIOAfLJ+nrsueG+MioolMF9mYYpw5TEIS52uFbhtdEsuF8JbaIx?=
 =?us-ascii?Q?lPEPkSuKgwj50P8fVqOvZilJhdKM8lzqKKe1nunrVLJ1knmCNfn86J0NK2g9?=
 =?us-ascii?Q?jCph75bt5dSkHg6UvsSnJXs/NiAmCb16wKghFMCGHcOt3ZROVKeOgRYwUl2K?=
 =?us-ascii?Q?qeixY67N748kl+VvvaJNWB/eSINtrH8TtJp/nrmG54LnZL78exTjx3b9AQKl?=
 =?us-ascii?Q?VkQ+Z1gDJ/yYMft9n3o/lOlRSEhybyTvrfSzcokjnHUS803HaZodMefUnhMo?=
 =?us-ascii?Q?ElGZVKd33ixiQgvp9iT1fcEp083Qa4cICzfwwOLTWHPC/08XySotIXlwfbAX?=
 =?us-ascii?Q?v2H7OZyhVmVQ1efjGYPvJCWZ8HPjCAgi5wdz0h7jnIS5/F3E2dvbZlm8k3/i?=
 =?us-ascii?Q?swbbC7/q+sBon0rTwcqSS6b5lKglmsxsKW0kt3kfT8UvCHF402BjeYMGQpfV?=
 =?us-ascii?Q?rc4Yt12qVa9GiDdqWh7bxGazk5h5hNVArO11T2bv9ct17X6CAus1jM3t0g83?=
 =?us-ascii?Q?PpMTqvAbXNd5sjAkxP3KEE4TLW26PCrIhgH0PvOFqmYe2rBdI2PdvBnXG6T1?=
 =?us-ascii?Q?7uDFBSshdK8uCClU6h7bH+oB5YwX5CeHH4YteLPKhrTZN0MV9MOyk/1t+xt4?=
 =?us-ascii?Q?aWwW94T/KAsFqODxDDwoHpITtbhTgT9YlMKPqi5ciluNcJ/BaFYNroNAKYTq?=
 =?us-ascii?Q?c+Lk8z/4/7EBDKl6/y4UXOWL5SEet+mMq3Srznv+rC1wlFcLSQpea0hRm/cK?=
 =?us-ascii?Q?kj4qu7N3ZAit5x8Ad+CeI4uGQneyEisYP4DblN9k2ui1VOmTOXLXZB9iXbbW?=
 =?us-ascii?Q?ke0PzT4u+UJdkin81XdRMKBbYX1G3dVg2J9mAtkpspV9zU2eDTX62Iu1tKgD?=
 =?us-ascii?Q?Ka5Lye1fnEi8Is+tnKzxU8mTiImJsKIMj9tDSLcP8im1BgQyUr2coparYL7t?=
 =?us-ascii?Q?OUOzkwoBQ9+/pgr3NOVGd+QQFi6yLgFyi1apCP+2bm/aVfMtSmSsPr2kOk5k?=
 =?us-ascii?Q?KHgCH+ziN8bajpmdB7qSPU5FFKIoGDZ7G9xO80xb8lKlcC7CV/M3VXA2vPQF?=
 =?us-ascii?Q?7eQfm9HWW0NwR8cQMs7BZh+XtU8LtzXAQEHnXy+HdnipwAEPL355mggaOrpI?=
 =?us-ascii?Q?YslF3hhlWlsp/sl6SYgqbm39ARA9G4xKR9v7p+VoXN+Bhx3/s9DO57DHJMz8?=
 =?us-ascii?Q?TbFfwZ2N3GzzwcWKbBgGWMzefChDP08l5CPCmyfX4pAlk7ugFRKfyBPzuDXd?=
 =?us-ascii?Q?hAzUeDgRxW7qruB0AQd9Ph1lZDDKwq9Ft+3nUcTe+tgeZ6zpW0mUt8W6s0pn?=
 =?us-ascii?Q?iXxS+uBStT9iKpzrGT2M3sZfunQjCE/Kh2UjsF0i9tQU2ko1eYGe7ud/S4Of?=
 =?us-ascii?Q?Pr+3khMIHBNS7dKR+r8XiEa6/R7jnO7++1X+zvAddMQagmDsmuxyIkk63Cv4?=
 =?us-ascii?Q?CKcvRdvCpt2x05KWf1XvNqUn26vuEoSqDaBzACbUVEZiIGmjrFV97W7lVOLt?=
 =?us-ascii?Q?qwoQe5R1xb0cflWU8m8WIR30YBvEUVWzmBKM9CFia0tdsh3gJo4xaxROiOtJ?=
 =?us-ascii?Q?+lrccR6LsWlQfi1Q44RDcVKci/yXNoBNFgkGIfum3ntF7XH8c30SgGWhd3Xr?=
 =?us-ascii?Q?/Kim2kyYIgvJeMyR+yWVBKAYQQRf1SeWmLY27t4O7shYwSekyp+VNiICsHIg?=
 =?us-ascii?Q?IILuKA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bbad1d7-93a6-46fc-92b4-08db10ae9214
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 06:16:56.3920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ToIHBhYpP9Lh/pmByK7duo6cVZkOLv3a+u72k1zv8FeWAf5VJCTEEfLTCwW6qvcaCJpdAAuqKw6eQyu+zfnwAuOb/ivsdXyf8n5xAgnRJZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1869
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



From: Borislav Petkov <bp@alien8.de> Sent: Thursday, February 16, 2023 9:07=
 AM
>=20
> ... here.
>=20
> We need a single way to test for this guest type and stick with it.
>=20
> I'd like for all guest types we support to be queried in a plain and
> simple way.
>=20
> Not:
>=20
> * CC_ATTR_GUEST_MEM_ENCRYPT
>=20
> * x86_platform.hyper.is_private_mmio(addr)
>=20
> * CC_ATTR_PARAVISOR
>=20
> to mean three different aspects of SEV-SNP guests using vTOM on Hyper-V.
>=20
> This is going to be a major mess which we won't support.
>=20

OK, I'm trying to figure out where to go next.  I've been following the pat=
tern
set by the SEV/SEV-ES/SEV-SNP and TDX platforms in the cc_platform_has()
function.   Each platform returns "true" for multiple CC_ATTR_* values,
and those CC_ATTR_* values are tested in multiple places throughout
kernel code.  Some CC_ATTR_* values are shared by multiple platforms
(like CC_ATTR_GUEST_MEM_ENCRYPT) and some are unique to a particular
platform (like CC_ATTR_HOTPLUG_DISABLED).  For the CC_ATTR_* values
that are shared, the logic of which platforms they apply to occurs once in
cc_platform_has() rather than scattered and duplicated throughout the
kernel, which makes sense.  Any given platform is not represented by a
single CC_ATTR_* value, but by multiple ones.  Each CC_ATTR_* value=20
essentially represents a chunk of kernel functionality that one or more
platforms need, and the platform indicates its need by cc_platform_has()
returning "true" for that value.

So I've been trying to apply the same pattern to the SNP vTOM sub-case
of SEV-SNP.   Is that consistent with your thinking, or is the whole
cc_platform_has() approach problematic, including for the existing
SEV flavors and for TDX?

Michael
