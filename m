Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D72F675239
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjATKTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjATKTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:19:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E83A4617D;
        Fri, 20 Jan 2023 02:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674209980; x=1705745980;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+77sCp/LhxIJHFv1Kdq1erHw/KSjZg3FLjKNFBKbYJc=;
  b=DXHBqLoxPZqg9xT1XU6R6+JkT8v6cKuyEkzoVEGnY4roQTzrXVVqhzb+
   SXp6i/F/wr8/1/+rQGvEWSha0u0UcWHKEiNUtA/ob96N3HymZf5ilJiUm
   gC7O5bibPfCBHQmDCueyxvwIjztQpq3vVWBqnMh1nF61tZ9sRfRU2mxLN
   4/UXYNeG41t6/tN3XMS0o3E+B2NWI32NRRZQ4AAfcnAnHr4oWivD/MNkw
   9kImG8GTbICeiRCUoTYgh9pXyYoRaS+LQ/PjT1n/Ma9KdCJtd9Geql6LI
   seH1STBsU+jy3E9s6bU/mSeaJ135MxoZpZYnkNmlsm/EnWbUQOpqVXZXv
   w==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="196677180"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 03:19:36 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 03:19:35 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Fri, 20 Jan 2023 03:19:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fL5/VIQkQrGwZTCW8+aKqFM7JuaV8t4NG9EE+q4znpxUYbi/oWRpEDrPDlXjlFe19Q/EIVtxM4xE4bx0ZZ8oZmHTQvakYDH932VcfNAH8xSxAg32cqNgWHAMKVacPYEZKX/+ygJLOHwRjRTqrV8Ztpy+iwjaTXdu+47SjZxS8PPM+xAbQPdm6Fm+mL1zbZKzCj9h3hsrNdcJq2AmWf3k9/+BrhTiq4SBPz2EVCR3qJIDIgTH2bnPPY9ldHb5oQLv6EU2mjHPQUItRClfjscALDcvXliOtYx2So/5M/6v42PrbkbJf1yQfS/ZA3S/BbHJwsQm4cWIDqTtHzn++jkanA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+77sCp/LhxIJHFv1Kdq1erHw/KSjZg3FLjKNFBKbYJc=;
 b=e4PIfhIhT1sSOVghOeznUHUrZy+RuUPLqZoULQsLfDIqH42q8h1vxubi1eRtZZI8rKMIllu2REl7JvKkKgzns2PB7yhCNDEqUyHXgrG+IjfUIkzMAgMmuqmHaIBP0y0M+txhgghEuHfD3r1DJmZcodJ3fo2JSFsETSpuatw0Efn4j15hRgn66U0NZu43dQoNU8N8D7IzM0gKBlbqRlKCHmE9FOCjuG0KRRPtXaG81rcqW5caeltHCJ/GRV+zFGmJtM/QU0mOMpNsLYtEi1AuYQ23tSDHWPfjzBhKvhCs26+Qi8yw3VGID5RIi1vxivrEH9UXOfcrKXN29d8jOMW53Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+77sCp/LhxIJHFv1Kdq1erHw/KSjZg3FLjKNFBKbYJc=;
 b=mx/HKiBDAmqahZatB4fiiJgCbxy1p2pYHQ8DScTmSUrhs1TJUv83dhukxX4Ii2HW5xPVWHnGkAjuW/HcLm5cM6TCV8AcEGD8okRUjzB+/Z+qsYpmtwzN540PbYYTAWwDm+4A5Bko26MnhCH+nAd46aeZssd1zdUfuEvWFfgEuTo=
Received: from MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9)
 by DM4PR11MB5342.namprd11.prod.outlook.com (2603:10b6:5:391::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 10:19:33 +0000
Received: from MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::8ac6:8219:4489:7891]) by MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::8ac6:8219:4489:7891%8]) with mapi id 15.20.6002.025; Fri, 20 Jan 2023
 10:19:33 +0000
From:   <Rakesh.Sankaranarayanan@microchip.com>
To:     <olteanv@gmail.com>, <kuba@kernel.org>, <andrew@lunn.ch>
CC:     <Arun.Ramadoss@microchip.com>, <linux@armlinux.org.uk>,
        <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <Woojung.Huh@microchip.com>, <linux-kernel@vger.kernel.org>,
        <f.fainelli@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net 2/2] net: dsa: microchip: lan937x: run phy
 initialization during each link update
Thread-Topic: [PATCH net 2/2] net: dsa: microchip: lan937x: run phy
 initialization during each link update
Thread-Index: AQHZKZH7WZopBqu86kymmreIhwsr3q6hn/+8gAQA9ACAAGKgAIAAAh0AgAEYyIA=
Date:   Fri, 20 Jan 2023 10:19:33 +0000
Message-ID: <399c5e0184c9e32ece951f63bfe9d865db290851.camel@microchip.com>
References: <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
         <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
         <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
         <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
         <20230116222602.oswnt4ecoucpb2km@skbuf>
         <7d72bc330d0ce9e57cc862bec39388b7def8782a.camel@microchip.com>
         <Y8l9mMpiFSHTt1iU@lunn.ch> <20230119093526.40dd03b0@kernel.org>
In-Reply-To: <20230119093526.40dd03b0@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6088:EE_|DM4PR11MB5342:EE_
x-ms-office365-filtering-correlation-id: b0c09b8f-b332-44c3-751f-08dafacfd32c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ga3ND8fxw9FR3J0gmrk9dcFYtmAVq3wyCnG63+dfvAhockgUK/UhdGS2fW0+MSiU5UnTEupK9H/9WjaeGs/QBEYuVAfm+rqK2SMAd5WHbRldK3eVudeC0Jmo8y1MRxYz1b95VtLUQhW7S1ayYKKpzClqKnSwpJ3zcw/Gs4ggwiK5iG1tZ9FLXWQsciMBge8FBNhphmcOhhtCb0+G05mHmkD9Zfp1uFYOgEp7RoiULTxpQ+MS0CWjjo8z7PMSRxi7wxXJZh5Tj6R/KjY/VOmoeS+kttdWUEw2sXkocP1nSRYjG0OHwp1rlThK0Dox/yIWauXevmvJBQLZ8ix2QwUF6WxJGLAtO2NpJNcluTCv0pOt8w7g0htWJCqdRu165zvQ9nwRnkNsUapcniAS6QxKaElRaAw4oh8EtioQIXaw+EkkxMVQGm7WmmyZBYGMM6HZT5LdkQxtqKY0xIgm8TGCt+rjWIEhDg18n+7a9laXu0inF4P8ZmuQz4PRWgf4cNUOEeoGMXU3bZx3ivns0JtrkBHRvqDQxkgCcygDlftayECqIDoqOgG4nNZt1A373MjsnsZb7A/0/Kw7FQNkQqVlZbmD62x8fiZcuAolukeb+FxGkaGMs01NE6Sr+XUwsuZUUPCO6bOFIpMGVVHIIWXJiaRUUNnjzLIwHRF2VO3efpvtRuAUk7GijnTGCoEcGVrJgTQzCjOf2bWJt0HRrGK/ng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6088.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(5660300002)(4744005)(8936002)(4326008)(7416002)(66476007)(66556008)(8676002)(64756008)(66446008)(66946007)(91956017)(76116006)(71200400001)(122000001)(38100700002)(6506007)(2906002)(6512007)(26005)(110136005)(54906003)(186003)(6486002)(36756003)(316002)(478600001)(2616005)(41300700001)(38070700005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFlQd0RzNTJ4RDVPQ0s2U3Jua3p3bCs3MU1lVVV1dW02UHdtWC9hVS96YjRk?=
 =?utf-8?B?MVNrd3UrQk45U2I1WlBzTVdvVUJnOXBEbVhPTFdBaG9GRjRYUFgrVFVDQkFC?=
 =?utf-8?B?Mnh0d21qdmNiNldvV1JxZmtwVVdjQzhaUUVXUkV2VjFPZ25mV2RNVk55dStY?=
 =?utf-8?B?QXdyZW11L01DNUJuZmw3MWtLWG0yT1NvOElacG5GaVRvODRDTkVYOUY0amtQ?=
 =?utf-8?B?K0pYT2ttTWUrRnM0UWdjQnpmMmZveVNncEVvQ1h6NnhOT0d1LzFVQkxrTTZ3?=
 =?utf-8?B?L3VpZWtIZzZiVFNGNWxVSXk2aVhsd2k0Y1VjUnFoMXUxTk5UN3ZuSER2aStx?=
 =?utf-8?B?bm1rNENBbklseUxGOFJaVnVNZjVCaFpGa3JBMjhOZ1FDUHF6Uytwd1FaQmMx?=
 =?utf-8?B?OUUxL0VGVEtNYXV3U0NvZVlqZUxOT25uallqdGJuM2RCd3EwVUpKKy9NVXQz?=
 =?utf-8?B?RTh0SjRkU0doTnBIVXJqM2hDMGlUN09MUUNUZXpLNWtIbXZtMHRoQ0JOaXkw?=
 =?utf-8?B?c1NUVm0rVE54Ukg5N0hXTTVlU0RySnlyV2pBakhuVmlGUVNGcnluY0VSTHIr?=
 =?utf-8?B?M3FqTFpLNEZuV0tPdVIrRmpPUkFmcjNHa1JnRWJud2VQQkVVZU0vcThJd25H?=
 =?utf-8?B?MjBVOTRMVGFGcm5nZStyeWsxVjBQRUpjZzZPTExhMmZTa1g1SWp1WXo0ODIr?=
 =?utf-8?B?TCtLbDF2ekx4ajlWRHFxa1FmTk9zcGpoSWVEbXJyTWJCVndGdit0QWc2ejlD?=
 =?utf-8?B?WWtKcUVoVmpZUGhoQ09PaTErMVFwMlgyMTBhWUFHVUdSWldRV0JjZDJldTIz?=
 =?utf-8?B?T0Q4VzFrVERrR3hCS3JCSldweXVraUtOVjB3TXRWUFRTYmJVaDBuR0VVWENM?=
 =?utf-8?B?Y0NZeFFqdFhvQkwwSjNaVEh2cWNwalJxYmphcExNWFJGMUt1R1ViUGRMc3I0?=
 =?utf-8?B?cjlNUGxyeHQxeUloWm1yVGtiRWtjK2VZbWNsN3FzaWJYMitWdDdJZUdRRU15?=
 =?utf-8?B?amNpdkZ4K2MwSTZuckEvMUU5S1NKbnA1a2NEa21nclZHWU4veXdza3FFRWdB?=
 =?utf-8?B?a0h3ZHorbFdIRFA0eTdwcm5zL1RoQ0hVT2ZPRHA2ZEtLaTNUTTN5b0RGK2o2?=
 =?utf-8?B?a3VRNGhMQysyWDRRZEg4eld6UDg1NXZqMUFYazFWZ21kaERyT0I3b0w1UXI4?=
 =?utf-8?B?UDVRSmljTnZ4MWNhUm5lSHNNQndFRlI1STFzYXVVTVBrVStxMmE0TXFSKytG?=
 =?utf-8?B?YWJQVDFIUFJIaVpHV3dEWW5NTE9oWlVkMldud1YwS1loc0xSRWZjcHBVRVVz?=
 =?utf-8?B?L29VSk44OVl0aWQ3RytCSnB5VzNmeTYyZFZrd2p5Z3Z2TzhqTkdHU2cwKzc0?=
 =?utf-8?B?MWJlY1NvbnZDUU9oUnlnMDdEL0t6bkRsbGpwRG5MWGpzWWxDV3pyYWdmbWdo?=
 =?utf-8?B?aStmRWR1VUpvWUVoY1haeWk4QldDdW9FUFlUYVJqdG9EWWdYTXYrOXZyejJ0?=
 =?utf-8?B?ZEJBOGYxbVRTVkRvQ3BYajRPQmF6Y051Y21sdHpOZ3Y2eVp4NzM1UHROT2pX?=
 =?utf-8?B?YklmTHFyTHB1amhyMmRRZXcrT0ZoVUJFWWxlcG52R1JUcUtqRlRLTklybm40?=
 =?utf-8?B?SktjbzNvam5RcHRsZUg5RlBnZXVVdHlMZHRJZEVpeWl0bFo3MVl3aGszTGpy?=
 =?utf-8?B?NXhzSHVMMEYxM0kySW9NOVlIYm5pOGxYWVdGajRrYnp2b3BibXJlTkVxbjkv?=
 =?utf-8?B?WDZyZkFJeVFZeHF0cnRXZ0hDQWQ3a09FaHdCZXc4dXoxck82bjI3amY0Q3ln?=
 =?utf-8?B?VXFIM1RKdkxyMCtLMTZBams5NEFSNi9JSmNkZG52cFQzQnpXMVpSc0QyK3dQ?=
 =?utf-8?B?Z3lRcHpEVEt2YTVmTng4dm1sWVhkRWRKRFpvTFlzaExSUDd6RjJiWHFlakVQ?=
 =?utf-8?B?TGp4VDdVZWNOZXpldFZuN0JnWTgyVnQwbGg0bnpLaHZKTHZRR3Fmbmo3V3Rl?=
 =?utf-8?B?SVFCMHJHdWk4L0ZZa1AyODQ5c2RWZzhmbzJobklRVXdMbXNkc3ZmZ3FKZkVM?=
 =?utf-8?B?NnJQanRFM1NBNTVpNkZoWElHM3NXdjZ0RDNsV2N1SzcwbUJmNHpTb25PSEZl?=
 =?utf-8?B?NGx2NWxYZFhXWlFzbzlYR1RpOWFYZnp5UVkzT2F4cHRYU055Zit3ajUxUHNz?=
 =?utf-8?Q?+dCQafb55zlT0oUi6nDJXgW8Do46LUfwqmpJvic0UHdE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <20D95D6535694B4C9FED98ADC388B1B8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6088.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c09b8f-b332-44c3-751f-08dafacfd32c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 10:19:33.3958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g2uqNIR+TAwwhf7JZJSOt+iKPD4zqAXR8WEuMwDgzPide0QCRpSmbuEyNZbS+wZnW2WsK7X1D7wDQqsp/aQUUaFLzR9cqT/y/evBxwmahKzQt/4s1o34AZrOTth1cdCb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5342
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIFZsYWRpbWlyLCBBbmRyZXcgYW5kIEpha3ViIGZvciB0aGUgc3VwcG9ydC4NCg0KSSB3
aWxsIHJlc3VibWl0IHRoZSBwYXRjaCBvbiBuZXQtbmV4dC4NCg0KVGhhbmtzLA0KUmFrZXNoIFMu
DQoNCk9uIFRodSwgMjAyMy0wMS0xOSBhdCAwOTozNSAtMDgwMCwgSmFrdWIgS2ljaW5za2kgd3Jv
dGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2ht
ZW50cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gVGh1
LCAxOSBKYW4gMjAyMyAxODoyNzo1MiArMDEwMCBBbmRyZXcgTHVubiB3cm90ZToNCj4gPiA+IFRo
YW5rcyBmb3IgcG9pbnRpbmcgdGhpcyBvdXQuIERvIHlvdSB0aGluayBzdWJtaXR0aW5nIHRoaXMg
cGF0Y2gNCj4gPiA+IGluDQo+ID4gPiBuZXQtbmV4dCBpcyB0aGUgcmlnaHQgd2F5Pw0KPiA+IA0K
PiA+IEkgd291bGQgcHJvYmFibHkgZ28gZm9yIG5ldC1uZXh0LiBUaGF0IHdpbGwgZ2l2ZSBpdCBt
b3JlIHNvYWsgdGltZQ0KPiA+IHRvDQo+ID4gZmluZCB0aGUgbmV4dCB3YXkgaXQgaXMgYnJva2Vu
Li4uLg0KPiANCj4gRWl0aGVyIGEgZml4IG9yIG5vdCBhIGZpeCA6KCBNZWFuaW5nIC0gaWYgd2Ug
b3B0IGZvciBuZXQtbmV4dA0KPiBwbGVhc2UgZHJvcCB0aGUgRml4ZXMgdGFnLg0KPiANCj4gRldJ
VyBHcmVnIHByb21pc2VkIHRoYXQgaWYgd2UgcHV0IHNvbWUgc29ydCBvZiBhIHRhZyBvciBpbmZv
cm1hdGlvbg0KPiB0byBkZWxheSBiYWNrcG9ydGluZyB0byBzdGFibGUgdGhleSB3aWxsIG9iZXkg
aXQuIFdlIHNob3VsZCB0ZXN0IHRoYXQNCj4gYXQgc29tZSBwb2ludC4NCg0K
