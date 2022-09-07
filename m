Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9945B0524
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 15:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiIGNal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 09:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiIGNaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 09:30:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2109.outbound.protection.outlook.com [40.107.223.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DED72EC3;
        Wed,  7 Sep 2022 06:30:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdAY1ePR48xrHGw4siljQf8pX2nHR/1w3QMxXQSIUzrmjzLqQXsbq2uxx40vc+yONJ2wM3KxhMsBzYtPaBppHshGqaYQNGGVccwrs0MbJLmDPsmHLMR9FNZ0njEJS6Tk7dsrqbH9r3h/7fbytYIDEKYntqrJ4C3nFH71Uc1io3gbXK5AXx6aAoNO5dA5O723/SlfUm1sfmOyzE2y0Mm3H8DDA4MqbbVdhRuuUXtv/aSZyG5A71TOJ+V/g8P26Ro87JBQxZNKSziFzLuZmpSju764Sj3km/p5G4tKRYv41yn7G1cRwRqA3m9rDdxSaDHqWtWvNu4B1Knj71BSSehIkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOG6YvjTerKWQiPDLdIv3rwv7Z0Qt1TtCgQiy0+3vu8=;
 b=Mo7dDDRiMRhrQsYtiIzeixQ8x/gBRtUE9jTq2qb0IPK4fG90IYOOehJo5EjJZDlIBj1sb4BagRGf1X78LJ/FrhOpQjDLdMM6P+N19oD2URZQ7Ubapu2UCxtoua2gDq7By1W3wgm9JkzwSVhbYicZEcDYnEVptnHh946wHx0o4+1cY2yF7mi3Ffvb8MiHLKnfkDPYnhIF2Nvmi0yAvzR0ht5ROWi5ygjpF66tKWjP7eQvCxD0btLS+TlydOHZ/a8moyw22JQfD8XWE+Vivi6ESgDf9TrZEnhXE0XGQN699WahykkN7RB6ndImECxv1DyLdQ1DDbXdmnr9kA4cl+SKeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOG6YvjTerKWQiPDLdIv3rwv7Z0Qt1TtCgQiy0+3vu8=;
 b=UQ/uH40zndMzuNm1210DLquoTl4pVJyvvMNoCAU9Z8M3pJg2tgyNqOqo1eAAKn8BC8cZC8LKQm1QRcSv50Su5qyy4r4YgoldYHMNFeCKY4IuHglfjJdMpws/WdUazCR5gqAmjO1GCfQIae6QfWdGHWIlVLMxXaj16qoG4M9jLTk=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by CO1PR13MB4886.namprd13.prod.outlook.com (2603:10b6:303:f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 7 Sep
 2022 13:30:30 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::f1c7:62d0:a63d:f5ca]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::f1c7:62d0:a63d:f5ca%3]) with mapi id 15.20.5612.012; Wed, 7 Sep 2022
 13:30:30 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "niejianglei2021@163.com" <niejianglei2021@163.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "anna@kernel.org" <anna@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Fix potential memory leak in
 xs_udp_send_request()
Thread-Topic: [PATCH] SUNRPC: Fix potential memory leak in
 xs_udp_send_request()
Thread-Index: AQHYwolqSwDQaGcF60Gtp3AbmUEwn63TvnaAgAA4cwA=
Date:   Wed, 7 Sep 2022 13:30:30 +0000
Message-ID: <9bb5ce3a9949b8a51fcacc52e42ff529a9f04b3f.camel@hammerspace.com>
References: <20220907071338.56969-1-niejianglei2021@163.com>
         <1e0877bc528f3e9218f0070889c7288a8aaa47ba.camel@kernel.org>
In-Reply-To: <1e0877bc528f3e9218f0070889c7288a8aaa47ba.camel@kernel.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR13MB5084:EE_|CO1PR13MB4886:EE_
x-ms-office365-filtering-correlation-id: b7d41beb-d52b-4f36-6feb-08da90d5223f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C1KR2H9r/1yLE8paJhbfu7DBlZfDAqrpkgPV7W7lm3uK2vFGBxQBsrOrxbqrYCuDVcjs3jIXt7ih0R6ZEjIxkbxrranqd/j3On32rehXieIcblMgGbLcV+t1rCxC/puRhqqE8QR8tP4Y3C4ypgvPxYaIR0mHBSrHEAeTG57d8aOcuAMZoAareYogZochnYWjW66W0BAuXPaODjVhSALNUL+jLbvBwHDZ3GGZhCweTu1ySFC2ch9ZvXkvLliO0xhUZ97oLXW11onFMJl0Md2ung93o4M1ZDYwdyX1A5FaqfeAeHhf5N5bSzfF/zrYWNahsG7ir2V9uSA1fKU64BRq5d3RF8oFzade7EgHbPXwTaT+bFhrOZSQVLmnQf37VJZ9kUalpcU/arhMM1obUyrzxHqxDGEnLk9Nj3BsZxlevGBfNZMZzd0rl8v7rkrCPmSRKYAzrbqAULtRsNS5YdWTMyQqTCIyOqtsjgJZfCIzxLnA0ZTCF7qTW2VK5RL6HflPGI5qSUg8Rj5yqhRpUhuC4BGOuM1oY2TuqbwwHm9N8Hdbcl6O4IGiWFuYBnHtidmAl+nTOKXNYYxjciNnkjDy4yzF2ec4lCblNrnnUIUe01hvS+UgyZhRhVkEl8drBTsdiltzHQZqHpZWJSAo2EbFK53resJ1po5wOLRX1uRBzLBjUanZka3pjpqIPEtLz/SIwZiR9Kb5dQ1ql8R1rVarRa0LhMM4c6b8L4sJPFl5WtP4DbZU8CdwbkuPORk9OLlSKJlCnjEQG7MZfgU6jQmk8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(376002)(136003)(39840400004)(396003)(6506007)(6512007)(26005)(71200400001)(41300700001)(478600001)(6486002)(83380400001)(2616005)(186003)(2906002)(7416002)(8936002)(5660300002)(110136005)(54906003)(316002)(76116006)(4326008)(8676002)(64756008)(66946007)(66556008)(66476007)(66446008)(38100700002)(86362001)(38070700005)(36756003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjNua2ZSaGlLdlRJU3JDZDFYamtPbnBVY29hYWhzMTdWMkR3QXZ4YXNlVHJq?=
 =?utf-8?B?VEw2cVFpTm4wRDgxYUJDT0dIWkxYWG1ybHQyZXo4U0xCdTI1Y3ByQWd6YVZO?=
 =?utf-8?B?SVFObVMvcTVsaFVqMDVOSVh6UHJ2S3VYTlRpTlVzUzdrRnNYUFNES1FtclB3?=
 =?utf-8?B?T2NaUmFNZ3MzeTVLMEpCei84NnJzM0k2aklHamtiN0tENi8waWlvK0VvK1VD?=
 =?utf-8?B?SDBhRnB1bnZUSTljTi9zU2hXaUFCek9JZmJzMEpIR3pKMmxpL3BhVHZaa0hB?=
 =?utf-8?B?UTI1WGF6MTZmYjBES1MrSXlBb0VyRm9ORkFjeEFBUUFmVmk4b2RpaERPSzF0?=
 =?utf-8?B?R25TNktuYllPUWFKNWxnR1dCaFNoN01WTVdkRzlhWmVJSjBLOFhZdVNmK2Nm?=
 =?utf-8?B?VlZlZVZaeFVDeHRLNlhjUnBkNUVoS0VJNU9LYm15KzVLaXowSHdDazF1djBC?=
 =?utf-8?B?QjV1Mk9kQ0UwSlNwYXgvdlpwWTIzMzJPdHo0dzFnQjNRbUk3UWM0Vi96c2ZY?=
 =?utf-8?B?WC9hSkh3b2Y4cURvcDNSaTZJQXNUODNBTm9Sd3JjNEJ5TFV6Z3FQYXZyVndk?=
 =?utf-8?B?NzRlOEJYSWRkS2VIQjNwNVIwNE5TL0E5Ynl2SCtBTFY4SWQ0cDNmaFhic1hZ?=
 =?utf-8?B?OFBORUN2VFQzcWVYVGpvS0Fpa1ovb1l2eWhFU2hBUEVtSUdkSjIyWnNzRXQ4?=
 =?utf-8?B?VU9HZ1lZN3M0TlluNVJYaWZLa0tGZEZCcVJ5cnBQQ2ZiMXJnZTdPblo4S1JD?=
 =?utf-8?B?SDkrZlZoK0hHbndVaHhXdlNiZlAxY2hOdFNGTjliTjNHbVhYdGlmNEdsWkRN?=
 =?utf-8?B?dG1lWDJjUElIZUlwWWNyUHRMR2xjQnZiOUNNT2RDYktTUGc5T2w5dUtYVC9C?=
 =?utf-8?B?MFVUemJZcTRYb0hNT093enZ2Yk5FcklpMmlJaEJSc0NySlhLUTJVMUkrajRu?=
 =?utf-8?B?WWNkdTh1UDAycXZuK3lzRG1SMXpoTkZTNVpMdmNYWkZLTTFJbkFZcGFBb1do?=
 =?utf-8?B?VmtKUDVJZGgrYU5RRlNHQzI4Q1MwNHRZaWxZWm1vbDk2TVdLQ05oTmp0Z25E?=
 =?utf-8?B?Y1R1SmVIbkQzOVh4WXpSY1ZpRER5bSthZVQrT3R0ZkpLNFFIbTlDRk5JRlc5?=
 =?utf-8?B?UGpEUEZQQ0IwVWVyekV0aDJEUXFRU0NSSGFGcmRxWE9OSHdFcnJ1Q3VVTVNZ?=
 =?utf-8?B?SzN1bURicHpTbjhoV2xHRklFZTRVRER6T3dOVFR3NmUxVnBEOHA0N2hNWUhE?=
 =?utf-8?B?S0duV1JUTURaN0g5c3gxVGJscW9zcFd0bHFxSUZUZXE2RUZadDZ1dER0UGov?=
 =?utf-8?B?RDZCREFXWTN3L05CQmpxaGpobFBlTDdIaFBIZGFFUjVQeWVNeHlIeHdCaHh5?=
 =?utf-8?B?RkovM0NWWHQ4NE9GWEhPRXNmNTYyb3pmVEhudStUZWxXcU5reVloOTUxOGhN?=
 =?utf-8?B?bjY0dE0wR0l5Ujk3bTV3b0JzSWdFUjF0OFAydVZYS3IyRmFRdm4wNDhHejhV?=
 =?utf-8?B?VHNCNzhPOVo0SGlxZFZGRGRDbU00RW9sVU9maTVhdWZKTTR5cWdNOFBHZXd2?=
 =?utf-8?B?Z0FPMVE1aExhWlJ2Tmx4cTQ0c2daRkZFdTBJUmtGSXZGTWlYWUJLUmI5aDVQ?=
 =?utf-8?B?bTBXektRZTg4cFh3bkNRdnVjV2JhMjF1REZVblNPK1JHVFJRMHdTaFIyeHps?=
 =?utf-8?B?WDNTWUcyY2FhbW9sUEZwR1A2TjZQcU54d0g5ZTRYdVAyVXZuV1NZVlQvS1Jz?=
 =?utf-8?B?aWhDWHdMaHZSL1N3dVVaVDR3U0IydzNKVTVVRk9uUUhhd1hTRWVsQm5lUFlu?=
 =?utf-8?B?R0xiUyswUjc5d2xBeUZzUW5ZOXh5RmtOQUVOaFovSGNMeHhEeUhETm5KdzQz?=
 =?utf-8?B?WHFremZvS3hTeFJhTlp3ekZwVUJmbkpBbndrWFlEN1VVNENKTlRPYUUwZCs2?=
 =?utf-8?B?cU9USmVEcTROWC95ayttT3FZREk5RWxhTmU0MG9zcjAxaFA0MUNtUXRtTzBO?=
 =?utf-8?B?V1NhRE9VR3NmNjJQYTRNSnFlMUJsaVNjVGtBeC9oL2dBLzZCWi95a2ozcjFB?=
 =?utf-8?B?TWhrTzhaN1lObXdjMCsyYnlSUGFIcTd1UmJzRHppc0lFUjdWeEI2dHVnb2lQ?=
 =?utf-8?B?bVo4ay8reDhjdVVIU1hJN1lKMEFJMzlxODlna3ZKVHQ3dWJSY2JQN3N5eTRS?=
 =?utf-8?B?S1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A53FC8EBADBCBB44AFD08D12C6081525@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4886
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTA5LTA3IGF0IDA2OjA4IC0wNDAwLCBKZWZmIExheXRvbiB3cm90ZToNCj4g
T24gV2VkLCAyMDIyLTA5LTA3IGF0IDE1OjEzICswODAwLCBKaWFuZ2xlaSBOaWUgd3JvdGU6DQo+
ID4geHNfdWRwX3NlbmRfcmVxdWVzdCgpIGFsbG9jYXRlcyBhIG1lbW9yeSBjaHVuayBmb3IgeGRy
LT5idmVjIHdpdGgNCj4gPiB4ZHJfYWxsb2NfYnZlYygpLiBXaGVuIHhwcnRfc29ja19zZW5kbXNn
KCkgZmluaXNocywgeGRyLT5idmVjIGlzDQo+ID4gbm90DQo+ID4gcmVsZWFzZWQsIHdoaWNoIHdp
bGwgbGVhZCB0byBhIG1lbW9yeSBsZWFrLg0KPiA+IA0KPiA+IHdlIHNob3VsZCByZWxlYXNlIHRo
ZSB4ZHItPmJ2ZWMgd2l0aCB4ZHJfZnJlZV9idmVjKCkgYWZ0ZXINCj4gPiB4cHJ0X3NvY2tfc2Vu
ZG1zZygpIGxpa2UgYmNfc2VuZHRvKCkgZG9lcy4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBK
aWFuZ2xlaSBOaWUgPG5pZWppYW5nbGVpMjAyMUAxNjMuY29tPg0KPiA+IC0tLQ0KPiA+IMKgbmV0
L3N1bnJwYy94cHJ0c29jay5jIHwgMSArDQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvbmV0L3N1bnJwYy94cHJ0c29jay5jIGIvbmV0
L3N1bnJwYy94cHJ0c29jay5jDQo+ID4gaW5kZXggZTk3NjAwN2Y0ZmQwLi4yOTgxODJhM2MxNjgg
MTAwNjQ0DQo+ID4gLS0tIGEvbmV0L3N1bnJwYy94cHJ0c29jay5jDQo+ID4gKysrIGIvbmV0L3N1
bnJwYy94cHJ0c29jay5jDQo+ID4gQEAgLTk1OCw2ICs5NTgsNyBAQCBzdGF0aWMgaW50IHhzX3Vk
cF9zZW5kX3JlcXVlc3Qoc3RydWN0IHJwY19ycXN0DQo+ID4gKnJlcSkNCj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBzdGF0dXM7DQo+ID4gwqDCoMKgwqDCoMKgwqDC
oHJlcS0+cnFfeHRpbWUgPSBrdGltZV9nZXQoKTsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgc3RhdHVz
ID0geHBydF9zb2NrX3NlbmRtc2codHJhbnNwb3J0LT5zb2NrLCAmbXNnLCB4ZHIsIDAsDQo+ID4g
MCwgJnNlbnQpOw0KPiA+ICvCoMKgwqDCoMKgwqDCoHhkcl9mcmVlX2J2ZWMoeGRyKTsNCj4gPiDC
oA0KPiA+IMKgwqDCoMKgwqDCoMKgwqBkcHJpbnRrKCJSUEM6wqDCoMKgwqDCoMKgIHhzX3VkcF9z
ZW5kX3JlcXVlc3QoJXUpID0gJWRcbiIsDQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgeGRyLT5sZW4sIHN0YXR1cyk7DQo+IA0KPiBJIHRoaW5rIHlv
dSdyZSBwcm9iYWJseSBjb3JyZWN0IGhlcmUuDQo+IA0KPiBJIHdhcyB0aGlua2luZyB3ZSBtaWdo
dCBoYXZlIGEgc2ltaWxhciBidWcgaW4gc3ZjX3RjcF9zZW5kbXNnLCBidXQgaXQNCj4gbG9va3Mg
bGlrZSB0aGF0IG9uZSBnZXRzIGZyZWVkIGluIHN2Y190Y3Bfc2VuZHRvLg0KPiANCj4gUmV2aWV3
ZWQtYnk6IEplZmYgTGF5dG9uIDxqbGF5dG9uQGtlcm5lbC5vcmc+DQoNCk5vLCB0aGlzIHBhdGNo
IGlzIHVubmVjZXNzYXJ5IGFuZCB3b24ndCBiZSBhcHBsaWVkLiBXZSBhbHJlYWR5IGRvIHRoaXMN
CmZvciBhbGwgdHJhbnNwb3J0cyBpbiB4cHJ0X3JlcXVlc3RfZGVxdWV1ZV90cmFuc21pdCgpLg0K
DQotLSANClRyb25kIE15a2xlYnVzdA0KTGludXggTkZTIGNsaWVudCBtYWludGFpbmVyLCBIYW1t
ZXJzcGFjZQ0KdHJvbmQubXlrbGVidXN0QGhhbW1lcnNwYWNlLmNvbQ0KDQoNCg==
