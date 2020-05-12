Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A811CF864
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbgELPFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:05:00 -0400
Received: from mail-eopbgr770072.outbound.protection.outlook.com ([40.107.77.72]:30085
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730672AbgELPE6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:04:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6tzswBd6T8k4XdzBRkY4RiK86VpUMuOjqihNiQnVccAB/L+tte8KBSjuZXPrvTV86ksICtv/d15GAyjZQVMcnlm64xqvqvUyzV2dAoax3cmPCleYiKg7Sx+PAXX73ca1bD5XesN24WbYxiczjiMN/7Oqu0NVwtSiy3xPrW+Kt9HJGxIiSixy4tFOyat5ASzn2ceRnhmLsoNCWOyNxfd3Fs1of2bMMDMTomFkeZ6LvKlY30/YMajKub88kwxg4xkJACAZuJSez09T6h5E+/hwhWnIu2ZcEqoH6vuzGwDzljmHYmOCvBLkwSi6szrcCC6oZomSac92O5cvAlHixWfoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLoy7SPr/nnlx+NwszrJ2bm7GNP4HsvqH3meQhmDzEc=;
 b=eGOqe5oMX0Zr4rFJRvOzl2fm4j8Q5W8qoNuYgi2d2iPC2/A8AMJC2FNtJ+biyqo43FRvKMwEjUDyeaDJ++OiVV2nevj6WUT/Z3b67lnLOxiibsNMKDC4kNsPoyUnRHzUyIOBasEya9IzSFch3RrJ21N3cNlncRyWpFuE2E69Xej8WJ7tEZiWxbZ5M9CYo44ATZiUaol2PbznDzHlLmPGLaa0uLCfcOhzPgANqGTRorZoOI8FcEvhLhAM4doJ++CAt/vGLT5mmvCBS6VBadZnNOVT1ifN2Ay4nn0E/O0WTkd+WvEeWgfqAJ8kEkDNX+qDn4lbd2lqA4HaD5mj5HjMbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLoy7SPr/nnlx+NwszrJ2bm7GNP4HsvqH3meQhmDzEc=;
 b=RHa5HFYdNuVJyKVFtzcULzGBuwCUc/Z+1lLuqDPexobfb8LeoghgfLZvoAIyLUI6b1l1RkXF9aeTZ45dyH23Cw82CiT0p6TcIV+hol8pp1uLKDcZCDl+rlqMak53T0kvaLDi5U3xWTI0qGRvrsH3JXBp0TQdz+sZqo6pEzS4eZM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1741.namprd11.prod.outlook.com (2603:10b6:300:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:04:45 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:04:45 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 08/17] staging: wfx: fix access to le32 attribute 'ps_mode_error'
Date:   Tue, 12 May 2020 17:04:05 +0200
Message-Id: <20200512150414.267198-9-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
References: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR1101CA0003.namprd11.prod.outlook.com
 (2603:10b6:4:4c::13) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by DM5PR1101CA0003.namprd11.prod.outlook.com (2603:10b6:4:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:04:44 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d832b7a0-71f1-48ee-9984-08d7f685ceba
X-MS-TrafficTypeDiagnostic: MWHPR11MB1741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB17414D5218B22CE8C41BB57393BE0@MWHPR11MB1741.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zIc3LJ26YuJMdah/yPwd0myYlPLwoIh4hk+inL7FV+6Xz5J22VNOPVnFqpsUAbPF/ygxJ+i9TpDeMGDQcewrhtdMKfqt5scJ9F+7D2Kys6nIAkQVC1xuJXxOWKqIM4AVYWKLcfniLx6kCtmhXdLorQ6obwRiPUGEPknuuwmi1Yf+3crKG7UELkoeKlpuMNsNXEh+aV3cizgG2VHeFMj1McxtYktvJi/yz33EPEiVTAH+ufbJPScuUsUOZYEnGNM3jxIXWEzlpXObLXxn1utSJT8j5aDj6hnUvWKD9agLMRp1dCpiQSKsvFN3vo9s5e6IIs+PK/LqXYBXtuLrTDU+nOsRDCx4qmoVMhec5qudgjCBSRKKUw0mTEK3jYXRAlaNllOIlYH7iQlS9kaX0TUpnpD7B4q0Rv+pGZvrld3eB2G5/V1+BLJVnXogIEn6nlLZjgkyB0S5x5FaN/Sy4h3xrGpTI06vDQvqaYEXAB33k/PmxGvdyfqH5dzNkrGtr6dS3GkVRR7NkAp2I4b6XRdc6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(33430700001)(54906003)(107886003)(478600001)(8676002)(5660300002)(316002)(1076003)(956004)(8936002)(2616005)(186003)(2906002)(7696005)(86362001)(4326008)(52116002)(6666004)(6486002)(66476007)(66574014)(26005)(66946007)(66556008)(33440700001)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: v2O4/zCuSXAlJ5oUGRhzZ2kSb7igwn2H32ZXXMhDpU7vtHVH9mFsab2Ku/YyZ0mZrZkpph1crGLKd07nJFqNs7RTRssuRvsR2u9hvv4EXB31N1HIju01CiTHOiX3THmbXyFmM80Dg9866Wd0GuVJl5aMurSkkkX3EB9VnItB5sR52HVsVvVeq3FTuRH6ifV2KCl03djvwxC8TQA/qHkIOneTasOj04RInH3cAGOmtvbRM2yV1Q0QDIZzb2HO8JT9GS8X416F+WKVlY7PWL+vdkNQcFEbhPVlu9m7tpKq1lpkNjc935k0dR1gkwKSYsu2nSS05n9KQyekC5yL+KsQdToRcWAqr8p67ZfYNv42TizGuapMoXrEcbMv+Z31cFC/lTa4lZ3ZWHjT3AlPLqnqectibRTmYIbe3QDUyNvy17LfJHObMdDxrLA0Yp4EZWMOFotsNWLmNeUsfOz3Tot3Ln2k/uXVTqxUlslQ7mavYyE=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d832b7a0-71f1-48ee-9984-08d7f685ceba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:04:45.7772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E73iJc2s7XrX9FxxcqFjzOqauCer3FUqsCTL8R/8VHBTZFtpfSG2HsVUdhyB9qNG03iWxEzDJ23ESOCZD6ThXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGF0dHJpYnV0ZSBwc19tb2RlX2Vycm9yIGlzIGxpdHRsZS1lbmRpYW4uIFdlIGhhdmUgdG8gdGFr
ZSB0byB0aGUKZW5kaWFubmVzcyB3aGVuIHdlIGFjY2VzcyBpdC4KClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl9yeC5jIHwgNyArKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNl
cnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3J4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCmluZGV4IDgzYzNmZGJi
MTBmYS4uODdkNTEwN2E3NzU3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9y
eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKQEAgLTE1OCw2ICsxNTgsNyBA
QCBzdGF0aWMgaW50IGhpZl9ldmVudF9pbmRpY2F0aW9uKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAog
ewogCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gd2Rldl90b193dmlmKHdkZXYsIGhpZi0+aW50ZXJm
YWNlKTsKIAljb25zdCBzdHJ1Y3QgaGlmX2luZF9ldmVudCAqYm9keSA9IGJ1ZjsKKwlpbnQgY2F1
c2U7CiAKIAlpZiAoIXd2aWYpIHsKIAkJZGV2X3dhcm4od2Rldi0+ZGV2LCAicmVjZWl2ZWQgZXZl
bnQgZm9yIG5vbi1leGlzdGVudCB2aWZcbiIpOwpAQCAtMTc2LDEwICsxNzcsMTAgQEAgc3RhdGlj
IGludCBoaWZfZXZlbnRfaW5kaWNhdGlvbihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwKIAkJZGV2X2Ri
Zyh3ZGV2LT5kZXYsICJpZ25vcmUgQlNTUkVHQUlORUQgaW5kaWNhdGlvblxuIik7CiAJCWJyZWFr
OwogCWNhc2UgSElGX0VWRU5UX0lORF9QU19NT0RFX0VSUk9SOgorCQljYXVzZSA9IGxlMzJfdG9f
Y3B1KGJvZHktPmV2ZW50X2RhdGEucHNfbW9kZV9lcnJvcik7CiAJCWRldl93YXJuKHdkZXYtPmRl
diwgImVycm9yIHdoaWxlIHByb2Nlc3NpbmcgcG93ZXIgc2F2ZSByZXF1ZXN0OiAlZFxuIiwKLQkJ
CSBib2R5LT5ldmVudF9kYXRhLnBzX21vZGVfZXJyb3IpOwotCQlpZiAoYm9keS0+ZXZlbnRfZGF0
YS5wc19tb2RlX2Vycm9yID09Ci0JCSAgICBISUZfUFNfRVJST1JfQVBfTk9UX1JFU1BfVE9fUE9M
TCkgeworCQkJIGNhdXNlKTsKKwkJaWYgKGNhdXNlID09IEhJRl9QU19FUlJPUl9BUF9OT1RfUkVT
UF9UT19QT0xMKSB7CiAJCQl3dmlmLT5ic3Nfbm90X3N1cHBvcnRfcHNfcG9sbCA9IHRydWU7CiAJ
CQlzY2hlZHVsZV93b3JrKCZ3dmlmLT51cGRhdGVfcG1fd29yayk7CiAJCX0KLS0gCjIuMjYuMgoK
