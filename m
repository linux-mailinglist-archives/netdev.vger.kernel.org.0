Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09646E5C18
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 10:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjDRIdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 04:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjDRIdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 04:33:18 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2105.outbound.protection.outlook.com [40.107.6.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7E576A5;
        Tue, 18 Apr 2023 01:32:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g20FnO/YAt1Qr/gmRT7fpCWvIH7TF/VhECYVuFHxLS8YV+G2dR+zZhkkm8Gw+6c/ao3alUznhRuseDD364CrL2NbLAszPhrL+z9MHg8J1SXeFvTnRHl+nCCHttHwixZ/TNSxWLq5B5xm7BLkxjMluKeyapc4BzibPF+FCv5jNOK0RFyHSKr4PoZYDOXTNWbGFQkOaFnadO+MCjsPk12weVA3nLrcBOh5VgVypPly+nXptPsFqnvBO0pgI+7vHzbI9pf3zVmpgzHK0S/dhVxQTlxm8AVQBIumtKDpDQujwt58vccSo38uyETncn5w5mbgZnHC7COXIi/4pH1Nx/ocmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CK8viEHb+nRPnlILGb8eB4oHtL1CJ6k8sTdDn2hI5v8=;
 b=jYV8uEZcyBTlaj48lx3rEsjybPHQ9en2Uf75vzbxNyochupMyZb6x5i9c3EuvohGZLjmB5MglvXJ6jCzkHJqXpn9RysI/Y0X7bkaCM6NWcm9X3CQNzu8KiygsoLRUIGOl1D5Hi6H7+YJdji8yA9Tug7bECB9quulDba9lQKn68mlmIZso8C4k+8uYjfLKhQfI4FFkQJ4Z+gk2yrgByx9WwuzRJTNWtE4PiD5J4KtGK/cLJV0OQ8ckOje8mlCDfFamPAmlyQBM6oyaGRFBB4gwa6X6MHpFsUGX4rtZppktYSgmcu8f7czWBSLKBk3DzMJgwVlfT3m/yfI/upQtY1r0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siklu.com; dmarc=pass action=none header.from=siklu.com;
 dkim=pass header.d=siklu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siklu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CK8viEHb+nRPnlILGb8eB4oHtL1CJ6k8sTdDn2hI5v8=;
 b=xoBtvKi57dM3Xkr8ooIJOQfd/YkIOqZ7rjZqKFS522Y3h6g1O+mYuqYc26nvIHhvYWhfZP7qyLyzVkORQfpms6zYo5blYnT0Xd51fyokvYk6NuSPVsjRBXC4JocrC4v0b6nleZdIiw7dj+wjjOgc5DfvBLKLp7HU22GWp5szk3g=
Received: from AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:26::11) by VI1PR01MB6623.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:183::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 08:32:36 +0000
Received: from AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 ([fe80::8941:8fd5:b4b2:9a3e]) by
 AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 ([fe80::8941:8fd5:b4b2:9a3e%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 08:32:35 +0000
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "krzk@kernel.org" <krzk@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH v2 3/3] dt-bindings: net: marvell,pp2: add extts docs
Thread-Topic: [PATCH v2 3/3] dt-bindings: net: marvell,pp2: add extts docs
Thread-Index: AQHZcU8s4YabXrARoUW85WcCTqyWVq8vxr+AgAD3PgA=
Date:   Tue, 18 Apr 2023 08:32:35 +0000
Message-ID: <b0f530ee10c2227b87cf6fd85db13fd33c4eb75f.camel@siklu.com>
References: <20230417170741.1714310-1-shmuel.h@siklu.com>
         <20230417170741.1714310-4-shmuel.h@siklu.com>
         <6e558956-3bed-c1eb-5474-c272fdc14763@kernel.org>
In-Reply-To: <6e558956-3bed-c1eb-5474-c272fdc14763@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siklu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR0102MB3106:EE_|VI1PR01MB6623:EE_
x-ms-office365-filtering-correlation-id: 21cc6cac-5cfc-47de-6ccd-08db3fe77626
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OBbRP+YVQHK+0PCRtNylf/UmyzGBteBGurDyzYq4IkvCivUdsNskGPQwUumFnAPE5JoUc/IVvQzM6sXAcMiQwwEvKL0laW/vKU+LkRwfNNAumeFMQ9jKmfj4s9TGqVgFFJv7lAEjvDUahaA0368TKMm+hhMnBiA41sy63CZhJP25T+zf8IrVb+5qbLguIDuUIYQ7tMArU2vkAKzye1j+8sAIY05ELN7bZ7FFj+tVPMi7iFScN+19Dj+qfZYude4UvOxmNakQbIzbSTaWSXojtm6dEShh8WBxai0FIM3lbuSllCnDhv3FvhpsOh7FWK2TARjCwAP5O4Q0RVe9CFgvpa7eWCKBiJv5mSDaR7Shm3lG7KFbR2d5RQi/2vqsm+pUNpNYs5mfMlafmjvXb1CsiGccpcFzVmCnx7HWX3R5x+PIt4Fpkd3h2300MRDRCOQTyVJSLflNYhkA4xYaxYTws7QoG1GKkYQmx/YI4sabtM2es3An1mcvor2ugKgjFY7I213UZ9dTgzE/nlToY0b9yTRnZ22NjJd02q5d6D7zD2R+xE+aJF+omX879KOzFstHZWD/nJ8g3y2ejDzROgLLz/fJRJBh+6Q4krwze2vBz/SofArUK8KbFXvz/b4P8MQK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0102MB3106.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(366004)(376002)(346002)(136003)(451199021)(26005)(186003)(6506007)(6512007)(41300700001)(110136005)(66946007)(54906003)(53546011)(91956017)(86362001)(2616005)(4326008)(316002)(76116006)(64756008)(66476007)(66446008)(66556008)(4744005)(2906002)(7416002)(8676002)(8936002)(6486002)(122000001)(38100700002)(36756003)(5660300002)(38070700005)(71200400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkJQTDJDci9HKzVaTHRJRlU4bzl6TVNwNyszZlA1UDEyeWFua0tzVy9kM0Nu?=
 =?utf-8?B?Rmp5ckFZdkMyMG40VmZMdlNSaENsUkNtcmZXYkk1RS9VMzVWaEx5dWErNHEz?=
 =?utf-8?B?L2JWZTlSVjgvSVk5alg0VEdEdzM5dWl2UlYxSE50bzlhbVpMdUZ2eXpic2R6?=
 =?utf-8?B?RllNSEtRM293Rk9aRnIzSmVVNFBKU05kb2g2UTVsUnY3ekJIQ0YwOXRmYlZI?=
 =?utf-8?B?UlNNU3k3RFBOSnZ2WnFuc0dhMXZZUUw0WnB6MXo1WjNIWGEzamdYQXUwbXVL?=
 =?utf-8?B?aG13TkdVNkhIQ2NLbklUbTlkaEpZeFpnT2RUS1RJR0tBb1lQSkExdE9EM0Uy?=
 =?utf-8?B?RHVyb1UzcnJibzVCZURBY3Y2MWRxRVZ0cHhIUm5iby9WMmtNbVo4cTRWMU9R?=
 =?utf-8?B?VGNzNFZ4ditTdkgrS1lOVlBWbmQycDkyOFY2bGxSdndsN3VWcEpDOXNBRTl2?=
 =?utf-8?B?Nk1TKzkvY2h0aE1BQ2pYb2hEeE5oNDJQbGZpSzgyQ2sxSEYweVB5TlZmRkhp?=
 =?utf-8?B?VkFRc055TWltcVM0a2hoeHZWbjFyemVHbVIydFZucmxvaFd6OFBBQWV6K01i?=
 =?utf-8?B?MUlkVmY3NDYvVyt1Y3VIOTJZcWVGbldZVkJYWTA1ZmdJMm9nR1dhN3Z4Zi8r?=
 =?utf-8?B?VmNPWFNLMVdTK3hHalZnZk4zSGZPSGZKeEtmTlN2cUN1TTkvbGtPWGNXZmRE?=
 =?utf-8?B?WjFaRVgreGU1TEJjUHV6QlI3K3N6ek1KcUx4UlRvNjJSS2REb3NwTkNHUVQ5?=
 =?utf-8?B?Qk1HSDg5ZlB2QmdzTmtrK0R5UDYyVGRjOWtwZTk0Q0Y0SjNnVUtpTEI1N05r?=
 =?utf-8?B?OTh1R3pZdUVJNktPNUtTQ0Zjc3NWNyt4M0pZckVTdDBCcE1JTldCbWkrN1J1?=
 =?utf-8?B?c0xjdlRiR3A5MmhXOTFBWUhvdXJtWFlucjQ1ZzYwRDhJL1BuR2RHcmg5TlFh?=
 =?utf-8?B?OUZ4Y2VFRHBid09kV1Z0YXJ0WGNRZ1psSlo0U3h2cnROMXp6dVBGcU1sQU9q?=
 =?utf-8?B?UUFiMjlUTzlFaW5NQUFpYmZDNjVuMWZ6c0huU1l2cVVSd25IYm5DK0J6Ry81?=
 =?utf-8?B?b2FDOFlGaXFEYWFOUzdYMUVEU21ZTnBLUEY5Q2NJN3JRSmc2bDlsanFqNndl?=
 =?utf-8?B?TndLRkE1RkVzYTJyQ1JFMXUvZEtPTDJ2N1Nwdy9melZROGpBUkhFMkVJeHgw?=
 =?utf-8?B?OHhJVGNDRGdSQ1dhT2dGbXlnVG01RHcxV244YUdtZ2g4QU5EMUZ1aCs0RnJr?=
 =?utf-8?B?WnhOWGJoaDRlOGVIdlBtanVVK0lhaUJlM3NadDVhUjdFZVNXS2oyU20vSlVy?=
 =?utf-8?B?NHZHSkJLc2JkcEszRkFnVC95bG1LSHBhazFSU0lyS01rWHp6WW9RWFBPSS9T?=
 =?utf-8?B?cERvbVVkZXNnZURZS1B4M3NvUVFWT2MvTFVuZmJ5VUtabS9PaGdJQ2JkUytt?=
 =?utf-8?B?dmpybFpQRXJsZnJqbVJTQWZuRUR6bXVMd3ZuN2dnam9LMzhMVjNQUHBuL3gx?=
 =?utf-8?B?VVYzYVlCWDhmNDVRZ2lzZllIWHhtRjhLVzhTcWJYU2hWcEdRd0xFNW5WU2Zy?=
 =?utf-8?B?VkdZV2o4aFJXaVl3bWlYZHp6c3RIM3FFMXNqVG9NVXZCU0xBYndZL2ZSUEZn?=
 =?utf-8?B?R1Ezc0E5bFdza0t3VTRDUnBqWXpvNjlrWXVhMi84aUNBU1d0MG16QWVJSkw3?=
 =?utf-8?B?QWg0SnlJcTdmNGhPekQ5SmQ2aSs0SjJMa0dhUU1OUFJmWGdpM3BnV2NjeUhC?=
 =?utf-8?B?WVZBaC95eUEyYUpXSUd0aDZPSzlHbXJDaDFXcllneXd0dFJ4Y083NWJpYXNx?=
 =?utf-8?B?b3ZwMlRtZlNSbFV5NE9XMEd0OEFEcU41bHRQQWR6bEorZjB3ZGxKVFRDaFY3?=
 =?utf-8?B?d1YzWUNEOEdIRm01d2lHTGt4YXByeVgxYTJWWHpVbHBQWjRjOUF5VVhNSHR6?=
 =?utf-8?B?WSs3RURkV3AySVM2Zk55R1pENG1sVmFMNmZoNUxVWXJaNnJKUHlrNXZYWlFt?=
 =?utf-8?B?QVNBaUhtMXVvMmV4eFFGWVVhY3pKYitSTXpkNVFDYnUvdmpVVmV6ZDBlczFX?=
 =?utf-8?B?Z1Qzd0IydXo0b21ocGZvSVdFejQ0R0dNV0ZxTjJIdisrcnpDTGpHcm5wS1Ba?=
 =?utf-8?Q?uZ6U0/ZrRb9K8ya8+UfBqfoxk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A5ACBE02B22354EAD5DA2B0F52D54EF@eurprd01.prod.exchangelabs.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siklu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21cc6cac-5cfc-47de-6ccd-08db3fe77626
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 08:32:35.5200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5841c751-3c9b-43ec-9fa0-b99dbfc9c988
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tigV7DP7RRcTFG4PE5qn4MgOpFIjXKhQ/3Tw6/e+wb445mAqu4TYSBQq3gY0heJoYrnyXO/C5rbJHz9nUJhhrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR01MB6623
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIzLTA0LTE3IGF0IDE5OjQ3ICswMjAwLCBLcnp5c3p0b2YgS296bG93c2tpIHdy
b3RlOg0KPiBDYXV0aW9uOiBUaGlzIGlzIGFuIGV4dGVybmFsIGVtYWlsLiBQbGVhc2UgdGFrZSBj
YXJlIHdoZW4gY2xpY2tpbmcgbGlua3Mgb3Igb3BlbmluZyBhdHRhY2htZW50cy4NCj4gDQo+IA0K
PiBPbiAxNy8wNC8yMDIzIDE5OjA3LCBTaG11ZWwgSGF6YW4gd3JvdGU6DQo+ID4gQWRkIHNvbWUg
ZG9jdW1lbnRhdGlvbiBhbmQgZXhhbXBsZSBmb3IgZW5hYmxpbmcgZXh0dHMgb24gdGhlIG1hcnZl
bGwNCj4gPiBtdnBwMiBUQUkuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU2htdWVsIEhhemFu
IDxzaG11ZWwuaEBzaWtsdS5jb20+DQo+IA0KPiBQbGVhc2UgdXNlIHNjcmlwdHMvZ2V0X21haW50
YWluZXJzLnBsIHRvIGdldCBhIGxpc3Qgb2YgbmVjZXNzYXJ5IHBlb3BsZQ0KPiBhbmQgbGlzdHMg
dG8gQ0MuICBJdCBtaWdodCBoYXBwZW4sIHRoYXQgY29tbWFuZCB3aGVuIHJ1biBvbiBhbiBvbGRl
cg0KPiBrZXJuZWwsIGdpdmVzIHlvdSBvdXRkYXRlZCBlbnRyaWVzLiAgVGhlcmVmb3JlIHBsZWFz
ZSBiZSBzdXJlIHlvdSBiYXNlDQo+IHlvdXIgcGF0Y2hlcyBvbiByZWNlbnQgTGludXgga2VybmVs
Lg0KPiANCj4gWW91IG1pc3NlZCBub3Qgb25seSBwZW9wbGUgYnV0IGFsc28gbGlzdCAtIGF0IGxl
YXN0IERUIG9uZSAtIHNvIHRoaXMNCj4gd29uJ3QgYmUgdGVzdGVkLg0KPiANCj4gQ2hhbmdlIGxv
b2tzIGdvb2QgdGhvdWdoLCBidXQgc3RpbGwgbmVlZHMgdGVzdGluZywgc28gcGxlYXNlIHJlc2Vu
ZC4NCj4gDQoNCkhpIEtyenlzenRvZiwNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suIEkgd2ls
bCByZXNlbmQgdGhlIHNlcmllcyBsYXRlciB0byB0aGUgaW5jbHVkZQ0KYWxzbyB0aGUgRFQgbGlz
dCBhbmQgcmVsZXZhbnQgbWFpbnRhaW5lcnMuIA0KDQo+IEJlc3QgcmVnYXJkcywNCj4gS3J6eXN6
dG9mDQo+IA0KDQo=
