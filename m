Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451756266E6
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbiKLEbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbiKLEbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:31:51 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11020017.outbound.protection.outlook.com [40.93.198.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2092012762;
        Fri, 11 Nov 2022 20:31:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezNUAF6bc81r0ZcdtE6NPg9bwDcJ/YRIi4q6uWsLyMc8IZUS5mjhiIthFT2mWQjRQEtthUsv09g0d4B7Y+wgnWfk678hzZuUtkeA1Rh5WyJTQ8xPtbkJZW6o2YX4TeVJhhwNLI2SGcSRwjxOjDzIUQho9BaiV/uDstoUU/fKxt2vYsz13aebqo13KkP2NEz79tCQxLozk3ZP37lG2sqVG+OlVG3qM/AY+VFKJMv6eYx/Lru8DTRoaSixjuOL68rPr/E6z/kZAPVNz3B8cd4Q6bXNFVX4eCb5hQ269XkqOoDJSl6kbvN0zJj7g3LMTsh7VV03Fu3JMs3hnsHz0ECn7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PrNLD14MyPgZ1f8NUVzy9IyYg1nCyy78m2thk0Cow78=;
 b=mz+oqebyVyN38ndPCPdUi8UZEgz0rgLDtOHa3rwAclvI2mbUswkEnUaresBT9FGO0SeKuQPID1wdj3eaPNrkacwpOVoAEfaXnuzZcG1PHkX/bjA0NaV3dYviejJuTQ/tcYGx1s5ZIuwsccWXOyd8qiZgw2JyyHwR/V8aAMRA1cykyCQ9e9SiSimcxMmg884r/o7rucYdrSf14bZKJ+TFN/C2k2UFw6oURxSMb1xLRiQp1BYyAL72Vx6QtpUaEDGkQPn+m+hWCIuTOOzAqthUIa5j3V2uyNsYipq+9JQNw18TjCvRYUKOm8NKRVDzPEiukBzDU0avj3yvQ/Nl3PrLug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PrNLD14MyPgZ1f8NUVzy9IyYg1nCyy78m2thk0Cow78=;
 b=as1fqMP8fQcg8fhB8HtdHW6cRRi1WsenVq/9IL+8OWcab4h61/63fSJS2/sMTCbQ3DDrkRQXcQw7agX7G1XbLnbx+ZNN3ieoeehjkFG53UibHccAd4HbuaqScm+EkXrLO+43zhpSfVb6FywP6/OO0KqaCvdsBlGYUdYHMUhCGyQ=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SJ0PR21MB1293.namprd21.prod.outlook.com (2603:10b6:a03:3e5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Sat, 12 Nov
 2022 04:31:47 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%7]) with mapi id 15.20.5813.015; Sat, 12 Nov 2022
 04:31:47 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Dave Hansen <dave.hansen@intel.com>,
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
Subject: RE: [PATCH v2 01/12] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
Thread-Topic: [PATCH v2 01/12] x86/ioremap: Fix page aligned size calculation
 in __ioremap_caller()
Thread-Index: AQHY9ZXvB05GbI897ESEeyxWArQdDq46a3cAgAAS8iA=
Date:   Sat, 12 Nov 2022 04:31:47 +0000
Message-ID: <BYAPR21MB1688A1C064C1B7C1989B6C47D7039@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
 <1668147701-4583-2-git-send-email-mikelley@microsoft.com>
 <7d621ab2-6717-c6b6-5c3c-90af4c2f4afc@intel.com>
In-Reply-To: <7d621ab2-6717-c6b6-5c3c-90af4c2f4afc@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c3cd7d2a-4667-4a41-a7f2-c33dbd652059;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-12T01:19:21Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SJ0PR21MB1293:EE_
x-ms-office365-filtering-correlation-id: cd35de3c-8d3c-4f68-705d-08dac466cfc9
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i3fxH+VijM5ghauj4KPxc6p5EYnjBjLpTWHU2EnRw53rdYEfVEr3fr2mTNVjiq3xDbE+Np7C4klVkb81Sk5ZqqBaRYr8hl4ULsb3UElc3SchnOzk8LG902x/T9s0gW8+klGCxkRrMYh4xCwSU0V1uwjeiK5AkjbCzR16/qbKsfZcK9z2llhmz8Xj7J/b5gdSyGMhiPxM71gpueOOVsNxNH/It/rfnD61hkrfZDfPJ8Xiu5lbFj+0q1R9318naJoSan0ejwT1C9tilSO8rVeZrRk8R3SacKCVRS7i4n8fSNkDZ035yO8tQU+58m/fpVSeUtojcDEp74pqabnd8gFgV2vMdDAbzvolsQmX/9OSxh/syyDk8td9lM8TLFOrB24SVZ41kfXHVagff2Kz3AeflKAhSI0Nst/APjaQIeATEIlM+aZ/ZxLxu1epmTc7jqk2mILme19JlV/Cil2YuEB0+yOEFbBbTYmGTLpNZ6QCMVaM4toyRSX52FdGbkZb/uP1GelL8cFQZVWv5mQqSbdafplpKv6tphSmIIZffaYertQDJkif7j0BgPqvOU+egVJZRaSvWGYdxUVwisDXQzHq5QS6hhGUlI2Cuy04jm3gG3GDICxGiAiIBhZmuEelSqcUySUn915wOQIbOGSPVKuQSP2MaN5U0AlLEelLcE0DyOx+8lL8s8jwxkZyFJY80nBz2Qo8yZDCinKfPQzMsXjUdejmrcOb9oFNX7DTsvxQBDO6S0LKP1nRcf3awJICbdyHqxcALcuXgy4pNVXsAgxVkwCrXjZ/iB7AWtLGFqUABRlyLTjqBdjIzA9yadSAt0rj0Q7qMF4ZF8E080QeMz/Kzw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199015)(66556008)(86362001)(8676002)(110136005)(33656002)(76116006)(316002)(66946007)(8990500004)(6506007)(83380400001)(53546011)(38070700005)(66476007)(66446008)(41300700001)(26005)(7696005)(9686003)(921005)(478600001)(10290500003)(64756008)(38100700002)(82950400001)(82960400001)(71200400001)(122000001)(7406005)(7416002)(8936002)(55016003)(186003)(52536014)(2906002)(5660300002)(66899015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elQrY0xOK2RHd0NodHZQYnFLaHVML1pEeUxLYWdxd3g3RVVoL1hGbkxIeFhp?=
 =?utf-8?B?Nm16UExXMENjWDhjQkZ1MnZiQ091RVJZUWhsY3pHb25HS1JzWlB5aDFiZEwv?=
 =?utf-8?B?K3pwMDlQSm1aNXlqdUxJZG5pUVBnNGxlQkgxYVg1bkJydC9vOHlhQWloRytZ?=
 =?utf-8?B?eGt4cjlXcFlSY2F4T2FhWlJVcm5WeDVUSGpGZWtmdEs3SURQN3plYXlzYS9h?=
 =?utf-8?B?d1kwclgwYms0SkpCOTMrVlNyUkNWUzZiYjYvK1F6VnZ3a3BLVmE2NHoxTU9v?=
 =?utf-8?B?Vml6VVBNSWJySUZ3VGlpNi9PN1huMWpmcmNDWTlqd2o0R21EakVLSStHZkc3?=
 =?utf-8?B?M3lnOFVPWWxhL0xVb3lMNFphakdaa2N1TzFmU0V4UnRUSG9QRjVMeVNwTFlW?=
 =?utf-8?B?U1lhWlJuR0RSdnFZclNCOU8vL05FS3Vndmd2TGZ2eWtrdDhtMzBjUitmRVEy?=
 =?utf-8?B?emdmemRZbEx2c1k3ZFBmTmM2Um5xTTYwd1E0MXFuWlY1SFV6M25FcHY4dkpB?=
 =?utf-8?B?YXdiR1poTjZnN1I4MnM1UGZZNXY1SzRvVjYzeTRTanM0R2lEYyswdUxYZ0I1?=
 =?utf-8?B?RVdLREhhTk9SQThtdHZZemVWUEgvYmxhUklVUnZzU1ZMT2pEK0pzVWUzdHhR?=
 =?utf-8?B?b3hQaGg2aGUwTmVvZGdBYjQyNGdyVzB1VUVJMitySGxYR0J2cU9sSjhURE54?=
 =?utf-8?B?UWZUcXd1SU5QT0VqYnIwZXl5YldXZWppL204WGlQOFFSQUVIRXhyaXBiU2ZR?=
 =?utf-8?B?ek8vTk1xSXVzbmJuYlRvbE43OHpGdWRKVjNaK0N4akVzNUxRcFM0MnFqcEsz?=
 =?utf-8?B?T3B4aDlPbWl2NGVtNmVJS01xQnEyTVV6SSsxSEh0YWdvNDdESmpqQlVlOTl0?=
 =?utf-8?B?dVFtZE45VTdDQThCQ0ZaNTZsVkRSL0J3ZVNDM2FXd1ZvaEpoTGRYL1Y3d2NC?=
 =?utf-8?B?eVBiNUpJV3k3dm1wbWl1Y1JxcHJVQ2ozV2F2SEtYb3lPUzJZeXpUOHU3WU5t?=
 =?utf-8?B?UStzZmIrWCtVUEJJeDdCdGU5d1p0NlpObEgweXR2M2NraDNXUFpjOUpJSFFu?=
 =?utf-8?B?UWtnTkIxZ0tsN2xBaFZLOWt2RWZwTUVGRFFWWVVvbHdYd0NrUHVMb21oSU4z?=
 =?utf-8?B?VkxUTmZOQWViK3o1UUlOdkwyVTdPeDdBZTJ2aUNXR2ZTSnZONlZUL1hHZXJj?=
 =?utf-8?B?a1RCeGZIYTZqV1IweDR2MzJPWHQ1VWJDemdYQkdTZlFmOTVDd0VoK1Z2cGFG?=
 =?utf-8?B?aWpndklXRXJTQ3RWb0tUSlBKSTJBc1U3alpoNUVlaUR4TUNSK3RwRmtOd2V1?=
 =?utf-8?B?L2lkZkZFZUFCdDF5UHF1NWFYb2xaY3BkS2FCUlkzWXllQ0UrNzJLU3NpaSty?=
 =?utf-8?B?MjZCWTZ3TUluVjRSKy9RU0ovVDRxd2F2bHlCR2pVL29BTklqWmpUbWI4dTZr?=
 =?utf-8?B?dmhHVjM4YjFua256b1J3b2NKaEM1dGwvK2RBSy9KTzZCWHp1dERIU3dGekhj?=
 =?utf-8?B?Rzd4Z2svZTd6WUc0MVp3VmJKOXY5NU12dDNNcXYvcnRZZUt2VTcvV1BEZkNp?=
 =?utf-8?B?MUNFeUkwQ0t3ckQ0a1ErTXNsanFtc2NrZDErVU9LNWYxeHdNUytZT1NJMHN3?=
 =?utf-8?B?MkduNHRwczhJYStkK3BEWHhCVk1uRWpoM2xBNldaRndHMFNsWHdCTkdtamhM?=
 =?utf-8?B?d1ppMTVveGViKzZFMXpNak0wbVhoc2xOeTdQZFI5UnhRUDhUTmd0UThjcGpp?=
 =?utf-8?B?S0R3ZU9mVkl0RVdmV21DSnVkSFNiUXR4OERwaW5nM3JSelIwTGV4R0JMQ0Fx?=
 =?utf-8?B?VmVNbmpkZUlyUDEwNmNMVFVoVXhtM0Zib08zOUNsdUtOb2lFaEJSbDR4bGRD?=
 =?utf-8?B?YWZ5b1dCTitmT0t3NFJaZjlnQ0ZWY3MvdUtYNnlSWm9hK2pYSHRibVUvQXha?=
 =?utf-8?B?aGtzbnFuMWcyVXZCNXJxekVNMzFTWWp6cUwrL3lEcHEzVnlndkVaMFgwaXFX?=
 =?utf-8?B?SjR4SDJJdWdtZTlOK1hMUFhvMnV2V2g2d2ZIQ2tlcC9mNkZlWURIL0pHdTR4?=
 =?utf-8?B?d3pZZDhpUDcvY1lEbllDa0tzVHBkT2hqSnRKVGZ0T09OeVJuUXBIN3dHNVI4?=
 =?utf-8?B?TWdpblpvR0JHbmxNeGVjSEEzQlV6YVZTSFprQ2JnVDdwY2MrZDVLOFlFYkJX?=
 =?utf-8?B?Nmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd35de3c-8d3c-4f68-705d-08dac466cfc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2022 04:31:47.7515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SEiLATylJCBzQ4Y7O3rFIQZzDNyDMx7hwak3ajPY3+YE0X9lxcv9SeMGEkq0riuKnieLL4nudbQRejcyIt+k4I257PDIpIwHJaLGV8xzNSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1293
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4gU2VudDogRnJpZGF5LCBO
b3ZlbWJlciAxMSwgMjAyMiA0OjEyIFBNDQo+IA0KPiBPbiAxMS8xMC8yMiAyMjoyMSwgTWljaGFl
bCBLZWxsZXkgd3JvdGU6DQo+ID4gSWYgYXBwbHlpbmcgdGhlIFBIWVNJQ0FMX1BBR0VfTUFTSyB0
byB0aGUgcGh5c19hZGRyIGFyZ3VtZW50IGNhdXNlcw0KPiA+IHVwcGVyIGJpdHMgdG8gYmUgbWFz
a2VkIG91dCwgdGhlIHJlLWNhbGN1bGF0aW9uIG9mIHNpemUgdG8gYWNjb3VudCBmb3INCj4gPiBw
YWdlIGFsaWdubWVudCBpcyBpbmNvcnJlY3QgYmVjYXVzZSB0aGUgc2FtZSBiaXRzIGFyZSBub3Qg
bWFza2VkIG91dA0KPiA+IGluIGxhc3RfYWRkci4NCj4gPg0KPiA+IEZpeCB0aGlzIGJ5IG1hc2tp
bmcgdGhlIHBhZ2UgYWxpZ25lZCBsYXN0X2FkZHIgYXMgd2VsbC4NCj4gDQo+IFRoaXMgbWFrZXMg
c2Vuc2UgYXQgZmlyc3QgZ2xhbmNlLg0KPiANCj4gSG93IGRpZCB5b3Ugbm90aWNlIHRoaXM/ICBX
aGF0IGlzIHRoZSBpbXBhY3QgdG8gdXNlcnM/ICBEaWQgdGhlIGJ1Zw0KPiBhY3R1YWxseSBjYXVz
ZSB5b3Ugc29tZSB0cm91YmxlIG9yIHdhcyBpdCBieSBpbnNwZWN0aW9uPyAgRG8geW91IGhhdmUg
YQ0KPiBzZW5zZSBvZiBob3cgbWFueSBmb2xrcyBtaWdodCBiZSBpbXBhY3RlZD8gIEFueSB0aG91
Z2h0cyBvbiBob3cgaXQNCj4gbGFzdGVkIGZvciAxNCsgeWVhcnM/DQo+IA0KPiBGb3IgdGhlIGZ1
bmN0aW9uYWxpdHkgb2YgdGhlIG1hcHBpbmcsIEkgZ3Vlc3MgJ3NpemUnIGRvZXNuJ3QgcmVhbGx5
DQo+IG1hdHRlciBiZWNhdXNlIGV2ZW4gYSAxLWJ5dGUgJ3NpemUnIHdpbGwgbWFwIGEgcGFnZS4g
IFRoZSBvdGhlciBmYWxsb3V0DQo+IHdvdWxkIGJlIGZyb20gbWVtdHlwZV9yZXNlcnZlKCkgcmVz
ZXJ2aW5nIHRvbyBsaXR0bGUuICBCdXQsIHRoYXQncw0KPiB1bmxpa2VseSB0byBtYXR0ZXIgZm9y
IHNtYWxsIG1hcHBpbmdzIGJlY2F1c2UgZXZlbiB0aG91Z2g6DQo+IA0KPiAJaW9yZW1hcCgweDE4
MDAsIDB4ODAwKTsNCj4gDQo+IHdvdWxkIGVuZCB1cCBqdXN0IHJlc2VydmluZyAweDEwMDAtPjB4
MTgwMCwgaXQgc3RpbGwgd291bGRuJ3QgYWxsb3cNCj4gDQo+IAlpb3JlbWFwKDB4MTAwMCwgMHg4
MDApOw0KPiANCj4gdG8gc3VjY2VlZCBiZWNhdXNlICpib3RoKiBvZiB0aGVtIHdvdWxkIGVuZCB1
cCB0cnlpbmcgdG8gcmVzZXJ2ZSB0aGUNCj4gYmVnaW5uaW5nIG9mIHRoZSBwYWdlLiAgQmFzaWNh
bGx5LCB0aGUgZmlyc3QgY2FsbGVyIGVmZmVjdGl2ZWx5IHJlc2VydmVzDQo+IHRoZSB3aG9sZSBw
YWdlIGFuZCBhbnkgc2Vjb25kIHVzZXIgd2lsbCBmYWlsLg0KPiANCj4gU28gdGhlIG90aGVyIHBs
YWNlIGl0IHdvdWxkIG1hdHRlciB3b3VsZCBiZSBmb3IgbWFwcGluZ3MgdGhhdCBzcGFuIHR3bw0K
PiBwYWdlcywgc2F5Og0KPiANCj4gCWlvcmVtYXAoMHgxZmZmLCAweDIpDQo+IA0KPiBCdXQgSSBn
dWVzcyB0aG9zZSBhcmVuJ3QgdmVyeSBjb21tb24uICBNb3N0IGxhcmdlIGlvcmVtYXAoKSBjYWxs
ZXJzIHNlZW0NCj4gdG8gYWxyZWFkeSBoYXZlIGJhc2UgYW5kIHNpemUgcGFnZS1hbGlnbmVkLg0K
PiANCj4gQW55d2F5LCBzb3JyeSB0byBtYWtlIHNvIG11Y2ggb2YgYSBiaWcgZGVhbCBhYm91dCBh
IG9uZS1saW5lci4gIEJ1dCwNCj4gdGhlc2UgZGVjYWRlLW9sZCBidWdzIHJlYWxseSBtYWtlIG1l
IHdvbmRlciBob3cgdGhleSBzdHVjayBhcm91bmQgZm9yIHNvDQo+IGxvbmcuDQo+IA0KPiBJJ2Qg
YmUgY3VyaW91cyBpZiB5b3UgdGhvdWdodCBhYm91dCB0aGlzIHRvbyB3aGlsZSBwdXR0aW5nIHRv
Z2V0aGVyIHRoaXMNCj4gZm94Lg0KDQpUaGUgYnVnIG9ubHkgbWFuaWZlc3RzIGlmIHRoZSBwaHlz
X2FkZHIgaW5wdXQgYXJndW1lbnQgZXhjZWVkcw0KUEhZU0lDQUxfUEFHRV9NQVNLLCB3aGljaCBp
cyB0aGUgZ2xvYmFsIHZhcmlhYmxlIHBoeXNpY2FsX21hc2ssIHdoaWNoIGlzDQp0aGUgc2l6ZSBv
ZiB0aGUgbWFjaGluZSdzIG9yIFZNJ3MgcGh5c2ljYWwgYWRkcmVzcyBzcGFjZS4gVGhhdCdzIHRo
ZSBvbmx5IGNhc2UNCmluIHdoaWNoIG1hc2tpbmcgd2l0aCBQSFlTSUNBTF9QQUdFX01BU0sgY2hh
bmdlcyBhbnl0aGluZy4gICBTbyBJIGRvbid0DQpzZWUgdGhhdCB5b3VyIGV4YW1wbGVzIGZpdCB0
aGUgc2l0dWF0aW9uLiAgSW4gdGhlIGNhc2Ugd2hlcmUgdGhlIG1hc2tpbmcgZG9lcw0KY2xlYXIg
c29tZSBoaWdoIG9yZGVyIGJpdHMsIHRoZSAic2l6ZSIgY2FsY3VsYXRpb24geWllbGRzIGEgaHVn
ZSBudW1iZXIgd2hpY2gNCnRoZW4gcXVpY2tseSBjYXVzZXMgYW4gZXJyb3IuDQoNCldpdGggdGhh
dCB1bmRlcnN0YW5kaW5nLCBJJ2QgZ3Vlc3MgdGhhdCBvdmVyIHRoZSBsYXN0IDE0IHllYXJzLCB0
aGUgYnVnIGhhcw0KbmV2ZXIgbWFuaWZlc3RlZCwgb3IgaWYgaXQgZGlkLCBpdCB3YXMgZHVlIHRv
IHNvbWV0aGluZyBiYWRseSBicm9rZW4gaW4gdGhlDQpjYWxsZXIuICBJdCdzIG5vdCBjbGVhciB3
aHkgbWFza2luZyB3aXRoIFBIWVNJQ0FMX1BBR0VfTUFTSyBpcyB0aGVyZSBpbiB0aGUNCmZpcnN0
IHBsYWNlLCBvdGhlciB0aGFuIGFzIGEgInNhZmV0eSBjaGVjayIgb24gdGhlIHBoeXNfYWRkciBp
bnB1dCBhcmd1bWVudA0KdGhhdCB3YXNuJ3QgZG9uZSBxdWl0ZSBjb3JyZWN0bHkuDQoNCkkgaGl0
IHRoZSBpc3N1ZSBiZWNhdXNlIHRoaXMgcGF0Y2ggc2VyaWVzIGRvZXMgYSAqdHJhbnNpdGlvbiog
aW4gaG93IHRoZSBBTUQNClNOUCAidlRPTSIgYml0IGlzIGhhbmRsZWQuICB2VE9NIGlzIGJpdCA0
NiBpbiBhIDQ3LWJpdCBwaHlzaWNhbCBhZGRyZXNzIHNwYWNlIC0tDQppLmUuLCBpdCdzIHRoZSBo
aWdoIG9yZGVyIGJpdC4gIEN1cnJlbnQgY29kZSB0cmVhdHMgdGhlIHZUT00gYml0IGFzIHBhcnQg
b2YgdGhlDQpwaHlzaWNhbCBhZGRyZXNzLCBhbmQgY3VycmVudCBjb2RlIHBhc3NlcyBhZGRyZXNz
ZXMgd2l0aCB2VE9NIHNldCBpbnRvDQpfX2lvcmVtYXBfY2FsbGVyKCkgYW5kIGV2ZXJ5dGhpbmcg
d29ya3MuICAgQnV0IFBhdGNoIDUgb2YgdGhpcyBwYXRjaCBzZXJpZXMNCmNoYW5nZXMgdGhlIHVu
ZGVybHlpbmcgZ2xvYmFsIHZhcmlhYmxlIHBoeXNpY2FsX21hc2sgdG8gcmVtb3ZlIGJpdCA0NiwN
CnNpbWlsYXIgdG8gd2hhdCB0ZHhfZWFybHlfaW5pdCgpIGRvZXMuICBBdCB0aGF0IHBvaW50LCBw
YXNzaW5nIF9faW9yZW1hcF9jYWxsZXIoKQ0KYSBwaHlzX2FkZHIgd2l0aCB0aGUgdlRPTSBiaXQg
c2V0IGNhdXNlcyB0aGUgYnVnIGFuZCBhIGZhaWx1cmUuICBXaXRoIHRoZQ0KZml4LCBQYXRjaCA1
IGluIHRoaXMgc2VyaWVzIGNhdXNlcyBfX2lvcmVtYXBfY2FsbGVyKCkgdG8gbWFzayBvdXQgdGhl
IHZUT00gYml0LA0Kd2hpY2ggaXMgd2hhdCBJIHdhbnQsIGF0IGxlYXN0IHRlbXBvcmFyaWx5Lg0K
DQpMYXRlciBwYXRjaGVzIGluIHRoZSBzZXJpZXMgY2hhbmdlIHRoaW5ncyBzbyB0aGF0IHdlIG5v
IGxvbmdlciBwYXNzIGENCnBoeXNfYWRkciB0byBfX2lvcmVtYXBfY2FsbGVyKCkgdGhhdCBoYXMg
dGhlIHZUT00gYml0IHNldC4gIEFmdGVyIHRob3NlDQpsYXRlciBwYXRjaGVzLCB0aGlzIGZpeCB0
byBfX2lvcmVtYXBfY2FsbGVyKCkgaXNuJ3QgbmVlZGVkLiAgQnV0IEkgd2FudGVkIHRvDQphdm9p
ZCBjcmFtbWluZyBhbGwgdGhlIHZUT00tcmVsYXRlZCBjaGFuZ2VzIGludG8gYSBzaW5nbGUgaHVn
ZSBwYXRjaC4NCkhhdmluZyBfX2lvcmVtYXBfY2FsbGVyKCkgY29ycmVjdGx5IGhhbmRsZSBhIHBo
eXNfYWRkciB0aGF0IGV4Y2VlZHMNCnBoeXNpY2FsX21hc2sgaW5zdGVhZCBvZiBibG93aW5nIHVw
IGxldCdzIHRoaXMgcGF0Y2ggc2VyaWVzIHNlcXVlbmNlIHRoaW5ncw0KaW50byByZWFzb25hYmxl
IHNpemUgY2h1bmtzLiAgQW5kIGdpdmVuIHRoYXQgdGhlIF9faW9yZW1hcF9jYWxsZXIoKSBjb2Rl
IGlzDQp3cm9uZyByZWdhcmRsZXNzLCBmaXhpbmcgaXQgc2VlbWVkIGxpa2UgYSByZWFzb25hYmxl
IG92ZXJhbGwgc29sdXRpb24uDQoNCk1pY2hhZWwNCg==
