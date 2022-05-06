Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508B851D28E
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 09:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351001AbiEFHx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 03:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiEFHxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 03:53:25 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2080.outbound.protection.outlook.com [40.107.21.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FB7674FE;
        Fri,  6 May 2022 00:49:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAxN/p4pgGWpdJm18JLPkKZ7dUtkszslzgqdMzf+QHbDDOz7riRUXEMZuhOlpLDDBXQabF1H36WtmXVHJkZCPyf2z21qYZYh0rRrVXFQeYv4he5YJ0ShRMBZMyShBRHgwrJtjZlhUo/cYg8pFN3U2x2XQ2bj9SSvgaPX/M0r9KiSoxT+nT8ZP3l4j/Qby9CV2yyPBuPxdysvBNvucuytIrDjE6WJYfPP5gNr2xqo7OBPL1qRSY0aTATOTsFgV0WkHMCOf1imbR0pYeFBACl2sHvmDDegdafr1sl3z9IV7hqRnjx24IN19qDC7bv0N9Wxcyp8CqH/bIs4Kzt4TGoD2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CeTVYehlN1c/no+n5VSxI6Q5xUOLMNTFh0hYLfmnDzA=;
 b=fftHmrlz9Ne9dq5D3pt1qQNPb2m4OKvXdBhCPwa3tcJ0H9cZY5RkwVpERl30wG8YygoI6GwHUPycdBvtReZRj4fnXSFcxenhh06nC32bU7gOjKDAt55bKd/FbA5W0RWBdPwpChTBYRDP/uz/0fVwcc25E4zugjml6Fpz3yZ0hIKD9ovgnhbKd6n8xQuzhcb1OckW18L77il2SM9UrL4QktXn4ze6z3ul5PbYK9BYQULijU8WSrITY++yRFCOzWL//j4qPDEY5g3M8YgjenglfO8CS4yizARDmVR54BFzrsfroWaSfQ0RxRSpS1cOfLSI4JMufbuM0Sx54Vk4sSFidw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeTVYehlN1c/no+n5VSxI6Q5xUOLMNTFh0hYLfmnDzA=;
 b=jzukSWAtcJG+fwtd8OEc8Z4agPel3xRo6IeqEPzH9NfcV1XCfuRhf8qfKEGyKcwgnTCS0HF7EJO8XsworzdgELvsRzwmtVwmsq/CR/Pbn5VU8xCTyV7GEAGIOakObsW07lovvxhaNWIar0bMbfMdf1dyEPFBJ9fX8lf6/GP6Kss=
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com (2603:10a6:803:29::11)
 by AM6PR07MB5287.eurprd07.prod.outlook.com (2603:10a6:20b:65::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Fri, 6 May
 2022 07:49:40 +0000
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::d4db:2044:5514:6d25]) by VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::d4db:2044:5514:6d25%7]) with mapi id 15.20.5206.025; Fri, 6 May 2022
 07:49:40 +0000
From:   Ferenc Fejes <ferenc.fejes@ericsson.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>
Subject: Re: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
Thread-Topic: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
Thread-Index: AQHYYR3WrsP3fgIutUOWZHiGk9ZeJA==
Date:   Fri, 6 May 2022 07:49:40 +0000
Message-ID: <302dc1fb-18aa-1640-dfc7-6a3a7bc6d834@ericsson.com>
References: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ericsson.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 910fa173-feac-4526-3800-08da2f34f9d4
x-ms-traffictypediagnostic: AM6PR07MB5287:EE_
x-microsoft-antispam-prvs: <AM6PR07MB5287C7D3DE2AA65787FFF8A6E1C59@AM6PR07MB5287.eurprd07.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /yRYnjFikHexMn1FCATkMoyIrfdPkHfL7IcL0NUZo4emp+Lz/EazsI48+BKl15taF/M+3Q8du/dKWLAeTOIcyu5xOMDGwfA8csMEdqZTCUHGtTYp3z4NxHN8ToP+E3lKSqYca/e3EpU1b0/Tsnoxz9jiE3ZliH5yE43HilebaKPNgcWZdc/0h6U1OCuuuL7q2NLgxy/wUZ53jz9nwdvbqlLsPd8n52s3mLpJKvNAm2IrMH+GsqHjgV/3fYAHvzVPNjrPM+L/jrDrk+6MAX4o3eGzM+c8AeijAhcM6W3EoZVVRdY0eyU2/IaVJgQg5w/oH3xRPWGB1K4USMGuSZAWLMu23eh8gvCWvzALTc43iiWQdl5lDmUSjj7QF5BJog/Dc6neaVh+p/avDG6PiOshPKpx9vKnLcpZmFMO21KZtu1i9zVk+1IRA6e13uDcOviREZF8pWVv6h2lBb4puBhoXFcd1NWNqPHtehiFgAxn8hK7js07Xr2H6vHNBJjYx4+stQAzhoo435KKP4kTwvUgyN0EpEs1m0sFTD0ss72tiKBfkZbQ6JGfVDEF3W6kOHWWpNEwdk5P5d1V1w7EQwjCK2yA4zLolqkV8eRWLtKoixJ9mDJAARx9Mw0TmhdL0givVIFNI+xhFrZrbO1TyzaQO90xb+zhUNkqDhEbk7J9/ga/BBbOBZ17g4Fu4sbmL7Uq3DGjt3JWnvgwPNfWBLJjY7/ZIvQvpe8qh4oJJYSk3KiX7FujA3b+7EIDoKQf3n04oe8z8cr72lhV90tpueRnQmKAsSsy24xKh22zFv5KOtrvYoCoHp1HOplgPTmqBDBb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4080.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(71200400001)(508600001)(2906002)(2616005)(186003)(44832011)(54906003)(110136005)(86362001)(31686004)(83380400001)(6486002)(966005)(91956017)(82960400001)(7416002)(36756003)(122000001)(76116006)(5660300002)(8676002)(6506007)(6512007)(26005)(4326008)(31696002)(38070700005)(38100700002)(64756008)(66946007)(66556008)(66446008)(8936002)(66476007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUpLbWM2bXZFRm50M0h1bXpSdkhuYTNQcGNWT2pGNkxnb0lQc0o1S0J1Q1Ft?=
 =?utf-8?B?VFMvSTcybVVsVXBGYkFWODJoWEJ3d1Z2cEpiQ2ZOY2cwN3h6TlFXaCtuR0Q1?=
 =?utf-8?B?RitXNWlZdCsrdFJoN2FnTXRnSTNxNGlYV2ptWC9zU1RiMmVYSDNlNWdPajVR?=
 =?utf-8?B?cXgxV0psWjJGSTBPOVJnUExOaFFEVTNDdGhvRGJxYWlscnFFd2Z6ZmpxZFpu?=
 =?utf-8?B?dlpDWnF5amtjbVc3VE5Ya3Q0WGhJWXJlMkNLUlRJUVFqSWdqVEdsRElzQ1dn?=
 =?utf-8?B?ZGl5TnlMUVQ2M2s2OTVtck8zTlFDV25hMEl2YlhDV2xuVXA1Z1pRM1Q0NlJi?=
 =?utf-8?B?R1F2YkFWaUhqRjBUbWt5Q2lObHUyaExjSW9jOVUreG9IdlZLQitVZnhpbFVK?=
 =?utf-8?B?RzN1ckxKS3ZWU3pKNXFUMEtjcXpsNytjbGVQaHhZOEQrTVEyZHczV3VjY1dM?=
 =?utf-8?B?NzRwc2NIZHJLL3JoU1ZlWWlneWQ3cldqN3dwZlRkT2k2RnFpQXVFQXM3MUxv?=
 =?utf-8?B?eE9rMU9Ca2Z3VUdFcXRlRjdSSE5LQ3JQckFpM1hXK1RXM1hpdXZjeWsxQnls?=
 =?utf-8?B?Y1pSaTgzdlZVditnQitDd2pCZnZVRWd1ZnZnRnFwdEhOcHE2b2lpWkJEcnZS?=
 =?utf-8?B?bUswWk1PSGVzdWN6a1F2Q1JsVFNSUEZkYkZ5VDF6ZVlEMXc4VnE5Q3ZsaUV5?=
 =?utf-8?B?T0JmTHhzUWJ3TityU3U3TTd3SnA1RVZMUGwzMlpsaTd3Q2cxMnllaXhvNkd4?=
 =?utf-8?B?TUlyNXJYNmhubXplZk1vRC9uTEo3RE52Rnl1dVpvYVF0blpPa1JweTJtUUpR?=
 =?utf-8?B?U2FWRTg3bFBnSmxBMzh0UllNUTJjVUtyeUcvMmdqSUlPT3MwcDN4ejhZd2ta?=
 =?utf-8?B?di9ycFpRQ3hYR1A3QVZlTmFnRDFtVlI4NnQrZi85T2dTMmJkKzdIUnVoZi9Z?=
 =?utf-8?B?MTljSHFhVHFiYTVRSzBGOUZiTzFXTFhkU2lqNFBmZFFNUW91dUZXS01FUFRX?=
 =?utf-8?B?Z05rUXdSaXVDekJrN3hvNXNzVzB6Mmo3Vm1LK3JlYStEbjdXMGZrN2pYeHZW?=
 =?utf-8?B?dHIwMU02eFZMRmUvYjA5bjFWSWNUR251U25Xb3dFdzBnOHR2bFhtVVR4Uzhj?=
 =?utf-8?B?cktacUo5VkJsa3UydUFQNE1GakFsdG9zaHpDaEVqTlhISSs4cnowNGl5ejRU?=
 =?utf-8?B?c0tQQU53RzVXWVQ0TW4rTUFCWFUvZTRFaGNUNzJyUHZLdTVYb29XR0JWejRO?=
 =?utf-8?B?OVkveUhoL1NEUys4aWNPL0oyU2hoRXRPSitOdjdsbjRBMGxIK0JkeHlCaW5j?=
 =?utf-8?B?TVlkTForSDdZSDRaek5uWExJazJraEFuUjUzcm1VMmJjVk1wamsvRnZpQU1C?=
 =?utf-8?B?TG9aRVpxOHRxMTdRdXgyTENIMEZwRXJjVVdQQnMwR3QzcSswWlNncFBZRi9u?=
 =?utf-8?B?QWFzdlVCOG5DMHQ5MzRoUWhNUWowNWNXdzVqcXd4Q3hnT2haVmpnT0Q3NjQ4?=
 =?utf-8?B?OWFnZXFxQTlyMU51Uy8rY25nSGM2ZGdEcnprdGRZMTVabzVyT0tYZk1iQ1lp?=
 =?utf-8?B?Tm9zWVlxNS9qb2YxYWhlVmRpTW90aEY1QUYvSlcwNTVRc1pPRkdCamNDNFNl?=
 =?utf-8?B?ajd5YzZua2t0UzB5WHQ4aGtIUk5lT0xVYXJEbXhPd0JBYnZyS0YzQ2hnMDVh?=
 =?utf-8?B?V0w3YUt5U0hpWWdzeWM5ZnEzVktkNHRmVkplK01HRUZNNXdpQlYzb3dNSSt1?=
 =?utf-8?B?R2lMdDFpNUFBb3RUbEhuU1ZDOXRWcVRJa29md0tzUm96VkRjMkVOV3FGUTZL?=
 =?utf-8?B?MW40Zm9QbXhNSVJ4TEdDVC9yeWJMbnR5ajNzb0M2TnUzeG1FRFJ6NityTTZG?=
 =?utf-8?B?dUhxejhUa1UrUzFIQzFkWDNTQUVNRHA4ZldGYVYydGdjRXVLc0RucmxVSUNv?=
 =?utf-8?B?WG1VY2RGZ2NUd0ZFaTlIaXQzSkNRR09FckNrdG1LTWIzcmc0aGtRTlU5a0pS?=
 =?utf-8?B?OGcwNTlFcFUxbjJDcGJSZ3QzQ0pEWldpL09lUm9jbUFMak1xY1lKTytOVHpB?=
 =?utf-8?B?SEhWdkh0d1l2dk1tdmR0V3Y1TktKTG5wUm5KMTF6OWZSMVFTRXdRbWFkMDFv?=
 =?utf-8?B?eVRwOERia1pNeUo1VHNVTXBnbzJPK29mSmRZRm16U0ZpQkVhNHVHVlpyVU1R?=
 =?utf-8?B?TWI1VkEzL3JJeDlScUYyR0xjMzJybHFRVEtoK1ByVmREQS82T0MvYVZGM0tz?=
 =?utf-8?B?SUxCRmZLaHFQRnNtUitwWnJqOW5zMURwZVg1THF3UC85clVodjIvRkhiQ1k0?=
 =?utf-8?B?dCtPWG9qQmUyc1BwZ0RVZkNUY2h1bW92N2I0OXEvTHp4eG9IWGhGdTFpSk4w?=
 =?utf-8?Q?6C9QtemYC/w1D6SU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <06B3E35355AD9143AE6FFBA08556F498@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4080.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 910fa173-feac-4526-3800-08da2f34f9d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 07:49:40.2273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y3mRtD2rp5gtI4Df11OEDeHUh9BNyI3Rm8GOJ5voJ6wWo7xaKdjMhBSXoA7jkmVo66P6JcFfya8vGwmHdshWXZyTlwJ0fo6V/6CzI77O8VM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR07MB5287
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkhDQoNCk9uIDIwMjIuIDA1LiAwMS4gMTM6MjksIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4g
VGhlIEZlbGl4IFZTQzk5NTkgc3dpdGNoIGluIE5YUCBMUzEwMjhBIHN1cHBvcnRzIHRoZSB0Yy1n
YXRlIGFjdGlvbg0KPiB3aGljaCBlbmZvcmNlZCB0aW1lLWJhc2VkIGFjY2VzcyBjb250cm9sIHBl
ciBzdHJlYW0uIEEgc3RyZWFtIGFzIHNlZW4gYnkNCj4gdGhpcyBzd2l0Y2ggaXMgaWRlbnRpZmll
ZCBieSB7TUFDIERBLCBWSUR9Lg0KPg0KPiBXZSB1c2UgdGhlIHN0YW5kYXJkIGZvcndhcmRpbmcg
c2VsZnRlc3QgdG9wb2xvZ3kgd2l0aCAyIGhvc3QgaW50ZXJmYWNlcw0KPiBhbmQgMiBzd2l0Y2gg
aW50ZXJmYWNlcy4gVGhlIGhvc3QgcG9ydHMgbXVzdCByZXF1aXJlIHRpbWVzdGFtcGluZyBub24t
SVANCj4gcGFja2V0cyBhbmQgc3VwcG9ydGluZyB0Yy1ldGYgb2ZmbG9hZCwgZm9yIGlzb2Nocm9u
IHRvIHdvcmsuIFRoZQ0KPiBpc29jaHJvbiBwcm9ncmFtIG1vbml0b3JzIG5ldHdvcmsgc3luYyBz
dGF0dXMgKHB0cDRsLCBwaGMyc3lzKSBhbmQNCj4gZGV0ZXJtaW5pc3RpY2FsbHkgdHJhbnNtaXRz
IHBhY2tldHMgdG8gdGhlIHN3aXRjaCBzdWNoIHRoYXQgdGhlIHRjLWdhdGUNCj4gYWN0aW9uIGVp
dGhlciAoYSkgYWx3YXlzIGFjY2VwdHMgdGhlbSBiYXNlZCBvbiBpdHMgc2NoZWR1bGUsIG9yDQo+
IChiKSBhbHdheXMgZHJvcHMgdGhlbS4NCj4NCj4gSSB0cmllZCB0byBrZWVwIGFzIG11Y2ggb2Yg
dGhlIGxvZ2ljIHRoYXQgaXNuJ3Qgc3BlY2lmaWMgdG8gdGhlIE5YUA0KPiBMUzEwMjhBIGluIGEg
bmV3IHRzbl9saWIuc2gsIGZvciBmdXR1cmUgcmV1c2UuIFRoaXMgY292ZXJzDQo+IHN5bmNocm9u
aXphdGlvbiB1c2luZyBwdHA0bCBhbmQgcGhjMnN5cywgYW5kIGlzb2Nocm9uLg0KPg0KPiBUaGUg
Y3ljbGUtdGltZSBjaG9zZW4gZm9yIHRoaXMgc2VsZnRlc3QgaXNuJ3QgcGFydGljdWxhcmx5IGlt
cHJlc3NpdmUNCj4gKGFuZCB0aGUgZm9jdXMgaXMgdGhlIGZ1bmN0aW9uYWxpdHkgb2YgdGhlIHN3
aXRjaCksIGJ1dCBJIGRpZG4ndCByZWFsbHkNCj4ga25vdyB3aGF0IHRvIGRvIGJldHRlciwgY29u
c2lkZXJpbmcgdGhhdCBpdCB3aWxsIG1vc3RseSBiZSBydW4gZHVyaW5nDQo+IGRlYnVnZ2luZyBz
ZXNzaW9ucywgdmFyaW91cyBrZXJuZWwgYmxvYXR3YXJlIHdvdWxkIGJlIGVuYWJsZWQsIGxpa2UN
Cj4gbG9ja2RlcCwgS0FTQU4sIGV0YywgYW5kIHdlIGNlcnRhaW5seSBjYW4ndCBydW4gYW55IHJh
Y2VzIHdpdGggdGhvc2Ugb24uDQo+DQo+IEkgdHJpZWQgdG8gbG9vayB0aHJvdWdoIHRoZSBrc2Vs
ZnRlc3QgZnJhbWV3b3JrIGZvciBvdGhlciByZWFsIHRpbWUNCj4gYXBwbGljYXRpb25zIGFuZCBk
aWRuJ3QgcmVhbGx5IGZpbmQgYW55LCBzbyBJJ20gbm90IHN1cmUgaG93IGJldHRlciB0bw0KPiBw
cmVwYXJlIHRoZSBlbnZpcm9ubWVudCBpbiBjYXNlIHdlIHdhbnQgdG8gZ28gZm9yIGEgbG93ZXIg
Y3ljbGUgdGltZS4NCj4gQXQgdGhlIG1vbWVudCwgdGhlIG9ubHkgdGhpbmcgdGhlIHNlbGZ0ZXN0
IGlzIGVuc3VyaW5nIGlzIHRoYXQgZHluYW1pYw0KPiBmcmVxdWVuY3kgc2NhbGluZyBpcyBkaXNh
YmxlZCBvbiB0aGUgQ1BVIHRoYXQgaXNvY2hyb24gcnVucyBvbi4gSXQgd291bGQNCj4gcHJvYmFi
bHkgYmUgdXNlZnVsIHRvIGhhdmUgYSBibGFja2xpc3Qgb2Yga2VybmVsIGNvbmZpZyBvcHRpb25z
IChjaGVja2VkDQo+IHRocm91Z2ggemNhdCAvcHJvYy9jb25maWcuZ3opIGFuZCBzb21lIGN5Y2xp
Y3Rlc3Qgc2NyaXB0cyB0byBydW4NCj4gYmVmb3JlaGFuZCwgYnV0IEkgc2F3IG5vbmUgb2YgdGhv
c2UuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFu
QG54cC5jb20+DQo+IC0tLQ0KPg0KPiArc3dpdGNoX2NyZWF0ZSgpDQo+ICt7DQo+ICsJbG9jYWwg
aDJfbWFjX2FkZHI9JChtYWNfZ2V0ICRoMikNCj4gKw0KPiArCWlwIGxpbmsgc2V0ICR7c3dwMX0g
dXANCj4gKwlpcCBsaW5rIHNldCAke3N3cDJ9IHVwDQo+ICsNCj4gKwlpcCBsaW5rIGFkZCBicjAg
dHlwZSBicmlkZ2Ugdmxhbl9maWx0ZXJpbmcgMQ0KPiArCWlwIGxpbmsgc2V0ICR7c3dwMX0gbWFz
dGVyIGJyMA0KPiArCWlwIGxpbmsgc2V0ICR7c3dwMn0gbWFzdGVyIGJyMA0KPiArCWlwIGxpbmsg
c2V0IGJyMCB1cA0KPiArDQo+ICsJYnJpZGdlIHZsYW4gYWRkIGRldiAke3N3cDJ9IHZpZCAke1NU
UkVBTV9WSUR9DQo+ICsJYnJpZGdlIHZsYW4gYWRkIGRldiAke3N3cDF9IHZpZCAke1NUUkVBTV9W
SUR9DQo+ICsJIyBQU0ZQIG9uIE9jZWxvdCByZXF1aXJlcyB0aGUgZmlsdGVyIHRvIGFsc28gYmUg
YWRkZWQgdG8gdGhlIGJyaWRnZQ0KPiArCSMgRkRCLCBhbmQgbm90IGJlIHJlbW92ZWQNCj4gKwli
cmlkZ2UgZmRiIGFkZCBkZXYgJHtzd3AyfSBcDQo+ICsJCSR7aDJfbWFjX2FkZHJ9IHZsYW4gJHtT
VFJFQU1fVklEfSBzdGF0aWMgbWFzdGVyDQo+ICsNCj4gKwlwc2ZwX2NoYWluX2NyZWF0ZSAke3N3
cDF9DQo+ICsNCj4gKwl0YyBmaWx0ZXIgYWRkIGRldiAke3N3cDF9IGluZ3Jlc3MgY2hhaW4gJChQ
U0ZQKSBwcmVmIDEgXA0KPiArCQlwcm90b2NvbCA4MDIuMVEgZmxvd2VyIHNraXBfc3cgXA0KPiAr
CQlkc3RfbWFjICR7aDJfbWFjX2FkZHJ9IHZsYW5faWQgJHtTVFJFQU1fVklEfSBcDQo+ICsJCWFj
dGlvbiBnYXRlIGJhc2UtdGltZSAwLjAwMDAwMDAwMCBcDQo+ICsJCXNjaGVkLWVudHJ5IE9QRU4g
ICR7R0FURV9EVVJBVElPTl9OU30gLTEgLTEgXA0KPiArCQlzY2hlZC1lbnRyeSBDTE9TRSAke0dB
VEVfRFVSQVRJT05fTlN9IC0xIC0xDQoNCkkga25vdyB0aGF0IG1pZ2h0IGJlIGxpdHRsZSBiaXQg
b2ZmLXRvcGljIGhlcmUsIGJ1dCB0aGUgY3VycmVudCANCmltcGxlbWVudGF0aW9uIG9mIHRoZSBh
Y3RfZ2F0ZSBkb2VzIG5vdGhpbmcgd2l0aCB0aGUgSVBWIHZhbHVlIFswXSBldmVuIA0KaWYgdGhl
IHVzZXIgc2V0IGl0IHRvIG5vbiAtMS4NCklNTyB0aGlzIElQViB2YWx1ZSBzaG91bGQgYmUgY2Fy
cmllZCB0aHJvdWdoIGluIHRoZSB0Y2ZfZ2F0ZSBzdHJ1Y3QgWzFdIA0KYXMgc29tZXRoaW5nIGxp
a2UgYSAiY3VycmVudF9pcHYiIG1lbWJlciBvciBzby4gVGhlbiB0aGlzIHZhbHVlIGNhbiBiZSAN
CmFwcGxpZWQgaW4gdGhlIHRjZl9nYXRlX2FjdCBmdW5jdGlvbiB0byB0aGUgc2tiLT5wcmlvcml0
eS4NCg0KQmFja2dyb3VuZCBzdG9yeTogSSB0cmllZCB0byBjb21iaW5lIGdhdGUgYW5kIHRhcHJp
byAoODAyLjFRY2kgYW5kIFFidikgDQp0byBhY2hpZXZlIDgwMi4xUWNoIG9wZXJhdGlvbiAod2hp
Y2ggaXMgcmVhbGx5IGp1c3QgYSBjb29yZGluYXRlZCBjb25maWcgDQpvZiB0aG9zZSB0d28pIGJ1
dCB3aXRob3V0IHRoZSBJUFYgKHNob3VsZCBieSBzZXQgYnkgdGhlIGluZ3Jlc3MgcG9ydCkgd2Ug
DQpoYXZlIG5vIHdheSB0byBjYXJyeSB0aGUgZ2F0aW5nIGluZm8gdG8gdGhlIHRhcHJpbywgYW5k
IGFzIGEgcmVzdWx0IGl0cyANCmp1c3Qgc2VuZGluZyBldmVyeSBwYWNrZXQgd2l0aCB0aGUgZGVm
YXVsdCBwcmlvcml0eSwgbm8gbWF0dGVyIGhvdyB3ZSANCm9wZW4vY2xvc2UgdGhlIGdhdGUgYXQg
dGhlIGluZ3Jlc3MuDQoNClswXSANCmh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L3Y1
LjE4LXJjNS9zb3VyY2UvaW5jbHVkZS9uZXQvdGNfYWN0L3RjX2dhdGUuaCNMMjENClsxXSANCmh0
dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L3Y1LjE4LXJjNS9zb3VyY2UvaW5jbHVkZS9u
ZXQvdGNfYWN0L3RjX2dhdGUuaCNMNDANClsyXSANCmh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29t
L2xpbnV4L3Y1LjE4LXJjNS9zb3VyY2UvbmV0L3NjaGVkL2FjdF9nYXRlLmMjTDExNw0KDQo+ICt9
DQpGZXJlbmM=
