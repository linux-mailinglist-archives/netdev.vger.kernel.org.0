Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B373A6424FE
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbiLEIrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbiLEIq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:46:57 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2113.outbound.protection.outlook.com [40.107.114.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36179958D;
        Mon,  5 Dec 2022 00:46:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWVqFN6l8xPcFe/ug49HYPGiirvkGOQTZ8uh+QqnQzxv4WOo40zT0M/8csBrBkVB00mlNL30tU6FsgMHGMRoVCdBil1hDdYqOWuTiQ7DfM4jOO6bWEbFkpIq4A0jZSRiZwrfdLLGpsW2vJf02CVqXWrxcSGhBPW85m79/0LdSRqM5WLV8KLzTA20DPJjITTNCYzZKz0ojb0LVFQOe1WOLUL+Y76qvarBW6FQC+bYLg8gO883Vo+HGtZRA78d0r3eRNRbZGsn0nKKl8S5JprDbEoyKfAwwVY3kQRKEfn0LUuYIcNWUUt4b6DgXJE1hEfwnWG7ZmmzHHLOIbVm1nsWBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GjXRNB44A0RBAz2Bm2VhO4IMPM+58gx2W68F0IvxtwA=;
 b=nY2o0xHihKdNsTsb4zd5YDLaKzBvdSYBPXQQpnUZANnuecnWy+/eEAKpKcCiGCS/rdBZbg1hgJQ2ZdO0OKql/Elj7oYeoLgzGUQ5r/cJH0kolYaC40sBwOC6Iv/YjD1lDRAuFdJrQDxiMEkpFVe83AW301Pp8jkWEzT//XHcO44YLdCTLSwwgRR/I6ddwCsUWrhx4Wpb+kZYXXZEdO+njGNrmhX/nmhX/PCLoa60W562xe90nbaPsssNJWNh/ZjrO++qzxlbUfvDSx2QAWKCTLHUL1+usdxLER9JZZHiqdRNq0NPlZoozhk5VT2QiMOxkQeMw5cHMpHhfylMov4Yxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjXRNB44A0RBAz2Bm2VhO4IMPM+58gx2W68F0IvxtwA=;
 b=tcnzmxZuzgH987cX9bj620fw/XclGff8pL/bSXTvNO/IvbVaaMrOSIWmDo+qhxLrpIBzgjhmEBPVQQm7NyDJq2vNqYojHUlLBhAqoUcvDBknScUCBPVTfPvWAps6CItoo6AcbEF0hH7iL1bmWsih9suSr+FiqufdMnAhiz95LU0=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5571.jpnprd01.prod.outlook.com (2603:1096:604:be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 08:46:54 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3%5]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 08:46:54 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     YueHaibing <yuehaibing@huawei.com>,
        "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "phil.edworthy@renesas.com" <phil.edworthy@renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] ravb: Fix potential use-after-free in ravb_rx_gbeth()
Thread-Topic: [PATCH net] ravb: Fix potential use-after-free in
 ravb_rx_gbeth()
Thread-Index: AQHZBvnifjjXKLvqgUuypcFW2XI0pa5b8fDQgAMLXQCAAADIsA==
Date:   Mon, 5 Dec 2022 08:46:54 +0000
Message-ID: <OS0PR01MB59220A33AE7B8256502579D286189@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221203092941.10880-1-yuehaibing@huawei.com>
 <OS0PR01MB592214C639E060C5AD3A67BF86169@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <CAMuHMdXs1jNgOD4u2ncW81rfxC7xb1+hc3N2VH_Gom8f9zB+vw@mail.gmail.com>
In-Reply-To: <CAMuHMdXs1jNgOD4u2ncW81rfxC7xb1+hc3N2VH_Gom8f9zB+vw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS0PR01MB5571:EE_
x-ms-office365-filtering-correlation-id: 0ccbdfb5-633e-43ee-5819-08dad69d4288
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4wCFtEQDrG0GR0OwByD+taCKh3GHrG6J4yCwzW/sNlUMFtTRSxz+duult5qNC6MreECKiwLWGdIyHtQq02bNhNy6H2Dmg6LLkW4zQDJM7iVQjlmRxiGHnCAF1snWfCaVPjKIs6zIxP7RXFjTjn05S7VKH3vqXsVPHKEEZOGZxD7WRoEaCiuUI3OwE+qeFGwIpNtfa4fIe36vupW8zL6TKbTW4vuKYxx2gssQ4J8JaBZG0hN6dRcL0vnkdrgwcUl0a6BQym5PUAiBORxlmubDtuAYTDJTImVx6CCCGukct9yRnO5KOMXcRdepahYVSwbq+9wvdgRW6FVi5r1sZMPgi6Uj8YH9JqWAcnoZoGCHpVY4IMDyl5QQvoOCe/Qag/CLUjsyqSVxSxs9u/XerHuZcLnIgLMU47MAySKCSZiqCJOk8ZApUCbYvBkiCj74q1DJ5J4fDwittXVlIOBpDJyTtHrgGZqIyF1BnV0cfnbXmiDLoakij4GIAsEiZoTT27l26RQGQHbYFnmCzQ8sP7f3StST9zaN4Uie2kmLh4sS/KV4AHvCiwBaibIbUr7W8bEWys3T6+78lbjWBa3HiZxvKqLAJvOz7ekGjDNXhHwX9atW44G9U/jGhz+cKA93wkR/KOK/3F4n66VcGUNFmMfRmT9yLZOqQoiQrWfASebiP1ZIk8ceUkAgpc7F+ZDXrVYd+vDzcOGaN2RIg0oAXisO+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(451199015)(2906002)(26005)(7696005)(54906003)(6916009)(316002)(53546011)(6506007)(186003)(9686003)(55016003)(86362001)(478600001)(83380400001)(33656002)(71200400001)(66476007)(66556008)(66946007)(76116006)(66446008)(64756008)(8676002)(4326008)(52536014)(41300700001)(38070700005)(38100700002)(122000001)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEV6NWhvSWtDcnhnaC9mWVloUGNzOHpWeXVra29idDJ3Y3dqeVk2WjQ5dks0?=
 =?utf-8?B?eS9JSkxrZTZoV1ZTQmF6aUVacDBuV0F4WUNJSS9yWXZ2bkQrc0orakRmTXJN?=
 =?utf-8?B?VmRpTjJNUHVEZ0hLZUNmYThrMDNxbDlGTy9EanF0Z0NOMUJ4Y3VMV3RDRmpr?=
 =?utf-8?B?VEtFVXBRYW9SY1ViajJmL29XTEcvLzBBeXZCR09LTWcwb200eEp2elJiZFFl?=
 =?utf-8?B?WEVKd09NVFNESTlVMkoyVC9pZTFyTnpxd28rcStxTk53bEpGSXJuMjhxUEgr?=
 =?utf-8?B?ZGRBblRQQmMxNERGQ2EzLzZ5VVRPdk1TNkZJaGdJbGpGbGtYTzJnMHp4SVND?=
 =?utf-8?B?N0s1NFkwbm5XR3BpQmI1M3hvbnR5SW1EQkwrOHNkaElGZ0daaWxtQ252aU56?=
 =?utf-8?B?V0dkd1ZIelZWRFM2ZTM5cFNtaUhzeUkzNkNZYXR0SGNRRzNTbW5FSmJKVzNX?=
 =?utf-8?B?QjRFQUR1NFNudENrbjVoY1lrb0orbFkyQldwR1g2U2xrMVE2RjJUSTZKQzdv?=
 =?utf-8?B?Wk5qR0RZVVZ0ZTNtL3pqeERQaFBGWFBGbGpWWUtvUkw2ZU16YjljUUhYUDFm?=
 =?utf-8?B?Z2F0WEdwZ2NYeXp0OFAvSmNJcVZUcVMvNUVzdzlhYjFrVEkwRzE2eHZKakR3?=
 =?utf-8?B?djBLRWRrQldkMmlkWUFkbzdqaW9QSGZEcGk0UFZwc1pZUkJNa0cwMENvVkl5?=
 =?utf-8?B?d3k3cnBGa3VHTUdIOUFhUSszYk8wTFEyekdERVc0RlpIalU1dEVZcXEwclg5?=
 =?utf-8?B?aysvQ3FGK0N0cHNDdTdDbjNLd3VoWU96MVlMbXBoVEZXTThOWWtudEY2Z2tR?=
 =?utf-8?B?cWN2LzRVcnJjUm1TUE02WloxblBXck5QM2J1ZnJLcmFCKzZaSWxXN2ZHbnZP?=
 =?utf-8?B?NnlGaWt3cUdKUmlKZE1qVDBOM2R0b2FvczZ1VjZoRDBXczdVek5LeXJlcG04?=
 =?utf-8?B?RmxQWUJmQXErVXZJZnErMzExMDZRTUpOM3BXY0MvSlFoSUFua1dSNExnL0Q3?=
 =?utf-8?B?TkpnUFVJNlNUQVN6MWovdnphQXJ4V3AwMkVCYVJHS0VLQ3ByRlRvTEpTemx6?=
 =?utf-8?B?QWZOZjBJZjc4d0tOam5GbmxKRVJDM1hlZEMvVEtKZTcxY2EzMW12UUU2aWJS?=
 =?utf-8?B?b1VvT1hjdDByL1ltamtNQ3lhY2g0Z1hRZDRteExrcTFyZTVMQkVMMk9qYm81?=
 =?utf-8?B?NWNObmg0VmJ6Y2NLaTZTVUNPUnFVZ3RWZEpTeDNaOFdjdTBmSzJHZDEwS3pr?=
 =?utf-8?B?SnJuTmRnd0xMZVp6QjREa2VFVitjQ0wvbWU4WG5iR3d2bEpBbWRBdzQvK042?=
 =?utf-8?B?RTJTaHZDTVNkMHgyekkzU3pxaGFQa3VWN0FabFNxVHVaNEJnY1ZqS21xMXRC?=
 =?utf-8?B?dHVqdUFCZ1RyczBRaVhwM2psSytvWFZMRSt2eG81L2xyVVpydmFtdVlMdnVr?=
 =?utf-8?B?R3pra2syNzQyRk9nMFRranRESFh6bmxDVGRXZnY1V0c1L1ZGYXYzalJ5QkNJ?=
 =?utf-8?B?b2dRYXplbGZ6NVlLcW0yYzRBaDNmanBtVFFpM1pYb2ZkY29nR2JhdDl0OEdL?=
 =?utf-8?B?QWFxQUd0bmlza3dPVlVsRDl3MmhvZEl5bXI2NERyazhTdVhLd3pXL0VQSlU0?=
 =?utf-8?B?MzloV2ZSbUZtWVNyMS9ud2JRVGl1eHlxZnYwTW5Pd0x3MnN2aFduREptcFFU?=
 =?utf-8?B?dm5SY09uaWhtSEo0ZWJkZDJURXhBSXFRWk4xR1dybFQrV1NrUHNLcWNDTVJk?=
 =?utf-8?B?QVZvR0YrM2pZcUcwdXgrcmdrTmdyZ1g5VWtreHFsbEFpWDNnVHdQRk5CMllQ?=
 =?utf-8?B?WGJtTU1VMCtOZEZCVWdBVVlDTVJjWUtRU0p1VVRHdkZJSW91d3RSZ0NzOUZw?=
 =?utf-8?B?cDBUbGJwUVFhVVFseHkzS21XT3NidmZSZGJoVkhkSVoxa0wvMU9YNGRRdnRK?=
 =?utf-8?B?SkJCbWhSaTdqNlBDdzNJTmJPa0p6eW8rVGpBODVpeDFyd0FsTlQyRGpJaVUv?=
 =?utf-8?B?c1U4SktWR2pzVSsxRmc1MHNWNnpOOG9OU1FyQlZIZDNlNWQwQ0ZuWFV2OEpZ?=
 =?utf-8?B?aFpZOUZnelFRU3NIVnJwaDhSaWdEUUc0ZmUrNzF5cndSUnM4TkRZTmdCajJh?=
 =?utf-8?B?aC9XbmwwK1dodCtJU3h1c21ENWVTSFZwckd3UXRNUkNoNXRGb1JWc2p2cjBS?=
 =?utf-8?B?Qnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ccbdfb5-633e-43ee-5819-08dad69d4288
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2022 08:46:54.0631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z83NfM/Z4MYjAnDCim/ulsDJpkK4BNe2RiBCyWAUkw55WV8fuAB3Exa00tUYTU+jFWJeZ3N8Fz7Y3wIo6pxeyvYHJ2AcuQyX9pBfb+IDguU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5571
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXRdIHJhdmI6IEZpeCBwb3RlbnRp
YWwgdXNlLWFmdGVyLWZyZWUgaW4NCj4gcmF2Yl9yeF9nYmV0aCgpDQo+IA0KPiBIaSBCaWp1LA0K
PiANCj4gT24gU2F0LCBEZWMgMywgMjAyMiBhdCAxMToyOSBBTSBCaWp1IERhcyA8YmlqdS5kYXMu
anpAYnAucmVuZXNhcy5jb20+DQo+IHdyb3RlOg0KPiA+ID4gU3ViamVjdDogW1BBVENIIG5ldF0g
cmF2YjogRml4IHBvdGVudGlhbCB1c2UtYWZ0ZXItZnJlZSBpbg0KPiA+ID4gcmF2Yl9yeF9nYmV0
aCgpDQo+ID4gPg0KPiA+ID4gVGhlIHNrYiBpcyBkZWxpdmVyZWQgdG8gbmFwaV9ncm9fcmVjZWl2
ZSgpIHdoaWNoIG1heSBmcmVlIGl0LCBhZnRlcg0KPiA+ID4gY2FsbGluZyB0aGlzLCBkZXJlZmVy
ZW5jaW5nIHNrYiBtYXkgdHJpZ2dlciB1c2UtYWZ0ZXItZnJlZS4NCj4gPg0KPiA+IENhbiB5b3Ug
cGxlYXNlIHJlY29uZmlybSB0aGUgY2hhbmdlcyB5b3UgaGF2ZSBkb25lIGlzIGFjdHVhbGx5IGZp
eGluZw0KPiBhbnkgaXNzdWU/DQo+ID4gSWYgeWVzLCBwbGVhc2UgcHJvdmlkZSB0aGUgZGV0YWls
cy4NCj4gPg0KPiA+IEN1cnJlbnQgY29kZSwNCj4gPg0KPiA+IG5hcGlfZ3JvX3JlY2VpdmUoJnBy
aXYtPm5hcGlbcV0sIHByaXYtPnJ4XzFzdF9za2IpOw0KPiANCj4gSUlVSUMsIGFmdGVyIHRoaXMs
IHByaXYtPnJ4XzFzdF9za2IgbWF5IGhhdmUgYmVlbiBmcmVlZC4uLg0KPiANCj4gPg0KPiA+IC0g
c3RhdHMtPnJ4X2J5dGVzICs9IHByaXYtPnJ4XzFzdF9za2ItPmxlbjsNCj4gDQo+IC4uLiBzbyBh
Y2Nlc3NpbmcgcHJpdi0+cnhfMXN0X3NrYi0+bGVuIGhlcmUgbWF5IGJlIGEgVUFGLg0KPiANCj4g
PiArIHN0YXRzLT5yeF9ieXRlcyArPSBwa3RfbGVuOw0KPiANCj4gU28gdGhpcyBjaGFuZ2UgbG9v
a3MgY29ycmVjdCB0byBtZSwgYXMgcGt0X2xlbiB3YXMgc3RvcmVkIHRvDQo+IHByaXYtPnJ4XzFz
dF9za2ItPmxlbiB1c2luZyBza2JfcHV0KCkgYmVmb3JlLg0KDQpUaGFua3MgZm9yIGRldGFpbGVk
IGV4cGxhbmF0aW9uLiBJdCBtYWtlcyBzZW5zZSBub3cuDQoNCkNoZWVycywNCkJpanUNCj4gDQo+
IFJldmlld2VkLWJ5OiBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0K3JlbmVzYXNAZ2xpZGVyLmJl
Pg0KPiANCj4gPg0KPiA+IE5vdGU6IEkgaGF2ZW4ndCB0ZXN0ZWQgeW91ciBwYXRjaCB5ZXQgdG8g
c2VlIGl0IGNhdXNlIGFueSByZWdyZXNzaW9uLg0KPiA+DQo+ID4gQ2hlZXJzLA0KPiA+IEJpanUN
Cj4gPg0KPiA+ID4NCj4gPiA+IEZpeGVzOiAxYzU5ZWI2NzhjYmQgKCJyYXZiOiBGaWxsdXAgcmF2
Yl9yeF9nYmV0aCgpIHN0dWIiKQ0KPiA+ID4gU2lnbmVkLW9mZi1ieTogWXVlSGFpYmluZyA8eXVl
aGFpYmluZ0BodWF3ZWkuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDIgKy0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ID4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gPiBpbmRleCA2YmM5MjMzMjYyNjgu
LjMzZjcyM2E5ZjQ3MSAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yl9tYWluLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yl9tYWluLmMNCj4gPiA+IEBAIC04NDEsNyArODQxLDcgQEAgc3RhdGljIGJvb2wgcmF2
Yl9yeF9nYmV0aChzdHJ1Y3QgbmV0X2RldmljZQ0KPiA+ID4gKm5kZXYsIGludCAqcXVvdGEsIGlu
dCBxKQ0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbmFwaV9ncm9fcmVjZWl2
ZSgmcHJpdi0+bmFwaVtxXSwNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgcHJpdi0+cnhfMXN0X3NrYik7DQo+ID4gPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBzdGF0cy0+cnhfcGFja2V0cysrOw0KPiA+ID4gLSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgc3RhdHMtPnJ4X2J5dGVzICs9IHByaXYtPnJ4XzFzdF9za2ItDQo+ID5s
ZW47DQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdGF0cy0+cnhfYnl0ZXMg
Kz0gcGt0X2xlbjsNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0K
PiA+ID4gICAgICAgICAgICAgICAgICAgICAgIH0NCj4gPiA+ICAgICAgICAgICAgICAgfQ0KPiAN
Cj4gR3J7b2V0amUsZWV0aW5nfXMsDQo+IA0KPiAgICAgICAgICAgICAgICAgICAgICAgICBHZWVy
dA0KPiANCj4gLS0NCj4gR2VlcnQgVXl0dGVyaG9ldmVuIC0tIFRoZXJlJ3MgbG90cyBvZiBMaW51
eCBiZXlvbmQgaWEzMiAtLSBnZWVydEBsaW51eC0NCj4gbTY4ay5vcmcNCj4gDQo+IEluIHBlcnNv
bmFsIGNvbnZlcnNhdGlvbnMgd2l0aCB0ZWNobmljYWwgcGVvcGxlLCBJIGNhbGwgbXlzZWxmIGEg
aGFja2VyLg0KPiBCdXQgd2hlbiBJJ20gdGFsa2luZyB0byBqb3VybmFsaXN0cyBJIGp1c3Qgc2F5
ICJwcm9ncmFtbWVyIiBvciBzb21ldGhpbmcNCj4gbGlrZSB0aGF0Lg0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIC0tIExpbnVzIFRvcnZhbGRzDQo=
