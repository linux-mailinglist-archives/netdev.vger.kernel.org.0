Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0324617F4C3
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgCJKOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:14:22 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:6032
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726316AbgCJKOV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 06:14:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JiTDrLHJW030/yLAfhAq99N1dyeGbPGeEi5Facu2R9B66YsRpFLK82WtkuXO25Kn36UQmrodwUqrcayHOMDg/iZKEyZoBa5Uwr285C5O7vArVeozLihONKlfYRaTlaeHCENrAYcd0jhq4Y6mmbVnOpdzZ5XGCWQZkFcF1/kqO3AAGZznqLVxbvO4pcJXKF4b4YAMoFGoeeUgdaU4Mb5EVimLAATqoag5L6xVmD9lsQS0qYD9dxvru3C3niALFhjmhDXMQaidRGWrNYN5MCSH2Nt7XTmJh0CDqgGoBYFbXp4ebSSh6nGCeVj9g1WrY3fwg/QuiFP4hgZ7f4IN+73K5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7/+NAZflO+4IVZuFWFhpIkVJOdHGRDq2rkYSpc44Y8=;
 b=NVN6dcY0BX5gp7hbxRCzQ2BYelOiOJUFiL7q4BjpHZGCEaNMrJ++U9andxfoR2l48BHCeI+F54IMy2DMJ3De6ioeVbSrUe0HVf21JBqM6yJzCyAvp7W122KO8N7m61+rz7pLchlFLo7E/QXASbGz1uPiqUypKkgjZBrQzGMCx9XEsJyMSTU7hgKFvvhqAUBQQb5sSpnPrgeUiWkJjyzF0uOW5TbwrVal7IY/anjWUercTwRFPzT/0nnfhbiwf85soC/J2LBACgVV5H1iipsDsvqg6B8suN4ktY9Kg5tcnbD2LCVNOFHSv+GMj3+agijsrBaDRuwlNrB4FqKlDLZ1kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7/+NAZflO+4IVZuFWFhpIkVJOdHGRDq2rkYSpc44Y8=;
 b=Of4xEvK4o0NWiAg8l2ZnLRItscheLfDEMBWLpH2S7uhSCcv3OJJ0Np8GzJmr3t1tIIZt9EFN2Jbwnb+f9NuRTdnpcJOVIekkklsEkBq8QaFBBrn/KqcXTC7mK/4qdha/LE0MjkJ0aZk/ozor/Y1GTaEfI+yjLDZ6ybZoMrzQZvM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB3615.namprd11.prod.outlook.com (2603:10b6:208:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 10:14:19 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 10:14:19 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 4/5] staging: wfx: fix RCU usage in wfx_join_finalize()
Date:   Tue, 10 Mar 2020 11:13:55 +0100
Message-Id: <20200310101356.182818-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310101356.182818-1-Jerome.Pouiller@silabs.com>
References: <20200310101356.182818-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0180.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::24) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0180.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Tue, 10 Mar 2020 10:14:17 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae01b841-0c73-4dc4-f8a6-08d7c4dbcb94
X-MS-TrafficTypeDiagnostic: MN2PR11MB3615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB361565829DD91A547AC18FDF93FF0@MN2PR11MB3615.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(39850400004)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(6666004)(52116002)(5660300002)(2616005)(86362001)(316002)(956004)(36756003)(478600001)(7696005)(8936002)(54906003)(4326008)(16526019)(186003)(26005)(6486002)(66574012)(66946007)(8676002)(1076003)(81166006)(2906002)(66476007)(81156014)(66556008)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3615;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lyOiIEVhMj+C9glfYT61Mcfyfhv+4kVzTE5ukiDaA46oA82whQOxe00LuEqlL5Nsj2WYe5ORFBfw+XbUFF3K5nHwKTAB2jqFjoOyJSAnTxo7JUcnoVxXAmtQq6Dynd1hAjO4WxiPwoVH6wPDT4BQYdX2BUFU6RpzIEHDSaAQ1tHMRPNT19bgot12iJiVUDsCWYkj0VEoNsMQLvciMR1NNa+Ygnx0MC6IbgL3w/FQMAu7frpNF0C1nTgiIM3Wz0xkHwNHxJXuSRRXaM43oeX7iOk0DlHVFhNhz/KzuSQzIcglpr+HUyvDQUBe+UYeSgXQkDaYzUsAddN+6rY2Z0xrlDU26Uy+sllSRsaNekd/yWMusF+k6+SE/BkJeIl7FhICDi9xgXb0F80zFP3YIDGhMyam0Pa1Le1822h/5dAv0rNTKkPFrErccypD01h9ViaK
X-MS-Exchange-AntiSpam-MessageData: N/kzrS6g6KLHlAsh7IOwanNA+mf+gQd8wtxijQ7ISBPwse+SeodN39hp459M0su7KiF0X43fjutymbksGpcWFH+V6qIsC+4FYslm8NxtgCuVhLl/3VpQ2CHwuWAZEEpXWOtnnzF2W3FBO2du6prPzw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae01b841-0c73-4dc4-f8a6-08d7c4dbcb94
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 10:14:19.1342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4lw/Y+lBWNxjE3CBk5Wm3SSlEOF4GwrLiXx2FWEdtKGJ30qVFmCa8XTUeQNsOc5JE6L0mfWSYXXGvdyb/QkMdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3615
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQWNj
ZXNzIHRvIHN0YS0+aHRfY2FwIGlzIHByb3RlY3RlZCBieSBSQ1UuIEhvd2V2ZXIsCmhpZl9zZXRf
YXNzb2NpYXRpb25fbW9kZSgpIG1heSBzbGVlcCwgc28gaXQgY2FuJ3QgYmUgY2FsbGVkIGluIFJD
VS4KClRoaXMgcGF0Y2ggZml4IHRoaXMgYmVoYXZpb3IgYnkgaGFuZGxpbmcgc3RhIGFuZCBpdHMg
UkNVIGRpcmVjdGx5IGZyb20KZnVuY3Rpb24gaGlmX3NldF9hc3NvY2lhdGlvbl9tb2RlKCkuCgpT
aWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5j
b20+CkZpeGVzOiBkMDAxNDkwMTEwNjYgKCJzdGFnaW5nOiB3Zng6IGZpeCBSQ1UgdXNhZ2UiKQot
LS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oIHwgMTUgKysrKysrKysrKy0tLS0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICB8ICA0ICsrLS0KIDIgZmlsZXMgY2hh
bmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4
X21pYi5oCmluZGV4IGJmMzc2OWMyYTliNi4uMjZiMTQwNmY5ZjZjIDEwMDY0NAotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl90eF9taWIuaApAQCAtMTkxLDEwICsxOTEsMTAgQEAgc3RhdGljIGlubGluZSBpbnQgaGlmX3Nl
dF9ibG9ja19hY2tfcG9saWN5KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogfQogCiBzdGF0aWMgaW5s
aW5lIGludCBoaWZfc2V0X2Fzc29jaWF0aW9uX21vZGUoc3RydWN0IHdmeF92aWYgKnd2aWYsCi0J
CQkJCSAgIHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmluZm8sCi0JCQkJCSAgIHN0cnVjdCBp
ZWVlODAyMTFfc3RhX2h0X2NhcCAqaHRfY2FwKQorCQkJCQkgICBzdHJ1Y3QgaWVlZTgwMjExX2Jz
c19jb25mICppbmZvKQogewogCWludCBiYXNpY19yYXRlcyA9IHdmeF9yYXRlX21hc2tfdG9faHco
d3ZpZi0+d2RldiwgaW5mby0+YmFzaWNfcmF0ZXMpOworCXN0cnVjdCBpZWVlODAyMTFfc3RhICpz
dGEgPSBOVUxMOwogCXN0cnVjdCBoaWZfbWliX3NldF9hc3NvY2lhdGlvbl9tb2RlIHZhbCA9IHsK
IAkJLnByZWFtYnR5cGVfdXNlID0gMSwKIAkJLm1vZGUgPSAxLApAQCAtMjA0LDEyICsyMDQsMTcg
QEAgc3RhdGljIGlubGluZSBpbnQgaGlmX3NldF9hc3NvY2lhdGlvbl9tb2RlKHN0cnVjdCB3Znhf
dmlmICp3dmlmLAogCQkuYmFzaWNfcmF0ZV9zZXQgPSBjcHVfdG9fbGUzMihiYXNpY19yYXRlcykK
IAl9OwogCisJcmN1X3JlYWRfbG9jaygpOyAvLyBwcm90ZWN0IHN0YQorCWlmIChpbmZvLT5ic3Np
ZCAmJiAhaW5mby0+aWJzc19qb2luZWQpCisJCXN0YSA9IGllZWU4MDIxMV9maW5kX3N0YSh3dmlm
LT52aWYsIGluZm8tPmJzc2lkKTsKKwogCS8vIEZJWE1FOiBpdCBpcyBzdHJhbmdlIHRvIG5vdCBy
ZXRyaWV2ZSBhbGwgaW5mb3JtYXRpb24gZnJvbSBic3NfaW5mbwotCWlmIChodF9jYXAgJiYgaHRf
Y2FwLT5odF9zdXBwb3J0ZWQpIHsKLQkJdmFsLm1wZHVfc3RhcnRfc3BhY2luZyA9IGh0X2NhcC0+
YW1wZHVfZGVuc2l0eTsKKwlpZiAoc3RhICYmIHN0YS0+aHRfY2FwLmh0X3N1cHBvcnRlZCkgewor
CQl2YWwubXBkdV9zdGFydF9zcGFjaW5nID0gc3RhLT5odF9jYXAuYW1wZHVfZGVuc2l0eTsKIAkJ
aWYgKCEoaW5mby0+aHRfb3BlcmF0aW9uX21vZGUgJiBJRUVFODAyMTFfSFRfT1BfTU9ERV9OT05f
R0ZfU1RBX1BSU05UKSkKLQkJCXZhbC5ncmVlbmZpZWxkID0gISEoaHRfY2FwLT5jYXAgJiBJRUVF
ODAyMTFfSFRfQ0FQX0dSTl9GTEQpOworCQkJdmFsLmdyZWVuZmllbGQgPSAhIShzdGEtPmh0X2Nh
cC5jYXAgJiBJRUVFODAyMTFfSFRfQ0FQX0dSTl9GTEQpOwogCX0KKwlyY3VfcmVhZF91bmxvY2so
KTsKIAogCXJldHVybiBoaWZfd3JpdGVfbWliKHd2aWYtPndkZXYsIHd2aWYtPmlkLAogCQkJICAg
ICBISUZfTUlCX0lEX1NFVF9BU1NPQ0lBVElPTl9NT0RFLCAmdmFsLCBzaXplb2YodmFsKSk7CmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYwppbmRleCAwMTBlMTNiY2QzM2UuLmVkMTY0NzVjMjA3YyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBA
IC02OTEsNiArNjkxLDcgQEAgc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxpemUoc3RydWN0IHdm
eF92aWYgKnd2aWYsCiAJCQl3ZnhfcmF0ZV9tYXNrX3RvX2h3KHd2aWYtPndkZXYsIHN0YS0+c3Vw
cF9yYXRlc1t3dmlmLT5jaGFubmVsLT5iYW5kXSk7CiAJZWxzZQogCQl3dmlmLT5ic3NfcGFyYW1z
Lm9wZXJhdGlvbmFsX3JhdGVfc2V0ID0gLTE7CisJcmN1X3JlYWRfdW5sb2NrKCk7CiAJaWYgKHN0
YSAmJgogCSAgICBpbmZvLT5odF9vcGVyYXRpb25fbW9kZSAmIElFRUU4MDIxMV9IVF9PUF9NT0RF
X05PTl9HRl9TVEFfUFJTTlQpCiAJCWhpZl9kdWFsX2N0c19wcm90ZWN0aW9uKHd2aWYsIHRydWUp
OwpAQCAtNzAzLDggKzcwNCw3IEBAIHN0YXRpYyB2b2lkIHdmeF9qb2luX2ZpbmFsaXplKHN0cnVj
dCB3ZnhfdmlmICp3dmlmLAogCXd2aWYtPmJzc19wYXJhbXMuYmVhY29uX2xvc3RfY291bnQgPSAy
MDsKIAl3dmlmLT5ic3NfcGFyYW1zLmFpZCA9IGluZm8tPmFpZDsKIAotCWhpZl9zZXRfYXNzb2Np
YXRpb25fbW9kZSh3dmlmLCBpbmZvLCBzdGEgPyAmc3RhLT5odF9jYXAgOiBOVUxMKTsKLQlyY3Vf
cmVhZF91bmxvY2soKTsKKwloaWZfc2V0X2Fzc29jaWF0aW9uX21vZGUod3ZpZiwgaW5mbyk7CiAK
IAlpZiAoIWluZm8tPmlic3Nfam9pbmVkKSB7CiAJCWhpZl9rZWVwX2FsaXZlX3BlcmlvZCh3dmlm
LCAzMCAvKiBzZWMgKi8pOwotLSAKMi4yNS4xCgo=
