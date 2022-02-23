Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C694C15F5
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbiBWO65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiBWO6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:58:55 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20104.outbound.protection.outlook.com [40.107.2.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63857AC936
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:58:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3B1iAffB/9/aXOKkTryT8kAsnbJEXYM2guVcsWqMCMEyp4rdO0F2Q3DmFG2bv6SNocRR6oAo+gfTr6c3WTCjuFCBVPfcxfHe0XMxftJB6+BMFhLTtDIhg+9CBPB7D40CM5GTkiU3RFU0fSrDmJCoXW3KVimw3msIsuYehmBnXAYNuKH+Djrn/e7+Cm9tVW4bq/b2vBr5VtSrx7/KVGYY9/isADreAQ8VyvroQvGiGeqeLXyNauAEduByi8+4+ne145XLxXtzw8aT6NVYrS9L00KxzFnPDXHQx1ZCIboSCs4Rg3eqGj3hOvKfFfAqfutfrBkYLYkM9CWDG5ngr0sFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0YaNzfmPpd0Vn3C2Cz3NScxlO4D4HPN5Z1dIPKNF0Q=;
 b=YHXSXom8E3uAtDTIu4SW5dEJK+XKAL/e0wDz/yKYeObJu19akjgVSzhQdhx8Rx8JyYwoaEtJaZvx63tFKVuS2rftFpf0m5zeGfQZ1bBaZadf1hLLG0JSk1kis0akzpoYDDQ6LwGrJEzCzkYIXAtoEgexJSqB9liNy2YRlleBEO8cAS+C5Qduv3k/t3reHxqFn5JBXqrYgQlsydSQE2fir3NkYtMbExPPuDcVnI5ePnMqZKS/ynwWrc3+1YHRWiKdj5QN1zkn57MGpVtoNtQSOmMITUbcPozw95oDwJe/QPy1QqhqNsq8FQOh2aG6ZxObGSTQFJnfbjMCFp2tcfnddw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0YaNzfmPpd0Vn3C2Cz3NScxlO4D4HPN5Z1dIPKNF0Q=;
 b=aZnp0Gk3aQzU50Gg+A0TcgWzKKBMB3+/yb5FMysQPdOazseiQCgwg4nvNZUR9DveA15SUjyiVgzQcuK6WVDi+NcGWLVL7/CE46N1o8jEGkrwYaOhsnAiPSQ6ji9M7SWsC0EPzBkVlmTzrXoA0t2OVLpBLLFwlSdoIyENV2Ta79w=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM0PR03MB4692.eurprd03.prod.outlook.com (2603:10a6:208:c4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 14:58:24 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 14:58:24 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v3 2/2] net: dsa: realtek: rtl8365mb: add support
 for rtl8_4t
Thread-Topic: [PATCH net-next v3 2/2] net: dsa: realtek: rtl8365mb: add
 support for rtl8_4t
Thread-Index: AQHYKD5bECnjwEICyka5vhOI7o1gjA==
Date:   Wed, 23 Feb 2022 14:58:24 +0000
Message-ID: <87y221eijz.fsf@bang-olufsen.dk>
References: <20220222224758.11324-1-luizluca@gmail.com>
        <20220222224758.11324-3-luizluca@gmail.com>
In-Reply-To: <20220222224758.11324-3-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Tue, 22 Feb 2022 19:47:58 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f66e8df7-9e3e-494f-1100-08d9f6dcf12e
x-ms-traffictypediagnostic: AM0PR03MB4692:EE_
x-microsoft-antispam-prvs: <AM0PR03MB4692C8D2CD3B64BDBF4CB6E7833C9@AM0PR03MB4692.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: av0UlH2kgeB/c0zRqxUBEmqD9mZUVbApHkcPFX+63q2Bz6WbJfaurue6fwE+146RWt8WA1f5gz7Q1ploVBHb3EoOc75jhj2+mjxu+A5FAn2WHxHI7bn7OTbhPaLWL8xRmWxJ9Sf194kBr3O+l6O+5MyUXAv0+VEpREEP2qjWQetJDThNjA2xpjyBSyaojRIhMdfnkxpaf26m104917iSjopQMWXn6C7DTx10yLSGeoOZXUpTlieKPAycPbFogHJS7ObRS9AQgOstZg8funzwyUr/A9uauN4bmlLUUopuKPt1Ks03kHL7W1PgPakQ1n4/DzMaJ1u6uvCD7WBuuHMhiV7XrC2fVwZMW00oMPAX1X4hE7dHnPXXAnhPnrXUGjnZbEpUfvXar41UVx6vRWihI3y4aDakibBTDVkSWlaGFWA+UgC2ikb4+bFJ/2WDKoJ3wNHaIReWQtemySz1OWQcCrwXoCaleGqON8bAVTqBpmamdDhllekZMGQQUFlD2+dJ2OwjbZB1enuXX0Bb497LPJ+q7olUTh8VZKTBqXzhZMjBSQhV1oA05EqWj7OrGjQNM1gzUprFqzrCUZCev/kppRiharbOLFd3JmYkzWmS7dklaiW0zxeL3kRyoL7VimyAtAigsN5cj4VtzbzpOXEfLALhuNI6q0MzoWBWmbIjre36UWDTCNkhm7+hTjN9cvetgfhT5bjtYIQ/xxFvwIbNDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(2906002)(85202003)(4326008)(66946007)(83380400001)(8676002)(91956017)(186003)(2616005)(66446008)(5660300002)(6486002)(6916009)(64756008)(76116006)(66556008)(66476007)(8976002)(8936002)(316002)(4744005)(85182001)(26005)(86362001)(6506007)(36756003)(508600001)(38070700005)(122000001)(6512007)(38100700002)(54906003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tjh3dVVVREtFMWQwbHVySzUrUmI4eGF4b2kwY243Y0cxM09XRzl1SjN6UWVD?=
 =?utf-8?B?QmcrWEM4UkZ4ODVRWTZSRWtBN3Y2c2E2cmpSb1k1SmxKT2VoR3VOOHFKTFhR?=
 =?utf-8?B?N3ZBM3QyNWlqUVdTcDh0dHhUT0ZQYnlqb1R4OVdBbnJvV3lycVJSK3kxYjFn?=
 =?utf-8?B?Uk4wZitiOUVWaFZNbEZudEtTMFZjMUdtemFQMVpTSTBRd2RMMkZKWjhsc0lQ?=
 =?utf-8?B?SGhKOCs0eVdrRlNDL2FIK25vMGdMaWNnMEZBVk5VQ013a3dJUzN3dHFpTkJI?=
 =?utf-8?B?dVFjMHlqNC9yWHY4T3NCcmtUSG0rWUVhMmZYK0dVTGEyTHNPYnVKdGl6T3lX?=
 =?utf-8?B?OFRnMWFHU3hLdTkxemRJL0JvNU10Wi9DUTdpdG95b1ljd1hzampHUUlUWnZM?=
 =?utf-8?B?M1V0RGE0eW5qUFFFRmNjNzNkd2F0N2RZOTZiejRtNENIajViaFBOZHlMSm1m?=
 =?utf-8?B?YjdZdHpzY0FoTVR6TjFETmZHQ3JaY2R3UGFYYzNPS29PVkl5TEtKMEZPcGpU?=
 =?utf-8?B?a29yWVhYSE1NTWUrdFVpUnhjS2w2eE9OZXZmUEQ1aU9SN1cxaDVHLzdwRko5?=
 =?utf-8?B?SUV6bGExUkpYTkM3RmlyTDA0WG10MHBYcnFRWHQ0K3pmajEwMUtFY0Z4eDd4?=
 =?utf-8?B?dXNPT25yUXp3bFBZTVZGN3M5MVZjcTZBSWFmY01yN2ZEZHB2dGFaR2YrUWpK?=
 =?utf-8?B?emExYjZLUFkyWkEzZVRJOHlUcisxR3Bna1F6eEdFTmVoMndlOGd3aDNrUkR0?=
 =?utf-8?B?V3VpVVd5OGxDS1JXRGNmNlVoTnRBaVRoQkR2bEMzdmFDT1hnVFlPNXRvWmtK?=
 =?utf-8?B?Vm16WHl2RHBNOHg1dTRTY2FIcUd0RDB1YnlvSWtOL244T1hzaG1WdVV1TlFW?=
 =?utf-8?B?QURNT0NGTS82Zko5WE8ybEk0REdpZ2E1YU43UitSdlllZnNtUnZCNWlIQmZB?=
 =?utf-8?B?L0xNSWUvZkhXL1A2S29Oall4Y3lhR2MwSGoybWVjWTdCZm1uTWxDTFM2djdQ?=
 =?utf-8?B?V0dZRjd4aURUSXNMZi9Qbk00UlI3dzdxZmVZYjRaK1VNOFp5a0dUSE5TQ0Jk?=
 =?utf-8?B?WG0ySzdSaTUyY1AxWDdMUDFjQ1RDZnExQW04WW5IVWgwWjI3TGMza2V3MUlt?=
 =?utf-8?B?dkVHd01RRWlNZk1PVmJEL25ZUFgvd2ljM0VKckxOVDU5cTdKaGZ2bmxmckxx?=
 =?utf-8?B?bkwzdTF5QUxvUGdEdUNhblNwM1lubXh4dmx3M2NERFZGNW1EbGMzMk0zOGVK?=
 =?utf-8?B?QnpySWUxNlVWVHNoMndGUTdEV2pITEd3aUN5QzNvS3FGbWxsTkJGbE9mMEND?=
 =?utf-8?B?VHEyR0JBbHJ3ZkxQbWV6NzJ0ZVlFUXhBeWcyWW14cmxZNlUzWm14OGNFcGZo?=
 =?utf-8?B?WlpQek9lbnFPN1pRL3dKODhFaE5YQUQ2aVo4eGh2T2dWaUxwY1Jvb1NUZHhz?=
 =?utf-8?B?UVFEdWl3OVdKNWxCbkcyQnZUcHVqTEJHaE5kVHpNc1BBNHJ0b0o5c1VqYXdx?=
 =?utf-8?B?OFVRL1NWM3hJMFVmK2g0MHdRQm5qcU5MY3piQ0NzNnhidndBei9OaWpKeWI1?=
 =?utf-8?B?RDhTNkpTVHplTjNsbUZlc1BDdWJiamhlb0I3OHZaaHVUQjV0cDVLVVppczdB?=
 =?utf-8?B?ZDJtdHhZRFZJM29qYVpRZHMrQjF4emxkWlc4cHdqRzBqMFpVOWp6djFFZWI4?=
 =?utf-8?B?Vm5RTGZHZUJOdFNPbXZMQzVDSDIyaTA5ay9DZGdDTDVmbHpQcGxOaFdwSnN6?=
 =?utf-8?B?Vk00NGNxUERpLzUvbituWkk0QUtGWktzUng0N081bWd1SzFNY2J3ampyL25w?=
 =?utf-8?B?QXp1K2F4K3FtenhMRytqVUNYeW16dlVwbE1tRWhzS1lpdldUYTBFTnpGWTd2?=
 =?utf-8?B?amxxSUxwRFBRdVhmeEtxVHJwY1RwVzRBYjYzbDF2SkV3empETTE1VXBGMXlz?=
 =?utf-8?B?YXA3U2prSlJ1NXhGZGxBNXhKSjZXMjVIQkowQ0pBb3RnN1dDZVAwWnlYdURa?=
 =?utf-8?B?ZVpvUVlBUk5NU3NNZ0hQMGk4QmxlV0xxc2NrQ043SUFkcWdwR3U3SkMwaUhO?=
 =?utf-8?B?VzYxTVRkSm1nRWNhYUJOQnczd3RSRG5iVS9SSW0vTXZEZDlHd092aGxSd3Na?=
 =?utf-8?B?ZittQXNQRjhaTGxWVGdOOWtXTXdPSXNDV0VoaTJqYzY2L2hnNHFPQzdjUXJQ?=
 =?utf-8?Q?QE7biAsTgclre75X3OdLZ1s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F40352B2484D64498790CF311545604@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f66e8df7-9e3e-494f-1100-08d9f6dcf12e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2022 14:58:24.8420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OowL9Sa/DHB8Xsz4ljL9Ys7WKZ62oe/VfEJ+RgZQLbx7vw3u5JfOmi3NUO4SBbSjM2s0YtKcw6YiTZXYK+UbXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB4692
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQoN
Cj4gVGhlIHRyYWlsaW5nIHRhZyBpcyBhbHNvIHN1cHBvcnRlZCBieSB0aGlzIGZhbWlseS4gVGhl
IGRlZmF1bHQgaXMgc3RpbGwNCj4gcnRsOF80IGJ1dCBub3cgdGhlIHN3aXRjaCBzdXBwb3J0cyBj
aGFuZ2luZyB0aGUgdGFnIHRvIHJ0bDhfNHQuDQo+DQo+IFJlaW50cm9kdWNlIHRoZSBkcm9wcGVk
IGNwdSBpbiBzdHJ1Y3QgcnRsODM2NW1iIChyZW1vdmVkIGJ5IDYxNDc2MzEpLg0KPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBMdWl6IEFuZ2VsbyBEYXJvcyBkZSBMdWNhIDxsdWl6bHVjYUBnbWFpbC5jb20+
DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NW1iLmMgfCA4MiArKysr
KysrKysrKysrKysrKysrKysrKy0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDY3IGluc2VydGlv
bnMoKyksIDE1IGRlbGV0aW9ucygtKQ0KDQpUaGFua3MgTHVpeiENCg0KUmV2aWV3ZWQtYnk6IEFs
dmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4=
