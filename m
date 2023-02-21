Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1D769DA27
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 05:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbjBUEkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 23:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbjBUEkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 23:40:36 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA0F252B1;
        Mon, 20 Feb 2023 20:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676954433; x=1708490433;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VXI7/IPURfo6NUe8waFmH+mjDxYjCKt2UoX7018fNHg=;
  b=UkFlWX7CbV6RK/40GOvk1t8W/LMdMhu69axenROCuFmC5AkzQA6UdS9I
   ER9wOyDlzby1C2AhV97xCz2D6Tgr4r7EHRvTcJ/ONZg03d8+8+Ksj8oAf
   KcgW/rn/iKfIJv3kPZghoNs3Uzc0F2eVT8ayCtpM8HauM5w1OUsB0j54H
   09sgMu4nw00MkUUmSRH5VByuCWI8iAnSDqeCFB0u2EVJkpDtmF+H40t9S
   HlnmS/ig/OY9k+1Pc479lrgTRb42XgMbOHprWMFYdN+M+FF6PYM2oVuXv
   tNUZUyV4tU7ZY2gNfpkzhUSy6UA5Ir/+spY4SBHxV81oq+71aXbtCth+3
   w==;
X-IronPort-AV: E=Sophos;i="5.97,314,1669100400"; 
   d="scan'208";a="201530720"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Feb 2023 21:40:32 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 20 Feb 2023 21:40:33 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 20 Feb 2023 21:40:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJrYX+Wa1/u2k2Ai1evEF4PdjDD9zBF9fggtZUz2GD7LGmhfMgnVSaJBKKhpftLQuFiPoZ9lXB8M5gLS1P2JUK+tMIO/DqwnGS0hFgX+9LOE00tEBklRrsxQXm4rwH48c87SWwomVEiO9Rjg21sMFTHXK2LRd/HLj8Ul7HnUR0OEImIzPCpWFD5qygDmOTqXP9hrdlrs3qtEnA9Lta5yWkIGZ8pjIHOq2quVPZ8+LehWcpsav29d15fmU4ZUIx2MXttTkiIezlx6fyQT9QqfKTlyhAo0PlgxiJm9y2+UAdf7dBYLaAXSrDrGq6PsiC/oIgr0FQkPleDB/23SFazj7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VXI7/IPURfo6NUe8waFmH+mjDxYjCKt2UoX7018fNHg=;
 b=KzXrEd6mNC4zud4vsw9Ky4elH34QsLehi2WHWrqf6D38jSNGGBzSjIYvCYwTtxUeXRau5TD6/R+9eyKWP/SS/sb71MgpBSvCCNvta20+ffxVXrwqH/7jK6rktllMTpphhHA0ouFLuXbgDHgDDAYifA9ps09c493QlO/eAYjE90lde27CsekWe4lYC+SrctTHah0I2awatoDxuup7Vm9cGXsaElAkwUyfKNXhWDJVpMzhfUZnC+WGiPVzTXJbP+byGCqlEPOZNt0Mrr5f1DcRjRqWy3NHT7mvo9odu7wESe3QEzo7UT4nVYlj6/j+IYQJniLnrBZiSu5YOqnmKHIodA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VXI7/IPURfo6NUe8waFmH+mjDxYjCKt2UoX7018fNHg=;
 b=NnAj+8bHLyKxL4PmkqUzJikhvKGNUuQfGnIZui/VQoYqCuDu2Dtrvh4crMAEqwr36yCHlO2WEWaGWdW5TV5RXsIi92xZdM/nJFZGO19K2nDZYDACAAk3V/AzBHiCOhpTD/P6i2lt8YXqe3NpVm13G0MtGiChXyvkjVV/2uvGGG8=
Received: from MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9)
 by BN9PR11MB5291.namprd11.prod.outlook.com (2603:10b6:408:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Tue, 21 Feb
 2023 04:40:31 +0000
Received: from MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::6be3:1fbb:d008:387e]) by MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::6be3:1fbb:d008:387e%8]) with mapi id 15.20.6111.019; Tue, 21 Feb 2023
 04:40:31 +0000
From:   <Rakesh.Sankaranarayanan@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <Thangaraj.S@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <edumazet@google.com>,
        <UNGLinuxDriver@microchip.com>, <kuba@kernel.org>
Subject: Re: [PATCH v2 net-next 1/5] net: dsa: microchip: add rmon grouping
 for ethtool statistics
Thread-Topic: [PATCH v2 net-next 1/5] net: dsa: microchip: add rmon grouping
 for ethtool statistics
Thread-Index: AQHZQr9J/veRNAG2l0aNi9udgtLRKa7TW04AgAV8yIA=
Date:   Tue, 21 Feb 2023 04:40:31 +0000
Message-ID: <79a59659f2a6771f94d079ba8675dbe046fb63c2.camel@microchip.com>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
         <20230217110211.433505-2-rakesh.sankaranarayanan@microchip.com>
         <20230217165346.2eaualia32kmliz6@skbuf>
In-Reply-To: <20230217165346.2eaualia32kmliz6@skbuf>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6088:EE_|BN9PR11MB5291:EE_
x-ms-office365-filtering-correlation-id: 49080ab9-bbb8-4a86-9e91-08db13c5c385
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BKA+HQ2nSHxOoGAvKwq0u0JzHe07OYgatYIlnUjlKdv+WRjnrWIfIyr49oaxy0M6hV1Jee/I2nHONXVx7AwpR8bsBiJ9MwmQMt56B1t9Pbb6vUo1kH6zoo73SiabPUMBVVOJwJI23SWmxR5croTHpG81PE5mqDJ0Vp2Ov9gOnqyHcWd94Nsv/RHy0rZO76xdgXV3ir+24HJ+kOKAFXQ7I+GllAACCh7QZt6ChV2e8QV328GWUk0swnjhhHztVqVE0zzGpWlgw5D2jP5dXRjzXKR0C9X7mqVtjCQdTZNPZpfPV3SexQJ9GOBGdEd4r9wICz67hqwm8LdWOGfsw6qLGX8jxWk9jMU2zbLaUjs9r6Y3Vp7M2RJp4WySkRmFapVl+fBimAgVY1iCwOt/wwS/evXE2AoAzThWIzxjNJpWbgnspb/IASC4ztzrWQ5IeAzi0bC+RtXLAuFvnE+9ZJc43E+7ggZBoGqu/IbPNUB/4pLv68pYZ5t23qOeO+vGSUh+CoL0fR2udOe+FMGQ8NyNbHi/M6RAcAi0ZrvDAH1X1XCtiofKDyIcKJ8kO4ly832ct1aj/UtDTeKJI40yQRE5T1ZFE/OCB6kRRL4SIfZrG4GxPZTSMvWiv0F+EpAXGbT8uxceyUOLKiUHChGvdAW5H3xCOdvvMq4ivvbTQiDNveKyqvvc2FCjixWWTqw0zvJMvwGM5NB+2ZiS9UfoFdk4OA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6088.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199018)(8676002)(66446008)(122000001)(66476007)(64756008)(66946007)(6916009)(66556008)(91956017)(316002)(41300700001)(76116006)(4326008)(5660300002)(86362001)(2616005)(83380400001)(186003)(6512007)(26005)(6506007)(6486002)(54906003)(71200400001)(2906002)(36756003)(38070700005)(38100700002)(478600001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amMwdTVTbFRGeVk5S21GR2lYck5ENXVUeFFRejNFKzhLNFdNaFFLMEoyNEdr?=
 =?utf-8?B?dGRxNGpLdW9wK2RyZ2pEMlc0OEdjaUNrYnRYTFpHK0FMUDZaRTFjRkg3MmFL?=
 =?utf-8?B?Tkc4VkJVODYyTS8vNVNsRUxteVVOVWl3UFlzNnFnb2N5RXkwS05JNHNNWU4x?=
 =?utf-8?B?N0g5djNEUnZuZURKTU1HYzllb1ZTYytUbCtXS2V4OW1FeDgzdU40WnVkeFlq?=
 =?utf-8?B?WWxFcFkrVmRkRGl6MVZiR1Zaai9XWEdnRE10OCs0L0xPalZ2bkQza3JpQ0lR?=
 =?utf-8?B?YWhSM3NwU1NpQ3hTZmJLaUlLY2YxQkdWSnY2b2lBcU1DbWNLUVg4Y2RxbTIy?=
 =?utf-8?B?RHBPQVE2UzZhLzFGc0N1UjZQWWZ3UFVHcDhxZ0ZGSm9aWUU2ZWhLemswMVZH?=
 =?utf-8?B?SWs0cUwyNFFHVXRYUC9DYUE2MTM0Nng1QkZrQTJEYUh6S1ZOaFB2dm05Zm1y?=
 =?utf-8?B?bWpFelRZR1NIcWk1MDJhcUJKK1FCbjliR2ZVa05JcitlaDZNUGhLb2xBb1lO?=
 =?utf-8?B?ekVWZzhCK0lJUG11WnlTZmV0Y1d4ZnAwemp5WkFLY3ZuVXA2a1M0aVhoNlQ5?=
 =?utf-8?B?bi8zZW01cm9yZTU2WDNxbDNGaWptd3FNN0YzVDRpZ3Y3TmY1ZzBUNnNQU2tT?=
 =?utf-8?B?cENxRWZnSWRLbHZOTzlmZjBMMGorK0FYRm1UMHIybDJneWN3UDR6ZmJ0WXk3?=
 =?utf-8?B?ZEJHU0NFdGVLRmhlNjRXekdEZkthNFJrVmNnVkZqL2YrRUFSSHNwRVlTMTE4?=
 =?utf-8?B?Q3BvOHZvUC9OV2dVa1lZRTVzaWVnUjlkTHNmbWErVWFka0VwcHBjVmRoL1p2?=
 =?utf-8?B?NlZrT0x1ZkZCUXRSeHR3REQ4cSsvcVRWN3ZxeGVPVFFlcElnd0JvY3YrbHVw?=
 =?utf-8?B?YzgzU2FQcWVMS2hQckNRZTY4WGM1b1l0THd2bytuaFU5UWJGeHI5UVdOdWlX?=
 =?utf-8?B?Q0JPK29tUk90Yi9Ma204cVhiOU94amk0RHlXcUNuZGxoRzJmYXdxcFJTRnkw?=
 =?utf-8?B?cStPVU0wRWFRajVRdU1ONXgyaFI5YzlKMVMzRituUlNUYzFadUoxY3ZScXRD?=
 =?utf-8?B?YTJjY2RnU1ZTQmdtTTIvNUt0bUxQU0QydzlwQ2RldHdaN3lzSmJWeHRqL3Vy?=
 =?utf-8?B?NC9OQmNaSGphNi9Cc1RrckQ4MGo3eUgyeW5RaDBQMGlGcG15VGMzYzhMaW1u?=
 =?utf-8?B?OTFISkhlYWpEemVMcmpiWHdpVEZWaS9ua21PT2g2UUMvUGlEZUpESUlFZWVX?=
 =?utf-8?B?WGd3eHVtYzdoTWYrYWlMUjYyOG5NekVPR2lxZm1KTi9HczBibEZuMEgyNnhz?=
 =?utf-8?B?K2ZsTVJQYWNmekp4cXVZQzd5TktjUmFuUUlaOVNyS3BQZWhGVFFQZGtEQTNH?=
 =?utf-8?B?akV1RGt4aW9Fb1JRWFViVVBqRFlmZW5MZWZjYkgrZjZhTHovM3VrYjljUEJw?=
 =?utf-8?B?WmtDWlEvdjBKRFBtQ3pIOUo5Q3JsZzRHMEhyTXpwUTdNM0M4Q01nd0VWTlpN?=
 =?utf-8?B?eDk2RE9weSt2RWRCcmsvQ3lidGF5aC9HcE56bkpNUzlQWm9heHBsNGJYMDkv?=
 =?utf-8?B?b0oxSC9FVHNENXNBNHpmTUFYYStyN3Zuemw0R0hlOGpBMDF0KzY2c0hGTnRN?=
 =?utf-8?B?Rm96OCs3RkdlWWpFSjhNRVc4R3JCOFd5a09uR0pKMURyZUh6eGpNQWlpb3di?=
 =?utf-8?B?cERDVHN3QWx6TXFBaE41Z1lTMnkwR3ZFZnlKYllLVUtGYjhNM3ByNUxHb1BX?=
 =?utf-8?B?Zk4yc09nai9oSFpiUmJiMzIybzZKZGVsOUNpRDJwT3ZUOHB5aWVZZWlSdmdQ?=
 =?utf-8?B?Y2NlSklKTHF3MHRxVTVXY1RWMHpnR04zc1Q5MlpGR1dvQ2ZRcTJxeDNEQm5M?=
 =?utf-8?B?SlN4QlovM2RxWHhlWW4zSjR0T2NTcEwwazB0NFJPQWFCYWVqSjhyVmYvSGlX?=
 =?utf-8?B?SUNxbzRHUlYvb0FuNUhPLzRNUEZFUzVNV3Q4VmZqOW42VmtqMG1wVGwxV2p1?=
 =?utf-8?B?WURJV1VqbzAxZEd3b0dSUjE2N0JreFNBSUFXdE1wcDNIMVRJLzd0S1V6Znp0?=
 =?utf-8?B?NVcwYmR1NFlJaUt6eUV4NG8zTzR1MXRCbWw4Z3JHZzI1TC9vV3lTTTM5VEhK?=
 =?utf-8?B?UDUrY0QxNEJubEhXeGVaWnNDQkxrWmxLVWxaNXVrTUR6Z3dRNG1oUHVWc1M2?=
 =?utf-8?Q?qSWHpZgLdQ/3UBlkEvyYrNiKvbgn4IRVYxJl0irxlVuT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4CBB00F67601D64583C2A7DB9883B68A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6088.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49080ab9-bbb8-4a86-9e91-08db13c5c385
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2023 04:40:31.2230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WkAXbKZsNZVnHBWRUG+tsLl4RD/25lsK7j0CNvpdbgyjhHNIzLWVlNNtFavGR7MT6zaLg764/RFtqoihVMM+Ytlx2ZcZz49+7axXSnBllr95AwK6d5gBABz/T3bQl23g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5291
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZCwNCk9uIEZyaSwgMjAyMy0wMi0xNyBhdCAxODo1MyArMDIwMCwgVmxhZGltaXIgT2x0
ZWFuIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+
IE9uIEZyaSwgRmViIDE3LCAyMDIzIGF0IDA0OjMyOjA3UE0gKzA1MzAsIFJha2VzaCBTYW5rYXJh
bmFyYXlhbmFuDQo+IHdyb3RlOg0KPiA+IMKgwqDCoCBBZGQgc3VwcG9ydCBmb3IgZXRodG9vbCBz
dGFuZGFyZCBkZXZpY2Ugc3RhdGlzdGljcyBncm91cGluZy4NCj4gPiBTdXBwb3J0IHJtb24NCj4g
PiDCoMKgwqAgc3RhdGlzdGljcyBncm91cGluZyB1c2luZyBybW9uIGdyb3VwcyBwYXJhbWV0ZXIg
aW4gZXRodG9vbA0KPiA+IGNvbW1hbmQuIHJtb24NCj4gPiDCoMKgwqAgcHJvdmlkZXMgcGFja2V0
IHNpemUgYmFzZWQgcmFuZ2UgZ3JvdXBpbmcuIENvbW1vbiBtaWINCj4gPiBwYXJhbWV0ZXJzIGFy
ZSB1c2VkDQo+ID4gwqDCoMKgIGFjcm9zcyBhbGwgS1NaIHNlcmllcyBzd3RjaGVzIGZvciBwYWNr
ZXQgc2l6ZSBzdGF0aXN0aWNzLA0KPiA+IGV4Y2VwdCBmb3INCj4gPiDCoMKgwqAgS1NaODgzMC4g
S1NaIHNlcmllcyBoYXZlIG1pYiBjb3VudGVycyBmb3IgcGFja2V0cyB3aXRoIHNpemU6DQo+ID4g
wqDCoMKgIC0gbGVzcyB0aGFuIDY0IEJ5dGVzLA0KPiA+IMKgwqDCoCAtIDY1IHRvIDEyNyBCeXRl
cywNCj4gPiDCoMKgwqAgLSAxMjggdG8gMjU1IEJ5dGVzLA0KPiA+IMKgwqDCoCAtIDI1NiB0byA1
MTEgQnl0ZXMsDQo+ID4gwqDCoMKgIC0gNTEyIHRvIDEwMjMgQnl0ZXMsDQo+ID4gwqDCoMKgIC0g
MTAyNCB0byAxNTIyIEJ5dGVzLA0KPiA+IMKgwqDCoCAtIDE1MjMgdG8gMjAwMCBCeXRlcyBhbmQN
Cj4gPiDCoMKgwqAgLSBNb3JlIHRoYW4gMjAwMSBCeXRlcw0KPiA+IMKgwqDCoCBLU1o4ODMwIGhh
dmUgbWliIGNvdW50ZXJzIHVwdG8gMTAyNC0xNTIyIHJhbmdlIG9ubHkuIFNpbmNlIG5vDQo+ID4g
b3RoZXIgY2hhbmdlLA0KPiA+IMKgwqDCoCBjb21tb24gcmFuZ2UgdXNlZCBhY3Jvc3MgYWxsIEtT
WiBzZXJpZXMsIGJ1dCB1c2VkIHVwdG8gb25seQ0KPiA+IHVwdG8gMTAyNC0xNTIyDQo+ID4gwqDC
oMKgIGZvciBLU1o4ODMwLg0KPiANCj4gV2h5IGFyZSBhbGwgY29tbWl0IG1lc3NhZ2VzIGluZGVu
dGVkIGluIHRoaXMgd2F5PyBQbGVhc2Uga2VlcCB0aGUNCj4gZGVmYXVsdCB0ZXh0IGluZGVudGF0
aW9uIGF0IDAgY2hhcmFjdGVycy4gSSBoYXZlIG5ldmVyIHNlZW4gdGhpcw0KPiBzdHlsZQ0KPiBp
biAiZ2l0IGxvZyIuDQpTdXJlLCB3aWxsIHVwZGF0ZSB0aGUgaW5kZW50YXRpb24gaW4gbmV4dCB2
ZXJzaW9uDQo+IA0KPiA+IA0KPiA+IENvLWRldmVsb3BlZC1ieTogVGhhbmdhcmFqIFNhbXluYXRo
YW4gPFRoYW5nYXJhai5TQG1pY3JvY2hpcC5jb20+DQo+IA0KPiBEb2N1bWVudGF0aW9uL3Byb2Nl
c3Mvc3VibWl0dGluZy1wYXRjaGVzLnJzdDoNCj4gDQo+IENvLWRldmVsb3BlZC1ieTogc3RhdGVz
IHRoYXQgdGhlIHBhdGNoIHdhcyBjby1jcmVhdGVkIGJ5IG11bHRpcGxlDQo+IGRldmVsb3BlcnM7
DQo+IGl0IGlzIHVzZWQgdG8gZ2l2ZSBhdHRyaWJ1dGlvbiB0byBjby1hdXRob3JzIChpbiBhZGRp
dGlvbiB0byB0aGUNCj4gYXV0aG9yDQo+IGF0dHJpYnV0ZWQgYnkgdGhlIEZyb206IHRhZykgd2hl
biBzZXZlcmFsIHBlb3BsZSB3b3JrIG9uIGEgc2luZ2xlDQo+IHBhdGNoLsKgIFNpbmNlDQo+IENv
LWRldmVsb3BlZC1ieTogZGVub3RlcyBhdXRob3JzaGlwLCBldmVyeSBDby1kZXZlbG9wZWQtYnk6
IG11c3QgYmUNCj4gaW1tZWRpYXRlbHkNCj4gZm9sbG93ZWQgYnkgYSBTaWduZWQtb2ZmLWJ5OiBv
ZiB0aGUgYXNzb2NpYXRlZCBjby1hdXRob3IuwqAgU3RhbmRhcmQNCj4gc2lnbi1vZmYNCj4gcHJv
Y2VkdXJlIGFwcGxpZXMsIGkuZS4gdGhlIG9yZGVyaW5nIG9mIFNpZ25lZC1vZmYtYnk6IHRhZ3Mg
c2hvdWxkDQo+IHJlZmxlY3QgdGhlDQo+IGNocm9ub2xvZ2ljYWwgaGlzdG9yeSBvZiB0aGUgcGF0
Y2ggaW5zb2ZhciBhcyBwb3NzaWJsZSwgcmVnYXJkbGVzcyBvZg0KPiB3aGV0aGVyDQo+IHRoZSBh
dXRob3IgaXMgYXR0cmlidXRlZCB2aWEgRnJvbTogb3IgQ28tZGV2ZWxvcGVkLWJ5Oi7CoCBOb3Rh
Ymx5LCB0aGUNCj4gbGFzdA0KPiBTaWduZWQtb2ZmLWJ5OiBtdXN0IGFsd2F5cyBiZSB0aGF0IG9m
IHRoZSBkZXZlbG9wZXIgc3VibWl0dGluZyB0aGUNCj4gcGF0Y2guDQpXaWxsIGFkZCBTaWduZWQt
b2ZmLWJ5IGluZm9ybWF0aW9uIGluIG5leHQgcmV2aXNpb24NCg0K
