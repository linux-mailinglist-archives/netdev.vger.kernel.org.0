Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7E268DED2
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 18:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjBGRYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 12:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBGRYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 12:24:10 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D86125B8;
        Tue,  7 Feb 2023 09:24:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQGEFG3kLCsRfVES6agOccNgBviy6ISR0AajJgHfoy41I9RalacOqnmTaAe/1PillmjxjgVOV7/gkoOSmaGraCrsAqfRLvx2RrKxCWI6j5reeMPGf4efQhdIFlAEe2+wEIIFWaFkYvyk1xunmimTwni3dfvPEEuteT2t1LtcBqCOMizT4UPcSu1VeNxwvQz+85RdFHkExMVu06DSNJVMxCBQ3hJXPBvWpUc8r5z9nusGS5iTAXWvqcrnLpDKB7K8yBJbanTeHRtRa3+RmR71tORzeMgqmV+UqOdcXAGetYC06Dv+ZgNfZ3dfBWhCSEvjW+ObG+EvAs4GmbG8P0TiOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7q1nMUJdkyFFSk1322Vyp3CL7krT/q3GbrwqxFgnd0=;
 b=iICoMiCCP6xJJZnL7VikOdc1bestBPM5BLY4iBjx0w/8q/CGZaU/NFZH/lIo5VL0BHfBA1EjGuXL2q13Uhfj51J+X/oTtmTzkMwBIIKV9cIZAoQF/4tE/CquV3/CA4LN6U6cSH5+VMi53CRPZmzw90Qobx6w6HPQKsKQ176s7zFohSx9/FAiLSF3xn8TkWmo6ZqHIWHWzOhP8SiN+5OdYTEYL5p+rFqg/r7haeYEU7RQHbvMNHyowSdw3o8Usjui0CiocQZwzWhe8vnRD/rmeSB6DX16rhcUuwCe56El4gXVrSEJqoEWOOvQ9WvdzD5JbUiotnhXA7FQhhmEd9Zedw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7q1nMUJdkyFFSk1322Vyp3CL7krT/q3GbrwqxFgnd0=;
 b=cltEF9/KDmJa7qxdiFRxiNKIsKBmbPxplWGa+KgBqeEZ1WU+GCe5Qn9+LC+N0+Lbi3AkSFOxnnMAT6rzW12jZGcZqd6Ai6Vs9l37NnRSUCgXGz0DIXtZqiAAEx2hj1hnAky/xBhSzaDmJEu9GL7vxvyJ+rrvh133sHyc1yIlGPQ=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by DM4PR12MB8558.namprd12.prod.outlook.com (2603:10b6:8:187::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 17:24:05 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 17:24:05 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
Thread-Topic: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
Thread-Index: AQHZNveRaZV2migBBki/Fbor0TTGVq67jUyAgAgJY4CAAAS0gIAAA0yAgAAlLwA=
Date:   Tue, 7 Feb 2023 17:24:05 +0000
Message-ID: <DM6PR12MB4202E78CB7CB3BE13817B782C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-3-alejandro.lucero-palau@amd.com>
 <Y9ulUQyScL3xUDKZ@nanopsycho>
 <DM6PR12MB4202DC0B50437D82E28EAAC2C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
 <Y+JnH+ecdTGgYqAf@nanopsycho>
 <DM6PR12MB42026D97627495DC2FF2A346C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB42026D97627495DC2FF2A346C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4909.namprd12.prod.outlook.com
 (15.20.6086.009)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|DM4PR12MB8558:EE_
x-ms-office365-filtering-correlation-id: dc46b1d8-74b8-4e3c-0bff-08db09301d08
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eVgEvp3uy3CY14tmMo35u/SOwTJy6d2xTrRCjDEmTdtAVyMjlH99Vy5g8vuw/yFX7TVk7NYglzAfkU+F4VZTK60GtMaGjjl5I99GFoRoRgMJr3/eXpTs9sOydIf7sDrODji8k8tVPNnz5phCsgxQj90OcS2XGWjFCrbWDPvdtQyAz5+yW7PH3uhleZrgRlmPPT9enPrsrwXgk3f9uBnaOhgu7rUc8pgm7CuZsGkOAbrnTkXSuFxuGRYVYAz8SGPnikFs9hy7n44V/Nm3iFdM6fFnVS0D7Mw2s2eP48v5KVNfiq44qmc2zIE0HBQRVwlT3dNmoBrFVd9c/GJT/ZvkUELwqtV/tHBhRl56p7if+/cdgyCktrDkNQLbOceKa2gnxsj9NIJkrjDUZNrq5M1jYLYap7nwP2LSSh7rtnghFLeyk+ppwJlxC7xFyKnbs+Vv5wMZvDoRxNPFfzhNk7WFmQ5vqEcFwze14I+vmqer9fnmFWWmbYAjGgY/TG2fuCJVD0IZwTAuRDieVXu9kEdC5wujT4gc/JnNtQUDgd/Pd05OWh3yMiZszOxe9r9nbTNsn5BX0u7z+pACxL5O7KpWh/ujIEgouJfeyHgKZ18PnxdZyCUgE6e2lnd2SAosbsU8xX8VVKUIDMbbdQ8JMhhTjm03tBGSVkEwS7pPL9MS1SM3XsxZJyd49jYvMlG9pxdffPfyxQIVKjrcsO8OQy1zkLDx+5Nb38A6raX+BYy2AUhDpkM3CdCBbzuSttRfpxqo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(366004)(376002)(396003)(451199018)(64756008)(66446008)(66476007)(55016003)(53546011)(478600001)(6506007)(8676002)(26005)(9686003)(186003)(4326008)(2940100002)(76116006)(110136005)(66556008)(66946007)(316002)(7696005)(122000001)(38070700005)(54906003)(71200400001)(38100700002)(33656002)(83380400001)(7416002)(5660300002)(8936002)(52536014)(41300700001)(2906002)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VU5XUzlpTU4yN1paOERQMHR4ck42VzdiS25VWm55bnhSK09YQkRlRWhuOGhT?=
 =?utf-8?B?QWZVZDcwbVZ2Z0g0L3ppUFFxYWVUaWwvL2JGanhUYnMybGhTNUdHRTlwTmdI?=
 =?utf-8?B?eDdRZUZES1N4VUhqN0h4aWo4Mkx0Tzk5RDByOFZtYU9oaVVmMmN4bVArTUdv?=
 =?utf-8?B?NVVJU3lVZWt2SEU4SXFYajEwNXF5ZnBKWGdYc1h3QmpQajNCU0wxeDFRbTRM?=
 =?utf-8?B?UGVSQ0Zmc3Q5LzB4eUJMUUdNdENnSy9KUnRTd3JNQ1g1cFYvazJwbG9zajhK?=
 =?utf-8?B?QlROWGRyanp5bGxMQ3ZaZXV4enkzR3c3UU93R3VEbVQxTTYxTjVlRU84ajhS?=
 =?utf-8?B?WGFabER3bzc0TjMzdjc0UEdWUm9ycUx3aXBoOHd1TmhLdzFLZDhSOFZRbG1U?=
 =?utf-8?B?b0NKSHFQZlNwZkxSSWkxekl1dURma1BZei9UVGdsdElMUXVMS1BVSHMxZDZT?=
 =?utf-8?B?bGVaS1EwdmwzRWNSUUFMS2hZdzRXZUlCUXllYlE5UnNISlFTb3Q3TVN2UVlO?=
 =?utf-8?B?TGc5UUttOWJzT05sQXVFVzVqTklXOEtUcGYzQ2lRSm9yNmRWeG4xZFAvZ244?=
 =?utf-8?B?TjlET0tpYmZZcmtoQ0ZFdXo4RzZjZ3A0SkpWeS9PRmFBQ1c4emRPMkdTTFZs?=
 =?utf-8?B?K2FqTnNQcHEyK1hXNXlUdjA4VkVjR0NLS1VUQjVtR0xvQVgvQVRzcHhkQUtn?=
 =?utf-8?B?aUxRS3ludFQ2ZFp1SkFpN09COFJOOEpFVFI4aEdiVW5aY0tGZXVSRkNWcE9Q?=
 =?utf-8?B?elFXZWpXVDlQMkY5ckxjMUVXYUlVd1VwNWJkK0pDRDZCRmtWREZGeGdURjBI?=
 =?utf-8?B?Qk1nSTUvNEZVUTZhQ3hqcXhNaS8rWWxlMGh0QkFqa1EyVWYyNlN4NGNBS1A0?=
 =?utf-8?B?UENGWDlUdFNDZGtaQW1HaTVsNEtWWmx5WkJaUEYrYU41amQ0eWw2TVZCOTY0?=
 =?utf-8?B?eTVwRi9MUmV4Y3podDJrM0NQYkZqcE5RNnl3Q2taSklBOVUwS3RtVStSZEZy?=
 =?utf-8?B?WUdOeEZqY0xEaVhueEhkeTl6YTYwRDJTVjg5QjNnRnVWelMzaEZnSW1YdGg5?=
 =?utf-8?B?RmxtQWlDeGRtT21YdnEyNDJaQjlrL2h2ZmJXVVpzam5LQ0hCY1k0K0RtZ1RV?=
 =?utf-8?B?ZmxjZ2FISFJpcU4ySzRVK09wTmx3TXJHcjNOaVZNNm1odmlRR3FlTEppUVJM?=
 =?utf-8?B?OENJbkxIQ01US1BLWFdrcVFOamYvL0FhOG9iTkVHRHlMS2dBMjdZbW51Syts?=
 =?utf-8?B?S1dYdmp3Wk44eE1tNjFJV3lPcUJBRW8xaUp5V3lyT0pHRzJ3eUc1NDJhUVYz?=
 =?utf-8?B?czBGWURYZ3c3MEU1NThpUUhWcCs4RnBCYkZwZnRQUTZHZ0ROVURGR1c4NEpk?=
 =?utf-8?B?Q1Y0Q1BlSG1TWk5KZnlaa2R2b0tLUDJZNFZpdktFZmluQkZ0Y2RVc2tmMlAr?=
 =?utf-8?B?eHpySzl1bm5wVzIzWDRoaTVjdHhmcHh2aHdIOUhUd1NUNTAyRzQvTmlmbHhi?=
 =?utf-8?B?SkNpTnVJbUlOZHdrRGVQMW52MjRLbExUNmpZUGVZVGhEa2UvYUljOEtVUi9l?=
 =?utf-8?B?azBWVXI4d1F4RGtIazlZclFWaGhLVTZPN29kekRBeWhkV2VGeXhCelp6TTlN?=
 =?utf-8?B?MUZFekVNVkxrSGhzbEJTT0ZmNEJEU2xoaU9HNWpFZVNuUWRFcFFQVzZSUm9K?=
 =?utf-8?B?VEEvaDRDK05uWi9tZHpmWkEwbC9Xc05VTy8zaTl6UFRzQ3l2V0ZhWUJTaklw?=
 =?utf-8?B?a3B6YzFnOS9xNDdCZ00vaFE0MGd3ZkNSRm92eXZsdCtRdWRGckJhMkJQeFN2?=
 =?utf-8?B?cTNnK2NZMTFJbjZHQURPV1BGQ3E0QVYvK0Zrc2ZlWU5XYXJodFFTR3ZKV2JT?=
 =?utf-8?B?SHo3NWxqTGtXbVQ5emdVUTJPTER5YmtWRnUwMXFwUXdKalNJUmVhTlVYZUF6?=
 =?utf-8?B?SUllVVhhbVNtTlVMakoxZUdqMTVYT3krWmNWdnRFZkthdzQyMWhCd3FnSjdX?=
 =?utf-8?B?eGMwemZMZ2FuNm52NUdJM3IwY2swcTNKT0FENWpyc1VzRjcrOVdPQTlVci9R?=
 =?utf-8?B?N2JLT01RVWxZWW16T0xxNkdyOGtDSGJvWFdBdDJodFV1ZTRxc1cyVk1aL0M3?=
 =?utf-8?Q?stK0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <516C5E8FAEA59542BEF6A295BFAE1BDE@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc46b1d8-74b8-4e3c-0bff-08db09301d08
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 17:24:05.2579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 16UloqCWE1LkzyF6lTMvRjCpInRR/0itVK5eo39bt0USBKYWNylvQgkArKSa0fyrBi1dAuEm4huY3gUWy0AUyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8558
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzcvMjMgMTU6MTAsIEx1Y2VybyBQYWxhdSwgQWxlamFuZHJvIHdyb3RlOg0KPiBPbiAy
LzcvMjMgMTQ6NTgsIEppcmkgUGlya28gd3JvdGU6DQo+PiBUdWUsIEZlYiAwNywgMjAyMyBhdCAw
Mzo0Mjo0NVBNIENFVCwgYWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQuY29tIHdyb3RlOg0KPj4+
IE9uIDIvMi8yMyAxMTo1OCwgSmlyaSBQaXJrbyB3cm90ZToNCj4+Pj4gVGh1LCBGZWIgMDIsIDIw
MjMgYXQgMTI6MTQ6MTdQTSBDRVQsIGFsZWphbmRyby5sdWNlcm8tcGFsYXVAYW1kLmNvbSB3cm90
ZToNCj4+Pj4+IEZyb206IEFsZWphbmRybyBMdWNlcm8gPGFsZWphbmRyby5sdWNlcm8tcGFsYXVA
YW1kLmNvbT4NCj4+Pj4+DQo+Pj4+PiBTdXBwb3J0IGZvciBkZXZsaW5rIGluZm8gY29tbWFuZC4N
Cj4+Pj4gWW91IGFyZSBxdWl0ZSBicmllZiBmb3IgY291cGxlIGh1bmRyZWQgbGluZSBwYXRjaC4g
Q2FyZSB0byBzaGVkIHNvbWUNCj4+Pj4gbW9yZSBkZXRhaWxzIGZvciB0aGUgcmVhZGVyPyBBbHNv
LCB1c2UgaW1wZXJhdGl2ZSBtb29kIChhcHBsaWVzIHRvIHRoZQ0KPj4+PiByZXN0IG9mIHRoZSBw
YXRoZXMpDQo+Pj4+DQo+Pj4+IFsuLi5dDQo+Pj4+DQo+Pj4gT0suIEknbGwgYmUgbW9yZSB0YWxr
YXRpdmUgYW5kIGltcGVyYXRpdmUgaGVyZS4NCj4+Pg0KPj4+Pj4gK3N0YXRpYyBpbnQgZWZ4X2Rl
dmxpbmtfaW5mb19nZXQoc3RydWN0IGRldmxpbmsgKmRldmxpbmssDQo+Pj4+PiArCQkJCXN0cnVj
dCBkZXZsaW5rX2luZm9fcmVxICpyZXEsDQo+Pj4+PiArCQkJCXN0cnVjdCBuZXRsaW5rX2V4dF9h
Y2sgKmV4dGFjaykNCj4+Pj4+ICt7DQo+Pj4+PiArCXN0cnVjdCBlZnhfZGV2bGluayAqZGV2bGlu
a19wcml2YXRlID0gZGV2bGlua19wcml2KGRldmxpbmspOw0KPj4+Pj4gKwlzdHJ1Y3QgZWZ4X25p
YyAqZWZ4ID0gZGV2bGlua19wcml2YXRlLT5lZng7DQo+Pj4+PiArCWNoYXIgbXNnW05FVExJTktf
TUFYX0ZNVE1TR19MRU5dOw0KPj4+Pj4gKwlpbnQgZXJyb3JzX3JlcG9ydGVkID0gMDsNCj4+Pj4+
ICsJaW50IHJjOw0KPj4+Pj4gKw0KPj4+Pj4gKwkvKiBTZXZlcmFsIGRpZmZlcmVudCBNQ0RJIGNv
bW1hbmRzIGFyZSB1c2VkLiBXZSByZXBvcnQgZmlyc3QgZXJyb3INCj4+Pj4+ICsJICogdGhyb3Vn
aCBleHRhY2sgYWxvbmcgd2l0aCB0b3RhbCBudW1iZXIgb2YgZXJyb3JzLiBTcGVjaWZpYyBlcnJv
cg0KPj4+Pj4gKwkgKiBpbmZvcm1hdGlvbiB2aWEgc3lzdGVtIG1lc3NhZ2VzLg0KPj4+Pj4gKwkg
Ki8NCj4+Pj4+ICsJcmMgPSBlZnhfZGV2bGlua19pbmZvX2JvYXJkX2NmZyhlZngsIHJlcSk7DQo+
Pj4+PiArCWlmIChyYykgew0KPj4+Pj4gKwkJc3ByaW50Zihtc2csICJHZXR0aW5nIGJvYXJkIGlu
Zm8gZmFpbGVkIik7DQo+Pj4+PiArCQllcnJvcnNfcmVwb3J0ZWQrKzsNCj4+Pj4+ICsJfQ0KPj4+
Pj4gKwlyYyA9IGVmeF9kZXZsaW5rX2luZm9fc3RvcmVkX3ZlcnNpb25zKGVmeCwgcmVxKTsNCj4+
Pj4+ICsJaWYgKHJjKSB7DQo+Pj4+PiArCQlpZiAoIWVycm9yc19yZXBvcnRlZCkNCj4+Pj4+ICsJ
CQlzcHJpbnRmKG1zZywgIkdldHRpbmcgc3RvcmVkIHZlcnNpb25zIGZhaWxlZCIpOw0KPj4+Pj4g
KwkJZXJyb3JzX3JlcG9ydGVkICs9IHJjOw0KPj4+Pj4gKwl9DQo+Pj4+PiArCXJjID0gZWZ4X2Rl
dmxpbmtfaW5mb19ydW5uaW5nX3ZlcnNpb25zKGVmeCwgcmVxKTsNCj4+Pj4+ICsJaWYgKHJjKSB7
DQo+Pj4+PiArCQlpZiAoIWVycm9yc19yZXBvcnRlZCkNCj4+Pj4+ICsJCQlzcHJpbnRmKG1zZywg
IkdldHRpbmcgYm9hcmQgaW5mbyBmYWlsZWQiKTsNCj4+Pj4+ICsJCWVycm9yc19yZXBvcnRlZCsr
Ow0KPj4+PiBVbmRlciB3aGljaCBjaXJjdW1zdGFuY2VzIGFueSBvZiB0aGUgZXJyb3JzIGFib3Zl
IGhhcHBlbj8gSXMgaXQgYSBjb21tb24NCj4+Pj4gdGhpbmc/IE9yIGlzIGl0IHJlc3VsdCBvZiBz
b21lIGZhdGFsIGV2ZW50Pw0KPj4+IFRoZXkgYXJlIG5vdCBjb21tb24gYXQgYWxsLiBJZiBhbnkg
b2YgdGhvc2UgaGFwcGVuLCBpdCBpcyBhIGJhZCBzaWduLA0KPj4+IGFuZCBpdCBpcyBtb3JlIHRo
YW4gbGlrZWx5IHRoZXJlIGFyZSBtb3JlIHRoYW4gb25lIGJlY2F1c2Ugc29tZXRoaW5nIGlzDQo+
Pj4gbm90IHdvcmtpbmcgcHJvcGVybHkuIFRoYXQgaXMgdGhlIHJlYXNvbiBJIG9ubHkgcmVwb3J0
IGZpcnN0IGVycm9yIGZvdW5kDQo+Pj4gcGx1cyB0aGUgdG90YWwgbnVtYmVyIG9mIGVycm9ycyBk
ZXRlY3RlZC4NCj4+Pg0KPj4+DQo+Pj4+IFlvdSB0cmVhdCBpdCBsaWtlIGl0IGlzIHF1aXRlIGNv
bW1vbiwgd2hpY2ggc2VlbXMgdmVyeSBvZGQgdG8gbWUuDQo+Pj4+IElmIHRoZXkgYXJlIHJhcmUs
IGp1c3QgcmV0dXJuIGVycm9yIHJpZ2h0IGF3YXkgdG8gdGhlIGNhbGxlci4NCj4+PiBXZWxsLCB0
aGF0IGlzIGRvbmUgbm93LiBBbmQgYXMgSSBzYXksIEknbSBub3QgcmVwb3J0aW5nIGFsbCBidXQg
anVzdCB0aGUNCj4+PiBmaXJzdCBvbmUsIG1haW5seSBiZWNhdXNlIHRoZSBidWZmZXIgbGltaXRh
dGlvbiB3aXRoIE5FVExJTktfTUFYX0ZNVE1TR19MRU4uDQo+Pj4NCj4+PiBJZiBlcnJvcnMgdHJp
Z2dlciwgYSBtb3JlIGNvbXBsZXRlIGluZm9ybWF0aW9uIHdpbGwgYXBwZWFyIGluIHN5c3RlbQ0K
Pj4+IG1lc3NhZ2VzLCBzbyB0aGF0IGlzIHRoZSByZWFzb24gd2l0aDoNCj4+Pg0KPj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIE5MX1NFVF9FUlJfTVNHX0ZNVChleHRhY2ssDQo+Pj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCAiJXMuICVkIHRvdGFsIGVycm9ycy4gQ2hlY2sgc3lzdGVtIG1lc3NhZ2VzIiwN
Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIG1zZywgZXJyb3JzX3JlcG9ydGVkKTsNCj4+Pg0KPj4+IEkgZ3Vlc3Mg
eW91IGFyZSBjb25jZXJuZWQgd2l0aCB0aGUgZXh0YWNrIHJlcG9ydCBiZWluZyBvdmVyd2hlbG1l
ZCwgYnV0DQo+Pj4gSSBkbyBub3QgdGhpbmsgdGhhdCBpcyB0aGUgY2FzZS4NCj4+IE5vLCBJJ20g
d29uZGVyaW5nIHdoeSB5b3UganVzdCBkb24ndCBwdXQgZXJyb3IgbWVzc2FnZSBpbnRvIGV4YWNr
IGFuZA0KPj4gcmV0dXJuIC1FU09NRUVSUk9SIHJpZ2h0IGF3YXkuDQo+IFdlbGwsIEkgdGhvdWdo
dCB0aGUgaWRlYSB3YXMgdG8gZ2l2ZSBtb3JlIGluZm9ybWF0aW9uIHRvIHVzZXIgc3BhY2UNCj4g
YWJvdXQgdGhlIHByb2JsZW0uDQo+DQo+IFByZXZpb3VzIHBhdGNoc2V0cyB3ZXJlIG5vdCByZXBv
cnRpbmcgYW55IGVycm9yIG5vciBlcnJvciBpbmZvcm1hdGlvbg0KPiB0aHJvdWdoIGV4dGFjay4g
Tm93IHdlIGhhdmUgYm90aC4NCg0KDQpKdXN0IHRyeWluZyB0byBtYWtlIG1vcmUgc2Vuc2Ugb2Yg
dGhpcy4NCg0KQmVjYXVzZSB0aGF0IGxpbWl0IHdpdGggTkVUTElOS19NQVhfRk1UTVNHX0xFTiwg
d2hhdCBJIHRoaW5rIGlzIGJpZyANCmVub3VnaCwgc29tZSBjb250cm9sIG5lZWRzIHRvIGJlIHRh
a2VuIGFib3V0IHdoYXQgdG8gcmVwb3J0LiBJdCBjb3VsZCBiZSANCmp1c3QgdG8gd3JpdGUgdGhl
IGJ1ZmZlciB3aXRoIHRoZSBsYXN0IGVycm9yIGFuZCByZXBvcnQgdGhhdCBsYXN0IG9uZSANCm9u
bHksIHdpdGggbm8gbmVlZCBvZiBrZWVwaW5nIHRvdGFsIGVycm9ycyBjb3VudC4gQnV0IEkgZmVs
dCBvbmNlIHdlIA0KaGFuZGxlIGFueSBlcnJvciwgcmVwb3J0aW5nIHRoYXQgZXh0cmEgaW5mbyBh
Ym91dCB0aGUgdG90YWwgZXJyb3JzIA0KZGV0ZWN0ZWQgc2hvdWxkIG5vdCBiZSBhIHByb2JsZW0g
YXQgYWxsLCBldmVuIGlmIGl0IGlzIGFuIHVubGlrZWx5IA0Kc2l0dWF0aW9uLg0KDQpCVFcsIEkg
c2FpZCB3ZSB3ZXJlIHJlcG9ydGluZyBib3RoLCB0aGUgZXJyb3IgYW5kIHRoZSBleHRhY2sgZXJy
b3IgDQptZXNzYWdlLCBidXQgSSd2ZSByZWFsaXplZCB0aGUgZnVuY3Rpb24gd2FzIG5vdCByZXR1
cm5pbmcgYW55IGVycm9yIGJ1dCANCmFsd2F5cyAwLCBzbyBJJ2xsIGZpeCB0aGF0Lg0KDQoNCj4+
Pj4+ICsJfQ0KPj4+Pj4gKw0KPj4+Pj4gKwlpZiAoZXJyb3JzX3JlcG9ydGVkKQ0KPj4+Pj4gKwkJ
TkxfU0VUX0VSUl9NU0dfRk1UKGV4dGFjaywNCj4+Pj4+ICsJCQkJICAgIiVzLiAlZCB0b3RhbCBl
cnJvcnMuIENoZWNrIHN5c3RlbSBtZXNzYWdlcyIsDQo+Pj4+PiArCQkJCSAgIG1zZywgZXJyb3Jz
X3JlcG9ydGVkKTsNCj4+Pj4+ICsJcmV0dXJuIDA7DQo+Pj4+PiArfQ0KPj4+Pj4gKw0KPj4+Pj4g
c3RhdGljIGNvbnN0IHN0cnVjdCBkZXZsaW5rX29wcyBzZmNfZGV2bGlua19vcHMgPSB7DQo+Pj4+
PiArCS5pbmZvX2dldAkJCT0gZWZ4X2RldmxpbmtfaW5mb19nZXQsDQo+Pj4+PiB9Ow0KPj4+PiBb
Li4uXQ0K
