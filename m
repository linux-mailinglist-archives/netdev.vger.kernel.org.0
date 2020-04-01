Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797C019AA72
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732312AbgDALIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:08:00 -0400
Received: from mail-eopbgr750070.outbound.protection.outlook.com ([40.107.75.70]:46082
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731343AbgDALEy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:04:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCuts7Esk0QK6OgjulZiff6pUJKK1lPwEuM3w4JCULnsdquImgSwe2DsPvGw9dWMjjWGRVg0b8mNagzX/kB3gDFthE9Jg8nXaRIlu7keIC92YtKVWJ2Z8YVLIwsDJf4nxQOT3tnoBx3cdjgiMiaOsPp8gKVLta0npp/fiXPjoghNNiEb9TV8DuOAes01k7KIuDlvuWfeDb72o2QBvosfUL7eAezamqszig0itNbTzz7sBPlom/zY9iJr15Z3sSdidsd0/lcxvaBqPtiHCREsM3J4YizVf1AFTnA3j8Gd7u6YQxS74DcQQKl8ozfKRgG3+A0TXGpRc7tYUHIIzPCZ3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJVaYPTTz7XNAS584fc+n8puN+xxXPzKeuB+iorTlwI=;
 b=Vdvnv6hN53CptSc2KF/vWbnwPcEdOnopYwxh0ILizoeiXPksZ2r8CXioG2gNUtwr/e2e1+3gQNCDUx5I3P3W3U0bxUUldoj8LoJ++cMhXhBCvmaHm8ukzA02y4emMp9lTeoe8ORZf1jd/A6nmf3boTIJbsCv3YBffYS0SbFQkd+Y5/n6g9rCOTENzNemqkDXrt41MN9aRDOMY3qxpe26RbLKEHIMwlcn2G8N3I6V6Sr9vWtbbfNMyqD58mocY0h5CAH5d6ztW6yjH5UaBnbTji2vnGM3KUeCWkbnLO0ZaZrAnI5rw4ub73yXbgY4csTqRm6elEO+cjAM80c9ekFHBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJVaYPTTz7XNAS584fc+n8puN+xxXPzKeuB+iorTlwI=;
 b=fLmgbxpWRCdzzeind+o5O1/nOc1CbKvcWlYAHWC8FHwYPgR85+CQKxofLq7fAZmj4pGd7gqO0jzGkCJ3q3hxYS7oejp8r0pKAiuqmDV5ExsapkNO2TTxvE3SsRHt37R3q/BvZp/vSmOQK8VGXDJyzEOE0DgExd4lEO1oeNKYzzg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:34 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:34 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 07/32] staging: wfx: avoid useless wake_up
Date:   Wed,  1 Apr 2020 13:03:40 +0200
Message-Id: <20200401110405.80282-8-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:32 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd05c000-c114-4b59-c9c5-08d7d62c75f9
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB42855550E561EB18DA26CBAC93C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ArJAtIy7VHKDp5zet8JMwOH8u2u+JpDDqI/50b3sihKxYgcP9P4P6ThARsT6+z6Y+ykTEZxS93WwOl7SlEtP/4SbXsppay1vRj02VtSLPKoe7JDj91TPNZGeuer2YUM009O2lbnlBPKOHRk9OzalFmiZD+AzWTG6j4MrwghH7mjV2kCHVUTiWjJyqqQ6s7kubJkmJcLFagcbDZt35GCAi2jWyLHlfbEk70T2N0E2srw3Wg1uoMITtitYDaUmtIx04C7CIpnXp1EkSdu5jWbr4vvt4v9kmJ+PtOUBrSuu6j3ElTBJgZrMWEVLB1gt2xYA5coQUzmHMcYMyVPCoteZD5mfZz+qUJW6Eae+f3ykEAcnYyhY+fHX5GNtu78KB0dhe3IHtDXA14kcRyppSwY5uZr7R4lsNUQWnr2PhODnG2399ncV9YTbVoxLH/+gMDz7
X-MS-Exchange-AntiSpam-MessageData: g1IjWURb5emZg+p3tiR/ohcb12FoQXZJbHQGAIL9hYASgGujiQt4jd+/C2EvsLUBrh3QQhFvwWJ09NK9+JESvmse4u9PnoL63vZULMHhg4udiXmvVf0jACx3Cj39+TxQ8U89Y+TTfsISAQoL5c0PHEdsgZg1rzX0fZKY5QCRAtXztSwxvLogdLVDgkOEaBxuggoD1vNQCmk6rCFo4bZEbQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd05c000-c114-4b59-c9c5-08d7d62c75f9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:34.4832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8dO0XJOUY5b9hNgQBqrK1+bUCAxko2ihiR+vleUnYxBuvz2V0kxt3LSVQpthu/tNkXrbQGhsPwd8lyBWiJ/rvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKX193
ZnhfZmx1c2goKSB3YWl0IGZvciBhbGwgcXVldWVzIHRvIGJlIGVtcHR5LiBJbiBjdXJyZW50IGNv
ZGUsCndhaXRfbGlua19pZF9lbXB0eSBpcyB3YWtlIHVwIGVhY2ggdGltZSB0aGVyZSBpcyBubyBt
b3JlIGRhdGEgZm9yIGEKc3RhdGlvbi4gV2UgY2FuIHNpbXBsaWZ5IHRoZSBwcm9jZXNzaW5nIGFu
ZCBhdm9pZCBzb21lIHdha2UtdXAgYnkKcmFpc2luZyB0aGlzIGV2ZW50IG9ubHkgd2hlbiB0aGUg
cXVldWUgaXMgZW1wdHkuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21l
LnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIHwg
NiArKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9xdWV1ZS5jCmluZGV4IDFkZjNiNmYyOGM2Ny4uMjU1M2Y3NzUyMmQ5IDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9xdWV1ZS5jCkBAIC0xOTAsNyArMTkwLDYgQEAgc3RhdGljIHN0cnVjdCBza19idWZmICp3Znhf
dHhfcXVldWVfZ2V0KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCXN0cnVjdCBza19idWZmICppdGVt
OwogCXN0cnVjdCB3ZnhfcXVldWVfc3RhdHMgKnN0YXRzID0gJndkZXYtPnR4X3F1ZXVlX3N0YXRz
OwogCXN0cnVjdCB3ZnhfdHhfcHJpdiAqdHhfcHJpdjsKLQlib29sIHdha2V1cF9zdGF0cyA9IGZh
bHNlOwogCiAJc3Bpbl9sb2NrX2JoKCZxdWV1ZS0+cXVldWUubG9jayk7CiAJc2tiX3F1ZXVlX3dh
bGsoJnF1ZXVlLT5xdWV1ZSwgaXRlbSkgewpAQCAtMjA4LDEyICsyMDcsMTEgQEAgc3RhdGljIHN0
cnVjdCBza19idWZmICp3ZnhfdHhfcXVldWVfZ2V0KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCiAJ
CXNwaW5fbG9ja19uZXN0ZWQoJnN0YXRzLT5wZW5kaW5nLmxvY2ssIDEpOwogCQlfX3NrYl9xdWV1
ZV90YWlsKCZzdGF0cy0+cGVuZGluZywgc2tiKTsKLQkJaWYgKCEtLXN0YXRzLT5saW5rX21hcF9j
YWNoZVt0eF9wcml2LT5saW5rX2lkXSkKLQkJCXdha2V1cF9zdGF0cyA9IHRydWU7CisJCS0tc3Rh
dHMtPmxpbmtfbWFwX2NhY2hlW3R4X3ByaXYtPmxpbmtfaWRdOwogCQlzcGluX3VubG9jaygmc3Rh
dHMtPnBlbmRpbmcubG9jayk7CiAJfQogCXNwaW5fdW5sb2NrX2JoKCZxdWV1ZS0+cXVldWUubG9j
ayk7Ci0JaWYgKHdha2V1cF9zdGF0cykKKwlpZiAoc2tiX3F1ZXVlX2VtcHR5KCZxdWV1ZS0+cXVl
dWUpKQogCQl3YWtlX3VwKCZzdGF0cy0+d2FpdF9saW5rX2lkX2VtcHR5KTsKIAlyZXR1cm4gc2ti
OwogfQotLSAKMi4yNS4xCgo=
