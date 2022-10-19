Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581A66050C4
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 21:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJSTv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 15:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiJSTv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 15:51:57 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11021024.outbound.protection.outlook.com [52.101.52.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE2D1D5867;
        Wed, 19 Oct 2022 12:51:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Op1958g+D2ax6ZeX2eCUxnHmxwCfbiPxpXF4CDRNSy/6mAv1V5zyMEnfPY/6JnHNqqeXd1ctfoaP1sOxVC/lTA+36h/DCKDVYNFVMlFu3/BtX8mYbqfLhxG7vjzYmiokY+ZPUnjmNn1FWVkbQ1t/84PsejqN48qwl1H9sPVo04H508qtNXzzfpUQpzk/vjN0eG8lE+Cf5weHvVgJ3q2IdUkH7D355kVl8/SJFOT/Q8u0kbBirdFO86XcNgYUAXf3Ty9BzZvvvR1FhPrL/Xvkk93myKk/MbjGTrgGKEQxokvx/8MxRxYYy2D08zBDjjwPt8jdlRJC3VYcnkMCjjAwRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zKbnEFR6E0AAdlQ5dR2049VJXE1gGIwGozRscz+KuXQ=;
 b=OCNqU4Mf3SVEebeZvLSrX+JxLhfgiLIXbnnSZlFK72I98UDKHCzZi9kfRl7We/WCkOxdKeRzESEK4qssQLTLTmwx7kAAnutiVwibhSRg55IjgDIdMK1Pu8o+qkp2at1KaLqxlJEwVIECBSWv+/onl+S9P1FL2scwtRbjG1gheRhMubt4F0/dGbj99RflVjdQ5xYoG5h7IYr9gVaDCb63aGW16QO8XlLx7hmzKQLfSrL+CBFIAxsx7WgORlXBO43RHE3Rt/owDcijRjvFVTRwICWxEHSylRO5NoqIxt64BINzogjSQpX1Hl5Ft5oSgbLhSWH71kFT7asnGpTf0HgvNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKbnEFR6E0AAdlQ5dR2049VJXE1gGIwGozRscz+KuXQ=;
 b=E5Ao8+dIPqJzHTVXUbjAHi/N7/lMYQgB4FzcCm4COBwiru9DgZ5tpQStzQwoButZy81OdVGMt1mHGIaeUgsooP60zyYF49lxDdT0Zy7t8mh9n8YteBE3sZUJVgOdGU3LIrENxu/DhHZKPmF+mWi5EbtT9W/AFqe0Zhn1piqr5ek=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by SA1PR21MB1301.namprd21.prod.outlook.com (2603:10b6:806:1e4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Wed, 19 Oct
 2022 19:51:41 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::7c3c:5968:72d6:3b5f]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::7c3c:5968:72d6:3b5f%9]) with mapi id 15.20.5769.004; Wed, 19 Oct 2022
 19:51:41 +0000
From:   Long Li <longli@microsoft.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v7 01/12] net: mana: Add support for auxiliary device
Thread-Topic: [Patch v7 01/12] net: mana: Add support for auxiliary device
Thread-Index: AQHY4l2VTutD6ZiBDEqvH/FFWFTxTa4VEWAAgAEQsOA=
Date:   Wed, 19 Oct 2022 19:51:41 +0000
Message-ID: <PH7PR21MB326302553E5EA7C55287B8E1CE2B9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1666034441-15424-1-git-send-email-longli@linuxonhyperv.com>
 <1666034441-15424-2-git-send-email-longli@linuxonhyperv.com>
 <8f23732f-8ee7-b120-1866-286503418d3e@huawei.com>
In-Reply-To: <8f23732f-8ee7-b120-1866-286503418d3e@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=42bd0605-d25b-4975-be2d-c6bdd7206988;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-19T19:45:52Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|SA1PR21MB1301:EE_
x-ms-office365-filtering-correlation-id: 3c20c4a4-11b5-4eff-58a6-08dab20b57c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kPAUpB8naEFz0k+IR8cfdOHXjUcjHZm5lzxJmXQHteGax1ozMXdVOe5pACSSRXCkd0yq1+94vwQh40ThKEyJyBy2KQl5ImnLBVYyPNks6Hy7V7jBsd/dqC7wtCcjry5pFF7CaPw4tED5Rpnm2mnLBXTcjUB/mY1+1ULf1ryzDODMsBrZk7BTVa6Hh05dpFlZBShjCD6esBrkHBkZwnMtwSkyfApz472mZUBZh5iQgHcso0yYJdqblydshCwOS9weOzcPcygq2USGHJTRAbxC7svmdTPKv88/ZPrr7n0bqkfvgXXnIqlIrwG+Wn/JL8MCAXhDHIwJ8fWxKZt3GgfIH74FBLHgSMBPb0BdbId9daZy0K/MQls/ZV4rEzzlz6+9LX/SO+HqWPBH5W8BfAg81QG9CckuLcytrup66ES5r0fkwEZH6PIEsRT4a+7JhFzKFugU/gf80R2ogkoz2mPDGHkS1XvAR9DfLxNOjErUREmOWtWKPhhMtoFmVPAXa/CiGHbzsA5xava8JPf23BzJO4U7WmC+vkhWZyy7JciL4gu2p/GfTCpL15lrM37r3exHdR8Fx8W2/Jo7JLH9oA6PVMkiIkBGbv/PGWYpii9OzDEwLRtLLQzZLAwXA7huCfPLNYUd19cshqIosdy6V0LDPjx9XC5jEoZxmHwN0wjBnm5+IJ+ZLvZeTodgLSmBdEfqjacwSw90ujf2ycX8kE3wZ77O32EJwGAGv6lEQM6BLZHUBUAjLz5E/NuL5xPgVqC9UoU/GVxtmgYnFJ25gGOcKeX3RZIW4PEG5LlWUmnA62qq++fT9TcbbUEmDYt7Ydmv5eUDcf3hTM8pDyazBtcZ7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(451199015)(122000001)(33656002)(6506007)(921005)(38070700005)(66476007)(9686003)(7696005)(110136005)(26005)(82960400001)(8990500004)(86362001)(82950400001)(8676002)(5660300002)(66446008)(7416002)(64756008)(2906002)(52536014)(8936002)(4326008)(66556008)(38100700002)(41300700001)(76116006)(55016003)(66946007)(83380400001)(10290500003)(316002)(186003)(6636002)(53546011)(478600001)(54906003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVdJQllnNytydHNtMmgvbmpXbSt1Sis0cXUwd3NVdFQxUlZJTXRZOGlkTEVa?=
 =?utf-8?B?ZXp1Rk0xRjhqSHJVK296QzFDMkVTeUFPT25nYWdJL3czVVpoZ2VZSy9DZFBQ?=
 =?utf-8?B?ZDliYzBrNHRZWWt6UERNSjhsTmZLRnZKT1FXRGxQSkVPK3JhYUdWZnZNNDFE?=
 =?utf-8?B?ZDNyNGwxczFVcHhIQ2NGNm9Pa3dVc0FtQTBkVmJOYm15QzhRV2ZTcXZJeTNz?=
 =?utf-8?B?UFJHeWxPVWlhcWt2VUNYdmpmdlVHeUZEK0FJaDB0cmVFUGVyTkt6dkNXeUZP?=
 =?utf-8?B?SVR4MEdWSk90MCtYR05ySXNVUHJ5Zjd4QkNpTXdXWkQwTTdqOVRDSGFWM210?=
 =?utf-8?B?YkFNcW4yYnh1SGFTaXdRczAxQUM4aUVaZHZqeWdpM2QyNzY0MDEyOGVjalRG?=
 =?utf-8?B?T0RCekxDbTlSazlTZU9sS1FabE1uYjhlRzFJWVRPMCtJc3pIYjFkV0tNdy9Y?=
 =?utf-8?B?R0xvRGdGUjZhbTFpRXBTQ1dZNjJkdWYyZEp2VElHc3V6NHFmRnd1SDFDdW5t?=
 =?utf-8?B?SnFLcVpkZHpmcm1JaFBhTisyS2U1MU5hQmVyZEd2RHlJVmdlVHRrSDhCNitl?=
 =?utf-8?B?ZGtjaHQrQ2ZHNHd5M1Nkc2M5RThhbXZHdUFsNUI1N3pQVmI1TFpVdkRzeld5?=
 =?utf-8?B?RHQyUjJVd1J4N0VyVzBWQ0U1RmxBSmZoRjNQUG81MWFHM2luM2pPNVlHK3Ex?=
 =?utf-8?B?NjVadGRuOTZQa1h3V1RNSHZXOXYyVFB6NmE3VWJVOW5SWnNadXdsY2lENXFr?=
 =?utf-8?B?dFF5QnlMeDZOSzBwWDV5ZVpvQVB3R0JHY0hWR0JWc09CNlk3Q29GMDJzenov?=
 =?utf-8?B?TXRvTU5Ba2NhekRON1J3MnJlUFg3ODhSUVd5OG9uN3BhT3kzd1VQdlNxVmRq?=
 =?utf-8?B?YmU1dGZKODF5aHJzUmE5TnB0SFAwZVhFazVXUXNHVUxYc2xiMVJUU2Z3MnhZ?=
 =?utf-8?B?OGVNUVpwejFtVDRrTXUxcm5pb042dVRQM2FydjY2U3NiTjBxTjVsSGt6UVpG?=
 =?utf-8?B?b0YxZllvZnF6RmhSbjh4TzFNWWtYSjdYU1hRbTBwNXhjMnNHLzhwdzlVYWhB?=
 =?utf-8?B?L2RVbEpxZkVCSDNKZ01ON3JKL2toTlg5bVl3MTdRTS9kSEFYbDhpb3FYYXdt?=
 =?utf-8?B?Ymc3RzFKQ2xJdnY3Q2VHM3JTMTdvczlqL1B5WVdLTFV6R3hMSEtMSDhuSHZG?=
 =?utf-8?B?Z0FkcWhTc0FWbFVZeXdwMXRpQk9FMzArRXFzYU12NzZsS296SFZDU0s3Wm5l?=
 =?utf-8?B?TTByTjdrbWFsYjBPQjltNHdUSktzT2pQUUxnd0RMK0Vna1FsYmtaZEMvdUto?=
 =?utf-8?B?eEJPZWhLRCtnZDdTWTFJSE95SjYxcXN4WVdnTlB3ODByM25tRjV0cTFjS0xW?=
 =?utf-8?B?SWlDQko0RHRwamhLZzExb0RkQ1RxZTdQVTJmVi9jVDYrSHZBK2FQNnZ1cEk3?=
 =?utf-8?B?bGhyNDBUSjRldWhaOS9QTTdFWXVUcFdvWVdmUzduaUQwR1U4U1pvQys4SXVv?=
 =?utf-8?B?VFY1aThkU2c1anhGbzJQUmM1blZ5eGZzSlArUzUrSGtnK1JvSDYwSmRZTzhL?=
 =?utf-8?B?L0M2azA5OHIzN2lwTHdCMjZuZnlOSmJmR0hjWjNzTHNINnd5SmYxbDRaZzdF?=
 =?utf-8?B?L2FrUEgyNytaMzVJOXp4TGdZUnpEdmh4SnZzcnVYaHdtNGV1ZTZ4eFJwcC9u?=
 =?utf-8?B?N2ZLWFdwSWIxM2s2L2FMdXRqT3N0N1VWZmdGQ2w0dnk3TU9TeUJGMFk5YlY4?=
 =?utf-8?B?V1N6Y2tBNlRRcGttaURRQnJZYUxuUU9ycFhxZW0zYnRkdExMeU5ST2ZMdExB?=
 =?utf-8?B?ZWtZd2pBQUxVa3RMVmp4SVVjL2gxUno1YWo1RlovYlEwZGdKcDlGU29JZDRQ?=
 =?utf-8?B?TXQwNUJDTzNnMmVsT3BVMGprYkRkSEUxQTEzV0UrTFl6SG5XSlBGMHNjUjhI?=
 =?utf-8?B?Y3FzZ1JlUUIydmpxV3ZqVkhSODlKVUoyd0k2alhCWDhpbzFrcnJMMGhKQjdM?=
 =?utf-8?B?SjFTRTJSenhFbFR2UXcvaW1JU2tkOUpnWFlOZnRsV1NkbjBwYmRwVGo4VVRS?=
 =?utf-8?B?TEpZcUlpUjRhR2dmd25URms1SkRRM0c2ZmQ3bXVKOFRTQXNqNHpRZ2NjenlD?=
 =?utf-8?Q?Fx3sheamxzFzXkLQ7SOGmgao7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c20c4a4-11b5-4eff-58a6-08dab20b57c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 19:51:41.2969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RuARHeDfKhW6SK9jpcN/f/RmPcXw3MX4j6SkY+NFylZhXr3T9ZUwLSXQo4lN/xaHBe/k3n1imlxRJ3d2buIGnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB1301
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BhdGNoIHY3IDAxLzEyXSBuZXQ6IG1hbmE6IEFkZCBzdXBwb3J0IGZv
ciBhdXhpbGlhcnkgZGV2aWNlDQo+IA0KPiBPbiAyMDIyLzEwLzE4IDM6MjAsIGxvbmdsaUBsaW51
eG9uaHlwZXJ2LmNvbSB3cm90ZToNCj4gPiBGcm9tOiBMb25nIExpIDxsb25nbGlAbWljcm9zb2Z0
LmNvbT4NCj4gPg0KPiA+IEluIHByZXBhcmF0aW9uIGZvciBzdXBwb3J0aW5nIE1BTkEgUkRNQSBk
cml2ZXIsIGFkZCBzdXBwb3J0IGZvcg0KPiA+IGF1eGlsaWFyeSBkZXZpY2UgaW4gdGhlIEV0aGVy
bmV0IGRyaXZlci4gVGhlIFJETUEgZGV2aWNlIGlzIG1vZGVsZWQgYXMNCj4gPiBhbiBhdXhpbGlh
cnkgZGV2aWNlIHRvIHRoZSBFdGhlcm5ldCBkZXZpY2UuDQo+IA0KPiBJZiB0aGUgUkRNQSBkZXZp
Y2UgaXMgYSBhdXhpbGlhcnkgZGV2aWNlIGluIHRoZSBFdGhlcm5ldCBkcml2ZXIsIGlzIHRoZXJl
IHNvbWUNCj4gdHlwZSBvZiBodyByZXNldCB0aGF0IGFmZmVjdCBib3RoIG5ldF9kZXZpY2UgYW5k
IGliX2RldmljZT8NCj4gSXMgdGhlcmUgc29tZSBraW5kIG9mIGhhbmRsaW5nIGxpa2UgcGNpZSBo
b3QgcGx1Zy91bnBsdWcgd2hpY2ggYWxyZWFkeQ0KPiBoYW5kbGVzIHRoaXMgY2FzZSwgc28gdGhl
IHJlc2V0IGhhbmRsaW5nIGlzIG5vdCBuZWVkZWQgaW4gdGhlIFJETUEgYW5kDQo+IEV0aGVybmV0
IGRyaXZlcj8NCg0KVGhlIFBDSSBwbHVnL3VucGx1ZyB3aWxsIHJlc3VsdCBpbiBsb2FkaW5nL3Vu
bG9hZGluZyB0aGUgbWFuYSBldGhlcm5ldCBkZXZpY2UsDQpJbiBtYW5hX3JlbW92ZSAoKSwgaXQg
Y2FsbHMgYXV4aWxpYXJ5X2RldmljZV9kZWxldGUoKSBmaXJzdCB0aGF0IGhhbmRsZXMgdGhlIHJl
bW92YWwNCm9mIHRoZSBtYW5hX2liIGRldmljZSBiZWZvcmUgdGhlIGV0aGVybmV0IGRldmljZSBp
cyByZW1vdmVkLg0KDQpPbiBIeXBlci12LCBQQ0kgZWplY3Rpb24gZXZlbnRzIGFyZSBoYW5kbGVk
IGJ5IHBjaS1oeXBlcnYgKGluIGRyaXZlcnMvcGNpL2NvbnRyb2xsZXIvcGNpLWh5cGVydi5jKQ0K
DQo+IA0KPiANCj4gPg0KPiA+IFJldmlld2VkLWJ5OiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3Nv
ZnQuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExvbmcgTGkgPGxvbmdsaUBtaWNyb3NvZnQuY29t
Pg0KPiA+IEFja2VkLWJ5OiBIYWl5YW5nIFpoYW5nIDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPg0K
PiA+IC0tLQ0KPiA+IENoYW5nZSBsb2c6DQo+ID4gdjM6IGRlZmluZSBtYW5hX2FkZXZfaWR4X2Fs
bG9jIGFuZCBtYW5hX2FkZXZfaWR4X2ZyZWUgYXMgc3RhdGljDQo+ID4gdjc6IGZpeCBhIGJ1ZyB0
aGF0IG1heSBhc3NpZ24gYSBuZWdhdGl2ZSB2YWx1ZSB0byBhZGV2LT5pZA0KPiA+DQo+ID4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L21pY3Jvc29mdC9LY29uZmlnICAgICAgICB8ICAxICsNCj4gPiAg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9zb2Z0L21hbmEvZ2RtYS5oICAgIHwgIDIgKw0KPiA+
ICAuLi4vZXRoZXJuZXQvbWljcm9zb2Z0L21hbmEvbWFuYV9hdXhpbGlhcnkuaCAgfCAxMCArKysN
Cj4gPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9taWNyb3NvZnQvbWFuYS9tYW5hX2VuLmMgfCA4Mw0K
PiArKysrKysrKysrKysrKysrKystDQo=
