Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8354A634325
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbiKVR7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbiKVR7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:59:13 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2118.outbound.protection.outlook.com [40.107.243.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF862DF;
        Tue, 22 Nov 2022 09:59:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFPONrMs3EWA7Mn8fpm35n2JMHoREhoxj60OaQw47gH5tiXYoz13IqEMg9cxlFh/P0Mrnyyi7/8OcGQGT+WuIBaBacE/nH0vqhjwqoY+gnLkjRTNQ70ZiWM46Fp41WF7OB4dbV+Vit3JWTgRnUNxSsizlahKi+a/i3cvuA30FhIaqhzcSsYOhgsA+SfxVcnYBsMIJR16X4+WrBAEmk1oWF9y6L02SbImFnUFzK7AuoaELHFATsP9e1I8eimskfJ+SNcNbbRw3xZIfaIsp3j6rhbR1+OHSw1n3Ftb6g/hE6u7/rT8AyDmiCFIy0aRIZ8hLY6bJrOgE7S6jxd4Jf3f2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7CLMJVxlLGzUCoelg8JilynhDxRxyhLN9DkNmCPoa34=;
 b=Qmne2YARzIKL8TB0d8njjqTndnII/YZRSgAovqjAfVMWEs5Q9Ktb3uhv+l8lTT3LOFSNFcnzizKZOFEZrKgGjKsAOK20uuuNkRQaE1OAwPLzKsumAe3Hpib7z1Zp8cF6m0l46uLdfrBKyKux7XWDFfl8UTpxvkHlC8ODLDRfW61lrgGNuCQI6WN74RJ1D9cNHfxxadS+oYrRTJa3OONn0DdGCOxKFZfcQ0KWeVyXaP7Ss5Qv5dTh+bfLAp2RBlWf2oBNn0mpLP+/fNtksGj4Ud5pHCSUNxatjS+C6XdMjPB0A84O8+b/WP/MNnjYufpXC+VGQ6gBpqGiyEt9COgoOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7CLMJVxlLGzUCoelg8JilynhDxRxyhLN9DkNmCPoa34=;
 b=gWvkJmEexOt7TDE3oKmBLCK4D8Letw1/EeU8tFAI8RiYPEc1gJ+WBmhdgVCrh+M/rsS6gENsB/OIG9oJLlQRvUflB1iS82xV4o2r7a+4xIGIMOjXNvf778vDgsC0g7AeSS1akV+vBQzr1MitGbEc5xv34tCj1NcGPnIbtZZpkTw=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DM6PR21MB1401.namprd21.prod.outlook.com (2603:10b6:5:22d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.2; Tue, 22 Nov
 2022 17:59:04 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%4]) with mapi id 15.20.5880.002; Tue, 22 Nov 2022
 17:59:04 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
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
Subject: RE: [Patch v3 05/14] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Thread-Topic: [Patch v3 05/14] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Thread-Index: AQHY+esxZzvGjSwYNUG8Av9Zi67yOq5DqJGAgABSJYCABX99gIAAfRcAgAFJGSA=
Date:   Tue, 22 Nov 2022 17:59:04 +0000
Message-ID: <BYAPR21MB168873879B0EEF71DED3D460D70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
 <01d7c7cc-bd4e-ee9b-f5b2-73ea367e602f@linux.intel.com>
 <BYAPR21MB1688A31ED795ED1B5ACB6D26D7099@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y3uNj0z26EjkHeCn@zn.tnic>
 <6b5129cf-6986-bbb1-7e60-37849fc383fc@linux.intel.com>
In-Reply-To: <6b5129cf-6986-bbb1-7e60-37849fc383fc@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0aa9a55e-e667-46c0-83ee-83cdac9fc05b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-22T17:44:47Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DM6PR21MB1401:EE_
x-ms-office365-filtering-correlation-id: e037ee59-511e-47ea-35aa-08daccb33e7a
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4USE/ye+/5Lg8eZ5ckUmGyaM8/R3dA6hmOewxU2cVEmFoZacRwJbzhrLxaLkt9dLhcLhT9GVQzYJqUMZhFUDqNFDg1GMw1O+DHCDPpn3ihddL2xy+EXrGKX/Nj4+Yh+00xZah2ASf7c35EmJZ1q5n3BpN9qqfmo93nCPjqUgyFh4P4Nyv8L4Eoy8n+TNsX2ykErzpgW+7cV9EQuDX+RqCUMkjwmPhE4cmOczJQA0JDtaWDpy4v90qVes4DXyeF6Gz94dRQNwtGpiC9EZxZ0NPI3GXtTBpNRvux7EvsrdIy6dV3Gv+nbcttR4SFDqmI/n/qxHOy4N9AxYOjjCBifxqJmrJWQ1DF8qcg5/1YkZbUpNpahoxWWDA4ot8aqTeP6OR+NN5qjd/K558RlP98GKmUPGTqszOV6KMDmcdIDEQpvrFgh0wIpJmjrbYaSnNUQjAzdFVh0NemGicJm6AqwrmAgVQa5CZDJFUWIi7oHacoU/G8XSFVD1Nr7ePOljFxodZWSxhNSH7Qk0omEn82k/9DPtIrsBPsyERxUIo5WdPZCZ3v0oxxzyoR3pLVdwt33L7d8P0I6zKVa2LEvL0JdsJcd5n4278eWQ1BZfBemBW4K6MVT51qBrg8HUtZqUfL73qNV9haQPnPA8dG0ukaGkoBnTJoKhuAPoha+K06TtOK3UrtBWtwYN5gzUhTGdthb0IKkW1yDxAw0RRohkcqG+rF4nxQ6NYK/aiBIAaB1qIsQLe9+pexEg0TPL4+AQ26td
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199015)(7406005)(5660300002)(7416002)(55016003)(33656002)(26005)(9686003)(8676002)(66446008)(66476007)(53546011)(64756008)(66946007)(66556008)(76116006)(54906003)(110136005)(7696005)(6506007)(316002)(186003)(52536014)(8936002)(41300700001)(122000001)(38100700002)(38070700005)(82960400001)(82950400001)(4326008)(83380400001)(2906002)(86362001)(8990500004)(10290500003)(71200400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0ZJR2xBUmlKdWRWelluOThURnlDRWtxVDNqN1lLTUZKc0lqM3MvNy9UVlhJ?=
 =?utf-8?B?b1E1Sm9VSFRLVkhhSlY4QkpkRFppNTdLcDlOWGo4b0M3N3BsNFBPaHV1cGwx?=
 =?utf-8?B?emxqckl3cWJkN3huTnVkOFB4MDVqQndURUljK3AxR29seDEzUjY2VklCRVNN?=
 =?utf-8?B?cEQyb3NybHpObnNTcmVBd2E0UlNTcm5xV0gzL3hmT296OUJQdEk2MWhRT0k2?=
 =?utf-8?B?ckVqWU1nK050cEpvYld6UlFEQTlRZms3MXpnbG1OUFUvNUgwS2haOEZ0UDdX?=
 =?utf-8?B?VHQwMXYvVTF4amwrNlRIZmI4SlY4Z3FwTlZheWtzS1NDa1BGOUZTRGI3WmZy?=
 =?utf-8?B?aDdOYWc5Yk45Y2NpSEQ0c0hySmFPYVMzNEFBcHkzYm1MR0R6Rzg5RkJNVjVz?=
 =?utf-8?B?bmljcElkV2U2OVNwZTFiYnVQZ0NCdzJIbFVheVI0OUFTaG4wcFdJQVh4N01J?=
 =?utf-8?B?NnJ6dFlzdXRkZXJYU0lOMFRiSGZFc1hOM21SUHVBZG5ENXVKVXhBTHZvcTBB?=
 =?utf-8?B?czBycWJ0aStESzQ1MDdld0hHYmRyNE1uTUxXSFdCQlo4YzVReXVvaUNwWUw5?=
 =?utf-8?B?QTNZeGgyOFd3T1lrTlJ3NzV2aWQrOEFjUUtnWDdLSmwrWE92dURkZ2w4VEwr?=
 =?utf-8?B?VTJqaFlWejhzc3pRNDJ1Y3Zqa2ZjZVBrYmhQalF1VjVxK0pzVUNVWFNLands?=
 =?utf-8?B?WXhNaTVSREM4dHZxdHZWeGVzQURTZ1NZZlUwQ29kRkN2cHhYaG9aV2NsT3Jr?=
 =?utf-8?B?aEpBOWhjWjRrakIxV25KZVNqUnFqK0RTak5qT0xIbkd2Q2hheCsrcDdlL3N0?=
 =?utf-8?B?aElTTmdCY3BVVzFEdzJZenJRQTM2NnMzUEl6K0wyU1NnMGdTamxjc05icyty?=
 =?utf-8?B?ZVJyalBRcVhPVUdSbXR2b3RuS09WS1JqNVRIalBEUkVlc3ZINXgvc242WDlZ?=
 =?utf-8?B?VVRGVmtwOTAwVzRNNm5CbEUrSGpsdE5DSVBJVlhqSjNKVmVBZUJsSWQrOGNq?=
 =?utf-8?B?SVBYUG1LdDFYZzliWFJ1aE1zY1c4aC9YeGFMS3UzUC9mNFlyNUc2Y0poUktB?=
 =?utf-8?B?eVpkcUQ3alc0Q0JBWHZDZHF6Wmo2VXJFakZMS2dQMEdieFdLQW9rVDhXR25I?=
 =?utf-8?B?MmxJbXNnczBFZUY3U2cra2VYQ3pmRHJDOG9rSjFFUGRWd3RoWHJSd0dHaXZP?=
 =?utf-8?B?cG04Z095ZWdZM0NyMFBXeVBBU21sN2k5Q05CWGYyRjdnZjBibmh6OUpNMlBN?=
 =?utf-8?B?RmtjRXFaeWVTdFFBekxoYzBnaXVmeENILythd3p6TEtPQktnL3VMVFNCcHNS?=
 =?utf-8?B?U2E2K25LOXZ2Y0xHeVFUcVE3VUZnUFQvcGtISjBFTjE1NXdoU2hyZVVVQnR0?=
 =?utf-8?B?eks1VVA3aEhBbHc5TkZWRk5aSjMwVTd1TXRMemxWdHF0cXpZbTZxcXAzSXM5?=
 =?utf-8?B?dmNUTnhSQ01hUEtkMzFabXdvTjRQalZqaVduN0pEeUVzLzFyRXJGcVl6KzBv?=
 =?utf-8?B?K2hMZTkrZFdxWHlNMmtCRHpmNXVlbTF5d25wUDhwaWFwdkgzVFZwY0FmRjlo?=
 =?utf-8?B?c3NOSlduUGprR3hRSG9iU3NJTUJ6L3JGTEh4bGpiSnVjOVdyRUpLQVFxT3hr?=
 =?utf-8?B?L1VVV2VsMWUvRitYNzNlTkhqTlluZ3NDQVB6UC95M0tSSmMzNFdXYTZQS2F6?=
 =?utf-8?B?b0lBTEVJcGdvZGlYK1ZPRkNQQ01FZWV1bU9UdzRNQitSNjdraWFMdWFqajRa?=
 =?utf-8?B?ajQ1SjZRcmFOcGViRHN0SmJkeU5WMWFTS2F0ZXpIeEVKUDZxVzduUUZrYUdt?=
 =?utf-8?B?Tzhxc2RGcjcySCtrb3FhK29OSnBjRVR1YXdDZkdzbk9RbnFzSTNVdlZPeDBS?=
 =?utf-8?B?QTZ3Q3IwM0duWFMxV0JjeEluK0J1YmVkbTFGY1NCNzZ3RWgya1FySFNnUUZC?=
 =?utf-8?B?U00wc1YzMHN1VFo4YkNhWER6Z1F1amYydUpMWUtRVmQwTXI3emZzcGxWMmhJ?=
 =?utf-8?B?Vkwva09OUk1ybmpsd0FhWWR4cFRNZjZzZjRDM3JkOU1ScGRSV0trZTJ0NFc1?=
 =?utf-8?B?OEQvUzNYWDRINTluT3JWYW5TbzFaS0hhZXlqTU8xWkNJb1BzcDVHMm1wTEJ3?=
 =?utf-8?B?ZGZ6azBGaWNWMUp3SUZ5OGpIVU9YK3IwQ0lqTzlqRE11TjNRejhteDFVSktM?=
 =?utf-8?B?Z0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e037ee59-511e-47ea-35aa-08daccb33e7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 17:59:04.5442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mI1L5mkhYfC+/cUc9HXoP3Wz+fXlCET30CGMIiio3OuoD6QAbq71pm7o3FoiJecjNUKUPYR7ZQK7YUON62XvPaRsFSCkgR8vE7Sn/dWC9rM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1401
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU2F0aHlhbmFyYXlhbmFuIEt1cHB1c3dhbXkgPHNhdGh5YW5hcmF5YW5hbi5rdXBwdXN3
YW15QGxpbnV4LmludGVsLmNvbT4NCj4gDQo+IE9uIDExLzIxLzIyIDY6MzkgQU0sIEJvcmlzbGF2
IFBldGtvdiB3cm90ZToNCj4gPiBPbiBGcmksIE5vdiAxOCwgMjAyMiBhdCAwMjo1NTozMkFNICsw
MDAwLCBNaWNoYWVsIEtlbGxleSAoTElOVVgpIHdyb3RlOg0KPiA+PiBCdXQgSSBoYWQgbm90IHRo
b3VnaHQgYWJvdXQgVERYLiAgSW4gdGhlIFREWCBjYXNlLCBpdCBhcHBlYXJzIHRoYXQNCj4gPj4g
c21lX3Bvc3Rwcm9jZXNzX3N0YXJ0dXAoKSB3aWxsIG5vdCBkZWNyeXB0IHRoZSBic3NfZGVjcnlw
dGVkIHNlY3Rpb24uDQo+ID4+IFRoZSBjb3JyZXNwb25kaW5nIG1lbV9lbmNyeXB0X2ZyZWVfZGVj
cnlwdGVkX21lbSgpIGlzIGEgbm8tb3AgdW5sZXNzDQo+ID4+IENPTkZJR19BTURfTUVNX0VOQ1JZ
UFQgaXMgc2V0LiAgQnV0IG1heWJlIGlmIHNvbWVvbmUgYnVpbGRzIGENCj4gPj4ga2VybmVsIGlt
YWdlIHRoYXQgc3VwcG9ydHMgYm90aCBURFggYW5kIEFNRCBlbmNyeXB0aW9uLCBpdCBjb3VsZCBi
cmVhaw0KPiA+DQo+ID4gc21lX21lX21hc2sgYmV0dGVyIGJlIDAgb24gYSBrZXJuZWwgd2l0aCBi
b3RoIGJ1aWx0IGluIGFuZCBydW5uaW5nIGFzIGENCj4gPiBURFggZ3Vlc3QuDQo+ID4NCj4gDQo+
IFllcy4gSXQgd2lsbCBiZSAwIGluIFREWC4gSW4gc21lX2VuYWJsZSgpLCBBTUQgY29kZSBjaGVj
a3MgZm9yIENQVUlEDQo+IHN1cHBvcnQgYmVmb3JlIHVwZGF0aW5nIHRoZSBzbWVfbWVfbWFzay4N
Cj4gDQoNClJpZ2h0LiAgQnV0IGhlcmUncyBteSBwb2ludDogIFdpdGggY3VycmVudCBjb2RlIGFu
ZCBhbiBpbWFnZSBidWlsdCB3aXRoDQpDT05GSUdfQU1EX01FTV9FTkNSWVBUPXkgYW5kIHJ1bm5p
bmcgYXMgYSBURFggZ3Vlc3QsDQpzbWVfcG9zdHByb2Nlc3Nfc3RhcnR1cCgpIHdpbGwgbm90IGRl
Y3J5cHQgdGhlIGJzc19kZWNyeXB0ZWQgc2VjdGlvbi4NClRoZW4gbGF0ZXIgbWVtX2VuY3J5cHRf
ZnJlZV9kZWNyeXB0ZWRfbWVtKCkgd2lsbCBydW4sIHNlZSB0aGF0DQpDQ19BVFRSX01FTV9FTkNS
WVBUIGlzIHRydWUsIGFuZCB0cnkgdG8gcmUtZW5jcnlwdCB0aGUgbWVtb3J5Lg0KSW4gb3RoZXIg
d29yZHMsIGEgVERYIGd1ZXN0IHdvdWxkIGJyZWFrIGluIHRoZSBzYW1lIHdheSBhcyBhIEh5cGVy
LVYNCnZUT00gZ3Vlc3Qgd291bGQgYnJlYWsuICBUaGlzIHBhdGNoIGZpeGVzIHRoZSBwcm9ibGVt
IGZvciBib3RoIGNhc2VzLg0KDQpUaGUgb25seSB0aGluZ3MgSSBzZWUgaW4gdGhlIGJzc19kZWNy
eXB0ZWQgc2VjdGlvbiBhcmUgdHdvIGNsb2NrIHN0cnVjdHVyZXMNCkluIGFyY2gveDg2L2tlcm5l
bC9rdm1jbG9jay5jLCB3aGljaCBhcmVuJ3QgbmVlZGVkIHdoZW4gSHlwZXItViBpcyB0aGUNCmh5
cGVydmlzb3IuICBCdXQgd2l0aCBhIFREWCBndWVzdCBvbiBLVk0sIHdpbGwgKm5vdCogZGVjcnlw
dGluZyB0aGUNCmJzc19kZWNyeXB0ZWQgc2VjdGlvbiBiZSBhIHByb2JsZW0/ICBJIGRvbid0IGtu
b3cgdGhhdCBrdm1jbG9jaw0KY29kZSBvciB3aHkgdGhlIHR3byBjbG9jayBzdHJ1Y3R1cmVzIG5l
ZWQgdG8gYmUgZGVjcnlwdGVkIGZvcg0KQU1EIG1lbSBlbmNyeXB0aW9uLg0KDQpNaWNoYWVsDQo=
