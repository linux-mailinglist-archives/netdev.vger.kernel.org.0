Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BC36CBFDC
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbjC1Mxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbjC1Mx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:53:26 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20615.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::615])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94760BB95;
        Tue, 28 Mar 2023 05:52:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wrd8rVECMjQoNkfsRlAbQDj03Yp3lnOQUpr9PrwQheCuC1royiPJOOougz/8Htr5Zd1dQv86uSaVKX9xZ2S1laGiztCvVNTKMQOWgV4cFacCVMGxSWVbXYAXrQbWjIBiTqc4QUdRcxnNEa+TMox+1zRlqkhY+XzxbMfybsCJ5iPBgn+OOW+2b0uGz9VI31+8fFExQd7vEbM/jROVY+2UECEIRu6/ViZsxW4DGNE4iqePxBvZYgWYqlGH48h6FyLQzZXkCvC2Sffx+FIn1l4ufCeyUYt1s0eQJdlnufRmsiRcFGl7TCT38J3FGcneOnGUEm5MzsFeGzyR+vaoRrX2cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODbF6+VxrLnJHkvh9P72n4yvXg90D4xKGu2qjx4U0wk=;
 b=kCCx7c6xb0XAlk1EKem7axlUjL5ub+/wySplLAbDYO98hq7eMGXRJFuxmIUbMpjx8y/cnoHHer2GDuixXwWbxqIRZ71O6xGJ32Ld1OUZwogKbtWKyohYGQj4J6Y09RR5Y7FBV8NFNh0BDlSLbHtO1m9Q2iJoi1EZ/fqc5Ktry+VSZDD5gQUB7ziAA/KTss6hBl0OXlqFv3YjmU8M6XLoWhUDR+X2gxr7yzPxO7zrMZlNUCh4rm1+VomQRpi+PYYu32pp8n9N6tCYtxhcVv+j/xv0ujPX4+p+20qtLKwQSD6c1EKth9bJFZGZDB/xi9hzqqwLMjE2NoVTCDn0cs5frQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODbF6+VxrLnJHkvh9P72n4yvXg90D4xKGu2qjx4U0wk=;
 b=r62WV+QOx8eo/mwWaAAr4oOaspbWE8c/tqgXbK6LrMOznDY3b4wAIV4Tkyu6h1KWk+1wTl7EsI3MUzY4+fHzYvgugY4Iw5vJISbx+nDErdJbbl/7KJePJ/kfRAlTHKBGJ1XXKpLI1syBBqucaXSEc6dqX4pRahsAhNBSJMUdBdE=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by BY5PR12MB4082.namprd12.prod.outlook.com (2603:10b6:a03:212::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Tue, 28 Mar
 2023 12:52:15 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::9d4f:fc5e:1bae:3654]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::9d4f:fc5e:1bae:3654%7]) with mapi id 15.20.6178.041; Tue, 28 Mar 2023
 12:52:15 +0000
From:   "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>
CC:     "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Thread-Topic: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Thread-Index: AQHZUYT4JLsiahlKOkOq6wiaqDsKBK76dskAgBXCyhA=
Date:   Tue, 28 Mar 2023 12:52:15 +0000
Message-ID: <MW5PR12MB559880B0E220BDBD64E06D2487889@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20230308061223.1358637-1-sarath.babu.naidu.gaddam@amd.com>
 <5d074e6b-7fe1-ab7f-8690-cfb1bead6927@linaro.org>
In-Reply-To: <5d074e6b-7fe1-ab7f-8690-cfb1bead6927@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|BY5PR12MB4082:EE_
x-ms-office365-filtering-correlation-id: ab5f77fe-8645-4c63-8b0c-08db2f8b41ce
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qJSRzVSQsI7lwYmyqZLsb9pj30XCGWI6Dw3Cys4/xreuNBym6J2Ksf/wvKeLKjxIC6ZTrNufmnO58gVPRehNknZQ6hyGqWuy2sbcY5hB9APw9HyR9AISkdh8oz8WpXhAktLIQbNMVDmDa1MvcGBKSCiqLwUbiA21DC3LhzCagsWpZyZXgFSANWC6/SLOC80oUDrX3wGlj6rjEpStB/eNiuMPtKht4YT1hnnfbu5ts5bLmSYybvGvq2+0GYdaTW2gPNBmNml6F85SnOSFaakCp/ALoyJ8trulPeUsBGe1bP5MRjJNaszVdGKzw3Df7UWLGEVYp0tHmY52eGw7+PMllJF7hank2XVz+eWQl8hBCcfzvVf98pB8d0vsltUFAQrJ/Ao1B+j4My91l1u/d3DHM1oof5Wc7tYb1iaO4yqq8H2fbr0gAkYf3sYw/fRsAmwnoZ7ygtweP9me9cPdgEbGYf9EbSua6lrci5V/gkTwL4IfxA1Vx0PvIXOUhR04XQtvZine6yQ/sRtxN2XGgSM0HkP+R5/0XLU07tovOjcyO1ry+oeDzjVvZBe1uaifVYyKpnKGgwJaJh8hsjnRbGdboiJTEF+BrxxqcHxb2YQysmeP9yc8JQhQacoqDXHeOinX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(451199021)(9686003)(53546011)(26005)(6506007)(41300700001)(55016003)(186003)(64756008)(7696005)(71200400001)(83380400001)(478600001)(54906003)(316002)(110136005)(38100700002)(4326008)(66476007)(66446008)(76116006)(7416002)(66946007)(66556008)(8676002)(33656002)(2906002)(52536014)(86362001)(38070700005)(5660300002)(122000001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjBSWGUzVDMvenF4ZUErQ083MFR0Rm4wdDZkZnduZC9TSzdHZWNuQnphbzNv?=
 =?utf-8?B?djk0Y3RLSHlVTFZQOFBHV0llSkVKNUcxRGY5dzN4OU51cE9ySXpGbEtnNGlT?=
 =?utf-8?B?azFrMEdTMVJOaGcwM2JNNE1laEQ4WGs0Qkdnek8wT2VoeUdib2UxaEpkZHpB?=
 =?utf-8?B?eUpNbkJ6WDVNNTMwc2VCUXFsZCtzaE9DY3N5R1BOZ0VHeGV6U1UzV1RLL2lt?=
 =?utf-8?B?Yi9ubGJDTEk4OG4za1V1aWRvV2RFcWJkTW5ZalN1RlN3QWtyUTBGTE40TTht?=
 =?utf-8?B?QzIxTldBYzBGcFVwQUFwSlJITGs3QkRFcy9sb0d2Y1BhYkJabnp4a3l3c1JF?=
 =?utf-8?B?UFBnWDlkR0Y4TW9yVWVieWZSOGpDNmhhbUdBVmhNOGZzd1IzMDEwbDY4SVFj?=
 =?utf-8?B?VHlTZmpYTHdYSXUzZ2NPYzZUcXlwTmZ4RjRnMk5pd1dWOGhjZGlkdndtVXV3?=
 =?utf-8?B?VzBqTmlldEpKeXJhb2FMT3ZDMG9OblZUdVZSY3JPVHN6d21EZXVnK1JSd0Ew?=
 =?utf-8?B?b2kzbXZXZ29rQ1VsWC9KRGwwY1JuRWU5L0pSOVR5M1BNTXZGRXZHQXIzZGF4?=
 =?utf-8?B?V3N3VWx1WHZIMURuY3NEcTNSSldNQTVtZEZ5a1B1M3A3MUlKQkxiTjlYRmlX?=
 =?utf-8?B?RVRCQW9jVGZTNEpWTUg0aTIrQzdsNUwzOFJ2VVdUVmVRaFVQVGJiTkc2cTF1?=
 =?utf-8?B?OWFtVFo5VzVmT25ZNGdvVVhmWm4yWFFVdU1ISFNibnRyT0tSQXlUQUxaT0ZR?=
 =?utf-8?B?cWFPVURVLzhLdjM4ZXN1dmwybUJSUzh5eUg3dXJERmpYWXNxZCtwaXd6SlJR?=
 =?utf-8?B?MDBiMUwzRzNqeUNkVTJEL1JodXpTb0thaTNLVmZRb1RuQ3BwdTFaNnJXSDQw?=
 =?utf-8?B?OW5xa0tITEhNQ1ZjSURzRlJKV1U3SEl1eEtmN28rR2VKald6NlBUaGVuWUlx?=
 =?utf-8?B?ajVhTUloVEZsSkpwdE9mUEErbGp3bzFUalJaaXhZb0JKTDcxTHloS2ZIeEdm?=
 =?utf-8?B?dS9oaWIxZC93RWpTdXZ3M2lnYzVNV3haZDFJYXZmV3o0bHJFRGtOUUdoOElz?=
 =?utf-8?B?d2U2ai9mN1FsL085ME41Z0lvL2ZlbmppNVM1dmN4T1VGbU55bzh3UEFvWjJv?=
 =?utf-8?B?dkNRS1NhZUxXQWlsam5SRUF6TmJ5cjc4YkZCaHc1MlptMmZkUUlUUkQrNEFt?=
 =?utf-8?B?bmNzRTlxUHd3M1ZrWk5YNTRwdk5lMGVEZ2hYdllzV3lkcE5TR0RwenRCMEFD?=
 =?utf-8?B?MkZobGdtUjdPSFhUSWpYdFU2emt3dS9NLysveFExUTFYVGlDYVVzNE1vbjJ3?=
 =?utf-8?B?YTEvZDBxT2dNZGlFa1RyWEwzYlg4WnlzeWp6U0VCVjJIUFRYWjlIaFBIaXUx?=
 =?utf-8?B?d1VlVEZXRGQ2Tk9HNVRKS0xMbGV1d3c4b3NJV2pvU1ZYRmdhRjgwUFNId0Fv?=
 =?utf-8?B?OGx3bkpxeTZLL0RRZTVxazlpRXpQWVRYbURFWDU5NHMxTnBmVDA1Ky9lemZh?=
 =?utf-8?B?Rlh3Wkc2ajNHTTQ2R0IzUDl4Y2F5eTduVnBGRzR3bS9EZGJsU3lBcFBCR3Jy?=
 =?utf-8?B?cXJ4Vmt2Qkw5aDBCTElPUUZTSkxwRTJEZU5Bb0ZpZFpiVU5tR3Rka3hNTE5V?=
 =?utf-8?B?dndldFJGbVRSa0RUZVZ1TFdQenYrRy8xN0VqZkdDNXlZSGlJLytDY3BrdXhL?=
 =?utf-8?B?MlJpMVJtV1ZjZ0hOOTYwaHNCcG1STWw3Z253ZHpNcU5aaHpzNjBNRFIyWnND?=
 =?utf-8?B?T1Z6a2Z2VmdpM3B5alp3M3FFT2xhQ0QzZ2tjSnpZdlFreC9QeW91eXFLVmtm?=
 =?utf-8?B?NlNvMmpFc3JUQzVFVy9CNkFxSktnK0szL2xNRjdwZHZwbXBhYWNUVldSek90?=
 =?utf-8?B?MjI1Rm9GL1htc0Y0WHdHSzJLY050U2RRUDQ3czk1Q3NqZ3RILzJvWkVVdGlL?=
 =?utf-8?B?NHI1b3AyczNxTk10KzVBZWxKN1hSSnFOMEN4SitFd055eGpaK0xBQzVvNFQy?=
 =?utf-8?B?ZjJOUXhsOUNKc3FRS2RwdHJwTnFqT3B1SmY1dVdLaDhOVXZPT0c1RGhETnZZ?=
 =?utf-8?B?cHlvZDE3LzVvbkpQQURrM1JOVDB0eG1LZWtscUdPTG5KcWF0c0pYdWdEOWdG?=
 =?utf-8?Q?4bxU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR12MB5598.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab5f77fe-8645-4c63-8b0c-08db2f8b41ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 12:52:15.3759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hrv+9dCv18OI6QzMf/yAv6cbAFooMq5fvrYn8EonOZEZ8YmPV6qlCMKgEFwBBPc38BqD1VrhTJvCTkL5FvvLrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4082
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiBUdWVzZGF5LCBN
YXJjaCAxNCwgMjAyMyA5OjIyIFBNDQo+IFRvOiBHYWRkYW0sIFNhcmF0aCBCYWJ1IE5haWR1DQo+
IDxzYXJhdGguYmFidS5uYWlkdS5nYWRkYW1AYW1kLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
DQo+IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5j
b207DQo+IHJvYmgrZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8u
b3JnDQo+IENjOiBtaWNoYWwuc2ltZWtAeGlsaW54LmNvbTsgcmFkaGV5LnNoeWFtLnBhbmRleUB4
aWxpbnguY29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2Vy
bmVsLm9yZzsgbGludXgtYXJtLQ0KPiBrZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsgU2FyYW5naSwNCj4gQW5pcnVkaGEgPGFuaXJ1ZGhhLnNh
cmFuZ2lAYW1kLmNvbT47IEthdGFrYW0sIEhhcmluaQ0KPiA8aGFyaW5pLmthdGFrYW1AYW1kLmNv
bT47IGdpdCAoQU1ELVhpbGlueCkgPGdpdEBhbWQuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IG5ldC1uZXh0IFY3XSBkdC1iaW5kaW5nczogbmV0OiB4bG54LGF4aS1ldGhlcm5ldDoNCj4gY29u
dmVydCBiaW5kaW5ncyBkb2N1bWVudCB0byB5YW1sDQo+IA0KPiBPbiAwOC8wMy8yMDIzIDA3OjEy
LCBTYXJhdGggQmFidSBOYWlkdSBHYWRkYW0gd3JvdGU6DQo+ID4gRnJvbTogUmFkaGV5IFNoeWFt
IFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRleUB4aWxpbnguY29tPg0KPiA+DQo+ID4gQ29udmVy
dCB0aGUgYmluZGluZ3MgZG9jdW1lbnQgZm9yIFhpbGlueCBBWEkgRXRoZXJuZXQgU3Vic3lzdGVt
IGZyb20NCj4gPiB0eHQgdG8geWFtbC4gTm8gY2hhbmdlcyB0byBleGlzdGluZyBiaW5kaW5nIGRl
c2NyaXB0aW9uLg0KPiA+DQo+IA0KPiAoLi4uKQ0KPiANCj4gPiArcHJvcGVydGllczoNCj4gPiAr
ICBjb21wYXRpYmxlOg0KPiA+ICsgICAgZW51bToNCj4gPiArICAgICAgLSB4bG54LGF4aS1ldGhl
cm5ldC0xLjAwLmENCj4gPiArICAgICAgLSB4bG54LGF4aS1ldGhlcm5ldC0xLjAxLmENCj4gPiAr
ICAgICAgLSB4bG54LGF4aS1ldGhlcm5ldC0yLjAxLmENCj4gPiArDQo+ID4gKyAgcmVnOg0KPiA+
ICsgICAgZGVzY3JpcHRpb246DQo+ID4gKyAgICAgIEFkZHJlc3MgYW5kIGxlbmd0aCBvZiB0aGUg
SU8gc3BhY2UsIGFzIHdlbGwgYXMgdGhlIGFkZHJlc3MNCj4gPiArICAgICAgYW5kIGxlbmd0aCBv
ZiB0aGUgQVhJIERNQSBjb250cm9sbGVyIElPIHNwYWNlLCB1bmxlc3MNCj4gPiArICAgICAgYXhp
c3RyZWFtLWNvbm5lY3RlZCBpcyBzcGVjaWZpZWQsIGluIHdoaWNoIGNhc2UgdGhlIHJlZw0KPiA+
ICsgICAgICBhdHRyaWJ1dGUgb2YgdGhlIG5vZGUgcmVmZXJlbmNlZCBieSBpdCBpcyB1c2VkLg0K
PiANCj4gRGlkIHlvdSB0ZXN0IGl0IHdpdGggYXhpc3RyZWFtLWNvbm5lY3RlZD8gVGhlIHNjaGVt
YSBhbmQgZGVzY3JpcHRpb24NCj4gZmVlbCBjb250cmFkaWN0b3J5IGFuZCB0ZXN0cyB3b3VsZCBw
b2ludCB0aGUgaXNzdWUuDQoNClRoYW5rcyBmb3IgcmV2aWV3IGNvbW1lbnRzLiBXZSB0ZXN0ZWQg
d2l0aCBheGlzdHJlYW0tY29ubmVjdGVkIGFuZA0KZGlkIG5vdCBvYnNlcnZlIGFueSBlcnJvcnMu
IERvIHlvdSBhbnRpY2lwYXRlIGFueSBpc3N1ZXMvZXJyb3JzID8NCg0Kd2lsbCBhZGRyZXNzIHJl
bWFpbmluZyByZXZpZXcgY29tbWVudHMuDQoNClRoYW5rcywNCnNhcmF0aCAgDQoNCj4gPiArICAg
IG1heEl0ZW1zOiAyDQo+ID4gKw0KPiA+ICsgIGludGVycnVwdHM6DQo+ID4gKyAgICBpdGVtczoN
Cj4gPiArICAgICAgLSBkZXNjcmlwdGlvbjogRXRoZXJuZXQgY29yZSBpbnRlcnJ1cHQNCj4gPiAr
ICAgICAgLSBkZXNjcmlwdGlvbjogVHggRE1BIGludGVycnVwdA0KPiA+ICsgICAgICAtIGRlc2Ny
aXB0aW9uOiBSeCBETUEgaW50ZXJydXB0DQo+ID4gKyAgICBkZXNjcmlwdGlvbjoNCj4gPiArICAg
ICAgRXRoZXJuZXQgY29yZSBpbnRlcnJ1cHQgaXMgb3B0aW9uYWwuIElmIGF4aXN0cmVhbS1jb25u
ZWN0ZWQNCj4gcHJvcGVydHkgaXMNCj4gPiArICAgICAgcHJlc2VudCBETUEgbm9kZSBzaG91bGQg
Y29udGFpbnMgVFgvUlggRE1BIGludGVycnVwdHMgZWxzZQ0KPiBETUEgaW50ZXJydXB0DQo+ID4g
KyAgICAgIHJlc291cmNlcyBhcmUgbWVudGlvbmVkIG9uIGV0aGVybmV0IG5vZGUuDQo+ID4gKyAg
ICBtaW5JdGVtczogMQ0KPiA+ICsNCj4gPiArICBwaHktaGFuZGxlOiB0cnVlDQo+ID4gKw0KPiA+
ICsgIHhsbngscnhtZW06DQo+ID4gKyAgICBkZXNjcmlwdGlvbjoNCj4gPiArICAgICAgU2V0IHRv
IGFsbG9jYXRlZCBtZW1vcnkgYnVmZmVyIGZvciBSeC9UeCBpbiB0aGUgaGFyZHdhcmUuDQo+ID4g
KyAgICAkcmVmOiAvc2NoZW1hcy90eXBlcy55YW1sIy9kZWZpbml0aW9ucy91aW50MzINCj4gPiAr
DQo+ID4gKyAgcGh5LW1vZGU6DQo+ID4gKyAgICBpdGVtczoNCj4gPiArICAgICAgLSBkZXNjcmlw
dGlvbjogTUlJDQo+ID4gKyAgICAgIC0gZGVzY3JpcHRpb246IEdNSUkNCj4gPiArICAgICAgLSBk
ZXNjcmlwdGlvbjogUkdNSUkNCj4gPiArICAgICAgLSBkZXNjcmlwdGlvbjogU0dNSUkNCj4gPiAr
ICAgICAgLSBkZXNjcmlwdGlvbjogMTAwMEJhc2VYDQo+IA0KPiBJIGhhdmUgZG91YnRzIHlvdSB0
ZXN0ZWQgaXQuLi4gU2luY2Ugd2hlbiB0aGlzIGlzIGEgbGlzdD8gSG93IGRvZXMgaXQgZXhhY3Rs
eQ0KPiB3b3JrIGFuZCB3aGF0IGRvIHlvdSB3YW50IHRvIHNob3cgaGVyZT8NCj4gDQo+IGNvbm5l
Y3Rpb24gdHlwZSBpcyBlbnVtLg0KPiANCj4gDQo+ID4gKyAgICBtaW5JdGVtczogMQ0KPiA+ICsN
Cj4gPiArICB4bG54LHBoeS10eXBlOg0KPiA+ICsgICAgZGVzY3JpcHRpb246DQo+ID4gKyAgICAg
IERvIG5vdCB1c2UsIGJ1dCBzdGlsbCBhY2NlcHRlZCBpbiBwcmVmZXJlbmNlIHRvIHBoeS1tb2Rl
Lg0KPiA+ICsgICAgZGVwcmVjYXRlZDogdHJ1ZQ0KPiA+ICsgICAgJHJlZjogL3NjaGVtYXMvdHlw
ZXMueWFtbCMvZGVmaW5pdGlvbnMvdWludDMyDQo+ID4gKw0KPiA+ICsgIHhsbngsdHhjc3VtOg0K
PiA+ICsgICAgZGVzY3JpcHRpb246DQo+ID4gKyAgICAgIFRYIGNoZWNrc3VtIG9mZmxvYWQuIDAg
b3IgZW1wdHkgZm9yIGRpc2FibGluZyBUWCBjaGVja3N1bQ0KPiBvZmZsb2FkLA0KPiA+ICsgICAg
ICAxIHRvIGVuYWJsZSBwYXJ0aWFsIFRYIGNoZWNrc3VtIG9mZmxvYWQgYW5kIDIgdG8gZW5hYmxl
IGZ1bGwgVFgNCj4gPiArICAgICAgY2hlY2tzdW0gb2ZmbG9hZC4NCj4gPiArICAgICRyZWY6IC9z
Y2hlbWFzL3R5cGVzLnlhbWwjL2RlZmluaXRpb25zL3VpbnQzMg0KPiA+ICsgICAgZW51bTogWzAs
IDEsIDJdDQo+ID4gKw0KPiA+ICsgIHhsbngscnhjc3VtOg0KPiA+ICsgICAgZGVzY3JpcHRpb246
DQo+ID4gKyAgICAgIFJYIGNoZWNrc3VtIG9mZmxvYWQuIDAgb3IgZW1wdHkgZm9yIGRpc2FibGlu
ZyBSWCBjaGVja3N1bQ0KPiBvZmZsb2FkLA0KPiA+ICsgICAgICAxIHRvIGVuYWJsZSBwYXJ0aWFs
IFJYIGNoZWNrc3VtIG9mZmxvYWQgYW5kIDIgdG8gZW5hYmxlIGZ1bGwgUlgNCj4gPiArICAgICAg
Y2hlY2tzdW0gb2ZmbG9hZC4NCj4gPiArICAgICRyZWY6IC9zY2hlbWFzL3R5cGVzLnlhbWwjL2Rl
ZmluaXRpb25zL3VpbnQzMg0KPiA+ICsgICAgZW51bTogWzAsIDEsIDJdDQo+ID4gKw0KPiA+ICsg
IHhsbngsc3dpdGNoLXgtc2dtaWk6DQo+ID4gKyAgICB0eXBlOiBib29sZWFuDQo+ID4gKyAgICBk
ZXNjcmlwdGlvbjoNCj4gPiArICAgICAgSW5kaWNhdGUgdGhlIEV0aGVybmV0IGNvcmUgaXMgY29u
ZmlndXJlZCB0byBzdXBwb3J0IGJvdGggMTAwMEJhc2VYDQo+IGFuZA0KPiA+ICsgICAgICBTR01J
SSBtb2Rlcy4gSWYgc2V0LCB0aGUgcGh5LW1vZGUgc2hvdWxkIGJlIHNldCB0byBtYXRjaCB0aGUN
Cj4gbW9kZQ0KPiA+ICsgICAgICBzZWxlY3RlZCBvbiBjb3JlIHJlc2V0IChpLmUuIGJ5IHRoZSBi
YXNleF9vcl9zZ21paSBjb3JlIGlucHV0IGxpbmUpLg0KPiA+ICsNCj4gPiArICBjbG9ja3M6DQo+
ID4gKyAgICBpdGVtczoNCj4gPiArICAgICAgLSBkZXNjcmlwdGlvbjogQ2xvY2sgZm9yIEFYSSBy
ZWdpc3RlciBzbGF2ZSBpbnRlcmZhY2UuDQo+ID4gKyAgICAgIC0gZGVzY3JpcHRpb246IEFYSTQt
U3RyZWFtIGNsb2NrIGZvciBUWEQgUlhEIFRYQyBhbmQgUlhTDQo+IGludGVyZmFjZXMuDQo+ID4g
KyAgICAgIC0gZGVzY3JpcHRpb246IEV0aGVybmV0IHJlZmVyZW5jZSBjbG9jaywgdXNlZCBieSBz
aWduYWwgZGVsYXkNCj4gcHJpbWl0aXZlcw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBhbmQg
dHJhbnNjZWl2ZXJzLg0KPiA+ICsgICAgICAtIGRlc2NyaXB0aW9uOiBNR1QgcmVmZXJlbmNlIGNs
b2NrICh1c2VkIGJ5IG9wdGlvbmFsIGludGVybmFsDQo+ID4gKyBQQ1MvUE1BIFBIWSkNCj4gPiAr
DQo+ID4gKyAgY2xvY2stbmFtZXM6DQo+ID4gKyAgICBpdGVtczoNCj4gPiArICAgICAgLSBjb25z
dDogc19heGlfbGl0ZV9jbGsNCj4gPiArICAgICAgLSBjb25zdDogYXhpc19jbGsNCj4gPiArICAg
ICAgLSBjb25zdDogcmVmX2Nsaw0KPiA+ICsgICAgICAtIGNvbnN0OiBtZ3RfY2xrDQo+ID4gKw0K
PiA+ICsgIGF4aXN0cmVhbS1jb25uZWN0ZWQ6DQo+ID4gKyAgICAkcmVmOiAvc2NoZW1hcy90eXBl
cy55YW1sIy9kZWZpbml0aW9ucy9waGFuZGxlDQo+ID4gKyAgICBkZXNjcmlwdGlvbjogUGhhbmRs
ZSBvZiBBWEkgRE1BIGNvbnRyb2xsZXIgd2hpY2ggY29udGFpbnMgdGhlDQo+IHJlc291cmNlcw0K
PiA+ICsgICAgICB1c2VkIGJ5IHRoaXMgZGV2aWNlLiBJZiB0aGlzIGlzIHNwZWNpZmllZCwgdGhl
IERNQS1yZWxhdGVkIHJlc291cmNlcw0KPiA+ICsgICAgICBmcm9tIHRoYXQgZGV2aWNlIChETUEg
cmVnaXN0ZXJzIGFuZCBETUEgVFgvUlggaW50ZXJydXB0cykgcmF0aGVyDQo+IHRoYW4NCj4gPiAr
ICAgICAgdGhpcyBvbmUgd2lsbCBiZSB1c2VkLg0KPiA+ICsNCj4gPiArICBtZGlvOg0KPiA+ICsg
ICAgdHlwZTogb2JqZWN0DQo+ID4gKw0KPiA+ICsgIHBjcy1oYW5kbGU6DQo+IA0KPiBtYXhJdGVt
czogMQ0KPiANCj4gPiArICAgIGRlc2NyaXB0aW9uOiBQaGFuZGxlIHRvIHRoZSBpbnRlcm5hbCBQ
Q1MvUE1BIFBIWSBpbiBTR01JSSBvcg0KPiAxMDAwQmFzZS1YDQo+ID4gKyAgICAgIG1vZGVzLCB3
aGVyZSAicGNzLWhhbmRsZSIgc2hvdWxkIGJlIHVzZWQgdG8gcG9pbnQgdG8gdGhlDQo+IFBDUy9Q
TUEgUEhZLA0KPiA+ICsgICAgICBhbmQgInBoeS1oYW5kbGUiIHNob3VsZCBwb2ludCB0byBhbiBl
eHRlcm5hbCBQSFkgaWYgZXhpc3RzLg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBLcnp5c3p0b2YN
Cg0K
