Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD8B2514CB
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 10:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgHYI7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 04:59:24 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:53959
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728033AbgHYI7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 04:59:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vg+W7PDZBIL4SJMIN0dfTm3JFc7pV0lcbCIOXWVcwJG0WnnyjWUHg1rMonn3jjwesXiHDgL2C2FmRSp7QBxyiWidx3EOgTHY6KFve46FUn8W1F6nkhrnfCxf2gK2mByboSAR33GAIQoLx+N7WOvPa0exrIgFCgL9G3D57DvspwzBKscuza70HJqVHzlyZM0oLJOaqAQDknR1qcTqeeJuUEe1+ADC/G0nFJZ3fcofW5e5D9RbsnftDA8TEkKQUBL4ojIwuPJEGxx4BIfeqrFyRzkNyXtfZwUwgfSeUUOOyQ8wQ2ExrTx2GdQo9UAk9ID0B1LfERoR2921sh0QwleVeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6h3ZZF67h4YqACm/j8Eh1W5rXu/X68RUEDVrbinPXJ0=;
 b=JF6ngQGNABGxMe6SPYdiEH1O45T1SF1s0VHbwkdoBW4013Xa9ykPgI7wm+ADFRS0KSvFCsOuujdF9HvFgYjzvtoGL3iCo/FqbF4Tr6YZ/p4bz7XK14Fi3zAOugid2nPANXdXioU9d/dG7tkaX8mxmOgFemVsmP9yAJgIOPolmJzGqVG9ZkHEtY5nGgAd7cRYeRoD2cHajfHDJo+ejTr0Qbt2Ye8YnWxKMTaijkxxD+N8+cuLvStALq59crAge/4wor3XqdinmbjeiTEk3fhIuikYpokJPmI9f3Q3DwEORqj5jcmN3vSuYN4J7rwr0itDVRWahOrPLe5qXY7PK5tYGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6h3ZZF67h4YqACm/j8Eh1W5rXu/X68RUEDVrbinPXJ0=;
 b=QbJhjos3c1kDix+KtOgrunykT2zf55n41QJpXBkrk3v/ZmToAY5zDLH8/S0KqBoRcawBl2a01YrSdO51eyD+4wsV2DKYFkc1E3VPbEp8dGc8umrLMZB6saTiopqOMsuSZ81Z2DNE4ic/E+InWfjNJt3T3jNTz4U9iSm8UB4Q8dc=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3501.namprd11.prod.outlook.com (2603:10b6:805:d4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 08:59:01 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 08:59:01 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 05/12] staging: wfx: fix support for cipher AES_CMAC (multicast PMF)
Date:   Tue, 25 Aug 2020 10:58:21 +0200
Message-Id: <20200825085828.399505-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200825085828.399505-1-Jerome.Pouiller@silabs.com>
References: <20200825085828.399505-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P192CA0002.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::7) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR3P192CA0002.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 08:59:00 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4add5ae-0310-4305-e7bc-08d848d51c58
X-MS-TrafficTypeDiagnostic: SN6PR11MB3501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3501AD0BBDC2AE15A30A171293570@SN6PR11MB3501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yUEghYn2mO4fW8B0Iizu+r51/1buU64U5lswJeMZrl2iZgFj5PBj37yF8tTUl7NJ8MtbdH7SmTv6VfAgf37/E6pY0CfoRoifgzZlyeMr4TPo6JXbSKRZ76hLhsbmW8Hdw0Vo8PhxP3D4Rb8a60v9a8ituUUO7iJoNwWebCGavD9S3DOnn3y7zr0jAAgnmeBN9hx4QLLmxza586tkgyu1ALOXGXv8dqzSkZDI4kXClfNN5B2VrGCKUnO4Qg5gdoVY82Sw2fVtmaMeMniFUF0Y1amCtv+YPngfXgdAgYDKyyOascX4ElOIOuh4L3uvxNmDx4qJu+SQ375xorzZKXIomg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(376002)(366004)(316002)(5660300002)(478600001)(107886003)(1076003)(8936002)(83380400001)(16576012)(956004)(66556008)(66476007)(26005)(2616005)(186003)(8676002)(86362001)(66946007)(6486002)(54906003)(6666004)(36756003)(4326008)(66574015)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4z+Ej5NhPi6vJmTVvVqPKIb2cyfPO5OrSwIEI+eLPkuHtRExMgjGei6s+lEwfNZegpmFoj55J84i0gSqU54YNyq3/NudhRkQp8WPT640wcp0jtgwrqfPrlT5g54sttQ8zCj3pz6wwB4zB5g46HTFe+g5SRnW2zRgc8Cg+gPZNsdx50v9CLyLQzeuQvNB5824Wx7E1IHjcQgMghF4PhnM9VcA8XT05eBEbUu4t7RhdCdkUbjtixC9CqDfS68tJrGszD2eZUuMj9Gi4JY5OS2AclncY54IvVLDMnMtelCiHudosbkRKHdrCSPwjcT86Jyhbs3VVC9fregCjV5QtsF0OrnZcGi480GJjXCWmcAJweih25n8VrzdgeZZWkNDKQtL/d2fLnVSeYiElVHqygIppnFnRvwTJzaDO10pb7ghQF0lGvOwERHP6W7SXHVytviCnGDHhZ4gH4RZtny0OCKwxsjpGzCRG6RBjrGDKWNyKS9lgMaEcddF+8jebM3Is8hBQORmGhfdl21aBkP/H8dEAhULnm3y0OpieU/STUl4MRT4v1KuIEgkPLNBDwOiBcgDRlnxgtq/7zCLfvQ91Z2OtKz0FFHhkNkCnqw5QKNjrCgw2uBAZDuOPDHjrguP0uH1EsmaHIQaIEXHBmbujADouA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4add5ae-0310-4305-e7bc-08d848d51c58
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 08:59:01.6226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1FqIuQ9CIT05aPMsNT4OMf6OgtCJ7JerLxKnYGSgoizy1W61/5EGOhAqL2HAkvjOzuUhf5uKCQt7ScsTo9qDcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3501
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBNRlAgaXMgZW5hYmxlZCwgdGhlIG11bHRpY2FzdCBtYW5hZ2VtZW50IGZyYW1lcyBhcmUgbm90
IHByb3RlY3RlZCwKaW4gZmFjdC4gSW5zdGVhZCwgYnV0IHRoZXkgc2hvdWxkIGluY2x1ZGUgYW4g
SUUgY29udGFpbmluZyB0aGUgTU1JQyBvZgp0aGUgZnJhbWVzIChpLmUuIGEgY3J5cHRvZ3JhcGhp
YyBzaWduYXR1cmUpLgoKVW50aWwgbm93LCB0aGUgZHJpdmVyIGRpZG4ndCBjb3JyZWN0bHkgZGV0
ZWN0IHRoaXMga2luZCBvZiBmcmFtZXMgKHRoZXkKYXJlIG5vdCBtYXJrZWQgcHJvdGVjdGVkIGJ1
dCB0aGV5IGFyZSBhc3NvY2lhdGVkIHRvIGEga2V5KSBhbmQgZGlkbid0CmFzayB0byB0aGUgZGV2
aWNlIHRvIGVuY3J5cHQgdGhlbS4KCkluIGFkZCwgdGhlIGRldmljZSBpcyBub3QgYWJsZSB0byBn
ZW5lcmF0ZSB0aGUgSUUgaXRzZWxmLiBNYWM4MDIxMSBoYXMKdG8gZ2VuZXJhdGUgdGhlIElFIGFu
ZCBsZXQgdGhlIGRldmljZSBjb21wdXRlIHRoZSBNTUlDLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0
bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvZGF0YV90eC5jIHwgNSArKystLQogZHJpdmVycy9zdGFnaW5nL3dmeC9rZXkuYyAg
ICAgfCA0ICsrLS0KIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggNDFmOWFmZDQxZTE0Li5kMTZiNTE2YWQ3Y2Yg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC0zMjUsNiArMzI1LDggQEAgc3RhdGljIGludCB3Znhf
dHhfZ2V0X2ljdl9sZW4oc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqaHdfa2V5KQogCiAJaWYg
KCFod19rZXkpCiAJCXJldHVybiAwOworCWlmIChod19rZXktPmNpcGhlciA9PSBXTEFOX0NJUEhF
Ul9TVUlURV9BRVNfQ01BQykKKwkJcmV0dXJuIDA7CiAJbWljX3NwYWNlID0gKGh3X2tleS0+Y2lw
aGVyID09IFdMQU5fQ0lQSEVSX1NVSVRFX1RLSVApID8gOCA6IDA7CiAJcmV0dXJuIGh3X2tleS0+
aWN2X2xlbiArIG1pY19zcGFjZTsKIH0KQEAgLTM1MCw4ICszNTIsNyBAQCBzdGF0aWMgaW50IHdm
eF90eF9pbm5lcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0
YSwKIAltZW1zZXQodHhfaW5mby0+cmF0ZV9kcml2ZXJfZGF0YSwgMCwgc2l6ZW9mKHN0cnVjdCB3
ZnhfdHhfcHJpdikpOwogCS8vIEZpbGwgdHhfcHJpdgogCXR4X3ByaXYgPSAoc3RydWN0IHdmeF90
eF9wcml2ICopdHhfaW5mby0+cmF0ZV9kcml2ZXJfZGF0YTsKLQlpZiAoaWVlZTgwMjExX2hhc19w
cm90ZWN0ZWQoaGRyLT5mcmFtZV9jb250cm9sKSkKLQkJdHhfcHJpdi0+aHdfa2V5ID0gaHdfa2V5
OworCXR4X3ByaXYtPmh3X2tleSA9IGh3X2tleTsKIAogCS8vIEZpbGwgaGlmX21zZwogCVdBUk4o
c2tiX2hlYWRyb29tKHNrYikgPCB3bXNnX2xlbiwgIm5vdCBlbm91Z2ggc3BhY2UgaW4gc2tiIik7
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2tleS5jIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9rZXkuYwppbmRleCA2MTY1ZGY1OWVjZjkuLjcyOGU1ZjhkM2I3YyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9rZXkuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2tleS5j
CkBAIC0xOTgsOCArMTk4LDggQEAgc3RhdGljIGludCB3ZnhfYWRkX2tleShzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZiwgc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSwKIAkJZWxzZQogCQkJay50eXBlID0g
ZmlsbF9zbXM0X2dyb3VwKCZrLmtleS53YXBpX2dyb3VwX2tleSwga2V5KTsKIAl9IGVsc2UgaWYg
KGtleS0+Y2lwaGVyID09IFdMQU5fQ0lQSEVSX1NVSVRFX0FFU19DTUFDKSB7Ci0JCWsudHlwZSA9
IGZpbGxfYWVzX2NtYWNfZ3JvdXAoJmsua2V5LmlndGtfZ3JvdXBfa2V5LCBrZXksCi0JCQkJCSAg
ICAgJnNlcSk7CisJCWsudHlwZSA9IGZpbGxfYWVzX2NtYWNfZ3JvdXAoJmsua2V5LmlndGtfZ3Jv
dXBfa2V5LCBrZXksICZzZXEpOworCQlrZXktPmZsYWdzIHw9IElFRUU4MDIxMV9LRVlfRkxBR19H
RU5FUkFURV9NTUlFOwogCX0gZWxzZSB7CiAJCWRldl93YXJuKHdkZXYtPmRldiwgInVuc3VwcG9y
dGVkIGtleSB0eXBlICVkXG4iLCBrZXktPmNpcGhlcik7CiAJCXdmeF9mcmVlX2tleSh3ZGV2LCBp
ZHgpOwotLSAKMi4yOC4wCgo=
