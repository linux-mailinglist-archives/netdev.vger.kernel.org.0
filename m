Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8A76B6E01
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 04:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjCMDe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 23:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjCMDeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 23:34:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D88E30E99;
        Sun, 12 Mar 2023 20:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678678462; x=1710214462;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VWtu5J0WQTWk1P6CEl7t3z5qgCssuwj1WBQnXgfQFmU=;
  b=cJbwOzZ14Q8Y3CvbdgNbAwgcAC2F7B/SKB9ebdfaV0/sBTO3zzZtfd1X
   T5S2GhUNdmxHXeKhoLucLBKIVdCH8BXZNMoFT0OnAcLUDknXUk/du+KqA
   OmsKNSr1ndwT47N+duo6ArkPfJsjE/+hHeA39sYwShteRizoEzs2Jpo2a
   55JlwunhbJ0y0/Tr3hmoBCZc2b4RuZbQ75213yr8+yeHYRhOHpjhKsmc7
   o0lE6A1cPBsDlfCC1Jmtfc2YXuNrpOPq43HvvvRvOmE1576lOEbhZXkLN
   vvtULfGlgb8dY13LAXsh+jJD2ocK1AKnogPaqwj3Vz7jsi7cO/uHo3kCT
   A==;
X-IronPort-AV: E=Sophos;i="5.98,254,1673938800"; 
   d="scan'208";a="141659973"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Mar 2023 20:34:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 20:34:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 20:34:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6chfM21Q3tLcp0CC1+LmBKJS1NyLXKtVpKyvEF3acKGeUeb6l7Bn2TBhVLGcqR8wCGDYqSXdi7f7IkSh7RSXROKC7UzJEWi5bWzGCKWT3UeaF6ahhoUccBSRmuFSiCkgJxjnpG5h8M0f9uwbIh1VH7VgohZAECT99TkpEVPOUYVBGVkpVVZlHIMl1mNOWtp5UsRkOoNQwyHlyPsyYZN1P6uqzEyyU0c7QbByW45ROUzzqvZHmlBxrc4qLjLS/wsNdS9sHyjG9VDr3lMjnjFvLbbIp1woF2CsfNJOQeUA1Mc3DNXIT6kDSPKx8kJxYtdtnPjsFuTOw47EADi5OW/LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VWtu5J0WQTWk1P6CEl7t3z5qgCssuwj1WBQnXgfQFmU=;
 b=oTHeJQ6fSzKHTx8OnKytUpxMXmLFU7okBMs03t4f01XQEuIvr4nkiy0pPWCmL5sKMVpG5DiM3IWaydxymIgBcwo4w64Ef9A4Cs/iilO34HcJEtzCDhc0AI11A8K/ZAWq6LYKv+RygIWp6exPUYKxplsgjVhLElxUvn5UrfYZSalWAT3WNJFDQJaq3ZQOp0Sci5q2eDP5C0WSZJVU8OwpApooDX019CMUgfS+ZJav3YFlo/Qs76kEPkiNXZ+fxDPDqGgPymVyyLyCV9xNAW5g90JgOzasO2+nOd/SIQSBE9U6kgWty4jvf/vAxNxPgq2nogtIESwIoVvxtCjBG6ccig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VWtu5J0WQTWk1P6CEl7t3z5qgCssuwj1WBQnXgfQFmU=;
 b=UQPh5clXsP8L9i4XUK74E1gZ+qgyzjHZI9OxWWBAjfsaQSY5c448g/SmDZjfEKd0R3CiK1Tc+k09qkmTtWhEmQQ8hQnzBTvkwtFFQMhcM8bm3YOHEcShv5fBOQg7Jrp2MYlrgbnbQdvP1BG3mPHZM/zovkndAxvK+05cK3L1UwI=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM4PR11MB5248.namprd11.prod.outlook.com (2603:10b6:5:38b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 03:34:17 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00%3]) with mapi id 15.20.6178.025; Mon, 13 Mar 2023
 03:34:16 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v3 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Thread-Topic: [PATCH net-next v3 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Thread-Index: AQHZUy//xI4vRrArI0eXiyVZdC83n674EwIA
Date:   Mon, 13 Mar 2023 03:34:16 +0000
Message-ID: <1b07b82f8692f5eb5134f78dad4cbcb3110224b2.camel@microchip.com>
References: <20230310090809.220764-1-o.rempel@pengutronix.de>
         <20230310090809.220764-3-o.rempel@pengutronix.de>
In-Reply-To: <20230310090809.220764-3-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DM4PR11MB5248:EE_
x-ms-office365-filtering-correlation-id: 36a3520c-ccf5-4077-e64b-08db2373d289
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y3CR9Wna0ANwWrWWVbQWLDWWgGj2Qox3IXjOSH/oeLVqKepGUZhOJn5p4JHQhgnSjeS0CMCIT6sgvR7q77HB0TXmMjmE8OuMMQ7iQfiUa8PW2myflUOJ8VpDgw+J1q0P4zg5zw7QKxODkHZBUdtVXgT1bA9VrFBVw8BJxkPJwgpTdZ/7TtJy+FEZ4CNKq1scrdzJbO3Kyh+/4EPYjopJA2zRQQ3nxR3KD8sw8JNZ3EgtiI5AeHIbLSfiViUKvBYM1kUaPE1Yz9xvO3XVF2qRX/WAAAvscNvngcSbiuIrhZQLD4SYObi36cCfaFAQub2i6sNgtmobgiD8aOFDfFXRbbfu0qzRtTf2YHaq8AtqCk8ZFAsDZBVUhcPRSDoKwKWHKtCroNvrWbFevTDqYhy0njuO21wxpB2KPVn0YxnTpOTRgbxPuvGcyg9XDI2NoSRpx6aDD38D6U/q4DKDyodcJMeh5qTVlkfTz6m7vczbTYbimWv5zuj/46JjEDy240LWQ9bALzs7y4XASHilNSICEW/mrdGkHj5OWlO1gLfV0j1YddzOATZxKxbw0lE675zpcSE88AQfwRDevmp2aygIeIX7BaK160Fm0fhDDhhQnAOhwYCvTMpr+CuXdiCSPfRYnSOPm8xL/o1Civoux62aKTL3/IL2hUhCVVt4CXLYgP8ulZeIqvC/336JH8mW2LUdHI0tyTRO5VxA9171RQD/WQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199018)(122000001)(2906002)(83380400001)(36756003)(7416002)(5660300002)(64756008)(66556008)(76116006)(66446008)(66946007)(41300700001)(8936002)(4326008)(8676002)(66476007)(38070700005)(91956017)(38100700002)(54906003)(86362001)(110136005)(316002)(478600001)(186003)(2616005)(71200400001)(6506007)(26005)(6512007)(6486002)(966005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QjhmaGs4eG1RdHErdXV2R05pSEJzU21iSFJobXpwVkc0QzVwMUl5R3kxd2Jz?=
 =?utf-8?B?N3Z3Umk5ZysrVEZ3cU1XZHVOZEZCSDJSaUlVenIweEcrK1NlR2o2Smcxc216?=
 =?utf-8?B?UCtHYm03Kys0bjhTN3BRRlhFS2U0ejNzell4MllES2tVZFFWQjE5NkRpSVZO?=
 =?utf-8?B?TTA0ZmhHNnNYTlRJN0VJMUxDUVF1ekUyeDdXRWhIYkZrZmE0OG9jTmtjZnY3?=
 =?utf-8?B?eGVGRnpvd3E5MkZobTVnMnh3Vm1rbnZ5ejJZQ0Voc2huWXBLbUNjUm15Z0Ey?=
 =?utf-8?B?TEwvakNPQ1Fqb3IzN2N5NXFpQWNGV2V3QWY3Y0wvSU1KSTZDZU1VNXJXZXNN?=
 =?utf-8?B?cGhGdWdxWkpaL0pGTUJyT00zeTBXVGdYTGw4ZFpmSzNJbUlxSFhqZlp5Mldo?=
 =?utf-8?B?SVJieDcrYjVFUjVIMmRRRVZ2L1g3c0FydXc5UWlNeUtGVmF3OXdUWDRBamQ3?=
 =?utf-8?B?TjNPSmRaaUNXQXdOaURIZmRweEpvZDQvdzhQNmRWWitwN2YwTm1Oc2hRYU42?=
 =?utf-8?B?a1BjaFBYK2tlbk5pTjBJa1lpcGpMckt1NnA1eGliKzdsT2J4aXR2ZCtZdFNF?=
 =?utf-8?B?d2tMeTJJRnRwWStZRk9Pa3k1RlpESlJvMmluSXphZGRrdjN6UTRzUllpSUZT?=
 =?utf-8?B?UjVxK2xRclNCbTdkTWpQVHJqTktwWmdrYVlkb3BRY3BEU24zOTZLcjR3K1NJ?=
 =?utf-8?B?bnJFbXhHRmMvQmhqajZRVlppWUVnQm15RjIvQVBPcGNnWXJCWHZyVHJpYXVv?=
 =?utf-8?B?dlZGTUlrVnMxQkkreTlGZHdTUG5oR3FOR1Y3U3EzQ0NJQ0pudHF1cTVaRUdS?=
 =?utf-8?B?QjdrMHg1SkRTVnBvcUxKd1ZVQW1vRzY0b3lsbFdEL0wvM0ZZQ3hrSVlZbHlY?=
 =?utf-8?B?ZHhCejZzdk96TU8rRUl2d0ZmZ0NFWDhvak5iMHBtUWU4bWI1R3BRTkZUREJM?=
 =?utf-8?B?YW0vL3BHMVhJZ2d3QVNpZW9Da0RQc2Y5RVRleGRBQWRQL3owWXJVb3Y4VXhS?=
 =?utf-8?B?aGdmNnpRV1ZacDdHV0dHbWlXVC9qQStibjVxdytUbEtKTGVQTFZtMGM1MFRv?=
 =?utf-8?B?bFJQWWlidSsxcmlRM0FVelhhZ0d3ZFBnT3ZJamxycWdXUkU0MzNwZHVER3lY?=
 =?utf-8?B?UzU2VDJLMnZhVmhPMmtKYTVwVWQ1SmRMcmc3RWdpZE00a2xhVEQvdUppNFNj?=
 =?utf-8?B?SDFVd3hNTTh0WXNJUE1VQ0ViWWVyMHorY0N5OGU0dk5wZHhKQ1F5bmxTWHc5?=
 =?utf-8?B?dnNLVFFPdVY1d3ZDeWwxaCtKZTlKM1RUQ2NlUUVWa1lDYkRuVGUwa2laUWd5?=
 =?utf-8?B?K3R4a3crU29OTldieGFyN2xPZ01TbzUwSUxmRGhpdDhjQjQzUmF4RkJUamdk?=
 =?utf-8?B?ZXVhREwvWGxkKzlUSnViaTYrcHlXdDV0RXZ3d0VUeEQ2akVNZkpoOWM0eHlD?=
 =?utf-8?B?SmovQXRJU2V6MkdRRVpGQWNKL0hEK1FGNERJOFgwaG1LTG16d3FmeExqZk5I?=
 =?utf-8?B?SlI1V0hqQzF6UzZoVU1maTZSOUVDdFZrNEVrTjhoZE1veUc0cEZOTHJ3TDg3?=
 =?utf-8?B?Wkp3K0N4eEJPdlZrOEpJaHV2aDI5a0NlV0RFa2pWZnlOTGxYWTZzNXJWTEtj?=
 =?utf-8?B?SDNDbndMUnZoR2o3VjNOa1dvdTdLVENJNE1UeVFGUUF4RDhEZHZhRUFlNTlw?=
 =?utf-8?B?eVBuTFFJZWNrcUhVak9oNU90aGVuRXRCN3JIL0hCZlhFYXJUaWtTUUJ0eStB?=
 =?utf-8?B?dTczTEJTYlEyb29tVmlObHhOSHoxeTRFalA5MUxEdndEU0hNV0xvdVFxMnNp?=
 =?utf-8?B?clhhK3FDWU1xWTJFNkRXTWhmUkQ3UDdlaWNSeCtrTmdyREQ4c1pjdjA5b3Vk?=
 =?utf-8?B?ck1pTWFkcHo1Z3liVERmWGtXM1ZSdC9wcXJzcklTOTRMaXpvc3FGV1YvVkF3?=
 =?utf-8?B?YWw4bVFFVktOcXdPMmxOU3BrV3lVMFFSUHpGWnBrTGZjMGhZKzVQaHlvTEZY?=
 =?utf-8?B?RjYwVVdNcTNGdGlhK3VvMm4vMnl3TmQwamxzSGx6ZGgrbGc5R0xWT1hib3Nw?=
 =?utf-8?B?cGttOE9VbmMzM2paV0FEMFFIN3J1OTdUSytRNGlRNWk5RnJsUmZud0hsVlBM?=
 =?utf-8?B?TTN4NVp6eUcwVzN0eUxnUEZlWTJ4MlhSWU9zMFB0WmNxNTlIV3JPcjBxSDNJ?=
 =?utf-8?Q?wQrte/DX2IQBbfHWyjeAsiE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0EABD47100413438367D91A95651307@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36a3520c-ccf5-4077-e64b-08db2373d289
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 03:34:16.3208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mem7+Wbs5nQLILTdZouDaGpB0sKiyfC0H6wwdGEit2tpHeT4csu1lo0HSz9tVdIm62pZMSOCdnmIMEaWdBcjP7ZlUEd49BhvxnFuu8+N9ik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5248
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCk9uIEZyaSwgMjAyMy0wMy0xMCBhdCAxMDowOCArMDEwMCwgT2xla3NpaiBS
ZW1wZWwgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiAN
Cj4gQWRkIEVUUyBRZGlzYyBzdXBwb3J0IGZvciBLU1o5NDc3IG9mIHN3aXRjaGVzLiBDdXJyZW50
IGltcGxlbWVudGF0aW9uDQo+IGlzDQo+IGxpbWl0ZWQgdG8gc3RyaWN0IHByaW9yaXR5IG1vZGUu
DQo+IA0KPiBUZXN0ZWQgb24gS1NaODU2M1Igd2l0aCBmb2xsb3dpbmcgY29uZmlndXJhdGlvbjoN
Cj4gdGMgcWRpc2MgcmVwbGFjZSBkZXYgbGFuMiByb290IGhhbmRsZSAxOiBldHMgc3RyaWN0IDQg
XA0KPiAgIHByaW9tYXAgMyAzIDIgMiAxIDEgMCAwDQo+IGlwIGxpbmsgYWRkIGxpbmsgbGFuMiBu
YW1lIHYxIHR5cGUgdmxhbiBpZCAxIFwNCj4gICBlZ3Jlc3MtcW9zLW1hcCAwOjAgMToxIDI6MiAz
OjMgNDo0IDU6NSA2OjYgNzo3DQo+IA0KPiBhbmQgcGF0Y2hlZCBpcGVyZjMgdmVyc2lvbjoNCj4g
aHR0cHM6Ly9naXRodWIuY29tL2VzbmV0L2lwZXJmL3B1bGwvMTQ3Ng0KPiBpcGVyZjMgLWMgMTcy
LjE3LjAuMSAtYjEwME0gIC1sMTQ3MiAtdDEwMCAtdSAtUiAtLXNvY2stcHJpbyAyDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBPbGVrc2lqIFJlbXBlbCA8by5yZW1wZWxAcGVuZ3V0cm9uaXguZGU+DQo+
IC0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMgfCAyMTgNCj4g
KysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3pfY29tbW9uLmggfCAgMTIgKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMjMwIGluc2VydGlvbnMo
KykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21t
b24uYw0KPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+IGluZGV4
IGFlMDVmZTBiMGE4MS4uNTRkNzVlYzIyZWYwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9k
c2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9j
aGlwL2tzel9jb21tb24uYw0KPiBAQCAtMTA4Nyw2ICsxMDg3LDcgQEAgY29uc3Qgc3RydWN0IGtz
el9jaGlwX2RhdGEga3N6X3N3aXRjaF9jaGlwc1tdID0NCj4gew0KPiAgICAgICAgICAgICAgICAg
LnBvcnRfbmlycXMgPSAzLA0KPiAgICAgICAgICAgICAgICAgLm51bV90eF9xdWV1ZXMgPSA0LA0K
PiAgICAgICAgICAgICAgICAgLnRjX2Nic19zdXBwb3J0ZWQgPSB0cnVlLA0KPiArICAgICAgICAg
ICAgICAgLnRjX2V0c19zdXBwb3J0ZWQgPSB0cnVlLA0KDQpXaGV0aGVyIHRoZSBzd2l0Y2ggd2hp
Y2ggYXJlIHN1cHBvcnRpbmcgY2JzIHdpbGwgYWxzbyBzdXBwb3J0IGV0cyBvcg0Kbm90LiBJZiBD
QlMgYW5kIEVUUyBhcmUgcmVsYXRlZCwgdGhlbiBpcyBpdCBwb3NzaWJsZSB0byB1c2Ugc2luZ2xl
IGZsYWcNCmNvbnRyb2xsaW5nIGJvdGggdGhlIGZlYXR1cmUuIEkgY291bGQgaW5mZXIgdGhhdCBz
d2l0Y2ggd2hpY2ggaGFzDQp0Y19jYnNfc3VwcG9ydGVkICB0cnVlLCBhbHNvIGhhcyB0Y19ldHNf
c3VwcG9ydGVkIGFsc28gdHJ1ZS4NCg0KSWYgYm90aCBhcmUgZGlmZmVyZW50LCBwYXRjaCBsb29r
cyBnb29kIHRvIG1lLg0KDQo=
