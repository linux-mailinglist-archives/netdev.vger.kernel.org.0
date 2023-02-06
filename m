Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB8668C08B
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjBFOyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBFOyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:54:17 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C546283D9;
        Mon,  6 Feb 2023 06:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675695256; x=1707231256;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BFvjYzwvWCbyA9OdvFBC5mh+gBLLWKF0zndj84KHwUw=;
  b=TNGMxfPldfrwn2BknsNufrGaxa3QvM4P9c/LzbcDZnXztzWk6eNYEMw0
   mjAYcRrhFvsWqNatZEijrKp/VjoaQP1uW5Nr1c84qxVDAUqOMegAfsIUC
   zjWT8PRVE2bzdJKaBcLeZ67utC+O1ToNQ0jpf9GO6xH39ZGhQCMssJiW2
   eznX5BBS6i9d8ntQ0btVMFT/wXt67PHBwSwXVXe8/LNtksmIlqzmzpIn1
   12CkjFKlMUaAYIlBt9YBvnUTA3ZLpfysf51653AOQpEUPNlX9hhIplFVV
   Vz9l9CnRtq1l4wK/8UtrfKVefN1kAd3HTbvXtGj0f5Jv9m3HP7uMHi3Ud
   g==;
X-IronPort-AV: E=Sophos;i="5.97,276,1669100400"; 
   d="scan'208";a="199507430"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Feb 2023 07:54:15 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 07:54:15 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 6 Feb 2023 07:54:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUNp6TBhCoeSSvCp1kPi9qA7WAC83AiPmOrh53gd52ygupLNDoUWqdkV5NiPH8DxuL2fQEkIELjHUa24UYIuaOBLGTsV9LsHnODHscg7XWxHtM7ydnFBwQCQVoICYUpYvaAlnJn2FrFT/SLI/A4/y2QECikQqmPd7E3rBE46nIGcvj+AA6444DwPH12aPSrW37X0Gb3y9xiCzJ/CUluWzByKgT1+00+ZZ+L4lhfyj7y3bwcGD48rn54RU25DOtAS1BCEpt9AIHfaP3tEpWZcEmId/bZr13Rx1YjFtEwJOmssURTMGext5zjeHvvFyK9JsmyUDfidI7aDPhxxd5yfpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFvjYzwvWCbyA9OdvFBC5mh+gBLLWKF0zndj84KHwUw=;
 b=QXW6k12yeeEq2fDdFur0V7mkrlLA7H4O/Oo4Oaa4VLZumaeBgVAlSAUBHekAgYTowuX/aJWaDY2PAKzdFx2GstcIkgAVw6ldK447MoEOzMyyYHpiZLRojU+l6XecmlP8t06tnk8iDUnQdvrnYByUc4dt5wazqM/gVOUtlIQU8TCA26N+lWo6ns1EXaW7I6eJXoXFcn5wMghhlGGnzZgHvYhqCFBqk2tTFgzU65DIhVwtuNUYRfYirkSf7qjYHGz/HEmoyuH9JN3yBBfxdItu7vpXbMgSHuivhoWplblkvWc4rJsX0z1BAVY450umynL3EWiRC10eYmxgocTDEMG5QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFvjYzwvWCbyA9OdvFBC5mh+gBLLWKF0zndj84KHwUw=;
 b=lWAzod1j7aJXe21FH5MPJMJyYefuXELFG5QSRHvzT8GmTZy8fw4uX0QaB0YZDnAReuru54y6DRF91ucdn9eCL04+jvPW5u63cE5YH/Ct5QTbFJ0lE3ONswQ1Y856xXU3qcbt3xjNBe6r59MlPv3zFi4HnxDwv6bD9oseQJwnYHc=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34; Mon, 6 Feb 2023 14:54:13 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.6064.031; Mon, 6 Feb 2023
 14:54:13 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <wei.fang@nxp.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>, <hkallweit1@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v5 05/23] net: phy: add
 genphy_c45_ethtool_get/set_eee() support
Thread-Topic: [PATCH net-next v5 05/23] net: phy: add
 genphy_c45_ethtool_get/set_eee() support
Thread-Index: AQHZOjI/lcY7X8lCpUePKV0JU6+Pjq7CAVoA
Date:   Mon, 6 Feb 2023 14:54:13 +0000
Message-ID: <da3509e4602e28a1cc0d14cfce72db68808f5947.camel@microchip.com>
References: <20230206135050.3237952-1-o.rempel@pengutronix.de>
         <20230206135050.3237952-6-o.rempel@pengutronix.de>
In-Reply-To: <20230206135050.3237952-6-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|MW3PR11MB4764:EE_
x-ms-office365-filtering-correlation-id: c925d7bf-a6cd-4717-7372-08db08520326
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kqHggnBP4aWAYAIvIajNQ0yExpuAylZ819WLxQImzqlOU61pbJtBDPTl7LL9eXmgw+byCwteXWvqKm67zvN3YS2JrCtogKGjoQtlM1GMS6GGaaaiFIA/Uv01FaxvvjxiWyjgUwX6jtear26rzJ9iDFWIwesy5BcU+no2RkZi0f074VCP5vcBsrNng/Yd1ivT9uLg2wFCgSBZa/JpMhs59GVl1Wiw8fQvxa0M0+mgK/VGtQGrzC5kA5ZHfT5kDSEMmXoFe05g+wYUnwJHbHWQ1DK01V+H87/XtxJfmSd+rgb5XAddfoa5fhthYoJTt3nsoE/1R9VEQlFlx96XR7qGi16UUDKD5NrQoBoJodMrcmsnujVG8U61t5h8u252WXGCmukZtng4nMQSEu8focI7GiFoSrSSL0MKcVNPfoBIouBzJ5aoJhFr3Ui+TXAo2Bj+aZA0sGDby7Sw2CnSsNkaCsGygcoqsp7kX6lxRzq/91HpCox5OTSOUgKgPKtRT6sw6GJp8axQYZHQ8NiZ9c6znZ2WRsIqsU7PohE/dFfuMLEFmCcx6AwcgvHVJv5deNgtQ/a+qGBe6y66oVMLQ0QzEJwZ3Yo1RrWw4+wktqnseUq8UAAA/dnt1N5+RgLkOvckBz7rseZ9BGOizYNgUEzywi9Uh+pLZIxxzsrc0kd620rX3jiVDBcN9wRCvLJIXnkLHmEkbrrffVNQC2V1tsMD2Ou65FDo5ZwnAxRzC7WZgJ5iPzE2pXNKxOvC0CHgDema
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199018)(8936002)(4326008)(6512007)(8676002)(7416002)(41300700001)(64756008)(66946007)(66476007)(66556008)(186003)(76116006)(5660300002)(66446008)(91956017)(6506007)(2906002)(122000001)(38070700005)(478600001)(6486002)(71200400001)(921005)(83380400001)(54906003)(36756003)(110136005)(86362001)(316002)(2616005)(38100700002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWlZajlBQjBUMmVma1kzWjRTaFk3UHpiemlEeDdFUXNGTWJTZi92b3dVWHg4?=
 =?utf-8?B?WTRjV1V4Z2JiV0tMeEI1WVpnRDhESDVtaGxpR1YxcjY1b20wNFRmdjA2Qlc0?=
 =?utf-8?B?RzdPQ2dhUzh0TTFPRnJiVG02MGdXK1ppODByZ3QvOE0yRUo4SlFZM2ZGT1pp?=
 =?utf-8?B?U25WWnF3NWhHZDR6ZU0wRTczb3hsUUQxekNEQWtkN3JWZWZ6M3FpQTBSQzNL?=
 =?utf-8?B?bzJjckUxamdMQVBwaTY5R0FJWEZPYjhBNWxOWktwcXJQVmdJS2U0Qlh4aThu?=
 =?utf-8?B?eHV3Y0hjVkE4NGZrb3FJSmlWMzVTMFdsT0EycGQwT0xCbjZzVXZ5L25JdVhT?=
 =?utf-8?B?aS9yVmRxNTEzd0Yxd2hGU0pZN0o0emQvc2RQN1ZDelNYczRpS25FLzBVTDFN?=
 =?utf-8?B?c01zaXNWRlE5SjF4R1pxc3UrbjF5SGM2ZDBBQlNQeFNUSTc1aUJvYTRJQUQw?=
 =?utf-8?B?WitKNlV2dGpaZnRhL2ErM3ljR2hwcHZLVno3NE02RjYzcmVCUCtpOU9YM1o4?=
 =?utf-8?B?K3F4LzBTR0kvbGdaUFE1SmZMbDkyMXg1ck05MlpPYWxJWEg0UDFkUkhpV3ZG?=
 =?utf-8?B?VHJ0TFMySHVyVCtwL0lPWGJZcHRxOEZIR25sNWlLdllMR3BWQjE4b3A0clBK?=
 =?utf-8?B?KytKZStDc2NUWU8vVG5UOWU2NnlQR0U1czhqQTNYT2tpakYvUFpsUTJZT1o0?=
 =?utf-8?B?UVVmOUlUM3NFclZ2NUlUWXU0bzhHTFBxOUhKRDNDZ08vNnpOcGVGUis2M2Va?=
 =?utf-8?B?Z1c0RFVNblcxK3VoNkR2Ym4vOTVYb1FhNkw3WDZmY0NORE5zR3B2UlZrRElx?=
 =?utf-8?B?K2tkTTJIdW5FYndkR1RXYlA1ajZOQ25lUHQvRCtHTWlkYmwvY1cyUkMvOE1j?=
 =?utf-8?B?bkp6c1pNd0hFaGRlUUNENkR6akVhcHBpb0J3Q3d5RDFsNkdJWkoxRkpNaWpG?=
 =?utf-8?B?czdMeklnYysxRmdxcDNlNzl2NW4zVUt3cWhhZXlubHZjNXBqVGhEMERORDhM?=
 =?utf-8?B?NkJKMlFLZXM3U0xFNjVCMm5jRWV1MFZyVnFjZ2FpNVF6cW5oTEJrYUFlcEJW?=
 =?utf-8?B?bEtKaU9XK1R0MWtBbkhwbWphVnJySVM2K2ZWWldFcnBSK3FEUktQNmhWblpn?=
 =?utf-8?B?YXlzVVRPTFQ0V2NiYng2b281ODBocE1YZ1dTVlF6WGRUZW8xRjFZNm9na0ZP?=
 =?utf-8?B?aXRWNUtJN3dQcmZTSTBwd3hkQzdFK29MZ2Vzckt0MUo1aDRWSW1RL0ttN3NI?=
 =?utf-8?B?V0ltQ0hWVGlxZXMzdVhqcG9WM2FLMHlyYzVkTG50ek9ZSk1NOVZCRUVHRUd3?=
 =?utf-8?B?ZjJGbDFIN0JiMnpZQXY5VWVlVVVyRHlvYUJiOVpQazkwa1orVGZTSGZTay9K?=
 =?utf-8?B?L3dhT1hzR1FrVGJWa1A2RVhnSzZwbWdZb0M1R0ZsNmJ4WFBnbU1RUnBXSng4?=
 =?utf-8?B?QnZ3Tjlxa2czSmg0eHk2L3R0UjRndzFPcU80WXdld083K3kyazNCdzdOSy9H?=
 =?utf-8?B?eklSTnYwOEVwNmZZdGdieUJXVWx2N2J4NGFCQks0MVdGQSs0V09SeiszbDBN?=
 =?utf-8?B?UE1TUmhGWEJycVVTck5hUDVNbnQrdERRanc5QjlCbUNOT2xDQzdZWHN5d0hp?=
 =?utf-8?B?bldicEVDcmQxWHJBbkpIMzVaQTg2UnY0MUs3c0Y4S25OSHVKaGxHRnhTWDlZ?=
 =?utf-8?B?RllRRWJhZ3gvaUVVVjVhU3pxZkQ2ekc1Rnh3enRmL3ZLa28wQWVaRlZ1TEJT?=
 =?utf-8?B?UTVtTVFFVDdwa1BINlcwRkRJY3d2T256a2lwNGZxcmV1a0pDRGZncUx6VG9y?=
 =?utf-8?B?YTR3cC94WjlPcklNY1dEMi93TEorQnRpWHEyR1d5Mk9vK3lzTnZxZDdDc2Jr?=
 =?utf-8?B?bjUxbXlvTHIvc2Y3Vm95eHBweU1qMTFaVDFpRWJHMnN5dnRobFBqYlpZdGRU?=
 =?utf-8?B?WkJTdEpTSmhaTG1ldVlURkhHOU5wd1NicWlJdUxnd1kxVzJQKy9QK0tpeVpB?=
 =?utf-8?B?ZGJaOUFqcVplOWYvaEJudFZXZ2ZJRVcwWHFDQlNRRERPcFBDT1ptM3FxYWxD?=
 =?utf-8?B?M1ZpclIyeTBDemN4dFE4UStRSVQxbmJxdUxRS2x3a05wUW84enF5SVRwQXEw?=
 =?utf-8?B?ZmZNUmRVTFFFQ2M2bURNeWlCc045ME8zUmU1aWlzdWF1ZzZ1alhvc0tsalJ0?=
 =?utf-8?B?UVNjSnRSdmJhNnBKWFZmS2EwWTVVMW1kRXpROXBESVNTTEpUVm54MzloeDBk?=
 =?utf-8?Q?cyZjHCz9v92N2CV3A82uCGACQr1YKqFu5M6QMbUgsY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1493A5F5CEDD5844A905596578CABFBA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c925d7bf-a6cd-4717-7372-08db08520326
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 14:54:13.5780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ukkWgPhwzj/fnen/c2HNALEcB+ToVhVTeWY5xVxtjNOpHxoCjJxqdWwv/7usnAzdbL1ird3cpjRy8VQ5e3198b8E3Zck2OXYPqMnyKm9v9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4764
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gTW9uLCAyMDIzLTAyLTA2IGF0IDE0OjUwICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiANCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9waHkvcGh5LWM0NS5jIHwgMjM1DQo+ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICBpbmNsdWRlL2xpbnV4L21kaW8u
aCAgICAgIHwgIDU4ICsrKysrKysrKysNCj4gIGluY2x1ZGUvbGludXgvcGh5LmggICAgICAgfCAg
IDcgKysNCj4gIGluY2x1ZGUvdWFwaS9saW51eC9tZGlvLmggfCAgIDggKysNCj4gIDQgZmlsZXMg
Y2hhbmdlZCwgMzA4IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9waHkvcGh5LWM0NS5jIGIvZHJpdmVycy9uZXQvcGh5L3BoeS1jNDUuYw0KPiBpbmRleCAzYWU2
NDJkM2FlMTQuLjM4MzYxZGYxZTY2OSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvcGh5L3Bo
eS1jNDUuYw0KPiArKysgYi9kcml2ZXJzL25ldC9waHkvcGh5LWM0NS5jDQo+IEBAIC02NjEsNiAr
NjYxLDEyOSBAQCBpbnQgZ2VucGh5X2M0NV9yZWFkX21kaXgoc3RydWN0IHBoeV9kZXZpY2UNCj4g
KnBoeWRldikNCj4gIH0NCj4gIEVYUE9SVF9TWU1CT0xfR1BMKGdlbnBoeV9jNDVfcmVhZF9tZGl4
KTsNCj4gDQo+IA0KPiAgLyoqDQo+ICAgKiBnZW5waHlfYzQ1X3JlYWRfZWVlX2NhcDEgLSByZWFk
IHN1cHBvcnRlZCBFRUUgbGluayBtb2RlcyBmcm9tDQo+IHJlZ2lzdGVyIDMuMjANCj4gICAqIEBw
aHlkZXY6IHRhcmdldCBwaHlfZGV2aWNlIHN0cnVjdA0KPiBAQCAtMTE5NCw2ICsxMzE3LDExOCBA
QCBpbnQgZ2VucGh5X2M0NV9wbGNhX2dldF9zdGF0dXMoc3RydWN0DQo+IHBoeV9kZXZpY2UgKnBo
eWRldiwNCj4gIH0NCj4gIEVYUE9SVF9TWU1CT0xfR1BMKGdlbnBoeV9jNDVfcGxjYV9nZXRfc3Rh
dHVzKTsNCj4gDQo+ICsvKioNCj4gKyAqIGdlbnBoeV9jNDVfZWVlX2lzX2FjdGl2ZSAtIGdldCBF
RUUgc3VwcG9ydGVkIGFuZCBzdGF0dXMNCj4gKyAqIEBwaHlkZXY6IHRhcmdldCBwaHlfZGV2aWNl
IHN0cnVjdA0KPiArICogQGRhdGE6IGV0aHRvb2xfZWVlIGRhdGENCg0KRG9lcyB0aGUgY29tbWVu
dCBuZWVkIHRvIHVwZGF0ZSBiYXNlZCBvbiB0aGUgZnVuY3Rpb24gcGFyYW1ldGVyLg0KDQo+ICsg
Kg0KPiArICogRGVzY3JpcHRpb246IGl0IHJlcG9ydHMgdGhlIHBvc3NpYmxlIHN0YXRlIG9mIEVF
RSBmdW5jdGlvbmFsaXR5Lg0KPiArICovDQo+ICtpbnQgZ2VucGh5X2M0NV9lZWVfaXNfYWN0aXZl
KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYsIHVuc2lnbmVkDQo+IGxvbmcgKmFkdiwNCj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBsb25nICpscCwgYm9vbCAqaXNfZW5h
YmxlZCkNCj4gK3sNCj4gKyAgICAgICBfX0VUSFRPT0xfREVDTEFSRV9MSU5LX01PREVfTUFTSyh0
bXBfYWR2KSA9IHt9Ow0KPiArICAgICAgIF9fRVRIVE9PTF9ERUNMQVJFX0xJTktfTU9ERV9NQVNL
KHRtcF9scCkgPSB7fTsNCj4gKyAgICAgICBfX0VUSFRPT0xfREVDTEFSRV9MSU5LX01PREVfTUFT
Syhjb21tb24pOw0KPiArICAgICAgIGJvb2wgZWVlX2VuYWJsZWQsIGVlZV9hY3RpdmU7DQo+ICsg
ICAgICAgaW50IHJldDsNCj4gKw0KPiArICAgICAgIHJldCA9IGdlbnBoeV9jNDVfcmVhZF9lZWVf
YWR2KHBoeWRldiwgdG1wX2Fkdik7DQo+ICsgICAgICAgaWYgKHJldCkNCj4gKyAgICAgICAgICAg
ICAgIHJldHVybiByZXQ7DQo+ICsNCj4gKyAgICAgICByZXQgPSBnZW5waHlfYzQ1X3JlYWRfZWVl
X2xwYShwaHlkZXYsIHRtcF9scCk7DQo+ICsgICAgICAgaWYgKHJldCkNCj4gKyAgICAgICAgICAg
ICAgIHJldHVybiByZXQ7DQo+ICsNCj4gKyAgICAgICBlZWVfZW5hYmxlZCA9ICFsaW5rbW9kZV9l
bXB0eSh0bXBfYWR2KTsNCj4gKyAgICAgICBsaW5rbW9kZV9hbmQoY29tbW9uLCB0bXBfYWR2LCB0
bXBfbHApOw0KPiArICAgICAgIGlmIChlZWVfZW5hYmxlZCAmJiAhbGlua21vZGVfZW1wdHkoY29t
bW9uKSkNCj4gKyAgICAgICAgICAgICAgIGVlZV9hY3RpdmUgPSBwaHlfY2hlY2tfdmFsaWQocGh5
ZGV2LT5zcGVlZCwgcGh5ZGV2LQ0KPiA+ZHVwbGV4LA0KPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBjb21tb24pOw0KPiArICAgICAgIGVsc2UNCj4gKyAgICAg
ICAgICAgICAgIGVlZV9hY3RpdmUgPSBmYWxzZTsNCj4gKw0KPiArICAgICAgIGlmIChhZHYpDQo+
ICsgICAgICAgICAgICAgICBsaW5rbW9kZV9jb3B5KGFkdiwgdG1wX2Fkdik7DQo+ICsgICAgICAg
aWYgKGxwKQ0KPiArICAgICAgICAgICAgICAgbGlua21vZGVfY29weShscCwgdG1wX2xwKTsNCj4g
KyAgICAgICBpZiAoaXNfZW5hYmxlZCkNCj4gKyAgICAgICAgICAgICAgICppc19lbmFibGVkID0g
ZWVlX2VuYWJsZWQ7DQo+ICsNCj4gKyAgICAgICByZXR1cm4gZWVlX2FjdGl2ZTsNCj4gK30NCj4g
K0VYUE9SVF9TWU1CT0woZ2VucGh5X2M0NV9lZWVfaXNfYWN0aXZlKTsNCj4gKw0KPiANCj4gDQo+
IC0tDQo+IDIuMzAuMg0KPiANCg==
