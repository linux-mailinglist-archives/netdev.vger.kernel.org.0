Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA4D613981
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 15:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiJaO5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 10:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiJaO5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 10:57:47 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2119.outbound.protection.outlook.com [40.107.114.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC26FFD2C;
        Mon, 31 Oct 2022 07:57:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZtJdVJxV4aEqCyodwZgYREBUzdBA27IsgmimjnoL8ZH6+Lao1PBNUYHHfdqCx91SVbqtgPVKXPytJd/ZDXJ6Sn09WH3XAc+jTMtMUMpcl+BsT4lS/o2ecTGiCiIs4OedK6x97GVm0H+keczWTRTBpt7Dd48DPEKWncUPcVJi2KNLhNYVP+R1jktHWXcY7xFaJJQwVvNx/4eX762qXQQVP/UfwwAnh250OZ8eSbzbkV6Lc5OXz45qx0UWbB5Hn/kdD959jSjDbGdHyEwnHQRNGVN9wyZnZJP/cFKkK421ObSjTKVXznWey87YLxKNWyOTSvspXTG+gqpOa31qX8BCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PKu6JzcH1qeqS3rw6+8eTtTqo1BOFccDh+wOXs8lXUk=;
 b=MRhR9FNemyWK8U6ZIX8aGiHyMsQnHRkbQVuX/L8AdDx1/B4q+GcV7106ZKDi8mmoDhePo7iAfErcJffE7wkfKKXacrYix04h1+h2vjuQk7brMZVEcC7z4siZpWvFUwAVyHLtSZazzmpzOdCnMeZsM7IyRp1wQSnmTGjk7N6IIGFlCc15W+FNvGRV5MmXvP5RXc16kTqOZhhdcUfUoNBHzQmKriHVtxMo2Ax5Do5Et5xEMICPaHXnJaVscw+OF76P2usIL+u6GrCpKYKo4+zQl+i5GFPf1+X1yTt1lOgBYbjXW/Lr49HyEsqQilLUNQ+1OHcP3pwYJjgbY/ECPFbCtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKu6JzcH1qeqS3rw6+8eTtTqo1BOFccDh+wOXs8lXUk=;
 b=LDjs05RqahrQ3iMT6HTjqrNjBMAoIjzeS7OQCDheb9MzxWU84pIblAkeeFCUG/v6yt/Vr8lxSGDdpAyZPKrsuMlnV2Dclll06k/fAGEYdSkX/dD8CcJ71vRy5InwWaKKz7uKCIxxTKO4TauQhlt3lJccCz7bXjGzB57gNH7Irqo=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSZPR01MB8630.jpnprd01.prod.outlook.com (2603:1096:604:18e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 14:57:43 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2%3]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 14:57:43 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 6/6] can: rcar_canfd: Add has_gerfl_eef to struct
 rcar_canfd_hw_info
Thread-Topic: [PATCH v3 6/6] can: rcar_canfd: Add has_gerfl_eef to struct
 rcar_canfd_hw_info
Thread-Index: AQHY6d1KzPu6u6sBIkGlqmouWtJppq4jl88AgAADhQCAAAeb4IAE+mXA
Date:   Mon, 31 Oct 2022 14:57:43 +0000
Message-ID: <OS0PR01MB5922BBCF1BDFD3176C5DAAF386379@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221027082158.95895-1-biju.das.jz@bp.renesas.com>
 <20221027082158.95895-7-biju.das.jz@bp.renesas.com>
 <CAMuHMdXayck0o9=Oc2+X7pDSx=Y+SHHdi3QtmYz+U-rumpc92Q@mail.gmail.com>
 <20221028102458.6qcuojc5xk46jbuo@pengutronix.de>
 <OS0PR01MB5922A029B93F82F47AE1DD7C86329@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB5922A029B93F82F47AE1DD7C86329@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OSZPR01MB8630:EE_
x-ms-office365-filtering-correlation-id: 15e34c83-ea95-422a-feee-08dabb504390
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2/3bIV/MHITUjjD3MRSg5tB5F5q747bPsZ7/3Fmxnt23xjN9PlJMy5laNdLLfe1TjiL5p4LoQ9SQyqcd8WuPp67cMtprw2O55m9mqmkpPYwK5UWAR5GCAcgrcHgmWPmTRxowFuiCTJLYhraDsinwXGIs73H2G80uvUhezf25LR7nFuH7UqSRC5fx48O5MYifHI+KTAOySw1aqT2z5EScOZYuTkURktrMWgH3Qdtzc2kIFe3uy54YhKC6tF/n0164cLTM8I7m1KQAJZbgh3uzPcSARM7wITyIQEbgyC8EYgBzSEa4Ji73WZ7Jv+wMBye4wC1lZFB/JHTE7YKWuiPSoA+PJfyCRRv4df7WZzBuXCV2B5uoimmyWka61K0Oiea6tJnCDSQdB3SKii5IU+kFaaNcPs4/gkEpZxEZqm1DN+4v2zWadSxM133iWxWb2wVsO+YVVJxUOOlZIyewm7ZiKhK2zICOHp33uFwlcbvcKr/4fqQ4kn+xBkzA43HOMBgYvIWd4DbqynvWfw9/SvU3gPmmQp5gj4hrNk5weuTrFyHtR2UcnTYCSKWzzpcITUOP1PJ/p/g001eMc6Ntux1xkzEDyJVRp6x+eCP4sFjPSEfTf+SFMhO6f7j1Sm3rU74NgP4DLTdwDqvNaNsr+ORouI16WBPq7320VUmU810gQuM8lXeJUjHvPYEHQjMUZfsAw91yeNL4C1GCcirZ+iqBAHV++Q5n6GF5oztoZZtYGVDGaZKoUqD3dXTpKMN6klo58IGjpthWMi3SoKg67m0+dVZG34SUyKrk7qiOTmgr5ew=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199015)(7696005)(7416002)(186003)(41300700001)(26005)(2906002)(8936002)(5660300002)(53546011)(6506007)(9686003)(52536014)(66946007)(966005)(33656002)(66556008)(66446008)(66476007)(64756008)(76116006)(4326008)(478600001)(38070700005)(55016003)(83380400001)(8676002)(86362001)(54906003)(316002)(122000001)(71200400001)(110136005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2dqMDdQQnRvQmhwY3QvZXd6a1R6OU5zQVhJZWliS1F5QmNmSHhYSXJOaDhj?=
 =?utf-8?B?NmpnWjBEdHA2MytGVmpjS0k1bDdzTTRvRDNKMUVtVUdPK2QyNGdvejQ5dENr?=
 =?utf-8?B?TjczY0NoaEhTZDErcWFzZmI0Wm5hbjlFTDNPellEYm5PZG5iZ1pXZGVLTHVm?=
 =?utf-8?B?dHE4eEtDMzA3Q2EyTGpvaklwb2MwVkZCRmk1c1NITHRqWlFSdkM5N05MTlVX?=
 =?utf-8?B?bzNSR3dST1JmRVJDSXFnMldONkNNZS8vR2YxWmk5R2YrTG0xdVhzOXg0QkNr?=
 =?utf-8?B?dlRUK2EvK2hXbW1CYWVFR1lpVjV5ZXRIUU9zQlptUisrUHkwenVzY3lhblJF?=
 =?utf-8?B?TklBbXZrckgyUlhaYXk5dWhzUCtYQVdBL3VNZGJwaXdaN1crbk05WUgvZ2E3?=
 =?utf-8?B?bytxODJUYUdtVWQ2UTFZakxLTUY2WEwwMDZLSUpRSXhBYlM3OVpWZkNhUnR6?=
 =?utf-8?B?Ylh4RHUrbzNJc04vM2RrMTNFbUR0ZExSUGFXaGZueFhLWlh5NS9Cc0J1SXE0?=
 =?utf-8?B?VUNMcHBTWWJrQjBBYlNsdkF6djZpT0RqZUpnREVSZmUvcVNmSkNYQ1I0OFBx?=
 =?utf-8?B?eDRqQXVNUEROOUo2NTRhQzZrWnNyNWIrYTc1Yjd5SHFudDlIRFp0Z0ZDL2xo?=
 =?utf-8?B?Wjc4MG1SQ2NXeEFVSm91VkFKZXhldTMrcHBwcGZpTGpFSGNpcUdDSDg3Z01S?=
 =?utf-8?B?azZkOGh5K3Y0NmRuVFRLRnlYbEcxVXhxeVlnS3JRbVdlRGx6cEZlelhBZW15?=
 =?utf-8?B?eDdyRkNINHUrR2xsNmN6SGxYWmFKRW9sM21vV3lTblJFV1BOam5JWTlRay9y?=
 =?utf-8?B?Y3RNMHY2em13SVdEeDdwYWl4RS8rRzhCMjBpc3pGWkpqYSt2T1IvaDdvbjRW?=
 =?utf-8?B?VkVTN1YzYVZDZ2dEdG1wUDhxS25JdlNIcFlXVzRYaGM4eXZyTE14cEQ0emho?=
 =?utf-8?B?ZS9jN0d1L2V4NzBoWnhtbFlJU0hTVjBMWEw2dVFHZEtnZmhSaEo5Y1BJdSti?=
 =?utf-8?B?UE0vU0YwclFKbW9LZWt6b0RMOHRnZEJ1ellFcXFqL3pMUEhjN3NHL2c3aTND?=
 =?utf-8?B?T0VZRHh1S3RKQmFib3pjc2xtZmdlYTRwam9pczQ0a1owRktoRVBuUjBrTGxy?=
 =?utf-8?B?YkwwRTlLbUVieFVQMjlvN3lEbmt6ZnVodlhxL3F5bnVwdUZUWHRTT2tKVmZF?=
 =?utf-8?B?R2lhQ3FpVE5lajFURE5oK0JuU01xL0pMcndoa0xMK2xxUEdZbVNEdisyTGh1?=
 =?utf-8?B?ZTFhdkY4eHJTSlI3SzZlZ2dBNWdTb25TL2p1djE0VEMwVkFIVGVlbHU4K09h?=
 =?utf-8?B?L2tlNnlaWkhDbXpRYlJXVGJrVHk1Q29zTmRjdUFLbE53SzEvRGgzd01YYlMx?=
 =?utf-8?B?UjloVS9HbFBvcWdJd1NKaC9ST05MWk5VSmJ0ZFd4cFVpUEpwYXFuekJGYmlX?=
 =?utf-8?B?N3FWZVRsdTgySXhZSFRaMktWY3lSVUdtTkpsZWtXLzVseGFRb3NVbWZoR2Q0?=
 =?utf-8?B?cnQ2bEUyeWNFS0o5eGF3alVSM0o1Y3lMeDJHZXBpM3VHQkJGTFNQRStvTTh3?=
 =?utf-8?B?YmhkOXF3REZ1cjZNbEE0clowMVhvanNCV2ZOZncwakhxVjlsMmRHV0EzMXpH?=
 =?utf-8?B?YWVmeWpCZEtNZkw5dWc1L3Nha0NaVHJlT04zOXVlSGpiUGVXYUs5VzJFMGRI?=
 =?utf-8?B?aUVDVTNxZ0pWVkJhZ0gwWEQ4UVZxeG1QN2N3enNpY251SEZzSWtJSytQRlIv?=
 =?utf-8?B?bUtXTFJZZW5oWjlTSlVCNVRWcUowRFBrblMxMnFiMFZXSnFBSHRuTXdCSXVa?=
 =?utf-8?B?bU90U2ZlakRua1VIVXc3NFFHNmhJd0d6VFIrNFdpOHZCbjcxNXhxWUo5dFdT?=
 =?utf-8?B?S2I1Q1E3VDQ4TUZxSGZaVkJUUk9yQkZWNDczMTF5Y0lRcXN6eStVMmgxbENm?=
 =?utf-8?B?NnFBQ25QNzFQNUJONm9OSHVacExyL0Jwc3BFN0NXUlZVTTFsalJNbWNmeXV0?=
 =?utf-8?B?N2paZ0R1VENXdnhHS2VmeFNVRUFLeWM1ODB6TldISGt6UmtDSEtnYVovZngv?=
 =?utf-8?B?WlltblBOTlM1WlowOGcwRjFEVUpNaEt3cVp4QnBrZ3MvV0RraGE2SForZzN4?=
 =?utf-8?B?cGhRbWxBQVdFTHVuaVpRS1lIUWRPd041aEdRN0RCWTNhQ0x1ZCtoakJFR3U3?=
 =?utf-8?B?aXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e34c83-ea95-422a-feee-08dabb504390
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 14:57:43.1075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JkPEbvFJthcB2jPaYvJExAKsf72sU+3vhGH0Y2yPoUfIVAEbI9UM7VkCLA18AaY0h5OUYzh7rSc2oO96lWRKyjQI9prT1pUt4mKmZwyx0ww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB8630
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiBTdWJqZWN0OiBSRTogW1BBVENIIHYzIDYvNl0gY2FuOiByY2FyX2NhbmZk
OiBBZGQgaGFzX2dlcmZsX2VlZiB0bw0KPiBzdHJ1Y3QgcmNhcl9jYW5mZF9od19pbmZvDQo+IA0K
PiBIaSBNYXJjLA0KPiANCj4gVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQo+IA0KPiA+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjMgNi82XSBjYW46IHJjYXJfY2FuZmQ6IEFkZCBoYXNfZ2VyZmxfZWVm
IHRvDQo+ID4gc3RydWN0IHJjYXJfY2FuZmRfaHdfaW5mbw0KPiA+DQo+ID4gT24gMjguMTAuMjAy
MiAxMjoxMjoyMiwgR2VlcnQgVXl0dGVyaG9ldmVuIHdyb3RlOg0KPiA+ID4gSGkgQmlqdSwNCj4g
PiA+DQo+ID4gPiBPbiBUaHUsIE9jdCAyNywgMjAyMiBhdCAxMDoyMiBBTSBCaWp1IERhcw0KPiA+
IDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4gd3JvdGU6DQo+ID4gPiA+IFItQ2FyIGhhcyBF
Q0MgZXJyb3IgZmxhZ3MgaW4gZ2xvYmFsIGVycm9yIGludGVycnVwdHMgd2hlcmVhcyBpdA0KPiBp
cw0KPiA+ID4gPiBub3QgYXZhaWxhYmxlIG9uIFJaL0cyTC4NCj4gPiA+ID4NCj4gPiA+ID4gQWRk
IGhhc19nZXJmbF9lZWYgdG8gc3RydWN0IHJjYXJfY2FuZmRfaHdfaW5mbyBzbyB0aGF0DQo+IHJj
YXJfY2FuZmRfDQo+ID4gPiA+IGdsb2JhbF9lcnJvcigpIHdpbGwgcHJvY2VzcyBFQ0MgZXJyb3Jz
IG9ubHkgZm9yIFItQ2FyLg0KPiA+ID4gPg0KPiA+ID4gPiB3aGlsc3QsIHRoaXMgcGF0Y2ggZml4
ZXMgdGhlIGJlbG93IGNoZWNrcGF0Y2ggd2FybmluZ3MNCj4gPiA+ID4gICBDSEVDSzogVW5uZWNl
c3NhcnkgcGFyZW50aGVzZXMgYXJvdW5kICdjaCA9PSAwJw0KPiA+ID4gPiAgIENIRUNLOiBVbm5l
Y2Vzc2FyeSBwYXJlbnRoZXNlcyBhcm91bmQgJ2NoID09IDEnDQo+ID4gPiA+DQo+ID4gPiA+IFNp
Z25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiA+
DQo+ID4gPiBSZXZpZXdlZC1ieTogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydCtyZW5lc2FzQGds
aWRlci5iZT4NCj4gPiA+DQo+ID4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2Nhbi9yY2FyL3JjYXJf
Y2FuZmQuYw0KPiA+ID4gPiArKysgYi9kcml2ZXJzL25ldC9jYW4vcmNhci9yY2FyX2NhbmZkLmMN
Cj4gPiA+ID4gQEAgLTk1NSwxMyArOTU4LDE1IEBAIHN0YXRpYyB2b2lkIHJjYXJfY2FuZmRfZ2xv
YmFsX2Vycm9yKHN0cnVjdA0KPiA+IG5ldF9kZXZpY2UgKm5kZXYpDQo+ID4gPiA+ICAgICAgICAg
dTMyIHJpZHggPSBjaCArIFJDQU5GRF9SRkZJRk9fSURYOw0KPiA+ID4gPg0KPiA+ID4gPiAgICAg
ICAgIGdlcmZsID0gcmNhcl9jYW5mZF9yZWFkKHByaXYtPmJhc2UsIFJDQU5GRF9HRVJGTCk7DQo+
ID4gPiA+IC0gICAgICAgaWYgKChnZXJmbCAmIFJDQU5GRF9HRVJGTF9FRUYwKSAmJiAoY2ggPT0g
MCkpIHsNCj4gPiA+ID4gLSAgICAgICAgICAgICAgIG5ldGRldl9kYmcobmRldiwgIkNoMDogRUND
IEVycm9yIGZsYWdcbiIpOw0KPiA+ID4gPiAtICAgICAgICAgICAgICAgc3RhdHMtPnR4X2Ryb3Bw
ZWQrKzsNCj4gPiA+ID4gLSAgICAgICB9DQo+ID4gPiA+IC0gICAgICAgaWYgKChnZXJmbCAmIFJD
QU5GRF9HRVJGTF9FRUYxKSAmJiAoY2ggPT0gMSkpIHsNCj4gPiA+ID4gLSAgICAgICAgICAgICAg
IG5ldGRldl9kYmcobmRldiwgIkNoMTogRUNDIEVycm9yIGZsYWdcbiIpOw0KPiA+ID4gPiAtICAg
ICAgICAgICAgICAgc3RhdHMtPnR4X2Ryb3BwZWQrKzsNCj4gPiA+ID4gKyAgICAgICBpZiAoZ3By
aXYtPmluZm8tPmhhc19nZXJmbF9lZWYpIHsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIGlmICgo
Z2VyZmwgJiBSQ0FORkRfR0VSRkxfRUVGMCkgJiYgY2ggPT0gMCkgew0KPiA+ID4gPiArICAgICAg
ICAgICAgICAgICAgICAgICBuZXRkZXZfZGJnKG5kZXYsICJDaDA6IEVDQyBFcnJvcg0KPiBmbGFn
XG4iKTsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgc3RhdHMtPnR4X2Ryb3BwZWQr
KzsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIH0NCj4gPiA+ID4gKyAgICAgICAgICAgICAgIGlm
ICgoZ2VyZmwgJiBSQ0FORkRfR0VSRkxfRUVGMSkgJiYgY2ggPT0gMSkgew0KPiA+ID4gPiArICAg
ICAgICAgICAgICAgICAgICAgICBuZXRkZXZfZGJnKG5kZXYsICJDaDE6IEVDQyBFcnJvcg0KPiBm
bGFnXG4iKTsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgc3RhdHMtPnR4X2Ryb3Bw
ZWQrKzsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIH0NCj4gPiA+DQo+ID4gPiBCVFcsIHRoaXMg
ZmFpbHMgdG8gY2hlY2sgdGhlIEVDQyBlcnJvciBmbGFncyBmb3IgY2hhbm5lbHMgMi03IG9uDQo+
IFItDQo+ID4gQ2FyDQo+ID4gPiBWM1UsIHdoaWNoIGlzIGEgcHJlLWV4aXN0aW5nIHByb2JsZW0u
ICBBcyB0aGF0IGlzIGEgYnVnLCBJIGhhdmUNCj4gc2VudA0KPiA+IGENCj4gPiA+IGZpeFsxXSwg
d2hpY2ggdW5mb3J0dW5hdGVseSBjb25mbGljdHMgd2l0aCB5b3VyIHBhdGNoLiBTb3JyeSBmb3IN
Cj4gPiB0aGF0Lg0KPiA+DQo+ID4gSSdsbCBhZGQgR2VlcnQncyBmaXggdG8gY2FuL21haW4gYW5k
IHVwc3RyZWFtIHZpYSBuZXQvbWFpbi4gUGxlYXNlDQo+IHJlLQ0KPiA+IHNwaW4gdGhpcyBzZXJp
ZXMgYWZ0ZXIgbmV0L21haW4gaGFzIGJlZW4gbWVyZ2VkIHRvIG5ldC1uZXh0L21haW4uDQo+ID4N
Cj4gPiBUaGlzIHdheSB3ZSdsbCBhdm9pZCBhIG1lcmdlIGNvbmZsaWN0Lg0KDQpJcyBpdCBPSywg
aWYgSSBzZW5kIGFsbCBvdGhlciBwYXRjaGVzIGllLCBwYXRjaCMxIHRvIHBhdGNoIzUgaW4gWzFd
IGFuZCBsYXRlcg0Kb25jZSBuZXQvbWFpbiBtZXJnZWQgdG8gbmV0LW5leHQvbWFpbiwgd2lsbCBz
ZW5kIHBhdGNoIzY/DQoNClBsZWFzZSBsZXQgbWUga25vdy4NCg0KWzFdIGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2xpbnV4LXJlbmVzYXMtc29jLzIwMjIxMDI3MDgyMTU4Ljk1ODk1LTEtYmlqdS5k
YXMuanpAYnAucmVuZXNhcy5jb20vVC8jdA0KDQpDaGVlcnMsDQpCaWp1DQo=
