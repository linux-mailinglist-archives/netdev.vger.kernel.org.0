Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F278857C2EA
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 05:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiGUDoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 23:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiGUDod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 23:44:33 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04olkn2063.outbound.protection.outlook.com [40.92.45.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD347822B;
        Wed, 20 Jul 2022 20:44:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dx0tcWOyQQhpiyt955PGPO/l0YFKZ+imNjSncN1SLaegktG3OwFl3RDYktXnNYJpmpcgG4LmPZCOhUN+/Au6AjeiZYly6ARU8PwBfs0zrZxAT4BzA+e8zrNr2DWXV4UCmaWx4EhGwImhN0kak7rbRFw48gtSP7eTklAcSfHdz12P+JYQ64hA+BaGDpgD5d1bgoQ5ogmfsEmP1zTOmWmVc4jM3FQdv2derl7f1qhQC63Kf7IWZgX4Y9HSnwYZHMkrGRe3BdSCiYBc+QCSBfFfw7Ssmfw+lZ5V031FISzIobrulm5czcqzkLNygetHhFTyPOkJWnltATa8Z54AgP4YTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bVvVIpZSYOQFr8xdIrSiLpYI0Tmgvw8NHr53m+gYclM=;
 b=ATc9rh4XhwGCWhZ+A8HgwpTbOzMImGRixlILS06yz0Xs26OHjWmNSyeWj+7bM8XInqRVm8uW0TtEJB9Rik5ZTidITNt/JhniPhDnqUuFG65BGfTbL11FtPf7oMY7jUM5Ozd61eyMM6oaVVKjyjXMIWe8XxkRb2towvq2zsmf7i1H946GRuqL4SrVmy8FGx7ORLlOkGHut8RjYDCQDZSo2/954kvhmpM/9KUASmaQINtY/kwN/qnhk8v74wOBJ2jsQTZBLZSmtLaqQA3TBgCq7oAvn5k/O2koFLuEp7lcNEZDhyT0wIETVfEmskVDA0idQLU58CLFkWHX31FTCvDXGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVvVIpZSYOQFr8xdIrSiLpYI0Tmgvw8NHr53m+gYclM=;
 b=bm+GVXYjCkhVdPE/kNxP9/Gih20TXmN6Ju3VVsuObj3Flo4RBjLHOXI8v49S65MFqRTUx/YudOIL9y3fHqP9rzx/YxNWJLG6gv361IaVszubhg0H6ZUATi53te5q4q/3YUuhFiHwwkG67DrVkGTFRklbBvYzzfc+cnN/xtCCaeO1DQXqLEQKqa1BH49sRJVYWx2albn6PSBvRvOpXpa0B3V1Rr9l8SFmHDlIB0NO+s97jSQCp6mbfpfaLKGa0EbPQU7RCrNx0EsCnQ4ZuhB3xl5dIA2KKjg8v8Vx/hBbjcJ2SCAL84F+oAy+hGN+mIpOQVjgPMkkgEpumfVQmScMhQ==
Received: from MN2PR17MB3375.namprd17.prod.outlook.com (2603:10b6:208:13c::25)
 by DM5PR1701MB1707.namprd17.prod.outlook.com (2603:10b6:4:1e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 03:44:31 +0000
Received: from MN2PR17MB3375.namprd17.prod.outlook.com
 ([fe80::48d3:68bb:bdcb:4658]) by MN2PR17MB3375.namprd17.prod.outlook.com
 ([fe80::48d3:68bb:bdcb:4658%6]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 03:44:31 +0000
From:   Vanessa Page <Vebpe@outlook.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     William Zhang <william.zhang@broadcom.com>,
        Linux ARM List <linux-arm-kernel@lists.infradead.org>,
        "joel.peshkin@broadcom.com" <joel.peshkin@broadcom.com>,
        "dan.beygelman@broadcom.com" <dan.beygelman@broadcom.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "open list:I2C SUBSYSTEM HOST DRIVERS" <linux-i2c@vger.kernel.org>,
        "open list:MEMORY TECHNOLOGY DEVICES (MTD)" 
        <linux-mtd@lists.infradead.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:PCI NATIVE HOST BRIDGE AND ENDPOINT DRIVERS" 
        <linux-pci@vger.kernel.org>,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>,
        "open list:PIN CONTROL SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:BROADCOM BMIPS MIPS ARCHITECTURE" 
        <linux-mips@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:WATCHDOG DEVICE DRIVERS" <linux-watchdog@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [RESEND PATCH 0/9] arm64: bcmbca: Move BCM4908 SoC support under
 ARCH_BCMBCA
Thread-Topic: [RESEND PATCH 0/9] arm64: bcmbca: Move BCM4908 SoC support under
 ARCH_BCMBCA
Thread-Index: AQHYnJYZEMhK4a4RdUuXvO3VZlf0QK2IK86AgAAANYCAAAMvTA==
Date:   Thu, 21 Jul 2022 03:44:31 +0000
Message-ID: <MN2PR17MB3375B15F7E0673D50B241CD5B8919@MN2PR17MB3375.namprd17.prod.outlook.com>
References: <20220721000626.29497-1-william.zhang@broadcom.com>
 <40cec207-9463-d999-5fc9-8a7514e24b91@gmail.com>
 <2492407a-49a8-4672-b117-4e027db09400@gmail.com>
In-Reply-To: <2492407a-49a8-4672-b117-4e027db09400@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-tmn:  [bp2sLtdJB2RouCmyZq3jzgBQVT89yPRyViQuiW1/v63JV2gL+B7geIWB3cgKS9hp4bYt2vExlYo=]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 423b877a-c3f7-4239-9103-08da6acb5221
x-ms-traffictypediagnostic: DM5PR1701MB1707:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JNoyt/BSvxYg4nbFZJqlx0WxEBaJZvvLIRtLBjkR1PHIRCWtCz5ULzskg67ILv5EIP3k/jf2e5b/IQjMDVwiV3kigX+8UvxTyelZ9d8JJLAwd+nGxs/wwIcyhB7r8XLl0ggpfaH+3aVsk9g2j6eeTzw6o6YkpJeOfyPwtulBvRs2Ec25jsH8H1cSdhmWSgdYLSAzOMQqIotDHf3BuocKFvuH24DwWWbz5pL/uWEfl3LHjFQokw2hFNu3yFC8NwRGQzvo3Vz4H6fDezSWk439Xj2Ib0NekuhHysrw0ot4P5+2K5cGpC3itUSfpwkYUHsuJPoRPxRUzsLJ8LER2lKl/iPv1gf50DWcHf1kHrxnbEyr+y2cxxUl8a7i4XHGoJ7+j/BulsQCSADCfTu9lza0+Oej/0IVyIf+wvD9fHVDekLiTmgwsopO13nlwNDCfle07bOIEbZvY4CUbbJhdRO+qavszGEcm/dW9NXxRUawyOgtakNFU2dA++29ofL0n9EJbng/PPVzPJBLCpLmJBMW6qDtYc/2NKK9imWWAlgXmzSr6QLEiwxxkVNuc01H9SXtde7EHBrg+DjVQIK9NDTaNbQ3xO8OaDUVTUnbOEbadE5KZK0340r7u54Ev11mow0OdWaoU0qj7WQ0y0qqNG7pSrohcF5XHoK0HIi2aalVfMw=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzJIbGh2MWJicW9OR1VORWRPT2p6SUdCRHhPdGdHM0EwVHFsOTBBbUpIcTJT?=
 =?utf-8?B?WU5oRzFyaHQ1dUpydGFPMXBVUkNEajRQeFZSdytBT0ljZXRWQVp3RnB1S1Z0?=
 =?utf-8?B?WUpKZ2xGdmJ0ZW9id0dOanJvcUthQUtCVXI1YTdHekExSXRleGRLdFUxOEhU?=
 =?utf-8?B?WjJqT2theHBkU2VNcEU3RHRMRGhUT3VPU2NuQUM5dzhQTWdaUnAvMlRkYVZp?=
 =?utf-8?B?ZjZ4bkJabkYwbmphWkJWVVM1OTB5a0kwVEJmVDBOMkpnMHZTckJXTnh2YW5O?=
 =?utf-8?B?d2lLa1JLVHJJWi95azVINnpFaHRUVU82WUh3RXpleEpReHpDaTVjbmRqM0pu?=
 =?utf-8?B?RnFqeWg2THB2RzVvQlAwRnU0amF3ZGFIOEpOODZlQTlyWmsvZ1hXc0Y4dUJw?=
 =?utf-8?B?dzJVTkdjVEhqclMzUGJwSnBDZEdLc1NKVEpvWElPVXFZMFFubnVxcjhvRkc3?=
 =?utf-8?B?eUI3VFM3WDQ2SDNRYmduRTJZa0dDZkpjd3NOVnZjWGkwQk9oNjhsSkdLaThM?=
 =?utf-8?B?UWtBVnNRQ243V0R6KzFYWWdYUG1KeFZURmo4MjdMc20raFpVRDdRdmxjanBJ?=
 =?utf-8?B?dHFuWVMveFBnMWp1YTYraXl4dE9TcWxOTkJJRlRiOHkxZEZqSkRESXdJY0NL?=
 =?utf-8?B?NnpqOENYdis1am5ZbTdaU3c5WHNxU3U5Q2I5cXp3b1VFRFVLdTV0eEFodnRD?=
 =?utf-8?B?UWU3bUZsWHc4T0VIRXduK2pPNFZGSFZDdFp2L21uS3lVL2FvcEU2cDIzN2I2?=
 =?utf-8?B?NURpZk1icUtqbW9meE5RdkFEUFZxYWMwVjFzaUFZWWZKMjdRTEV1WHZRbmow?=
 =?utf-8?B?NFZGbTdzbkJWQ0l1NnEvSENzMzNEL2RkbENzV3ZBUHRPVEU1cktHRzExWkc2?=
 =?utf-8?B?RFpEdG1yU0w1UEdsZi9YV3lJd0NzOHFFREJNdFMyQ1JFTFFQeVlEbkh1NEhF?=
 =?utf-8?B?eGxsSGpWOEl5WHBiNklnZFB0emxCeVhyWE1GbmZaQzRYV25Oc3dWNkVuaFIx?=
 =?utf-8?B?endoUE9EZzFwWEpsZ2RQQ3Znbjl0UkpXdzZRRThmdmt2dmt5YmFUNmIycTJV?=
 =?utf-8?B?aTdIWjJqbHkxRlloUWtTMDdKM1JzYmdDK0dnOHNxZkJKaUZGQjYwbHcxQUtH?=
 =?utf-8?B?NDQ0SXkxb1FwVjhzUk1WaDdBNHU2QTFTMGl1K0tNVlNpZlNWVmlscm05d0Ns?=
 =?utf-8?B?Q1BuVFdETE9qbXA0c0xucWczV2kwb1l6djN4MFpBRUhNeG12MjBWTEZyNVg1?=
 =?utf-8?B?blk0VThzbTRwYTlCNDhQZklHSFZCZkZVcUx1Zk5QVDdybjZoNVRqTWFEVUJm?=
 =?utf-8?B?eXlpK3JZRXNWY2ptdG5NRytNdXFPcGdFNFhzcmwxK3p4Zk1lRlB5MUNCVHpB?=
 =?utf-8?B?ekJ0WGcrL1ZWY3ltbzN6Ti9mQ1NsQld1V3ZibURUWTNWcDNSRUZ2aWtZV251?=
 =?utf-8?B?SVhpckdWelRUK0pvajVQQmQ4N1hhR1VLeEtMY0hnd2VtOEpaUkNkSVVuVlVV?=
 =?utf-8?B?MHBuZVZ6QjZveENzSVQ5Mk5mTmJkdzhKOVNheUx3SElxN2xjQ2ZURjZjZkRW?=
 =?utf-8?B?UkZoODFxV2MrTy80bHhPNEk0R0FNaXNpdmx2RWcvOVBteEhERWEyM1JmMVln?=
 =?utf-8?B?SGhacGdEMVAzVERMRUJ0UlROT0RQK3VxOFc0Vzhzalk0RlJ1VHEwWS9uemVn?=
 =?utf-8?B?VVFIVFhaUFovb0p3Q1J2blhkS0kvQmM2NWllc2pCT2NDVWtKejJHTFB1NWtj?=
 =?utf-8?Q?UukzvwwtMyNxd0IdEL7OKfHITj45dyE13gvm7bF?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR17MB3375.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 423b877a-c3f7-4239-9103-08da6acb5221
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 03:44:31.4870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1701MB1707
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WW91IGtub3cgbm9ib2R5IHVuZGVyc3RhbmRzIGEgZGFtbiB3b3JkIG9mIGFueXRoaW5nIGluIHRo
aXMgZW1haWwuIFlvdSBjYW4gbm90IGRvIHNlYXJjaGVzIHRocm91Z2ggZW1haWwuIFN0b3AgaGFy
YXNzaW5nIG1lLiBSZXBvcnRpbmcgeeKAmWFsbCBkb2VzbuKAmXQgd29yayBhbmQgSeKAmW0gbm90
IGRlbGV0aW5nIG15IGFjY291bnQgYmVjYXVzZSBvZiB5b3UuIFNvIHN0b3AgZnVja2luZyB3aXRo
IG1lLiANCg0KVGhhbmtzDQpCeWUgDQoNCj4gT24gSnVsIDIwLCAyMDIyLCBhdCAxMTozNSBQTSwg
RmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+IHdyb3RlOg0KPiANCj4g77u/
DQo+IA0KPj4gT24gNy8yMC8yMDIyIDg6MzIgUE0sIEZsb3JpYW4gRmFpbmVsbGkgd3JvdGU6DQo+
Pj4gT24gNy8yMC8yMDIyIDU6MDYgUE0sIFdpbGxpYW0gWmhhbmcgd3JvdGU6DQo+Pj4gUkVTRU5E
IHRvIGluY2x1ZGUgbGludXggYXJtIGtlcm5lbCBtYWlsaW5nIGxpc3QuDQo+Pj4gDQo+Pj4gTm93
IHRoYXQgQnJvYWRjb20gQnJvYWRiYW5kIGFyY2ggQVJDSF9CQ01CQ0EgaXMgaW4gdGhlIGtlcm5l
bCwgdGhpcyBjaGFuZ2UNCj4+PiBzZXQgbWlncmF0ZXMgdGhlIGV4aXN0aW5nIGJyb2FkYmFuZCBj
aGlwIEJDTTQ5MDggc3VwcG9ydCB0byBBUkNIX0JDTUJDQS4NCj4+IExvb2tzIGxpa2Ugb25seSAx
LCAyIDQgYW5kIDUgbWFkZSBpdCB0byBiY20ta2VybmVsLWZlZWRiYWNrLWxpc3QgbWVhbmluZyB0
aGF0IG91ciBwYXRjaHdvcmsgaW5zdGFuY2UgZGlkIG5vdCBwaWNrIHRoZW0gYWxsIHVwLg0KPj4g
RGlkIHlvdSB1c2UgcGF0bWFuIHRvIHNlbmQgdGhlc2UgcGF0Y2hlcz8gSWYgc28sIHlvdSBtaWdo
dCBzdGlsbCBuZWVkIHRvIG1ha2Ugc3VyZSB0aGF0IHRoZSBmaW5hbCBDQyBsaXN0IGluY2x1ZGVz
IHRoZSBub3cgKGV4KSBCQ000OTA4IG1haW50YWluZXIgYW5kIHRoZSBBUk0gU29DIG1haW50YWlu
ZXIgZm9yIEJyb2FkY29tIGNoYW5nZXMuDQo+IA0KPiBBbmQgdGhlIHRocmVhZGluZyB3YXMgYnJv
a2VuIGJlY2F1c2UgdGhlIHBhdGNoZXMgMS05IHdlcmUgbm90IGluIHJlc3BvbnNlIHRvIHlvdXIg
Y292ZXIgbGV0dGVyLg0KPiAtLSANCj4gRmxvcmlhbg0KPiANCj4gX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQo+IExpbnV4IE1URCBkaXNjdXNz
aW9uIG1haWxpbmcgbGlzdA0KPiBodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2xpbnV4LW10ZC8NCg==
