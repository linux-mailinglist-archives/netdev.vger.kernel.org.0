Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A07564E4A
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbiGDHH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbiGDHHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:07:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD7D2DFC;
        Mon,  4 Jul 2022 00:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656918466; x=1688454466;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YjR4wgt8loRwj6rfDUOHdBl/OdIuHHdg40cqe4cI1LU=;
  b=KKmJ6QhOgF4l8gJNFF4TWjlXtOeV6NpIFbyYE30O10AjRY6NM+PnfUlI
   XwP7u/tn08BRGppHsNBtUCo2u0f/rLAcs+HgRuuO0tHr1vxxqPcaY37yQ
   urwrDX1vhuSiJksNRcmBNGQMgHtWpvLXp+KB0gt5gdJv9Kme6P4NUhkQn
   ugoyoS0Z0wbnQJ5vGUJ14dy6lYFS8jQNPO2f87nd5na5ZJ4au0HvYPLt4
   BOY+0sBd5/neNP9OAskMIWQhS6XLPchKM/G77rxalvu+Vy11RVcdgpmES
   Sw7luYGs8Z8Kc1GPu480bvDaNysiijWVJ0gdFA7VZ+zwnyfaodxLX22vK
   w==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="170915350"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jul 2022 00:07:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 4 Jul 2022 00:07:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Mon, 4 Jul 2022 00:07:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lM7hRJ6ILvy0rnf8c5RlqfQcjvEWX/w1g33tjkozKcp3tpaimSyyh5buHPqwmaliG+L0pmGL+tJ3Jhc5H2v9L0Nye9enCM9/e8nuCjGQ8w2+DAY4nCZMiK5rljNiPf0fAgKkOIyslApX85ua2VmwFBW/9Bpl061LZA8Dkb1bxs9r207JALOzocswMgu6UbGIgx/kg+SIhb6fLgQNuAh6UWfEKp2xMWu8Wo70VMI1CetH6UFd3xE+er2OWyATM/jGs1dzBPn64Qv0Md81IASs03SWTrLqXAs4sVGcaxTYfvStqJbtIWPDx7FOJgaBAyC8O12xINYt3Wb0JTsy0q6KLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjR4wgt8loRwj6rfDUOHdBl/OdIuHHdg40cqe4cI1LU=;
 b=bQ3Ojz1DacDJc7ExhJjqV6mYgWeAgnipnJOChwSll23H1OH1MSNwheFGbP9M1OrnzdHU0tVV4qNFUpMI3yoCoEpWrak+GNgdU4+SW1ZaMcNALJewb5ZRDb0w/T0S+6MN71MraDufvBJ75ehQQotBVyNjbAVilN6gXnF+1ysdS8U+JNIJPubJYY61XQ4mJM74GUuIdfMwTotpmlRC2dfuPyeI9+zkCU72NhQ0Ne4jHR/+KepJlwdZ5jsmFBeh+jGDyjm2IV3DrGO22HigUEKgR4UC5xRoD0N8HwKCjcJ38PeIr3zervZQtBJdbNjixrcqh8BXNz864pYP63FZ/HHaBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjR4wgt8loRwj6rfDUOHdBl/OdIuHHdg40cqe4cI1LU=;
 b=M+mkC7Y+OLTOJVC3HQCf6qzlZVedl+yaRq3NWQ435dnYeqDmza5eAQf+XhPKx4wSo5+uPO0zbo42uMhHeuNS8qVRYT109qfq/sUB2k98+zuOgjjlzfeAgIKLIsMG4kZozqTvz5njXh/qUsxFJI2C//IOEY2YfN3e2upR/DNYS+s=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by BN6PR11MB4052.namprd11.prod.outlook.com (2603:10b6:405:7a::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 07:07:40 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c%8]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 07:07:40 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <Conor.Dooley@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <Nicolas.Ferre@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH RESEND 2/2] net: macb: add polarfire soc reset
 support
Thread-Topic: [net-next PATCH RESEND 2/2] net: macb: add polarfire soc reset
 support
Thread-Index: AQHYjR7TauaCitsCNUadh5DGhDTAlg==
Date:   Mon, 4 Jul 2022 07:07:40 +0000
Message-ID: <7306d7c3-fab1-e645-e996-c1f281979fe1@microchip.com>
References: <20220701065831.632785-1-conor.dooley@microchip.com>
 <20220701065831.632785-3-conor.dooley@microchip.com>
 <25230de4-4923-94b3-dcdb-e08efb733850@microchip.com>
 <0d52afa2-6065-25c5-2010-46aaa0129b59@microchip.com>
 <06936f06-88d5-e3e2-dc23-9d4a87c0bf5e@microchip.com>
In-Reply-To: <06936f06-88d5-e3e2-dc23-9d4a87c0bf5e@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba6aa431-a160-42ac-efd3-08da5d8be239
x-ms-traffictypediagnostic: BN6PR11MB4052:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tLsK6OHPOyILazoVVnvAbUZvsOCAk3wph7BdJQgT0bsfSmeHyn8fy4uHCWFIbolsivP18l0MPP0hCCqdaduLTCNX3UNWoJ2OCgHQa+Mum06Jcs74P8b4oN0hJ3UAbI/nXdfI5UNYwSuFslQGidaetSZpXrUqo0uFP3Fg2WXtVj17uQ5CqhOUzxJ7eNY86moUB7IWY8lKUwiwIPfoAZ+SgBHK9xqpRtsQpE+1+ujjkGw6+JnYlQTCwK2srH9rRL85ef0P+xflSQx4huQv0U2PHVwOt+zmmLxxlToqzmKuTqRtjsNa+fqtf0FAn0RqanX8U7q+C633QDQXju2MOA9g+ao3nAUVTko8po/FftclaequB+/80K+JWtJ9AkG6FFyFkY09qy6ZWP3PGaCquzAu+Na1SAU8TFGGhNxBuL3ma77E4PGu9xPs/TZpkIYun09vVk9qQ6yblERomrVkNffm9UjseJH3edtaFd52Msw2jamzy8WMKXJrcakq2WGz+dBmxXcWZzwCnC9beF3j8JdFdTUYAN/cdDnfXL/GvbNlZ/eSy6YaKugrHU7duHr4Cgar6nuswen5QXwka+GsKfnJplom1zKCqP6kRTltCUF19tyNGeGGPCOE6+WzHuWbVrRMQAmnZilIV8eImcWLIZnnzkMw3K9fNsGY9VQlcM8PkaXTxicXpyFrNVgyB9YWDlhHbHUXaepzXb4p+CBbeZZSE+omtQGgRGkQR4FRJeA20SnK5eEwsO2qFttQ+0CqByziOKwWwHDwsNNC6sXnpo3tqrVgOMep3XL9LW6yFFk23q9cxjcPhsw4qAThOJLSkNT+F8QDfEqj6qeUufreNkrHRX5AVXfTEF8FaU8LWtTceBZJvG8CIewAG4cU7qJsJPBd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(346002)(366004)(39860400002)(136003)(478600001)(6486002)(71200400001)(186003)(31696002)(36756003)(31686004)(2616005)(41300700001)(86362001)(5660300002)(8936002)(2906002)(7416002)(110136005)(38100700002)(6636002)(54906003)(316002)(83380400001)(26005)(6512007)(6506007)(64756008)(91956017)(66446008)(4326008)(8676002)(66476007)(122000001)(66946007)(76116006)(66556008)(53546011)(38070700005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEdXWmoydXpWQXhLeDQweHRwai9MQU1PRVpvS2ZKWCtKcHlUUzYzbE90ZEha?=
 =?utf-8?B?dVVrS25tYktZQW5iRS9pRVZyYU03ZjU3Mld6K3RYQnZGQ2x3M2NhMDg3OEtS?=
 =?utf-8?B?TGw2YXNjdmZ1cEdVeXJHWnB4NkZZNUgyL0xFemtPOHJrREl5cEphbE5WejBS?=
 =?utf-8?B?SWJTZ09oeHRTZ1hEMUhoZkMxKy9SOThpcGJTTC9hN0psYTRhaUZJaVhneFBz?=
 =?utf-8?B?eVdudXRGYUJMUE9aY2lmeGRGVE5TaFRIK2JiQ2RZMVlKQmREc3VrektJaWtr?=
 =?utf-8?B?QldBTXl5VVVQUm9pRktSQUM3bDVwU3YrNzB1aFphNEFBWFViZG5jMFJtSGc1?=
 =?utf-8?B?SjhGRVVLbTFFMUZBc3FNSXErNlRDTStJL08vamVuRVpUK1FoUzJ0SVJ2Q3h6?=
 =?utf-8?B?UGZTSjJPT2lqa1lMbnlXdldZUHI5cXgwbGpsRm1wNGZVQnVpb3RIVGdmTGsv?=
 =?utf-8?B?WkNmZ3liRmZQUmR6WHZBUEd5K2N6WXZLYjRVNmY5c05zVW4zalZwVWRONXA3?=
 =?utf-8?B?bnN3WEd1M0pWUUFvRDFtZ1VyTlFUbVB3bytLQzcvVUpxUkR4SFUvT3dBTHdW?=
 =?utf-8?B?bFdkelJCU1plbUJndzhQN0Mwa210YURBZDFqMDJRUFg5VUhkSUs4RE15eWFY?=
 =?utf-8?B?T081Z2hES0pxY1NqZ1pGdGZlS25WdlZXQm9PRFR0NjN2NW9mZ2hydG1uOXBx?=
 =?utf-8?B?dmF5Sy8ydzVadDg1MWFZaHhVRjRQN1RzNUF4RnBxVjlDUEsyOWRTNzVVODJ3?=
 =?utf-8?B?ZlAvSC9GcWJkdEdsa0ZiNndac2VrSXluTjJ5SmlxWXRNM1dUdHR4dkh1T0Vo?=
 =?utf-8?B?NW1MbTBFdzFSQzBsRkhlSDJxdW1ROXZtQTBEb09wUEpZeG1mTEFSZE1tQVZh?=
 =?utf-8?B?MTNveldTYldOT1J2Sno4Y21QMFRGSkFETHV4WFpzdkRqam1wRmtWL1p6ZWtM?=
 =?utf-8?B?d1RQQ05yaDNkNThWc3Y3VXM2UFQreGRSdk1vajlQeEpiOGxOVjdpV1Z4WTNl?=
 =?utf-8?B?aXJZbzRkOWNNMEk3THZ1VlJBd2o2aUl0SDFiMEZvZTdpUFFiTFhqdnQ4dUpG?=
 =?utf-8?B?NzhpRUtBalRqb1FVTnFYMFYvZ29MT05QQmhTZDVwZmZZTmZpWnlWMVFsdmtu?=
 =?utf-8?B?VzBuOFk5RjlyUzdXM0Q5V0JHVFJheTVETjN5VEJhNzNxb2FrcHFhUDVFV3Qv?=
 =?utf-8?B?ckhXQ3pJZi9XeWNrVjd2K2NOVzROVDVETjhjenhRQ29TckRGUUdlYnFGdm5x?=
 =?utf-8?B?UXRiNy9GSHZRMFljaWtFNnJuZkVLdWtHZWFydW9oWmhkTXZ1bTRicU85U21h?=
 =?utf-8?B?VWkxcTBEQndWMlRWaUV1ZUtaalpiZWZJRjVQaXFkNlJWZzlKMllaejVMNzdL?=
 =?utf-8?B?azh3bndMNHBRZlE4UzdCa3I1TUw1K214WDhuQlppQWZzaVpmVnI4TEFKNFg5?=
 =?utf-8?B?dkh5NzE0WTJtS2oyekNSQ3RXc1JSWDg5RzcxRk5hRloraHJ6OVF2UnBuZmtO?=
 =?utf-8?B?Und6cmFRMWx4SjZpZG0yZUZZdlhYK2Jsdm1DT2M5QklubEJDaUpCd0RVdzQw?=
 =?utf-8?B?OXd0U0laSFR2TURyenk4R1hmMDBucTVheXV6QUdnbHV3Zmd0eVE2WDZRdEgr?=
 =?utf-8?B?VGdNenNUTWxqeXlsWi9TZ3JDQ21keUcvN2xSMWJldkdLTmtUMitHeHg1bVd6?=
 =?utf-8?B?eWlJRHFCM0RSQ2hQZDlRelVjSmtIcGlpYlIzSmxNNVFHOVQ2T3dEdkh6MXoy?=
 =?utf-8?B?UnBqR3d3MUFHQldEUk9aUW0vRVBnT1Rha2dZVEpZN3BIREh3VHF1OGtmMHZ1?=
 =?utf-8?B?WkxzRlV0T2I0ZDhYK0tVMG9xSEc2S3Z2YXFuRlJWTzBqQ04xN2ZkdDZmTTl1?=
 =?utf-8?B?WWNTTjdJbUxQZE5RVmxwTEgxVEZHTnVST3dBVC9nNXBLSDU0d3V0UTM3U3Bl?=
 =?utf-8?B?ZmxzY1A3MUdJcis3VkJ1Qkc1WWRVZGZ5cG9RSDFrSVhpTnppaDBaMmtxZDRF?=
 =?utf-8?B?c2hoVHZxRk1idExiZ0o3ZDgrRWkwODZrODdLZHYvakErUWx1OUdYN0tweUF2?=
 =?utf-8?B?dW91d05CZU5CMUZmVSt1aDdCc3lDOHRHSmhOWTNSTzhEcWZOYVlUeWlvMEhI?=
 =?utf-8?B?MlJsd29ZaENRMHhTTkNvSENwUzBzYjAvWmM3OXJCU05nUENrS2dxQUwzb1NL?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A99041BFA2F819408485E540CB3DAD4F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba6aa431-a160-42ac-efd3-08da5d8be239
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 07:07:40.3162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7dLziNSCLLHHxudTK4C3x5zPtBvBuuaPj7Bfkw4HXNh6eMNa8UJPovw9Ff74W7/dp0mNd1SrSdXzVyWOViQ0ixQUf5dNxkmu2yCsrBtxYFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4052
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDIuMDcuMjAyMiAxODozNCwgQ29ub3IgRG9vbGV5IC0gTTUyNjkxIHdyb3RlOg0KPiBPbiAw
MS8wNy8yMDIyIDA4OjU1LCBDb25vciBEb29sZXkgd3JvdGU6DQo+PiBPbiAwMS8wNy8yMDIyIDA4
OjQ3LCBDbGF1ZGl1IEJlem5lYSAtIE0xODA2MyB3cm90ZToNCj4+PiBPbiAwMS4wNy4yMDIyIDA5
OjU4LCBDb25vciBEb29sZXkgd3JvdGU6DQo+Pj4+IFRvIGRhdGUsIHRoZSBNaWNyb2NoaXAgUG9s
YXJGaXJlIFNvQyAoTVBGUykgaGFzIGJlZW4gdXNpbmcgdGhlDQo+Pj4+IGNkbnMsbWFjYiBjb21w
YXRpYmxlLCBob3dldmVyIHRoZSBnZW5lcmljIGRldmljZSBkb2VzIG5vdCBoYXZlIHJlc2V0DQo+
Pj4+IHN1cHBvcnQuIEFkZCBhIG5ldyBjb21wYXRpYmxlICYgLmRhdGEgZm9yIE1QRlMgdG8gaG9v
ayBpbnRvIHRoZSByZXNldA0KPj4+PiBmdW5jdGlvbmFsaXR5IGFkZGVkIGZvciB6eW5xbXAgc3Vw
cG9ydCAoYW5kIG1ha2UgdGhlIHp5bnFtcCBpbml0DQo+Pj4+IGZ1bmN0aW9uIGdlbmVyaWMgaW4g
dGhlIHByb2Nlc3MpLg0KPj4+Pg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBDb25vciBEb29sZXkgPGNv
bm9yLmRvb2xleUBtaWNyb2NoaXAuY29tPg0KPj4+PiAtLS0NCj4+Pj4gwqAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDI1ICsrKysrKysrKysrKysrKysrLS0tLS0t
LQ0KPj4+PiDCoCAxIGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMo
LSkNCj4+Pj4NCj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2Uv
bWFjYl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+
Pj4+IGluZGV4IGQ4OTA5OGY0ZWRlOC4uMzI1ZjA0NjNmZDQyIDEwMDY0NA0KPj4+PiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+Pj4+ICsrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4+Pj4gQEAgLTQ2ODksMzMgKzQ2
ODksMzIgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBtYWNiX2NvbmZpZyBucDRfY29uZmlnID0gew0K
Pj4+PiDCoMKgwqDCoMKgIC51c3JpbyA9ICZtYWNiX2RlZmF1bHRfdXNyaW8sDQo+Pj4+IMKgIH07
DQo+Pj4+IMKgIC1zdGF0aWMgaW50IHp5bnFtcF9pbml0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2Ug
KnBkZXYpDQo+IA0KPiBJIG5vdGljZWQgdGhhdCB0aGlzIGZ1bmN0aW9uIGlzIG9kZGx5IHBsYWNl
ZCB3aXRoaW4gdGhlIG1hY2JfY29uZmlnDQo+IHN0cnVjdHMgZGVmaW5pdGlvbnMuIFNpbmNlIEkg
YW0gYWxyZWFkeSBtb2RpZnlpbmcgaXQsIHdvdWxkIHlvdSBsaWtlDQo+IG1lIHRvIG1vdmUgaXQg
YWJvdmUgdGhlbSB0byB3aGVyZSB0aGUgZnU1NDAgaW5pdCBmdW5jdGlvbnMgYXJlPw0KDQpUaGF0
IHdvdWxkIGJlIGdvb2QsIHRoYW5rcyENCg0KPiANCj4+Pj4gK3N0YXRpYyBpbnQgaW5pdF9yZXNl
dF9vcHRpb25hbChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPj4+DQo+Pj4gSXQgZG9l
c24ndCBzb3VuZCBsaWtlIGEgZ29vZCBuYW1lIGZvciB0aGlzIGZ1bmN0aW9uIGJ1dCBJIGRvbid0
IGhhdmUNCj4+PiBzb21ldGhpbmcgYmV0dGVyIHRvIHByb3Bvc2UuDQo+Pg0KPj4gSXQncyBiZXR0
ZXIgdGhhbiB6eW5xbXBfaW5pdCwgYnV0IHllYWguLi4NCj4+DQo+Pj4NCj4+Pj4gwqAgew0KPj4+
PiDCoMKgwqDCoMKgIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBwbGF0Zm9ybV9nZXRfZHJ2ZGF0
YShwZGV2KTsNCj4+Pj4gwqDCoMKgwqDCoCBzdHJ1Y3QgbWFjYiAqYnAgPSBuZXRkZXZfcHJpdihk
ZXYpOw0KPj4+PiDCoMKgwqDCoMKgIGludCByZXQ7DQo+Pj4+IMKgIMKgwqDCoMKgwqAgaWYgKGJw
LT5waHlfaW50ZXJmYWNlID09IFBIWV9JTlRFUkZBQ0VfTU9ERV9TR01JSSkgew0KPj4+PiAtwqDC
oMKgwqDCoMKgwqAgLyogRW5zdXJlIFBTLUdUUiBQSFkgZGV2aWNlIHVzZWQgaW4gU0dNSUkgbW9k
ZSBpcyByZWFkeSAqLw0KPj4+PiArwqDCoMKgwqDCoMKgwqAgLyogRW5zdXJlIFBIWSBkZXZpY2Ug
dXNlZCBpbiBTR01JSSBtb2RlIGlzIHJlYWR5ICovDQo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBi
cC0+c2dtaWlfcGh5ID0gZGV2bV9waHlfb3B0aW9uYWxfZ2V0KCZwZGV2LT5kZXYsIE5VTEwpOw0K
Pj4+PiDCoCDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKElTX0VSUihicC0+c2dtaWlfcGh5KSkgew0K
Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBQVFJfRVJSKGJwLT5zZ21paV9w
aHkpOw0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkZXZfZXJyX3Byb2JlKCZwZGV2
LT5kZXYsIHJldCwNCj4+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAiZmFpbGVkIHRvIGdldCBQUy1HVFIgUEhZXG4iKTsNCj4+Pj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAiZmFpbGVkIHRvIGdldCBTR01JSSBQSFlcbiIp
Ow0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0KPj4+PiDCoMKg
wqDCoMKgwqDCoMKgwqAgfQ0KPj4+PiDCoCDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0gcGh5X2lu
aXQoYnAtPnNnbWlpX3BoeSk7DQo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocmV0KSB7DQo+
Pj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl9lcnIoJnBkZXYtPmRldiwgImZhaWxlZCB0
byBpbml0IFBTLUdUUiBQSFk6ICVkXG4iLA0KPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBk
ZXZfZXJyKCZwZGV2LT5kZXYsICJmYWlsZWQgdG8gaW5pdCBTR01JSSBQSFk6ICVkXG4iLA0KPj4+
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCk7DQo+Pj4+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiByZXQ7DQo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCB9
DQo+Pj4+IMKgwqDCoMKgwqAgfQ0KPj4+PiDCoCAtwqDCoMKgIC8qIEZ1bGx5IHJlc2V0IEdFTSBj
b250cm9sbGVyIGF0IGhhcmR3YXJlIGxldmVsIHVzaW5nIHp5bnFtcC1yZXNldCBkcml2ZXIsDQo+
Pj4+IC3CoMKgwqDCoCAqIGlmIG1hcHBlZCBpbiBkZXZpY2UgdHJlZS4NCj4+Pj4gK8KgwqDCoCAv
KiBGdWxseSByZXNldCBjb250cm9sbGVyIGF0IGhhcmR3YXJlIGxldmVsIGlmIG1hcHBlZCBpbiBk
ZXZpY2UgdHJlZQ0KPj4+PiDCoMKgwqDCoMKgwqAgKi8NCj4+Pg0KPj4+IFRoZSBuZXcgY29tbWVu
dCBjYW4gZml0IG9uIGEgc2luZ2xlIGxpbmUuDQo+Pj4NCj4+Pj4gwqDCoMKgwqDCoCByZXQgPSBk
ZXZpY2VfcmVzZXRfb3B0aW9uYWwoJnBkZXYtPmRldik7DQo+Pj4+IMKgwqDCoMKgwqAgaWYgKHJl
dCkgew0KPj4+PiBAQCAtNDczNyw3ICs0NzM2LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBtYWNi
X2NvbmZpZyB6eW5xbXBfY29uZmlnID0gew0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBNQUNCX0NBUFNfR0VNX0hBU19QVFAgfCBNQUNCX0NBUFNfQkRfUkRfUFJFRkVUQ0gsDQo+Pj4+
IMKgwqDCoMKgwqAgLmRtYV9idXJzdF9sZW5ndGggPSAxNiwNCj4+Pj4gwqDCoMKgwqDCoCAuY2xr
X2luaXQgPSBtYWNiX2Nsa19pbml0LA0KPj4+PiAtwqDCoMKgIC5pbml0ID0genlucW1wX2luaXQs
DQo+Pj4+ICvCoMKgwqAgLmluaXQgPSBpbml0X3Jlc2V0X29wdGlvbmFsLA0KPj4+PiDCoMKgwqDC
oMKgIC5qdW1ib19tYXhfbGVuID0gMTAyNDAsDQo+Pj4+IMKgwqDCoMKgwqAgLnVzcmlvID0gJm1h
Y2JfZGVmYXVsdF91c3JpbywNCj4+Pj4gwqAgfTsNCj4+Pj4gQEAgLTQ3NTEsNiArNDc1MCwxNyBA
QCBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfY29uZmlnIHp5bnFfY29uZmlnID0gew0KPj4+PiDC
oMKgwqDCoMKgIC51c3JpbyA9ICZtYWNiX2RlZmF1bHRfdXNyaW8sDQo+Pj4+IMKgIH07DQo+Pj4+
IMKgICtzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfY29uZmlnIG1wZnNfY29uZmlnID0gew0KPj4+
PiArwqDCoMKgIC5jYXBzID0gTUFDQl9DQVBTX0dJR0FCSVRfTU9ERV9BVkFJTEFCTEUgfA0KPj4+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBNQUNCX0NBUFNfSlVNQk8gfA0KPj4+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBNQUNCX0NBUFNfR0VNX0hBU19QVFAsDQo+Pj4NCj4+PiBFeGNlcHQg
Zm9yIHp5bnFtcCBhbmQgZGVmYXVsdF9nZW1fY29uZmlnIHRoZSByZXN0IG9mIHRoZSBjYXBhYmls
aXRpZXMgZm9yDQo+Pj4gb3RoZXIgU29DcyBhcmUgYWxpZ25lZCBzb21ldGhpbmcgbGlrZSB0aGlz
Og0KPj4+DQo+Pj4gK8KgwqDCoCAuY2FwcyA9IE1BQ0JfQ0FQU19HSUdBQklUX01PREVfQVZBSUxB
QkxFIHwNCj4+PiArwqDCoMKgwqDCoMKgwqAgTUFDQl9DQVBTX0pVTUJPIHwNCj4+PiArwqDCoMKg
wqDCoMKgwqAgTUFDQl9DQVBTX0dFTV9IQVNfUFRQLA0KPj4+DQo+Pj4gVG8gbWUgaXQgbG9va3Mg
YmV0dGVyIHRvIGhhdmUgeW91IGNhcHMgYWxpZ25lZCB0aGlzIHdheS4NCj4+DQo+PiBZZWFoLCBJ
IHBpY2tlZCB0aGF0IGIvYyBJIGNvcGllZCBzdHJhaWdodCBmcm9tIHRoZSBkZWZhdWx0IGNvbmZp
Zy4NCj4+IEkgaGF2ZSBubyBwcmVmZXJlbmNlLCBidXQgaWYgeW91J3JlIG5vdCBhIGZhbiBvZiB0
aGUgZGVmYXVsdC4uLg0KPiANCg0K
