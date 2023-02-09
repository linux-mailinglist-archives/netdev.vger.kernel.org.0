Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABAD690EFB
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjBIRPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBIRPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:15:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF13F60B84;
        Thu,  9 Feb 2023 09:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675962945; x=1707498945;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=a8g38umJsXRLogjs7YJWj+JDUTFMeR/3UAkpzLMXQm8=;
  b=bsKu2MNZ7at6CEd8TmajAIdliRiYhKyH3jqurkC8kmmnBS5ps2dInqSo
   1jG0TTJL+HgpwPIGwxrSUDYLJgaiYKU+LHa20wSiwySulb3EilJ5Cpi1P
   ehewD2yRxapWolKG0KDAHjjuuglDkECR255pfMg3MHfAd/nrgTYHBy3BV
   uTa0ghVpmnGV8QZNHF5/+N295Nr9eWo//kbEisZ4xFaUZVr7cWkQAtEUS
   QNGpwhZrljKhBoZUwF01fOR+Loco+kbFB27sthqp16cBwTmiGS/lCj2oA
   A2/RuOtws8G187ioLMkenI/rSdqiq/v/vx1knEc6Pl3c6Zjte27sFy4r+
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,284,1669100400"; 
   d="scan'208";a="136393696"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2023 10:15:44 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 10:15:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 10:15:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bua/2uZmutq2g9bYYJ7f2QDabprS5T1gsj/Q3iBCX3rGPjzhWa3ZSEU4LY4PrpqYlSuAD+Ps3o97Bc1s5QJWDsxXCRvo8nFnA5Szjvby1oFJLSOhWbsv3zgEBFfTFsTmb1pinJdsnpPefmR2ip5C0N+bNpghCQ2NS24jhpcHGW80XKrTPtjGb6+hYujg1ropjHpjKlCNeuLCdAKno7A2+Xlr1aETIOxoe6veq+zeWTGZLvTGf/GMh+ifl/Pky/H6/u07DLyTSBPKulVEA2SrBbpv2lmxVcFD2sGqlx9YR47dcbNj1B6gCYDisOTTcv0Q9vgjNodfVJou4gVzkpLuEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8g38umJsXRLogjs7YJWj+JDUTFMeR/3UAkpzLMXQm8=;
 b=BwOurAEjMXoGBVAmzP8ZkxzbXhsUfujTpciSyts382MRTuWoNb+z/OoJSCal/f84+ICp8JQzqgD0NCzbC/B4ovN/UPrEYhYWCmo70JeKMmvXOhttUO9HPWcEcvItO3+1YaFmNP/t4U2gxRs0ren/vIjOZwUjlNOxWfQi6fpKFULHJ5cpGxL5Nm1VWpbdzp2HegeP96f8zx0RNgD/rErWp+BU4KXg+ny4TH8bG4cZux50u7O7BzXgHV8D4MPptt/wdUzrZuxa7VU/Ck/tDQBSWOZjq6cyrPUqeNtqCdDGPgKcxcfzRoZrOOUS+wK+HVQNx7OU/R9zmkY1TzHlAW+6zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8g38umJsXRLogjs7YJWj+JDUTFMeR/3UAkpzLMXQm8=;
 b=PXdAm+LFyJivts+/zJjBjRLySfY1JJuA9jwaR7JtUhnLRuY7OsOOcX8LDmV0MdtOtDdQD3mk0H+f6Sbku/MdD0r5zO7jjMmdIuxq0LIOyUKwThVMqhemWMHjBChGneaflhxt+OHk/0gT/LVx/VCYnMz4x5DKHibowSGea3SVakM=
Received: from PH0PR11MB5176.namprd11.prod.outlook.com (2603:10b6:510:3f::5)
 by SJ0PR11MB5118.namprd11.prod.outlook.com (2603:10b6:a03:2dd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 17:15:38 +0000
Received: from PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::8c0c:f9a9:5e2a:1f0]) by PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::8c0c:f9a9:5e2a:1f0%5]) with mapi id 15.20.6086.019; Thu, 9 Feb 2023
 17:15:38 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <heiko.thiery@gmail.com>, <Claudiu.Beznea@microchip.com>
CC:     <kvalo@kernel.org>, <linux-wireless@vger.kernel.org>,
        <michael@walle.cc>, <netdev@vger.kernel.org>,
        <Amisha.Patel@microchip.com>
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
Thread-Topic: wilc1000 MAC address is 00:00:00:00:00:00
Thread-Index: AQHZO8ksXzruIoRs50KxNC39W3lrs67G3K6A
Date:   Thu, 9 Feb 2023 17:15:38 +0000
Message-ID: <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
In-Reply-To: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5176:EE_|SJ0PR11MB5118:EE_
x-ms-office365-filtering-correlation-id: bbd6c6f0-5e79-48be-e8d7-08db0ac1438e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /HGxjvSuhF8A7uWyI1LnP8lpqBEwVlfSS0kOj4KaWZ2CgQNVdQGXq5xx0qa0sEZN288R+n6TR8FNCUpSUx7C4nuYmiLKIWwRQmeWJaCbr5U4vju6zMGK6y7tqZzNdHe1DnDcvSYbkUJbuBJFZadUod83F7Sy0252NuKsKFkfXdDunUidDQVr/b1D6FHsjx1dF2wYhP/kcktT6jE6MQoTSo9H4j2drtvLYsidOxCBd3kKy35bM4mejobekvqn2p0fPqbdq2K2sRFmdqLOG9D37aRVv1MLrFokiRwCrDyQ0hvOyNvT+YROjUHv8S8i6gY6UkeHkdNTM1PNcZuFai+sXJc4RRL6QG2P4h8iHAkRb54gk7s7WQzSyvtc/qvGjRhNIU2jjsoF23j0rzMm0IM9nUEsp/jLtcc/E6L90gkWNSLItkEzmXx7WUKgH0acFkxv/xfB5GqAApHVy3c2a8cmpT6O99mZriaR6g7UEwM8mDOqDgmUSWJAheRRX4NQB/c//FWEviPBT/VqyXtzxo3AhPRRyFCPyHZUdBl/YRHGZK9B3MIHV9I25T/j/LaFA7+Fd0EqLqx0L4ObByn2R3WSVuJ4du7hQt0lhAQ1JVyn6/OKaF9t1dzRPGuuzJD+gy1TSjuDvVyhbkHnz348FBBPQ7AeHMgVsFxgEsfnHOh2bDLdGjcf7fQiVM4Zk+3T2zQ4Mh0TFsaz7NDaogPukhVJHfkRsLxFBQgg+1+yrHFv7UjZh1FETOn3eeLH2C8mGts+UbjU6UzIe+9WXjBFdC4FxRpggHtzmmk8ktDigUgcKS0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5176.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199018)(2616005)(31686004)(38100700002)(6636002)(122000001)(54906003)(316002)(217773002)(110136005)(31696002)(86362001)(36756003)(38070700005)(5660300002)(2906002)(6512007)(186003)(26005)(71200400001)(478600001)(966005)(66946007)(6486002)(66556008)(66446008)(64756008)(41300700001)(66476007)(4326008)(8676002)(76116006)(107886003)(8936002)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFRjUmRJOWRtVmFrS1Jyd2VLYzZLRVlScmlJSmQ3WHVJMkVLMmttSlFkWDQ5?=
 =?utf-8?B?eThqZjJKb01vL1JBYzdtQmRFV01IYmVnWkEyN1lOUkMzbEV2cVUvWUhSbEI3?=
 =?utf-8?B?dU4ydFJtOCtmclJpdnRkSjUvdzhpYmNUNHNJUG9CallUUnoxUGlCQU94aTJ5?=
 =?utf-8?B?amZ4emRMWEhIZFA5ZkR5U3o3b3l3bk1GUy9DMFhjSU1GSE15V24wN2paMUhS?=
 =?utf-8?B?REVENFFzMFRSb1ZnWFdwbjc5a2s1WFFGV1hzbUNTSU9MYWZTaHFkdTJVQkEy?=
 =?utf-8?B?VUtScXIwdndYMXdwTTUzVlpGeW9PNDRYVG1ieHNOeE5TcDlJSmY0SEhKSm9p?=
 =?utf-8?B?SVUxaWExeHoyWFRhT1JyTCtNWWJKWEt2T05ObkhUKzJWRitkelpaRFZxRE9S?=
 =?utf-8?B?bFBWSmtjcmxFd1d3WGJKK0FSZVRNOVZUR2VBcElDWUhXMGJqVzJaa0FQaml0?=
 =?utf-8?B?djJzaDBvVk1SK2tyYlhBU29SbWhrWmNrM2JpdVpxaU01K3h4cG5WNWQvR00w?=
 =?utf-8?B?MWhsVWNiK3dIMkExeFhlYk5RS0c5WXpvMW1meEQ2QTZxY0hSVDFsSnFVcURn?=
 =?utf-8?B?MFRWUFd1NlBic1RYYVlIZHZ2SEo5OWVTR2NjWExIYy9zRktKV0pyY1l3VnVT?=
 =?utf-8?B?NC9EWGR5YlFUTStUWllWdkZONjc1WFJMd2JKTlVFNnkwbklWazIvQ0s4d2pr?=
 =?utf-8?B?bXMwc0tOTGJGTllaL2lHV2I2MmNKdy9VQTRJZmRFRnoxQngxcW02YlpjdTQy?=
 =?utf-8?B?eTRPSmNUZnE4aVMzMHZRajk2SjdJOXR6eWpuL0ROTlI4VzVtd0RPWUQzYU5F?=
 =?utf-8?B?RWlJdUtuL2lqQmdaZ0w5bFBOc2Y5WjUrZ1FkdlVtdEkvbFFra2JjamtUYkZy?=
 =?utf-8?B?N1M0Z1VFT0ZuRWJIOUhoNmRQRUR4cWgrYUpiOWNXMnVwaWh2WXAySG1melN2?=
 =?utf-8?B?TnU3eUs2VXVKS1VMRHZUUFRONVVCczVSVWFSVDBBYlI0R1ZiM0hRU1ZiK05Q?=
 =?utf-8?B?cTc5dHRNR0VLTXpzNnFpVlVhUlREa2QwcytyaGowak9vMjcxM25ldmgyOTJ0?=
 =?utf-8?B?ZkNrOHljRHJPbzNOL3pHYWFGM3pHOGErblppUnNqNUxKL2xWbkRTbUFDTkUx?=
 =?utf-8?B?eGNKRk1HVXhZK05Ed1VYVGtrR0pacmx6U2hJdFQrWjkyL0F6cWNQL3ovbWQ4?=
 =?utf-8?B?aURmSGtZYldLdkJHUjljdlA1Q0hJYkN6Yk9PYzhpa3hleVFNdWY1QUhiVzhC?=
 =?utf-8?B?Smg1UmZVd2p0cklBSnBtSXlQaUhCclNVSlhHTlZMemZicXl6bmtpT3dtV2Jk?=
 =?utf-8?B?RmpNNGNOcTRZNzkzNFlqVktXd3VKbEg5dUpna25wSk4zVXJCUk1Sck5QMklX?=
 =?utf-8?B?RURmRU9xMWRuaVp6ZkNZa2kxdGNuZlFNYkU2dTlQWThCTFlnNXN2bEdCNzUr?=
 =?utf-8?B?TUIzcld2RTcvTFhKZ2hGdmNaL2wwRldqSjRkUnVtbUNIZFIrMUs2ZDJ5NE1w?=
 =?utf-8?B?aFM5NXI5M1ZYSFFtZnJFZklUSW5HYnZYWjk2T0FOLzduUDFYUUUxWS9HYy9y?=
 =?utf-8?B?Z0I2VmMrSmNSRGlhWllYUFpjNEFFYkF3M3VDaHRWdHNmb3RhNHdGMTA4R2Ja?=
 =?utf-8?B?ODQyakdiMkpVTzIxNENJaUt3QVVTY0JVK0xmS3puTmE2emUwejNSY1VjK1BI?=
 =?utf-8?B?K2R0cTFiRzF3Ym5MRENhNmlwc1BjR3JqMSs4SGU2amNMMXh4NzBaanhyU0xW?=
 =?utf-8?B?S3QwVGJjUEFMSzlyV1Nsbk96Nmt2eUt6SkpOWmZOdnhRaWgvTm1CMTRoclBJ?=
 =?utf-8?B?UkxNWjNsb055U2kyc0plVGVQUkRQRDY4VjRQSFJTTkNoSmE2UlJtNTFKN2xs?=
 =?utf-8?B?YVlmZ0VRWitFOEZUWXc4QXFZc0dvMkFweWhJOUR1cFVxWWhoU0dIZVg0dk51?=
 =?utf-8?B?RGlnRm9CSjRja0lpbEtGRWNqb09HYktUOTB0ZlhYNzA0WDY0ajB3d3JmN2JQ?=
 =?utf-8?B?VXo2Y3MzdnREbmZRZzZiS1lsOXFqdHVNWXVEaFZjZlhVdjF4YWFvMS9ya04v?=
 =?utf-8?B?L2d3WlJBTG9VaGNIVFZUYndXUkdQbTdha1VLR05sNVptWUU5NTFjOERjUHZS?=
 =?utf-8?Q?6M7rawvpxKksAfbLEsrauV0zk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25AF551C2F18E44793DA7CC802EA1EA2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5176.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbd6c6f0-5e79-48be-e8d7-08db0ac1438e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 17:15:38.0993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SU/UYiiKRJTmoTOTQGW4NIT31emPMRzHhB7HwbBAuaDbihoQY7eUNAhUV/gn0zbf4lf58+miU8CSw2Uq7QcEKm/8LmXYZi7Xd+miokfp7xM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5118
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSGVpa28sDQoNCk9uIDIvOC8yMyAwNzoyNCwgSGVpa28gVGhpZXJ5IHdyb3RlOg0KPiBFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEhpLA0KPiANCj4gSSdtIHVzaW5n
IHRoZSBXSUxDMTAwMCB3aWZpIGFuZCB3aXRoIE5ldHdvcmtNYW5hZ2VyIFsxXSBJIHNlZSBpc3N1
ZXMNCj4gaW4gY2VydGFpbiBzaXR1YXRpb25zIEkgc2VlIHByb2JsZW1zLg0KPiANCj4gSSB3YXMg
YWJsZSB0byByZWR1Y2UgdGhlIHByb2JsZW0gYW5kIGhhdmUgbm93IGZvdW5kIG91dCB0aGF0IHRo
ZSBjYXVzZQ0KPiBpcyB0aGF0IHRoZSBpbnRlcmZhY2UgaGFzIHRoZSBIVyBNQUMgYWRkcmVzcyBp
cyAwMDowMDowMDowMDowMCBhZnRlcg0KPiBzdGFydHVwLiBPbmx5IHdoZW4gdGhlIGludGVyZmFj
ZSBpcyBzdGFydHVwIChpcCBsaW5rIHNldCBkZXYgd2xhbjANCj4gdXApLCB0aGUgZHJpdmVyIHNl
dHMgYSAidmFsaWQiIGFkZHJlc3MuDQo+IA0KDQpJSVVDIG5ldHdvcmsgbWFuYWdlcihOTSkgaXMg
dHJ5aW5nIHRvIHJlYWQgdGhlIE1BQyBhZGRyZXNzIGFuZCB3cml0ZSB0aGUNCnNhbWUgYmFjayB0
byB3aWxjMTAwMCBtb2R1bGUgd2l0aG91dCBtYWtpbmcgdGhlIHdsYW4wIGludGVyZmFjZSB1cC4g
cmlnaHQ/DQoNCk5vdCBzdXJlIGFib3V0IHRoZSByZXF1aXJlbWVudCBidXQgaWYgTk0gaGFzIGEg
dmFsaWQgTUFDIGFkZHJlc3MgdG8NCmFzc2lnbiB0byB0aGUgd2xhbjAgaW50ZXJmYWNlLCBpdCBj
YW4gYmUgY29uZmlndXJlZCB3aXRob3V0IG1ha2luZw0KaW50ZXJmYWNlIHVwKCJ3bGFuMCB1cCIp
LiAiaXAgbGluayBzZXQgZGV2IHdsYW4wIGFkZHJlc3MgWFg6WFg6WFg6WFg6WFgiDQpjb21tYW5k
IHNob3VsZCBhbGxvdyB0byBzZXQgdGhlIG1hYyBhZGRyZXNzIHdpdGhvdXQgbWFraW5nIHRoZSBp
bnRlcmZhY2UNCnVwLg0KT25jZSB0aGUgbWFjIGFkZHJlc3MgaXMgc2V0LCB0aGUgd2lsYzEwMDAg
d2lsbCB1c2UgdGhhdCBtYWMgYWRkcmVzcyBbMV0NCmluc3RlYWQgb2YgdGhlIG9uZSBmcm9tIHdp
bGMxMDAwIE5WIG1lbW9yeSB1bnRpbCByZWJvb3QuIEhvd2V2ZXIsIGFmdGVyDQphIHJlYm9vdCwg
aWYgbm8gTUFDIGFkZHJlc3MgaXMgY29uZmlndXJlZCBmcm9tIGFwcGxpY2F0aW9uIHRoZW4gd2ls
YzEwMDANCndpbGwgdXNlIHRoZSBhZGRyZXNzIGZyb20gaXRzIE5WIG1lbW9yeS4NCg0KPiBJcyB0
aGlzIGEgdmFsaWQgYmVoYXZpb3IgYW5kIHNob3VsZG4ndCB0aGUgYWRkcmVzcyBhbHJlYWR5IGJl
IHNldA0KPiBhZnRlciBsb2FkaW5nIHRoZSBkcml2ZXI/DQo+IA0KDQpPbmx5IHdoZW4gdGhlIGlu
dGVyZmFjZSBpcyB1cChpZmNvbmZpZyB3bGFuMCB1cCksIGRyaXZlciBsb2FkcyB0aGUNCmZpcm13
YXJlIHRvIHdpbGMxMDAwIG1vZHVsZSBhbmQgYWZ0ZXIgdGhhdCB0aGUgV0lEIGNvbW1hbmRzIHdo
aWNoIGFsbG93cw0KdG8gc2V0L2dldCB0aGUgbWFjIGFkZHJlc3MgZnJvbSB0aGUgd2lsYzEwMDAg
d29ya3MuDQoNClJlZ2FyZHMsDQpBamF5DQoNCjEuDQpodHRwczovL2dpdGh1Yi5jb20vdG9ydmFs
ZHMvbGludXgvYmxvYi9tYXN0ZXIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMx
MDAwL25ldGRldi5jI0w2MDANCg==
