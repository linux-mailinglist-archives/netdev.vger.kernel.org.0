Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1CC51BA4D
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 10:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348555AbiEEIaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 04:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348302AbiEEIaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 04:30:02 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2130.outbound.protection.outlook.com [40.107.114.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BC7340E9;
        Thu,  5 May 2022 01:26:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OynxgnJP8rrqQXTZz1Bto8i2sWXkXmWRg2LcOMXPh26rSKZoTcg5kbJEXhJzQ8GqGhAyRfZlp2CSXBpHtRK4RrJkDeL/t9WtZr6MrzrMLDRYz0pMUmGTGQXHv5he7szxxQlGc09KJa05Woh8sd61OJoEcYfR/d61n9GNSYVQxsqVPCjBsS9Lt+cMLqZCI6Yqim2wV/91uhKNMfZcNkiy++KUFiIVN1Ly46qvRmq+vHJ4QEhA9z+yNi/RL6ZFZLYdZ5FJMh4y+nkhayBTr/MapGJ3WZMu+5DRrjKTRFd4ttVh7MZqNa+k4v/efOuyBbyX4Jt13tWpbLKz96gHJbZsZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YqK6ktVeoN8u2pMQnes4lL39HMTiyMyc2X0fF1WWn9k=;
 b=X8cUs9ZPSdH6Hcllkl3RGYNhXb/hUAQevl49iCz3i0oP+oCJv66cTPrSQTs7kG/eAWyHXJ3Ixn7DA4KGgqZcCItHXRMg6c2kZTaInZzx2JEYQefw3Ws9HfoOXbkGWmVP7IkqKxwbYqv+bqok3cP2x0q4rlVWQWlvTlYdJFJ7wS6j2cc3KZ4RcOFL3uNwUGuduc+x24qbB6wATM8fU76DUKyXdCw5yCO0T7g/3YW7X2TWX0RT56sbS4mHr1z/nDyhVKpLDJwZd3UQmfm6CY2qnlAzZiADDUyL4pBOPI6oCLDLIv72AjjW4Mbpc4VL8U9J+695MH8lwSPdKNdpVL/vug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqK6ktVeoN8u2pMQnes4lL39HMTiyMyc2X0fF1WWn9k=;
 b=Ycy3keHUF8e9OHrK2R3z2PRzNgg7PgSJfI1k0S7PoPP32tJTEqro0WkMXtR9vF7PHkO2yLI6NENkQ9V/SBHe6wtjb3FMPgqNQOxjLK3hwdcmZAwCe2fBV53KPJCEA18B5qT1QbOIhl+sjB7xKaxSxlHJPnvODyCXcxvU1WITnx0=
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com (2603:1096:400:de::11)
 by TY1PR01MB1674.jpnprd01.prod.outlook.com (2603:1096:403:2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Thu, 5 May
 2022 08:26:20 +0000
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244]) by TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244%6]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 08:26:20 +0000
From:   Phil Edworthy <phil.edworthy@renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
CC:     Biju Das <biju.das.jz@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 3/9] ravb: Separate use of GIC reg for PTME from
 multi_irqs
Thread-Topic: [PATCH 3/9] ravb: Separate use of GIC reg for PTME from
 multi_irqs
Thread-Index: AQHYX8cTbSA3aaX0qk+IOyWB2dPOW60PLtAAgADE46A=
Date:   Thu, 5 May 2022 08:26:20 +0000
Message-ID: <TYYPR01MB70865430D4CC407AADD54752F5C29@TYYPR01MB7086.jpnprd01.prod.outlook.com>
References: <20220504145454.71287-1-phil.edworthy@renesas.com>
 <20220504145454.71287-4-phil.edworthy@renesas.com>
 <dd090d04-d2d7-4c9a-75cf-ba0c305de495@omp.ru>
In-Reply-To: <dd090d04-d2d7-4c9a-75cf-ba0c305de495@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c577a9a-d3ed-42a9-d58e-08da2e70eee2
x-ms-traffictypediagnostic: TY1PR01MB1674:EE_
x-microsoft-antispam-prvs: <TY1PR01MB167495A6606C587E15A2F816F5C29@TY1PR01MB1674.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d9iOtfi/wct+lGUCX4coA0LZx2CwPKTBoNAqsqkVpJvVsTik3NzEv3Aey5ZxLhkb6PwPAs2i6a41CmORj0PJSyHBIgZmgWRyRFa35QVsfHhHvo+d0VPGtfP2GSSuSNmkPEMk6X/Sg0JxdaZQc/nVM9IoDYaWKN3wQVoLMN7SC+VYxVQpgJw8X8qbvJVKLjPQLbD2zYoQICFCjQ4NAqvSlMYLSkLNetYcUuyWGqLyObVFaHI1npgDaD2RwSzKvLqmO+my0hLRvZRS0AXXsQu70Gyn8Rvlsx5VQgpJ7t8+J2Eje5DJwMSifA7pTgRH6flV05FIn8hIFr/TTtGbLoP2C02qZLjh6rYtCFP8hzCWufSiPM5+a8kaw0SORRrZ36xGJsIUmRHA1TChVWwTaLjEaSfNf1ck0eRB9R7yvlxTzPQ5sJwVn3D7ZFNc8H7jfI9vTf1GlN9iRip8qLXT1UqoSIo9KrvbLmmT7P3fmjnjSUeABpdpnbvhizE4zH9OREEAdv83NwHs9YMSKyztNs9fJPTROH1gQvuqP1ga3MYw9fo5RVASp21j0L5ImsweHsrKbXHyJ/C9ZyH1OyRoJCaQib7mvXuK5I9Gm/AvGkawHrNyHbEH/a69hVHECBCAS9MkqOQkFk5kruwJOx5jbLDuW3bVPT9iGE8rzM5SJ3lBN3TaZb23NlXglVCv/ED+B7tAYeLkQh91hWSipAUYr9NzCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYYPR01MB7086.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55016003)(9686003)(508600001)(83380400001)(6506007)(33656002)(8936002)(5660300002)(26005)(44832011)(52536014)(186003)(2906002)(71200400001)(7696005)(54906003)(53546011)(4326008)(110136005)(8676002)(66476007)(64756008)(66946007)(66446008)(66556008)(76116006)(38070700005)(38100700002)(122000001)(316002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cStzVm5hSG8wek9HTm5zM2VvN1V2QnZOTE9lVVFlL2diY3JtcTNzb0pCelM3?=
 =?utf-8?B?L1A0VU5IYUdnUU9lV05rRDBFbXJZVWp5YmtubTNrK1BlTUZXSVZtZE1xcnNC?=
 =?utf-8?B?Mk9zNU1lZ3J2ekhFaHpEaFY2YmcrMzJHLys4Si9ZNThCZmRha0hCbzJZT3Jw?=
 =?utf-8?B?dld0aVlhSzBKZ2poWFNiZnlqTjk0c1dad0dtTER3UjMwb21ISm9ieVdRb2RL?=
 =?utf-8?B?TFBVN0p4WThWYXZGcFZVSjNNUkxJbDBZVTZXUjUvMjM3UXRpeUdZY0FlaEVn?=
 =?utf-8?B?bU8wbXU5ay9kaFNEaGk4UGtXQ1h3aWRWTFk0WVNRU0w2T2luOGxuZVNqTmtF?=
 =?utf-8?B?WXJtSXJzMG1lNEt3TVUyMFlpMDFJNkRpUG96TnZuV1pRamJJeVQybVhhNjMr?=
 =?utf-8?B?dTVWV1ljRmkxT0FVUWtwaU12OHRTRXJoYjhwcEdZRkFiWGpTQjlvNFpYU2th?=
 =?utf-8?B?eXJ4SnlCVE9oeWVuMEZBaGFqdk9Tb29pOXU1Z2R1b0UzMi9iak40c21JYTdM?=
 =?utf-8?B?SlpjNklhcFUzbFh2RWIxYk1LT3FFbHFvbHcwTXFWWlZBWE93L1RoV3ZvZ0Rn?=
 =?utf-8?B?amJNdlU4N280cEZsR28yRyt2ZmFGUDN0YjE3Y2xYbTRFeEdkNEpaVGRORW8w?=
 =?utf-8?B?b1lhRC9iMlFYRE13V2FDM0Y2dy9adG1yT3Bxc1k2SVcyanBsSHNNUWFwS05h?=
 =?utf-8?B?cWdNQjZpalo3Nm81RnZ5SjlXdCszcUlLeU16a0QvMEQyekFnai9BakszVEMx?=
 =?utf-8?B?a1V3dzdrZ1V6S1gwbFBEY1FLYlg0dkRCRVlCUUs0cXB4c2pKY01iMFNpV0tR?=
 =?utf-8?B?NUs3Q0JtVnVtQzIrRUdraFl2aVp6UVRPRHc4VGJEcm1vQ3AxcXhKQW04ZGMx?=
 =?utf-8?B?VDdDQm1WNVY0cmJGTTZqM2RzM2RDbmQwVHFRcjF4MW1mQ1BneWJERkhNYmtq?=
 =?utf-8?B?QkwzSlAxdjhzOVdWNHBBZlJlcm40WE8xVnRINnZKcjlRS2cwMTg5WU1PNjhS?=
 =?utf-8?B?V3NpVGUyTE1TcGRzVkZiaTZzRG84Y2MxQU1URGFTZmhFbytUWW82bXd5UEdJ?=
 =?utf-8?B?R1JRVWVlZzViaXNvdDVoYkl6ejJCNFVxS0Q2WWlMbXpXdWtoVzRYZzE1ajFR?=
 =?utf-8?B?cWV3UVNtOVU5aWxSUXI1eWJFZHlzcDhhVEZ0VEpQWXNBVVdRRHk5K1Z4dmh4?=
 =?utf-8?B?bEZQK0FxMCtDcFZZOUZnd2NiWlZYK1plNDBtaFh3MExnZXg1SU10Zm1tcC9a?=
 =?utf-8?B?YzZ3ZHg5VjA2ZUZZUG5JenRaWHNnNzl5TmZlZkpkQklRc1E0dEpVZ0dqWHRK?=
 =?utf-8?B?VWpQaHozbEJaeUY3OXdSR2dpUTBMRmNXbXdZbzdxRFE3RVVkeFBwOUtvMWJO?=
 =?utf-8?B?K2dYbFFJSWlyc2RMbjc4MVcvQUdmTXpvRVk5c2NDelJBN1lwRllkcmpFdjRY?=
 =?utf-8?B?NTk2WmZNdktJVTVhT0dacDNDTUQva3d6NFpQVjFSMlJPaldGZ3FYRTE5cFh6?=
 =?utf-8?B?bU9MNE5PWWpRek50RzVwdFlYQXhPZ2dRYktVK0hNajE1NllNQVJWcWUwN0hY?=
 =?utf-8?B?di9TandBMkVuejFERTdJUnQrVWhnendUUzV3dFZYQ0FVOENxbHNEZUpmUVBh?=
 =?utf-8?B?eERXaEcyTm5RWHQrY3F5d2x2WWk4YmFhZHhMaXNyeVdRc3dLaGZtMnZsd2dO?=
 =?utf-8?B?WjFEcDNhTHE5TU8zdkhSRVg3RHJjUFFzRFNNZkJtRTNobS9iTTJVT2RSWGhl?=
 =?utf-8?B?S2VIQ09CcDQ2UGhCdE1salJkbFVRYnYvTVBXUi9GNXYyYjVYVElxWjlsREVN?=
 =?utf-8?B?RVY4Wko1UmRSVXNYeWpsRVVOMFZ1bk9ET1VhVXk5Nm5keUdNUzI2UjZJbTlD?=
 =?utf-8?B?a1V5NlRGSHF1eHIrUjYrZWg2VHhxTEd4M2ZXWUNjY3NvendMT25MVkhoR0xO?=
 =?utf-8?B?NFhjb2VQc2hBOSt2UlNNMEEvMUZuVllxMGNCRHFnV0s0WENMdmcxdmhqWjVM?=
 =?utf-8?B?QnNhbkZaeUFFNFFKczRub1hxY1RRaDh5ejhBRWFFZlZmUXNjc2VCMGRJQzFt?=
 =?utf-8?B?TWhlYU1tUWNtTTE0aWQ3cmZaQXFzTHltM09qSGNvVkd6alZMVVZYOFA0RlAz?=
 =?utf-8?B?UDN6aHI5QnJYdDNXNWRPVy9rdGZXbWZJbEI5bUFVZTg2QzVxVlAzdmZYckVK?=
 =?utf-8?B?NW1LVGRTdWxoWWxDeDl0K3pZYThLVmdOVkppS0R4WDlRRFV6dUxVaEJGWDN3?=
 =?utf-8?B?bDZWa2I5T2FjWGtIZzBYUlcrNlduR3kxTVROSFpQMHVEdE9lWTM0NmNhVjBI?=
 =?utf-8?B?QjNEYmpNY1loeVdhSlBWM0pLYmxQOTAwSTJ3TmN6UWJtS0xhR3hNbGpqSFkv?=
 =?utf-8?Q?PRPAyiYZJAIZlI98=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYYPR01MB7086.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c577a9a-d3ed-42a9-d58e-08da2e70eee2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 08:26:20.4779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I8aJBjCRvGjptwu9R3OOG8u19u2tpmpZQBPdt60vbW8tUgi7Gh7uy+1yqjC65gnjTNMXDdTViNTPHGzcOvMqKnsZJq1XnKkx5rwuxTZFfjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PR01MB1674
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpPbiAwNCBNYXkgMjAyMiAyMTo0MCBTZXJnZXkgU2h0eWx5b3Ygd3JvdGU6
DQo+IE9uIDUvNC8yMiA1OjU0IFBNLCBQaGlsIEVkd29ydGh5IHdyb3RlOg0KPiANCj4gPiBXaGVu
IHRoZSBIVyBoYXMgYSBzaW5nbGUgaW50ZXJydXB0LCB0aGUgZHJpdmVyIGN1cnJlbnRseSB1c2Vz
IHRoZQ0KPiA+IFBUTUUgKFByZXNlbnRhdGlvbiBUaW1lIE1hdGNoIEVuYWJsZSkgYml0IGluIHRo
ZSBHSUMgcmVnaXN0ZXIgdG8NCj4gPiBlbmFibGUvZGlzYWJsZSB0aGUgUFRNIGlycS4gT3RoZXJ3
aXNlLCBpdCB1c2VzIHRoZSBHSUUvR0lEIHJlZ2lzdGVycy4NCj4gPg0KPiA+IEhvd2V2ZXIsIG90
aGVyIFNvQ3MsIGUuZy4gUlovVjJNLCBoYXZlIG11bHRpcGxlIGlycXMgYW5kIHVzZSB0aGUgR0lD
DQo+ID4gcmVnaXN0ZXIgUFRNRSBiaXQsIHNvIHNlcGFyYXRlIGl0IG91dCBhcyBpdCdzIG93biBm
ZWF0dXJlLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogUGhpbCBFZHdvcnRoeSA8cGhpbC5lZHdv
cnRoeUByZW5lc2FzLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6
QGJwLnJlbmVzYXMuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5l
c2FzL3JhdmIuaCAgICAgIHwgMSArDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yl9tYWluLmMgfCAxICsNCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZi
X3B0cC5jICB8IDQgKystLQ0KPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3JhdmIuaA0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5o
DQo+ID4gaW5kZXggMDgwNjJkNzNkZjEwLi4xNWFhMDlkOTNmZjAgMTAwNjQ0DQo+ID4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiArKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IEBAIC0xMDI5LDYgKzEwMjksNyBAQCBzdHJ1
Y3QgcmF2Yl9od19pbmZvIHsNCj4gPiAgCXVuc2lnbmVkIG11bHRpX2lycXM6MTsJCS8qIEFWQi1E
TUFDIGFuZCBFLU1BQyBoYXMgbXVsdGlwbGUNCj4gaXJxcyAqLw0KPiA+ICAJdW5zaWduZWQgZ3B0
cDoxOwkJLyogQVZCLURNQUMgaGFzIGdQVFAgc3VwcG9ydCAqLw0KPiA+ICAJdW5zaWduZWQgY2Nj
X2dhYzoxOwkJLyogQVZCLURNQUMgaGFzIGdQVFAgc3VwcG9ydCBhY3RpdmUgaW4NCj4gY29uZmln
IG1vZGUgKi8NCj4gPiArCXVuc2lnbmVkIGdwdHBfcHRtX2dpYzoxOwkvKiBnUFRQIGVuYWJsZXMg
UHJlc2VudGF0aW9uIFRpbWUNCj4gTWF0Y2ggaXJxIHZpYSBHSUMgKi8NCj4gDQo+ICAgIEkgdGhp
bmsgdGhpcyBuZWVkcyB0byBiZSBjb250cm9sbGVkIGJ5IHRoZSAnaXJxX2VuX2RpcycgZmVhdHVy
ZSBiaXQNCj4gZnJvbSB0aGUgcGF0Y2ggIzQuDQpHb29kIHBvaW50LCBJJ2xsIGZpeCBhbmQgc3F1
YXNoIHRoZSB0d28gcGF0Y2hlcy4NCg0KVGhhbmtzDQpQaGlsDQo=
