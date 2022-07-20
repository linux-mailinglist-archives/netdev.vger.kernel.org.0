Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6522257B5A3
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbiGTLgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiGTLgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:36:54 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE36123BF0;
        Wed, 20 Jul 2022 04:36:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxyOzgVr9lcdJA22NJzsYJ+W0wU/NyDiN9Y1U4zNdO8YA8pFZF69CnBtinNb3cznPwYyqLReIoazeJWn7t8UAnG7tKHaPYQkv9h+aBSb81MfX+/L/571xAbvza9t/1gRv9exQoY+HhuIzYnxow1OIs8bn8BMDHEGG2ejWsDeKo7vyFAq/nVHPWiCxcxOCgRz1av5S+v3dqEc8H4P8Q7/em1aW5r/KGwrm41wnjYX1BO1xyuxa+QqL6/znzPmOjvEXdrULq4JBN59aOLEZxjiVcVPSKMo06PJaCDKJI1QUdh019BdOouaBdzHL9t/wQkF2QVMljNJr9pHa9S3F+GfJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wpjVdPD8TBSqCfqep8zi8vI7uevI0ivgvbn1QfCh/EI=;
 b=FK6ox/SUzcWBzFssuDOWiWCaTXEiE29xcXoi9XhKWmQ3ODN7uhkd9xSgqtYPuj6GiyrRM70T5NAgUeIsZtAVohlPHYPe1IUf5ULUPK1B8HDlC85iXcd82u0brV/JcZ/89sDxCj383sz+P5sgo7CDJ+87aP7IR01VGRUB9GjSSsW6b44J+0sMrHnIyucGhVigehGIsG4OCdKPYplC82gVBFzFK+gd8MG1a/LVZppmuWdKfUAu9hxThV1cfE4QKYdHs/H8rFFEsJBPixVZpGaNp6zxi1UgNaSdvrp6/B4TrnqATszixpIepvaPoTNdZKvkOZPU6K9+rw1iFeDnIv5DbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpjVdPD8TBSqCfqep8zi8vI7uevI0ivgvbn1QfCh/EI=;
 b=lyDVeio75Woa3rNFFX7nXZ/T68Fqz7dlqxxno8+oYTntBp3mlucYbowCcbO13lxwDIg1lG5Vh59PaZFZrKi56Xaussapl3u7dQ9Yr1az/DHipujUAQXKUvn2krYENjj2YDVtSwXVNK3mSBf0P2hNBH4gV9VEjC+iw1V1RGQM5Zk=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by MN2PR12MB3886.namprd12.prod.outlook.com (2603:10b6:208:16a::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Wed, 20 Jul
 2022 11:36:50 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::84ee:58ac:88c4:3b7b]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::84ee:58ac:88c4:3b7b%7]) with mapi id 15.20.5438.025; Wed, 20 Jul 2022
 11:36:49 +0000
From:   "Katakam, Harini" <harini.katakam@amd.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Harini Katakam <harini.katakam@xilinx.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
Subject: RE: [PATCH 1/2] dt-bindings: net: cdns,macb: Add versal compatible
 string
Thread-Topic: [PATCH 1/2] dt-bindings: net: cdns,macb: Add versal compatible
 string
Thread-Index: AQHYnCwBdyQpTUiRGEGURkZaCeNDoq2HIFMAgAAAQSA=
Date:   Wed, 20 Jul 2022 11:36:49 +0000
Message-ID: <BYAPR12MB477363E846E5EB15D7AA2ABF9E8E9@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20220720112924.1096-1-harini.katakam@xilinx.com>
 <20220720112924.1096-2-harini.katakam@xilinx.com>
 <d836f94c-4e87-31f6-5c3a-341e802a23a6@linaro.org>
In-Reply-To: <d836f94c-4e87-31f6-5c3a-341e802a23a6@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 047fca03-390c-4047-3c3e-08da6a4422b2
x-ms-traffictypediagnostic: MN2PR12MB3886:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XfTMaLMyxUaIQX+iI0HRAal+dTEp0VdGD5UObyc84XyWQLAKVIdhgf+oFhXaYvh276xPV5odquUNHtfEoNJ/WopJ1Gexiq//F4HQKJnvkKEzxUgHAeLuspSjdky0kXko5mo93fNh2VCKdvFVq/8AVQL8BWBpqi3ptnVVEjHrZkj4gRJ2qF3qYPMCnkj1h3pZh69nH0iaa7WM/BEOA6NHfvqlKmxAm/1w9ti8QeWv8skCA3seLOmtAFHX3XMXcCMhQ6kTcQ/4/9QeLcmnok24tKIG8Ka0PTbvZNZ3JRq+vad0lnJq6JGpQC2sD1HOHygiiU01avZfRjG73yXrhoxnyGIUX46Q2mXWhAJimdH9L2/Bh0RtJzXyguZNicAiznckr6SbXXTb/SYwQG6bNGycVAa6+vaayxNW1lUj1+Q9V2+A3QkurD7PoDwka9YflbBp6Cy8hKcTyYfGJYvDOSsfemg3ZKEAd5HmGbL5pPi3AzpDD22lzfASXF9juLNeJQia+wj7anjFrJjxSPEpXK6QkvICW1djik1sIAzpRNynuCfw7jbSLyvHoVyE6zdIE+ShI7HMgaj7oc2xcE+23tn9xcLSNsCl66YaxlY+HjgDtK85n0nqkMZm/Ia6R5eBEQ2Rin5c3PSOoaiCX4ckbjyPuISzuHn0UrZTr+PxEci+UCupDV34U4+ez5KSN6XGYPI5c7QksTNMMfGXbnIl7mkmzSIKrmFk+JVIFhkZ2SXuHUN3BzIglOmsgtbIyLR4HoFmSS5da9M4z12WB+3/ny9PaE3z7rykBDZ0l4l3mKiugiselAtJ3MSRSPgIwVCbiItVftw+xy0zGlkin/gSN88Iew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(33656002)(8936002)(52536014)(66446008)(86362001)(76116006)(5660300002)(66946007)(26005)(64756008)(8676002)(4326008)(6506007)(921005)(54906003)(66556008)(55016003)(38100700002)(110136005)(66476007)(316002)(38070700005)(7696005)(83380400001)(41300700001)(186003)(107886003)(9686003)(7416002)(122000001)(478600001)(71200400001)(2906002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rm54UERiUjRSS2lCN1ZsbmMrbktmVlBucG5PUjk0SFF2OTJRUDJzWkZwZmtH?=
 =?utf-8?B?c0JhVGhlMXZOT3F4K2Z0NGxoMm05N09Jdll6M3B1SjVSUXFJcW5tUnFVcXFw?=
 =?utf-8?B?SDhUYUt3bFBNQ0VwTVJoQU1OQXplVW5sQkZWMmhyNXcwVFJzUHkzUG5UWXVK?=
 =?utf-8?B?RzZCRVREM0FhcXZ4Rit1dDM2SWwxSEllVnMwU2NkcmZ3N0JZY2NTYlB5VlhD?=
 =?utf-8?B?c0VNdVVZV00yZmM2bElZKzFNZ2VjME9jQzdmczBCSTBNL25iMHN5cm9Sakpu?=
 =?utf-8?B?VjJyTHNSaDNEeUZ3V3RnRnNUMkJvclRVaEJXN2t2MnVabG1WeWU2WVdHN0tu?=
 =?utf-8?B?Ukw3UkVxNWhBcXR1MUhBTXZ5V2QrSkpyZDRTelppWFVIaVl6TE5EZFMxZDFI?=
 =?utf-8?B?NjZuMEV4RkZKM3UzZVMrVjYwaUdGc3ZUOHpBQkdLdDhxaTROQnZPZllhTHh1?=
 =?utf-8?B?UlgyQlJNUlZvRjZoYmt6UDF4U2J6ZmY1SE82ZWdQL3FPN2IyYUYzUGNFSkM1?=
 =?utf-8?B?RldSNWlOb3ZpSlh0WGl2ajh0Qlc4SGVXSVBncmxGTlduYnFScThhOUhtakM2?=
 =?utf-8?B?Ymt4eFhVQlA4ZDhFVzJwUUUwUGpVbmx1bDdickZaS3RFQmtkZWtVQ3BydmJI?=
 =?utf-8?B?Ny9sUVV4ZGp1R08xMnNiY1NwalVDd0QwemdKUitwODZnSGN4ejloRnBoZnlK?=
 =?utf-8?B?TzM4dE15QjcvQkJlUlJTaTBwcU5OZGRSdzFTK0FaVGV4c3pDQVJ1cVYrbCtt?=
 =?utf-8?B?WnI0VkFwTEo0Q3NPSzFlbmZlUmJFR3Y5alJiVDZqQmI1R0pCQUllVFkxejZG?=
 =?utf-8?B?SHNtQmpyaVMraXV5c1Fuak8vYlhEc0p3ZWdrMDd5ZWF1b0dZRnoxMFNEZWMy?=
 =?utf-8?B?Y1hsYVVJbTZPMHFrRFo1WTZFaFFDZEhXcUhodEI4c0gwZS9yQlRvS01Ga0l1?=
 =?utf-8?B?NDNoZ0pveU1vbVBoU080U2l2Z1FWNU90VTdDKzBRcXR1VjZoWHU4MW5EQlBa?=
 =?utf-8?B?WTRPWC84elAyUzZEeHBYTHB2aUNEQ0oxOG9TZGZTeXFsbzNtc2NBYUNtckZP?=
 =?utf-8?B?Skc4aGUvQ1owTXpaU3N5bVVTcFJMdzUrUEc1bzlKWjhxaEprNHBUSnZ2T1M2?=
 =?utf-8?B?Y21OcllOQm55Zk5RQ2cwUzV4bnFldlF6WmM0VnN1V0hQRWwxbTBMU1ZhcEhE?=
 =?utf-8?B?L3c1dFNiblIxN0lLRlNUSjlBRXBoSkExZzhEMG8ydjFBNDF1RHJFS3RyN0tm?=
 =?utf-8?B?Tm52NzlnTFlGSk93MHd6WXd3cG1VdlNyVnI0NzhIWENQV1B2aWtnNUlnVFkx?=
 =?utf-8?B?aXV5Y0k3NWYzYjFseWh6RkgydmhJYlRnWjNucE1vSGdqMWJYVlJZTElWVG0y?=
 =?utf-8?B?WUNKcTdJYXNFNUdUaVhvN1BOVmQvbENkakdETHJjYTJHcFMrVFI0dVRsaWd0?=
 =?utf-8?B?NXhMODREWXFmbndYZnV3ZmlsZ1dkUERwSVVQb0RWL0lVbkEyVmJMK0ZnWlg4?=
 =?utf-8?B?RDhGcCtqRjA4ZXg1Z3V6VHdHQ1dQZVR0dGh3L1U2VlZGZWw2RE9abzhyZ1VE?=
 =?utf-8?B?WWZ1dTVuTjBhWkRaTTVVZHpiUWlIMGN5VzVvQTZiR3dBdm56WktFUlphRTdQ?=
 =?utf-8?B?eG9BV0ZmVUlBVFNib3RGTE94eTNoWlZiT0ZJY3dDa2NyMllmaVE1WWhMbjdi?=
 =?utf-8?B?NU1pZndpYUU4b1NxZ1FSQ0lyeml5VXJBQ3Jidzd0ZGpnSjdUOTR1YnRrUGwx?=
 =?utf-8?B?c1h0cTUrTnpRQzVNSWRUUVBjSHlhKzhQamo1TjRneGs2RS96YTJDMko1aFNi?=
 =?utf-8?B?bGJBTnFOMXNKNmE3bWE4VUdqcFdhZDRDRkNiUkk4V09IRXdrSHR0WnR2TnBC?=
 =?utf-8?B?Q0JJMjE2eFFKRlk3ZXZPelZpamFxT2lZT0xPYlkwMGc4cVNLWUpVZ3lqcnkv?=
 =?utf-8?B?VW1NRnRycmsyb1pyMUd4eE5OSXc1RGN2YUczbmNUcFIxVkJzbDhxL1NvcmtP?=
 =?utf-8?B?M0ZRamVhdjREeUxGdkFQY201TTFTbXZZcnZYTXAxcU1yajNISlZSVEJva29k?=
 =?utf-8?B?LzB2b3d2WWtrMTFTU0VWZjJsWmJ2Q1JhdGFLMjVCOGM1SlpuT3dxU2ZoNDV5?=
 =?utf-8?Q?85rM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 047fca03-390c-4047-3c3e-08da6a4422b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2022 11:36:49.8304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0pNXrCyhPdA7kvjNCgxxLLOGH9ggvfjVZn5WFpBuJuGniIDwpggAjLjQ6F2BdNE9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3886
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS3J6eXN6dG9mLA0KDQo8c25pcD4NCj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9k
ZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jZG5zLG1hY2IueWFtbA0KPiBiL0RvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvY2RucyxtYWNiLnlhbWwNCj4gPiBpbmRleCA5YzkyMTU2
ODY5YjIuLjFlOWY0OWJiODI0OSAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvbmV0L2NkbnMsbWFjYi55YW1sDQo+ID4gKysrIGIvRG9jdW1lbnRhdGlv
bi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jZG5zLG1hY2IueWFtbA0KPiA+IEBAIC0yMiw2ICsy
Miw3IEBAIHByb3BlcnRpZXM6DQo+ID4gICAgICAgICAgICAtIGVudW06DQo+ID4gICAgICAgICAg
ICAgICAgLSBjZG5zLHp5bnEtZ2VtICAgICAgICAgIyBYaWxpbnggWnlucS03eHh4IFNvQw0KPiA+
ICAgICAgICAgICAgICAgIC0gY2Rucyx6eW5xbXAtZ2VtICAgICAgICMgWGlsaW54IFp5bnEgVWx0
cmFzY2FsZSsgTVBTb0MNCj4gPiArICAgICAgICAgICAgICAtIGNkbnMsdmVyc2FsLWdlbSAgICAg
ICAjIFhpbGlueCBWZXJzYWwNCj4gDQo+IE5vdCByZWFsbHkgb3JkZXJlZCBieSBuYW1lLiBXaHkg
YWRkaW5nIHRvIHRoZSBlbmQ/DQoNClRoYW5rcyBmb3IgdGhlIHJldmlldy4gSXQgaXMganVzdCBi
YXNlZCBvbiB0aGUgb3JkZXIgaW4gd2hpY2ggZGV2aWNlDQpmYW1pbGllcyBmcm9tIFhpbGlueCB3
ZXJlIHJlbGVhc2VkLiBJIGNhbiBhbHBoYWJldGl6ZSBpZiB0aGF0J3MgcHJlZmVycmVkLg0KDQpS
ZWdhcmRzLA0KSGFyaW5pDQo=
