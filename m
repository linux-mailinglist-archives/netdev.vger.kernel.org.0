Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12EE11A46FA
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgDJNen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:34:43 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:31903
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726843AbgDJNdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZ+hR93Q9HSVbae9YZJqR50jMhm+63VhleorFk11KbyWGGnPbiYQGQ8wF/x2TdsqHuPYYE99E1t0J4+FeUGDx9bIFmDNWknikM0imPnnjPFcrm06gvBNitgEnFOYJcPcjmntLpfP/V3aFNICG5z2DIk4SfJGS+w2CttAvdw6LKVwuzOUykO4gB9zx6vXMlcRokful/xaI4PZO2QFHMULCH4IHA9XLzunTgrHuE1wLKjfw8AaxgpT3+TcksQ/EvD0qZLxEOuiIMqmPbT4aR9EWiUMQBISF4pXGW1gg3kyeoXMvzLA/ilMPGbwcOLNAdC5ohZ+v3D7o/a/GSpcvjpjJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yu5CxUPaR/7YO+Aqu4ylkWT9SCgtsS7xMkFIQU23T0U=;
 b=WJPWKnk7ht7xV4txT5J6WJUtRmWEPv1U6G8q8sBtUrgSHEdFtSYtJGS8Sdtm/wdSsriaYpm36JRFseltp0FDqHvMVIX3rkqtAj899CqGUtQ4t81AztyHVw+xyaBJU9gsVCd2h0+sEOF79v23Dl3lbbugc0TDb/SEyw+edReygIeSjeYYUFGWueYrFMaIhITVdFvT5+864zEWtYJDzkLW/mZrDXgriE/NRpPwZrgjfARBD8nLhBxWr62ddT93HPjQjzE1NCXcNKchJ9Dzg5P/97p9/WI/IU1WcaAlIVABD1XW/aBQASfSZTeeWnifElBsqN6ylfIkf7qQ8iXRnPnZmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yu5CxUPaR/7YO+Aqu4ylkWT9SCgtsS7xMkFIQU23T0U=;
 b=pqIZmvDDOAKp5v/BwDmu1FfJc6E6SzLaRUndozw/kBhSH9CnxfxUdNXIh9T8+B5wb5wdmESpm/L3WtoCWngFzxy1pk8VwMpzU45TKS3JSjBhmFlvZ+8XywcL37RXiAb1rUh0ubYnZJy7ybZoJR3Lq90PrkkK304RgW+Y/wIWDR4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:14 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:14 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 08/19] staging: wfx: fix support for BSS_CHANGED_KEEP_ALIVE
Date:   Fri, 10 Apr 2020 15:32:28 +0200
Message-Id: <20200410133239.438347-9-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:12 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1d5f853-21c8-45d9-0bfe-08d7dd53b841
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB43984E76FD84BE38C4A0CBF393DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(6666004)(8936002)(4326008)(52116002)(66574012)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c5NZAt/ODpNKv2IBAi3PZyldCseizbNW0u4bKFf1oQuWrwozK+qDSvX+x9OhmV2D76M+138ATzgxU5gZK9Ge4mki1voFHhuBQwNX9QNmyuELmo590FJSQW9PdqUDwuFMuW1YYdDDe/f+PicxX1fUhZzRMVUChJbWNqoiMsNty+7yE2Oe4n8MylF5bWRHuN4hF0ZctVbsMaQRfzFGVJW1Rvg2QEO+e2eNPIavJw2BNUPpAWlUVwkN1FOX+LjF9cRY6PScm0QhxE/PgLvIeQGNjVIu6okP3PCw1aS5fwbS7fnsjAANfa3tptKwIpOgmXirztYCTdjISnG0OLpgcPofqotVEXG3ecErMRY4b4tJE0Itv+rWZUKzq+N1fz6f02jiE48geJpwoMwf0KSCSxfIYv7vrei/N7Pak+8ihORxBKqBlso+tJ02PK0S87RdPACo
X-MS-Exchange-AntiSpam-MessageData: Rujnk6esPtAm1QHjH0Ds6KM9974EhwPv1iN6p40Jy1cr1ZMiH02iDb6Th+XiN2xE4vfbWZvVlm8vv8YXR4tY84FNjQS+cdgpHmN5KzMNcIl3lPrfOkcLwNJvSzOiZ6mzteXsFjkFU2ubrTFkTDFjUVP2HMsmUZbhSqFYdFGkl6eDtooswaAyqSTfKt4EAjHxuW6cxbNjqBrgxclqJw1e4g==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1d5f853-21c8-45d9-0bfe-08d7dd53b841
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:14.2877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fS+tAPpoM1YRAZl450Kc9CnsWM/1rhUES7aYSlyu4Cuyg65hK6YYuhiBDMpb3DFU649uvL5RE7NvqNKJcWo0cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ2hp
cCBmaXJtd2FyZSBpcyBhYmxlIHRvIHNlbmQgcGVyaW9kaWMgbnVsbCBmcmFtZXMgdG8ga2VlcCB0
aGUKYXNzb2NpYXRpb24gd2l0aCB0aGUgQVAuCgpUaGUgZHJpdmVyIGFyYml0cmFyeSBzZXQgdGhp
cyBwZXJpb2QgdG8gMzBzZWMuIFdlIHByZWZlciB0byByZWx5IG9uCkJTU19DSEFOR0VEX0tFRVBf
QUxJVkUgdGhhdCBwcm92aWRlIGEgdHJ1ZSB2YWx1ZS4KCk5vdGUgdGhhdCBpZiBCU1NfQ0hBTkdF
RF9LRUVQX0FMSVZFIGlzIG5vdCByZWNlaXZlZCwgd2UganVzdCBkaXNhYmxlCmtlZXBfYWxpdmUg
ZmVhdHVyZS4gSXQgaXMgbm90IHZlcnkgZGlzdHVyYmluZyBzaW5jZSBBUCB3aWxsIHByb2JhYmx5
CnBpbmcgdGhlIHN0YXRpb24gYmVmb3JlIHRvIGRpc2Nvbm5lY3QgaXQuCgpTaWduZWQtb2ZmLWJ5
OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJp
dmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDYgKysrKystCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggNzY5M2NlMjJmMzAwLi42
N2UxNmM0MzU4NDggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNjQ2LDcgKzY0Niw3IEBAIHN0YXRpYyB2b2lk
IHdmeF9qb2luX2ZpbmFsaXplKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCiAJaWYgKCFpbmZvLT5p
YnNzX2pvaW5lZCkgewogCQl3dmlmLT5zdGF0ZSA9IFdGWF9TVEFURV9TVEE7Ci0JCWhpZl9rZWVw
X2FsaXZlX3BlcmlvZCh3dmlmLCAzMCAvKiBzZWMgKi8pOworCQloaWZfa2VlcF9hbGl2ZV9wZXJp
b2Qod3ZpZiwgMCk7CiAJCWhpZl9zZXRfYnNzX3BhcmFtcyh3dmlmLCAmd3ZpZi0+YnNzX3BhcmFt
cyk7CiAJCWhpZl9zZXRfYmVhY29uX3dha2V1cF9wZXJpb2Qod3ZpZiwgaW5mby0+ZHRpbV9wZXJp
b2QsCiAJCQkJCSAgICAgaW5mby0+ZHRpbV9wZXJpb2QpOwpAQCAtNzI4LDYgKzcyOCwxMCBAQCB2
b2lkIHdmeF9ic3NfaW5mb19jaGFuZ2VkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCQkJCSBf
X2Z1bmNfXyk7CiAJfQogCisJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9LRUVQX0FMSVZFKQor
CQloaWZfa2VlcF9hbGl2ZV9wZXJpb2Qod3ZpZiwgaW5mby0+bWF4X2lkbGVfcGVyaW9kICoKKwkJ
CQkJICAgIFVTRUNfUEVSX1RVIC8gVVNFQ19QRVJfTVNFQyk7CisKIAlpZiAoY2hhbmdlZCAmIEJT
U19DSEFOR0VEX0FTU09DIHx8CiAJICAgIGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9FUlBfQ1RTX1BS
T1QgfHwKIAkgICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0VSUF9QUkVBTUJMRSkgewotLSAKMi4y
NS4xCgo=
