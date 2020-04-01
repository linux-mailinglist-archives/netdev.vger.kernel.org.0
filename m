Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFF319AA4A
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732632AbgDALGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:06:10 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:6083
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732371AbgDALFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DuIakfpLclIhvC08MDL/J8knykQsinZFlpg5IPJGTIXMgLQ2M7hLeionptugLsxuTKHfKYz+2V8k0bxkMl0Fj572jkWoEpzUm2T14IkxMfgjvzN4HTLRHtERbSF7MLUbRYjlyyh1CH9L6Pyc3QYZRwJgDEmV8t/cYU0ijypBqCzonKIT2DozlZOX71bCd6Nue38dImEo23NsSkHdzDO9ZX+Ah8Yrd21bKObIPKx3LM2rokLC1N7NtgY0EsqfqRt0DVfIyamX5CxI3IFdGMAdqP4yEvnEil3lZi8QqeRiNmaLkvsFO1D8hXNb3hhcMZQX+gIIcZAw5RMTiysjTFUEwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipe2aWSSMB78BnIB4Y4LFB4IIbiiUl6mWBkN44tREXU=;
 b=IIi/uduRDDQfP7kFQecOJZqBIr1Ebqw7dj63N2eEKe9zivY/1tWtZnxEVPn+MPI0w3wbBrbYxxOZ3Z2gOLj1fxvhsPyfz6uvUQOccPbTb/Nx4U45JT2AGHJA5UZOd5cdq0Ud8TLjjllyuZAvo3/3J2kKvP5fGwOJnLwYpuoJUSOIE9z1JHtaBojS64lwrwXJPt+xs5/qWAO4m7PDQpqtO7Omx57IN8cMw8vNEup2HTTg4nWR9ZQwdpnwogDtO/zZhQkzm7L0exZUQRUN3pIClVfUTvY3FTkXtte8TA8gRO1TqaKaHei5rVttZ2gQP1p7aIjOh9gQy4B3INmEdsn5gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipe2aWSSMB78BnIB4Y4LFB4IIbiiUl6mWBkN44tREXU=;
 b=a8cySrl6iFH6icN+yjjognMfL52vVldCG/9+vaE4GdDU8Sh2TzRDBY27GDUDLCxoervqR1rWAZyFAQbghqNIIrSCSlzOZYZb9P99Hj4MISdIgyvqaJmnauWLrrmYiEvMAI3AMY12ehm5YkDwPx0i7BQLj0VKV/yxV4bG4Bihfy8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:05:16 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:05:16 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 27/32] staging: wfx: relocate wfx_skb_dtor() prior its callers
Date:   Wed,  1 Apr 2020 13:04:00 +0200
Message-Id: <20200401110405.80282-28-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:05:14 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98face08-f269-438a-e95a-08d7d62c8ede
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285A4602698C6EBF81A5EBC93C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VVVq+4BeHiIgyQUhbAaFp5+TuAjBw1M8BMgUj1Cf8dNjWCgGwFBMpetIYRindcY6XvKbjVF0pQgm4R+dJ8u0uSkTtubIDzuyDtMmwwpexl8c++KLurn96N3r873GlkpURHkQykcPIelS3buv6kHWjOGrNTo7UIMOjKpGryhjlVRHqFcYPDNnYx9Y/KR028rZ08bYGrgGmKYKkRC89TQUZhXajofrzojKQMxye+aBbhnsFOx7QBdDg7wt1Mz1uW4RcogZelNS30cZPM5xYV5hpNn66zDmNg1kcywye4pO5wzoJMOdRKjkGc/1pC4BJMBuv+fgLn/0bwuxwxAmSq5FjDshkYioLGkoX4dUVipenrSAfyXMr6LzdocR2h+y6olis5cilk7zqVSZovk7R8Mgeza/AGUV7uQEgKsEyqfXsFaTKuSqm1DwZJQp+GAwmOCZ
X-MS-Exchange-AntiSpam-MessageData: VvsOg203fCxAOgFw5SmD5eD+P87gc4+3aDNcVDpkydevIe9l425L3qH+1dMtt+ol+2TWzFppmQwcUM3HAak0PMpD+HJDNJdMARtYfNylJWsRv89FevyUW6nAyPqJ+Yk/4JUX98F1s+KrmrArjnQAUkfCNzRhkLX33pSlxFUBIFUH60DzIl1+uDsOymCov22hNVWOSjvqoTlIIl/JVqem9w==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98face08-f269-438a-e95a-08d7d62c8ede
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:05:16.3141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eT0dG2VgO0kqVvrWsd962Ro2Q/uv2294PB9ZTQESTHZRP0WzcKSGG2Ms13svaZ39Bm/PAUYbeE2Ct4tdlUK3RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
YSBuZXh0IGNvbW1pdCwgd2Ugd291bGQgbGlrZSB0byBtYXJrIHdmeF9za2JfZHRvciBhcyBzdGF0
aWMgYW5kIHN0b3AKdG8gZGVjbGFyZSBpdCBpbiBkYXRhX3R4LmguCgpSZWxvY2F0ZSB3Znhfc2ti
X2R0b3IoKSBwcmlvciBpdHMgY2FsbGVycyB0byBhdm9pZCBjb21waWxlIGVycm9yLgoKU2lnbmVk
LW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgot
LS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwgNzIgKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAzNyBpbnNlcnRpb25zKCspLCAzNSBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCmluZGV4IDE3MjA5ZjY0NWU0Yi4uZWM5NTUx
OGM5MTY3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYworKysgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwpAQCAtNTAzLDYgKzUwMyw0MyBAQCB2b2lkIHdm
eF90eChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV90eF9jb250cm9s
ICpjb250cm9sLAogCWllZWU4MDIxMV90eF9zdGF0dXNfaXJxc2FmZSh3ZGV2LT5odywgc2tiKTsK
IH0KIAorc3RhdGljIHZvaWQgd2Z4X25vdGlmeV9idWZmZXJlZF90eChzdHJ1Y3Qgd2Z4X3ZpZiAq
d3ZpZiwgc3RydWN0IHNrX2J1ZmYgKnNrYikKK3sKKwlzdHJ1Y3QgaWVlZTgwMjExX2hkciAqaGRy
ID0gKHN0cnVjdCBpZWVlODAyMTFfaGRyICopc2tiLT5kYXRhOworCXN0cnVjdCBpZWVlODAyMTFf
c3RhICpzdGE7CisJc3RydWN0IHdmeF9zdGFfcHJpdiAqc3RhX3ByaXY7CisJaW50IHRpZCA9IGll
ZWU4MDIxMV9nZXRfdGlkKGhkcik7CisKKwlyY3VfcmVhZF9sb2NrKCk7IC8vIHByb3RlY3Qgc3Rh
CisJc3RhID0gaWVlZTgwMjExX2ZpbmRfc3RhKHd2aWYtPnZpZiwgaGRyLT5hZGRyMSk7CisJaWYg
KHN0YSkgeworCQlzdGFfcHJpdiA9IChzdHJ1Y3Qgd2Z4X3N0YV9wcml2ICopJnN0YS0+ZHJ2X3By
aXY7CisJCXNwaW5fbG9ja19iaCgmc3RhX3ByaXYtPmxvY2spOworCQlXQVJOKCFzdGFfcHJpdi0+
YnVmZmVyZWRbdGlkXSwgImluY29uc2lzdGVudCBub3RpZmljYXRpb24iKTsKKwkJc3RhX3ByaXYt
PmJ1ZmZlcmVkW3RpZF0tLTsKKwkJaWYgKCFzdGFfcHJpdi0+YnVmZmVyZWRbdGlkXSkKKwkJCWll
ZWU4MDIxMV9zdGFfc2V0X2J1ZmZlcmVkKHN0YSwgdGlkLCBmYWxzZSk7CisJCXNwaW5fdW5sb2Nr
X2JoKCZzdGFfcHJpdi0+bG9jayk7CisJfQorCXJjdV9yZWFkX3VubG9jaygpOworfQorCit2b2lk
IHdmeF9za2JfZHRvcihzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc3RydWN0IHNrX2J1ZmYgKnNrYikK
K3sKKwlzdHJ1Y3QgaGlmX21zZyAqaGlmID0gKHN0cnVjdCBoaWZfbXNnICopc2tiLT5kYXRhOwor
CXN0cnVjdCBoaWZfcmVxX3R4ICpyZXEgPSAoc3RydWN0IGhpZl9yZXFfdHggKiloaWYtPmJvZHk7
CisJc3RydWN0IHdmeF92aWYgKnd2aWYgPSB3ZGV2X3RvX3d2aWYod2RldiwgaGlmLT5pbnRlcmZh
Y2UpOworCXVuc2lnbmVkIGludCBvZmZzZXQgPSBzaXplb2Yoc3RydWN0IGhpZl9yZXFfdHgpICsK
KwkJCQlzaXplb2Yoc3RydWN0IGhpZl9tc2cpICsKKwkJCQlyZXEtPmRhdGFfZmxhZ3MuZmNfb2Zm
c2V0OworCisJV0FSTl9PTighd3ZpZik7CisJc2tiX3B1bGwoc2tiLCBvZmZzZXQpOworCXdmeF9u
b3RpZnlfYnVmZmVyZWRfdHgod3ZpZiwgc2tiKTsKKwl3ZnhfdHhfcG9saWN5X3B1dCh3dmlmLCBy
ZXEtPnR4X2ZsYWdzLnJldHJ5X3BvbGljeV9pbmRleCk7CisJaWVlZTgwMjExX3R4X3N0YXR1c19p
cnFzYWZlKHdkZXYtPmh3LCBza2IpOworfQorCiB2b2lkIHdmeF90eF9jb25maXJtX2NiKHN0cnVj
dCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaGlmX2NuZl90eCAqYXJnKQogewogCWludCBp
OwpAQCAtNTg5LDM5ICs2MjYsNCBAQCB2b2lkIHdmeF90eF9jb25maXJtX2NiKHN0cnVjdCB3Znhf
dmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaGlmX2NuZl90eCAqYXJnKQogCXdmeF9za2JfZHRvcih3
dmlmLT53ZGV2LCBza2IpOwogfQogCi1zdGF0aWMgdm9pZCB3Znhfbm90aWZ5X2J1ZmZlcmVkX3R4
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQotewotCXN0cnVjdCBp
ZWVlODAyMTFfaGRyICpoZHIgPSAoc3RydWN0IGllZWU4MDIxMV9oZHIgKilza2ItPmRhdGE7Ci0J
c3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YTsKLQlzdHJ1Y3Qgd2Z4X3N0YV9wcml2ICpzdGFfcHJp
djsKLQlpbnQgdGlkID0gaWVlZTgwMjExX2dldF90aWQoaGRyKTsKIAotCXJjdV9yZWFkX2xvY2so
KTsgLy8gcHJvdGVjdCBzdGEKLQlzdGEgPSBpZWVlODAyMTFfZmluZF9zdGEod3ZpZi0+dmlmLCBo
ZHItPmFkZHIxKTsKLQlpZiAoc3RhKSB7Ci0JCXN0YV9wcml2ID0gKHN0cnVjdCB3Znhfc3RhX3By
aXYgKikmc3RhLT5kcnZfcHJpdjsKLQkJc3Bpbl9sb2NrX2JoKCZzdGFfcHJpdi0+bG9jayk7Ci0J
CVdBUk4oIXN0YV9wcml2LT5idWZmZXJlZFt0aWRdLCAiaW5jb25zaXN0ZW50IG5vdGlmaWNhdGlv
biIpOwotCQlzdGFfcHJpdi0+YnVmZmVyZWRbdGlkXS0tOwotCQlpZiAoIXN0YV9wcml2LT5idWZm
ZXJlZFt0aWRdKQotCQkJaWVlZTgwMjExX3N0YV9zZXRfYnVmZmVyZWQoc3RhLCB0aWQsIGZhbHNl
KTsKLQkJc3Bpbl91bmxvY2tfYmgoJnN0YV9wcml2LT5sb2NrKTsKLQl9Ci0JcmN1X3JlYWRfdW5s
b2NrKCk7Ci19Ci0KLXZvaWQgd2Z4X3NrYl9kdG9yKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBzdHJ1
Y3Qgc2tfYnVmZiAqc2tiKQotewotCXN0cnVjdCBoaWZfbXNnICpoaWYgPSAoc3RydWN0IGhpZl9t
c2cgKilza2ItPmRhdGE7Ci0Jc3RydWN0IGhpZl9yZXFfdHggKnJlcSA9IChzdHJ1Y3QgaGlmX3Jl
cV90eCAqKWhpZi0+Ym9keTsKLQlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IHdkZXZfdG9fd3ZpZih3
ZGV2LCBoaWYtPmludGVyZmFjZSk7Ci0JdW5zaWduZWQgaW50IG9mZnNldCA9IHNpemVvZihzdHJ1
Y3QgaGlmX3JlcV90eCkgKwotCQkJCXNpemVvZihzdHJ1Y3QgaGlmX21zZykgKwotCQkJCXJlcS0+
ZGF0YV9mbGFncy5mY19vZmZzZXQ7Ci0KLQlXQVJOX09OKCF3dmlmKTsKLQlza2JfcHVsbChza2Is
IG9mZnNldCk7Ci0Jd2Z4X25vdGlmeV9idWZmZXJlZF90eCh3dmlmLCBza2IpOwotCXdmeF90eF9w
b2xpY3lfcHV0KHd2aWYsIHJlcS0+dHhfZmxhZ3MucmV0cnlfcG9saWN5X2luZGV4KTsKLQlpZWVl
ODAyMTFfdHhfc3RhdHVzX2lycXNhZmUod2Rldi0+aHcsIHNrYik7Ci19Ci0tIAoyLjI1LjEKCg==
