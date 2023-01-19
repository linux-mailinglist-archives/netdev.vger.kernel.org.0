Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B1A674271
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjASTMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjASTLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:11:44 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146DF5F3B4
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 11:11:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhJrh2Zep8t+wN3lranD+BvdxJufbU6yAAZ890/nZS2C2AIW9KE9Lw0uV7Vf6/rX0EKhhLKoIIKG0WEMyDc6BWRjbjfCyihcSkOL0xnXb5lvnWUP0lJneWuZMjJPuiEyTVVRN7T9dcgLZPMWb9UkGpS4vC0rk074mIWy4NOGEWWqpiXrwo4dKgFU1m5mgFwFBnd1uUpp44Y6ZsSrTt0uvqtzuI6zcWrtxS8ZSclf/C1G1KNFemhyhIHImzMbS2BN2KRLjduG7mwUVLsQ6M3ePyCleYCQC9sXcXwVawHhcHsk9r1gymtP3h6h77DHvdIJD/SbbEIa/SM1ifXwULPXLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLYgVZIOge+tS1Oz+xQkrt2VdXnVIw5E1aUAiBGQTds=;
 b=eqZOvNyrjUWusEQ0/NR1eP3gnYSjRd15EDyaji11l/fbZkBsjqVp9Cwy/cc3RcTDyOan8xI3XzJZtBR6XS8FdROh2Bs3UijIp9qFpvRXMeGTGCB7gj2hNnB30JOjlLfDwri9w+UrXqN9brB0zmAyerGTTzq85EHn8gEc2YR1gCYUklhJ7sMIj0NnVYKQKq0lQYdXL/ATPfWOC1WkwRd9J2rmsZlKi9KuaODe6GfzKYncjntfvrnxJXlgmttqDq9stenevYZAHuXDmcR3uK+C1Y4B24C63zX9kMWXeo8kw7ueFgWJ8HaKEzp5nAH1SUUEQryyzl6k+sfZUYStkPZMjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLYgVZIOge+tS1Oz+xQkrt2VdXnVIw5E1aUAiBGQTds=;
 b=W8lY830nYQcjS+niqxeJE31XD6YlLfPoZCOk3KoyD1n4/JMxeGonR7z6ZRIkleGmzA/UgbYJ2mwY8rJbqPu7VDG+dUj4EhJGa7OjVhR01gOIUF0p1/snI2CrL7HBU8g4fu23EDT0TLFdY89fmP3YEwgkGKhBpNFEkLzfZ9Z66UY=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by MN2PR12MB4207.namprd12.prod.outlook.com (2603:10b6:208:1d9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 19:08:23 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%7]) with mapi id 15.20.6002.026; Thu, 19 Jan 2023
 19:08:22 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 1/7] sfc: add devlink support for ef100
Thread-Topic: [PATCH net-next 1/7] sfc: add devlink support for ef100
Thread-Index: AQHZK/m3dRrScZP960COfMprLSU9Pa6l+3oAgAAKC4CAAA6kgIAABqSA
Date:   Thu, 19 Jan 2023 19:08:22 +0000
Message-ID: <d04946bc-765e-e9dd-22f3-69be77a7439b@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-2-alejandro.lucero-palau@amd.com>
 <20230119091606.2ee5a807@kernel.org>
 <82a57ba1-bd28-3742-0027-a6a284569aee@amd.com>
 <20230119104427.69d95782@kernel.org>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.53.21091200
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|MN2PR12MB4207:EE_
x-ms-office365-filtering-correlation-id: fca08c7d-f13e-44a3-c85c-08dafa5088f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m9eWRZ4jhGJuXuPHSAlWb8eUac28JkHisXy+vPkOOq7zXR2Kc0LGKWAX4DzhL/shgdNG1wK7WlsISiFyuChjL1/857ZAnjya9qcsopUbqQHxNFduLvw33UhIuSqT1IKeIcuf9YJ7C6r9avlUefBvLWwgh6HVrdVvjd+YpHbyWL6w4EfiGk3MGGJRMOrfyFI7zebKJLy7wwyp1egP/kL3h0htYIaSzCghDvU5vbz8wr3STBsQeExqBMx2c8XoNVQeW+4MfSGV79wtJBrKgkn3he/nuhGqK+cda4zbpesR8AZ5kdcdmZIrzrilha9hc8LVxf47i7U8UoYvKXa7iIJ/xnJdZNqXMWfwSQKVnixQ5aDY6lM9aHDx/KEACn2TiweHwVWXk+3PZZamuHLly70LttO2FqmNBb/bfvskjxgM14KRcnnhqY7qoeuCtNFLJ4s1tY6q6+GUTIqQgmyb4ftn0KunNcMRdM+LNmas9EsSHfxku2McgCohaMMkXg0VrVPThGHHDLfLOfFKkXat9ua7XGhftt2kaRZrI4LbIOBDKp4pOpYtrqcEdEHwta7ILc7yiB1lFmTvgev6/Hd9Tk/QfJ+HJkKSAkA/yBoxq0MjZG7V3SNYTL+4AAqYy2oSGA6i1ZXGWGN71AYq5jIphdPX7fACi1Zz7/Bx3vJa5LyHk7/VfoYnEV0cHOq113Z4jux72s2WSDSE6/ZlavuX1MP32KTk93/5a+qAH9rV70DadEM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199015)(31686004)(86362001)(26005)(38070700005)(31696002)(41300700001)(5660300002)(8936002)(38100700002)(122000001)(36756003)(6486002)(186003)(71200400001)(110136005)(54906003)(53546011)(83380400001)(6506007)(6512007)(478600001)(8676002)(91956017)(4326008)(66946007)(316002)(64756008)(76116006)(66446008)(66556008)(66476007)(2906002)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ay9SSThUUkxIRWd4dXZNRmxvSjJzNW5UQ3lkMzI3eDFhb2dua3A5UWEzRGVY?=
 =?utf-8?B?UnNxb2lVZWZRU2J3djVtNEkwZ2pQR0haM3JjTkdiTTNFQzFkRnlWamovV0NK?=
 =?utf-8?B?NTZpVXlPOFlDYkVYWkpNaURPSXRCQlp5QnpqbFR3QmhYazlFcmM3YmFhNmxP?=
 =?utf-8?B?d3g5ay9kSGwxL1VZUnp6Tmk5ZUpsamg2L1pIQVAvNWdDL0YxSFhibGNCZ21o?=
 =?utf-8?B?aTJLazFCRmRpRTBUbERZcFRWOUF0MXA3dnlZem1JT1NnTk1qRjYzZkVGbUlE?=
 =?utf-8?B?STdKWHQ1SStpSXFPYndZU2Myb0tTazV5VjJERXUrbmVTZUxmOUw4bno0Mjhw?=
 =?utf-8?B?VHlpZ1ZCN3VOL0pDbm5GM0VvdEFRMlE2RGdoWS9MOHgrZ1Bna3BIakJ2NWRG?=
 =?utf-8?B?aVdTaFFJUWVpMW9mTENPUDZ6SzAwaVBscGpzY1BtbWtWRXhvRzlEWWIydkN0?=
 =?utf-8?B?WTZwVTdKazVHLzRQcjlSNlFyUGtjNEx4QjZZa2JTclhCOHU2bTZQN3FnWWtR?=
 =?utf-8?B?bk1IRmlsMEEyWXZNdDlBdXE1c0xZRGJ3ZDc5THRhSlF3WStBSDlqVnBQSlRo?=
 =?utf-8?B?QnVHOVg4R3Q2a05aem4zbitnVm4zeXVvVEVjczcyQ1ZPMjZZOXBNMXZNQTQ1?=
 =?utf-8?B?bmIzQjVRYlNHSG0vd2JqMHpYUW1ZWHBpbGVWR0FzMzhscFRFeGVxaXRORjVG?=
 =?utf-8?B?V1NoUllrWGsxdUNKVjBibVkxZ09oWDdpRlZYekgyamNpMmF3dGwzenFyNEli?=
 =?utf-8?B?VFhjcTBNcW5mZUdRSUZ3RGhqc2tNQ2FOTG9TNEtNcFc5TjhlVXc4MWl3SjRF?=
 =?utf-8?B?UVNLZGY3N0dTcGsxTjVTZ2VCOHcyK1NZR1lxTVVITzRCZ2NQNVF4SmVDSEU0?=
 =?utf-8?B?dmtrWnFZS3BUK0lySkpsRjI2VDY5V2Q4cjdyd0IrY09HVWhLRU5PMEUxQ1ZC?=
 =?utf-8?B?dkdhVHVwMWZPNWJSeWVrOGZEd3dHVzM0SzJZYS9sZysxWWxQbmtVbXovKzNo?=
 =?utf-8?B?WmQ5Z2trRHErN2VDVWJnSTQrS3VKQ3N3RXUyZGJPaWtnMnp6R2E2OHgzN2Yz?=
 =?utf-8?B?c1VWQTVhU3dJekZ5Z1pYRm9DWGFOZ1J3YWg1ekNNbm1Cc1VOdFVhd1ArV1JD?=
 =?utf-8?B?ZGlGeXdjNWV1TWJYM0NNZDloVjlIcDl4ZXlka0NEUzcvNnkrazQ1WmNpaHk2?=
 =?utf-8?B?OGlxUmFWRVhCaDNscXhDRGtYdnNldDY5VE1IRGZkMUxxMjA2L0cvellkek1G?=
 =?utf-8?B?aWR2MGQ4b2VSeXdzNEtQcDdvSTlkOE1ZRmVVMlV2OFc1c21LaDlINFRpeFF0?=
 =?utf-8?B?ZnZQU2ZRdFhkWlVSWVI3azZ4MHNRUi82bFlKbUxDNURUbkJyNEppcEV6VGlL?=
 =?utf-8?B?UktjWFlRVklqWG0yYkt1TWF0ZFlueUIxU014QUVwK3Jod2Q1dUVUNmZna3lz?=
 =?utf-8?B?ODVLcHJ0dW45QjBZclZ2NkNJZWJWS0hsT0RYTVZRQ0JIQ3ZNSDU5aU1lcGRx?=
 =?utf-8?B?UlhOdWdLcmEwOXJvZ2FDcm5pVmV5ait4T3V2anR0alhjZ2JUcFZxWUZSQUdt?=
 =?utf-8?B?eXQzQk9MVy8yczFUTGFRNDFMUEo0eUFOdUYySXJyWVZqOGN0NXgxN3RVNDZ6?=
 =?utf-8?B?UE9xQlhBdnBwanczQ1dubktTbVhYeTcxTzVvSUtFSE4vWSs0MjlTYVlRWko3?=
 =?utf-8?B?WS9RVm0vM08zN0hoc2kvSk9vMW5tQWtCR1dieTUyazRqMkk2ODJJLzBzWlpE?=
 =?utf-8?B?VnU3MlgzZjJBTkNoV1F1Z01Ic1U2UHV1Nmpzekd6LzM4dG1naFR3VXJMaTZT?=
 =?utf-8?B?aWlKK2VOL21tekduc3IyMExhQkZ4Q3NnYk9vczYyZ2xScDdkM3dwR3VTRUEr?=
 =?utf-8?B?VXJIRmlmTDRlSkxsZlFaclhFTEFVR3NGcS9jRUV5ZmRNTGo2am9iVFJsR1N1?=
 =?utf-8?B?WGg2bGhzSEJaV1BreWk3WHcxQ1lRZGFaaFpSb0JWUlF2ekNvY3Fxa09yYXZ6?=
 =?utf-8?B?bjQ2Sy8vTUR1Q1FJMjlpNmtPWjFPaHBqY2dGeTdsNmFrczN5bVlkYnI4OEp4?=
 =?utf-8?B?eDVwckNBTFRJckVtUEtuNUVoL2tyZXl0YlZDSndzZjIwNUc2MkZRdjhGTWVr?=
 =?utf-8?Q?8vLhkDZbQVTw56CPcsNAaXmZR?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5425E2573096140A80756735878C69A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fca08c7d-f13e-44a3-c85c-08dafa5088f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 19:08:22.8130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EseSQ6kWSUTNCVJD2GNyTYpzo0TIUKtNfUYsK0lmwsa5HSvvNhg/RJM/BKT/EKXdKPUwCQQoGSZHS8Kp+T1XAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4207
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzE5LzIzIDE4OjQ0LCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gVGh1LCAxOSBK
YW4gMjAyMyAxNzo1Mjo0MiArMDAwMCBMdWNlcm8gUGFsYXUsIEFsZWphbmRybyB3cm90ZToNCj4+
IE9uIDEvMTkvMjMgMTc6MTYsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPj4+IE9uIFRodSwgMTkg
SmFuIDIwMjMgMTE6MzE6MzQgKzAwMDAgYWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQuY29tIHdy
b3RlOg0KPj4+PiArCQlkZXZsaW5rX3VucmVnaXN0ZXIoZWZ4LT5kZXZsaW5rKTsNCj4+Pj4gKwkJ
ZGV2bGlua19mcmVlKGVmeC0+ZGV2bGluayk7DQo+Pj4gUGxlYXNlIHVzZSB0aGUgZGV2bF8gQVBJ
cyBhbmQgdGFrZSB0aGUgZGV2bF9sb2NrKCkgZXhwbGljaXRseS4NCj4+PiBPbmNlIHlvdSBzdGFy
dCBhZGRpbmcgc3ViLW9iamVjdHMgdGhlIEFQSSB3aXRoIGltcGxpY2l0IGxvY2tpbmcNCj4+PiBn
ZXRzIHJhY3kuDQo+PiBJIG5lZWQgbW9yZSBoZWxwIGhlcmUuDQo+Pg0KPj4gVGhlIGV4cGxpY2l0
IGxvY2tpbmcgeW91IHJlZmVyIHRvLCBpcyBpdCBmb3IgdGhpcyBzcGVjaWZpYyBjb2RlIG9ubHk/
DQo+IEkgb25seSBoYWQgYSBxdWljayBsb29rIGF0IHRoZSBzZXJpZXMsIGJ1dCBJIHNhdyB5b3Ug
YWRkIHBvcnRzLg0KPiBTbyB0aGUgbG9ja2luZyBzaG91bGQgYmUgc29tZXRoaW5nIGxpa2U6DQo+
DQo+ICAgIGRldmxpbmsgPSBkZXZsaW5rX2FsbG9jKCk7DQo+ICAgIGRldmxfbG9jayhkZXZsaW5r
KTsNCj4gICAgLi4uDQo+ICAgIGRldmxfcmVnaXN0ZXIoZGV2bGluayk7DQo+ICAgIC4uLg0KPiAg
ICBuZXRkZXZfcmVnaXN0ZXIobmV0ZGV2KTsNCj4gICAgZGV2bF9wb3J0X3JlZ2lzdGVyKHBvcnRf
Zm9yX3RoZV9uZXRkZXYpOw0KPiAgICAuLi4NCj4gICAgZGV2bF91bmxvY2soKTsNCj4NCj4gQW5k
IHRoZSBpbnZlcnNlIG9uIHRoZSAucmVtb3ZlIHBhdGguDQo+IEJhc2ljYWxseSB5b3Ugd2FudCB0
byBob2xkIHRoZSBkZXZsaW5rIGluc3RhbmNlIGxvY2sgZm9yIG1vc3Qgb2YNCj4gdGhlIC5wcm9i
ZSBhbmQgLnJlbW92ZS4gVGhhdCB3YXkgbm90aGluZyBjYW4gYm90aGVyIHRoZSBkZXZsaW5rDQo+
IGluc3RhbmNlIGFuZCB0aGUgZHJpdmVyIHdoaWxlIHRoZSBkcml2ZXIgaXMgaW5pdGlhbGl6aW5n
L2ZpbmFsaXppbmcuDQo+DQo+IFdpdGhvdXQgaG9sZGluZyB0aGUgbG9jayB0aGUgbGlua2luZyBi
ZXR3ZWVuIHRoZSBkZXZsaW5rIHBvcnQgYW5kDQo+IHRoZSBuZXRkZXYgZ2V0cyBhIGJpdCBpZmZ5
LiBJdCdzIGEgY2lyY3VsYXIgZGVwZW5kZW5jeSBvZiBzb3J0cw0KPiBiZWNhdXNlIGJvdGggdGhl
IG5ldGRldiBjYXJyaWVzIGEgbGluayB0byB0aGUgcG9ydCBhbmQgdGhlIHBvcnQNCj4gY2Fycmll
cyBpbmZvIGFib3V0IHRoZSBuZXRkZXYuDQo+DQo+IFdlJ3ZlIGJlZW4gZmlndXJpbmcgb3V0IHdv
cmthcm91bmRzIGZvciBzdWJ0bGUgb3JkZXJpbmcgYW5kIGxvY2tpbmcNCj4gcHJvYmxlbXMgc2lu
Y2UgZGV2bGluayBwb3J0cyB3ZXJlIGNyZWF0ZWQuIFJlY2VudGx5IHdlIGp1c3QgZ2F2ZSB1cA0K
PiBhbmQgc3RhcnRlZCBhc2tpbmcgZHJpdmVycyB0byBob2xkIHRoZSBpbnN0YW5jZSBsb2NrIGFj
cm9zcyAucHJvYmUvDQo+IC8ucmVtb3ZlLg0KDQoNCk9LLiBUaGFua3MgZm9yIHRoZSBleHBsYW5h
dGlvbi4NCg0KSSB3aWxsIGFkZCB0aGUgbG9ja2luZy4NCg0KPj4gQWxzbywgSSBjYW4gbm90IHNl
ZSBhbGwgZHJpdmVycyBsb2NraW5nL3VubG9ja2luZyB3aGVuIGRvaW5nDQo+PiBkZXZsaW5rX3Vu
cmVnaXN0ZXIuIFRob3NlIGRvaW5nIGl0IGFyZSBjYWxsaW5nIGNvZGUgd2hpY2ggaW52b2tlDQo+
PiB1bnJlZ2lzdGVyIGRldmxpbmsgcG9ydHMsIGxpa2UgdGhlIE5GUCBhbmQgSSB0aGluayBtbDV4
IGFzIHdlbGwuDQo+IFJpZ2h0LCBvbmx5IG5ldGRldnNpbSB3YXMgZnVsbHkgY29udmVydGVkIHNv
IGZhci4gVGhlIHN5emJvdCBhbmQgb3RoZXINCj4gdGVzdGVycyB1c2UgbmV0ZGV2c2ltIG1vc3Rs
eS4gV2UnbGwgcHVzaCBhY3R1YWwgSFcgZHJpdmVycyB0b3dhcmRzIHRoaXMNCj4gbG9ja2luZyBz
bG93bHkuDQo+DQo+PiBJbiB0aGlzIGNhc2UsIG5vIGRldmxpbmsgcG9ydCByZW1haW5zIGF0IHRo
aXMgcG9pbnQsIGFuZCBubyBuZXRkZXYgZWl0aGVyLg0KPj4NCj4+IFdoYXQgaXMgdGhlIHBvdGVu
dGlhbCByYWNlIGFnYWluc3Q/DQo+IFJpZ2h0LCBJIGRvbid0IG1lYW4gdGhpcyBwYXJ0aWN1bGFy
IHNwb3QsIGp1c3Qgb3Zlci10cmltbWVkIHRoZSBxdW90ZS4NCg0K
