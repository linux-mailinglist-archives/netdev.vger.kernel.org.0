Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09CA58F59F
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 03:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiHKBtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 21:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiHKBtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 21:49:01 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140079.outbound.protection.outlook.com [40.107.14.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EBB7C767
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 18:48:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZINWsdeiWm838dls0Dep0jGobojosJBGmjLNUoKGlva9rVmp200VDg6DNuU5aqCt4QSySYk50dYew+1wuj0zfEHv3WHPLqqtkBzq4y7oOejf3setMknLDkuBggn7Gd/xeB5bpqMSXKcaFIzFksBZB7Zx9A18cDypzY2Siq+XsvbIh/5p4pXts7XJP0/ChhD9PBCQqVbxSRCsHKCDtBsrgpaj51pAXL4sLxd5c2mY90A3zy1dv3c1iCZv6hJWG5Z0anILCZEP0rBfydjpk1JWVCg6ticagJZ6i/qpUyeIYJgDQa62ZTaxCpFIVKZSQicS5j4E6GjrirrEIjvakzLlIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hT1CpOp0oIh6YjEN+44qBgaHIq0PUAMnv1SAp6rJ/Hc=;
 b=XfHkf7I4sPdgwEfpCbJiPwcPwDC/i6nRKyEDznXK5dCWWG/AMV3skoZ9csgbt5gQe62SAup2zLWxtyQNIyGFNzaXWKtxTbACf/Rb6KBjoqCxzP6UzVyKRgCLMZpBtOAXVAGirnY7Qfe/0SsZIBLmRca/3SyE1wKjIRMfTOEaB9+0UlJ/BZIqhZZKBk+WNt+h3pUJng3k1WdIlG9Oz1VmaajBlmddN4LMJ94LRQTKKuueVgrdlEdODfLfuuiXrz4VQvc0VaXjeA0BDKx7XQddeSGyglsg3ehqH+sIXr3OlL8VddBL8LhQrQwTyZgNPZntgpXtxSCADyam8iPCXpEdPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hT1CpOp0oIh6YjEN+44qBgaHIq0PUAMnv1SAp6rJ/Hc=;
 b=PmS1yn0UpT0A4SlkF8bs+/hC1sAhh0WVW7IORxDZiUaWI7cYOiwl6UK4QRY+Ot7CK6UedVN9wYMrvkBMDlM0UtHUYlv3ak6C1Iabl2GVb+R56MT1z48rcDme3V5suHRo69AZCGQvw967Uak9HWmSjkgTuwN873eKMJkha0rqGmY=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM7PR04MB6822.eurprd04.prod.outlook.com (2603:10a6:20b:108::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.23; Thu, 11 Aug
 2022 01:48:56 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Thu, 11 Aug 2022
 01:48:56 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Clark Wang <xiaoning.wang@nxp.com>
Subject: RE: [PATCH net-next] net: phy: realtek: add support for
 RTL8821F(D)(I)-VD-CG
Thread-Topic: [PATCH net-next] net: phy: realtek: add support for
 RTL8821F(D)(I)-VD-CG
Thread-Index: AQHYrJ2pZTR9F75p40+SQcCj0/P9y62ojNqAgABehGA=
Date:   Thu, 11 Aug 2022 01:48:56 +0000
Message-ID: <DB9PR04MB81062AB20D311BEAEE0514DA88649@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220810173733.795897-1-wei.fang@nxp.com>
 <910fdffd-53b5-8b9a-1ba5-496ddddb9230@gmail.com>
In-Reply-To: <910fdffd-53b5-8b9a-1ba5-496ddddb9230@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bae09bc2-8967-4f4d-248f-08da7b3ba725
x-ms-traffictypediagnostic: AM7PR04MB6822:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pkkBYq4wLbGk7Lkes1b4WFuBILuEjEGgSZboK3luLmXti1SJX/L+NwDeShT3XIVxwciJ4/RKuDdEozbTYkziLkY7zwonD7PGAhKW7hmqpcF8HvJyRzDyd3WgKgfA6Q354n+uJoz6IQdmIe3G9CiDxOegyjwm07IYuTyzW21FYn+sGHaqOnDSWLw+2z3Re6sgzTYYtZUSC512dECEwSBkHn7vosB6A8BrhygyEWISajlJOx6nnv3kcuYdcgCDIH75OZy3VNP5UxKelwWDY7zatP+2ebSnAg+hrIM3C9gOYvddzsnVddScXt6VhZmJyHH9QZg4KzO+u+Trpvc9gjmaQ2qrL/quMWmQt/oyBqM8Jofbh628mz5rDq8QvQy8l8ZGfb02o8UrXEyNdLsR38+dHXfWrVCJg8B8KTWkgtW6G8cOLpRu1PpTUXgVwWOr1Ag1BgRB5UPua0sOyTiuYv4BIaKrJ8z9ZJ9K+rzQj4eb4PjKePi0fE193YdGrwHR1o4M66lKF0k30Wspv3OGe/RBHHeiZ62L7Ovp6KAj8l7Bo5iv1LZkBaHwmgVwxK7Me6vZaUtVIEtIG76sWqjDbfAotJnMEa7+shPonK9pBqndqHyVAw5tNiM6hOkWS+Wi4QbdTASoIkIJjMIx1rGTuUqVGLv5TgEBbZkxsP/dm2wQJVdieKbMrNV8i6XSBDYnIV1q4toSGvHY+XAJ8tMAjrp1CC0VmaKkVAEH9bn4regXu2yrQ3ta6t9k43CdA0hRdKKUu+dScVYxvgdrkyT6j+2J0k3r6+mRMo54XOcbdUcvKgk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(83380400001)(55016003)(316002)(8676002)(4326008)(33656002)(110136005)(76116006)(66946007)(66476007)(66446008)(64756008)(186003)(66556008)(41300700001)(2906002)(9686003)(478600001)(7696005)(53546011)(6506007)(26005)(86362001)(122000001)(38070700005)(44832011)(8936002)(38100700002)(52536014)(5660300002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YWdXL2lqWVdtQmFTdDR3ZldEYUdpYml3S0dyazVrTTNtbytzeWM4cE4xYmd6?=
 =?utf-8?B?RlliSE1HL1FpUVdXSWNxK3BzazVlelQ0NWlrTnhyV2pLanAxUlhCOGxIZ1Jr?=
 =?utf-8?B?NFIzNkJzMDlnRXdFL05RRDV3VmVzQ1JCSjBQVUltSzBpWFlNUmJhT0ZkYU9z?=
 =?utf-8?B?Rys0RG9yWlNQaS9TOGNnWEgrd2RGV2toZ1N1Vk9Zb2g5ZDA1YlFaWDFYbWVP?=
 =?utf-8?B?WmkxSlBlblFvOGJPTEUwSWZqUlZBNWZRTTlMNThGTXRXRVlqR256ZXBNWVFG?=
 =?utf-8?B?RXQ0dDRKUGJjVXQ5bjM5b2hkaVVzaWRMcEk5dUpFR0ROWFpsWmZjdHdlL0Ir?=
 =?utf-8?B?SjFaSStCMzlBLzUrTlJXdzZqTkIyNWxQTi94Z0JkbHRud1hrRkZpcUxERTcr?=
 =?utf-8?B?c05JL0MwVGIzYjU2R1kydHpHQUt2VzhYdjJzTnhvNWh2Yk9UT2dHaHVrWnhr?=
 =?utf-8?B?Z0hmTmFrSkw4Mk93aFRoVjFjcmErLzZRTkRUNEFxeHpOYm9tMTUxbHh5MlBB?=
 =?utf-8?B?R1MrdDh5MWw5WHhBcTN2SVpOY24zWHFQWFdiS0o2TVppSzgxckRqUHJxOEZ1?=
 =?utf-8?B?V2xGTjVvUDVwcmNjdFhFMWxWQ3RjS21ucTQ4OXhUZmhOajl5QllOa2w5Zk1y?=
 =?utf-8?B?Qm9KSks3V1lMS01OTnVMWXJVK0tsTUdzY2hncmFhTTdveGxqSUhMSE14THhB?=
 =?utf-8?B?M1VpcXZKWGJRdWIzTDlrNFFpMUFtV09zQW5aUlpveWZ4N2VUSXM2d3ZuZjVs?=
 =?utf-8?B?djFYZmt2OURCYXFpaHljbFZ6K2xBL1dsYncrUU1FUjhDczBDRWIxZFNKWnRx?=
 =?utf-8?B?RHR5TXM3czJjWElvVlI0MS9wYTRUSW9MVUJJUFpKK0g4TEFmcTQ2UDlqczhE?=
 =?utf-8?B?VWswOW41V3B5dkhiUCtobXVwbGswTUZCT0VySlZ0cHQ2Z2lRRzJsTmovaUUx?=
 =?utf-8?B?UlVuZk9DbmsxQ280cDZBY0tMNmE0a05qYWd2a1hFQktWbmxvYzVWb25pV3NM?=
 =?utf-8?B?Y0RkT1U0cFduY1VqUFNsTFVCVjhlZkJGMzdyYU0xTnJHclJqdFQ1WFluNzlp?=
 =?utf-8?B?VnRFUkU1c1dZYmtkNUVRRDBKbHdNendTUXpKSDU5Vko5MUdrd3NRTmFUL0dC?=
 =?utf-8?B?dEMrbVNFZDU4dkZKcU8rSmlFK1N6aHN2cGViT3czcnBtdFE2ajJ2OHJ5am0w?=
 =?utf-8?B?R2FhK29xMTlFUHVzam1LZ0EvRHdWZWdsOGlvZGw2NWY0dmpCejJjV2Q4UTF5?=
 =?utf-8?B?R0ZTMjFxWjFJd3VSQVV2T09Ick92cTdpMUFLdzErY2NjemdVb2RsakkyY2lu?=
 =?utf-8?B?aC95L0E4cTlBN3ZiaHI0bkNvV096b0NXbWIwQWpvdGhMbEdHSnY3Nzd4Q3hG?=
 =?utf-8?B?dHcyOVhpcjVteHlIN1lBb3lPR0U5VHB6Vk10NVdCVXVMeWRRYVptWjdvSm54?=
 =?utf-8?B?TWRuNlFWWG9ZaVNFcjFER3RXSmhHaitvT3o0eHVSekp0SGxWYW5nNnNQclJt?=
 =?utf-8?B?Y1NpZUFFMHpZbEFvY0tpNXJOUGhEMm4xbWw3RGRFQ3FoMTArOU1WdEsvK1Js?=
 =?utf-8?B?bktlS3VCY2tienNwbDVzbnRkY0RtRkJpOFloVUdlUjZvd1Mxc1F4RHBPdUZH?=
 =?utf-8?B?bE85QnJiTEVYdk1DcWsrU3FTSUk0VmMrcGdodVhVdFdESlprL29VZnVEMHU0?=
 =?utf-8?B?eXhFMGZ5NkdMcTdJelRtcFJxUXVWWHlmOXJuZkVkV1NFWGFkYzU0Wlg4TlJ0?=
 =?utf-8?B?RjcyYnJqejVqN1I5TnNJVXdzUXg5Zm5OSEZJbk02M0RjdVc1TVNMZlAvYmdM?=
 =?utf-8?B?S2ZEdUdKY3BybFU5eTY5azRwY3pNenVGQ2l6d2V0OE01T3FSdkprYnNwZmRa?=
 =?utf-8?B?VjJCcTRMQXg2OUIraXU0eTQ3ditYMGpIWmdGTUpGRUhSZVFya3gvZ2h1czRP?=
 =?utf-8?B?TFNlazc3bWgzOFgxTXhEMlQ2VmZ4NWNtSzN5L3BOSklOUWNXcXVqMndQRXpK?=
 =?utf-8?B?M3ovRzR2enZRMS9NbmF1NW1lYllZclZubU5CYTFrQzQzRUtLMTVLMDFxL1RP?=
 =?utf-8?B?dWwxQVVtVDF2M0hwZzV5RUlzeEJIbDBLYTVmUXRuMHE5RDJPcGhuWSszRmVF?=
 =?utf-8?Q?wZwA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bae09bc2-8967-4f4d-248f-08da7b3ba725
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 01:48:56.3248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WQFoAFpfTePAbHqoIx26JdIJ57A/SU5OcVgC57GFr5nddyNQS6QMOiUNB2zdIRWM+46AhYc2/nrDh1l3Dv9bTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6822
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGVpbmVyIEthbGx3ZWl0
IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMuW5tDjmnIgxMeaXpSAzOjU1DQo+
IFRvOiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT47IGFuZHJld0BsdW5uLmNoOyBsaW51eEBh
cm1saW51eC5vcmcudWs7DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5j
b207IGt1YmFAa2VybmVsLm9yZzsNCj4gcGFiZW5pQHJlZGhhdC5jb207IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmcNCj4gQ2M6IENsYXJrIFdhbmcgPHhpYW9uaW5nLndhbmdAbnhwLmNvbT4NCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dF0gbmV0OiBwaHk6IHJlYWx0ZWs6IGFkZCBzdXBwb3J0
IGZvcg0KPiBSVEw4ODIxRihEKShJKS1WRC1DRw0KPiANCj4gT24gMTAuMDguMjAyMiAxOTozNywg
d2VpLmZhbmdAbnhwLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBDbGFyayBXYW5nIDx4aWFvbmluZy53
YW5nQG54cC5jb20+DQo+ID4NCj4gPiBSVEw4ODIxRihEKShJKS1WRC1DRyBpcyB0aGUgcGluLXRv
LXBpbiB1cGdyYWRlIGNoaXAgZnJvbQ0KPiA+IFJUTDg4MjFGKEQpKEkpLUNHLg0KPiA+DQo+IA0K
PiBEb24ndCB5b3UgbWVhbiA4MjExIGluc3RlYWQgb2YgODgyMSBoZXJlPw0KPiANClNvcnJ5LCBJ
dOKAmXMgd3JpdHRlbiBlcnJvciwgSSdsbCBjb3JyZWN0IGl0IGluIG5leHQgdmVyc2lvbi4NCg0K
PiA+IEFkZCBuZXcgUEhZIElEIGZvciB0aGlzIGNoaXAuDQo+ID4gSXQgZG9lcyBub3Qgc3VwcG9y
dCBSVEw4MjExRl9QSFlDUjIgYW55bW9yZSwgc28gcmVtb3ZlIHRoZSB3L3INCj4gPiBvcGVyYXRp
b24gb2YgdGhpcyByZWdpc3Rlci4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IENsYXJrIFdhbmcg
PHhpYW9uaW5nLndhbmdAbnhwLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvcGh5L3Jl
YWx0ZWsuYyB8IDQ4DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0t
DQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAzNiBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkN
Cj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvcmVhbHRlay5jIGIvZHJpdmVy
cy9uZXQvcGh5L3JlYWx0ZWsuYw0KPiA+IGluZGV4IGE1NjcxYWI4OTZiMy4uYmZkZTIyZGM4NWY1
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9yZWFsdGVrLmMNCj4gPiArKysgYi9k
cml2ZXJzL25ldC9waHkvcmVhbHRlay5jDQo+ID4gQEAgLTcwLDYgKzcwLDcgQEANCj4gPiAgI2Rl
ZmluZSBSVExHRU5fU1BFRURfTUFTSwkJCTB4MDYzMA0KPiA+DQo+ID4gICNkZWZpbmUgUlRMX0dF
TkVSSUNfUEhZSUQJCQkweDAwMWNjODAwDQo+ID4gKyNkZWZpbmUgUlRMXzgyMTFGVkRfUEhZSUQJ
CQkweDAwMWNjODc4DQo+ID4NCj4gPiAgTU9EVUxFX0RFU0NSSVBUSU9OKCJSZWFsdGVrIFBIWSBk
cml2ZXIiKTsNCj4gTU9EVUxFX0FVVEhPUigiSm9obnNvbg0KPiA+IExldW5nIik7IEBAIC04MCw2
ICs4MSwxMSBAQCBzdHJ1Y3QgcnRsODIxeF9wcml2IHsNCj4gPiAgCXUxNiBwaHljcjI7DQo+ID4g
IH07DQo+ID4NCj4gPiArc3RhdGljIGJvb2wgaXNfcnRsODIxMWZ2ZCh1MzIgcGh5X2lkKQ0KPiAN
Cj4gQmV0dGVyIGFkZCBhIGhhc19waHljcjIgdG8gc3RydWN0IHJ0bDgyMXhfcHJpdi4gVGhlbiB5
b3UgaGF2ZToNCj4gDQo+IGlmIChwcml2LT5oYXNfcGh5Y3IyKQ0KPiAJZG9fc29tZXRoaW5nX3dp
dGgocHJpdi0+cGh5Y3IyKTsNCj4gDQoNClRoYW5rcyBmb3IgeW91ciBzdWdnZXN0aW9uLCBJIHdp
bGwgYXBwbHkgdGhpcyBtZXRob2QgaW4gbmV4dCB2ZXJzaW9uLg0KDQo+ID4gK3sNCj4gPiArCXJl
dHVybiBwaHlfaWQgPT0gUlRMXzgyMTFGVkRfUEhZSUQ7DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0
YXRpYyBpbnQgcnRsODIxeF9yZWFkX3BhZ2Uoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikgIHsN
Cj4gPiAgCXJldHVybiBfX3BoeV9yZWFkKHBoeWRldiwgUlRMODIxeF9QQUdFX1NFTEVDVCk7IEBA
IC05NCw2ICsxMDAsNw0KPiBAQA0KPiA+IHN0YXRpYyBpbnQgcnRsODIxeF9wcm9iZShzdHJ1Y3Qg
cGh5X2RldmljZSAqcGh5ZGV2KSAgew0KPiA+ICAJc3RydWN0IGRldmljZSAqZGV2ID0gJnBoeWRl
di0+bWRpby5kZXY7DQo+ID4gIAlzdHJ1Y3QgcnRsODIxeF9wcml2ICpwcml2Ow0KPiA+ICsJdTMy
IHBoeV9pZCA9IHBoeWRldi0+ZHJ2LT5waHlfaWQ7DQo+ID4gIAlpbnQgcmV0Ow0KPiA+DQo+ID4g
IAlwcml2ID0gZGV2bV9remFsbG9jKGRldiwgc2l6ZW9mKCpwcml2KSwgR0ZQX0tFUk5FTCk7IEBA
IC0xMDgsMTMNCj4gPiArMTE1LDE1IEBAIHN0YXRpYyBpbnQgcnRsODIxeF9wcm9iZShzdHJ1Y3Qg
cGh5X2RldmljZSAqcGh5ZGV2KQ0KPiA+ICAJaWYgKG9mX3Byb3BlcnR5X3JlYWRfYm9vbChkZXYt
Pm9mX25vZGUsICJyZWFsdGVrLGFsZHBzLWVuYWJsZSIpKQ0KPiA+ICAJCXByaXYtPnBoeWNyMSB8
PSBSVEw4MjExRl9BTERQU19QTExfT0ZGIHwNCj4gUlRMODIxMUZfQUxEUFNfRU5BQkxFIHwNCj4g
PiBSVEw4MjExRl9BTERQU19YVEFMX09GRjsNCj4gPg0KPiA+IC0JcmV0ID0gcGh5X3JlYWRfcGFn
ZWQocGh5ZGV2LCAweGE0MywgUlRMODIxMUZfUEhZQ1IyKTsNCj4gPiAtCWlmIChyZXQgPCAwKQ0K
PiA+IC0JCXJldHVybiByZXQ7DQo+ID4gKwlpZiAoIWlzX3J0bDgyMTFmdmQocGh5X2lkKSkgew0K
PiA+ICsJCXJldCA9IHBoeV9yZWFkX3BhZ2VkKHBoeWRldiwgMHhhNDMsIFJUTDgyMTFGX1BIWUNS
Mik7DQo+ID4gKwkJaWYgKHJldCA8IDApDQo+ID4gKwkJCXJldHVybiByZXQ7DQo+ID4NCj4gPiAt
CXByaXYtPnBoeWNyMiA9IHJldCAmIFJUTDgyMTFGX0NMS09VVF9FTjsNCj4gPiAtCWlmIChvZl9w
cm9wZXJ0eV9yZWFkX2Jvb2woZGV2LT5vZl9ub2RlLCAicmVhbHRlayxjbGtvdXQtZGlzYWJsZSIp
KQ0KPiA+IC0JCXByaXYtPnBoeWNyMiAmPSB+UlRMODIxMUZfQ0xLT1VUX0VOOw0KPiA+ICsJCXBy
aXYtPnBoeWNyMiA9IHJldCAmIFJUTDgyMTFGX0NMS09VVF9FTjsNCj4gPiArCQlpZiAob2ZfcHJv
cGVydHlfcmVhZF9ib29sKGRldi0+b2Zfbm9kZSwgInJlYWx0ZWssY2xrb3V0LWRpc2FibGUiKSkN
Cj4gPiArCQkJcHJpdi0+cGh5Y3IyICY9IH5SVEw4MjExRl9DTEtPVVRfRU47DQo+ID4gKwl9DQo+
ID4NCj4gPiAgCXBoeWRldi0+cHJpdiA9IHByaXY7DQo+ID4NCj4gPiBAQCAtMzMzLDYgKzM0Miw3
IEBAIHN0YXRpYyBpbnQgcnRsODIxMWZfY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2UNCj4g
PiAqcGh5ZGV2KSAgew0KPiA+ICAJc3RydWN0IHJ0bDgyMXhfcHJpdiAqcHJpdiA9IHBoeWRldi0+
cHJpdjsNCj4gPiAgCXN0cnVjdCBkZXZpY2UgKmRldiA9ICZwaHlkZXYtPm1kaW8uZGV2Ow0KPiA+
ICsJdTMyIHBoeV9pZCA9IHBoeWRldi0+ZHJ2LT5waHlfaWQ7DQo+ID4gIAl1MTYgdmFsX3R4ZGx5
LCB2YWxfcnhkbHk7DQo+ID4gIAlpbnQgcmV0Ow0KPiA+DQo+ID4gQEAgLTQwMCwxMiArNDEwLDE0
IEBAIHN0YXRpYyBpbnQgcnRsODIxMWZfY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2UNCj4g
KnBoeWRldikNCj4gPiAgCQkJdmFsX3J4ZGx5ID8gImVuYWJsZWQiIDogImRpc2FibGVkIik7DQo+
ID4gIAl9DQo+ID4NCj4gPiAtCXJldCA9IHBoeV9tb2RpZnlfcGFnZWQocGh5ZGV2LCAweGE0Mywg
UlRMODIxMUZfUEhZQ1IyLA0KPiA+IC0JCQkgICAgICAgUlRMODIxMUZfQ0xLT1VUX0VOLCBwcml2
LT5waHljcjIpOw0KPiA+IC0JaWYgKHJldCA8IDApIHsNCj4gPiAtCQlkZXZfZXJyKGRldiwgImNs
a291dCBjb25maWd1cmF0aW9uIGZhaWxlZDogJXBlXG4iLA0KPiA+IC0JCQlFUlJfUFRSKHJldCkp
Ow0KPiA+IC0JCXJldHVybiByZXQ7DQo+ID4gKwlpZiAoIWlzX3J0bDgyMTFmdmQocGh5X2lkKSkg
ew0KPiA+ICsJCXJldCA9IHBoeV9tb2RpZnlfcGFnZWQocGh5ZGV2LCAweGE0MywgUlRMODIxMUZf
UEhZQ1IyLA0KPiA+ICsJCQkJICAgICAgIFJUTDgyMTFGX0NMS09VVF9FTiwgcHJpdi0+cGh5Y3Iy
KTsNCj4gPiArCQlpZiAocmV0IDwgMCkgew0KPiA+ICsJCQlkZXZfZXJyKGRldiwgImNsa291dCBj
b25maWd1cmF0aW9uIGZhaWxlZDogJXBlXG4iLA0KPiA+ICsJCQkJRVJSX1BUUihyZXQpKTsNCj4g
PiArCQkJcmV0dXJuIHJldDsNCj4gPiArCQl9DQo+ID4gIAl9DQo+ID4NCj4gPiAgCXJldHVybiBn
ZW5waHlfc29mdF9yZXNldChwaHlkZXYpOw0KPiA+IEBAIC05MjMsNiArOTM1LDE4IEBAIHN0YXRp
YyBzdHJ1Y3QgcGh5X2RyaXZlciByZWFsdGVrX2RydnNbXSA9IHsNCj4gPiAgCQkucmVzdW1lCQk9
IHJ0bDgyMXhfcmVzdW1lLA0KPiA+ICAJCS5yZWFkX3BhZ2UJPSBydGw4MjF4X3JlYWRfcGFnZSwN
Cj4gPiAgCQkud3JpdGVfcGFnZQk9IHJ0bDgyMXhfd3JpdGVfcGFnZSwNCj4gPiArCX0sIHsNCj4g
PiArCQlQSFlfSURfTUFUQ0hfRVhBQ1QoUlRMXzgyMTFGVkRfUEhZSUQpLA0KPiA+ICsJCS5uYW1l
CQk9ICJSVEw4MjExRi1WRCBHaWdhYml0IEV0aGVybmV0IiwNCj4gPiArCQkucHJvYmUJCT0gcnRs
ODIxeF9wcm9iZSwNCj4gPiArCQkuY29uZmlnX2luaXQJPSAmcnRsODIxMWZfY29uZmlnX2luaXQs
DQo+ID4gKwkJLnJlYWRfc3RhdHVzCT0gcnRsZ2VuX3JlYWRfc3RhdHVzLA0KPiA+ICsJCS5jb25m
aWdfaW50cgk9ICZydGw4MjExZl9jb25maWdfaW50ciwNCj4gPiArCQkuaGFuZGxlX2ludGVycnVw
dCA9IHJ0bDgyMTFmX2hhbmRsZV9pbnRlcnJ1cHQsDQo+ID4gKwkJLnN1c3BlbmQJPSBnZW5waHlf
c3VzcGVuZCwNCj4gPiArCQkucmVzdW1lCQk9IHJ0bDgyMXhfcmVzdW1lLA0KPiA+ICsJCS5yZWFk
X3BhZ2UJPSBydGw4MjF4X3JlYWRfcGFnZSwNCj4gPiArCQkud3JpdGVfcGFnZQk9IHJ0bDgyMXhf
d3JpdGVfcGFnZSwNCj4gPiAgCX0sIHsNCj4gPiAgCQkubmFtZQkJPSAiR2VuZXJpYyBGRS1HRSBS
ZWFsdGVrIFBIWSIsDQo+ID4gIAkJLm1hdGNoX3BoeV9kZXZpY2UgPSBydGxnZW5fbWF0Y2hfcGh5
X2RldmljZSwNCj4gDQo+IEFuZCBieSB0aGUgd2F5LCBuZXQtbmV4dCBpcyBjbG9zZWQgY3VycmVu
dGx5Lg0KDQpPa2F5LCBJIHdpbGwgcG9zdCB0aGUgVjIgd2hlbiB0aGUgbmV0LW5leHQgaXMgcmUt
b3BlbmVkLCBUaGFua3MgZm9yIHlvdXIga2luZGx5IHJlbWluZGVyLg0K
