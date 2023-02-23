Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0626A1180
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 21:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBWUwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 15:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBWUv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 15:51:56 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2119.outbound.protection.outlook.com [40.107.96.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B5816AEB;
        Thu, 23 Feb 2023 12:51:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghzYkxOrRALnahdYFgrs54gDTI1NsFohB2mylj9pbdiXR+PcGildhOiFaJaNVg8NNR3PQVvZWyZnBrPOemVptIpInHPDctZ4KrV5fs0J09Ahh16Rxb/b6ZiIj3fAHFgTFkPH6wzT6F9Mlpx1WR/7RAfF1hQAXgLpq5e6+wAQbXsNa66ZscERSRf84qbcw8aQ3PJM6nV7Rc3GTZin2Z/E+s3bwa5AuDjvEjYJkKS9haBq7IKGXQZ+3whMOlAVsSUAkMeGBsrFYdGV+EVQNg2CxNaWLdVuoM8X7gpnHCCAkliLSeg6s8af8RpBzZnYCf6l4rxd490gOjhEGApjSTttvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDv1VufghoMma3edBX2wCrBm4mf8mrgxvcd5Uho6qyo=;
 b=GKzsaJKmKt8D0JFzERPR+p/TzI8+TglpSo4JBSwKbYJitAqmnGg8hy3sdI82gnVOND2v7epFQRywXgoPCShdA7J5Pk02ZzdgR7T3kJ94yjxX6h0w/YdwyE0cBIxLy257DygKjKIei1X1bc59As5tVMX3FynFp/aqDATL9NbIFS8uOrS/g1zsQTEKVQ8O2GgDRV/gJIRlEhSAD2Z09O31fCiEZejSV/1otCYpzGxA6Slxa8/fJ5Vw2+7oybB3Z31VDgtujWb1gRz6uzvFYVNSYVB5k/FG3toldpi7kMEcYAL6emToorFd6ccp57D6ZASc5VTkDETXRd+GHzdbombUzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by PH7PR21MB3213.namprd21.prod.outlook.com (2603:10b6:510:1d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.10; Thu, 23 Feb
 2023 20:51:50 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::629a:b75a:482e:2d4a%5]) with mapi id 15.20.6156.005; Thu, 23 Feb 2023
 20:51:50 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <seanjc@google.com>
CC:     Borislav Petkov <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        KY Srinivasan <kys@microsoft.com>,
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
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAeE2AIABk95AgAGmoACAAAYigIAAAicAgAAHCQCAAAYXAIAADqWAgAAB8ICAAAP2cIAAK2uAgBQ2PACAAAQygIAAAMUw
Date:   Thu, 23 Feb 2023 20:51:49 +0000
Message-ID: <BYAPR21MB168836495869ABB4E3D61D61D7AB9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <4216dea6-d899-aecb-2207-caa2ae7db0e3@intel.com>
 <BYAPR21MB16886D92828BA2CA8D47FEA4D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aP8rHr6H3LIf/c@google.com> <Y+aVFxrE6a6b37XN@zn.tnic>
 <BYAPR21MB16882083E84F20B906E2C847D7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aczIbbQm/ZNunZ@zn.tnic> <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
 <Y+auMQ88In7NEc30@google.com> <Y+av0SVUHBLCVdWE@google.com>
 <BYAPR21MB168864EF662ABC67B19654CCD7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+bXjxUtSf71E5SS@google.com>
 <e15a1d20-5014-d704-d747-01069b5f4c88@intel.com>
 <e517d9dd-c1a2-92f6-6b4b-c77d9ea47546@intel.com>
In-Reply-To: <e517d9dd-c1a2-92f6-6b4b-c77d9ea47546@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7e5abc83-93fc-47c7-a733-2c16fac43ad3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-23T20:44:31Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|PH7PR21MB3213:EE_
x-ms-office365-filtering-correlation-id: ecd6634b-948d-4671-ae10-08db15dfc93a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HRMyk54SkgvrScVrQrDmLSs4KZSswc8O2pAuTaiu0nsCAKGbhOR6W0PN+aGlkv2lolLE5LLEpmlja00N8lAGrcJiu2PUc5ELi2SSppK2JuyQ9l9m4EpKLi6Hrxzreddn0mNfJgpZhAsTBuBTe+jxCCk9ct85o8x74ZEy75/gCBYSwdHehBqdInccIKU9CXeMKCqVnnCVDO8dL1nI8Zyij76T3xc03Guzc1ibz+4Puiwm5jZT5N0fFn7bcKNMYXoBw1bt2JF5oKcFb9cs4cAu9+p6wBIHupM4W7l4xgZTCbTXjHcIjUk0N4RZRWHfXVXShNe4b9guX8hkrm27i7NibAiOmr/Iqb0LN2t+75nNzvpKK5F3U4ukBbnB0gDC9SePhPVdh6yQSc+ht1GCZZr8H5V6/6W9TdvKQBV6quixwGX0wixWY9rNj2H69fq/PqAjQBuJrJhvKNf62KcWZcOF9TEazWu7anTUyyTTFTk6gCID5NUqCz0Q7b/Fr9MzIEmaaqv0BTw2ex9RKtl2iLboFwZssd6QwI/8nSQULBKwbha3myaZt7v24whHqqvQZsNx7R4qNq7ceWOfAa7EMH2bqBPr5nA78lUNMVeu31ujQ/Rn1gM0B2NPLuGzH3Wkc8uZTWPcIwfeJwMdJmh1Vw8OORgpjuUlL+erK7ebQ/kqE2XwqZqgcoWwPEK3t7yQdAIXw8MKAE814Xs5UzW/0oGMbn8mE/0AWCPu0B63b2yJqu+lBfpdraYVDwtPwPDX9kCa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199018)(54906003)(8936002)(316002)(52536014)(53546011)(6506007)(122000001)(82950400001)(82960400001)(8990500004)(86362001)(33656002)(71200400001)(7696005)(55016003)(2906002)(7406005)(10290500003)(478600001)(5660300002)(110136005)(38100700002)(7416002)(9686003)(41300700001)(38070700005)(26005)(186003)(66946007)(66446008)(66476007)(64756008)(66556008)(76116006)(4326008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkJQTXRhZmFIS1FJWjhxSy9nQThvUGJsdEdySE9jZFNzdzM5TEhmZmlyeEx0?=
 =?utf-8?B?UXJDMlBYS2NjRlh3NFJOZXZNeUtZa0lyMW5FWmNYZ05DUFdNVmpQTWw1WEFu?=
 =?utf-8?B?YUJxU3YrV1ZGMW1STmZzQUtGemo4N3JNbjRHZnBhM3cwMEV0VENzYlRDMjBU?=
 =?utf-8?B?bm0rYmNUbEVzcnFHY0JVN3hUM3NOdjlCSHhoZzJaWVEzMk9BY01jZzVrYlJt?=
 =?utf-8?B?ZnlEM3NsL3p2N0Urb2RhQ2ZvT2wyUm84VWs2VnMzWCtGcXhUVnB6dHF1SjEw?=
 =?utf-8?B?VVV5aXduRVM3cndtbmpwTVlqM1lKWHNhM1QyeVRQSndqMUh3MkFHV0hNRnR4?=
 =?utf-8?B?TXpJaW5UZkQ2dS9KTHhkMEJTdzRqRmJaYWN5MlZUSEl2aTN5ODJLQ0lUTnFT?=
 =?utf-8?B?azdpVnNjSGxXL1FBM3Izd1VJR2ZpZ0RPaUxGRUVFODM4bFVoRExKRTAvNE9U?=
 =?utf-8?B?TlhVL0ZFRTdyNWN3L1EzZ2tOcXdJcGEzbkxoZDVUSUdDclB4RmFjVTExcHc1?=
 =?utf-8?B?Vzc5dG1zMlNHYkw2aFNDNkZrTkVJYzZKOURHV0NlZk5aR1V6R1lOc3hLYWlF?=
 =?utf-8?B?K1lHY3VmbUZucjdZZHFuRnZaNFlUVDVaTGtnaC9UYUd1TkdFMXVvVmpHQXVI?=
 =?utf-8?B?Q2c5WnFVTVQ1aUNSUWZjSklZMUlKRGo2eE1EN1JuWTVGWk5ZUHVHTGhhdUVn?=
 =?utf-8?B?RUs0MzlialhQWXlOWG43Y2RTRmd1UE5NWXRhODhwbkUxNnZaRW1CVFoxZ2g0?=
 =?utf-8?B?M01WbnFCSnkvUGNUREl4anpHREk1RDMzM3RUL2JTdWFncUROV0EwU2lEekRq?=
 =?utf-8?B?bXRNL0o0VXJlVmFocWxYVDhJUi9FRXdidVh0aXpuZ25zRWNqZTcwckxxM0d2?=
 =?utf-8?B?d0c1dzQzUWZ6RDFKNjhYM1BjdFI0WmlGY2ViVmZPOHA1dE9pWGZNWllBd0NK?=
 =?utf-8?B?MUx2VmhVWmNvaHJ2M0ZEcTZGSzFXK2hrandjVHJKRzBKQmZNK0VZM2I3QmNp?=
 =?utf-8?B?VklRNExvUU9aTk53ZFZuZnkvblVDamdvMitGQW93WFBaVCtVcHpkQVRtZjVu?=
 =?utf-8?B?b0JOanJuTUFTK3FSbUlVblZ2c3FKZXpXbEd5cGJneDlUVis4c1pUNnplV0VX?=
 =?utf-8?B?QWZlVTZQNzNmMWdHNDhqQmcyczh3SWpmTzZSamdYQ2syS1R6d3V6UXpYYzVa?=
 =?utf-8?B?ZDBRZGhRM0E0NVAvWEgxY0lQZmFoVlpFQzI4czhGb0dOK29KR3R6MSs4aXZW?=
 =?utf-8?B?VWlHN2lYQkVrV2Jpc2JwTDhkVDIxcytZaUJQUmc4S3ZpZG1IdXlrKzZDK3Q5?=
 =?utf-8?B?YnJBTDZjdU1uTXJ6bGJ6dFptOHdjWC9CWi9SSFd3d3ZWRWFUaTZYbHBlbzN3?=
 =?utf-8?B?R0tNRmIxYzM5MmFCVXZCalVja1kzZWJpaThhejczbGMyY2VpZEk4WHNNR0xM?=
 =?utf-8?B?U2h6U1NEYTkvMmtGVGsyaFFXcSsyTkNCUHFGU2JQK2hKd2dHVzBoN1ArbFJv?=
 =?utf-8?B?TDFXNklYZTM3b1Iyd0cxTGRSTWVmZGFaNVljM0xJS2VDR2Z3YjFTOGhhWFIz?=
 =?utf-8?B?eGhTODVINWdVUWU3SGwrcE9EWGZFUkdmWDFhWHBERmxCeGlGZ2JNTFNCWEk3?=
 =?utf-8?B?ak1uN3lOTUx5ejBnYUEvWGUyQUY2bnE5bnlXSy9LaTVtWUpDZUZxT0RoMUlX?=
 =?utf-8?B?QVRqWXZHNkZ2b0pqeHVNblR3NHp3SE5ReXNVeFIwWXBTaWxLRU42VHd4Vjkr?=
 =?utf-8?B?QlIzaE9HVStFVTdhRkh4akMrWktyTWwvOFJpV0h4Y0hpL1NMTXF5UlhMWDZz?=
 =?utf-8?B?amRHb0djSUd4RUlzQXhuQ3NCQnNMeWRPL2JqZVRucTRaTUxNTWpHcUhIZFht?=
 =?utf-8?B?NTNWbFpjakJOTHJJMHJKQkw3ZURYZ25vMlRlTUFRRHBpUXNPVnlMTHBKSGhV?=
 =?utf-8?B?YmxaZHZqekJiSUlaRXc3SkphZytabWRzQmNxQTNkUVNicEs4TVhBUWIzcFJt?=
 =?utf-8?B?L2ZyWWVtMnpMZlpiK0xtYXVsWnpnTE50ODlRRTJuT29ZSXNncGxoeTZ0UDhS?=
 =?utf-8?B?Z1pXODVGTzVraG1CbU9WdElGUkhMSUg3Si9BMjRhQW83L091cXBOOFRMMXNn?=
 =?utf-8?B?V3ZVbXAvTHlmcklGQWlyaFlnVnJEZjEzdy9LczNhVkEzcjNXTEVNRGZ3ajBq?=
 =?utf-8?B?M1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecd6634b-948d-4671-ae10-08db15dfc93a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 20:51:49.9919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Hei5Jmu4OMBbXlctPjSW+zIxO/5TQqFjODBrg4K+q+tB3VRu8uHHFSkRFxBZWaX/kBHwo3kPDphAc66bZf77bMy0hWWzxNbr9rihvHEIOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3213
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4gU2VudDogVGh1cnNkYXks
IEZlYnJ1YXJ5IDIzLCAyMDIzIDEyOjQyIFBNDQo+IA0KPiBPbiAyLzIzLzIzIDEyOjI2LCBEYXZl
IEhhbnNlbiB3cm90ZToNCj4gPj4gKyAgICAgICBpZiAoY2NfcGxhdGZvcm1faGFzKENDX0FUVFJf
R1VFU1RfTUVNX0VOQ1JZUFQpKSB7DQo+ID4+ICsgICAgICAgICAgICAgICAvKg0KPiA+PiArICAg
ICAgICAgICAgICAgKiBFbnN1cmUgZml4bWFwcyBmb3IgSU9BUElDIE1NSU8gcmVzcGVjdCBtZW1v
cnkgZW5jcnlwdGlvbiBwZ3Byb3QNCj4gPj4gKyAgICAgICAgICAgICAgICogYml0cywganVzdCBs
aWtlIG5vcm1hbCBpb3JlbWFwKCk6DQo+ID4+ICsgICAgICAgICAgICAgICAqLw0KPiA+PiArICAg
ICAgICAgICAgICAgaWYgKHg4Nl9wbGF0Zm9ybS5oeXBlci5pc19wcml2YXRlX21taW8ocGh5cykp
DQo+ID4+ICsgICAgICAgICAgICAgICAgICAgICAgIGZsYWdzID0gcGdwcm90X2VuY3J5cHRlZChm
bGFncyk7DQo+ID4+ICsgICAgICAgICAgICAgICBlbHNlDQo+ID4+ICsgICAgICAgICAgICAgICAg
ICAgICAgIGZsYWdzID0gcGdwcm90X2RlY3J5cHRlZChmbGFncyk7DQo+ID4+ICsgICAgICAgfQ0K
PiAuLi4NCj4gPiBJdCBkb2VzIHNlZW0gYSBiaXQgb2RkIHRoYXQgdGhlcmUncyBhIG5ldyBDQ19B
VFRSX0dVRVNUX01FTV9FTkNSWVBUDQo+ID4gY2hlY2sgd3JhcHBpbmcgdGhpcyB3aG9sZSB0aGlu
Zy4gIEkgZ3Vlc3MgdGhlIHRyaXAgdGhyb3VnaA0KPiA+IHBncHJvdF9kZWNyeXB0ZWQoKSBpcyBo
YXJtbGVzcyBvbiBub3JtYWwgcGxhdGZvcm1zLCB0aG91Z2guDQo+IA0KPiBZZWFoLCB0aGF0J3Mg
X3JlYWxseV8gb2RkLiAgU2Vhbiwgd2VyZSB5b3UgdHJ5aW5nIHRvIG9wdGltaXplIGF3YXkgdGhl
DQo+IGluZGlyZWN0IGNhbGwgb3Igc29tZXRoaW5nPw0KPiANCj4gSSB3b3VsZCBqdXN0IGV4cGVj
dCB0aGUgSHlwZXItVi92VE9NIGNvZGUgdG8gbGVhdmUNCj4geDg2X3BsYXRmb3JtLmh5cGVyLmlz
X3ByaXZhdGVfbW1pbyBhbG9uZSB1bmxlc3MNCj4gaXQgKmtub3dzKiB0aGUgcGxhdGZvcm0gaGFz
IHByaXZhdGUgTU1JTyAqYW5kKiBDQ19BVFRSX0dVRVNUX01FTV9FTkNSWVBULg0KDQpBZ3JlZWQu
DQoNCj4gDQo+IElzIHRoZXJlIGV2ZXIgYSBjYXNlIHdoZXJlIENDX0FUVFJfR1VFU1RfTUVNX0VO
Q1JZUFQ9PTAgYW5kIGhlDQo+IEh5cGVyLVYvdlRPTSBjb2RlIHdvdWxkIG5lZWQgdG8gc2V0IHg4
Nl9wbGF0Zm9ybS5oeXBlci5pc19wcml2YXRlX21taW8/DQoNClRoZXJlJ3Mgbm8gc3VjaCBjYXNl
LiANCg0KSSBhZ3JlZSB0aGF0IGdhdGluZyB3aXRoIENDX0FUVFJfR1VFU1RfTUVNX0VOQ1JZUFQg
aXNuJ3QgcmVhbGx5IG5lY2Vzc2FyeS4NCkN1cnJlbnQgdXBzdHJlYW0gY29kZSBhbHdheXMgZG9l
cyB0aGUgcGdwcm90X2RlY3J5cHRlZCgpLCBhbmQgYXMgeW91IHNhaWQsDQp0aGF0J3MgYSBuby1v
cCBvbiBwbGF0Zm9ybXMgd2l0aCBubyBtZW1vcnkgZW5jcnlwdGlvbi4NCg0KTWljaGFlbA0K
