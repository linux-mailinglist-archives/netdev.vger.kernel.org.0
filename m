Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59DA66CDEF
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbjAPRvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbjAPRvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:51:05 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A592E0D7;
        Mon, 16 Jan 2023 09:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673890390; x=1705426390;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Sd8ny0hlZ3iMMtS/Hk6cTJmfSbExCTW3kU5lFN/Go+Q=;
  b=plVnZpuJxFN72DbzC/4tHVXtbRdvo1YifQZkYZKBIBxpiUdulZhbJnDS
   VOr9xPyKBEPdsZL39RnzrwMA1Iw33vG+JdKj30EwY+p2g5MRFtpyFqSZM
   MqKKc2gPOA1/2thHbQQD7d1NroYwyx1XuhHOtjQM4tpCJsQauSI1wsuSX
   AWG0FPlPz+I1cgZ3nHIlyxBr9TP+3x4wKg4RC4pmzh8cYcC2OCnPVBMd9
   4HRwSD088u1DuAVfg+lDzJpsyHtXMycAbfe6cTL+Id5J6GdabYNUEphJ1
   nhy7EMFBwr8I0sarLmHkQUo2dQMwPXr1BEvC1Ktd7xcJ9tzUitrDtV+Eg
   g==;
X-IronPort-AV: E=Sophos;i="5.97,221,1669100400"; 
   d="scan'208";a="196874639"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jan 2023 10:33:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 10:33:09 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 16 Jan 2023 10:33:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GEpG56UXbMIuYf0z1MuIIZXkAgaMzBQEXZb+LciKPSZjOtbjLFh0v48npwsWTRqWB1EkJuxHVY2ZAK0sIgFIoc3eZ86UJ6ihekweG/dDITNEG6Lra17+vxaGdy1a60j6PFDZYhQj6u0kXkjA/UUaYG/YHozt+Ve2VQ0oSvnwLdG1IEXZ7ZsYBrkBRqlrmmmVmvedSH6DPuuDZ8jmtoj27NZ1CPwn5aeCbwDF1V9rGWwKi0BDdvtJA40jDwru/6uPYdWE+b4Bq8H5n2oObcbRxwdg1Uln4G8/nVHMcT9qviVSMxq4eXvZxagWzR/bhqp3Y357HfbNmO6SHMrVPqclOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sd8ny0hlZ3iMMtS/Hk6cTJmfSbExCTW3kU5lFN/Go+Q=;
 b=moNuHcSZZXAuGi1suWcd47WhkUm9fbcmv4nbokXqOIO2JRPDxyBX+GVloH3BSnTQUZFQwQIIQ9uG4I8EKcnX70S/GvbbAPk0peGydrjaal2lNMGzKhh1G3mJ0YsIJeOX2SDcMKaoF5BT18aBxjBzSJII9EyDh1yQhWqWEEtQBcfs1RUub9xhcdJSQ6HOEWrj+GYaxQLakGWDITtxkyhMHuOlytnVF+tCRPBz2pANWH72d2Yc3WkXBE5WsfDDvC6VqUQLG+t7E/A7MDfZdyMmgm6+ZxSqyIAQQ7KcLRLWoNUCwM1vKWo7Ezl58NMaz7ncOLSxgoIaqMwh1Gv814393Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sd8ny0hlZ3iMMtS/Hk6cTJmfSbExCTW3kU5lFN/Go+Q=;
 b=YjK8OjQepVHF3DWbhHtFkOktN/GFO6ohCuGSCCm/8w1p+giNuNfRm7SBnk5e8jHEXrMKcx2zPpQiD95adjLu8ECimUqBhtXe2lK7QXlgs6hvabV0FK7j7Cz5vvcwbKc9Ot1hmhwgz2FDGINeV5yLxcb3Z6cDJMTIP32bw78AC+s=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by PH0PR11MB7586.namprd11.prod.outlook.com (2603:10b6:510:26e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 16 Jan
 2023 17:33:06 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::3558:8159:5c04:f09c]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::3558:8159:5c04:f09c%4]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 17:33:06 +0000
From:   <Jerry.Ray@microchip.com>
To:     <Arun.Ramadoss@microchip.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>
Subject: RE: [PATCH net-next v6 6/6] dsa: lan9303: Migrate to PHYLINK
Thread-Topic: [PATCH net-next v6 6/6] dsa: lan9303: Migrate to PHYLINK
Thread-Index: AQHZJHAUgbmW0ofBykmmlKO+Ubpgs66aQvuAgAcVNfA=
Date:   Mon, 16 Jan 2023 17:33:06 +0000
Message-ID: <MWHPR11MB169365CB3BE33AFBF6566277EFC19@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
         <20230109211849.32530-7-jerry.ray@microchip.com>
 <39a76c164362f5e03238666e194fc135b19ade12.camel@microchip.com>
In-Reply-To: <39a76c164362f5e03238666e194fc135b19ade12.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|PH0PR11MB7586:EE_
x-ms-office365-filtering-correlation-id: 27704656-2022-493c-dc11-08daf7e7ba4c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QxtYCNyvjhVsoEVzu3EpDFjalGL+ls3dqeEDKskRiwAZF4HtQV7dVoA/jML64eegoE0q0aaUmM8HL+eQ6dzclS2izYtjwOEViAzpCKh8jSnXtlswIa+FIMaUPNNleJGcw8hgHljSeXKE/5HHF4vRPRGV8s0l7kKtKn/Xlc6GngaNOFbCnNOCCU6mgbg11dZ5ej9shag9eEeD8/WS1Z9trsS8kAnWOZQ+c2Vt3WQWpD3kvWNtJ8I2SxY/bdX69VBujWg21tyd3pqzpy7OZ0yr4w92hvaqIIxP1Ef0rjBIdh4YWNsFV4KLXftBnOS+MZyTQ5aOh4j80fGvDTsN6Epp8AEP8w+U9U0K7INf4UUNcIqAHrH+fQXy5faX6+tQ1QXFom2gz8/A3gujGbzAgXuraO6y5MnyawXaIr+VPJnTj6yy+qtoze+d2nyUAsChkCOF+ai6pgqSfpMpevZm9ssm9w+0KEd7SXP2Y9THegHEjqQIo5Ygc+0zRAHbp8fbwN+F4ZsTwtailWbbjPH5MaBUC+AMpuXDO0WbAdskYSW86UJkN0qQQbsnb/rj6hLxpn35DTuRbM7jczctciLg4SYGpK2ADeK7Q2cNDtEFrd4BTRaVdHEnlWXajDT8p+oTlRfuP9Np7CsZmFVhDkRtXtB7ZJs9gsMJ340xF7ps0zy15uxDrk4LmAG+JooEs0J22fF7BNEyVBst+1MBRGOsLmagLvXHlQBxrxOAoEGVe511N7E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(6506007)(9686003)(26005)(186003)(7696005)(64756008)(71200400001)(122000001)(38100700002)(921005)(478600001)(38070700005)(83380400001)(86362001)(33656002)(55016003)(52536014)(7416002)(5660300002)(8936002)(66946007)(66556008)(76116006)(316002)(2906002)(66476007)(66446008)(8676002)(110136005)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dEo0U3Z0MUVHSWpkRmg2TDNqRm1DNkRsRkNvSjV4Q2tlTzN4Mk11dFVVV0Rl?=
 =?utf-8?B?Y0tsSzlRK3V5b3NrL2xBa212a2Y4cW9DRW5tRXhnbEp5M1krdXFoWUw3anNh?=
 =?utf-8?B?SkNxRUJZbnQ3a0liNzNDRDhHYTdDYllQMGxHbXRQZEhuRjBERzF5STVyMDRV?=
 =?utf-8?B?VHNsbG5rdmpYMGdpdDFzd2g5aGRXWFBEbGs5dHd4VlBFREFOTGpkeXhXaE83?=
 =?utf-8?B?K0x3K1EydU5UMkZNcTVmelhDb1ExMXhuUzVmeGVvejVZMEFmNHJtNE9EdFFN?=
 =?utf-8?B?dDZpeHY1QWR2RE9kbndaSjJjOGdNWGZFZXRYL1MwV3JhRjhIY1ZESURjQlRx?=
 =?utf-8?B?SXdqbWFWbjR6Wm5xajBVYnBEbkJGZXJGMlpWZTJXZGdxazA1b3Y2YUV6WEZt?=
 =?utf-8?B?clZaeHRIT1h6ZTlpdVNBUUYyS2l3VktrbG5NanNlZTdld2tNaGZ1Um8zdEdG?=
 =?utf-8?B?aDVYVVB2c2FKQllpZitmVFp0Q2k3cXlwdzlvSG4vZHBKbG0yY2FvK0s5MTR3?=
 =?utf-8?B?R0l3YTd3STFzNStSazRadlV6ckpTTWgzN0c0dGx2YmZ2VTlmdGMwUXpMS3Ji?=
 =?utf-8?B?MTBpbncwTWZsaUFPUDNwMU9RZnZpRFhMckE5RkhwaGpqYzZveHQvS2NsL1hY?=
 =?utf-8?B?UVU1TnQyQ1I5RjNkb3g1dFd3bERJb2VuUHBDTk9FT05LZWRadnFCYmZTMk11?=
 =?utf-8?B?cXVscFJWbGhOMnUzeEpKaVN5QTJYMXQyVGdLQnpKUFJsRjB1bTMvRjQ3T00y?=
 =?utf-8?B?Y2U2eXFSUU9Ebk9ZcGJmRy9yMWM3N09pM1Z2dWNKTERYU2x0czZ0UXB6cUU5?=
 =?utf-8?B?U2VWSjFlTkdkZFVzcGJ6Z3JuWW9NN1hpZkczZmtMVWtFYWszcUxLMDBVTzl6?=
 =?utf-8?B?eHlaNXJhbnJicG11VGlvYXVWL1MzSTlnOXNOK2dQVEJJSm1vei8rZTZXUTRw?=
 =?utf-8?B?T0pISVk0TE1qUStZMUpQK0RGY2lhNWJSN0Yxc2xUM0FXSVN6Nys1UzRROGFr?=
 =?utf-8?B?NE56N0VNcmRZMW1NdzNKaHRCL3BKWVZ6bWZ3RnFoaXFLZkxSVmNFb1R6WVJX?=
 =?utf-8?B?MHZ5WGY2NlBwK3lUUVFZNis0WGtPV3BoZGtEc1gveGRkRVpyckVPVGpPOW1C?=
 =?utf-8?B?NHZvckcwZi95eVc4ZHJ4UWRnNDRqRGswVyt2QUtsQUlvMUxndEFJNW54aHVN?=
 =?utf-8?B?SWdqZTNsR3lWNzdWOWtjd3gzeDBJOVpNelRGVDQzeExPMVQ3cVZVb2lpYWNz?=
 =?utf-8?B?N2RGcFFRbWxSMy9uTWJZeStmZ0g2ZnhZSXp4Y2pKRUwyMzdxM01zbVFnY201?=
 =?utf-8?B?U0p3elhRUHdheUR5Vjd0R2NyazdzOVJyUkVKK1hidHZYK1VIK3pYQ3JiaXY3?=
 =?utf-8?B?NTY1YU1vcVc0OW5tYTJGTkhpZkxQeWp6b3FRaWxUVnBONUFPNTN6MjI5Q3Ba?=
 =?utf-8?B?MG5senhlSlBVNGpWL0p1RkJLMW1ab05kdVNWOVhha1ZLUzdna25Od3VRbG1z?=
 =?utf-8?B?dlliaWlsZWtPSVBWakE3NGhDUkcxQ2tySWhrcGRJMy9RWVpoSW9BQVBCd2JR?=
 =?utf-8?B?SlZsTHNKTEh1a0hHakJUMlJzZ3BLUnNZWTM5ZDJSK1I3NWI0Ry9PYk1lT29a?=
 =?utf-8?B?enl4QjljNmZRSTk1MTBGYTlyZklSWFhxbGxXWGFINENFbklmbjUvbzUxUkRy?=
 =?utf-8?B?b0Vyb2pYOUM5Sy9uNjZWVHN0cksyYSswWnlRR0pnVEJwQWtwbG5HeG9FQWJ3?=
 =?utf-8?B?eXp4WkNTNUJwRzJJam5xODZiVStWb000Y1k1bWloZmRtaU1NblljN3Uxc2Vp?=
 =?utf-8?B?YytwRTJpWXJaVjZDa0tmRU8wYTZYbnlPcmpmRUFRcmMySWIwUk8zTnN0NVJ0?=
 =?utf-8?B?bVJIUTVlcjI2YlRuMnBtcCtuQjJVMkJTZDZJejQvM29yNndKVVF4aGdUazE2?=
 =?utf-8?B?VDQ3bFBoTVkvWlUyQldSbGFBYU5kdk1WV1ZRcHFXUndaTnRySDA2MEdZcmRq?=
 =?utf-8?B?OVA2S1dPcVR0M21qOVNlNEVxOHl2YW9OaWZPbkc4Nm84cTFOSHBPbWNwOFE5?=
 =?utf-8?B?R3RJMmdQOGNtckxPZkRpN0F3WGl0c1FHT1kzVzN1UDk2akFKQ0dUbFdoZ21r?=
 =?utf-8?Q?/s07YchpWQuEV/owvN6GspUsj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27704656-2022-493c-dc11-08daf7e7ba4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 17:33:06.1139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rvUI8M239WWCqUT/tL8s1Dduh6AipnDfEGpr1Q/63ImatYHrCyLi7nYjfb/IHB0jca8GmMOg8uJ9tGiFb2CYHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7586
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbGFuOTMwMy1jb3JlLmMNCj4gPiBiL2Ry
aXZlcnMvbmV0L2RzYS9sYW45MzAzLWNvcmUuYw0KPiA+IGluZGV4IDdiZTRjNDkxZTVkOS4uZTUx
NGZmZjgxYWY2IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9sYW45MzAzLWNvcmUu
Yw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9sYW45MzAzLWNvcmUuYw0KPiA+IEBAIC0xMDU4
LDM3ICsxMDU4LDYgQEAgc3RhdGljIGludCBsYW45MzAzX3BoeV93cml0ZShzdHJ1Y3QgZHNhX3N3
aXRjaA0KPiA+ICpkcywgaW50IHBoeSwgaW50IHJlZ251bSwNCj4gPiAgCXJldHVybiBjaGlwLT5v
cHMtPnBoeV93cml0ZShjaGlwLCBwaHksIHJlZ251bSwgdmFsKTsNCj4gPiAgfQ0KPiA+ICAgIA0K
PiA+ICtzdGF0aWMgdm9pZCBsYW45MzAzX3BoeWxpbmtfZ2V0X2NhcHMoc3RydWN0IGRzYV9zd2l0
Y2ggKmRzLCBpbnQNCj4gPiBwb3J0LA0KPiA+ICsJCQkJICAgICBzdHJ1Y3QgcGh5bGlua19jb25m
aWcgKmNvbmZpZykNCj4gPiArew0KPiA+ICsJc3RydWN0IGxhbjkzMDMgKmNoaXAgPSBkcy0+cHJp
djsNCj4gPiArDQo+ID4gKwlkZXZfZGJnKGNoaXAtPmRldiwgIiVzKCVkKSBlbnRlcmVkLiIsIF9f
ZnVuY19fLCBwb3J0KTsNCj4gPiArDQo+ID4gKwljb25maWctPm1hY19jYXBhYmlsaXRpZXMgPSBN
QUNfMTAgfCBNQUNfMTAwIHwgTUFDX0FTWU1fUEFVU0UgfA0KPiA+ICsJCQkJICAgTUFDX1NZTV9Q
QVVTRTsNCj4gPiArDQo+ID4gKwlpZiAocG9ydCA9PSAwKSB7DQo+ID4gKwkJX19zZXRfYml0KFBI
WV9JTlRFUkZBQ0VfTU9ERV9STUlJLA0KPiA+ICsJCQkgIGNvbmZpZy0+c3VwcG9ydGVkX2ludGVy
ZmFjZXMpOw0KPiA+ICsJCV9fc2V0X2JpdChQSFlfSU5URVJGQUNFX01PREVfTUlJLA0KPiA+ICsJ
CQkgIGNvbmZpZy0+c3VwcG9ydGVkX2ludGVyZmFjZXMpOw0KPiA+ICsJfSBlbHNlIHsNCj4gPiAr
CQlfX3NldF9iaXQoUEhZX0lOVEVSRkFDRV9NT0RFX0lOVEVSTkFMLA0KPiA+ICsJCQkgIGNvbmZp
Zy0+c3VwcG9ydGVkX2ludGVyZmFjZXMpOw0KPiA+ICsJCS8qIENvbXBhdGliaWxpdHkgZm9yIHBo
eWxpYidzIGRlZmF1bHQgaW50ZXJmYWNlIHR5cGUNCj4gPiB3aGVuIHRoZQ0KPiA+ICsJCSAqIHBo
eS1tb2RlIHByb3BlcnR5IGlzIGFic2VudA0KPiA+ICsJCSAqLw0KPiA+ICsJCV9fc2V0X2JpdChQ
SFlfSU5URVJGQUNFX01PREVfR01JSSwNCj4gPiArCQkJICBjb25maWctPnN1cHBvcnRlZF9pbnRl
cmZhY2VzKTsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwkvKiBUaGlzIGRyaXZlciBkb2VzIG5vdCBt
YWtlIHVzZSBvZiB0aGUgc3BlZWQsIGR1cGxleCwgcGF1c2Ugb3INCj4gPiB0aGUNCj4gPiArCSAq
IGFkdmVydGlzZW1lbnQgaW4gaXRzIG1hY19jb25maWcsIHNvIGl0IGlzIHNhZmUgdG8gbWFyayB0
aGlzDQo+ID4gZHJpdmVyDQo+ID4gKwkgKiBhcyBub24tbGVnYWN5Lg0KPiA+ICsJICovDQo+ID4g
Kwljb25maWctPmxlZ2FjeV9wcmVfbWFyY2gyMDIwID0gZmFsc2U7DQo+ID4gK30NCj4gPiArDQo+
ID4gK3N0YXRpYyB2b2lkIGxhbjkzMDNfcGh5bGlua19tYWNfbGlua191cChzdHJ1Y3QgZHNhX3N3
aXRjaCAqZHMsIGludA0KPiA+IHBvcnQsDQo+ID4gKwkJCQkJdW5zaWduZWQgaW50IG1vZGUsDQo+
ID4gKwkJCQkJcGh5X2ludGVyZmFjZV90IGludGVyZmFjZSwNCj4gPiArCQkJCQlzdHJ1Y3QgcGh5
X2RldmljZSAqcGh5ZGV2LCBpbnQNCj4gPiBzcGVlZCwNCj4gPiArCQkJCQlpbnQgZHVwbGV4LCBi
b29sIHR4X3BhdXNlLA0KPiA+ICsJCQkJCWJvb2wgcnhfcGF1c2UpDQo+ID4gK3sNCj4gPiArCXUz
MiBjdGw7DQo+ID4gKw0KPiA+ICsJLyogT24gdGhpcyBkZXZpY2UsIHdlIGFyZSBvbmx5IGludGVy
ZXN0ZWQgaW4gZG9pbmcgc29tZXRoaW5nDQo+ID4gaGVyZSBpZg0KPiA+ICsJICogdGhpcyBpcyB0
aGUgeE1JSSBwb3J0LiBBbGwgb3RoZXIgcG9ydHMgYXJlIDEwLzEwMCBwaHlzIHVzaW5nDQo+ID4g
TURJTw0KPiA+ICsJICogdG8gY29udHJvbCB0aGVyZSBsaW5rIHNldHRpbmdzLg0KPiA+ICsJICov
DQo+ID4gKwlpZiAocG9ydCAhPSAwKQ0KPiA+ICsJCXJldHVybjsNCj4gPiArDQo+ID4gKwljdGwg
PSBsYW45MzAzX3BoeV9yZWFkKGRzLCBwb3J0LCBNSUlfQk1DUik7DQo+ID4gKw0KPiA+ICsJY3Rs
ICY9IH5CTUNSX0FORU5BQkxFOw0KPiA+ICsNCj4gPiArCWlmIChzcGVlZCA9PSBTUEVFRF8xMDAp
DQo+ID4gKwkJY3RsIHw9IEJNQ1JfU1BFRUQxMDA7DQo+ID4gKwllbHNlIGlmIChzcGVlZCA9PSBT
UEVFRF8xMCkNCj4gPiArCQljdGwgJj0gfkJNQ1JfU1BFRUQxMDA7DQo+ID4gKwllbHNlDQo+ID4g
KwkJZGV2X2Vycihkcy0+ZGV2LCAidW5zdXBwb3J0ZWQgc3BlZWQ6ICVkXG4iLCBzcGVlZCk7DQo+
IA0KPiBJIHRoaW5rLCBXZSB3aWxsIG5vdCByZWFjaCBpbiB0aGUgZXJyb3IgcGFydCwgc2luY2Ug
aW4gdGhlDQo+IHBoeWxpbmtfZ2V0X2NhcHMgd2Ugc3BlY2lmaWVkIG9ubHkgMTAgYW5kIDEwMCBN
YnBzIHNwZWVkLiBQaHlsaW5rIGxheWVyDQo+IHdpbGwgdmFsaWRhdGUgYW5kIGlmIHRoZSB2YWx1
ZSBpcyBiZXlvbmQgdGhlIHNwZWVkIHN1cHBvcnRlZCwgaXQgd2lsbCANCj4gcmV0dXJuIGJhY2su
DQo+IA0KDQpJIHdpbGwgcmVtb3ZlIHRoZSBlcnJvciBjaGVjayBhbmQgd2lsbCBnbyB3aXRoIGVp
dGhlciAxMCBvciAxMDAuDQoJY3RsICY9IH5CTUNSX1NQRUVEMTAwOw0KCWlmICgoc3BlZWQgPT0g
U1BFRURfMTAwKQ0KCQljdGwgfD0gQk1DUl9TUEVFRDEwMDsNCg0KUmVnYXJkcywNCkplcnJ5Lg0K
DQo+ID4gKw0KPiA+ICsJaWYgKGR1cGxleCA9PSBEVVBMRVhfRlVMTCkNCj4gPiArCQljdGwgfD0g
Qk1DUl9GVUxMRFBMWDsNCj4gPiArCWVsc2UNCj4gPiArCQljdGwgJj0gfkJNQ1JfRlVMTERQTFg7
DQo+ID4gKw0KPiA+ICsJbGFuOTMwM19waHlfd3JpdGUoZHMsIHBvcnQsIE1JSV9CTUNSLCBjdGwp
Ow0KPiA+ICt9DQo+ID4gKw0K
