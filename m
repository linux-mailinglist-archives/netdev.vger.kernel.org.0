Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D070F62EC44
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 03:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240461AbiKRC7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 21:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbiKRC7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 21:59:52 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11021024.outbound.protection.outlook.com [52.101.52.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B04F73B90;
        Thu, 17 Nov 2022 18:59:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VB8L0N4SKnHxWj5RoChIVT7kaB6zdODZnaHYzBkBUNx85/KxaCLsI0eh7XeU5ckT5vCj5I16UmLWOIazGq0zyMOg/WuTjyv45Zkv/YVeGiQd6LGSNrBVyHcxu3+OftqGHMdi3sY8nymDepz1f6We4CQyhQD/ZFaxtMnudbdkdl1CI7xkZQxYkO9pTotzz7akhDJXlKX98AIoH/u0JELaIXpmkOsk+Dq2sBp4E4zfgezqowyVjdrDEjrAbwbPvRlMik61n3DJCT7QqHMDlRyuNMgx1+qekVIwMg6recLCdjZ0x9oaPc3OWDDtyj5khXJa2xmuojiliy3K0DMjBpv5mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xv4yzEFMO7rIqRY2DbFS0Br/aYY/OvZeogHuR0OGr/o=;
 b=SKpOoFRzFIKJ8BQpSfdC6dZYnw5nOuc0a59RQtcZl96q1cEQ3rbczOwvKU124sp89jw1z+SRhoXV0ZCqXSmH5ju/lvmXUCqAORQA4uFkgiQYH/P2tpDtI+HUMJG7htW6bRt85O7hH77zui0DsVE9/PzFONnfQ2aPRZNCwIs8LQ0SCzs5cUrw5wYfljdvAzhQHQHi47tjdpnz600jwn+1HMNaqTpLFVDdVC6JY/50v6AlE/LxtSDJe6s5dLFn6+D2Reyx3iFpdnI+Yk0bjPCUZYvg9iUlSc0AIfbEglXPixeXTupz9WWhowiHlef89WCBqxqAM8+XthWVfm0jQDEOVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xv4yzEFMO7rIqRY2DbFS0Br/aYY/OvZeogHuR0OGr/o=;
 b=AOw4NUUz6bugzvo/erhFxIr8OOuMRfiPFbxDCtON+h8LQ1jNgZ6kcJaLgKM9Zka+AadANG6VHODJEOFWLJHin2QGIaF08AngqetaeBjTF2LM8C0e7wF+88WvRt0c3G6z5e6Q3xcIW9QYJVZDtXXuTj4AXyzelNKvqfCBTAZ1oY4=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by CY5PR21MB3471.namprd21.prod.outlook.com (2603:10b6:930:c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Fri, 18 Nov
 2022 02:59:48 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%4]) with mapi id 15.20.5857.008; Fri, 18 Nov 2022
 02:59:48 +0000
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
Subject: RE: [Patch v3 05/14] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Thread-Topic: [Patch v3 05/14] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Thread-Index: AQHY+esxZzvGjSwYNUG8Av9Zi67yOq5CAh6AgAALRwCAAfH/8A==
Date:   Fri, 18 Nov 2022 02:59:48 +0000
Message-ID: <BYAPR21MB16886DA6333D33A9B2D5CBE0D7099@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
 <4d27540e-691e-bd86-0f70-1faff39f7187@amd.com>
 <8c9554a7-7569-ec5b-8da4-6f169d3fefda@amd.com>
In-Reply-To: <8c9554a7-7569-ec5b-8da4-6f169d3fefda@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=56f92c23-9333-44c0-953d-715e4e097cdb;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-18T02:58:20Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|CY5PR21MB3471:EE_
x-ms-office365-filtering-correlation-id: f6f5c633-59ba-43b2-ee05-08dac910f44a
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PBJgoSLRChmfunsNUldJqhjTRU+LI2PN5VjJ0Tf80eNCcrpHftLieMtO06PhYuIs5Iu41TKYy0q1SkOOtk09K56rUjHe+S/SvwicfpGcYlQOezyYthkoGlNkKslWoeyRIzLfif9w+xywaEUL36C1BCZNqmceVOiWh/MRDq0iQGqw8QSqoQwJvL6FgQL6FeK62W0gEJVT4LsPAm5OGmVevvYXXaFvMFO/5v4Nq7ovzpjEEeVdqqM0bMLlj9wQnyVCQ3E9Q70pnA5y/R8T1MnJh+ZtYVKCIVbiIuCR82UMRMkLVzw1YcRslUEWy9QxC5DJQlyMVebQD7Dhlzz3DZSJqOpo3dS1ejsJ1jIeDNsJ6mnTAaewQgg7tsCzXaDFjzYsdsfPTAUcrOg+nC+4wxUUUG3RM2ty5pjeatWjNb3+0AY8KdjoTRi/ClG8yLlkLr6+U8PIeF42j2bvBalA/ofN6VcwZv5I3hRGIfEk46QXbg8FbYOzu2u1Xz3lMeSB+XKWkd1Novr4EYOE5GAg0hwfyikMGv3sAoeHjdCw4/Knn1vHpy3q6F01nPM7IfUrLtAVfOTbBL9QuGfN4YsbzQiKePTkwvO5vvRznlcMGd8YXozAyPwACzNK22TZbxMOZEks/asJ7h+4bAcSBB0T/vD1K/y9ykfrcgyaDnth9tln+EAkQRnOy1jO+HKuAKCtO3C47r035qGGn1xIM4AS7S/pRDmWp7tXq+GAwACqJpwqjh/aVBEyo8faW3f5RpOGDFKla9+XtkK9kTknBhZFUJDnqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199015)(10290500003)(478600001)(71200400001)(41300700001)(66556008)(52536014)(64756008)(66446008)(8676002)(66946007)(83380400001)(76116006)(66476007)(8936002)(5660300002)(186003)(7416002)(33656002)(7406005)(7696005)(316002)(110136005)(9686003)(53546011)(6506007)(26005)(82960400001)(82950400001)(86362001)(8990500004)(2906002)(55016003)(921005)(38070700005)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWZSV0U2SEZlTkVCbWFOVG1ERDd3clZlbkhPVXphK0tuYm0vSnhCeWZvZzNR?=
 =?utf-8?B?Vkc1Mk9mUXFIM3YzK2d6M0Fuc2Zudkd3SW5VcnhNWnphZURGQ1E1Q3FoWjFl?=
 =?utf-8?B?U1l5UDAyWkx1eGFsQUNNVGJLMU9iaTB1cHBNeE5QNTRQb3hac0xnTEJ4TXJT?=
 =?utf-8?B?Y0ZUWlBCb3dSUEdqdjRYem5McXlFK0NadmRPNXV4NmwyZTBwcWw5VkNiZGN0?=
 =?utf-8?B?L2d5eDhQM29WVkNOUjB6YXVXRnQxb0oyVlovcjl6d0ZHa004Qit0cW1BOUx5?=
 =?utf-8?B?UTYzTC9JbTVlbG9aV0FCTWpWWW4rM2ZkMmVGU0cvOGsxWDBiODBMYkRYRyty?=
 =?utf-8?B?OHJ1Z1JMUjFQMEM4VFJXSXBsTExNTXdiYkFCZkxHZVdLR2RZT0x3ZjMxa2p0?=
 =?utf-8?B?UTNCZ21WbXhuNXlhV2wwZTVOaFZKMkJpWVRIcFJucEdqVTIzcHFXK0VIRVgx?=
 =?utf-8?B?NHdMMEtkNWZ4VVdwS0twUUJmQ0NIQmhrVTRCaThQSHNPSWd3VnphWXRxd0t5?=
 =?utf-8?B?YlhuS3hPa3Y2ME1sREJGeHFBYS94UUlXOTJCUERYNUxRM1J6a0FndzE0RkEy?=
 =?utf-8?B?WFl0N3lpaTZydTBUaXhEZDZXTlRLcnJhZ1lIMm5GSUFBRUFudXcvVlphY29J?=
 =?utf-8?B?cHdPeGhKTHNRNXlJTDhtangvSWUrMk83ZWtNejU3ZytCR2gwelJEL1RwZys1?=
 =?utf-8?B?Y29qOFI3L0ZzNG13V016NUtJU3d2c2NuN09HLzNJUWxhRmlodS9PelRWb0t2?=
 =?utf-8?B?di81NWJnWnNhOE9ZL3Y2OXlMSzNxNzBlanV1czFIN2pqaUgybm1lcW1abVpU?=
 =?utf-8?B?V3hPSTY5WDRZRVBjQXRabHdmQzJ3WVY5bm5xSFRMazBmaGROUDB6d3NrUlpG?=
 =?utf-8?B?MUFWUEx6WTJaYmtFOUVWNllZVHJVeFhYZFNWUW5TR3ZkcUpLOHNLbUk1aVRI?=
 =?utf-8?B?K1F1TmJjMmtSMW92Ui9pdFJFS0U3a3dJWHEwajRQbmQ2LzZZL0VWMC85TkxT?=
 =?utf-8?B?Qjl0REJnTXgzSCt0RFpyVnM2MDBGcTEwL3VRd2Via1IwSHRIUStYQlVNekc2?=
 =?utf-8?B?RTlONGdyc05PcXFpRFoyNm9jQXJaOSt5d2piUkFBSEpWOVVLYzhzRVhTaFR5?=
 =?utf-8?B?K3B4LzB6cm5sKzc5YW9BMW83b1NQanFUODFoYU5KS0xicUxIMzJiQ2NsbUNj?=
 =?utf-8?B?R01qWFBDVEp0R29zNHJ1ZHkyeFROQ3o2a1JKSzBHT1h3d1ZHb0VMWmRlS3Fu?=
 =?utf-8?B?MlRlaXEyTHJSWE5naDh3VWpUOGtTcmo4ZmRqaXY4T3pwR291Mkw5a25SUXpB?=
 =?utf-8?B?MGxwT2x3NmhNaUpHUDUva25xMWc0R3E0dm1Eck51VUJqSURFVjUwRFZ1Tk83?=
 =?utf-8?B?WEhQa3MxeGE1TXZQNzdzdmtvQko1NHZjUU41QTJHWUV5SDVzTU9sRVA2L1J1?=
 =?utf-8?B?dWxMMjZ5cWV3cnkyZHY4ZDlCeDBBaVh3WnJiMlRuUWFiM2hDNUhmQis2S2dx?=
 =?utf-8?B?QUZLdUhNYVI3RWxFVXlFRDBwRnFhSjNRTVdzN2RFR2ZsOWpFVmJJRndoNFZ1?=
 =?utf-8?B?OGxySXZZdXozWVAvSzZ3c21XTERzNjJwb2krSmUvU3FnNkkreXZjWnJpUGNy?=
 =?utf-8?B?NHBVK3lLQWFaV2RPQjF5dVNBVjl2SUtTbXdYWUpIMmJsNllvdEovbEVVK1hQ?=
 =?utf-8?B?cnUwZlNBN0t4b2lCejRtcStzWVB6Nlo3bHg2V0E0bXZxNDZHQTdZOEloZ0tM?=
 =?utf-8?B?NEwvWTl3dGtaSi9NVDQ3cWNJWWF0Z3VPL0JFemhZVlRzQTNmZVNDaE5GdjJw?=
 =?utf-8?B?U3c0eW5MaXN3am9tQ1I5RFhMejRjdHExNjZ5cURPMDJXdC9RRlJTU3ZlMmRq?=
 =?utf-8?B?WmNwUXF0ZmxlVFNMSE9xektya0tGQk41Q2lobzlZdlhaMmZKUjJsWCtablhC?=
 =?utf-8?B?aXd3aGYxSjdpSFBVUk9CbnRFUnY0OWdMeDh0M0lvNlhEOFdUL2QrM200N2s3?=
 =?utf-8?B?TnRydGROUXQzQWNCcHdNWEk0ZGtzcGQ0aW40WFVTOC9SaDl1RzJqbXFpeGFq?=
 =?utf-8?B?SG9MVkcrR25Qb0JFZ3IxTFREU0ZBc3RzNVEvQ3p1b1g1WHB1a1BabnBDaWJr?=
 =?utf-8?B?ZXJiM2dESFFmZnF1cTltTHlmNk10M1Bya2ZseU83M1ZNaW8rV2xIWjBUdGgw?=
 =?utf-8?B?bEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6f5c633-59ba-43b2-ee05-08dac910f44a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 02:59:48.1245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FwwN6QOIrh3GNTWDav39ZMFwoi6nXo0JCnB5JS+NQx7sE5y6xf2IikWwnVWgpRTUgPxmQpWGENqQnv5RImf3C5pe3S5BJX0bUYqaRS98GJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR21MB3471
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1kLmNvbT4gU2VudDogV2VkbmVz
ZGF5LCBOb3ZlbWJlciAxNiwgMjAyMiAxOjE2IFBNDQo+IA0KPiBPbiAxMS8xNi8yMiAxNDozNSwg
VG9tIExlbmRhY2t5IHdyb3RlOg0KPiA+IE9uIDExLzE2LzIyIDEyOjQxLCBNaWNoYWVsIEtlbGxl
eSB3cm90ZToNCj4gPj4gQ3VycmVudCBjb2RlIGluIHNtZV9wb3N0cHJvY2Vzc19zdGFydHVwKCkg
ZGVjcnlwdHMgdGhlIGJzc19kZWNyeXB0ZWQNCj4gPj4gc2VjdGlvbiB3aGVuIHNtZV9tZV9tYXNr
IGlzIG5vbi16ZXJvLsKgIEJ1dCBjb2RlIGluDQo+ID4+IG1lbV9lbmNyeXB0X2ZyZWVfZGVjcnl0
cGVkX21lbSgpIHJlLWVuY3J5cHRzIHRoZSB1bnVzZWQgcG9ydGlvbiBiYXNlZA0KPiA+PiBvbiBD
Q19BVFRSX01FTV9FTkNSWVBULsKgIEluIGEgSHlwZXItViBndWVzdCBWTSB1c2luZyB2VE9NLCB0
aGVzZQ0KPiA+PiBjb25kaXRpb25zIGFyZSBub3QgZXF1aXZhbGVudCBhcyBzbWVfbWVfbWFzayBp
cyBhbHdheXMgemVybyB3aGVuDQo+ID4+IHVzaW5nIHZUT00uwqAgQ29uc2VxdWVudGx5LCBtZW1f
ZW5jcnlwdF9mcmVlX2RlY3J5cHRlZF9tZW0oKSBhdHRlbXB0cw0KPiA+PiB0byByZS1lbmNyeXB0
IG1lbW9yeSB0aGF0IHdhcyBuZXZlciBkZWNyeXB0ZWQuDQo+ID4+DQo+ID4+IEZpeCB0aGlzIGlu
IG1lbV9lbmNyeXB0X2ZyZWVfZGVjcnlwdGVkX21lbSgpIGJ5IGNvbmRpdGlvbmluZyB0aGUNCj4g
Pj4gcmUtZW5jcnlwdGlvbiBvbiB0aGUgc2FtZSB0ZXN0IGZvciBub24temVybyBzbWVfbWVfbWFz
ay7CoCBIeXBlci1WDQo+ID4+IGd1ZXN0cyB1c2luZyB2VE9NIGRvbid0IG5lZWQgdGhlIGJzc19k
ZWNyeXB0ZWQgc2VjdGlvbiB0byBiZQ0KPiA+PiBkZWNyeXB0ZWQsIHNvIHNraXBwaW5nIHRoZSBk
ZWNyeXB0aW9uL3JlLWVuY3J5cHRpb24gZG9lc24ndCBjYXVzZQ0KPiA+PiBhIHByb2JsZW0uDQo+
ID4+DQo+ID4+IFNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgS2VsbGV5IDxtaWtlbGxleUBtaWNyb3Nv
ZnQuY29tPg0KPiANCj4gTWVhbnQgdG8gYWRkIHRoaXMgaW4gdGhlIHByZXZpb3VzIHJlcGx5Li4u
DQo+IA0KPiBXaXRoIHRoZSBjaGFuZ2UgdG8gdXNlIHNtZV9tZV9tYXNrIGRpcmVjdGx5DQo+IA0K
PiBSZXZpZXdlZC1ieTogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1kLmNvbT4NCj4g
DQoNClRoYW5rcyBmb3IgdGhlIHJldmlld3MuICBBbmQgSSBzZWUgeW91ciBwb2ludCBhYm91dCBz
bWVfbWVfbWFzay4gIEkgaGFkDQpub3QgcHJldmlvdXNseSBub3RpY2VkIHRoYXQgaXQgaXMgZGVm
aW5lZCBpbiB0aGUgbW9kdWxlLCBzbyBubyBuZWVkIHRvIHVzZQ0KYSBnZXR0ZXIgZnVuY3Rpb24u
DQoNCk1pY2hhZWwNCg==
