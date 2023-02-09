Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20C46910BE
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 19:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBISwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 13:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjBISwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 13:52:07 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BD3F740;
        Thu,  9 Feb 2023 10:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675968723; x=1707504723;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sUE0udBtlNU+BMmFu9Vr+FqZgrT80MIVjRnuD2oJMt8=;
  b=ldx1ikwjKUs05Q/zrWJkmSCrl/mPGA37NTe1amuvbABg7C7v0WtIaqiu
   9CJuFYL2OkMeifMUynAWmgrduhkR/ubI/06+yeODhVY7VsG2OIfuyiQYy
   P3MZVJHOPNALpRWxn65njbzVTdUMP+CevqZiA3V3As1/N0GObe3WUvcEE
   GcWxTkD+yao294lU/CAcbaqEwow5+42qStvplFzHdKJ0flwtvLBgyA5eB
   Ca07X4VaRvbFyL9Y/Vb0uRvpKUcTiWYowQ8ZSeRtjHrXIYW+oqY4OQ+QK
   BDUX9q1trpFeeVLVkXHjmeUxjFnsTosAmmL+etVXYKSWDy1Ajw0EMtAwU
   g==;
X-IronPort-AV: E=Sophos;i="5.97,284,1669100400"; 
   d="scan'208";a="199754808"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2023 11:52:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 11:52:01 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Thu, 9 Feb 2023 11:52:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFpPVEucrKWNDcp334U7rBEoArDFU+eBBy9nUJNMl0S3jNW9JPOBFVgSNIrJ92xllBPd3VfvIPbQ+qxTwP7K23jRqJypAQA4zkNS+MlMwZSBU5yPH0wzFDEmHTkCIKCjzDxaQax4XCnUcPM+18QW+Pw0Owv1G4eIP/3xjb5TXAhWDDV7xCOD2MrPMya/RDr4N95w5oW4qeve8+mCwMFGMZKk9xmQzbjzFxhQq+xShtfqhdl7t4duRrYezNdGdB932G2AKkD29UpS/XKIV1z3a07XdWpCVPUG/GX2Cg9FuvMsqt7qfLvZZq9Rrw/P/70NbijnLVMMsdyk2f10bLXCxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sUE0udBtlNU+BMmFu9Vr+FqZgrT80MIVjRnuD2oJMt8=;
 b=k+lSe00vGMcAYndAK9qYvqeupkmgvk9luI4VUAAgagAgM1e9tc0BJ2LSxJ+q2Y45qz5Kpzcxzxl82sYpwu1Dte72039+nOJ1jgJ2gVhK+fAy20tRvu4WH6JCkty5AddO7kN/+niJ9GobSwXOfjvteu7WmuJGwxKW3KXJAWqPj40zVgL07cK7nw4hFWGb5BxgrRPeDoRAjLnMKogucb55gqMsBmCrzsBmedvUqhcXfXsEmsdp8zfnu+CtM/nEX2R/aZLWgHVAtXLPOpiFaISgr7HFrh7jkFfwk7uw4EB6aRMW3XHAS4dpn9JlrA4bYW9t4SBadxiUZXjVd6WL2/0oGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUE0udBtlNU+BMmFu9Vr+FqZgrT80MIVjRnuD2oJMt8=;
 b=tOELnsn8F3ugorYgNwFFaUh6l+rX4RQHmWUj9BNua7WgzYKeH2t/X17/hkRQYTd59cx0jEKbg7LbhJZ9KW8oS6RxfH2UXKwCbyFHQSrYpzSO16AB2J7GG2fO963zfQghpIAMQNa5pGQfCuU55jdFKFnX1+j6iibUiw+Vup2JEx0=
Received: from PH0PR11MB5176.namprd11.prod.outlook.com (2603:10b6:510:3f::5)
 by SN7PR11MB6994.namprd11.prod.outlook.com (2603:10b6:806:2ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 18:51:58 +0000
Received: from PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::8c0c:f9a9:5e2a:1f0]) by PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::8c0c:f9a9:5e2a:1f0%5]) with mapi id 15.20.6086.019; Thu, 9 Feb 2023
 18:51:58 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <kuba@kernel.org>
CC:     <heiko.thiery@gmail.com>, <Claudiu.Beznea@microchip.com>,
        <kvalo@kernel.org>, <linux-wireless@vger.kernel.org>,
        <michael@walle.cc>, <netdev@vger.kernel.org>,
        <Amisha.Patel@microchip.com>
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
Thread-Topic: wilc1000 MAC address is 00:00:00:00:00:00
Thread-Index: AQHZO8ksXzruIoRs50KxNC39W3lrs67G3K6AgAAJKoCAABHAgA==
Date:   Thu, 9 Feb 2023 18:51:58 +0000
Message-ID: <51134d12-1b06-6d6f-e798-7dd681a8f3ae@microchip.com>
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
 <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
 <20230209094825.49f59208@kernel.org>
In-Reply-To: <20230209094825.49f59208@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5176:EE_|SN7PR11MB6994:EE_
x-ms-office365-filtering-correlation-id: ffa215eb-45de-4bb8-d287-08db0aceb8b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: luEk3JLSc5qA2T22aYDI5jd7H9NzTL8nxB6CYqHvlJ6XOOBn89oidxxpAE4z5CbWusvO/K+08YVOsbiWm6BvMBHqEmO3jKs8rTy5BVLjkzs+xjgLy2cKIoBOrnqY3fbaJSw6uOyPhDZy+3h9ulQXl/iMuHfvUFRr34dRmj7UVQr3jUfyoP+VY+g0LyVAgHm6CsJSBR0Qa4JKvaNjI8b/En2J8xYUGr+I1e7N33Y+aWx94HKazouggVXg4dZgN6cTo2BH+8k/ujAfA8h3F9M+eAXopgkOolPeABbhdHnrSeT2y4d57FxA2nJ6YMWG6qFqAs3MlukkDdCJAxQ0HkkIqmDmDLng2LxBFqL+yskIv5iJM5D0EadiY6cBuNtT3N2lMErclZ4WX6jWnNB2qeMfJoQLRYCNTi6+q6+oLy21VkR1phMWYViBbpCDhxfCxdTuE0yWicqvd3xHlfQ26aHAkfKFOGoz1L1IoO7dMHChjm2PJmRQ1I4iYBZRWbh8D2SeIS5Qpwg2+1FohH/OBk9qRJEGNYdouKHlyLeIkXMdEe6NyD39HKDtYpBNWw2STOwFiYHteVYj04K+Edy/lNmg7G54IXo/AbyG1NzkoTjybICZVJ1NHqB4u0wz+5vF5fzTeb70na/H/onJUUM8KRSHjRCwzkayjdoPt8aT6l4r4MZkvMWtF35BDouJ6qea9xd9l4G6Oxp54+E0zwx/bH3NqXeBddMAMIfpi7ceUNVGhWQQxzLZJsMkX+I+xUMJTZ41XgsG0vHiZIvI0xdu9itxog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5176.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199018)(66556008)(64756008)(66476007)(66446008)(8676002)(66946007)(76116006)(31686004)(4326008)(6916009)(41300700001)(122000001)(2616005)(38100700002)(86362001)(5660300002)(186003)(316002)(26005)(6512007)(38070700005)(6506007)(107886003)(54906003)(217773002)(6486002)(53546011)(36756003)(2906002)(478600001)(8936002)(31696002)(71200400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UzdnQmh3RitXbHhZUmxOQVF4a24rZHZua29LSStJZGVBWlB2L1hVN0RTbVNP?=
 =?utf-8?B?UzRmWU5KYlZsMHN6WERLcDRSTkh0VEVCOGVFVkpGZWQrNlFaOUtueTFkVzFW?=
 =?utf-8?B?cmFzalhJK1BFbXI3aFRHamdGRUxnQ1RqWFAreW82bkNQWEhxdVdnN1g3cDQ1?=
 =?utf-8?B?M2pXTkdXVTladWNDUTJCdzIzKytDeGVWUW1DZEJWNHlpeHNBTXgvSHA2ckVK?=
 =?utf-8?B?TlhJK0pmZkp3K1pPM1VnZXBXV3BuNkJ0MWVpNlZONldGL09UMmZ1cG56NWlM?=
 =?utf-8?B?L2YxK2JZQitkZTNQMmhsNnRkcS9hejN0SUNSb1pmNXJSQlk5NTY2QkdYaHd4?=
 =?utf-8?B?OXdvcnJPWElJN293bmk1M2JITDBLQnVDNXFUY3E3L2tNUGl0eUNmZW1CNDE3?=
 =?utf-8?B?MHlOdnNQekZZcGFJQlZPaGlyb3FjTFBvL1ZOY2plQnZ2YUsxOG84TEl1b2Ra?=
 =?utf-8?B?cXBKWUFvcmpacUpsKzd5VldZaWpVOFMxWHhGRWhYSGhqQis4eFJRNzVHV3Q2?=
 =?utf-8?B?aTNYS1hLcUcwdWRlSUtESkhvT216VGtKZHc0bUFzVGQ5STlYVERGOWt3SVB3?=
 =?utf-8?B?TlozWm9reGVjaHNsMlFsYk1HL0VZQkk4NnpSVGNicjdBbCtjeWREdE9OUVRu?=
 =?utf-8?B?SWhJWHNRdkh0Rm9HckN3Qzc4YXc1eFNQRklaaW9sOWNzVEZwRU9ObnNYOXpK?=
 =?utf-8?B?NDZJZWQvVXhRN3hsS3RubW1hT0lYZFpFS3kyakErWkx2UzBhb2UxZy9CMGRZ?=
 =?utf-8?B?aWdoeHRMYkpsRWlmWUZKUEVnQVFYZDloaFIzWjNBTWowdHk5YnFEU09YOUc0?=
 =?utf-8?B?NTRYZHZOeXB4VFVTN3ovS1FmZHVZTnBNaThLVUpUckwvd2xpbHV2ekwwY1lj?=
 =?utf-8?B?eFJ1R1VDRUFDcWNZUUpaVERrRUI5RjFDN3FYY1htbUxXdWZpUTFZakNXMlp2?=
 =?utf-8?B?N3pyYUNuSjN3WWNGajh6NEtzd1Y1T2dCUVVMTkpiU2o0S0lvajVzb1pHSGlI?=
 =?utf-8?B?ZlZTMGEzREVBczcya2xaRHZJamJ3TDN2RUdoWWNsUFZWblI2bUZXNzd1VWlL?=
 =?utf-8?B?K2hJS2thZGNPendjanJ1b1NlUHJ6M2g2akpxd2JadXMyTVdyU2lLZVdUdi8y?=
 =?utf-8?B?NWhONHZ3K0djWFluZ3E3WVhzLytsUlRzYTBkOGVOYmdPYjdRbXp6cmlUWFpJ?=
 =?utf-8?B?VlBXcDNNYkVScDJDcVA4NFpDd0dSQzNWTFEwU1RmSFM5N0VxUEZrRkdNU0xl?=
 =?utf-8?B?Z3ptditwMVpFYi96ZVNYdWMyZy9lZ0ZNY0p5bk1XZnRtZkhlK01pRjlYV3FE?=
 =?utf-8?B?MTNKcVMyb2lML1poUEd6WlYxTnBTbGUrV3Vkc1VHVEFDa1RrV2JFTUxXbHBq?=
 =?utf-8?B?TEZ4Um9MWjBEUUZ1MjRXV1dwNmEwVXN6Y0FneGhMR0ZQS09WNVpIcXA5UEhB?=
 =?utf-8?B?OC9PbGZXeFpibXcrQ0ZUTXNuaDFlVW40dWs0R3luZGczcUJrYS9pMGQ4aE12?=
 =?utf-8?B?dU0wUmhhSHhkeUtIdkRUMVZEMTJNMS9LM2xTc2h3QlgvS3lHQi9LUUhOOGtU?=
 =?utf-8?B?bVNVVnFBTXk3RkFocnZyNVBXZEF5ek1aVEFKaTQ3bSthM2N2SGtwSitYMDR1?=
 =?utf-8?B?YkNpYzhRVkVPbkJjRnU5SUdYOFIyNDF1c1NsOVN6WUNTTUlYY0taRGhZR05m?=
 =?utf-8?B?LzRlMzM2Q2Y3WWVXdlN6ZElHam5FTE9xSzBWQjFrUkhOYlRIZHZoNlBxMDJK?=
 =?utf-8?B?UEQ3Zng0TzZnYzVLaHFkWUNkZjl0TWl2R00xOVI0aDlCTC84a2hEZXNpdFRE?=
 =?utf-8?B?dnJoeUF0TkNta0IxSFlseCtyTFdFTDBjR1V6NnpzR2F0SHBzaXF6Y0VESmx4?=
 =?utf-8?B?YmVHUTdSMTdGcEVlOHRTTFVNaFgzUjZIcTN2OWZQYnNSTU5HeG5KUEJraHpQ?=
 =?utf-8?B?K1lybloyN2lpSzJ2YjVORDVOY282WWdSWmhhTW5iTEEwK1dtbUxCWTBtb1V0?=
 =?utf-8?B?MFNBeTk5RE1mMTlENUFobHFSY2t6R3J6cXpnUnBjSGRaMndOeUpraGVMS0dz?=
 =?utf-8?B?TVZFOWxlZzFTbzNLTGkrb0FwdjVOdXliZC9mTkVBQXJiVUJ0OWgzblk1MTJw?=
 =?utf-8?Q?dBtYEh063zqA6SDTFLt6hZF1K?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <07DC9A550E2D6948BA341DDE12971943@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5176.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffa215eb-45de-4bb8-d287-08db0aceb8b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 18:51:58.1143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lYmjsbrOMBiK1nKew+LMkKFKplfC1lpbVLZqj1O2ACHYhd93imjhz2XwO8LA5UjnB5vh452+LQQMSJl3CReVafm23pHG1QVYJkUFYwFpo4I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6994
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMi85LzIzIDEwOjQ4LCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6
IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0
aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBUaHUsIDkgRmViIDIwMjMgMTc6MTU6MzggKzAw
MDAgQWpheS5LYXRoYXRAbWljcm9jaGlwLmNvbSB3cm90ZToNCj4+IElJVUMgbmV0d29yayBtYW5h
Z2VyKE5NKSBpcyB0cnlpbmcgdG8gcmVhZCB0aGUgTUFDIGFkZHJlc3MgYW5kIHdyaXRlIHRoZQ0K
Pj4gc2FtZSBiYWNrIHRvIHdpbGMxMDAwIG1vZHVsZSB3aXRob3V0IG1ha2luZyB0aGUgd2xhbjAg
aW50ZXJmYWNlIHVwLiByaWdodD8NCj4+DQo+PiBOb3Qgc3VyZSBhYm91dCB0aGUgcmVxdWlyZW1l
bnQgYnV0IGlmIE5NIGhhcyBhIHZhbGlkIE1BQyBhZGRyZXNzIHRvDQo+PiBhc3NpZ24gdG8gdGhl
IHdsYW4wIGludGVyZmFjZSwgaXQgY2FuIGJlIGNvbmZpZ3VyZWQgd2l0aG91dCBtYWtpbmcNCj4+
IGludGVyZmFjZSB1cCgid2xhbjAgdXAiKS4gImlwIGxpbmsgc2V0IGRldiB3bGFuMCBhZGRyZXNz
IFhYOlhYOlhYOlhYOlhYIg0KPj4gY29tbWFuZCBzaG91bGQgYWxsb3cgdG8gc2V0IHRoZSBtYWMg
YWRkcmVzcyB3aXRob3V0IG1ha2luZyB0aGUgaW50ZXJmYWNlDQo+PiB1cC4NCj4+IE9uY2UgdGhl
IG1hYyBhZGRyZXNzIGlzIHNldCwgdGhlIHdpbGMxMDAwIHdpbGwgdXNlIHRoYXQgbWFjIGFkZHJl
c3MgWzFdDQo+PiBpbnN0ZWFkIG9mIHRoZSBvbmUgZnJvbSB3aWxjMTAwMCBOViBtZW1vcnkgdW50
aWwgcmVib290LiBIb3dldmVyLCBhZnRlcg0KPj4gYSByZWJvb3QsIGlmIG5vIE1BQyBhZGRyZXNz
IGlzIGNvbmZpZ3VyZWQgZnJvbSBhcHBsaWNhdGlvbiB0aGVuIHdpbGMxMDAwDQo+PiB3aWxsIHVz
ZSB0aGUgYWRkcmVzcyBmcm9tIGl0cyBOViBtZW1vcnkuDQo+IA0KPiBuZXRkZXYgc2hvdWxkIGJl
IGNyZWF0ZWQgd2l0aCBhIHZhbGlkIGxsYWRkciwgaXMgdGhlcmUgc29tZXRoaW5nDQo+IHdpZmkt
c3BlY2lmaWMgaGVyZSB0aGF0J2QgcHJldmFsZW50IHRoYXQ/IFRoZSBjYW5vbmljYWwgZmxvdyBp
cw0KPiB0byB0aGlzIGJlZm9yZSByZWdpc3RlcmluZyB0aGUgbmV0ZGV2Og0KPiANCg0KSGVyZSBp
dCdzIHRoZSB0aW1pbmcgaW4gd2lsYzEwMDAgYnkgd2hlbiB0aGUgTUFDIGFkZHJlc3MgaXMgYXZh
aWxhYmxlIHRvDQpyZWFkIGZyb20gTlYuIE5WIHJlYWQgaXMgYXZhaWxhYmxlIGluICJtYWNfb3Bl
biIgbmV0X2RldmljZV9vcHMgaW5zdGVhZA0Kb2YgYnVzIHByb2JlIGZ1bmN0aW9uLiBJIHRoaW5r
LCBtb3N0bHkgdGhlIG9wZXJhdGlvbnMgb24gbmV0ZGV2IHdoaWNoDQptYWtlIHVzZSBvZiBtYWMg
YWRkcmVzcyBhcmUgcGVyZm9ybWVkIGFmdGVyIHRoZSAibWFjX29wZW4iIChJIG1heSBiZQ0KbWlz
c2luZyBzb21ldGhpbmcpLg0KDQpEb2VzIGl0IG1ha2Ugc2Vuc2UgdG8gYXNzaWduIGEgcmFuZG9t
IGFkZHJlc3MgaW4gcHJvYmUgYW5kIGxhdGVyIHJlYWQNCmJhY2sgZnJvbSBOViBpbiBtYWNfb3Bl
biB0byBtYWtlIHVzZSBvZiBzdG9yZWQgdmFsdWU/DQoNCg0KcHJvYmUoKQ0KICBldGhfaHdfYWRk
cl9yYW5kb20oKTsNCg0KDQptYWNfb3BlbigpDQogICBpZiAoaXNfcmFuZG9tX2FkZHJlc3MoKSkN
CiAgICAgICByZWFkX21hY19mcm9tX252KCk7DQogICAgICAgZXRoX2h3X2FkZHJfc2V0KG5kZXYs
IGFkZHIpOw0KDQoNClJlZ2FyZHMsDQpBamF5DQo=
