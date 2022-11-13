Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9310C62705D
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 17:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbiKMQBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 11:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbiKMQBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 11:01:51 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022020.outbound.protection.outlook.com [40.93.200.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CF1E0DC;
        Sun, 13 Nov 2022 08:01:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h90sOjvYPYmsmvV+osmHv7BtDhYgAD30Sen4KXpRJhOQ/xmBVICvZ6Zrefnm+gHaNFRRTl70VbcQjQ4jPcEOtBjU/2Jx3poTUy5288tgL0z+k9uz7BlrycyEOpaja91ozKijYo7b74MRium4RBWgg1YjUtagJgw4wR5BHrE3wKBF3cdVN7WVKG3JZrfS5BpYrIQ/3O36Uo7B7tPfcCCngwiE+03SoaBhru9VIwvSmg9l5V1lpUApNIwuatep3xE0h2fLHSo22+5fhh/meDgHvZUzQUSJsQ8XKtSHlkH70eRQIfs61snyLR95ATz6wQE2xyNbMh6gLnu4cr3Ri/x4QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BOOihLB5E0cD0DIXJxl2WUEBs3ZtYUri/br+T125XU=;
 b=DuhoS0R9R6wPOFv4Y/RjpWLNeGzcJF99Bl58nnk5HNvWXHvb4g7Uf2u3x3mzuSJ+Tu8rcs4iNqPZPUQOWGTbqgF0xuv97S8vE8AkhJSDYXAQZOCmPaPlxe1yQVVYJN9ptl94DPrEatc2tFA4kNtdrMXhLdwVpAMKYTkVKhcoy87C2KYsnXf9O/mqntmD3736qMaRNUEwO+WocDU4KplHXLpGsqfrjqYRTSjS/xo4UYyGPVRtqnxQpg06w8hEH4TMiC0yyhFLqz9jeTld7TdegAMc932LPVt3V9nsAWGAXZrEAgEvyrXIEyirr2bW62Gea3O3aW5x7nd169HRyoxJLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BOOihLB5E0cD0DIXJxl2WUEBs3ZtYUri/br+T125XU=;
 b=HotIN5r928vWRvhy9bQwzkcYoGOI3blMw2u2J7Z/uWK9y0KRq+hAe/+b1AP4nSUdm31h0nWUvAcXaeruyrKZVBzNiskubE4R/AFE9cv5Lg+VX3fJ11Ry8FDJXN8VzBLrsVcu8mgq1RRO5VhDHJMQ93wSOvXyvE52syZBG3MGpFU=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by CY5PR21MB3423.namprd21.prod.outlook.com (2603:10b6:930:d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.6; Sun, 13 Nov
 2022 16:01:46 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::6468:9200:b217:b5b7]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::6468:9200:b217:b5b7%3]) with mapi id 15.20.5834.006; Sun, 13 Nov 2022
 16:01:45 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
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
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
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
Subject: RE: [PATCH v2 05/12] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Thread-Topic: [PATCH v2 05/12] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Thread-Index: AQHY9ZX1oDYFlp1yV0m/sy45yxtPB646EZUAgALdf6A=
Date:   Sun, 13 Nov 2022 16:01:45 +0000
Message-ID: <BYAPR21MB16885EAC0F3670125073F32DD7029@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
 <1668147701-4583-6-git-send-email-mikelley@microsoft.com>
 <177144ce-aa63-58f9-d3ea-dec9cde482a5@amd.com>
In-Reply-To: <177144ce-aa63-58f9-d3ea-dec9cde482a5@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5c33b2d5-736d-44ce-b04d-e01707fd06f7;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-13T14:35:07Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|CY5PR21MB3423:EE_
x-ms-office365-filtering-correlation-id: 33423117-6cf7-4db4-4699-08dac5905d2e
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uGAjaSPUDKfI9FxSSdn+m4+HhwH7leRFc42hQPMgju41KA1/Phxi6TwVXGQWZDNYrxoqvtmFyPrt5Em7CFppqzHaMSa37EObAGqxll964SHMlDGojknDX4YZcs6H4esqpMo1LVUvp6Uv0zsk5R8QPtz8ovbmO8aIMk5ZL4H+Dt2yfXFXiC3I8n4Oixw7KFan7tYYYnc6hUKrqA/3/yOb+bFYLzYMzqFi3uWsbGVuUZugtKMTUrQFUO2v4uyWRZlB9wrsU9oIArysFcdsJ+0/xamqajZ0xjq47vCoZCAvG524NXl8FVEIYEPqogN1CsU0ajd1ZvVzaeDbPx7tfRB8DzfyMKjIyYw1mTCV8J+9lM71DbQNPB0rTsUXKYUp+Q6o9bcI5Uc04rOlRpM0qb4QrWqUnaKUpfTF/W3R2Ojqbuxjl2SEhEPCo/Qu0MkBxccp+aZmwZgSBOVw2FMw1eagep8se9lwIrbs3dBchUmmn9vsU70wwcwR8DlxE4YQ3qVRTxhSQrl4seipLjqEXiVdb8d9ItNsiaWN9tjIgPQSCdEXFh9vLWQF+TJAYExQHBMsyFQdiRYhz52nYC4mGb+QVrNE4+PGcT3lb+dhwQmLTe+MAgm/JGQmakXFXBhch9W9N0PY9mEKMESFSwkzs4m68Ah7j/KMC8GL5I2QEqM2GsXEX7pLS/ecrMlKMqcVNUwz+szEFvfTSf6H/p3dXYBKKl9ydGSaFlTtshHnlgu0+qIAT6sWSozXmYZCPYx/ExMJKov9aTclDka+ZpReKJmif2lGWX7IKtsa2aidb5KH9VD9Q0PIMpBsAkwAxmojBNHKaH1Z4mSIfc7TYm1OR1fVpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199015)(53546011)(6506007)(7696005)(316002)(186003)(83380400001)(5660300002)(33656002)(52536014)(8990500004)(2906002)(8936002)(7416002)(7406005)(64756008)(66946007)(66556008)(66476007)(66446008)(55016003)(8676002)(76116006)(9686003)(41300700001)(26005)(38070700005)(478600001)(10290500003)(122000001)(110136005)(82960400001)(82950400001)(38100700002)(86362001)(71200400001)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DIZCKn8xAXwZaECL/X1ahfZFOyva1EWcjCZyD2vmy6Emh1hNell9GAZQbRre?=
 =?us-ascii?Q?Swp8l8Hg8CcneumgxRs2Md8ZWQ97DzMtOIWbVaRsw+RzwPT9CiWvDiOyjeAe?=
 =?us-ascii?Q?X8lay3xiRz/HkUG+eBwW/FQkLbKqCNIg1SxqDSVkkNnI/mDJ4Wb7FBEQFNXv?=
 =?us-ascii?Q?1nUxXgzZZWDBZsUn1IOrkF+5+ldEZ+cEoQrbpf0Ds9GHiB4eUIZ9Qq7swJii?=
 =?us-ascii?Q?S3hpzHSs9/dMkLBV33I/04EEItlXW+6kQx/oTv1Ow+XirPlZe4Zby8JwlGxl?=
 =?us-ascii?Q?Ff4iGk5OJKEhFS0g5BX1wIrZCJBTu+8QF1/MS+9KaDXDKRf9MFFIQqmRHuUz?=
 =?us-ascii?Q?3w+Jqc2Ngx/EGyG5Yu6bs/7NCHZFkyrI6mZ2vFoSFMPiS/lbz6/34aH7pFcO?=
 =?us-ascii?Q?oJm13FIIfsGWwf5KC3i4C65oYngihY3yvp7I5AMMLxXPOQ+5MFs48r7oze+7?=
 =?us-ascii?Q?4YXCOi8Wp3KSsRteAUkfE4XzkXOrG4gfcFa3hF6Kl1VSKE9r9KsMshLUNRKw?=
 =?us-ascii?Q?wbtSEdHqKjWssbumyW2nba2Srrr+eJJNuEm35b+5RHKI4g2ynkkYrRcJmSQS?=
 =?us-ascii?Q?NUIeIFehD9Ye2liNPo4KiihC3+pUPrT8hS2QXP4fXFipI0Yoo2sui9X6y5zi?=
 =?us-ascii?Q?v7SC/hEUpD/6KpjlwoNs8CevoBrjpSvNfhJuOEBg70qO0XEN/kzXWq8sGKJf?=
 =?us-ascii?Q?+Zez50qV2x2MX/viNFHCRsnrc4wsgBb0rtpcccL2iRh6BJaUQ8/vC03RPsV4?=
 =?us-ascii?Q?fMP8QNf3gHDWlk9Iyp7LyZ1pZmrhHCzQXNXnWjX/49dHKyjyTRzJKpZzAnfO?=
 =?us-ascii?Q?Z/oskV7/f8SoQRyQNfg1xJJBTo9TpT5mNbS3+jRE8ftSxqyxapBGg0FOWd4X?=
 =?us-ascii?Q?XvuVeo42UZU5y3qqK1aotJjZ6KypzzlE/rGQjp8UtB0cR9Uiu3Egx/sCcOpU?=
 =?us-ascii?Q?9wfVBQp4qviziE4Y5Khlh6clz4jyAinmBcBZsHyp9THZyeqNEb7srqM8xNgb?=
 =?us-ascii?Q?3cnWYCmYlRb+rkUS6tErIg8spDVEILHdtg18q094Cm3j7ptD/LN6WRDj6hLM?=
 =?us-ascii?Q?wUjGI6B/1hk8Z/HjVt9kqPnTQsbV81BsdBsr0qkHa6BcyOkdAx2DmXfTYvzN?=
 =?us-ascii?Q?yIOm4nXX8cGVwatwEiDbse2dH/j9+OzbVOISmkQUyIz4/qgM+gTNh6mYw4H7?=
 =?us-ascii?Q?NzDk7sAz8vmI2TR8jN1nIF5cHXxhhi2jbe5NVaIhDi5Ox5KeotMKmLwwdsqc?=
 =?us-ascii?Q?9yoCfDRuGB1A47OQ96yx5imILaFoJPRUmJqTJAZOhQCcgj7ORLFBD9Octhrw?=
 =?us-ascii?Q?BZyuMt1+ndY1c1QlDvohVP1l5xXfPu4qaPZ9ByNAsBfysO/39JdyRoRxpPzz?=
 =?us-ascii?Q?0IdZ/7ovxZlS9X6RmeEbBafuxpphucuVTRONHuXkfMNQJ4pKB/tacZ8Xv+lj?=
 =?us-ascii?Q?udAuv+XoouL8Ys00V5p3pb632p3x52h7DeGdobNdFGdSiABnlb/IaY5VSOW1?=
 =?us-ascii?Q?Cio7TRS5RexWT7/qiZeoZbOLdD9sfyjayqkYO27KQYI/V7QepxVPuSKyKWYr?=
 =?us-ascii?Q?aRKeAdX7fX1BzTvzFohIQVf1Bau3YR8zT52IXt2mLRH5s1FkfdZt69JFtJYy?=
 =?us-ascii?Q?lQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33423117-6cf7-4db4-4699-08dac5905d2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2022 16:01:45.5154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dX+bOIhwCqIMjUhpMrvVSi6IhYUR4qaumAn/fQ4Y3JSKx5c3U/knvfw6dKR53TxxYjJ8ljS8inmyK1ZZP7Uxmv7WD4izVDv0unOVYEwJpMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR21MB3423
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com> Sent: Friday, November 11, 202=
2 10:50 AM
>=20
> On 11/11/22 00:21, Michael Kelley wrote:

[snip]

> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.=
c
> > index 06eb8910..024fbf4 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -2126,10 +2126,8 @@ static int __set_memory_enc_pgtable(unsigned lon=
g
> addr, int numpages, bool enc)
> >
> >   static int __set_memory_enc_dec(unsigned long addr, int numpages, boo=
l enc)
> >   {
> > -	if (hv_is_isolation_supported())
> > -		return hv_set_mem_host_visibility(addr, numpages, !enc);
> > -
> > -	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
> > +	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT) ||
> > +	    cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
>=20
> This seems kind of strange since CC_ATTR_MEM_ENCRYPT is supposed to mean
> either HOST or GUEST memory encryption, but then you check for GUEST
> memory encryption directly. Can your cc_platform_has() support be setup t=
o
> handle the CC_ATTR_MEM_ENCRYPT attribute in some way?
>=20
> Thanks,
> Tom

Current upstream code for Hyper-V guests with vTOM enables only
CC_ATTR_GUEST_MEM_ENCRYPT.  I had been wary of also enabling
CC_ATTR_MEM_ENCRYPT because that would enable other code paths that
Might not be right for the vTOM case.  But looking at it more closely, enab=
ling
CC_ATTR_MEM_ENCRYPT may work.

There are two problems with Hyper-V vTOM enabling CC_ATTR_MEM_ENCRYPT,
but both are fixable:

1) The call to mem_encrypt_init() happens a little bit too soon.  Hyper-V i=
s fully
initialized and hypercalls become possible after start_kernel() calls late_=
time_init().
mem_encrypt_init() needs to happen after the call to late_time_init() so th=
at
marking the swiotlb memory as decrypted can make the hypercalls to sync the
page state change with the host.   Moving mem_encrypt_init() a few lines la=
ter in
start_kernel() works in my case, but I can't test all the cases that you pr=
obably
have.  This change also has the benefit of removing the call to
swiotlb_update_mem_attributes() at the end of hyperv_init(), which always
seemed like a hack.

2)  mem_encrypt_free_decrypted_mem() is mismatched with
sme_postprocess_startup() in its handling of bss decrypted memory.  The
decryption is done if sme_me_mask is non-zero, while the re-encryption is
done if CC_ATTR_MEM_ENCRYPT is true, and those conditions won't be
equivalent in a Hyper-V vTOM VM if we enable CC_ATTR_MEM_ENCRYPT
(sme_me_mask is always zero in a Hyper-V vTOM VM).  Changing
mem_encrypt_free_decrypted_mem() to do re-encryption only if sme_me_mask
is non-zero solves that problem.  Note that there doesn't seem to be a way =
for a
Hyper-V vTOM VM to have decrypted bss, since there's no way to sync the
page state change with the host that early in the boot process, but I don't=
 think
there's a requirement for such, so all is good.

With the above two changes, Hyper-V vTOM VMs can enable
CC_ATTR_MEM_ENCRYPT.  The Hyper-V hack in __set_memory_enc_dec()
still goes away, and there's no change to the condition for invoking
__set_memory_enc_pgtable().

Thoughts?  Have I missed anything?  Overall, I'm persuaded that this is a b=
etter
approach and can submit a v3 patch series with these changes if you agree.

Michael
