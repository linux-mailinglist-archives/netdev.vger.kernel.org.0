Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BE5639FC5
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 03:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiK1Cwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 21:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiK1Cwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 21:52:33 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westus2azon11020027.outbound.protection.outlook.com [52.101.46.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C60CE02;
        Sun, 27 Nov 2022 18:52:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4ohoVkcXtO5OUari+NicZ+mZTku2kEwCnBr329yMaVaZUo+P2rC3YMoSUosfDE3OLDsAEJwv3Z3vteTZtloiPZ3BeyBEaW8gLidHYajQPKmvncFlPJungTeHaaCyNUVdGyqTKb9CmHlFDurkh5ldoE3VjqlMy8/9L1sAHYxN5IcJDiRq3gTDhqf+seVGIeE/3rNM4Gsbv807U5ZginlGMSATzPmwstW7NL02Y04FxwMo2TULINLfv0uMneri+Yqm5yOYmIZWuLw9L/ed/g9XGFTIEmAsOCpLTjPACascsx6hgIM/kAhA/PCbKi5SH4mJ2jXhxK32uk14sbcjyYdeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDH55LsbVGWl7BXMrjYAUf+ehcqMzT7uVdBSFrsfrxA=;
 b=TWXDeIbgJpposMCEAskMHYJT/iT0kMksaR4pSuQYGA5E+ZFojnt4L9SZNPOVSKCPSbHT27HE7KRVLIsakutDso7Gjk7dup3Bc1ULZ7MIJroZE0FH5cipNIjtkhdB3qxvhk68zmYxF/QkqOFaYjNv3/eTMgMIfivndvebag9J9UyVdoJwUo+PO5BWjjXGytiZMCLqYQXTd+A2CRp2N5XASwPBupXqlIrRH12ljXcvEzUbRGNfmGcf3wusjJMKpZX6owMJkqu36ncBUvBheWMIJHMjJF56h3aso1IJUeO1o+LlbYlepYu8Jp6wLHshD0blgicw8DCKG9fy38jK5dN9LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDH55LsbVGWl7BXMrjYAUf+ehcqMzT7uVdBSFrsfrxA=;
 b=eixiAOmy7PDOkzTJQhEd5QecC8c55x7bIdxpi99BHi82R1NfKgXvAW1T39moYFdKtRui2mIYl+G5+a82HfNkAjhI1/pLsYEC9WF1h4T7G3yUVdndqan/qjnaUlT1+HnWA8rmoXs5K622vc9WZQ8IN6yTvVQ687jOYb5XZPny5eA=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by DS7PR21MB3389.namprd21.prod.outlook.com (2603:10b6:8:81::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Mon, 28 Nov
 2022 02:52:29 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::ac9b:6fe1:dca5:b817]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::ac9b:6fe1:dca5:b817%6]) with mapi id 15.20.5880.008; Mon, 28 Nov 2022
 02:52:28 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
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
Thread-Index: AQHY+s4ztxnVbL+L5UCX76A2RK98j65D/NUAgA+0gRA=
Date:   Mon, 28 Nov 2022 02:52:28 +0000
Message-ID: <SA1PR21MB133512D4B7B78DB38765EBFEBF139@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
 <01d7c7cc-bd4e-ee9b-f5b2-73ea367e602f@linux.intel.com>
 <BYAPR21MB1688A31ED795ED1B5ACB6D26D7099@BYAPR21MB1688.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB1688A31ED795ED1B5ACB6D26D7099@BYAPR21MB1688.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=44062edc-2214-466e-b1b5-eadfe699b503;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-18T02:41:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|DS7PR21MB3389:EE_
x-ms-office365-filtering-correlation-id: ede13aee-46fe-4330-5fb2-08dad0eb9680
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hsevWlo5/D/U5rBJJ1hLbSXqE7FKumz78crazpU5Qm9nYahVgjywEU0etIJ/zTTYtobK/5pXQMMwgJxGcA9PYDGZD4cnKk/tMZfW1PV+F6S3LOzyHcTuVQh3ixyoHpnXPR2lJOXgt52SYFBOweCFxiK6fgFtbHfYtlEVzm92OK6f2jaQeVVxaXuUDUYnXCXeWHS037/PmUxWK63sAVmftLRAJhNUwy5EhGKxGewmHbPc/p5MwQqbpyS8fU0I+7Xez0Jg2NM1Clpm4LM0QD1y5hKKmKsPnD3tIvkaREZReavTuhEZbHJkgLAzaBlSfONa8F4PXQ3F2cGJVDDNVkx1Upq1B+53nlu3egWXy6tE8FAAoHqIy5ilbpJW/bLbfrUM2yvXK1LIAmz1ey6n+ikSiVipoBBh+Gl8a++VTR6sg49OX6LGuWeM+sw4ySPIyMXpLopJaaXhtLsHCo2Kg7NKIJQ1C3f0ULyGEXip/tGEATMv7baF0asXAQXCWKb2dGXHDZ87M2K+WyMF1O4rtgfX44Cy4FFFTF1/KIZIHSBSCU4yPnElYJx5VWC3tCic6YUnHDWBOsdDgrjnMCoB52M8KlSSeQIp3FkUw5rW0XViO3XHwtqOSHbiphiEH9OBy2KKxLI4/bMNyF35aZmFQy3ViSTTO6QzbL/+rdy+g3KO/2rcQCd1HOuxI2PPix0hK2tUB/6oyuVD+H8JXZZWi5DQrM7z1rAEjcCw4w3lNKWF+lHdOv2tv/h23ucb3dJNE65jID1eXoOGBsWLppD3XreB0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199015)(86362001)(33656002)(55016003)(41300700001)(66946007)(5660300002)(66556008)(76116006)(64756008)(6506007)(66446008)(8676002)(66476007)(110136005)(26005)(71200400001)(9686003)(7696005)(83380400001)(186003)(10290500003)(478600001)(921005)(38070700005)(316002)(82950400001)(82960400001)(38100700002)(8936002)(7406005)(7416002)(52536014)(122000001)(8990500004)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnZYMm81RVQ5eHZFSjM5S3ZNejYrQlBOUGhneDlKOVgrN0NtUHVOdTNqdWtj?=
 =?utf-8?B?blFRMGorS3dudEM0bGdML2FCMTZhWWVnMzdpdEFWUjF6U0M0c3lmYXBtS2k5?=
 =?utf-8?B?NkVBRXRVcmJ4VE5qVm5NTkxSV1lNeWQ2bk1OeEFYZFlZY2E5bzRlRXlKVnJl?=
 =?utf-8?B?WGgzS0ZGbnlQblFxZE51UnBTZE9GYStYTjk2OE5wNERxcHFGb1JCVXFUUlFD?=
 =?utf-8?B?OThqSVpXdnNoajk2ZnhjYzFCcXpMR2gxRmp2bjVJVDBnRjBtRFYvV3hBK3dr?=
 =?utf-8?B?MkxmRUg0S2kxZUkyWk9xOS9IQnNvWHgrNzFKY0ErQ3E2QUpBVHdvaXRaN0Jl?=
 =?utf-8?B?SEhxR1phLzJvOTkvUlBhWWJwZ2ZTRjM3NjJreWcyV1lQSGdnRzhEL000L2Qy?=
 =?utf-8?B?ek1DaXRIc3hsUmh3MmgwdmJueVFLNFVuaGc0SVhZb202S1lPK0piMWJublJ3?=
 =?utf-8?B?aGlqMC9IWXNqbVVWVzVMWWRtKzFabXdEcFhJRjc3cFVsMVFvZFFlUmYwOHhJ?=
 =?utf-8?B?UitMV0FRRS9YVXgwUUg5TVJYTm9lclhnVkNiK2RacHBnTEFwV2pHbmp5TnVT?=
 =?utf-8?B?ZzFtOElhL1lDM1B0ZitWdS82MmJERXFBOE9qRmpKVXlUNzAybENtWERsc1RR?=
 =?utf-8?B?a0t6cnZCNy9ZWkwwS2NHdDBTSGYzaE5BT2ppMjZaeHIyWU5TYXdDNkdzZVJj?=
 =?utf-8?B?QXlZMk5adEUzZzNBcGlrOW5DcEZVVjB6QXJEZFQ4NVprbjJlSlNNMDVrV2xP?=
 =?utf-8?B?enc5K1VuSjZ6bDJJRStQQ0lpdVhBQjdaaTJVTmVickIzZUlNdTVQcFpxZXcr?=
 =?utf-8?B?K01SRitSYVlSQmtoY0V3b0xobzJnanRleDBHeVVQRjZHalM5bkRDek9tdWhv?=
 =?utf-8?B?TEhRVjQxQVBxWDBMYXFPYjI4RmJEUTlJS0RnUmFERDJQUzV6ZGZHaEdNdEJ5?=
 =?utf-8?B?ZnJuLzU5TXpBODhHRlYvWS9HOWQvN1RTZ2NGb3BIWTJpNXl2WHdOMW5IREZ6?=
 =?utf-8?B?M1p2V1FyMXdUaDI3ZG1PNjI4aHptYUdmb21ETHNWSm9tS0RXVGZJc1dIK0FQ?=
 =?utf-8?B?cEJsYW91eG42UzJFZlVBZnBRTmtPN0gyV2hFditMQjNpWHZ1NE82N3p0VVpQ?=
 =?utf-8?B?OUl2Z1lXa0x1SFloeWN5WEU1ZEE3MWt5Uk1LYjRnMk9ib1pPcjU3cTJwcWVT?=
 =?utf-8?B?K3k1Tnd3WDk1YnJuNlhyZUlacUJmS2puOVlhc3RDNFFxUlhEYittYS9JMG9R?=
 =?utf-8?B?NFU3amtRNUk5aUNqRTdQNTc1U1JYQ2lMeEhha0RrcGw4ckpIQUkvMlhKeXdZ?=
 =?utf-8?B?R0ZoSW1KWGtCWml3N0R2TTNodU5jK1l4aTllZ3Z2VUQ4cFlMVGMzZ0lUalZ1?=
 =?utf-8?B?eEM3dGhrNmJCNHE1UVYxOUtXT3BJMnFNU3ZoNjNxbncrVUN1SEFlUjZIdTdI?=
 =?utf-8?B?dlhCenUyOFhCVUtvWkV2YXhIZXhlbDFrR3RoVE1iSWd5QytRL09FeWpvclov?=
 =?utf-8?B?K29sL0JDcEhxd3FTUVI4ZkZwdFNwTXlKMWdPeDJjeE4vNkJLa2hwZzJ3NGpF?=
 =?utf-8?B?ZEh6TFFRbk9ULzNZZ2M2a2FGZFBuQUhCcHhrcCsvSUE2VEFFcFUzdU1raWpI?=
 =?utf-8?B?STNOOWQvZFRVM2FEdy9VWUNHU2xQdHlPMjFNVzQ1WEVFNk53MisvR05OblJ6?=
 =?utf-8?B?VXNjaVVZdzRCMk1Ed0l2N2s3SEF6dVo4QmxOZ1ZkRDhudndNTzQzckg3a1pZ?=
 =?utf-8?B?WVRBV3ZyNFQ2b3AzclVkaXFnWk93VFgzaVpjb1ZzVTQ5eUNZUEVtcDNpdG1w?=
 =?utf-8?B?QWRaYkowWkcrc1VwdVhtU2xyUHlYNUh5ZEs3dEdNQlF6NDZ0OWMxa0F4UFR0?=
 =?utf-8?B?QUZSRXRYM3dmaGgrdGFaYmM4b0xYWnBXV3JnVWY1OGl6Yy9Qa285Nnp5MnRG?=
 =?utf-8?B?ajBnMjFkL2N4djFrRXhBZUg5alhXUktqQXFZY0ZDeGdtbmhhZWNCaXZqZmtI?=
 =?utf-8?B?VHNqdFdONUJPYko1cTBPejhpTHA3Q2RHUmlMcm1ZYlVoOWFVRTd1Njl0U1o0?=
 =?utf-8?B?MSsrYXlXM1pWQkU3M2pBSlBkUldVZWJZZU5LTHZkZWQ2a3A5QWQ0bUVVUmRN?=
 =?utf-8?Q?McXbheOBp63UvI/SLXlgidsDP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ede13aee-46fe-4330-5fb2-08dad0eb9680
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 02:52:28.6921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lr8zDb1AGU1hiWaDKJRIAUZs+ClVuybdtAI0Dq/a7Y5YJkLtStCQXF3UMGPTF/yAUVIdv9zKCWUW6cSGQAIWmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3389
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBNaWNoYWVsIEtlbGxleSAoTElOVVgpIDxtaWtlbGxleUBtaWNyb3NvZnQuY29tPg0K
PiBTZW50OiBUaHVyc2RheSwgTm92ZW1iZXIgMTcsIDIwMjIgNjo1NiBQTQ0KPiBbLi4uXQ0KPiAN
Cj4gQnV0IEkgaGFkIG5vdCB0aG91Z2h0IGFib3V0IFREWC4gIEluIHRoZSBURFggY2FzZSwgaXQg
YXBwZWFycyB0aGF0DQo+IHNtZV9wb3N0cHJvY2Vzc19zdGFydHVwKCkgd2lsbCBub3QgZGVjcnlw
dCB0aGUgYnNzX2RlY3J5cHRlZCBzZWN0aW9uLg0KPiBUaGUgY29ycmVzcG9uZGluZyBtZW1fZW5j
cnlwdF9mcmVlX2RlY3J5cHRlZF9tZW0oKSBpcyBhIG5vLW9wIHVubGVzcw0KPiBDT05GSUdfQU1E
X01FTV9FTkNSWVBUIGlzIHNldC4gIEJ1dCBtYXliZSBpZiBzb21lb25lIGJ1aWxkcyBhDQo+IGtl
cm5lbCBpbWFnZSB0aGF0IHN1cHBvcnRzIGJvdGggVERYIGFuZCBBTUQgZW5jcnlwdGlvbiwgaXQg
Y291bGQgYnJlYWsNCj4gYXQgcnVudGltZSBvbiBhIFREWCBzeXN0ZW0uICBJIHdvdWxkIGFsc28g
bm90ZSB0aGF0IG9uIGEgVERYIHN5c3RlbQ0KPiB3aXRob3V0IENPTkZJR19BTURfTUVNX0VOQ1JZ
UFQsIHRoZSB1bnVzZWQgbWVtb3J5IGluIHRoZQ0KPiBic3NfZGVjcnlwdGVkIHNlY3Rpb24gbmV2
ZXIgZ2V0cyBmcmVlZC4NCg0KT24gYSBURFggc3lzdGVtICp3aXRoKiBDT05GSUdfQU1EX01FTV9F
TkNSWVBULCB0aGUgdW51c2VkIA0KbWVtb3J5IGluIHRoZSBic3NfZGVjcnlwdGVkIHNlY3Rpb24g
YWxzbyBuZXZlciBnZXRzIGZyZWVkIGR1ZSB0byB0aGUNCmJlbG93ICJyZXR1cm47Ig0KDQpJJ2Qg
c3VnZ2VzdCBhIEZpeGVzIHRhZyBzaG91bGQgYmUgYWRkZWQgdG8gbWFrZSBzdXJlIHRoZSBkaXN0
cm8gdmVuZG9ycw0Kbm90aWNlIHRoZSBwYXRjaCBhbmQgYmFja3BvcnQgaXQgOi0pDQoNCkJUVywg
SSBqdXN0IHBvc3RlZCBhIHNpbWlsYXIgcGF0Y2ggYXMgSSBkaWRuJ3Qgbm90aWNlIHRoaXMgcGF0
Y2guIEkgaGF2ZQ0KcmVwbGllZCB0byBteSBwYXRjaCBlbWFpbCwgYXNraW5nIHBlb3BsZSB0byBp
Z25vcmUgbXkgcGF0Y2guDQoNCkZpeGVzOiBiM2YwOTA3YzcxZTAgKCJ4ODYvbW06IEFkZCAuYnNz
Li5kZWNyeXB0ZWQgc2VjdGlvbiB0byBob2xkIHNoYXJlZCB2YXJpYWJsZXMiKQ0KDQp2b2lkIF9f
aW5pdCBtZW1fZW5jcnlwdF9mcmVlX2RlY3J5cHRlZF9tZW0odm9pZCkNCnsNCiAgICAgICAgdW5z
aWduZWQgbG9uZyB2YWRkciwgdmFkZHJfZW5kLCBucGFnZXM7DQogICAgICAgIGludCByOw0KDQog
ICAgICAgIHZhZGRyID0gKHVuc2lnbmVkIGxvbmcpX19zdGFydF9ic3NfZGVjcnlwdGVkX3VudXNl
ZDsNCiAgICAgICAgdmFkZHJfZW5kID0gKHVuc2lnbmVkIGxvbmcpX19lbmRfYnNzX2RlY3J5cHRl
ZDsNCiAgICAgICAgbnBhZ2VzID0gKHZhZGRyX2VuZCAtIHZhZGRyKSA+PiBQQUdFX1NISUZUOw0K
DQogICAgICAgIC8qDQogICAgICAgICAqIFRoZSB1bnVzZWQgbWVtb3J5IHJhbmdlIHdhcyBtYXBw
ZWQgZGVjcnlwdGVkLCBjaGFuZ2UgdGhlIGVuY3J5cHRpb24NCiAgICAgICAgICogYXR0cmlidXRl
IGZyb20gZGVjcnlwdGVkIHRvIGVuY3J5cHRlZCBiZWZvcmUgZnJlZWluZyBpdC4NCiAgICAgICAg
ICovDQogICAgICAgIGlmIChjY19wbGF0Zm9ybV9oYXMoQ0NfQVRUUl9NRU1fRU5DUllQVCkpIHsN
CiAgICAgICAgICAgICAgICByID0gc2V0X21lbW9yeV9lbmNyeXB0ZWQodmFkZHIsIG5wYWdlcyk7
DQogICAgICAgICAgICAgICAgaWYgKHIpIHsNCiAgICAgICAgICAgICAgICAgICAgICAgIHByX3dh
cm4oImZhaWxlZCB0byBmcmVlIHVudXNlZCBkZWNyeXB0ZWQgcGFnZXNcbiIpOw0KICAgICAgICAg
ICAgICAgICAgICAgICAgcmV0dXJuOw0KICAgICAgICAgICAgICAgIH0NCiAgICAgICAgfQ0KDQog
ICAgICAgIGZyZWVfaW5pdF9wYWdlcygidW51c2VkIGRlY3J5cHRlZCIsIHZhZGRyLCB2YWRkcl9l
bmQpOw0KfQ0KDQo=
