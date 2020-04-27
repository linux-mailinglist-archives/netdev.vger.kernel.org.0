Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D501BA53C
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgD0NlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:41:03 -0400
Received: from mail-mw2nam12on2071.outbound.protection.outlook.com ([40.107.244.71]:6160
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727844AbgD0NlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWScUi6LTxJnsK7J9zglDRw4ITVfhnE2KljLit5Z9TnBo6td0dBqiqwEY6a98xn6XcZr7a8+U93a0VHbrR4OnuWiXT8Ds7XDUKQz1ZOZ2CrnD2XnTDEUnhg96Ji4FvhGyAO2qYdRSAwvtOmPjDqkEEIpIdvJ9fmmm7FZZ9MhzPhMF/gKuPiaPFgWz7I3nie2nFVNl9lfjHU3s3b0hsOAlFyET+W0q1YgCLSwsq7GnEzrOv8Po4Ie7NjrbGby5IJO/HkMwpFhVB/JSZT8WP01RjWzRIUMSR7EkW0a+ctHZAZUNR4tcmfA8rk+hlSDcP1d0qVX264EMWRPc5lcHHMxEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNn7O+LkSOLVea7vlLN+uZe+zF/6KR4RChRExQDAq6U=;
 b=I/r3iWoaR3JpJZCqBAIkMj1X8qmeCVqiAdCBlsJGsR1EAODEtKBlm9CZ21UG0Cb335ANZmcQqD68N+gGQBmIlxGslejtwQWvacVjkjkr1nTETPY3nvAoHXfDXOg+bBvjtGtqwNjVuAvrZz10xCgy9V+0C42w8OX3swUobJwphLZ5NCyesn04AzjBnKg1VJwbjmmibm/QqkOTbjrIPpCQ3/4cDHJyct9AwTV8O7s61i3KNPwnj236XaabX/fGl2m24f8sRcKPA6IkJuBiarFbHYbpw6lPmy+BeJA/RhpILL1H0z8r9qMYq8VAXOYVrNkdlgxFrNqyz6fSyLpbCrT+/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNn7O+LkSOLVea7vlLN+uZe+zF/6KR4RChRExQDAq6U=;
 b=oygfM4Gx+6LFVnbZeUrsiauGgTIYvZ89bfElLeNmn4b7U0bOf2aYyKI9F31FSr6Mxd9UlHGgCAH7oNyPs/ObE2HOmLzOJnhlWx8LxAGUXptsNIOSRgWI/MGCYScuCmMWsG714pktQwkQlRakCtorhrgTWTPZL3pjD5ZmcBlBWjI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:00 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:40:59 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 01/17] staging: wfx: fix (future) TDLS support
Date:   Mon, 27 Apr 2020 15:40:15 +0200
Message-Id: <20200427134031.323403-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
References: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::28) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:40:57 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f37661d9-c036-4132-d0d6-08d7eab09ec0
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB14248CBB2264711077927BBC93AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4326008)(81156014)(86362001)(8936002)(6486002)(52116002)(6666004)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(66574012)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2O/UdelLHzAkPrph+RQgbuDNCh2eo6h94npKJqq1lfpeRrFwX0w+PhvdD+C4GZ9fedhqsTUgj//75HfAwXNSDjSQlXkIk3Tt1qduBL9uBRqRO4OVL4Q5E8K8ywbYufpYL8NFfz46e0/GyUhNkEnc/2riBm3ztoNtT1GrI/PC74T1DtmGIxzKoVbOl+WXCj/8fUdL8eYuWzeHg7MFJOxCNf3f5vUnW4c06dv32nVvMH3He1zXmomzEC82h/JxtngSkzCEtff1S+EI+4uHOtVADa1P6stJCJOl1+E7Chh/SsERJ8LWn2v6fgJ8t07GguxDV2MufyrbwAesjFdLbVP2wlMyXQj50STTVzYJPsIUvCkrikYrHfw7F/g02PhEJ6TKYkBUBrlb7CvLo2fnyBYnvjZscnqDOnBDa93H8qK7/ynRuvvOViqzdNLWnvcwpc1d
X-MS-Exchange-AntiSpam-MessageData: kktZQnoBN5aoW+do5KAdTtQuZqrF6zErfPtO/pRMHhSZPws3wh4zO6iH5L20e3+FexrdseO179d3lucqEqTQjcU7HA1gvy9J3USjTSSIaZXB7wcMNSb84h16l29rgFrN9gZ6LyQl1YtVVvslvy5pc3whjni+QSD8UM89sRMDWfsNUV115y5o7wp8xjpdc9I49MXpmOpGBJSqMODh+j7y7pZTZ/t1JYzjtYjTcbkyw/U5G+LOWpAZvKH32KG3zTaIP0c11ZmeKLRqLu5RDwbGyrg2HrDDt4htpYGneP6cTc1SNVgjI6umjJiptl06Ab3B+hOd/mkpuU80XznWZBra0S0etCbwPswkOSz921ERw0vrbOQhQw3yk9bqcd7tZqVcI+wtWx7boeGaL/3XM5jALuJX+WrpJQf2Lw77vi6LwAJIep1w3T5PLSezHVo8gZLUQgniLDxxvl0411dfLaj6/2fmA4/EZ/rwy4Ah//jpucaDEDoH59zFee3Tqw286zGNY70VIqcLnmWAiPi8zAbCKO+lwhrhp4SQHYOPtJJ/JadtsCozcIsvkXEc6O+K3MwF+ZunVTqmzmxmLgBtrR7Db9BpkgMy6NwlZ8BGVC5G+XxvAvWaVv0TIAyOtvF4+cAFGHcn4KXYncOrNSQVipcXYSJ20uujmcnlh8qWR+vJQZmVqNUjPeyt8DyZBNaws8yv2ZfInUwiiEMpI4NgzFXrRbmW0DLw3DuWINWHj+xvFdmyfoV0haGCeCCmy9npmNYwSxOWETmPJ85wKYn2hU7lgOqclVr8vFYGaONpIuWF9IV/veWkMf0LuKiZxDC49FiyPg74FhR1/MQcLoGAZzbImFLGSr4nYXOqByr+VhiFZtE=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f37661d9-c036-4132-d0d6-08d7eab09ec0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:40:59.6953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AZK5Xog5eoDBoXRUhbp2FE6vh7Y3Jz5+75izXQGomzpkUdK7UqT6oc0JrWqZv/SfIAglzQz+7hW2weH7VSI5Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRldmljZSBkb2VzIG5vdCBleHBlY3QgdGhhdCB0aGUgQVAgdG8gaGF2ZSBhIGxpbmstaWQuIEhv
d2V2ZXIsIFRETFMKcGVlcnMgc2hvdWxkIGhhdmUgYSBhIGxpbmstaWQuCgpUaGUgZHJpdmVyIGRv
ZXMgbm90IHlldCBkZWNsYXJlIGl0c2VsZiBhcyBzdXBwb3J0aW5nIFRETFMuCk5vdHdpdGhzdGFu
ZGluZywgZml4IHRoZSBjb2RlIGluIGFudGljaXBhdGlvbiBvZiB0aGUgc3VwcG9ydCBvZiBURExT
LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxh
YnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCA5ICsrKystLS0tLQogMSBm
aWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpp
bmRleCBmM2UxMDZmN2VlYWMuLjIyNjJlMWRlMzdmNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC0zODQsOSAr
Mzg0LDggQEAgaW50IHdmeF9zdGFfYWRkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3Qg
aWVlZTgwMjExX3ZpZiAqdmlmLAogCXNwaW5fbG9ja19pbml0KCZzdGFfcHJpdi0+bG9jayk7CiAJ
c3RhX3ByaXYtPnZpZl9pZCA9IHd2aWYtPmlkOwogCi0JLy8gRklYTUU6IGluIHN0YXRpb24gbW9k
ZSwgdGhlIGN1cnJlbnQgQVBJIGludGVycHJldHMgbmV3IGxpbmstaWQgYXMgYQotCS8vIHRkbHMg
cGVlci4KLQlpZiAodmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04pCisJLy8gSW4g
c3RhdGlvbiBtb2RlLCB0aGUgZmlybXdhcmUgaW50ZXJwcmV0cyBuZXcgbGluay1pZCBhcyBhIFRE
TFMgcGVlci4KKwlpZiAodmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04gJiYgIXN0
YS0+dGRscykKIAkJcmV0dXJuIDA7CiAJc3RhX3ByaXYtPmxpbmtfaWQgPSBmZnood3ZpZi0+bGlu
a19pZF9tYXApOwogCXd2aWYtPmxpbmtfaWRfbWFwIHw9IEJJVChzdGFfcHJpdi0+bGlua19pZCk7
CkBAIC00MDgsOCArNDA3LDggQEAgaW50IHdmeF9zdGFfcmVtb3ZlKHN0cnVjdCBpZWVlODAyMTFf
aHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAogCQlpZiAoc3RhX3ByaXYtPmJ1ZmZl
cmVkW2ldKQogCQkJZGV2X3dhcm4od3ZpZi0+d2Rldi0+ZGV2LCAicmVsZWFzZSBzdGF0aW9uIHdo
aWxlICVkIHBlbmRpbmcgZnJhbWUgb24gcXVldWUgJWQiLAogCQkJCSBzdGFfcHJpdi0+YnVmZmVy
ZWRbaV0sIGkpOwotCS8vIEZJWE1FOiBzZWUgbm90ZSBpbiB3Znhfc3RhX2FkZCgpCi0JaWYgKHZp
Zi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9TVEFUSU9OKQorCS8vIFNlZSBub3RlIGluIHdmeF9z
dGFfYWRkKCkKKwlpZiAoIXN0YV9wcml2LT5saW5rX2lkKQogCQlyZXR1cm4gMDsKIAkvLyBGSVhN
RSBhZGQgYSBtdXRleD8KIAloaWZfbWFwX2xpbmsod3ZpZiwgc3RhLT5hZGRyLCAxLCBzdGFfcHJp
di0+bGlua19pZCk7Ci0tIAoyLjI2LjEKCg==
