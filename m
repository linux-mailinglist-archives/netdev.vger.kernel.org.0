Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2051F67C602
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 09:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbjAZIjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 03:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236437AbjAZIip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 03:38:45 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0466AF53
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 00:38:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUm7LK/0CoM3ExJt77f1vk8ojaonROUjC3BGAq0ITRC3SL13h4xbKy+27v7CGQtB4BTTpkzZ0H8Fn+s9Y1Ze7mgcIU2m7SpyRERGQrZ8d66t7nAhOTS4IlISCSaZWiuFjDqt9hH4Ge5zPxMhp08gUh3nS1n23SQdYHq0Sfqs3vXj9jnwpKF6MOycXP6MHmOIPCrZVmlD48q4NOn0clOtRAU6e2sDe5Sjd8ho+Z9fCy0knVXASouYmkjyiYcSuu0igaJn2GPEi5etiO4ANyrO2F437W2BOOcXC8jUJSt9Jlpg9C8IPKfk5nmLpxexEkLidhIB4nN5bOL1zQhEHZ/vww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MnaLOysMxHOOZyIQTTKx1iendR/tHA0KvioVWZA+z+o=;
 b=YbVN2JtGOLhr09ntJ+VXDxGOA5xKkD+cz9GA4f1bUzDUJTSCRc6C/ILEBRCoWb85cMwgEjFj8+nRVbCw4yxICqGsuRlPVzgTuw4KG2h0Fp5wteECYa2YlWDFpI2/2HNc9iEFCotiviwwuj/WBCA01w7O/FDTuqRS8k4b3IBAhXLkOKuEY4BGhTWb9qBxcq1S0p162D82TXUTSyY9J4f/pqA9NZoa4c9gVrNCmi2QuzpfuUo0QsJSZNp3mDNxl5EajiHvfazbEOv671LHbNvt2Udrbagu1INcv4ZQdrPnN9hl/Kn8uHi/N3q6EP1gV1VNTl7JvvcOCaepTDddrKgnMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnaLOysMxHOOZyIQTTKx1iendR/tHA0KvioVWZA+z+o=;
 b=n8fESZtzYUsx7eal9hSAhw8rzXrby3Fp+5IyK2lmFPJhVD4OfNfcqxudqlHUxdH3Xmk5IrX2voGhGdF2jqHSGeinctMOgHtzB6aYYpsDAEKDW9aYd97mgSfNeJAEG/RT1G3fy5uHoIOkbNSYqllPaQKZK3JlBFXOg17kQo1mdy//kOpifzalE1vrp8FY1dmtp72UeuVcZgd+4v4bUB/BJNa5PY6zfk466OFOfadGjYqWMhieWgm/ERyPwzn/tHwOyqwXbxgo91cGp91uZ1aFAxeLOULPXTnYDt4rcKRW6x70DgvRDMf7EAJhzJ/3FotHjC8PM7/PTkikEmJrOK5rIA==
Received: from BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6)
 by DS0PR12MB6414.namprd12.prod.outlook.com (2603:10b6:8:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 08:34:57 +0000
Received: from BL1PR12MB5286.namprd12.prod.outlook.com
 ([fe80::db3c:8645:45d9:50c5]) by BL1PR12MB5286.namprd12.prod.outlook.com
 ([fe80::db3c:8645:45d9:50c5%8]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 08:34:57 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Sabrina Dubroca <sd@queasysnail.net>
CC:     Dave Watson <davejwatson@fb.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: Setting TLS_RX and TLS_TX crypto info more than once?
Thread-Topic: Setting TLS_RX and TLS_TX crypto info more than once?
Thread-Index: AQHZMB7YC7z42CILq0e4LpqRgbiPR66uJm6AgADHsQCAAXPNAA==
Date:   Thu, 26 Jan 2023 08:34:57 +0000
Message-ID: <b4fafaaf-2012-cf54-c614-84a6fd2467b7@nvidia.com>
References: <A07B819E-A406-457A-B7DB-8926DCEBADCD@holtmann.org>
 <Y9Bbz60sAwkmrsrt@hog> <77DB4DFF-0950-47D4-A6A1-56F6D7142B19@holtmann.org>
In-Reply-To: <77DB4DFF-0950-47D4-A6A1-56F6D7142B19@holtmann.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5286:EE_|DS0PR12MB6414:EE_
x-ms-office365-filtering-correlation-id: 7657a2b3-0176-4bf5-1f92-08daff7834d2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cPEciPdSulYGijef5HhZODCDdS59lZIZGwN3W/PiGgeUMqgN15YM5kijs5qz7Lpcshz6zmsECXsViFgAaCdyMAd37yL5aLFZ70PsgLLF6sWcH5gkrLf9wCl02qdEWfZGLMoxM33O14FNL561OwohbjGgxoVcljpFWbhZeki0755L41Fbs3VF9JK4CCvTOicJjigbEp+lfxKn7HUtmad5VPOcIDA/kKKugNJgTWz464SnUKbeP7aWfQtVMMF/8AsON6+UX17gmB+pIa2t6AJYOeoUt3tA658nGJraOsrzaAl1HhF2bMWlmxxtH9EGC+saXH/Iu4B6bLeFwf04lq92EF9rpX22azkLkJ5w8EiDLLG16OcAKOiF//SdGNiM0mNWM/7ODUtof4fNY2raE9CY5bV5GTiNe2Mnr+r6DPqwkLom1p3vXVcdeGdgDMyLi7mkBkU6MyZiPy2nOeCAQFLjIvu5jf3ZYkgzPabx5xRHDf0ph2nZ7sQgdEluHWn94oOhX5OufdXt3jCNaQqbSnkfFWF3UogC1XXcMFXmjwIiGCaYn/RHVn+Xrhil0j2Oo0ddd+Bi2YtoOQ0erbszRIBpIy10o0n2B+dc/MDvgDJMCL+gUQX/OFSKZdJrLiJOK02h2p20YwGEArASGoDoVWLbAn/C/Ne1bUH9jJT6n6TQq8ku+Qz2018eihO3iDG9P2SWvh7BsP0SOT8iec6OyCNBirAuKQsAV5hhF5P3V+QHO2qf04rbLzK+cFaAV6b8S08MxuUw6+7g3WjBXAondTooEQPA+HpWNrpH9+Edcc4xU7X8Og10IXbqjZSzTDd/OWHKI92r6Lya4hnvJyNI0dMpH2gRt1YsmkscdTqZIYk+258=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5286.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199018)(2616005)(5660300002)(31696002)(66946007)(122000001)(76116006)(8936002)(71200400001)(64756008)(38100700002)(186003)(53546011)(54906003)(38070700005)(6506007)(26005)(6512007)(8676002)(478600001)(6486002)(31686004)(966005)(2906002)(91956017)(41300700001)(4326008)(66446008)(316002)(83380400001)(86362001)(36756003)(66556008)(66476007)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmRmYW1IVDBSM1l0aHlHZEttK1lRZlpINU5IbVNYYVdDS28rSU8yWk02NlMz?=
 =?utf-8?B?UVhYTFUwQk5SS1EyLzY4aml1aE90azlGdm1yQWFLU0p6WWc2T3R6QzhzZU92?=
 =?utf-8?B?blZ6VGhJa3pUb0h4MktUODFubmV1THEySER1eXMrbGpyLzV4WGM2MUtBbm53?=
 =?utf-8?B?bFNCVjZiQVlZYWNtcWNxYmY2M1lCV05pL3paYjJyREo1UkFLaDN5Ti9HRjdF?=
 =?utf-8?B?WklOOVBmbkUwSlJPUCttSHJ3TG9ES3FxeGI4RDlYcE1rTHhpMTBKU0gvT2dz?=
 =?utf-8?B?Zk5WQ1krL205M1FaZCswVHZCQWdMbFZYbjdiTmtwOHliRks2bnNZckQrUno4?=
 =?utf-8?B?a2JvTzFOYUpvck9QcVJIRHFkcXBTbExBNjhaWDlwbXQzKzZhR0o4dlBuMHZK?=
 =?utf-8?B?RmVnOTJUVFgxbkhTWDRMYVZFY1lDRWlwQ1BhanBiSVg1RmR1VVRiWG9JTUd0?=
 =?utf-8?B?SG9sQlFZaWxqSnYxNTBudFBKYW54dHhEM2RBMlJtZ1dyYTRhSkJZTjVsa0dz?=
 =?utf-8?B?eDE3d3hPSnRyemJKbm1pdE04Y081cnYvNXBPM21zUTlSSVdIcHVnREh3WGEy?=
 =?utf-8?B?UWZKajJOZW9KTEcycFVvbXNlWjB0R1ZaakZSV09zWG1iTkliM3BoNVYvbXU1?=
 =?utf-8?B?NEdMY043QStxQkdKRE5OalFPZ2pZVEF6Ykp3akdrYTBFeU05ZVFMWWVJRmkw?=
 =?utf-8?B?dEVWUmxlYVNsOG9tamJSZG5zbWkrOEg0WmJITnNBcUpJWXhvSlJ2UXRYWjVx?=
 =?utf-8?B?U2hJZU85R2RtbjhJNlZtZGtqMEZ1clFVd3h4QytYTWcrRzRwR1dLQVpCRlVN?=
 =?utf-8?B?M0FvMUYrTVdaakR2alRGMkhxeXROYmQ3RDQvWE91cHdDSXhDYkdSTXYzR0RO?=
 =?utf-8?B?QVpEUUtBRWFnYjFKakpYZzk1QTY0dE9sNmw5TTR3VVBvbEh1NnZ1SnBaVkRQ?=
 =?utf-8?B?U1hreEZhdUxxbzkvOXhMOGx5MnJVK3REWGg3Lzc0QlhjZXhhUWdLelV0ZkFp?=
 =?utf-8?B?UGpKcUV4eTZnSUh6UWRjRURzWW5ucFJXaTFudGozb1F4VStvTVMrQ2VFWi9U?=
 =?utf-8?B?Qlh2NUZOYkpGNERCdG8vWWlLVDVOc3h0K2dsMzd1Q2pPb09Rc2Uvak4zZFh2?=
 =?utf-8?B?TnJCN2ErOVZZdVljQndpZ3NYWEVkbkRoTTVLU3haMm9tN2tZVUp6VTdOdWR3?=
 =?utf-8?B?L05jM1hTekRJUTYwYzJEdWFVMDNNZDF2a3E1c1NGTXU4UU5jdDhQbkhYMUVV?=
 =?utf-8?B?cEZmRUNSNUNWallTbkFJTGs2YUhnZWFZcXhaS1JEYndKNUU1NU9aNEVPekxx?=
 =?utf-8?B?RWp4OXdmU3V1OFpRQnErRU9wbVM4YkI4bi85WmJvWmFXbVZ3Ylh0cFphK2t3?=
 =?utf-8?B?bmRieXJGV1Z3dzBISmswV1FGeG9xOTMzSU1KaUJCKzlJeFA4UTVXdmlwMGZD?=
 =?utf-8?B?UTdhS0RzTUpwckxZN0RYbnM0OFdVbjA3ODhFMWFlZWlJbGVvS2U4SU15MGtv?=
 =?utf-8?B?K2FiTFo3bSthbWJBUlh2cU5mOG4wdjdpMTE1OXhvdlQyQWJKQkdnaXFtTE9r?=
 =?utf-8?B?YzVhZlRqSUQwQTN2UWdiUzZ6RHI2bnk0R1BLUGdWVTdJUlVEL1k5bFZDOHY1?=
 =?utf-8?B?QWFBZmRMZGhaM2htRmtqdUNSRzRPNllmbDZyTXYxQjk0NjY1U3cvbDhTWHNq?=
 =?utf-8?B?NkFLZDV1ZGNqYmZCL1lzdnB4dW50R1hlQWl3VkJQTVhNa1BFYU9kUXhLZlZj?=
 =?utf-8?B?Z1M5Tnh6cnFvR0M5QTlrV0Z2dXYreVp5aDVzM1g5OTJka0M5elMyWG1PWmdh?=
 =?utf-8?B?Rm1VN2MzVVlaU3ZVTEVndWIzQkxya2puU2dHMWdwRElmR2d1ZU5ZaUNZN2hm?=
 =?utf-8?B?eXdOVHlwc2V5Nmx5TDhsWkhCU2NqVG5TK1BUSmxTcEp1YnJqdmN6MFAyeDQy?=
 =?utf-8?B?NERxKy9obFhyRGNoZHRaVGJkTVc4TG5kZmdUN3NYeVJCTkVEd0F6UHhLYVhu?=
 =?utf-8?B?ZjlYbU5vdWpJM1dKQWsyQ3NURkM3ZUYzU0lCR0lZVUpVVWduc1FLVkV2Q2I1?=
 =?utf-8?B?OUhrc2Z0ZWx2OTB4NDIzK2dlNXBIeURmRFJvM3M1aUJBWjdmSGUyTS81V3BX?=
 =?utf-8?Q?PB/PRthoF1fE5ID6jdeLpVtfB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B672056244162C4083B497F00B1AC7AA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5286.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7657a2b3-0176-4bf5-1f92-08daff7834d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 08:34:57.3378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8y8McsqLKFNQgG4NxmDKRpY9xFbxA2zOOtIExNIc4b7lrWGpYftiFtml3ICYdoN6qEVAsgdcO3k4WYUsQgHMrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6414
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjUvMDEvMjAyMyAxMToyNCwgTWFyY2VsIEhvbHRtYW5uIHdyb3RlOg0KPiBIaSBTYWJyaW5h
LA0KPiANCj4+PiBpbiBjb21taXQgMTk2YzMxYjRiNTQ0NyB5b3UgbGltaXRlZCBzZXRzb2Nrb3B0
IGZvciBUTFNfUlggYW5kIFRMU19UWA0KPj4+IGNyeXB0byBpbmZvIHRvIGp1c3Qgb25lIHRpbWUu
DQo+Pg0KPj4gTG9va2luZyBhdCBjb21taXQgMTk2YzMxYjRiNTQ0NywgdGhhdCBjaGVjayB3YXMg
YWxyZWFkeSB0aGVyZSwgaXQgb25seQ0KPj4gZ290IG1vdmVkLg0KPiANCj4gSSBzdGlsbCB0aGlu
ayB0aGF0IGNoZWNrIGlzIG5vdCBuZWVkZWQuIFdlIHNob3VsZCBnZXQgcmlkIG9mIGl0IGZvcg0K
PiBUTFMgMS4yIGFuZCBUTFMgMS4zLg0KPiANCj4gKGFuZCBJbHlhIHNlZW1zIHRvIGhhdmUgbGVm
dCBNZWxsYW5veC9uVmlkaWEgYW55d2F5KQ0KPiANCj4+PiArICAgICAgIGNyeXB0b19pbmZvID0g
JmN0eC0+Y3J5cHRvX3NlbmQ7DQo+Pj4gKyAgICAgICAvKiBDdXJyZW50bHkgd2UgZG9uJ3Qgc3Vw
cG9ydCBzZXQgY3J5cHRvIGluZm8gbW9yZSB0aGFuIG9uZSB0aW1lICovDQo+Pj4gKyAgICAgICBp
ZiAoVExTX0NSWVBUT19JTkZPX1JFQURZKGNyeXB0b19pbmZvKSkNCj4+PiArICAgICAgICAgICAg
ICAgZ290byBvdXQ7DQo+Pj4NCj4+PiBUaGlzIGlzIGEgYml0IHVuZm9ydHVuYXRlIGZvciBUTFMg
MS4zIHdoZXJlIHRoZSBtYWpvcml0eSBvZiB0aGUgVExTDQo+Pj4gaGFuZHNoYWtlIGlzIGFjdHVh
bGx5IGVuY3J5cHRlZCB3aXRoIGhhbmRzaGFrZSB0cmFmZmljIHNlY3JldHMgYW5kDQo+Pj4gb25s
eSBhZnRlciBhIHN1Y2Nlc3NmdWwgaGFuZHNoYWtlLCB0aGUgYXBwbGljYXRpb24gdHJhZmZpYyBz
ZWNyZXRzDQo+Pj4gYXJlIGFwcGxpZWQuDQo+Pj4NCj4+PiBJIGFtIGhpdHRpbmcgdGhpcyBpc3N1
ZSBzaW5jZSBJIGFtIGp1c3Qgc2VuZGluZyBDbGllbnRIZWxsbyBhbmQgb25seQ0KPj4+IHJlYWRp
bmcgU2VydmVySGVsbG8gYW5kIHRoZW4gc3dpdGNoaW5nIG9uIFRMU19SWCByaWdodCBhd2F5IHRv
IHJlY2VpdmUNCj4+PiB0aGUgcmVzdCBvZiB0aGUgaGFuZHNoYWtlIHZpYSBUTFNfR0VUX1JFQ09S
RF9UWVBFLiBUaGlzIHdvcmtzIHByZXR0eQ0KPj4+IG5pY2VseSBpbiBteSBjb2RlLg0KDQpUaGF0
J3MgcXVpdGUgY29vbCENCg0KPj4+DQo+Pj4gU2luY2UgdGhpcyBsaW1pdGF0aW9uIHdhc27igJl0
IHRoZXJlIGluIHRoZSBmaXJzdCBwbGFjZSwgY2FuIHdlIGdldCBpdA0KPj4+IHJlbW92ZWQgYWdh
aW4gYW5kIGFsbG93IHNldHRpbmcgdGhlIGNyeXB0byBpbmZvIG1vcmUgdGhhbiBvbmNlPyBBdA0K
Pj4+IGxlYXN0IHVwZGF0aW5nIHRoZSBrZXkgbWF0ZXJpYWwgKHRoZSBjaXBoZXIgb2J2aW91c2x5
IGhhcyB0byBtYXRjaCkuDQo+Pj4NCj4+PiBJIHRoaW5rIHRoaXMgaXMgYWxzbyBuZWVkZWQgd2hl
biBoYXZpbmcgdG8gZG8gYW55IHJlLWtleWluZyBzaW5jZSBJDQo+Pj4gaGF2ZSBzZWVuIHBhdGNo
ZXMgZm9yIHRoYXQsIGJ1dCBpdCBzZWVtcyB0aGV5IG5ldmVyIGdvdCBhcHBsaWVkLg0KPj4NCj4+
IFRoZSBwYXRjaGVzIGFyZSBzdGlsbCB1bmRlciBkaXNjdXNzaW9uIChJIG9ubHkgcG9zdGVkIHRo
ZW0gYSB3ZWVrIGFnbw0KPj4gc28gIm5ldmVyIGdvdCBhcHBsaWVkIiBzZWVtcyBhIGJpdCBoYXJz
aCk6DQo+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvY292ZXIuMTY3Mzk1MjI2OC5naXQu
c2RAcXVlYXN5c25haWwubmV0L1QvI3UNCj4gDQo+IE15IGJhZCwgSSBraW5kYSByZW1lbWJlcmVk
IHRoZXkgYXJlIGZyb20gZW5kIG9mIDIwMjAuIEFueXdheSwgZm9sbG93aW5nDQo+IHRoYXQgdGhy
ZWFkLCBJIHNlZSB5b3UgZml4ZWQgbXkgcHJvYmxlbSBhbHJlYWR5Lg0KPiANCj4gVGhlIGVuY3J5
cHRlZCBoYW5kc2hha2UgcG9ydGlvbiBpcyBhY3R1YWxseSBzaW1wbGUgc2luY2UgaXQgZGVmaW5l
cw0KPiByZWFsbHkgY2xlYXIgYm91bmRhcmllcyBmb3IgdGhlIGhhbmRzaGFrZSB0cmFmZmljIHNl
Y3JldC4gVGhlIGRlcGxveWVkDQo+IHNlcnZlcnMgYXJlIGEgYml0IG9wdGltaXN0aWMgc2luY2Ug
dGhleSBzZW5kIHlvdSBhbiB1bmVuY3J5cHRlZA0KPiBTZXJ2ZXJIZWxsbyBmb2xsb3dlZCByaWdo
dCBhd2F5IGJ5IHRoZSByZXN0IG9mIHRoZSBoYW5kc2hha2UgbWVzc2FnZXMNCj4gZnVsbHkgZW5j
cnlwdGVkLiBJIHdhcyBzdXJwcmlzZWQgSSBjYW4gTVNHX1BFRUsgYXQgdGhlIFRMUyByZWNvcmQN
Cj4gaGVhZGVyIGFuZCB0aGVuIGp1c3QgcmVhZCBuIGJ5dGVzIG9mIGp1c3QgdGhlIFNlcnZlckhl
bGxvIGxlYXZpbmcNCj4gZXZlcnl0aGluZyBlbHNlIGluIHRoZSByZWNlaXZlIGJ1ZmZlciB0byBi
ZSBhdXRvbWF0aWNhbGx5IGRlY3J5cHRlZA0KPiBvbmNlIEkgc2V0IHRoZSBrZXlzLiBUaGlzIGFs
bG93cyBmb3IganVzdCBoYXZpbmcgdGhlIFRMUyBoYW5kc2hha2UNCj4gaW1wbGVtZW50ZWQgaW4g
dXNlcnNwYWNlLg0KPiANCj4gSXQgaXMgYSBsaXR0bGUgYml0IHVuZm9ydHVuYXRlIHRoYXQgd2l0
aCB0aGUgc3VwcG9ydCBmb3IgVExTIDEuMywgdGhlDQo+IG9sZCB0bHMxMl8gc3RydWN0dXJlcyBm
b3IgcHJvdmlkaW5nIHRoZSBjcnlwdG8gaW5mbyBoYXZlIGJlZW4gdXNlZC4gSQ0KPiB3b3VsZCBo
YXZlIGFyZ3VlZCBmb3IgcHJvdmlkaW5nIHRoZSB0cmFmZmljX3NlY3JldCBpbnRvIHRoZSBrZXJu
ZWwgYW5kDQo+IHRoZW4gdGhlIGtlcm5lbCBjb3VsZCBoYXZlIGVhc2lseSBkZXJpdmVkIGtleStp
diBieSBpdHNlbGYuIEFuZCB3aXRoDQo+IHRoYXQgaXQgY291bGQgaGF2ZSBkb25lIHRoZSBLZXlV
cGRhdGUgaXRzZWxmIGFzIHdlbGwuDQoNCldlbGwsIHdlIGNhbiBhbHdheXMgYWRkIGEgdjIgaWYg
dGhlIHVzZS1jYXNlIG1ha2VzIHNlbnNlLiBUaGVyZSB3YXMgbm8NClRMUyAxLjMgd2hlbiB3ZSB1
cHN0cmVhbWVkIHRoaXMsIGFuZCBJIHRoaW5rIHRoYXQgdGhlIGFib3ZlIHdvdWxkbid0DQp3b3Jr
IGZvciBUTFMxLjIsIHJpZ2h0Pw0KSGF2aW5nIHRoZSBrZXJuZWwgcGVyZm9ybSBrZXkgZGVyaXZh
dGlvbiBzb3VuZHMgbmljZSwgYW5kIGl0IG1heSBoZWxwDQp0aGUgVExTX0RFVklDRSByZWtleSBk
ZXNpZ24gSSBtZW50aW9uZWQgb24gYW5vdGhlciB0aHJlYWQuDQoNCj4gDQo+IFRoZSBvdGhlciBw
cm9ibGVtIGlzIGFjdHVhbGx5IHRoYXQgdXNlcnNwYWNlIG5lZWRzIHRvIGtub3cgd2hlbiB3ZSBh
cmUNCj4gY2xvc2UgdG8gdGhlIGxpbWl0cyBvZiBBRVMtR0NNIGVuY3J5cHRpb25zIG9yIHdoZW4g
dGhlIHNlcXVlbmNlIG51bWJlcg0KPiBpcyBhYm91dCB0byB3cmFwLiBXZSBuZWVkIHRvIGZlZWQg
YmFjayB0aGUgc3RhdHVzIG9mIHRoZSByZWNfc2VxIGJhY2sNCj4gdG8gdXNlcnNwYWNlIChhbmQg
d2l0aCB0aGF0IGFsc28gZnJvbSB0aGUgSFcgb2ZmbG9hZCkuDQoNCkkgYWdyZWUgYWJvdXQgdGhl
IHByb2JsZW0uIEJ1dCwgdGhlIHBhcnQgYWJvdXQgSFcgaXMgaW1wcmVjaXNlLCB0aGUNCmtlcm5l
bCBoYXMgYWxsIHRoZSBzdGF0ZSBuZWVkZWQgKGV4Y2VwdCBtYXliZSBpbiBUTFNfSFdfUkVDT1JE
KS4NCg0KPiANCj4gSSB3b3VsZCBhcmd1ZSB0aGF0IGl0IG1pZ2h0IGhhdmUgbWFkZSBzZW5zZSBu
b3QganVzdCBzcGVjaWZ5aW5nIHRoZQ0KPiBzdGFydGluZyByZXFfc2VxLCBidXQgYWxzbyBlaXRo
ZXIgYW4gZW5kaW5nIG9yIHNvbWUgdHJpZ2dlciB3aGVuDQo+IHRvIHRlbGwgdXNlcnNwYWNlIHRo
YXQgaXQgaXMgYSBnb29kIHRpbWUgdG8gcmUta2V5Lg0KDQpXZSBkaWRuJ3QgZG8gdGhlIHJla2V5
IGRlc2lnbiB3aGVuIHdlIGNvZGVkIHRoaXMsIGJhY2sgdGhlbiB0aGUgbG9naWMNCndhcyB0aGF0
IHJla2V5cyBhcmUgcmFyZSBhbmQgY29ubmVjdGlvbnMgYXJlIHR5cGljYWxseSByZXN0YXJ0ZWQg
d2hlbg0KYSByZWtleSBpcyByZXF1ZXN0ZWQuDQoNCkkgdGhpbmsgdGhhdCBoYXZpbmcgYW4gZW5k
IHJlcV9zZXEgbWFrZXMgc2Vuc2Ugb25seSBpZiB3ZSBkbyB0aGUgcmVrZXkNCmluIHRoZSBrZXJu
ZWwuIE9uIHRoZSBUTFNfREVWSUNFIHNpZGUsIGhhdmluZyB0aGUgZW5kX3NlcSBoZWxwcyBiZWNh
dXNlDQp0aGUgZHJpdmVyIHdpbGwga25vdzogKDEpIHdoZW4gdG8gc3dpdGNoIHRvIHRoZSBuZXh0
IGtleSBvbiB0cmFuc21pdDsNCigyKSB3aGVuIHRvIHVzZSB0aGUgb2xkIGtleSBmb3IgcmV0cmFu
c21pdDsgYW5kICgzKSB3aGVuIHRvIGRlbGV0ZSB0aGUNCm9sZCBrZXkgYXMgYWxsIG9sZCBrZXkg
ZGF0YSBoYXMgYmVlbiB0cmFuc21pdHRlZC4gVGhpcyBjYW4gYWxzbyB3b3JrDQp3aXRoIGFueSBu
dW1iZXIgb2Yga2V5cy9yZWtleXMuDQoNCj4gDQo+IFJlZ2FyZHMNCj4gDQo+IE1hcmNlbA0KPiAN
Cg0K
