Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A558666AC4
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 06:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbjALFXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 00:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235863AbjALFXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 00:23:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCC4D5F;
        Wed, 11 Jan 2023 21:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673500981; x=1705036981;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=KZ58LXcjz+if2CPEtoPmbJUH1SFADUKGyJSBpuIF6/Q=;
  b=MgWCpRcwWH5fdw9no21e+e4ao8g70O6kSYRaG8BGR/Gqw2LgqIo70Gtb
   2RMP9DcRtv7fGmvcTQHG2WyTcyr1DIr1v9HmgqBjXGzJcWP7RdoCOgV2a
   nCuZUkg0K3vSF2aTKEyC/SNIUi03R1EhLTuAgXEKp01IaE0jGsIqL7aCY
   KMv0gs3yAqZFI/d/WvvSTOQiHKtuTgh5Gzr/G3flBGmzDOSCYA6sr46cH
   3aY2rtilaSXPPy0+jJPHsRdZMVc4wn/hkM1y5F5LYj3cXSL9GoVJDPZia
   c2L7jKOKG7kTStfNDZJ4uvO2eYYWUPuyxoyjTPEgXlhlFlMbQ/N6P1/8h
   g==;
X-IronPort-AV: E=Sophos;i="5.96,319,1665471600"; 
   d="scan'208";a="196313439"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jan 2023 22:23:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 22:23:00 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Wed, 11 Jan 2023 22:23:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYmmrVETeymvcBb7FmSjLxWPUbj6Uvm4clnygHJkMtwqSsVXfzXjsEZaqYL/TLgmGvdHfMbhlr/SQZGhCEHIbG/SEe298beiEm/qKH2Turb61oZMIg55pnFRBFB4AQE8drzV7E+P16IF6fuU85fypBKAaKPU1ncrTLGh4OdkMqn59qAJvfJ8owygMTt905W2+swkNUlpwJqauh0jD6U1x8P4zZonhDGfDTQuEirOD3nYbYSWTqb8fj0vc0TbxqCnSQYPaawmztrZ4QZojTdrkQpcfrvL98A37BN25Uc8ykX+pKHNCyztd+WwYdaNas3gURzg8WvmOVdkutQgxpVsVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZ58LXcjz+if2CPEtoPmbJUH1SFADUKGyJSBpuIF6/Q=;
 b=mshdGA+agHB0vpm3xrVPNQFG4EBapZMBc+unrrtwBteSOvfHuGfT7H+OddMJ0UJnTBYv5n7VoHStcHFNlz1XaXgOPXZtp2P4K4JgE3VXJT9ckKYxPRPgAT2sxLRuQky8vu3OXEPjMFre4hXwu1NUVI8gYVyqpP/3SyreXotJHzEP6asmrl5YtDB0s6DJkjsX1qe7JwBXQYOBICTQ311rSgK4olE8541W0vJ6wS8m/0D31GawKWHw2/cxr+q3iNiWbn23RXNPzPIb11vX1kB0doBTBGtbFJoHpdk3t79Z5ncaKJn4LStdi+I3rtph1FovLyq/WyeV/6uGTtkSWopu2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZ58LXcjz+if2CPEtoPmbJUH1SFADUKGyJSBpuIF6/Q=;
 b=QMiEO0drNIV0UmokXBWNFJ4q0emJ0qGK47R/M68kaeJQKabQh64o83PWfXE1U5VcF8jGG3/2oCEv2LDA+d7TO5MY0gu/ZEsTaHvORmrprdf90UrxdSnv2cp2CFKh2RNr9qB3y1SaqoJOYhVHnrCG1dqL7pK0vkvTs9nBXrb5sXA=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 12 Jan
 2023 05:22:58 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 05:22:57 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <Jerry.Ray@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jbe@pengutronix.de>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>
Subject: Re: [PATCH net-next v6 6/6] dsa: lan9303: Migrate to PHYLINK
Thread-Topic: [PATCH net-next v6 6/6] dsa: lan9303: Migrate to PHYLINK
Thread-Index: AQHZJkVFmVKzfxnNXECuO8UktCHt4K6aP1AA
Date:   Thu, 12 Jan 2023 05:22:57 +0000
Message-ID: <39a76c164362f5e03238666e194fc135b19ade12.camel@microchip.com>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
         <20230109211849.32530-7-jerry.ray@microchip.com>
In-Reply-To: <20230109211849.32530-7-jerry.ray@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH0PR11MB7471:EE_
x-ms-office365-filtering-correlation-id: 58ab4c0b-d35e-489d-1b24-08daf45d10d6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6bie9e3OLb6BfVkQtsOenNh5qUoSeeyuUdXQApu/Z6qbowH4wgRYZsXn2/+1cNLXAtfqICeA0V3N0BYikclomsuZf2uTSPt5kMCXpsH4Lfv4zvhqMVQWWUUOonjL4C7bvOOacXwjH9zIj16J5qWUFEuWrN50n2c+ihQcrcZvZySGRBLvxhSVYvpcxY044r9hzDqyEjrrylbcxflz3F0Ty20Cfq/INWpv9qthxByTbeB2FbQMRuU9dzsqhcpOGdqEUfMyrqQpRYaUbwK24gyIQsz7kW/ToMXOhatSECTDJlPGW8a8kSoMpGJ8qKvLjouq4QffWKha1mdxBxARDTliEg+2SaZ4mAmlnsEsQZI0wEhzN5gQlBqV/bdOXVdVll17LOvH9CqzlRuCEoomVXp5pMlOFA9F6dhCR3TN3iJEo4L7EhIKyl8vUBa31b77hWm1bU/pdrqMIu4/OUTR+yv+9t45/zabcsRN/pkeZWLrcmoJHC5Ctvjs5A5Xgwk4Z+ORum21c433/gEdbP5AR4RpwK3lCypBykicaGp7lVEJQSSGg+FdS6PWogvLmCnSkgGLzhBQdn5RVahUytBZSLezJFRy1pIlX6IB5+Vi1JHEO0swNouehxkO0VVPkQrYKDorGaUBUjJm+sdmxI0N4o7AMVEM0z68Uux1XpJdkTfty8kEglY6D7PzdUtbcpDQsPjBGLbqAGooAb/S4vKrnu+QvkbqtGjQeX3LSbdK4G0U+ELM6ccBJNh2ctXu9fKs/BFJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199015)(76116006)(921005)(41300700001)(6486002)(38070700005)(478600001)(38100700002)(186003)(71200400001)(86362001)(110136005)(316002)(2616005)(26005)(91956017)(66556008)(66946007)(8676002)(6506007)(7416002)(5660300002)(8936002)(36756003)(66446008)(64756008)(6512007)(2906002)(66476007)(83380400001)(122000001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDhybmNUSVQwSThVdEMyN0ZJYXpFRnlUSEtHb0NzUUNGOFFaN0ZQb2EvYlVO?=
 =?utf-8?B?RmZRWFpkYjF1NDFXNVA1MGJmeTEwa1JnWUtmVmZPdTFRRkNWekVZRWtHV3ZM?=
 =?utf-8?B?RUJKRldUcGhYY21MT2RvNmdpRXJYb0taUW04ZlIrbEo0M01WZzRsaVJIY2ph?=
 =?utf-8?B?WElzckh4dW1UVGdIQmxUakRJbjU4cno1bDVJQ1dzN05PaHhEZWlYNk1ubnRR?=
 =?utf-8?B?VXZURndKL2Q3TFhNOXVmb0kwbmxNU0U4eWgwQk9ibGpRUURPenJqbUR4d1Vo?=
 =?utf-8?B?ZXdKNFJ6SE0xZmcwWnByTEJhSDNGTDcwU3dkTTZVZW01YkhPVlJSeTROVXh6?=
 =?utf-8?B?azlrMzZ1dDZnNzVRZERlR1NXVmw0M3UwVGk3L3pVeXFFb1h3Yk9scjNyWFBL?=
 =?utf-8?B?bFlqN01HeFlkREV2MERPTklDYW1wTjNRSVV1ZlJIUmJZcDhOeEZCTStTeWkr?=
 =?utf-8?B?TzFGNlYxb1V1cEE5Z0g2cTdBQzRmMEVpQWZsMElaNTFUbUZ2RzM1MzR4MWFK?=
 =?utf-8?B?ZVR5ZDM2L3R4Y2lvbmdZT1pFY0hodlpPYUFJRmdVRTkvbnZMcjNmeDFZQTJH?=
 =?utf-8?B?Z0Q3SHUrOTNhZlJYTS9SNHpHb01EdDNMU2Q5RzRKV090ZUtWZk5yK01IUURo?=
 =?utf-8?B?Wlh6TG1sUWxWbkFlb0FEZXhTSUJzWkRWY1NzTkJvUjVlN2kyNk8vT3A0aEgz?=
 =?utf-8?B?NFdhUFZ1c01rdzJoZjJUYWQ5K0dCVUp1S0NVV0x4RzhMM09JZ3lFT0txKy9i?=
 =?utf-8?B?Y1JZUmpRaXV5VHkzYUx4TTJPSEdDUExZUjB6bHZrdFhqQXlNRWdKVExpbEpP?=
 =?utf-8?B?WThRdmo4OHgyOXp2KzVHN1FIUndremVvNk03YkZ0YTJieVRIcTBDVXU2MUdC?=
 =?utf-8?B?eFpMY3VXMkxnRDdjODdaUTJuSjYwdzcvZDd1TkVOZUg1NGVjQTBiejRiZ09L?=
 =?utf-8?B?UDlyMWY2TGsybjIxYWVrb0dESWdYZ08rMGNiQXh0RStrWFl6dDdKN0tOMEtO?=
 =?utf-8?B?SFExWHYxbFozL3c0TXJveEFvMDE4b1k2YU90dTh3NGZTOVpHMVNIUVh1VGdV?=
 =?utf-8?B?YUlaZlZzRERSL3Fqd1RITWYrSkNJdEJpWUN2U3llMVpUSUlnK3pEMDF2aG1v?=
 =?utf-8?B?VzNhWC9iU0JSVGRKRW9kYmRlck1Ob015U1BoNG5oMEFOdlQ4Z2FSUWtrb0xK?=
 =?utf-8?B?SkhLdVBRRC9ZdW9SMG0vcWlndERrQVFocW5uMlBTa3FFOUxzTEtLakw0a1lI?=
 =?utf-8?B?ZG5SWElRalZyNnNnN2MrZzlmT2tvaXlJcFBXWUxNNFh2cHkrRmx4OVZTR0gy?=
 =?utf-8?B?cFV5RHdkWERzK2prVFp4aFQyeUkwczlNMjg2T096eDhzNWJFcnE0TkxxbW8x?=
 =?utf-8?B?M24xRU0wbUNPbTRnWlhWYTF1dGJEMlloSEtqcE9tUUZSL1dYYzlBcVVoZytu?=
 =?utf-8?B?U1AvbG0xUXlWTVhnS0FOZTJPZW16RHo1bjlOSmxoaEhGekhrT0FDSUFzTisz?=
 =?utf-8?B?eE4wRng5NU5RaDYybEhTdkI0UjFwVFpSemlaaFZsTWdlcmJDa0NqTnd2eUo5?=
 =?utf-8?B?U29ZVmFGMFZxK0VyME5qRHV5NlNXdTJTczJ1dmcySDBUdDJGSEJRWUQ0WGtJ?=
 =?utf-8?B?ZVl4MFZxSFA1YTRnRm8zdmZUeitjTUxBTHFoWmduVXlRc1gxN3Q1dWhSZHdx?=
 =?utf-8?B?b1JWbDdIZFgwWUNJNGFSYWdsNkxYK3NiMHZ5eUMwemQwbVhwSGk5eHZ1SkRS?=
 =?utf-8?B?TEY4cmpWWXhCejFJUHRqaEF2WjB2L1c2M2JpanNUbGpYK1RzL2ZTNFpzN0ZO?=
 =?utf-8?B?dVgxdGtrODFFOUMwMFFWaVRIdGs4eTlTZ0o3Tk1nS2xaMXFWWEQ4K2NMYkc4?=
 =?utf-8?B?aExIMTAzK1ZsckxHazhSbmNaa3owSDRYbW9rTmdsZWRiRWJSYnVsVWM4UkJx?=
 =?utf-8?B?QmZ5Kzl0NlZxanpPUGMzV1JaOGQ5dGQza3BOVHNnZms3VUVXVDY5dmJ5dHRi?=
 =?utf-8?B?YUp1UXZFcXpld3NoZXBjdTQxcG16OVNYVHJkb0FySTJSU3c2OUNadDdUVEpO?=
 =?utf-8?B?K2gxMlowTWJ5NTg0a2oyeHMwRTJpZkJNcTEvaEU0V3VUMnlwQ2RCc1V3V2RH?=
 =?utf-8?B?a3gvZ25yRTZ6dVp3bTZjODlSRHh2cUNpRFA4RzhyVGZsaHRlQWhqSDBZdzZa?=
 =?utf-8?Q?2kUkjw+Qd/XuqQbJ4w8CmHI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C37CF6B8696134685B04DA285E4A132@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58ab4c0b-d35e-489d-1b24-08daf45d10d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2023 05:22:57.7480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B0551NS6Mqn+oHKWlTP4Z6h2LL8w4f6r3i2LL+bbgR1YRVmhlBAvNN5OdY1oIh0N2ccVkjQdKQa2Wg2lFe3DCez31QulBL4bBAXPkY13x1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7471
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmVycnksDQpPbiBNb24sIDIwMjMtMDEtMDkgYXQgMTU6MTggLTA2MDAsIEplcnJ5IFJheSB3
cm90ZToNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbGFuOTMwMy1jb3JlLmMN
Cj4gYi9kcml2ZXJzL25ldC9kc2EvbGFuOTMwMy1jb3JlLmMNCj4gaW5kZXggN2JlNGM0OTFlNWQ5
Li5lNTE0ZmZmODFhZjYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9sYW45MzAzLWNv
cmUuYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbGFuOTMwMy1jb3JlLmMNCj4gQEAgLTEwNTgs
MzcgKzEwNTgsNiBAQCBzdGF0aWMgaW50IGxhbjkzMDNfcGh5X3dyaXRlKHN0cnVjdCBkc2Ffc3dp
dGNoDQo+ICpkcywgaW50IHBoeSwgaW50IHJlZ251bSwNCj4gIAlyZXR1cm4gY2hpcC0+b3BzLT5w
aHlfd3JpdGUoY2hpcCwgcGh5LCByZWdudW0sIHZhbCk7DQo+ICB9DQo+ICAgIA0KPiArc3RhdGlj
IHZvaWQgbGFuOTMwM19waHlsaW5rX2dldF9jYXBzKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50
DQo+IHBvcnQsDQo+ICsJCQkJICAgICBzdHJ1Y3QgcGh5bGlua19jb25maWcgKmNvbmZpZykNCj4g
K3sNCj4gKwlzdHJ1Y3QgbGFuOTMwMyAqY2hpcCA9IGRzLT5wcml2Ow0KPiArDQo+ICsJZGV2X2Ri
ZyhjaGlwLT5kZXYsICIlcyglZCkgZW50ZXJlZC4iLCBfX2Z1bmNfXywgcG9ydCk7DQo+ICsNCj4g
Kwljb25maWctPm1hY19jYXBhYmlsaXRpZXMgPSBNQUNfMTAgfCBNQUNfMTAwIHwgTUFDX0FTWU1f
UEFVU0UgfA0KPiArCQkJCSAgIE1BQ19TWU1fUEFVU0U7DQo+ICsNCj4gKwlpZiAocG9ydCA9PSAw
KSB7DQo+ICsJCV9fc2V0X2JpdChQSFlfSU5URVJGQUNFX01PREVfUk1JSSwNCj4gKwkJCSAgY29u
ZmlnLT5zdXBwb3J0ZWRfaW50ZXJmYWNlcyk7DQo+ICsJCV9fc2V0X2JpdChQSFlfSU5URVJGQUNF
X01PREVfTUlJLA0KPiArCQkJICBjb25maWctPnN1cHBvcnRlZF9pbnRlcmZhY2VzKTsNCj4gKwl9
IGVsc2Ugew0KPiArCQlfX3NldF9iaXQoUEhZX0lOVEVSRkFDRV9NT0RFX0lOVEVSTkFMLA0KPiAr
CQkJICBjb25maWctPnN1cHBvcnRlZF9pbnRlcmZhY2VzKTsNCj4gKwkJLyogQ29tcGF0aWJpbGl0
eSBmb3IgcGh5bGliJ3MgZGVmYXVsdCBpbnRlcmZhY2UgdHlwZQ0KPiB3aGVuIHRoZQ0KPiArCQkg
KiBwaHktbW9kZSBwcm9wZXJ0eSBpcyBhYnNlbnQNCj4gKwkJICovDQo+ICsJCV9fc2V0X2JpdChQ
SFlfSU5URVJGQUNFX01PREVfR01JSSwNCj4gKwkJCSAgY29uZmlnLT5zdXBwb3J0ZWRfaW50ZXJm
YWNlcyk7DQo+ICsJfQ0KPiArDQo+ICsJLyogVGhpcyBkcml2ZXIgZG9lcyBub3QgbWFrZSB1c2Ug
b2YgdGhlIHNwZWVkLCBkdXBsZXgsIHBhdXNlIG9yDQo+IHRoZQ0KPiArCSAqIGFkdmVydGlzZW1l
bnQgaW4gaXRzIG1hY19jb25maWcsIHNvIGl0IGlzIHNhZmUgdG8gbWFyayB0aGlzDQo+IGRyaXZl
cg0KPiArCSAqIGFzIG5vbi1sZWdhY3kuDQo+ICsJICovDQo+ICsJY29uZmlnLT5sZWdhY3lfcHJl
X21hcmNoMjAyMCA9IGZhbHNlOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgdm9pZCBsYW45MzAzX3Bo
eWxpbmtfbWFjX2xpbmtfdXAoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQNCj4gcG9ydCwNCj4g
KwkJCQkJdW5zaWduZWQgaW50IG1vZGUsDQo+ICsJCQkJCXBoeV9pbnRlcmZhY2VfdCBpbnRlcmZh
Y2UsDQo+ICsJCQkJCXN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYsIGludA0KPiBzcGVlZCwNCj4g
KwkJCQkJaW50IGR1cGxleCwgYm9vbCB0eF9wYXVzZSwNCj4gKwkJCQkJYm9vbCByeF9wYXVzZSkN
Cj4gK3sNCj4gKwl1MzIgY3RsOw0KPiArDQo+ICsJLyogT24gdGhpcyBkZXZpY2UsIHdlIGFyZSBv
bmx5IGludGVyZXN0ZWQgaW4gZG9pbmcgc29tZXRoaW5nDQo+IGhlcmUgaWYNCj4gKwkgKiB0aGlz
IGlzIHRoZSB4TUlJIHBvcnQuIEFsbCBvdGhlciBwb3J0cyBhcmUgMTAvMTAwIHBoeXMgdXNpbmcN
Cj4gTURJTw0KPiArCSAqIHRvIGNvbnRyb2wgdGhlcmUgbGluayBzZXR0aW5ncy4NCj4gKwkgKi8N
Cj4gKwlpZiAocG9ydCAhPSAwKQ0KPiArCQlyZXR1cm47DQo+ICsNCj4gKwljdGwgPSBsYW45MzAz
X3BoeV9yZWFkKGRzLCBwb3J0LCBNSUlfQk1DUik7DQo+ICsNCj4gKwljdGwgJj0gfkJNQ1JfQU5F
TkFCTEU7DQo+ICsNCj4gKwlpZiAoc3BlZWQgPT0gU1BFRURfMTAwKQ0KPiArCQljdGwgfD0gQk1D
Ul9TUEVFRDEwMDsNCj4gKwllbHNlIGlmIChzcGVlZCA9PSBTUEVFRF8xMCkNCj4gKwkJY3RsICY9
IH5CTUNSX1NQRUVEMTAwOw0KPiArCWVsc2UNCj4gKwkJZGV2X2Vycihkcy0+ZGV2LCAidW5zdXBw
b3J0ZWQgc3BlZWQ6ICVkXG4iLCBzcGVlZCk7DQoNCkkgdGhpbmssIFdlIHdpbGwgbm90IHJlYWNo
IGluIHRoZSBlcnJvciBwYXJ0LCBzaW5jZSBpbiB0aGUNCnBoeWxpbmtfZ2V0X2NhcHMgd2Ugc3Bl
Y2lmaWVkIG9ubHkgMTAgYW5kIDEwMCBNYnBzIHNwZWVkLiBQaHlsaW5rIGxheWVyDQp3aWxsIHZh
bGlkYXRlIGFuZCBpZiB0aGUgdmFsdWUgaXMgYmV5b25kIHRoZSBzcGVlZCBzdXBwb3J0ZWQsIGl0
IHdpbGwgDQpyZXR1cm4gYmFjay4NCg0KPiArDQo+ICsJaWYgKGR1cGxleCA9PSBEVVBMRVhfRlVM
TCkNCj4gKwkJY3RsIHw9IEJNQ1JfRlVMTERQTFg7DQo+ICsJZWxzZQ0KPiArCQljdGwgJj0gfkJN
Q1JfRlVMTERQTFg7DQo+ICsNCj4gKwlsYW45MzAzX3BoeV93cml0ZShkcywgcG9ydCwgTUlJX0JN
Q1IsIGN0bCk7DQo+ICt9DQo+ICsNCj4gDQo=
