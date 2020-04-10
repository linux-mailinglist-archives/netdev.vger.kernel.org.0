Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5331A46D5
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgDJNde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:33:34 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:31903
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726882AbgDJNd2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZ82ueTcHM0et4w9t46ImAvnrmgblBFFfLuyO98gzP6xL3JW+S7sFpoTKwYTG4IWd1de8/MeSbZMLUubkxWyI1Vph6Cz1Nx71xKoDP6tP8FlCvhpxJBX2OVGlNjZh5Xh1SKPzq1phIc3qdEtR/jr1/adHltQHoU5cvUxPedI3WG7mKx8pDN9iTwhcDSYon4RWnuer5x7I9U/X1T8PbFksGObnL5TjaShJMZC0LSN4nMWs5qVHiwJc+ihFqFivltTKlqKKrHRrkTznfd2z1M5+q45yjFA3RVYTcqbnBn1I6b0VEigYgxncJp/6dlN9Pe4bmYHjVFBg9w6TSBZmlwzoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLP/tXNbrsZ3QDmxPqEtAoFTBekIcBSBvX/C3FvbAhQ=;
 b=OLgudng99DlPcDkPyTBQX8eZpTct5cY93hi7CIMOQ2yR1CdQRiTpPA6MKKbuiVbOcp4Vs4SxWDfW8ygf6ZWlZnAaCScF0yWlzWRspatmtGHu5UJJx/RVaasYJBc+k6TetyIV/3c6PNZozNMgP3SJMyEFyUsxaMT/Z9oOZ0Ns4Xd/ToHmCpnQfTndD4lDQCbTmgtwU+vFnAuZJxP+dgPfC4HxxQvOEyx2roxQTqKlYrT5AzMamCOD3X5ytPTCENpoSuEQN6XzHyKJRlai+f/7PQkBqDjwO+GZF5YJjNFUUzomlEz5IFMWkM+jRLJfuUMn0r9/sKjfWRwRv/gdgfsjVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLP/tXNbrsZ3QDmxPqEtAoFTBekIcBSBvX/C3FvbAhQ=;
 b=eYztXJwllxV+Q7qm1uP2pfdlT1Q5XwtlJ6y9JwuH6q70BmaGfj0zlyj3VyOEMp8hH0zSquyTj3UmmejVUSfNZgIRBmjIxhWFNr244b+rQraWasCcQve/u5ynBCH2plQam7SXwq0yFo46D5KH5yqvaxDRn/1Beb8zDGXZdI0V7TM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:20 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:20 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 11/19] staging: wfx: request to send beacons in IBSS mode
Date:   Fri, 10 Apr 2020 15:32:31 +0200
Message-Id: <20200410133239.438347-12-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:18 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f17c5843-ce79-4dbd-aeb9-08d7dd53bba5
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB439888E81357642B213D7C2993DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(6666004)(8936002)(4326008)(52116002)(66574012)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5E8Y5U2Uat11wVDzA/Pkyh4dzF6vr1w43K9q6iJOmY/4K18A57NdzXi7A4+Q51wCUXFc5DunuCBKBqeEyNSE6fpgQK3V5jkFEZfeHTxzCMsclDCGGRy1quwh754LbY5BN9wkna4pPjbJ1/K7LRuc7jSTlVyXvdxBrHoEJChDVP7RWou6zmwmUVGDKCYiyM7/uFxAXLB7ta2lEQre89/rtC0qMFt/agaqAfMDtf2bPJYzx8bWYzGjrpdMY/4fbcpF92lDIMbGiCfUr8wXahWJkdwqst4uVYGxhF7mQLysdq+bwdYWETnQ/mAaAe8qzzyLQwV3Eb/SziywbR14Mbo8I+YCApLg39QoVsMnygN3UCYh6DJJU1RY0+Sq3oiH32nzLS+ZNffXMXKSczvo5E9hLerjehad29gRIqNn7HBvdmUMYugb2czWo82Xh1MnLOn+
X-MS-Exchange-AntiSpam-MessageData: 5u1JcM/TR0jYP8nqRgwoPOzoJLT8u9ArwpxnBhWf3KlpnhFNDH8zUQ4VB/KapyWbXMJkUWUDmezTql5qwAwyh+b3DfaOJc4d22V/eb4lYyeA/fK+xh2cYAgIqQyc9rFD6T9moiMB4NHZ/RD2PQV8FITrJ4qywMSFy+tZLdRMO7x5R8rSJ1umD2zuWNiZQmK5VvwCMlx6gaOp7CIcdN0fUA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f17c5843-ce79-4dbd-aeb9-08d7dd53bba5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:19.9954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CvxjMdbUgGs70Q0P3UePEJjxzyYG6SjiuYiAiJWBar1himCiRiuEcuoKX0MdGhYJQn+XB7GpRJIn7EZTXOhu9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudGx5LCBmaXJtd2FyZSB0YWtlIGluIGNoYXJnZSBvZiBzdGFydC9zdG9wIHNlbmRpbmcgYmVh
Y29ucyB3aGlsZQppbiBJQlNTIG1vZGUuIEhvd2V2ZXIsIHRoaXMgYmVoYXZpb3IgbWF5IGNoYW5n
ZSBpbiB0aGUgZnVydGhlciByZWxlYXNlcy4KCkN1cnJlbnRseSwgYXNraW5nIHRvIGZpcm13YXJl
IHRvIHNlbmQgYmVhY29uIHdoaWxlIGluIElCU1MgbW9kZSByZXR1cm4KYW4gZXJyb3IgYnV0IGlz
IGhhcm1sZXNzLgoKVGhlcmVmb3JlLCBzZW5kIHRoaXMgcmVxdWVzdCB1bmNvbmRpdGlvbmFsbHku
CgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFi
cy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDMgKy0tCiAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggN2Fm
N2JmYTRhYzk5Li4zNTEyZTU5ZjA5NjggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNjk3LDggKzY5Nyw3IEBA
IHZvaWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCiAJICAg
IGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9CRUFDT04pCiAJCXdmeF91cGxvYWRfYXBfdGVtcGxhdGVz
KHd2aWYpOwogCi0JaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9CRUFDT05fRU5BQkxFRCAmJgot
CSAgICB3dmlmLT5zdGF0ZSAhPSBXRlhfU1RBVEVfSUJTUykKKwlpZiAoY2hhbmdlZCAmIEJTU19D
SEFOR0VEX0JFQUNPTl9FTkFCTEVEKQogCQl3ZnhfZW5hYmxlX2JlYWNvbih3dmlmLCBpbmZvLT5l
bmFibGVfYmVhY29uKTsKIAogCWlmIChjaGFuZ2VkICYgQlNTX0NIQU5HRURfQkVBQ09OX0lORk8p
Ci0tIAoyLjI1LjEKCg==
