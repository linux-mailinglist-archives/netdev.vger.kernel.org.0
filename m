Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D98546715
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 15:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345387AbiFJNHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 09:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344310AbiFJNHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 09:07:00 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59106DF8B;
        Fri, 10 Jun 2022 06:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1654866419; x=1686402419;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TWWWBCcq+IR4pYJ1squ8fqueq0S+k+YnQS0XpWCssGc=;
  b=nGHxvLzS4pNE/MDdxbfQwGcjxHlZ409Lw+bl+Sgaeb9Uf70ZcZbPbgeL
   GBCRa31lHl4Qe/teegWHc44F0mOdlvk/EWF+S6Mr6+4Jd66/WAGwGLGKC
   gZuX1N+bm0qcJCulu7NK/1x2/05WHpNWaSD43+O6FAJ43qyZAMOqAcWn1
   zzbkhAaTsO7ipOD68Xa0goDsUVsBx2bhYL85uIrBSbzGz9jok4KT2UIXA
   tWjrnOhxM49aU8voX7bUzpj1w786IrWd1fogyKD0UH/OttaqoJHLfou3y
   76QErckeDlNofgqJavVMKVPSXpym/T3cQtM8kbTavt4uO84wcKhgD17lO
   g==;
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="162795233"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jun 2022 06:06:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 10 Jun 2022 06:06:56 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Fri, 10 Jun 2022 06:06:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJxh7GICaj/Ei5S8z15qSBpGqCVSObuTgtiCix5AJ0Jl1jpmzyg92H1x9vV0yWdqxY8wpleMGTU//+bUnxSwbjV+6twTmsct9tk6fawzx+ENUrEOzfIFDUWl69aRfHqiSnQrZkZ561+hSFtFdFblfxP4t3HufqNIJRZKcX16rSd4EAeZyqtPq960BYhn9nhoilBoThpNv4fkMf9/IerDKaKRfOZ03Tu9eH5dJaKZhED70s7csZMiqSBeFunfSH2jkkTtwxZEPUe3I7cqcf5OknBXLt67n+ZMNuPNZcFvdCzVXD+vy19K0lMvPVqAC/fb/ZXmtokeIFhuJwPGIBjWJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWWWBCcq+IR4pYJ1squ8fqueq0S+k+YnQS0XpWCssGc=;
 b=iCGYgu/azCkPspDZkptLlB3HCNQ1Z2yRFBp/aziFazvweYLQS9tW+I14UF8HjxkS7s3atVrEG2kEQtyq906EQnm6loZzbvBQqgqcLdFqNLZfHDyqSvFTQYekRzu2MZSXM9Qd3r1Hyjg92l9ElWXdz5HeC63hETfytgQebc/g3AwsHvX507AZMxAtSLxeHGf12lvHN9of56IAgriypSnnaiuIAVaO08seVJP46Xe4NuAVDOTfgzeaTHBs4sKkyyfwbDmSgsuk2lgsp0LBB1BL/0SKeVXCTxEaUf5exNmBg4S8UIHLl2ou1tDeEHEYmb/NJGszg1KvJ1k4Wha52IiuGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWWWBCcq+IR4pYJ1squ8fqueq0S+k+YnQS0XpWCssGc=;
 b=g8fge0/RPTnDHI96ygbEZryh7zkKmeB+4iolutgVsGb986Ow28FCf5sIk+d4OlD9bxkVaGyIXI+329+CPNS2j5YuZamvxbATYEinmr9kC4aVzDC8KbUio7pQEbMHVbLIue2nk6ghS0E84bWc1jAgAyUR51JmZ/Ki3S+meHBukEY=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by BN6PR11MB1249.namprd11.prod.outlook.com (2603:10b6:404:3e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 13:06:51 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5cfe:8088:aa93:fce8]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5cfe:8088:aa93:fce8%3]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 13:06:51 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <o.rempel@pengutronix.de>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v1 1/1] net: macb: fix negative max_mtu size for
 sama5d3
Thread-Topic: [PATCH net-next v1 1/1] net: macb: fix negative max_mtu size for
 sama5d3
Thread-Index: AQHYfMrz7fUZ0wozcE+MjY5h7+m8Rw==
Date:   Fri, 10 Jun 2022 13:06:51 +0000
Message-ID: <2ff1e2ec-c192-c293-d8e3-d23a1f551c09@microchip.com>
References: <20220610094517.1298261-1-o.rempel@pengutronix.de>
In-Reply-To: <20220610094517.1298261-1-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61fe3c8c-5e26-4ff3-de00-08da4ae215f0
x-ms-traffictypediagnostic: BN6PR11MB1249:EE_
x-microsoft-antispam-prvs: <BN6PR11MB1249EBEA5A4556B1506EBDE587A69@BN6PR11MB1249.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: orcJxIVV/26mo4IjUTiPQhE9UFceFeQw4VCmh/pIhlqs7O0ZshtZyqLwt2PMHPSOQK/LiuStxFtMMx7wWS/2xJWR1Kn0IIp834D2HWnhw0rrX5ba7RzKSrCV8RAWjrUmxTaHBMMljxbR3qP9Y0RQhhFAQ8aqpKr725P55yFfrPekXZzQyzjicaGN943YmmZLpi9RLSlRM4J8zKhTKwzhfgxOZ4ZZWuOuQGl5V2KkNDFLFrjENQI556DRxJhBVnW7AAtg7TNpk5ix0xlIdeV5teZxtvq4zX8dSyd144UWIQwJCGrbFYruxOb905+PcXNISdKn2akCQWQUTKXO5iVKXKgvVfypO1X6CvTilyaWqVxQ0O1/YdY8k0tq9wzJ32xPRTCyd3dGU+S5owBuBPUdWK/zROhC/zialNJjiPtwpamMchNK6uBpCU3JR/32P+xy/gjV6x+MJdmzeSgy7uZQyKtVmdrLD3b1wqZSh6p2vbU3QLdVR4EXxvxAjQqmS5dWpJNU79y08k2uCZhg55R/4Kmt4x79gwqhSB8AfmPqQXYa2pH+gAKth6QD0conrz1AxC29wfHZGmk2Py/Am+GbY+xywg3RxgPZgs281Nzr/Oa0M+WCrYBgAwtrUEHg2Gmkapg67l7Ilms1Y4E5n6vdPmIHHsrXztkrNOhb6D09HH3+WLFMfjBP1ImMvpMLkFqfsYzZmBIUoGEzNR6m4QyNUqScEPGmgFATRU/nl83N9wwT87n/0ZU8OtQHmh8bSLOwX1Pv+kL8gAixmEEMRCi9MQyMn8FjpFYH7TyDvMijsTfwSXtZfwWi8pDgsSqd7/QL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(31686004)(31696002)(86362001)(38100700002)(53546011)(6512007)(83380400001)(38070700005)(2616005)(122000001)(186003)(26005)(71200400001)(508600001)(110136005)(8936002)(5660300002)(54906003)(6486002)(66946007)(66556008)(66476007)(76116006)(66446008)(8676002)(64756008)(4326008)(316002)(91956017)(2906002)(138113003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEZzK0cvMnBnNEN3blo0S1pEY2thYjBkR3lKSFlOeU9FMzBNQ0NLbzZWU2pt?=
 =?utf-8?B?WnNVczNBdGJOaW1NWjlYM1p1Z09Qc0VaMjFQZG9ic1VrYXRMTW0ranI4cGgr?=
 =?utf-8?B?YzZ0eWdWZmFPNE4rdzVyTXUyQ2wwWnBkRnJEMU9jVWp2L0lPbFV3Mk5RWk45?=
 =?utf-8?B?dUZrNW5tQVJGcmtNTDNUQW5zYURrUkdVYnRNT0RPRlJRZTFhTmk0TnhrSDMx?=
 =?utf-8?B?T3RSckZrcWM4djZyMXdUUjRYU2FvN3ZlZXNPOE1IbUZWK3kyRjUxSW9iM0Qr?=
 =?utf-8?B?V09Vb0pRSi9LczFrY0h1S1hjSTFtK2NZWGhPbU55YXV2NGl1T2s3V3Btamtu?=
 =?utf-8?B?NlBNU0p6L2FkbWxFODNiNXd2VElBQllSRVhwckxFc3RjY2U1QWl5ME85TWFp?=
 =?utf-8?B?MzkxTlBIOFJNNlpKZFpCdDNzMFFjZndtYkg3TWtFWWVIWE5vV1ZGallVUkxp?=
 =?utf-8?B?bFduQnZNV2YzODZXRTMzRWpINUtHRlIrU1ZLeUVBVjV6TFlPejJ4dnArY1Bt?=
 =?utf-8?B?TGgzZ3JndDBDK2piQjVmTDhvckhKSnBHVnRNd1dVb1dVT0dreklYbjFRTHVl?=
 =?utf-8?B?OFF2cllwbWswSUNGd2Zka2RINjF1dURJU3NwR3ZzNzRpOHBqa1hDelpuYmF5?=
 =?utf-8?B?TytjaWtMV3V2ZUdIOUZXZkx0elVsNlQrOE1iYkR6U1JmZWtwbXJsRnlDdUhT?=
 =?utf-8?B?SEtCcmQyWnlXUHpicTVjNG03Tm9kbmdWb3lwOXM5SVlaRlBiMENPcEpGUGRO?=
 =?utf-8?B?dGFLRTJvaklSSmNrWFpUL3dOM09WU0F3K0Urd3VBVkNSNGloeTFXTjFRL3By?=
 =?utf-8?B?QkFLcFZpT3o0eWl1b25obTVmM0U2SmJVYWM1RkIwMThOUHdKdmQ3b2VUUVlV?=
 =?utf-8?B?UDZ4L1JGekpmSy9XclZpY0x1b2J1TkZKVWFvcGpYeW5SRk9CbGtXeTR6Snhm?=
 =?utf-8?B?RDZ6SjJRT0dydy9FNGhxTVlSWVJIQ1RvK1hUUmJ2S2ZRNVh4b1Rpamk4T2NT?=
 =?utf-8?B?V3U1bXJkL0ljYmk4QUtFUFRGVFFESlRVWXVOVmtNL1dWalRBcmxMRnE5SXl6?=
 =?utf-8?B?bmoxUmtZa0pEUlp3TTczbjRYbERnUVpZUllyRHErRG1FMnhDbWE4MkVLc2xk?=
 =?utf-8?B?YlJGQVh5aXcrNDNEZ01rcDBLK0ViZjlJblBHWmx4MUxHbjdMOCtGNnpaOUYr?=
 =?utf-8?B?L3ZYSHRGK2N3ZGIxank4NHNIYWZuQXBFQXJLcjhTcDVyYjM2eWlscldDRGFX?=
 =?utf-8?B?TThBQ1VTZ2FCOFcydDBNV3FiSkxzZ29PYXVhS3JCOFN0T2lSLytpMXBzdWJL?=
 =?utf-8?B?SFZUOHpDci9Gdks4b3dzVU1aQllyMWRTUEYzSjJSdHZUcVZGVVZhZmh5WEhj?=
 =?utf-8?B?ZzBLdTd5di9SRnlWSkV0RnhZQmxRWXcyZ04yNjcwNVdtSTRHNmFxUXZRQk0x?=
 =?utf-8?B?dm9kUldBVW1uSXZsb2JvS2kxbHdqbWRTZGtYQVpNcjdzU3RqRXZYcm5zTmNa?=
 =?utf-8?B?RkUxbC9iV1htT0h6QXpoOFBuenExVG1SblBoT3RiRy9hOE04NDVyRTJvZURl?=
 =?utf-8?B?VHoxUmtTa0hUNys4TXd3NGFycEhEL3VzUG0yQzRJRGVSSlRCdm50Vyt3cVVL?=
 =?utf-8?B?Z0NiVW44NDI0VytqR1RvZno0MnV0VnUzK25TUlNCV3g2R1E1eEtBVnVPM1Rr?=
 =?utf-8?B?RlYyMHVBR1NmTXNPTXVYcHBFbEVmNG9mQjU4NTN5VlFHVUNXRlI0cDcwajZJ?=
 =?utf-8?B?eG9TY0VvNFJIQTM4NUc3NkN3QjRSQm80YnJDSWEvT2dVUjlTMEc1eVA0MmtL?=
 =?utf-8?B?MXpSOE02OHkyVXVzTnp5ZFVMcVJibzU2bTh0NUliU1lORzBjMW9WSzF3Ulp6?=
 =?utf-8?B?SzBESHNmajdQb05XN3ZzSzBEYngzM3VEVmJ2S2dDSm5IcWQ4UFN1cVozMFVL?=
 =?utf-8?B?Y20reC9tajAzdmZYK3Rkcmc1UmhIc3NTSVVGM3hjM3ZmVGUxa0Z1N3dCR3Fi?=
 =?utf-8?B?VDdJaktxOFJFNCtLZ2ZsMWpSbS9kU2l4bFpCdkpYZDBKRTA5a0pOZ01hYVFU?=
 =?utf-8?B?S0VYbC9OOUhkSGp2WGxyaTFMcTBkcUt6SysrQXFvbkJVL3J4Q3J1SjBqNzlh?=
 =?utf-8?B?NWVsZHY3S1lXZk1IVFFPcnpNTDV4QXFTb1RtUCtleEZ0TzAvZTFlMnRtcHJC?=
 =?utf-8?B?UmVwdUlBUHc2TE9RRnRnenNHTzk4SmdUOE9MbGNFdHdwZnVrNjRyL3hYRVgw?=
 =?utf-8?B?RGZpZjQvRTZlVUJpOWFUcnNraUdZcmwxRSs4aS9oR0o1dW53WmdZRjR2cjF6?=
 =?utf-8?B?MTBPZFNUQ3RuRFBPMVVoMUZaMnBmRmdmTE41SERscFBsbkhTZjhoL09tVU9u?=
 =?utf-8?Q?CHt5TqW7/Iq0H1kU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7A7AA789E5EBE498B2BE6A8F7E92F1E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61fe3c8c-5e26-4ff3-de00-08da4ae215f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2022 13:06:51.7205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gxNdlfTJTr1yv620Z2lh6U/vjBKSVgVc6atZSbq7Tsgzw4dL3fvKuiRrb6J5F583/MaAf+Ewr9YLMPbwMbAq+Rf9OLOUDyTmonQI8/Dm028=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1249
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAuMDYuMjAyMiAxMjo0NSwgT2xla3NpaiBSZW1wZWwgd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gTWljcm9jaGlwIFNBTUE1RDMgdGhlIEpN
TCB3aWxsIHJldHVybiBudWxsLiANCg0KU2hvdWxkIGJlIGJlY2F1c2UgaXQgaGFzbid0IGJlZW4g
Y29uZmlndXJlZCB5ZXQuIEl0IGlzIGNvbmZpZ3VyZWQgbGF0ZXIgb24NCm1hY2JfaW5pdF9odygp
IHdoaWNoIGlzIGNhbGxlZCBvbiBvcGVuLg0KDQpTbywgYWZ0ZXIgaGVhZGVyIGFuZCBGQ1MgbGVu
Z3RoDQo+IHN1YnRyYWN0aW9uIHdlIHdpbGwgZ2V0IG5lZ2F0aXZlIG1heF9tdHUgc2l6ZS4gVGhp
cyBpc3N1ZSB3YXMgZGlyZWN0bHkNCj4gYWZmZWN0aW5nIERTQSBkcml2ZXJzIHdpdGggTVRVIHN1
cHBvcnQgKGZvciBleGFtcGxlIEtTWjk0NzcpLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogT2xla3Np
aiBSZW1wZWwgPG8ucmVtcGVsQHBlbmd1dHJvbml4LmRlPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0
L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgfCAyMCArKysrKysrKysrKysrKysrKy0tLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDE3IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gaW5kZXggZDg5MDk4
ZjRlZGU4Li5jN2UxYzlhYzk4MDkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5j
ZS9tYWNiX21haW4uYw0KPiBAQCAtNDkxMywxMCArNDkxMywyNCBAQCBzdGF0aWMgaW50IG1hY2Jf
cHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gDQo+ICAgICAgICAgLyogTVRV
IHJhbmdlOiA2OCAtIDE1MDAgb3IgMTAyNDAgKi8NCj4gICAgICAgICBkZXYtPm1pbl9tdHUgPSBH
RU1fTVRVX01JTl9TSVpFOw0KPiAtICAgICAgIGlmIChicC0+Y2FwcyAmIE1BQ0JfQ0FQU19KVU1C
TykNCj4gLSAgICAgICAgICAgICAgIGRldi0+bWF4X210dSA9IGdlbV9yZWFkbChicCwgSk1MKSAt
IEVUSF9ITEVOIC0gRVRIX0ZDU19MRU47DQo+IC0gICAgICAgZWxzZQ0KPiArICAgICAgIGlmIChi
cC0+Y2FwcyAmIE1BQ0JfQ0FQU19KVU1CTykgew0KPiArICAgICAgICAgICAgICAgdTMyIHZhbDsN
Cj4gKw0KPiArICAgICAgICAgICAgICAgaWYgKGJwLT5qdW1ib19tYXhfbGVuKQ0KPiArICAgICAg
ICAgICAgICAgICAgICAgICB2YWwgPSBicC0+anVtYm9fbWF4X2xlbjsNCj4gKyAgICAgICAgICAg
ICAgIGVsc2UNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgdmFsID0gZ2VtX3JlYWRsKGJwLCBK
TUwpOw0KPiArDQo+ICsgICAgICAgICAgICAgICBpZiAodmFsIDwgRVRIX0RBVEFfTEVOKSB7DQo+
ICsgICAgICAgICAgICAgICAgICAgICAgIGRldl93YXJuKCZwZGV2LT5kZXYsICJTdXNwaWNpb3Vz
IG1heCBNVFUgc2l6ZSAoJXUpLCBvdmVyd3JpdGluZyB0byAldVxuIiwNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgdmFsLCBFVEhfREFUQV9MRU4pOw0KPiArICAgICAgICAgICAg
ICAgICAgICAgICBkZXYtPm1heF9tdHUgPSBFVEhfREFUQV9MRU47DQo+ICsgICAgICAgICAgICAg
ICB9IGVsc2Ugew0KPiArICAgICAgICAgICAgICAgICAgICAgICBkZXYtPm1heF9tdHUgPSB2YWwg
LSBFVEhfSExFTiAtIEVUSF9GQ1NfTEVOOw0KPiArICAgICAgICAgICAgICAgfQ0KPiArICAgICAg
IH0gZWxzZSB7DQoNCk1heWJlLCBzaW1wbHkgd291bGQgYmUgdG8gYWxzbyBjaGVjayBicC0+anVt
Ym9fbWF4X2xlbiBhbmQgaGF2ZSBzb21ldGhpbmcgbGlrZToNCglpZiAoKGJwLT5jYXBzICYgTUFD
Ql9DQVBTX0pVTUJPKSAmJiBicC0+anVtYm9fbWF4X2xlbikNCgkJZGV2LT5tYXhfbXR1ID0gYnAt
Pmp1bWJvX21heF9sZW4gLSBFVEhfSExFTiAtIEVUSF9GQ1NfTEVOOw0KDQppZiB0aGF0IHdvcmtz
IGFzIGl0IGlzIHRoZSBzYW1lIGNvbmRpdGlvbiB1c2VkIHdoZW4gdXBkYXRpbmcgSk1MIGluDQpt
YWNiX2luaXRfaHcoKS4NCg0KVGhhbmsgeW91LA0KQ2xhdWRpdSBCZXpuZWENCg0KPiAgICAgICAg
ICAgICAgICAgZGV2LT5tYXhfbXR1ID0gRVRIX0RBVEFfTEVOOw0KPiArICAgICAgIH0NCj4gDQo+
ICAgICAgICAgaWYgKGJwLT5jYXBzICYgTUFDQl9DQVBTX0JEX1JEX1BSRUZFVENIKSB7DQo+ICAg
ICAgICAgICAgICAgICB2YWwgPSBHRU1fQkZFWFQoUlhCRF9SREJVRkYsIGdlbV9yZWFkbChicCwg
RENGRzEwKSk7DQo+IC0tDQo+IDIuMzAuMg0KPiANCg0K
