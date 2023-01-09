Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9529663018
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbjAITPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235538AbjAITO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:14:59 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021025.outbound.protection.outlook.com [52.101.57.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FA28FD9;
        Mon,  9 Jan 2023 11:14:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9no5nM9Lrg9jbshi0bsQQWx/n+tSqqKlr7zXO8WLfADV84+2AS7ZSjYWeka10br2yQyjdLqrjfqHN9V5cWqiNRaHnB+L4JXfz/R0BrBIooZvBnEIpvbw4xVaa5kkLxwC3SzuUqBuTy7W1FafzXnykuxgrYnztyiOzlSCiYTcN8D0FeqnZV2qCBNCiFHGguAN4iytnVq+z2Q68YzWJzBs2SEpQihZi1/EmvGYGhWETgf8NEtX7LiqvKlSEjqu6f1JSYl9+HJEg6GIdUEB8IAuiFw6fReyKKu0XxUrMzcfRRFfP5hKBEQFjBnFgc4MyAs+i76XeV3MbNp/TTkxzbILg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xBfP1UUUu/m3u4QCqt5hPIRo13W3hzr5F4cZI15EgL4=;
 b=QL9ZXO+Xv9X2yy+RJoZUi0g/Xb6jzVJizsJXmNHKTp+P0UTZUSg7Y+LTsxnwCMavzdQhEh4AfCD/Et3ObVRghh/7YvshE/sGSpGk2x/Bp1JgFU7KiQBhasZSkp+2PDBPZyHKHaPHPuYiimcrNw1uKEaZ6/2dDjKeie/wWGsw/00Vo1HnNJ68TfsatGGVclx3aTpbNrPGlkgfyOHh+B3Pmq9wFqXjUsS24BgcOshkWzvDEfTEbPQ2A4lpB0eocTorgWkYfLCE0b8X5aVyxHJkoPugL5un0l7EH3rIqYMCz/6kijmm3O3bxD98JG/UOD7pa2GP+O9rlTENdo0Y3TXyaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBfP1UUUu/m3u4QCqt5hPIRo13W3hzr5F4cZI15EgL4=;
 b=iZYbIS2ThToDwe2g031XBzsk1/TF9a8Fbtv0AhgCXF8KhAH9dfR6SeGrl48jn5tGcD2xOjI+FQpBCAGpIX66OTo8HvSPV3+Rae8OOqrgDJuSVEXk938KibtE4yJHrKdCaKY0fD7wyPnIeDXTGazTpGv9MnLnXN7ds5Xc6NEVBp4=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by PH0PR21MB2079.namprd21.prod.outlook.com (2603:10b6:510:a8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.3; Mon, 9 Jan
 2023 19:14:54 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::db1a:4e71:c688:b7b1]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::db1a:4e71:c688:b7b1%5]) with mapi id 15.20.6002.009; Mon, 9 Jan 2023
 19:14:54 +0000
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
Thread-Index: AQHZBf6qXxv12SnI/0WwIL+HXSylNa6E8yMAgAA/XSCAEX2zAIAAAIfg
Date:   Mon, 9 Jan 2023 19:14:54 +0000
Message-ID: <BYAPR21MB1688568F9F76C1FB4AA49FE9D7FE9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <1669951831-4180-5-git-send-email-mikelley@microsoft.com>
 <Y62FbJ1rZ6TVUgml@zn.tnic>
 <BYAPR21MB16884038F7EE406322181C58D7F39@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y7xmvt2/mGyox9L+@zn.tnic>
In-Reply-To: <Y7xmvt2/mGyox9L+@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=aba4fbda-5485-4ae5-a69b-7cfc3ce8ae3b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-09T19:12:47Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|PH0PR21MB2079:EE_
x-ms-office365-filtering-correlation-id: c808704f-adc7-498d-ec1a-08daf275ca71
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z1Md2UbmDSewAfeEL3ZRPPRLC/xme6gL6EwSqPYDl/E5lEK2Hk9BmH/wFITft3tWwS9rjtTkRwPFgSaJwgnHe9Snu/KOIDM8ZuIfKhILAnzVIU9Rf1M79Ap5WyH92+b3EPtGOReM+HYT/6py5Fpm9dP13MofxMDkTTcBmD0wDDO0BySs3WJaCPvx0c+QdKiF74574NFcEhhbNbbFxuhnxOCVpEe22Z1DjlTqmF0SLMSejkR+UE7GkV0DlP/uLSMeKQ4f9EAWQKqjayPlo63QZJ2gfX1RO82Ehk1dhsE2ys4WtuhU15Izp0fXLQq0OkNVjnDtJbAkdfR7/IwpgNwBDgCFv1QCDZGBEWWugiKWxeHkdw7N70rSgHFh/ZcVJNAPfgjtNJq6bz3dCtaEcrL7RwjVmtOfCGVeuu4kTIuJBevmmGf/x92NMwmQ5UEyAI3YtmzxSgW81or5DIcoyBVFtlFsrkUiZo/UPMOFb7AldIz5VmjJIfPfWsFMcMNAqHb+cE0oH0OGwJXCIk+VQYjt+8mpJcXGG7tGDJhxfnOVF4DolfRHugTfU1RpXCMSkW7S6pxCBihRiigs+eYtUpImum52/7dDN36DObW+aS0dyB9nCuil1h15Ur38vNNXz+uwDCCFgAERAqjU040lhUOw7IzIUWYxiJdhj/Zut9vWmim57sImUhSAApSogW7f01Uiw9ZT2TUFxEgWvkRaWOz6ELzG0oNIAZ8aW7sv4xiCTQzvzUtSK7jxh8YZVyc545s5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199015)(33656002)(478600001)(54906003)(7406005)(7416002)(8936002)(122000001)(52536014)(2906002)(10290500003)(5660300002)(8990500004)(71200400001)(186003)(9686003)(26005)(82960400001)(82950400001)(7696005)(55016003)(316002)(38100700002)(6506007)(38070700005)(41300700001)(6916009)(8676002)(4326008)(76116006)(66556008)(66446008)(66946007)(86362001)(66476007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?snwJ3cYFBqqb1H1rGdGYrhCP9VQDHNXULimOG5yqGlw70N/e/b8nWzCX9A4m?=
 =?us-ascii?Q?zi3FgPdBtFsxmpGW25ydRsdv7i4veX3vTDc7m1842KEP3LgeJNDUBIj4EGDh?=
 =?us-ascii?Q?ZNv1DE1LhTwq6SuImKRe9wkP1Lfg6dxYOxnvfpZR1Lt61xZ2GmKrbiE2w7hV?=
 =?us-ascii?Q?USxIQ0czTqCZ/Oy6nuDfTfIjRlljPoFDdfdXheluKDg0XT9ob0xOrlD2p3jk?=
 =?us-ascii?Q?90hbR4jVQ26rafT4oZWiegrUG+QfZNKpqJyjV2SkQdSFCFrSVSxYlt4QpPJ1?=
 =?us-ascii?Q?vOgWQWQeRVWa+RyUCbuhwJCImbh+GesWwQRhHvEg5T8w0WbJaBr7P8HhmGB5?=
 =?us-ascii?Q?2L+c7WOGGgxzcIfQL50oJfelkL9meFOy2DwgTT6kglgXivD2x5BhNJTC3+YW?=
 =?us-ascii?Q?8szwXMcbux+VgMIBLm3x3QCAXRyxT/+rb+yp/y9Y8EJetyTSLYGpITCU4BdP?=
 =?us-ascii?Q?VQxOlV2DNoI61KLkfWmCHYpeHN+CBliUW5kYqHEGUlMPgdLKYw3A9iJItRsU?=
 =?us-ascii?Q?nv7Y9d7G5YhdENLAHovMlgJVGcOaC0thVz7ZlbRJubI6CTfy3VVonHaOY9CL?=
 =?us-ascii?Q?eTX5rwpQhFXKFIutg2kZPkNYE7wChgwTQFaGudibmzBl1H7rX8cErrNancw8?=
 =?us-ascii?Q?6LIGVBeQxVi5BZdDN69s5NJsB6Pjop84jU8E9do46ksJqpE/4k7BHLOK2EXQ?=
 =?us-ascii?Q?mh/fwzrPcvnwyKanV8Vg3kElC0eX6DnaUO2DWwxUjCi8pVPxkbR/FcoB5Hir?=
 =?us-ascii?Q?cvFvXC/pj16Llxz3ZhkLemmpp2KREn9Stdf+gbT4ejs7YLpiOZi+hHjhY/b+?=
 =?us-ascii?Q?1Dr24Ld6ye+qdNOeamtOq5kj3RAh3Ja3NmBhtsdBWhyuP1D/JKcUGoM5WlgL?=
 =?us-ascii?Q?KFphbjY/aDnHQWIwy8brjddJXaNfkraTuAx73fPQAoa1TN/jycAyyNiomGDa?=
 =?us-ascii?Q?AeGm5gnfAOM8jg8k64iXTb3zRoZl2Dj9p1mXmslpNhWAs5vReaXNjbD3KBpF?=
 =?us-ascii?Q?bcuv9AE45YnVYn6f0QfpP0VZQD9tZWIU1t5aaaS2DxVG+BBUXQ71AVPcGmXc?=
 =?us-ascii?Q?ZrvM16hI21Vaf5qzASKXq6rpJJXPSLE3De0SsiFHpIT1i1uzyUDQEXefHUrr?=
 =?us-ascii?Q?6Pqstg9xSsDYYejeuaPWxo7D49PQ4OrU+4ocTLQZbEZnaoSNSKy8UvYLkzC4?=
 =?us-ascii?Q?LpSEPG6CrzvX8zDukQ9lzcLRS1prXRkdsbeYslfcbu6NOcIIgyOs649eAxkF?=
 =?us-ascii?Q?VFTX/G/GaQmX3+48RwC25EiuTD9ZGv/kDj9U9QfEGoIT5C6r078lcFQ6Zkde?=
 =?us-ascii?Q?JpPB7ZOauwhsPUydndCbq4ewbJPMawHdQeb42T8HHjjYQ3g4uum86muQEz9e?=
 =?us-ascii?Q?xk4NihoiiKjj4YM+KqgQYBc2wONb0uUVSQUAwcdXkX9ckHo7zO54j3kEqf5W?=
 =?us-ascii?Q?utzd8JOfdbryoMyL4mTranttRFRp8K3MP9Z7LY+piODTtAHsP7ZSQ7iR6v2U?=
 =?us-ascii?Q?r98H+d6XweoogXwZRhocafkwCsTJyYweB+oxXCa/k0HoPfXWY5WSw+8ErRCG?=
 =?us-ascii?Q?h79Hk2UT8la8iHW9dxJct/5wAP1TabH7A89Zkyj05KuvAyMIb4AEuHBnupqB?=
 =?us-ascii?Q?gA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c808704f-adc7-498d-ec1a-08daf275ca71
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 19:14:54.7749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2uyS1SyyLqP8EmurMCyDa7+ER2eMQlIC3gVpWryrHH6iScJKymrv0IwVZr5O86kT3eYWMcSLOwsbEA3qR32SDGwWd2COr4Bn4qfQDg58NUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB2079
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Monday, January 9, 2023 11:11 AM
>=20
> On Thu, Dec 29, 2022 at 04:25:16PM +0000, Michael Kelley (LINUX) wrote:
> > I'm ambivalent on the backport to stable.  One might argue that older
> > kernel versions are conceptually wrong in using different conditions fo=
r
> > the decryption and re-encryption.  But as you said, they aren't broken
> > from a practical standpoint because sme_me_mask and
> > CC_ATTR_MEM_ENCRYPT are equivalent prior to my patch set.  However,
> > the email thread with Sathyanarayanan Kuppuswamy, Tom Lendacky,
> > and Dexuan Cui concluded that a Fixes: tag is appropriate.
>=20
> Right, just talked to Tom offlist.
>=20
> A Fixes tag triggers a lot of backporting activity and if it is not reall=
y
> needed, then let's leave it out.
>=20
> If distros decide to pick up vTOM support, then they'll pick up the whole=
 set
> anyway.
>=20
> And if we decide we really need it backported for whatever reason, we wil=
l
> simply send it into stable and the same backporting activity will be trig=
gered
> then. But then we'd at least have a concrete reason for it.
>=20
> Makes sense?
>=20

Yep, that matches my thinking.  I've avoided marking something for stable u=
nless
it fixes something that is actually broken.

Michael
