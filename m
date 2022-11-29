Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350F863B6F3
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbiK2BPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234609AbiK2BPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:15:44 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022018.outbound.protection.outlook.com [52.101.53.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DBA19006;
        Mon, 28 Nov 2022 17:15:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BsVch565ZfMRcg0s1Dvk2+eLbM5DZ78ua1h9y2UNGw0ReDUQMO/HzsqD/Bmi+SG3m9OTfzqqAxcuNeEm9a7tguL6+eOTLxiaTwdiFoXo3DxEwlVove1lAQTVgCstwkffk8RkGvY0EQ05zfipnyKDsU+qr1ijaXnL+n2jtT0cbREYpLrtClKQzrSfFJRNoxTNjA7R1Rd6HPcEYqX68cfWAhGAGd0Kc9E7W9mhRRx3K3Zx/RBVlP/0uePOj3P+B9JrbYJdKNnyR7ZBupVhworkET9002KaXKMvkNbmYXQ4dSYqI7rdXDIJzTi6AagrenKpC95MRLMFro9lyH2YU9JEPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4kMqFo0A4ijScl1Uw2KzvkPYIFhq6vsHjNx90U5ZWyc=;
 b=Utfl3z0O1zTKHLqnn4zQwjjpIFWI2V5VIhuvQUlkw4mlzAlIwnyiMAC17RQpIsRSAFS47mJv6vguNsFNjST+TOFjYyDqRpurbKU+iLmbuDbERTX+OmQ/FMOVTatZzlrIVNcwFzp/WQ7ausWRLeq7KnhTjx3Cfbrkv7QYgvFQkmhizP0h8pUyszARrr9+JRCx410114XtxBXD25L/GRVvWKbPLxp6Cin+RtrYbpxrb7UpWabLmqhzUqui4pBMAMKVQKvSfdSNGDo382mzMK3aWcqYn7P1Jx2M3/vyqVgHqMI+bxqjV8W4V4pzV1sfFBo581ioH5L5kUfjunXWNCJyNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kMqFo0A4ijScl1Uw2KzvkPYIFhq6vsHjNx90U5ZWyc=;
 b=IyeCFv0PI8IqCRw5DWMl+xGYgm5ypv7weJUV/zMyPxRNzYqCCKTMkA2raX1Qumhp08akCCLMyUaHMNycX5/Nk8KZPpY0EVib9DcEgOiatz89s9P+9auc6IzYHFtGnQ+yhNqQzP5vGGX2r2KgCCdgphRe2hUOj+oEKYWvfOP4A3s=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DS7PR21MB3270.namprd21.prod.outlook.com (2603:10b6:8:7e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.4; Tue, 29 Nov
 2022 01:15:39 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%6]) with mapi id 15.20.5880.008; Tue, 29 Nov 2022
 01:15:39 +0000
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
Subject: RE: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Thread-Topic: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Thread-Index: AQHY+es2O4adbWIH8UyWtCwRyUnUyq5JgOOAgAHDpcCAAEhFgIAAJ7oQgAjDHRCAACLagIAAALfwgAANigCAAAHQEIAAKJ+AgABUTmA=
Date:   Tue, 29 Nov 2022 01:15:39 +0000
Message-ID: <BYAPR21MB16886FF5A63334994476B6ADD7129@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
 <Y3uTK3rBV6eXSJnC@zn.tnic>
 <BYAPR21MB16886AF404739449CA467B1AD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y31Kqacbp9R5A1PF@zn.tnic>
 <BYAPR21MB16886FF8B35F51964A515CD5D70C9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <BYAPR21MB1688AF2F106CDC14E4F97DB4D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Ti4UTBRGmbi0hD@zn.tnic>
 <BYAPR21MB1688466C7766148C6B3B4684D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Tu1tx6E1CfnrJi@zn.tnic>
 <BYAPR21MB1688BCC5DF4636DBF4DEA525D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4USb2niHHicZLCY@zn.tnic>
In-Reply-To: <Y4USb2niHHicZLCY@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5bf512c6-5269-4150-a3f2-e0407069d5bc;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-29T00:58:15Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DS7PR21MB3270:EE_
x-ms-office365-filtering-correlation-id: 9f635404-094b-4a43-9b92-08dad1a73a20
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S+jXDRrHNDhZ5/gEpKUJCS0zcE5OJXfqTSTgRJ1osN53fl8irgAvREr7SUoWbSwgWAlrOu1Rh85fV2WpMMlHPjzW2w/Vse9B2GsiBkmzPMiLk3cKv/B+kvE7D69j28R5J6fk37XSgFXpwOADS07xsVse/YaOfu3mN0SHUEx0ZqHcBWbmh2yhGW18Z4XxZiZp9z7iq2KX8CDJspbsI+klH1B+SszPiNBh0ajQMJq0W319FgOzXSgHYqWY6xTW52Sq/O7gN46sInA3jJuhc6I+CCZYhvCvDTXyzGRkX3D6d39sSDWaO37FT3qXTP/11dBNyVHxxQAjOnJT5kHYdCTe84qGzHhU+DSXlbYF5QOwZkNF3fWisLUXgf4cFAXabUNVJ0L+UPd5sCIi2yAJxKTF4XE1T7eDiYBcn2Hmv6lkj4DAVItOLWnEnAi3gQfigsortc6lTLDSEHqUUEBySaVSpW2CSR/fdVjFiXgrgd6XV9/VZlACAgX73GD43HZvE4PVWSqIAt1Z1fwfiP7DGiGd8CfvFCMnb+bbpFEg5i79jN1reMYs1yQTL7uAs5MEmQ/33LhSpc6oRKwIWQamqEOZR66dUArNuWwD1jJLHrMqn4tOd6RpV/TvSYWem40Q1xJm9tZhv2+t9BKqntnq8rXpB0yn6EVNv9BzisaS607u6iXhe/ksHbmfbTz9OCrOlWgBGwr1hRex+lCse41T1E7Pii1tjukwCLcaQQdEUKq4F2T7lFPTN2fXG3Uiyd2y6EZDyq+74Oovkhn9ZTsGhctmpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199015)(2906002)(38070700005)(8990500004)(33656002)(55016003)(86362001)(9686003)(26005)(7696005)(186003)(6506007)(38100700002)(71200400001)(66899015)(122000001)(83380400001)(82960400001)(76116006)(66556008)(66476007)(66946007)(64756008)(8936002)(66446008)(52536014)(7406005)(7416002)(4326008)(8676002)(5660300002)(41300700001)(966005)(10290500003)(82950400001)(478600001)(6916009)(316002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?t26ESdBfjSMtkN2ovBpmQ6ZXbSXOXmCfTHPLFt5JobdecqNoaYVqc2hy+zbe?=
 =?us-ascii?Q?xLFiY2WYx1Y2o2lWrZu4/m/+gjfFeT+ne3vUHHAT0ox3qGkeAs7Y7rB544Ne?=
 =?us-ascii?Q?zEsilpEBgD97aDNu0xyv+jkiXsZ/tEBEtMAlSjvuOvmWCKg4yx9n5nRZT7UL?=
 =?us-ascii?Q?v/L5YaDNcuTU2jNeEqg/p6lHgfosd9NdTcg+7iHrS8mypQ9x/wFrYlVCLdaG?=
 =?us-ascii?Q?gLd8H6G9zNv1JCAKiXEwC5/JXBYYWWmiVOS/9uLNg8tH8K8qxivhGhP859ZG?=
 =?us-ascii?Q?FuESRJSRyLl6cEcepUrj93eswVAiV0MG1nIXA+ICguvOBJFT3M/r1SltmwWU?=
 =?us-ascii?Q?OeBLBU0Ga4WUWZQFUzzat/3BSYBRjBZXyNawYGYBWqEOjyi9LPTXyz2K3BNo?=
 =?us-ascii?Q?mGNfIkis6SKl238P2UdAOS6YePFAeEVd8xLrSHMv4d1hyHHUYxWmAo0bQ6Se?=
 =?us-ascii?Q?KQ2HFwIm6Q9mHPVnXcM4PYj2DO042IsTAuefSq78FozwPlAMFd2tTVNuzAJP?=
 =?us-ascii?Q?wf4DfxJgfAzYkhVP54V6Rw+2K/3g/W3UZESE8RJ7LHfNc0hXBgazyn++o3MV?=
 =?us-ascii?Q?dYzF1E/wYZYUTQo1pihOHK/lDT/iHDkBOljQb/lKGOBU0X7aIVulyhw0lA0O?=
 =?us-ascii?Q?4TDP9+PvXQXqieN2eoc9MVT7SEah2buNnHLDRn7Lwj2M6KHlFDG3Dlx0m/+x?=
 =?us-ascii?Q?iIFC8F/GETWpJuRbfprXhRCDRUgR3405BCeG8HuohibHiOdQdpZHZ1R8q5VC?=
 =?us-ascii?Q?9jwbjLV7v9RE2mQ1xEiE8eHhopddUFRXEMcXJmRUZVPL7NXChBekbc05+Gn6?=
 =?us-ascii?Q?Iue83wkf2+wqnxf5jeVaImsjA4HDmjzWYWpolA3GB9anJUXpreHqvlMPp8YC?=
 =?us-ascii?Q?5Hml8aebz6V6g7O9Dr1sD2lzqrVQ9gi/m+rgDZ6qqdndvqUlOia9HBwZXpFv?=
 =?us-ascii?Q?93S5EL87TKvKmu5DJYEj/fvOsY3YK/HCiezregVe6jU3y+yhVHEzPkxbgBsb?=
 =?us-ascii?Q?7tLG1kOaQ88zBu5Q1BwK/YAb5IszhxEpUmDb9oZoO/X/ZMtytC8l21VRfMS8?=
 =?us-ascii?Q?nnAVD2XOQiMLqsGB5vyfkMxrspL72QGMk/MrNfukSeRWbKBNxb60C/14okrs?=
 =?us-ascii?Q?TmjqRWEAQ/Qug65lcfSve6dwNrQCHbhmpX84jN61bGeheTxPAe2OvJmV53Dx?=
 =?us-ascii?Q?Kx3+ClrDiOW4PZZoBfx0t8mE9dyDXw5mEFpgU5uSScf28FejDYh7ANscifdT?=
 =?us-ascii?Q?uNxhwJY1teSOilPSD/DP7ywSh4ugRn69gVv6a+uJbHBUj209rd6CVQT5aj+p?=
 =?us-ascii?Q?tDNmywiJU7drsNbc/jSkeRHFRX2kJ+2NQbEs4yZWHvYNUDYoxZsKI+DBBm5Y?=
 =?us-ascii?Q?8grqebId6YJhQUv6jXfoBz4UTZqyfb2ZxdF+X72uv57rCKwo2QYH56m+HpR1?=
 =?us-ascii?Q?4sCajTSaPtIp38MKqWo6zN3MwT0qIWeUZMxkJNIbg6QDEwNYbTWKxJAMWwtF?=
 =?us-ascii?Q?lVf5bBQu/mk6nYxXEf9GEzWpHFryfR2/L4KkXawJtUiwaYnMhfrVBuQATydO?=
 =?us-ascii?Q?pvYX+RdyBfgh8qJSvu9dYI+UvFB65yr9LZUuDVrrnL747NN5zunLj4uLlTxG?=
 =?us-ascii?Q?/A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f635404-094b-4a43-9b92-08dad1a73a20
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 01:15:39.0668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yFO5RHrZ+HoNZkZWBreqNnfJARMZYUnDwbfF//ruV/0JPzUmuZd3NPd0thjoIRJzchqTDkX0wCdwjaoSBziXYzH9LsK/kIZ93VWMbvGSsYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3270
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Monday, November 28, 2022 11:57 =
AM
>=20
> On Mon, Nov 28, 2022 at 05:55:11PM +0000, Michael Kelley (LINUX) wrote:
> > But vendor AMD effectively offers two different encryption schemes that
> > could be seen by the guest VM.  The hypervisor chooses which scheme a
> > particular guest will see.  Hyper-V has chosen to present the vTOM sche=
me
> > to guest VMs, including normal Linux and Windows guests, that have been
> > modestly updated to understand vTOM.
>=20
> If this is a standard SNP guest then you can detect vTOM support using
> SEV_FEATURES. See this thread here:
>=20
> https://lore.kernel.org/all/20221117044433.244656-1-nikunj@amd.com/
>=20
> Which then means, you don't need any special gunk except extending this
> patch above to check SNP has vTOM support.

Yes, we could do that.  But this patch set is still needed to get the preli=
minaries
in place.  The initial code for supporting AMD vTOM that went upstream a
year ago is too Hyper-V specific.  This patch set removes the Hyper-V speci=
fic
stuff, and integrates vTOM support into the overall confidential computing
framework in arch/x86/coco/core.c.  The Hyper-V code was already somewhat
there via CC_VENDOR_HYPERV, but that really should be named something
else now.  So that's why I'm suggesting CC_VENDOR_AMD_VTOM.
=20
>=20
> > In the future, Hyper-V may also choose to present original AMD C-bit sc=
heme
> > in some guest VMs, depending on the use case.  And it will present the =
Intel
> > TDX scheme when running on that hardware.
>=20
> And all those should JustWork(tm) because we already support such guests.

Agreed.  That's where we want to be.

Of course, when you go from N=3D1 hypervisors (i.e., KVM) to N=3D2 (KVM
and Hyper-V, you find some places where incorrect assumptions were made
or some generalizations are needed.  Dexuan Cui's patch set for TDX support
is fixing those places that he has encountered.  But with those fixes, the =
TDX
support will JustWork(tm) for Linux guests on Hyper-V.

I haven't gone deeply into the situation with AMD C-bit support on Hyper-V.
Tianyu Lan's set of patches for that support is a bit bigger, and I'm
planning to look closely to understand whether it's also just fixing incorr=
ect
assumptions and such, or whether they really are some differences with
Hyper-V.  If there are differences, I want to understand why.

Michael
