Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0110E6208E1
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 06:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiKHFUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 00:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiKHFUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 00:20:03 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11861C122;
        Mon,  7 Nov 2022 21:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667884802; x=1699420802;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SrWxFo5EIwfHf2psG10lsOYeONkXJZfKXoxo8wf+tyk=;
  b=cv9VBZCbtcg0N5406GVOSxte3c8cj9spFQUc+QEdmLydw1C/EkyI5T6Q
   v1ioRu2J5k5IvrkrOE6JE00Q+8dvsyMDHUgopuczVAVSC1WkNBSa6taSn
   Ej9LSZMWL4o17sJrNeWlDGvGhmwo0+uzvSxINREaRxKXWudkRdBy+HGWn
   qllwd0GbGeFRBfigHfpCm9Orlt0i+CtDZ0tjDhss//OiFS9cdBJ9VIUr9
   eogxhkFA9lJpv4gZdc0dkhpEqjKLTkYODnWuKg3r7xgM1k8mcvvJlPe58
   OBJDeLZ5gctzRAf12g7+lJAGP2Jd6EZ1SH2o9DN4se1SlP9WgdgQ+UnpM
   g==;
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="185843716"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Nov 2022 22:20:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 7 Nov 2022 22:20:01 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 7 Nov 2022 22:20:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLkf8MlhxwSeATyqN1ky28M0tqmATdFjzyHDT+UZALeKF9BZ2FXjd5eDkFZISSNpInXZpJDJAinNVcngNP+Dp1BWxBk3tUCmQ8E5Aete46xx+ebKKMJecocbPGk0HYy4aZ53geXSTUpIpqcPAeGZKrXDHqtK/YXcdEzxBR2ZkW66sedU5zY67w7MKygp8RD+4oADYRg/j+37yB0PQnta5VZLo35Cq/A8saWy0lz0kwz6kVZlWcLtIK7nkjt03z+u9x2mY29QR+A9M4NsnK+eqxW+VvyDufBAZozvb00lstp36IY7AcJ7hQjfVIS1/rRRmA3KCcBGP9T4SjjW7qPLkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SrWxFo5EIwfHf2psG10lsOYeONkXJZfKXoxo8wf+tyk=;
 b=SQevM28cFVV5t+nUUoXgHBXhPieNrcTFVm8mPQUrxHqpyTyn514u47kOXqtHi/ApZPtY2afhrjOv8ybUplDSzQsXbEhy01zlZ0PGle29p/gmiHE5wdP74XTxn3BABVv2S1Ov0lY+EV6nQ8DBW9X7szOSE5+yvqFsy6KvXM+uRmmfERpEKD76fpTrO+k6Oryl42cR+mU2KeRlzvysv61VRinFimSUAn9ucJm7gAcmVlyEv5tKf0SpCSXOZxIsBdq5CV6H16SmTPJECfEnFR6UyZTl3Be+sSOrBHp/5afdAHJeNpGpJtrTlYc6Jg0LjZzG/kX1ia4Wo/VOVYqUpWlbfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SrWxFo5EIwfHf2psG10lsOYeONkXJZfKXoxo8wf+tyk=;
 b=ZzQqjiuDzavbcF2/k6PFK96f5MZWgpUj3mMUTM0toBL7vZC5dEmLfGGFAfLMreKb+Y2pLDpVDoaOi/dtCFjGpDdNOKYSEc5KlQfjphBXkm8TGsc4GaqwO9aXybEjQjkey64KApO2fbKOvLhMH/g3Mv4M6oV10aqrS/Rex7ZKazo=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 MW4PR11MB7104.namprd11.prod.outlook.com (2603:10b6:303:22b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Tue, 8 Nov
 2022 05:19:56 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7%3]) with mapi id 15.20.5769.021; Tue, 8 Nov 2022
 05:19:56 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: microchip: add ksz_rmw8()
 function
Thread-Topic: [PATCH net-next v2 2/3] net: dsa: microchip: add ksz_rmw8()
 function
Thread-Index: AQHY8rEM0eBxPYN62E68S9B2WU5RRa40fhUA
Date:   Tue, 8 Nov 2022 05:19:56 +0000
Message-ID: <b0da927408ecfd8110782429ed20026abe484f87.camel@microchip.com>
References: <20221107135755.2664997-1-o.rempel@pengutronix.de>
         <20221107135755.2664997-3-o.rempel@pengutronix.de>
In-Reply-To: <20221107135755.2664997-3-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|MW4PR11MB7104:EE_
x-ms-office365-filtering-correlation-id: dcd14d89-b600-4d4c-fb5f-08dac148e018
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w4BmHy8Nxd6GFVZQB1JJTFQb58K4ipJk9Gf83rlGsBGq9XDn/N8haewHWknCY/6rcFaZizQnZi5nT54ZxtBcopEo7kze9raXUxDlXKzV+qQJEZdSMuSAs1UlUDjaxLvybhPHhygZxeS2EH/9Sq5r1UhcqYzA4pGoX9YErcfoioqk7Vvo30ijAQ9Pwc0AyYqZKoq9rMJhSsTBvxFls/Vi58039OYmVICMgos4kNhWZn+J/xaXmItQ/5EWkEYbjPIL8pdP9Hx1/2pvD2SJzDM4sVaXzPmwpUG2MpBYeG47xDgc4gQIOJ3RjUQN0aIJrm+Rj+QdasKFiB8skya86U6eFs/7UTCNbQHmvydl0Yq+OJLyqFb9EnM1slBBDlU+skjflz8reWrrWoCgVdhM2e01N6hgILN/oAm2NlETjUHXbAHsPP5A2gBJ+n6QB6h6xUfOtsMAzvtl2+NnTNnx9e6riy0PKPrAFNRZ3q6awXFwf73R99NBBWe3W/R532rYp/ko+ZiBlfFQcYOmfAC6/Xdmf/OuEVfKs1q4ZD2DrYoAk99SqUdBRzZ5DdjfGBMldn8zlH8o0ZtnswwNNZiUqHZJrsu7NTsu/HTnkiM5fGJA3FMHIET6OUF0hprSYOxaloa1jziI2Dox29K1BDDz6rlHuZBlqV0CbJXVlPUnqhn2p7gdYoISsqbL8broa6YZq3HjgOv5if3ZlOpA5KKeKMx7A7wgXCas2YjDUKjzBvOU+Sd+FDSU7TicabPhNPG7evB/zaBtoyGqEfhG7D89KHddzjDcbCxrMKFBcVNNMNo8NwRe3UQri7FTuNxx0a7eAkxC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199015)(4326008)(110136005)(54906003)(316002)(2906002)(8936002)(5660300002)(41300700001)(36756003)(186003)(2616005)(7416002)(91956017)(64756008)(66476007)(76116006)(66946007)(66446008)(66556008)(6512007)(26005)(83380400001)(8676002)(6506007)(6486002)(478600001)(921005)(38070700005)(86362001)(122000001)(71200400001)(38100700002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejU0UkZDWmZtOVREUWEvUS9FU0hQMFRPYVBOR0pseWJUaEZpK2pNZUhUdjUv?=
 =?utf-8?B?ZFliSU43eThrT0o0MXdBZzNyTzROeWdySjB2M1ptU2tyNG10NnMxeTh2YmFP?=
 =?utf-8?B?T3NrZmM5WXhiVFJycTlpWDBOWS9nN0lGS2F3R1BuZFhZc3NCL0VSR2lHZG5t?=
 =?utf-8?B?cGk5RVBUenRRUlAwNm1TVnBWR1dwL250VWM0NTE3aWp4ZWVhNGdvSUluVTI4?=
 =?utf-8?B?ZXpYTm8yRTRFN3FLVm9tU3Z0TWYrSEl4c0RsZUR1WUlUcTZsMkEzU2gzVEJ5?=
 =?utf-8?B?QXpGV3lGTjZEWG5IY2puWFJSakp4ZGFIZEdiamRlSUxVaDFVSis2TWFObTNQ?=
 =?utf-8?B?eU5YUm9FVnU4RzQ2ZVpDd0FrOU5MZ0lscVFLZ0t3aThRa0lJRXBlMHVYOTU1?=
 =?utf-8?B?ZGxrQ1lSd3d3d1BrU3lmWnVETmRZYUh6ajZCYjNFekV2L21wb3U5eUEzcjlB?=
 =?utf-8?B?cU9LbndvVmVrYTd1ZDFYc2RNMjlaQVlQeVp6MEpuWVpFL3dSWHRwVXBXQUZm?=
 =?utf-8?B?ZWYxaTd6OWVNdXdGNkVyLzd5QkVTcE5rd1lBY1lqOEw5aW9sYUFobW16ODJI?=
 =?utf-8?B?MjJtUFh2SlVMQWI0bS9zODFlWnMzMlQ3OE04Y0c1S0Vzb2d0NkpSenYvYmpz?=
 =?utf-8?B?bFd3UFloeFJ6MzgxNlRydmx4eXJadDJMcEhYbXdvaG1qbTErQnYwdFhPN3Ur?=
 =?utf-8?B?NXVvbEZaUEpRTmRkMVZIY0I0S2FNWXAyU2N6b1FkQVhLMDY1U3lHUEdrUDZa?=
 =?utf-8?B?REgwL3FNeUg5emgrNUNBT2FFVnZZRWh2VUMrNEtobDBWMVdyK3NGRHZHdmVT?=
 =?utf-8?B?ZXh5UlNpRmlFWDh4SVhrOGhIOEZHRjN4S2F6emJ4OCsrT2UvcmR3bTBxVnVu?=
 =?utf-8?B?SUZsNG9yaUN1MHFhUm9pamU0cVFGVTYvRDVZYm5MakorYzZsSTBKWU8yMC83?=
 =?utf-8?B?UkRJcTVqWStNY0V5RXVWVTkzMVJQSTBtV0N5WDBwY0pyV1UvSDA5NmRXTEdF?=
 =?utf-8?B?YmNnVlBONUorUEZkaUV6WStkOCs0NnhtYjMxSU1pSkdkS2VzbnBPcXdUZVhX?=
 =?utf-8?B?QUlFazdyM3JOV09pK0kzT016U1hudzJHOEwwZEFlbUN3NWVZdmhUV1ZPVUd6?=
 =?utf-8?B?RTBkK28zMHArd2RkUkx2eXhSbDdSbk5vY3ZHZG1sTDg2Z3hNc1Y3MEJqdEFX?=
 =?utf-8?B?emtQeitVM3REa3FnRGFNTC9ZWXlXTXlFWGhiS1VoQjErN1FoQTYwTzkxb2NG?=
 =?utf-8?B?SDJDTjdHR3NwRkhKQ2UvWGhKcGY1VjNKY1NZNUhOa0NEQkdxZXJrWkNRa1dT?=
 =?utf-8?B?blZta1RaSHhoVHRoTktXQjR5UFlzeGZZSFVkSXk5SGJVelR3YUtDVmNIMVMz?=
 =?utf-8?B?NnI5UGhiNEVZVVF6b1pzRVdaUngwbFlPQmxIQm1LYlpTQVNXL0JwMUJrMGZC?=
 =?utf-8?B?R0FHKzZ4MGRUVE81ZkRqTmJSY0NXaFJ6cFBqb3pSd3NhNnlLU2VlWlgwMGY3?=
 =?utf-8?B?bjk3VlBJeE55R2kwcGdxNW9NWmdTQ1Y2MnRGQzl6WUd6Nzg5WmhIQkhCT1g3?=
 =?utf-8?B?U0xyNUpHMkE3WmxicTlTOEhkVzk1MGRJR2ZFenVHNUY1SHhJUWd3L2MrNzZT?=
 =?utf-8?B?TTVuUHNqdWxBRzNESG53VXF5bHlvRGxUbFIxUjNTanB5UkR2VmZZT0VTSkd0?=
 =?utf-8?B?UXFMb2lRTWFOMllhUlJrd2FCbDk5NGtkUHNtbVZUOHMwaStsK255U2ZjcmZN?=
 =?utf-8?B?dWRrU2M0ZjhiUUNBdHNDZWRXaHRMcERvVEdYWCtocFlMVUk5RjZkNlFlQnph?=
 =?utf-8?B?Y1E3Si9ndVZpalZQbjhOa25BMStZWkg3ak42ZWdjMGJYR3FiZmFZaDF0RHFs?=
 =?utf-8?B?QTJ2NWZjQXVxREsyVFo3WTFkRFU5cHA0YzA3UkRmVmk2OXNlTmtJTGJYZ2tJ?=
 =?utf-8?B?NS83aEIwR2gxTkZ0ZXdWMmRMTVBZZ0dyM0hDZy84UXFwa2x0MGFKSFpxQzBa?=
 =?utf-8?B?aFE1RzZjN0x3alFFV3krOGxaWnN3WTMrTTVyd0FlZnRoNDBXMWNEK3BDMEJy?=
 =?utf-8?B?bGJua09seFBqTlpxMnViVDB0WlBDN3hmdFQzenQ5V2JYUlcxbHhES2lJVWNZ?=
 =?utf-8?B?Ui9IN3FQbm96SXI5Yy9PWjNKb3l4RVpQNUNSNG9jbHd2NUNhWnI3ZjVObktJ?=
 =?utf-8?Q?5xV0a2R0tebhmhnkkimugKA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88B4B3F29DCDAC4FBE9B166C2AFDF7CA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd14d89-b600-4d4c-fb5f-08dac148e018
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 05:19:56.7729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GbemioKtR+/73peKW2yb9w+b7wJlhgqINutO7N8WYKImkqtdRjYZnTHOblCVyHva2uOp4f/lKL9K8Macx6t01Qj8vjE+6x6bT4hnXOez+Ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7104
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTA3IGF0IDE0OjU3ICswMTAwLCBPbGVrc2lqIFJlbXBlbCB3cm90ZToN
Cj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBBZGQga3N6X3Jt
dzgoKSwgaXQgd2lsbCBiZSB1c2VkIGluIHRoZSBuZXh0IHBhdGNoLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogT2xla3NpaiBSZW1wZWwgPG8ucmVtcGVsQHBlbmd1dHJvbml4LmRlPg0KPiAtLS0NCj4g
IGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oIHwgNSArKysrKw0KPiAgMSBm
aWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+IGIvZHJpdmVycy9uZXQvZHNhL21pY3Jv
Y2hpcC9rc3pfY29tbW9uLmgNCj4gaW5kZXggN2RlNTA3MDYzN2VjLi44NWNlNmVjNTczYmEgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+ICsr
KyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+IEBAIC00NTMsNiAr
NDUzLDExIEBAIHN0YXRpYyBpbmxpbmUgaW50IGtzel93cml0ZTY0KHN0cnVjdCBrc3pfZGV2aWNl
DQo+ICpkZXYsIHUzMiByZWcsIHU2NCB2YWx1ZSkNCj4gICAgICAgICByZXR1cm4gcmVnbWFwX2J1
bGtfd3JpdGUoZGV2LT5yZWdtYXBbMl0sIHJlZywgdmFsLCAyKTsNCj4gIH0NCj4gDQo+ICtzdGF0
aWMgaW5saW5lIGludCBrc3pfcm13OChzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgb2Zmc2V0
LCB1OA0KPiBtYXNrLCB1OCB2YWwpDQo+ICt7DQo+ICsgICAgICAgcmV0dXJuIHJlZ21hcF91cGRh
dGVfYml0cyhkZXYtPnJlZ21hcFswXSwgb2Zmc2V0LCBtYXNrLCB2YWwpOw0KPiArfQ0KPiArDQoN
CkFja2VkLWJ5OiBBcnVuIFJhbWFkb3NzIDxhcnVuLnJhbWFkb3NzQG1pY3JvY2hpcC5jb20+DQoN
Cj4gIHN0YXRpYyBpbmxpbmUgaW50IGtzel9wcmVhZDgoc3RydWN0IGtzel9kZXZpY2UgKmRldiwg
aW50IHBvcnQsIGludA0KPiBvZmZzZXQsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
dTggKmRhdGEpDQo+ICB7DQo+IC0tDQo+IDIuMzAuMg0KPiANCg==
