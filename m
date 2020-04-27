Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EDC1BA526
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgD0Nma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:42:30 -0400
Received: from mail-mw2nam12on2085.outbound.protection.outlook.com ([40.107.244.85]:27104
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728116AbgD0Nlc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPj6v55XamexDKiGixbHEpWScxaYmMKB90SIyuZrB25Bb7y/9mbvvN+lgauLJSzF2jyWXYD2beDOLALxcMD6kuWIHoLt190qWNrwQPXOfngh2SBlLRG3pSlycIwdX/4tB8o39MctfvacJwjRPEOV3FmoKcdYg1Es21AvfpNDFkKkzRvEPHxYdwwa8rTjX2UjaUhV3mdo+XTITDLvGueoOQDPi5csVm1An0U1UMPD/MdrHZw1pmINDgvD3wtWqom4B4LgrvA9TVnVzFyFRQW8WIjjr///D2xcHshMEp6iXl3qGBTxtI8QK8HCxLjl3zkYgTq6kgF4w05G719ppC7REQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=On2eMFuNjyY36pdcuuXf4k4EUyRYjcNDklcZkuROdwE=;
 b=eTBpRhGAzr6vcD3UgtYVXVb6T+Eszbxtw5VfB9NXJVESCtvPP6YyQuJxJU570a3OSpBnL6d/8wbpOSlnUWkq/AUMwqyRnhst06EXVaPy81rPwHzg9YwMlwqtBMXwIN+muxyCxiJ7yfghGJuU2F6moSmiKK16Ogl6aJUkzyJpWdZT7nS+ZTtgmy9a0myew4Wq7X6t4gctAe0g+qWP2j6g3TUeGqPkt+tifaAMLC1GLCr2rPBy/pEg2QXEZqM7SBOxuv3VVxnk6Wi1R4pqf9s39JQy7JxPzE0ApQq/eLIY+7HW+TACSoenolUAhZXyitwy8/AjdtKYoOObhlnI4wtfsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=On2eMFuNjyY36pdcuuXf4k4EUyRYjcNDklcZkuROdwE=;
 b=I3fGbg5CXtcHEva16WxHN99XUdW1mgcNVfrWBcK6X5KVd4ZVGy/lhR16SbTgqnjZL8MxVIGXsFXHl1htvPoSi2UPza0V64xMWIKYWsPLfRJ95Fu2+s42yknJLu8zyTJjRPETippWNVq7JFj2ZsYLx+Oc7BiH9G6usDOFR5AO2yM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:28 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:41:28 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 11/17] staging: wfx: fix double init of tx_policy_upload_work
Date:   Mon, 27 Apr 2020 15:40:25 +0200
Message-Id: <20200427134031.323403-12-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:41:25 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6a75ff4-01dc-4d4e-3162-08d7eab0af8e
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1424F2B7F24FBA1FAD51162893AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4744005)(4326008)(81156014)(86362001)(8936002)(6486002)(52116002)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(66574012)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JhQrA7DO9Ue1NQkIv7op2nnRO9BnnmtYYQIgXd+uGXda4vEMTbqrcQ44YPrZhOkgNSpD+vuoisH6bJrNfl6KHHP3HGW/7JwmJ2xVF1HnuoTC/cIbsaw0yDOYflC0bOhdlJQxbKirSEXaCIl1+gNB3lA8QBC0F7Ee+b/KBAhH7sCindZ1/ZaB5UfughoXUjw+i6Ax+BJHQFZ2Hsb7aRgaTlwXa8gbgK1tXXf7ksvKT3VkPlUYzhe2L7zwiszhkOilQN7ZbaAYEKy2fLWxF94XqtUnefFP/WO90fb9ck7Re8OYUSnOp89w0ucAC8k2ApbHLxBHJqdmNkA29KZe/lBdhP6wZ3CbK64BAzc7pxXRLx52ZUecV8m4xBY6/9lfmQKparvmhhjZnUGgU3eNhCPkOM/ORwlpKdJgvgj8YfG1g8Ex12wVb/Q7IwtSCRoYukI7
X-MS-Exchange-AntiSpam-MessageData: Ytz4JuhSDdP3QtvfbYHhEOznn41/Sv+izIYYKkGhYE/filRoTqSzPSa3c6yXGsrDQ2kSpxnBk6yU6EpQprNkBUUmsBENC16NcOBMEd9V0PzKu4xXNKH6WkAzfrJdX4w9ryTgrl8POU9BHGtYBOeCBKexvsBLoYLx44cVytmXcRUhlum9Rj9b6nebNkWgJz6HqnsFGrZloEc3vuw9pKo/AoO85wE2wGiESC+aC1VdueB7Sqn13sYq9f4E0MIItr7u57+msZkczlbCQaDgIRuwfNhiu9pyFO279XZ6/tg6PxzOks1y58sFdZr6kP85ZRyf4bhA8YohGhkB7DX8ETbs9BnZ0blZ+Pv2lfPPuDdFaQ1mstxvFkAe0tlSb/pjOsy2naKToer+9DLehQm2Ys1ucP32pRpeUDzVutE1cCLXK/70CfZWKysAisodhvJ349WTKtF1cAPe11S4yf3AfN5x9ysyf7J27v1YmQLW/rZ3T/En1MhLySlH/so7LcJuMdd9e3oGFa0z8TbthqZcvvglM1UI+QjEsdrBkre5Hn8hXIOJzqTisZZlek/rAqqC8jkcAIX1mHLuZhki5LW0D97lrPQR3Me1mz9fOAq63KIzexj6PH0An6DiKAF3HjnWSSBg2Plyvk54dfC5FNc/wZ9jUuzrQhY0phGJjmzPUjCV3tOQg31s/UsY83VZdDMw2xCTuDA665xwTt4F9z/bOC9dE46AP21DeIceSa2OlnlcEYtqm802TKY8rKI9yNhShvQiVCpUdh7j8Y0M094MCGaQyxORuhD/8bAHlFccIvTtIwIGwlEydkK9ZcgxNUXuqA3keZSrxfFtpZFE0hXkMMzFHkWAxuV02tZ9oQg/7zrFk7g=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6a75ff4-01dc-4d4e-3162-08d7eab0af8e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:41:28.1927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqC01YgsYeKsFUpm7BwCQuYx9iZA5ibp4GxKgu50RTK2fjlIKagAWSL8K9EdJVs1XfrfH4Q7mT2aFcgE+aDoHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHdvcmtfc3RydWN0IHR4X3BvbGljeV91cGxvYWRfd29yayB3YXMgaW5pdGlhbGl6ZWQgdHdpY2Uu
CgpGaXhlczogOTk4NzkxMjFiZmJiICgic3RhZ2luZzogd2Z4OiBmaXggdGhlIGNhY2hlIG9mIHJh
dGUgcG9saWNpZXMgb24gaW50ZXJmYWNlIHJlc2V0IikKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93Zngvc3RhLmMgfCAxIC0KIDEgZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKaW5kZXggNjdlYjRhNmUxNzZiLi43NGVjMGI2MDQwODUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNzgy
LDcgKzc4Miw2IEBAIGludCB3ZnhfYWRkX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKIAlpbml0X2NvbXBsZXRpb24oJnd2aWYtPnNj
YW5fY29tcGxldGUpOwogCUlOSVRfV09SSygmd3ZpZi0+c2Nhbl93b3JrLCB3ZnhfaHdfc2Nhbl93
b3JrKTsKIAotCUlOSVRfV09SSygmd3ZpZi0+dHhfcG9saWN5X3VwbG9hZF93b3JrLCB3ZnhfdHhf
cG9saWN5X3VwbG9hZF93b3JrKTsKIAltdXRleF91bmxvY2soJndkZXYtPmNvbmZfbXV0ZXgpOwog
CiAJaGlmX3NldF9tYWNhZGRyKHd2aWYsIHZpZi0+YWRkcik7Ci0tIAoyLjI2LjEKCg==
