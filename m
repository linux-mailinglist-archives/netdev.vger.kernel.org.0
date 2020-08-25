Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE722514E0
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgHYI7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 04:59:44 -0400
Received: from mail-bn8nam11on2079.outbound.protection.outlook.com ([40.107.236.79]:20448
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729051AbgHYI7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 04:59:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCgapgpsMb4e5M1A/p7sVSLsANMj4zLu4LNVltCyUmZ4VfklZhYH0xuhWZH0XHUxcNhZZCtwIrGzC6T/TXCy/0VQhuutbHSUnXB9PbkwLM3TQToyrH/05zsfvvLP0bxPzF9JYejoGZEV27pEJZ+WsNdXYACqSVlfhnye/UAYoU2Wz1zcfzK6ExVNQc93rf9zfdaQRrxo9QzimoCrKXdRotpPsWkiQwUczfBgJQnKgy7rBOF+U4bczjCri0eCWSYjfTA6V2KcpatPkEObw642jsCkjp5GkM07obpbRIUrV20xPFtgmWk9/NTDki3ANM/fr8KWmNj3YmJZwGJvbhKUvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0v0NTeVO8a5ZoHPuayBgPRqg+JDLyTRDjtM91NRk3k=;
 b=EysgKOUJ1xSOm7ZMB1HpQZIb1hUY3FhQci4NNUPLwFzd0ZYjewydFhU3c5oQI61FG8Ko2Ac7nQbx83IXQriA8FpOwX7EFQngnqpW7LuxOP4F0aoROVxOpGPhqsC7rqKBUwrdJkKfNY9/0R0yQhBCSuCxKIpBAWpcM5ldcs2t30mBmuCa9lj3bRiRqcM/H+cF0/uzBYSrKu1ASOnpsuTEoht4MawjkXj58aktiMxijPMmWbEIPKY3wtQKpxvCgSpc4eBtGVDTOkj2MLsmVeSc1B04rujeqXNb7XH5qGqvLms1tCTp85tRsZF3nOUiUO1OqOfUlnLO0j3QvpkLt5QdMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0v0NTeVO8a5ZoHPuayBgPRqg+JDLyTRDjtM91NRk3k=;
 b=h61vMFCszT4q5hwyUVKAbEnryPsGDEEPJSJHmd1BZWnagV6QGY8FFZC9Vwb5oKhJGbQ7Z3UDjUogH9tOL80YJdWLWilEkTN5j94ZOcgdoIVYhe5WRHY0yNoMYl8eR7NnB5MlnebEzwtqhiSocAntIh3u2m1FI6HmYD8EleqwpRA=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3501.namprd11.prod.outlook.com (2603:10b6:805:d4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 08:58:57 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 08:58:57 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 02/12] staging: wfx: improve usage of hif_map_link()
Date:   Tue, 25 Aug 2020 10:58:18 +0200
Message-Id: <20200825085828.399505-2-Jerome.Pouiller@silabs.com>
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
Received: from 255.255.255.255 (255.255.255.255) by PR3P192CA0002.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 08:58:55 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80639ebb-f9f7-4e62-43e7-08d848d51979
X-MS-TrafficTypeDiagnostic: SN6PR11MB3501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3501CB84575B3FB79188830C93570@SN6PR11MB3501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OrLni9KdMAuJJdZX33ga51UXqLyLPFuAdHGzb+PbHPaEfxwJfv2TCXylMrvTjtPy8cFDIW/JrR2jV08TF2nMzlqpwJOiyZuZAnOPmjTBqdCxTVPJy3gtlDwqESnuXn/9mxHQRWl3rNMun62J59jVVD68XplnH6+KP0oPNqZ9hrVSGRJV2OYE5Z9cP6r44sDUsLeieEvsrNzyVhXTwbR6Can5QSKhZIcluvfjO10aT/a3L8HDTxoRFeWDcyClQe2ejd+OvJKTa1AsxLsy4LCSoVkVK5cw1rKIkoOhlYPImMYaYO3hYLl+l2AkuKUNjPS+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(376002)(366004)(316002)(5660300002)(478600001)(107886003)(1076003)(8936002)(83380400001)(16576012)(956004)(66556008)(66476007)(26005)(2616005)(186003)(8676002)(86362001)(66946007)(6486002)(54906003)(6666004)(36756003)(4326008)(66574015)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RYptpOpL42f037M1W6LTEcLo7g1hpC9QTYNx1H0JViT3wvStRVu20rs8V4szaDhTFc9wDEBZBbyg6Bv0SfmaEwNAVgBlsYzi3+qAiNSXVr6tOsL0mqSKcZVSv7R13ubuCOfAMo6LMw93sBnLcLDieOdgx/yAo66bmutp5vDa/NrVIyGd8oTRQoRz6GJ/FbK2N2J9depUWs2BFeu+N7obCuEyGmE05/4xn97BvYfForxF29h82JQuzzm/Rk5db2IzQsYA9b2Iq98T9KGDll5htlFN2qz8AWVkCSIHEVSkLRLErJh5OkIhiOyEzIfTvLjCQg3aIZbN/HpOZSxumOFfZZFgukAMPqhRye66k0AcJsDTGGIVXbb4S7TbU+WZZSexxW9eEPWPWSXw9rn3g8aBq8pi43akmXAzhtnz6wfR1DQ2KLIIr/nNuqvrFip/Vk+vJ8+vmxPAyiiGLTCMrzfcw/QE8hbiysMu+HeS5iHskmdVDTXphjm11KMiXFykB5/aBEgXjBRZIyZL7xNcX9y7dFpO2OxK1VBoIhhIeA1awR6dxDmkPnZa1zNw9SZiViuAI6KJwgXDgWBkVGRWvn/5V1ujND+aa6xsKPS6J3GxGhbXqpvfYyOyqqxq0hIO+DV95zk/3lcmhQW3TV71N7U2hQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80639ebb-f9f7-4e62-43e7-08d848d51979
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 08:58:56.7535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X1S7My9oiJT6XiqMhgqkEhsGwdpMWOnzC1LVPFQV21WNKuUaFFR0LPWTfmeXc2WlAfPwwI0WE1i2RD1Vt+E+lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3501
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVW50
aWwgbm93LCBoaWZfbWFwX2xpbmsoKSBnZXQgYXMgYXJndW1lbnQgdGhlIHJhdyB2YWx1ZSBmb3IK
bWFwX2xpbmtfZmxhZ3Mgd2hlbiBtYXBfbGlua19mbGFncyBpcyBkZWZpbmVkIGFzIGEgYml0Zmll
bGQuIEl0IHdhcwplcnJvciBwcm9uZS4KCk5vdyBoaWZfbWFwX2xpbmsoKSB0YWtlcyBleHBsaWNp
dCB2YWx1ZSBmb3IgZXZlcnkgZmxhZ3Mgb2YgdGhlCnN0cnVjdCBtYXBfbGlua19mbGFncy4KClNp
Z25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNv
bT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIHwgNSArKystLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfdHguaCB8IDMgKystCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAg
IHwgNCArKy0tCiAzIGZpbGVzIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCAzYjVmNGRjYzQ2OWMuLjZiODllNTVmMDNmNCAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYworKysgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eC5jCkBAIC00OTksNyArNDk5LDcgQEAgaW50IGhpZl9iZWFjb25fdHJhbnNt
aXQoc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgZW5hYmxlKQogCXJldHVybiByZXQ7CiB9CiAK
LWludCBoaWZfbWFwX2xpbmsoc3RydWN0IHdmeF92aWYgKnd2aWYsIHU4ICptYWNfYWRkciwgaW50
IGZsYWdzLCBpbnQgc3RhX2lkKQoraW50IGhpZl9tYXBfbGluayhzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwgYm9vbCB1bm1hcCwgdTggKm1hY19hZGRyLCBpbnQgc3RhX2lkLCBib29sIG1mcCkKIHsKIAlp
bnQgcmV0OwogCXN0cnVjdCBoaWZfbXNnICpoaWY7CkBAIC01MDksNyArNTA5LDggQEAgaW50IGhp
Zl9tYXBfbGluayhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgdTggKm1hY19hZGRyLCBpbnQgZmxhZ3Ms
IGludCBzdGFfaWQpCiAJCXJldHVybiAtRU5PTUVNOwogCWlmIChtYWNfYWRkcikKIAkJZXRoZXJf
YWRkcl9jb3B5KGJvZHktPm1hY19hZGRyLCBtYWNfYWRkcik7Ci0JYm9keS0+bWFwX2xpbmtfZmxh
Z3MgPSAqKHN0cnVjdCBoaWZfbWFwX2xpbmtfZmxhZ3MgKikmZmxhZ3M7CisJYm9keS0+bWFwX2xp
bmtfZmxhZ3MubWZwYyA9IG1mcCA/IDEgOiAwOworCWJvZHktPm1hcF9saW5rX2ZsYWdzLm1hcF9k
aXJlY3Rpb24gPSB1bm1hcCA/IDEgOiAwOwogCWJvZHktPnBlZXJfc3RhX2lkID0gc3RhX2lkOwog
CXdmeF9maWxsX2hlYWRlcihoaWYsIHd2aWYtPmlkLCBISUZfUkVRX0lEX01BUF9MSU5LLCBzaXpl
b2YoKmJvZHkpKTsKIAlyZXQgPSB3ZnhfY21kX3NlbmQod3ZpZi0+d2RldiwgaGlmLCBOVUxMLCAw
LCBmYWxzZSk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaAppbmRleCBlMWRhMjhhZWY3MDYuLmIzNzFiMzc3N2Ez
MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaAorKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eC5oCkBAIC01NSw3ICs1NSw4IEBAIGludCBoaWZfc2V0X2VkY2Ff
cXVldWVfcGFyYW1zKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCB1MTYgcXVldWUsCiBpbnQgaGlmX3N0
YXJ0KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25m
ICpjb25mLAogCSAgICAgIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5lbCk7
CiBpbnQgaGlmX2JlYWNvbl90cmFuc21pdChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBlbmFi
bGUpOwotaW50IGhpZl9tYXBfbGluayhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgdTggKm1hY19hZGRy
LCBpbnQgZmxhZ3MsIGludCBzdGFfaWQpOworaW50IGhpZl9tYXBfbGluayhzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZiwKKwkJIGJvb2wgdW5tYXAsIHU4ICptYWNfYWRkciwgaW50IHN0YV9pZCwgYm9vbCBt
ZnApOwogaW50IGhpZl91cGRhdGVfaWVfYmVhY29uKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25z
dCB1OCAqaWVzLCBzaXplX3QgaWVzX2xlbik7CiBpbnQgaGlmX3NsX3NldF9tYWNfa2V5KHN0cnVj
dCB3ZnhfZGV2ICp3ZGV2LAogCQkgICAgICAgY29uc3QgdTggKnNsa19rZXksIGludCBkZXN0aW5h
dGlvbik7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwppbmRleCBjMzFlMzAyZDA1YzkuLmI2Y2NiMDRmMzA4YSAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jCkBAIC00MzQsNyArNDM0LDcgQEAgaW50IHdmeF9zdGFfYWRkKHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAogCXd2aWYtPmxpbmtfaWRfbWFw
IHw9IEJJVChzdGFfcHJpdi0+bGlua19pZCk7CiAJV0FSTl9PTighc3RhX3ByaXYtPmxpbmtfaWQp
OwogCVdBUk5fT04oc3RhX3ByaXYtPmxpbmtfaWQgPj0gSElGX0xJTktfSURfTUFYKTsKLQloaWZf
bWFwX2xpbmsod3ZpZiwgc3RhLT5hZGRyLCBzdGEtPm1mcCA/IDIgOiAwLCBzdGFfcHJpdi0+bGlu
a19pZCk7CisJaGlmX21hcF9saW5rKHd2aWYsIGZhbHNlLCBzdGEtPmFkZHIsIHN0YV9wcml2LT5s
aW5rX2lkLCBzdGEtPm1mcCk7CiAKIAlyZXR1cm4gMDsKIH0KQEAgLTQ0OSw3ICs0NDksNyBAQCBp
bnQgd2Z4X3N0YV9yZW1vdmUoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAy
MTFfdmlmICp2aWYsCiAJaWYgKCFzdGFfcHJpdi0+bGlua19pZCkKIAkJcmV0dXJuIDA7CiAJLy8g
RklYTUUgYWRkIGEgbXV0ZXg/Ci0JaGlmX21hcF9saW5rKHd2aWYsIHN0YS0+YWRkciwgMSwgc3Rh
X3ByaXYtPmxpbmtfaWQpOworCWhpZl9tYXBfbGluayh3dmlmLCB0cnVlLCBzdGEtPmFkZHIsIHN0
YV9wcml2LT5saW5rX2lkLCBmYWxzZSk7CiAJd3ZpZi0+bGlua19pZF9tYXAgJj0gfkJJVChzdGFf
cHJpdi0+bGlua19pZCk7CiAJcmV0dXJuIDA7CiB9Ci0tIAoyLjI4LjAKCg==
