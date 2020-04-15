Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6591AAD66
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410248AbgDOQMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:12:43 -0400
Received: from mail-eopbgr700077.outbound.protection.outlook.com ([40.107.70.77]:38433
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410235AbgDOQMd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:12:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4X+dWKGir9hmlC69xsQl0BrG+RW6tFS2+ejSn6ATxwV4NH5BXjw60QkB3GKDuyQDjygMfHeWvx78BqCkOgYS6mVja+wJauj2Ex8KsMQb8D4HPNk8AiORGFqsn3QMiPBeD4f3Y7T35LVlH35/p5di+wRp4yGh7ttsmwEwD4e4NaEXSgt/uJqazTyszZTma+H7hxo6HLqPV7D4vDZMEEE3zUM1zK/0isKsWXlbfev7bmagbACFtZEZTGlo0Ak8G26Y4Fh2P/pAkhLYiDTGjU4mUmgEx7wYt6GpiQP0JzJ3yH80ahrAAgcF1dU9ATiQVGyv2nRuAG1HuWGMHiqmRNIUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YT2VADB+GGJ3Msh7hizMM+OgRTfpOnA8TW0G5pIreY=;
 b=XPHICGMB61pJuUD7ReNsU5j0cMfla5634B3ZEwbCYUpn/2eQi19AehVXsVM919vrMyXD7e1qIb+p8pAgDyRKVnIz+wlrKDAXKpxzh3d3YSpmM/c/cZLVdsLynEZDtpB1kU0Z8YaZl8hFbqlcoBvyuDte2UZWuhMyO2KDZZKNQ1175NFEBO7fp12HSGcav1ZqZP3WElg94V9V9ADHEBCZzwUD4UW++ijrHfBgMWjB/10se6OolmDlEQy/bQKLaG/5+KdKhSDSG5fuZD7iZ/kyNQ7qplS8gmp2bYnMOPVQ7CR5hwLlGb0yaPWidCQrlfQDwCzy5yLDN+CEK+iYXxPFew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YT2VADB+GGJ3Msh7hizMM+OgRTfpOnA8TW0G5pIreY=;
 b=Rz7R/kSva9UsHxmnl005M8eNJDFtF4blxp0UBtj58sVUHGf9nzqPkk2wf2ANyCH0HLc0ul9MDQah8UbwwVV8tbCbbCyqi2NGZzbU9st8aTNxvSZ3gkLwGfb+dTzjK/W7vd5K19LN9T3zNs0gGRpUPYoF8qB4wr3I6PG7+qRUPDU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1408.namprd11.prod.outlook.com (2603:10b6:300:24::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Wed, 15 Apr
 2020 16:12:21 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:12:21 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 04/20] staging: wfx: simplify handling of beacon filter during join process
Date:   Wed, 15 Apr 2020 18:11:31 +0200
Message-Id: <20200415161147.69738-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
References: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::40) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:19 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47210ce1-d1af-41f9-f4c5-08d7e157c6b4
X-MS-TrafficTypeDiagnostic: MWHPR11MB1408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1408DA02B422C2CF9537513D93DB0@MWHPR11MB1408.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(396003)(376002)(346002)(39850400004)(366004)(8886007)(8936002)(5660300002)(2906002)(6666004)(86362001)(8676002)(478600001)(81156014)(66574012)(1076003)(4326008)(52116002)(316002)(54906003)(107886003)(186003)(16526019)(66556008)(66476007)(36756003)(2616005)(6512007)(6486002)(6506007)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: euYUjX9R6wi7fdXtf8ebMg+hsPV5rSRbv71WN0LP6bOHpDmQnxP4RFP3Xjun0rpd/ebVrLD5O7HeU9TX74SsyIz9ZuZFfynnKh+HPv9FGirRMjf9DQ6rqolzOvOTiMeaPI3DAPRfQjBuBZamy2jvTExbpBsZ3owG/9Zt8p2EMWNXAYfgih2He3fFPyHSzNdzOL76YuWGYxQgHOXZwCaH37brTeB/XsOfS1DfEH8XYN+Zt56RuZ4fibNDR/KL7dcrCZaBBxW1ci1Z8lk55YaHv3J7EG2uWtwGOymUnWKTgzp9idiGBCzgLX9sm7ZUFMVq7JnghMJEFLcogfbpUm87YIFLJasuA9aZjrZW9N3JyNAyw5xlThqIlavDSL0h+BHnhjEzZMYkKnO8tgDT72ffsoSFdL11EM8PGlnzAPmxxvcyWprbsFy8RRFBHNdTD1ED
X-MS-Exchange-AntiSpam-MessageData: DoIew2VXx8pq2u51uoFtaI4BFoARMs3Ve3xe/llbwC1JsP9jvCID4cwpwEht2Y6swUshrpancGvvGfMDl37PF1shYVYzi2MJMSKEaUehxlCWT8ZCw1hTWoh9Tkef9zG+cXuf6ktkWmXH3LkpXhfRXLlNWpiBc4tkVrryh3BQ5P6uFbuq8eMrwxVRsTQ6NDs4fbOL6LOqHdF6iprr15QZaQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47210ce1-d1af-41f9-f4c5-08d7e157c6b4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:12:21.1885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9PMnHxfvb+lFwHmAcP5kTHFUYoYox97m/ptrwar0e+Kpg7dq7ajW3oBaydSmPS0m938dKuuyj8LHXO27TUhqHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biB0aGUgZGV2aWNlIGpvaW5zIGFuIEFQLCBiZWFjb24gYXJlIGZvcndhcmRlZCB0byB0aGUgaG9z
dC4gT25jZSBoYXMKcmV0cmlldmVkIGFsbCBuZWNlc3NhcnkgcGFyYW1ldGVycywgd2UgY2FuIHN0
YXJ0IHRvIGZpbHRlciB0aGUgYmVhY29uCihhbmQgb25seSBiZWFjb24gd2l0aCBjaGFuZ2VkL25l
dyBkYXRhIHdpbGwgYmUgZm9yd2FyZGVkKS4KCkN1cnJlbnRseSwgdGhlIGRyaXZlciBkZXRlY3Qg
YmVhY29ucyBpbiBkYXRhIFJ4IHByb2Nlc3MuIEl0IGlzIGZhciBtb3JlCmVhc2llciB0byBqdXN0
IHdhaXQgZm9yIHRoZSBCU1NfQ0hBTkdFRF9CRUFDT05fSU5GTyBldmVudC4KClNpZ25lZC1vZmYt
Ynk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcnguYyB8IDEyIC0tLS0tLS0tLS0tLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYyAgICAgfCAxMCArKysrKysrKystCiAyIGZpbGVzIGNoYW5nZWQsIDkg
aW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9kYXRhX3J4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcnguYwppbmRleCBj
NWI4M2ZlZGViNTUuLmMzYjNlZGFlMzQyMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9kYXRhX3J4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMKQEAgLTExOCwx
OCArMTE4LDYgQEAgdm9pZCB3ZnhfcnhfY2Ioc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJICAgIGFy
Zy0+cnhfZmxhZ3MubWF0Y2hfdWNfYWRkciAmJgogCSAgICBtZ210LT51LmFjdGlvbi5jYXRlZ29y
eSA9PSBXTEFOX0NBVEVHT1JZX0JBQ0spCiAJCWdvdG8gZHJvcDsKLQlpZiAoaWVlZTgwMjExX2lz
X2JlYWNvbihmcmFtZS0+ZnJhbWVfY29udHJvbCkgJiYKLQkgICAgIWFyZy0+c3RhdHVzICYmIHd2
aWYtPnZpZiAmJgotCSAgICBldGhlcl9hZGRyX2VxdWFsKGllZWU4MDIxMV9nZXRfU0EoZnJhbWUp
LAotCQkJICAgICB3dmlmLT52aWYtPmJzc19jb25mLmJzc2lkKSkgewotCQkvKiBEaXNhYmxlIGJl
YWNvbiBmaWx0ZXIgb25jZSB3ZSdyZSBhc3NvY2lhdGVkLi4uICovCi0JCWlmICh3dmlmLT5kaXNh
YmxlX2JlYWNvbl9maWx0ZXIgJiYKLQkJICAgICh3dmlmLT52aWYtPmJzc19jb25mLmFzc29jIHx8
Ci0JCSAgICAgd3ZpZi0+dmlmLT5ic3NfY29uZi5pYnNzX2pvaW5lZCkpIHsKLQkJCXd2aWYtPmRp
c2FibGVfYmVhY29uX2ZpbHRlciA9IGZhbHNlOwotCQkJc2NoZWR1bGVfd29yaygmd3ZpZi0+dXBk
YXRlX2ZpbHRlcmluZ193b3JrKTsKLQkJfQotCX0KIAlpZWVlODAyMTFfcnhfaXJxc2FmZSh3dmlm
LT53ZGV2LT5odywgc2tiKTsKIAogCXJldHVybjsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IGVjOTQ5Y2UwYjI1
Ni4uYjAxNDY3Zjc2MDZhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTcxMiw5ICs3MTIsMTcgQEAgdm9pZCB3
ZnhfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAlpZiAoY2hhbmdl
ZCAmIEJTU19DSEFOR0VEX0JFQUNPTl9FTkFCTEVEKQogCQl3ZnhfZW5hYmxlX2JlYWNvbih3dmlm
LCBpbmZvLT5lbmFibGVfYmVhY29uKTsKIAotCWlmIChjaGFuZ2VkICYgQlNTX0NIQU5HRURfQkVB
Q09OX0lORk8pCisJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9CRUFDT05fSU5GTykgeworCQlp
ZiAodmlmLT50eXBlICE9IE5MODAyMTFfSUZUWVBFX1NUQVRJT04pCisJCQlkZXZfd2Fybih3ZGV2
LT5kZXYsICIlczogbWlzdW5kZXJzdG9vZCBjaGFuZ2U6IEJFQUNPTl9JTkZPXG4iLAorCQkJCSBf
X2Z1bmNfXyk7CiAJCWhpZl9zZXRfYmVhY29uX3dha2V1cF9wZXJpb2Qod3ZpZiwgaW5mby0+ZHRp
bV9wZXJpb2QsCiAJCQkJCSAgICAgaW5mby0+ZHRpbV9wZXJpb2QpOworCQkvLyBXZSB0ZW1wb3Jh
cnkgZm9yd2FyZGVkIGJlYWNvbiBmb3Igam9pbiBwcm9jZXNzLiBJdCBpcyBub3cgbm8KKwkJLy8g
bW9yZSBuZWNlc3NhcnkuCisJCXd2aWYtPmRpc2FibGVfYmVhY29uX2ZpbHRlciA9IGZhbHNlOwor
CQl3ZnhfdXBkYXRlX2ZpbHRlcmluZyh3dmlmKTsKKwl9CiAKIAkvKiBhc3NvYy9kaXNhc3NvYywg
b3IgbWF5YmUgQUlEIGNoYW5nZWQgKi8KIAlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0FTU09D
KSB7Ci0tIAoyLjI1LjEKCg==
