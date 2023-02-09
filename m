Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0175D690B0D
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjBINz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjBINzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:55:54 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEBE5ACF4;
        Thu,  9 Feb 2023 05:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675950943; x=1707486943;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vy6oQLcaWPpJngaDvcSxCgYRgeRfNGJ+uISd6+u8OQw=;
  b=Xx1aLT5MoCw3maHf/Px9/OE12unWGrhezW0I/a28e59Q+07VyoMuKCoF
   N3yk+j0bE809d4fBGvPxuXJb7V22uIQ1VKa+/PBu6IoelgzKTdrbiY3T6
   U+7KxZtOYfkSPEXGQ0NIEF8kmazzMMbWU8TWi/bf+hy9OD2qmSrXCmwYY
   A9fw0psS/VVCfRVYwAlWxy+H80OdjcdP7WvNytuL2coPmU0AIqbGDqAa/
   isWS7kiol3MbmMJsw0thkZTDCCI4uZ1lmifKUab+HpNWHSzbAZ5usT9qs
   ZizHguD4Reqet0kPX+jjuCC0N645cNw6Evig0zKQ/SkOma5m+S9xzsXYk
   w==;
X-IronPort-AV: E=Sophos;i="5.97,283,1669100400"; 
   d="scan'208";a="136355756"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2023 06:55:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 06:55:19 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 06:55:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O03H7FHmMVWd+A/WcxQMKjQ8T8wI7um+hcNOrBU7dgF+2sztNQKCnuw1ri2o3PTJhhmnrSYxvh3Kzq/OXZR8EnHd57myLCWvD35CCgPp8uXCxGi1+oVNiXaqeP80Su+HbusA1hu8g+qmd6j5om/emcR8oR+zqIA0/tzoRF+xLa6FcVV8DtdDsPl47DFMCS9C5vY1/z3JCiyXj5NY3dmMNhFzetyiD7Z+Ia6E+eA4EdC6r9t7TgNi+EiWkrkR1fNK1E3prZa9VcjwHxEChJrW1cNf9+IGOoca7lYTqpE/MJ/9iUqxEwwzNGTiu/P1z+68LaPbeJ1nxluMw92fGdXFCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vy6oQLcaWPpJngaDvcSxCgYRgeRfNGJ+uISd6+u8OQw=;
 b=YvQ3bMFgBugjST6BqzBHkalh0+4VwO5PK3TqZsRVgT+2K9CR7yT0Yxi+iX6iejRuKL3yLLExHQTpleeyotTAcoRwke+jQ51C55WwH5+Eb6bVLXcjxxYng7zDoR7bxnRZZnW+VieySS/NkGipxbdTfUgWJ6GmjOts3eCxAgoinRp+mZO+bGl0W3hs8joV77N6JFnEAXNT6xoHsUqYK/NZozhyRETz8hORirF6hi2339wa0evkr4fwijnXFSHEzn+JPiNEti0leiORRm6q8ADsJnpZIj5iLvQK9qJdKrPZVJi235OqzqupSXCbbuM8dbmzIpAGPaCg81lrnFsgGK1alg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vy6oQLcaWPpJngaDvcSxCgYRgeRfNGJ+uISd6+u8OQw=;
 b=OayCAOgP973DTELVHYeE9RE7b1wGnUpGXwTwOV2NQDmZhrEHaMcu2yIXS24mmGNe12nc/t3OsJsgdpW7+NWSqOYqJTJDHoKHhEdsX8GQJWLdaeBpBIZtwAkA/IXMKGZ2J+V3h0OGnJzLy3GfKQcuzpgBNuqdI986uafsIG7OuEQ=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 BL3PR11MB6315.namprd11.prod.outlook.com (2603:10b6:208:3b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 9 Feb
 2023 13:55:17 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.6064.035; Thu, 9 Feb 2023
 13:55:17 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <wei.fang@nxp.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>, <hkallweit1@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v7 1/9] net: dsa: microchip: enable EEE support
Thread-Topic: [PATCH net-next v7 1/9] net: dsa: microchip: enable EEE support
Thread-Index: AQHZPGwmF0f8RCM05Uet7ZLhPHDy7a7Go24A
Date:   Thu, 9 Feb 2023 13:55:17 +0000
Message-ID: <fc16d1439ea9be10045ab31ecb7f4b6ca45d7fa4.camel@microchip.com>
References: <20230209095113.364524-1-o.rempel@pengutronix.de>
         <20230209095113.364524-2-o.rempel@pengutronix.de>
In-Reply-To: <20230209095113.364524-2-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|BL3PR11MB6315:EE_
x-ms-office365-filtering-correlation-id: dd9c5f49-e814-40a1-a9a0-08db0aa546a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6skcQVHdEFQReyMpVo6wfUINCYcfRE7ozMJ6uD0oJZ9eojHmdMiXSoF5+cZajYl5oEioSuOi+QFdyfKnOuV7PyhJZtgHV+XRQMzmJpKi/usnzcWu5m/oH8Ef5afgqDwAZt6314jwu/SVpyF8OH4ehHCqp0hgAbOndxI1wWlCjgky3iwAQVdDBQle7C98Dt2hwHANmdlyGWW2p9ev9dlYSv7NlSPhn0tsy3Vu6mJVFXEl2EBCXJADYzW06odcXNOdzQ57tAP74gJ4/uCu3ngJbjLrKohR7c661AXG0fSyX1fGnh6az5wUAwh77xI9wW3OZpa7fEM3NP5nPey8o0p3LQdGBXw42qcGXRSd601k5zGbc5aeXqI5oGFDBN3gRgu2Y+yXCAC5lRT7ZuMQBLQkqYUcMNsOXZXcDzVFvZxiv6TKdq5IAmheQFZH/IAguMqfj8G4/vjvZMpgQuNmurPw5wIklhV2+8ftJwa24N0kaDPYnblylamMbYYul0RGRE03jOoE2D3r0RN+g+aiszTa/5Adw1LXSxBsZE0ayOTEFO1FUb8emAdDWFRsRUjQO3kvTd/R5ZJYBS9lISjpC3xVhOGA2h74iJPbS3vTf5Owuy5EmB7IHPZyayZ78cfRktavfFe9Y7F21waUAUTGcSf/YXR7NDjof/iUpZXHu+7lt7+pJDkyjY6U+jUOV4REkEHf2rzI+ktpMtNBDIYl7vuEUIVly74uXotboiFl8BseA4xc70VvomtdLA0gdSy8HeWz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(38100700002)(122000001)(921005)(4326008)(41300700001)(186003)(91956017)(8936002)(64756008)(8676002)(66476007)(6506007)(66946007)(76116006)(66556008)(66446008)(5660300002)(2616005)(36756003)(38070700005)(4744005)(7416002)(316002)(86362001)(54906003)(6512007)(71200400001)(478600001)(6486002)(2906002)(110136005)(83380400001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2ZFL21oYXVEMkdPMkhmazNsYkhjL1M0bkFJOVFLVjJVVGNNUW00NFZGQm1u?=
 =?utf-8?B?US90NzY0WjV6OFJkaVZXcUZyNDRGTXl3UHZCOTk3TFRVRnpJNStjdEpGRTNi?=
 =?utf-8?B?K2t2YU9KakNCRW1XVGgzdkpHYzJzcFBTSkdjVVVRTGxMaGx1cHhXV3oveStG?=
 =?utf-8?B?ZWo1UXJKTjlIYjUyS2ZaOEtEQVZHQm1iT1NzRG9PYVRSNld2SW9UYktLUGJX?=
 =?utf-8?B?TklWK0hUOG1TT0RyMU1oVHcwdzk1V1AzYXJhbEJ6OUlUTU1wUHpVeGJiMnBB?=
 =?utf-8?B?bXFSS2YxN1hGR3pZcnRLb3RCa3pKaUxRVjV0S0RqR2FYOVJlamEyeHh5Yloy?=
 =?utf-8?B?K0xpMFhkNXdZL0Nub2V5Qitma1ZmZGdLa1A3TG9XLzNDTk1IYUlsTGZWTjgv?=
 =?utf-8?B?TmRCOTgrN1BFT1dqUDVWRVZUMlRxb3ZmSjVPQVo1L2xDM1JhTGpUNm9jUnNi?=
 =?utf-8?B?ZFBoQkcyYXhpck1oTTkvdTFvS0M2d2duc2FZd3VleWc2MGZnNUhVN0J6YW4y?=
 =?utf-8?B?WndaNjVOQkhJa1draEZaTjhzcU1NM2xEcUlOaEZlUnNMVmlCQjdMTUJKbkJM?=
 =?utf-8?B?OEdtc3h0Um5Ud3VWZkxvenppMXQ2SGMzREhwZ3RYbHJRdnBFWVFnOXE2MnJN?=
 =?utf-8?B?Z25QWGxMQXVQZDJaOEdnWkhveExZVUlobzNFQWY4TGk0Vlc1QkFNM3pQRkdl?=
 =?utf-8?B?aFhsRlh3cVY2UGtmUzNHdUptbmgxMytxNHJ5VnF6c2xNS2hIbTgxS3RpcTho?=
 =?utf-8?B?aEtYM3ZDZmJPbG5KbXVyNjlIWlpDTnlJdzJJNURUMlVoeXVUVkZ1WEFKcjFy?=
 =?utf-8?B?elppM1dxKzFheWFaTXI1QTFxbDc1YVRVaWwvWHZvclBUSmdsbmp2WGFHRGxE?=
 =?utf-8?B?UWJVR2ttUS9LZ2ZUTUtpeEZWUm53Y3NUNkErWEIwQ1B6QUNyd3NlZGExQmY2?=
 =?utf-8?B?NVA0K0lTSjR0cmZYNXVWcmh4ZWk3dUFwVXBCd25WcUpNdXNDenVLYXJaNUVL?=
 =?utf-8?B?ZGFDV29ISFRmd21JLzFFck9pZTkxR0t6ZzdVQUROcnVoUGxUS3dPWWhHOXFo?=
 =?utf-8?B?Z01SUURCYmtDZjBnUHozdFBjd2xGVVp0dU5aeUJvOVEzVEcwUVNrcXpTUkFP?=
 =?utf-8?B?RTJKazNVZEJtZzFLQXc0VXRRNGJBbU1ab3FGY3U3TGk2MndlT3J5SXUxa254?=
 =?utf-8?B?WVR1YytjcDl4R0YzdG5GaGR0eEIwNEQzcmErSmtIakoyaUIrTm9lSVU2MlNo?=
 =?utf-8?B?Y3lSRXFTSE9keGxrRG8zVU9IMzZva2xRRFBqclloWlRybXNxWHVhaW10R3Qw?=
 =?utf-8?B?d3RTeThaQ0JSd3lQUS9ZdytrSzlIV2x5aHpidWIvZGVZVmQ5eURRVkZNaVNw?=
 =?utf-8?B?ZzE5T3d6RjVBZW9QSTRKZ0hhbTR3VWJtOGlsNVl5ell1KzQ5WVJOdGpiWUM5?=
 =?utf-8?B?dWVsd0NDSWIzL3pJZHV0WGs4aEVUUTdkc3BaQnptN3QrV2NmSmhSWm9WbUJW?=
 =?utf-8?B?ellCWjR3U3NPK1Rsc3F4UzEyU2JWV0xwdlEwaHQxOTZxWWZkZjVDWGF3ZnQv?=
 =?utf-8?B?WDJpNzA2T3ZNYzhLZkxvWXp2Sm01MEI4Z2xIV3lKT1NZRFVHUHZGZDlwV0pv?=
 =?utf-8?B?TEt5RUFzeC9yWUEwMnh2MC95UFdzc0FUOGdTSjQyQ0xEelJOK3VXbzRLekd2?=
 =?utf-8?B?dTVGWlFrTmVuN0M3LzYxM2kwMkttNllLSUFOWjFVdU9KNWYrZ0llSXcwWnNk?=
 =?utf-8?B?VUFSd2tIMk5jK2hMSnVHRFZnUnFtRWVoOEJ2WGtQVmE2WUdqOGRsM25MbjRY?=
 =?utf-8?B?TDY0Zi9qSFdzaU5LdFdTOENKYXNBVzNxdDI5RFRZeVNPclAyZmJQRTJvTlJp?=
 =?utf-8?B?NkhYaGVaRW03ekJOMEI5TzhQazByYXBPaVpFKzl1MkpLTmQvcUtvSmMzSG5i?=
 =?utf-8?B?aExvTmF2ekN1M3hMbzlYUEFLeEpERFBRWUR6dGN4OVo4ZDk1V2QxRTErNzFz?=
 =?utf-8?B?Y0g1Z3Z6WHU1STZaYlJUWS9xZFpLNVhhNUNCK2E0TUZ2ck16UWh5NkhLQ2FB?=
 =?utf-8?B?Nk8xYUw2TmVUTnpReUFJdGswbnI3Vjd6djJrcm1EZDdrc2JCYU5hVDNBeFU3?=
 =?utf-8?B?TkorUkZkS05ScU0rWEJuS0c3S2lXQXpxR1JXZUEzbUlMTForM1RNM2V5c2dN?=
 =?utf-8?B?UFlFekN5MDVWQmZKUE1YbzVmKzVsZVlpc2lndTNBS1B5ajJ1T09pbExFN1du?=
 =?utf-8?Q?fd2hl6/wj7EStJm6XxZO5IysjFdJrxf0QfCXikAg3Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C0BE159F41B004AA744DAA707792CE7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd9c5f49-e814-40a1-a9a0-08db0aa546a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 13:55:17.3626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tE05/yzSNF9xX+ddg0V2gH5e7OQ16s6rkcODYe7KOWHZaxX0w0qe+z/0VBdzwAoJzLNiQxUMXkzj7ohmVOr4d7yKQP8vteBKoo6DpXEUhW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6315
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIzLTAyLTA5IGF0IDEwOjUxICswMTAwLCBPbGVrc2lqIFJlbXBlbCB3cm90ZToN
Cj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBTb21lIG9mIEtT
Wjk0NzcgZmFtaWx5IHN3aXRjaGVzIHByb3ZpZGVzIEVFRSBzdXBwb3J0LiBUbyBlbmFibGUgaXQs
DQo+IHdlDQo+IGp1c3QgbmVlZCB0byByZWdpc3RlciBzZXRfbWFjX2VlZS9zZXRfbWFjX2VlZSBo
YW5kbGVycyBhbmQgdmFsaWRhdGUNCj4gc3VwcG9ydGVkIGNoaXAgdmVyc2lvbiBhbmQgcG9ydC4N
Cj4gDQo+IEN1cnJlbnRseSBzdXBwb3J0ZWQgY2hpcCB2YXJpYW50cyBhcmU6IEtTWjg1NjMsIEtT
Wjk0NzcsIEtTWjk1NjMsDQo+IEtTWjk1NjcsIEtTWjk4OTMsIEtTWjk4OTYsIEtTWjk4OTcuIEtT
Wjg1NjMgc3VwcG9ydHMgRUVFIG9ubHkgd2l0aA0KPiAxMDBCYXNlVFgvRnVsbC4gIE90aGVyIGNo
aXBzIHN1cHBvcnQgMTAwQmFzZVRYL0Z1bGwgYW5kDQo+IDEwMDBCYXNlVFgvRnVsbC4NCj4gTG93
IFBvd2VyIElkbGUgY29uZmlndXJhdGlvbiBpcyBub3Qgc3VwcG9ydGVkIGFuZCBjdXJyZW50bHkg
bm90DQo+IGRvY3VtZW50ZWQgaW4gdGhlIGRhdGFzaGVldHMuDQo+IA0KPiBFRUUgUEhZIHNwZWNp
ZmljIHR1bmluZ3MgYXJlIG5vdCBkb2N1bWVudGVkIGluIHRoZSBzd2l0Y2ggZGF0YXNoZWV0cywN
Cj4gYnV0IGNhbg0KPiBvdmVybGFwIHdpdGggS1NaOTEzMSBzcGVjaWZpY2F0aW9uLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogT2xla3NpaiBSZW1wZWwgPG8ucmVtcGVsQHBlbmd1dHJvbml4LmRlPg0K
PiBSZXZpZXdlZC1ieTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KDQpBY2tlZC1ieTog
QXJ1biBSYW1hZG9zcyA8YXJ1bi5yYW1hZG9zc0BtaWNyb2NoaXAuY29tPg0KDQo=
