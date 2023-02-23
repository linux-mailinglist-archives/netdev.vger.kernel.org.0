Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2FC6A10F9
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 21:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjBWUBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 15:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjBWUBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 15:01:36 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021014.outbound.protection.outlook.com [52.101.62.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF925DCD8;
        Thu, 23 Feb 2023 12:01:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrhgER9WUNWrtgXDy+8U9zQqIGWhbUNOZwvm5G3Wh9lk03hVoFl7s1/qmrx93JBoUk/Guij0CFVzFpgSeGO4pyt/zmZSkibxnxCS49DP2+tkY0pkWCEso+GFCZf9tjjUnGPXY5b2LTe8vj6MR5BwmhUyaFrsHI6RcnlmwotIMakafJwTl3g/uUdYwSwPrjfpYBRQohoJSI+HWwgAxPmr/4KF6yQ9494Xi76t/QAG8ZeYlKcSGXVJ1zSI+mjjxkymDZFRuWqXXWGKroouaIYpvoP+GeiWlOKqYvgYH4/gdtAXYTjXAQSTS2CDTkUNn4i+/CS3rpEBI5AnR70EL/JPtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5PZYYoNumnpefwbb8lMG+7ZZBKljha4EfU+BHpyrmU=;
 b=hxMNeMXxu0QfD/kZy3d6Je6YhuW2HPQl2FLKCehcoRcw0Dvjp39vTweHmXgSv0l9mMa7lcdUniUsh05ueleFkJNSptPR7YkqQ1X86lUv4CERM+bl9NUeSGcuoEv9tIcmrCtJNF+j9ci8Cqe9p+nfmvUEDAwELkw1oYgpyAWDoQ3/wr28FtXhL/Cd+bMJCKByeEJsfepGWxKbVm/Fx0u0sxomzZcakhBKWpO+dxAnm4tfG6Ox/XfE9tcVg65L2zZ2UO87zVzHb2k+Ev3W7AFjMybbj+7Fy3JRyxP14EvO7G0RMwow4yAGcRFhxrZwGezZaEt2gQGUw9EMNlY0iov04Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5PZYYoNumnpefwbb8lMG+7ZZBKljha4EfU+BHpyrmU=;
 b=On2DntWAyHihnXUmOoaBQ1wkX8AoXLjPi02oOkMri4UDa7uDNTSMX2+AwGHFhTR61K5zj2OtaYKFhmLdxPcXLIEVRxZzdXDY5WbInA/Wqy9TNooRzPhKr0N4lf+kSg6WZpijGVWAuo0sv/jKOQ6jOaZ7ZzftvuMYr6g4EB+UdMs=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by PH0PR21MB1326.namprd21.prod.outlook.com (2603:10b6:510:102::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Thu, 23 Feb
 2023 20:01:31 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a%5]) with mapi id 15.20.6156.005; Thu, 23 Feb 2023
 20:01:31 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
CC:     Dave Hansen <dave.hansen@intel.com>,
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
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAeE2AIABk95AgAGmoACAAAYigIAAAicAgAAHCQCAAAYXAIAADqWAgAAB8ICAAAP2cIAAK2uAgAjCToCAACg1IIAAE3gAgAC0MPCAALlogIAIVjcAgAAFkACAAAXogIAACzEAgAAdyoCAAJ2IgIAAls0Q
Date:   Thu, 23 Feb 2023 20:01:31 +0000
Message-ID: <BYAPR21MB1688F68888213E5395396DD9D7AB9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <Y+4wiyepKU8IEr48@zn.tnic>
 <BYAPR21MB168853FD0676CCACF7C249B0D7A09@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+5immKTXCsjSysx@zn.tnic>
 <BYAPR21MB16880EC9C85EC9343F9AF178D7A19@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y++VSZNAX9Cstbqo@zn.tnic> <Y/aTmL5Y8DtOJu9w@google.com>
 <Y/aYQlQzRSEH5II/@zn.tnic> <Y/adN3GQJTdDPmS8@google.com>
 <Y/ammgkyo3QVon+A@zn.tnic> <Y/a/lzOwqMjOUaYZ@google.com>
 <Y/dDvTMrCm4GFsvv@zn.tnic>
In-Reply-To: <Y/dDvTMrCm4GFsvv@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=296573c8-6e3d-4168-8438-368954410322;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-23T19:45:00Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|PH0PR21MB1326:EE_
x-ms-office365-filtering-correlation-id: 33a79436-4622-4591-e562-08db15d8c1d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xIC5PYMWBSjj6uWTxgtC2jDEPAYv1faMPra1DheghX5sFUw/LRjEZ6cthken3FHilZc3gznmlcBuRR8aQfTt0D2PUHn0IgY7R+sE0OcibPROc1i+FlhnwBwoWmkMvrkLvl/Gd+WYP0OvVZAYyYNFp/V/oBRxjSWlmcOHSzaxsSdDmGTbBX0Uz/kiVqymXK2669UwAb7DOiKv/5rnyaNwRsRzgnqF+KhTphGS07tasftPkwJ2NVoRn3UeWlLL+ZIH3op31BmGSltW8DwYVbn5k5T5Z1ClP08uTuXmIbXYSV9CeQBWOTPz2ch0rmmBFJDK1PaT/pvVOiQGNtxNxSF0T29NAz/pwThKJT38vl1RBKSeJRFOSiuw9GLJoXEDyCJiVMjf7b2cJutQ8fBGS5xHoOZzicd/Xnu5SQgR79oyJQHTD6QVelWKtJQLYEqsXpNNtfMaOMlEiqI7Fi4rhEDahJQ5LiDkbg+j4dmjEOF93oCqEtydpocVcX00tYJEVC/xv5fpBY0UfrAhjuKiTwVAim560Jf6FWHuR6xCBz09scpTKmKyQVTt/8aypqy/frOLJDqBCzmrA97bq+oihHb+MWEF1Mt7BkU3bcSWNWJ2wF38C1mBuMFS/MXQVPXoqVd8W8JD4qVucxVzLOk84HyNpvnUgM0f8B8pL9efuYUoVO0EnLfLUsYNWR+3fzI2wBx8AmEskDc82cnjEBEVBbjZPL24oJWp2KvAgvhQIr6Lm4g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199018)(76116006)(64756008)(66446008)(66476007)(110136005)(478600001)(54906003)(66946007)(8936002)(8676002)(52536014)(316002)(5660300002)(41300700001)(4326008)(6506007)(66556008)(9686003)(186003)(10290500003)(26005)(966005)(71200400001)(38070700005)(33656002)(55016003)(86362001)(82950400001)(82960400001)(2906002)(7416002)(7406005)(8990500004)(122000001)(38100700002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zqt4l6HOabxKFroE+CUBDaBfZaavWblMrEnDQR5xF1vRgBfJUh8tuRxbBcRW?=
 =?us-ascii?Q?o26KFAhLrm/moWb/Wov14Gh31yYpbS1mW37Y8dT1hHG7BAg/yYKbkx62YPGB?=
 =?us-ascii?Q?+MerjmyMdR/8DHB1VJ40hBLZzHzjCfec6mVW6bb4x28VI9YFZZIjtsE3f1Ko?=
 =?us-ascii?Q?bNzub+kemzPJkZKregyXQcomHEv8nY+f2U9iGyh4+nA4D8vH4pYxNySNYLSi?=
 =?us-ascii?Q?ga9CR44gQeMdtcH2nd8SiwGFab/uqhD/t1AGWYS2sF94Binrc65hr155Lfdg?=
 =?us-ascii?Q?mJDRrX+JyyGYRjh1rqrTBYGMYQkdx770f34HtgC2JuZdutIBqlUSOIoqZsDh?=
 =?us-ascii?Q?SvSjHb/rMhuRkFlQaPOy2Ab0zDYivKPgzfLNDIethPCY3PRVf5wlzyPlflOf?=
 =?us-ascii?Q?3TisI7ImNf/q1/kTT+PzlUkmvpFSazrVzBpK//NR8KAdfXvOn+CxBSzlthbA?=
 =?us-ascii?Q?WjcnF8B13XbjH0kj71LanKkIb7cUv/c54Xwe3mZwPaUVRVuL3Dg6y2+MxJo7?=
 =?us-ascii?Q?2qsyvkHBIzoKccRxvWjRG3nyh177j7AOfn/YqZzk0SDvtEP64Qoul8MM2KYV?=
 =?us-ascii?Q?Kb1c5MZCfwWUfWfqlaoloS5ZodAPuhbq45GKAKA6gNu0/hCJ6f3gEgCR7WEd?=
 =?us-ascii?Q?f0R1dhlnMfGiOef0+CPDYG2SJri35CyhvDw9GTss57tqwHsCQcKouCL5bj1b?=
 =?us-ascii?Q?ZQGlAH0KYAaqrOs/0EU0OH3QpZZAHmIuxzSc/OK3gAnLjAGYMxmgpApZVcVW?=
 =?us-ascii?Q?mO3EYilbHH3DuRavLQY3DKzoHARs3rQ1pFzH/Fe4GHWw2kF8BLTRRr8vNYGq?=
 =?us-ascii?Q?1a3Fks/HeiKWXDPSik5uTVqqmZ4V7QtAtJcx71vrX5YNGxI/ne8amwNWoqlJ?=
 =?us-ascii?Q?wxvxEaa5Lax/z013+dhbLTCkcGSQnKa6ulLimajH65FN4TRhZcwdNqJ9GDMY?=
 =?us-ascii?Q?2XLvgqRWdz2de7svuvozHDRcSUWnCDVOejivbdu1zOVoVS9InSTjQ5YDrhdO?=
 =?us-ascii?Q?EsId+2eiIcaeRwo2eXaXSmFuwANiv8HiNfzs+06qIXHkTOqIe17QT+HG3b49?=
 =?us-ascii?Q?/fubIRHz6izp7rsrH6u+2EXPaPQbWQgqGfGC6ncPFTaUKVt+vQqvZ35oVrBZ?=
 =?us-ascii?Q?nh7X9q3jCGlbe9RQKA3dw2FLfblvGsgZCvTXIIY+YHXO3kR10Gk3gNwjpouK?=
 =?us-ascii?Q?hnEwWtRWbjraxHweuQyUOAqOk6Cka65FQTaY+WtqCaoVBl+fAuj2EOTw00UN?=
 =?us-ascii?Q?xUHlQAC/Ov2yclhfJtvpQYNVrEwIydsMOo/PylEaXzoJbMQpDKJdDKJNlWAg?=
 =?us-ascii?Q?hI5aQtwRVANtF9lEcOYRyxDaZXJEHafnyYTiNejsf0vfbnRU9dGwD0J/k6O2?=
 =?us-ascii?Q?ivFroVtXOoaD1HNbpORy73510y/vojGoI1ZwR9/42Ngj/AvsYA7whksVQwG8?=
 =?us-ascii?Q?8hCGjzrZ/92YPEjJx649KmRYv5gwDmJG2J5w+zmTzfFa9B4Yamjb9d9tXaFN?=
 =?us-ascii?Q?YxkdStn6VQ52rA1dIYM/24G9pGJsz2np76AskdJbef+uUbhuMZmPkxqpOFpq?=
 =?us-ascii?Q?3bduGA3xYHcF/Wdt0MeJ4JKCGVlTUE+fir42nGaX13AP9VJzEoCcey8f06v4?=
 =?us-ascii?Q?fQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a79436-4622-4591-e562-08db15d8c1d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 20:01:31.2237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7r7GmfsfRyw2tdRmpOaos1hpAZ7clj+loYa2KzsMTfSMrfzHQ9CtAhcIhv8ng7mp/fa3CyJYQ578peqM3vPptjWcfAbPOy24zTAbnLLwInA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1326
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Thursday, February 23, 2023 2:45=
 AM
>=20
> On Wed, Feb 22, 2023 at 05:21:27PM -0800, Sean Christopherson wrote:
>=20
> > All I'm advocating is that for determining whether or not a device shou=
ld be mapped
> > private vs. shared, provide an API so that the hypervisor-specific enli=
ghtened code
> > can manage that insanity without polluting common code.  If we are ever=
 fortunate
> > enough to have common enumeration, e.g. through ACPI or something, the =
enlightened
> > code can simply reroute to the common code.  This is a well established=
 pattern for
> > many paravirt features, I don't see why it wouldn't work here.
>=20
> Yah, that would be good.

Just so I'm clear, are you saying you are good with the proposal that Sean
sketched out with code here? [1]   With his proposal, the device driver
is not involved in deciding whether to map encrypted or decrypted.  That
decision is made in the hypervisor-specific callback function based on
the physical address.   The callback has to be made in two places in common
code.  But then as Sean said, " the hypervisor-specific enlightened code
can manage that insanity without polluting common code". :-)

I like Sean's proposal, so if you are good with it, I'll do v6 of the patch
set with that approach.

Dave Hansen:  Are you also OK with Sean's proposal?  Looking for consensus
here ....

> If the device can know upfront how it needs to
> ioremap its address range, then that is fine - we already have
> ioremap_encrypted() for example.
>=20

Again, the device driver would not be involved in Sean's proposal.

Michael

[1] https://lore.kernel.org/linux-hyperv/Y+bXjxUtSf71E5SS@google.com/
