Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA2B6452FC
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiLGE0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiLGE02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:26:28 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A8E53EC5;
        Tue,  6 Dec 2022 20:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670387187; x=1701923187;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pInThWlIo1MaNpC1dISLcToFM8xgmA5b696uQjx3Qu0=;
  b=FGdInGog5K6GhU9jQszspinjsUIx8A9T+KOfQghDvGwlYBC9VYD/5k3Z
   Mp4WWF3h8eFzUx1qOqtKwR6A7nikWD7D1bLESOYq5HINofq4U4z+0FcWo
   5008+FoMg6eWgA0T5B4SBLsXw16Anc0naFgte5TpdeFPoGB4clVmMjOFs
   Q37CUW3Ppt0DFEWA2X4e9QNdW0ehX7dItOtpy42rYu6phfYWzK5YtTeRv
   O6M5ILFNr5z8HqpZJN98sUd80bZGIjZMMa/IGU7Byb1BLJoyD9EFYrZKr
   SytxlaN2rDbR5mcsTqLgMT2HCI6m+Z7v0oUM1tV7IpFphAGjYa+z1yvl1
   A==;
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="192014215"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 21:26:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 21:26:26 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 21:26:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2VaggRzfdoid4UAQieOt9q17O++j2Zf7Nc9BGebdTQij8WYFkRn46v7W7qKB2b7BzxOsgE/Svv9QJWOqtrRlkVBVFYDnPZUEBQWhLtF/TSWPz6e3MeD+jRaf4dd0XGjeNJ0FZXRpYadjNc0DGxeZySlos14OuJpOrsSfYIC6DdEH1CVTmgJvCoPT+Y2i4/BiJxM8LsTN3W0u1j2teKWLF49PXUFuzEV48RJB1XYyRECE0508430LJd3tzNtJ6Yi7n5dWdfsyw/3EMvIwqVa9oZVyClUQFVWD00vPSa8tAhTqa/1FpAuCXnVwphnAtfHOGK+INiisfTMkmCEEUnz9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pInThWlIo1MaNpC1dISLcToFM8xgmA5b696uQjx3Qu0=;
 b=C1HMM3nTbK7XcZSmAbn3Oqv6cTZkqouLFQmdaQWZ5i1GIVNFv5/TU6+DoDbMjTUmJMOjnLddzVc9XYlx/RgGiK7mj/iOv+4/KobPAIwBm7CQjjVJ7U/IbyiomKWuzgMjFMOvsmK7kP63ZFbqlbdAuG0uZB75XSv2MsGP0olyJW9DbjGRHVz8rGNpfsrHCQKCHQkEL3SSN/77UgXvFQAUwITgZYDTeXW9A6YKOPbq6AI/AJR3sbjKFJCpHDxXkD+LCVku0Qq6puanedYtFftGlrUQDwFPirintAreyGj1a88EHAyYbR/vUZwXEFYK+xK1sZ6JeGjmO9DgOA7rXrDtYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pInThWlIo1MaNpC1dISLcToFM8xgmA5b696uQjx3Qu0=;
 b=amd/MIt0mfNffx6aBsnqvMZiGv1iJcupLAFjR2bz6qoLKHpvPwm3k5/AulzboPPwSq0x8DQ9NIr0TG7Lkg1k3hrrfZpk+QIXm3lr+mhkcepOGOarFo8yS+7BPtsqz68nXnNFMcVhtOaG1lueKrRZFVur6l10Co/PRBteGkGjL2A=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM4PR11MB5994.namprd11.prod.outlook.com (2603:10b6:8:5d::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Wed, 7 Dec 2022 04:26:24 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 04:26:24 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <ceggers@arri.de>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [Patch net-next v2 01/13] net: dsa: microchip: ptp: add the posix
 clock support
Thread-Topic: [Patch net-next v2 01/13] net: dsa: microchip: ptp: add the
 posix clock support
Thread-Index: AQHZCVNAKFnzaF6/O0a2gEung33QoK5gqtAAgAADFICAASeUAA==
Date:   Wed, 7 Dec 2022 04:26:24 +0000
Message-ID: <e981fd246439fe9b1237571a99514b7380391ba4.camel@microchip.com>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com>
         <20221206091428.28285-2-arun.ramadoss@microchip.com>
         <5892889.lOV4Wx5bFT@n95hx1g2> <20221206104827.corkkthxmypegja7@skbuf>
In-Reply-To: <20221206104827.corkkthxmypegja7@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DM4PR11MB5994:EE_
x-ms-office365-filtering-correlation-id: fc1f2f33-bf64-465b-f2f8-08dad80b3363
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0CF+vCr4Os/R8+PpMxqYO2Zlw/ETZD4oy7EZuvPkkVKs1eMQwU3U9OrLS+UHmGQYB77eD4DM9pSCQ/HtbiQJ4+vZQR957YNC+YDkcoGPN/QZIbT0Z1fGhyhvoqDIg1ZH0ulgsLjvHZOfjt64ANqv9EY1ApuWxGocbNnSDDxjoL8+PhrHQQzOriLCz84+1A7K7LTxP/7dmPXYlPdwiTF0B9NB+9t4Z8Qu8Zz0lpme4N8D6f8ulGxhVTVXyLfeD3fprwXeh9+1ESyJl5J3B7eGpvufQdvXYHfELwLx7zisdbQX+knGuFAyN5KOW4b1ILEWYdKqc1k5rcnWSSUbYKAnRQdmUyYVrMkGs/K2z8ggn8tmBAihr6fHUBTm21uvVDPmAGfQOlmcp5pp8qIDIVxXUUf2/agjMkgDEQJgZsTx/PTrexePidJBhH0qq2bKSvYnF1JMGpbVBPTNNQiStBYJBx9tUHlW04qUHtQbSGSiF4tMT8sXhPiA2sBXV1tZWZnJCH2Vv9aT5Fdw0ICMzS5OX6qyjv6C+5ma/joyLo+MKftFP+0BltauX/ECQLw9R+bxfSJ6wWkc7FUrwlikuUjVPZMECrnOGo5pzRw2bOsurp5cWOw1JkTJKSLyqQ/Xn7tAtsFJJDeXRaGmDca+x/iTz6VBtnTUB2m2zbDcpscXZBBC9IqOpRSdXBReO0B161hwH4DCqilcxVJUAgISaXBrBkEOAt+xi+EVJ71fMBMLWoI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199015)(83380400001)(122000001)(86362001)(8936002)(5660300002)(91956017)(2906002)(38070700005)(7416002)(4326008)(41300700001)(8676002)(478600001)(186003)(26005)(64756008)(6506007)(6512007)(110136005)(66946007)(2616005)(66556008)(76116006)(66446008)(54906003)(66476007)(6486002)(316002)(38100700002)(71200400001)(36756003)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3hiT2xvLzdBV3kzckxDWVFsam1oK29IWG9XSWNuNW5RN3VkSkNIeUFRMmNO?=
 =?utf-8?B?emhMVjU3bzBRZkFNQ2ZCR3QrUm15SVNoSjQxTkZyejRseGxoTmRBQnR3c29K?=
 =?utf-8?B?K3EwdmNWSG1zY3VjSVpRREpyYVJPN0tGN0kra2FOZ0FCVTlGVWQwR1l3QmtN?=
 =?utf-8?B?d2E4UEVsa0RSc1BML25sOXlYb3BCYmMzMkVXTEsvNkNhSW1RRHQvazZlWk1F?=
 =?utf-8?B?LzBPa0FOOFZEc1RodVNwWFRrYnYvbW1ydnp6aDFZbERJSDdTTlV6T1FEczlF?=
 =?utf-8?B?SHMyeEo1NXYrMXR3N1RWTWNqcXRSY0pydkN5REhRcmJyb0NXOXIzZnpyL1lT?=
 =?utf-8?B?RHNLZW1Qem9heGZTaXJRZy9tSXlMbzJwRnh6cUMxQ29WTzhIUmoyZDVvV2FQ?=
 =?utf-8?B?L0dmK1NibWVLK0kyVm5uZ2dUaFpzamtwaEd0RDVXRTlXc0p0Mm1Hak9kVExk?=
 =?utf-8?B?NGFNWXI0bDBEZFRvdHZWUmZycnNlVHVwUkIzQ0lLcTZZTWNSZHFkbmtZNjZv?=
 =?utf-8?B?K3Fzc1ZUVEJzdFR2MzZ5TGhuSVBZU2ZQTnZ4QmNBSVBqYjIxRktKaE55cHZP?=
 =?utf-8?B?ODhjZk15WWRTUjVPQUdSd2VpbER1WDBjTENpZ1loZ1hTYy9kdGF3TUY4UEpR?=
 =?utf-8?B?UHdpNTBSYUNCRjU1eXNxdzhNeWVRRS9KVTEzbGFIOTBQZC9QbGJmTjRLSVlV?=
 =?utf-8?B?S2JETTI2NVJSTElNYTVBR1htaEJHbjlhUVpPUVdGWHcrZ08rbHh5NDZObGRC?=
 =?utf-8?B?STh5VFBDR1BpekdHSlRwY09oWVVRcHFuRjdmVW45N1B6cjk0c2NDOGw0bjJo?=
 =?utf-8?B?bUJQSHk3V2w5SlZaTVRnbEN6Q2VhaEhkb0hpb3p1M1lRVWRSWVFvVHBoWVJD?=
 =?utf-8?B?dUxMUjBZcUZsd1NBa2RSSHREK2ZjbXdSbXZJaVNNYUJGT1l0bVRKWFNsZ0RG?=
 =?utf-8?B?U0YyUHJlYjZKMjBRUjF0VnFtMnViN2gyTStkZ1kwTEsrY3JSMFR2ZW4xN052?=
 =?utf-8?B?NktwVkhWaWxXVlN0YXhZK3Y1TjV6bThSejVDY2loOEZ3ME1nZlVsSmM1ZC9a?=
 =?utf-8?B?Q2xyazcwd0EralNsRDBScDIzYTd1Mmh4RmR4YnJJeTlyTG9zeEkzam9XVHhC?=
 =?utf-8?B?aHpzaGczRmg1a3l1a25iMmlHUE05MlFsWm1jS0Era01Id1IrSmxJa3JjRjRw?=
 =?utf-8?B?Ly9ZUFlyakJwRTVocGlNWFBiQTZUdjRhKytDeHJaQ1VNZ3NSeExBK3lEYmtT?=
 =?utf-8?B?dDJ6clZ2NU04clFRc1FQM0pDUUh2SCtDV0wzRm5Uc0JCYTV5Qlc1RHRoRFly?=
 =?utf-8?B?b2ZRbXNQM3ZwTWcraEoxOUo1WGdOcGdrTjgxVUREQkVuMXFrYUdRMjFSRnlr?=
 =?utf-8?B?VE9aZDA3N3laV3VEelo5UlYrc1d5c3lpTzBnN0MzNHlrMVlBMk9KdHVSNENn?=
 =?utf-8?B?eUEwdXpFUW02dzIwZU5TQlJmbThvcTE4WjNlZkhJSXRQcnRaVE5HTmlNTGhq?=
 =?utf-8?B?SE1MYzdIUjYyMHdKL0RHWnRSVDVPV3lSOW9tK1RZbENlUjkyYStGdEFtYUJC?=
 =?utf-8?B?Z3NUUHowY2E0cFJIWlJvWTE0M0FNUElhMmI2N2wzWEtlT3VwNDRwMjRVUDdL?=
 =?utf-8?B?SkkwSC9ZdW9iQitDOW1VdUIxNGxyMnpqcitNcW1qVEpUTHVKTUVydmpycE1Z?=
 =?utf-8?B?bE1KVGo2UlpzUG05N1pMTHd0ZWJkRVVBbzg1QnFRN2ZzckhlNEtmQzlRbzlZ?=
 =?utf-8?B?TVRXSDZxMnZSU3l3Uy9SUnFKV29LM1dLNmxUUVJQM2QzUFVRbUVWTGJBeFR4?=
 =?utf-8?B?OGdGNHR6aUxsMU4vZGNNbnEwbCtYdU9zcitrL1FuYkpPTi8wdlB2RWRRZFNr?=
 =?utf-8?B?RytyYjc1UjN6SVowZTBsenVGc0ZsRHdHbmdiU1Z4MTdKcmhvRzBuY0p4bkRP?=
 =?utf-8?B?S2NHa3FKclUwV1BPb0VlRW9OeUxIWE9vNThsOEx2QnVVTittNDNvNjhrLzNZ?=
 =?utf-8?B?MUErT2FYcElqaTdIQXBlTUNNUk1xQmVZeDcrNmp6aStCcDN0VUFWckt5bjBy?=
 =?utf-8?B?dXZuNUlLdyt5VUZaR09ESUJqL05lWmxHNUlIQ2lXWmR5VVlPUnEzUFVqTW1F?=
 =?utf-8?B?VFFFNGZsVGVZZmoyaHMxcFdnb2VvRjdMdFR4dmJXQ3dHS0FoaDBUWlpPQUdR?=
 =?utf-8?Q?oe1JfTOnb3A8Abfedqo2aWQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A53311C8AB3B648A327D0DEF0AD30F6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc1f2f33-bf64-465b-f2f8-08dad80b3363
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 04:26:24.4305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yRnd0I6Le8LmOIhmNgUsS2+puzrRhvRljZkRHWd3uOU6HgVwpdxFN1Lz28CXiKcsOV5xKNbm1iN0yMD/xGltU8MCmjSpHGKd6d1KiDQ8H3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5994
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpPbiBUdWUsIDIwMjItMTItMDYgYXQgMTI6NDggKzAyMDAsIFZsYWRpbWly
IE9sdGVhbiB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBPbiBUdWUsIERlYyAwNiwgMjAyMiBhdCAxMTozNzoyNkFNICswMTAwLCBDaHJpc3RpYW4g
RWdnZXJzIHdyb3RlOg0KPiA+ID4gdjEgLT4gdjINCj4gPiA+IC0gRGVsZXRlZCBzZXR0aW5nIDgw
MjFfMWFzIGJpdCBhbmQgYWRkZWQgUDJQIGJpdCBpbg0KPiA+ID4ga3N6X3B0cF9jbG9ja19yZWdp
c3RlcigpDQo+ID4gDQo+ID4gZGlkIEkgbWlzcyB0aGUgZGlzY3Vzc2lvbiBhYm91dCB0aGlzIGNo
YW5nZT8gSSB0aG91Z2h0IHRoYXQgdGhlDQo+ID4gZmlyc3QgZ29hbCBpcw0KPiA+IHRvIHVzZSBL
U1ogc3dpdGNoZXMgYXMgYSBib3VuZGFyeSBjbG9jayB3aGljaCBpbXBsaWVzIHVzaW5nIHRoZQ0K
PiA+IDgwMi4xQVMgZmVhdHVyZS4NCj4gPiANCj4gPiBVc2luZyB0aGUgS1NaIGluIFAyUCB0cmFu
c3BhcmVudCBjbG9jayBtb2RlIElNSE8gcmVxdWlyZXMgd3JpdGluZw0KPiA+IHRoZSBwZWVyIGRl
bGF5cw0KPiA+IGludG8gc3dpdGNoIHJlZ2lzdGVycyAod2hpY2ggbmVlZHMgdG8gYmUgaW1wbGVt
ZW50ZWQgaW4gYSBjb21wYW5pb24NCj4gPiBhcHBsaWNhdGlvbi9zY3JpcHQgZm9yIHB0cDRwKS4N
Cj4gPiANCj4gPiBBcyBmYXIgYXMgSSByZW1lbWJlciwgdGhlcmUgaXMgYWxzbyBubyBzdXBwb3J0
IHVzaW5nIHB0cDRsIHdpdGggMS0NCj4gPiBzdGVwIHRyYW5zcGFyZW50DQo+ID4gY2xvY2sgc3dp
dGNoZXMuDQo+IA0KPiBJZiBpdCB3YXMgaW4gcmVzcG9uc2UgdG8gc29tZXRoaW5nIEkgc2FpZCwg
SSBqdXN0IGFza2VkIHRvIGFkZCBhDQo+IGNvbW1lbnQNCj4gYXMgdG8gd2hhdCB0aGUgODAyLjFB
UyBiaXQgZG9lcywgbm90IHRvIGRlbGV0ZSBpdC4uLg0KDQpJIGdvdCBjb25mdXNlZCB3aXRoIHRo
ZSByZXZpZXcgY29tbWVudHMgbGlrZSBJcyB0aGlzIGJpdCByZXF1aXJlZCBmb3INCnAycCAxIHN0
ZXAgdGltZXN0YW1waW5nIGFuZCBhbHNvIGJlY2F1c2UgdGhpcyBiaXQgaXMgbWVudGlvbmVkIHJl
c2VydmVkDQppbiBkYXRhc2hlZXQgZm9yIEtTWjk1NjMuDQpXaGVuIHRoZSA4MDIuMUFTIGJpdCBp
cyBzZXQgaW4gUFRQX01TR19DT05GMSByZWdpc3RlciwgaXQgZm9yd2FyZHMgYWxsDQp0aGUgUFRQ
IGZyYW1lcyB0byBjcHUgcG9ydCBhbmQgbm90IHRvIG90aGVyIHBvcnRzLg0KU2luY2UsIHRoZSAy
IHN0ZXAgdGltZXN0YW1waW5nIGRvZXMgbm90IHdvcmsgaW4gS1NaOTU2MywgdGhpcyBiaXQgaXMN
Cm1hZGUgYXMgcmVzZXJ2ZWQgaW4gdGhlIGRhdGFzaGVldC4NCkkgd2lsbCByZXZlcnQgdGhlIGNo
YW5nZXMgYmFjayB0byBzZXR0aW5nIDgwMi4xQVMgYml0IGFuZCBhZGQNCmFwcHJvcHJpYXRlIGNv
bW1lbnQgaW4gdGhlIGNvZGUvY29tbWl0IGRlc2NyaXB0aW9uLg0KDQoNCg==
