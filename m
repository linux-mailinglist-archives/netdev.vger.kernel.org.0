Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA4B69261A
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbjBJTML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBJTMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:12:09 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB70975F4F;
        Fri, 10 Feb 2023 11:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676056326; x=1707592326;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ACugTI8oopGy7JFwxGs7dumDocoZjq4Eg4Rbox6h4C8=;
  b=1uDFqIjm4RcivXJOCqTawuY7S625JPXvsqjg5F7svU+hp10sHTo6V5lU
   OAbsWkEQyE4VcCq3HL/AkuRvhCDTtiW/+ykmVxI6UlULJUWXrHgqjP3qK
   0fKNo6mleXDMU41X7r0VPAu6bxz54JHjaIXKrlq0A9mUOw/UdWAh0PSqV
   rj67Jcn7V+1KfLCYl8CitTKFZNrAf7P8dtpCgUejCRuEWX4JtusHldeMv
   arGUsB7hz56eXA5Cvf92nzJugTNrZcinwnjH7iZev1HUrVSGyTh8S7GEh
   yEVmX8OTahndnZUj6p3rJF4hgcaNGCBz8BuMbyh/zcUylZjuIvTzxcRBO
   g==;
X-IronPort-AV: E=Sophos;i="5.97,287,1669100400"; 
   d="scan'208";a="199949019"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2023 12:12:03 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 12:12:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Fri, 10 Feb 2023 12:12:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U55mYb3MXTTESwZxDcvCCgk+2bUZd+JPeA6klGmTXeY2siNR+9Pm9MJlbSFkoOO8AuHBJcGFhLkdRxF5fUQpF+418Bk63bd4KgJOJ86KkLc56TQQoC/cqejkxMsA3dokdiBgptireKFhe6Lm8km4HJmSKKAtvfJPibDBLBPBkmQnoP3x22wqQ8qX0xhC0vNt4pmZUk1qRGOSido3n2PEO3MAntmiaDwJ4d8oo6fIfD1UPJ6aQo7ffs2eNXIoHR41nKxW4FKLA9Q6vrHx2VOgBj/oQamzr2LdsVSDvi41uj5Wl7FBgkTZY073cSvgAQ3lsC7q26EAGtHMdJhBHNvckw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACugTI8oopGy7JFwxGs7dumDocoZjq4Eg4Rbox6h4C8=;
 b=DXXXyGBqptQhDIXcXh78GsKVXbqwcMXyuErPBZbCsAzlV4ViEpKZ8vkXTvYC78KYSq/LRHSgXQdejN3keTAKu/SkNTmz3iXhPNHCvTBGUNRVcfzKBYbCPtuLM+kyZ0E2lP9c/5fyeXKfiwFZqlnYAq6J8iz/OPNqFj5joZCA96zPAJbGVZ2z4nc/UJYc4nwJGWczUbMNYdgS8+wDm0+WyiUqY6nu58Z5cEpGBEoj/2lnL4k3FJ5g4b+w2eI6Zb1J3tc9PxZ1FtTbGJvmQmgY+RicXrqEdINDKrouauWYgascuQCuhU+flDdThwxdVJCnLXql++l8tHOt9ZtEPFyBfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACugTI8oopGy7JFwxGs7dumDocoZjq4Eg4Rbox6h4C8=;
 b=ukvxKbXdssiCrgg2yoky6N8r3n03dgXUJqJ2bWqFE+V29EYbVgp95sqlboU5wyEeHsksU1J95H9tuPzLGCbTJ/ywXUZla/oMUwt5HRv/J2lvUsqjV8TClc6fPfCM3DmQNb/e1blfJxZT6b4u5FU73YhHXUKfis7rBrZAuoekKww=
Received: from PH0PR11MB5176.namprd11.prod.outlook.com (2603:10b6:510:3f::5)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 19:12:01 +0000
Received: from PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::8c0c:f9a9:5e2a:1f0]) by PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::8c0c:f9a9:5e2a:1f0%6]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 19:12:00 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <kvalo@kernel.org>, <heiko.thiery@gmail.com>
CC:     <michael@walle.cc>, <kuba@kernel.org>,
        <Claudiu.Beznea@microchip.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <Amisha.Patel@microchip.com>,
        <thaller@redhat.com>, <bgalvani@redhat.com>,
        <Sripad.Balwadgi@microchip.com>
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
Thread-Topic: wilc1000 MAC address is 00:00:00:00:00:00
Thread-Index: AQHZO8ksXzruIoRs50KxNC39W3lrs67G3K6AgAAJKoCAABHAgIAAJdqAgAADPYCAAMi3AIAAAkmkgACj2AA=
Date:   Fri, 10 Feb 2023 19:12:00 +0000
Message-ID: <2c2e656e-6dad-67d9-8da0-d507804e7df3@microchip.com>
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
 <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
 <20230209094825.49f59208@kernel.org>
 <51134d12-1b06-6d6f-e798-7dd681a8f3ae@microchip.com>
 <20230209130725.0b04a424@kernel.org>
 <2d548e01b266f7b1ad19a5ea979d00bf@walle.cc>
 <CAEyMn7bpwusVarzHa262maJHf6XTpCW4SL0-o+YH4DGZx94+hw@mail.gmail.com>
 <87bkm1x47n.fsf@kernel.org>
In-Reply-To: <87bkm1x47n.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5176:EE_|PH7PR11MB7003:EE_
x-ms-office365-filtering-correlation-id: a22a2590-86b5-41cd-76db-08db0b9aafd6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N8DVVfD/+L1orLkacVIwgx524c+MfV18mclnP+w/NRz4dxdqg6qZ896OeQlxwGqYegNLai8fRJHBuP0saoGFpVc0u0fXHgotX7nCWiwVlAHU3dPSUNWgkuMNxq6OSg8BXzQgE9Sg3O20wJOMirqym3irkQ4LpZq+iQeeYTQb4NqnwOSkPyWTysnFpr3h+iaXb98daj76th4plb7GdrWGZ3+qqxWSgioVTxnvlEtdaj/OhNN1JEG3Gm7YPQCY2SoZ5MwRrx8wx65L++/ZtKiNp78ujXqpzpNFXnY3bml/63tb0GsgDYcp7BdVudHv7KqNE+i2Fe3F914VIfoL1SZwnV7BGvfUNmimpvFIlP1giq3PF0HunLofvVfB/Enu+4/PoTmvkX79tDHwBINpoyqkUH+WWPcN3bxFT5y6QM/czqYqijAc9VwPb5+bR2LJIv0JqIjDTK/TPB2KGld/8/ce5zEGHfcQxvTvOkUN81xlitFRsTpCBOF5Gr8ptdg7Sc7h8RNA0s0VwNFpPDVSzF6bbWuaH2wXjfKeMqt1FUOG1RjTN4fCwMK3hjwy21/EV2TLsLAyuET9p0lLQ3LQg3BkdhO1/7ZbOmpDbXCcT5jU8mX0vRO/9QWPPaKtyCDn28NXDWqTVaipZgJOOQay84UZ1YJkA5W+aeguRQWvK+cQHrZ3Un2zmT2ZlHtC8wySKico1tY7lpsm40E5+viKzQChxVqoE7txA7zAa5FIM/b+jzDzjrQ9tro3UD3DR3YytHj8+McgMxHZ/AGigmojZPsSSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5176.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199018)(107886003)(41300700001)(64756008)(76116006)(4326008)(66946007)(66446008)(66556008)(8676002)(66476007)(38070700005)(83380400001)(31696002)(86362001)(122000001)(6506007)(38100700002)(2616005)(36756003)(53546011)(26005)(5660300002)(186003)(217773002)(8936002)(6486002)(478600001)(316002)(110136005)(54906003)(2906002)(31686004)(6512007)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amJZeWlDOVpxRUFhWTh6TTNGNXB6QWdERmxTRWkxMUplaW9Db0FzS1Y0SlAx?=
 =?utf-8?B?TGp2VzNmUzRWMjRjRUNqTFI3TnpEdGhwWHNwaXh4bnEyTnhFbkljcjYrbFJJ?=
 =?utf-8?B?SVNHeUJqR3JVNjBRM1VpV042WFlxMUZBS1I5dGdjNFVBME5xTHMxcHRDejli?=
 =?utf-8?B?cDA2VlUvTG5ST2xKWDNHbHI2TzNuUVo3Zk95Y3Z2WVNQd0VKNmtSN0lnMEpk?=
 =?utf-8?B?a29wcmFuVWxBZEhqSHl4bEFaOVk2Ykg2KzdPQ25oWUFZRGVVVHdtVlJ2YzBH?=
 =?utf-8?B?YXhGUGJ4NEdwaG5WYldnc3UvZlRWUXZqTUF6WWcySGtObXdyVnUweG05dmpq?=
 =?utf-8?B?L0hDeTJTTHc3TmhXV0ZkSWhoRWN6bmhLTG5uL1hYUWQ4VWIwOGhBTm4xeWZj?=
 =?utf-8?B?MFg0R1RxOXVNSmY0VkY4WDNCM1RqUmY1dkY1MEFBemJrcFVna01ZMWQ5RFJP?=
 =?utf-8?B?K01mYzNhUis0N1JKWlN6SUZoVm9rUzRnbFFjcVRpYmVXS1BSWFpsWGpmMGZa?=
 =?utf-8?B?V2lGSFpNcVdvajI3dHVBVFMrQXdpMlQ3V3dZcWhucGdnMko3SjFMVGtwaVFi?=
 =?utf-8?B?UnJ5eXNwSERqUDh3QWZUV3ZvREorbkxnajRBWWNjcU1aOCtOVTVHSWJHNnZj?=
 =?utf-8?B?WDY0WjVBbG14UVkzV1pOK1IrRlVGOHZCRGl4SFRDcEE5SXg0VTh6QkFWb1Q5?=
 =?utf-8?B?TTZvUnY1MWRxZ3RMRHBlTG9vYk1jQi90WSt0ZkJTVWhIZUgzbDVTN3pYM243?=
 =?utf-8?B?U010NzRHekYxZVZnL0xoaU1LVno2VjB2Q1BUREpaQTQ4MUJEaytCdytpZWoz?=
 =?utf-8?B?ZjFULzJtMFYzLzZZYmxyY3hTWG01S3lBR0k2NXdPMjg1Y25CQzRDd3RXdlVl?=
 =?utf-8?B?ell6bFpFOGE5U0Y4RVR1VFd1UEtlOVIwK3JBMTFkalpCM2tGUjd6Z2NvajU5?=
 =?utf-8?B?dW5meExlTTZMRGl0REdTT2VKc3pCY29vTmhNWnRLQXNOMWcwV3BIelgwSVNv?=
 =?utf-8?B?WjRqQnBOcC8xS21YVlNYZE5oY2hyUjJ6WHA2OUVGK2xrdXZhRldDcE9zRjBm?=
 =?utf-8?B?STRvVTgvOXNrTjU4d3Rneks4QzY0UFc0RDFhQkdqSFJMSG5aRmtQQUltK1Uz?=
 =?utf-8?B?MFYzQ3AvZERhZTFHR245TXdza2l6VzA3MWg3TmdyblRVMUcyQ1d3U1pteSs2?=
 =?utf-8?B?VXUvRU9WOWl2UWdQaGs4OWkzMzNKTDlGaEVkaWdleERQVng3c3hSaUVBbzR5?=
 =?utf-8?B?TGRiaFN2ei9jWlExaVZPVUxTNHVuZmRTZzRJOEl2TnpLUjk2N3kveklNczFq?=
 =?utf-8?B?Q0xtcThWbXJ2QjBWdkVucTJ4dDRzY0I0cEhmQnQrVmxjd0lISHUyUGllKzhM?=
 =?utf-8?B?ZGdzSmRzb3F4OU5UUFFaeHNra0U3c0NpMnZ3QjJVZVQvdnhtNTlxUERBMm1S?=
 =?utf-8?B?dTNtYmtLalJZbkpDMmx5bThKWGhMTitqUFpmZXdGMmE4cU0zOTlLbU9Ka09V?=
 =?utf-8?B?YTRDbll0ZC85UlhiTHZzQTVLU2dDbDNLZzZrbnhjNnZmM2FYaW1sYnYyelR6?=
 =?utf-8?B?VWdqQmRUbXlEVjhGNUxNVGxaeThNSlBEQlJ6VHRRS2pPaGkxZGxaSU96Y29S?=
 =?utf-8?B?YnJzVHV4OHM2Ylhxb3lqMzJIWVZSWmZ3cWNIMlpnK3BONjNtODJtY3FrcVJr?=
 =?utf-8?B?NDZYNVY1TlJTZzVYajhsWGY1dDBaNWRmZjl4amk5UHE2UkdyNzRURlRYTnBF?=
 =?utf-8?B?VmVoeStWcDNIVzBrUG9zMUQ1T3JwekM3QUhyelJJZG04bWt5VkZwVWdXQUlF?=
 =?utf-8?B?aStsRjRybm43RHlKUDZldkg1UFJaZ1dtUTB5TFc3OFA5L3BHNjhYV2V5UDJO?=
 =?utf-8?B?ZmhUN2xQVW1IT21xVVFLakZCV2JDNHdyZExHMFVWOGx3VmtkTlBVYWcyaEZT?=
 =?utf-8?B?TGVTM3hkdTJ3aHlSTjlTRXl0amhVdEM5dTRveFdIZnA1cy91VHhsbDByVGRU?=
 =?utf-8?B?bHlPQ1AxemNkNlAzN3FsVzFjWHFZek0zVThhNG5lQXNxL2NyN3BnNys2L2Er?=
 =?utf-8?B?K25hVUtKQVc2TzhXcE5rV2pmbnk1SDlwSkxpTTFLOXRyM1NQd0tKZk1ZY1hE?=
 =?utf-8?Q?009mZwFcKKiIN6lOGeXDRRc8f?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B201C4E2867407469FFF5D46EE487F13@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5176.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a22a2590-86b5-41cd-76db-08db0b9aafd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 19:12:00.5838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WFP0/SYCc7ZlCnUv2/1QnP2XH8y0lqM0awk7tFq7nvHn6zptFDY2uAAn9/RpaM5VTMXdRxweubntmGOZIzmQgGi9+qRA5lkzQPhBv/ko60U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS2FsbGUsDQoNCk9uIDIvMTAvMjMgMDI6MjUsIEthbGxlIFZhbG8gd3JvdGU6DQo+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gSGVpa28gVGhpZXJ5IDxoZWlrby50
aGllcnlAZ21haWwuY29tPiB3cml0ZXM6DQo+IA0KPj4gSEksDQo+Pg0KPj4gQW0gRG8uLCA5LiBG
ZWIuIDIwMjMgdW0gMjI6MTkgVWhyIHNjaHJpZWIgTWljaGFlbCBXYWxsZSA8bWljaGFlbEB3YWxs
ZS5jYz46DQo+Pj4NCj4+PiBBbSAyMDIzLTAyLTA5IDIyOjA3LCBzY2hyaWViIEpha3ViIEtpY2lu
c2tpOg0KPj4+PiBPbiBUaHUsIDkgRmViIDIwMjMgMTg6NTE6NTggKzAwMDAgQWpheS5LYXRoYXRA
bWljcm9jaGlwLmNvbSB3cm90ZToNCj4+Pj4+PiBuZXRkZXYgc2hvdWxkIGJlIGNyZWF0ZWQgd2l0
aCBhIHZhbGlkIGxsYWRkciwgaXMgdGhlcmUgc29tZXRoaW5nDQo+Pj4+Pj4gd2lmaS1zcGVjaWZp
YyBoZXJlIHRoYXQnZCBwcmV2YWxlbnQgdGhhdD8gVGhlIGNhbm9uaWNhbCBmbG93IGlzDQo+Pj4+
Pj4gdG8gdGhpcyBiZWZvcmUgcmVnaXN0ZXJpbmcgdGhlIG5ldGRldjoNCj4+Pj4+DQo+Pj4+PiBI
ZXJlIGl0J3MgdGhlIHRpbWluZyBpbiB3aWxjMTAwMCBieSB3aGVuIHRoZSBNQUMgYWRkcmVzcyBp
cyBhdmFpbGFibGUNCj4+Pj4+IHRvDQo+Pj4+PiByZWFkIGZyb20gTlYuIE5WIHJlYWQgaXMgYXZh
aWxhYmxlIGluICJtYWNfb3BlbiIgbmV0X2RldmljZV9vcHMNCj4+Pj4+IGluc3RlYWQNCj4+Pj4+
IG9mIGJ1cyBwcm9iZSBmdW5jdGlvbi4gSSB0aGluaywgbW9zdGx5IHRoZSBvcGVyYXRpb25zIG9u
IG5ldGRldiB3aGljaA0KPj4+Pj4gbWFrZSB1c2Ugb2YgbWFjIGFkZHJlc3MgYXJlIHBlcmZvcm1l
ZCBhZnRlciB0aGUgIm1hY19vcGVuIiAoSSBtYXkgYmUNCj4+Pj4+IG1pc3Npbmcgc29tZXRoaW5n
KS4NCj4+Pj4+DQo+Pj4+PiBEb2VzIGl0IG1ha2Ugc2Vuc2UgdG8gYXNzaWduIGEgcmFuZG9tIGFk
ZHJlc3MgaW4gcHJvYmUgYW5kIGxhdGVyIHJlYWQNCj4+Pj4+IGJhY2sgZnJvbSBOViBpbiBtYWNf
b3BlbiB0byBtYWtlIHVzZSBvZiBzdG9yZWQgdmFsdWU/DQo+Pj4+DQo+Pj4+IEhhcmQgdG8gc2F5
LCBJJ2Qgc3VzcGVjdCB0aGF0IG1heSBiZSBldmVuIG1vcmUgY29uZnVzaW5nIHRoYW4NCj4+Pj4g
c3RhcnRpbmcgd2l0aCB6ZXJvZXMuIFRoZXJlIGFyZW4ndCBhbnkgaGFyZCBydWxlcyBhcm91bmQg
dGhlDQo+Pj4+IGFkZHJlc3NlcyBBRkFJSywgYnV0IGFkZHJzIGFyZSB2aXNpYmxlIHRvIHVzZXIg
c3BhY2UuIFNvIHVzZXINCj4+Pj4gc3BhY2Ugd2lsbCBsaWtlbHkgbWFrZSBhc3N1bXB0aW9ucyBi
YXNlZCBvbiB0aGUgbW9zdCBjb21tb25seQ0KPj4+PiBvYnNlcnZlZCBzZXF1ZW5jZSAocmVhZGlu
ZyByZWFsIGFkZHIgYXQgcHJvYmUpLg0KPj4+DQo+Pj4gTWF5YmUgd2Ugc2hvdWxkIGFsc28gYXNr
IHRoZSBOZXR3b3JrTWFuYWdlciBndXlzLiBJTUhPIHJhbmRvbQ0KPj4+IE1BQyBhZGRyZXNzIHNv
dW5kcyBib2d1cy4NCj4+DQo+PiBNYXliZSBpdCB3b3VsZCBiZSBhICJ3b3JrYXJvdW5kIiB3aXRo
IGxvYWRpbmcgdGhlIGZpcm13YXJlIHdoaWxlDQo+PiBwcm9iaW5nIHRoZSBkZXZpY2UgdG8gc2V0
IHRoZSByZWFsIGh3IGFkZHJlc3MuDQo+Pg0KPj4gcHJvYmUoKQ0KPj4gICBsb2FkX2Z3KCkNCj4+
ICAgcmVhZF9od19hZGRyX2Zyb21fbnYoKQ0KPj4gICBldGhfaHdfYWRkcl9zZXQobmRldiwgYWRk
cikNCj4+ICAgdW5sb2FkX2Z3KCkNCj4+DQo+PiBtYWNfb3BlbigpDQo+PiAgIGxvYWRfZncoKQ0K
Pj4NCj4+IG1hY19jbG9zZSgpDQo+PiAgIHVubG9hZF9mdygpDQo+IA0KPiBUaGlzIGlzIGV4YWN0
bHkgd2hhdCBtYW55IHdpcmVsZXNzIGRyaXZlcnMgYWxyZWFkeSBkbyBhbmQgSSByZWNvbW1lbmQN
Cj4gdGhhdCB3aWxjMTAwMCB3b3VsZCBkbyB0aGUgc2FtZS4NCj4gDQoNCkluIHdpbGMxMDAwLCB0
aGUgYnVzIGludGVyZmFjZSBpcyB1cCBpbiBwcm9iZSBidXQgd2UgZG9uJ3QgaGF2ZSBhY2Nlc3MN
CnRvIG1hYyBhZGRyZXNzIHZpYSByZWdpc3RlciB1bnRpbCB0aGUgZHJpdmVyIHN0YXJ0cyB0aGUg
d2lsYyBmaXJtd2FyZQ0KYmVjYXVzZSBvZiBkZXNpZ24gbGltaXRhdGlvbi4gVGhpcyBpbmZvcm1h
dGlvbiBpcyBvbmx5IGF2YWlsYWJsZSBhZnRlcg0KdGhlIE1BQyBsYXllciBpcyBpbml0aWFsaXpl
ZC4NCg0KDQpSZWdhcmRzLA0KQWpheQ0K
