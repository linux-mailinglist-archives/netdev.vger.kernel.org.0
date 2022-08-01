Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0697586B6A
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 14:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiHAM4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 08:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbiHAMzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 08:55:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158F1BF56;
        Mon,  1 Aug 2022 05:52:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghQG3Hn2W32Ivf8qfFV7+0WJGchc0UXpP5EsDaSoBrRwCrS7jeYyOd/l/b6mDB/959AQyK/5ry2/veHpuQYssUwefn9FWxyEB27ML4etPF8LcO81Aa9ZiWdthfjzRKLmzzebXWoCKMRFPUOE/SQ4iM79CndlGm5LC0VVvZYOIuviY55RClxV3AMXbjdC7b75ItOFSlNti67hMnioSmjjAJTYcKLImHIPgNVieYeaK7cY3u3u8ZiIReMMQg6SIot4oq3QNFSnQD4vy5IcBD/Jb8YETPXuXIYbCjMXxYSpYdouzj1q+7BMtP/+6H9Edi2e23knaQ2vR3qSfM4tdbBK2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQxyV3NfhDc12HeKqjD2iTdYvU98TL02c5frQR8tC7I=;
 b=RoPqRgO7gjSxJ78mXW34aLSFMPVIBLMaeHpeEZp+Y9zN3kZbqo6nOIqF4YF2H16jgzD9v4DEdryM7W8mOLGpl0gLcZQpviNQHETx1Div9XhvJd9kaosGgOb/x+ulsSkbyxWYWyVVfeANlZdeEolU9gH9Oh8MyRxH21BsaPakc1OBGWD+pBUwZuQg3Hh8zBo2yQXXdKqJwntoKN0TYgHmw1BwKb7jSrG7iOawsMAU6uBb2n/Nx7J6dixdfDtL2655FhFJJITBZ7EtulfhFKkleVQoLPSDDKsFMCIIomZMnAcRewsChIGoJiYH6h1WMHRUjJda6mESlJxnry1Ivp75Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQxyV3NfhDc12HeKqjD2iTdYvU98TL02c5frQR8tC7I=;
 b=0MGrcFHM95fBIDsrY0Ox+pZCJe1ROevqQM4olk1QwjffgBB7IWoZQOQpPThbY0W13O97bB82j6JBQTcjMuE3i+EbcsDUMMEONGAj8Ksz7cgkSfFumSflIbmwgworC7ApJLQ6J8c5DN8CfqdG3pINRYjH0TSXnlYsQhw7CbNxKFk=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by SA0PR12MB4445.namprd12.prod.outlook.com (2603:10b6:806:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Mon, 1 Aug
 2022 12:52:41 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4%3]) with mapi id 15.20.5482.012; Mon, 1 Aug 2022
 12:52:40 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     "Claudiu.Beznea@microchip.com" <Claudiu.Beznea@microchip.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "git@xilinx.com" <git@xilinx.com>,
        "ronak.jain@xilinx.com" <ronak.jain@xilinx.com>,
        "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>
Subject: RE: [PATCH v2 net-next 1/2] firmware: xilinx: add support for sd/gem
 config
Thread-Topic: [PATCH v2 net-next 1/2] firmware: xilinx: add support for sd/gem
 config
Thread-Index: AQHYo4KW9Ab3qn7LAkWtUF0qlmb7S62Z0vgAgAAty4A=
Date:   Mon, 1 Aug 2022 12:52:40 +0000
Message-ID: <MN0PR12MB5953E6739D58E6BC444DE3E6B79A9@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <1659123350-10638-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1659123350-10638-2-git-send-email-radhey.shyam.pandey@amd.com>
 <bcbea902-6579-f1d4-421e-915e8855822a@microchip.com>
In-Reply-To: <bcbea902-6579-f1d4-421e-915e8855822a@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85499bd3-afaf-4eaf-b7d1-08da73bcb82d
x-ms-traffictypediagnostic: SA0PR12MB4445:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y4ruIESXXuQbML+1himSJAIb0Xky7UtRDczaDaoI4fV6IK+d7wK/W3aDbaTLnxD6UJLf9EVVwnRSYkpJJV3I3L0jpySpGc40vnkGkdi9TBZ2VP5ZeYqZgYbROtRPX7/rK3TXfaCBgtSL9OUUawK7tBp+zDP2N/QAA93bJ3PS9NuZhoIsgOVqrtnpEsSZe9N2L5g+9z/rvzPAxd/irWRjNgxSWKKfH3eq6jQ7EpAUgiJhHVn6YuQLE79wyX24eMgiwQGeTyI/ooUhw64O4THBiaiEtPTE56clptFGfAF6nJ0ZO6Dy6ar8atENdnpdKQxQqTcx1j9/uQJRFY2LRsW2D6HL0U2oiV3ETOJ58dgFO6P5FxG4dSxUKMqqdq09n7rtzjdHrqGf1VHGUp/4XOp4Qa072pUaMaMkSdvXEqhtK9Az7KAcextdiGVIWxZSMAFQKUz1lHLZBrFlS9Dx5DIWn4twcuzFKIPHTBLjN5abE55+hSISt3I/KiS/Fj2ZWH/Nl65KtwdZobdQexmiry+jUaAPn8cM7R92Y5GCUF7eHphvW5ud4Ip8d/Moxbcbkb/mFg2KB+tE4KxzaCwy6sDZ6hGIZ0v56WVnQfJ0hyfSG0kOz4yApi874084U8baAis59h/vov0GcddRrO2IO5KLFC3jRpLT01buzmZA7620vMAL5gLqzgCiOgF/ck9QSY0HqI4EWddrl6OPtd+R50yTph+Ezy5DKPvsO7QXMUv0XFd0SjcWtsXa6WOJv5pO/FJilwihK/QT8ab1Q6L6FdPOelwWK7x+8eGH2DbAP2ZLsTp0zhE8jftVoHwMBYs7E69I
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(2906002)(7696005)(6506007)(33656002)(9686003)(53546011)(41300700001)(186003)(107886003)(86362001)(38070700005)(55016003)(83380400001)(52536014)(66946007)(6916009)(7416002)(66556008)(71200400001)(122000001)(64756008)(4326008)(66476007)(8676002)(38100700002)(54906003)(8936002)(478600001)(76116006)(316002)(5660300002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckdPWkRyY3NzOStmQkdyMlpoVkVhczNxWmRrc0lvNXI3LzlmU1BMSU5UNENs?=
 =?utf-8?B?SWIxRHZWSFlwK00wRDJwNXF6ZWl6c2dTa2liQW9JNTBVUStKeVMzTVQ2dCtJ?=
 =?utf-8?B?SFpPZVV2V3MwNnFQcFUzRi80cWY1RFhCM3hpT3pBc2RLTWJVRXh6T3hSR0ZO?=
 =?utf-8?B?M0VWa25EWUg0Z2I2MWtjYnJ4R1IyRFNVc0VnZUU4VTBZODZrMEJUOW9zbzlL?=
 =?utf-8?B?czlQTnBEMzE3clFEdE41YXFJS3NzRFM5cGlZRnVQcEptVVlmMVFDeXJvU091?=
 =?utf-8?B?UnZWZ0FMWUFEWTJHRnVwd29ITHlRLzRTZjFaUFh6MGN2azA1VENHQm4vYjBR?=
 =?utf-8?B?OEtJSVBFeVdQMXpNdzZGQkZwcU5MSDVIbWcwcllITW1Rb1YzSXFHQVdnVVBP?=
 =?utf-8?B?U2VTc2RrRWVaUGpNbUdqWkcyUXZ5dUc3Q2VhT0VGOGFHYi9LTktTNko4VFpu?=
 =?utf-8?B?bFUvcWdWSXZCN1NDa0lURHJiTTlqWHZCRUlrZVRWRkVFSWJWUDRSanozTUtL?=
 =?utf-8?B?d0U2azFLSEMzVUk4cHlwdDZqcGVSenlXQ2R1TFBFYlBMNWZQallNNU1RcDd5?=
 =?utf-8?B?Z3c5MmVQTFpWUDNxRE14N2dwSXZqMkcrejZ0R0Z4SHZNelBjOEJaVmNsakZZ?=
 =?utf-8?B?eHR4MEpvdjU2Q3ZWR0VjenV0QVlLY3dsemJEb0VFM0Z3Qm11RjUxU2lpOVU0?=
 =?utf-8?B?U2R3TWg2RDhpVmVoQnN3cGRyUjBlSmZxMGxWVlhQVm5uYWZIb0pVN0UyU3VJ?=
 =?utf-8?B?eEMzOUVXUWVJSHQ3R0VUd2hMY0lVK3BsQzI4ZDZzdmk4UWc2WmFkWlhXRTVG?=
 =?utf-8?B?RU91NmxuRVZiNDNMYkV1ZGQ2aW1HVE5tV2tOSE02VnBvbFZYVVVocjN2ZEkx?=
 =?utf-8?B?ejB0ekhLS0g1dlJGRWJkREpwTlUzd0NXUndaQ0ZkZHZNY3ptVWVXSHVrTmhF?=
 =?utf-8?B?YUIrL05lZXhiYklBN1ZHaHZKcGZCV2NkdWJtcUU3V3dKei9MV0hHZllGcjBY?=
 =?utf-8?B?bTR5MDVmZXBMbDhobW9PZ0pJSzdXdlY4SElMTmkxem1PZWVEVU13blIvQTQr?=
 =?utf-8?B?STFHTVZJbE9KT203U0F3aW81WCtXaHN2bnhnZjkrSVZ4MnJUMWtDZ0IvdUVJ?=
 =?utf-8?B?K3p6eUx5bDZkR3FGakVmTGZxem9SbWZaR1JySWJuZmJCckVMK3NjOTh0bXVY?=
 =?utf-8?B?cS9lTnpxMGxqK2ZTbTlsM2Vjc2Q0OTFzeFlXU0w4amtYaWRsQktsMGhxNzky?=
 =?utf-8?B?NENmenBnTEx6UmxrV1J4UnJhOTZiTFBFRWtVSDZacWVaREhnOWRqS0ExQXhs?=
 =?utf-8?B?LzVQNkZTNDVEMmw3U3NtTVNGc29qUnRMMmdsUDBmTmdlVFlPOGRkVEZCSFdG?=
 =?utf-8?B?ZldQSjA5ZGpveGMyQ0pWMHducktnTzdjSUlCSkszTHhsSHd2ODJjQjlKdzVn?=
 =?utf-8?B?M2JPb2pkYkxRM29kY2NNNjlkbnAvcGRHSTVhbU56a2U1dlEvUVMxUHJDL0FZ?=
 =?utf-8?B?dUdzUlNtZ0tGdjRlZDluaHJ0L0x6a2lTQWw3am5mdEV6U3NlWHUzZnFwU2xB?=
 =?utf-8?B?cU5OcCsxcklzSmVtczFnbUQrYnFkRmlYT2FrZnBKMW1uWVBhUDZSZ3UxWjgy?=
 =?utf-8?B?SzVPY0NSL3NGdUFUc0w3Z01oeFh1SVZINU91dmZZdDZqMlpOSUUrd2YvVmRz?=
 =?utf-8?B?YVExUUJPUVhPcm5ZVXdXVUU0N3RYb0prR0xOSTMwa1J3TFppcElEOWpPUWVH?=
 =?utf-8?B?YUFJQ0RNUGxOemdkTzJXTkZNSnV1ZHdSYk8vLzhNbmVlK0g4UE5FRkhoakNi?=
 =?utf-8?B?WTFpYXdtQmt6YmpPNVRhSE1pYUM0WlV1RThob0l1OU1VNHcwSFBYQUZPcEgy?=
 =?utf-8?B?QkNwL1E1aUd3T0tNWXNvYnVld2JXVkxvbHNzQVdOdU5TUmE0SC9WYmg4ZlQ2?=
 =?utf-8?B?U1ROREZxZ1RpVXBaN2Rmc3BsZUhJQzdtViswSjg3TXBwUTVEUU5UM3dhY2Zw?=
 =?utf-8?B?d0V2OUYzYmVwMGh4WFpBMS83VlpvdXZLY29rTExvUklVbkV3TUN3c3hqekxM?=
 =?utf-8?B?U0RGdW5IS3BYTldEM2UzOUNnVkFJQ2ZFbGI1bDh5b1Rab1JUUUQ0QktWYVd4?=
 =?utf-8?B?MkdvVTRUUjVaZG9aQ2QzL3Q2YUg1T1R0dGhSTGxUcHlTd3l2WEltV0F6c3pJ?=
 =?utf-8?Q?i+iRdu1ja0nsDZg4MYFsapI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85499bd3-afaf-4eaf-b7d1-08da73bcb82d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 12:52:40.7083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HzRfms5r00BAK+NQ/a1kN4EsXmcDQXgg+nk+fb57hfbbg2uud2iEPZlTDXbONflC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4445
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDbGF1ZGl1LkJlem5lYUBtaWNy
b2NoaXAuY29tIDxDbGF1ZGl1LkJlem5lYUBtaWNyb2NoaXAuY29tPg0KPiBTZW50OiBNb25kYXks
IEF1Z3VzdCAxLCAyMDIyIDM6MjcgUE0NCj4gVG86IFBhbmRleSwgUmFkaGV5IFNoeWFtIDxyYWRo
ZXkuc2h5YW0ucGFuZGV5QGFtZC5jb20+Ow0KPiBtaWNoYWwuc2ltZWtAeGlsaW54LmNvbTsgTmlj
b2xhcy5GZXJyZUBtaWNyb2NoaXAuY29tOw0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpl
dEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+IHBhYmVuaUByZWRoYXQuY29tOyBncmVn
a2hAbGludXhmb3VuZGF0aW9uLm9yZw0KPiBDYzogbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZy
YWRlYWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBnaXQgKEFNRC1YaWxpbngpIDxnaXRAYW1kLmNvbT47IGdpdEB4aWxpbnguY29t
Ow0KPiByb25hay5qYWluQHhpbGlueC5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiBuZXQt
bmV4dCAxLzJdIGZpcm13YXJlOiB4aWxpbng6IGFkZCBzdXBwb3J0IGZvcg0KPiBzZC9nZW0gY29u
ZmlnDQo+IA0KPiBPbiAyOS4wNy4yMDIyIDIyOjM1LCBSYWRoZXkgU2h5YW0gUGFuZGV5IHdyb3Rl
Og0KPiA+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2ht
ZW50cyB1bmxlc3MgeW91IGtub3cNCj4gPiB0aGUgY29udGVudCBpcyBzYWZlDQo+ID4NCj4gPiBG
cm9tOiBSb25hayBKYWluIDxyb25hay5qYWluQHhpbGlueC5jb20+DQo+ID4NCj4gPiBBZGQgbmV3
IEFQSXMgaW4gZmlybXdhcmUgdG8gY29uZmlndXJlIFNEL0dFTSByZWdpc3RlcnMuIEludGVybmFs
bHkgaXQNCj4gPiBjYWxscyBQTSBJT0NUTCBmb3IgYmVsb3cgU0QvR0VNIHJlZ2lzdGVyIGNvbmZp
Z3VyYXRpb246DQo+ID4gLSBTRC9FTU1DIHNlbGVjdA0KPiA+IC0gU0Qgc2xvdCB0eXBlDQo+ID4g
LSBTRCBiYXNlIGNsb2NrDQo+ID4gLSBTRCA4IGJpdCBzdXBwb3J0DQo+ID4gLSBTRCBmaXhlZCBj
b25maWcNCj4gPiAtIEdFTSBTR01JSSBNb2RlDQo+ID4gLSBHRU0gZml4ZWQgY29uZmlnDQo+ID4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBSb25hayBKYWluIDxyb25hay5qYWluQHhpbGlueC5jb20+DQo+
ID4gU2lnbmVkLW9mZi1ieTogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRl
eUBhbWQuY29tPg0KPiA+IC0tLQ0KPiA+IENoYW5nZXMgZm9yIHYyOg0KPiA+IC0gVXNlIHRhYiBp
bmRlbnQgZm9yIHp5bnFtcF9wbV9zZXRfc2QvZ2VtX2NvbmZpZyByZXR1cm4NCj4gZG9jdW1lbnRh
dGlvbi4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9maXJtd2FyZS94aWxpbngvenlucW1wLmMgICAg
IHwgMzENCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICBpbmNsdWRlL2xp
bnV4L2Zpcm13YXJlL3hsbngtenlucW1wLmggfCAzMw0KPiA+ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDY0IGluc2VydGlvbnMoKykNCj4g
Pg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2Zpcm13YXJlL3hpbGlueC96eW5xbXAuYw0KPiA+
IGIvZHJpdmVycy9maXJtd2FyZS94aWxpbngvenlucW1wLmMNCj4gPiBpbmRleCA3OTc3YTQ5NGE2
NTEuLjQ0YzQ0MDc3ZGZjNSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2Zpcm13YXJlL3hpbGlu
eC96eW5xbXAuYw0KPiA+ICsrKyBiL2RyaXZlcnMvZmlybXdhcmUveGlsaW54L3p5bnFtcC5jDQo+
ID4gQEAgLTEyOTgsNiArMTI5OCwzNyBAQCBpbnQgenlucW1wX3BtX2dldF9mZWF0dXJlX2NvbmZp
ZyhlbnVtDQo+ID4gcG1fZmVhdHVyZV9jb25maWdfaWQgaWQsICB9DQo+ID4NCj4gPiAgLyoqDQo+
ID4gKyAqIHp5bnFtcF9wbV9zZXRfc2RfY29uZmlnIC0gUE0gY2FsbCB0byBzZXQgdmFsdWUgb2Yg
U0QgY29uZmlnIHJlZ2lzdGVycw0KPiA+ICsgKiBAbm9kZTogICAgICBTRCBub2RlIElEDQo+ID4g
KyAqIEBjb25maWc6ICAgIFRoZSBjb25maWcgdHlwZSBvZiBTRCByZWdpc3RlcnMNCj4gPiArICog
QHZhbHVlOiAgICAgVmFsdWUgdG8gYmUgc2V0DQo+ID4gKyAqDQo+ID4gKyAqIFJldHVybjogICAg
IFJldHVybnMgMCBvbiBzdWNjZXNzIG9yIGVycm9yIHZhbHVlIG9uIGZhaWx1cmUuDQo+ID4gKyAq
Lw0KPiA+ICtpbnQgenlucW1wX3BtX3NldF9zZF9jb25maWcodTMyIG5vZGUsIGVudW0gcG1fc2Rf
Y29uZmlnX3R5cGUNCj4gY29uZmlnLA0KPiA+ICt1MzIgdmFsdWUpIHsNCj4gPiArICAgICAgIHJl
dHVybiB6eW5xbXBfcG1faW52b2tlX2ZuKFBNX0lPQ1RMLCBub2RlLA0KPiBJT0NUTF9TRVRfU0Rf
Q09ORklHLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uZmlnLCB2
YWx1ZSwgTlVMTCk7IH0NCj4gPiArRVhQT1JUX1NZTUJPTF9HUEwoenlucW1wX3BtX3NldF9zZF9j
b25maWcpOw0KPiA+ICsNCj4gPiArLyoqDQo+ID4gKyAqIHp5bnFtcF9wbV9zZXRfZ2VtX2NvbmZp
ZyAtIFBNIGNhbGwgdG8gc2V0IHZhbHVlIG9mIEdFTSBjb25maWcNCj4gcmVnaXN0ZXJzDQo+ID4g
KyAqIEBub2RlOiAgICAgIEdFTSBub2RlIElEDQo+ID4gKyAqIEBjb25maWc6ICAgIFRoZSBjb25m
aWcgdHlwZSBvZiBHRU0gcmVnaXN0ZXJzDQo+ID4gKyAqIEB2YWx1ZTogICAgIFZhbHVlIHRvIGJl
IHNldA0KPiA+ICsgKg0KPiA+ICsgKiBSZXR1cm46ICAgICBSZXR1cm5zIDAgb24gc3VjY2VzcyBv
ciBlcnJvciB2YWx1ZSBvbiBmYWlsdXJlLg0KPiA+ICsgKi8NCj4gPiAraW50IHp5bnFtcF9wbV9z
ZXRfZ2VtX2NvbmZpZyh1MzIgbm9kZSwgZW51bSBwbV9nZW1fY29uZmlnX3R5cGUNCj4gY29uZmln
LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTMyIHZhbHVlKSB7DQo+ID4gKyAg
ICAgICByZXR1cm4genlucW1wX3BtX2ludm9rZV9mbihQTV9JT0NUTCwgbm9kZSwNCj4gSU9DVExf
U0VUX0dFTV9DT05GSUcsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBj
b25maWcsIHZhbHVlLCBOVUxMKTsgfQ0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTCh6eW5xbXBfcG1f
c2V0X2dlbV9jb25maWcpOw0KPiA+ICsNCj4gPiArLyoqDQo+ID4gICAqIHN0cnVjdCB6eW5xbXBf
cG1fc2h1dGRvd25fc2NvcGUgLSBTdHJ1Y3QgZm9yIHNodXRkb3duIHNjb3BlDQo+ID4gICAqIEBz
dWJ0eXBlOiAgIFNodXRkb3duIHN1YnR5cGUNCj4gPiAgICogQG5hbWU6ICAgICAgTWF0Y2hpbmcg
c3RyaW5nIGZvciBzY29wZSBhcmd1bWVudA0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L2Zpcm13YXJlL3hsbngtenlucW1wLmgNCj4gPiBiL2luY2x1ZGUvbGludXgvZmlybXdhcmUveGxu
eC16eW5xbXAuaA0KPiA+IGluZGV4IDFlYzczZDUzNTJjMy4uMDYzYTkzYzEzM2YxIDEwMDY0NA0K
PiA+IC0tLSBhL2luY2x1ZGUvbGludXgvZmlybXdhcmUveGxueC16eW5xbXAuaA0KPiA+ICsrKyBi
L2luY2x1ZGUvbGludXgvZmlybXdhcmUveGxueC16eW5xbXAuaA0KPiA+IEBAIC0xNTIsNiArMTUy
LDkgQEAgZW51bSBwbV9pb2N0bF9pZCB7DQo+ID4gICAgICAgICAvKiBSdW50aW1lIGZlYXR1cmUg
Y29uZmlndXJhdGlvbiAqLw0KPiA+ICAgICAgICAgSU9DVExfU0VUX0ZFQVRVUkVfQ09ORklHID0g
MjYsDQo+ID4gICAgICAgICBJT0NUTF9HRVRfRkVBVFVSRV9DT05GSUcgPSAyNywNCj4gPiArICAg
ICAgIC8qIER5bmFtaWMgU0QvR0VNIGNvbmZpZ3VyYXRpb24gKi8NCj4gPiArICAgICAgIElPQ1RM
X1NFVF9TRF9DT05GSUcgPSAzMCwNCj4gPiArICAgICAgIElPQ1RMX1NFVF9HRU1fQ09ORklHID0g
MzEsDQo+ID4gIH07DQo+ID4NCj4gPiAgZW51bSBwbV9xdWVyeV9pZCB7DQo+ID4gQEAgLTM5Myw2
ICszOTYsMTggQEAgZW51bSBwbV9mZWF0dXJlX2NvbmZpZ19pZCB7DQo+ID4gICAgICAgICBQTV9G
RUFUVVJFX0VYVFdEVF9WQUxVRSA9IDQsDQo+ID4gIH07DQo+ID4NCj4gPiArZW51bSBwbV9zZF9j
b25maWdfdHlwZSB7DQo+ID4gKyAgICAgICBTRF9DT05GSUdfRU1NQ19TRUwgPSAxLCAvKiBUbyBz
ZXQgU0RfRU1NQ19TRUwgaW4gQ1RSTF9SRUdfU0QNCj4gYW5kIFNEX1NMT1RUWVBFICovDQo+ID4g
KyAgICAgICBTRF9DT05GSUdfQkFTRUNMSyA9IDIsIC8qIFRvIHNldCBTRF9CQVNFQ0xLIGluIFNE
X0NPTkZJR19SRUcxDQo+ICovDQo+ID4gKyAgICAgICBTRF9DT05GSUdfOEJJVCA9IDMsIC8qIFRv
IHNldCBTRF84QklUIGluIFNEX0NPTkZJR19SRUcyICovDQo+ID4gKyAgICAgICBTRF9DT05GSUdf
RklYRUQgPSA0LCAvKiBUbyBzZXQgZml4ZWQgY29uZmlnIHJlZ2lzdGVycyAqLyB9Ow0KPiA+ICsN
Cj4gPiArZW51bSBwbV9nZW1fY29uZmlnX3R5cGUgew0KPiA+ICsgICAgICAgR0VNX0NPTkZJR19T
R01JSV9NT0RFID0gMSwgLyogVG8gc2V0IEdFTV9TR01JSV9NT0RFIGluDQo+IEdFTV9DTEtfQ1RS
TCByZWdpc3RlciAqLw0KPiA+ICsgICAgICAgR0VNX0NPTkZJR19GSVhFRCA9IDIsIC8qIFRvIHNl
dCBmaXhlZCBjb25maWcgcmVnaXN0ZXJzICovIH07DQo+IA0KPiBBcyB5b3UgYWRhcHRlZCBrZXJu
ZWwgc3R5bGUgZG9jdW1lbnRhdGlvbiBmb3IgdGhlIHJlc3Qgb2YgY29kZSBhZGRlZCBpbiB0aGlz
DQo+IHBhdGNoIHlvdSBjYW4gZm9sbG93IHRoaXMgcnVsZXMgZm9yIGVudW1zLCB0b28uDQoNCldo
aWNoIHBhcnRpY3VsYXIgc3R5bGUgaXNzdWUgeW91IGFyZSBtZW50aW9uaW5nIGhlcmU/IFRoZXJl
IGlzIGEgdGFiIA0KYmVmb3JlIEdFTV9DT05GSUdfKiBlbnVtIG1lbWJlciBhbmQgYWxzbyBjaGVj
a3BhdGNoICAtLXN0cmljdCANCnJlcG9ydCBubyBpc3N1ZXMuDQoNCj4gDQo+ID4gKw0KPiA+ICAv
KioNCj4gPiAgICogc3RydWN0IHp5bnFtcF9wbV9xdWVyeV9kYXRhIC0gUE0gcXVlcnkgZGF0YQ0K
PiA+ICAgKiBAcWlkOiAgICAgICBxdWVyeSBJRA0KPiA+IEBAIC00NjgsNiArNDgzLDkgQEAgaW50
IHp5bnFtcF9wbV9mZWF0dXJlKGNvbnN0IHUzMiBhcGlfaWQpOyAgaW50DQo+ID4genlucW1wX3Bt
X2lzX2Z1bmN0aW9uX3N1cHBvcnRlZChjb25zdCB1MzIgYXBpX2lkLCBjb25zdCB1MzIgaWQpOyAg
aW50DQo+ID4genlucW1wX3BtX3NldF9mZWF0dXJlX2NvbmZpZyhlbnVtIHBtX2ZlYXR1cmVfY29u
ZmlnX2lkIGlkLCB1MzINCj4gdmFsdWUpOw0KPiA+IGludCB6eW5xbXBfcG1fZ2V0X2ZlYXR1cmVf
Y29uZmlnKGVudW0gcG1fZmVhdHVyZV9jb25maWdfaWQgaWQsIHUzMg0KPiA+ICpwYXlsb2FkKTsN
Cj4gPiAraW50IHp5bnFtcF9wbV9zZXRfc2RfY29uZmlnKHUzMiBub2RlLCBlbnVtIHBtX3NkX2Nv
bmZpZ190eXBlDQo+IGNvbmZpZywNCj4gPiArdTMyIHZhbHVlKTsgaW50IHp5bnFtcF9wbV9zZXRf
Z2VtX2NvbmZpZyh1MzIgbm9kZSwgZW51bQ0KPiBwbV9nZW1fY29uZmlnX3R5cGUgY29uZmlnLA0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTMyIHZhbHVlKTsNCj4gPiAgI2Vsc2UN
Cj4gPiAgc3RhdGljIGlubGluZSBpbnQgenlucW1wX3BtX2dldF9hcGlfdmVyc2lvbih1MzIgKnZl
cnNpb24pICB7IEBADQo+ID4gLTczMyw2ICs3NTEsMjEgQEAgc3RhdGljIGlubGluZSBpbnQgenlu
cW1wX3BtX2dldF9mZWF0dXJlX2NvbmZpZyhlbnVtDQo+ID4gcG1fZmVhdHVyZV9jb25maWdfaWQg
aWQsICB7DQo+ID4gICAgICAgICByZXR1cm4gLUVOT0RFVjsNCj4gPiAgfQ0KPiA+ICsNCj4gPiAr
c3RhdGljIGlubGluZSBpbnQgenlucW1wX3BtX3NldF9zZF9jb25maWcodTMyIG5vZGUsDQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZW51bSBwbV9zZF9jb25m
aWdfdHlwZSBjb25maWcsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgdTMyIHZhbHVlKSB7DQo+ID4gKyAgICAgICByZXR1cm4gLUVOT0RFVjsNCj4gPiArfQ0K
PiA+ICsNCj4gPiArc3RhdGljIGlubGluZSBpbnQgenlucW1wX3BtX3NldF9nZW1fY29uZmlnKHUz
MiBub2RlLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBl
bnVtIHBtX2dlbV9jb25maWdfdHlwZSBjb25maWcsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHUzMiB2YWx1ZSkgew0KPiA+ICsgICAgICAgcmV0dXJuIC1F
Tk9ERVY7DQo+ID4gK30NCj4gPiArDQo+ID4gICNlbmRpZg0KPiA+DQo+ID4gICNlbmRpZiAvKiBf
X0ZJUk1XQVJFX1pZTlFNUF9IX18gKi8NCj4gPiAtLQ0KPiA+IDIuMS4xDQo+ID4NCg0K
