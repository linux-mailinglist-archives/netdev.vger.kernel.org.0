Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337321C55BA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgEEMjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:39:31 -0400
Received: from mail-eopbgr680041.outbound.protection.outlook.com ([40.107.68.41]:21169
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729090AbgEEMik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 08:38:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFnx+zMn+SGrfv8KLoswdNk2jkwF2sz8hogbxtRvfdKoR3b1TkLkyzFizeZoF2fqNGya1UbYHgQkIyiWMvodPGUydBemqDR0eRogDn3+Isj45pBICbkPVTOzBOaZRpTwnVG27JK3y3gEyyy6gqL7EEB5l7fJ8JSWcTOPOYvpDF3wWtcsmkF30uhoN7Aik1J7XlYhjKRwDLWWkbcBIMmUtt8ay0YlDBvHKitg7yXBuNL5lqzBVoQwfu/GxbryTmFDOO2dWpzNY4czfxApAfVMyDFVoXr4jzFQCrV6DIPaSc4YlrTd4R3Rkpz/xAMnkPWEteCx0/9ui3cx4kvpdOWkhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EcUyPk9HZS90+PsFFElskjoPjhRG9AXCGuuvtKpa0IQ=;
 b=B0C3rXTKnUcu1V3yVT5fpQO195zjvQyT/9fVXTw7XvdspHR+t4NhvtN4Ut3zzD3hgVU9Udsox1ZOcLxPlCtz8VhZA3aOWeZfPnNzHTAa3nWOOCQSVyD9F0rwLurSadSmEQcchvTPnDbaUSXgCP3Pc/zjxHbfpcGPDjj8zJSjvRlGsvVwCvPdR9L0guNnDHE+7QJX3KF9cuyB/+Ht5cdNNO2zsVEwQkSivP0PrQSfiZh5DyA7B1svbLYd6akXBEWTd3HzqNVwuYTxdBiRH7f9BAe0LIDjXVW60kAE1FvTY/O8iDkEjqjGr/0yxtTSusL3QqEgb3t0tJQkGcGb4iXABg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EcUyPk9HZS90+PsFFElskjoPjhRG9AXCGuuvtKpa0IQ=;
 b=ihT53FlWnxFNCiI+W3+fRQnU2YKM6tkk7mBTb7a06HIy7TkNfoRmusIf16b2sWn76nPVG1174NLH5iCHKSwOBaKQJNPritcAPHE/Nfw9oSm1l79WNo0waEOK0cY8O+5HzzuwhMVRQTDcPz+bfit0XJKJAabx8gpW2GbtS7TiE4Y=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1824.namprd11.prod.outlook.com (2603:10b6:300:110::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Tue, 5 May
 2020 12:38:27 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 12:38:26 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 07/15] staging: wfx: introduce a way to poll IRQ
Date:   Tue,  5 May 2020 14:37:49 +0200
Message-Id: <20200505123757.39506-8-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
References: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0022.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::27) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by PR3P189CA0022.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 12:38:24 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fe488cf-928d-4865-c3cc-08d7f0f1350d
X-MS-TrafficTypeDiagnostic: MWHPR11MB1824:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1824CA79A24E59B52348334493A70@MWHPR11MB1824.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uwy6JxzVHlUPwRXcN0Q21anwH7G3IAIT7nNlFtWEYAaYMam1UxFY4flaD4UGMlMOnwS9ASDeDbkqVB4M12Ls6URu+I2pVc9NWptIvzbFQpap0U7bo07debwYc4EvGhjykmPsowKfEWu7iPuDhF4PoJ6lM9qRnU+Q9EewZnsaZJyUckAYHZHrpYLdSglUi4z9D7u8G6jl5qMABJ2KNCzsWW4On70DNJXSiGn/ZEK4cHOiEatKOpmlXpuCz+w5SOvQqmVy0r/c4ghTArsfHmHlrp0vCKoN4SjxzeaJtgRNHNzmpy5ImOiio6g0EpOrp4K8loJR23XoM7R7k1xZGaO9avPwRh7x5IG65sHfUqFoL6FzUst+hiudl95GUGkMLDcA+NmC8BhzOMKbRpmCGcFjvSzukeyyGVGUvLeJCR62bmYf+yHh//v/we02ob+RlgZ40yv83aftZ0BsKKeBSXE80DzIPhccBwDq8J6L8PT0YS6V8AAjOgR2ysKlGpCKmJ2IIIZSSc7B4cbj63TVDscFdNyovqFETnphsYVXqDRKdF1kiU+WmiQIQbCUQNC5q2PI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(39850400004)(366004)(376002)(346002)(33430700001)(86362001)(6666004)(107886003)(8886007)(1076003)(6512007)(6486002)(66574012)(36756003)(5660300002)(2906002)(66476007)(6506007)(16526019)(186003)(52116002)(66946007)(66556008)(54906003)(2616005)(4326008)(8936002)(8676002)(316002)(33440700001)(478600001)(43043002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mxtROYWbXqQ0ZOPPXaz/1Irp5fqRWD92XRfdZBlYq+WEN+c9pMkZy7B9QSHgGbqxxXpu6i2zupA45Ovx9DRhl/FIKVeSOGV2fYvHypqtyiUi6B2W/mUdDyJxA3uadV3ey1VchVCNYet3zXMCMtwBI5jeKz6ItS3KebnyP17r9gh+Okq8xv6avk3aON394PEvv7clx11DrD9374znAKd18ESrFesE85PwNHdF0+1SD1g1cxN2M4DdRBTS+/dyTyBqQhLCf9sAQ88x3Q6KhRIj3fqYoykpPnbxLBEmUEBbj2VR65OzgF8hNoMOhOypqW0AJAKf95ne4WwVovc6LgyBcrubXEBeeJVkVi9AE2lVyY9Z1SX0q3UvheECxnrDcFa7BquvVRuvB7Od0p4hVo78QRQoOtncIaoaeb7iAYq0eWYuJwsCJSsG0A2rAaRAIUP8uPeBkecROfuR8ft2V+QpAEHD79e1TG3V8AtPN+FCikIhwvni+SJw4GfIA2k9GVQHyxE6U8szEes4gI2FRnzJ3fZl2JLecEk79x2m7DoXh0tswj3cZ8tIKbvK0lB6zbsHnH7KIYhhIXJOQzZTLiWroNhcLY4k+ZEM3wbNGieksN1rUl16BF8N73O1wrAmbCCRa2DXgQzuHH+0jXyEZfTwvZ4jQNKkeIxP34ZKvQCRpKxiyBxIBLH1XWcvlHZ1K/fnUU/5IQo63pjdKWNE0BqqvwQP7DVKWOEd0iEoxK2WCl8OvodfUNlo2I++8VR0ODrrqseJLhpaX2w1efwuhRLsXAywsWCgQfyZacNCxbDNqjRQg4yz6sD3wCCZ4ABK+ncA6/PXQW25CC6457rv0yQcvdeHIiqexu/esckTc+Qx0Ec=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fe488cf-928d-4865-c3cc-08d7f0f1350d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 12:38:26.8151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jNtWZfCnAtlpm+fuKb4nj/N/wNN95vNtRMjd+utct2mZygeA7+4lg4ViwbgpOR4V2p8qheel0yR4LadbAGduug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1824
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgcG9zc2libGUgdG8gY2hlY2sgaWYgYW4gSVJRIGlzIGVuZGluZyBieSBwb2xsaW5nIHRoZSBj
b250cm9sCnJlZ2lzdGVyLiBUaGlzIGZ1bmN0aW9uIG11c3QgdXNlZCB3aXRoIGNhcmU6IGlmIGFu
IElSUSBmaXJlcyB3aGlsZSB0aGUKaG9zdCByZWFkcyBjb250cm9sIHJlZ2lzdGVyLCB0aGUgSVJR
IGNhbiBiZSBsb3N0LiBIb3dldmVyLCBpdCBjb3VsZCBiZQp1c2VmdWwgaW4gc29tZSBjYXNlcy4K
ClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJz
LmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMgfCAyOCArKysrKysrKysrKysrKysr
KysrKysrKysrKysrCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmggfCAgMSArCiAyIGZpbGVzIGNo
YW5nZWQsIDI5IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2JoLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMKaW5kZXggYmE3ZmEwYTdjZDlhLi5kM2U3
ZWVkODljMzggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvYmguYworKysgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2JoLmMKQEAgLTMwNyw2ICszMDcsMzQgQEAgdm9pZCB3ZnhfYmhfcmVx
dWVzdF90eChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAlxdWV1ZV93b3JrKHN5c3RlbV9oaWdocHJp
X3dxLCAmd2Rldi0+aGlmLmJoKTsKIH0KIAorLyoKKyAqIElmIElSUSBpcyBub3QgYXZhaWxhYmxl
LCB0aGlzIGZ1bmN0aW9uIGFsbG93IHRvIG1hbnVhbGx5IHBvbGwgdGhlIGNvbnRyb2wKKyAqIHJl
Z2lzdGVyIGFuZCBzaW11bGF0ZSBhbiBJUlEgYWhlbiBhbiBldmVudCBoYXBwZW5lZC4KKyAqCisg
KiBOb3RlIHRoYXQgdGhlIGRldmljZSBoYXMgYSBidWc6IElmIGFuIElSUSByYWlzZSB3aGlsZSBo
b3N0IHJlYWQgY29udHJvbAorICogcmVnaXN0ZXIsIHRoZSBJUlEgaXMgbG9zdC4gU28sIHVzZSB0
aGlzIGZ1bmN0aW9uIGNhcmVmdWxseSAob25seSBkdWluZworICogZGV2aWNlIGluaXRpYWxpc2F0
aW9uKS4KKyAqLwordm9pZCB3ZnhfYmhfcG9sbF9pcnEoc3RydWN0IHdmeF9kZXYgKndkZXYpCit7
CisJa3RpbWVfdCBub3csIHN0YXJ0OworCXUzMiByZWc7CisKKwlzdGFydCA9IGt0aW1lX2dldCgp
OworCWZvciAoOzspIHsKKwkJY29udHJvbF9yZWdfcmVhZCh3ZGV2LCAmcmVnKTsKKwkJbm93ID0g
a3RpbWVfZ2V0KCk7CisJCWlmIChyZWcgJiAweEZGRikKKwkJCWJyZWFrOworCQlpZiAoa3RpbWVf
YWZ0ZXIobm93LCBrdGltZV9hZGRfbXMoc3RhcnQsIDEwMDApKSkgeworCQkJZGV2X2Vycih3ZGV2
LT5kZXYsICJ0aW1lIG91dCB3aGlsZSBwb2xsaW5nIGNvbnRyb2wgcmVnaXN0ZXJcbiIpOworCQkJ
cmV0dXJuOworCQl9CisJCXVkZWxheSgyMDApOworCX0KKwl3ZnhfYmhfcmVxdWVzdF9yeCh3ZGV2
KTsKK30KKwogdm9pZCB3ZnhfYmhfcmVnaXN0ZXIoc3RydWN0IHdmeF9kZXYgKndkZXYpCiB7CiAJ
SU5JVF9XT1JLKCZ3ZGV2LT5oaWYuYmgsIGJoX3dvcmspOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9iaC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5oCmluZGV4IDkzY2E5ODQy
NGUwYi4uNGI3MzQzNzg2OWUxIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmgK
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5oCkBAIC0yOCw1ICsyOCw2IEBAIHZvaWQgd2Z4
X2JoX3JlZ2lzdGVyKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KTsKIHZvaWQgd2Z4X2JoX3VucmVnaXN0
ZXIoc3RydWN0IHdmeF9kZXYgKndkZXYpOwogdm9pZCB3ZnhfYmhfcmVxdWVzdF9yeChzdHJ1Y3Qg
d2Z4X2RldiAqd2Rldik7CiB2b2lkIHdmeF9iaF9yZXF1ZXN0X3R4KHN0cnVjdCB3ZnhfZGV2ICp3
ZGV2KTsKK3ZvaWQgd2Z4X2JoX3BvbGxfaXJxKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KTsKIAogI2Vu
ZGlmIC8qIFdGWF9CSF9IICovCi0tIAoyLjI2LjEKCg==
