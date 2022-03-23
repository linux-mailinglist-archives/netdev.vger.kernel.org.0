Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2434E5383
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 14:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244498AbiCWNuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 09:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242760AbiCWNua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 09:50:30 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20117.outbound.protection.outlook.com [40.107.2.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ED638BCA;
        Wed, 23 Mar 2022 06:48:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQ6Gor6qAw1VrKoYF9sk4/uJGNBEYMDTglcAoqay2t8Ij2j/I4iPwdEIN2PayvtMrYKJaB/4RnAy8pUo6eY5oH5UdlD/8GxAOECL9460PT8Et4lekahdU0JeJOFaG3D5BnCZzKLz+AbY5+wNob26AuJ3ZmA1+T48pZ1b4XpFXcszKeNukyLliH6WDh/XVTScbRfq0axswrXsqvpT+FU9zFyYQ5nr671Pz4W+1Yjzfv9JZ5tU/udtKQxvCNtSztF1vD8TjSmtbkPeN0F9M/hjUR7T3KmwFGNtJFPvMLJ+I943CJrFEcAHyZFOHJd3QHTfZRBFn/7bl5Jyxapp0MQj3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgveS0trkGXMgLYUfhcm5HZaHDyWL40MmS1XcGL84Qg=;
 b=PCU+v5qhOQu+xhiKh6oCPPwXS/oTACBdXlciEJ/bV2aQCCTzWEZ/2mjhwQzXdYKj8/WLa+HFOtMdbThj914+LbT8WaQxAkw2Ec9eyMAMvp8Ooq+LiNYP5Imo2hRVl1SSiL0Vqf8qfcDowf3kbwis/sV+6tAYFr+hSFqydzEqq0cF3Qgd8aLFo/3nkV9H3e/66/aDBx7Wn/+SbWVmNAir4KikrXhnYqYacJjS0NifHzZPvobH0elYlGNRNwwMJlSZ5mGQoZL4KN6TDYbBmn0wdeR0feXaMCA8LhxS1b3pArJbMUBD6nrmxIDtZMBaE34Fs7eyavS+8bAgPvVbhMeSJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgveS0trkGXMgLYUfhcm5HZaHDyWL40MmS1XcGL84Qg=;
 b=mEjh8NnZpd6mmENqKCtAZ+0G6WxrJqzL4UW1HVR1NdZMqrNQvlAjT2L3eL8hWvCiP1xB2GqDHc6x/ikVHW7Z8R7G8NyTfTqhqwKcJRJHn6bBl7VshRqqqdr49372JcnsNjkdc8bRfQamB6deA814NXqsjHDld/MwUX2jj+5b2eY=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PAXPR03MB8297.eurprd03.prod.outlook.com (2603:10a6:102:23f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Wed, 23 Mar
 2022 13:48:56 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.5081.023; Wed, 23 Mar 2022
 13:48:56 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: realtek: make interface drivers depend
 on OF
Thread-Topic: [PATCH net-next] net: dsa: realtek: make interface drivers
 depend on OF
Thread-Index: AQHYPrNz45zCE6bCjEaBGmJXraNsLKzM7dWAgAAOeAA=
Date:   Wed, 23 Mar 2022 13:48:56 +0000
Message-ID: <20220323134944.4cn25vs6vaqcdeso@bang-olufsen.dk>
References: <20220323124225.91763-1-alvin@pqrs.dk> <YjsZVblL11w8IuRH@lunn.ch>
In-Reply-To: <YjsZVblL11w8IuRH@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8b3bc32-f5a2-49d8-25bc-08da0cd3e062
x-ms-traffictypediagnostic: PAXPR03MB8297:EE_
x-microsoft-antispam-prvs: <PAXPR03MB82972BE321DB94FE049ED27683189@PAXPR03MB8297.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TAKKLmdZPJ16H1xhh82gpJ+BVH/rLt4ggP3iQ9isRmG6xL2pMr6yAvWAF24+f6y8PxzzqfeE+H8Ah5gLa1i7T/mxuB/N2OQlc255+qz8eQdzcc7X3MuxOG1UUAjVt1b5WTcu+vgztQlMDxiMczVXR92gAfABUgthYZU4nSTCbiAB6JF+ksCFP328dszHdRoTYsSa9bpviGQeDpH9H2NpJaJmcx/jPUKAKIoHG4c5YnY1fd3HMZ/LgSsNX8qmtnds73WxhVfLwWOo7kASQNUFnr1cEhCl7mR+SXYl+6cxM40D0k//FZPGciLuBLDd282ZOtdXjUKN4ZrQKrLIrQ1J+DzjUAHWsBcqKxZMs7/udpihOKD66mKsCjwvpuOglpIMxEFwFajgvNSadsSHvk/sF4AbZSPYP1U2E/kwK2KslkvZBJOm19TUlzz0rsekTkZpZdj5nrL/K7UdDGkLEVZDf3uo/3dqS2DICxMBpm4sKk2brOiEma8iG7arHRUvs84+kNdIVt/u5WVOjB2L2a/Qe+PQ1kZILpAbBMSt5BE4g0YbWDNk6g9JQDRTili1MwukI9E5uhEOay9tlrwC/lcrXKL0+eqYnznA4aCoPhF89EiLc6/akeRnLfB/TRJjuSI/TL1dBDoCWCLKk9Fe5f3uVQn99FaRet6Z5f4av47BI8qWFjwI5JC9fCH+7HUkdDNNFvf6UK1bKyePWLmVjZc63lqyJD61PDoCNFhJnd0kqW4sDS0yWccDl1BCKJk8ncBdoAyJs9jSL4gxskP95Co5bTjyS5qnaP9ZzE3G4ILrN+U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(508600001)(66574015)(8936002)(7416002)(8976002)(5660300002)(38100700002)(38070700005)(85202003)(2906002)(6486002)(966005)(122000001)(36756003)(64756008)(85182001)(66476007)(66556008)(66946007)(76116006)(91956017)(66446008)(54906003)(6916009)(6506007)(83380400001)(26005)(1076003)(2616005)(186003)(6512007)(86362001)(316002)(8676002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1A5eDMxV20xa2lQV0VQVWlFN2F2TklKUzc5UzZ5MVdGZjcrajQ2bjNGbkU0?=
 =?utf-8?B?TWVFQUgrMzRLWWROb2EyQjREa0dkSHJmZDRZZWFGWjdLb0lxUXVZNGJWd205?=
 =?utf-8?B?YldtOVExUEVCZ21lOE9EQUk2c3FpTm9tRE9lZWZLQXJPMVhxVlA3Y1FGU01L?=
 =?utf-8?B?c0hpaGtKZG9pcndNd0t0R1dQTjY1aG9TS0pkTS9jMlZhYy9sUjhpaFJoK2hu?=
 =?utf-8?B?ZmtTMnd3YW5wTFp1QjdUR3RQWFZuQjBacXJPM0M1dW45ZTFJOU1paTkxT2or?=
 =?utf-8?B?SUpHUlNxdkdIaUxTNVhqUk40UjVVODE1VXZkUG11ODJrMFlRK2lUZlF6ZmtO?=
 =?utf-8?B?OXk4UnB0MnpIMWFnQlNuaHBoeUphM0NMZWJ4VEY2ZzZ4bnNFeXlnMzJodXpi?=
 =?utf-8?B?Yk16eFZmRUxVaDd2aDNPdU5HOTNKcWFGU1JhdW14eTlENFI1MXFlWkt0eGtC?=
 =?utf-8?B?NWhZc3M3UkpMZGVYdC9TNTA4TUNiRHRkNk1PcTVxZlVmUGdUM2lNQWNnVXpo?=
 =?utf-8?B?TU9xMXNVWmFYRUFXSUYrOEpkZTNGa05ycEhWeWFsYllVdXhJNVhYbGlJMmRD?=
 =?utf-8?B?OWRKMjFkaUNmNDJtWitCc1JJRnpwMzRPSVhKQndsR0dhcWtVelAxWk1aeUhJ?=
 =?utf-8?B?aGc0YU00Qks0ajJ2ZW83ekZvdWpNYStNTUpTbTRPRFZnQ0tGWUlibXpkNlJ2?=
 =?utf-8?B?bUJuR0JWbkU0aUhlMTVMUUVPUjZBTFNsd2JUUEF0ZDVHYVFhc0U1R01GTG9H?=
 =?utf-8?B?bXJsREQyOE1ja1ZBSVFGMFpKN1gwRy9VZlNFV2svVUVmU1JoczZRelc1SW1B?=
 =?utf-8?B?UU0rSmpmc2Ixb0lDSTZNNENYU0NQRDJDRFlUUzhRbWxiUXFEWU1nWHFPQ2tO?=
 =?utf-8?B?b1IrZnNtVkhCUDRIUnZ2dWpFVkNyeG5vS0htYy9WYXFFcUFIMUU0K3V5Tk9a?=
 =?utf-8?B?RHRSUTh0d2M3Smt6cVNZeXhjMnl1b0liZE42bnlOVGUwaGh3eVJDeHdZNWhN?=
 =?utf-8?B?TlRCQnBZQUc3QlE1TVFTdnI2RzdBSlRrTUhsZTQ2L0VkQjRLaTg3TmZGcFB6?=
 =?utf-8?B?WXpWcHdjOThRMWRqL2svYjNPUTVmd2ZXaTN3cndjYThOVHBWcGN4Vm9YdnBL?=
 =?utf-8?B?VmpCbEdwRkdyNmY2bGd4Uks4WGx0SW80UWVtTWI2c0M2MjBra011U0MrNWRL?=
 =?utf-8?B?M1FoOHNXc29xL0RERnFHWTlYdksvWFByNEVzQ3dkUU00OG5ubHZyMGJINVpr?=
 =?utf-8?B?STgvWEh6TU5lVDFERWh2MnF5ejQwQ29oeERTaHV3a3JnK21OT3NxakY2NTBO?=
 =?utf-8?B?a0ExTDlSa2NNOGZkdHNVdGljODBpcEZaTXFxaGpyK2hPVTNvSHNDRDNkVFBJ?=
 =?utf-8?B?RFFNcm9icUJoRkxJZWt0cGVZcUF4UGlsUkg0SUtENi9DZlYvTndUMlJFRk95?=
 =?utf-8?B?OEhoeG1ZNGExOCtIamJ0b3poMm5BZGFSb2FCb2xKNm5SSXFQUWRtU1VsYXp4?=
 =?utf-8?B?NnJWdnl2cXJLckJxa0FIR0g4N0FQR2xMODdjOFVQaTBMMkU0WmJqd05TRmcy?=
 =?utf-8?B?MHY4Z1VMUXJIS0h2Z2JOa1E1NTZ4RkMwd25qZmFVNjBIQ1dNbVBKQUlLUVBw?=
 =?utf-8?B?cVo0eDVrZXBVbHMrNlJaM29rdFlpa3VVMUlXSDFabG53MHp5eXpvWFZZWFBo?=
 =?utf-8?B?Rktqa2NrdGFNaDRPc3VaVmx5V1Z4UURBTDViWFprRmd1RXJSWUttWkVQV1ZS?=
 =?utf-8?B?OHZkNko0aldxdHcwcmxBZXF4eE1QRWk1aVlkYllmM1h3b2JJdnJYWUlRcE1K?=
 =?utf-8?B?c1l3V3dCbUt6RVl1d3JVTmdZQ0lhL3Boem4wUzF3UjBDZmJMdkJkRTd0dDFx?=
 =?utf-8?B?ZGp2WmNTT0hpVVNldVJEckJ0THJzd0JvWno2NU1rbGJHS2hTV1IyQ2VTNmNu?=
 =?utf-8?B?L2R1RklKZjFzWFJyNERvVjhwdEVvMUIvam5hMUtCa3Y0NXNXbWJiODNwa0Rj?=
 =?utf-8?B?U0xqMGJXZ0hRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12AF4A9D4BBF2243B118A6D58ED8A6B8@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b3bc32-f5a2-49d8-25bc-08da0cd3e062
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2022 13:48:56.7726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LliuKLjDl/XBWffAcs7WoYGnt6241x+fLjukYrQpffZJ3sJ9Bb87SDkeDu08afMsXz0LG3wExysUJWzd8lxDiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB8297
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiBXZWQsIE1hciAyMywgMjAyMiBhdCAwMTo1Nzo1N1BNICswMTAwLCBB
bmRyZXcgTHVubiB3cm90ZToNCj4gT24gV2VkLCBNYXIgMjMsIDIwMjIgYXQgMDE6NDI6MjVQTSAr
MDEwMCwgQWx2aW4gxaBpcHJhZ2Egd3JvdGU6DQo+ID4gRnJvbTogQWx2aW4gxaBpcHJhZ2EgPGFs
c2lAYmFuZy1vbHVmc2VuLmRrPg0KPiA+IA0KPiA+IFRoZSBrZXJuZWwgdGVzdCByb2JvdCByZXBv
cnRlZCBidWlsZCB3YXJuaW5ncyB3aXRoIGEgcmFuZGNvbmZpZyB0aGF0DQo+ID4gYnVpbHQgcmVh
bHRlay17c21pLG1kaW99IHdpdGhvdXQgQ09ORklHX09GIHNldC4gU2luY2UgYm90aCBpbnRlcmZh
Y2UNCj4gPiBkcml2ZXJzIGFyZSB1c2luZyBPRiBhbmQgd2lsbCBub3QgcHJvYmUgd2l0aG91dCwg
YWRkIHRoZSBjb3JyZXNwb25kaW5nDQo+ID4gZGVwZW5kZW5jeSB0byBLY29uZmlnLg0KPiA+IA0K
PiA+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIyMDMyMzEyMzMuWHg3M1k0
MG8tbGtwQGludGVsLmNvbS8NCj4gPiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwv
MjAyMjAzMjMxNDM5LnljbDBqZzUwLWxrcEBpbnRlbC5jb20vDQo+ID4gU2lnbmVkLW9mZi1ieTog
QWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRrPg0KPiANCj4gSGkgQWx2aW4NCj4g
DQo+IFRoaXMgbG9va3MgbGlrZSBzb21ldGhpbmcgd2hpY2ggY291bGQgZ28gaW50byBuZXQsIG5v
dCBuZXQtbmV4dC4gQ291bGQNCj4geW91IGFkZCBhIEZpeGVzOiB0YWcuDQoNClRoZSBkcml2ZXIg
aGFzIGJlZW4gc3BsaXQgaW4gbmV0LW5leHQgYW5kIGRldmlhdGVzIHNpZ25pZmljYW50bHkgZnJv
bQ0Kd2hhdCBpcyBpbiBuZXQuIEkgY2FuIHNlbmQgYSBwYXRjaCB0byBuZXQgYXMgd2VsbCwgYnV0
IHRoYXQgd2lsbCBub3QNCmNvdmVyIG5ldC1uZXh0Lg0KDQpWaWV3IGZyb20gbmV0Og0KDQogICAg
ZHJpdmVycy9uZXQvZHNhL0tjb25maWc6DQogICAgLi4uDQogICAgY29uZmlnIE5FVF9EU0FfUkVB
TFRFS19TTUkNCiAgICAuLi4NCg0KVmlldyBmcm9tIG5ldC1uZXh0Og0KDQogICAgZHJpdmVycy9u
ZXQvZHNhL0tjb25maWc6DQogICAgLi4uDQogICAgc291cmNlICJkcml2ZXJzL25ldC9kc2EvcmVh
bHRlay9LY29uZmlnIg0KICAgIC4uLg0KDQogICAgZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvS2Nv
bmZpZzoNCiAgICBtZW51Y29uZmlnIE5FVF9EU0FfUkVBTFRFSw0KICAgICAgICAuLi4NCiAgICBj
b25maWcgTkVUX0RTQV9SRUFMVEVLX01ESU8NCiAgICAgICAgLi4uDQogICAgY29uZmlnIE5FVF9E
U0FfUkVBTFRFS19TTUkNCiAgICAgICAgLi4uDQoNCkkgYW0gbm90IHdlbGwtdmVyc2VkIGluIHRo
ZSBwcm9jZWR1cmVzIGhlcmUsIGJ1dCBzaW5jZSA1LjE3IGhhcyBub3cgYmVlbg0KcmVsZWFzZWQs
IGlzbid0IGl0IG1vcmUgaW1wb3J0YW50IHRvIGZpeCA1LjE4LCB3aGljaCB3aWxsIHNvb24gaGF2
ZSB0aGUNCm5ldC1uZXh0IGJyYW5jaCBtZXJnZWQgaW4/IEhlbmNlIHRoZSBwYXRjaCBzaG91bGQg
dGFyZ2V0IG5ldC1uZXh0Pw0KDQpBcyBmb3IgNS4xNyBhbmQgdGhlIG9sZCAobmV0KSBzdHJ1Y3R1
cmUsIEkgY2FuIHNlbmQgYSBzZXBhcmF0ZSBwYXRjaCB0bw0KbmV0LiBEb2VzIHRoYXQgc291bmQg
T0s/DQoNCk9uY2UgdGhhdCBpcyBjbGFyaWZpZWQgSSBjYW4gcmUtc2VuZCB3aXRoIGEgRml4ZXM6
IHRhZy4NCg0KVGhhbmtzIGZvciB5b3VyIGhlbHAuDQoNCktpbmQgcmVnYXJkcywNCkFsdmluDQoN
Cg0KPiANCj4gT3RoZXJ3aXNlDQo+IA0KPiBSZXZpZXdlZC1ieTogQW5kcmV3IEx1bm4gPGFuZHJl
d0BsdW5uLmNoPg0KPiANCj4gICAgIEFuZHJldw==
