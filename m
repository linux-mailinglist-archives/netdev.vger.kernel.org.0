Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74E51BA52A
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgD0Nmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:42:43 -0400
Received: from mail-mw2nam12on2085.outbound.protection.outlook.com ([40.107.244.85]:27104
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727977AbgD0NlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPNxTLltAoeN7+UdBsxPu9j9der0VUi/uuHLM0/85R2+V0+Zv2tNGTh2QuB4NGPrjFCfRCKWGD4t86LJjAmEjkWLGkfrCQ9vNq8wWmBqyouJXRHXB5M1oryIyghWAtkoDmFf7Q8LQD5OsZgA/yQKWHycWmxEsCx3ZMzwOQEB9x1jFhx88XvFl/pyGhrZ2cMD2NiTQ6jWdSDGkwCEpdT6z1dGbDK1gIKEtLpH56nzFjFiXIWmkxzqV3bAFhchX2DUWcdcLjqqVhNAD8I1jaWFaw6jwsdv3owMYyomrM4V71P5klBRwsO+0aQlLdbkQ7FcBg7yZDVJeTspAB4crVgT/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6uDElDmF4BJeb2iUOBzvnX7akdRxQ+c+0g1HkzX/GM=;
 b=WWjusyBTQ866lZCem5CPf64XsZgzk3oqQz0reZ9YgXR47ckXNnDgcfrRz3teEVDVypufeaXtMSC+fHFxv29MzCb2oFJ68TMOBF+bwaiifiUAfHszxN5Bk3xhs8etNHThnALC84BR5nPPnOHlKrjAVyWe+InSqJAVN4SyAtH7DDOaVE9I/ciknYUBmNjbtAxwpiEqqL8kcwh3zlODSf2q+v1RS4pgLoKFxubT9WigeMsSXuPnBR6H1uRGGjRrKw+EIrPbMY3GpbVvQANlatNghE6TNxkj+X3p/5aQalwljDB11iNB+wfG2fA+GB87PBy0FkeSx0kCRhgFWV25+wWX5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6uDElDmF4BJeb2iUOBzvnX7akdRxQ+c+0g1HkzX/GM=;
 b=VB5ufhilHdM8ETSpfQ7ikf8suERL/o8jfMltvqZSURkBYQjQ9CwUf1Kew8M6wwzJKZSHLBBmcgX4PBEsAoI+BCfsXwIQlhFxxEE8+xSGt9p4cxoOA4H04FLsz6XLV+hpY/1Jo9tplGDofjp2Wam63AIbMbDc8Ob+5qjkAE+E3Q0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:23 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:41:23 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 09/17] staging: wfx: fix overflow in frame counters
Date:   Mon, 27 Apr 2020 15:40:23 +0200
Message-Id: <20200427134031.323403-10-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:41:21 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8144568-c3b9-44ad-0f53-08d7eab0acbf
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1424A68C136806F8BB3F13E893AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4326008)(81156014)(86362001)(8936002)(6486002)(52116002)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(66574012)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oAw3BhWUPavU/AZbmVr9LNN4dHLJMg7ENUdusnhN2v12wH70GBZ9z29lwrT9BUW7Ca0BeSDse5ao3dDFy1yPUwe0rLlP0mjkCcixNtCWTZQhyBFx6DeZKQiQ2rZKRV66Un/BqHpaEOr5aFk6dkfIyWyxjlPSYcxa419E/3roWKiL8pXcY+To67se2B7YSxcKdDMdr5e3jBlNGehrbD48U6nYJ/K8VJPopv/JYbwnWo+9NIEsn3ThVKvSqMOqQlXsWJF3sGUE1jBYvW3rBvH+NajCm6aj7VGmjfC1gii1O8OajkBDXhKzyqP81k8glCqXreB8aVtuFvTolcCexyH6hvd9eJrDujqe+dx7brm1qEufkr8A43fH3BoZkDassXZD57mxEkYFEwpYqaJA7eBAxwxLsJRKAuRc0VD97CmFBUH8HsUd4g9Yx2H5bU60VuPQ
X-MS-Exchange-AntiSpam-MessageData: Td3FUCpur+o/8/tuhiiojX1PzqbuR148dlnub+o7UAmcD4nUWaKW7vVEMCoUp/NBCpTNJwwE6eOJz0X2/n5EEmHEEoqMFyqv9fGjTMlXmeDhG26yi7rSi6RpJeVnaGNqJQ8Z5F55rWGiPXbT+58wxD+nCPS4LMXOKVhsJtuVxhcTZR6u7qxsD5dIieYvmKoFkE6ZSPW1R1qdeNwqZj31uDz7Gd6e8kzSFinnU7E9obFLuQeOpRXsJjjE7NyWDRBdLMzSeiY687kw6cNcYsgF2g4VkpAwzR5gf/AcK4WSNojiLPq9eV14pMlRMa2hDM4gLpZ9jqUuta4KBKpnt7/wwrfKzUfehIf+ssTRVd49QC9/nJH7rgVkMw0hVhiOdOwtbnG/YAh6n/AcZ2YiLywksfad+aAfJ9k4YtyatTbKeJgo6406d8DnNlVYJvWpxykMbR5Dne0D0WCoprwj13dY8QmDfm7ERIVa4QB2h/jfr3Qvc1DnvuXw9UTqwrgF2IG1B27mXdqdHvZqxuRKPLg02vfDt9ZrrOwd+xI5K1sNm0p52wBP1lKL/EWeVfnmuPYu2g3WV4vUn2Kw7rA3ebEUcWVsvWAyVVjyZmmaKb399jxV9QhCqqhIItM+bbD2xh63QnFOtmkj9sKVppNERPfxKgtUbCimvCzdA4t5tyXlX6RrrxV/z9LJzL9og/4MsqGOPlT1Cf6LfKI118MS953VZkdwYTXnVDNg8OLvpQ/Ozx5H7N/Qt88WcCpcV3bdVNARFnraVwq4Z6OS3MSLp6dVVmazbbYGMdbXwVr0KQIKyABTINuplUz7I6QjgJAz/j1ne8JOWeW6GdwlRuMVpLDKGUzhPsAhAY34odLNnd/BxYU=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8144568-c3b9-44ad-0f53-08d7eab0acbf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:41:23.1859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rz7hRVIQG4xewr/kk8yR1hAamNtlD8DPCjPyiMvAtZ/6tXeRXwWzDp1W3Bv4kUHo2lkm5heujUOEwsccl7SNug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aGFzIGJlZW4gcmVwb3J0ZWQgdGhhdCB0cnlpbmcgdG8gc2VuZCBzbWFsbCBwYWNrZXRzIG9mIGRh
dGEgY291bGQKcHJvZHVjZSBhICJpbmNvbnNpc3RlbnQgbm90aWZpY2F0aW9uIiB3YXJuaW5nLgoK
SXQgc2VlbXMgdGhhdCBpbiBzb21lIGNpcmN1bXN0YW5jZXMsIHRoZSBudW1iZXIgb2YgZnJhbWUg
cXVldWVkIGluIHRoZQpkcml2ZXIgY291bGQgZ3JlYXRseSBpbmNyZWFzZSBhbmQgZXhjZWVkIFVD
SEFSX01BWC4gU28gdGhlIGZpZWxkCiJidWZmZXJlZCIgZnJvbSBzdHJ1Y3Qgc3RhX3ByaXYgY2Fu
IG92ZXJmbG93LgoKSnVzdCBpbmNyZWFzZSB0aGUgc2l6ZSBvZiAiYnVlZmZlcmVkIiB0byBmaXgg
dGhlIHByb2JsZW0uCgpGaXhlczogN2QyZDJiZmRlYjgyICgic3RhZ2luZzogd2Z4OiByZWxvY2F0
ZSAiYnVmZmVyZWQiIGluZm9ybWF0aW9uIHRvIHN0YV9wcml2IikKU2lnbmVkLW9mZi1ieTogSsOp
csO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmggfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaAppbmRleCBmN2U4NzZkMWIwMzEuLmEwZTAyNWMxODM0
MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaAorKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5oCkBAIC0xOCw3ICsxOCw3IEBAIHN0cnVjdCB3ZnhfdmlmOwogc3RydWN0
IHdmeF9zdGFfcHJpdiB7CiAJaW50IGxpbmtfaWQ7CiAJaW50IHZpZl9pZDsKLQl1OCBidWZmZXJl
ZFtJRUVFODAyMTFfTlVNX1RJRFNdOworCWludCBidWZmZXJlZFtJRUVFODAyMTFfTlVNX1RJRFNd
OwogCS8vIEVuc3VyZSBhdG9taWNpdHkgb2YgImJ1ZmZlcmVkIiBhbmQgY2FsbHMgdG8gaWVlZTgw
MjExX3N0YV9zZXRfYnVmZmVyZWQoKQogCXNwaW5sb2NrX3QgbG9jazsKIH07Ci0tIAoyLjI2LjEK
Cg==
