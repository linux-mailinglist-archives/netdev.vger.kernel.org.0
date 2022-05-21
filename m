Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BA752F95A
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 08:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242922AbiEUGou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 02:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiEUGor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 02:44:47 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120047.outbound.protection.outlook.com [40.107.12.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1288E15EA4C;
        Fri, 20 May 2022 23:44:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QjwQaFHlDMYgroEanxZGpwKmEwTMym0WkHT+xXG88ufLmy4nJavMmcIayfAo0Iwij6J0ZCEePjB3XDMqaXqs0dmjOnPFWeAbAa4pU0BZAjEjZB5l6kaeu9ifnm1jr3FI6UGvZrgDJ2KclJ4y9xTEAyRY73PchDB6H8uV79yd6PMvTCq3N3hHkEf22jjXkFY3MLsqSKSH/iMgoxdx34n9tYAGEPcFSabqifw+nEWzYsV3GYQiF1r+u+zGG54E6Af/gtbWDsOcQY1gA9FuJww6rwydj7Te+ysirvjwr2mfkXhYrGd7iBNrZDBPyqOnXYHniJIJ1oX+VTHE/lkI8UTnKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GnsGqMB9TXAY5aKM1sSEfAILsKscrL00dkbi8AR1CYo=;
 b=mhEYO+V7xCEuxXgepphewruTag3DVgtGtdERETGJ6VYRRNuGcEgZuMF95qapeK0v4PRyE1UZdo/JcdD4QsiPpVOpltLkbUzGmbOrLJ7dTj1jWLg7gMOPcCw8VhDTkbSKY2wgl66kOUdEazOoaB+l9FNTGSQXH8TYhPdMDePP0+18woRaZJEShBGhQhcBXu/A+/qNlU6ZMscFedQuFXJhd6FQiXwosmm/GWE5VmbGsaYyF+EvMqYZDq+7ihCeD/fH3kgIJGgCG5HDpjYLpMceT+fYZFzu02G9+ANN0CmqSnTkV/TlBuP5Ol6d4k8faHpKlkUlpxPboO+n+BbFTypDmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB2236.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:12::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Sat, 21 May
 2022 06:44:41 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d%8]) with mapi id 15.20.5273.019; Sat, 21 May 2022
 06:44:41 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     =?utf-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Dan Malek <dan@embeddededge.com>,
        Joakim Tjernlund <joakim.tjernlund@lumentis.se>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fs_enet: sync rx dma buffer before reading
Thread-Topic: [PATCH] net: fs_enet: sync rx dma buffer before reading
Thread-Index: AQHYa7YuVEP9k/Dzd0ymrSBr6A4wj60nQJAAgAB0SUyAAAVXAIAAULSAgADaLoA=
Date:   Sat, 21 May 2022 06:44:41 +0000
Message-ID: <d8cc1123-30d2-d65b-84b1-2ffee0d50aab@csgroup.eu>
References: <20220519192443.28681-1-mans@mansr.com>
 <03f24864-9d4d-b4f9-354a-f3b271c0ae66@csgroup.eu>
 <yw1xmtfc9yaj.fsf@mansr.com>
 <b11dcb32-5915-c1c8-9f0e-3cfc57b55792@csgroup.eu>
 <20220520104347.2b1b658a@kernel.org>
In-Reply-To: <20220520104347.2b1b658a@kernel.org>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84cbb22f-7924-4c4d-e8a2-08da3af5623b
x-ms-traffictypediagnostic: MR1P264MB2236:EE_
x-microsoft-antispam-prvs: <MR1P264MB2236A8B45A4B20A72B37FEC8EDD29@MR1P264MB2236.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XrtpRHTxCckiBEeDcY6DvLyTL7nf2oh3/qCrcS4/5O1z73p5ZnLJNkmqpCFD0zenOQgMSfXMvLlVK8BLLzfpkDxLhPPENRWTUJv8/9MwrEBWL8znBdTpjL6HPvBmUp0Shg/1tdIcFrEkk1o3J3mDlgaDhPXn0ancMPYDsDL3og6I91Pdg13YHHy572Ro9AejtQfVCAYxYscLxSfWp39g/TkMYt/4g8KOyZyu+ljlryFlaT9i3dkS3MymFMupeFO15FNxi6bafuk316DbH3KUSpNCZ3sAxegt9XzFUOWoRcpXQ5+G1nlZFbggZqfj3WV7FvtzZyi1pDw1t12msyT/2LYxRIzzI6k7dYeptKlAVuhDk0Dnducf3j09cqKLxFhouGztTe8izZmceXZWEBmEumRX98+71LwbRBiwriMMgmW/EpYJBvu4DGPLpktKjFzwEA28CiNQlygYYHv8c+jAKNPxQ/LdbJUO7vORHxEP8KO6xpL+0VGWJqK3n44qXgHKMl3STWdVHItlGezLLavlfopiQW7Xt2ygVxKOV/UQ64JdlMuRv9uAaHsV/Ab32DeX9nDunjryx0jM5UG82cTr2apbZPsZXRn94v5yEIDgVJabEJvP1dHqpSPHusA+8HDBspeQXOiaS5whpZyja7sfRaWa15bFa1N4sgViLNCRAe900dvjY1Yqkh25Dc44oqnrg/39IYkw6ZwZl6Z54d5PzvWajkANZdgeuyXXXQ73W52YBI9KUBJofC8cx9JiM68GrtZ2D+MqRj6zNSQa6OD0Ms0+hyxUe5GiBSmksmG+8RMUyY/lhgpzKcxz1XCbScyO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(5660300002)(71200400001)(6916009)(31686004)(76116006)(186003)(66556008)(64756008)(66446008)(316002)(38100700002)(508600001)(2616005)(91956017)(8676002)(66476007)(6486002)(7416002)(38070700005)(66946007)(54906003)(8936002)(36756003)(44832011)(66574015)(2906002)(83380400001)(6512007)(122000001)(26005)(31696002)(86362001)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2l3MkNGelhkNVcwSXc1ZXNUTHdxZXFuYkF6Y3AydnNzS3I0S05vREFKODMr?=
 =?utf-8?B?RFBpVUd5YnQydWtLRlprVVBYUlpIQXBmd3VRbUptWk5LbU5xQUhUU2tEZml0?=
 =?utf-8?B?VnB5czU5QkV1RzdOUVpNdFdibmgrei9vRjFITi9zcnJKeGJIbkFIajMrTnEz?=
 =?utf-8?B?UzR0bFlUMlJDZUFvN3E4QlF5ekE4ZDNKdjhNbXM3ZEgxdi9qTHR1THpMTjlH?=
 =?utf-8?B?YkkvRWxkTURuZ3o2UDdmdksrZisxMjExYmVXc3pVcmd4RjVYUGptN1dzZnI4?=
 =?utf-8?B?T29JYTUrRnVyQjFXeE1IYXhMdERrMmIrR1JOY0NWdTJRMWNGY1MxcS8yVGhq?=
 =?utf-8?B?M0hRQllCSXFocS9HV05pcXhoTTdSV3RIYkl3NGJyY0RGQk1TSWpra1ZVZENh?=
 =?utf-8?B?N0k4Q0x6UVpBcWFvaVRlaDA3WXVwb2QwRVpFKzJtQU40N3ZaZGxaWUdXVStV?=
 =?utf-8?B?VWFqUGNkaXpTVDMrMmU0V0ExNERtZnM3TVZPenVyZ3llUENsdXdMRitVcTZm?=
 =?utf-8?B?Ym14UHN1eENpcVZhTi9LWWJxVlJ4WVBhQ2JTSmZOTjFFN3JLK3FLMEdiRFpL?=
 =?utf-8?B?YjRLSXFQTnYzZ3F4L2N2Q2htL2huY2s5cWNPRGg1ZGtKcFVVU3FuWnJrQVNm?=
 =?utf-8?B?ZnlKcW9TbytJY2VRcDVpQUVMVE1uMGdTWVlQRHkrMGptV0ZlQis1citSRFUr?=
 =?utf-8?B?a0xuc1ROeUQ2MVhFc25paDQwRUVqcm9LbG9EMFovUlozYStSZ29FaWNOWWtS?=
 =?utf-8?B?eDdFRDRya1IxNzVFZnJwQktZeWdOdDh6WXJ4S3I3YitTcjRQckZnc2ErejQ4?=
 =?utf-8?B?VHZhU1BMcjFBQm5ud2VWelhqS0JlSi95bDJEVmpQT2w1ZE42d3RWQ25ZaHRW?=
 =?utf-8?B?Q25sUkFsdmRsQkRIY1BEMUp2SW83SzRIdC9jRXc2VVZMUUlWY1NsUWFpQjVp?=
 =?utf-8?B?QXl3cnU0UysxcHFMMG9qQjFkR003bzhmRXlqR2FNbTI5dFVtQ2ZRa3RCT3Bn?=
 =?utf-8?B?ZFdPVHRjMGFrenNFRUFEUkxYc2lDcWhraHBWYjFpcWlLelBzK0RsdHhtdWpl?=
 =?utf-8?B?VE1Sc2MvQmV3NS9lalJTOTI0OVlJdmdIcUxWQTJaWGRQNndPRnZmUERHRi9k?=
 =?utf-8?B?QnJ2b1RzT1B1bzhWbkVCM1lrMEw0MnozUGFHZmE1MzBkWG9jUVBQTGpiWmlv?=
 =?utf-8?B?ekRNdnBPQ2NoU2xNc2NHNmxrUXVESE05RWlCSC9XOVVHdGtwV1EyQ1VkMjgz?=
 =?utf-8?B?UFF4NGF1U2VqSzFUQTZaNzduTUhBdXNURXR6czd2TjkwK0o2d3V4Zi9BRDZi?=
 =?utf-8?B?TVZOTUZWcjhUSEF5MmlKc1I3SFlxaFgwOW9FemRkc1NVeStmeURxM3FSbVlR?=
 =?utf-8?B?RTJwZC8yRWN6K3BzT2I3dmpINXp5RnNOckVvbmRVL3RFYU54VTZCRnVPOXMw?=
 =?utf-8?B?am00ZURPb0tNOVNONjBRQkpxclRZRXZJdmxaTUlBeDRBZzhyQWVIT0M4TWlv?=
 =?utf-8?B?Yzh4ZHFiYzZtMnBja0g1MDVFY25HM3N2M2JTblh5MUJiNDlaZzhnbng3dXh1?=
 =?utf-8?B?RjhkSzVOMWdxMWsvcGhkUDlaaWdoSkMrT1VnZFhkbHY2OTFsSmxZVzhjNGRi?=
 =?utf-8?B?L2tIRXJSR0g3SG1RbE1BL0o1WVpMRnE5a29qR0xpQmpidTJxbkN1TW40UHhU?=
 =?utf-8?B?ampXSDRKTFQ5elFsQmlpM2lEWlJ4YzllVnVTd1I4RitCQW1uTVExZzFvVDVD?=
 =?utf-8?B?NEtKeDliTUdidy94dDBqMksvTTNxS0JuY3dPMStBK2QwaDhGbXpIUml0Yndr?=
 =?utf-8?B?ZFBnNUhUcnh4MnZVYXp3NGFtei92NzZFV0N4UkRvSGI0NUppTnBJbnlYK3ph?=
 =?utf-8?B?RGdYeHlhejB1ZWh1b2ZQSno2SVBXTjNQN3AzeXF0Mnl1UGZnZnR0THMyNDZY?=
 =?utf-8?B?L2dwSHgrc05CTFZBd2ZnTTJpQ2dxcEdlNitIUE9DMGRFaVZMZjIzMnJ5Q2xP?=
 =?utf-8?B?TUZSbHd0ZTFmZ3hCOEVyOGJkL0dDS3JkZGJhT3lxQXF4WlV3V0JCSVAxQVFK?=
 =?utf-8?B?eVNvZ0lTRm54a255Y2E3VVFJTnozcDl5M1NCVExuazE0ZUI4c1BwMjVXOWpU?=
 =?utf-8?B?cGR4eUJZZnVvcVN5Z3ZqSWs0MVgyMzFMVTFKTmtyMzU3TjBaVmJYTE1raWpU?=
 =?utf-8?B?TnNwdVV2dnZ3dFQ0ZTBQRUxoeGZudmxnMm8rWTJBRW90Rm5JY2pyeUxDbExO?=
 =?utf-8?B?UlVrQjgvc01hRUJ5NVY5SDVBL3pGUlRacjUya2IyVW5aRktFSlZjcEFCTVd1?=
 =?utf-8?B?SlB6TStCZW9VTURjVk02d01ZdUZuNTVTVkNtcVYycDEzZ0xadEw1ZXJGcGFH?=
 =?utf-8?Q?Ir+8l8QrtjJRltzymDquz4iFONrBT0j5CqSEv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <96F8FD2E775A6E41ABADF71DB4913400@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 84cbb22f-7924-4c4d-e8a2-08da3af5623b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2022 06:44:41.5213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nKTYwsJEdpO2gGLC2FFu+lJbxTB6Z4JM8BPoCbahFv6fEC2hWyztiwkfVdzk+eVwMDs7TpE0gZ4AO3G+hKySM4vR5MtAZEarTWA0XaiX8xY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB2236
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDIwLzA1LzIwMjIgw6AgMTk6NDMsIEpha3ViIEtpY2luc2tpIGEgw6ljcml0wqA6DQo+
IE9uIEZyaSwgMjAgTWF5IDIwMjIgMTI6NTQ6NTYgKzAwMDAgQ2hyaXN0b3BoZSBMZXJveSB3cm90
ZToNCj4+IExlIDIwLzA1LzIwMjIgw6AgMTQ6MzUsIE3DpW5zIFJ1bGxnw6VyZCBhIMOpY3JpdMKg
Og0KPj4+IENocmlzdG9waGUgTGVyb3kgPGNocmlzdG9waGUubGVyb3lAY3Nncm91cC5ldT4gd3Jp
dGVzOg0KPj4+PiBTZWUgb3JpZ2luYWwgY29tbWl0IDA3MGUxZjAxODI3Yy4gSXQgZXhwbGljaXRl
bHkgc2F5cyB0aGF0IHRoZSBjYWNoZQ0KPj4+PiBtdXN0IGJlIGludmFsaWRhdGUgX0FGVEVSXyB0
aGUgY29weS4NCj4+Pj4NCj4+Pj4gVGhlIGNhY2hlIGlzIGluaXRpYWx5IGludmFsaWRhdGVkIGJ5
IGRtYV9tYXBfc2luZ2xlKCksIHNvIGJlZm9yZSB0aGUNCj4+Pj4gY29weSB0aGUgY2FjaGUgaXMg
YWxyZWFkeSBjbGVhbi4NCj4+Pj4NCj4+Pj4gQWZ0ZXIgdGhlIGNvcHksIGRhdGEgaXMgaW4gdGhl
IGNhY2hlLiBJbiBvcmRlciB0byBhbGxvdyByZS11c2Ugb2YgdGhlDQo+Pj4+IHNrYiwgaXQgbXVz
dCBiZSBwdXQgYmFjayBpbiB0aGUgc2FtZSBjb25kaXRpb24gYXMgYmVmb3JlLCBpbiBleHRlbnNv
IHRoZQ0KPj4+PiBjYWNoZSBtdXN0IGJlIGludmFsaWRhdGVkIGluIG9yZGVyIHRvIGJlIGluIHRo
ZSBzYW1lIHNpdHVhdGlvbiBhcyBhZnRlcg0KPj4+PiBkbWFfbWFwX3NpbmdsZSgpLg0KPj4+Pg0K
Pj4+PiBTbyBJIHRoaW5rIHlvdXIgY2hhbmdlIGlzIHdyb25nLg0KPj4+DQo+Pj4gT0ssIGxvb2tp
bmcgYXQgaXQgbW9yZSBjbG9zZWx5LCB0aGUgY2hhbmdlIGlzIGF0IGxlYXN0IHVubmVjZXNzYXJ5
IHNpbmNlDQo+Pj4gdGhlcmUgd2lsbCBiZSBhIGNhY2hlIGludmFsaWRhdGlvbiBiZXR3ZWVuIGVh
Y2ggdXNlIG9mIHRoZSBidWZmZXIgZWl0aGVyDQo+Pj4gd2F5LiAgUGxlYXNlIGRpc3JlZ2FyZCB0
aGUgcGF0Y2guICBTb3JyeSBmb3IgdGhlIG5vaXNlLg0KPj4+ICAgIA0KPj4NCj4+IEkgYWxzbyBs
b29rZWQgZGVlcGVyLg0KPj4NCj4+IEluZGVlZCBpdCB3YXMgaW1wbGVtZW50ZWQgaW4ga2VybmVs
IDQuOSBvciA0LjguIEF0IHRoYXQgdGltZQ0KPj4gZG1hX3VubWFwX3NpbmdsZSgpIHdhcyBhIG5v
LW9wLCBpdCB3YXMgbm90IGRvaW5nIGFueSBzeW5jL2ludmFsaWRhdGlvbg0KPj4gYXQgYWxsLCBp
bnZhbGlkYXRpb24gd2FzIGRvbmUgb25seSBhdCBtYXBwaW5nLCBzbyB3aGVuIHdlIHdlcmUgcmV1
c2luZw0KPj4gdGhlIHNrYiBpdCB3YXMgbmVjZXNzYXJ5IHRvIGNsZWFuIHRoZSBjYWNoZSBfQUZU
RVJfIHRoZSBjb3B5IGFzIGlmIGl0DQo+PiB3YXMgYSBuZXcgbWFwcGluZy4NCj4+DQo+PiBUb2Rh
eSBhIHN5bmMgaXMgZG9uZSBhdCBib3RoIG1hcCBhbmQgdW5tYXAsIHNvIGl0IGRvZXNuJ3QgcmVh
bGx5IG1hdHRlcg0KPj4gd2hldGhlciB3ZSBkbyB0aGUgaW52YWxpZGF0aW9uIGJlZm9yZSBvciBh
ZnRlciB0aGUgY29weSB3aGVuIHdlIHJlLXVzZQ0KPj4gdGhlIHNrYi4NCj4gDQo+IEhtLCBJIHRo
aW5rIHRoZSBwYXRjaCBpcyBuZWNlc3NhcnksIHNvcnJ5IGlmIHlvdSdyZSBhbHNvIHNheWluZyB0
aGF0DQo+IGFuZCBJJ20gbWlzaW50ZXJwcmV0aW5nLg0KDQpXZWxsLCBJIHNheSB0aGUgY29udHJh
cnkuDQoNCk9uIHRoZSBtYWlubGluZSB0aGUgcGF0Y2ggbWF5IGJlIGFwcGxpZWQgYXMgaXMsIGl0
IHdvbid0IGhhcm0uDQoNCkhvd2V2ZXIsIGl0IGlzIGdldHMgYXBwbGllZCB0byBrZXJuZWwgNC45
IChiYXNlZCBvbiB0aGUgZml4ZXM6IHRhZyksIGl0IA0Kd2lsbCBicmVhayB0aGUgZHJpdmVyIGZv
ciBhdCBsZWFzdCBwb3dlcnBjIDh4eC4NCg0KSW4gNC45LCBkbWFfZGlyZWN0X21hcF9wYWdlKCkg
aW52YWxpZGF0ZXMgdGhlIGNhY2hlLCBidXQgDQpkbWFfZGlyZWN0X3VubWFwX3BhZ2UoKSBpcyBh
IG5vLW9wLiBJdCBtZWFucyB0aGF0IHdoZW4gd2UgcmUtdXNlIGEgc2tiIA0KYXMgd2UgZG8gaW4g
ZnNfZW5ldCB3aGVuIHRoZSByZWNlaXZlZCBwYWNrZXQgaXMgc21hbGwsIHRoZSBjYWNoZSBtdXN0
IGJlIA0KaW52YWxpZGF0ZWQgX0FGVEVSXyByZWFkaW5nIHRoZSByZWNlaXZlZCBkYXRhLg0KDQpU
aGUgZHJpdmVyIHdvcmtzIGxpa2UgdGhpczoNCg0KYWxsb2NhdGUgYW4gU0tCIHdpdGggdGhlIGxh
cmdlc3QgcG9zc2libGUgcGFja2V0IHNpemUNCmRtYV9kaXJlY3RfbWFwX3BhZ2UoKSA9PT4gY2Fj
aGUgaW52YWxpZGF0aW9uDQpsb29wIGZvcmV2ZXINCiAgIHdhaXQgZm9yIHNvbWUgcmVjZWl2ZWQg
ZGF0YSBpbiBETUENCiAgIGlmIChyZWNlaXZlZCBwYWNrZXQgaXMgc21hbGwpDQogICAgIGFsbG9j
YXRlIGEgbmV3IFNLQiB3aXRoIHRoZSBzaXplIG9mIHRoZSByZWNlaXZlZCBwYWNrZXQNCiAgICAg
Y29weSByZWNlaXZlZCBkYXRhIGludG8gdGhlIG5ldyBTS0INCiAgICAgaGFuZCBuZXcgU0tCIHRv
IG5ldHdvcmsgbGF5ZXINCiAgICAgaW52YWxpZGF0ZSB0aGUgY2FjaGUNCiAgIGVsc2UNCiAgICAg
ZG1hX2RpcmVjdF91bm1hcF9wYWdlKCkgPT0+IG5vLW9wDQogICAgIGhhbmQgU0tCIHRvIG5ldHdv
cmsgbGF5ZXINCiAgICAgYWxsb2NhdGUgYSBuZXcgU0tCIHdpdGggdGhlIGxhcmdlc3QgcG9zc2li
bGUgcGFja2V0IHNpemUNCiAgICAgZG1hX2RpcmVjdF9tYXBfcGFnZSgpID09PiBjYWNoZSBpbnZh
bGlkYXRpb24NCiAgIGVuZGlmDQplbmRsb29wDQoNCg0KSWYgeW91IGRvbid0IGludmFsaWRhdGUg
dGhlIGNhY2hlIF9BRlRFUl8gdGhlIGNvcHksIHlvdSBoYXZlIHN0YWxlIGRhdGEgDQppbiB0aGUg
Y2FjaGUgd2hlbiB5b3UgbGF0ZXIgaGFuZCBhIG5vbi1zbWFsbCByZWNlaXZlZCBwYWNrZXQgdG8g
dGhlIA0KbmV0d29yayBzdGFjay4NCg0KSW52YWxpZGF0aW5nIF9CRUZPUkVfIHRoZSBjb3B5IGlz
IHVzZWxlc3MgYXMgaXQgaGFzIGFscmVhZHkgYmVlbiANCmludmFsaWRhdGVkIGF0IG1hcHBpbmcg
dGltZS4NCg0KDQoNCkluIG1haW5saW5lLCB0aGUgRE1BIGhhbmRsaW5nIGhhcyBiZWVuIG1ha2Ug
Z2VuZXJpYywgYW5kIGNhY2hlIA0KaW52YWxpZGF0aW9uIGlzIHBlcmZvcm1lZCBhdCBib3RoIG1h
cHBpbmcgYXQgdW5tYXBwaW5nIChXaGljaCBpcyBieSB0aGUgDQp3YXkgc3ViLW9wdGltYWwpIHNv
IGJ5IGNoYW5nZSBpdCB3b3VsZCBzdGlsbCB3b3JrIGFmdGVyIHRoZSBwYXRjaC4NCg0KPiANCj4g
V2l0aG91dCB0aGUgZG1hX3N5bmNfc2luZ2xlX2Zvcl9jcHUoKSBpZiBzd2lvdGxiIGlzIHVzZWQg
dGhlIGRhdGENCj4gd2lsbCBub3QgYmUgY29waWVkIGJhY2sgaW50byB0aGUgb3JpZ2luYWwgYnVm
ZmVyIGlmIHRoZXJlIGlzIG5vIHN5bmMuDQoNCkkgZG9uJ3Qga25vdyBob3cgU1dJT1RMQiB3b3Jr
cyBvciBldmVuIHdoYXQgaXQgaXMsIGRvZXMgYW55IG9mIHRoZSANCm1pY3JvY29udHJvbGxlcnMg
ZW1iZWRkaW5nIGZyZWVzY2FsZSBldGhlcm5ldCB1c2VzIHRoYXQgYXQgYWxsID8NCg0KQ2hyaXN0
b3BoZQ==
