Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823404C9AF4
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbiCBCIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiCBCIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:08:53 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2118.outbound.protection.outlook.com [40.107.237.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDCA40E50
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 18:08:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/lRUhAku/HOjP9G3akFbNYVt9yKb+N3FkWNn9NCP5qhq0WJGHFOow6d7r8mKDfhvh4xL74A+rWMrWWFxYQWYRqO0HSEYrMlfwKprvWJE2OymMIg/bDSgHxoIaEE60cRuYFN89Ay56EwACn3WRQWgNfs4mjzCGMKrpo+CzIZT7yzBCCuF5vzur1x3A9xZ6S5hgQmHZ9LPemBwngp+jKqBXMqySKRPcdj18wiPpYZ/hmS3sZW8Go/SngEAWdf3Qmm34SSnR3+Dvt4ylPvvihqjdsNOpOREuIEXCQf5XesR4njpYLIVwh3jpnkzlAiDnE4XBLx9avscIM8iX8Wo2dT9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UOkgoE+DUmDQsMpI+O+lCD40RMxFxLV03NT+CA75fwI=;
 b=l+fsA9/NBJnkdk8YfqN4UX8yIl9Uo3PYPQhadkAdsLWZOuRznaSFf/oU7yLMNvuOYBQWTOyKqIlw3yscasj1RZDwPhd52ReiavN3XyvuvWGuao26n0tJ+wTADepFjxnzeCQqHLysZ+wC2W8uY1hT251zH6SG+cibSRw44tyf8HiH5tO/6jKSVePaPYVfksccczjz/RtESN3pDLbOWblAnmpio0D+SKMdMXMdmsMegPnnoQA9sQMTZ/YbRFN93aCW5xeO5AJLC09B7buGXEN2rBeO8BxVQNRgVmCcQIzNFeCOv1h32TiwIGdMf9x6UHbD1kk+5oAUmRU8Y88m1mF1UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOkgoE+DUmDQsMpI+O+lCD40RMxFxLV03NT+CA75fwI=;
 b=VF4klF51BBao/i67kuHDw75a7SB0FhUS9lNp/K2o+pfJuoR+xEOxcJHSk6IXD9a1gP7kltr5oBgoMneuSWGFUZS1gwZITqaecxZzWoccvC7hbaFnai0lphGhfGfkUiK4rVRDwzv+t9HvwJlhRMGO6LE1g2jQGMjOq7exduwHjMg=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by BY3PR13MB4931.namprd13.prod.outlook.com (2603:10b6:a03:365::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.9; Wed, 2 Mar
 2022 02:08:06 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 02:08:05 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@nvidia.com" <roid@nvidia.com>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [PATCH net-next v1] flow_offload: improve extack msg for user
 when adding invalid filter
Thread-Topic: [PATCH net-next v1] flow_offload: improve extack msg for user
 when adding invalid filter
Thread-Index: AQHYLJA1WIpeXHQPrE2POqOUDtRW9qyrWCuAgAABaOA=
Date:   Wed, 2 Mar 2022 02:08:05 +0000
Message-ID: <DM5PR1301MB2172DF13345FBB630D5F0BB9E7039@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <1646045055-3784-1-git-send-email-baowen.zheng@corigine.com>
 <20220301175553.55274863@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220301175553.55274863@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e524e870-ebb6-4929-20c4-08d9fbf17d08
x-ms-traffictypediagnostic: BY3PR13MB4931:EE_
x-microsoft-antispam-prvs: <BY3PR13MB49318541446429CB79E8ABCBE7039@BY3PR13MB4931.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QH3zgrPrHjw7oM00f80EZEDpanrf3y5cIQ4qFQ7LhnddXDiMf6xdOUBa68wg0o3Qv5swYDFS6FfMETeDKCdBu/SXORvzSE6nDX66+Z7wUZCdFYA5yfmzoNynnCfuQxJj+HEFMeZp3I0Da/Zod5T94a2aBtNX9O9Tx9s96Nx22kA8Bl+UHDOaf9OxNpTmr6mgF1ZQcX9CHU0dXLisiJulweBwbC4N8bFth9+nZCjYNvL9mNA5U6KQiegR3yzxXM218J7WtVixDhgS8Umh5Gdzz8+FfAml95NIochIld3cqAFHNfYNnCb8GD5mA79iPIQPbcdcC6ftBafW7KUWPdds5Hyjcp104fE8zUvB3rJAN5zm2oZvYcsojvneuxosSUqIfI2ZQxZjnjBv+u/yhGU39ju9ZKbbi6X/F2ZHVxMDz5NYftsvvDWAMpdR+czDfy1eu9oI0M0NKsWxrcRnboeCnsVrFD8NK8wFlG4DIB0sa4Mmm7vkaCJy0kC/xjIW8NhxEJKIz1MkX5MqEwToZcVn2td5+4neNRY8ZJ355/wqKXwx+wJowgk5s/ouXE1qWb8OZ2JhVY9yCmb5WFQK3A3wenAvr5ap3LUtkYLuvT8vG+y/3ngSPsE6kz0yMDhcHiLR2oa1Vhbf8ANbc3jYDQuQVAtdpBPqSwYZrnxvPw3XrUbbuN5LAPEcnRH0u4d2h3Aqc0lZJwqoeMgVBk7KPcnW3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(396003)(366004)(346002)(376002)(38100700002)(122000001)(4326008)(7696005)(9686003)(76116006)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(86362001)(5660300002)(52536014)(33656002)(508600001)(8936002)(44832011)(38070700005)(53546011)(71200400001)(2906002)(83380400001)(316002)(55016003)(107886003)(26005)(6916009)(54906003)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0gxRFdhS2EySmtpSDh3c1JJUlZpT0gxTk0yWnpoYkw4TkU1OVpaVllqRzZP?=
 =?utf-8?B?b21KZUlmSSs5dVFON0o5Rk9pc1Y3VExjNzZTS3hXUWFpaUxQc0g1WXgvbkZh?=
 =?utf-8?B?RlhMSFRUeHYwa1B2L0xQRFJXSFBEYWh4Uk0wWmZjYS9mL2xKYytDWFNEUDZz?=
 =?utf-8?B?VGZ5OUczNlROOTJlTTlrVWZqZnV1eldnQzV0NkExNjk5Uksra3MxU1YwMTVu?=
 =?utf-8?B?Y21WOVhYc29VdUtaNkJkdjBJdjZOcWE0aHZTdFhvWUU2NTIwQ25lVlNTbEZU?=
 =?utf-8?B?TnBIVnFwV0JyNXRVOGRBRXpWYXhUZkZlT21oekZJZkZ1aTR1MXpUdE1QZ2kv?=
 =?utf-8?B?dndQaE1jOHlOVGpRU0ZrQVNzSEdHQ1Z6c2tZQnYvN3JkRFAxcVEyNlE2dk1O?=
 =?utf-8?B?WndBZndHcDJPWW5sMml6eGJsK3Vsd2NyYmdmTG5sSHg3cGRDU2FZTXptZSsy?=
 =?utf-8?B?Sy83c1VIMHRabldHNWVNTG5tWk4wZFRBK0hTRXJZMFRoUmluZU9XckN2TDA1?=
 =?utf-8?B?T0VVU1A0WVZhaWxQcllTUk51ZGsxRHRaNStabVIrVXpOeWpoN2VWMFFTYisz?=
 =?utf-8?B?VC94R3V2a25yU3hCZnJoOHBtUFlzV2I3OERDUUxFckZhNlFTbnRxRTc3d0lj?=
 =?utf-8?B?Ky82LytQNXM0d1ZyYlpXYjZwTVYrTmp3MEJmMHA0dmp3cnVRVDF3eW02ak9p?=
 =?utf-8?B?ZFpQR0JPczUzNlVvQk16Y2JidjRYZVlDRkV5dGU0ZEhpUHYySzZGWVlNaEhn?=
 =?utf-8?B?bkNYTGFoZDdlV2l1NGRSc0NwN3Y3eFhRNWNDZ1k4eVJreDdVT2tqQXltMFZF?=
 =?utf-8?B?Rm9WSGgxMnpUcy9CUXU5VWFUeDNlKzlrM0ZiZ3BpOFQ2UlpoZXZYcHVaZDlV?=
 =?utf-8?B?bkd6amtaSzczM1lTQ0JTYjF5SnA1dm1oblNGSzdmV09pUWM0R1BIejVDeXVT?=
 =?utf-8?B?TU9sS3NmaFpOQ1l6K08vQXo3SkpneGEvRXEwR1RUdDJhTDhpcnhkR0RObDVp?=
 =?utf-8?B?QmM5cmRUZVFJTDM1VkFOeUtVL3AyZXVsMzhUL0U4SVErTGhGQkFBNUVKQ3JD?=
 =?utf-8?B?UVpQWXV5WDVrNDdaNmpodHdTaUtqUllvT3VQeUhsOG1kZUliY1VvcjJ6VEY3?=
 =?utf-8?B?YTY2d0xqZ0ZlTkVUa2dETTZ5ZnpNTUZHekJvcjRtbUdzcE5hczNHeWIzQ2JV?=
 =?utf-8?B?b3pBbW5vTVpnQ0lmM1lCck5COFJNMCtDOHhueVRqNWFCUHRYcTRhNlZTVUlt?=
 =?utf-8?B?bHlibE9lOVNMM3k5MWo1NmV4b093ZU50czg5YlhFNWVQM0l6MVV6UUp5ckpw?=
 =?utf-8?B?NDd6TTJDL0NtdENQT2RsK1FicTVJakpTQzVnY2N2UHdqUUFoQjRwQmdBcE4y?=
 =?utf-8?B?b3FUaHBsOGRSdHVxTXI2dlZrT3ZuRzFEaTd1eDhxNG13Ynphd0pid3JsNm5k?=
 =?utf-8?B?eUk3aEhQZ0MwTjdRNFYzMC8xcm1MOXROZWxkLzZZSTdFVVZrS2RDS3IwVDE3?=
 =?utf-8?B?OCtCUU1Vc1dOTVU3bTlza0xlNjVSTEFWSU1YTHNBcDFrTjJyQUUzTmNZNU5j?=
 =?utf-8?B?SzArbmN0UEFsVlVKanA0Ulh2WFM5MzBLanV5NTh4Skd6TEpnN3RId1VVQ2tH?=
 =?utf-8?B?Vk1sTnl4Vlp1OEI5dGV0SW5ldWFQa1htdnVwa1lOWVgrYWtET2hpMzFUUzBO?=
 =?utf-8?B?YU9zS1hwU3BYZTRITUR3ZVh4cnRMdUM3VEhuTkJ0R3NlME43Q0pNMmNaaXZI?=
 =?utf-8?B?YVhHcFkxODZ5d0IyK3dnbUlwa0pvSXhabkdJT3JWRnBZckZWb3FveGttc1J1?=
 =?utf-8?B?RDJtM25rekRWQ29tVEllVzRwTnN2UmEyYWluT2p3MzQ3bGxDUVlJZUlNVVZW?=
 =?utf-8?B?V2RLOC9wTmRMUW9zejR4d3V4N0ZNUXdzekJCRWozQ0xURTRaNzFlOTVTVnAr?=
 =?utf-8?B?K1ZIR1BMU3IwMGJxSjJxMmhKSjZCU0gvR05jUDB1TWtSSTVsYkNyaWJkT1Mw?=
 =?utf-8?B?TWNmM3hxK2s4KzVCR2h1UmwycCsrYU4zTTZIOGZiZ1BST3Q5K2xNZ1FKeUdR?=
 =?utf-8?B?bTdrQ3hoK1Z4dVpRR0VQdE0raGRPZHllcWdUTFdqNlEvWE0xTzJtMkZNNGt5?=
 =?utf-8?B?OGYydTg3Zmc5OFBJenQ4T3E3ZlhIaE9hRUtLa2MzK1haUmZwZktDVHBWNWtz?=
 =?utf-8?B?MU9EaFdGZkVFN0lSTDlUUFdhOG54VVBaRjh4QWt1dW0wYTUza2FCR0Q4Zm9S?=
 =?utf-8?B?SktjZ1A0WHhiSG1JWkxCbUI5SDRRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e524e870-ebb6-4929-20c4-08d9fbf17d08
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 02:08:05.2541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JZumZcSgGrqcP4Tg2T5Wj9eCe+yQ6LCy1jUl9+3mHKt6qgxo5+9ifilE+rF9yWW+cUWRESayDKttlNr0FF2BCO+xXZwdBieBYII+ET73Lcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4931
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkbmVzZGF5LCBNYXJjaCAyLCAyMDIyIDk6NTYgQU0sIEpha3ViIHdyb3RlOg0KPk9uIE1v
biwgMjggRmViIDIwMjIgMTg6NDQ6MTUgKzA4MDAgQmFvd2VuIFpoZW5nIHdyb3RlOg0KPj4gQWRk
IGV4dGFjayBtZXNzYWdlIHRvIHJldHVybiBleGFjdCBtZXNzYWdlIHRvIHVzZXIgd2hlbiBhZGRp
bmcgaW52YWxpZA0KPj4gZmlsdGVyIHdpdGggY29uZmxpY3QgZmxhZ3MgZm9yIFRDIGFjdGlvbi4N
Cj4+DQo+PiBJbiBwcmV2aW91cyBpbXBsZW1lbnQgd2UganVzdCByZXR1cm4gRUlOVkFMIHdoaWNo
IGlzIGNvbmZ1c2luZyBmb3IgdXNlci4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBCYW93ZW4gWmhl
bmcgPGJhb3dlbi56aGVuZ0Bjb3JpZ2luZS5jb20+DQo+PiAtLS0NCj4+ICBuZXQvc2NoZWQvYWN0
X2FwaS5jIHwgMiArKw0KPj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4+DQo+
PiBkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL2FjdF9hcGkuYyBiL25ldC9zY2hlZC9hY3RfYXBpLmMg
aW5kZXgNCj4+IGNhMDNlNzIuLmViMGQ3YmQgMTAwNjQ0DQo+PiAtLS0gYS9uZXQvc2NoZWQvYWN0
X2FwaS5jDQo+PiArKysgYi9uZXQvc2NoZWQvYWN0X2FwaS5jDQo+PiBAQCAtMTQ0Niw2ICsxNDQ2
LDggQEAgaW50IHRjZl9hY3Rpb25faW5pdChzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCB0Y2ZfcHJv
dG8NCj4qdHAsIHN0cnVjdCBubGF0dHIgKm5sYSwNCj4+ICAJCQkJY29udGludWU7DQo+PiAgCQkJ
aWYgKHNraXBfc3cgIT0gdGNfYWN0X3NraXBfc3coYWN0LT50Y2ZhX2ZsYWdzKSB8fA0KPj4gIAkJ
CSAgICBza2lwX2h3ICE9IHRjX2FjdF9za2lwX2h3KGFjdC0+dGNmYV9mbGFncykpIHsNCj4+ICsJ
CQkJTkxfU0VUX0VSUl9NU0coZXh0YWNrLA0KPj4gKwkJCQkJICAgICAgICJDb25mbGljdCBvY2N1
cnMgZm9yIFRDIGFjdGlvbiBhbmQNCj5maWx0ZXIgZmxhZ3MiKTsNCj4NCj5Hb29kIGltcHJvdmVt
ZW50IGJ1dCBJIHRoaW5rIHdlIGNhbiByZXdvcmQgYSBsaXR0bGUsIGhvdyBhYm91dDoNCj4NCj4i
TWlzbWF0Y2ggYmV0d2VlbiBhY3Rpb24gYW5kIGZpbHRlciBvZmZsb2FkIGZsYWdzIiA/DQpUaGFu
a3MgSmFrdWIgZm9yIHlvdXIgc3VnZ2VzdGlvbiwgdG8gYmUgaG9uZXN0IEkgZGlkIG5vdCBmaW5k
IGEgYmVzdCB3YXkgdG8gbWFrZSB0aGUgbXNnIG1vcmUgdW5kZXJzdGFuZGFibGUuIA0KSSB0aGlu
ayB5b3VyIGRlc2NyaXB0aW9uIGlzIG1vcmUgY2xlYXIgdGhhbiBtaW5lLiBJIHdpbGwgY2hhbmdl
IGFzIHlvdXIgYWR2aWNlLg0KPg0KPj4gIAkJCQllcnIgPSAtRUlOVkFMOw0KPj4gIAkJCQlnb3Rv
IGVycjsNCj4+ICAJCQl9DQoNCg==
