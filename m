Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245211A46B8
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgDJNdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:33:02 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:31903
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbgDJNdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYWr4Yp4vuipIoI6ocIuIR9kpdt10NneweKmwxhww3zUREZ+HDUfFyxde8EVY8LV9J62TkMn1wIA5zC2dccDoIHDoa9jnQbag9GWspNGq0JXFLnTYefVBN7z50umRykusegyewLNmsNS4JEYhI1a2vf0gbreXH9frkWaY+Uh6v+2TDtzKr+Sh8rBgKgrgmdm/jtryrgD+FwNvLDtipxiNpKB4BYjdQanvxhmLmOBrUMAA46LlJRG5/RjMqizEUOj1DlGqErkI+bhy3IAGSI8SFhY0dlMw0KHnLkUHncbmc+gcDf19espGJ8vywmk12wZst6Qb6Va+zpsBa60cmxLgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJT3ghRjYF+yCt0VzNVh93PeCH6CUzTVgVy/EH9E+38=;
 b=fmjdWmW9oDVwLf0RBgS0cdyZfkKJURm6Z3rmYnrzwulZdviH6ph96pahLBI37YX7aqKeYl6cjP0r8o9jGxwY6tIVpK7ncwP2TnUpMcOJoNFwouW4BXlSH8Y1SaJZFJE5KK+RpGxzegPXKd8C3gwT5ZZc1deauC8c/0z+nQjTICfwSbiQFhzhF0F29PSgEZYFRX36FEqdU09274cfLyABRoIukSliR4IJZNicf1dLwU7vY4XdSclGOZeiQsMVDCa8k/BI3GKp35cumxksISLRBl24NgKwoYcVU5Lr/ZWnJoH98UGsq2vljv2ldr2EVvfq7Vgd+mWidvbpQi4TF44Bcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJT3ghRjYF+yCt0VzNVh93PeCH6CUzTVgVy/EH9E+38=;
 b=eYVE4cKjcYDwnKuWjXbbPV4E6cjYLPReVb9o1WP8GrcKw2TbRqczPQuglkFntp/+/LtropcT7HEdCuDhQjJm4lP/asulb3T6kYOC1mJrB3LUV/lUbg5dELk8LcKWDpm7EPzOpWkQEli8I86lbq+DtmcWGqXVXQXKtD6qwqP/mn0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:32:59 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:32:58 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/19] staging: wfx: simplify start/shutdown of RF
Date:   Fri, 10 Apr 2020 15:32:20 +0200
Message-Id: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR15CA0056.namprd15.prod.outlook.com
 (2603:10b6:3:ae::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:32:57 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ebb8577-3b2d-43a3-f974-08d7dd53aef6
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4398CF1040F11CF1A43E4EF193DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(6666004)(8936002)(4326008)(52116002)(66574012)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6zx6D68VPXxYU44cOtbtVVydnLD7SPEE3m+RM4XkItYe1ZwK3KQSChUsu7uCL/maMHq7Lp/W6cCKxD6XgHE5tadtmBKHQpm/qYCWQ8LMkuYYORfJLihQxQaZaidXf9UUnh6A4Z6Zj5l4R8puyxNvvYxM0Okz7l0+AEfSaMF4kTTi5aM6oZ254764cSeIciGHk9MTtx8U8oq7gVU7iJtkC+faD/LVyo9H0M2AuuJpXyrY01Ebu6i1DlIrvHxa5wrDZungUF+00nU5VOdvsjy6Hda99T4AS5hR1tN3qP8d6ev3wE2iOTs97pXgUjQcS2xOWDRQI2NeH0TgE7muwwdIdhtI1YyzGcG972yvfaeNBuBT7w40k8ExIuSfOX3O3tmEEEMdAqYHwGJPln/nbu/O7L37XY4MwMKdtszTFerFq/9La76A8htZ6H4DdA8Hjipk
X-MS-Exchange-AntiSpam-MessageData: AOeIXXKVBiKjBpF8DoxLBSc9jsf0yalBwTNuXAYS5KjHNys+jYwMFU+SsoYaUcblfR+miXEZiWt6ZzJ6KLNiIoZhg3KNOLwIG5TbZw2ZIEtPnTzpEaJwfyfp7itlGEOcQGEk1dSYC7NLf3pNYDOGsHW3FfqKkGSf9fYk/D4xm7YGWriVILnwrBBVP5Eku4f7PZ7scaQjZagl0MkgpuBvlA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ebb8577-3b2d-43a3-f974-08d7dd53aef6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:32:58.7247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fpHDgpkj+/7LQf3+AWSSxGW3ySoc+H3McS4i/UED2ekDibZaTHOMPoUBZTUeSlLXI31oW07heDInK1SZHtvPLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGVs
bG8sCgpUaGlzIHNlcmllcyBtYWlubHkgc2ltcGxpZnkgdGhlIHByb2Nlc3NlcyB0byBqb2luL2xl
YXZlL2NyZWF0ZSBuZXR3b3Jrcy4KCk5vdGljZSBpdCBpbnRlbmRlZCB0byBiZSBhcHBsaWVkIG9u
IHRvcCBvZiB0aGUgUHVsbC1SZXF1ZXN0IG5hbWVkCiJzdGFnaW5nOiB3Zng6IGNsZWFuIHVwIEhJ
RiBBUEkiLgoKCkrDqXLDtG1lIFBvdWlsbGVyICgxOSk6CiAgc3RhZ2luZzogd2Z4OiBmaXggcmFj
ZSBiZXR3ZWVuIGNvbmZpZ3VyZV9maWx0ZXIgYW5kIHJlbW92ZV9pbnRlcmZhY2UKICBzdGFnaW5n
OiB3Zng6IHJlZHVjZSBob2xkIGR1cmF0aW9uIG9mIGNmZzgwMjExX2JzcwogIHN0YWdpbmc6IHdm
eDogY2FsbCB3ZnhfZG9fdW5qb2luKCkgc3luY2hyb25vdXNseQogIHN0YWdpbmc6IHdmeDogaW1w
bGVtZW50IHN0YXJ0X2FwL3N0b3BfYXAKICBzdGFnaW5nOiB3Zng6IHNldCBhbGwgcGFyYW1ldGVy
cyBiZWZvcmUgc3RhcnRpbmcgQVAKICBzdGFnaW5nOiB3Zng6IGNoYW5nZSB0aGUgd2F5IHRoZSBz
dGF0aW9uIGFzc29jaWF0ZSB0byBhbiBBUAogIHN0YWdpbmc6IHdmeDogcmVtb3ZlIHVzZWxlc3Mg
Y2FsbCB0byB3ZnhfdHhfZmx1c2goKQogIHN0YWdpbmc6IHdmeDogZml4IHN1cHBvcnQgZm9yIEJT
U19DSEFOR0VEX0tFRVBfQUxJVkUKICBzdGFnaW5nOiB3Zng6IGRpc2FibGluZyBrZWVwIGFsaXZl
IGR1cmluZyB1bmpvaW4gaXMgdXNlbGVzcwogIHN0YWdpbmc6IHdmeDogZHJvcCB1bm5lY2Vzc2Fy
eSBjb25kaXRpb24gY2hlY2tzIGluCiAgICB3ZnhfdXBsb2FkX2FwX3RlbXBsYXRlcygpCiAgc3Rh
Z2luZzogd2Z4OiByZXF1ZXN0IHRvIHNlbmQgYmVhY29ucyBpbiBJQlNTIG1vZGUKICBzdGFnaW5n
OiB3Zng6IHJlbW92ZSB1bm5lY2Vzc2FyeSBjb25kaXRpb25zIGluIHdmeF9ic3NfaW5mb19jaGFu
Z2VkKCkKICBzdGFnaW5nOiB3Zng6IGF2b2lkIGR1cGxpY2F0ZSB1cGRhdGluZyBvZiBiZWFjb24g
dGVtcGxhdGUKICBzdGFnaW5nOiB3Zng6IGFsbG93IHRvIGpvaW4gSUJTUyBuZXR3b3JrcwogIHN0
YWdpbmc6IHdmeDogaW50cm9kdWNlIHdmeF9qb2luX2lic3MoKSBhbmQgd2Z4X2xlYXZlX2lic3Mo
KQogIHN0YWdpbmc6IHdmeDogcmUtZW5hYmxlIEJBIGFmdGVyIHJlc2V0CiAgc3RhZ2luZzogd2Z4
OiBjaGVjayB2YWx1ZSBvZiBiZWFjb25faW50CiAgc3RhZ2luZzogd2Z4OiBkcm9wIHVudXNlZCBh
dHRyaWJ1dGUgJ2JlYWNvbl9pbnQnCiAgc3RhZ2luZzogd2Z4OiBkcm9wIHVzZWxlc3MgdXBkYXRl
IG9mIG1hY2FkZHIKCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIHwgICAyICsKIGRyaXZl
cnMvc3RhZ2luZy93ZngvbWFpbi5jICAgfCAgIDQgKwogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2Fu
LmMgICB8ICAgNCArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICB8IDI0MSArKysrKysr
KysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaCAg
ICB8ICAgNCArCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oICAgIHwgICAyIC0KIDYgZmlsZXMg
Y2hhbmdlZCwgOTIgaW5zZXJ0aW9ucygrKSwgMTY1IGRlbGV0aW9ucygtKQoKLS0gCjIuMjUuMQoK
