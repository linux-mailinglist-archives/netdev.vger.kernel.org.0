Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADC219AA1F
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732536AbgDALFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:05:30 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:6083
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732519AbgDALF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njgc14w20R23fOHzYTwh+B4IAXHL+55iZjwWl2UVXDn9WBy4DeeJuPc/XgpgFlGR3TVAFj7UAgp065Ehi13uVDg8rMTTCtdeLB/jnbwWqvttdbngAd4c5csxDLjZKCnbsMULhau2sisObrRGjrIsEA6HrX/rb8EpfhQnr97NkZu84HzXUCGj6QY6Cyjrv4/73ZHgV59OwscTI/KbVtP5s2aRiYwsoJ2g+l411TbArM8B1iLlWI0xK7xUV8HezQ4CFzQV/78zSi2tbE+Prt9cL/ZXVYLG7eCfX342+DBmuAo2txArJXfbVmHaMeeeuzGmoKCUIrPKsbU2J+XDWzNFmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuiUnwuz2aP9VbUPhDjydwCeV6LGGUmPjVg+SxwDwqM=;
 b=TcDAVO22xxraX8gCSfM7eR7jkpUoczSgT/zGQVO6YlrOqaHQDQmInGFlkfzKDbCOY35pSdR/4GAIBKi0qoVYh4hVcBZiuyUD3pGB/bEtJig+2JOqn6OrecJtQizRO3J6ypjYQQPpfLe9Ex8oY8ZDf0wE30/9IUUBvF3S6VPeqwAmgh3TN+XPQZmidxql4hNBhSdlynDWsBZIL4eGEkDsiM2LwIIUluACun185e7aZg8IHxkcXciDIALP+jWTdZmqEPsgXim5xrE6zIIXXegJjAT4mDwAn3X9NuV7FFVWg36HfcYoBZ7Vo5ucb/dHDV33IQ9hxgEV4P46UbQkKx3QuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuiUnwuz2aP9VbUPhDjydwCeV6LGGUmPjVg+SxwDwqM=;
 b=E8Cwhicr/aMSW8+4VwRHNGMS7z+ik1TfhrW/sbbQ9rTd0AsanUXTUPH/aZzHEjV/VRhtgdd4xr5pROGf6A+z8wdfrtJTdeopAzt/MLXqSkDHB1pBqJQoEvxuSHbJ/m8gUdmXxD47JHSp1tto4lt9QUu5VA39vRcijbDWKIrIuKc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:05:20 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:05:20 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 29/32] staging: wfx: wfx_flush() did not ensure that frames are processed
Date:   Wed,  1 Apr 2020 13:04:02 +0200
Message-Id: <20200401110405.80282-30-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0501CA0156.namprd05.prod.outlook.com
 (2603:10b6:803:2c::34) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:05:18 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f4ee1ce-1dfd-40a6-a054-08d7d62c9172
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB428561076EE3E695868B439493C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+Os8x3p0D1MvFCMESx8f4w6kLzWbdtAjT6VVxbGaaDQ1vodwTkiR7MEcHz/Ti7/Kkl2nVo8PLjC8xZ6bJeranXVDeSKBUul8d2WDpUspYPot+LiCqGMK0glB5AM6auId2naRomev9lMQE5JExQMg/eHR2TCLFtQG/ywfNw0qjEIm4JzaPdW2YhwuaXatct+dzJyue7ZPHDLv40Wt4xh+sekwXhtgKNJLv29ypwN1ToXalv2ivnChsDbvn6dp/79gvFknX6BPTC2YdtCz7WUv97YnWwX9Q1ukOWwwIst4TlvE8ZQTTw0m5juHIchMVq0ZP9tLj5Pm+Y7m8OCSzE+U6kP5mu31vZ8K/jX0hcZ1Zh69pwvLiaCQ3jbouQlSz1Dq/O25mGNCP65/JW046/SSmVlscAxcYwKSpETAYo+zGnWVKxtzAR9S/jy7H4R0ZZF
X-MS-Exchange-AntiSpam-MessageData: aWtP+UqJQoh8tA75uY4sUoPsKh47mYY1EXs15EH14+JTMco6X/Zet7049HIwkWArgQe3wXXw+7fwb8CiuxHpqs52KE6q3aIXZEbiKRpom5IRivT6UZSfgFDptPA4YiF+22EgHwgsCkZpAAJVszhE1zlcoS0EtZwcuJTpPbjstggdcqsX8tfVggtYwfE9N9V32ePpUg6tk/oel5p9hXdR3g==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4ee1ce-1dfd-40a6-a054-08d7d62c9172
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:05:20.7655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /OdnmbXSGghxACJ+Vegvd7zkSu7HRuBg5Lh6PmufhWdvbXMTlmNeB2Xkxv1IMwEn55zSUM1xTl9QmjAbhgpI8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X2ZsdXNoKCkgZXhpdGVkIG9uY2UgYWxsIGZyYW1lcyBhcmUgcmV0cmlldmVkIGZyb20gdGhlIGRl
dmljZS4KSG93ZXZlciwgaXQgZGlkIG5vdCBlbnN1cmUgdGhleSB3ZXJlIHByb2Nlc3NlZCBieSBk
cml2ZXIgYmVmb3JlIHRvCnJldHVybi4gVGhlcmVmb3JlLCBzb21lIGZyYW1lIG1heSBiZSBwcm9j
ZXNzZWQgYWZ0ZXIgdGhlIGludGVyZmFjZSBoYXMKZGlzYXBwZWFyLgoKQ2hhbmdlIHRoZSBwbGFj
ZSB3ZSBzaWduYWwgdGhhdCB0aGUgcXVldWUgaXMgZW1wdHkgdG8gZml4IHRoYXQuCgpTaWduZWQt
b2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0t
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvYmguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYmguYwppbmRleCA5ZmNhYjAwYTM3MzMu
LmJhN2ZhMGE3Y2Q5YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvYmguYwpAQCAtMTA4LDggKzEwOCw2IEBAIHN0YXRpYyBpbnQg
cnhfaGVscGVyKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBzaXplX3QgcmVhZF9sZW4sIGludCAqaXNf
Y25mKQogCQkJcmVsZWFzZV9jb3VudCA9IDE7CiAJCVdBUk4od2Rldi0+aGlmLnR4X2J1ZmZlcnNf
dXNlZCA8IHJlbGVhc2VfY291bnQsICJjb3JydXB0ZWQgYnVmZmVyIGNvdW50ZXIiKTsKIAkJd2Rl
di0+aGlmLnR4X2J1ZmZlcnNfdXNlZCAtPSByZWxlYXNlX2NvdW50OwotCQlpZiAoIXdkZXYtPmhp
Zi50eF9idWZmZXJzX3VzZWQpCi0JCQl3YWtlX3VwKCZ3ZGV2LT5oaWYudHhfYnVmZmVyc19lbXB0
eSk7CiAJfQogCV90cmFjZV9oaWZfcmVjdihoaWYsIHdkZXYtPmhpZi50eF9idWZmZXJzX3VzZWQp
OwogCkBAIC0xMjMsNiArMTIxLDggQEAgc3RhdGljIGludCByeF9oZWxwZXIoc3RydWN0IHdmeF9k
ZXYgKndkZXYsIHNpemVfdCByZWFkX2xlbiwgaW50ICppc19jbmYpCiAJc2tiX3B1dChza2IsIGhp
Zi0+bGVuKTsKIAkvLyB3ZnhfaGFuZGxlX3J4IHRha2VzIGNhcmUgb24gU0tCIGxpdmV0aW1lCiAJ
d2Z4X2hhbmRsZV9yeCh3ZGV2LCBza2IpOworCWlmICghd2Rldi0+aGlmLnR4X2J1ZmZlcnNfdXNl
ZCkKKwkJd2FrZV91cCgmd2Rldi0+aGlmLnR4X2J1ZmZlcnNfZW1wdHkpOwogCiAJcmV0dXJuIHBp
Z2d5YmFjazsKIAotLSAKMi4yNS4xCgo=
