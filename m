Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E545B1A46F8
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgDJNdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:33:22 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:31903
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbgDJNdQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bduK8uy3N04M7SiuGQwTm/wM7fNphrNXlQhJlf1ruA2z4OP8Lwj+Hj8NdPe8MQPk0uwEQKoyeY/qaXGc5Oy3Renc6byVfgEUK7vO0GFQxSKd0vvnmdQqnYukNzr/KBHY6ZnKSr8u3NnA5BRwaN+guIRvi51CEcOaqwrYFodn0B0IR50xdTo9WNBWx4aSKFlwqAljK1dau1xzfX3iGKuLiDiEQI8/lq/kvp6zZXKoccM6lBGveKI6hNpgRQhp+HfT2i/hl4tLURsueTwre62Dcif0EXxrwy6I2wrr8SLfoQO6WBvyV/3GgK3sUDFX65nqOjAnQjYL2jYPB2OlfMTR4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2izc7uyB5xdqbmiVLnM3cS7LoKZSmt7UicKL5cibTs=;
 b=hRJ0IuqX8hmj1n2rx/nHym4bJjCiP8UK7cPL2YEj/cUQncmxcgsjGoNmF9VSvEU87zsYTrCiYFcUVeGiz/+m7uH+UFxf5YWqyNa3ThRgGCY7qsFweZYf2k+XuPz6vcYW83mJD2AUOqF5YzvabdRlVBwPwdMeRIhwoRy3p0vzZGtTfOMTvvcC/V2jXnfh/s0YV4R6xQlnSNCC27/S/9u1TgYJE+6ZhB9dMpvASazLhWSYTmZCqysG1qEyA9DmZnOsuFiigJOhltTARGHA2E6kHGCYbf6e5PUnEg/r7XCJiTs6AGKO9sHm684rCiHy8ATxZHHgsaxojoDSLB/6d6p9cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2izc7uyB5xdqbmiVLnM3cS7LoKZSmt7UicKL5cibTs=;
 b=f2qVbwnHgMfFENAXWlnAgVT2c9x7bfImmfPyukAwZimlvtjiDK5Wh0EYtQxfS9Nx2KpTCkwjcS8QA01RZ+k6ZfAn3ub9bOPfGxPBzapxshRWzIdA2XSNnAGlMl5266K+Y8G3GsHXHmPtzyzZE9Rny4/KIlgjQiCTY4XZajPcQl0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:10 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:10 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 06/19] staging: wfx: change the way the station associate to an AP
Date:   Fri, 10 Apr 2020 15:32:26 +0200
Message-Id: <20200410133239.438347-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
References: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR15CA0056.namprd15.prod.outlook.com
 (2603:10b6:3:ae::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:08 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1715a438-8244-456e-579f-08d7dd53b60c
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB43988A32FEE92DE0AC3F189993DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(6666004)(8936002)(4326008)(52116002)(66574012)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4IpcuRAfME5f/oY1B1+lf4jQ66ACBmKUN2cKQmnnpxRhrJvrcGUV0ZP/HGYGcLwK/3d4zHlF2NXR/5d6UyrAVodX3BDGhJ04XVcx7UTe3vGpn9meiXMO54CrCnijkJBcx7u3rnILKJptR3/DjJP9JFHtkSp1T+HRwdANhshjFWUl1wzTaJDNRXgpUujfc1FDfXvo0A71lCgJhIM7i6OpUu+uQzexSVwB/JmOJH17rjDiwyfTeqaUa3bp0aXi50sAURhZ48X1USYUd7GXqbE7CbrJKVS9S+dV9fO9i0bbVKx5RJ8mzm1JBvvDj3vpLIixKqGBcicNkkcaSYf3uP5mxJH2Lam/tTwt/A/c/ejNhug04lqag2bMwQESgdzTjvTHDZWXBTOW+J8y6VE2HcmZW8HZKyGaTp6Q2K1pUDWc9kpQ5MWbv26hOtR4ryt2GpHb
X-MS-Exchange-AntiSpam-MessageData: hmE3p0LxZk++jlaLwS3aTA1o0BauyVz1gyJgC4XURkUElJCLClPgTWQroFRcr2SQ+XeKPRJMNJTK4j8gix0GbQGnOvqw36zSQJEpCUZb2bK5zHo9z9qcVauGKL7Mf/3plOAiItjsyItdnuXBugOisUnrDbYdZjoJAYNFUv/q4zaSP9nc0jSk9P08Lu0JIRk3vf6c/O2C0MDtZMzdbP/2UQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1715a438-8244-456e-579f-08d7dd53b60c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:10.4549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tbs+oXfWTrSN+fYAq36Rx3cTr/j8YjYt55aeCVxxJRlfnTJFG6Q7f51fo7wDkWR7NsHSFtk+us51LacQn8ZRGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ2hp
cHNldCBuZWVkIHR3byBzdGVwcyB0byBhc3NvY2lhdGUgd2l0aCBhbiBBUDoKICAgMS4gaXQgc3Rh
cnQgcmVjZWl2aW5nIGJlYWNvbiBmcm9tIHRoZSBBUCAoZG9uZSB3aXRoIHdmeF9kb19qb2luKCkp
CiAgIDIuIGl0IHNlbnQgdGhlIGFzc29jaWF0aW9uIHJlcXVlc3QgKGRvbmUgd2l0aCB3Znhfam9p
bl9maW5hbGl6ZSgpKQoKVGhlIGpvaW4gcmVxdWVzdCAoc2VlIGhpZl9qb2luKCkpIGNvbnRhaW5z
IGJhc2ljIHJhdGVzLCBiZWFjb24gaW50ZXJ2YWwKYW5kIGJzc2lkIHRvIGNvbm5lY3QsIHNvIHdl
IHRyaWcgb24gdGhlc2UgZXZlbnRzIGZvciB0aGUgZmlyc3Qgc3RlcC4KClRoZSBzZWNvbmQgc3Rl
cCBpcyBvYnZpb3VzbHkgYXNzb2NpYXRlZCB0byB0aGUgZXZlbnQgQlNTX0NIQU5HRURfQVNTT0Mu
CgpOb3RlIHRoYXQgY29uZl9tdXRleCBpcyBub3cgZWFzaWVyIHRvIG1hbmFnZS4gSXQgaXMgaGVs
ZCBieQp3ZnhfYnNzX2luZm9fY2hhbmdlZCgpIGFuZCBpbm5lciBmdW5jdGlvbnMgZG9lcyBub3Qg
bmVlZCB0byBsb2NrIGl0LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9t
ZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCA2
MiArKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAxNyBpbnNlcnRpb25zKCspLCA0NSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCAxZTdm
ZjJiYTMzZDguLmFjYmJjM2E0NDczMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC00NzEsMTYgKzQ3MSwxMSBA
QCBzdGF0aWMgdm9pZCB3ZnhfZG9fam9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAlpbnQgc3Np
ZGxlbiA9IDA7CiAKIAl3ZnhfdHhfbG9ja19mbHVzaCh3dmlmLT53ZGV2KTsKLQltdXRleF9sb2Nr
KCZ3dmlmLT53ZGV2LT5jb25mX211dGV4KTsKLQotCWlmICh3dmlmLT5zdGF0ZSkKLQkJd2Z4X2Rv
X3Vuam9pbih3dmlmKTsKIAogCWJzcyA9IGNmZzgwMjExX2dldF9ic3Mod3ZpZi0+d2Rldi0+aHct
PndpcGh5LCB3dmlmLT5jaGFubmVsLAogCQkJICAgICAgIGNvbmYtPmJzc2lkLCBOVUxMLCAwLAog
CQkJICAgICAgIElFRUU4MDIxMV9CU1NfVFlQRV9BTlksIElFRUU4MDIxMV9QUklWQUNZX0FOWSk7
CiAJaWYgKCFic3MgJiYgIWNvbmYtPmlic3Nfam9pbmVkKSB7Ci0JCW11dGV4X3VubG9jaygmd3Zp
Zi0+d2Rldi0+Y29uZl9tdXRleCk7CiAJCXdmeF90eF91bmxvY2sod3ZpZi0+d2Rldik7CiAJCXJl
dHVybjsKIAl9CkBAIC01MzAsNyArNTI1LDYgQEAgc3RhdGljIHZvaWQgd2Z4X2RvX2pvaW4oc3Ry
dWN0IHdmeF92aWYgKnd2aWYpCiAJCXdmeF91cGRhdGVfZmlsdGVyaW5nKHd2aWYpOwogCX0KIAl3
ZnhfdHhfdW5sb2NrKHd2aWYtPndkZXYpOwotCW11dGV4X3VubG9jaygmd3ZpZi0+d2Rldi0+Y29u
Zl9tdXRleCk7CiB9CiAKIGludCB3Znhfc3RhX2FkZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywg
c3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKQEAgLTY1Myw2ICs2NDcsNyBAQCBzdGF0aWMgdm9p
ZCB3Znhfam9pbl9maW5hbGl6ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAloaWZfc2V0X2Fzc29j
aWF0aW9uX21vZGUod3ZpZiwgaW5mbyk7CiAKIAlpZiAoIWluZm8tPmlic3Nfam9pbmVkKSB7CisJ
CXd2aWYtPnN0YXRlID0gV0ZYX1NUQVRFX1NUQTsKIAkJaGlmX2tlZXBfYWxpdmVfcGVyaW9kKHd2
aWYsIDMwIC8qIHNlYyAqLyk7CiAJCWhpZl9zZXRfYnNzX3BhcmFtcyh3dmlmLCAmd3ZpZi0+YnNz
X3BhcmFtcyk7CiAJCWhpZl9zZXRfYmVhY29uX3dha2V1cF9wZXJpb2Qod3ZpZiwgaW5mby0+ZHRp
bV9wZXJpb2QsCkBAIC02ODEsNyArNjc2LDYgQEAgdm9pZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChz
dHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIHsKIAlzdHJ1Y3Qgd2Z4X2RldiAqd2RldiA9IGh3LT5w
cml2OwogCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gKHN0cnVjdCB3ZnhfdmlmICopIHZpZi0+ZHJ2
X3ByaXY7Ci0JYm9vbCBkb19qb2luID0gZmFsc2U7CiAJaW50IGk7CiAKIAltdXRleF9sb2NrKCZ3
ZGV2LT5jb25mX211dGV4KTsKQEAgLTY5OSw2ICs2OTMsMTQgQEAgdm9pZCB3ZnhfYnNzX2luZm9f
Y2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJfQogCX0KIAorCWlmIChjaGFuZ2Vk
ICYgQlNTX0NIQU5HRURfQkFTSUNfUkFURVMgfHwKKwkgICAgY2hhbmdlZCAmIEJTU19DSEFOR0VE
X0JFQUNPTl9JTlQgfHwKKwkgICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0JTU0lEKSB7CisJCWlm
ICh2aWYtPnR5cGUgPT0gTkw4MDIxMV9JRlRZUEVfU1RBVElPTiB8fAorCQkgICAgdmlmLT50eXBl
ID09IE5MODAyMTFfSUZUWVBFX0FESE9DKQorCQkJd2Z4X2RvX2pvaW4od3ZpZik7CisJfQorCiAJ
aWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9BUF9QUk9CRV9SRVNQIHx8CiAJICAgIGNoYW5nZWQg
JiBCU1NfQ0hBTkdFRF9CRUFDT04pCiAJCXdmeF91cGxvYWRfYXBfdGVtcGxhdGVzKHd2aWYpOwpA
QCAtNzE4LDQxICs3MjAsMTQgQEAgdm9pZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVl
ZTgwMjExX2h3ICpodywKIAkJd2Z4X3R4X3VubG9jayh3ZGV2KTsKIAl9CiAKLQlpZiAoY2hhbmdl
ZCAmIEJTU19DSEFOR0VEX0FTU09DICYmICFpbmZvLT5hc3NvYyAmJgotCSAgICAod3ZpZi0+c3Rh
dGUgPT0gV0ZYX1NUQVRFX1NUQSB8fCB3dmlmLT5zdGF0ZSA9PSBXRlhfU1RBVEVfSUJTUykpIHsK
LQkJd2Z4X2RvX3Vuam9pbih3dmlmKTsKLQl9IGVsc2UgewotCQlpZiAoY2hhbmdlZCAmIEJTU19D
SEFOR0VEX0JFQUNPTl9JTlQpIHsKLQkJCWlmIChpbmZvLT5pYnNzX2pvaW5lZCkKLQkJCQlkb19q
b2luID0gdHJ1ZTsKLQkJfQotCi0JCWlmIChjaGFuZ2VkICYgQlNTX0NIQU5HRURfQlNTSUQpCi0J
CQlkb19qb2luID0gdHJ1ZTsKLQotCQlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0FTU09DIHx8
Ci0JCSAgICBjaGFuZ2VkICYgQlNTX0NIQU5HRURfQlNTSUQgfHwKLQkJICAgIGNoYW5nZWQgJiBC
U1NfQ0hBTkdFRF9JQlNTIHx8Ci0JCSAgICBjaGFuZ2VkICYgQlNTX0NIQU5HRURfQkFTSUNfUkFU
RVMgfHwKLQkJICAgIGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9IVCkgewotCQkJaWYgKGluZm8tPmFz
c29jKSB7Ci0JCQkJaWYgKHd2aWYtPnN0YXRlIDwgV0ZYX1NUQVRFX1BSRV9TVEEpIHsKLQkJCQkJ
aWVlZTgwMjExX2Nvbm5lY3Rpb25fbG9zcyh2aWYpOwotCQkJCQltdXRleF91bmxvY2soJndkZXYt
PmNvbmZfbXV0ZXgpOwotCQkJCQlyZXR1cm47Ci0JCQkJfSBlbHNlIGlmICh3dmlmLT5zdGF0ZSA9
PSBXRlhfU1RBVEVfUFJFX1NUQSkgewotCQkJCQl3dmlmLT5zdGF0ZSA9IFdGWF9TVEFURV9TVEE7
Ci0JCQkJfQotCQkJfSBlbHNlIHsKLQkJCQlkb19qb2luID0gdHJ1ZTsKLQkJCX0KLQotCQkJaWYg
KGluZm8tPmFzc29jIHx8IGluZm8tPmlic3Nfam9pbmVkKQotCQkJCXdmeF9qb2luX2ZpbmFsaXpl
KHd2aWYsIGluZm8pOwotCQkJZWxzZQotCQkJCW1lbXNldCgmd3ZpZi0+YnNzX3BhcmFtcywgMCwK
LQkJCQkgICAgICAgc2l6ZW9mKHd2aWYtPmJzc19wYXJhbXMpKTsKLQkJfQorCWlmIChjaGFuZ2Vk
ICYgQlNTX0NIQU5HRURfQVNTT0MpIHsKKwkJaWYgKGluZm8tPmFzc29jIHx8IGluZm8tPmlic3Nf
am9pbmVkKQorCQkJd2Z4X2pvaW5fZmluYWxpemUod3ZpZiwgaW5mbyk7CisJCWVsc2UgaWYgKCFp
bmZvLT5hc3NvYyAmJiB2aWYtPnR5cGUgPT0gTkw4MDIxMV9JRlRZUEVfU1RBVElPTikKKwkJCXdm
eF9kb191bmpvaW4od3ZpZik7CisJCWVsc2UKKwkJCWRldl93YXJuKHdkZXYtPmRldiwgIiVzOiBt
aXN1bmRlcnN0b29kIGNoYW5nZTogQVNTT0NcbiIsCisJCQkJIF9fZnVuY19fKTsKIAl9CiAKIAlp
ZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0FTU09DIHx8CkBAIC03ODMsOSArNzU4LDYgQEAgdm9p
ZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJd2Z4X3Vw
ZGF0ZV9wbSh3dmlmKTsKIAogCW11dGV4X3VubG9jaygmd2Rldi0+Y29uZl9tdXRleCk7Ci0KLQlp
ZiAoZG9fam9pbikKLQkJd2Z4X2RvX2pvaW4od3ZpZik7CiB9CiAKIHN0YXRpYyBpbnQgd2Z4X3Vw
ZGF0ZV90aW0oc3RydWN0IHdmeF92aWYgKnd2aWYpCi0tIAoyLjI1LjEKCg==
