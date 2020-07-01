Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E566210E9E
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731885AbgGAPIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:08:36 -0400
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:52640
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731811AbgGAPIX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 11:08:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbHVrVOIsbuB/SHLRIj5oAmgWj7ogtM0gsr6NIoRDhlr1WgPMOJ2BwevMjBYgmhzGQBEbv42FWeGUgagOpqsl1R0rMEgbOZurDafMNS5Bb8tzmmFhI/ld8Gp49Sb0BZig1t2UzymGzbnH1r/gGahLuHg3lIMq8xXj75IPorNdEU6SecMmTZP7Ja9ZxD21leLTw3IsHVpEBkLbHebN/Plvv2xqfp2PGB6b6HtN5U/UQc7QNZvcsCadtQZn2MelnkcT7L7D+jL42iRkYBPnoXhkf7jC0//7f9rgMpBrbptntZLd73q+nBEkg59kl+YnejqZ6UpX8xjThgByyxXlXzQhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0WYfDeM/2vOHp34XrR8eW4auaR/xAu4eeyVN3zjOvA=;
 b=GozECPuVJ/UFREoZAGBXZ7SNSUHUB+a1AhfPqKoWG+gBZjVa720ZMZaC2O8nbEWpoUQiDwsggaiii995Vo1QA+ildZaA/OF+5Ojz+Gdb+sMkLkF2y5sJNlYp6vIIGC3hBomlOOBJx6zYZKJvV3425Eyp2zWxEH+Z/aJD1q6vHanC672fTyUh/awynBlSxIgji63aKxy+9C24fynCV4zFgWGRRPjc1iYHNw0jsjnzq3jTkwKTFGwTZivf6Cnj66wPOsex+q8MwYjiz+Eq1ctBMR+fWpWusglex0nPdAWNoFas86NcNZ2BaCZLE8p5ceMJnUjc7iZWLFAat9lqYofdtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0WYfDeM/2vOHp34XrR8eW4auaR/xAu4eeyVN3zjOvA=;
 b=SRa5UyIKyAoXsubsL90j/wdNwtxPecSs/f4ylUvv2h9+wBrcei+EY14bq2vrYWQn8fcNIICrset0vQGBNWEiy0SerKfes4Lt14lVscz836wp17u6YykTo+pCeHL3y4I6KUoNsrxZUEJeRtNFynC7rBco5XcDL9PVRdGegH4rBiQ=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4736.namprd11.prod.outlook.com (2603:10b6:806:9f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Wed, 1 Jul
 2020 15:08:12 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3131.033; Wed, 1 Jul 2020
 15:08:12 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 06/13] staging: wfx: improve protection against malformed HIF messages
Date:   Wed,  1 Jul 2020 17:07:00 +0200
Message-Id: <20200701150707.222985-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701150707.222985-1-Jerome.Pouiller@silabs.com>
References: <20200701150707.222985-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR07CA0143.namprd07.prod.outlook.com
 (2603:10b6:3:13e::33) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR07CA0143.namprd07.prod.outlook.com (2603:10b6:3:13e::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Wed, 1 Jul 2020 15:08:11 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c11d379e-9ead-40ea-b9e9-08d81dd092b0
X-MS-TrafficTypeDiagnostic: SA0PR11MB4736:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB47366A607112B2A7A9084023936C0@SA0PR11MB4736.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5QYgg2RoPGPR1x18EAFYbwOmnMpkLwy/aHnPl3r647fjOPUPib096624pKai78YCpnzDg0iwhO6WArdy9XOp2PdSJmymFWWJEVOU1oOxZqdlK+Nae6l2wQHwu32oAAGVr1Zco7z+N5k8YQlL0vymuhGIZvy91B//nwVrvXJe1M9BjA52DPLgh2M9qHjSTp2/cgR3BYlRRxKT/qTsA1qvOHKODpcwt/kshTZTEfep34UKPaY1W3Yws7FZbKV1y8l02PhcQ4R3R6PjXBX19CcdOHyptVBmHOtcKP9Jeb+1Nn1ZXm5b55RiIRWSMuIYGo+LAN+l4rfgZQuFHJOOG2HBd0VEwaP68mRWHv0DS/ntcX4gOvkK9R+VVAiaASHBzYcgnhcgepx6apa2qJX8AqVxK/dXV89dZ8Khv6ZEjoWY0DtrK/+mWqVSn3lf5NmCELzqhf4/8K7ReYPQ/FkPj7NKAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(366004)(346002)(376002)(396003)(136003)(5660300002)(6486002)(15650500001)(86362001)(6666004)(66574015)(36756003)(2906002)(43170500006)(186003)(83380400001)(16526019)(8936002)(66556008)(66476007)(107886003)(4326008)(8676002)(2616005)(1076003)(478600001)(316002)(966005)(54906003)(66946007)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Dv9ro+k0oyQoP1fWqd9tkzoOoT0I0/iTPZb6/CmrSRuYH2KPCm2cwPzugnzLPAfAh3IVdaXHI+PZQJzzevolb4DxXjOqUTNxemqaTnnY8SE48QlU6+No8bI0dBWijqEKyruA8RhjjmRykgMdF69UcdXxaLYuKHSXx59qhPScPgt0qNNuBozNQiGtivLBG+3DV5weW6ezogu0lQp38AxUhC6yEgd1P5HVbN4cFjbt0PcaMi3ELUvFhn8us/7oN2XAyB4PwOQvErlLQzsw5TFJZc/OOC+dsSC5f2Y8udaOdX7qr5HEqBe8Apy/gU+oy2sZLOf/4EuUIQ14H8eFvR93j9n8RIFPDROqR+Y0Eue7PjSf8MH5elTk7rR+Nc6BpPnvuIDhL+/phemVh4pfzgkmbkg5Iv3mXJV/pbpPPIhTAjVQSuiPuy1khhbheEurrqLd6WuKCfELIuUNFsWnlzJbHrvW2g1dPypTbHOBW6sB44SE0Vebj9O7SG06Ibfh88WLcgQeDvY1RAw+6G5T9D9ijzbCok8x24/DnpW245K4zAY=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c11d379e-9ead-40ea-b9e9-08d81dd092b0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 15:08:12.7102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYoMifO+MuLMW11K5+kskinhYhX4aOwuVwTbCjqZlQLh9lGHp85liDDI9dVhxGVrBl8pbNtAAZR1pGbBstWJJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4736
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQXMg
ZGlzY3Vzc2VkIGhlcmVbMV0sIGlmIGEgbWVzc2FnZSB3YXMgc21hbGxlciB0aGFuIHRoZSBzaXpl
IG9mIHRoZQptZXNzYWdlIGhlYWRlciwgaXQgY291bGQgYmUgaW5jb3JyZWN0bHkgcHJvY2Vzc2Vk
LgoKWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2RyaXZlcmRldi1kZXZlbC8yMzAyNzg1LjZD
N09EQzJMWW1AcGMtNDIvCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21l
LnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jIHwgMzYg
KysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMjEg
aW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9iaC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jCmluZGV4IDFjYmFmOGJiNGZh
MzguLjUzYWUwYjVhYmNkZDggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvYmguYwor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMKQEAgLTU3LDcgKzU3LDYgQEAgc3RhdGljIGlu
dCByeF9oZWxwZXIoc3RydWN0IHdmeF9kZXYgKndkZXYsIHNpemVfdCByZWFkX2xlbiwgaW50ICpp
c19jbmYpCiAJaW50IHJlbGVhc2VfY291bnQ7CiAJaW50IHBpZ2d5YmFjayA9IDA7CiAKLQlXQVJO
KHJlYWRfbGVuIDwgNCwgImNvcnJ1cHRlZCByZWFkIik7CiAJV0FSTihyZWFkX2xlbiA+IHJvdW5k
X2Rvd24oMHhGRkYsIDIpICogc2l6ZW9mKHUxNiksCiAJICAgICAiJXM6IHJlcXVlc3QgZXhjZWVk
IFdGeCBjYXBhYmlsaXR5IiwgX19mdW5jX18pOwogCkBAIC03Niw3ICs3NSwyNyBAQCBzdGF0aWMg
aW50IHJ4X2hlbHBlcihzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc2l6ZV90IHJlYWRfbGVuLCBpbnQg
KmlzX2NuZikKIAloaWYgPSAoc3RydWN0IGhpZl9tc2cgKilza2ItPmRhdGE7CiAJV0FSTihoaWYt
PmVuY3J5cHRlZCAmIDB4MSwgInVuc3VwcG9ydGVkIGVuY3J5cHRpb24gdHlwZSIpOwogCWlmICho
aWYtPmVuY3J5cHRlZCA9PSAweDIpIHsKLQkJaWYgKHdmeF9zbF9kZWNvZGUod2RldiwgKHZvaWQg
KiloaWYpKSB7CisJCWlmIChXQVJOKHJlYWRfbGVuIDwgc2l6ZW9mKHN0cnVjdCBoaWZfc2xfbXNn
KSwgImNvcnJ1cHRlZCByZWFkIikpCisJCQlnb3RvIGVycjsKKwkJY29tcHV0ZWRfbGVuID0gbGUx
Nl90b19jcHUoKChzdHJ1Y3QgaGlmX3NsX21zZyAqKWhpZiktPmxlbik7CisJCWNvbXB1dGVkX2xl
biA9IHJvdW5kX3VwKGNvbXB1dGVkX2xlbiAtIHNpemVvZih1MTYpLCAxNik7CisJCWNvbXB1dGVk
X2xlbiArPSBzaXplb2Yoc3RydWN0IGhpZl9zbF9tc2cpOworCQljb21wdXRlZF9sZW4gKz0gc2l6
ZW9mKHN0cnVjdCBoaWZfc2xfdGFnKTsKKwl9IGVsc2UgeworCQlpZiAoV0FSTihyZWFkX2xlbiA8
IHNpemVvZihzdHJ1Y3QgaGlmX21zZyksICJjb3JydXB0ZWQgcmVhZCIpKQorCQkJZ290byBlcnI7
CisJCWNvbXB1dGVkX2xlbiA9IGxlMTZfdG9fY3B1KGhpZi0+bGVuKTsKKwkJY29tcHV0ZWRfbGVu
ID0gcm91bmRfdXAoY29tcHV0ZWRfbGVuLCAyKTsKKwl9CisJaWYgKGNvbXB1dGVkX2xlbiAhPSBy
ZWFkX2xlbikgeworCQlkZXZfZXJyKHdkZXYtPmRldiwgImluY29uc2lzdGVudCBtZXNzYWdlIGxl
bmd0aDogJXp1ICE9ICV6dVxuIiwKKwkJCWNvbXB1dGVkX2xlbiwgcmVhZF9sZW4pOworCQlwcmlu
dF9oZXhfZHVtcChLRVJOX0lORk8sICJoaWY6ICIsIERVTVBfUFJFRklYX09GRlNFVCwgMTYsIDEs
CisJCQkgICAgICAgaGlmLCByZWFkX2xlbiwgdHJ1ZSk7CisJCWdvdG8gZXJyOworCX0KKwlpZiAo
aGlmLT5lbmNyeXB0ZWQgPT0gMHgyKSB7CisJCWlmICh3Znhfc2xfZGVjb2RlKHdkZXYsIChzdHJ1
Y3QgaGlmX3NsX21zZyAqKWhpZikpIHsKIAkJCWRldl9rZnJlZV9za2Ioc2tiKTsKIAkJCS8vIElm
IGZyYW1lIHdhcyBhIGNvbmZpcm1hdGlvbiwgZXhwZWN0IHRyb3VibGUgaW4gbmV4dAogCQkJLy8g
ZXhjaGFuZ2UuIEhvd2V2ZXIsIGl0IGlzIGhhcm1sZXNzIHRvIGZhaWwgdG8gZGVjb2RlCkBAIC04
NCwxOSArMTAzLDYgQEAgc3RhdGljIGludCByeF9oZWxwZXIoc3RydWN0IHdmeF9kZXYgKndkZXYs
IHNpemVfdCByZWFkX2xlbiwgaW50ICppc19jbmYpCiAJCQkvLyBwaWdneWJhY2sgaXMgcHJvYmFi
bHkgY29ycmVjdC4KIAkJCXJldHVybiBwaWdneWJhY2s7CiAJCX0KLQkJY29tcHV0ZWRfbGVuID0K
LQkJCXJvdW5kX3VwKGxlMTZfdG9fY3B1KGhpZi0+bGVuKSAtIHNpemVvZihoaWYtPmxlbiksIDE2
KSArCi0JCQlzaXplb2Yoc3RydWN0IGhpZl9zbF9tc2cpICsKLQkJCXNpemVvZihzdHJ1Y3QgaGlm
X3NsX3RhZyk7Ci0JfSBlbHNlIHsKLQkJY29tcHV0ZWRfbGVuID0gcm91bmRfdXAobGUxNl90b19j
cHUoaGlmLT5sZW4pLCAyKTsKLQl9Ci0JaWYgKGNvbXB1dGVkX2xlbiAhPSByZWFkX2xlbikgewot
CQlkZXZfZXJyKHdkZXYtPmRldiwgImluY29uc2lzdGVudCBtZXNzYWdlIGxlbmd0aDogJXp1ICE9
ICV6dVxuIiwKLQkJCWNvbXB1dGVkX2xlbiwgcmVhZF9sZW4pOwotCQlwcmludF9oZXhfZHVtcChL
RVJOX0lORk8sICJoaWY6ICIsIERVTVBfUFJFRklYX09GRlNFVCwgMTYsIDEsCi0JCQkgICAgICAg
aGlmLCByZWFkX2xlbiwgdHJ1ZSk7Ci0JCWdvdG8gZXJyOwogCX0KIAogCWlmICghKGhpZi0+aWQg
JiBISUZfSURfSVNfSU5ESUNBVElPTikpIHsKLS0gCjIuMjcuMAoK
