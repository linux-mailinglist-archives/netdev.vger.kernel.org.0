Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72075A1492
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 16:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242613AbiHYOnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 10:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242604AbiHYOnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 10:43:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1418CF46;
        Thu, 25 Aug 2022 07:42:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIZzQCn0WU1eiBBvUyffAjWzxTVwsWRzyDwb3H9/wLQFE235Ulta5BXm9zo1/gKolJo8+ao2ncHGnGvPDvsT4CE4oMzYoNANFDwjVbh0PQpfHg4xH76Vj9Qb3r+E4u/RtF2htz4lnchslyLJojhXtOSADOT641BE9quLGflY3m1ulXsXr0fUWwd8xw3CbyyyzNdcJ40xBnrGPKCsNi02s61JCGR2rVo7wiyVRNAIgUc3MBc87L4F5wA1ucYfJloGejsh8yRhmJZFL7omfN9ogafg6NqD20TU+Pdt1OwfGH/IwzqOAgbiMlKAIvoq4iAOswPFIbAGXjkZ1Imh8rfInA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PV0P6t4cMcjIBKVH2qkZS2ETEorSz9uzNuL4s3UDw4s=;
 b=ZA0JCiq/ee/noKs9BRaK4qJd+g5q1nZfEm3Awaq5+0T/frDc1kMKG/fcjUwC3HuDcx3HXHyHzOIwI/PFSnbRaL0mtQ55nGEVYO03NR1HA1jdgwZDJM8nPcrT8qFaWTCwcHWmOpWU03rEyKxrQymlHLZjUaslcz64ZocSPerYr6qamnETycjLVarBvSbDFpgTYa1TShJktP5VhCvJktx9QTlpHbdwsl6poeZmioPp/iSaZEz1g2BcrTrIERIstYXE2FOJ9Q1iupqZIhTMvLqBuWcOFhAWwVLm1SrVhQUBkCklUEwVeDlahdcOGWMZIOgSADDCtKo4ZGUUQYnU95Pd6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PV0P6t4cMcjIBKVH2qkZS2ETEorSz9uzNuL4s3UDw4s=;
 b=ULzKDn3mY6+B1f/8ZN1yiFyK1kv2QVewNrpYk64k7kCa0S7/8U86rnL8eyU83chuNIx5dL+kTRw4N7tkiIGXmzzhn0gVhVnXL1elGut9Xja7GsjLElCll3VRMse08hr3l+v6/ZT0otvYaLL/gr66il45cDG/hJjukGgv311ZgmqZ87ZFR/e7z/ri03jFpgfC6GW9ZyI41IvmAv3kBbcKxQCAqjG8LlgdHmc0g4IurerxPNyta9jTLwVg1DUdFEJoAO5vUdUkUpCR75LZPJFGtngCwsk3j8rE8jabqXCJBASWxVOAR3rxVlJQfmRFmlR/s3qNzDFJpra5lTJJRzayew==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BY5PR12MB3684.namprd12.prod.outlook.com (2603:10b6:a03:1a2::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Thu, 25 Aug
 2022 14:42:25 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::29c2:ae5e:a426:46f0]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::29c2:ae5e:a426:46f0%6]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 14:42:25 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>
CC:     "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "ast@kernel.org" <ast@kernel.org>
Subject: Re: [PATCH v2 bpf-next 00/14] xsk: stop NAPI Rx processing on full
 XSK RQ
Thread-Topic: [PATCH v2 bpf-next 00/14] xsk: stop NAPI Rx processing on full
 XSK RQ
Thread-Index: AQHYT0tpbpOS7hf0yU2uZi+ifIWmea21TECAgAfAfYCAABpiAIAAJ+eAgAEEKwCAAi//AA==
Date:   Thu, 25 Aug 2022 14:42:25 +0000
Message-ID: <4e65c78fd58f1bea9ccccb4f056b5d8e83b75c3f.camel@nvidia.com>
References: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
         <f1eea2e9ca337e0c4e072bdd94a89859a4539c09.camel@nvidia.com>
         <93b8740b39267bc550a8f6e0077fb4772535c65e.camel@nvidia.com>
         <YwS41lA+mz0uUZVP@boxer>
         <ff1bb9e386d1231b5b44d645b8f9a02af8abdd79.camel@nvidia.com>
         <6305b48ebc40b_6d4fc2083@john.notmuch>
In-Reply-To: <6305b48ebc40b_6d4fc2083@john.notmuch>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: beddb7dd-1ab5-4d0e-5d17-08da86a806b0
x-ms-traffictypediagnostic: BY5PR12MB3684:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jVlAbhjn4+KLkw6yWuRDe3cEhihIb4w6bgAdCjUnjAe99XQuqzLvzaRnzcXKHFHst/TP6fdOkyl99OtOMjKUTCoLE+G7cMOxhj9wJqC9I5OQs5XMEKTx/C+qzEnmxj49uyzqPkaVx+BJ6/HlneoEA1zh2Lbuyv/1rXBkM1bHbHZ9/7pHFHOJy2X/VyL8QfQlDjyDWSmG0w6QOAVsF4RHn6PJvQCRDED6bwtxWCFFbeUOF316lA5aFzmhNMnoALWwktolanmvuLVxlywwG0OhAWU8LezKhGbUwm0RyGZZMDaMIqt/O/P9VEeBvoqdbu26rKBtoVgUstIn6tplusZrL89pXEoed+nsMaSvztX/VnLpXcB0es8FDVmORQs9VRGQLeJ73EcbyzEnOkRNhTkmOzNi15QWEoCnnSlaWIoFzQi8vLWV1+kd+KR87YV8ARUaoGADAcyRjSL9jRLnBXCWUFuNKx0pKQl25Xq/SBgB7xAYp4/MnAiLG2TiKfRkFNyon1cJLBd9KfhZ+r0bwYz6hkwlUMJ7ED0P+rx22lT1Tg7/xo0u82+0BQCKD2oT0hNqJCsVXSokL19S4Xir7yF5FkqybnGTZytkZ9dXQw133ncn2FiIj4HAb88NttT4sYIWQm/i6ZAZNj1goygChYw5v9E+0wgI6gM3IDunVs/uG14zscTUm9Ctp2RTyKmbTlcA8rEPU+CC3Ewhh90OIv67KIFxZKB0rmYoL3ZR4lO8tqD9iYxBkt0NLOVTfKRHNUzMMcRd5gXa4LyLq6HOIOibxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(55236004)(41300700001)(38070700005)(478600001)(38100700002)(6512007)(2616005)(186003)(6506007)(26005)(71200400001)(6486002)(4326008)(91956017)(54906003)(316002)(66556008)(76116006)(8676002)(66476007)(86362001)(66446008)(66946007)(8936002)(122000001)(5660300002)(2906002)(7416002)(36756003)(110136005)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1AwZWlmV09FOWJHWlYySVJ4bC9TNUM5Y0F0VGVJRXBMT0UvZW9IbUd6cDhJ?=
 =?utf-8?B?b0VodlArV2t0NjZoRG1acTBERmlRdElUYnpDYzRESncwZWdZdVZKMnNKd2xI?=
 =?utf-8?B?bWhwODZUSWpRK0NzUkwrREFnVW5HUWQrL0VjS1pjYWVDVG1hb1RONnY5M2pQ?=
 =?utf-8?B?YzB2MVV3d1luNHI5VkpoRXZIanBHdGFzOWY1NFZESExocm9DZjBRamYvK1Fv?=
 =?utf-8?B?dzF5ODBJQjI4MXhubTBXd1lHK3Y3SE9vdkFLZHZNbTlMMHl2L3c0V2FpSDA4?=
 =?utf-8?B?TGJZcm13YUxFU2xadDFadVBQSU80ZThJcVFkOEtjSlhSQ0VodW9VL2xCLzB3?=
 =?utf-8?B?dTIxbDF5Y2tFZjBUZ3N2RWZoS0FCR09KaHlaUmsrM0hwTDZGazFSQzlRenNx?=
 =?utf-8?B?UTN2NzA4TzEvNXJrTTRRbkIwTk4rQ1lYcFFoRy9iM3dYWFZsYmlEM1l1akpB?=
 =?utf-8?B?LzM4dnBJUU5RelhqRzJJa2psR0EzZm9jV0JtbjY0d2JaUVBsNzFKUkcxQ2tI?=
 =?utf-8?B?T25DdExCdW9MbFVDbVBVSEZMc0tXei9IcmlLK3V0QzNIeHZCN2pqeThtYjZz?=
 =?utf-8?B?TUZDL0lIODlGZGVCclFCSVFzNFMxM1YzcE1RZ09wM254R2V2ZnNiM2ZQZldX?=
 =?utf-8?B?WUladDQwTXNaa0hMTnhnUDdjNjMzUlJpOVlCYzNxeHlMU0JqSHJtWFM4bGxM?=
 =?utf-8?B?Vnd1enRocnE3SHVHMWJHM1pwWk14N1JoMTRTT2RMdjlBWDNJSFJWSnNTNVQv?=
 =?utf-8?B?VUkwRWx2aE1CU245VEV4WTFSVlVjbjB2L3lWQ3JZNW5PbTlKekhhSGVpL2pK?=
 =?utf-8?B?eHlwRDRkT2V5ckl5RmFqSFV5SVhkeDN2UlR1L083QklBSlk1a0t6SjlnSElx?=
 =?utf-8?B?MmhHcHZXT0JBeC8rNTMvTlNRd0FtRnZaYTA2dVdPVGJyZUtDdS8wSnA1bklG?=
 =?utf-8?B?VUpDZXlmOE5kUWNUZG84V1VIZktydllPeFV6UVVzV3NRZTEwc2I2SEI2bkdr?=
 =?utf-8?B?SFI5cTZISm1ld1lpREJMaENBQjdLbEdHbjBCWXFteEZlMG9yVFVqNDI1YlJO?=
 =?utf-8?B?Z3dMNm9xOWY2Q3VFRGFyUk04U3owaHVhbUlQK05ReWhEYUlmVC9zSU9DaCtN?=
 =?utf-8?B?T3Yva1FBQ3U0eGNxbTUxZlJuOWU1ZTlXR2E1R1R5VTJSUnJNN0hQellta1BT?=
 =?utf-8?B?VERrQmxFV3hVbjR6QW4vd09zRFAwanJLczF0UXhsTlVOZGh5MnFCZ245K3lo?=
 =?utf-8?B?YTFRVlZKRVg4R0lMOFZxazZvc0EwRXdlT3AvcDBIRlhwYkM3dXVvaVU2cE9Z?=
 =?utf-8?B?MWV3NGJZRWNGT1RZdWpYQjU5eEE3dmpFdEtPZFIwRXhrdjVLSnNaS0ZRRTNw?=
 =?utf-8?B?RWFCMUZicHowUnMzOWdZZEVvOCswYzA4NTJzRTN4T3Q5OFU3U2xlM3BlWXNO?=
 =?utf-8?B?T2k4eU45cTgrSW1SNTJxZWdpclg5NXJuSTR6VStveVJIQUpQenplMGlLT0Qv?=
 =?utf-8?B?UDgwWit0L3FobEw2QmI5bFZwRTNiMFFFVC9DSFYyMXkreExjQzdKSE5OQmNU?=
 =?utf-8?B?K3dySDFJTTNnOXdWbG9UWjdJQVBXekxNeHl3UjdFVjBCZmgzNGh4N1pTQW5B?=
 =?utf-8?B?QXNMR05HNG1WUDd3NlpQMzNPdVpKR3lMWHRwcXo2Qk5sMXdaQVpwUlFwVVgx?=
 =?utf-8?B?MTZQK04wSW1kRExUV29kZlErNWVGVWV1dG1kdjBQWkpSb3ZocjZ5aEVkY2Fn?=
 =?utf-8?B?blgvVDNla3ZKcWhlWHQvbmx0ZkFheWhGVEVLeHAwcHVEbkl0cUpHY2hOZUQ4?=
 =?utf-8?B?eC9VUXFxMnVBN2lOZXdwVXJUT0FiUjRyY2w0K2YxTEJtRE5ROWtOcFkyZEw4?=
 =?utf-8?B?L2hXSzNmRzIyNEw4M28wQWFEdUtvVldUZXJMOWZHSDIxMGtiVFNxNThSekht?=
 =?utf-8?B?Q2tCQmJXdHgyaElwY0xsRTZaRXRWdCtRYXdTMWZWTHMzY2l3TEdFWll0THNE?=
 =?utf-8?B?T2JVTUdvbGhYMzl1b2VFajg5ck5FblJud0VBc3hmc0gxUjhndCs1Z2lTTW5u?=
 =?utf-8?B?Q1d4aWN2ZlRaZm11c2d3c3JoU1JlRkJRL3hqOTI4Nk4xQjlrNE5rOGZVRnEz?=
 =?utf-8?Q?iGAfhYlmzx3A9jbLSC2BnYkHK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C74DEEF74D2F4847BB1327957C5AC43A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beddb7dd-1ab5-4d0e-5d17-08da86a806b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 14:42:25.0726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MrwKfhlKl9G6i6+8Fyw7Kl4bBN6cJgx45eX3dT7Qu8jyCcvGA7RDA6wnORa6miYwKb7MNLIdkInt7JwA0C9aUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3684
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA4LTIzIGF0IDIyOjE4IC0wNzAwLCBKb2huIEZhc3RhYmVuZCB3cm90ZToN
Cj4gTWF4aW0gTWlraXR5YW5za2l5IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyMi0wOC0yMyBhdCAx
MzoyNCArMDIwMCwgTWFjaWVqIEZpamFsa293c2tpIHdyb3RlOg0KPiA+ID4gT24gVHVlLCBBdWcg
MjMsIDIwMjIgYXQgMDk6NDk6NDNBTSArMDAwMCwgTWF4aW0gTWlraXR5YW5za2l5IHdyb3RlOg0K
PiA+ID4gPiBBbnlvbmUgZnJvbSBJbnRlbD8gTWFjaWVqLCBCasO2cm4sIE1hZ251cz8NCj4gPiA+
IA0KPiA+ID4gSGV5IE1heGltLA0KPiA+ID4gDQo+ID4gPiBob3cgYWJvdXQga2VlcGluZyBpdCBz
aW1wbGUgYW5kIGdvaW5nIHdpdGggb3B0aW9uIDE/IFRoaXMgYmVoYXZpb3Igd2FzDQo+ID4gPiBl
dmVuIHByb3Bvc2VkIGluIHRoZSB2MSBzdWJtaXNzaW9uIG9mIHRoZSBwYXRjaCBzZXQgd2UncmUg
dGFsa2luZyBhYm91dC4NCj4gPiANCj4gPiBZZWFoLCBJIGtub3cgaXQgd2FzIHRoZSBiZWhhdmlv
ciBpbiB2MS4gSXQgd2FzIG1lIHdobyBzdWdnZXN0ZWQgbm90DQo+ID4gZHJvcHBpbmcgdGhhdCBw
YWNrZXQsIGFuZCBJIGRpZG4ndCByZWFsaXplIGJhY2sgdGhlbiB0aGF0IGl0IGhhZCB0aGlzDQo+
ID4gdW5kZXNpcmVkIHNpZGUgZWZmZWN0IC0gc29ycnkgZm9yIHRoYXQhDQo+IA0KPiBKdXN0IHdh
bnQgdG8gcmVpdGVyYXRlIHdoYXQgd2FzIHNhaWQgb3JpZ2luYWxseSwgeW91J2xsIGRlZmluYXRl
bHkgY29uZnVzZQ0KPiBvdXIgWERQIHByb2dyYW1zIGlmIHRoZXkgZXZlciBzYXcgdGhlIHNhbWUg
cGt0IHR3aWNlLiBJdCB3b3VsZCBjb25mdXNlDQo+IG1ldHJpY3MgYW5kIGFueSAidGFwIiBhbmQg
c28gb24uDQo+IA0KPiA+IA0KPiA+IE9wdGlvbiAxIHNvdW5kcyBnb29kIHRvIG1lIGFzIHRoZSBm
aXJzdCByZW1lZHksIHdlIGNhbiBzdGFydCB3aXRoIHRoYXQuDQo+ID4gDQo+ID4gSG93ZXZlciwg
aXQncyBub3QgcGVyZmVjdDogd2hlbiBOQVBJIGFuZCB0aGUgYXBwbGljYXRpb24gYXJlIHBpbm5l
ZCB0bw0KPiA+IHRoZSBzYW1lIGNvcmUsIGlmIHRoZSBmaWxsIHJpbmcgaXMgYmlnZ2VyIHRoYW4g
dGhlIFJYIHJpbmcgKHdoaWNoIG1ha2VzDQo+ID4gc2Vuc2UgaW4gY2FzZSBvZiBtdWx0aXBsZSBz
b2NrZXRzIG9uIHRoZSBzYW1lIFVNRU0pLCB0aGUgZHJpdmVyIHdpbGwNCj4gPiBjb25zdGFudGx5
IGdldCBpbnRvIHRoaXMgY29uZGl0aW9uLCBkcm9wIG9uZSBwYWNrZXQsIHlpZWxkIHRvDQo+ID4g
dXNlcnNwYWNlLCB0aGUgYXBwbGljYXRpb24gd2lsbCBvZiBjb3Vyc2UgY2xlYW4gdXAgdGhlIFJY
IHJpbmcsIGJ1dA0KPiA+IHRoZW4gdGhlIHByb2Nlc3Mgd2lsbCByZXBlYXQuDQo+IA0KPiBNYXli
ZSBkdW1iIHF1ZXN0aW9uIGhhdmVuJ3QgZm9sbG93ZWQgdGhlIGVudGlyZSB0aHJlYWQgb3IgYXQg
bGVhc3QNCj4gZG9uJ3QgcmVjYWxsIGl0LiBDb3VsZCB5b3UgeWllbGQgd2hlbiB5b3UgaGl0IGEg
aGlnaCB3YXRlciBtYXJrIGF0DQo+IHNvbWUgcG9pbnQgYmVmb3JlIHBrdCBkcm9wPw0KDQpUaGF0
IHdvdWxkIGJlIGFuIGlkZWFsIHNvbHV0aW9uLCBidXQgaXQgZG9lc24ndCBzb3VuZCBmZWFzaWJs
ZSB0byBtZS4NClRoZXJlIG1heSBiZSBtdWx0aXBsZSBYU0sgc29ja2V0cyBvbiB0aGUgc2FtZSBS
WCBxdWV1ZSwgYW5kIGVhY2ggc29ja2V0DQpoYXMgaXRzIG93biBSWCByaW5nLCB3aGljaCBjYW4g
YmUgZnVsbCBvciBoYXZlIHNvbWUgc3BhY2UuIFdlIGRvbid0DQprbm93IGluIGFkdmFuY2Ugd2hp
Y2ggUlggcmluZyB3aWxsIGJlIGNob3NlbiBieSB0aGUgWERQIHByb2dyYW0gKGlmIGFueQ0KYXQg
YWxsOyB0aGUgWERQIHByb2dyYW0gY2FuIHN0aWxsIGRyb3AsIHBhc3Mgb3IgcmV0cmFuc21pdCB0
aGUgcGFja2V0KSwNCnNvIHdlIGNhbid0IGNoZWNrIHRoZSB3YXRlcm1hcmsgb24gYSBzcGVjaWZp
YyByaW5nIGJlZm9yZSBydW5uaW5nIFhEUC4NCg0KSXQgbWF5IGJlIHBvc3NpYmxlIHRvIGl0ZXJh
dGUgb3ZlciBhbGwgc29ja2V0cyBhbmQgc3RvcCB0aGUgcHJvY2Vzc2luZw0KaWYgYW55IHNvY2tl
dCdzIFJYIHJpbmcgaXMgZnVsbCwgYnV0IHRoYXQgd291bGQgYmUgYSBoZWF2eSB0aGluZyB0byBk
bw0KcGVyIHBhY2tldC4gSXQgc2hvdWxkIGJlIHBvc3NpYmxlIHRvIG9wdGltaXplIGl0IHRvIHJ1
biBvbmNlIHBlciBOQVBJDQpjeWNsZSwgY2hlY2tpbmcgdGhhdCBlYWNoIFJYIHJpbmcgaGFzIGVu
b3VnaCBzcGFjZSB0byBmaXQgdGhlIHdob2xlDQpOQVBJIGJ1ZGdldCwgYnV0IEknbSBzdGlsbCBu
b3Qgc3VyZSBvZiBwZXJmb3JtYW5jZSBpbXBsaWNhdGlvbnMsIGFuZCBpdA0Kc291bmRzIG92ZXJs
eSBwcm90ZWN0aXZlLg0KDQo+IA0KPiA+IA0KPiA+IFRoYXQgbWVhbnMsIHdlJ2xsIGFsd2F5cyBo
YXZlIGEgc21hbGwgcGVyY2VudGFnZSBvZiBwYWNrZXRzIGRyb3BwZWQsDQo+ID4gd2hpY2ggbWF5
IHRyaWdnZXIgdGhlIGNvbmdlc3Rpb24gY29udHJvbCBhbGdvcml0aG1zIG9uIHRoZSBvdGhlciBz
aWRlLA0KPiA+IHNsb3dpbmcgZG93biB0aGUgVFggdG8gdW5hY2NlcHRhYmxlIHNwZWVkcyAoYmVj
YXVzZSBwYWNrZXQgZHJvcHMgd29uJ3QNCj4gPiBkaXNhcHBlYXIgYWZ0ZXIgc2xvd2luZyBkb3du
IGp1c3QgYSBsaXR0bGUpLg0KPiA+IA0KPiA+IEdpdmVuIHRoZSBhYm92ZSwgd2UgbWF5IG5lZWQg
YSBtb3JlIGNvbXBsZXggc29sdXRpb24gZm9yIHRoZSBsb25nIHRlcm0uDQo+ID4gV2hhdCBkbyB5
b3UgdGhpbms/DQo+ID4gDQo+ID4gQWxzbywgaWYgdGhlIGFwcGxpY2F0aW9uIHVzZXMgcG9sbCgp
LCB0aGlzIHdob2xlIGxvZ2ljIChlaXRoZXIgdjEgb3INCj4gPiB2Mikgc2VlbXMgbm90IG5lZWRl
ZCwgYmVjYXVzZSBwb2xsKCkgcmV0dXJucyB0byB0aGUgYXBwbGljYXRpb24gd2hlbg0KPiA+IHNv
bWV0aGluZyBiZWNvbWVzIGF2YWlsYWJsZSBpbiB0aGUgUlggcmluZywgYnV0IEkgZ3Vlc3MgdGhl
IHJlYXNvbiBmb3INCj4gPiBhZGRpbmcgaXQgd2FzIHRoYXQgZmFudGFzdGljIDc4JSBwZXJmb3Jt
YW5jZSBpbXByb3ZlbWVudCBtZW50aW9uZWQgaW4NCj4gPiB0aGUgY292ZXIgbGV0dGVyPw0KDQo=
