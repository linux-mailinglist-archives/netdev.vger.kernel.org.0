Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D54673617
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjASKxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjASKxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:53:11 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17814A1C0;
        Thu, 19 Jan 2023 02:53:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHTBYQ+0gMHsNvpS8V0NvtN6wZOiKy0CU0E9NEcZQg/+/u4nw2BhHYEVWf3Zr+hP+vfr8cVi/rvDBYEtebiWJsZ+mdkWfAIrYAn990uBNTfFk2Gxd1Mln4sIM9wzEU5ukDW/UEKiya4UTwOjrD2gYAsty9wn0rjyfPbUUzgVWy0Sn4TXzplev+0nEyloGAQQR1SepNTzF4s/zYd0C2t5C6w4WnTaTSSqbV1xtU01W8kjIV88gqnV/ewdXkwTZMP0Kl3O/Su9Yop+qwLO5VEYutHwAS9UsJuBhew8TEmuMlxR2/wk8SjQTXPknFqPj4IcYF7rfPS0idfcL8yNSZpZHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c7RJ5SHZPcfvWc0Nz3Hq4OoE4lP6w1uf+LGUmFUIkQE=;
 b=TJQ1X7SjfUVYuBk+/GPYVbktmAWipPwXlU/KI1zHwKtFFkD+Koe5iDoJeuwZOj7Gk0xbqaXRfteelgADE19O2jaLiOf3KMvRGPmi2zjsGacxh8m5idJqJWrwNQWGf5NRzO/jN3vQhO0RUyc+iWIGn3ll3wd7XUGpYAJF+byQOjsk1OGQksv6wex2bhFAbL8p4b72V0b+B6BTG0uo/oZGnUB6LlidBjjXHCTJ1Wj2eTIE77z52Jkg0c4Cu6jS11vGRJlGaHQpF/xoYDCpkJejzb9p6ch7XfG2fP9c/PZtst4HP0AnmGMMsikylQ5G7gVBpEWlv+uANqc7/9svGGs4ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7RJ5SHZPcfvWc0Nz3Hq4OoE4lP6w1uf+LGUmFUIkQE=;
 b=HzK/MvVTC4qj/BInaFJTI7cQM5Fn3w3HNlt/JuZy+kqWzBAZswI/VFieI3ZWFJrLQ4dtdgUY9sjtXuo0OkAFQ9zsU3x1Py7+EglmpHxbCAgZBa9vtsKOUuhgrlghCHIIF7gJIHR5kYsHf4SqcAdClTWaQyQHdMK7ey0bCL8M/Hc=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by IA1PR12MB8080.namprd12.prod.outlook.com (2603:10b6:208:3fd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 10:53:03 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::2341:7d31:d412:f31c]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::2341:7d31:d412:f31c%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 10:53:02 +0000
From:   "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next V2] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Thread-Topic: [PATCH net-next V2] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Thread-Index: AQHY5Q+/hQESpMCxEk+Zmtk3AXijhq4cIcUAgBvn0BCAAEdjAIBtyNdg
Date:   Thu, 19 Jan 2023 10:53:02 +0000
Message-ID: <MW5PR12MB55984C7FB2FAA7D22BC00BF787C49@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20221021054111.25852-1-sarath.babu.naidu.gaddam@amd.com>
 <cfbde0da-9939-e976-52c1-88577de7d4cb@linaro.org>
 <MW5PR12MB559842AC3B0D4E539D653B3D87019@MW5PR12MB5598.namprd12.prod.outlook.com>
 <f338976e-40eb-5171-c14d-952d07d67730@linaro.org>
In-Reply-To: <f338976e-40eb-5171-c14d-952d07d67730@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|IA1PR12MB8080:EE_
x-ms-office365-filtering-correlation-id: e2d0f66f-85df-40c4-f821-08dafa0b566f
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h+i3uHJI56QLCUwHd73ZkyRB6fN0Yyq2jbNkk4lliJ+bQnkxqK/O1lqFKDlya8vbXN+xZDNMXOKSd87vgv37ugASpfWwUtBMuXQZuJn5Jp+04b88fw1lOglSljb4nT3skatg4T7fB0ka7I+dHVWhK+pcM87ffW/wsxHRJoiQdqtq4iACGqdyco8NDGdXGp43GbNxiUNQyr1nCSEXklLu5i6r+wWiZPazN8At+DM5NaPNs/OVuwjW0OVu3lixSTQKQoGpE7D6UWZifx75Ubj8TGXlek5b5xE1srWACwneXzQnHXFjwqt8hKHIyUx0VnGPL5mw/TEm+5vUIfURijdYEYCUzHMPql8G8ZQqFjVGJPCBmpAjXbSkkH3VvAsZuDOezc2hEKqcWw4ka/2ZXSFB+egxDbSUcdaLMS4HY/iXYg3hrLztG1a1RCWgaVxAS4CatPaAjMVvZ0O1BdxFvbqdUxIYuo54RGcS18qVT/iijhDrb8VUdqQF++2HTMUo1nNxssvFX9PZv2VVl+LuX1Gj5/xqCbeBJkWYvGi5OCjVTnXVwTWRfSXJUrF3TEHQphZ3yyGACwI5mc90+8PugwA3VYuJ6TJYNCMkMioGXP6bUaqnx9FjVxYMQ2/uJ4bWOHKYetL1UT9C8Gz/ADjtMTHPS04qkoriT1Z4QCBnTd+6PccI3WWzkTrLmdmkoBptAZ/Lw37Gx9yISX31HnngKaDXhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(83380400001)(52536014)(33656002)(122000001)(38100700002)(4326008)(38070700005)(86362001)(5660300002)(2906002)(8676002)(7416002)(76116006)(8936002)(66556008)(66446008)(66476007)(55016003)(66946007)(64756008)(26005)(41300700001)(186003)(9686003)(53546011)(6506007)(71200400001)(110136005)(54906003)(7696005)(316002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czk5bEYvQVZnMkg2M29NVkJyWUVZSnQxSGpodHF0RWlIUUF1YXJwMytHM2hj?=
 =?utf-8?B?VWhZTUxVM0hGY00vNDRhTmF1aWs1Z2p6VlY1aWtlSXhyN2xlcHVQTUIxL2g4?=
 =?utf-8?B?eGg0QmVqMzFjWFRORS9DT1BOSTZ1RXV2QmcwK29BTHBwYlZ5ZW5rZHVHNmdv?=
 =?utf-8?B?bFRkZ2VCT0dKRDhtM2pYZHc5RXF6dGh4SnhXOXpBYWxHSm95Qlp6VmNMaHIr?=
 =?utf-8?B?ajhUR0tHa29BM0hHdXdxT09RUFMyT1IrZHdDa3RKZUFNVy9kWmRMR05HQ1VJ?=
 =?utf-8?B?WXE1eTBHcDVCV1J1cUhJeEVxL0hxRUxNNmZGR3grL0RFM1NhZkxIQUVrRHlm?=
 =?utf-8?B?YmxFY2xYQ2FLajkwaXBGeVRsM2lqaVErVFB0T1diRHBNbkJRZG0yUkliQ09O?=
 =?utf-8?B?R3ZlalFhNXdRcnhsZnkvaWpqaVhzZDY2b3VRRDJjekJ5NEZKbko2c3BCYVVR?=
 =?utf-8?B?TU5OMlFXL2JjbFBwUi9pUXBLNnJwT0ZhcFQ1WHhuNmowN09ZUUVPeFJNKzVO?=
 =?utf-8?B?Y3NpY0czOXZVbWRSUXFZdy82RzJPU2Jzc1lOTHI3QkptTFlZc3NOeFU5ek5x?=
 =?utf-8?B?Y3RZbzE2RzBNSjNGOXVBaTZ0WmdSV2E2OFY2aWxTRWNtYW5NaEtuM1FmcDlz?=
 =?utf-8?B?ZTNqcGFXNTkwVVFiQ0hUSkIweVNETnRVOXE2TzRLQlZwMkdic3dqUitsZ2RG?=
 =?utf-8?B?VHFxcDBkV1VrUlRqeElFL3dTTHkycE42L203UzhhaDhjOWx0UGgyRHFlSUtC?=
 =?utf-8?B?OTVpM0Z4U01YcGc1VmxCNSsxSy9QTlkrcDlGcEpUSmFoUHlCVTZkeFBuNys1?=
 =?utf-8?B?c0FSQ3V5Q3V3ejNhSi9kd2dVM2VWNW82ZzhVU21pem1KaENuUjRZMXZwVDBC?=
 =?utf-8?B?bnQ4UUpWNXhSYW5HQnNvbFdOSzlpRWljQW5reUJ4cmt1T25zU29zOTFhNXJU?=
 =?utf-8?B?c2xiRnREWTR1Qkg1K1Vyb3FRc1BJWUVNNlVJTzQvWG13NjVtSlR0anYwbnNn?=
 =?utf-8?B?N1d6QVdZZkFlMUhjazdaTU5XM0g1bHBMeWhud2VwcXFUbXJ4V3B6TlRjQlYy?=
 =?utf-8?B?N2gySzhINHBmS1FFWjVsMG5PWWw2aG80K3c5NmdBa3h3a3ROL1JxQkFQZ3NV?=
 =?utf-8?B?dG9BT1lkQ0E0YzBFR1llYkxEUHBhR1AyQ3Evc0xWakxoWTBQUGFLRWZFU0V4?=
 =?utf-8?B?VWcwR3hrV0Y1WnR3cU9MOE4rK041NVUzZG9nQU1pa3pXK3dOa0o4TWR1WnpM?=
 =?utf-8?B?K3paZW9ETUVOck85bzYrTkxjZC9PM1RYRkdibXhLUW9JL2RXcnhyNEs4RmtT?=
 =?utf-8?B?QVorSVRUb3ZkOCtEbVRzWHB3eXFXb1IrT2FSUFpRQXplTmVUaVlTSk0ydVlW?=
 =?utf-8?B?NmxqUk00eU5wa0dqSzBMdS9FbmJLaWUzN1FmNEQ4R21OcnlvZFZaREFHSEE5?=
 =?utf-8?B?aXBtRWtpL09xYVRCQ1lOemJkdUFTb1NlYSt4R3pUcHZLNjFidFlUNmZRN1lu?=
 =?utf-8?B?a3UrRTVKcGY3N1pJRzlMOVZ2Q1Q4RCtldTVTZGVvMnF3eG54NGVVaVZGeVR6?=
 =?utf-8?B?Yk56M0IvVXcydDdpUFk4cDVwV3N1ZUt5MGpnc2RCd3pCOVdwamFrSUF3cjZs?=
 =?utf-8?B?c1p0SkExdm85VDhGWCt5TFU3c2hkVkxmMG9kOVhnYUVBZ3o4eFB4a2orZTQv?=
 =?utf-8?B?RTE2dGhFS3dLL25VcXczTHAzeXNBVWQ2UDBlWUtZVmc4eGs3eTB5dFZGS25m?=
 =?utf-8?B?dnZUOTY4RUxuSHhkYnkzeCtWMFN4dlZSMHRLandPR2FpYXNadnBiamNsVFJY?=
 =?utf-8?B?OHROUnJYSm40T0JUOWU3SnF1QllmdHphckUxWjZPYnAvVDRzSmxEelNlYjNY?=
 =?utf-8?B?MzlyN1l2N3g0U3o5Q2o3UkVtWVBvMy9NVk5pcnE0MmFiZ2xNZXQ0OG15STBF?=
 =?utf-8?B?UTdLbEFiZDhNMnhKMGFSM1NqcVVURHg1OEN4VUp6a3RReFpITFVRTzRFWXI5?=
 =?utf-8?B?VmdnTTVhYzNCZ0krNlB6SXhZaTFMTkY2R2lnT2lTNEZLWjZVbENseEt6SWMx?=
 =?utf-8?B?cm5XN3VZOStOYW9yN1VkSHhzZ0lsdEtiWDdMdk5CV3ZoYjAwWEZnRGpZMjlV?=
 =?utf-8?Q?fjME=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR12MB5598.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d0f66f-85df-40c4-f821-08dafa0b566f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 10:53:02.7796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LCrI3nhoWm+zMzGDvrVQzdVDfQ+kUKqKFbe/Fb3WnHW3eJTsqhPsuDSZdjzk3TXxxhpmENWFIf6qxLYY4tN/eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8080
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiBUaHVyc2RheSwg
Tm92ZW1iZXIgMTAsIDIwMjIgNzozNiBQTQ0KPiBUbzogR2FkZGFtLCBTYXJhdGggQmFidSBOYWlk
dQ0KPiA8c2FyYXRoLmJhYnUubmFpZHUuZ2FkZGFtQGFtZC5jb20+OyBkYXZlbUBkYXZlbWxvZnQu
bmV0Ow0KPiBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRo
YXQuY29tOw0KPiByb2JoK2R0QGtlcm5lbC5vcmc7IHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbQ0K
PiBDYzoga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnOyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsNCj4geWFuZ2JvLmx1QG54cC5jb207IFBhbmRleSwgUmFkaGV5IFNoeWFtDQo+
IDxyYWRoZXkuc2h5YW0ucGFuZGV5QGFtZC5jb20+OyBTYXJhbmdpLCBBbmlydWRoYQ0KPiA8YW5p
cnVkaGEuc2FyYW5naUBhbWQuY29tPjsgS2F0YWthbSwgSGFyaW5pDQo+IDxoYXJpbmkua2F0YWth
bUBhbWQuY29tPjsgZ2l0IChBTUQtWGlsaW54KSA8Z2l0QGFtZC5jb20+DQo+IFN1YmplY3Q6IFJl
OiBbUEFUQ0ggbmV0LW5leHQgVjJdIGR0LWJpbmRpbmdzOiBuZXQ6IGV0aGVybmV0LWNvbnRyb2xs
ZXI6DQo+IEFkZCBwdHAtaGFyZHdhcmUtY2xvY2sNCj4gDQo+IE9uIDEwLzExLzIwMjIgMTA6NTcs
IEdhZGRhbSwgU2FyYXRoIEJhYnUgTmFpZHUgd3JvdGU6DQo+ID4+Pg0KPiA+Pj4gKyAgcHRwLWhh
cmR3YXJlLWNsb2NrOg0KPiA+Pj4gKyAgICAkcmVmOiAvc2NoZW1hcy90eXBlcy55YW1sIy9kZWZp
bml0aW9ucy9waGFuZGxlDQo+ID4+PiArICAgIGRlc2NyaXB0aW9uOg0KPiA+Pj4gKyAgICAgIFNw
ZWNpZmllcyBhIHJlZmVyZW5jZSB0byBhIG5vZGUgcmVwcmVzZW50aW5nIGEgSUVFRTE1ODggdGlt
ZXIuDQo+ID4+DQo+ID4+IERyb3AgIlNwZWNpZmllcyBhIHJlZmVyZW5jZSB0byIuIEl0J3Mgb2J2
aW91cyBmcm9tIHRoZSBzY2hlbWEuDQo+ID4+DQo+ID4+IEFyZW4ndCB5b3UgZXhwZWN0aW5nIGhl
cmUgc29tZSBzcGVjaWZpYyBEZXZpY2V0cmVlIG5vZGUgb2YgSUVFRTE1ODgNCj4gdGltZXI/DQo+
ID4+IElPVywgeW91IGV4cGVjdCB0byBwb2ludCB0byB0aW1lciwgYnV0IHdoYXQgdGhpcyB0aW1l
ciBtdXN0IHByb3ZpZGU/DQo+ID4+IEhvdyBpcyB0aGlzIGdlbmVyaWM/DQo+ID4NCj4gPiBUaGFu
a3MgZm9yIHJldmlldyBjb21tZW50cy4NCj4gPiAgRm9ybWF0IGNhbiBiZSBhcyBkb2N1bWVudGVk
IGJ5IHVzZXJzDQo+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9wdHAvIG1lbWJl
cnMuIFRoZSBub2RlIHNob3VsZCBiZQ0KPiBhY2Nlc3NpYmxlIHRvIGRlcml2ZSB0aGUgaW5kZXgg
YnV0IHRoZSBmb3JtYXQgb2YgdGhlIFBUUCBjbG9jayBub2RlIGlzDQo+IHVwdG8gdGhlIHZlbmRv
ci4NCj4gDQo+IEkgYW0gbm90IHN1cmUgd2hhdCBkbyB5b3UgbWVhbiBoZXJlLiBBbnl3YXkgZGVz
Y3JpcHRpb24gbWlnaHQgbmVlZA0KPiBzb21ldGhpbmcgbW9yZSBzcGVjaWZpYy4NCg0KQXBvbG9n
aWVzIGZvciBwaWNraW5nIHVwIG9uIHRoaXMgdGhyZWFkIGFmdGVyIGEgbG9uZyB0aW1lLg0KUFRQ
IGNsb2NrIG5vZGUodGltZXIpIGlzIHVwdG8gdGhlIHZlbmRvci4gRHJpdmVyIHdoaWNoIG5lZWRz
IGEgcmVmZXJlbmNlDQp0byB0aGlzIG5vZGUgY2FuIGJlIGFjY2Vzc2VkIGJ5IHRoaXMgbmV3IHBy
b3BlcnR5LiBJIHdpbGwgdXBkYXRlIHRoZQ0KZGVzY3JpcHRpb24uDQoNCj4gPg0KPiA+DQo+ID4+
DQo+ID4+IEluIHlvdXIgY29tbWl0IG1zZyB5b3UgdXNlIG11bHRpcGxlIHRpbWVzICJkcml2ZXIi
LCBzbyBhcmUgeW91DQo+IGFkZGluZw0KPiA+PiBpdCBvbmx5IHRvIHNhdGlzZnkgTGludXggZHJp
dmVyIHJlcXVpcmVtZW50cz8gV2hhdCBhYm91dCBvdGhlcg0KPiA+PiBkcml2ZXJzLCBlLmcuIG9u
IEJTRCBvciBVLUJvb3Q/DQo+ID4NCj4gPiBBRkFJSyB0aGlzIGlzIGZvciBMaW51eC4gSXQgaXMg
bm90IHJlbGV2YW50IHRvIHVib290IGFzIHRoZXJlJ3Mgbm8gUFRQDQo+IHN1cHBvcnQgdGhlcmUu
DQo+IA0KPiBBbmQgQlNEPyBCaW5kaW5ncyBhcmUgbm90IGZvciBMaW51eCBvbmx5LiBQbGVhc2Ug
YWJzdHJhY3QgZnJvbSBhbnkgT1MNCj4gc3BlY2lmaWNzLg0KDQpUaGlzIG5ldyBiaW5kaW5nIGlz
IGEgZ2VuZXJpYyBwcm9wZXJ0eS4gSXQgY2FuIGJlIHVzZWQgaW4gb3RoZXIgDQpkcml2ZXJzIGFs
c28gaWYgdGhleSB3YW50IHRvIGFjY2VzcyB0aGUgUFRQIGRldmljZSBub2RlIGluIHRoZSANCmN1
cnJlbnQgZHJpdmVyIGFuZCBJdCdzIGFuIG9wdGlvbmFsIHByb3BlcnR5Lg0KIA0KSSB3aWxsIGNo
YW5nZSB0aGUgY29tbWl0IGRlc2NyaXB0aW9uIGFzIGJlbG93LiBJZiB0aGlzIGlzIGZpbmUsIEkg
DQp3aWxsIHNlbmQgYW5vdGhlciB2ZXJzaW9uIHdpdGggdXBkYXRlZCBjb21taXQgZGVzY3JpcHRp
b24uDQogDQoiVGhlcmUgaXMgY3VycmVudGx5IG5vIHN0YW5kYXJkIHByb3BlcnR5IHRvIHBhc3Mg
UFRQIGRldmljZSBpbmRleCAgDQppbmZvcm1hdGlvbiB0byBldGhlcm5ldCBkcml2ZXIgd2hlbiB0
aGV5IGFyZSBpbmRlcGVuZGVudC4NCiANCnB0cC1oYXJkd2FyZS1jbG9jayBwcm9wZXJ0eSB3aWxs
IGNvbnRhaW4gcGhhbmRsZSB0byBQVFAgY2xvY2sgbm9kZS4NCg0KSXRzIGEgZ2VuZXJpYyAob3B0
aW9uYWwpIHByb3BlcnR5IG5hbWUgdG8gbGluayB0byBQVFAgcGhhbmRsZSB0byAgDQpFdGhlcm5l
dCBub2RlLiBBbnkgZnV0dXJlIG9yIGN1cnJlbnQgZXRoZXJuZXQgZHJpdmVycyB0aGF0IG5lZWQN
CmEgcmVmZXJlbmNlIHRvIHRoZSBQSEMgdXNlZCBvbiB0aGVpciBzeXN0ZW0gY2FuIHNpbXBseSB1
c2UgdGhpcyANCmdlbmVyaWMgcHJvcGVydHkgbmFtZSBpbnN0ZWFkIG9mIHVzaW5nIGN1c3RvbSBw
cm9wZXJ0eSANCmltcGxlbWVudGF0aW9uIGluIHRoZWlyIGRldmljZSB0cmVlIG5vZGVzLiINCg0K
VGhhbmtzLA0KU2FyYXRoDQoNCj4gQWxzbyB5b3VyIG1lc3NhZ2VzIG5lZWRzIHdyYXBwaW5nLiBV
c2UgbWFpbGluZyBsaXN0IHJlcGx5IHN0eWxlLg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBLcnp5
c3p0b2YNCg0K
