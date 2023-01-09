Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A192662CF1
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 18:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbjAIRhM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Jan 2023 12:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjAIRhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:37:04 -0500
Received: from NAM06-BL2-obe.outbound.protection.outlook.com (mail-bl2nam06on2100.outbound.protection.outlook.com [40.107.65.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81788122;
        Mon,  9 Jan 2023 09:37:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUNPhUgL4FTee0wPs553HY8U7sPM+BMVVfmJNFsLCfp0xSEa2yVQAP6g/XM/pKbNMCgfGU7DD7ro0fKefYfO8cC0Yynx+Ko7B/9LGxoeCAdos/kYBDhtYoAyfCjg4u+O3BwBbG0QiydaVTjcQrHu58qtdimr5OIVkovZChknTn11KjhpJdYsO4H4Zxylg0McsPIWiZQPZwBXdK3jW/Q28GwR71FquMrlM+TuCSxX5vAxH8Dy6S79ivjd1X8tmbcrHv/PHdaFt994VxMnaNfi8VaVvJosICuBgWcxEBJVsbfjwHrYKAg/x73UgB86WeSeglH5CLKVltWyw8GNUcJ1eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edRiFYw9gG3Ptp47FmkhwJck+31/m/mfwXy/CElgrPc=;
 b=WMSAeDe7tmg480addzb19CqDM1bP6k3xvzK4uuDI4RejlkZrnjUn1Zxtz2qMyJn4yresrWqgeGLOsJ0SA38ZL9lmBBzob8iz5S5PXdI3T0SU2NgHlzt5h/3pz0NQK3ccMUQvFsskTdFqeu/wtXeq7W+25n1O0wkdhEqVu7xa5kJ5j6qawaWzswIQ+kxrWyuVl1X6v6+6UMeMRg/rYme/EPyul/CcgXdstS67vx9JYiK5QZP5Zo85kiQbfnuuXJ5phhC6Nlxn2aX7TKXLDssH6YmlQlghsVjkbzSzVRBcVDVQuVhd2TFYos+FpN1rruVRzHFX6Dnhzo2xvzo9inPIlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by CO1PPFF9F90C361.namprd21.prod.outlook.com (2603:10b6:30f:fff1:0:4:0:12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.9; Mon, 9 Jan
 2023 17:37:00 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::db1a:4e71:c688:b7b1]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::db1a:4e71:c688:b7b1%5]) with mapi id 15.20.6002.009; Mon, 9 Jan 2023
 17:37:00 +0000
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
Subject: RE: [Patch v4 06/13] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Thread-Topic: [Patch v4 06/13] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Thread-Index: AQHZBf6t6ANAbNIeJ0+xGWlNnYd7aq6WhaYAgAANReA=
Date:   Mon, 9 Jan 2023 17:37:00 +0000
Message-ID: <BYAPR21MB16889518EB304B1A95FE7D22D7FE9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <1669951831-4180-7-git-send-email-mikelley@microsoft.com>
 <Y7xDDNMIDyHKLicG@zn.tnic>
In-Reply-To: <Y7xDDNMIDyHKLicG@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7bf203f5-46e0-4c75-b114-2484064f1313;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-09T17:26:05Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|CO1PPFF9F90C361:EE_
x-ms-office365-filtering-correlation-id: 4ae1af79-c20a-45e2-4b2c-08daf2681d10
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sPm37+Wa2rjze3I/ziRd9ja+BwCSBNho0EWeP0SyjgbjoNZb/4M7EKV0lSWtLQkNbxiAAI0knozyacJM4pp2kTLRoefyXduDZT/dd18jXp+u9Z/kMAZAdQ/BFddtk78sp5RMgqqTAgDh1RSc/IUslk0ODw+tOXKmWgOWQcOxgoRVQBojbb76hkV1E1WzKUYNm/M9H4iiRiH/FJqlj8drXPDm28YzxqMSXQ3P4vI4FQO4EXTe5jF0NIlMf7m6Tud2dhaN72W22Mis9v+m+4xbA+c3in2bYz7tkoMenFc2m5dshYTWzwgv7DiXSoxREkxX6NUV6iAUUJY7Hu/gAaXYMiqtR29MohrSfMZNqKglVydSB/DYC1R4IqVgvIHxGashVrCk37AmrrJfN1B+ghaNzTP7lsNW62SRWF/2twF66gROI3LcmsaiJycAG1H/K9zMbadEWOqciA2kve0mo2dQ/EtIbbBpCRIicIgsSfUhO1GEJlMgoJ7msThMEOn2m/6I1xLy0lAQduZWTdJzFnc/3CZM4u5ekUMjb/8LSVl7B4CcgKV9xX19Y8TnSi20UZZyd1e+5to8XR3W2ZLutxxW0iMdpuT6nncdk6Q4jIPizVIUrYQ/MOrrSjQtPJWAZCbQTtMgLa2qZC76gy+iWGZt8t2e7E+/GEz+UaVPH4ezvWjVDALraGFFfgww6hlx+bGZnSZJn1xh6wR6uDbNCsc314jdL2SYNfJA5S6t1v8W+Y8K8SJofrUJWoVfAAthhynL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199015)(6916009)(54906003)(38070700005)(41300700001)(38100700002)(478600001)(2906002)(316002)(122000001)(82950400001)(82960400001)(6506007)(4326008)(83380400001)(33656002)(64756008)(52536014)(66476007)(66446008)(8676002)(186003)(9686003)(86362001)(10290500003)(26005)(66556008)(7696005)(55016003)(8990500004)(5660300002)(76116006)(66946007)(8936002)(71200400001)(7416002)(7406005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ot+WLmUbIZ/n8kJxQ5/wHNIMh8VI4r93OF3PtJU/0nzXpTPnbexPrbHunsvu?=
 =?us-ascii?Q?FYsXmbk0dH5QnjSdqEcu4cSgROfnFxdKJuerj49ZE6G20e/IkhSUe7+OiH60?=
 =?us-ascii?Q?bMqDQlHFZtJv64ecgqlUv4L3owyl/nMzkCDyv+OB/L9rP4l43u5u256pxVQK?=
 =?us-ascii?Q?KbQmDXhi+dOjFoDTpLFrwBTh6QskBo/uvGGb7/CTR4sZ/gFBeny+2Ld0CBlU?=
 =?us-ascii?Q?f7b4cWwZNLtg0KTncDzy82Y/ekrB/9o/D2fM96jSzdvFsKs3W2yEJRbOnKsY?=
 =?us-ascii?Q?yhGoAA29KSyrq7pGd2QXfYMPtnbXe++HIutnHDK3uXCqauuWg95SwZGjdEmW?=
 =?us-ascii?Q?jxTdgmxB/SYUCzljXz+ljsyMrNCtCVBUZ7Mwb3eE9W/0dTZhPbDRfwFTjgxc?=
 =?us-ascii?Q?jsPmog8BPWD2LWwPV0qJELuC+LEY0DSkXBzadY4U9OFbxIamtEwVDQ3a8oXT?=
 =?us-ascii?Q?dBeNRtXOCn2CYBW7qoqoppynO5cbq80gBCxyX9oIeMXS5tqzYDzPVMaUzkc5?=
 =?us-ascii?Q?pJOLjHtoa0V0nbySxIEnJeDvff4imYWLoELYKbhG9o4glk4Yerv+ZllHxR8l?=
 =?us-ascii?Q?WIO4SMQbC3UlB5vcWmvo3u0EWK2QN43qwKfWRnKZ4MSX3ANMq7nKwnLQwK6c?=
 =?us-ascii?Q?4bLZqvmftq+FU7pfibOLLkz9xmqUb95UGOwMzjqOgbkqfklBN7WkKgsrD+3U?=
 =?us-ascii?Q?9pZR4kyAjXZK7lDlSMSFwGAESTxvSbLUAfd0Gn3aPuHPiqv6tGMKfrRR6DoK?=
 =?us-ascii?Q?zWUvaKULzvK8ytDVquSETypby71vvRgQ8awEUyxdR6nX5u9fTpy/u45AZh9c?=
 =?us-ascii?Q?SROLUc+/qYYnq3Q4oAnT3voExg43GsgXD4LXshD/Psg6yl6l7rmHOzU5S2wu?=
 =?us-ascii?Q?TV7lc7/7qF/Bd1gCFlAfv2KDbz2Zo9l15dvAlPoR+c/BO+AWvxbvtEpCY4ef?=
 =?us-ascii?Q?wo+tUalJ5lNtD8RDkCdZoEtRhFOr1kKBKDkCv06dFsTjFshoVqiRIwkV8Ex8?=
 =?us-ascii?Q?Eb6Jd1HXoL0/h9nOcSnQEWs1UDd1Esdn5gC0SeqZiW38S+7SRgBNDEMEEInN?=
 =?us-ascii?Q?8/nZ7fjEmXo17kGa05/H//ZuoPyrJFzoIigb3t1j+4kXmO/wE0PFn4tyqhYL?=
 =?us-ascii?Q?yLrwvyf71A6mfWG54Vpmoob9Ft7mU0KgTa0YVcbLJ+LLp7/2seWOCCDB+VUi?=
 =?us-ascii?Q?nh5C+IFwzFV/Yvru7bYcO5YtoySzdy4eRWmtuFqCKjGD8Qmi97UmQyCoeCBE?=
 =?us-ascii?Q?NYSiEAXwV/3zjBl/OBRBxrJhfIFXhmrL0nFjuyA9PGL7ynntxMOBuOo7wMGx?=
 =?us-ascii?Q?T3ejl/+o2wggUT8mmn70JCiLZgRPsrym+lxp1oI8KnlHOcEanB/pxmQP7+td?=
 =?us-ascii?Q?V+zJAnXsdAw57eHB1BQDbmmM+40rFC4qnFnqNCbtEpbaujpVTz++rlzjF3j0?=
 =?us-ascii?Q?8dnI56UgPVOiyxuGQ/AN/Jt2GL95bVdRkYPirj/LcgykR4Nck1C2Bwd21+Po?=
 =?us-ascii?Q?JhC7fIk1SaE02JPCZUfEOahSh7L3Hu7LznVpUqnvWhBTFAvKcqESu6Xbs9P7?=
 =?us-ascii?Q?aa6ht8GrdenLXrHaaBcGZg7znm2gVNIFDwjy9kB2gCBM1V3mAXJyNIicZwEm?=
 =?us-ascii?Q?Ww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae1af79-c20a-45e2-4b2c-08daf2681d10
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 17:37:00.4161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WWwUwVo9ZatuBmUFQZ+HW6h2Wf6nE/yQDVW3AaBGqne3HIRhrhovRjsiIjM65qJr3l9vRqLFl3A65iGG5BaJqVL15ouwcrMKqSaid5/PNZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PPFF9F90C361
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        KHOP_HELO_FCRDNS,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Monday, January 9, 2023 8:39 AM
> 
[snip]

> > diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> > index 49b44f8..c361c52 100644
> > --- a/arch/x86/coco/core.c
> > +++ b/arch/x86/coco/core.c
> > @@ -44,6 +44,24 @@ static bool intel_cc_platform_has(enum cc_attr attr)
> >  static bool amd_cc_platform_has(enum cc_attr attr)
> >  {
> >  #ifdef CONFIG_AMD_MEM_ENCRYPT
> > +
> > +	/*
> > +	 * Handle the SEV-SNP vTOM case where sme_me_mask must be zero,
> > +	 * and the other levels of SME/SEV functionality, including C-bit
> > +	 * based SEV-SNP, must not be enabled.
> > +	 */
> > +	if (sev_status & MSR_AMD64_SNP_VTOM_ENABLED) {
> 
> 		return amd_cc_platform_vtom();
> 
> or so and then stick that switch in there.
> 
> This way it looks kinda grafted in front and with a function call with a telling
> name it says it is a special case...
> 
> > +		switch (attr) {
> > +		case CC_ATTR_GUEST_MEM_ENCRYPT:
> > +		case CC_ATTR_MEM_ENCRYPT:
> > +		case CC_ATTR_ACCESS_IOAPIC_ENCRYPTED:
> > +			return true;
> > +		default:
> > +			return false;
> > +		}
> > +	}
> 
> The rest looks kinda nice, I gotta say. I can't complain. :)
> 

OK.  I have no objection to putting that code in a separate "helper"
function.  The only slight messiness is that the helper function must
be separately wrapped in #ifdef CONFIG_AMD_MEM_ENCRYPT, or
marked __maybe_unused.

Michael








