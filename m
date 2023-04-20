Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FDE6E89A3
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbjDTFdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbjDTFdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:33:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BAA524B
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 22:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681968761; x=1713504761;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7U46dcwj/UDQlH95RaU4srkpOndvN0m8+AsHMdj97mI=;
  b=mojDpmvURTt/s5a/SQG38hmYg4xUQYCWIRf4YiWDL6QuXgFXVt+fKlXh
   +48ytB/d075OmbRlAM7yBF/s6NaB89qYXyP/TFZ/OxIhewN6/YxNgiubr
   Hh0lyi0ky2/zzXCZPhHibmcUQyCvpkkExxLwF77hcyGvEhfi1smwnifkI
   7FUUTidsYrKbESW1mXqzF/jU5KB23t6JkDFpntn6XexKFrPSRz4X7JtZN
   cBHyGdzhSWoknW+lVF9NYDOTqnEKRo3yxPJau3f7gPV/65kF4V2+e+F8P
   FwEWQ4tYjoSrKVMbAR0jVdYu7Z02HeEN7+hIEIwat8Op9ifxSvSSkrCrB
   A==;
X-IronPort-AV: E=Sophos;i="5.99,211,1677567600"; 
   d="scan'208";a="148001525"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2023 22:32:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 19 Apr 2023 22:32:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 19 Apr 2023 22:32:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsFs58ZHH4vcB9NRCPsm5K+0G6ch2fRcqyw7gRDibzYv5O3Ie3jlH4U+RhI7liynnnWvzfIYItnQwfd7n0ji4QI01ufO5EkgirlaXwsE+xyH4yYmxeeN8xUmbnipmJpCTfQyc9K97Ppp9vnhX2hn/jcQK4Ym6q2VDRYkkSTVQhUQz8Q3XKaPWf+x9zWgAQsSaLrlfutHhoMAKftqYeORlcKzGDyBKu9Z7lUOzD9aPI5Mk6no3mYMkYZeHbJp6k6rvody5YGwescIoPhpjCSoWS0QIkNxL3N1H/QhgW4g4ruiDfQCX3Lgf27eTZ/sb9l5fNz+hnhWTcszuXfAZWRUAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7U46dcwj/UDQlH95RaU4srkpOndvN0m8+AsHMdj97mI=;
 b=djFOm/tyGWpcCWgk8xlNZFwQQDO38g0fv27TL3k2bKSrec7wnX2pE1lP4wbs0e0BRhBGf0Bmk5/dclfLDc1FN9ClunbnD0RVMD0tcM1N0m5nlOjOG79Nb1d/108tCJ0vIAuwVl26IUw/NKsAVjsq3ySSojXO3q34sdiceKT65+7RhBIHs0pAo41+COL/P8hJyQtvfAttrxkjU70xltzij8SBDqwS0Y5nusOc5OsD0TyQUrpnDZMTFhMejEvDTQokDy7M3+KhP+Nz6D/SdovwzYO0pHN50aL9klabGPW0NtW71jE5slTKR2Rvk7zWX0ZtohfwAuMyna4F+97UZTIOGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7U46dcwj/UDQlH95RaU4srkpOndvN0m8+AsHMdj97mI=;
 b=r/LpaoKItqoIafZ6Gh4Oam08KLDq8PZIyqtGHsPGpvxzGZK+Ph96rsBFax/Ea1FBTOwbsuyoSguPn1kYXsGYHnEKUnDBFdHyFo5s9pMCveAdwn1j/LvQhanNvTahXnXhwUxQnpfFcdjqV4grLDkJFiH6Snk8KG6qXm1ifx73f+0=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 MW4PR11MB6689.namprd11.prod.outlook.com (2603:10b6:303:1e9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 05:32:33 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::1c94:f1ec:9898:11df]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::1c94:f1ec:9898:11df%5]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 05:32:33 +0000
From:   <Parthiban.Veerasooran@microchip.com>
To:     <andrew@lunn.ch>
CC:     <ramon.nordin.rodriguez@ferroamp.se>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Jan.Huber@microchip.com>,
        <Horatiu.Vultur@microchip.com>, <Woojung.Huh@microchip.com>
Subject: Re: [PATCH] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Thread-Topic: [PATCH] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Thread-Index: AQHZch60FAFhEuZCEEOymhDDWGLMLK8ytcIAgAAIDYCAAPEwgA==
Date:   Thu, 20 Apr 2023 05:32:33 +0000
Message-ID: <e8f98365-d542-d3ba-d2b3-0903a3e7cea7@microchip.com>
References: <ZD7YzBhzlEBHrEPC@builder>
 <9e5da8b1-bd47-307c-da75-580df4d575f6@microchip.com>
 <83ee7ed8-87a2-4581-99c2-5efd4011257a@lunn.ch>
In-Reply-To: <83ee7ed8-87a2-4581-99c2-5efd4011257a@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|MW4PR11MB6689:EE_
x-ms-office365-filtering-correlation-id: ae76e3f2-17f6-402e-3ce7-08db4160a446
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sFRkQZsAQBnhos5/LZ9MH62juwcSnCgA92v4JvKWkw0xX3T8CzH7+6dujWc5YzUDQSFCyG0xm3UzoJM9PNe+934Lh/pU+bNiK4pPCYthruDaDqD9LsUwiJ+RWvqDIsyXWszdGAJlwtEZGc3lK+05urkg79rF4Tuo1QeQuuyprouZIvyfClt8Tx4r+hEscdry2DrC52UjV1z4dwEK1TrGcKgnp4+oVWcAMDyLTdYVXFBezI6G20dzHdSoCusQ0Q84wosGiIfVDtYihH4tv0ixXOqdTPC5+kJYWFWtBZPrf/CttZaCYY9WZTLagC6h4c5WJSdtE2EJoPjNeJ6+ACPgCvmlfgiwkTS24feYzrtEZncQseF3cxSMCRUdSmcKygichhu/G19+guX89+1Njj123Y+t8Db3kp91fD1g6beCvRF9hWc3Je0NueoXHjHfoxuR7es0Wd0KfCmSO0JfDaVOoC6KiagGR7alSCcoXHWmjIksqIVjWHjsGd9s9LD/QqNLKo3fuDlNnAVEU+Xgt7nU4nJqvlV9c4KacFL22M6X0AWpFprDrW7kc9Z+8HGZd3p6UovS3AXMpoD1JRYs5ogT9LrAjR2Wbplp9FHGn8o1leyPLZfBd8cMEePCDtAgJaDFuyXwzoDUqGM2lt/ge3XCsCbVmUXbwJCuaG22ajrsH0Uv1XtxyhV0xZXko8DSNiz1JgI/ZXGUSnzJKmIP1OGWaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199021)(66899021)(31686004)(6916009)(4326008)(316002)(54906003)(966005)(91956017)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(36756003)(186003)(53546011)(6512007)(6506007)(26005)(107886003)(38100700002)(122000001)(2616005)(83380400001)(5660300002)(41300700001)(8676002)(8936002)(478600001)(6486002)(71200400001)(86362001)(31696002)(38070700005)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFcyaDU1VkhjL3RIczBFZEpDZThrZ1QrQURtcStza2FNZmhNSEwwNFRQZHpt?=
 =?utf-8?B?cWhnNDgxZWY1RkROUll5N0tEbDVUZUp1bzNsQWFBbzBxUkFiNDI4R0toa3VH?=
 =?utf-8?B?cGUwU2xiRUdYNTYzL2J1NDdVTmlENmlVOFM5Si9PdnNhNnFuS056V2cyeUFU?=
 =?utf-8?B?clkwOFFnOUlRS1FGYWVzQXRSN3RZUmxVY1J3dE9RSldNZ2NoaDhhR1pOVEVY?=
 =?utf-8?B?cFpUekgyTDRXVENlWTVjUE5EbXQ4NVpCTldvVmVlaWxyakt6U0o2QkZYYjBM?=
 =?utf-8?B?bUNWNzg1V3daZE9NYXY3OFQ3aDNaYU1CaFZHenN1bXYyZnZseXkwOHZ4c3B5?=
 =?utf-8?B?M1llTW9GNkVIakFJMnZablZDUThxdmdLL0ZjaEs0RjY2NzZ0NTUyNi9kTDVz?=
 =?utf-8?B?N1NTOW1UbTNvbWlBeFU5N09QVytSTC9CeFJCL0xEd2t2d3Q3eHdPbVRYSWVB?=
 =?utf-8?B?enoreG1za2dFREFoUFdBQ3k4VjljVTNTQ1FNLzhYckFiMFNYZjVPdVpYQWE5?=
 =?utf-8?B?bE5Gd1Rla25xbFQ5QUduemEzVjM2bVlxVVJxK2E3VnZ3enJGMXBUUXVaNjdQ?=
 =?utf-8?B?dWh5ZHAwN2FBT0FVZDhaOTlORSttd2Q4d0QxNDVkREJEdnZnUE52ZHRYQys0?=
 =?utf-8?B?bk1mNHBGOUtZWmxRL2Ryd3d3VGloWXdPMVhXWnRvY0EyRit4cEU0MCtPbDFX?=
 =?utf-8?B?OFZabDhLNW90Ulo3N2hqbVByOEw4MHA0R1RvbkFLU0VMTEpPbEdMU2Q3SDZY?=
 =?utf-8?B?dUxnYXhWSHlTb1RTTjNPVTFIdHhSR0JCc2lEUVZ6dnpneTBKSjZPVDZqWFlS?=
 =?utf-8?B?QkRVTVI3WXJaNVIwbHY0TkZ3TzhjN2t5ZU80bk1neHNZZlQwT1JmQ2l1ZXVQ?=
 =?utf-8?B?SkNxOUVNek1mdkQ0a21mQmxvYnBDL1lWUHhmR0hlL0NPRXNjS2NWRERya05H?=
 =?utf-8?B?UkpFRUM5MTFkRTg2Y2d5c0FwNllWOFpSQkRyZDNtcmpvNXBvRFVmdWFYdndG?=
 =?utf-8?B?Sm9iSXM1L1lXNndQVDdRczVzemVhaHdiT0FkTkRwRjBsd0VTSTY3Y2FjQ1JW?=
 =?utf-8?B?Rmg2bVphNTRMZzVBNlFKREhsZWJBYlZid0UwWkE3ZjlmRC9WNllERGxXRVJ5?=
 =?utf-8?B?OUJFSXdsM3duQlVEUzU1OEx5ck5raVA4YVpoMlhJanpsazhzR3NpNFBPa3Zo?=
 =?utf-8?B?SyttekdVODFzVFQ1cEtFU2tEMHd5SzMybWtpVDBtVXFsck5vM0xRbCs3WGoz?=
 =?utf-8?B?cm0vdDdxR245Y2NHQXJzRHhoR3Z6cThwOUpTckQ0MGp6aXpCY1p2THFobkg1?=
 =?utf-8?B?cHUrblI1NVF6eGlNYzJHYUREa0QzbWtGUTRRWC83Q2dyTnkzbFdoc2t4cHQw?=
 =?utf-8?B?OGNLR2lDSDQ5eDR0TWIzVnhNa3RGV1BtYVlubTZSWVJLaDdlNzhvRWhaSFRp?=
 =?utf-8?B?NVRVcjE3Q2N4Rk9xOWpjTUZOeFJkYlhkL0tOSUhzNzREbGh3VGUvcjRicm9l?=
 =?utf-8?B?NXNkV0M2NXFNcnpvK29qRFljZGV3V0Z5b2ZmeXRmbklUbGoxRlMvYWNJeEsw?=
 =?utf-8?B?WmpPQncvYzNxUDNJVUg2NzgrZXNWV0l2cTdtc0VESk9tZk5GN3B1VGNwTzBK?=
 =?utf-8?B?Q1NpbG96YU1yeDhKc2Z5TlpkRzVvTlpzeTB2WStvK2JRaGd4QkdMQ3FnM0pw?=
 =?utf-8?B?SitJYU11U3Vkc040RUYzWVpTQ0RSYWJrREgrL2VEaXIxTTA1T3lyRS9aTXFj?=
 =?utf-8?B?OGZoTkJkZWZsbG5JdDZBSWZmdUgwWGxUdG9scmlIYm5kVEtmOXErMUNiUGk3?=
 =?utf-8?B?K2RuNS9NVkJGM1RxQjhKWU5tZEZiZHFvTEpuTmZBYktwL1lPcFRmOG1wMEx6?=
 =?utf-8?B?SDZQeTF1WVM4R3l5d3ZIM1VMQndNNXJ4ZmlDM3ZURjBwS1FnbkNGZHVnMitz?=
 =?utf-8?B?MjVWa08zN0hpV09PN3Q4RHpCVCtkSUpkZTlKa1ViNWEyR0t3SThZdHFKSzVh?=
 =?utf-8?B?d1pBZkV2ZHVjQzFQeGlYcSszZndPZjdKbGNOKzNKek5JV2tzYnFZNm1nLys0?=
 =?utf-8?B?T3prOW5GU3U2cUE5UitKL2gyalNIUE9pTlVPUXJzanNDKzI0NHZWQVZLWDVu?=
 =?utf-8?B?UWlNVHROSUJmMnY4dlVKSW8zV0tqTzZTb1pWMFFhUXpoeFlOeFBQUW1KdnZi?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <43162C95A4730D4FA68C7B1D2C2A1F20@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae76e3f2-17f6-402e-3ce7-08db4160a446
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 05:32:33.1207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i2CNv/FeNpf8vEhZQMI7x6gOXOO11oecrExS7qmBSesrOcQqCJGOWlVBSnKO4xh9/8nCwPkrECJcXFxehJvFPnKN+nZ8ihuAs6BlaYlgm4rF9nuwWl9887Asff+d8+1W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6689
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTkvMDQvMjMgODo0MCBwbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gV2VkLCBBcHIgMTksIDIwMjMgYXQgMDI6NDA6
MjlQTSArMDAwMCwgUGFydGhpYmFuLlZlZXJhc29vcmFuQG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+
PiBIaSBSYW1vbiwNCj4+DQo+PiBHb29kIGRheS4uLiEgVGhpcyBpcyBQYXJ0aGliYW4gZnJvbSBN
aWNyb2NoaXAuDQo+Pg0KPj4gVGhhbmtzIGZvciB5b3VyIHBhdGNoZXMgZm9yIHRoZSBNaWNyb2No
aXAgTEFOODY3eCAxMEJBU0UtVDFTIFBIWS4gV2UNCj4+IHJlYWxseSBhcHByZWNpYXRlIHlvdXIg
ZWZmb3J0IG9uIHRoaXMuDQo+Pg0KPj4gRm9yIHlvdXIga2luZCBpbmZvcm1hdGlvbiwgd2UgYXJl
IGFscmVhZHkgd29ya2luZyBmb3IgdGhlIGRyaXZlciB3aGljaA0KPj4gc3VwcG9ydHMgYWxsIHRo
ZSAxMEJBU0UtVDFTIFBIWXMgZnJvbSBNaWNyb2NoaXAgYW5kIGRvaW5nIGludGVybmFsDQo+PiBy
ZXZpZXcgb2YgdGhvc2UgZHJpdmVyIHBhdGNoZXMgdG8gbWFpbmxpbmUuIFRoZXNlIHBhdGNoZXMg
YXJlIGdvaW5nIHRvDQo+PiByZWFjaCBtYWlubGluZSBpbiBjb3VwbGUgb2YgZGF5cy4gSXQgaXMg
dmVyeSB1bmZvcnR1bmF0ZSB0aGF0IHdlIHR3byBhcmUNCj4+IHdvcmtpbmcgb24gdGhlIHNhbWUg
dGFzayBhdCB0aGUgc2FtZSB0aW1lIHdpdGhvdXQga25vd2luZyBlYWNoIG90aGVyLg0KPj4NCj4+
IFRoZSBhcmNoaXRlY3R1cmUgb2YgeW91ciBwYXRjaCBpcyBzaW1pbGFyIHRvIG91ciBjdXJyZW50
IGltcGxlbWVudGF0aW9uLg0KPj4gSG93ZXZlciB0byBiZSBhYmxlIHRvIHN1cHBvcnQgYWxzbyB0
aGUgdXBjb21pbmcgMTBCQVNFLVQxUyBwcm9kdWN0cw0KPj4gZS5nLiwgdGhlIExBTjg2NXggMTBC
QVNFLVQxUyBNQUMtUEhZLCBhZGRpdGlvbmFsIGZ1bmN0aW9uYWxpdGllcyBoYXZlIHRvDQo+PiBi
ZSBpbXBsZW1lbnRlZC4gSW4gb3JkZXIgdG8gYXZvaWQgdW5uZWNlc3NhcnkvcmVkdW5kYW50IHdv
cmsgb24gYm90aA0KPj4gc2lkZXMsIHdlIHdvdWxkIGxpa2UgdG8gY29sbGFib3JhdGUgd2l0aCB5
b3Ugb24gdGhpcyB0b3BpYyBhbmQgaGF2ZSBhDQo+PiBzeW5jIG91dHNpZGUgb2YgdGhpcyBtYWls
aW5nIGxpc3QgYmVmb3JlIGdvaW5nIGZvcndhcmQuDQo+IA0KPiBIaSBQYXJ0aGliYW4NCj4gDQo+
IFBsZWFzZSByZXZpZXcgdmVyc2lvbiAyIG9mIHRoZSBwYXRjaCB3aGljaCB3YXMgcG9zdGVkIHRv
ZGF5LiAgSXMgdGhlcmUNCj4gYW55dGhpbmcgaW4gdGhhdCBwYXRjaCB3aGljaCBpcyBhY3R1YWxs
eSB3cm9uZz8NCj4gDQo+IEkgZG9uJ3QgbGlrZSB0aGUgaWRlYSBvZiBkcm9wcGluZyBhIHBhdGNo
LCBiZWNhdXNlIGEgdmVuZG9yIGNvbWVzIG91dA0KPiBvZiwgbWF5YmUgdW5pbnRlbnRpb25hbCwg
c3RlYWx0aCBtb2RlLCBhbmQgYXNrcyBmb3IgdGhlaXIgdmVyc2lvbiB0bw0KPiBiZSB1c2VkLCBu
b3Qgc29tZWJvZHkgZWxzZSdzLiBGb3IgbWUgdGhpcyBpcyBlc3BlY2lhbGx5IGltcG9ydGFudCBm
b3INCj4gYSBuZXcgY29udHJpYnV0b3IuDQo+IA0KPiBNeSBwcmVmZXJyZWQgd2F5IGZvcndhcmQg
aXMgdG8gbWVyZ2UgUmFtb24ncyBjb2RlLCBhbmQgdGhlbiB5b3UgY2FuDQo+IGJ1aWxkIG9uIGl0
IHdpdGggYWRkaXRpb25hbCBmZWF0dXJlcyB0byBzdXBwb3J0IG90aGVyIGZhbWlseQ0KPiBtZW1i
ZXJzLg0KPiANCj4gUGxlYXNlIGRvbid0IGdldCBtZSB3cm9uZywgaSBmaW5kIGl0IGdyZWF0IHlv
dSBhcmUgc3VwcG9ydGluZyB5b3VyIG93bg0KPiBkZXZpY2VzLiBOb3QgbWFueSB2ZW5kb3JzIGRv
LiBCdXQgTGludXggaXMgYSBjb21tdW5pdHksIHdlIGhhdmUgdG8NCj4gcmVzcGVjdCBlYWNoIG90
aGVycyB3b3JrLCBvdGhlciBtZW1iZXJzIG9mIHRoZSBjb21tdW5pdHkuDQo+IA0KPiAgICAgICAg
ICBBbmRyZXcNCj4gDQo+IEZZSTogRG8geW91IGhhdmUgYW55IG90aGVyIGRyaXZlcnMgaW4gdGhl
IHBpcGVsaW5lIHlvdSB3YW50IHRvDQo+IGFubm91bmNlLCBqdXN0IHRvIGF2b2lkIHRoaXMgaGFw
cGVuaW5nIGFnYWluLg0KDQpIaSBBbmRyZXcsDQoNClRoYW5rcyBhIGxvdCBmb3IgeW91ciByZXBs
eSBhbmQgY2xhcmlmaWNhdGlvbi4NCg0KU3VyZSBJIHdpbGwgYWxzbyBwYXJ0aWNpcGF0ZSBpbiBy
ZXZpZXdpbmcgdGhlIHBhdGNoZXMgaW5jbHVkaW5nIHYyLg0KDQpJIGZ1bGx5IGFncmVlIHdpdGgg
eW91IGFuZCBhbHNvIEkgcmVhbGx5IGFwcHJlY2lhdGUgUmFtb24ncyBlZmZvcnQgb24gDQp0aGlz
IHdoaWNoIHNob3dzIGhvdyBtdWNoIGludGVyZXN0IGhlIGhhcyBvbiBvdXIgcHJvZHVjdCBhbmQg
ZHJpdmVyIA0KZGV2ZWxvcG1lbnQuDQoNCgkxLiBBZGQgc3VwcG9ydCBmb3IgTEFOODY1MC8xIDEw
QkFTRS1UMVMgTUFDLVBIWSdzIFBIWSBpbiB0aGUgDQptaWNyb2NoaXBfdDFzLmMgZHJpdmVyIHdo
aWNoIGlzIGJlaW5nIG1haW5saW5lZCBieSBSYW1vbi4NCgkyLiBBZGQgZ2VuZXJpYyBkcml2ZXIg
c3VwcG9ydCBmb3IgdGhlIE9QRU4gQWxsaWFuY2UgMTBCQVNFLVQxeCBNQUMtUEhZIA0KU2VyaWFs
IEludGVyZmFjZS4NCgkzLiBBZGQgZHJpdmVyIHN1cHBvcnQgZm9yIExBTjg2NTAvMSAxMEJBU0Ut
VDFTIE1BQy1QSFkuDQoNCk5vdGU6IDJuZCBhbmQgM3JkIHdpbGwgYmUgaW4gYSBzaW5nbGUgcGF0
Y2ggc2VyaWVzLg0KDQpBYm92ZSBwcm9kdWN0IGxpbms6IGh0dHBzOi8vd3d3Lm1pY3JvY2hpcC5j
b20vZW4tdXMvcHJvZHVjdC9sYW44NjUwDQoNCkFzIEkgY29tbXVuaWNhdGVkIGJlZm9yZSBpbiB0
aGUgYmVsb3cgZW1haWwsIHdlIGhhdmUgdGhlIGFib3ZlIGRyaXZlcnMgDQppbiB0aGUgcGlwZWxp
bmUgdG8gbWFpbmxpbmUuDQoNCkhpIEFuZHJldywNCg0KVGhhbmtzIGEgbG90IGZvciB5b3VyIHN1
cHBvcnQuIEkgd2lsbCBjaGVjayB3aXRoIG91ciBjb2xsZWFndWVzDQpzdWdnZXN0ZWQgYnkgeW91
IGFuZCBnZXQgYmFjayB0byBtYWlubGluZSBhZ2Fpbi4NCg0KQmVzdCBSZWdhcmRzLA0KUGFydGhp
YmFuIFYNCk9uIDExLzAzLzIzIDExOjE1IHBtLCBBbmRyZXcgTHVubiB3cm90ZToNCiA+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IA0Ka25vdyB0aGUgY29udGVudCBpcyBzYWZlDQogPg0KID4gSGkgQWxsYW4NCiA+DQogPiBJ
dCBoYXMgYmVlbiBhIGxvbmcgdGltZSBzaW5jZSB3ZSB0YWxrZWQsIG1heWJlIDIwMTkgYXQgdGhl
IExpbnV4DQogPiBQbHVtYmVycyBjb25mZXJlbmNlLi4uLiBBbmQgdGhlbiBQVFAgZGlzY3Vzc2lv
bnMgZXRjLg0KID4NCiA+IEl0IHNlZW1zIGxpa2UgU3Bhcng1IGlzIGdvaW5nIHdlbGwsIGFsb25n
IHdpdGggZmVsaXgsIHNldmlsbGUsIGV0Yy4NCiA+DQogPiBPbiBGcmksIE1hciAxMCwgMjAyMyBh
dCAxMToxMzoyM0FNICswMDAwLCANClBhcnRoaWJhbi5WZWVyYXNvb3JhbkBtaWNyb2NoaXAuY29t
IHdyb3RlOg0KID4+IEhpIEFsbCwNCiA+Pg0KID4+IEkgd291bGQgbGlrZSB0byBhZGQgTWljcm9j
aGlwJ3MgTEFOODY1eCAxMEJBU0UtVDFTIE1BQy1QSFkgZHJpdmVyDQogPj4gc3VwcG9ydCB0byBM
aW51eCBrZXJuZWwuDQogPj4gKFByb2R1Y3QgbGluazogaHR0cHM6Ly93d3cubWljcm9jaGlwLmNv
bS9lbi11cy9wcm9kdWN0L0xBTjg2NTApDQogPj4NCiA+PiBUaGUgTEFOODY1MCBjb21iaW5lcyBh
IE1lZGlhIEFjY2VzcyBDb250cm9sbGVyIChNQUMpIGFuZCBhbiBFdGhlcm5ldCBQSFkNCiA+PiB0
byBhY2Nlc3MgMTBCQVNF4oCRVDFTIG5ldHdvcmtzLiBUaGUgY29tbW9uIHN0YW5kYXJkIFNlcmlh
bCBQZXJpcGhlcmFsDQogPj4gSW50ZXJmYWNlIChTUEkpIGlzIHVzZWQgc28gdGhhdCB0aGUgdHJh
bnNmZXIgb2YgRXRoZXJuZXQgcGFja2V0cyBhbmQNCiA+PiBMQU44NjUwIGNvbnRyb2wvc3RhdHVz
IGNvbW1hbmRzIGFyZSBwZXJmb3JtZWQgb3ZlciBhIHNpbmdsZSwgc2VyaWFsDQogPj4gaW50ZXJm
YWNlLg0KID4+DQogPj4gRXRoZXJuZXQgcGFja2V0cyBhcmUgc2VnbWVudGVkIGFuZCB0cmFuc2Zl
cnJlZCBvdmVyIHRoZSBzZXJpYWwgaW50ZXJmYWNlDQogPj4gYWNjb3JkaW5nIHRvIHRoZSBPUEVO
IEFsbGlhbmNlIDEwQkFTReKAkVQxeCBNQUPigJFQSFkgU2VyaWFsIEludGVyZmFjZQ0KID4+IHNw
ZWNpZmljYXRpb24gZGVzaWduZWQgYnkgVEM2Lg0KID4+IChsaW5rOiBodHRwczovL3d3dy5vcGVu
c2lnLm9yZy9BdXRvbW90aXZlLUV0aGVybmV0LVNwZWNpZmljYXRpb25zLykNCiA+PiBUaGUgc2Vy
aWFsIGludGVyZmFjZSBwcm90b2NvbCBjYW4gc2ltdWx0YW5lb3VzbHkgdHJhbnNmZXIgYm90aCB0
cmFuc21pdA0KID4+IGFuZCByZWNlaXZlIHBhY2tldHMgYmV0d2VlbiB0aGUgaG9zdCBhbmQgdGhl
IExBTjg2NTAuDQogPj4NCiA+PiBCYXNpY2FsbHkgdGhlIGRyaXZlciBjb21wcmlzZXMgb2YgdHdv
IHBhcnRzLiBPbmUgcGFydCBpcyB0byBpbnRlcmZhY2UNCiA+PiB3aXRoIG5ldHdvcmtpbmcgc3Vi
c3lzdGVtIGFuZCBTUEkgc3Vic3lzdGVtLiBUaGUgb3RoZXIgcGFydCBpcyBhIFRDNg0KID4+IHN0
YXRlIG1hY2hpbmUgd2hpY2ggaW1wbGVtZW50cyB0aGUgRXRoZXJuZXQgcGFja2V0cyBzZWdtZW50
YXRpb24NCiA+PiBhY2NvcmRpbmcgdG8gT1BFTiBBbGxpYW5jZSAxMEJBU0XigJFUMXggTUFD4oCR
UEhZIFNlcmlhbCBJbnRlcmZhY2UNCiA+PiBzcGVjaWZpY2F0aW9uLg0KID4+DQogPj4gVGhlIGlk
ZWEgYmVoaW5kIHRoZSBUQzYgc3RhdGUgbWFjaGluZSBpbXBsZW1lbnRhdGlvbiBpcyB0byBtYWtl
IGl0IGFzIGENCiA+PiBnZW5lcmljIGxpYnJhcnkgYW5kIHBsYXRmb3JtIGluZGVwZW5kZW50LiBB
IHNldCBvZiBBUEkncyBwcm92aWRlZCBieQ0KID4+IHRoaXMgVEM2IHN0YXRlIG1hY2hpbmUgbGli
cmFyeSBjYW4gYmUgdXNlZCBieSB0aGUgMTBCQVNFLVQxeCBNQUMtUEhZDQogPj4gZHJpdmVycyB0
byBzZWdtZW50IHRoZSBFdGhlcm5ldCBwYWNrZXRzIGFjY29yZGluZyB0byB0aGUgT1BFTiBBbGxp
YW5jZQ0KID4+IDEwQkFTReKAkVQxeCBNQUPigJFQSFkgU2VyaWFsIEludGVyZmFjZSBzcGVjaWZp
Y2F0aW9uLg0KID4+DQogPj4gV2l0aCB0aGUgYWJvdmUgaW5mb3JtYXRpb24sIGtpbmRseSBwcm92
aWRlIHlvdXIgdmFsdWFibGUgZmVlZGJhY2sgb24gbXkNCiA+PiBiZWxvdyBxdWVyaWVzLg0KID4+
DQogPj4gQ2FuIHdlIGtlZXAgdGhpcyBUQzYgc3RhdGUgbWFjaGluZSB3aXRoaW4gdGhlIExBTjg2
NXggZHJpdmVyIG9yIGFzIGENCiA+PiBzZXBhcmF0ZSBnZW5lcmljIGxpYnJhcnkgYWNjZXNzaWJs
ZSBmb3Igb3RoZXIgMTBCQVNFLVQxeCBNQUMtUEhZIGRyaXZlcnMNCiA+PiBhcyB3ZWxsPw0KID4+
DQogPj4gSWYgeW91IHJlY29tbWVuZCB0byBoYXZlIHRoYXQgYXMgYSBzZXBhcmF0ZSBnZW5lcmlj
IGxpYnJhcnkgdGhlbiBjb3VsZA0KID4+IHlvdSBwbGVhc2UgYWR2aWNlIG9uIHdoYXQgaXMgdGhl
IGJlc3Qgd2F5IHRvIGRvIHRoYXQgaW4ga2VybmVsPw0KID4NCiA+IE1pY3JvY2hpcCBpcyBnZXR0
aW5nIG1vcmUgYW5kIG1vcmUgaW52b2x2ZWQgaW4gbWFpbmxpbmUuIEpha3ViDQogPiBwdWJsaXNo
ZXMgc29tZSBkZXZlbG9wZXJzIHN0YXRpc3RpY3MgZm9yIG5ldGRldjoNCiA+DQogPiBodHRwczov
L2x3bi5uZXQvQXJ0aWNsZXMvOTE4MDA3Lw0KID4NCiA+IEl0IHNob3dzIE1pY3JvY2hpcCBhcmUg
bmVhciB0aGUgdG9wIGZvciBjb2RlIGNvbnRyaWJ1dGlvbnMuIFdoaWNoIGlzDQogPiBncmVhdC4g
SG93ZXZlciwgYXMgYSByZXZpZXdlciwgaSBzZWUgdGhlIHF1YWxpdHkgcmVhbGx5IHZhcmllcy4g
R2l2ZW4NCiA+IGhvdyBhY3RpdmUgTWljcm9jaGlwIGlzIHdpdGhpbiBMaW51eCwgdGhlIG5ldGRl
diBjb21tdW5pdHksIGFuZCB0bw0KID4gc29tZSBleHRlbnQgTGludXggYXMgYSB3aG9sZSwgZXhw
ZWN0cyBhIGNvbXBhbnkgbGlrZSBNaWNyb2NoaXAgdG8NCiA+IGJ1aWxkIHVwIGl0cyBpbnRlcm5h
bCByZXNvdXJjZXMgdG8gb2ZmZXIgdHJhaW5pbmcgYW5kIE1lbnRvcmluZyB0bw0KID4gbWFpbmxp
bmUgZGV2ZWxvcGVycywgcmF0aGVyIHRoYW4gZXhwZWN0IHRoZSBjb21tdW5pdHkgdG8gZG8gdGhh
dA0KID4gd29yay4gRG9lcyBzdWNoIGEgdGhpbmcgZXhpc3Qgd2l0aGluIE1pY3JvY2hpcD8gQ291
bGQgeW91IHBvaW50DQogPiBQYXJ0aGliYW4gdG93YXJkcyBhIG1lbnRvciB3aG8gY2FuIGhlbHAg
Z3VpZGUgdGhlIHdvcmsgYWRkaW5nIGdlbmVyaWMNCiA+IHN1cHBvcnQgZm9yIHRoZSBPUEVOIEFs
bGlhbmNlIDEwQkFTRS1UMXggTUFDLVBIWSBTZXJpYWwgSW50ZXJmYWNlIGFuZA0KID4gdGhlIExB
Tjg2NTAvMSBzcGVjaWZpYyBiaXRzPyBJZiBub3QsIGNvdWxkIFN0ZWVuIEhlZ2VsdW5kIG9yIEhv
cmF0aXUNCiA+IFZ1bHR1ciBtYWtlIHNvbWUgdGltZSBhdmFpbGFibGUgdG8gYmUgYSBtZW50b3I/
DQogPg0KID4gVGhhbmtzDQogPiAgICAgICAgICBBbmRyZXcNCg0K
