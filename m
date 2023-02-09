Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC4968FC7A
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 02:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjBIBNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 20:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjBIBNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 20:13:34 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2126.outbound.protection.outlook.com [40.107.255.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB367F2;
        Wed,  8 Feb 2023 17:13:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JaGIiRCUxC2ONqEMHbckPRxM90wYbkyyMjnUsMCY5t/ofKTZ8a9OY1rTzMqFryiyGohhKeBlyVwLeuFVaoVYot2x7QEx7kUN+THlC1DSotKfjA7UGmFxwoPKI0OHLVqx60rSjB+8hHbtgaQm0Vtu6Oq29+1FZN4rpKdrExNG1Tb6P1V/LsZI63DOEPWo7AJk+4E8qkZ8PTedwIDUNzbiWldMq/2c5vLs4mVHtjUyvBuWgg9GJECFPMsOdXttRW0bhZA1FyoqrLrZjtQKPAWye1ogMauSoeDkldd23ki2YOxH8x2nkmkz+lpml8hhzpjjh0lKNneLNSDGyFibjud8RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kt883XnP873DNjI3tcpUKsVrlKkPl1OXzztj9tHvIA8=;
 b=O+ZshqtNFAGIUvhpBZvKhxUpGDyFxru1rEwyH42sURbzIzspM+MHGU80QuzgAdDOkjIF/BfbrceGcj8Mm90fDrMgZ3Vz2Jotqj15vBd5icO5tnZqwvC3SnlK9AUEfGkK39FcqisQVeTZH74g670Kv7HP09YoBrqKIGwrtKafCSR5EhinTmg0xoW/th0Hecr85CGR17k3A3j0IY+igdO4b2crywsR/x+x/VAiKNtAv3V6aglM5YqZuBfsGUwLempdj4UEMRpva3M8G2OJsQULBzYsRiR4H5csuWVGeZtqgSLNWnIqst5QNQCanuOLuHj8p6JBF98ZoFIcY57xQes27Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kt883XnP873DNjI3tcpUKsVrlKkPl1OXzztj9tHvIA8=;
 b=NFZ75sSR4UVhQ/FW3tByifuN5zP48q/1b3MpIY/vQDHrktmIIuvAZ5lHc4GyCf/f+HTvXFDDeVdiTBdZSp7gw+3PmZGcfy1piOyIVjE6T7EPuFPhYlqgg/wSf7l5/PC/7dZP9fh5aLIw/erVkRHKWUrZAmc5NyWgJErZiZtD58w=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB10826.jpnprd01.prod.outlook.com
 (2603:1096:400:297::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 01:13:30 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5f2:5ff1:7301:3ff1]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5f2:5ff1:7301:3ff1%4]) with mapi id 15.20.6086.018; Thu, 9 Feb 2023
 01:13:30 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next 3/4] net: renesas: rswitch: Remove gptp flag from
 rswitch_gwca_queue
Thread-Topic: [PATCH net-next 3/4] net: renesas: rswitch: Remove gptp flag
 from rswitch_gwca_queue
Thread-Index: AQHZO4/XWkjOagyXYUyGke476gwxR67FN4YAgAB3t1CAAB3CgIAAARaA
Date:   Thu, 9 Feb 2023 01:13:30 +0000
Message-ID: <TYBPR01MB5341F74F5E55F4AD7F45A7E1D8D99@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230208073445.2317192-1-yoshihiro.shimoda.uh@renesas.com>
 <20230208073445.2317192-4-yoshihiro.shimoda.uh@renesas.com>
 <4c2955c227087a2d50d3c7179e5edc2f392db1fc.camel@gmail.com>
 <TYBPR01MB5341C01EC932D1F53AEF188AD8D89@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <CAKgT0Uc6DYv+08jXJS_yrs_XMkEbMXvMCvP03AdY8Q391kqt_w@mail.gmail.com>
In-Reply-To: <CAKgT0Uc6DYv+08jXJS_yrs_XMkEbMXvMCvP03AdY8Q391kqt_w@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB10826:EE_
x-ms-office365-filtering-correlation-id: 971d6a2a-9b41-4efb-9740-08db0a3adaf1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +r2HU0lojKzi4QQ3y9LpXYo5LqZ71hqT8nBrql5DmRDbKcpL+18jHWv0Kr7QaN/Ly14ibl1+PWldyVFiGT/YWJax6Z4hIwyngC14BtO/JJfPk1DRX6rJiWOl7KbfDKiC+jBUfU635FSgkRZtQe0EDNGyJ+2pjlSk4lj8oab7NnW5XWbzRRLonilbE2EOmT3GwHsTi+tVqlMsKE/LOJBiocmv1+u+wWb3qC3kqm4iiseNnjzTb7bKSwmNRhTRlvnx4mjQYY8HWjDjj9eldMSb7w8wLElYG3Fzh83Jh3N3CJdvIfSLFQDspOCjOcWjF2QPBwQN7eqVCZsJn0iabSuEUPcFqCFg4jMcIazh+UX3K2RXZURWyT4znoaZLSl+xazdQUYNRKu10TTI+BFelGUA1iwluI9mLndkRz3zeoruQB7Vbjx9fT1VhxIr41udYSCQTsVKktmZTzaq1IrIyB7/NdWwmB0JrNa2vwQXgiooZ+HK89RZckp7c6h8miCgRqXzRagFJYFrtVV19KyRZRYR9koseNVhsyD8kDTqkYkBmyHIRFjg7d8Tp5EICJKmUCNJw582pqEDMUDTT56qPp5eftwfIlFeNhJ6bf3wNuznjIPQcCWHN/PTLN/ErvQ3tmZsGjmGr+NFnSJglBVBBekFSIGoSZL0Ag9de8k1SuupQ3E8B43Rzith7tZhuWmpCn7dTCg5RzpnhCMJ6+6Hg7Wmxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(451199018)(71200400001)(6916009)(66476007)(66946007)(316002)(64756008)(76116006)(66556008)(66446008)(8676002)(86362001)(122000001)(55016003)(83380400001)(4326008)(8936002)(5660300002)(41300700001)(2906002)(33656002)(52536014)(38100700002)(54906003)(53546011)(6506007)(38070700005)(9686003)(186003)(478600001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1BlSDNTV21hRFJvVUlyNGI2bWExdkNMbWcxSlViRnAzWVlhQjBXWU5KOURj?=
 =?utf-8?B?aXNIMVB4djBHRUU1RkZhQnZNS1BIc1UrWEgzclNQMkM3aUFjWmZ1UVZhUnk1?=
 =?utf-8?B?OUVXWS9Wcnh4c3VJbXRmaEQzR2tseFZpeG5hYVJOeDcxai9XRHBTL2Q3Q2Q1?=
 =?utf-8?B?Y3E0dlc1ZzlMSDA2WTF1OEcrTVVXVmU2UVd6NUR4Vm5qT21KaEU3ckluMmlq?=
 =?utf-8?B?dWdJR2FSUnIycVJST1FDRTc5emZUQ3dEaExzcmdYUFRnZzNJZm1sdkhsZUJU?=
 =?utf-8?B?Qmw5b3JEOXlRV05yY1RyK3ViSlZsSG5oWlNtT2pES0FSa1pUTWF5UUp4Z2xt?=
 =?utf-8?B?c1hwOGdPT2NTcWRqQ0hoTXNQdG9jb0VESDd1VWJlZjRudjZXVDBzUzNKczhH?=
 =?utf-8?B?OFJlcE40M2ZGYmRoV1JnTTJCVngzNVRxamlUZHJ4OUxTL3hTaDdCN2VRbFRI?=
 =?utf-8?B?MlB5cGJSZXRmeDdPSWtTN3ZnUXc0Y0JwKzR0K3hXRWp2TG9ZYlZEU1ZyVmha?=
 =?utf-8?B?T2oyUFJpc0p3SjR4UUJYRHZYSnppQnc3K09sM0lEY0lzRXFMVUFYdEtuNFZC?=
 =?utf-8?B?Wjdjb0Z4TmI3eUhMK1lIcjU2U1p6WXlOcW9nZ3hKczFBVHloRVJ1QWpxY3Jv?=
 =?utf-8?B?ZHBTZVBBNEduVysrS3BuUWJrSEExd1M1V054OE81VTB3QWFlZFQwSkFSampK?=
 =?utf-8?B?clhJU2NYbVpvMnVsUUV2NFRFV1JDRVRuYnNLcUtUaG1SM0lzZncrd256TFR3?=
 =?utf-8?B?UzVyb2JCanlwcmRyd29ITnJpcVVBbFBCYmR6bnAwa2EwUUFXT3JXSGM1clJQ?=
 =?utf-8?B?TnE1a0Y1VUkyL2NoT0dDdEJabWlJbHBMTmRLTU85SnhnU2hCK0hMMFVVN3Yx?=
 =?utf-8?B?MUwxMkdQTWNFSi9JdGhjTVQyZ1hMaUJpK0FybklaYms3UnhJem11bW95L0RK?=
 =?utf-8?B?N3plUWdUYWFrbFh0My9YS0pZYzJ0ak0zWGdZTlVKdEtRYlF0bVZQYnB2dU40?=
 =?utf-8?B?dU9CNmd3Z20yRHk0c2tONEZEbzRzd3RpbmhFWUYxVm9KanY3OW5BUjZSc2xL?=
 =?utf-8?B?dzNFeHFxMEoxSlAyUk1CYi8yQTkzd1BFdERRYi9FVHlPdEFGZU14enVFN0l6?=
 =?utf-8?B?QkNsTld6WHVhcnFsdUQvbzlTZkVxeUE4dFR0RDZUWGptdDdMUnlTcTQ5UlZC?=
 =?utf-8?B?K0ZFUmtGMS9iYm9qNkxXaUtONEtzRnUxSHJhVkNzWkUvbHlJT1hJdVFwWFZu?=
 =?utf-8?B?di9tSUx1ZjZQeEp1WXdNQTgzRXdxN0FzbjRxbHpWT3FFNHVONzVNS3JrN1l1?=
 =?utf-8?B?N1VObmF0WnhuRURycWd6akc1WXQ5ZUNrbEZRb1dkbG9LZUFmRGt3dHFBbTJ5?=
 =?utf-8?B?aTBrN1R4SmNyNmRkUjJ4eGZGZDdXSUd1VEs4TUJ5Tk5GTk5pdzFUTUl4YXlF?=
 =?utf-8?B?OElFVm5jUkZWUDYyaVhvUVJpRDYyMUJQVVZmZkZsVEZhNk43NWV3cllWL2di?=
 =?utf-8?B?R0s0a2lwQ0o1cWxjQnhDR1lmcjl5UmdCQWJrZ1RIaWxENEp1NmdDTi9YTk41?=
 =?utf-8?B?amwwWEJVOGxIQUFqdFVqdnJsZFBISkhjUDFLRUFGM1VEVmtRVHFoaXJabXVp?=
 =?utf-8?B?emZPTC9lREhoYjV4Wi9EdjJ6WUxZKzRkTzYyM2hWNWNDRVRiTXJoT25pblBC?=
 =?utf-8?B?d0RhcnhFOTdWMUl5Tkx0T2d0VDhNT0EvTTg4UnFtTzk0NnRXcHExMW5vYUxT?=
 =?utf-8?B?K2RsYU0vRldBcithQlYvSUVjOGw2NlBWSmVlWit6WmNUaG8xYUk1YW1LK3lX?=
 =?utf-8?B?MndkUTIyaFZhb1AxNFA0RnV4amU0dStqc0RkSWgvNEJXSTRhQk5jbm5FMDZx?=
 =?utf-8?B?N1pHNDNFNnFFLzF5Q1o5ZStwbDZnaEtBOUlOT2NYc2k3NkRtNVNYY3RGVXQr?=
 =?utf-8?B?TENzV09SVnRVdnovSWFWTE1VVFRaVFhpTm1mcklHM0VKd2RmMmtKeXBwT0I1?=
 =?utf-8?B?ZW9pbnd6L3Rya2FuZVB0UGVucWIxRW50WkpqMFVqQnZNazZSc3RQd2Y1S2x2?=
 =?utf-8?B?YXFuL1BrN21WVllHYmY4L1hxY3R0ZHdVanZ0dDFkYVpXUlI3Y0oyTlZVcWdi?=
 =?utf-8?B?UDNOUHErS1RKNTlWaDZUOVZMVks4ODdZT2UrSzlSUXl4eTBYMnBEVUIrVU9S?=
 =?utf-8?B?djNaTXdWMEY2YmdwU1V4YXZVanlpVmEwaUtMVUp6QUcxa2EyS3o5d0xIdGZs?=
 =?utf-8?B?TjlXNFZlQm9OM3VXQ25NTWV6QzVBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 971d6a2a-9b41-4efb-9740-08db0a3adaf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 01:13:30.0391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9UqVJhswPUyaspZG0vl6xTGtYMV4zkjkSx7rMAyyeg3XTsoX3tETQW0kdxD935/oNqlfoi3horxJaMjTu89frJPEBAkXCCK7KTA1+seLh6T4NaaahFvHzxegkfTm8KuH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10826
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxleGFuZGVyLA0KDQo+IEZyb206IEFsZXhhbmRlciBEdXljaywgU2VudDogVGh1cnNkYXks
IEZlYnJ1YXJ5IDksIDIwMjMgMTA6MDIgQU0NCj4gDQo+IE9uIFdlZCwgRmViIDgsIDIwMjMgYXQg
MzozMyBQTSBZb3NoaWhpcm8gU2hpbW9kYQ0KPiA8eW9zaGloaXJvLnNoaW1vZGEudWhAcmVuZXNh
cy5jb20+IHdyb3RlOg0KPiA+DQo+ID4gSGkgQWxleGFuZGVyLA0KPiA+DQo+ID4gPiBGcm9tOiBB
bGV4YW5kZXIgSCBEdXljaywgU2VudDogVGh1cnNkYXksIEZlYnJ1YXJ5IDksIDIwMjMgMTowNyBB
TQ0KPiA+ID4NCj4gPiA+IE9uIFdlZCwgMjAyMy0wMi0wOCBhdCAxNjozNCArMDkwMCwgWW9zaGlo
aXJvIFNoaW1vZGEgd3JvdGU6DQo+ID4gPiA+IFRoZSBncHRwIGZsYWcgaXMgY29tcGxldGVseSBy
ZWxhdGVkIHRvIHRoZSAhZGlyX3R4IGluIHN0cnVjdA0KPiA+ID4gPiByc3dpdGNoX2d3Y2FfcXVl
dWUuIEluIHRoZSBmdXR1cmUsIGEgbmV3IHF1ZXVlIGhhbmRsaW5nIGZvcg0KPiA+ID4gPiB0aW1l
c3RhbXAgd2lsbCBiZSBpbXBsZW1lbnRlZCBhbmQgdGhpcyBncHRwIGZsYWcgaXMgY29uZnVzYWJs
ZS4NCj4gPiA+ID4gU28sIHJlbW92ZSB0aGUgZ3B0cCBmbGFnLg0KPiA+ID4gPg0KPiA+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBZb3NoaWhpcm8gU2hpbW9kYSA8eW9zaGloaXJvLnNoaW1vZGEudWhAcmVu
ZXNhcy5jb20+DQo+ID4gPg0KPiA+ID4gQmFzZWQgb24gdGhlc2UgY2hhbmdlcyBJIGFtIGFzc3Vt
aW5nIHRoYXQgZ3B0cCA9PSAhZGlyX3R4PyBBbSBJDQo+ID4gPiB1bmRlcnN0YW5kaW5nIGl0IGNv
cnJlY3RseT8gSXQgd291bGQgYmUgdXNlZnVsIGlmIHlvdSBjYWxsZWQgdGhhdCBvdXQNCj4gPiA+
IGluIHRoZSBwYXRjaCBkZXNjcmlwdGlvbi4NCj4gPg0KPiA+IFlvdSdyZSBjb3JyZWN0Lg0KPiA+
IEknbGwgbW9kaWZ5IHRoZSBkZXNjcmlwdGlvbiB0byBjbGVhciB3aHkgZ3B0cCA9PSAhZGlyX3R4
IGxpa2UgYmVsb3cgb24gdjIgcGF0Y2guDQo+ID4gLS0tDQo+ID4gSW4gdGhlIHByZXZpb3VzIGNv
ZGUsIHRoZSBncHRwIGZsYWcgd2FzIGNvbXBsZXRlbHkgcmVsYXRlZCB0byB0aGUgIWRpcl90eA0K
PiA+IGluIHN0cnVjdCByc3dpdGNoX2d3Y2FfcXVldWUgYmVjYXVzZSByc3dpdGNoX2d3Y2FfcXVl
dWVfYWxsb2MoKSB3YXMgY2FsbGVkDQo+ID4gYmVsb3c6DQo+ID4NCj4gPiA8IEluIHJzd2l0Y2hf
dHhkbWFjX2FsbG9jKCkgPg0KPiA+IGVyciA9IHJzd2l0Y2hfZ3djYV9xdWV1ZV9hbGxvYyhuZGV2
LCBwcml2LCByZGV2LT50eF9xdWV1ZSwgdHJ1ZSwgZmFsc2UsDQo+ID4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgVFhfUklOR19TSVpFKTsNCj4gPiBTbywgZGlyX3R4ID0gdHJ1ZSwgZ3B0
cCA9IGZhbHNlDQo+ID4NCj4gPiA8IEluIHJzd2l0Y2hfcnhkbWFjX2FsbG9jKCkgPg0KPiA+IGVy
ciA9IHJzd2l0Y2hfZ3djYV9xdWV1ZV9hbGxvYyhuZGV2LCBwcml2LCByZGV2LT5yeF9xdWV1ZSwg
ZmFsc2UsIHRydWUsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUlhfUklOR19T
SVpFKTsNCj4gPiBTbywgZGlyX3R4ID0gZmFsc2UsIGdwdHAgPSB0cnVlDQo+ID4NCj4gPiBJbiB0
aGUgZnV0dXJlLCBhIG5ldyBxdWV1ZSBoYW5kbGluZyBmb3IgdGltZXN0YW1wIHdpbGwgYmUgaW1w
bGVtZW50ZWQNCj4gPiBhbmQgdGhpcyBncHRwIGZsYWcgaXMgY29uZnVzYWJsZS4gU28sIHJlbW92
ZSB0aGUgZ3B0cCBmbGFnLg0KPiA+IC0tLQ0KPiANCj4gSXQgaXMgYSBiaXQgbW9yZSByZWFkYWJs
ZSBpZiB0aGUgcmVsYXRpb24gaXMgZXhwbGFpbmVkIHNvIGlmIHlvdSBjb3VsZA0KPiBjYWxsIHRo
YXQgb3V0IGluIHRoZSBkZXNjcmlwdGlvbiBJIHdvdWxkIGFwcHJlY2lhdGUgaXQuDQoNCkkgYWRk
ZWQgdGhlIGRlc2NyaXB0aW9uIG9uIHYyIHBhdGNoLg0KDQo+ID4gPiA+IC0tLQ0KPiA+ID4gPiAg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNoLmMgfCAyNiArKysrKysrKysrKy0t
LS0tLS0tLS0tLS0tLQ0KPiA+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dp
dGNoLmggfCAgMSAtDQo+ID4gPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyks
IDE2IGRlbGV0aW9ucygtKQ0KPiA+ID4gPg0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNoLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5l
c2FzL3Jzd2l0Y2guYw0KPiA+ID4gPiBpbmRleCBiMjU2ZGFkYWRhMWQuLmU0MDhkMTAxODRlOCAx
MDA2NDQNCj4gPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNo
LmMNCj4gPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNoLmMN
Cj4gPiA+ID4gQEAgLTI4MCwxMSArMjgwLDE0IEBAIHN0YXRpYyB2b2lkIHJzd2l0Y2hfZ3djYV9x
dWV1ZV9mcmVlKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LA0KPiA+ID4gPiAgew0KPiA+ID4gPiAg
ICAgaW50IGk7DQo+ID4gPiA+DQo+ID4gPiA+IC0gICBpZiAoZ3EtPmdwdHApIHsNCj4gPiA+ID4g
KyAgIGlmICghZ3EtPmRpcl90eCkgew0KPiA+ID4gPiAgICAgICAgICAgICBkbWFfZnJlZV9jb2hl
cmVudChuZGV2LT5kZXYucGFyZW50LA0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBzaXplb2Yoc3RydWN0IHJzd2l0Y2hfZXh0X3RzX2Rlc2MpICoNCj4gPiA+ID4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKGdxLT5yaW5nX3NpemUgKyAxKSwgZ3EtPnJ4X3Jpbmcs
IGdxLT5yaW5nX2RtYSk7DQo+ID4gPiA+ICAgICAgICAgICAgIGdxLT5yeF9yaW5nID0gTlVMTDsN
Cj4gPiA+ID4gKw0KPiA+ID4gPiArICAgICAgICAgICBmb3IgKGkgPSAwOyBpIDwgZ3EtPnJpbmdf
c2l6ZTsgaSsrKQ0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAgIGRldl9rZnJlZV9za2IoZ3Et
PnNrYnNbaV0pOw0KPiA+ID4gPiAgICAgfSBlbHNlIHsNCj4gPiA+ID4gICAgICAgICAgICAgZG1h
X2ZyZWVfY29oZXJlbnQobmRldi0+ZGV2LnBhcmVudCwNCj4gPiA+ID4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgc2l6ZW9mKHN0cnVjdCByc3dpdGNoX2V4dF9kZXNjKSAqDQo+ID4gPiA+
IEBAIC0yOTIsMTEgKzI5NSw2IEBAIHN0YXRpYyB2b2lkIHJzd2l0Y2hfZ3djYV9xdWV1ZV9mcmVl
KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LA0KPiA+ID4gPiAgICAgICAgICAgICBncS0+dHhfcmlu
ZyA9IE5VTEw7DQo+ID4gPiA+ICAgICB9DQo+ID4gPiA+DQo+ID4gPiA+IC0gICBpZiAoIWdxLT5k
aXJfdHgpIHsNCj4gPiA+ID4gLSAgICAgICAgICAgZm9yIChpID0gMDsgaSA8IGdxLT5yaW5nX3Np
emU7IGkrKykNCj4gPiA+ID4gLSAgICAgICAgICAgICAgICAgICBkZXZfa2ZyZWVfc2tiKGdxLT5z
a2JzW2ldKTsNCj4gPiA+ID4gLSAgIH0NCj4gPiA+ID4gLQ0KPiA+ID4gPiAgICAga2ZyZWUoZ3Et
PnNrYnMpOw0KPiA+ID4gPiAgICAgZ3EtPnNrYnMgPSBOVUxMOw0KPiA+ID4gPiAgfQ0KPiA+ID4N
Cj4gPiA+IE9uZSBwaWVjZSBJIGRvbid0IHVuZGVyc3RhbmQgaXMgd2h5IGZyZWVpbmcgb2YgdGhl
IHNrYnMgc3RvcmVkIGluIHRoZQ0KPiA+ID4gYXJyYXkgaGVyZSB3YXMgcmVtb3ZlZC4gSXMgdGhp
cyBjbGVhbmVkIHVwIHNvbWV3aGVyZSBlbHNlIGJlZm9yZSB3ZQ0KPiA+ID4gY2FsbCB0aGlzIGZ1
bmN0aW9uPw0KPiA+DQo+ID4gImdxLT5za2JzID0gTlVMTDsiIHNlZW1zIHVubmVjZXNzYXJ5IGJl
Y2F1c2UgdGhpcyBkcml2ZXIgZG9lc24ndCBjaGVjaw0KPiA+IHdoZXRoZXIgZ3EtPnNrYnMgaXMg
TlVMTCBvciBub3QuIEFsc28sIGdxLT5bcnRdeF9yaW5nIHNlZW0gdG8gYmUgdGhlIHNhbWUuDQo+
ID4gU28sIEknbGwgbWFrZSBzdWNoIGEgcGF0Y2ggd2hpY2ggaXMgcmVtb3ZpbmcgdW5uZWNlc3Nh
cnkgY29kZSBhZnRlcg0KPiA+IHRoaXMgcGF0Y2ggc2VyaWVzIHdhcyBhY2NlcHRlZC4NCj4gDQo+
IEkgd2FzIGFjdHVhbGx5IHJlZmVycmluZyB0byB0aGUgbGluZXMgeW91IHJlbW92ZWQgYWJvdmUg
dGhhdC4NCj4gU3BlY2lmaWNhbGx5IEkgYW0gd29uZGVyaW5nIHdoeSB0aGUgY2FsbHMgdG8NCj4g
ZGV2X2tmcmVlX3NrYihncS0+c2tic1tpXSk7IHdlcmUgcmVtb3ZlZD8gSSBhbSB3b25kZXJpbmcg
aWYgdGhpcyBtaWdodA0KPiBiZSBpbnRyb2R1Y2luZyBhIG1lbW9yeSBsZWFrLg0KDQpkZXZfa2Zy
ZWVfc2tiKGdxLT5za2JzW2ldKTsgd2VyZSBub3QgcmVtb3ZlZC4gVGhpcyBwYXRjaCBKdXN0IG1v
dmVzIGl0IGludG8NCnRoZSBmaXJzdCAiaWYgKCFncS0+ZGlyX3R4KSB7IiBiZWNhdXNlIGhhdmlu
ZyBkb3VibGUgImlmICghZ3EtPmRpcl90eCkgeyINCmlzIG5vdCBnb29kLg0KDQpCZXN0IHJlZ2Fy
ZHMsDQpZb3NoaWhpcm8gU2hpbW9kYQ0KDQo=
