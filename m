Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E512C6E5C3C
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 10:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjDRIhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 04:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjDRIhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 04:37:13 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2124.outbound.protection.outlook.com [40.107.21.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D618161AB;
        Tue, 18 Apr 2023 01:36:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caMMAlxOOtVOV5jtsoolkDT5yW2k8YAoMSom1y03FOoMSF25I5oX43eWVbdmUyYLE3UOONEM6sc2g0Y79zo1oSZGDL8Y+EaMCBh8AnThvM/kOKShdgD3QbZnF1PDIzO+ZQI27PXjigPd8i/+qbF4RNO85JVjtt8i87wwZ79OUgMSZXSDT1T+R5hyUdvu/eMNhaYnqGyVHg/bVlFbXqf/dU3Qk9ACXp/k7abk29rFyrQ3xtKKkJCuware23IfuDyLAPqjs4hl0nxABNf0tdzCC5GzBWfAj7Ib06RlECR6zS2nxfqw+CoIXIanVoNb2po9HXhdQomfkxYM9p2zEj/TQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVkyK7TC7XU8ci1DA6H8owDU4jdoDpyaZ6CMj9edWWg=;
 b=NCKFO0Ju7m6XgX+tTTvzlLokcnCPTi0aEPI4TcLLCY6iTNRLiszmB9/s4Q2oiFkRSTrHCkj00XQX4f+Xlif9Ww4m/+5nYBmVlaMm3kgcmgNAiv+qqhmMN4heYX4BJE/UDwkidYrvuVdp4YcOnWovv7278RvhY/joS5VdBPJE7hIXpY3MCJvixDiRAN34nB5ltuY/p3fCs4Cm5BLLGoo/Pt3rvdEMtzsmxK3kNeB5mC4pxoKl8lJ8arQdo/jI6cBwlx+vJZ/EZm3skXhTsVrixWD0btasTT+5FWVBtIjO9wduruIrhJIqR7hIlkd9n+b4N1dWVobHpa30Cj+StWwurQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siklu.com; dmarc=pass action=none header.from=siklu.com;
 dkim=pass header.d=siklu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siklu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVkyK7TC7XU8ci1DA6H8owDU4jdoDpyaZ6CMj9edWWg=;
 b=SzcH9jDLH4BXxPCwwthTLAZezBn+cxsOgf14O7oAYley0IT2oYOSvz+Nia0YKuabT1HERmLUaBY4QrDSGalhPUzg0zB1UWyh6JVGkCDN+Uos+jlYY/vbqLcGUEAnpNmX+L2d+IuSGf1LZtcuZxTzNOrfAgLiRsbNfEsAXPX+jyU=
Received: from AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:26::11) by PAXPR01MB9001.eurprd01.prod.exchangelabs.com
 (2603:10a6:102:2b8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 08:36:42 +0000
Received: from AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 ([fe80::8941:8fd5:b4b2:9a3e]) by
 AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 ([fe80::8941:8fd5:b4b2:9a3e%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 08:36:42 +0000
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH v2 0/3] net: mvpp2: tai: add extts support
Thread-Topic: [PATCH v2 0/3] net: mvpp2: tai: add extts support
Thread-Index: AQHZcU8pePq4GQoDaUyDpS2t94etM68v24UAgADjogA=
Date:   Tue, 18 Apr 2023 08:36:42 +0000
Message-ID: <8ad5e6ee57baa4e1aeb7210a1a31bcdd77e9eb3d.camel@siklu.com>
References: <20230417170741.1714310-1-shmuel.h@siklu.com>
         <20230417120152.1ac03faf@kernel.org>
In-Reply-To: <20230417120152.1ac03faf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siklu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR0102MB3106:EE_|PAXPR01MB9001:EE_
x-ms-office365-filtering-correlation-id: d6b895c3-b183-4a22-bfb0-08db3fe8095f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qp91L+BbCYrHXRKMImqBY5ap4FJfo7iTYH/25XEsxyzgszQY1pNd+B62cAO4p+QT7FV84rCwJED6VZhBpH/XLlBGVjWnCr4or6Q3LWl3xymXz0aN4QcSKfZU8KDjO081F+lqpkUnBhmyGz2tzj2yqs7cRseCF6rJancLMdyxM6fisNdTVZ0vyuAjVbDA1ROWt1jNRpIvNbvngGERaGVIarrQYlzoJocVuq9RCAh6pCRi7EiF5E0ht9kZYpcRVKlTNPTENUWLsDCweo8lymD6RnG/I7ZKYW608m2gdfaqdq0qsdUH6Z2eVRhaAzS+g7f2v+DJFulfklzBVUBMlUhUzTWrelLVZOh89s6gq8OtBtEgiXA9NzSo/vY19jLRL+w79IusO/ft5LzbAQytO+MztZWj5nTiordAcs2Srd5Q3WqcNSrGQ2Pz2HTjlOiduMmLeuYtwNvzbcM9w7XhR8i1jGAmkEdoGWlHuuq77XNVz87Edm1dfdZSoLz+cxQ0uuEQ1T6rZQW304RplC1eOHAxUR4cKdLFNwwgpVCTE/pcIBSc/XwjDh45xVNY+E8qlfEyX0wi/06Y6vb4cTtFB+wlch3Mpjr7exsaNlXaGVAHyOY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0102MB3106.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39850400004)(366004)(136003)(376002)(346002)(451199021)(478600001)(71200400001)(38100700002)(8936002)(8676002)(316002)(41300700001)(6916009)(91956017)(4326008)(76116006)(66446008)(66556008)(66946007)(54906003)(122000001)(66476007)(186003)(4744005)(2906002)(38070700005)(6512007)(26005)(64756008)(6506007)(86362001)(83380400001)(36756003)(2616005)(5660300002)(966005)(6486002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWNJeXNHRzdoaCtlQ1pkOHZ1ZUxCNkhSQXBDTUhBZ1BTcS92aHdZc21LNlBn?=
 =?utf-8?B?d2RGUUc0N2l1Sy9nejQzUEMwWXN4ejFMYjZNSG40WVJBWHdSUDlRQXliMEda?=
 =?utf-8?B?WG9KcE9kMEo0bkt1ZWVkSTh2dzJkWEVoMjhkVHlLZVd6aXMyb01TMTRiUkRO?=
 =?utf-8?B?cmpHalpIaTFraWhqdUJDOWhOM3ppZGM5U2hVenFYYmVBV1p5L3dTdDF3V3k0?=
 =?utf-8?B?OXVSWStwb2ludVkwOGEwa1oxU1RZU2pRNGplSld4Q3pnZ3dEd3IrRE41QlN0?=
 =?utf-8?B?eGZpdWdWR2RYYXhSaHgvSjNldnhVUXU0ZkMvMGNxR3NkZHBFK1VMcFdHcnFP?=
 =?utf-8?B?ZVliNlpvK1NPUzRrVms3TVkwK0hIUkFQVUF1c3FYNnNydGVmOE5WQmpYclhn?=
 =?utf-8?B?VUQwTXBTMCtQa2VBQWlBOUk2bEVqVzl5VXVSZlV4b1d2WFhSaW43S01ZS1BP?=
 =?utf-8?B?cEU3SUZna0VCb0NIVWVPRGtPaVZoSlNDRXVMOGtVcFBmYUpha2FVZWxVbTlj?=
 =?utf-8?B?azRJMDNnN1B6aXUvaVRpRUk1Q0JDeW9PNkMzVVF1Z3k4Y0lJd2FiN3pSYTN0?=
 =?utf-8?B?R1NtbFR1RS93blFRb0poNCtVNTB2bUlOUmQ4cHpxa2dDVUxpc0VITWJ0bHVK?=
 =?utf-8?B?RTlaaDBhN0Z1akhiRGt1RnRTY290Nm11N2tROHFuT1ArUGZRbGhZUDRiRWRM?=
 =?utf-8?B?R2E1eFBCMGpXK3RhampTMFhwdmp0S3ZORUFTMW01a2Z0ZzZRc1pTMVNjSzNZ?=
 =?utf-8?B?N1NyaWNjK013ZWs1alYyUWx1T2ovR0hNWEtnTkRRL0NGSmloWXBaVEh4enkz?=
 =?utf-8?B?am1PK1dPeWIwZFRXZEJ4OFZ3ZE11RjNORnM3Z25laUtYbHBRU0pCWkVRZ1Fs?=
 =?utf-8?B?cnhJdWZBeHFvQTZabDZGaEhVNWthMFF1UUExbG02OUtRWXg1emdZZnVpTDMw?=
 =?utf-8?B?bnBoQUYwOE5GdUUxY0Vsc0Njbi9KbnZTMWJXOVE4RG1sbFpIUE1jMWU5YkRx?=
 =?utf-8?B?MHR3MXhFWm5pTmx4M1IxNXMvRUVsZEVYeXJ1UkZNaTlnc0x6MVdZNnRSeGFl?=
 =?utf-8?B?R1d0YnBVQ0hXUFV3YlljTzgzUWExQ211d3lhRHpabytyQ0g5dXJjQjhCY0E4?=
 =?utf-8?B?N3FLWU03ZW40WG1GaXRwN3ZhblpaTG43YXlDcXVjeGtzYXpJQlVVMEI1RnIx?=
 =?utf-8?B?RzNaeEltNThUNytHWlFibDhrM0d5OEJON2ZOb2FpZEJzQXhFSS94QkxMY2dT?=
 =?utf-8?B?VTlqaGZaTzJVT2dyYWM4a0VGTitqMjlKMlg5RUs4NXpRRGpRV1lXUDFIbnk0?=
 =?utf-8?B?bVR5blZiT3g1VWVMbVRhOWx1TGlhYUlMRW9XTXdvUXVrdVFMZzluOGNjZmU5?=
 =?utf-8?B?R2dHR0wxU20zRU5uVFhibHhjdllrS20rVHhUM09sdHFFdUcvLytSdUhmUHpV?=
 =?utf-8?B?UEVCMEpwVmRhZEtrbWJFa0xwOUJDQU9COUxlaDBCNGoyM1dYaVlPZG01Rmw4?=
 =?utf-8?B?OWczT2d2L1AyZkFSUmVHL0FBZmVzV3hsZGNRMGRZV1JWKzB6NFdoS3RhSGdR?=
 =?utf-8?B?TFRIOGJmMFdVQ1hqK0pPNEl1ZW5mYzcyU0lkdmNwQU9PVUlSWncvTTFRU0V0?=
 =?utf-8?B?RWNlamFkZ0Vicllsc1czT2djT1J6bkdocWpoQ2pOTUhvZ0xhVzJXR1pGVGFU?=
 =?utf-8?B?dnk0VlFEeXgrdkJQRVBLVVhrM0l5Z1pPeU8xT2VWZUtRb3RycCtKbFN1bU1I?=
 =?utf-8?B?dXVnT3FRR0R3TnRTNDE0ajZFa1lWaDVTSTlQdGNna3B6amlzVXZ4RlRDSnlm?=
 =?utf-8?B?L0VSTmU2S3Btei9LMUI0bG1GZmp1UDhvVEs3WDkyMU9zV1JVczNLMXR6RkJH?=
 =?utf-8?B?Wk5YdkdMYVJRSGFvRGY2R0kzOUNSR3N2aGM2aXJiMEwvWDI4N3diVGdGbzdz?=
 =?utf-8?B?WWtjOVdLMjFvMzdqRE8wTHVEQWJrTFJvcThPcHJpTlgrSzRoaEpNbHRYSDd2?=
 =?utf-8?B?ZmlPTHhLNUgydFZoRFNBOWJsYk5Nd09HNjBhcWdBWHFzb242VHIya1B4UW1P?=
 =?utf-8?B?eEp3N0c3VEZMalpkRU9oRWw5ckZYQzEvbVFJaFVQaDMydWJiNU1yWFpkbURy?=
 =?utf-8?Q?iHEyVjs8UXkFDZa+QiiDVJb/N?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C54B6E85DF0E24298099BAB2EB658FC@eurprd01.prod.exchangelabs.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siklu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6b895c3-b183-4a22-bfb0-08db3fe8095f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 08:36:42.5057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5841c751-3c9b-43ec-9fa0-b99dbfc9c988
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iE0kUa0zkgf76T/fMYGMxXVbscxAxX2oGtsqR07qhKSthZIkRfeq5/xqP0/fG4Cm3DXF/1PoV+N9glv6YwzVQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR01MB9001
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIzLTA0LTE3IGF0IDEyOjAxIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gQ2F1dGlvbjogVGhpcyBpcyBhbiBleHRlcm5hbCBlbWFpbC4gUGxlYXNlIHRha2UgY2FyZSB3
aGVuIGNsaWNraW5nIGxpbmtzIG9yIG9wZW5pbmcgYXR0YWNobWVudHMuDQo+IA0KPiANCj4gT24g
TW9uLCAxNyBBcHIgMjAyMyAyMDowNzozOCArMDMwMCBTaG11ZWwgSGF6YW4gd3JvdGU6DQo+ID4g
VGhpcyBwYXRjaCBzZXJpZXMgYWRkcyBzdXBwb3J0IGZvciBQVFAgZXZlbnQgY2FwdHVyZSBvbiB0
aGUgQXJhbWRhDQo+ID4gODB4MC83MHgwLiBUaGlzIGZlYXR1cmUgaXMgbWFpbmx5IHVzZWQgYnkg
dG9vbHMgbGludXggdHMycGhjKDMpIGluIG9yZGVyDQo+ID4gdG8gc3luY2hyb25pemUgYSB0aW1l
c3RhbXBpbmcgdW5pdCAobGlrZSB0aGUgbXZwcDIncyBUQUkpIGFuZCBhIHN5c3RlbQ0KPiA+IERQ
TEwgb24gdGhlIHNhbWUgUENCLg0KPiA+IA0KPiA+IFRoZSBwYXRjaCBzZXJpZXMgaW5jbHVkZXMg
MyBwYXRjaGVzOiB0aGUgc2Vjb25kIG9uZSBpbXBsZW1lbnRzIHRoZQ0KPiA+IGFjdHVhbCBleHR0
cyBmdW5jdGlvbi4NCj4gDQo+IFBsZWFzZSB3YWl0IGF0IGxlYXN0IDI0aCBiZXR3ZWVuIHJlc2Vu
ZHMuDQo+IFBsZWFzZSByZWFkIHRoZSBydWxlczoNCj4gaHR0cHM6Ly93d3cua2VybmVsLm9yZy9k
b2MvaHRtbC9uZXh0L3Byb2Nlc3MvbWFpbnRhaW5lci1uZXRkZXYuaHRtbA0KDQpIaSBKYWt1YiwN
Cg0KU29ycnkgYWJvdXQgaXQuIFRoYW5rcyBmb3IgbGV0dGluZyBtZSBrbm93IGFuZCBsaW5raW5n
IHRoZSBydWxlcy4gDQoNCi0tIFNobXVlbC4gDQo=
