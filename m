Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE3B1A46EC
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgDJNdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:33:38 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:31903
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726940AbgDJNdh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KY0JBxZrsUcCvavNEYzkfZtQ5zt4IDRaV3qt/YwbEYCH172+VhiT/GCn99XrpCP5AyuKeoRxsa99hZo8cAe16S/t5kVE6XCMeHYXPezPhrv4xjG/oU2nERZ2eIbicchX7w48xLOi2sTrO7VHpqyW739cCsnaD0YgNSMLcO4DRNHYyXly+bVJwSG6IZRG/p0okzf+0ucrP6FEhxoAZWn87XLGHiYnDAUm0FNu4XQhbbkKgzSv5CRdQmqCO546NOBvSwfJW5IfwvjJSDviMojh++IpQ9N+c8PrVxdd1ewx2ormeWJv0YaXqlHvomvgiGqk4xeD1iAclC3z8vFq1U74lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+k6i3QYl7UNlie9H8QNJ3/xlP3O6itZF1R+aGTJlHA=;
 b=JPFW+zeh6MbuXakWdAKRcQWJ3YF5LGrgXvLvd5Upx5oQJldiJI/EZ+vWZAmPuKR9KWwSPITu0/KxtipISN1LosWCs0r7yErASdi1ihyEhbeBkCrPJEVs/TUSLqIz3SpW7i69EA7ElY6qc2NlQwRKh6hqu02LU7adpnrzErgY0dllj9etBb0k0muyxO975BcmrQgIawBg/cdM4fELPZnV6j8cPKZzoZHcFhG5F9/QartzifDy9m50kNv+zP4SVPUm5OpYSmZ4onj0U9IB7660hXQ3eVnwtMerELijhSOK7Vq1LVIidepM9DgtdXSXMA3hQWIUCckmVqrxjJLmx694aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+k6i3QYl7UNlie9H8QNJ3/xlP3O6itZF1R+aGTJlHA=;
 b=ZAtuIDnjB63BO+9h44YrraeIf4MbeSGMhVavl+4r0924Io4tdbfa5gzh8lH3e4dTStyDqNXO9aWfMXQoGnuYKDejeI7iAlPlC9b12fbKzLL0TADF8ZRRMhhQSVfFB2AANKgs6CVPGocpN7CLgkZDBwg8gvRhxycFuXhPwrucXPs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:25 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:25 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 14/19] staging: wfx: allow to join IBSS networks
Date:   Fri, 10 Apr 2020 15:32:34 +0200
Message-Id: <20200410133239.438347-15-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:23 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2df7867-4904-4cad-2a7a-08d7dd53bf0a
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB43980ED45A92F321E7E3A57E93DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(4744005)(6666004)(8936002)(4326008)(52116002)(66574012)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3XcRfiAq24UpqNBdCgHp79U7i78XDtukphHfLc9d4rs509UNIG1faO2iKfymQ6laD3Pg/GzrCwCnuItSE+pV2w2SumWfif9ZJ6fPHgWcjVkw0ZVjD6X7bpvg7R/LYmcpK1v95U9/dTBuqe2AhSO6qTss3Jfufzyh4XO1qOLQEj04Ddy2Rim8jsPBaSxDw4DSy5IO6ohzkkTn0fb0P9Xy+GEF+qAhiNgyWZzJ9PygN6YR8wXMyJwD79uUBiOEjaCpHsN/o73VLRXuk2M8c4HBrL/vXl6IK3VsQAS42cPobk2NJKJoeG4oIr62mQnBhba1q04CCgXGVjY6UEF5HHYVRjjhVStgxIOixLzDPUlpadphlIUU37XoxtbHA3etSlVHGuWuqxeSaLDYGqljkeJqomTpNytXH5gWdTwnBEq/L3u/3Dr1Y9LvObaonfNxGfbA
X-MS-Exchange-AntiSpam-MessageData: 5ziEVhuLPrApIvhgrSXs9Ss5a07cqykIfK3VKplORHvACDS7z32NS+nAApFy/DExA1W5NTsj2FAMGQf0CyNhPL0lqu+ERoYI9jL33rdbsfIwkw1r+zClxaqhbtaNbzjqDMPRyII7prGMMMO1WZhjYGC2W1AGUjxuwCG3ExVe8QE/71C1Sgj8A62XC7Ug/PFeWqRORqGZkr6ICVD6FFYJwg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2df7867-4904-4cad-2a7a-08d7dd53bf0a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:25.6331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yep5ktm1l0/oMQKKqKZlWQTnsaXDUDTgetlyGl+lS/rcMaVt3mLYiMKT6zISvISlNt1GVhqUFgrlsnTwddtuYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudCBjb2RlIGRvZXMgbm90IHBlcm1pdCB0byBqb2luIGFuIGFscmVhZHkgZXhpc3RpbmcgSUJT
UyBuZXR3b3JrLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3Vp
bGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAyICstCiAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpp
bmRleCA3NWYxYzUxNTc1MWIuLjhhYTM3M2Y1ZGVhZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC00ODQsNyAr
NDg0LDcgQEAgc3RhdGljIHZvaWQgd2Z4X2RvX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJ
CXd2aWYtPmJlYWNvbl9pbnQgPSAxOwogCiAJcmN1X3JlYWRfbG9jaygpOyAvLyBwcm90ZWN0IHNz
aWRpZQotCWlmICghY29uZi0+aWJzc19qb2luZWQpCisJaWYgKGJzcykKIAkJc3NpZGllID0gaWVl
ZTgwMjExX2Jzc19nZXRfaWUoYnNzLCBXTEFOX0VJRF9TU0lEKTsKIAlpZiAoc3NpZGllKSB7CiAJ
CXNzaWRsZW4gPSBzc2lkaWVbMV07Ci0tIAoyLjI1LjEKCg==
