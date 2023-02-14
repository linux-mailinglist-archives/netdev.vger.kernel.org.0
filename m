Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E7B695AD0
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 08:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjBNHpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 02:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBNHpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 02:45:54 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021024.outbound.protection.outlook.com [52.101.62.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891D0AD39;
        Mon, 13 Feb 2023 23:45:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqlqX2pfpYqA1p+v4WgLvr/XsktfL2c+JVQe/Q3nSop0Xa9jHDvgHmuRwfOgOtvbFGatoAtTBeJpBa6KA1/bBvQfdH8QEVug6IAwazp5NQG5FNTShQnpEoo4PaFl4QpCZvCJJuSnA/QkNnejet9dNLWPSGNdcQ6CwMkJT5X5dtrhd67N4K7wM265mpB2ujg54EoNXVTEcN54n5IzK58i2XIGMRYS5JZQNWYF0R9ZmY0D3vairYl5Dfgyokay2pMaiCrzdHiHABnUOutmVTtuKRkkZLY+UnRzvTfb281VA+GP10VOYgBauoWpLpjZjQDbuuUikxrx1ppIzkw56lXAgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GBQCzH/P/IYYh+PzivfC/NCzotD9OaMIDHPFPu4qarI=;
 b=f0cQliF8Cte6p5aTm/IngYaGuz2ElnwKxIxdJ+AdQEW+VR92k00YJT1QXGlQ2+j0jdyt/LAKJAuaPhkOQmLK59oqDqgmP+vBgnlZ1VFQpcSIrlfz1S/U6AGHwTwLiVVBmbi+S8YakYO1nmVzpFsRwUQBeyGYZj5rpgkcuxcPjmnZKJ3yRvIKrA98rZ7irVEyN5ipJgLovVP9fb4H9Gr/Q0gxB9tG31eO8LVgdIH5OauHRdBj/B4nNUEuZvKAzaVzEGGPJVpdBgWRKtr8WbJ6b0LKzl6SMhHzqY58ZnQWG+uFH3xfaJHvOcCzBKj2nkZYzlgq41G+tB+JJUMgWaE29Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GBQCzH/P/IYYh+PzivfC/NCzotD9OaMIDHPFPu4qarI=;
 b=LmQNiGjqUEPWztri5/Ic0/ZuG1kv9O3QC5Uw4p2facASN3LXWRWjmql8x4VD4hxNrJFlUf9UJvT6k+Ap6lMswFx21U98J5Gd4WM5eO7aqJUidoBCnL2mW3wbKkJXlX5wSQ2l8qZEMa0///bV+uHR1LDp8pOX6NhvLH6s9wdyTwU=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SJ0PR21MB1997.namprd21.prod.outlook.com (2603:10b6:a03:291::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.1; Tue, 14 Feb
 2023 07:45:49 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a%5]) with mapi id 15.20.6134.002; Tue, 14 Feb 2023
 07:45:49 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Dave Hansen <dave.hansen@intel.com>,
        Borislav Petkov <bp@alien8.de>,
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
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAeE2AIABk95AgAGmoACAAAYigIAAAicAgAAHCQCAAAYXAIAADqWAgAAB8ICAAAP2cIAAK2uAgAU7wrA=
Date:   Tue, 14 Feb 2023 07:45:48 +0000
Message-ID: <BYAPR21MB1688D8BB8DF29D0EE07CFD02D7A29@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <4216dea6-d899-aecb-2207-caa2ae7db0e3@intel.com>
 <BYAPR21MB16886D92828BA2CA8D47FEA4D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aP8rHr6H3LIf/c@google.com> <Y+aVFxrE6a6b37XN@zn.tnic>
 <BYAPR21MB16882083E84F20B906E2C847D7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aczIbbQm/ZNunZ@zn.tnic> <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
 <Y+auMQ88In7NEc30@google.com> <Y+av0SVUHBLCVdWE@google.com>
 <BYAPR21MB168864EF662ABC67B19654CCD7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+bXjxUtSf71E5SS@google.com>
In-Reply-To: <Y+bXjxUtSf71E5SS@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=dae2ce49-f2a6-4dd4-97ad-e9a48449d001;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-14T07:42:38Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SJ0PR21MB1997:EE_
x-ms-office365-filtering-correlation-id: fb883981-13d5-41e6-a704-08db0e5f7d1b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bZ1I/gNP0zUNhujeqeIyW8zLFDUauQWPN4viJgcLdhy427OY1+tZcoZIPu/2WjPkeYru0CZpXStftBnkfWXLCtSLZHhWz7KSMOKnnd2PthHOrFYRd5ymxhIOAJ9emuU5EeTrfM8DDnq6GVOqD3qEPf6UZbzH5+O0B72JLZgsaQ9qQyue/FTIKvQpPwkFt7FFbCKqJnTV2JAkitW5QMrn6cSDsIUc482JttKP7OMxnEqXv9vzxkMUKvitc1PR3kZg6OkYLf1hWPny8M9rUcluRPoUScDXTLxBDnvb0/LsFZ2qqnhPFXZPhDc5LA1ugp6slzLDqDfP7PM8t/hQ/6AZ5UTU4NFHgBuAaIZJ6nExJc4VzoouTiex/wBZUQPw03KTj5mwmR/Mxizm8YbG6VFag4wdyywTffVfVxs7Y85984XS9hJgrdNqvisHbWaGTDGBNYhVWFlAcJPN29Argzh9xvP9CbOqLFdHUwvNtXc+LqOakolyHt9M7rNPFRn1xAUrQS8qbauraLhqBbxFVc4Rst6LBLKkDAJgjxeWeMFXox7oCMnzueLbx2Sd3epnpY7k65DWPWIuGemI9vn4MjZu25aOT4HYgCpNgWjaOj5tLKiKzVWepw0e3M2wqN8GJXSOmglYyWP7mv6RzeOV+7NfJDg1ug3HNSz/QDNubNOKjzGqxLdpfqjDKosrpvwXfStOS8DNOrHKssQaPHEBag/Z7QFUWkgCRCVaWXdtACYWujZqedyzhuCq3epmxXs5m3+m
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(451199018)(38070700005)(38100700002)(122000001)(82960400001)(82950400001)(8936002)(86362001)(33656002)(8990500004)(2906002)(41300700001)(52536014)(7416002)(4326008)(5660300002)(7406005)(55016003)(9686003)(6916009)(53546011)(6506007)(186003)(316002)(66946007)(54906003)(66476007)(478600001)(66446008)(8676002)(64756008)(10290500003)(7696005)(71200400001)(66556008)(76116006)(66899018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0kkVH0Se8wqJ/efuO7O3+S4UhREjMUwAQjq+fsJmT5JYHnZX/Lx4r70CK9Cw?=
 =?us-ascii?Q?arzvvyDZS9S6owgpAw4FmjYmn7eg2emLGRsUalPw6iOIhwtW0nWo83gqm93g?=
 =?us-ascii?Q?VVRcTx5+bL2UjZx+jIjXC5xuYnRtCcOtckJwOV5iWydR+M3stLJZgvDEzbX3?=
 =?us-ascii?Q?y2XUodeGIXif96MbrV61yh7sippaigsJFk2nbD79OBZeZVr6LNS5OgzC36Ze?=
 =?us-ascii?Q?DDireyJ1DanQjJyidlnSCaVkMfuOZhDs79fX18XQ7bvFJMXDgQRJSJEX+Ig7?=
 =?us-ascii?Q?UfuwN324B66d3P1sGdZx/raje4rqL0r5JfPy9VVj3FYwfxmNJ6vEelLlfwRc?=
 =?us-ascii?Q?RVwE579B5Z6W82LVg+wrddm7sMJRy+c9CIZW89r2Kwv0JeAuJNe0qeE/R+J1?=
 =?us-ascii?Q?1QKSuHQJZ3XOoHUZ6C1yQy6fd7v8AvvInOPNj7sqVfWh1GQq+AEs03MAZxG0?=
 =?us-ascii?Q?YZoKEouQT7M3xTEARGS0UpyRYHwkMF/Fu0c9Gq6TXWSb2vUGiZJUI4cVzO11?=
 =?us-ascii?Q?OW/Hqt/HjgbLayfxCz6KFMJlEwmwB1s2iujeMxnRyKP3JCR+sZzygfrMexqw?=
 =?us-ascii?Q?/mU5eGGRyHBZVyt7LIeNYvCZ7jqFBPstBNE6oEYAqpJxqiFcAOIhsp5bmrSB?=
 =?us-ascii?Q?v5tZLGceec4sMqdJ9vVTjZkRC+uCRhbCUBw24lWeaZk0uGd3ISVsWA46gY8B?=
 =?us-ascii?Q?2Ln/ZmVETVtfUClIzvdsWnPYkpEI0IDH/epUnAQyJffKDC5VtN+ZPj7Bq+a6?=
 =?us-ascii?Q?1lC1hPmaFj9gR2EbgDCNk6+THjsOmHBpG2z1E9mjWz6sgIqZzi1PFAWf1yrw?=
 =?us-ascii?Q?cbSJvuUIMY26Kak+aTkOHv/iviW3vSGYPr37773FxJyTbxhw/u/FKA/TKR7D?=
 =?us-ascii?Q?flteFqrs9bI+XFQIZMHDQZ+3iCazbDQ2T1HYof/e04ZJth6br4Pdtx6TemOc?=
 =?us-ascii?Q?HIerlofrJJjlf3o7wsa00STvtP8Ex7KS4TmamFaTHUWw4Zi28JNcL4bT/e6E?=
 =?us-ascii?Q?4CKlRM35/4Z4qbx9neMErUj5gLTXyQs/G9zp2r9bMGOOyOy6nM1W7kjbe1QT?=
 =?us-ascii?Q?lbdmPbewICROOC3fSsg4XOjZCX7CM8yVLXVIKjGKN9rX1eQV6fVJ3vj+mpZ6?=
 =?us-ascii?Q?cpIhXcs5tSdQefUYFlACnYTF7l5FkxFvQ1jRdHzfd57XEoP5H4Itcr+4FOEl?=
 =?us-ascii?Q?6w2I+7pu7uDS/BcK+Kqf0MapioX2YZSPWkMdhXw2z6suHW8NOUFT0VcPUNaY?=
 =?us-ascii?Q?wp3JLgllpismSdo8RTq7qg69OJEx9s+2u+s+NZ0vCvn2kdGiJhjNYkyuFHMw?=
 =?us-ascii?Q?fYBWd3E7gH6sPdy96EMM7hAOVqerHFBKvbs8EYOmNSK8IyRgQHZzdUNX++Yb?=
 =?us-ascii?Q?SDA8W2IFqy4LFBjnApRY+++v6ye1EFTuqKc6gqtAWJqr47toq4a4ynn7OnLi?=
 =?us-ascii?Q?GVBMGyjbD4iH7/C2EJSzs0ZT92xhtvx2c1jN6KWOGV1nwlUfcI6fF9E/rEiY?=
 =?us-ascii?Q?pIVOfreIWDqL3t+ZvGcD3rkAocf22b8Y8NVzUf+s3EcoKeSXFgiUM8/rxgiW?=
 =?us-ascii?Q?aDh9P0IxlMdVuSe0quRmqnR6CKFjbj8agR579ZzuoNtesrLTZbc68HW5lUNH?=
 =?us-ascii?Q?lGMaR6jRq6nKh4lFFpju8B+LSUtRmJLCWLN9PYO4fVA/IhSBoZVUZzBlPOaB?=
 =?us-ascii?Q?SFcHgA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb883981-13d5-41e6-a704-08db0e5f7d1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 07:45:48.6234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LZ5nnsIKEsNxZwwFPlpYizYCMw3mhuKT0tUxr2A37wjNHbGrt6xJVhx0qtCluV772L+cudPcGcF/2UfXtVvl0cFCtxlExriMkPIKiNYScX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1997
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Christopherson <seanjc@google.com> Sent: Friday, February 10, 20=
23 3:47 PM
>=20
> On Fri, Feb 10, 2023, Michael Kelley (LINUX) wrote:
> > From: Sean Christopherson <seanjc@google.com> Sent: Friday, February 10=
, 2023
> 12:58 PM
> > >
> > > On Fri, Feb 10, 2023, Sean Christopherson wrote:
> > > > On Fri, Feb 10, 2023, Dave Hansen wrote:
> > > > > On 2/10/23 11:36, Borislav Petkov wrote:
> > > > > >> One approach is to go with the individual device attributes fo=
r now.>> If the list
> > > does grow significantly, there will probably be patterns
> > > > > >> or groupings that we can't discern now.  We could restructure =
into
> > > > > >> larger buckets at that point based on those patterns/groupings=
.
> > > > > > There's a reason the word "platform" is in cc_platform_has(). I=
nitially
> > > > > > we wanted to distinguish attributes of the different platforms.=
 So even
> > > > > > if y'all don't like CC_ATTR_PARAVISOR, that is what distinguish=
es this
> > > > > > platform and it *is* one platform.
> > > > > >
> > > > > > So call it CC_ATTR_SEV_VTOM as it uses that technology or whate=
ver. But
> > > > > > call it like the platform, not to mean "I need this functionali=
ty".
> > > > >
> > > > > I can live with that.  There's already a CC_ATTR_GUEST_SEV_SNP, s=
o it
> > > > > would at least not be too much of a break from what we already ha=
ve.
> > > >
> > > > I'm fine with CC_ATTR_SEV_VTOM, assuming the proposal is to have so=
mething
> like:
> > > >
> > > > 	static inline bool is_address_range_private(resource_size_t addr)
> > > > 	{
> > > > 		if (cc_platform_has(CC_ATTR_SEV_VTOM))
> > > > 			return is_address_below_vtom(addr);
> > > >
> > > > 		return false;
> > > > 	}
> > > >
> > > > i.e. not have SEV_VTOM mean "I/O APIC and vTPM are private".  Thoug=
h I don't
> see
> > > > the point in making it SEV vTOM specific or using a flag.  Despite =
what any of us
> > > > think about TDX paravisors, it's completely doable within the confi=
nes of TDX to
> > > > have an emulated device reside in the private address space.  E.g. =
why not
> > > > something like this?
> > > >
> > > > 	static inline bool is_address_range_private(resource_size_t addr)
> > > > 	{
> > > > 		return addr < cc_platform_private_end;
> > > > 	}
> > > >
> > > > where SEV fills in "cc_platform_private_end" when vTOM is enabled, =
and TDX does
> > > > the same.  Or wrap cc_platform_private_end in a helper, etc.
> > >
> > > Gah, forgot that the intent with TDX is to enumerate devices in their=
 legacy
> > > address spaces.  So a TDX guest couldn't do this by default, but if/w=
hen Hyper-V
> > > or some other hypervisor moves I/O APIC, vTPM, etc... into the TCB, t=
he common
> > > code would just work and only the hypervisor-specific paravirt code w=
ould need
> > > to change.
> > >
> > > Probably need a more specific name than is_address_range_private() th=
ough, e.g.
> > > is_mmio_address_range_private()?
> >
> > Maybe I'm not understanding what you are proposing, but in an SEV-SNP
> > VM using vTOM, devices like the IO-APIC and TPM live at their usual gue=
st
> > physical addresses.
>=20
> Ah, so as the cover letter says, the intent really is to treat vTOM as an
> attribute bit.  Sorry, I got confused by Boris's comment:
>=20
>   : What happens if the next silly HV guest scheme comes along and they d=
o
>   : need more and different ones?
>=20
> Based on that comment, I assumed the proposal to use CC_ATTR_SEV_VTOM was
> intended
> to be a generic range-based thing, but it sounds like that's not the case=
.
>=20
> IMO, using CC_ATTR_SEV_VTOM to infer anything about the state of I/O APIC=
 or vTPM
> is wrong.  vTOM as a platform feature effectively says "physical address =
bit X
> controls private vs. shared" (ignoring weird usage of vTOM).  vTOM does n=
ot mean
> I/O APIC and vTPM are private, that's very much a property of Hyper-V's c=
urrent
> generation of vTOM-based VMs.
>=20
> Hardcoding this in the guest feels wrong.  Ideally, we would have a way t=
o enumerate
> that a device is private/trusted, e.g. through ACPI.  I'm guessing we alr=
eady
> missed the boat on that, so the next best thing is to do something like M=
ichael
> originally proposed in this patch and shove the "which devices are privat=
e" logic
> into hypervisor-specific code, i.e. let Hyper-V figure out how to enumera=
te to its
> guests which devices are shared.
>=20
> I agree with Boris' comment that a one-off "other encrypted range" is a h=
ack, but
> that's just an API problem.  The kernel already has hypervisor specific h=
ooks (and
> for SEV-ES even), why not expand that?  That way figuring out which devic=
es are
> private is wholly contained in Hyper-V code, at least until there's a gen=
eric
> solution for enumerating private devices, though that seems unlikely to h=
appen
> and will be a happy problem to solve if it does come about.

Yes, this is definitely a cleaner way to implement what I was originally pr=
oposing.
I can make it work if there's agreement to take this approach.

Michael=20

>=20
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_api=
c.c
> index a868b76cd3d4..08f65ed439d9 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2682,11 +2682,16 @@ static void io_apic_set_fixmap(enum fixed_address=
es idx,
> phys_addr_t phys)
>  {
>         pgprot_t flags =3D FIXMAP_PAGE_NOCACHE;
>=20
> -       /*
> -        * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgpro=
t
> -        * bits, just like normal ioremap():
> -        */
> -       flags =3D pgprot_decrypted(flags);
> +       if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
> +               /*
> +               * Ensure fixmaps for IOAPIC MMIO respect memory encryptio=
n pgprot
> +               * bits, just like normal ioremap():
> +               */
> +               if (x86_platform.hyper.is_private_mmio(phys))
> +                       flags =3D pgprot_encrypted(flags);
> +               else
> +                       flags =3D pgprot_decrypted(flags);
> +       }
>=20
>         __set_fixmap(idx, phys, flags);
>  }
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index 6453fbaedb08..0baec766b921 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -116,6 +116,9 @@ static void __ioremap_check_other(resource_size_t add=
r, struct
> ioremap_desc *des
>         if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
>                 return;
>=20
> +       if (x86_platform.hyper.is_private_mmio(addr))
> +               desc->flags |=3D IORES_MAP_ENCRYPTED;
> +
>         if (!IS_ENABLED(CONFIG_EFI))
>                 return;
>=20

