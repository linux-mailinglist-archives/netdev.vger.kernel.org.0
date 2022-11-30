Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7734C63DA44
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiK3QLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiK3QLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:11:24 -0500
Received: from DM4PR02CU001-vft-obe.outbound.protection.outlook.com (mail-centralusazon11022025.outbound.protection.outlook.com [52.101.63.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C064884DD2;
        Wed, 30 Nov 2022 08:11:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmT2+6066PNkDbpVEBvcFntRZGQqv4v1Caodr6q6ez9dSYaXuRC9oDG6hkn1Fk9DLN06F27vwBHkmU/Uv22NzQi6I2bCbWka3E8rL3EgWbdmhKlfPWW4g/h3nAQR0iZKLLQFYW1vNSTQAynF3YEI9XVblHht1uHx7Mv+LQn7wAH8O/F25bU2HIf/WBghRjtxg2e7QzPld/TyxYg0rmTlwODmzF9SQHwGVjO7YRjUHuIcm0WZgDJnPDwSS2/44pKXWtl2g3ONmbmk/erl8PP7T9ZX6w2kuWBL3ljjsy2Am4At7hxLkT0AUgd43hC2/TUJ4cKzB70BfbLuO3CzTFFMzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2un+YaYUrYcPyG/w1JniPYtm1LjFzWwURIaJT4UpIY=;
 b=VYhNY8MApF7sbrpSC+iSZNXhDpEHg3lDK2aoYkUfRyANoGswRHC5IpCuKwWgd5J6YRyHOIyhfLlx211v1vnA/X6bPVVkxcIK54lMMlX0y2v3bE4a5jH8YnlHYJlNXtV8xIa7Cmd4f9gjyiLFuhqtC5GmbQZkITVl0h+1nv5WtIRlkkex7kEBDmNG/xly+KmGt4oPnxikTSrvHN63HN8Q7q6X1wlJdhu5g8sLKxJTuRQQeZHKfuqq5vOmhhhc+K+Dv6uV58sLBOnJlRk07KjnfcDAmR6w+Fl8TjF3H4W0+ZFV1k5v40C+bHsnR/o7GgzIGRo9+qeszkS+FCMD07hPCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2un+YaYUrYcPyG/w1JniPYtm1LjFzWwURIaJT4UpIY=;
 b=i6Q2Zc/gkyPSP1ZeWnPreEwzh9t7hVk8LglNUYaNGt2TvKEzHe3XY/yPv/IDnKoBzTIwo+vScajeYFE0XhSUn4AtfXB29f1iPXbTrRHpocuFRvvoTfMa8QV5xUhGazMBdd6lMRWYad8AowLcYZmem1V1OGC5I1PjBwSSg4gwPhY=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MN0PR21MB3171.namprd21.prod.outlook.com (2603:10b6:208:37b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.4; Wed, 30 Nov
 2022 16:11:18 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%6]) with mapi id 15.20.5880.008; Wed, 30 Nov 2022
 16:11:18 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
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
Subject: RE: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Thread-Topic: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Thread-Index: AQHY+es2O4adbWIH8UyWtCwRyUnUyq5JgOOAgAHDpcCAAEhFgIAAJ7oQgAjDHRCAACLagIAAALfwgAANigCAAAHQEIAAKJ+AgABUTmCAAIE5AIAAb5XAgAApEACAAXbTMA==
Date:   Wed, 30 Nov 2022 16:11:18 +0000
Message-ID: <BYAPR21MB168891CB2831C9BAF829EADBD7159@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <BYAPR21MB16886FF8B35F51964A515CD5D70C9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <BYAPR21MB1688AF2F106CDC14E4F97DB4D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Ti4UTBRGmbi0hD@zn.tnic>
 <BYAPR21MB1688466C7766148C6B3B4684D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Tu1tx6E1CfnrJi@zn.tnic>
 <BYAPR21MB1688BCC5DF4636DBF4DEA525D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4USb2niHHicZLCY@zn.tnic>
 <BYAPR21MB16886FF5A63334994476B6ADD7129@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4XFjqEATqOgEnR6@zn.tnic>
 <BYAPR21MB1688D73FBBF41B6E21265DA3D7129@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4ZFmktxPlEjyoeR@zn.tnic>
In-Reply-To: <Y4ZFmktxPlEjyoeR@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4d8ac474-9661-4173-b112-bd1a32d94ebd;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-30T16:08:38Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MN0PR21MB3171:EE_
x-ms-office365-filtering-correlation-id: f1bed3aa-93cf-45bd-a5d8-08dad2ed839d
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ngeZelr/5IkfH3kbtD83LLGdjGhe6u8LN0PWeKcLW3CenXuBvJ1dFkWfgU6lPQ8IhZz8MZMRBEtEkReD4W0T7F7Gp267ra80qEaqSs4K8K/oNkIka7WlLVLJMpSJV3eONhz2ZHWLV99ee73X3xIAqZD2uBUiSaQ9lLpR+22DN0WHHtHmFi6QBWU8/W35+tVWl93koszy6MhoxDWE0zYOuugaLzELSx3tALyTqHUU92p/MHNRQ9BIjl5jiLv2KCpX3DiVtGc8jk3viMWlY9QpUFEWY329Rv76bxybMCPHU716QnVU+5tE+tpdN6rIqD04Copp4mOFQFj9V2wmXD7NkWU6NGJ7vX2HdrPzaqKr4JLAVXSuESiso9ptq5mrjR0qihNBb5AQ0irg7LDDDBdkQ04/P8DPrv4bSrlVlAj6e9TD3WW8BZQ7RFULAQFZwhNVwBjjqFFXwp38LNJe7Yvupe+AzMrkrgAR03OSnw87R7GK15L4tV+KTKQUK9tpgYERWc9IaugwfNjrGnEWRrqGH+E/4q07GLkguydcoB6P8qKZ0ibx/9v5psGBXJDEvJj5iv+Uv4coFSgtJuH2T1B7EP/k6KUhI1i52x6uZhGhA13tX7FAVRU8Mep1jf3sq44AXxtLigDdTyE5tVMnyOnjXNduKPjMsmdRm/LaI8IiruHL64DBYCklr4fAnW2zmUa390mfi/yX0GLAlkE1R5mzp/1Rci8Sx7s5nDph+4wgq+WsTQhhHZ6DJ7O+nT5wLn1v
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(451199015)(38100700002)(33656002)(122000001)(55016003)(54906003)(86362001)(38070700005)(82960400001)(82950400001)(9686003)(26005)(6916009)(316002)(71200400001)(478600001)(10290500003)(6506007)(7696005)(8676002)(2906002)(5660300002)(7406005)(7416002)(4326008)(66476007)(76116006)(64756008)(66556008)(52536014)(66446008)(66946007)(41300700001)(186003)(8990500004)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iEJNhDpofC0yQuSb2BF4BqEyFjf2dQX62VSPsMfpYCmomyHQZDCWSKnjyaOG?=
 =?us-ascii?Q?zsa3TYCh/ji35tiearDnXgxfCdMrHQVB5xTKGSe8fgG+uDKQFiujtoQYDuhl?=
 =?us-ascii?Q?v6GHM0l1nsysQ34HUdRk8q9QXnWkfR30m/nW1iuFWjwD+GHusHcwzMgu0JWb?=
 =?us-ascii?Q?ki8EeU5vae/xUxtQQVbEjmrWxT/+T4M57YMUSh5oDUGHg6RcJ2ESl80JlUlk?=
 =?us-ascii?Q?uS8/EHK7LGobrLJqDeTg/7C9hxt5C084maYic/dMeBVHZj7JuCBzZbdSuliR?=
 =?us-ascii?Q?fsAD1oBhU2OMYE2hVXha6gn4125NI3n3um6474q3XVAIhG0ZgWvdRef/X2ct?=
 =?us-ascii?Q?x1El+fkl/VVEBO0UPjn99w+eQ4NpL3fZtkQML7IL0tg+2ChiTRo2By+ILOF2?=
 =?us-ascii?Q?GrhGf35326Pi4YHZ2szXhiSfnmo4BJ7dJKJaJl+JfOc4/BCRyUdQyAUTq2Ot?=
 =?us-ascii?Q?Z6E9JyuxXPPJiPnwKBkHrLS7vM2auBK1QDHdawGDW7kp6P/Tfqtq6oY8pd59?=
 =?us-ascii?Q?hOyhseOJ/EFvy6QV6qlJsow0h1WP6/zjwvbBJJAlyWWzdv7csAX/6/1x6IDq?=
 =?us-ascii?Q?VVJ/t8RBr/xefvZ25tQfIugNpE4TJHysEzSM8H1m72ZGXP2f1hl0Xovc3fX1?=
 =?us-ascii?Q?bnCrnu7ng+6mJ2hwdiAINPvduXAESrXYzKIrcP2hPCYa35cbMwNkwtJ0avfz?=
 =?us-ascii?Q?m7rUef1worYQpxeIBsx7XNSV2Z/dSLl0PJvV1e9VYYCh0O4OWu2e0HaxEF15?=
 =?us-ascii?Q?zViDV9dAHxwiccRJuy8pVurtS4tK6P9a8GheZqBam3nb4D0jZDQb66HmVOXy?=
 =?us-ascii?Q?JKoSXGHoO5YbF9RR7EINR1ibFNuz6ADDy6mrgcMyUaE7nEq/p/fOtgzpsd2w?=
 =?us-ascii?Q?Mtm12kjuJLmRniAjl5a4j+CnZQhksuARdknV6FzSLwi/9u3CPgB6zYLDkSsS?=
 =?us-ascii?Q?F7R++0dNcojkUeTe8E5nkE5ArCdz70La5SMq6ayfg8qSodTUzcLHanv/sjhB?=
 =?us-ascii?Q?ioO7DUSCaxon24Mz/UgT7SgQWZS0qFdk5q6CZJnBmZR2qNSi2OIrxkB0asSq?=
 =?us-ascii?Q?uPsu9d1FBd6w9wBJNS0AJrG3PIjLfhcRDgBhcoJfaARzaF7iQr+x6E85viIb?=
 =?us-ascii?Q?fVXKrovf5poMdgPjJTSRAKwDv87MM1nftjd+VCgnoTt27Wk6Eiq80yfoGUSh?=
 =?us-ascii?Q?ijblIYW7SohBX60Q1La85Obdbrmo7iDRSO8uZtGisE9J3zPN4Yt5O51jdsCM?=
 =?us-ascii?Q?iN//i2f7rHGsBGYkQ5wjp15PI/kcVSdXBZ+Oqosco8Wyv13DRCxKPAGiniCK?=
 =?us-ascii?Q?zXw6W+jmIKP4JE6ISSOJsq82i035vHdueomrXcmibLEo5I2uVey2v7euJCKe?=
 =?us-ascii?Q?wP2UQeZzFSVj/Uy64yvV/1pD10siPcExB77HxHOXQA8jaK6KXOqbid+yckus?=
 =?us-ascii?Q?1C/53Nu2FKfUxa6skTFhnD1JpwdI+3SRgA+yFNlO814Vwuz/mRdon6VVcRiP?=
 =?us-ascii?Q?RDogE5RWiWdBvTqsygsLOiXqIVSi9CNyz4QiYLfeUa1j/cg+yhcT6Sa98kFG?=
 =?us-ascii?Q?BWYKqPdOAa3Rtg4PgMEGZovu51BdQ/jKXgJb2p84cW/aIk9SN7fN84YbGl+y?=
 =?us-ascii?Q?cQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1bed3aa-93cf-45bd-a5d8-08dad2ed839d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 16:11:18.3182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uvGkZMQGOXQCeDBYEmXaDXbFf5hF2i90uYC/Fvp+DQd82jK/jukELL3AfibWX0njzXa69S0W/eXDNcts0wXnjO+BCrw+defhiO8J9yViFbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3171
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Tuesday, November 29, 2022 9:47 =
AM
>=20
> On Tue, Nov 29, 2022 at 03:49:06PM +0000, Michael Kelley (LINUX) wrote:
> > But it turns out that AMD really has two fairly different schemes:
> > the C-bit scheme and the vTOM scheme.
>=20
> Except it doesn't:
>=20
> "In the VMSA of an SNP-active guest, the VIRTUAL_TOM field designates
> a 2MB aligned guest physical address called the virtual top of memory.
> When bit 1 (vTOM) of SEV_FEATURES is set in the VMSA of an SNP-active
> VM, the VIRTUAL_TOM..."
>=20
> So SEV_FEATURES[1] is vTOM and it is part of SNP.
>=20
> Why do you keep harping on this being something else is beyond me...
>=20
> I already pointed you to the patch which adds this along with the other
> SEV_FEATURES.
>=20
> > The details of these two AMD schemes are pretty different. vTOM is
> > *not* just a minor option on the C-bit scheme. It's an either/or -- a
> > guest VM is either doing the C-bit scheme or the vTOM scheme, not some
> > combination. Linux code in coco/core.c could choose to treat C-bit and
> > vTOM as two sub-schemes under CC_VENDOR_AMD, but that makes the code a
> > bit messy because we end up with "if" statements to figure out whether
> > to do things the C-bit way or the vTOM way.
>=20
> Are you saying that that:
>=20
> 	if (cc_vendor =3D=3D CC_VENDOR_AMD &&
> 	    sev_features & MSR_AMD64_SNP_VTOM_ENABLED)
>=20
> is messy? Why?
>=20
> We will have to support vTOM sooner or later.
>=20
> > Or we could model the two AMD schemes as two different vendors,
> > which is what I'm suggesting.  Doing so recognizes that the two schemes
> > are fairly disjoint, and it makes the code cleaner.
>=20
> How is that any different from the above check?
>=20
> You *need* some sort of a check to differentiate between the two anyway.
>=20

Alright.  Enough conceptual debate.  I'll do a v4 of the patch series with
the AMD C-bit and vTOM schemes folder under CC_VENDOR_AMD and
we can see if there's any further feedback.  I should have that v4 out late=
r
today or tomorrow.

Michael
