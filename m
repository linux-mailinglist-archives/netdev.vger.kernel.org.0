Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE05935E7D2
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 22:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238608AbhDMUv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 16:51:57 -0400
Received: from mail-mw2nam08on2123.outbound.protection.outlook.com ([40.107.101.123]:27809
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239416AbhDMUvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 16:51:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YP1cvPSC1Kr4o8how7sl+FAcPnLoPMsKyoQwK6xlcICAeu02OWrGLgf9+EpMLWKvDRRKC5EvBphgu8sfaPGhZIJ76pPQLuvYFfGF6VPpFw6Oa5qG7MjEXoMbaAE+/l8curxH/mhsVmKKIrF2Stx4vZAwcOtTCMlsS9Upoub5xlp3ShA+KIA/+VeEE+482pJC/u2ALr3mqRI5hd0uyKIfMV+liAB4vPvjLMf7Q4+KUQb9Bk0Q4m5LnmUTKTlKhPJ4aQD4owAziLkYQQxzBC0iNluTFeNJudyoLVXoVFjelEtPW1aG4Z7d9G4+GodpGWPcyHdA+wOfG4ZR1jacprFjhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMmZP64cpj8yU8Y4haaewcAaYjDMN2QUh8Hxn6IEKJk=;
 b=SJtO0rqoKMNOXiENX683OslUavwWOnq0RZjGA0jfVIZVXTlUegEQFHDdzfxNbeNnUx4wBIP8Xm4DXQGiqLiyKwmZG5DYgU6fLHD0k2UMx8WeYeRholI2IxNFYgrxbTbleQOR2SHeDCm+ovwDMQACS0jWAmsXUdVI9mFrZM/NWCjLSJsxCEQ63iO2NqwyqKuIbQ0xmGFVg5n7ZmDroS8Rv0zJCV/ZOvjOz/ckkL1vUo3UEM92Kyt6HZIpl3g7kt/wZADsYt8PKAdKVRGDcN1ecEn5U7ZyWsXEdyp9jwYWJty3qL1nMJzIMj5B8RudD8oI82T1RY++SdF5Vg2uFS8DBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMmZP64cpj8yU8Y4haaewcAaYjDMN2QUh8Hxn6IEKJk=;
 b=JT+gMGsUob4G7k4WHT3buSF+b6SUFwDbs9X2kKn6B0B9XHyVEA1QZhRfgOvHnX5CQ9jpK8n+xk8Btylp1DluybMVJtR9+PC9HWTtcwRRRw04S5KwHjZlQxdDG+ZqSw23/lji9eRQ8A9BnJPeMxwuItCzdah360w4bWqk5tqt7Kg=
Received: from CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11)
 by CH2PR22MB1848.namprd22.prod.outlook.com (2603:10b6:610:5e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Tue, 13 Apr
 2021 20:51:22 +0000
Received: from CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::fd2f:cbcc:563b:aa4f]) by CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::fd2f:cbcc:563b:aa4f%5]) with mapi id 15.20.4042.016; Tue, 13 Apr 2021
 20:51:22 +0000
From:   "Gong, Sishuai" <sishuai@purdue.edu>
To:     "xie.he.0141@gmail.com" <xie.he.0141@gmail.com>,
        "eyal.birger@gmail.com" <eyal.birger@gmail.com>,
        "yonatanlinik@gmail.com" <yonatanlinik@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: A data race between fanout_demux_rollover() and __fanout_unlink()
Thread-Topic: A data race between fanout_demux_rollover() and
 __fanout_unlink()
Thread-Index: AQHXMKbDAkps2kEyfUyo2A/srpWwgg==
Date:   Tue, 13 Apr 2021 20:51:22 +0000
Message-ID: <4FE5BFAB-1988-4CA9-9B97-CEF73396B4EC@purdue.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [66.253.158.155]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 868578c1-dd3e-4e4a-cfbe-08d8febde5b0
x-ms-traffictypediagnostic: CH2PR22MB1848:
x-microsoft-antispam-prvs: <CH2PR22MB1848BDF2AD6D6A4441E4F9E1DF4F9@CH2PR22MB1848.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hkJPZ7za+etao3t+4o7/7V2SJp7W0ebPgavnL3CYRvaDobSktMtJQxffLZJzIABQLC2dnewZ5/mmvFLFP+/5gF90DoskcJfmwLxkfW26GUIiSfMUFqMci+j6YYzdQVMg6BgcaqXaVJ15HtP7P/ByNWxcp8hnpy3ebECWMDJAzqk00xsNqqM5PwXoP9jNGwLm3LmYliVPb7J1Tg7WHUC5K/T7rwLyFhrcHaj2d4oXKlfAA1DR0ImHpJQMdy+LPYF6V4qPrWkOS3YhC7tPz6JqUEjkUIJMz2XiA2nHKxIOjSQEWCeI3frYS6a8jFwrK++QdOurXyu9p/SigNtdtf4gRc7IMF4qt99dR6GNSJEe+ZSVCed790WNzmmi5aFmMn7svXlKQ6i62I3nq/tpwrwSnVr53ZFwPBdl0jpr0LM6JS2RTEH//KfRc6fHHD137iQUifw4qL6v6WF62+LvOawauHAiLWkB1Uj1mOIijDqZxp44oDOiHeYdnR3wVm1O9APF97LAF4AAkNq89XPqE6biUObe+1Kb5vnFr1B/SePxtlBH+y7xtv4TkrW+GwcN4snCkc/a2vMN6Tut5TRKVOdUjMOG4w1a28e4Tjil66tqGCIqTvSrRDBRcq4og3kURw2dOAK9Wzxrx/3Ba3DfAypLsth9z+3BfWj8DzEJ3lNScC4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR22MB2056.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(346002)(396003)(366004)(478600001)(71200400001)(86362001)(2906002)(6486002)(6512007)(83380400001)(316002)(6506007)(4744005)(122000001)(38100700002)(110136005)(5660300002)(33656002)(186003)(66446008)(66556008)(786003)(64756008)(66946007)(76116006)(26005)(8676002)(75432002)(8936002)(66476007)(36756003)(2616005)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Q0pXS3l5RDFaYktnZVBkSkRqcytnN1NJMUxWVm93TjJRM0pqMS9Kc2VhUUJx?=
 =?utf-8?B?SGZicHFpT1ROZUNxT2dkeHoydTNJZy9TeGFpSHptcDlFbWNtN04yMitFUWh0?=
 =?utf-8?B?SEVVSVd4U2h0bWN5ZmpnRDFIY3N1amRsMWdaaVB2b0YwL1Z3K0t4VFEydHFY?=
 =?utf-8?B?dk5wNElaSEREWVVFZWM5VHVmbEE3WTJPNkJZbUhJbENNczhibEFmanhxVG5N?=
 =?utf-8?B?MkgwRW9BQStYTmN4WlBaZXpxM3R0VElBM2ltbVFmQ3VSeXp2MDdaTUhCSzFF?=
 =?utf-8?B?TkNNcGtPR3Q1WGdkRFlXU3NjUFdSQ2E3Wjl3aHZIeUZWemZvanF2bEQvRzNW?=
 =?utf-8?B?SnUxem95ZU1XY1UweVhQTmgwMS9yWUs3TSttZDE0Wk9CRlRZcCt4elQ0dG9X?=
 =?utf-8?B?Wnd3MytXR0NtL0JyVE9zV1ZEM0pyK0ZpelEzbjIxcVBEQ1JGLzV1RnZLakVp?=
 =?utf-8?B?eThlN1RBaDBkRWZyWFlCb2VleHN5NnZUU2I4TWk1ODJ0WVB3OWZ1VzZ2NVNY?=
 =?utf-8?B?dXBoMjVGaVowQkdac2kwOEllU2JlajhKVmY2bjNMR0NLbjNOWkJlMkF4eUEz?=
 =?utf-8?B?eTBubDZSbnFmbDh6ODdVM3ZEUkE3U2h2b1phc2ZCaEx2dnNjd1hmSml0OFZM?=
 =?utf-8?B?T0Z5YnpZWFBjQ09JNWo2SzVqS01pL0dFV1d4UnFqM0g5Nk53M3o0UmJ5QXBz?=
 =?utf-8?B?dTZZOVQ3ZEljRjFzajN1cUg5VUs1ajR2NC8xM0NKL2kvQ09nWGpNSVgzTWcv?=
 =?utf-8?B?SzZlSTlYQUl4R2d6bk0xS3YybXVQdytIR0d5RnZCVHorZDBSTkIrNGFHTER2?=
 =?utf-8?B?Qk9HK0tRaDBva3cyOUMyQXZDQjRWMWVuSTVyOE1wUldIMnp2VElwWmpxTG5G?=
 =?utf-8?B?T0RvYTVROFpwcE9teEJ6NnFiYThBVTAxZzZoTVBZd29qZDRZZVVmeTV5SHZW?=
 =?utf-8?B?cjhFWUZ5VGYwOGpxZFcvWHhoQS9nTElVcCtwYTRkZ0tLMm1icmQrZEQ0ZE5i?=
 =?utf-8?B?ZG5DbTYyUTRVUjJGMVMvdEpSb1NHdE12NWdoOXF2Ymd3alRWWTVhYjZvWHFi?=
 =?utf-8?B?Vis1Q21WSVFwVEt2N1ROamRiTXI5bGt6SCtOSENqeUd3dGVicG5WRUpaNExo?=
 =?utf-8?B?M3NYUlE4b0VKc0V5OWQrR3dwdWd0L01FZ0ErS2FsVFJhNDV3eW1vU1p3OGpa?=
 =?utf-8?B?NXEvdFRCNERkdEoyU1dPSUxGTUlYcmJwWFVsVFZIampkYkJrVGVSMTFUZlNH?=
 =?utf-8?B?Q0crK2VIdFBsN1BYY0lnaXdXUHVGMUdIVThTbk4wWjBwbzZXR3V6emJhb1h4?=
 =?utf-8?B?OTVVWHlsOHB4U1g2WkxIYWtsazdmQS9ZSVA1N3ZCWm9CZkd4cTh5bXFIdkJj?=
 =?utf-8?B?RnM4WFNzek1ZK2RLVVdHc2RhbDhQMzhiRnc3bW01cmZFb3pESFprVWdudkkr?=
 =?utf-8?B?S1pGRjNjdERYZHVNUmJlaCtnMmR0dDJTK2tua0ZtUzRQb01ZZzRYRDM5SUpK?=
 =?utf-8?B?b2VMOEN3cjh3ODBodGZVYUFqc3o0WjVOUUw2TWk5bXNuQ3VOVnR0UjV3YytW?=
 =?utf-8?B?bE9DTVRlYlBFZWo4RDZtNm5rcXBQdzUyc2RhRHk3OVJVNDJLYURvVmdQRlZl?=
 =?utf-8?B?cm9ETkk0cFBaaGh5MkJSY25zUVk3eW0xdkh4N1g3MkRSNlB2eHpJUW5Sekg2?=
 =?utf-8?B?cFRBamd5Q0VmVmkrcnk2VCtQcUZGQXkzR083WjRuU09ucll4R1RyZXM0WFBo?=
 =?utf-8?Q?XcXvbuvikpqAHGqp7S1dk2ycaUaxIo1btEOmy0L?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBABAB31D18128428BA80058CDE3124D@namprd22.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR22MB2056.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 868578c1-dd3e-4e4a-cfbe-08d8febde5b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 20:51:22.8271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xE9wWcjAVPXFR1+TXOPdputmin62jv57tNTIrFEaHADbU6/QbQ393BA7B+HeU4k12dG2+5sdVdf1BcrzRqOkXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR22MB1848
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCldlIGZvdW5kIGEgZGF0YSByYWNlIGluIGxpbnV4LTUuMTItcmMzIGJldHdlZW4gYWZf
cGFja2V0LmMgZnVuY3Rpb25zIGZhbm91dF9kZW11eF9yb2xsb3ZlcigpIGFuZCBfX2Zhbm91dF91
bmxpbmsoKSBhbmQgd2UgYXJlIGFibGUgdG8gcmVwcm9kdWNlIGl0IHVuZGVyIHg4Ni4gDQoNCldo
ZW4gdGhlIHR3byBmdW5jdGlvbnMgYXJlIHJ1bm5pbmcgdG9nZXRoZXIsIF9fZmFub3V0X3VubGlu
aygpIHdpbGwgZ3JhYiBhIGxvY2sgYW5kIG1vZGlmeSBzb21lIGF0dHJpYnV0ZSBvZiBwYWNrZXRf
ZmFub3V0IHZhcmlhYmxlLCBidXQgZmFub3V0X2RlbXV4X3JvbGxvdmVyKCkgbWF5IG9yIG1heSBu
b3Qgc2VlIHRoaXMgdXBkYXRlIGRlcGVuZGluZyBvbiBkaWZmZXJlbnQgaW50ZXJsZWF2aW5ncywg
YXMgc2hvd24gaW4gYmVsb3cuDQoNCkN1cnJlbnRseSwgd2UgZGlkbuKAmXQgZmluZCBhbnkgZXhw
bGljaXQgZXJyb3JzIGR1ZSB0byB0aGlzIGRhdGEgcmFjZS4gQnV0IGluIGZhbm91dF9kZW11eF9y
b2xsb3ZlcigpLCB3ZSBub3RpY2VkIHRoYXQgdGhlIGRhdGEtcmFjaW5nIHZhcmlhYmxlIGlzIGlu
dm9sdmVkIGluIHRoZSBsYXRlciBvcGVyYXRpb24sIHdoaWNoIG1pZ2h0IGJlIGEgY29uY2Vybi4N
Cg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpFeGVjdXRpb24g
aW50ZXJsZWF2aW5nDQoNClRocmVhZCAxCQkJCQkJCVRocmVhZCAyDQoNCl9fZmFub3V0X3VubGlu
aygpCQkJCQkJZmFub3V0X2RlbXV4X3JvbGxvdmVyKCkNCnNwaW5fbG9jaygmZi0+bG9jayk7DQoJ
CQkJCQkJCQlwbyA9IHBrdF9zayhmLT5hcnJbaWR4XSk7DQoJCQkJCQkJCQkvLyBwbyBpcyBhIG91
dC1vZi1kYXRlIHZhbHVlDQpmLT5hcnJbaV0gPSBmLT5hcnJbZi0+bnVtX21lbWJlcnMgLSAxXTsN
CnNwaW5fdW5sb2NrKCZmLT5sb2NrKTsNCg0KDQoNClRoYW5rcywNClNpc2h1YWkNCg0K
