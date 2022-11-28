Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0784F63AB79
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbiK1OoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbiK1One (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:43:34 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022022.outbound.protection.outlook.com [52.101.53.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623A2F4D;
        Mon, 28 Nov 2022 06:43:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hdmci4KXqfS9gDfZmjAc8F16cVUvJ9rVJO1lY3EpN5xcGsYmoaeUtnEQCfuunhxeaxkP+pyxC2xa+yV+ix5owVtvYF6NHhJm8IdQJ7LdxA9pAH3e0XHvUhNNCQBRKzWYr2LJzu1cTpRhfI0+gB6azUFwRBMWYSL+rN3E0ff2icJF5jnS0TwAXgnMV5gQX997sNXk3ioKayN9v7Bu9NNvJcYyNVKMsljFXmwc1XLuAdpjg4kHkAfkrikb0SETEgwvyk1bRGRcqcQ1cjpPMlGFoPxTbmCnoqyBAvxDO/23rGtDU5Op+v+vn8XhpopNhXix67kdRdV7uVbZPwEc+N8y+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IbxIBpWIC1pB2oR37d8mqGU2QyfwTS1TPXwRBBV0QHs=;
 b=U3YQT+WI3SC7btlgvgsknPALvPSbAX4FTqFg/8Ur/FGd7wtMcj1K2oLbP7pSeMY2S5Yxx+7KfhUcTyma02Js8/WrBGVQkryCejzXaDTGC9FM7B9tTFG7DdvQXIU//XOVT1So389WTB8ph8rqf5YyO91P6OD6Nqk3TwLfT6zOGLwYY1vrWAzi2UibXIWZPvCZXEeUFFdXlrMggdkUa8Lqa9JEMAX9Aa7E2Oyq/l4Jh/Yr/I0HfUID9dQNYFMq9ptCjgI1GwtUVRTWeoHYIpveDJZ302CTgqtfd9RRVGZwFXJvdvW1PCl8EzWLeSwaielhy3EDIj/ScNSzGDCooVWZiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbxIBpWIC1pB2oR37d8mqGU2QyfwTS1TPXwRBBV0QHs=;
 b=OAWl+cNEunCCMWZcwjUuAY5oatj5l5TySZ4TVSILMu2dKtvcDHbeg4VXZVU5UF+bSw4+MDU7IM4etXEzXjSTj8VpV9hXNiTobo+4cWdzUwyvREyjrvSWtUM4X2l9uAooT2TF47FndyM+CO11A8RVJbpXuoj6AYfVm3tuSP9yG4c=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DS7PR21MB3342.namprd21.prod.outlook.com (2603:10b6:8:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Mon, 28 Nov
 2022 14:43:29 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%6]) with mapi id 15.20.5880.008; Mon, 28 Nov 2022
 14:43:28 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Wei Liu <wei.liu@kernel.org>, "bp@alien8.de" <bp@alien8.de>
CC:     "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
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
Subject: RE: [PATCH v4 1/1] x86/ioremap: Fix page aligned size calculation in
 __ioremap_caller()
Thread-Topic: [PATCH v4 1/1] x86/ioremap: Fix page aligned size calculation in
 __ioremap_caller()
Thread-Index: AQHY/pnBKtjG2pB9XUmkHUxGJNjaHK5PxXQAgASrlLA=
Date:   Mon, 28 Nov 2022 14:43:28 +0000
Message-ID: <BYAPR21MB1688F9B7FC41946DBD9F8784D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1669138842-30100-1-git-send-email-mikelley@microsoft.com>
 <Y4DdCD7555d2SpkZ@liuwe-devbox-debian-v2>
In-Reply-To: <Y4DdCD7555d2SpkZ@liuwe-devbox-debian-v2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5e8c05f8-053b-48bf-89fb-051a344f1c55;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-28T14:38:44Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DS7PR21MB3342:EE_
x-ms-office365-filtering-correlation-id: 9e9adda8-4228-4a59-a6c2-08dad14ee9b9
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ymZFcKKJD1zuJkPnYnBpTYgXhsX0KF0aOE5C4aI64Ijpi0UCHErGx7T9x7SalhAskxpuNK1JtYG5ioxRIQCbChtEdvQ71gbXyLHJHPbe0MBIpZ1c7y6JKWyAjVGFNOMsjEO407wvuUvlfHkNMqCMn084sUchkI+QO0dklUH6dCchkc3mabvwxc2Ejw3yZHaBhbYqCRlya+9wnfzEJv9C1BHwonc1ZOvIzEAZtpoJrz+Yv0MZYmCKtPDyRIDyVqe8w1wLEpF1qqm/ICsyg5wn9lfjD3oKNBCUMsRi7shfTGyHkDGMczQIKPk5+IOv3PNEJrXOtQibj/guoliG5vUKdgFrop+8s0CcvGTfw25xM7rhXH8vd3Y8VuNhjsbM5G8SWtHHU1I0TrsV09hznaE/X+Xwll6HKimpKe6AK7ttFP87drrHKOZr9P+1+FFmD27UoqsySn1dddimxBgRE7+w+4MfZ96mFEs2NoWK2Zb6PS8Fpb7OweD6lY48r7tEcx/oQrDENthTjJoyVJRPZYoL86jsL8jnlx9uPBlmJ+eXwAbojoEG08MWcOQByXlPWFEoX7rga+/sEH3LqpKHsvHlEPljE+wMRBTagsw2vfECqf4r23JW40YL7Kt7AWnqzczDgub9xhg0VTzBzvq+rnuyCUnKz6VtGpTHhaeoVLnW/NbZT8k1PnARg97Rm/ts+P0rAwXpq3jGS8qF8xmjm8M8Af5e+BJm7rCh/FSm6g76u6Pz4G1bmLy/OxCBY7gMOyeqQUmCxI0R5sCvXIRtWxmgJFz9iw4qGtIxVdxT26ewYj+SFtnufRt7vXcFFKWuv2R8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(451199015)(4326008)(83380400001)(38070700005)(86362001)(38100700002)(122000001)(7416002)(5660300002)(186003)(82960400001)(82950400001)(2906002)(7406005)(41300700001)(8676002)(71200400001)(8936002)(8990500004)(52536014)(64756008)(7696005)(6506007)(9686003)(66556008)(55016003)(66446008)(66476007)(26005)(966005)(66946007)(110136005)(54906003)(10290500003)(76116006)(478600001)(316002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0Ix3Kp4DlrUxlOxklCCQoWhiclPLWzYVrS6ErmFQ+j7cO2PsnBKl4K5XL1lj?=
 =?us-ascii?Q?c4Mw0StqFCW2Xty5AmWa/wrYUZynzR7WGYG+jt7JgXqEXWKfdR2gaxVnwnhG?=
 =?us-ascii?Q?Nv723oFoNRInkMiXvXmjgr+KKcmqZr3PgklaW/gL1MCU0qNXt245Ufa6I8PH?=
 =?us-ascii?Q?kOl+99R9EGOqC4WkWcSUL2wp7GEw42j20eSTVY0wWdzrIRphY+x2ey04b4ry?=
 =?us-ascii?Q?UatI1FUWJldkOvxE/49jXkO6kJ5RekV1pszDTUKOGLgTDQAPO+yAs3E/l1y2?=
 =?us-ascii?Q?LLVNVvA+qlYEjoh7Esb/WWrOhhg/LBaF6CVCXaJW7dTI+vnyFpqbe+YXU4dk?=
 =?us-ascii?Q?liqtXTlgoFGvhjc/ZUqfq5glMGiQPt5lb6BAz3Tgh3rfZvohkazvR7suY5Y5?=
 =?us-ascii?Q?1Etf5NUmg9DxHyLW5siGA77t3GqwgPjm6iSQ2I0yUK9Z+lxhUqbwmmYoKXjf?=
 =?us-ascii?Q?UUS60C3Kx0pJTdv9KQavuUeRuip5uirEjXym5N0wYy0PAGJa8k3YPM/BPLtS?=
 =?us-ascii?Q?b9VFQnQatGVz9l0oxYu/7H1XMduU5FLg4G7JCIRV5nFoYTmss06sQhyQ987K?=
 =?us-ascii?Q?sgv/RbfXXQeyLJ6YbptuT+3lN5qZOG1hFOan0/zrxwW26yWKjFP2gUquHtre?=
 =?us-ascii?Q?1mozvz6viLGv4ScEYgiU1uA7Zm3j8VHNqYuNGoxnBJVzpVhGV9Lxxj32uSMr?=
 =?us-ascii?Q?nJT5GB8qqMRp450wV35GZQpAmtOaQcFCUfRl69r/xfUhA2iZhYTE/omo6sOH?=
 =?us-ascii?Q?Lo6/qZ+lFKdLmPEItH9vztePyB7EhrXFchm7CyvrWmwcXRJgpC8nCSYC4BEu?=
 =?us-ascii?Q?QFxdedeVxUIR9Ftccn7+nr/0NJI75CfdKJkw26iWL0S6Kx9hiFQGQuETAIXp?=
 =?us-ascii?Q?1vkC/6sDS/H3KjMUNdDX40oHA7yCHk/I+ZoMqsC53fWT3sm4e4BWebHzbEms?=
 =?us-ascii?Q?WT2JPnP5QPXXPyr/yghkK9dY4c8LkhrO9B2Dbxd4A2rZ3BTu4tEn0K2KQRh1?=
 =?us-ascii?Q?BuTXCaL3RzjGP/fRa0Nt684n2JlS0L3IcjPCNn6b4Em8yaN7VN+fnZNf1RNw?=
 =?us-ascii?Q?QSU8cCxFl7AVDD+AXpVnzHH6iVRudu2iTN6PDQvYYBxXEZePJKeOQ5d8LMLS?=
 =?us-ascii?Q?N/BScCwXdj7qFssQP2MECXnKRJJRQhSHQNw3ys5qlquNY2d+QKWKx5zGExzW?=
 =?us-ascii?Q?Z4sQjmet572rGHZtl7EnWmrS70CsJdx5wCMvHBjnMz/jK8f6dDPou6swizOy?=
 =?us-ascii?Q?+FVs3bDCKKJmdO4MH0U5LN1oQ+FYq1R/KbikFOXZ5GgV4+Yd0mcPjXtAZ0Ge?=
 =?us-ascii?Q?4ghpQK+44A7gtZd+NYYwreErKBg3+krA/6verOnUmxriicXucn0T130C2w4Z?=
 =?us-ascii?Q?8GuEk6d1VQpBQwaL8PWFyr9/Sv+p4Fn2MPQSo8/8miE32zywFhslKHpUOwas?=
 =?us-ascii?Q?B4N1ezl+nxtGO89+TAamvKjIde/Jn17NyNBFjb4On7cMF9VMriFxWENg5zL6?=
 =?us-ascii?Q?cCLSB9bJw2RFc8LVNvm8OHhr/ptU6RnO6poTkzsjrDcR7wI1PtEYuS9kuNmI?=
 =?us-ascii?Q?v3PJdVKziQuAgA/BtBdfmIPa3lWHTeHwVdBVGt84j9XWmhtVElOylNC0DEGa?=
 =?us-ascii?Q?zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e9adda8-4228-4a59-a6c2-08dad14ee9b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 14:43:28.4633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9dkvG0KatYOQpeOMnWgn0goIEXTHrvtYB+LpoYyKBUf7VBliHrSB+Z85hb0LoJ1kJsGOJVoSnvGgwSM2MKa+1c8oGTpoKud/+rJxSQqM2B4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3342
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Liu <wei.liu@kernel.org> Sent: Friday, November 25, 2022 7:20 AM
>=20
> On Tue, Nov 22, 2022 at 09:40:42AM -0800, Michael Kelley wrote:
> > Current code re-calculates the size after aligning the starting and
> > ending physical addresses on a page boundary. But the re-calculation
> > also embeds the masking of high order bits that exceed the size of
> > the physical address space (via PHYSICAL_PAGE_MASK). If the masking
> > removes any high order bits, the size calculation results in a huge
> > value that is likely to immediately fail.
> >
> > Fix this by re-calculating the page-aligned size first. Then mask any
> > high order bits using PHYSICAL_PAGE_MASK.
> >
> > Fixes: ffa71f33a820 ("x86, ioremap: Fix incorrect physical address hand=
ling in PAE mode")
> > Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Michael Kelley <mikelley@microsoft.com>
>=20
> Reviewed-by: Wei Liu <wei.liu@kernel.org>
>=20
> > ---
> >
> > This patch was previously Patch 1 of a larger series[1].  Breaking
> > it out separately per discussion with Dave Hansen and Boris Petkov.
> >
> > [1] https://lore.kernel.org/linux-hyperv/1668624097-14884-1-git-send-em=
ail-mikelley@microsoft.com/
> >

Boris -- you were going to pick up this patch separately
though urgent.  Can you go ahead and do that?

https://lore.kernel.org/linux-hyperv/Y3vo5drAFPQSsrF4@zn.tnic/

Michael

> >  arch/x86/mm/ioremap.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> > index 78c5bc6..6453fba 100644
> > --- a/arch/x86/mm/ioremap.c
> > +++ b/arch/x86/mm/ioremap.c
> > @@ -217,9 +217,15 @@ static void __ioremap_check_mem(resource_size_t ad=
dr, unsigned long size,
> >  	 * Mappings have to be page-aligned
> >  	 */
> >  	offset =3D phys_addr & ~PAGE_MASK;
> > -	phys_addr &=3D PHYSICAL_PAGE_MASK;
> > +	phys_addr &=3D PAGE_MASK;
> >  	size =3D PAGE_ALIGN(last_addr+1) - phys_addr;
> >
> > +	/*
> > +	 * Mask out any bits not part of the actual physical
> > +	 * address, like memory encryption bits.
> > +	 */
> > +	phys_addr &=3D PHYSICAL_PAGE_MASK;
> > +
> >  	retval =3D memtype_reserve(phys_addr, (u64)phys_addr + size,
> >  						pcm, &new_pcm);
> >  	if (retval) {
> > --
> > 1.8.3.1
> >
