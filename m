Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B6A671908
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjARKgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjARKev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:34:51 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E6EC1329;
        Wed, 18 Jan 2023 01:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674034801; x=1705570801;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=otr+PIGzuM8YJPXm4l5jLUvaWnxCW41C14JSeuvHyug=;
  b=r3JodLGaUwQJMJtp3B6l80YIJU2p98Qj0hn2/kvjSQsM0eA6aLn1s37+
   QObVHgKdp6iHX63+ujHDI1Pb29YvRsTtzOKmDcm1a02+LuUC7Y93x4ksh
   3LH1kqTnuaG0hvIiuD3erAjIE8nTv4uWFjNYzxsKNmsXrMre8i8zGq4Hy
   PAxJkuXF4o0/ZP4aLQoUhkrJj5Us97yjBUsEZ5PRU+3lkI6zjMt4IS2NI
   m9bBU8+isw7+yY2wLoWQJA+ZlrhI+AX4aC6NzmaRG28aptUPwBFelPss4
   GX75WyiyDaRvw/oWubrXu4BiJQkTzcSEuH7mShVdb7oTkiV/fWfTiKl7Y
   A==;
X-IronPort-AV: E=Sophos;i="5.97,224,1669100400"; 
   d="scan'208";a="208276251"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2023 02:39:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 02:39:45 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Wed, 18 Jan 2023 02:39:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzWIec1mhRleD0UCeqPJTXyk3e62wfC8rMqY1sqJgvWEM977USW/AwoCXatalJSwAGpHgxBqbZYCpWzon1gKVAc8xdnuqr9QINzN49Q6EFvCAFNSnOzcBtqqL0UGJkuYNlsjhMnHYOQmlP6wB0xXCX6BNxUIJaWiqdvhm2kHEZAgWzuyYbyHl/ABMdQI5IV/p86R4uPwF2L1q4cdd+hWGO5ntenvWY/kR2YrJwLjhI5PIHEKO+G4xdD4l+rKEyPSuAbMuczrF1CNCiJPHerE88PfSOFo2HYDtyHIscpLd+0lA/vGQVFztKfRGZyXo4GN61OETM+DVQwJCv0hz2TU3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=otr+PIGzuM8YJPXm4l5jLUvaWnxCW41C14JSeuvHyug=;
 b=E8dlL8u2eiD/MJi5SZnzQOqhCgQPrbVCENZUN9QGtGxZ4Gb8zJnFrr0PZQmfyzp64Z7SBg//JLtyBj99LeOeQirEQFhPlQpMz3K3S4udvSfCFnUz5bHMemDq5fsjg2R9UegZbTmSjBlosywn3m74OBONwVV1lLdi6mh5omtSbI4H1+zPe74FhP8BHnH/UiQcM0KOaDApwe9THdc9//J7KeR34OvMIWmk5wL7lHT7iE4T5w77sTjuXazP/nL4qPBmLXe2PpUlBYl00s39T/Ls6FnhyyOBmBdiga+pNerbAw+rSDftk5DCdMKsTZbZgsknOqTHftTZ/hkZZFDslw6V6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otr+PIGzuM8YJPXm4l5jLUvaWnxCW41C14JSeuvHyug=;
 b=j/Pc+YpXRAtjtEv4Jv1UVX4d/X8d+EzMy5Cb5U5oImbs8b0Wg4U2y2KKPFxxbq1kW1LKFEq/j+9e7s51SNpLoXKPZ+iCtStEbZj8BHjRgHRqBV8Of9gIxxwCHkSmSF5Xh0J+XXpWlXFrko/bUT9K8kRzbaeKkC/vaUyjEZk/wVE=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by CY8PR11MB7106.namprd11.prod.outlook.com (2603:10b6:930:52::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 09:39:44 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::2177:8dce:88bf:bec5]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::2177:8dce:88bf:bec5%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 09:39:44 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <robert.hancock@calian.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: macb: fix PTP TX timestamp failure due to packet
 padding
Thread-Topic: [PATCH net] net: macb: fix PTP TX timestamp failure due to
 packet padding
Thread-Index: AQHZKyDLP7eDvXlFkkupFIpmR7I2DQ==
Date:   Wed, 18 Jan 2023 09:39:44 +0000
Message-ID: <b3e819eb-208c-e8f9-0027-f6dd36f8d716@microchip.com>
References: <20230116214133.1834364-1-robert.hancock@calian.com>
In-Reply-To: <20230116214133.1834364-1-robert.hancock@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB1953:EE_|CY8PR11MB7106:EE_
x-ms-office365-filtering-correlation-id: 90f65129-58e7-487a-b06b-08daf937ee2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y5cUvOABjPyZV4aj541CLDK4V3tqDmhc/CFs+OYfa0YCRw679xmdjML65o1HM0air82NyHRXEo2O9b5PDN7T6BElAo/DsUQxWJUH4QA+SQcur4qfFDbMvaxhQjitVceyAwc/7Ja5sJe0+G5H8bj64f/SNS35GFd/0kGEfSJmWXiYo+zqT6gyTecsCWOerS3IJj3xa3Jnh6Ri0o/1UqCjIJJAZxrrVvqXcCeevh81f3dhsIDRpyyNiKvg8kxodussZmV+v+0vHD7L/P5Nt9mWbiwZ7D9FgXVDcjsTBoOWzOj5StN6hZvrRCspD3ePLsZ8bkMwBXAcUihiMqqw1F1sikNGBX+aUslQBLo2xTXz2SbnjuW2cqnCJmHVtWUDx81Q/wDu9dlinb4J9R2JarGc+SYnvfQaO39zktdVKWXpOlqw8fyVuY3MgEW1L7XRQrtj15Ea7ZTi6GixPts+YCqE4mqBHY3ZQMDZeeONDXXb1WUFzHvxNeCmnQEecYKAUjMKGiTlJPjzjrIu8erKb9fBB2yoob0aLmmux2whvv2kXG+JE/1mN78lTDFvhj3sycTarBh7oyi0fJQAZ5Q99nsWDuB/xhZe9RUTJiMn/RbD0cjYTUywOFQyvPnqs521scePYiTCUaIXeXVAk1Z77QYT98J6iZ8LltTpfZLbpfZ7FnP3YZ9iea5Ar/N9EOY6kV4/6E7RQ8lI8ot4C2VmsQvVzARGljrgxZSj5sOZnb5qC7VDaxEGsKE7AG6X+r8cA3bPw20jIO2wmTy7/ZKfcszZJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199015)(38100700002)(83380400001)(122000001)(86362001)(2906002)(38070700005)(5660300002)(8676002)(66946007)(66476007)(64756008)(8936002)(76116006)(31696002)(4326008)(66556008)(66446008)(91956017)(41300700001)(2616005)(186003)(26005)(6486002)(53546011)(6512007)(6506007)(110136005)(71200400001)(316002)(54906003)(478600001)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnNudUh4Uk9UTjNMaVlDWEhqVDVpOXc4TVlNVVYxdGNDYW1nWTdtdk1GcEkx?=
 =?utf-8?B?K1JmK3hFbkZyVGNXaTA0U0VzNlZuZHd4eXgwYlN2TW9SbWhVamJMQ2h6QVEv?=
 =?utf-8?B?SGpEbGtKRXdaamdndFc3d0dxOTRSQW1WUlFCR2tyWWg1UzdzVGZqVmE2R3cw?=
 =?utf-8?B?OVluQnpTenhjMkcrN0U0b0psNmNtTGhWSWpCeUVhRWh6ekdSYk1LcEhia0xq?=
 =?utf-8?B?ZUxzdzRhbFJockV1aU5nMlZPNXRjbUxmbjk4T081Y3NrOXNhczErS1M5U3FK?=
 =?utf-8?B?ZG5ENVFJamkwNFVWWlYxK2k5NmNKdWRCNEY2WXZ0V1dEUS8xQXpNcHhjdUJS?=
 =?utf-8?B?UHFZUkxBQlhGMmdWZ3Z3M3RkdlVCcVVaaEQ1SHR3NE16VHpzOHBHMnhuQ0sy?=
 =?utf-8?B?cXBBU1VXc0JvVVVSN0lrdXZmYzF6RHI0aGNWQ1dCS2lQaWE5OFFGZEJ4aGNj?=
 =?utf-8?B?TGswdlhqR0JFNUMrakErd2IwWlBnZ1UvclI0RWE0Qk9wU1ZTcnJ1QVZzdWZC?=
 =?utf-8?B?TnRHQ0xVMVlGSXFBTTA0WmovVTRvQmR3TmM4NkxJSkszSEFoME50N3NxbVNv?=
 =?utf-8?B?aytLMTV2UlZVb3N1dnhZY0NQUEFsbFpnTEpockZkUXFGbGVFMlhoY2Zmb2lR?=
 =?utf-8?B?b1UzVElDSVlISTdmbFUxbDQySTRKZ3czNlp6cml6STAyblUzWXRoS2I1UmxG?=
 =?utf-8?B?THpzalJGTXE1aW05ZkNzbkpvakRXUDhxOXNPNjB3aG5vMVltT2orZ3FLN0Ru?=
 =?utf-8?B?TG1abUgxTVRxTGpVYk9RS09Qa0w3bEVVMURYOUhkY0VKaUgxTjZ5UTZST0Ru?=
 =?utf-8?B?ZDBPL05DQ2hBbStDeUNjSTRMekdHQTJabnBkUENWeisvNUtvb28rbTNza0lw?=
 =?utf-8?B?WjNlYy9PaFhxeGVOeWhONjVuM3RNRjdoYThQc3M4RllqN1JEWTFTSGJPT05s?=
 =?utf-8?B?K3FSd0pMVlEweE04SkNJYzI3bVI3M0V2UExJMkNjSml6SkRtL0YzVUNrYXVh?=
 =?utf-8?B?a3FER05kS3ZmMG5xNXIzUHJoN2JhK1dDeXpPQzhycG9nR040bHV1alJ2MlU2?=
 =?utf-8?B?TURMc0o1Zlh6SEM4dmpRVEVraE9MTUt4NFdCcDR0dk53a2t1RzBGRTB2UW02?=
 =?utf-8?B?TWQ0M2VodURyZUk0YlM3MHRiU0FyUmVYcDNRajFoWkJXaTZicEVsREZBZUVr?=
 =?utf-8?B?YkFRNjNpOGY1eWpZVThFVUZ5TWpQRm4xZ09XNFBIR3VIS3VyR3lYa25ub2wv?=
 =?utf-8?B?dzBUcmhUc2I3djVJaW11dWo2M01oei9sR0UveXgrb3h6MWFLK3BtMWhwdEdE?=
 =?utf-8?B?dGw2VTRNZXhQNFJlVE12enZkbWx4WjlzWjg2WHVTRENpRmoxeXUwbGVhL290?=
 =?utf-8?B?THlyU3JESmVGK01rVXhZNGZuWmxyUHVyWUFsb0h5QVorZEdTdHBmR0h5ZkJK?=
 =?utf-8?B?NmxUVkdlZ1R1bkNNcW9XVEVoM2VqWGczRzV6bW5CbTl1UmJFRUh5eGc2KzRS?=
 =?utf-8?B?ais2ZlFJcnYrZTYySmY5MFV3L21ZV2ZkZFV4TTJIbUUvbFI1S1lPakplQjZv?=
 =?utf-8?B?Y21vaGNZMVRLMFk4VFc3UXJWUkxvakwwaTZUZmhZbUpJNlFQRDRFc0NwYnNU?=
 =?utf-8?B?Rk56WEwzWVd4ZXZtQms1YzZHWDZOWklZUVdCR0RYTGdxMnJlMWFWUmZOa2V1?=
 =?utf-8?B?VkMxVGtBTlF5NllUaFNMSURhRXNHYWo1S2h1c1hqYmY3Rlc2OVNadGp1RXVM?=
 =?utf-8?B?RldDSFdNOGswem03WGhzamRDdWpiUGVrVzduUEdCem8wV2d2TENVOXZZWC9H?=
 =?utf-8?B?VW1vQ3U2V3BWM3o0VUZTTDY3RjlJR1RtNXVoWXQyTGU4TUFKWDRwZzM4ZGpu?=
 =?utf-8?B?YWd6SFNSZWhlMG9pdU5tYkdTVjhoMTc5Q1RQZUFlNi9nNHpBOVRXWlp0Tzcv?=
 =?utf-8?B?ZkJmbjhmMzlJcHRuKzVLR2I5aHZOVnhncm42M0V3ajArYzNEcFRhQjNJclZm?=
 =?utf-8?B?andGaE84Q1ZDREhzbzMwUjh6dUEwRkhOOHJuYUNwOGhlUDA4TUFEcnRtcmJU?=
 =?utf-8?B?UGxhNU4rcWFpckxoVDA2ZXpmVHFRM2dyMWQvMlZ2TllPWkNMSnU3MVlON05p?=
 =?utf-8?B?a0g4Q0ZneDVoeURBSE9OMU1kRFY3VmNoejVwL3VwbzZCaDNsTWt4U3pyTnZ6?=
 =?utf-8?B?Nnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFC5A51058D84F40B18EBEB744784185@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f65129-58e7-487a-b06b-08daf937ee2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 09:39:44.0613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0KQQYbDkGBd+2QJ6xshJmnS6dg8+DoRfC5c7FRpJrUw4tIyvOJsYW6rRaBm0Qj5fOuFNNpPUvQOSckNVYKQ1KVduiyLwxRQaIIQ1bMvFJ98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7106
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTYuMDEuMjAyMyAyMzo0MSwgUm9iZXJ0IEhhbmNvY2sgd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gUFRQIFRYIHRpbWVzdGFtcCBoYW5kbGluZyB3
YXMgb2JzZXJ2ZWQgdG8gYmUgYnJva2VuIHdpdGggdGhpcyBkcml2ZXINCj4gd2hlbiB1c2luZyB0
aGUgcmF3IExheWVyIDIgUFRQIGVuY2Fwc3VsYXRpb24uIHB0cDRsIHdhcyBub3QgcmVjZWl2aW5n
DQo+IHRoZSBleHBlY3RlZCBUWCB0aW1lc3RhbXAgYWZ0ZXIgdHJhbnNtaXR0aW5nIGEgcGFja2V0
LCBjYXVzaW5nIGl0IHRvDQo+IGVudGVyIGEgZmFpbHVyZSBzdGF0ZS4NCj4gDQo+IFRoZSBwcm9i
bGVtIGFwcGVhcnMgdG8gYmUgZHVlIHRvIHRoZSB3YXkgdGhhdCB0aGUgZHJpdmVyIHBhZHMgcGFj
a2V0cw0KPiB3aGljaCBhcmUgc21hbGxlciB0aGFuIHRoZSBFdGhlcm5ldCBtaW5pbXVtIG9mIDYw
IGJ5dGVzLiBJZiBoZWFkcm9vbQ0KPiBzcGFjZSB3YXMgYXZhaWxhYmxlIGluIHRoZSBTS0IsIHRo
aXMgY2F1c2VkIHRoZSBkcml2ZXIgdG8gbW92ZSB0aGUgZGF0YQ0KPiBiYWNrIHRvIHV0aWxpemUg
aXQuIEhvd2V2ZXIsIHRoaXMgYXBwZWFycyB0byBjYXVzZSBvdGhlciBkYXRhIHJlZmVyZW5jZXMN
Cj4gaW4gdGhlIFNLQiB0byBiZWNvbWUgaW5jb25zaXN0ZW50LiBJbiBwYXJ0aWN1bGFyLCB0aGlz
IGNhdXNlZCB0aGUNCj4gcHRwX29uZV9zdGVwX3N5bmMgZnVuY3Rpb24gdG8gbGF0ZXIgKGluIHRo
ZSBUWCBjb21wbGV0aW9uIHBhdGgpIGZhbHNlbHkNCj4gZGV0ZWN0IHRoZSBwYWNrZXQgYXMgYSBv
bmUtc3RlcCBTWU5DIHBhY2tldCwgZXZlbiB3aGVuIGl0IHdhcyBub3QsIHdoaWNoDQo+IGNhdXNl
ZCB0aGUgVFggdGltZXN0YW1wIHRvIG5vdCBiZSBwcm9jZXNzZWQgd2hlbiBpdCBzaG91bGQgYmUu
DQo+IA0KPiBVc2luZyB0aGUgaGVhZHJvb20gZm9yIHRoaXMgcHVycG9zZSBzZWVtcyBsaWtlIGFu
IHVubmVjZXNzYXJ5IGNvbXBsZXhpdHkNCj4gYXMgdGhpcyBpcyBub3QgYSBob3QgcGF0aCBpbiB0
aGUgZHJpdmVyLCBhbmQgaW4gbW9zdCBjYXNlcyBpdCBhcHBlYXJzDQo+IHRoYXQgdGhlcmUgaXMg
c3VmZmljaWVudCB0YWlscm9vbSB0byBub3QgcmVxdWlyZSB1c2luZyB0aGUgaGVhZHJvb20NCj4g
YW55d2F5LiBSZW1vdmUgdGhpcyB1c2FnZSBvZiBoZWFkcm9vbSB0byBwcmV2ZW50IHRoaXMgaW5j
b25zaXN0ZW5jeSBmcm9tDQo+IG9jY3VycmluZyBhbmQgY2F1c2luZyBvdGhlciBwcm9ibGVtcy4N
Cj4gDQo+IEZpeGVzOiA2NTNlOTJhOTE3NWUgKCJuZXQ6IG1hY2I6IGFkZCBzdXBwb3J0IGZvciBw
YWRkaW5nIGFuZCBmY3MgY29tcHV0YXRpb24iKQ0KPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnQgSGFu
Y29jayA8cm9iZXJ0LmhhbmNvY2tAY2FsaWFuLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IENsYXVkaXUg
QmV6bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KDQoNCj4gLS0tDQo+ICBkcml2
ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgOSArLS0tLS0tLS0NCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgOCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBpbmRleCA5NTY2N2I5NzlmYWIu
LjcyZTQyODIwNzEzZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5j
ZS9tYWNiX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2Jf
bWFpbi5jDQo+IEBAIC0yMTg3LDcgKzIxODcsNiBAQCBzdGF0aWMgaW50IG1hY2JfcGFkX2FuZF9m
Y3Moc3RydWN0IHNrX2J1ZmYgKipza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0KPiAgICAg
ICAgIGJvb2wgY2xvbmVkID0gc2tiX2Nsb25lZCgqc2tiKSB8fCBza2JfaGVhZGVyX2Nsb25lZCgq
c2tiKSB8fA0KPiAgICAgICAgICAgICAgICAgICAgICAgc2tiX2lzX25vbmxpbmVhcigqc2tiKTsN
Cj4gICAgICAgICBpbnQgcGFkbGVuID0gRVRIX1pMRU4gLSAoKnNrYiktPmxlbjsNCj4gLSAgICAg
ICBpbnQgaGVhZHJvb20gPSBza2JfaGVhZHJvb20oKnNrYik7DQo+ICAgICAgICAgaW50IHRhaWxy
b29tID0gc2tiX3RhaWxyb29tKCpza2IpOw0KPiAgICAgICAgIHN0cnVjdCBza19idWZmICpuc2ti
Ow0KPiAgICAgICAgIHUzMiBmY3M7DQo+IEBAIC0yMjAxLDkgKzIyMDAsNiBAQCBzdGF0aWMgaW50
IG1hY2JfcGFkX2FuZF9mY3Moc3RydWN0IHNrX2J1ZmYgKipza2IsIHN0cnVjdCBuZXRfZGV2aWNl
ICpuZGV2KQ0KPiAgICAgICAgICAgICAgICAgLyogRkNTIGNvdWxkIGJlIGFwcGVkZWQgdG8gdGFp
bHJvb20uICovDQo+ICAgICAgICAgICAgICAgICBpZiAodGFpbHJvb20gPj0gRVRIX0ZDU19MRU4p
DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gYWRkX2ZjczsNCj4gLSAgICAgICAgICAg
ICAgIC8qIEZDUyBjb3VsZCBiZSBhcHBlZGVkIGJ5IG1vdmluZyBkYXRhIHRvIGhlYWRyb29tLiAq
Lw0KPiAtICAgICAgICAgICAgICAgZWxzZSBpZiAoIWNsb25lZCAmJiBoZWFkcm9vbSArIHRhaWxy
b29tID49IEVUSF9GQ1NfTEVOKQ0KPiAtICAgICAgICAgICAgICAgICAgICAgICBwYWRsZW4gPSAw
Ow0KPiAgICAgICAgICAgICAgICAgLyogTm8gcm9vbSBmb3IgRkNTLCBuZWVkIHRvIHJlYWxsb2Nh
dGUgc2tiLiAqLw0KPiAgICAgICAgICAgICAgICAgZWxzZQ0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICBwYWRsZW4gPSBFVEhfRkNTX0xFTjsNCj4gQEAgLTIyMTIsMTAgKzIyMDgsNyBAQCBzdGF0
aWMgaW50IG1hY2JfcGFkX2FuZF9mY3Moc3RydWN0IHNrX2J1ZmYgKipza2IsIHN0cnVjdCBuZXRf
ZGV2aWNlICpuZGV2KQ0KPiAgICAgICAgICAgICAgICAgcGFkbGVuICs9IEVUSF9GQ1NfTEVOOw0K
PiAgICAgICAgIH0NCj4gDQo+IC0gICAgICAgaWYgKCFjbG9uZWQgJiYgaGVhZHJvb20gKyB0YWls
cm9vbSA+PSBwYWRsZW4pIHsNCj4gLSAgICAgICAgICAgICAgICgqc2tiKS0+ZGF0YSA9IG1lbW1v
dmUoKCpza2IpLT5oZWFkLCAoKnNrYiktPmRhdGEsICgqc2tiKS0+bGVuKTsNCj4gLSAgICAgICAg
ICAgICAgIHNrYl9zZXRfdGFpbF9wb2ludGVyKCpza2IsICgqc2tiKS0+bGVuKTsNCj4gLSAgICAg
ICB9IGVsc2Ugew0KPiArICAgICAgIGlmIChjbG9uZWQgfHwgdGFpbHJvb20gPCBwYWRsZW4pIHsN
Cj4gICAgICAgICAgICAgICAgIG5za2IgPSBza2JfY29weV9leHBhbmQoKnNrYiwgMCwgcGFkbGVu
LCBHRlBfQVRPTUlDKTsNCj4gICAgICAgICAgICAgICAgIGlmICghbnNrYikNCj4gICAgICAgICAg
ICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07DQo+IC0tDQo+IDIuMzkuMA0KPiANCg0K
