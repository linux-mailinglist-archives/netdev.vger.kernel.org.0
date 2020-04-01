Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB5519AA6F
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732244AbgDALHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:07:52 -0400
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:6024
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732312AbgDALEz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:04:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AVxqCNBlB0I8Pcq4tmBXgOUuuEWsInjRfMH/UdAyEnUmXYSX1XLaoSPk6aUfPoOmPFqM5JzW7mR3SZ7WUji2YJm/c10SbeiTjLt2dIOGGaHyBE3E1DGrzAkNbcW20nSLJNlt7ccpd/Ky8y2Hgl3n6ur6C6OAdcN0WDM+Glg77MiQJRRKeIWKz3xM2lzO5vmcaGbMRlgS2F6IS0pvqf75IkCIFOt1ATQZEsszTqOZeWK+cWlryDCMwPNIjp4vlDa/dqVoDRo+29yo9W5xTXel9C2yDA2/Q6h2Snbziu//MK0gA7CY/G/IB0tytIWohlAusiJVWPYqBELGjDUK0zut5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ixh1kI1Qt5S2Eb+CPATQzrHK332RntXNptR9YznsozY=;
 b=HQM2AMzCl2XTn3EEl8sOhUgWWD01rhARF4Bpoxiggj6uhtT57qwLu759R+IwMSUyJO92IYd7iIcfolIn6HRZ8094oKYXIVnQkraOUWPzMeYk+MQXc7MpA7SAhRWY1jwF1R0Vcout8kx/Y7b1q87PhQzUBaMdBAPfLnVPUHs30IuHLmyzXiaRP2rtah2QjfwFICgPGGZDB3Z/2VeNq1TBB5r3T8Pmr0mMoW9M3JdG0SBAjmnB7iDok3XHyzKRS72N1orTwxE5Hd5tF++n/B742gZDoGkMG2ICm5ZZGTZ19SntVumGUurPdSKybCUDmeG9PeYKqTYxapV/AdKWnaYuug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ixh1kI1Qt5S2Eb+CPATQzrHK332RntXNptR9YznsozY=;
 b=TSzlJPgTZ7w9XMBwS2lLw+soowe8HXWRb6J3CiRIG+Hg8C49fWlNePomosDZ4ISRx4kVWqwlv4lQ/ct0qE1NITBDvCQomS0sgzw7lrUJKhsoEeXwuzRFvujxMpIdgjPxYxEw3LSM/szt98ORgvSEvj6fejejxQzVFFNIZtQdrZo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:36 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:36 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 08/32] staging: wfx: simplify hif_handle_tx_data()
Date:   Wed,  1 Apr 2020 13:03:41 +0200
Message-Id: <20200401110405.80282-9-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:34 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ebcc93b-d074-446a-d67e-08d7d62c772d
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB42858EEAA56BA11C64E5C5FC93C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4hp4Kt/JEx7J1c18Z1udEV141S4a1O84JN6cYovakw+E1NDq8V+OI2hVeQ975qTCum45wGxT3R8KxwGNDHpWLBKWlhIL4gJLjrMO84PmxawjVtehcKWUkKUI2T3zp/JHWO6z6KAjFvS0LpMIT9lgyJZ8wUfWUZ4r/vKQ/diq97q/iZo7jzKtUcnudubdaTIWiT70IhMNdzmp9ucg28QlP5fI2/2A0tqwQQYl+m0vuUg5KnH4kJa3atob8Q1XisXx+CoSxBmFEzgTcL4FiDm4eP81x20gXnvOCFPCauKTFHMADh8PoLbcLBI1E0GxL2Aw3q6n0odvuHRPO6qS+6WBKf9McSi2HI831hNzShZnoKgRlOOphuYTjBwBT0Q0o87m9FN1yHr0kLsmPqI4ecNrjU82WEO0kDHopwns4Jntwy5SAmz0/rkGVEsIGw8MuZ5X
X-MS-Exchange-AntiSpam-MessageData: gv7ksC2TDwtcWJ9daevmbuJkZg6g0VnZ7v6tHGvbsT1AmwO9aJB9n0jBvVdBmc3v7569SInypzY2u5jqhnWT34yT+/zc74FxPMCTjoHiS6T5UQid0XAlE8mNisTsZlrZ6H+7QZ7o+aMnLtroF2j2A9qwfywHaw7bvygHw06ilnSi1XEAXTvkPBVWmRNjzE5PtiKtCVnOcDo1o8rvgMEQYQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ebcc93b-d074-446a-d67e-08d7d62c772d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:36.5210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pl2jMYeIPnlCPCtKJIwj/rOaHclvqIqB9r3IAT9s90e1J5ZFbLATsjs2El3hk5J6x0qFPexL7BUNUFnCBK50cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGxhc3QgYXJndW1lbnQgb2YgaGlmX2hhbmRsZV90eF9kYXRhKCkgd2FzIG5vdyB1bnVzZWQuIElu
IGFkZCwKaGlmX2hhbmRsZV90eF9kYXRhKCkgaGFzIG5vdGhpbmcgdG8gZG8gd2l0aCBISUYgbGF5
ZXIgYW5kIHNob3VsZCBiZQpyZW5hbWVkLiBGaW5hbGx5LCBpdCBub3QgY29udmVuaWVudCB0byBw
YXNzIGEgd2Z4X3ZpZiBhcyBwYXJhbWV0ZXIuIEl0CmlzIGVhc2llciB0byBsZXQgaGlmX2hhbmRs
ZV90eF9kYXRhKCkgZmluZCB0aGUgaW50ZXJmYWNlIGl0c2VsZi4KClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L3F1ZXVlLmMgfCAxOSArKysrKysrKysrLS0tLS0tLS0tCiAxIGZpbGUgY2hh
bmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKaW5k
ZXggMjU1M2Y3NzUyMmQ5Li44NjQ3NzMxZTAyYzAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvcXVldWUuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKQEAgLTMxOSwx
MyArMzE5LDE3IEBAIGJvb2wgd2Z4X3R4X3F1ZXVlc19pc19lbXB0eShzdHJ1Y3Qgd2Z4X2RldiAq
d2RldikKIAlyZXR1cm4gcmV0OwogfQogCi1zdGF0aWMgYm9vbCBoaWZfaGFuZGxlX3R4X2RhdGEo
c3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBza19idWZmICpza2IsCi0JCQkgICAgICAgc3Ry
dWN0IHdmeF9xdWV1ZSAqcXVldWUpCitzdGF0aWMgYm9vbCB3ZnhfaGFuZGxlX3R4X2RhdGEoc3Ry
dWN0IHdmeF9kZXYgKndkZXYsIHN0cnVjdCBza19idWZmICpza2IpCiB7CiAJc3RydWN0IGhpZl9y
ZXFfdHggKnJlcSA9IHdmeF9za2JfdHhyZXEoc2tiKTsKIAlzdHJ1Y3QgaWVlZTgwMjExX2tleV9j
b25mICpod19rZXkgPSB3Znhfc2tiX3R4X3ByaXYoc2tiKS0+aHdfa2V5OwogCXN0cnVjdCBpZWVl
ODAyMTFfaGRyICpmcmFtZSA9CiAJCShzdHJ1Y3QgaWVlZTgwMjExX2hkciAqKShyZXEtPmZyYW1l
ICsgcmVxLT5kYXRhX2ZsYWdzLmZjX29mZnNldCk7CisJc3RydWN0IHdmeF92aWYgKnd2aWYgPQor
CQl3ZGV2X3RvX3d2aWYod2RldiwgKChzdHJ1Y3QgaGlmX21zZyAqKXNrYi0+ZGF0YSktPmludGVy
ZmFjZSk7CisKKwlpZiAoIXd2aWYpCisJCXJldHVybiBmYWxzZTsKIAogCS8vIEZJWE1FOiBtYWM4
MDIxMSBpcyBzbWFydCBlbm91Z2ggdG8gaGFuZGxlIEJTUyBsb3NzLiBEcml2ZXIgc2hvdWxkIG5v
dAogCS8vIHRyeSB0byBkbyBhbnl0aGluZyBhYm91dCB0aGF0LgpAQCAtMzQ0LDEyICszNDgsMTIg
QEAgc3RhdGljIGJvb2wgaGlmX2hhbmRsZV90eF9kYXRhKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBz
dHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCSAgICBod19rZXkgJiYgaHdfa2V5LT5rZXlpZHggIT0gd3Zp
Zi0+d2VwX2RlZmF1bHRfa2V5X2lkICYmCiAJICAgIChod19rZXktPmNpcGhlciA9PSBXTEFOX0NJ
UEhFUl9TVUlURV9XRVA0MCB8fAogCSAgICAgaHdfa2V5LT5jaXBoZXIgPT0gV0xBTl9DSVBIRVJf
U1VJVEVfV0VQMTA0KSkgewotCQl3ZnhfdHhfbG9jayh3dmlmLT53ZGV2KTsKKwkJd2Z4X3R4X2xv
Y2sod2Rldik7CiAJCVdBUk5fT04od3ZpZi0+d2VwX3BlbmRpbmdfc2tiKTsKIAkJd3ZpZi0+d2Vw
X2RlZmF1bHRfa2V5X2lkID0gaHdfa2V5LT5rZXlpZHg7CiAJCXd2aWYtPndlcF9wZW5kaW5nX3Nr
YiA9IHNrYjsKIAkJaWYgKCFzY2hlZHVsZV93b3JrKCZ3dmlmLT53ZXBfa2V5X3dvcmspKQotCQkJ
d2Z4X3R4X3VubG9jayh3dmlmLT53ZGV2KTsKKwkJCXdmeF90eF91bmxvY2sod2Rldik7CiAJCXJl
dHVybiB0cnVlOwogCX0gZWxzZSB7CiAJCXJldHVybiBmYWxzZTsKQEAgLTQ5NiwxMyArNTAwLDEw
IEBAIHN0cnVjdCBoaWZfbXNnICp3ZnhfdHhfcXVldWVzX2dldChzdHJ1Y3Qgd2Z4X2RldiAqd2Rl
dikKIAkJc2tiID0gd2Z4X3R4X3F1ZXVlX2dldCh3ZGV2LCBxdWV1ZSwgdHhfYWxsb3dlZF9tYXNr
KTsKIAkJaWYgKCFza2IpCiAJCQljb250aW51ZTsKLQkJaGlmID0gKHN0cnVjdCBoaWZfbXNnICop
c2tiLT5kYXRhOwotCQl3dmlmID0gd2Rldl90b193dmlmKHdkZXYsIGhpZi0+aW50ZXJmYWNlKTsK
LQkJV0FSTl9PTighd3ZpZik7CiAKLQkJaWYgKGhpZl9oYW5kbGVfdHhfZGF0YSh3dmlmLCBza2Is
IHF1ZXVlKSkKKwkJaWYgKHdmeF9oYW5kbGVfdHhfZGF0YSh3ZGV2LCBza2IpKQogCQkJY29udGlu
dWU7ICAvKiBIYW5kbGVkIGJ5IFdTTSAqLwogCi0JCXJldHVybiBoaWY7CisJCXJldHVybiAoc3Ry
dWN0IGhpZl9tc2cgKilza2ItPmRhdGE7CiAJfQogfQotLSAKMi4yNS4xCgo=
