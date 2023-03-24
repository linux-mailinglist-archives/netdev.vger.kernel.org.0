Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E176C80F3
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 16:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjCXPN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 11:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjCXPNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 11:13:25 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021014.outbound.protection.outlook.com [52.101.62.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC81231DE;
        Fri, 24 Mar 2023 08:13:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JC+m6OdaCFcY6agxQpl0D1/QRGCZgOrKfe8nDKpk/F2UvahzI6ry/HxLn8lcE8ftdo4VRAcIdklqA0d7fYe3Yb9gMIp2sfjIxDcMRoMi/i4hOLsUPUtDzcWwBAa+HOSdmoP/FNZdlaw5/9CHgSePxmX6+dlaGLdFqvn32Dudt3UQ7mSJ1xfo9qrl8JoFkbnIHVVSEp2cWj7Cv0fNgawXNsdMoQwGBJ3rBL+KTFVY93wg+LO/PR5iAGD2hSd4g7Dsyex/929sDW8P6yMdJNvVQFWDu1qSH8NZmLgbAGHH7p/hyRCpHhAwkXQ3c0WrQHqutAAmclFklfti22CSXajhQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5WjoRHOL+IJ/ZVYxw6c/KzswnOn4ZebLaz3/dJpB14=;
 b=mBXMuLUCOvKWZvikEwys0qSnfYduiwhmCFtTP55AEIAwTPI62eonSKLZAuW3KxLbG2o4NNl+u3vSIyIKk6QdUfEL+696bSo7pI7WInHwduPmpYyrRtxpyBgR/X+jx/4VRL+MUDI0+iBhxsxlZi04uSgqW0l4S8+2pe+XnM9aqJP9jR0JAZduHZnbVTYgMucjZ1uoY++VwIhs+jHa1730FXz18gnGOeeYLG2AVGUdZpOqcIha0aQPFB1ZECSNIw9TgeE+UwqmsGuKH61ZJ7nLeGyzJSGmQnpKqRjYZb15OqY1V2Dz+X2KW13c0ImvyMz70vyO/evXXtonqb92uWQELg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5WjoRHOL+IJ/ZVYxw6c/KzswnOn4ZebLaz3/dJpB14=;
 b=hg34D0UP2N2PkW166b8cnvYmzDC2Hr9u2ixJqJuU5ynF9bGBOCv8GBJg4LB2wfeYAs3TcJYF7CVzStSSUw1hoCxsit4GaeY4VX5LYr8X1P1Ii+DSrWWcf5cH9949kJ7Yr49FPaYOJlmz5+jB+3EXXBxHyMYdpXp3lC7EzAr8F8A=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by CY5PR21MB3541.namprd21.prod.outlook.com (2603:10b6:930:e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.9; Fri, 24 Mar
 2023 15:13:02 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::acd0:6aec:7be2:719c%7]) with mapi id 15.20.6254.007; Fri, 24 Mar 2023
 15:13:02 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Lorenzo Pieralisi <lpieralisi@kernel.org>
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
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
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
Subject: RE: [PATCH v6 12/13] PCI: hv: Add hypercalls to read/write MMIO space
Thread-Topic: [PATCH v6 12/13] PCI: hv: Add hypercalls to read/write MMIO
 space
Thread-Index: AQHZUjC678nWh0Aok0mZnGfqvXbiuK8KGuuAgAAEwiA=
Date:   Fri, 24 Mar 2023 15:13:02 +0000
Message-ID: <BYAPR21MB1688C99BC6C86DEAC22C35D1D7849@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
 <1678329614-3482-13-git-send-email-mikelley@microsoft.com>
 <ZB24Kdu6WMGYH1L7@lpieralisi>
In-Reply-To: <ZB24Kdu6WMGYH1L7@lpieralisi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ab695d91-a721-41aa-8164-63a4a5d2d20c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-24T15:05:10Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|CY5PR21MB3541:EE_
x-ms-office365-filtering-correlation-id: f60406c8-2c02-4fb5-e474-08db2c7a42c8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +pC3RU0SpjgHnGYbBmtq9uZLTIfdjX+wtc7NczUjgAOCrw7pWc7O5iZKp/0WsFmhrdksqIwQuEeFldIQ1BryZERqf3SifL+pfZcYTtgECP9ONKDxovVPd5KvtzCs2+ALAkeo1Ft4hdgTxJHnmiBfvM3d8QizujImwd6kcoosWuAx5L1Yz/jsloBfFydjGjTchMPS6OPEBGc3VZJJkXKYFigB28W12Hrzpzd3NmHdj8dVdsvrMSoKeKnxJsWuudLros2/ntPnAQrgVUCqMFDSkE16EgTWPeFSpc/nHzlf4UqhR5lAyAAbFZwrfFIQdKgmBBaFVjGypSZ/rmcRXFkcYUSkHLs8l0uF71G4/ixL8PByi/vyrBqOKQDCG9glf32r9doAWCQ20gM/e/4LYYk6M2h48ziplTZOMtIAubHYCpRliJSGh0cEv0anVQEuPYtOGZDdqsScb94R+7bnmE0nOT7M8LjuUKNoSg9zbXckiJBOucs9Q5cIpGKWAI1c3Mh+U0tNbHozBPkiYMngJywenSFm4VHsY8G23ZYp4D8ptJY/Ydt+I46aXLgph7YFbdZmwwMyFDRQQ8RAbuoS8efZlwCtNjChpRcUCeYoJ//h+f5HXsl+oTjV8TxCNW37LAnvwN5V8MVtdCrXsa8VcSdSlrQ+EZL0PK3RX5IVwCFm2iI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199018)(478600001)(10290500003)(7696005)(71200400001)(38100700002)(26005)(6506007)(9686003)(316002)(186003)(54906003)(83380400001)(8676002)(4326008)(41300700001)(66476007)(64756008)(66446008)(76116006)(66946007)(66556008)(8936002)(5660300002)(7416002)(7406005)(52536014)(2906002)(6916009)(82960400001)(82950400001)(55016003)(122000001)(33656002)(38070700005)(86362001)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tBnL6r3TSWnrCjsjbNwoiM5t5hRU4egI4sdpsV5IMAgDIMkvCR+urj8sYpBV?=
 =?us-ascii?Q?SpyUfn/VaNPm7XT4on9EYVIFX/syGHTYODRRKoKSayZjsSsVzUgGy/jC8n22?=
 =?us-ascii?Q?cFo9+ikSVn4PKQiq79F5zF4MlC9xRlW0zRrit0P66iKF9Gccw8U5GxjgzH3v?=
 =?us-ascii?Q?42qRW/AY5HWBTIIIdLRl1lxTOmzcqWC03enHh+ep6BKpbHiOEpvffVTFbTq4?=
 =?us-ascii?Q?hlq1KBISmijBapP/Nv9CRdcQrJiDl4I/o4F2d0nvfpiEIPo6i0+rtK9THNaq?=
 =?us-ascii?Q?YjuFjUG0tiRzkA7CzYkqTQmOzZlc1qBe5XQEuUH91b1z/vm0NC7UWcvp+jph?=
 =?us-ascii?Q?kaA1TuzoYF2dFApkMq+/z0Gj/Ljlebplsb1zXy7Ipr0aO1O2WDKbhET+2QQ+?=
 =?us-ascii?Q?KUURb96Yuq5mNicQPp7KC4T23KgPA3EbBj0xXnYVhu0E0WeLkY8ch15W3+iZ?=
 =?us-ascii?Q?E3lvsrg0haVCO/mTmkMCbKs37uPNY3ihiv6eBpeJ8PQnmPuyzi6Hq/PK0iX/?=
 =?us-ascii?Q?Bn/YIlMH3nuMDCm02zT9JWi637KBXyI1p/6sHlMd5UCQqdGUj3F8Jpzot12s?=
 =?us-ascii?Q?89EI4Bxjgx1oHPFdLayIZ7mUhJVZIHGKWaJsb9p3laRn0WsBam+TK9sucACh?=
 =?us-ascii?Q?/ZwhaI2vvw+1n24B9Rfn1E2EcDlcf+mk+TJ42UGxGnHywZiKWbxPr7qJHv3y?=
 =?us-ascii?Q?OPm66t0U4lnhz+T0YzgEySHxr7bRVSYJNI2owrrG0UT6KADhoKTV19ZVHAaY?=
 =?us-ascii?Q?xJm4AvvIjzsEfyIggRlUXO1hZPssrdPavcUCINTrqoqIdkhJPKhD000ShPuj?=
 =?us-ascii?Q?H2shzt6D9GqYmkCiiNRD0SO94oumb4vgPGAILdS+ItvkQ75RR6Ju8wpj+3jr?=
 =?us-ascii?Q?WWYKnbMVaxQSWEVwV0eWAjUtO+logYNL+smNoi+sQGA7Ct8YmwQ9JSbpMAxb?=
 =?us-ascii?Q?WlBlDZbJuCt1HmOZ99Nl54yrzwthVD0FoOfQMAhPijYoO1vnmkMEbxVCJ5tA?=
 =?us-ascii?Q?4RwHq8mQc+UwTwv6sWhQA990kqiOkdQjqicaj6C8PblxCiMQ4aahfIZiMXKc?=
 =?us-ascii?Q?Qv2sVkGf77XY4sCZIP6f+cAmsf4VJR/6Y3sp4uk+SRgh6xidqN2sUTZna5ZG?=
 =?us-ascii?Q?lQKxtkXfESuuN6Frq6Z4UX26F8OVNIlEBpOb/XBRI71BQMt573Vjyt77+TDx?=
 =?us-ascii?Q?MGgY4z6F3yXfD6mvdJyXyTDDvZFRqHn6CwGinmzKNUO/dQCdPO2C+viLWh1/?=
 =?us-ascii?Q?uLvYl/zrvoFo/IZi1fg2OXeLrsz/rH/HrIXM8LlXpodC08bKLC+1NDeWi5u5?=
 =?us-ascii?Q?4BQiZyGGvCWvb/VgzIaJxXFzdZPvwBCwGb143fEgYBZBTucEzwyNT5K9lyLw?=
 =?us-ascii?Q?o/D1YyY5JON+iIDiwXX+WhAVXsRlkxPedddxxBwDgSbWjAuI1DeZKQtfPWYA?=
 =?us-ascii?Q?yjWQqXjA4I3cC182f+E9q4rOzGWNhTRvfImOQvuaivd/jD4203d++sQslBr+?=
 =?us-ascii?Q?XGdWo7IhKKWXzKQmszpWQmC/r5gnZ2NYvxxBieLuOznWr2NtkAOuZinO7MI3?=
 =?us-ascii?Q?D4ksuETgCbzN0V8kHOzCKvdzCsJl1lCBQAS9ayUgWXY4Z5nR/K2Pjp2T6ycv?=
 =?us-ascii?Q?Rw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f60406c8-2c02-4fb5-e474-08db2c7a42c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2023 15:13:02.0761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BeweakFjNyJv7hEebpoeZF9481K1126BX1YF7lKNQwcomNJSLyvIaCwulh9OjjVJb3w4L0+xnqLhbHdSv6njb5FSttbHNknOLLqe0du6yRM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR21MB3541
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Pieralisi <lpieralisi@kernel.org> Sent: Friday, March 24, 202=
3 7:48 AM
>=20
> On Wed, Mar 08, 2023 at 06:40:13PM -0800, Michael Kelley wrote:
> > To support PCI pass-thru devices in Confidential VMs, Hyper-V
> > has added hypercalls to read and write MMIO space. Add the
> > appropriate definitions to hyperv-tlfs.h and implement
> > functions to make the hypercalls.
> >
> > Co-developed-by: Dexuan Cui <decui@microsoft.com>
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  arch/x86/include/asm/hyperv-tlfs.h  |  3 ++
> >  drivers/pci/controller/pci-hyperv.c | 64
> +++++++++++++++++++++++++++++++++++++
> >  include/asm-generic/hyperv-tlfs.h   | 22 +++++++++++++
> >  3 files changed, 89 insertions(+)
>=20
> Nit: I'd squash this in with the patch where the calls are used,
> don't think this patch is bisectable as it stands (maybe you
> split them for review purposes, apologies if so).
>=20
> Lorenzo

I did split the new code into two patches to make it more
consumable from a review standpoint.  But I'm not understanding
what you mean by not being bisectable.  After applying the first
of the two patches, everything should still compile and work
even though there are no users of the new hypercalls.  Or maybe
your concern is that there would be "unused function" warnings?

In any case, squashing the two patches isn't a problem.

Michael

>=20
> > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/=
hyperv-tlfs.h
> > index 0b73a80..b4fb75b 100644
> > --- a/arch/x86/include/asm/hyperv-tlfs.h
> > +++ b/arch/x86/include/asm/hyperv-tlfs.h
> > @@ -122,6 +122,9 @@
> >  /* Recommend using enlightened VMCS */
> >  #define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		BIT(14)
> >
> > +/* Use hypercalls for MMIO config space access */
> > +#define HV_X64_USE_MMIO_HYPERCALLS			BIT(21)
> > +
> >  /*
> >   * CPU management features identification.
> >   * These are HYPERV_CPUID_CPU_MANAGEMENT_FEATURES.EAX bits.
> > diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controll=
er/pci-hyperv.c
> > index f33370b..d78a419 100644
> > --- a/drivers/pci/controller/pci-hyperv.c
> > +++ b/drivers/pci/controller/pci-hyperv.c
> > @@ -1041,6 +1041,70 @@ static int wslot_to_devfn(u32 wslot)
> >  	return PCI_DEVFN(slot_no.bits.dev, slot_no.bits.func);
> >  }
> >
> > +static void hv_pci_read_mmio(struct device *dev, phys_addr_t gpa, int =
size, u32 *val)
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
 size, u32 val)
> > +{
> > +	struct hv_mmio_write_input *in;
> > +	u64 ret;
> > +
> > +	/*
> > +	 * Must be called with interrupts disabled so it is safe
> > +	 * to use the per-cpu input argument memory.
> > +	 */
> > +	in =3D *this_cpu_ptr(hyperv_pcpu_input_arg);
> > +	in->gpa =3D gpa;
> > +	in->size =3D size;
> > +	switch (size) {
> > +	case 1:
> > +		*(u8 *)(in->data) =3D val;
> > +		break;
> > +	case 2:
> > +		*(u16 *)(in->data) =3D val;
> > +		break;
> > +	default:
> > +		*(u32 *)(in->data) =3D val;
> > +		break;
> > +	}
> > +
> > +	ret =3D hv_do_hypercall(HVCALL_MMIO_WRITE, in, NULL);
> > +	if (!hv_result_success(ret))
> > +		dev_err(dev, "MMIO write hypercall error %llx addr %llx size %d\n",
> > +				ret, gpa, size);
> > +}
> > +
> >  /*
> >   * PCI Configuration Space for these root PCI buses is implemented as =
a pair
> >   * of pages in memory-mapped I/O space.  Writing to the first page cho=
oses
> > diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hy=
perv-tlfs.h
> > index b870983..ea406e9 100644
> > --- a/include/asm-generic/hyperv-tlfs.h
> > +++ b/include/asm-generic/hyperv-tlfs.h
> > @@ -168,6 +168,8 @@ struct ms_hyperv_tsc_page {
> >  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
> >  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
> >  #define HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY 0x00db
> > +#define HVCALL_MMIO_READ			0x0106
> > +#define HVCALL_MMIO_WRITE			0x0107
> >
> >  /* Extended hypercalls */
> >  #define HV_EXT_CALL_QUERY_CAPABILITIES		0x8001
> > @@ -796,4 +798,24 @@ struct hv_memory_hint {
> >  	union hv_gpa_page_range ranges[];
> >  } __packed;
> >
> > +/* Data structures for HVCALL_MMIO_READ and HVCALL_MMIO_WRITE */
> > +#define HV_HYPERCALL_MMIO_MAX_DATA_LENGTH 64
> > +
> > +struct hv_mmio_read_input {
> > +	u64 gpa;
> > +	u32 size;
> > +	u32 reserved;
> > +} __packed;
> > +
> > +struct hv_mmio_read_output {
> > +	u8 data[HV_HYPERCALL_MMIO_MAX_DATA_LENGTH];
> > +} __packed;
> > +
> > +struct hv_mmio_write_input {
> > +	u64 gpa;
> > +	u32 size;
> > +	u32 reserved;
> > +	u8 data[HV_HYPERCALL_MMIO_MAX_DATA_LENGTH];
> > +} __packed;
> > +
> >  #endif
> > --
> > 1.8.3.1
> >
