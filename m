Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0DB6CF57E
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 23:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjC2VpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 17:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjC2VpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 17:45:02 -0400
Received: from DM4PR02CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11013002.outbound.protection.outlook.com [52.101.64.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB5940DC;
        Wed, 29 Mar 2023 14:44:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zc6c2KlgY+lLlBYi+G3nvhDlv2N8gkWWuVFHD6VHcLzlif6k1mYzoIyjHiEeAznPpfgQrNTUuVNYOeG9worJxXKHdn2V8V9dBTGzIuGGJm8OVngcG8UQnM9y09wNyLJs52WiEIwKIiQ7y2aHNoB/T5NvRmBW9sh0zPRg8ExlhphysNc1juSXSH7dsJmiopxhVdOPDKYhF99iN1Nbhs9pZrPcpFc7D2QgF0XaoBmLd+MDWTP0hmO3vjmReDO2gQJlJURkh3jI92Mvi8e1xx3CuHJ4CvKIS3h4q25+CmgvyiQ07/yVDGVQ1o+XF11DaIPhkUJ1v+a1egrMCEaAqHXO9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/MHb3uUz1RFzvEHbdAZ23IDcdbggyDpROKGRvIVQU4=;
 b=LW/q08Jj3E1z3DPJGr/kfGWrKliaSh51tiLEsMFebvThsV4Qd4/+Kt45Lqic3AqS2VoM7U3K/Ep479gxz3IKPgMox8fUAdk6rLU+YEpw7D7cAiUho7EnXrnc9Tyd4fHTb21zV1Xy8dKuOVKIJkT71LP9GojqAhtGgg+JjtfQRkpAXheU3jggf2ipI0WzxI28Amf2B5FnMJ80FWXhrAVyw9pZLMrEGB6oIEX5aWEzKv/e9o5h27lvNw1xLEjqNIKNfago50lB4KmABFAu3QS6cODN/Us4iUPCyGuUhTmK5vsaEVSbDfAz3OPrve8/XSF06a8vkZ1zuN9O8LPIY7iWEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/MHb3uUz1RFzvEHbdAZ23IDcdbggyDpROKGRvIVQU4=;
 b=zz+2/ulJeQ+9d9nAvUI5yfL8MCNjvRO1wplbhu3t0Y3h51+AKj3ldZSfJQRdvRe64E0iKJV0jczua1VZR8taxo17j6liFxW2/KfjY6SMePgNGTwaXmOZcfNEZ60vYCU8xjdvrxhXuJ2197ITsXVbPJZUf3ALp0mjxdGBUh5OzzQ=
Received: from BYAPR05MB3960.namprd05.prod.outlook.com (2603:10b6:a02:88::12)
 by MWHPR05MB3037.namprd05.prod.outlook.com (2603:10b6:300:66::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Wed, 29 Mar
 2023 21:44:56 +0000
Received: from BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::8cb8:9578:d0c0:83d3]) by BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::8cb8:9578:d0c0:83d3%7]) with mapi id 15.20.6222.035; Wed, 29 Mar 2023
 21:44:56 +0000
From:   Vishnu Dasa <vdasa@vmware.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     Bryan Tan <bryantan@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 1/2] vsock: return errors other than -ENOMEM to
 socket
Thread-Topic: [RFC PATCH v1 1/2] vsock: return errors other than -ENOMEM to
 socket
Thread-Index: AQHZYVmt0SAOkvisqUmdGPRwnwHd1q8QAT2AgAAKT4CAAABfgIACQLyA
Date:   Wed, 29 Mar 2023 21:44:56 +0000
Message-ID: <B25B4275-957C-4052-B089-3714B6A7B0A3@vmware.com>
References: <97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru>
 <99da938b-3e67-150c-2f74-41d917a95950@sberdevices.ru>
 <itjmw7vh3a7ggbodsu4mksu2hqbpdpxmu6cpexbra66nfhsw4x@hzpuzwldkfx5>
 <CAGxU2F648TyvAJN+Zk6YCnGUhn=0W_MZTox7RxQ45zHmHHO0SA@mail.gmail.com>
 <0f0a8603-e8a1-5fb2-23d9-5773c808ef85@sberdevices.ru>
 <ak74j6l2qesrixxmw7pfw56najqhdn32lv3xfxcb53nvmkyi3x@fr25vo2jlvbj>
 <64451c35-5442-73cb-4398-2b907dd810cc@sberdevices.ru>
In-Reply-To: <64451c35-5442-73cb-4398-2b907dd810cc@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB3960:EE_|MWHPR05MB3037:EE_
x-ms-office365-filtering-correlation-id: 5a7a2c8c-33da-4f87-c3fb-08db309ed66f
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YWiD7Ju/JO4PziHT33p8LGmye9GjD2HypkaWoI6bR9kJvR5DcgUBS11cq8hgKOuSY95zaWeDW+7P5Wr5DzyqgYlmHgvaZJ4CaslaBX7KHUaS1fTYBOG6DjW+Jeqg1frPwh7R1Irm3ye2SB+SIKiBZzhIv9+/PuTWMGsxSTqvXtY9zDqxJHu0MHZJXWBeu8Ojuzzw/OHcy9AUqmF0191JwZmbFKbYYVl65l22+IaMs5KMB0vhoxwjW6aqeqJ9j/GWHr4Yct92AySFNSMMX9/KIDHPx88RK1Q0u32lkMCLjGGiaJl6MH0RFE39NtaKRhO9Xzu2T2zK4PiZLINuAmMFIWdCTSnRpEN4wxOs9XI53iq6nJ8J5Dr1a0CpAf5OYIh/WtL1wb/IGymmOETpxtZox55DGWR7G4DRZ4cPz4mwUlLSpDbLZpioTAkrPW+6z792+GMXxssUnNOvPOHtryxgxhFCM1af9oPK2imRO5i707IsrLEE18gYLobS4+MZydUvwCREJPiNG20fEqe6wRLa0kjS66DsJEuXjl/lMqxPWUXMfni1MAzNJJ7R2NfO/t1t3jrekHjk/f4or6Z7XYrGVTvufPea2qfZqaUflCXAiJHivmTgj8fYqd0QVkfSdnBqfwN5NmKv/hrfzcxE1cRRr2TPPGCs/F+DxLd/gfJTu3RoIoA1jdIltOjO9JTy9ig1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB3960.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(451199021)(122000001)(7416002)(38070700005)(71200400001)(5660300002)(6512007)(6506007)(2616005)(86362001)(2906002)(33656002)(36756003)(53546011)(186003)(966005)(83380400001)(6486002)(8936002)(41300700001)(478600001)(110136005)(45080400002)(76116006)(66946007)(4326008)(54906003)(66556008)(8676002)(66476007)(64756008)(66446008)(38100700002)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFBnMlVML0ZaSncvYnNxY2NkVmhvOGVFcFJ6eU1YT1B3aDEyb1ZoZDRWRndx?=
 =?utf-8?B?ZWRDMzBodGJoQmdPSFJXeXcyMWt0Z2REVVdRMmhLWFJ3YWcvSVBnVzFzcWJ4?=
 =?utf-8?B?UnFUK3diZkRDUWcyaExWK3FMRXpBSkk1cndhczBtdVl5ZFAzbjlkeTFTUVJZ?=
 =?utf-8?B?OUFDaldNL1BaVXRFQlo1UVZINlM0dTh3L1dYd3R2bFVkNkxOUVVQQXVvbXJX?=
 =?utf-8?B?V1J2SGZuWDZDb0pPTGNEUDdYTnlaOFYveGZ2ZjdPUWFuRmdFQUlWMDI2MTVW?=
 =?utf-8?B?OWhzTlZEWHZQWnRmei9TR0VmUWFKVXdwMTF2YUdYaENlWUU4MTloZVM0QW8r?=
 =?utf-8?B?MG5MSmZiTGxzRy81Q2dCS211LzF6QXdOdzlNeUEvOW9nVjF4UFY1Vy91Y0t3?=
 =?utf-8?B?bHZ3TVk1aW5na21tMTc0dXBsb1dud3VodGdXcWFvUUd4NkpZRVQrUWJYNzA2?=
 =?utf-8?B?SU9RL0p3NnNVL2VjajA2L2szSDNoY0VQK1Q3QXpnbjBGRlQ0WXVxL3NuTzM3?=
 =?utf-8?B?dGQxUzJXR2pwejJ4UXpoN1lDWjFhNHBzekdTYnJrY0tPcnJ5RkVFdEkweDhk?=
 =?utf-8?B?cFlka3RuM0J4dnh5VWlOTDdOVDZPdit5dVMxcWM3Y1NaN003NXZ6RnRGLy92?=
 =?utf-8?B?blEzSzJqTGF3aWgreW5STXJsdVlMdmdKUlRBc1Z2N2FZYmNURDdRS1NMendJ?=
 =?utf-8?B?VVRQeHErUUxCNS94a0ZZR0pGblpYblJmdnJFMWFyZElUa1FYeGQvWXVVSGdB?=
 =?utf-8?B?ZnpiNGJ2V1l0K0dhNGxXNU4ydXJuU05pTjFWcEU5WlMxN244N29yV2RBRWNZ?=
 =?utf-8?B?VHFrTGFZNHFwdXZTRDBudWdVMlVpaU44Z2FZYVpXSnExOTBOek15UWt2dzRO?=
 =?utf-8?B?RVZpRUJkUDJERGltTUhlbW10TGhKdnhhK1VGNHMrS0xqNlAwMWFURGkxV0Ur?=
 =?utf-8?B?Vjlrc0I1WFpxVFM1bzJVSWNrUmxCblB3djkzUTdzbGQrT3dVWlovWjRPSXl5?=
 =?utf-8?B?WFBlMHdqNzVYaG96Nk83Qkw2YWl1dG1PNWFMTUxubkNkaTQ4S2hIVGRHQlps?=
 =?utf-8?B?Q0kxYnBjUVFTemdJYkZtTmIzZDRmbUI4QURWSFlucUx3VVY2RGVCczIxYlhM?=
 =?utf-8?B?ckl3eTJGMlJGMVBWdDVtNXJDMVQ0SGlQQktudWdpUnRXMkZBTzE0TFBBOHRX?=
 =?utf-8?B?VHpwZFFSa3BreUljZlduL3F2ckltNmFXODdVa1ZoYVc5NUJTRS9COXg0N0pW?=
 =?utf-8?B?OVVuRWtXZ2JHeDU2ak5OVElwRU41UDlzc1BOZUs1c2xqRWpJSFh4Qjc0ZEhK?=
 =?utf-8?B?am1qTGZCVUpEbDIwbTZSSUQ4d0hXUG9Jdkt5NzIweDR1N2txZWQ4OS9QMzNp?=
 =?utf-8?B?dXN6aWQ0K1g3cEY2T2VxTDYzemZSY25jL2JOSXIzYjRLdi81WFNOVlpjWEZ0?=
 =?utf-8?B?YmM4UTBXaWJna1h3VTBJSERTUFJrcGVSQThwa2czQTcxd1RkRHAvYUJ5Vjdx?=
 =?utf-8?B?ZWQ1SEc5Y1JzZUtuemM2S1h1UTl6YVhINFVFYUUxY09KVDY4OW10OVhUWFg4?=
 =?utf-8?B?eDRzd2RuL3NmeWtrazFiSDVPajBLSmlzWitEczVNYXdRTTVlczJzMUlHdEZH?=
 =?utf-8?B?WWcxcVZ3SEZFYkhlMDBjZWdnM3BHNEs0akU3Sk10VDRjaE9OOUU1WTRaSHpV?=
 =?utf-8?B?YVRRYmFuTjN5cFp0R0E0R3Vnekx2KzZUZVljR3NjbStoOGtwaFhTM2J1V21k?=
 =?utf-8?B?OXJwVkd2bjdER01LRUMxTFVPckpobFhrYUk1eTdJajVJLzZxUS9lRnV3alEv?=
 =?utf-8?B?c1czOWhjdU1aR0hwR1ZPN2FGU3g3UWVrSGhLcG56d2hKYjZDd2RnL2tsVW1t?=
 =?utf-8?B?WHgrMFF5VUNRNEpOVkVqa28rTVd4RDE5bndEbXFpV3NiWExXVWR0Z0pZWVR5?=
 =?utf-8?B?SHRTWjVvcWZpQzdYMkxXbzhVVkhubUlDS1Q2RlpIWkt0eEVyRmkyWld1d1lL?=
 =?utf-8?B?T1I4dnRQVTF0d1BXYkNNaHdEQzN2VmlxOWVnRzJSdVNPdm04aUdXdFJJcXds?=
 =?utf-8?B?NnlqYjI5RFIrOVpLZmNrZG9VN3lBUWxJZ3RwZ0l0Q1BBeE9QZTVhRlVYNE13?=
 =?utf-8?B?aHlSS0k2bmpKVHpMcW1uKzhWZko4bWtQNFo2VGs2cks2SmVTUEw3RVRvRDh1?=
 =?utf-8?Q?wCAi+qjfcWm0zZoretGy3Z/i5bz9BPuvgeNg3hVFwbMP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <51D797D87D37EF48BBE8918DC580B1F4@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB3960.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a7a2c8c-33da-4f87-c3fb-08db309ed66f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 21:44:56.3573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xkimASDeBnS10j++Yv9U+UEFMOZxXk1+LyNj/81flPIoOx1kqRjseCo+DuHbDrpbb3JvZ21syN16SVw3qfFn1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3037
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWFyIDI4LCAyMDIzLCBhdCA0OjIwIEFNLCBBcnNlbml5IEtyYXNub3YgPEFWS3Jh
c25vdkBzYmVyZGV2aWNlcy5ydT4gd3JvdGU6DQo+IA0KPiAhISBFeHRlcm5hbCBFbWFpbA0KPiAN
Cj4gT24gMjguMDMuMjAyMyAxNDoxOSwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPj4gT24g
VHVlLCBNYXIgMjgsIDIwMjMgYXQgMDE6NDI6MTlQTSArMDMwMCwgQXJzZW5peSBLcmFzbm92IHdy
b3RlOg0KPj4+IA0KPj4+IA0KPj4+IE9uIDI4LjAzLjIwMjMgMTI6NDIsIFN0ZWZhbm8gR2FyemFy
ZWxsYSB3cm90ZToNCj4+Pj4gSSBwcmVzc2VkIHNlbmQgdG9vIGVhcmx5Li4uDQo+Pj4+IA0KPj4+
PiBDQ2luZyBCcnlhbiwgVmlzaG51LCBhbmQgcHYtZHJpdmVyc0B2bXdhcmUuY29tDQo+Pj4+IA0K
Pj4+PiBPbiBUdWUsIE1hciAyOCwgMjAyMyBhdCAxMTozOeKAr0FNIFN0ZWZhbm8gR2FyemFyZWxs
YSA8c2dhcnphcmVAcmVkaGF0LmNvbT4gd3JvdGU6DQo+Pj4+PiANCj4+Pj4+IE9uIFN1biwgTWFy
IDI2LCAyMDIzIGF0IDAxOjEzOjExQU0gKzAzMDAsIEFyc2VuaXkgS3Jhc25vdiB3cm90ZToNCj4+
Pj4+PiBUaGlzIHJlbW92ZXMgYmVoYXZpb3VyLCB3aGVyZSBlcnJvciBjb2RlIHJldHVybmVkIGZy
b20gYW55IHRyYW5zcG9ydA0KPj4+Pj4+IHdhcyBhbHdheXMgc3dpdGNoZWQgdG8gRU5PTUVNLiBU
aGlzIHdvcmtzIGluIHRoZSBzYW1lIHdheSBhczoNCj4+Pj4+PiBjb21taXQNCj4+Pj4+PiBjNDMx
NzBiN2UxNTcgKCJ2c29jazogcmV0dXJuIGVycm9ycyBvdGhlciB0aGFuIC1FTk9NRU0gdG8gc29j
a2V0IiksDQo+Pj4+Pj4gYnV0IGZvciByZWNlaXZlIGNhbGxzLg0KPj4+Pj4+IA0KPj4+Pj4+IFNp
Z25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0K
Pj4+Pj4+IC0tLQ0KPj4+Pj4+IG5ldC92bXdfdnNvY2svYWZfdnNvY2suYyB8IDQgKystLQ0KPj4+
Pj4+IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+Pj4+
Pj4gDQo+Pj4+Pj4gZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svYWZfdnNvY2suYyBiL25ldC92
bXdfdnNvY2svYWZfdnNvY2suYw0KPj4+Pj4+IGluZGV4IDE5YWVhN2NiYTI2ZS4uOTI2MmUwYjc3
ZDQ3IDEwMDY0NA0KPj4+Pj4+IC0tLSBhL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KPj4+Pj4+
ICsrKyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KPj4+Pj4+IEBAIC0yMDA3LDcgKzIwMDcs
NyBAQCBzdGF0aWMgaW50IF9fdnNvY2tfc3RyZWFtX3JlY3Ztc2coc3RydWN0IHNvY2sgKnNrLCBz
dHJ1Y3QgbXNnaGRyICptc2csDQo+Pj4+Pj4gDQo+Pj4+Pj4gICAgICAgICAgICAgIHJlYWQgPSB0
cmFuc3BvcnQtPnN0cmVhbV9kZXF1ZXVlKHZzaywgbXNnLCBsZW4gLSBjb3BpZWQsIGZsYWdzKTsN
Cj4+Pj4+IA0KPj4+Pj4gSW4gdm1jaV90cmFuc3BvcnRfc3RyZWFtX2RlcXVldWUoKSB2bWNpX3Fw
YWlyX3BlZWt2KCkgYW5kDQo+Pj4+PiB2bWNpX3FwYWlyX2RlcXVldigpIHJldHVybiBWTUNJX0VS
Uk9SXyogaW4gY2FzZSBvZiBlcnJvcnMuDQo+Pj4+PiANCj4+Pj4+IE1heWJlIHdlIHNob3VsZCBy
ZXR1cm4gLUVOT01FTSBpbiB2bWNpX3RyYW5zcG9ydF9zdHJlYW1fZGVxdWV1ZSgpIGlmDQo+Pj4+
PiB0aG9zZSBmdW5jdGlvbnMgZmFpbCB0byBrZWVwIHRoZSBzYW1lIGJlaGF2aW9yLg0KPj4+IA0K
Pj4+IFllcywgc2VlbXMgaSBtaXNzZWQgaXQsIGJlY2F1c2Ugc2V2ZXJhbCBtb250aHMgYWdvIHdl
IGhhZCBzaW1pbGFyIHF1ZXN0aW9uIGZvciBzZW5kDQo+Pj4gbG9naWM6DQo+Pj4gaHR0cHM6Ly9u
YW0wNC5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJG
d3d3LnNwaW5pY3MubmV0JTJGbGlzdHMlMkZrZXJuZWwlMkZtc2c0NjExMDkxLmh0bWwmZGF0YT0w
NSU3QzAxJTdDdmRhc2ElNDB2bXdhcmUuY29tJTdDM2IxNzc5MzQyNTM4NGRlYmU3NTcwOGRiMmY3
ZWVjOGMlN0NiMzkxMzhjYTNjZWU0YjRhYTRkNmNkODNkOWRkNjJmMCU3QzAlN0MwJTdDNjM4MTU1
OTk0NDEzNDk0OTAwJTdDVW5rbm93biU3Q1RXRnBiR1pzYjNkOGV5SldJam9pTUM0d0xqQXdNREFp
TENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsxaGFXd2lMQ0pYVkNJNk1uMCUzRCU3QzMwMDAlN0Ml
N0MlN0Mmc2RhdGE9TU1mRmNLdUZGdk1jSnJiVG9Ldld2SUIlMkZabXpwJTJCZEdHVldGVld6dHVT
emclM0QmcmVzZXJ2ZWQ9MA0KPj4+IEFuZCBpdCB3YXMgb2sgdG8gbm90IGhhbmRsZSBWTUNJIHNl
bmQgcGF0aCBpbiB0aGlzIHdheS4gU28gaSB0aGluayBjdXJyZW50IGltcGxlbWVudGF0aW9uDQo+
Pj4gZm9yIHR4IGlzIGEgbGl0dGxlIGJpdCBidWdneSwgYmVjYXVzZSBWTUNJIHNwZWNpZmljIGVy
cm9yIGZyb20gJ3ZtY2lfcXBhaXJfZW5xdWV2KCknIGlzDQo+Pj4gcmV0dXJuZWQgdG8gYWZfdnNv
Y2suYy4gSSB0aGluayBlcnJvciBjb252ZXJzaW9uIG11c3QgYmUgYWRkZWQgdG8gVk1DSSB0cmFu
c3BvcnQgZm9yIHR4DQo+Pj4gYWxzby4NCj4+IA0KPj4gR29vZCBwb2ludCENCj4+IA0KPj4gVGhl
c2UgYXJlIG5lZ2F0aXZlIHZhbHVlcywgc28gdGhlcmUgYXJlIG5vIGJpZyBwcm9ibGVtcywgYnV0
IEkgZG9uJ3QNCj4+IGtub3cgd2hhdCB0aGUgdXNlciBleHBlY3RzIGluIHRoaXMgY2FzZS4NCj4+
IA0KPj4gQFZpc2hudSBEbyB3ZSB3YW50IHRvIHJldHVybiBhbiBlcnJubyB0byB0aGUgdXNlciBv
ciBhIFZNQ0lfRVJST1JfKj8NCj4gDQo+IFNtYWxsIHJlbWFyaywgYXMgaSBjYW4gc2VlLCBWTUNJ
X0VSUk9SXyBpcyBub3QgZXhwb3J0ZWQgdG8gdXNlciBpbiBpbmNsdWRlL3VhcGksDQo+IHNvIElJ
VUMgdXNlciB3b24ndCBiZSBhYmxlIHRvIGludGVycHJldCBzdWNoIHZhbHVlcyBjb3JyZWN0bHku
DQo+IA0KPiBUaGFua3MsIEFyc2VuaXkNCg0KTGV0J3MganVzdCByZXR1cm4gLUVOT01FTSBmcm9t
IHZtY2kgdHJhbnNwb3J0IGluIGNhc2Ugb2YgZXJyb3IgaW4NCnZtY2lfdHJhbnNwb3J0X3N0cmVh
bV9lbnF1ZXVlIGFuZCB2bWNpX3RyYW5zcG9ydF9zdHJlYW1fZGVxdWV1ZS4NCg0KQEFyc2VuaXks
DQpDb3VsZCB5b3UgcGxlYXNlIGFkZCBhIHNlcGFyYXRlIHBhdGNoIGluIHRoaXMgc2V0IHRvIGhh
bmRsZSB0aGUgYWJvdmU/DQoNClRoYW5rcywNClZpc2hudQ0KDQo+IA0KPj4gDQo+PiBJbiBib3Ro
IGNhc2VzIEkgdGhpbmsgd2Ugc2hvdWxkIGRvIHRoZSBzYW1lIGZvciBib3RoIGVucXVldWUgYW5k
DQo+PiBkZXF1ZXVlLg0KPj4gDQo+Pj4gDQo+Pj4gR29vZCB0aGluZyBpcyB0aGF0IEh5cGVyLVYg
dXNlcyBnZW5lcmFsIGVycm9yIGNvZGVzLg0KPj4gDQo+PiBZZWFoIQ0KPj4gDQo+PiBUaGFua3Ms
DQo+PiBTdGVmYW5vDQo+PiANCj4+PiANCj4+PiBUaGFua3MsIEFyc2VuaXkNCj4+Pj4+IA0KPj4+
Pj4gQ0NpbmcgQnJ5YW4sIFZpc2hudSwgYW5kIHB2LWRyaXZlcnNAdm13YXJlLmNvbQ0KPj4+Pj4g
DQo+Pj4+PiBUaGUgb3RoZXIgdHJhbnNwb3J0cyBzZWVtIG9rYXkgdG8gbWUuDQo+Pj4+PiANCj4+
Pj4+IFRoYW5rcywNCj4+Pj4+IFN0ZWZhbm8NCj4+Pj4+IA0KPj4+Pj4+ICAgICAgICAgICAgICBp
ZiAocmVhZCA8IDApIHsNCj4+Pj4+PiAtICAgICAgICAgICAgICAgICAgICAgIGVyciA9IC1FTk9N
RU07DQo+Pj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICBlcnIgPSByZWFkOw0KPj4+Pj4+ICAg
ICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPj4+Pj4+ICAgICAgICAgICAgICB9DQo+Pj4+Pj4g
DQo+Pj4+Pj4gQEAgLTIwNTgsNyArMjA1OCw3IEBAIHN0YXRpYyBpbnQgX192c29ja19zZXFwYWNr
ZXRfcmVjdm1zZyhzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBtc2doZHIgKm1zZywNCj4+Pj4+PiAg
ICAgIG1zZ19sZW4gPSB0cmFuc3BvcnQtPnNlcXBhY2tldF9kZXF1ZXVlKHZzaywgbXNnLCBmbGFn
cyk7DQo+Pj4+Pj4gDQo+Pj4+Pj4gICAgICBpZiAobXNnX2xlbiA8IDApIHsNCj4+Pj4+PiAtICAg
ICAgICAgICAgICBlcnIgPSAtRU5PTUVNOw0KPj4+Pj4+ICsgICAgICAgICAgICAgIGVyciA9IG1z
Z19sZW47DQo+Pj4+Pj4gICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPj4+Pj4+ICAgICAgfQ0KPj4+
Pj4+IA0KPj4+Pj4+IC0tDQo+Pj4+Pj4gMi4yNS4xDQo+Pj4+Pj4gDQo+Pj4+IA0KPj4+IA0KPj4g
DQo+IA0KPiAhISBFeHRlcm5hbCBFbWFpbDogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0
c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRh
Y2htZW50cyB1bmxlc3MgeW91IHJlY29nbml6ZSB0aGUgc2VuZGVyLg0KDQoNCg==
