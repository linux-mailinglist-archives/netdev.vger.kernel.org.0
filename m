Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1BF6CB35D
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 03:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjC1Bs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 21:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjC1BsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 21:48:25 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2053.outbound.protection.outlook.com [40.107.22.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B7B10CC;
        Mon, 27 Mar 2023 18:48:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HoXkxU3tF4F83WPJnVXut99rscZPxnY06UacC67eh5LyGG7CAcwkDINzYvUZ92XA0FBtrWuXqijEi40thJ1hAlKkiJmDhXB00POaGxOo8byAR4CnOAJ1gp6GSLhusuVO0iwZhJgaxTERrl8aEeH+09PGs/ETTjbDsKFPAPGS5FdEySFCcvpCS3d60UxoEnZVSEfl54XMVFGToTqRJvOSXNJotaQVgSwKEzRO3BDWve6qHI92bWVDYRzvQMKA+Vs7CDiNCK6BOum5+E4aQTJIQNLAp8UJ5aG3+mA+vDnNIX8xQ+Q5+DL1ICmGgr4MfcMx+B5yDmi2J5ANNX2f9u3RYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9qEwIvw+5gjiMSwT2zc8t9hZd6d4IuGU8+n3NghsKw=;
 b=CKVTajD+05XdKxiGtve+0gmSlAjDy5swUiS778vdy4wVfE5JDp1OoXVIBjAxit/oaQugUX+pFip9YSZ2LhyKjC521DkqV5yUEsVE7GTt0GtXWjenSO5hfbnCgYIU9jsN3iZv1I1hgiMptGs0tmbBlekUVLMUCHxTuY2qMMDuFpSXbGvEwWYhq0J6miMaXWlBeQWEkIcp8BzVrrUubKANN5lT7pUuL2jv1Ess/yzpda+k0Kerxd62F8SPth11BMOAqpaUrZV49mzTgGP1/oYHSeh/RjVizGnql8LGVqUCcxeizlN+cHtO5FbjEj8eTT3PzhKxPkqKSpuxF2+zx5pRtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9qEwIvw+5gjiMSwT2zc8t9hZd6d4IuGU8+n3NghsKw=;
 b=Es6NFhMBH5j2qfxHJoEB38UQ+737u3vVJYsBz3ODi0/YAi8ygie5ohK2SjBzkWl7JaoGZ5KkYwHBufcbQmDY6Txhi3BfCbVEb65VYzTeTvjmvCzX4PTGCpOQ2UseFGCI0w0D5GHaFSDNfk8rlStlSmuGqg2VtaWWD2DWuLUPDWU=
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by DU2PR04MB9180.eurprd04.prod.outlook.com (2603:10a6:10:2f7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.29; Tue, 28 Mar
 2023 01:48:20 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::7570:a694:21d6:f510]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::7570:a694:21d6:f510%4]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 01:48:20 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Amit Cohen <amcohen@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net-next v2 8/8] net: fec: Indicate EEE (LPI) support for
 some FEC Ethernet controllers
Thread-Topic: [PATCH net-next v2 8/8] net: fec: Indicate EEE (LPI) support for
 some FEC Ethernet controllers
Thread-Index: AQHZYLeTmfQrKYLR6EeEdbCLjgH2T68PbPOg
Date:   Tue, 28 Mar 2023 01:48:19 +0000
Message-ID: <AM5PR04MB313931611AE76814BAE5AFE188889@AM5PR04MB3139.eurprd04.prod.outlook.com>
References: <20230327142202.3754446-1-o.rempel@pengutronix.de>
 <20230327142202.3754446-9-o.rempel@pengutronix.de>
In-Reply-To: <20230327142202.3754446-9-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM5PR04MB3139:EE_|DU2PR04MB9180:EE_
x-ms-office365-filtering-correlation-id: d1dc4f48-5d20-4ab1-59b8-08db2f2e81fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PqqnzLdqOmoftd6gULX3LllSvD2Xb8BfNy+ISNhZpPQUtlSTcvZdtcT3wkCwNZkDd3a1y0hLsNaIAkE5S+jeaay1USRmAmUG7Dbj1RLqA0K45TYWbx1lmm1GBxxvUjfwjkJ0ToTBj/w/w/LdmawDnljkKSIZhPo2v/tYkWXO27ml6k7dz717ZWmg7be4Xo2eGkVSl4uJ4hUbeJaJ6mpszUUhhyUrVTSBZLq17q8kiMq0Ko3GsS6xNTxuNBWyfUJtAp69utTryXkvAFQDVg/dyFNDwWF4DH1+H3HkrJYwHd7KzJGlJWKk0nEehgPB4sS1bqWl3sgZeIU0MA58rEiRJbpaTvRVz5d0ys/MYt561UtCXLxWLsQ+ATI161q+YpKJBnjke597uOPNLNDEAAkNi+8agRjhSR99j5QhaQ+y7ORJbCt0/1cucwKfBzmgBIy8tPL4XKsKczlrTh3X5dXZNc/VKcZDqdd+d7RvQxq3qS07pzytZSgc7PddRa97spMfXxid3t6idTQzt9IKYPH8HJwpFA/bVCdb4+qZUTnbej7x4uJuBUUco7EhhP4ArqYMyRggNufcX4oLS7kBpiLZDIcEvzEl2uyLAwVjwUNTQYS+3SkmwXORzkJZqCeWj1wQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199021)(83380400001)(8676002)(66946007)(66556008)(64756008)(76116006)(2906002)(66476007)(4326008)(66446008)(54906003)(71200400001)(478600001)(7696005)(9686003)(316002)(186003)(110136005)(26005)(38070700005)(53546011)(7416002)(55016003)(6506007)(44832011)(86362001)(52536014)(41300700001)(8936002)(38100700002)(122000001)(33656002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Y20rck5nWHJZRFhqNzFNYVYyTFpnMzhrZEd6K0c0VlRpRGhFUWhuNGtnUVk4?=
 =?gb2312?B?VnoyOW15cmRhYmZXSnMyNG9vcVA3am1YUVhtaGd5NHJsTmF5aXdEWi8vMXp5?=
 =?gb2312?B?cmh2VTlJNDl3WmNvbnRYR1JWOGVkcUxHQjN6QjlRanNndDY2YlFvWjdkaGFK?=
 =?gb2312?B?YjUwQnlTTFNRdnd3cXpBR1JET25DdVZncUhkRlBNRU9MeFFDK0FsSCtGa2tV?=
 =?gb2312?B?Z2xvRzhkYzV6cCs0NjhHempobFZIaFI2VWNNOW4vU3NtVG9CRm44RGRwN1Ju?=
 =?gb2312?B?eWdzZ3Y2WFZTb2JWbTAwVkV3SjAxRU9DeVluRk1zOW1nUlFWcmhRbGxwTFBT?=
 =?gb2312?B?V3VSb1FZYnk1RGUvZGM0cWZ6RkhCM3hWNlF5OHdDNDRCWm0yRnlyNEk3USt0?=
 =?gb2312?B?dWJoWDJLU2M3S0tZWmpOY2FtN3J4TnZvUkF4cXViSkdXemFSWFFSbHhob3k4?=
 =?gb2312?B?Vjk4bEVTeC9EOWJaeGc1VmluYzg1Zk5PM3NjYnpEWmZRaUsrSzdzVllZU1BZ?=
 =?gb2312?B?c2ttRElrY015QVUwQ1Y0UEFLZURqbmN1MncwUzRjNzRGTlFVNHVQRkhHVFZ4?=
 =?gb2312?B?SmwyYXN5MFpCMDMyVGY1aFU0a1lJckFXWGlOMGR1NDJmZWNYa1hkWEFibTJx?=
 =?gb2312?B?NXFIM2JHM01xY0dhV3ZzcThpbEUzcXRZeUt0MmhoZThTMHRBNlVjaHVVUmk2?=
 =?gb2312?B?RHJsUkwrcDlKSG9MNXI4UE81dVJKY2Raak9oSEpjYmwyN1RGcm14QUk5QW03?=
 =?gb2312?B?WU04OFl0cCtLRFpJd1pBTXgyYXRoZDJkSDIvcDhrS21jUzExWmtkSmRYcGtC?=
 =?gb2312?B?dDgzQU9DZUY3andNY2lLU2YzdmFpME5BdnB3Z0dsaGttWDFPcFJEa3pzZDVU?=
 =?gb2312?B?cktITkZpVXhRdEZEcXpzczU2NUVwM3hkK1I0UWlkbFJaWCsrTHRjcStWeXF4?=
 =?gb2312?B?Y282MjFGZjhxZHJKOEY3dU9peDFaL0h5YURWOUF2cU9pWHhNN05CT3A5c1Fk?=
 =?gb2312?B?MmJwbGlSNUtEY1ZsLy94enArQ1EvV3VaMmxjRnRYekNBcDhOeGd1K3FValpG?=
 =?gb2312?B?eTZZS2lHakdxdVJ2VWJjK2NPaGQ4OGxiTHRPMWpzMDNxenoxSjdYaEFZMVg3?=
 =?gb2312?B?cHE0WHBBOUJaWHBpblVHWGZCa1dwaHJwRVlyL1hrcEUyMnJyTmg3dWlNMGVk?=
 =?gb2312?B?aW5mMW05a3NjUXZ1RHJQVXZKMk1Vam5rbXcwWHFXZFBiL2JSQ3FKdndDeEQx?=
 =?gb2312?B?TWt2NmRyRWRPQ09EQndCd25WbWVsNFpyZkdZUTJkc3FGSWRZeHRGeEVFM0pq?=
 =?gb2312?B?SUxoa1JDU21acGJPRHZZNDI4UVNFQUFVaWxjY3UyTUVDeWduQktlLzNHQXFa?=
 =?gb2312?B?Y1F1Wk1vNllsTGdrakI4RTNSM2RXMWdoYnFrbnRxeHc1NFVBT29mQTZ0YlhP?=
 =?gb2312?B?YXNYMEl5d0hxVXV2YitxQ3BGa3E5TWxUblB5ZmxqbmQ1VktjY1FIcjFOMjkr?=
 =?gb2312?B?eDNVREQybmhlbnExZ0U3TU5UTWNOMG9oUzlFdTAzQjg2M1VKZlU3c3djY2hh?=
 =?gb2312?B?T0RCb2hWRTRxVHBZUTM3TSt6SnhibmJmU1J5ZEFGMWN4RlpoY1dFd1liNXBW?=
 =?gb2312?B?cU5ZRjV2eWJZdVZROC8zZ09hNzZOVXRhVElJMldPZmVpOGFnWGc4VFB4emZw?=
 =?gb2312?B?VGxyRlVib0pzeWVVb1hoYnd3VFRWbVNHNkI0emYrMEc2ZWx5c2ZiTnFERDh2?=
 =?gb2312?B?T3lQdzdEMFBrTm9haHFoSkIxRWZVTTg1MjhGcnJIQlBDTmQ5cnBpOGJENFdt?=
 =?gb2312?B?TWRqWURyRUtjaHJ0WDRzUXZ0NmdMMDgxbnNmN1hJSUk0b1JXRFNnZUNkemtZ?=
 =?gb2312?B?L0E1eTBMTjdienAxcHR0OXg3SlB5dksxOVdLZFp1cTlFWUMyeFQvOTQ0cEtk?=
 =?gb2312?B?SENGQzEvSGRuM0xWTTNiVUFnOGlzMTBaMno3bk85RUNsaTNnZTJhN2pIMU5S?=
 =?gb2312?B?Qm8rSk5aakNWekVkb3h4WGV3bS8yL1JJSXdpZ1lTK0U3MWE1b2ZCb2dPTHd1?=
 =?gb2312?B?Q2poQ1FaNENlbG83OTBCNmRUVlgrM2RnQ1Z3V2ZDdUtOYURoYWVlWFhXbFg0?=
 =?gb2312?Q?pYMw=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1dc4f48-5d20-4ab1-59b8-08db2f2e81fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 01:48:19.8442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: faQ+jspiORpqHeswa9PseUK5McVXn3bx0AhpXno7xijKNFYzsoGrM+1pNohGIw3hzxhb6ZfTWwV0S5fFh8jCRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9180
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBPbGVrc2lqIFJlbXBlbCA8by5y
ZW1wZWxAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjPE6jPUwjI3yNUgMjI6MjINCj4gVG86
IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZl
bWxvZnQubmV0PjsNCj4gRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFrdWIg
S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47DQo+IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0
LmNvbT47IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IEhlaW5lcg0KPiBLYWxsd2VpdCA8
aGthbGx3ZWl0MUBnbWFpbC5jb20+OyBSdXNzZWxsIEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9yZy51
az4NCj4gQ2M6IE9sZWtzaWogUmVtcGVsIDxvLnJlbXBlbEBwZW5ndXRyb25peC5kZT47IGtlcm5l
bEBwZW5ndXRyb25peC5kZTsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgU2hlbndlaSBXYW5nDQo+IDxzaGVud2VpLndhbmdAbnhwLmNvbT47
IENsYXJrIFdhbmcgPHhpYW9uaW5nLndhbmdAbnhwLmNvbT47DQo+IGRsLWxpbnV4LWlteCA8bGlu
dXgtaW14QG54cC5jb20+OyBBbWl0IENvaGVuIDxhbWNvaGVuQG52aWRpYS5jb20+OyBHYWwNCj4g
UHJlc3NtYW4gPGdhbEBudmlkaWEuY29tPjsgQWxleGFuZHJ1IFRhY2hpY2kNCj4gPGFsZXhhbmRy
dS50YWNoaWNpQGFuYWxvZy5jb20+OyBQaWVyZ2lvcmdpbyBCZXJ1dG8NCj4gPHBpZXJnaW9yZ2lv
LmJlcnV0b0BnbWFpbC5jb20+OyBXaWxsZW0gZGUgQnJ1aWpuIDx3aWxsZW1iQGdvb2dsZS5jb20+
Ow0KPiBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPg0KPiBTdWJqZWN0
OiBbUEFUQ0ggbmV0LW5leHQgdjIgOC84XSBuZXQ6IGZlYzogSW5kaWNhdGUgRUVFIChMUEkpIHN1
cHBvcnQgZm9yIHNvbWUNCj4gRkVDIEV0aGVybmV0IGNvbnRyb2xsZXJzDQo+IA0KPiBUaGlzIGNv
bW1pdCBhZGRzIEVFRSAoTFBJKSBzdXBwb3J0IGluZGljYXRpb24gZm9yIHNwZWNpZmljIEZFQyBF
dGhlcm5ldA0KPiBjb250cm9sbGVycy4gQnkgaW5kaWNhdGluZyBFRUUgc3VwcG9ydCBmb3IgdGhl
c2UgY29udHJvbGxlcnMsIGl0IGFsbG93cyBQSFkNCj4gZHJpdmVycyB0byBjaG9vc2UgdGhlIHJp
Z2h0IGNvbmZpZ3VyYXRpb24gZm9yIEVFRSBhbmQgTFBJIGZlYXR1cmVzLCBkZXBlbmRpbmcNCj4g
b24gd2hldGhlciB0aGUgTUFDIG9yIHRoZSBQSFkgaXMgcmVzcG9uc2libGUgZm9yIGhhbmRsaW5n
IHRoZW0uDQo+IA0KPiBUaGlzIGNoYW5nZSBwcm92aWRlcyBtb3JlIGZsZXhpYmlsaXR5IGFuZCBj
b250cm9sIG92ZXIgZW5lcmd5LXNhdmluZyBmZWF0dXJlcywNCj4gZW5hYmxpbmcgUEhZIGRyaXZl
cnMgdG8gZGlzYWJsZSBTbWFydEVFRSBmdW5jdGlvbmFsaXR5IGluIGZhdm9yIG9mIE1BQyBFRUUN
Cj4gc3VwcG9ydCB3aGVuIGFwcHJvcHJpYXRlLCBkZXBlbmRpbmcgb24gdGhlaXIgc3BlY2lmaWMg
dXNlIGNhc2VzIGFuZA0KPiByZXF1aXJlbWVudHMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBPbGVr
c2lqIFJlbXBlbCA8by5yZW1wZWxAcGVuZ3V0cm9uaXguZGU+DQoNClJldmlld2VkLWJ5OiBXZWkg
RmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4NCg==
