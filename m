Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237BB69AE0B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjBQO3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQO3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:29:13 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707CE53EF4;
        Fri, 17 Feb 2023 06:29:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNM2rwufJy5Grcn6IFa1kCbq2zrexbkJUnq2MutQVUzyAsPCr9Wzcdn/MsvY879zd9LxmH9I9OZWbyI0SqDmbOMFHBHnZR9EXaozuwCXOTE3GCKXzvl89P280Nu9CErvLDOpDcqfU9gCVbnp5pvsGgvNIluZcwjtMfPcS2kxPwJKLmGzGp5fdqCHySuvyl0NABZITmF7Bu5N7n0IUsqYaLN39Qgc+3aBWLVPafNMbTA9u6ZDUwTu/YST3CNFjgp0B0jtvJ8m6/ptOnA0kIgaGuhck66ck53yoRQVCpchB1+aWBa5HlvPe6ro2Xh+3SsjArQx4QJjpwqBv9GnTATOkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kwUHLPUmGx5WjbZyQcolKXhl0He3s1BwD3K/vSGYsdk=;
 b=Qrd0/zY0ic7eeYHhIt+TtGr5Oy37hdoiM+OlSZZlVmJcoC4DuPlUUO0sdgVyGaVa6D28LormrFYeYxTDTVATbSRinSLA1Y73IVVU3OQbKgHMn61ZYYZgfW9Ah5IB6QaJtZC50LxnbWb+WaT9OXXmvyVy7Fe70YBiAjwFyerEUyZ2AClrBmJxyuGdvHy+hsxW/Wfi5rMcjzpiN5FFK+BH8/vk3ZH7RtbjTrvJYakB/xZWrGC2yE1e13SyxaxGNXyZkFjHnXxfwuoLOay0yfmU8Gf9JvpsYy9ljYw9NGPjn3oqV9Kfa3wgBJbTHCLANKvVJy31t2Iiog35RlA74k4YPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwUHLPUmGx5WjbZyQcolKXhl0He3s1BwD3K/vSGYsdk=;
 b=ha5sWCOhtmeXHFX7Smq/w/AIv/O2oieIPbNLJHbi2B4pKr7iwy2Y/2YEYjmQ4YWY+vUlKk2wPMLw6ktmyJ6wxCiR4cFOjTO/uClHNTluPdEu2A3KEpIkRVPvNL1IONST1GLoxab9J6DFyjLH4LhNdCeHvf+SNRHkS+hR3nNINT0=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by PH8PR12MB6724.namprd12.prod.outlook.com (2603:10b6:510:1cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 14:29:07 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%7]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 14:29:07 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Colin Ian King <colin.i.king@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] sfc: Fix spelling mistake "creationg" -> "creating"
Thread-Topic: [PATCH][next] sfc: Fix spelling mistake "creationg" ->
 "creating"
Thread-Index: AQHZQrHUINR7pGfQW0efR1Hx/nThj67TMsOA
Date:   Fri, 17 Feb 2023 14:29:07 +0000
Message-ID: <DM6PR12MB42023DB0BCF889AE31D0A72AC1A19@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230217092528.576105-1-colin.i.king@gmail.com>
In-Reply-To: <20230217092528.576105-1-colin.i.king@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4314.namprd12.prod.outlook.com
 (15.20.6086.011)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|PH8PR12MB6724:EE_
x-ms-office365-filtering-correlation-id: a6038794-5594-4cd0-a4e8-08db10f353da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3DzfM9PCqBMAINvgKHAxW4X/r0F818mprW9dwr6tvHEsfRQSIGuOdAq8qns/04dpg5+Yo3AnqEx00bGBXivq+LWHr5gFfSFxok3J1Lqeu+rRS6tqX4fuyXr7SdWlgs2oTTFr+7cIG+iiTjtF3UVendU5XSv8ykuTsYMyjOS/jUDuvXQr0ee/IhJM13yckRExs4KYvDydX0UZXP/TiPH4gAUyFwfUt+PI+B2/SnzW4GmoBxek5r0i/mIQX/A5mKwWY79PvmJ2p4Mfl+uUcoXqpWEgEHqPg5/FnTSQZLMh1Kk57eiY2uu+3CMlt+VrMmqtjqNMtGa4k11WevoTQyERVpCNEU/QFWoe+6X+KAve+0x3rDNkSSdR9mR3U1g0xNQmehCLWQcvu7gp/ex+MAhmR920a2ontX/8aFoDvahlATj3Nx2Ac1nSW6bpLueBsIdlizZFcv7nfPl4rNqu2RznrIHNTryAmW1sgmjzdERVGc1duXhDoVUVQDk+9M/+HBhhFtl179iJqrRDxnRBeuoVdSBYZkXVKIMtV1F8r71v41DEP2rc7eGNBw/J6VVpUPIzqAO2xz2+uMLYYe3dSfsmtMYDf48axtnkZxae74B8ThN0sUy+XGW4yukkbj/d1Q3X4xDKy/fg5d28OjUIuNGICc4SBbUcCGNuKE1xVwXZ0IPyy2gTV9em7W4KP8xhjNtcUpYVB8VmgcIeML5HzTrzQVUDS5JjYQh4W7Jj8gB93fyFXVXV8ZwqBEim+MzTtuEL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(451199018)(76116006)(66946007)(110136005)(316002)(54906003)(66556008)(66446008)(2906002)(55016003)(64756008)(41300700001)(4326008)(8676002)(66476007)(5660300002)(7416002)(8936002)(52536014)(53546011)(33656002)(83380400001)(38100700002)(122000001)(71200400001)(478600001)(9686003)(6506007)(7696005)(26005)(38070700005)(186003)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTJ6VXJ2K2l4aDZYdGhkUE9GV3Z0cnNNOGV1bmJYNDZwTEZ0VTZRbyt1OEY1?=
 =?utf-8?B?NGQ2NytoT3E3clIrY1JrMVVYajMramllelJWK1VoaS8wVnNWV1VNV2VITnVT?=
 =?utf-8?B?S1JMaW5RaXIxTjRuWHdtYzVORzhPSG9yaE9LMCtFRG9LNWdobE5QYk5HYzcx?=
 =?utf-8?B?WC9TYlFCOE9mZkMwSXN6c29LRW91NUxrcXlDOXhBUldSU2lXTzRHbGZkaDdZ?=
 =?utf-8?B?MmJwZmt5OWsrV0M3TGFjRzhvTzVYb0pCaTB6Q2xyTk9MemlrUW11T3N0cGs4?=
 =?utf-8?B?d2g3M0Y0Z1UvQ0txWGY5WW1Kc0Y5cjFpZDRHUWd6ZUI3eDV3SnprTHZkc2g4?=
 =?utf-8?B?U3hsNS80NUl0bUU5NExUQkl1NDQ0OERBeXU5YmhZVFZGMWY0eGQ5L2xXejFn?=
 =?utf-8?B?NGRVMnl5cEg3UkRhU2plWnMya3lubWdxK2cxQlBKbjRQSU1hd1NTL1lFeERa?=
 =?utf-8?B?dUhOMnh5RzZoRk1TWG5yNUk0akxXV2owZTA5MGxrK2I5OHpQZHNxN0FTd2VK?=
 =?utf-8?B?Qit1M2FCeFZ4VGQ2dWFob1ExbStwZGFmemhIS1FwTWxkTFFKMHV0WDlEQnY4?=
 =?utf-8?B?NDRXeUd4Z05nd2pQano1Mllwa09mbFZ5QkZNemdaQTJVNk1Ka1VndXdUUWVC?=
 =?utf-8?B?UXZiR0dCWnh1Z0ZKNG8rWVBNUGVWYXEyK2dHWEhjMGxjU2tIeUk0K1RFTFp3?=
 =?utf-8?B?VDI4VWdrODR3bDc0WUI1OFVldGI1NWhRL1VNUi9pMzdMeFRvQTlpZkMrSVIv?=
 =?utf-8?B?bXFPRkNiNExOZXhIZ3gvNE9sYXFRUE5TYkFNSXBXQjA5YnVUUkNvT1hlbzRl?=
 =?utf-8?B?YkdvWi84d1J5cTR2Y3ZaWGJFTnRxSEZjQkw5blB5K0JVb3FPTGc3WlRSZFUz?=
 =?utf-8?B?a0tSVE9mc0NqZm9TT3hRSHFSMk0rTGdaa093YmFBSStsNk43ZExLaHZwUDh0?=
 =?utf-8?B?RURYcXphcU9MZW8wTisyTlNEdnpuOWduRzZRY01DWHE4dUUyK0tKN1EvclU1?=
 =?utf-8?B?bmozWlo5NCtEdUtGOC9mZDVURTAzWVhGdHcwZ0pIUFM0THJVWEoyWTl1MGVM?=
 =?utf-8?B?aFVaN2pRY0twQ25rRnhZSHpuTjdpSVdNcTY1SENYWCt1d2prWVJ5dnJWaHlZ?=
 =?utf-8?B?RGtkUU5MNDRnRW1BTHVucFFjYzlHRjJIZnI0UVdVcDJLU09oSVVHa3k2cm50?=
 =?utf-8?B?ditBekQyRTNkbEEwVE16VHRCU2JtNFQ2WFRWNHdmY0d4bEhhcDlnUytIdzE2?=
 =?utf-8?B?QTR4Z3p3UzlXcmIrWVk5TGErTUVaQjA5LzNnQWtQanpMbEQzUkxJa0V3enpC?=
 =?utf-8?B?VU81R2hvN1NiQlVqcnVJSk9rVlM3OEZIMERIRklDcXJFNlNFZTRNekdlN2d6?=
 =?utf-8?B?TU1vMjAra2x4ejAvZTRJVWdBQW0ra284RmI3UG1Da1g3UjVNeG1VUnBDU2tl?=
 =?utf-8?B?VUZrcHhmRjNUL2dtbDVINmYzTXlKdzkvSE9pRUducWRuenFaMFZuT3BBMjlW?=
 =?utf-8?B?NnRldGYvMWMwVnpjSEpXVUJOWTg2VFR0dHBubEw5VzZ0dTdvZDFHU1Jhakpj?=
 =?utf-8?B?dllsQktyZFpLLytaUEhRQldXRmlMRGRjWG1RdXpiY3JvdVlMSGE2a1VyY2Ir?=
 =?utf-8?B?MStXbmlaNkRURUM2U3l5L0p4a3dudmQwQUM0Mi9VZW5qWHNsWFJkNTZEM1Ir?=
 =?utf-8?B?eFhWOUw4cXdUNUs5bFUyQ0hMdmtKMlg2cmZGdDNvcnM0VTVRYzR4RHMva0xX?=
 =?utf-8?B?R1QzL2JKY2M1clpVK3BUQXcrdkEwcnk5L0NUMXM5a0VFd1FtcWp2OXpsb2pW?=
 =?utf-8?B?YlpXUDV2bTFUeFFxcFg0c0pWdHRrVTRHMEpwVG5jTjIyQnM4VTVWdmUxTFUx?=
 =?utf-8?B?YmxsbnZKbHFQYS9xRDZZUHdzd1RIdzdBTUY4YUQxUmhaQ3ZTOTRWM09qcnAw?=
 =?utf-8?B?Q0loaEk5cUxodElxS3lRU3dKRklyTHN1RC84NkxDMytsdlRFbjd2WHRHTzVz?=
 =?utf-8?B?dGhsMm5CRE9HR1RMSWdlbVExMExXY0VJc05YeXdOd1dCaDRiT2o4N2VrTXJ0?=
 =?utf-8?B?YXRsQWlrMHl2bzJkRWVUcEl3V1A0WXU4bzlWNDZHa09sU3JrNW8vVEpTM2FJ?=
 =?utf-8?Q?jkpY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A709443828CC54BB7C95CCE93099307@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6038794-5594-4cd0-a4e8-08db10f353da
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 14:29:07.2367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eWVbxzaBzxsyZgie24YL5ayxy4QeFrAOfnsUhX+k6WmcnN9sXzH5LLfX7y541rUpkRCMMhKE8UjxsiqozabMMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6724
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzE3LzIzIDA5OjI1LCBDb2xpbiBJYW4gS2luZyB3cm90ZToNCj4gQ0FVVElPTjogVGhp
cyBtZXNzYWdlIGhhcyBvcmlnaW5hdGVkIGZyb20gYW4gRXh0ZXJuYWwgU291cmNlLiBQbGVhc2Ug
dXNlIHByb3BlciBqdWRnbWVudCBhbmQgY2F1dGlvbiB3aGVuIG9wZW5pbmcgYXR0YWNobWVudHMs
IGNsaWNraW5nIGxpbmtzLCBvciByZXNwb25kaW5nIHRvIHRoaXMgZW1haWwuDQo+DQo+DQo+IFRo
ZXJlIGlzIGEgc3BlbGxpbmcgbWlzdGFrZSBpbiBhIHBjaV93YXJuIG1lc3NhZ2UuIEZpeCBpdC4N
Cj4NCj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmkua2luZ0BnbWFpbC5j
b20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhfZGV2bGluay5jIHwg
MiArLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0K
Pg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmeF9kZXZsaW5rLmMg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYw0KPiBpbmRleCBkMmViNjcx
MmJhMzUuLjUyZmUyYjI2NThmMyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
c2ZjL2VmeF9kZXZsaW5rLmNBbGVqYW5kcm8gTHVjZXJvPGFsZWphbmRyby5sdWNlcm8tcGFsYXVA
YW1kLmNvbT4NCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmeF9kZXZsaW5rLmMN
Cj4gQEAgLTY1NSw3ICs2NTUsNyBAQCBzdGF0aWMgc3RydWN0IGRldmxpbmtfcG9ydCAqZWYxMDBf
c2V0X2RldmxpbmtfcG9ydChzdHJ1Y3QgZWZ4X25pYyAqZWZ4LCB1MzIgaWR4KQ0KPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgImRldmxpbmsgcG9ydCBjcmVhdGlvbiBmb3IgUEYg
ZmFpbGVkLlxuIik7DQo+ICAgICAgICAgICAgICAgICAgZWxzZQ0KPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgcGNpX3dhcm4oZWZ4LT5wY2lfZGV2LA0KPiAtICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAiZGV2bGlua19wb3J0IGNyZWF0aW9uZyBmb3IgVkYgJXUgZmFpbGVkLlxuIiwN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgImRldmxpbmtfcG9ydCBjcmVhdGlv
biBmb3IgVkYgJXUgZmFpbGVkLlxuIiwNCg0KVGhlIHBhdGNoIHN1YmplY3QgZG9lcyBub3QgbWF0
Y2ggdGhlIGNoYW5nZWQgd29yZC4gQ3JlYXRpb24gaXMgdGhlIA0KcmlnaHQgb25lLg0KDQpJZiB5
b3UgZml4IGl0IHlvdSBjYW4gYWRkOg0KDQpSZXZpZXdlZC1ieTrCoCBBbGVqYW5kcm8gTHVjZXJv
IDxhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20+DQoNCj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGlkeCk7DQo+ICAgICAgICAgICAgICAgICAgcmV0dXJuIE5VTEw7DQo+
ICAgICAgICAgIH0NCj4gLS0NCj4gMi4zMC4yDQo+DQo=
