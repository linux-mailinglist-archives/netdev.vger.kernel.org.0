Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBABE60B6D2
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbiJXTLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiJXTK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:10:57 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2070a.outbound.protection.outlook.com [IPv6:2a01:111:f403:7010::70a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C1F1D0DE;
        Mon, 24 Oct 2022 10:49:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvcsHGxIOdJYsdu9RB30cq4U59XtUi9IjZ1YP7+JS20k6xRNzyRPqM+F5xLOg/ooAvgVMiitqeYkvFRwXR2CC2sk/ZiRMGzcuwF+s6fYUaooPSLbeOFQSkGn1q3nYmETULEwQqxJs+vEov3npkbEV0YyL6OjJyFCCZt0v8H02c85ZjX7KauK2tQemhDxFgLyOwHzJTeRfbmnIwOBxU0wqmlhjtRSiQyuWxqtcBkdC0RRc8/UggluiQXmJ/60/fDdE+zqFW6UwVr/pASzmwna6H9f+Z8IUCiq9kugZJWuQOY2TiuthheMpVHHFfybTUTwzckBFVy5HYkzHyE+lmNXHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFqfUU05Njl4MYXwW/tRE5l+nIgTsSeN4cViCxRXZpM=;
 b=gx161wjjopZ3d+PbgWsZz+7rp/yyjMLwyOjiud/lRiFDL0qLfPDZm+bzj5w4lsW5X2lz4Zt9M4LWyQKxPbtYhLMohjvF+7cdD0Yf9KwMs0TOxDXKGa2I2NxMUGRUr1Pip99OWA6i2ysl5jGgSsemdZUU17cLqQ/OF1Yzu5+s8Eo/4+1o/9MbWXwHeZif614wl45Hf+NowTJOxdfjMxp1R3nVNy+MOlAcZUBoqPtAjSjmjIszYBpF6aCbRef6LU67N/Q8xgC8ZkUbMLidVkBCrvAkcEieVwrJSL6oL9W/rnYVZdFRvZrLRlP2hGMX3lm1a7nYJNCSA/QGMS8jQcAvSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFqfUU05Njl4MYXwW/tRE5l+nIgTsSeN4cViCxRXZpM=;
 b=AsBoGIWU0K0uWzkhBnj2V1E8RYMAtyAWRJ+RPMDUpeNfwqxF22s6isJDbAB/YeUAq4Y1iRZfDMlS/UNQXHQRHoqAm1jxDiUTAlJuQb8ML+j1SJO4HEBo8c2YC/j/DQuc7dgR1nuFxpBrKJo7IzksOjKJqTejNhchuENvlWnP5rY=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYWPR01MB10709.jpnprd01.prod.outlook.com (2603:1096:400:2a5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 14:21:22 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f%7]) with mapi id 15.20.5746.028; Mon, 24 Oct 2022
 14:21:22 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <stefan.maetje@esd.eu>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Herring <robh@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 0/3] R-Car CANFD fixes
Thread-Topic: [PATCH 0/3] R-Car CANFD fixes
Thread-Index: AQHY5fEGwQJzFVL18EapyRdRl58K164dmqyAgAAA/IA=
Date:   Mon, 24 Oct 2022 14:21:22 +0000
Message-ID: <OS0PR01MB59223010090B51B907B6BC5B862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
 <20221024141659.62rtawuce7mczbt2@pengutronix.de>
In-Reply-To: <20221024141659.62rtawuce7mczbt2@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYWPR01MB10709:EE_
x-ms-office365-filtering-correlation-id: 9c97077e-d67a-4f05-c673-08dab5cb06a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Oq/IZfjAlZIoVmkrpbtg9g/GQ3nriViVRobLZPsa074Mrop12v07X0nHYnkEV7tk4n4TArFTq2Br0f8PD99ADDyzrahZAbb46w61zvwHVcOKceD3TETiDJiX8swg0Yq2N7Op0P6lb2R86lHz3HayfvokHh+1whoJEmWqW2VbBeuWER/Qv7Xf5YMKw5GFq7I2QxnsF9HqoAclEWurj1aQ1LvmvEgCjhId35gRF4sKOkKjtKiYeT1MRgpt+Aeyym88oIH6dYZi/cTieDX8G/XA8FXm+1fyDAjYqNly3RkE98p5yDXt58fRfKtY2rD3kg5jrpBEzoeEjbC4RsT8lAXMMrLJBoKRSneU0Cwt/33LTj5zf7QN6B52O/LZucCfQT36qZWU1Z6oSTdFKo3VGZYXHLbHzICDnvoV/TMuK/vKPatgl/RVlz6/RTu1N7+HIxBp6SYswhUrFBr308dpKxWVf2ofbgw7Xlv4J3bEcUZwIDYl+kS7Nfvv+sBpaMwQBcs9JkIupW2o2imdQdkNpzbf1pHioIGaQjaHmJezK5JVg0L7zvGj/FeU/eOF39tnPdhEnygx3xCaDeIQqUmivWbPrGd7DQVlNBLKhwp9T2B1dc2YXcWf3qggGES6wSOg0bcOsuAy6XLte8xA0QXsLGIzKlPHrYe1UTq9uWpLQ9EiB7lajHiGgGqfRaWo9qhVH82KTxZTjOi5pqfpW3vf2HvfEoOh3FLRPNJkFbtDCI3lxBdsIsc9tYntxqyKUdBomIyGeeIevbq8wRlDBQ7UUBU++g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199015)(41300700001)(7416002)(26005)(8936002)(52536014)(6916009)(5660300002)(66946007)(66556008)(66446008)(54906003)(76116006)(64756008)(53546011)(8676002)(6506007)(4326008)(9686003)(7696005)(66476007)(38070700005)(316002)(122000001)(38100700002)(4744005)(186003)(55016003)(33656002)(2906002)(86362001)(71200400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVJrRjZmbXNWc1ZsV0NuajU5TFB2L3phbHRWRms3TGFlK1JJU2lRNU9xU01o?=
 =?utf-8?B?dUVKc2hmSXJQS29CcktnOHo4U2VYOWJYNzNoMk9zNit1aFhXOXNuNEVNalZW?=
 =?utf-8?B?eTdNSHlSclpFYmdwN1FYVG1adWMwa1U0K3ZWalJmVjFNUmN5eVc0TlFYWW01?=
 =?utf-8?B?Z2RaNFpjNVZ1djcvZDhBK1RqNDlXVEl6YlhUUys1eVJPcUlLSHpWaWNRcnN0?=
 =?utf-8?B?b3prb3ZneGlHWmNCWjByRVZhSE1qQjZRbWFuRjlNY3RlOVc4Z2tOVFFQSmRB?=
 =?utf-8?B?eEtEU0F1ME01cEVPVmc5dkxKTlRZNWRmSXU2OTdYa1ZVTDJleTFRWks0VFRu?=
 =?utf-8?B?V3R5WUNOVUZaRFozam1jWU5pS3d0RnlLc01UcDhMQ2VuK21NcTl0T1dsR3NS?=
 =?utf-8?B?Y0lKRWdja1pYSGJ2Tlkxcm9zL09XbFAyOHpwK2xQY2ZBSXlaOUQzVnZEcXhz?=
 =?utf-8?B?SFJMZ3JVVDRHbTQ3cGdpWHVFeis3V1I4UlJPZy9vWmNaM3dMZFFSV2lnSnFB?=
 =?utf-8?B?YW1pa21IdlN0Q1hpZnBGZmU0YXFrRWtJQURoYlBESm5OQ1BmQk4zTVg3Rk5G?=
 =?utf-8?B?dXEyWVNxWnFIcTNHRkwreGZ5UFpkKy9na1REVmlacnd0a0licktaanNaNzRB?=
 =?utf-8?B?ckVrdlA2WWpYQnRNajJ4aktyYkttRmJjS21GSFFkQVNFb1FBRkI0S3BKNVVq?=
 =?utf-8?B?MzNOQ1lpL3lZa0h2ZUFVbytGQjZHRm1qS0M5SklWcFJOeFY3SU92SU1wNm1i?=
 =?utf-8?B?STJFakFLNnVRRWZVM1NBcVdScVprNW50VGJOdGc4Um5CVXdlUGtJdGRwakxa?=
 =?utf-8?B?YTdFeWV4dWJlaGowbHdTdFU1OVpZMnF2eWFCQW9PVmh3b0V5ZHkxOW9CbFVO?=
 =?utf-8?B?bUxGKzRhdmVyRG1UZjBVSGJNNWFaM0NpeWlhWTJNNTRnWStRZE81VW5XK0po?=
 =?utf-8?B?RFFuMi9lYm94aWgwNDlWNXJIempxay9Oa2d6MUpsN0JPNHpBNHdIMHlXMzlF?=
 =?utf-8?B?MEY5a2ZtcGtEUUdkb0F6dTIxUEF1aVVnanpCR3VHbkNxc2NOa1FjdEhNN21J?=
 =?utf-8?B?enY0OFRNT29ra2pYdkFsdW1VWkcyYWFVaDlwYjVNV2RxQ2lTd2pqRW5RUW53?=
 =?utf-8?B?cWw3TjY4NWZMeHVKdERrdzZ0Q2tVcWFzNEcvWndGZmN3ckhxQ0tPL0wxVkF3?=
 =?utf-8?B?OE1nWWJlOVF3MGdqTUk5eHNSM01DdlFNYTVXWGdKUlRkMkVDNmk4ZS9VZjU1?=
 =?utf-8?B?Rm9uRDJJV1RWdzNLQ3h3dUsrS0I1YkNmeitIK0hib0dwWHkyc1BGQVJiQ3ZB?=
 =?utf-8?B?c2ZFNWpKMmY1S2JKYXVkdEp4MGpBbklMOS9zRUVNRUdoL3F1aElNVFF1L1Vp?=
 =?utf-8?B?M1ZVclVueENFQnkvUUZXUTVxWGtYU1hMMHVwamR5cFVkd0JYaWh6cDA0eFA1?=
 =?utf-8?B?NnM4cmFXY2hmZjNRTVFqY2c1R1FhUzdZZ1JLNGM2ZUdVTkRtSytpMHBYdnI3?=
 =?utf-8?B?OU9WdlRDdEVJcTFYZVd0eGx2QTJnalRMWDJ3UEQyQjRKKzQxc1ZRVzJPN2pl?=
 =?utf-8?B?c2ovcU5LNUx2NFp4VVVaRkIzcStIKyt4RmQwVjA4SEdQUVVTRzl1UTZJOENq?=
 =?utf-8?B?cy95VHVNcFltSDQrbXRDMEpJWXRyc2lBRWxzLzZEemVVVzZOR0JQU1g5alF2?=
 =?utf-8?B?SERpaUUyMXNqcE5sNDgzUk45cVZCL3lPbnpKTWJkekgvMkFCQnRha2tXei90?=
 =?utf-8?B?S1JCanRES1BSVkNGZ3MwOE16NmZZVjFuTFFBOW5yWmtLakJjaEE3K0NSa0pT?=
 =?utf-8?B?b045clpWb0xVek85RHhRaEE5UEtETmxSYUY4T1pIeG5URlRUcmM0WDJ3Q2wx?=
 =?utf-8?B?MXhiK0RqRTZpWWN3L0RCRjFBckJ6Z1NvbmwvRmdQWElCZjkxS3RwVm91bnRn?=
 =?utf-8?B?akIxV1BHdHYxa3FrNHB2aG90K2VFZkpvOXhGWitvRFlzbGNteisrMzczczJn?=
 =?utf-8?B?T3V0cm0ybHRORlZqTFRvdm5sbXBvM0QxamhONm16RHdzSlRJK1Y0YjVXMUVF?=
 =?utf-8?B?eCtGU0l2a0ZVNXlocWdMOWw4d3I5RS9XbjZ0S0FJU2hDMkVEblpEenpaRFVF?=
 =?utf-8?B?c1dFOG02ZEVRa0ZYZ1dWZXp4MVczblRiNVRLSndBaDZkTEF5YVoyYjRjTks4?=
 =?utf-8?B?dHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c97077e-d67a-4f05-c673-08dab5cb06a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 14:21:22.0681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5j98zjurdXVjq9mY387rYbcCZLOa7n6tcu/MFX65H9dSs4wgGvHl9HAiR9bKNYSVUsRAw8aKbVAUltlpAfV8vlXXzhegaSaAzHIMLa/2qm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10709
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDAvM10gUi1DYXIgQ0FORkQgZml4ZXMN
Cj4gDQo+IE9uIDIyLjEwLjIwMjIgMDk6MTU6MDAsIEJpanUgRGFzIHdyb3RlOg0KPiA+IFRoaXMg
cGF0Y2ggc2VyaWVzIGZpeGVzIHRoZSBiZWxvdyBpc3N1ZXMgaW4gUi1DYXIgQ0FOIEZEIGRyaXZl
ci4NCj4gPg0KPiA+ICAxKSBSYWNlIGNvbmRpdGlvbiBpbiBDQU4gZHJpdmVyIHVuZGVyIGhlYXZ5
IENBTiBsb2FkIGNvbmRpdGlvbg0KPiA+ICAgICB3aXRoIGJvdGggY2hhbm5lbHMgZW5hYmxlZCBy
ZXN1bHRzIGluIElSUSBzdG9tIG9uIGdsb2JhbCBmaWZvDQo+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5eXl4gdHlwbw0KPiA+ICAgICByZWNlaXZlIGly
cSBsaW5lLg0KPiA+ICAyKSBBZGQgY2hhbm5lbCBzcGVjaWZpYyB0eCBpbnRlcnJ1cHRzIGhhbmRs
aW5nIGZvciBSWi9HMkwgU29DIGFzIGl0IGhhcw0KPiA+ICAgICBzZXBhcmF0ZSBJUlEgbGluZXMg
Zm9yIGVhY2ggdHguDQo+ID4gIDMpIFJlbW92ZSB1bm5lY2Vzc2FyeSBTb0Mgc3BlY2lmaWMgY2hl
Y2tzIGluIHByb2JlLg0KPiANCj4gRml4ZWQgdHlwbyB3aGlsZSBhcHBseWluZy4NCg0KVGhhbmtz
IGZvciBmaXhpbmcgdGhlIHR5cG8uDQoNCkNoZWVycywNCkJpanUNCg==
