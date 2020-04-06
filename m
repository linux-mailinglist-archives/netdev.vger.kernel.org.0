Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB83119F468
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgDFLS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 07:18:56 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:6126
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727813AbgDFLSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 07:18:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNz2NbL5n62YPHtPN5UZEUAZvhkLv7MzEbvWg7rXFi22F0xMWAjzA1UROmtTlOM3B1sv0hAL4LElW8gRPUDCtGtmTJI8RqpX6mWpi4BI8AC58ZIv9OhFw5hVF02/K0pw1QkOUUgLdNnrsCUW23otfXGMRVDThoVdxoZAb1kVcBRNfqI4gt11ZG99w7U3gm+dPzVa8At/Ie9HpVeN0RE5oT15G+krk71XhNBWqVt8cP6364Zq3owzIL0fzdeNRXyoToiUvFJqFAHWMlI+4JVeHiy63VKKCsSTgVCGwWTzzsxIYMYRUMKLaZeJLU/idvjK+NJnUoI/tTjQZVm0NL8zJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+TqyORzHzQYF5t1pQw359Vq4ysUBiutjY0sYLqxW5o=;
 b=HIOuWBBFuqBEB340PW7A0HA3ocAlO7eyH2d9e/r7yDvgRFM8x/LNrC2KF728WLeH8Z1KDO5BxsRwAQL13tlXXDJzx9LAWd63ATUxeszpi9XF1LLHPPOU6ZOiaU4UvIv7Vk8ZhRvOEr6ie/00wi4dNt1S63Wk1JUyq4cm4b1HaGgU6nqTBFrCD0il4rYEPfL8uKuxmv5vpxF2NJzZyRZNxo+BYBUiDWinAO4D7rm55aruP57gTPtT3I5RQlgUrxb1loQwsMSZbDSesBpQYEMfrt1IcdoL044AMhA9kRXWTnva7qBdL3L8A3T4RftZSztMV5yXILesYPzlHf8H4x0rMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+TqyORzHzQYF5t1pQw359Vq4ysUBiutjY0sYLqxW5o=;
 b=EKt7Nya0wg1xxsvA0Q2MuQCaYRJyw+KI0etCED8vrT++dsTLP0X0UIQentxsssxSc25NYDOEJwMBVCKs+kxEe/zMBjWtU39nXTAZBF/UAih2+j+wQP3k7Dmnbp0CKaQlDii17njAoNUD0+tz+V30MKxhjcQ+B/Q1qMUEanG4d0I=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from BN6PR11MB4052.namprd11.prod.outlook.com (2603:10b6:405:7a::37)
 by BN6PR11MB3860.namprd11.prod.outlook.com (2603:10b6:405:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Mon, 6 Apr
 2020 11:18:32 +0000
Received: from BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376]) by BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376%3]) with mapi id 15.20.2878.018; Mon, 6 Apr 2020
 11:18:32 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 09/11] staging: wfx: allow to connect an IBSS with an existing SSID
Date:   Mon,  6 Apr 2020 13:17:54 +0200
Message-Id: <20200406111756.154086-10-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200406111756.154086-1-Jerome.Pouiller@silabs.com>
References: <20200406111756.154086-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:3:d4::20) To BN6PR11MB4052.namprd11.prod.outlook.com
 (2603:10b6:405:7a::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR05CA0010.namprd05.prod.outlook.com (2603:10b6:3:d4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.13 via Frontend Transport; Mon, 6 Apr 2020 11:18:30 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd833fe7-1028-4e00-2e31-08d7da1c3d97
X-MS-TrafficTypeDiagnostic: BN6PR11MB3860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR11MB3860F184E1642C192D352AA993C20@BN6PR11MB3860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(396003)(39850400004)(346002)(366004)(136003)(376002)(186003)(16526019)(7696005)(52116002)(36756003)(5660300002)(107886003)(316002)(54906003)(66946007)(66476007)(4326008)(2616005)(66556008)(1076003)(66574012)(81166006)(6666004)(6486002)(8936002)(2906002)(86362001)(81156014)(4744005)(8676002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z0VRYYMOyEbwmtGhe1YGFlZSyf32Y2D2SKuJlfJX5xgW93Agcv+BCmnBVAVeV9SnW3N1YLzmdXlUFyEPmZyqblI5UsYyr/3sm6qXet9lmRmdA7LiEnmN56AKAjut84Is7suEoiLU/I8myJqeMhMfhglLvTOcit0ePAz9V/9te8H2szrzkVOUsasGjjuf3jfbA3dPIxc45nKLspM1TGSi5i5284C1KoNhyUfd+OKMDygzVxnumFX3ItiIkfg7/HiyWsC4ghxkIY2Z800tYQSHjkzs3mFCYSvk/mKcJRuzPatD13HsW+GlOstbaEp1YD9KK7I5HCsAvmzoHubN5XZ//v8UB1HJ8FzvBp1Oek/AvOXE2NLwfZPn5ZQD6TnOgOzqlU1957CYT7t4cg7jQUzcgOYiKMAo4L7MqpS6S2YokLWwIC8yZ9Wh63d/sgnXIzpG
X-MS-Exchange-AntiSpam-MessageData: o700U8rurANnoBYUGR81BbeohMhP0rtVQ6Aarredi16rvBnSYuKImkxc3QmeC2iBRWKbkTK+OwFQWp87sKFnYt/eliB44UhhSUTuaL/bpw2+C+IvMO0Vyar1owzgyAlzPhoc+gbZ4c1GSKT/j/Qwm8Ah9tbxecqlbT6mPjGnbg/IaP6MmvaN+rivFKN3LUDSHkANvJZlkmRUwgD0CKiyJw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd833fe7-1028-4e00-2e31-08d7da1c3d97
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 11:18:32.6420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0dcevD3R5U2pRsDjxei+3e+RmMtpJi9cIDGHfk3KOwJ8MahC57lv9d0eKKfB6B0PltKMsNRCtymY/m8JbB1rdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3860
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2l0
aCBjdXJyZW50IGNvZGUsIGNoaXAgaXMgbm90IGFibGUgdG8gam9pbiBhbiBleGlzdGluZyBJQlNT
IG5ldHdvcmsuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWls
bGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyB8IDIgKy0K
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl90eC5jCmluZGV4IDQ0NTkwNjAzNWU5ZC4uZDQ0ZTVjYWNiYmNlIDEwMDY0NAotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4
LmMKQEAgLTMxMCw3ICszMTAsNyBAQCBpbnQgaGlmX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYs
IGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmNvbmYsCiAJYm9keS0+YmFzaWNfcmF0
ZV9zZXQgPQogCQljcHVfdG9fbGUzMih3ZnhfcmF0ZV9tYXNrX3RvX2h3KHd2aWYtPndkZXYsIGNv
bmYtPmJhc2ljX3JhdGVzKSk7CiAJbWVtY3B5KGJvZHktPmJzc2lkLCBjb25mLT5ic3NpZCwgc2l6
ZW9mKGJvZHktPmJzc2lkKSk7Ci0JaWYgKCFjb25mLT5pYnNzX2pvaW5lZCAmJiBzc2lkKSB7CisJ
aWYgKHNzaWQpIHsKIAkJYm9keS0+c3NpZF9sZW5ndGggPSBjcHVfdG9fbGUzMihzc2lkbGVuKTsK
IAkJbWVtY3B5KGJvZHktPnNzaWQsIHNzaWQsIHNzaWRsZW4pOwogCX0KLS0gCjIuMjUuMQoK
