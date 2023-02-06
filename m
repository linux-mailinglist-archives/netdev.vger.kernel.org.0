Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC9F68C069
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjBFOq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjBFOqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:46:25 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4DC7A9E;
        Mon,  6 Feb 2023 06:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675694783; x=1707230783;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZaYkIWMfcG9TLdutmPiemjcxNgahUn8lVhERyZkT0/4=;
  b=TlTuGddFDseyJkI1oESeN1I8l83tHnN8zfwUny/IP2JM+ODq74PSt0J2
   VwCX0puuES7tuUnYNbKygUrtU332UFQq7HtHUpGpyP95fTU0GsBHC1l68
   TwSqey8QDtNNuXIWi4Uv2c9Cigz+E42AuDxMW7TMox2MEGRuxMhIlKXa0
   oj0nnipSp7k3SyjNdJm10MbG//yvanw0sIjhz7Zwpa5E2Gbnl4z22L26J
   JfjFd4sA7inwQTFmhxIqVOETV0Hs0R4t1/mMij0750TxwLEbpHK5haUaj
   ZSESj8Jz+nX3fERrOXwIDXHPpb+Ls42qkYPtxcFiceCDX7vBEmEKsOL+k
   g==;
X-IronPort-AV: E=Sophos;i="5.97,276,1669100400"; 
   d="scan'208";a="135763840"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Feb 2023 07:46:20 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 07:46:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 6 Feb 2023 07:46:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltEfoa9kB2f0IbNsDGgfYYcn0ZLltiIWeh0hYUosCTVfEju+FEMnsHacu8TcKxWkLIIVlEesawKCXBORnG3b5Mi19pf9JGBnPJ0wS0zy5hWWYGZVtBw9ySyNu4shG+BVTycEU/OysVeRp3XOmDfCXgQnuTGrzr3gWkm49p8XNyoQCkTPTDx81RJU2fUTWMbtFp+B7C7ZMsjjX8j43FOanNjV3qImH61Ym45adpnEhewIVqBb3cyE5jDpH/DOFcJ3wp8rhFo6bv1nVqfj7g1XK+8iPfz1aqYx9n+hIDEOcr0GqSSLD94U32Iy/ueHMOdOz+JbDh7vhfJUjMnfv49hCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaYkIWMfcG9TLdutmPiemjcxNgahUn8lVhERyZkT0/4=;
 b=ByP9nBz6Tx7+fLDKJSlJ6VAVVVrTFlAJ8CTGsXvyIOjt8SUkI9+3Q4WV3rHnQzGaX86JeAdjSvrAn9bFOwkFJqE7XRyQrPt0g/jXWAPTMqFIkkh/4jUh/arjPFOVEA0ow1PGamHwe0bsHcloxpZqZ/PtQM5iNC1co7c9JWUO1yMZ8m5GkgbQspevXmkN9zahfF7xFc8OVFE0PV06TPEB75cGIq3wpo3bhLXMTU8QfgxlL+f6awjaD+/uFBffXj4xKd5WuS85TJCy5VTW1aN6/J2ff5AB7rjvb4GgFDFjTVM8AoDi/mixkUdcJu0Va75304cVUqemHJQIH9hYlw2WIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaYkIWMfcG9TLdutmPiemjcxNgahUn8lVhERyZkT0/4=;
 b=jigxnGnONnicQm1HA/uFd3G60kZ7JMKELFv0WteI23fgbkS9cCVBgJeSFE4LMU/BGe/eXhqTxvbqH8DHYhCMoXtPofZyKCJDK/ZdiYdO6F/j7n9MYAhhsme11pcRcUjd2BwPS5bUrTT8H+Tsb+moTEmqdW52B4SOZRPa2QUPBiI=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SA0PR11MB4621.namprd11.prod.outlook.com (2603:10b6:806:72::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34; Mon, 6 Feb 2023 14:46:19 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.6064.031; Mon, 6 Feb 2023
 14:46:19 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <wei.fang@nxp.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>, <hkallweit1@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v5 02/23] net: phy: add
 genphy_c45_read_eee_abilities() function
Thread-Topic: [PATCH net-next v5 02/23] net: phy: add
 genphy_c45_read_eee_abilities() function
Thread-Index: AQHZOjI7xbLjcLVlr0W7AfhUp+nroq7B/yUA
Date:   Mon, 6 Feb 2023 14:46:19 +0000
Message-ID: <af4fa39e31a6275a07c577cb3d7fa5f114bdda05.camel@microchip.com>
References: <20230206135050.3237952-1-o.rempel@pengutronix.de>
         <20230206135050.3237952-3-o.rempel@pengutronix.de>
In-Reply-To: <20230206135050.3237952-3-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SA0PR11MB4621:EE_
x-ms-office365-filtering-correlation-id: 7a6e399d-1fbf-4e17-18a8-08db0850e8b7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XItCIV2PMdru2KE47HHVPbjVYiE8FrZ6m6zGHZgmDt7maHol7Wnn3D/b94ohK9kV/SDiES95Jw6KM0h6wV5Ljk/nVTtID8OQ6WA8DVxdv6CndU/0udolKZXYQu9/sjbKJCXyaEBmMGNqMmGXjzqDJLwllSB9b2PiZDHO6MH7IT3Bgbhy6BfSm00O3ePJ1n4sT2g79WbzJC2MrOjjNyvthnATMZGTMti9sEfOgde0PYoLro3aq2zVpM2nhJUp3q0vappkn6GwYNUho7wpwskePgNTWVVHNb34uRiARlteiGpWO30GawaEYmKHn/pSiK0ZpS1ifnmhJl7hmckCYesmetiKgvcnKmsPYgZapHgbW8YxBgRUYspjZwI3R8Y6gtCN4TsClaElcMwWmW2GeS+iHInXvGRrUUKzOP0o/3+8uoBlsnWblp+Wc78SerlzOW+V5tLNVjKi6howBaK/5IZvuTlIYFW3vujYm4TfsY/M+t/UzrDgX8ZQUsTh6YeQWBRDs48amdMl2X/vIWj14i52/aSn5+koOW4Ar3BwoGLrgReu61W1X8oQgckpHGbnc0AN3i3x/07sH5gj0+kne7yFdhD74cYtbWd5tKCmg4bkwsdl/tYdB3WP/+ZHnorzMgERul5vDQtc2QXlMqmWMj8bsW3yw7bO+/0xXFGlgIGT+RSRawWrVednH6ogIZYTyeob6jYCovatHpOGL0Xe92l8U+gcfEIfs/YAq8oDtA/x7FgeWvHszFI5UBIv0UjR4MgE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199018)(122000001)(186003)(38100700002)(6512007)(6506007)(36756003)(7416002)(2906002)(83380400001)(478600001)(6486002)(71200400001)(110136005)(54906003)(38070700005)(64756008)(2616005)(4326008)(66946007)(76116006)(66446008)(66476007)(66556008)(91956017)(41300700001)(8936002)(921005)(8676002)(86362001)(316002)(5660300002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NnVROTRLVm9WeGVaQ2hkWThNRUFFSEs2bzhWWUZydXlYTktJMDYraklTRXlM?=
 =?utf-8?B?UDkrL2JmdW5TQ3dKdGNiYnV6UW91ZmppclV0RnhuWngwZC9ocjJxS1FXbkFx?=
 =?utf-8?B?YkErbnZGYnZ6a3RhcTRDeHAyNEZ0ODMyN0M1ZnUwQlpBaUFqODB6RDYvU1lF?=
 =?utf-8?B?a2djQmJCY01xY3RaL1dORmhQODhVeHk1bDdJWkdoZHh1djlZVlY3NnBXRmhU?=
 =?utf-8?B?bmZ1Q3V1V2E3TnZFdGRrRjNWcEVlMXlHanZJSmRlWTZxdEI5eXBOU2MrOHE1?=
 =?utf-8?B?TEdidG5jZXRDcE1mS0tMWUR3WlRUaFlRTlFLOVFUMGRPNHdYNUxUanZWcksz?=
 =?utf-8?B?OHltY1dyK0ZKREtsbERFZnBwSzhyTnpqQkRKQlU1cDViR2lFVzBOMXNuc0VE?=
 =?utf-8?B?NmRkS3hIZmdxeldhL3BvbW1SdDNSVlR4ZnVSckdicWRqS0h4ZE56OVlRUlJZ?=
 =?utf-8?B?QUJYMUplMmZzTlRDdllZZlhPRU0yMk5CemdQUUdaMjZ4Q0c5OW51T3FOYkxR?=
 =?utf-8?B?b3Z6aS94OERjckRHN2xuV2RzSVpFUjJaU050YWk4ZWVBTmRiWk1KVTJvZ2dx?=
 =?utf-8?B?RUtpa1Vwb3gzdjFacjRQOHlOYTYyV1FLS1FEZjMydGp3UEFYWHpkZ0RyOUZx?=
 =?utf-8?B?bDMwWCs2Mm50V1BqWmtsL3ovQVAwbHAzTVhDMzhmVEwrOC9JRzVTdGJwL2tt?=
 =?utf-8?B?NDFhYU5UZUNrRWZMSHk1Nkp3by85WXhNc0ZabmVhOXZiUWdwZ1VRUHhOb2Fz?=
 =?utf-8?B?TTNITFlQaHdoV012K0V3WFNubU90bUVZQWRCKzRXR0doWGlDMmJEVjFpTlJP?=
 =?utf-8?B?bjNIWG5CNklFd0lSQzFOVkxZMFFtZXRuSEpDK002aVREeE9sbjlIUi9HRDhT?=
 =?utf-8?B?L3UxdHdOSmkvZWc2VXBMZTJuU1BZYWMvNU5vSEFEZUk0clFDT204N3J3dSt3?=
 =?utf-8?B?RmtiRDhHMjFkU0FTa29Edkw0TWoyMGZFM1Jma0E3Qmx0K0dTN3d2QVVHUFBh?=
 =?utf-8?B?eUZhR3E0aWlOeDliU0Z5Uk5uOVRDdVRLTWdONVltd2pYSkhyZUZmT2l6SmFE?=
 =?utf-8?B?NWhFd0F3d25pQkFyRjZPNFhIbFhuU0d4N1I4Ti9WZjkvSVcvNnpxVXorUEg3?=
 =?utf-8?B?M2dxT2d6U1pYZjljYVhxMEhxK3FqVTd0VkNsd3BNVFF2WkY1VzlzdzM0OVds?=
 =?utf-8?B?RDROQW5qRW4yZ2NTRVI3RklwWmNJZUpWMXVhK1l3QzV4RWFwVFlvSkxzNHZQ?=
 =?utf-8?B?WEpRNmVrTmFxcmxvdG15L0wvM1hZQTc2eHRsKzJhVTB2ZHZJTzd2YzBJRkFS?=
 =?utf-8?B?amhHTmIwRnE5TjR1bmp4bXZndWkyY3kzN2txZitpQ1orbVgxU1FCcW9HVEhy?=
 =?utf-8?B?TFBvMER2bk9vTDhmMEFreXdYNDkrcGlMcUdDbjFweTVZM3NKS05yb2dIcTBC?=
 =?utf-8?B?M2gxay9Xa2Vrc0V3NEZkUzE1blZYQ1dxbTduZllYZjhiYmdwZHRVQ2VhUlE2?=
 =?utf-8?B?U0lqTWc1SURVdXI4dlkrVURCbHpoUkxVR2g4Vm5YaDczS0JCc1luZG9XdElp?=
 =?utf-8?B?SWZPcmVOaUtJMHhvLzFHS1NKRlAySTBTVzREYmk3YTY5LytGR1lDa1JxTGtW?=
 =?utf-8?B?em93NU5Eci9tVERaS294VWxMQVZaVXB6T0t4NkNMN0Z6azV4RVYrSUpudnlC?=
 =?utf-8?B?TzFLN0tCQThpemRma054YWtqek9aYXpNK0RJMDZjWUxNVzhTNUVhcFBUcUZa?=
 =?utf-8?B?aUtFRUdrMWJWeTIxUnZrWm8rK3hZWEdZbkVJTzBXTHVWTEhJRnRTVmx6aC9L?=
 =?utf-8?B?UFp5ZllwSTBzT3E0QjN3bm5rOERIV1hzQVFPajUwZUhHc3JzdHpmdGdkeERP?=
 =?utf-8?B?bER0eFIzaXVPSEJxRjdLUDk1N3gvWkVNQVVIU2R3a3RtTDh4RU50OFlKVUxw?=
 =?utf-8?B?c0Z1SjVXcFdCVFdaM2ZtRzhMdFNBaEVNR2dCc2dIOE5nNkd6RnN6UjQzdUtW?=
 =?utf-8?B?YWtWdlBvQnVqWWczcEIxRVRPT1docUZoY2JEZjRWeDhNamx5SE9pTmI0UndG?=
 =?utf-8?B?dk96bjhXajFXVkVUd29qNHJaZ2wrR2xSMFdYWUhlWjU0WllqTElOZmp5ZE10?=
 =?utf-8?B?bW1hVHRoQjlJdk9JaG9ZeUgzbjZNK2ZKcW8zUlRiS0hQNS9MRVlTU3l5NG5I?=
 =?utf-8?B?clVseGRwZXM1U21iSld6bUNEQ2swLyszbEY2TFl5YW5ZQVdRQ0tFTkdTZXFQ?=
 =?utf-8?Q?9khSJwZlb6exs9eBRP1ZxuyIJo675MgbXROBYoVPhs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <01E815184C94F149A355FDDFF9135213@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6e399d-1fbf-4e17-18a8-08db0850e8b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 14:46:19.7307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dQa6qA861eLQNErGZq7W0LeYAE7L8VFqRLuAwbHXJFXoLsCyrfLLvU611+CWiPUlz5+UWIpmQb5VTNrFdUs83jdiZwRJA90SmFoKU/TNnIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4621
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
IA0KPiBBZGQgZ2VuZXJpYyBmdW5jdGlvbiBmb3IgRUVFIGFiaWxpdGllcyBkZWZpbmVkIGJ5IElF
RUUgODAyLjMNCj4gc3BlY2lmaWNhdGlvbi4gRm9yIG5vdyBmb2xsb3dpbmcgcmVnaXN0ZXJzIGFy
ZSBzdXBwb3J0ZWQ6DQo+IC0gSUVFRSA4MDIuMy0yMDE4IDQ1LjIuMy4xMCBFRUUgY29udHJvbCBh
bmQgY2FwYWJpbGl0eSAxIChSZWdpc3Rlcg0KPiAzLjIwKQ0KPiAtIElFRUUgODAyLjNjZy0yMDE5
IDQ1LjIuMS4xODZiIDEwQkFTRS1UMUwgUE1BIHN0YXR1cyByZWdpc3Rlcg0KPiAgIChSZWdpc3Rl
ciAxLjIyOTUpDQo+IA0KPiBTaW5jZSBJIHdhcyBub3QgYWJsZSB0byBmaW5kIGFueSBmbGFnIHNp
Z25hbGluZyBzdXBwb3J0IG9mIHRoZXNlDQo+IHJlZ2lzdGVycywgd2Ugc2hvdWxkIGRldGVjdCBs
aW5rIG1vZGUgYWJpbGl0aWVzIGZpcnN0IGFuZCB0aGVuIGJhc2VkDQo+IG9uDQo+IHRoZXNlIGFi
aWxpdGllcyBkb2luZyBFRUUgbGluayBtb2RlcyBkZXRlY3Rpb24uDQo+IA0KPiBSZXN1bHRzIG9m
IEVFRSBhYmlsaXR5IGRldGVjdGlvbiB3aWxsIGJlIHN0b3JlZCBpbnRvIG5ldyB2YXJpYWJsZQ0K
PiBwaHlkZXYtPnN1cHBvcnRlZF9lZWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBPbGVrc2lqIFJl
bXBlbCA8by5yZW1wZWxAcGVuZ3V0cm9uaXguZGU+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvcGh5
L3BoeS1jNDUuYyAgICB8IDcwDQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Kw0KPiAgZHJpdmVycy9uZXQvcGh5L3BoeV9kZXZpY2UuYyB8IDE2ICsrKysrKysrKw0KPiAgaW5j
bHVkZS9saW51eC9tZGlvLmggICAgICAgICB8IDI2ICsrKysrKysrKysrKysrDQo+ICBpbmNsdWRl
L2xpbnV4L3BoeS5oICAgICAgICAgIHwgIDUgKysrDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDExNyBp
bnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L3BoeS1jNDUu
YyBiL2RyaXZlcnMvbmV0L3BoeS9waHktYzQ1LmMNCj4gaW5kZXggOWY5NTY1YTQ4MTlkLi4zYWU2
NDJkM2FlMTQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9waHktYzQ1LmMNCj4gKysr
IGIvZHJpdmVycy9uZXQvcGh5L3BoeS1jNDUuYw0KPiBAQCAtNjYxLDYgKzY2MSw3NiBAQCBpbnQg
Z2VucGh5X2M0NV9yZWFkX21kaXgoc3RydWN0IHBoeV9kZXZpY2UNCj4gKnBoeWRldikNCj4gIH0N
Cj4gIEVYUE9SVF9TWU1CT0xfR1BMKGdlbnBoeV9jNDVfcmVhZF9tZGl4KTsNCj4gDQo+ICsvKioN
Cj4gKyAqIGdlbnBoeV9jNDVfcmVhZF9lZWVfY2FwMSAtIHJlYWQgc3VwcG9ydGVkIEVFRSBsaW5r
IG1vZGVzIGZyb20NCj4gcmVnaXN0ZXIgMy4yMA0KPiArICogQHBoeWRldjogdGFyZ2V0IHBoeV9k
ZXZpY2Ugc3RydWN0DQo+ICsgKi8NCj4gK3N0YXRpYyBpbnQgZ2VucGh5X2M0NV9yZWFkX2VlZV9j
YXAxKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ICt7DQo+ICsgICAgICAgaW50IHZhbDsN
Cj4gKw0KPiArICAgICAgIC8qIElFRUUgODAyLjMtMjAxOCA0NS4yLjMuMTAgRUVFIGNvbnRyb2wg
YW5kIGNhcGFiaWxpdHkgMQ0KPiArICAgICAgICAqIChSZWdpc3RlciAzLjIwKQ0KPiArICAgICAg
ICAqLw0KPiArICAgICAgIHZhbCA9IHBoeV9yZWFkX21tZChwaHlkZXYsIE1ESU9fTU1EX1BDUywg
TURJT19QQ1NfRUVFX0FCTEUpOw0KPiArICAgICAgIGlmICh2YWwgPCAwKQ0KPiArICAgICAgICAg
ICAgICAgcmV0dXJuIHZhbDsNCj4gKw0KPiArICAgICAgIC8qIFRoZSA4MDIuMyAyMDE4IHN0YW5k
YXJkIHNheXMgdGhlIHRvcCAyIGJpdHMgYXJlIHJlc2VydmVkDQo+IGFuZCBzaG91bGQNCj4gKyAg
ICAgICAgKiByZWFkIGFzIDAuIEFsc28sIGl0IHNlZW1zIHVubGlrZWx5IGFueWJvZHkgd2lsbCBi
dWlsZCBhDQo+IFBIWSB3aGljaA0KPiArICAgICAgICAqIHN1cHBvcnRzIDEwMEdCQVNFLVIgZGVl
cCBzbGVlcCBhbGwgdGhlIHdheSBkb3duIHRvDQo+IDEwMEJBU0UtVFggRUVFLg0KPiArICAgICAg
ICAqIElmIE1ESU9fUENTX0VFRV9BQkxFIGlzIDB4ZmZmZiBhc3N1bWUgRUVFIGlzIG5vdA0KPiBz
dXBwb3J0ZWQuDQo+ICsgICAgICAgICovDQo+ICsgICAgICAgaWYgKHZhbCA9PSBHRU5NQVNLKDE1
LCAwKSkNCg0Kbml0OiBNYWdpYyBudW1iZXIgY2FuIGJlIHJlcGxhY2VkIGJ5IG1hY3JvLg0KDQo+
ICsgICAgICAgICAgICAgICByZXR1cm4gMDsNCj4gKw0KPiArICAgICAgIG1paV9lZWVfY2FwMV9t
b2RfbGlua21vZGVfdChwaHlkZXYtPnN1cHBvcnRlZF9lZWUsIHZhbCk7DQo+ICsNCj4gKyAgICAg
ICAvKiBTb21lIGJ1Z2d5IGRldmljZXMgaW5kaWNhdGUgRUVFIGxpbmsgbW9kZXMgaW4NCj4gTURJ
T19QQ1NfRUVFX0FCTEUNCj4gKyAgICAgICAgKiB3aGljaCB0aGV5IGRvbid0IHN1cHBvcnQgYXMg
aW5kaWNhdGVkIGJ5IEJNU1IsIEVTVEFUVVMNCj4gZXRjLg0KPiArICAgICAgICAqLw0KPiArICAg
ICAgIGxpbmttb2RlX2FuZChwaHlkZXYtPnN1cHBvcnRlZF9lZWUsIHBoeWRldi0+c3VwcG9ydGVk
X2VlZSwNCj4gKyAgICAgICAgICAgICAgICAgICAgcGh5ZGV2LT5zdXBwb3J0ZWQpOw0KPiArDQo+
ICsgICAgICAgcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4gKw0KPiANCg==
