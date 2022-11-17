Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F1862E147
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 17:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239909AbiKQQPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 11:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234968AbiKQQOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 11:14:55 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westus2azon11020020.outbound.protection.outlook.com [52.101.46.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04AF73B8A;
        Thu, 17 Nov 2022 08:14:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IaYnTUnedCIGkB69IIOxmgOXuwiKN3agHp+RDV45GR+dwx4aY8RltX8+slUsL+uGOkLmIo2HYh94yci5i26SdIn4dBVCE712diNQSAVkGVk5XlVKhCBrlbwXGRCTzjuCdzJH7dJ241ZdtlcxnFGUJ4kvTI3lngFPOJrjgyQZzzdSzjnBL3uoUv6vbV+8EpTFvLYp/Mt2PSKBauz1ha1WSx9cqQLRVJ5U3N2xJ40FevNhYhAxg09Y7xyeH8VGRDOC+b0qJNamY9GoXwN2JVCgQM23rKZx2DElwlJmuhfi86VgZ+anHZugGOTy776UMcKZW/jYxiBWrKFfjjwhpkP/vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k0+51ET5fN3JGrcfV0Ha3oiOM5W5x+Z1Hx9xmpCaCNo=;
 b=RvSRX0jeutJqTqyhVQUcS1Go1Agd8zU3p+8iKpx72C++o/LwaWIJ9FlmOJUwJrNLFtuMevW5K2fZLmxWLPWWK5y+8MM+JOo3jB77soXZ4y8v7JTwxg7537FZ2zORVEAo8g22s7E2W5fjS6Bf2764eL9x24pVqPg1kCn2VzXZwAzkPCY2lzHATrqLif0mw2AuIw47oSzFl9OvcbduwWNwQD4ZaDiBWEaIKsTCLd6ZKhEZJzrxbpur6/CBnz0hPLmleYvlkraMYCWaRQ8VaiH8/qaRHe/wF+SZtOnIZX1pxZMiNyQohm8k1O2ennKjCLXtX7B/nZ31ph8k7PLPI3HDPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0+51ET5fN3JGrcfV0Ha3oiOM5W5x+Z1Hx9xmpCaCNo=;
 b=TTw9Ny2t29vwQHYz7b24lSjSazw8oyHV+pOym7gAoiV+Gn/Acjk+bH4L/XhunyKfxCam1WnyvXHINt0ffL+RSingfi5Hb1giyeVmFjiiC8u+PLrY7MQ6wtN3Xt6iVlIEtO5S5OQP8I2fWYBg6j8ZMm8FtI3aHmqOBRrdIfZ9XKk=
Received: from SN6PR2101MB1693.namprd21.prod.outlook.com
 (2603:10b6:805:55::19) by CH2PR21MB1512.namprd21.prod.outlook.com
 (2603:10b6:610:8f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.8; Thu, 17 Nov
 2022 16:14:45 +0000
Received: from SN6PR2101MB1693.namprd21.prod.outlook.com
 ([fe80::bd63:35dc:eb6e:3c9e]) by SN6PR2101MB1693.namprd21.prod.outlook.com
 ([fe80::bd63:35dc:eb6e:3c9e%8]) with mapi id 15.20.5857.007; Thu, 17 Nov 2022
 16:14:45 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Wei Liu <wei.liu@kernel.org>
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
Thread-Index: AQHY+es8ed4NTpMKIkC2HrScaVa/VK5DO1YAgAAO7JA=
Date:   Thu, 17 Nov 2022 16:14:44 +0000
Message-ID: <SN6PR2101MB16939A620AE1C8C7D98816A5D7069@SN6PR2101MB1693.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-14-git-send-email-mikelley@microsoft.com>
 <Y3ZQVpkS0Hr4LsI2@liuwe-devbox-debian-v2>
In-Reply-To: <Y3ZQVpkS0Hr4LsI2@liuwe-devbox-debian-v2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1b916e67-6612-420f-b8e5-935a432a8d45;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-17T16:10:02Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR2101MB1693:EE_|CH2PR21MB1512:EE_
x-ms-office365-filtering-correlation-id: fe252482-78a9-47e5-8ca6-08dac8b6d75e
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vJl9sLed8Wu/dNSvP5rj4vLXuJiS2rqMsdP28cV2YbNNlSJ4BpxN4mHsJQ8qOf8LwFUE/7YVa5dq8+7j0zcbBpv9k8RelVLBHgUC800QnClV4mdaYXqIr53oEgCdSRQVIsTX0Kc3EtuHGZMWuGXLa3ACKOu9LCeIIfGHKxdFuTzuDp4BxaJSar+vojtkxDTZeDev/gVubcydKaSTVH5EUMs5dYSt6nPouByawMRigNZBKb5tJ/Zz+Wdb5cbKAeEJmirmfSkldYeZxsyL/AdINJgKPw83L6RqwdgccU/qW5GV1AdG7va1TGlefVV6Sr23MIVcqnwtOfSNRXYQ3pA2mYfK0myF6s5mFnXjMYosLzCFeRQIFSrm1Rv59h3dN1aN9ABnVK0SnQvH9T5HFmYmyKQZ8bQUOl2l0Xmb3Cx/fmIaISTYcnoaV537+V8gEdsXCPchhUbXWEirB83gaKNo5+XvtZtUAn0SUlR+a4ieZNGgnFcITXQxxATTQcGBRD0+6kwkN5yOVAADZoPLIw8BNuPIhU2+uEcqFM/wisdKzRLm7eznNsG+beY+cPPk4M3JGtMjPFd59fbu/PK34QVenqvnBG1MzjHmkcc/ZOGwQbp9ikY+EyVvlEWPD3KFu6PnnSZ2UfB9xkG0roGGAigNpNlKD5+1qi/oV6UnIIks1w2EDGWOQBo1u8Oqeb/dbd/Tt1PkbcBIbBYgB38XPiuR7UVo49MKQy3gYIrWM8qKQ/PRqgbyza/bhyNvMvxgRjDO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1693.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(8990500004)(2906002)(4326008)(8676002)(7416002)(8936002)(52536014)(5660300002)(41300700001)(76116006)(66946007)(64756008)(66556008)(66446008)(66476007)(33656002)(122000001)(10290500003)(82950400001)(82960400001)(38070700005)(83380400001)(316002)(6916009)(54906003)(86362001)(7696005)(6506007)(26005)(71200400001)(478600001)(55016003)(7406005)(38100700002)(186003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pNyOc8c7Q1hQO4I9si+DC/918J+rb3VoARSMwBcwDHbyo0XFbNI86OOaOELa?=
 =?us-ascii?Q?B911FCb373WUFYFkLxuFnurZ2BQICRGNc0Tncgn2nDOzTYgPNKF2FHB5W5tW?=
 =?us-ascii?Q?fncEqo/on+1zcKkdgxzEGfsnJ87ay/ICh33IedSu1ZdGuoKJNCURxyvktsXQ?=
 =?us-ascii?Q?O+3H32pqr8XK522YntIAMHbgl9r3w2h/HQAuR7IJgi/N48eWz1jBuCcAcong?=
 =?us-ascii?Q?eUUgZeB7aCr3KusqfRQtw96nSX6XW2t7pnKstGNiKtvoojaoNbbIRJdnoj2z?=
 =?us-ascii?Q?GdGm8VjUOXphZdXcdExXlcG5yI81pa1PBGJLOawzv37RNo6t7sb2y1tIqe7r?=
 =?us-ascii?Q?JdmRO7Bnc8w6MVfcw0QwzwolV1a5hc8tdB/mX34nJiAuXovvBPcgS+jn5SrT?=
 =?us-ascii?Q?N5i7kKICtfAqCkowzECE0VK1aHpCo3H449zuH4dwcy6c160GF8/dhDCmA3Bl?=
 =?us-ascii?Q?1L7IlVcJiZojD5SVpTMBV6qjKZpZfqEKkc5h3NddNi83QWw6Z3Bbub01iH+F?=
 =?us-ascii?Q?K86hEDOCMLz/MKSXo/m5TAH9ZsSb29+SHUYxzFR2gTykd6iOI0LQtUjqWTpv?=
 =?us-ascii?Q?TiEB9SqRJ73jViFXVPRgd/kJ6Iz+LHEd3vO9fBruKfJEIE/RICOxxIt08mSg?=
 =?us-ascii?Q?cIqdmAog5PGSYcbZmuYeVAPxuztvl1dp9l+mDeel0jpyENydmnIOLVdTqEXz?=
 =?us-ascii?Q?eN7h/6bMPg5+VT3R8VEzWpXVjz9wU8k6ZgX6a3aHOl1QWMR5gE564fs2OPyF?=
 =?us-ascii?Q?uIZon5nxWSG+yseke0S9SMtskaZoXMYhCc8juo3JsJMTKB1Yxsm2WL3AnZ0E?=
 =?us-ascii?Q?mCB7mfx1jxp/KlIb8qMftVrzrjIjuoDj0B4tUwP+mwKd/1ibV+R5eUvBzyF5?=
 =?us-ascii?Q?oVZvxPDQ4g8QNzsScVcr6rici66pWz5gzz3k1jnJbtXDmdXtdKOr4sbbuxYH?=
 =?us-ascii?Q?zHFHFvLGEYjwl9sETExBFxcXm+qwRTkTZFadZ2qn8Ilch3pxICSzRNqJabL8?=
 =?us-ascii?Q?qZAr0Cxo9p1craYqgSWvzyHeuN9lKu3aHuMh1oivE2WfPu2Jg5XH57Udw8NM?=
 =?us-ascii?Q?HRN1wAGdzbySZ9vaH8oH857W/g9VJV7rCfUBEjTcuGjQVzgkOomTH6Vvok6R?=
 =?us-ascii?Q?cKO4tTqfX5XeRuH5RHGJG66+A76TMm1+NKC47A0bMp8Lb7sJNRoeguMhpoiq?=
 =?us-ascii?Q?q1XLjAgQ1/h90K/FtXg7KaXcTY6+BVHUjIFQzFdRMSIsL+50maG8cyI4o7+Q?=
 =?us-ascii?Q?qzuR+Xo7MLhXtdsZ5UU2mbOvDNO0OtBXywu1y1hvZxQJ6Ujfumn6ECSAEMvB?=
 =?us-ascii?Q?MFHO1qN15m4Piwlf/I2QCnZCGUItKzmhrLfg7Q1tIm+CitdGF4iKle3Bq1Rd?=
 =?us-ascii?Q?MGLY981KVFUkjG2lVjn2lt7l9g5oUOWD3kkZevxtJ0WNkc5+fnVEruIaUhuG?=
 =?us-ascii?Q?Xzo8D1fpqvCPetbcexupaUrg0xt2op69b2cJH6IlJjrUoc9/nCY9aen837Tu?=
 =?us-ascii?Q?z2g1B3+KYOrWRqVv51FOw1uu79Hsw+XTsIhE+zrUmHewxcvXn0YabFUaGVRy?=
 =?us-ascii?Q?WvBqgSJb70KlqlsDzgcUlJwt+u05hEUcBAN8JTBF5KWFqvB9A/F9NsONTjEj?=
 =?us-ascii?Q?mw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1693.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe252482-78a9-47e5-8ca6-08dac8b6d75e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 16:14:44.8778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jQQ8MEzWIqwrtjE/H9z7/DXFVrXfD4Xxit2Dgel3hpOC/1RqZb0w/NjUN07BZlHxgZSOCna0pQuwD08cWXhhUk8uC9ZDJz9J0l3sFDefEnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1512
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Liu <wei.liu@kernel.org> Sent: Thursday, November 17, 2022 7:17 A=
M
>
> On Wed, Nov 16, 2022 at 10:41:36AM -0800, Michael Kelley wrote:
> [...]
> >
> > +static void hv_pci_read_mmio(struct device *dev, phys_addr_t gpa, int =
size, u32
> *val)
> > +{
> > +	struct hv_mmio_read_input *in;
> > +	struct hv_mmio_read_output *out;
> > +	u64 ret;
> > +
> > +	/*
> > +	 * Must be called with interrupts disabled so it is safe
> > +	 * to use the per-cpu input argument page.  Use it for
> > +	 * both input and output.
> > +	 */
>=20
> Perhaps adding something along this line?
>=20
> 	WARN_ON(!irqs_disabled());
>=20
> I can fold this in if you agree.

These two new functions are only called within this module from code
that already has interrupts disabled (as added in Patch 14 of the series),
so I didn't do the extra check.  But I'm OK with adding it.  These function=
s
make a hypercall, so the additional check doesn't have enough perf
impact to matter.

Michael

>=20
> > +	in =3D *this_cpu_ptr(hyperv_pcpu_input_arg);
> > +	out =3D *this_cpu_ptr(hyperv_pcpu_input_arg) + sizeof(*in);
> > +	in->gpa =3D gpa;
> > +	in->size =3D size;
> > +
> > +	ret =3D hv_do_hypercall(HVCALL_MMIO_READ, in, out);
> > +	if (hv_result_success(ret)) {
> > +		switch (size) {
> > +		case 1:
> > +			*val =3D *(u8 *)(out->data);
> > +			break;
> > +		case 2:
> > +			*val =3D *(u16 *)(out->data);
> > +			break;
> > +		default:
> > +			*val =3D *(u32 *)(out->data);
> > +			break;
> > +		}
> > +	} else
> > +		dev_err(dev, "MMIO read hypercall error %llx addr %llx size %d\n",
> > +				ret, gpa, size);
> > +}
> > +
> > +static void hv_pci_write_mmio(struct device *dev, phys_addr_t gpa, int=
 size, u32
> val)
> > +{
> > +	struct hv_mmio_write_input *in;
> > +	u64 ret;
> > +
> > +	/*
> > +	 * Must be called with interrupts disabled so it is safe
> > +	 * to use the per-cpu input argument memory.
> > +	 */
>=20
> Ditto.
>=20
> Thanks,
> Wei.
