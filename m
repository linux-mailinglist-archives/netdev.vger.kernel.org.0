Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD23674D8F
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 08:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjATHBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 02:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjATHBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 02:01:38 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7B311659;
        Thu, 19 Jan 2023 23:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674198093; x=1705734093;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TSs141guRQs1QKHghywFGLu/XSsS7bl4z9o1V160/mQ=;
  b=mocEgFgYAFgs2MLnLT/Pk6XtONHbbXF4wdInM27lV/BtHRtacyTMpGTf
   VkzGPJvDSNLMAhKhzZPQcUWETizBRAcwzdw6VNVFVbX7XBBqgvswDMtYn
   4GkUfP3aIKcGO2N8hUfVuQxkNiLVui4ZedGuu1gf6VYPc2auka81eZWWW
   gACB6+djcQvlM9XwlMTAH6kkQwOrKfDccZO3v21A5Fah0ztBDmtXASuYG
   Fwqx8NldNFT5Um6acvw+13G6Tpjk+RKvwpfX3kbhL3FL9nKXpLms4t35E
   pYbIVhpMfNquW4DxNA0R0/oVzERa83pAeNZ4brQ10Pv8EMSfU3QV23HCQ
   w==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="196655699"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 00:01:32 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 00:01:24 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Fri, 20 Jan 2023 00:01:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThNXRyiCAVVPBNgjmWlg+uyW9jm2Kn320VrlA33QHUBtarBh5JYRxcQvgrs8kldzIL51u2Ybww70XRS5ewiZieGBupCvWBgnD1Jw7n5YECEK9ebcrZ9WzkkhiLIgVYPYzWT1RrKVUEAdVBAzWCgIqEHv9Q0yOhEoyErGWwU9/3QJYdMGugU158qZB+DbdF56gsD0Hv8qkFIDVZgknvoi3uXBJk/MLSlMoljzyQ9Pgbdk7FlpSMAs1X9tSwJagQbatLxu1eV6SvLoKq+/iMuEmZ2764kLbMhHrjDw5y45m/2qjOoinXgTJQfULAm4DeZAfAjjNzZmSQY7kQ0qSaunZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TSs141guRQs1QKHghywFGLu/XSsS7bl4z9o1V160/mQ=;
 b=DTVUwdD2AAmWSiyBSI6cN7To24OLL3xkYnKLBL+GvDQ2xlvLa8WqqvsKmpQ9gUqwwsapREiV8PkN86E1sjLIEVW9t0iSlDxM7mMaA7IpQC7BcxnOIFGe7swWXuj0bXcmUwQ4W4myCRpxnI1fZvNI8YL2/ZiQ0ODhYakM8vqP8w0CghpMXnRVLz5EcD5oNKoOT/8kMVMvZko+WiHPN95okUk5AcfmLQnvVIAATojNypB37Jy/pFJdw8y7RjEvq0S0lqN9AanPommdr0Gzt+vUe1LUJt5FvlXDlORIvuxArleqCBqA2VAsc2u+gykUiLVw55al5dQJhsE4RTsesWZ3AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TSs141guRQs1QKHghywFGLu/XSsS7bl4z9o1V160/mQ=;
 b=MalnqSDNbfZ6gx/U1BDfGImivdCeJIVjp345OU+gnabyOtI7F1b6eOVVxwBwklWlSnyz+XXnUOxhPi7cDhCpH0G30Xc8C4Ng39mgTlS0dPjWpTS/Df1j5UXlY+fsnSX5IRN8hh28zyJfO9wBQKGT0E7XXctfd54kQn1FBBLeJjg=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM4PR11MB5994.namprd11.prod.outlook.com (2603:10b6:8:5d::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24; Fri, 20 Jan 2023 07:01:20 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.5986.018; Fri, 20 Jan 2023
 07:01:20 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <a.fatoum@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@pengutronix.de>, <pabeni@redhat.com>, <ore@pengutronix.de>,
        <edumazet@google.com>
Subject: Re: [PATCH net] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Thread-Topic: [PATCH net] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Thread-Index: AQHZLAhN1bL1NvCdeUO6Em39hgWKCK6m4ewA
Date:   Fri, 20 Jan 2023 07:01:19 +0000
Message-ID: <64af7536214a55f3edb30d5f7ec54184cac1048c.camel@microchip.com>
References: <20230119131014.1228773-1-a.fatoum@pengutronix.de>
In-Reply-To: <20230119131014.1228773-1-a.fatoum@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DM4PR11MB5994:EE_
x-ms-office365-filtering-correlation-id: a514dcdc-f803-4427-b6ab-08dafab4221a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NU2RkBpAxUiZEtfvsTbxBRGe1YGIV8e03DZ2XPV27UISeqnyVBAwBzKUDzpIdtEl+VhZU5T/aaOUoPFwmJvyogQI6gXJWhxc78jHfeBXHVcg2t/A6UJd67JSD9/ARVHWGxqIxzNgEYvsECcbHDN9pDqU5eypFRlRQTwrHlYbd3vxgOEGOe/lCQ9OX/qMWnTg31XzkGkZCxuTjz0hvAsr/ODgy8iQ/9NzjHsfX1gTJhzLe2YmE9yT6JfP+rDbfZyKsMVi3IysXfpLhY2n4U72z5sf3Tf0kBTSEdvGsf3XxsCa3g84XL9crz8Zr2dNIk2Q0VYcWeFKLwxLd8N/7xiUAl4efhHoSFWNj2XeRk7fJveMFWvjNuZZ0y/MHlnzTNagZvo7iMl8sDvYfZiGGvDcVDmYFEVwDuzasLftdHVdcMcz7sa2eOAxyBmaXXCcypItMXEkJ/swy5GwF6g5lHJ6jW6RgZDNUSWqF+dADShp2rvW8CGnW0Lcx1+tRFyrzFnG/AyKdzUKiZ84cfTMMb7GG69SG0LLoxng2PfY9AicddWIzNqL7b5ZYgInhQT5P4Et2glOc41kQafFlKMJGGJqeoYUQN0WSL+1vI5GuCkfe3fxatutnm2Dgv6e6DwmoU6sCt3uS3ZW5aOOzSiLr/zmxqEr+mb6DCRUZQQZev8TwuW6kgDddDBNdsUy4CRRZIO8COS9hW0Ih067DSVUhhDIQ529iR1UIWuOgoH7w5EwCK0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199015)(38100700002)(122000001)(38070700005)(86362001)(36756003)(71200400001)(6506007)(2616005)(478600001)(186003)(6486002)(6512007)(26005)(966005)(8936002)(7416002)(2906002)(5660300002)(41300700001)(64756008)(8676002)(110136005)(76116006)(4326008)(66946007)(66476007)(66446008)(54906003)(66556008)(91956017)(316002)(83380400001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjdZQ2NtWkFpRTI3d2ptZEtabis3WUx0R2h1Rjlza0JwZWlNaEdZVXkzZmI1?=
 =?utf-8?B?VU5kZHlMYjl5RXFiK0xYZk5QT010WG5nY3VNVDhLcldjRzhiUlV4dXRleEt1?=
 =?utf-8?B?TWFuYWQxbzJXaWRMTlZJbHJJNUZhRUNqZnc4dGcyZDMrbUlBcjdKVjlHN0dQ?=
 =?utf-8?B?Z3FvN0hGZVFwR0p6YlZjVWFUR1VQQVFXUFBtOTZCZEhUNG5yY0tudEY5ODUv?=
 =?utf-8?B?WnJCRjZjQ3Y0SGhoeUJyMHZZOEpoTGxIbFhvTnZkZ1k1S2d6Uk90eVhhUTZn?=
 =?utf-8?B?VitET1VXZ2NOWkJvMXpiSk9rbVBpUVdHR0RuOE0yYXkxTzQrUGNuV05LbFBp?=
 =?utf-8?B?eGdFWjhSZzBCVDZKSVVUR1UvY2FIS0hlYmQzMDBDak1za3NuT0JWR0t4MHA0?=
 =?utf-8?B?SnRtcGNWU2svNUtqTlBJQyt3NWtxNHhVWnhhdTZISnNBY0wyUktFYlNtMHJj?=
 =?utf-8?B?Q0R4RmV4RWFvVHJ2eE0vL1d5cWZ5a0VQUmJWcmo5eXRrbXlsRlYzeit1UUxT?=
 =?utf-8?B?NG9MTVhBMStjbnpPTDdFQ0hjUHBjczdhT2dvekJSMlFGVkhvWS9zUThrR2pl?=
 =?utf-8?B?MkVETk1iQUFUcEFWSi9yZm8zS0JJekhiaUdIZzZqMzFVdkV1OWsrN1Bsc2NZ?=
 =?utf-8?B?RndGaEd5T1c3UnNac2IzSlZ4d1BLUVFlcW4zTzZXRktYMTJRbVFEV1ZkZkxI?=
 =?utf-8?B?cFJMRERqTE8vQWZadTd6MXlueG1QRlBuOHNnbmJ4U1dRZDhCUFY5SGFWcUtR?=
 =?utf-8?B?bjd5Um5tU1Rja2ZjK05MWnpVczNNb0hKczdVbXRDWjVXMFkvZFhxMWxXNGNQ?=
 =?utf-8?B?clM4NmlBMGpaOTZtRjRKYWNPUVF1RTRaSytsempNWWdIdUlrMjlSdkl3U1ZF?=
 =?utf-8?B?T0U5NVhBdndScXpGdlZWcWRjVFdQU05GSEsydFVkNXVUbU56Ny96MU5sR01Q?=
 =?utf-8?B?aDNNZjB2Z1JMWTJxeCtFeXpucCtTMGY5bW9saUtIVkFKVksvd2diMVBIcEYw?=
 =?utf-8?B?b044SFBrMDY5eTRCRHB2QnFrQ2hZODJoaThlWUdzbWlCenNLQW1WTTltNG5I?=
 =?utf-8?B?NTViVjY3c2oxbWJOOTI4dnlYdzJQOXZXMCs2cjBYOTVXTit0S29aOU5uTzNC?=
 =?utf-8?B?aUZKRzQvZklyaWdXMmd3UVJ6YmVHZHllMUN1cyt3eG5BOW9DWjNZeXlHQitF?=
 =?utf-8?B?QnI0RXhuOHlqRG83elYxMVp1S2pPaG5nM0J6YVdmMU5pUXRXRTQ4azJ5TXVq?=
 =?utf-8?B?ZzJtaVF0bUNoT0Z4WXdxWnJqazhoV3NRKytkN0VXSnB4ZWpEellKRFptNWUy?=
 =?utf-8?B?SzRBTld2Y0tTQUNmNEdWNjdCMzZLZTF0MnkrK1cxMkEwYW5xNElxWlZFWHVW?=
 =?utf-8?B?R3dXVU1KblVvRHAzejJPOXE1czZKSW8reWM0TGdRTFNUSTZPOFRJcElGbXlX?=
 =?utf-8?B?eHZGRlRuZlVaVExTR3FDU2R2bGVhK2xLeXpQVjB3aVNYUFpZUjBYZnZoRkM2?=
 =?utf-8?B?SzMvTko5TjVJQWp0TUtuU1NzTVhXQUJnRnpiSDhici9RdklzaHozZ1RJUDZ5?=
 =?utf-8?B?a0FHMk1tSnlTUktFQS9wZWNsakFEcFNqWHo5d2tUQ2tJaEROMEVwOFNnR1Vk?=
 =?utf-8?B?MDJhNlhnd3lVU1Q4Y2lzZDNDbXZPN3RCSUlyb0Z3MkI2RldvSzhwUS9IWjUz?=
 =?utf-8?B?dXl5TmlxS3Bua1lGbTZqUWMrOXhoNzUzbEtYMzV1R1dlQ1FhWnRtM2Nvcnpu?=
 =?utf-8?B?TmIzN0lmam8wVHVmU2laSTJKTnJzYWNzTEthZE9tQUNTSTBUMGNuN3dqdGJz?=
 =?utf-8?B?VllseFpCNUY5RVNjNkdJa01BaFQzMFdhV1paTEcrS29yTVREU2N1aTFhVWVY?=
 =?utf-8?B?eXU3VDd2TGpTVXc4cVRmZ1NKdGFUbWpNZEptZUdocjZuLzVhR1ZyRVFleUwy?=
 =?utf-8?B?OXFnWWIvZGd3VkIwWFgvOFVjZFZBZ2lFQmJUQndrUCtSNGpzSUxSN0RseWhu?=
 =?utf-8?B?WUJNem9pUmJ3clBnTnBCRGlGMzhGK0swTjJwZmt2NVJNMnJ3MjVyZzBSeXNB?=
 =?utf-8?B?ZUVnajRLTXY2UGwyZ2J6TFZQbmU5akhWMHBicHJUTkh2SFBoWXZLUXRoMGox?=
 =?utf-8?B?cUp1QkVKYmVxWkx5NFB1Q1VGNHRzM1lscDZJdGxmekplaDE3bDJwTzJLbVBG?=
 =?utf-8?B?YUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F3E44EFBF29574FB3BB199063C42E07@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a514dcdc-f803-4427-b6ab-08dafab4221a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 07:01:19.9111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iFJ6922TxXcYx31CJLzFEt3AZz0Z9NfAUenlZbEmiiN3SeghS7DGFFCUtclcOSVOxWebfJy9oGxP2nj4M/WU4AFkVRCbTZtwS+PdR2Vrx4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5994
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWhtYWQsDQpPbiBUaHUsIDIwMjMtMDEtMTkgYXQgMTQ6MTAgKzAxMDAsIEFobWFkIEZhdG91
bSB3cm90ZToNCj4gW1lvdSBkb24ndCBvZnRlbiBnZXQgZW1haWwgZnJvbSBhLmZhdG91bUBwZW5n
dXRyb25peC5kZS4gTGVhcm4gd2h5DQo+IHRoaXMgaXMgaW1wb3J0YW50IGF0IGh0dHBzOi8vYWth
Lm1zL0xlYXJuQWJvdXRTZW5kZXJJZGVudGlmaWNhdGlvbiBdDQo+IA0KPiBFWFRFUk5BTCBFTUFJ
TDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBr
bm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IFN0YXJ0aW5nIHdpdGggY29tbWl0IGVlZTE2
YjE0NzEyMSAoIm5ldDogZHNhOiBtaWNyb2NoaXA6IHBlcmZvcm0gdGhlDQo+IGNvbXBhdGliaWxp
dHkgY2hlY2sgZm9yIGRldiBwcm9iZWQiKSwgdGhlIEtTWiBzd2l0Y2ggZHJpdmVyIG5vdyBiYWls
cw0KPiBvdXQgaWYgaXQgdGhpbmtzIHRoZSBEVCBjb21wYXRpYmxlIGRvZXNuJ3QgbWF0Y2ggdGhl
IGFjdHVhbCBjaGlwOg0KPiANCj4gICBrc3o5NDc3LXN3aXRjaCAxLTAwNWY6IERldmljZSB0cmVl
IHNwZWNpZmllcyBjaGlwIEtTWjk4OTMgYnV0IGZvdW5kDQo+ICAgS1NaODU2MywgcGxlYXNlIGZp
eCBpdCENCj4gDQo+IFByb2JsZW0gaXMgdGhhdCB0aGUgIm1pY3JvY2hpcCxrc3o4NTYzIiBjb21w
YXRpYmxlIGlzIGFzc29jaWF0ZWQNCj4gd2l0aCBrc3pfc3dpdGNoX2NoaXBzW0tTWjk4OTNdLiBT
YW1lIGlzc3VlIGFsc28gYWZmZWN0ZWQgdGhlIFNQSQ0KPiBkcml2ZXINCj4gZm9yIHRoZSBzYW1l
IHN3aXRjaCBjaGlwIGFuZCB3YXMgZml4ZWQgaW4gY29tbWl0IGI0NDkwODA5NTYxMg0KPiAoIm5l
dDogZHNhOiBtaWNyb2NoaXA6IGFkZCBzZXBhcmF0ZSBzdHJ1Y3Qga3N6X2NoaXBfZGF0YSBmb3Ig
S1NaODU2Mw0KPiBjaGlwIikuDQo+IA0KPiBSZXVzZSBrc3pfc3dpdGNoX2NoaXBzW0tTWjg1NjNd
IGludHJvZHVjZWQgaW4gYWZvcmVtZW50aW9uZWQgY29tbWl0DQo+IHRvIGdldCBJMkMtY29ubmVj
dGVkIEtTWjg1NjMgcHJvYmluZyBhZ2Fpbi4NCj4gDQo+IEZpeGVzOiBlZWUxNmIxNDcxMjEgKCJu
ZXQ6IGRzYTogbWljcm9jaGlwOiBwZXJmb3JtIHRoZSBjb21wYXRpYmlsaXR5DQo+IGNoZWNrIGZv
ciBkZXYgcHJvYmVkIikNCg0KSW4gdGhpcyBjb21taXQsIHRoZXJlIGlzIG5vIEtTWjg1NjMgbWVt
YmVyIGluIHN0cnVjdCBrc3pfc3dpdGNoX2NoaXBzLg0KV2hldGhlciB0aGUgZml4ZXMgc2hvdWxk
IGJlIHRvIHRoaXMgY29tbWl0ICJuZXQ6IGRzYTogbWljcm9jaGlwOiBhZGQNCnNlcGFyYXRlIHN0
cnVjdCBrc3pfY2hpcF9kYXRhIGZvciBLU1o4NTYzIiB3aGVyZSB0aGUgbWVtYmVyIGlzDQppbnRy
b2R1Y2VkLg0KDQo+IGNoaXANCj4gU2lnbmVkLW9mZi1ieTogQWhtYWQgRmF0b3VtIDxhLmZhdG91
bUBwZW5ndXRyb25peC5kZT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tz
ejk0NzdfaTJjLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEg
ZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlw
L2tzejk0NzdfaTJjLmMNCj4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzdfaTJj
LmMNCj4gaW5kZXggYzFhNjMzY2ExZTZkLi5lMzE1ZjY2OWVjMDYgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3N19pMmMuYw0KPiArKysgYi9kcml2ZXJzL25l
dC9kc2EvbWljcm9jaGlwL2tzejk0NzdfaTJjLmMNCj4gQEAgLTEwNCw3ICsxMDQsNyBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IG9mX2RldmljZV9pZCBrc3o5NDc3X2R0X2lkc1tdDQo+ID0gew0KPiAg
ICAgICAgIH0sDQo+ICAgICAgICAgew0KPiAgICAgICAgICAgICAgICAgLmNvbXBhdGlibGUgPSAi
bWljcm9jaGlwLGtzejg1NjMiLA0KPiAtICAgICAgICAgICAgICAgLmRhdGEgPSAma3N6X3N3aXRj
aF9jaGlwc1tLU1o5ODkzXQ0KPiArICAgICAgICAgICAgICAgLmRhdGEgPSAma3N6X3N3aXRjaF9j
aGlwc1tLU1o4NTYzXQ0KPiAgICAgICAgIH0sDQo+ICAgICAgICAgew0KPiAgICAgICAgICAgICAg
ICAgLmNvbXBhdGlibGUgPSAibWljcm9jaGlwLGtzejk1NjciLA0KPiAtLQ0KPiAyLjMwLjINCj4g
DQo=
