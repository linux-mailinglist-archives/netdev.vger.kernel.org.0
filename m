Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18B31CDF71
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbgEKPtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:49:55 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:10442
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726687AbgEKPtw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:49:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuKPmBZ8t3AM7ocFRLII6tXB6O0INrwT5KZMlk60T1a0inUtIAOD3FoybyBohBc8VIGW7nuZ9206VT2TY6gvSi8VFpgUID7Fkly6o+82SDkBfwJlnxeOONMAluNXDmQ8QBVylxhxvoGuaYv81gcA6ZD8CVJCs6C92cfYBB0nj8PFlTtmOPfKJ892uPml/zKmWC49wtIWTHaRJ3iP1kawhcbc52gL+Jj6wt1b2khQry9Qi2qHCjm6xr1S068mszLBnP5gebqBiXqWsdBg8jhvjm0fhuuoAqGziDTbzKVFEffOUEwOXpnIc5vC85xpSmdTx+qB2OXf9TvFCfcMLOfTZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7W9J6xx50RVl9zf/gu8v/A2L1KffHWgqaGOXqplNmJE=;
 b=jQuJr3AvmRsHT/YE2FW6z9mYr49ZVY/cpI357wHR34vMfjoWjnPTi1JcTZvjyLah/H0v5/UOpBxiCUkVwqN0mvSOQ1Of6Z0DmnuaqbycYyydPqjqHcFCua5EYhOjT7RU9zIMZ4EAaE098AfEe8KFI4xeZ0VocXBuopphCxrxmAhE6jAyHobHZnncCflp/1SJYqQKEOqivyoQS8yKIRUgMlvj2YR9xsih4Rgt7er2HvBIHGTlirbzWPIJPiNddaVOfJ2oEQebJ2uFJHPLBEIbzejM0Na5oi5CLFhZe7yslCJW7z96F67HD5eL+WcQEndJwLuTsjlSq8kK5BTHfDppCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7W9J6xx50RVl9zf/gu8v/A2L1KffHWgqaGOXqplNmJE=;
 b=VL+p5qNh86SgduLbWgK6AFcNTiC3KEdxnrOQAaISnAj25Q3nPBGTM+r1RLl4ETEe99RKx2Q70jBz04hRtcEHFxejp6tH/eKjkJM7E2wcxwmzhD9w/R4oXcKccCPDv3neU7H0OOKueY+A2EFDpeGrqst0N65Wqo2esYnrXlB/R24=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 15:49:49 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:49:49 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 02/17] staging: wfx: take advantage of le32_to_cpup()
Date:   Mon, 11 May 2020 17:49:15 +0200
Message-Id: <20200511154930.190212-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511154930.190212-1-Jerome.Pouiller@silabs.com>
References: <20200511154930.190212-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN6PR2101CA0026.namprd21.prod.outlook.com
 (2603:10b6:805:106::36) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:805:106::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Mon, 11 May 2020 15:49:46 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e5573fa-8721-46e7-c297-08d7f5c2ef67
X-MS-TrafficTypeDiagnostic: MWHPR11MB1968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB19681F7EC91956252EADC43793A10@MWHPR11MB1968.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ikWSDKipqhjMaLhwbo5x4Z4v2aV6TA/c/C9mhlb/6qQf62SfEeYaKIPMgaTzfErG1+k9Kd7kvLHvDx5wa9sxJrDz5b6WTR8rUDnROFoCCYWqVxYLxqTKRtuqIYlrZPpbUYC5z3s8DUh71BJuNU2IcRzMUB1KAbFPQoRD/5D+ASKvYH9jm8gKeT9FJActoDrPVizm0i/Iht+1lVIx6rv8QbVIoCNw0l7vs+lYv3+z7ZWT2cfngrWRcfOm7uqTmmMdHNqUE8zQWftrrpqerjA/8W6idyL3FmQxQETFv0x23CESziYEE7+pkLWztji0mbCUeAVSXEaihI+6hAX0ODek8kZTXwwEemHOvdXZR6VGuPovrIIPxQVH+dWDA2HxWC5xxzUC1OUQU1SmEn0JN3R9kApOl0AwoBSHPwlF94QC8i6ekR+SZECAkmIVUieCXnP0k5urL9KAssRDzlEPToPCUQY7J7eenopXL9VK0/eabb5BlOO6Lu2wb8r2c1jPtH670MJK5eUlizG2YxvrtEml+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(346002)(136003)(396003)(376002)(366004)(33430700001)(186003)(52116002)(86362001)(316002)(5660300002)(7696005)(6486002)(33440700001)(478600001)(54906003)(6666004)(4326008)(107886003)(66574014)(36756003)(16526019)(26005)(8936002)(956004)(2616005)(8676002)(1076003)(66476007)(66946007)(66556008)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kHET30azroMIUNwd4oirhX53Ix/D3yfO+drhgIheqqZxJZDGrfYJ9XW1ugBvPc+DJuzOk0xq00m+zxPBCVJy3w54Y8jbjcDA/tojKkGCJc1Xu5VR7n9aivOiWXOgRFWEAIFPFzM79AQw0UVrQsw6HN4rM3Ini+0UKP/e5AvWDNy3TImv5GoaPtaGdcrfvJ5wold+Ty8b8adQjbobc9h6jl0A5gYL9s3L3ru78YgbHcD7DyeS5wlxbUpuYKy0hC7mRLb1aoHki7PfpGBvDFHEPTX/UjmLz0k2nkpgrcr80In8NxTL7+yb26ZtfaMSg0oYjEHTYEjw0Rzzh+ziTGFk3Pxcj0uErYo98TtxmYBNa3lOUvpb9EcnFK/BSzj+zJfEs3kfLCXD8YmUgNL9u6kuVwNyqi+KjUOO2z+xPxIJJwoJ04ENJX0M7sekPuVTQn/po4f6+eJlEwaq2qrUaxxirStianvYG21IxPCQiV78FDE=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e5573fa-8721-46e7-c297-08d7f5c2ef67
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:49:48.7968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DIuyJEfEf1XoYOs1s6uY9YNtMn+Khxa8SQSMn/Snf7siU0v5NrNlc9YFHKpeUzMXfOV0Se6Z2FLzcWnE/kkmLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKbGUz
Ml90b19jcHUoKngpIGNhbiBiZSBhZHZhbnRhZ2VvdXNseSBjb252ZXJ0ZWQgaW4gbGUzMl90b19j
cHVwKHgpLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxl
ckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgfCAyICstCiAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
cnguYwppbmRleCBhYzRlYzRmMzA0OTYuLjgzYzNmZGJiMTBmYSAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfcnguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5j
CkBAIC0yMiw3ICsyMiw3IEBAIHN0YXRpYyBpbnQgaGlmX2dlbmVyaWNfY29uZmlybShzdHJ1Y3Qg
d2Z4X2RldiAqd2RldiwKIAkJCSAgICAgICBjb25zdCBzdHJ1Y3QgaGlmX21zZyAqaGlmLCBjb25z
dCB2b2lkICpidWYpCiB7CiAJLy8gQWxsIGNvbmZpcm0gbWVzc2FnZXMgc3RhcnQgd2l0aCBzdGF0
dXMKLQlpbnQgc3RhdHVzID0gbGUzMl90b19jcHUoKigoX19sZTMyICopIGJ1ZikpOworCWludCBz
dGF0dXMgPSBsZTMyX3RvX2NwdXAoKF9fbGUzMiAqKWJ1Zik7CiAJaW50IGNtZCA9IGhpZi0+aWQ7
CiAJaW50IGxlbiA9IGhpZi0+bGVuIC0gNDsgLy8gZHJvcCBoZWFkZXIKIAotLSAKMi4yNi4yCgo=
