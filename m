Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CD04FE1B1
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355070AbiDLNFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356170AbiDLNDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:03:18 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120072.outbound.protection.outlook.com [40.107.12.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5117C11144;
        Tue, 12 Apr 2022 05:44:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJQEnHSHIiQsrcF99umur+uVLJxDGLCoSMPFIE+UfnDoqGro5CS71YI8YmpWFRyaDZllf/w/4WjW+nAJF956wyxnA7OgdND94B3Z5tIB+VVfq5dg1F6ndSHgRskljOxGgO4VrIB5YNEu2OpG3HDUca0iTcHiWwfx1VY2DxR+1tTbmcg19P13fd0ISSa/fMvrwq8bbJUORH02hywsd59I9FVK0X8Wfmk5DH2BdkhJjfpyhCzJsf6TOwLpedQzxeMl/etlGSPmZnUJ00lLh1249SyCmAblPybEAg/UCZdMw64K4X9+U3W51WWl4x9isvIUbbfH1OJ2fbbJnMNF70y9kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRr4La5g7gfz1Ijao7ott2s8a2Q3JBOjnbde5eMZOaY=;
 b=oM9h3VdRVQhTLVhQoT/YWtRwSXiNI38292XRbdsk8jk9l76f1hJmOf8yn3oCQEtsGs+JXCybO+/ISZfkeT+0o37fdGNFvv948JkMzQuwO2WRyFJK5nktC9iNZ/mqfy+AYZk+rSI2jPvVBPFbntapluK2rj9dOItOulpX6kMeDYm0GkFusnUeFXbJO1ryX0qLaaLyc1ch9uo4xhezDINsfNxvZpR0mfDe91RRyKuqsYZkXENuht4JrGN9F8iBrCKxt88hNBspl9Y+WaskGceNvVENogefjAh4aQ8yArs4tMKRRhcdv75GT+ru2rLIed1gqwmW4Bg6RP7RsxASdauH3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB3713.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:29::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 12:44:05 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c%9]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 12:44:04 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Mans Rullgard <mans@mansr.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Dan Malek <dan@embeddededge.com>,
        Joakim Tjernlund <joakim.tjernlund@lumentis.se>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] net: fs_enet: fix tx error handling
Thread-Topic: [RFC][PATCH] net: fs_enet: fix tx error handling
Thread-Index: AQHYOhZLfutteoVHyEyDssvsMY2EG6zsYc2A
Date:   Tue, 12 Apr 2022 12:44:04 +0000
Message-ID: <346b9fec-f0a4-70d0-529c-32659490df03@csgroup.eu>
References: <20220317153858.20719-1-mans@mansr.com>
In-Reply-To: <20220317153858.20719-1-mans@mansr.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3b64e73-7b34-4f5d-f1b3-08da1c8220e8
x-ms-traffictypediagnostic: MR1P264MB3713:EE_
x-microsoft-antispam-prvs: <MR1P264MB37135B31BFFB155519B68EF0EDED9@MR1P264MB3713.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Myo/TAytXJUo4F8PdOLFeot16CCmO1Vy89Rz2eqFMnQ21zbg3u3UugFFa1ANHYzre/vFuCa5j70Va2mhVuPg2eyBtCVNxAxOEvFDoOiqy7ageRVxHLHNkMhbhLbErMTBrSpT1MNVPmBTSx9qD7W52CWkZsLJK6l/zt4rf9ag1uhBQiXqrSwmHZdfMBntvkQ04CZpbOMdYcQAeiUAEq2Y5YGu6Z88xuU46eN+5OFaXZVUv/g5rmr7WSPOZfKWQQ7PcWjhiNWFUCScF6obC0s3beaijkIv27LELnoQ4WW4NYGhz0QZlSI/+038iekgA0HCqm0Q/DnZZ++ezIYrLZ03lD3Bg8IyuOS1whGIW5KpLmFwc1tkwMQAhno8dwfqAWjqG2oSCrhrCAf7sKrctffXwHxCcITZ809QzYl8u2hdYzv2wY+uleaf6RBGEhMj7M+JSrZAewcs2GwoCO+6S9w1liOXn3ZLT+xKf7n44VAyBLY8cR8Hf0GkUEUnLHysiSHupF3HfXMVZS2H9QKKYjAeMCp+3EC/Daz/mgtZ+zxludcSmr5dFZ4TFqTcctKpInCdzFHvyTs/HrDdyXJocJXco5CactzPv3TJbjyMmbqz11Qhr/oeqxWkIT8osxsgt5i1ePTZJy4MnPi1qnJDx4oGAbg+dCCmHz3mSEq+dOF/8nbU/cO3Os79yKKLeDto4u26YPAvCUglRP2Tg+f2y6yHW1EE3fZShXK3km7VeR+yFOIpAHnetexHZr0Snl50TTHws+0lCa8l9IQJQqbq4ZJcC/7VYRMdhZrKjDfUKcecYp8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(2616005)(5660300002)(26005)(36756003)(186003)(66574015)(508600001)(122000001)(83380400001)(31686004)(38100700002)(86362001)(8936002)(7416002)(71200400001)(44832011)(31696002)(921005)(6506007)(8676002)(6512007)(2906002)(316002)(64756008)(66556008)(66476007)(66946007)(66446008)(76116006)(91956017)(110136005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXpXSEFjQ2kvWGVlaytNY3FJSnJZVnh1dWEvZFlvbmdTUGUzVktsSG94aDg5?=
 =?utf-8?B?MW1uSG50L1lhTitXSVlrbWFlMWNUWXZuTW9kclh1UUMwbXNDMmdmQkl6QTVW?=
 =?utf-8?B?MThVQjN4bUZSbGNPdC9NMEJBZm1oZkovVEpEdi9VR0xWQ1VUVmh3MW14cmt5?=
 =?utf-8?B?WEIwcHJOSmNsZzlXK3U1NzNDemFVN1ladmVpSU5sa3prQU1HNSsvVFprTE5i?=
 =?utf-8?B?SFRqTVkvL1ltejFQNkxxakNLQkd3Vkh5WndwK3pNdmd3SnpQOHJZa1B3ZlZr?=
 =?utf-8?B?a3pQTmdxZVBDWG5GdnJuUmJ5czc3YWRmTk83MDE5MFB6S3dSTlpkTis1bCt6?=
 =?utf-8?B?RG04MVV6YnlTc3dSQUE0SzNZaUd2cENrL0Nrc1ZmdHBKK1cvSS9wVWVjRlFN?=
 =?utf-8?B?TmgyN3MvWlJSWUM0ZG9keUlSNE9XUk9RZjd5M1FpK0RwMFczMG5RbWxQRkVT?=
 =?utf-8?B?T1hNMFF6ckwvSjdrSkRNTm84a3lndFhJejNUVzRmSFhBRUdHWFRGT3VsZWFG?=
 =?utf-8?B?NzNCaEZzTS9vSDR6Ykl2N1VKOUtaWThyOVhmUEdIVlB6WjRYUEVUM3BOc084?=
 =?utf-8?B?emhUMWp4SEFneUhqNnh6VEhRRlZweGRFUnJEZ0kyWFNXcDNFd25LZFV1bHk0?=
 =?utf-8?B?MFg1UlBsR0djek5GazBTQmE2OWVmTXJFQ1A1N1lHY0tjK0JoYnIvOWFmV1d6?=
 =?utf-8?B?ODI3eitzV1FZNjRMV2xFM2p6YjJLR1FYYTBkN2c4SkZJU1I1c3FXZTNjN1Rw?=
 =?utf-8?B?dTJlVjdraU5MVisxUnFXWk02MzVJdW9XSGlDNnJ1OXhxeUQ1UURENU0rdGZM?=
 =?utf-8?B?WjF1UDd4VFQ2bDNTTG9EODNRcTgxSDA2VTVtK3oxSnlMS0JRZHFOakFuK3Q0?=
 =?utf-8?B?K1Q1MmkzR3FGeHBGQ1oxZ0p3d0VvVkJsV3RsamNOM3J6VXB4ZXFZL2xJQWpi?=
 =?utf-8?B?Wnh6QjZzSTF3VXFia04wblRqUG81UHlNcGFOS0xSWlJISjBid3AzWHF4Vk1a?=
 =?utf-8?B?a3RhWFpFZVY0QkVyeUx5N09xMzJ3ZVc2dnAySEd6bzczZHhHZVlZUG5JQjVy?=
 =?utf-8?B?aTc1ZkdndUFTMkZrbm96WktYN01kOXBXZUE2ZkdpVUl6Y2h4dFQxeW13WFNC?=
 =?utf-8?B?bVNlMGtiei9YM0ZQcFBsRGpscXl6Q05hNHJ0TUhvZHJzUWkxZGVrUUh2K2lv?=
 =?utf-8?B?aEtGQzE5UXVWOWcvN25FQmIyK01HMkIvc1FlM0M2NFhaelJMQXJCQ2FkOUJQ?=
 =?utf-8?B?d08xNmtwYUoxQlZjREJTSVNVeVl1MW0xeXFXQmtBQ2F2NzdRcHE4c3QvRGgw?=
 =?utf-8?B?bjgwYmVBa0FTZUdCZ1JsQWx2ZzJqL2tibXpJbTFFVEs3cWk1M1FSRkFUTENz?=
 =?utf-8?B?M3RKakV4Z05rRVNiNFZrRDBjSEJvc3hEQnUyTFk4VDJrbzR2cTZML3FpYmt6?=
 =?utf-8?B?dThzN0hKYVV0NkFQb3cwNGlwU1FBVkhUM3FWQnlEd3NlUDJ3VFBTYlAxaERD?=
 =?utf-8?B?SHVraE4yd2pGTm55ZUxybVRtejNTNlhQL0dPTUE4NlhVWForUDhuK2R3MXFI?=
 =?utf-8?B?TEVkd1E3ek5SWGZqS2g5Z0hHMXlHSXVxZ2h5Z24zTmV6SzNZajZiSDFJaU1Y?=
 =?utf-8?B?UisxTFlYTmFzQ2ZMVXd6K1FLRlVNaThSdHJXZytoTGc5YU54NndjVFpQUU9o?=
 =?utf-8?B?ZEtrYzlQMkhhU205Y3FBc2M2cm94SFVOeXJoeWUvZXdlVVBLaTRCS1hxWGhK?=
 =?utf-8?B?QmJtYlZlUkxyMWtCdEFnSUt1T2NudUF0WEhrWFdUQm1VVk1wV0UvL0RlWXY4?=
 =?utf-8?B?M0Zxb2dlUnNIZWdFU1QySjBoZFBKSkpGZGgveHpXb280b21sZ250Z0djYTJZ?=
 =?utf-8?B?WnJqYWVOUENoRGdIRWw4UFZvM0thNXZGbVl0dUo2TWo1L1NkcWZSVzdoQm5E?=
 =?utf-8?B?Kzl6Sm5IWEQ1di9GSGxzTTRMaForSE1wc1MraXAycVpFYjl6MnA0MGdsVGVm?=
 =?utf-8?B?Wkd3cFpjZWxjaEhINWRqQURPaFVQcGxDWFJ5N1dVMTBEVWNJYUEram9OejlO?=
 =?utf-8?B?cDRPVVRUTUNuNk5DZ0NkUXY4VVoxdWQzRTBMTkFRRzZ3ZmpER0pJckprcmtQ?=
 =?utf-8?B?UkR4Ky90Ri9UeHplTml5LzMxbWF4aVdCcXVQRVFSWEFsKzYxcDMrU3BMeDQx?=
 =?utf-8?B?c3VncjNIK0FiYlhOWUJjRnlpLzVWWUVkcGc4MHpkcHlaaFhDQTdkVU9URVE5?=
 =?utf-8?B?cm85VnViek1OS3BRRHhoWGk2VnpTMlFmMEZXYkZXREYyUUova0VqSURhTUVH?=
 =?utf-8?B?cmhwQkVtem04ZURlVnVITEN3dG5aOERxNTMweHV0Qll3RDBNejh4cXIzUEF1?=
 =?utf-8?Q?3aWPjPDYhgzFv1Y5TflfOEjUJinohtI55n0L0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B75309C6C747642B486EFC097385193@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b64e73-7b34-4f5d-f1b3-08da1c8220e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 12:44:04.9184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lJjLizPJ9C8/VieIrr5wO2UPI3Cb3rSKcE7KvD1Tuu1wTJPriwa4oVMfy2LdEfM6b7rgaWD1mo0RqJWUYQfwNpgOEpdGiDiyhxne5t8b05M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3713
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDE3LzAzLzIwMjIgw6AgMTY6MzgsIE1hbnMgUnVsbGdhcmQgYSDDqWNyaXTCoDoNCj4g
SW4gc29tZSBjYXNlcywgdGhlIFRYRSBmbGFnIGlzIGFwcGFyZW50bHkgc2V0IHdpdGhvdXQgYW55
IGVycm9yDQo+IGluZGljYXRpb24gaW4gdGhlIGJ1ZmZlciBkZXNjcmlwdG9yIHN0YXR1cy4gV2hl
biB0aGlzIGhhcHBlbnMsIHR4DQo+IHN0YWxscyB1bnRpbCB0aGUgdHhfcmVzdGFydCgpIGZ1bmN0
aW9uIGlzIGNhbGxlZCB2aWEgdGhlIGRldmljZQ0KPiB3YXRjaGRvZyB3aGljaCBjYW4gdGFrZSBh
IGxvbmcgdGltZS4NCg0KSXMgdGhlcmUgYW4gZXJyYXRhIGZyb20gTlhQIGFib3V0IHRoaXMgPw0K
DQpEaWQgeW91IHJlcG9ydCB0aGUgaXNzdWUgdG8gdGhlbSA/IFdoYXQgZmVlZGJhY2sgZGlkIHlv
dSBnZXQgPw0KDQo+IA0KPiBUbyBmaXggdGhpcywgY2hlY2sgZm9yIFRYRSBpbiB0aGUgbmFwaSBw
b2xsIGZ1bmN0aW9uIGFuZCB0cmlnZ2VyIGENCj4gdHhfcmVzdGFydCgpIGNhbGwgYXMgZm9yIGVy
cm9ycyByZXBvcnRlZCBpbiB0aGUgYnVmZmVyIGRlc2NyaXB0b3IuDQoNCkknbSBub3Qgc3VyZSB0
byB1bmRlcnN0YW5kLiBZb3UgY2hhbmdlIHNlZW1zIHRvIGRvIGEgbG90IG1vcmUgdGhhbiB0aGF0
LiANCkVzcGVjaWFsbHkgaXQgY2hhbmdlcyB0byBsb2NhdGlvbiBvZiB0aGUgaGFuZGxpbmcgb2Yg
ZXJyb3JzLiBQcmV2aW91c2x5IA0KZXJyb3JzIHdoZXJlIGhhbmRsZWQgaW4gaW50ZXJydXB0IHJv
dXRpbmUuIE5vdyBpdCdzIGhhbmRsZWQgaW4gdGhlIG5hcGkgDQpwb2xsIHJvdXRpbmUuIFlvdSBo
YXZlIHRvIGV4cGxhaW4gYWxsIHRoYXQuDQoNCj4gDQo+IFRoaXMgY2hhbmdlIG1ha2VzIHRoZSBG
Q0MgYmFzZWQgRXRoZXJuZXQgY29udHJvbGxlciBvbiBNUEM4Mnh4IGRldmljZXMNCj4gdXNhYmxl
LiBJdCBwcm9iYWJseSBicmVha3MgdGhlIG90aGVyIG1vZGVzIChGRUMsIFNDQykgd2hpY2ggSSBo
YXZlIG5vDQo+IHdheSBvZiB0ZXN0aW5nLg0KDQpZb3Ugc2hvdWxkIGF0IGxlYXN0IGNoYW5nZSBt
YWMtc2NjLmggYW5kIG1hYy1mZWMuaCB0byBtYXRjaCB0aGUgY2hhbmdlcyANCnlvdSBkaWQgaW4g
bWFjLWZjYy5oDQoNClRoaXMgd291bGQgYWxsb3cgbWUgdG8gYXQgbGVhc3QgdGVzdCB0aGUgRkVD
IG9uZS4NCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWFucyBSdWxsZ2FyZCA8bWFuc0BtYW5zci5j
b20+DQo+IC0tLQ0KPiAgIC4uLi9ldGhlcm5ldC9mcmVlc2NhbGUvZnNfZW5ldC9mc19lbmV0LW1h
aW4uYyB8IDQ3ICsrKysrKystLS0tLS0tLS0tLS0NCj4gICAuLi4vbmV0L2V0aGVybmV0L2ZyZWVz
Y2FsZS9mc19lbmV0L21hYy1mY2MuYyAgfCAgMiArLQ0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgMTkg
aW5zZXJ0aW9ucygrKSwgMzAgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZzX2VuZXQvZnNfZW5ldC1tYWluLmMgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZnNfZW5ldC9mc19lbmV0LW1haW4uYw0KPiBpbmRleCA3
OGUwMDhiODEzNzQuLjQyNzZiZWNkMDdjZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZnJlZXNjYWxlL2ZzX2VuZXQvZnNfZW5ldC1tYWluLmMNCj4gKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZzX2VuZXQvZnNfZW5ldC1tYWluLmMNCj4gQEAgLTk0LDE0
ICs5NCwyMiBAQCBzdGF0aWMgaW50IGZzX2VuZXRfbmFwaShzdHJ1Y3QgbmFwaV9zdHJ1Y3QgKm5h
cGksIGludCBidWRnZXQpDQo+ICAgCWludCBjdXJpZHg7DQo+ICAgCWludCBkaXJ0eWlkeCwgZG9f
d2FrZSwgZG9fcmVzdGFydDsNCj4gICAJaW50IHR4X2xlZnQgPSBUWF9SSU5HX1NJWkU7DQo+ICsJ
dTMyIGludF9ldmVudHM7DQo+ICAgDQo+ICAgCXNwaW5fbG9jaygmZmVwLT50eF9sb2NrKTsNCj4g
ICAJYmRwID0gZmVwLT5kaXJ0eV90eDsNCj4gKwlkb193YWtlID0gZG9fcmVzdGFydCA9IDA7DQo+
ICsNCj4gKwlpbnRfZXZlbnRzID0gKCpmZXAtPm9wcy0+Z2V0X2ludF9ldmVudHMpKGRldik7DQo+
ICsNCj4gKwlpZiAoaW50X2V2ZW50cyAmIGZlcC0+ZXZfZXJyKSB7DQo+ICsJCSgqZmVwLT5vcHMt
PmV2X2Vycm9yKShkZXYsIGludF9ldmVudHMpOw0KPiArCQlkb19yZXN0YXJ0ID0gMTsNCj4gKwl9
DQo+ICAgDQo+ICAgCS8qIGNsZWFyIHN0YXR1cyBiaXRzIGZvciBuYXBpKi8NCj4gICAJKCpmZXAt
Pm9wcy0+bmFwaV9jbGVhcl9ldmVudCkoZGV2KTsNCj4gICANCj4gLQlkb193YWtlID0gZG9fcmVz
dGFydCA9IDA7DQo+ICAgCXdoaWxlICgoKHNjID0gQ0JEUl9TQyhiZHApKSAmIEJEX0VORVRfVFhf
UkVBRFkpID09IDAgJiYgdHhfbGVmdCkgew0KPiAgIAkJZGlydHlpZHggPSBiZHAgLSBmZXAtPnR4
X2JkX2Jhc2U7DQo+ICAgDQo+IEBAIC0zMTgsNDMgKzMyNiwyNCBAQCBmc19lbmV0X2ludGVycnVw
dChpbnQgaXJxLCB2b2lkICpkZXZfaWQpDQo+ICAgew0KPiAgIAlzdHJ1Y3QgbmV0X2RldmljZSAq
ZGV2ID0gZGV2X2lkOw0KPiAgIAlzdHJ1Y3QgZnNfZW5ldF9wcml2YXRlICpmZXA7DQo+IC0JY29u
c3Qgc3RydWN0IGZzX3BsYXRmb3JtX2luZm8gKmZwaTsNCj4gICAJdTMyIGludF9ldmVudHM7DQo+
IC0JdTMyIGludF9jbHJfZXZlbnRzOw0KPiAtCWludCBuciwgbmFwaV9vazsNCj4gLQlpbnQgaGFu
ZGxlZDsNCj4gICANCj4gICAJZmVwID0gbmV0ZGV2X3ByaXYoZGV2KTsNCj4gLQlmcGkgPSBmZXAt
PmZwaTsNCj4gICANCj4gLQluciA9IDA7DQo+IC0Jd2hpbGUgKChpbnRfZXZlbnRzID0gKCpmZXAt
Pm9wcy0+Z2V0X2ludF9ldmVudHMpKGRldikpICE9IDApIHsNCj4gLQkJbnIrKzsNCj4gKwlpbnRf
ZXZlbnRzID0gKCpmZXAtPm9wcy0+Z2V0X2ludF9ldmVudHMpKGRldik7DQo+ICsJaWYgKCFpbnRf
ZXZlbnRzKQ0KPiArCQlyZXR1cm4gSVJRX05PTkU7DQo+ICAgDQo+IC0JCWludF9jbHJfZXZlbnRz
ID0gaW50X2V2ZW50czsNCj4gLQkJaW50X2Nscl9ldmVudHMgJj0gfmZlcC0+ZXZfbmFwaTsNCj4g
KwlpbnRfZXZlbnRzICY9IH5mZXAtPmV2X25hcGk7DQo+ICAgDQo+IC0JCSgqZmVwLT5vcHMtPmNs
ZWFyX2ludF9ldmVudHMpKGRldiwgaW50X2Nscl9ldmVudHMpOw0KPiAtDQo+IC0JCWlmIChpbnRf
ZXZlbnRzICYgZmVwLT5ldl9lcnIpDQo+IC0JCQkoKmZlcC0+b3BzLT5ldl9lcnJvcikoZGV2LCBp
bnRfZXZlbnRzKTsNCj4gLQ0KPiAtCQlpZiAoaW50X2V2ZW50cyAmIGZlcC0+ZXYpIHsNCj4gLQkJ
CW5hcGlfb2sgPSBuYXBpX3NjaGVkdWxlX3ByZXAoJmZlcC0+bmFwaSk7DQo+IC0NCj4gLQkJCSgq
ZmVwLT5vcHMtPm5hcGlfZGlzYWJsZSkoZGV2KTsNCj4gLQkJCSgqZmVwLT5vcHMtPmNsZWFyX2lu
dF9ldmVudHMpKGRldiwgZmVwLT5ldl9uYXBpKTsNCj4gLQ0KPiAtCQkJLyogTk9URTogaXQgaXMg
cG9zc2libGUgZm9yIEZDQ3MgaW4gTkFQSSBtb2RlICAgICovDQo+IC0JCQkvKiB0byBzdWJtaXQg
YSBzcHVyaW91cyBpbnRlcnJ1cHQgd2hpbGUgaW4gcG9sbCAgKi8NCj4gLQkJCWlmIChuYXBpX29r
KQ0KPiAtCQkJCV9fbmFwaV9zY2hlZHVsZSgmZmVwLT5uYXBpKTsNCj4gLQkJfQ0KPiArCSgqZmVw
LT5vcHMtPmNsZWFyX2ludF9ldmVudHMpKGRldiwgaW50X2V2ZW50cyk7DQo+ICAgDQo+ICsJaWYg
KG5hcGlfc2NoZWR1bGVfcHJlcCgmZmVwLT5uYXBpKSkgew0KPiArCQkoKmZlcC0+b3BzLT5uYXBp
X2Rpc2FibGUpKGRldik7DQo+ICsJCV9fbmFwaV9zY2hlZHVsZSgmZmVwLT5uYXBpKTsNCj4gICAJ
fQ0KPiAgIA0KPiAtCWhhbmRsZWQgPSBuciA+IDA7DQo+IC0JcmV0dXJuIElSUV9SRVRWQUwoaGFu
ZGxlZCk7DQo+ICsJcmV0dXJuIElSUV9IQU5ETEVEOw0KPiAgIH0NCj4gICANCj4gICB2b2lkIGZz
X2luaXRfYmRzKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZnNfZW5ldC9tYWMtZmNjLmMgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZnNfZW5ldC9tYWMtZmNjLmMNCj4gaW5kZXggYjQ3NDkwYmU4NzJj
Li42NmM4ZjgyYTgzMzMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVz
Y2FsZS9mc19lbmV0L21hYy1mY2MuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVl
c2NhbGUvZnNfZW5ldC9tYWMtZmNjLmMNCj4gQEAgLTEyNCw3ICsxMjQsNyBAQCBzdGF0aWMgaW50
IGRvX3BkX3NldHVwKHN0cnVjdCBmc19lbmV0X3ByaXZhdGUgKmZlcCkNCj4gICAJcmV0dXJuIHJl
dDsNCj4gICB9DQo+ICAgDQo+IC0jZGVmaW5lIEZDQ19OQVBJX0VWRU5UX01TSwkoRkNDX0VORVRf
UlhGIHwgRkNDX0VORVRfUlhCIHwgRkNDX0VORVRfVFhCKQ0KPiArI2RlZmluZSBGQ0NfTkFQSV9F
VkVOVF9NU0sJKEZDQ19FTkVUX1JYRiB8IEZDQ19FTkVUX1JYQiB8IEZDQ19FTkVUX1RYQiB8IEZD
Q19FTkVUX1RYRSkNCj4gICAjZGVmaW5lIEZDQ19FVkVOVAkJKEZDQ19FTkVUX1JYRiB8IEZDQ19F
TkVUX1RYQikNCj4gICAjZGVmaW5lIEZDQ19FUlJfRVZFTlRfTVNLCShGQ0NfRU5FVF9UWEUpDQo+
ICAg
