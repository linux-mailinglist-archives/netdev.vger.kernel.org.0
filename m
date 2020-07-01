Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE01A210EAA
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbgGAPI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:08:58 -0400
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:52640
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731724AbgGAPIf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 11:08:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e19KJhKS8yZJ0FiTiz1TGhknut11msWmg0WVTIhe3ZuwgtqoR8iF+r/DYhRm8/iBP3XQlTk8w8Z6egP+tfrx9EXulAqafIw+pNoGa/2R35qPSU9j3AMZJDsH50+kjHKCAxruqpv6tZFwwq51pFtkH9yuZ90WHiiYfVMlzn3ipTotKCI+Zh3qz1ApYkyzEeikBgURXawIQoHp3RCfx4esfC0pYnvwGyUxY31+PTCv4vDBcvWQvgs45toqi3Y/Zgsxpa6ORuKBfViKk7sqULDF7aUmQjC07Z05H/cvzrdyXhKQ2TE2O+Q51B2L3kMiAwQZFI+zavC+Jje5Xvmeqtgg5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7qhSZGDaIuv3wC9nAfoolTg6r6BTwjMVpN6rCLAOHU=;
 b=Xj9z9ql1FgoxxpoFVW7Ml2ualadJgzX5JzHnJ4286sk16iQMoH7Kw2+qLmbYj/uh+CeZ65I5hWRoxbX8w6GsNlPEPe6epl8TWG0Xu3BriKILKjUYCwueXADXjbUvPlYWgglhU4U6DWS0idEOuxqzX0IRI7HvTfA0nNJVZIwHIZs/SYfCyMF/aOomVl3Hnwmzx7EBwWjrncX6aFjRa3E9YhUcuP96uu4wDE5lSxCe8+f++TNFxIBF7kGY+cZ/kG1uwXPd7ZC6qFFUSBLh6XP7yHXanNV03K0e+BrbQSTElBzzQsMEgtr1rDun2G0X/ZIFmG2aDyi6psK+iQxi1U/xUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7qhSZGDaIuv3wC9nAfoolTg6r6BTwjMVpN6rCLAOHU=;
 b=CCLp7rUkfOYZb3F45h287vTd4hY5XhJxAXF03taY1Badkto95iAj/rsjB65mGfR/XbhThcI0RuzD10c1jl2wFkfTrx1gKuhdwOkJXFCRVBChXyvDdaGmFmQUzIw+ntTDXwupJ9jLA0jW8pYVJce7qd45ny5anykGBOpN6rA6LEA=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4736.namprd11.prod.outlook.com (2603:10b6:806:9f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Wed, 1 Jul
 2020 15:08:22 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3131.033; Wed, 1 Jul 2020
 15:08:22 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 11/13] staging: wfx: fix CCMP/TKIP replay protection
Date:   Wed,  1 Jul 2020 17:07:05 +0200
Message-Id: <20200701150707.222985-12-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR07CA0143.namprd07.prod.outlook.com (2603:10b6:3:13e::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Wed, 1 Jul 2020 15:08:20 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efa75f7b-2a47-41c3-2984-08d81dd09874
X-MS-TrafficTypeDiagnostic: SA0PR11MB4736:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4736E759FB4BD73DC09E7C05936C0@SA0PR11MB4736.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgSxdpnY65M8YbytWEX9uZW/I2/KYKkhZKOkBQyRdKXQYAPfARzsps3JiVriiUzIWt7wdpFGrdgC/NLeWlAb+A8nWRQACRfdGsXU0z1jBtVJfsUxyPkb+7emABGtOw4mHNu/eWe+5AM1vHrPaSbQBA8i0BmFYMNdpxIdDmUNCnMTsVlbz20jGKTfqTf24d+IJPikzZCLb/0vAfxVySAs7IeZlpprnXmf+lRJPO1QSboyLD1zj0XZSWnMe3tA9NmQ9kxXAa0Gkh4XSMgf/F/+57S0qp7ipdZuXAYqLR3n/WGBP7/Gjvel8B9bdEJj0qt2RjW+70EryoPGTGW0RPv+Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(366004)(346002)(376002)(396003)(136003)(5660300002)(6486002)(86362001)(6666004)(66574015)(36756003)(2906002)(186003)(83380400001)(16526019)(8936002)(66556008)(66476007)(107886003)(4326008)(8676002)(2616005)(1076003)(478600001)(316002)(54906003)(66946007)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZDDlVKgCpX0L7tmz0Sf8NK7Gyv/kkYoKz5ieoyJCfHUK1urcbfdxerQKp6x2ohfd8lc4Val7UNZdLaEpXUY8kw4W7uUWk7HiXf2J4tJF7b8UUCIvVj12727piseUbikJTAteJBwRed9fG+/Ld/ImRxbQouPAN531MtzN/d73BsoOOdEjPsHVrPl+FANkPV2+Ds2VOTlNo27ppkmI3nAMAYuwmT1mD2Dvtd52ETF7O5nkbgSEZBmx+Ef+bxKPwCQTJlL6p3AGUcxXveMl94dOjL2qVkJOCISXMBRH82L221yF2Ef1+xy1mzZTA0SJlyjX4XkLdKW/pxo5LKsLKIRr9Diu3yh4o03Mm41c8hu8/V851Ot9FvJwq4clUw5d42cTfCsZ/zXvi/B35dcOuw3hGS3zOfXkgPcXOjEsRLuVWkeU5Io5TP0sfMfCJ/i0Xj4sImZMYqZdKkKM5IbEV0FJt4ZLCp5dkr1MetRYrpV3rr9HYpML0cA8DByDr+nDCbHeP+m9Ld0As5o1M+269RF4fA4cl4lMwK2ys63lCeyzWDY=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efa75f7b-2a47-41c3-2984-08d81dd09874
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 15:08:22.3366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xUtjOB4eR+WPE6GEqNXYHTYCYSgmZxnSfKk5thReaxKWYsKqjrjdn7kJxaJOG9Hu8lFe2T87zU9UqSk5Ee92UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4736
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVG8g
ZW5hYmxlIHRoZSBUS0lQL0NDTVAgcmVwbGF5IHByb3RlY3Rpb24sIHRoZSBmcmFtZXMgaGFzIHRv
IGJlCnByb2Nlc3NlZCBpbiB0aGUgcmlnaHQgb3JkZXIuIEhvd2V2ZXIsIHRoZSBkZXZpY2UgaXMg
bm90IGFibGUgdG8KcmUtb3JkZXIgdGhlIGZyYW1lcyBkdXJpbmcgQmxvY2tBY2sgc2Vzc2lvbnMu
CgpNYWM4MDIxMSBpcyBhYmxlIHRvIHJlb3JkZXIgdGhlIGZyYW1lcywgYnV0IGl0IG5lZWQgdGhl
IGluZm9ybWF0aW9uCmFib3V0IHRoZSBCbG9ja0FjayBzZXNzaW9ucyBzdGFydCBhbmQgc3RvcC4g
VW5mb3J0dW5hdGVseSwgc2luY2UgdGhlCkJsb2NrQWNrIGlzIGZ1bGx5IGhhbmRsZWQgYnkgdGhl
IGhhcmR3YXJlLCB0aGVzZSBmcmFtZXMgd2VyZSBub3QKZm9yd2FyZGVkIHRvIHRoZSBob3N0LiBT
bywgaWYgdGhlIGRyaXZlciBhc2sgdG8gbWFjODAyMTEgdG8gYXBwbHkgdGhlCnJlcGxheSBwcm90
ZWN0aW9uLCBpdCBkcm9wIGFsbCBtaXNvcmRlcmVkIGZyYW1lcy4KClNvLCB1bnRpbCBub3csIHRo
ZSBkcml2ZXIgZXhwbGljaXRseSBhc2tlZCB0byBtYWM4MDIxMSB0byBub3QgYXBwbHkKdGhlIEND
TVAvVEtJUCByZXBsYXkgcHJvdGVjdGlvbi4KClRoZSBzaXR1YXRpb24gaGFzIGNoYW5nZWQgd2l0
aCB0aGUgQVBJIDMuNCBvZiB0aGUgZGV2aWNlIGZpcm13YXJlLiBUaGUKZmlybXdhcmUgZm9yd2Fy
ZCB0aGUgQmxvY2tBY2sgaW5mb3JtYXRpb24uIE1hYzgwMjExIGlzIG5vdyBhYmxlIHRvCmNvcnJl
Y3RseSByZW9yZGVyIHRoZSBmcmFtZXMuIFRoZXJlIGlzIG5vIG1vcmUgcmVhc29ucyB0byBkcm9w
CmNyeXB0b2dyYXBoaWMgZGF0YS4KClRoaXMgcGF0Y2ggYWxzbyBpbXBhY3QgdGhlIG9sZGVyIGZp
cm13YXJlcy4gVGhlcmUgd2lsbCBiZSBhIHBlcmZvcm1hbmNlCmltcGFjdCBvbiB0aGVzZSBmaXJt
d2FyZSAoc2luY2UgdGhlIG1pc29yZGVyZWQgZnJhbWVzIHdpbGwgZHJvcHBlZCkuCkhvd2V2ZXIs
IHdlIGNhbid0IGtlZXAgdGhlIHJlcGxheSBwcm90ZWN0aW9uIGRpc2FibGVkLgoKU2lnbmVkLW9m
Zi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0K
IGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV9yeC5jIHwgMzEgKysrKysrKysrKysrKysrKysrKysr
KysrKystLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgfCAgMyArKy0KIDIgZmls
ZXMgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcnguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0
YV9yeC5jCmluZGV4IDYwZTJlNWNiNDY1NmEuLjZmYjA3ODg4MDc0MjYgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGF0YV9yeC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0
YV9yeC5jCkBAIC0xMyw2ICsxMywyNCBAQAogI2luY2x1ZGUgImJoLmgiCiAjaW5jbHVkZSAic3Rh
LmgiCiAKK3N0YXRpYyB2b2lkIHdmeF9yeF9oYW5kbGVfYmEoc3RydWN0IHdmeF92aWYgKnd2aWYs
IHN0cnVjdCBpZWVlODAyMTFfbWdtdCAqbWdtdCkKK3sKKwlpbnQgcGFyYW1zLCB0aWQ7CisKKwlz
d2l0Y2ggKG1nbXQtPnUuYWN0aW9uLnUuYWRkYmFfcmVxLmFjdGlvbl9jb2RlKSB7CisJY2FzZSBX
TEFOX0FDVElPTl9BRERCQV9SRVE6CisJCXBhcmFtcyA9IGxlMTZfdG9fY3B1KG1nbXQtPnUuYWN0
aW9uLnUuYWRkYmFfcmVxLmNhcGFiKTsKKwkJdGlkID0gKHBhcmFtcyAmIElFRUU4MDIxMV9BRERC
QV9QQVJBTV9USURfTUFTSykgPj4gMjsKKwkJaWVlZTgwMjExX3N0YXJ0X3J4X2JhX3Nlc3Npb25f
b2ZmbCh3dmlmLT52aWYsIG1nbXQtPnNhLCB0aWQpOworCQlicmVhazsKKwljYXNlIFdMQU5fQUNU
SU9OX0RFTEJBOgorCQlwYXJhbXMgPSBsZTE2X3RvX2NwdShtZ210LT51LmFjdGlvbi51LmRlbGJh
LnBhcmFtcyk7CisJCXRpZCA9IChwYXJhbXMgJiAgSUVFRTgwMjExX0RFTEJBX1BBUkFNX1RJRF9N
QVNLKSA+PiAxMjsKKwkJaWVlZTgwMjExX3N0b3BfcnhfYmFfc2Vzc2lvbl9vZmZsKHd2aWYtPnZp
ZiwgbWdtdC0+c2EsIHRpZCk7CisJCWJyZWFrOworCX0KK30KKwogdm9pZCB3ZnhfcnhfY2Ioc3Ry
dWN0IHdmeF92aWYgKnd2aWYsCiAJICAgICAgIGNvbnN0IHN0cnVjdCBoaWZfaW5kX3J4ICphcmcs
IHN0cnVjdCBza19idWZmICpza2IpCiB7CkBAIC01MywxNSArNzEsMTggQEAgdm9pZCB3Znhfcnhf
Y2Ioc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJaGRyLT5hbnRlbm5hID0gMDsKIAogCWlmIChhcmct
PnJ4X2ZsYWdzLmVuY3J5cCkKLQkJaGRyLT5mbGFnIHw9IFJYX0ZMQUdfREVDUllQVEVEIHwgUlhf
RkxBR19QTl9WQUxJREFURUQ7CisJCWhkci0+ZmxhZyB8PSBSWF9GTEFHX0RFQ1JZUFRFRDsKIAot
CS8qIEZpbHRlciBibG9jayBBQ0sgbmVnb3RpYXRpb246IGZ1bGx5IGNvbnRyb2xsZWQgYnkgZmly
bXdhcmUgKi8KKwkvLyBCbG9jayBhY2sgbmVnb2NpYXRpb24gaXMgb2ZmbG9hZGVkIGJ5IHRoZSBm
aXJtd2FyZS4gSG93ZXZlciwKKwkvLyByZS1vcmRlcmluZyBtdXN0IGJlIGRvbmUgYnkgdGhlIG1h
YzgwMjExLgogCWlmIChpZWVlODAyMTFfaXNfYWN0aW9uKGZyYW1lLT5mcmFtZV9jb250cm9sKSAm
JgotCSAgICBhcmctPnJ4X2ZsYWdzLm1hdGNoX3VjX2FkZHIgJiYKLQkgICAgbWdtdC0+dS5hY3Rp
b24uY2F0ZWdvcnkgPT0gV0xBTl9DQVRFR09SWV9CQUNLKQorCSAgICBtZ210LT51LmFjdGlvbi5j
YXRlZ29yeSA9PSBXTEFOX0NBVEVHT1JZX0JBQ0sgJiYKKwkgICAgc2tiLT5sZW4gPiBJRUVFODAy
MTFfTUlOX0FDVElPTl9TSVpFKSB7CisJCXdmeF9yeF9oYW5kbGVfYmEod3ZpZiwgbWdtdCk7CiAJ
CWdvdG8gZHJvcDsKKwl9CisKIAlpZWVlODAyMTFfcnhfaXJxc2FmZSh3dmlmLT53ZGV2LT5odywg
c2tiKTsKLQogCXJldHVybjsKIAogZHJvcDoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggNWM3NDRk
OWM4YzExNC4uM2FjZjRlYjAyMTRkYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9k
YXRhX3R4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKQEAgLTQxOCw3ICs0
MTgsOCBAQCB2b2lkIHdmeF90eChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4
MDIxMV90eF9jb250cm9sICpjb250cm9sLAogCQl3dmlmID0gd3ZpZl9pdGVyYXRlKHdkZXYsIE5V
TEwpOwogCWlmIChXQVJOX09OKCF3dmlmKSkKIAkJZ290byBkcm9wOwotCS8vIEZJWE1FOiB3aHk/
CisJLy8gQmVjYXVzZSBvZiBUWF9BTVBEVV9TRVRVUF9JTl9IVywgbWFjODAyMTEgZG9lcyBub3Qg
dHJ5IHRvIHNlbmQgYW55CisJLy8gQmxvY2tBY2sgc2Vzc2lvbiBtYW5hZ2VtZW50IGZyYW1lLiBU
aGUgY2hlY2sgYmVsb3cgZXhpc3QganVzdCBpbiBjYXNlLgogCWlmIChpZWVlODAyMTFfaXNfYWN0
aW9uX2JhY2soaGRyKSkgewogCQlkZXZfaW5mbyh3ZGV2LT5kZXYsICJkcm9wIEJBIGFjdGlvblxu
Iik7CiAJCWdvdG8gZHJvcDsKLS0gCjIuMjcuMAoK
