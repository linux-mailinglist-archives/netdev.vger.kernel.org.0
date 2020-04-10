Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9771F1A46B9
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgDJNdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:33:04 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:31903
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726181AbgDJNdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+qR9/kFx9PiB1bvI6ufuB7MLlxITyIK0I6BK1QwoO2LfozWcvMygKuCTgIQgXE5qUY5OahgE5x0ZlsKjMn61K5kXZ57QzRVKHit8rMAvF3T6boa3/RzVKUY0pq37BtpyK8auYdqVFSoFDQ9SBkED7yN1XE6sI6VO73msC9RAXDpFfx1dpIMf77GGhegXsV3Ph3tTcVwmm0CCdKybF5JxtceM7yDYGlxINJZEjzua0mujFjw1I7i1PXHgfMD1tLJGSG3Ib5h2QabRTiNZ53II1655DSsGCf1/XaDyTEuQCVh57vJkpYidjAVhaH+CnbuH0Uav66ugraDYkwa+Z5pfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ReanvtT/cyTujwHvDghjxXROX8i/R50wqYa1At2zGA8=;
 b=JaUIwTDBmPhL49f9jALR8HUr5Zpx1vTrKw68TBUev47Gg+mYCr4D6eG61O9niOX3o+you8a28167MJHtC3QGE+CG1vI//L3osi+DNFbs1E9oG27HfoV3wudGsgr8LcJAQzQz10xWJZVowXdyuo0v8nyVK1m3o5sKqlYRId8MchmaJvo5aokpNYq7TAbFyBqxLAWdcS5mgPVn3YX/8zTEeSJ4GUq8zf0P0o3UZxLFSZopoRKtfXVqxrj50JBHl/2K+givTH9/sDXTGUQoxHsnrcRzJyA7UMbg65GRdhhGgC65GauRAWd73SclvdPKUMrFr46H2qyEmhNr1cylht28gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ReanvtT/cyTujwHvDghjxXROX8i/R50wqYa1At2zGA8=;
 b=ZP34UKRK7IpoRxhQNBINdGyk4jaL72rciCR+t3GeDDzeXejGwOF302U5RoF6e9RdTFz7l36CXCUi/vqr7ggz6pjcnBJh0uswsJ5okcRv1ybkjLTZ1sIJHYmx6Vea0pstCSKKU4JeWf1O8hwEOL3e1QDGzkJWdIZYbAZxY7LLNu0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:00 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:00 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 01/19] staging: wfx: fix race between configure_filter and remove_interface
Date:   Fri, 10 Apr 2020 15:32:21 +0200
Message-Id: <20200410133239.438347-2-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:32:58 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4dcfdaf-15c9-4f30-d679-08d7dd53b025
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB43984EC35337E8022AA4918893DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(6666004)(8936002)(4326008)(52116002)(66574012)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v0Wn3IGW6eZ4aNivT+cWGTppfUhEojxQyhVH7xhCU73v202QuuIb4XaZXf+MfwxUzxB13+63o/5LohZ7wotmjgDnRzjqUQ7DF4v6Mld1mfP96E7tUwIhLcTvp5qOl7gqvvqcHsubO77vKaUMWY51Ddxoyuh4yh5gSWi8qFJIgSJEQ4cHElucCH2Avvs2evOsiW4XwcPlAgz/pNJbprobLXmF8rxl+BLrvdZNr7ZFQxLbDezRN/LJBeAi3bib0YdggWtYotEb8+C9Nqmx+XjWcBhk+EUXcNdjCvNDnzQDdhtVZDWBA4vVDLm+XZInFvOqmm9nYeOWwvjAN22e9OaFE6aXiZmyhHUbVA+MLw4hQIkmpVsDlr50KaTakRfCZhmJBXnXKrFbVm1JCtYBJ2N02KYvSziQ5q7TmCtxrGn63f8pPosJi25FVZ+Lzfto5PPi
X-MS-Exchange-AntiSpam-MessageData: BV7TAgthZtvpA8E4WnEqdvki/WQfPY7xz5HRgwvRo9EHJlpTaJZZ8gfdg2TRFpJCx13D3eTZQkztOmdMExA54pnl8hPq4SoF8IYMOFINZ4g6O8f1jT+irQrpTypr8rGEuM01wueuy1XVXDnb6ySv+SvYG9tpgncIIMbZsIbu+jaryFQR3eF3+Y5pVXTSGzljg0lb6vfAStlIbxDc0nhYjA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4dcfdaf-15c9-4f30-d679-08d7dd53b025
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:00.6406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ztRYh3Vn6oKwxleerpzGG332KQQQy45A/u8XbkLH5RappaCNLxx/klDndRl1S26e9JlD9qT/0QPL86zJT87XwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3JlbW92ZV9pbnRlcmZhY2UoKSBhbmQgd2Z4X2NvbmZpZ3VyZV9maWx0ZXIoKSBjYW4gYmUgcnVu
CmNvbmN1cnJlbnRseS4gVGhlcmVmb3JlLCB0aGlzIHBhdGNoIHByb3RlY3QgYWNjZXNzIHRvIHRo
ZSBsaXN0IG9mCmludGVyZmFjZXMgZnJvbSB3ZnhfY29uZmlndXJlX2ZpbHRlcigpLgoKTm90aWNl
IHRoYXQgd2Z4X2NvbmZpZ3VyZV9maWx0ZXIoKSBub3cgbG9jayAiY29uZl9sb2NrIiBhbmQgInNj
YW5fbG9jayIuCkJlc2lkZSB0aGF0LCB3ZnhfaHdfc2Nhbl93b3JrKCkgYWxzbyBhY2Nlc3MgdG8g
dGhlIHNhbWUgbG9ja3MuIFNvIHdlCmhhdmUgdG8gbG9jayB0aGVtIGluIHNhbWUgb3JkZXIgdG8g
YXZvaWQgYW55IGRlYWRsb2NrLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGpl
cm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5j
IHwgNCArKy0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICB8IDIgKysKIDIgZmlsZXMgY2hh
bmdlZCwgNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKaW5kZXgg
NmUxZTUwMDQ4NjUxLi4wYzdmNGVlZjA0NWMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc2Nhbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCkBAIC04Niw4ICs4Niw4
IEBAIHZvaWQgd2Z4X2h3X3NjYW5fd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJc3Ry
dWN0IGllZWU4MDIxMV9zY2FuX3JlcXVlc3QgKmh3X3JlcSA9IHd2aWYtPnNjYW5fcmVxOwogCWlu
dCBjaGFuX2N1ciwgcmV0OwogCi0JbXV0ZXhfbG9jaygmd3ZpZi0+c2Nhbl9sb2NrKTsKIAltdXRl
eF9sb2NrKCZ3dmlmLT53ZGV2LT5jb25mX211dGV4KTsKKwltdXRleF9sb2NrKCZ3dmlmLT5zY2Fu
X2xvY2spOwogCXVwZGF0ZV9wcm9iZV90bXBsKHd2aWYsICZod19yZXEtPnJlcSk7CiAJd2Z4X2Z3
ZF9wcm9iZV9yZXEod3ZpZiwgdHJ1ZSk7CiAJY2hhbl9jdXIgPSAwOwpAQCAtOTYsOCArOTYsOCBA
QCB2b2lkIHdmeF9od19zY2FuX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCQlpZiAo
cmV0ID4gMCkKIAkJCWNoYW5fY3VyICs9IHJldDsKIAl9IHdoaWxlIChyZXQgPiAwICYmIGNoYW5f
Y3VyIDwgaHdfcmVxLT5yZXEubl9jaGFubmVscyk7Ci0JbXV0ZXhfdW5sb2NrKCZ3dmlmLT53ZGV2
LT5jb25mX211dGV4KTsKIAltdXRleF91bmxvY2soJnd2aWYtPnNjYW5fbG9jayk7CisJbXV0ZXhf
dW5sb2NrKCZ3dmlmLT53ZGV2LT5jb25mX211dGV4KTsKIAlfX2llZWU4MDIxMV9zY2FuX2NvbXBs
ZXRlZF9jb21wYXQod3ZpZi0+d2Rldi0+aHcsIHJldCA8IDApOwogfQogCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRl
eCA0ZDVkYmZjMjRmNTIuLjM4MGU1MzE5NDcyYSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC0yNDIsNiArMjQy
LDcgQEAgdm9pZCB3ZnhfY29uZmlndXJlX2ZpbHRlcihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywK
IAogCSp0b3RhbF9mbGFncyAmPSBGSUZfT1RIRVJfQlNTIHwgRklGX0ZDU0ZBSUwgfCBGSUZfUFJP
QkVfUkVROwogCisJbXV0ZXhfbG9jaygmd2Rldi0+Y29uZl9tdXRleCk7CiAJd2hpbGUgKCh3dmlm
ID0gd3ZpZl9pdGVyYXRlKHdkZXYsIHd2aWYpKSAhPSBOVUxMKSB7CiAJCW11dGV4X2xvY2soJnd2
aWYtPnNjYW5fbG9jayk7CiAJCXd2aWYtPmZpbHRlcl9ic3NpZCA9ICgqdG90YWxfZmxhZ3MgJgpA
QCAtMjUxLDYgKzI1Miw3IEBAIHZvaWQgd2Z4X2NvbmZpZ3VyZV9maWx0ZXIoc3RydWN0IGllZWU4
MDIxMV9odyAqaHcsCiAJCXdmeF91cGRhdGVfZmlsdGVyaW5nKHd2aWYpOwogCQltdXRleF91bmxv
Y2soJnd2aWYtPnNjYW5fbG9jayk7CiAJfQorCW11dGV4X3VubG9jaygmd2Rldi0+Y29uZl9tdXRl
eCk7CiB9CiAKIHN0YXRpYyBpbnQgd2Z4X3VwZGF0ZV9wbShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikK
LS0gCjIuMjUuMQoK
