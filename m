Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECA1402E58
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 20:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345849AbhIGS3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 14:29:39 -0400
Received: from mail-mw2nam08on2127.outbound.protection.outlook.com ([40.107.101.127]:46817
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236461AbhIGS3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 14:29:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FSy0G8cFPTqaqtXd8Ld0wRwD8u1BDbNyk7gjP6vW5Das7GNFug+JzkJVg54wqQqMeY7HyWd637hu0SMjKBT6XCXSvrtfI0bkw2xbSmvXdlwGN4ZQObn0LIkRfvvOslTZzAfrPtnT+O95McdWArD34DnkjR588Fmrd5584/Vbbunt06cM8RFFjwwcg2jX4R3rG1Z955cKbjKfgUoh+KiOI1YHtRMXk/aokV7rRPDrQIuormQVznXrjAMFqv1n/Lo3Iu8zgBuHEkGb/kDQQr2Ki4yJJKyCTx4H+zhhZ/N7PlcC17zLepuRmkfXcI0/leN2aUX2a6vugUOPwkEkMBX2Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BngrG05tIdaOouvnD3jq1PXoDDTBEdl76ytp7KToilM=;
 b=n39zFG1++4cFryRye9AqbvEs8KA1Uw0X4iIb01VpcaSgQByYDob1kER06TZ+kgD7F2tMa2AZMSVWp+rWld3Vf/kg751gMbjAj/PWLWZTb1Uz2qZe8GqCeAVjLTalzNr4WX7h6MEDOblRESA9q3v8NazDzj6uSoyskJlzOvz/L60zhz0GRgLLj53SH4TkuN/i+ZmxFtNqvsOMLg/2OyULPt+Ju/1ZmDEEar1y7mW5tWt1WFVWiBCfhKuy0hwpkakNZeSgcJAANEj/A5xwyvIbMXYX2saNAEl2n9EM0RNFHNALFXfcY2pw6drSerc09xZf1LgjXqDs1o7GXhBdjCjE7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=psu.edu; dmarc=pass action=none header.from=psu.edu; dkim=pass
 header.d=psu.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=psu.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BngrG05tIdaOouvnD3jq1PXoDDTBEdl76ytp7KToilM=;
 b=qEy91l7j0PbudwOU7blEikVd4bUjAuWrvMNiDjgThJlb6V5er85r2/4O6HOWupLVtU5TsISBiBScST9ZSnKuvL06VSpQh5PHOeW671i9UdzGGCTLOm0k9r3JDhNERMMLmrxAJvo9Xifwzk8/F0qmHTj20NjrTy5FXtZsLw+t3Z0=
Received: from BL0PR02MB4370.namprd02.prod.outlook.com (2603:10b6:208:42::31)
 by MN2PR02MB6382.namprd02.prod.outlook.com (2603:10b6:208:1bd::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Tue, 7 Sep
 2021 18:28:28 +0000
Received: from BL0PR02MB4370.namprd02.prod.outlook.com
 ([fe80::40fc:3ab5:8af7:7673]) by BL0PR02MB4370.namprd02.prod.outlook.com
 ([fe80::40fc:3ab5:8af7:7673%7]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 18:28:28 +0000
From:   "Lin, Zhenpeng" <zplin@psu.edu>
To:     "Lin, Zhenpeng" <zplin@psu.edu>
CC:     "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "alexey.kodanev@oracle.com" <alexey.kodanev@oracle.com>
Subject: [PATCH] dccp: don't duplicate ccid when cloning dccp sock
Thread-Topic: [PATCH] dccp: don't duplicate ccid when cloning dccp sock
Thread-Index: AQHXpBYmYVTUvVQssESqpTbpnXejmg==
Date:   Tue, 7 Sep 2021 18:28:28 +0000
Message-ID: <D95F1297-95A1-4AC9-B0C2-803C453B1BAE@psu.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: psu.edu; dkim=none (message not signed)
 header.d=none;psu.edu; dmarc=none action=none header.from=psu.edu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ffc2000d-4aec-42d4-a102-08d9722d4982
x-ms-traffictypediagnostic: MN2PR02MB6382:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR02MB6382B17084523FAAAE75C02FB7D39@MN2PR02MB6382.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5o2ZtMQJMXLlcBwCly4A9Wp/gSmAUNXX3HXToDAxSXG/aVEAOIqCyo24u2uwW4lzRM+3QBeRHEhlRqKmTpHLqEeWyCdYEsww0gJCYr/rpsfyv/bxU9P+EXl542h0V5HUqR37gQFphkkOQceUv4q4RiZ1NIF6XGlfp4nI3YacRT79/SusOx1fbF6+8PyHugA0kLXI/puTCR5J5+I4pRi8iwuElS4be2Iq8+wFpnCN+SaAjCkK2Wlf/0o/uWUMeH7B902xtZmLRs7mq94mE85JjDyMQp+AhJHnj71DQVMG5qpH9ESd0b7LcwV8PIp2IrJCYZU2PJ+yK0eLK23KmrLLgN+GgBUtK3+EyN3/O1Q5IvfOZZK5rdsfX618AXRk//JuWUlmmYNt2XqZy+wBSz/LqYsfJWR/wM51aGpheu0/+GiCpkw/YgJSTmSyNB3CA+4LrJCSC3FXX26JP0NyESobju6i3ttOgWNipiJj5TgC43wfSCO+zO1c1Z56Xi6UDig93+OhpEUOiqyQ5LgijEuE7LZcuTEisUu8F/uBGZbUCwFSybOuMnnTrhvioQYTljdONQYmw90NbtkS0/FcD/IETJKOtSXBfoLsS0SZKvA3rWrCkCaxZzxGxsoNZtIfRrRbTrVX3eAO9dmUve2JlLZJOyibJeBMulyrga4Lq/RcLxgfJpNb62IKCAPCEZo/oGl+JKr9D0A/9idZBDAiGhOZy3O9M9HE5D7rYR0OvFVV19k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4370.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(36756003)(66946007)(66556008)(66476007)(66446008)(64756008)(86362001)(2616005)(37006003)(75432002)(6862004)(6506007)(38100700002)(122000001)(478600001)(8676002)(54906003)(4326008)(5660300002)(26005)(186003)(6200100001)(8936002)(6512007)(71200400001)(6486002)(2906002)(38070700005)(91956017)(316002)(76116006)(33656002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzF0RXdSU2poYnV6RTNNUDBrSlBwYkU3QW9acVJpUXNkcVRTTkRrWDV4dG9k?=
 =?utf-8?B?SUdzYUVZT0ZQNnQxZ2J5cWU1N2VWLzlUUDBydUdwU29tRmVTM0tkUTF4TlhN?=
 =?utf-8?B?R1pWeUE5Z0tERU5RMUtlOVU5Q3l0K2YzOEtwMC9ESlN2UzJpTWZMZjBMcmhp?=
 =?utf-8?B?QzdTNEU3Z3ZMYmh1YmZYQ2I5S2JUbDJya1JDLzlJUWtvL3g3bmNudCsydGVN?=
 =?utf-8?B?OWlaSHV6NkRVN2ZVWG5rOUFvL0V6U0pZVGNENlY0dVBESm1WU2NkME9FY2l2?=
 =?utf-8?B?MmR4RGtWNEcxQjhkSWFuWHFIQ3ZPUktvaEpPQlV1R2tTUVBDREZ2RVdVdlRx?=
 =?utf-8?B?OE1MTUdVNERGbWdjSWlnRWtsM1dVL3Y4VFNwcVhzRjBFdlUydjRKZnVvSFYr?=
 =?utf-8?B?MzlpUDcxdDRURFFZdVI2STdWQUNhaTlpWU1vTEk2ZmhUclBEOGNRQVl0enNK?=
 =?utf-8?B?OS9hUmhPU2JnZVl0Q3FXdnY5RHM1YlBiVCszWldraFFnS0l1Wjg0cVZ2Nm5U?=
 =?utf-8?B?N3RRdnBySHpNeW1mM2hsaGpqWTFZYVdpblFzcHRSSG1kK1J3Y0pOczh2NXpX?=
 =?utf-8?B?bmhBNjIrZGdhclpiU2FKWHZBQ1czdzJJVXBVdEJGM3ZLbUVJSHZrMU1IM05s?=
 =?utf-8?B?bHdGeWx6aGRmazNoOHFWMkMzQ0xLSmFXQUJZREwwWU44NWtRUzgrTEYvckxa?=
 =?utf-8?B?VXNMV2R1SG53aFQyUjZIU0VwMy8yRDB0aGswbUdyVTBPMEZwRnE3bXhSbnFU?=
 =?utf-8?B?dTF2c0tiUU13ZkQ5bmVrUlhtRWQwcmZPU2x2VGlDWmJvQk53Y1pLTjRLZlVH?=
 =?utf-8?B?Ykl6S0kwKzV4dG5uSkROWHJlR1BMV0hSbTJtYXZMVXREaWEzYzhIMFd4LzZy?=
 =?utf-8?B?NWQzSXVyUHFQWWRkbXZOcy9zV3dWVmd2T0pxSm55ZERzYTRrR3ZnbVgrTXpK?=
 =?utf-8?B?R2lXa2lWdGhLeFdaMVB0TEdqQndDR1Ivd0gzRDZaQjJPSy9sNnEySUZ2UTVC?=
 =?utf-8?B?TDJrd24wSm1WdXFVbUhkT1RpWmFQeHFwYjBkbUhENENsZmcwZkorYi93Nk9t?=
 =?utf-8?B?dnNOVmM3cjJOSW5Td3hQYmhvYitxN0piNGk2bGo4MExKaEZ5enJOVElKcmdk?=
 =?utf-8?B?b0ozK2xaK2laajgzK1RxdDhxNS9iei9hbWE4ZEpObmpYZ0ZRU3Z0T1dES3JB?=
 =?utf-8?B?Wm9KQ0I3S1dqdHB0bmEyUEVYTk5zN1luYXQxNUNEallPdXRKd2VuQWRSd0dE?=
 =?utf-8?B?SWhwWE5NaVJWSGJSZ284aVJWcTJzMFBkQmZqWEhhaTZuTjV5OGJ3bHNnY3pa?=
 =?utf-8?B?anpWNzE0bmltUXFHM3Z5S0d2enQxRUFWTUdpU3JVOTBueThhb2hydjhpYS9j?=
 =?utf-8?B?aWg2YWRKSEZRQXpudkFQR0wvTkZyRS9kZ3VWMjVrMzBuTytJRFBOMVNnODY0?=
 =?utf-8?B?Ylo2VkRORHNjLzFHR0hDN2ZjRWQ1SDBQNGNSMElxV1NWZlFERHBUSlV1K280?=
 =?utf-8?B?NnpIZnlibFpEOGJyKzBJSjdGeHE3VkErZ2llbmowNmxSVUwzVzFRTUp3Zk10?=
 =?utf-8?B?NE55ejBTVVo1aXNqS3EzcjBzNUlXQUhRWUJYaDZpVDI3V1diSkdHakJybEw0?=
 =?utf-8?B?WWFFcmVXbmNiM21VVENtNW1PYUlKNTZ0VUgzZkkxTVdYc2FDMTRhOWJHSlp3?=
 =?utf-8?B?VHB4QjFNS3o3RDJLKzIveE82M3Y1eUc1Y1VnbnozRjFrdmMxTXhMeUpIQk5Q?=
 =?utf-8?Q?xvvdi12CUj++tlLGZ8R8uhRBO/RckPw8gRzmW/M?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <23BB301FAF512542BBDD915D4F818B8F@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: psu.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4370.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc2000d-4aec-42d4-a102-08d9722d4982
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2021 18:28:28.1288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7cf48d45-3ddb-4389-a9c1-c115526eb52e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y6NEeg9s+8r5PTsGKw3pPJqOfevDRdHe145faDzj895Qr4oKIMTma4r2LYBl0A/s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6382
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q29tbWl0IDI2NzdkMjA2NzczMSAoImRjY3A6IGRvbid0IGZyZWUgY2NpZDJfaGNfdHhfc29jayAu
Li4iKSBmaXhlZA0KYSBVQUYgYnV0IHJlaW50cm9kdWNlZCBDVkUtMjAxNy02MDc0Lg0KDQpXaGVu
IHRoZSBzb2NrIGlzIGNsb25lZCwgdHdvIGRjY3BzX2hjX3R4X2NjaWQgd2lsbCByZWZlcmVuY2Ug
dG8gdGhlDQpzYW1lIGNjaWQuIFNvIG9uZSBjYW4gZnJlZSB0aGUgY2NpZCBvYmplY3QgdHdpY2Ug
ZnJvbSB0d28gc29ja3MgYWZ0ZXINCmNsb25pbmcuDQoNClRoaXMgaXNzdWUgd2FzIGZvdW5kIGJ5
ICJIYWRhciBNYW5vciIgYXMgd2VsbCBhbmQgYXNzaWduZWQgd2l0aA0KQ1ZFLTIwMjAtMTYxMTks
IHdoaWNoIHdhcyBmaXhlZCBpbiBVYnVudHUncyBrZXJuZWwuIFNvIGhlcmUgSSBwb3J0DQp0aGUg
cGF0Y2ggZnJvbSBVYnVudHUgdG8gZml4IGl0Lg0KDQpUaGUgcGF0Y2ggcHJldmVudHMgY2xvbmVk
IHNvY2tzIGZyb20gcmVmZXJlbmNpbmcgdGhlIHNhbWUgY2NpZC4NCg0KRml4ZXM6IDI2NzdkMjA2
NzczMTQxMCAoImRjY3A6IGRvbid0IGZyZWUgY2NpZDJfaGNfdHhfc29jayAuLi4iKQ0KU2lnbmVk
LW9mZi1ieTogWmhlbnBlbmcgTGluIDx6cGxpbkBwc3UuZWR1Pg0KLS0tDQpuZXQvZGNjcC9taW5p
c29ja3MuYyB8IDIgKysNCjEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCg0KZGlmZiAt
LWdpdCBhL25ldC9kY2NwL21pbmlzb2Nrcy5jIGIvbmV0L2RjY3AvbWluaXNvY2tzLmMNCmluZGV4
IGM1Yzc0YTM0ZDEzOS4uOTFlN2EyMjAyNjk3IDEwMDY0NA0KLS0tIGEvbmV0L2RjY3AvbWluaXNv
Y2tzLmMNCisrKyBiL25ldC9kY2NwL21pbmlzb2Nrcy5jDQpAQCAtOTQsNiArOTQsOCBAQCBzdHJ1
Y3Qgc29jayAqZGNjcF9jcmVhdGVfb3BlbnJlcV9jaGlsZChjb25zdCBzdHJ1Y3Qgc29jayAqc2ss
DQoJCW5ld2RwLT5kY2Nwc19yb2xlCSAgICA9IERDQ1BfUk9MRV9TRVJWRVI7DQoJCW5ld2RwLT5k
Y2Nwc19oY19yeF9hY2t2ZWMgICA9IE5VTEw7DQoJCW5ld2RwLT5kY2Nwc19zZXJ2aWNlX2xpc3Qg
ICA9IE5VTEw7DQorCQluZXdkcC0+ZGNjcHNfaGNfcnhfY2NpZCAgICAgPSBOVUxMOw0KKwkJbmV3
ZHAtPmRjY3BzX2hjX3R4X2NjaWQgICAgID0gTlVMTDsNCgkJbmV3ZHAtPmRjY3BzX3NlcnZpY2UJ
ICAgID0gZHJlcS0+ZHJlcV9zZXJ2aWNlOw0KCQluZXdkcC0+ZGNjcHNfdGltZXN0YW1wX2VjaG8g
PSBkcmVxLT5kcmVxX3RpbWVzdGFtcF9lY2hvOw0KCQluZXdkcC0+ZGNjcHNfdGltZXN0YW1wX3Rp
bWUgPSBkcmVxLT5kcmVxX3RpbWVzdGFtcF90aW1lOw0KLS0NCjIuMjUuMQ0KDQo=
