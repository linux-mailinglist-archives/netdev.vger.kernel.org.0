Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 416BA17F4CA
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgCJKOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:14:38 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:6032
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726497AbgCJKOT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 06:14:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIv1cIVskUl5DYxYG/LzDl4b86A7G45dxJ09rYOI4cYnfwHkLEbTBf3RrYz9XURKFENCP8EEhV3mPkaJlpImveorDr1MXjpo05oYIdlc8ZrOlrM8kCKbwKbA5WCWkHImfQtVJIvcleIB8jpFkCElsXOdT55J6FCGDEVA4TeP0WYq72m3zhVwPtVvnAlvPoA1KN3PxYSZbxyGU5LMs/QTLWYH9xR/q5uJ2FKtZZL+wAQ+Ye7bVP74PTyX9mLF8n7KbFzEPxAwpjlXchtdbq9+bfh7jAvI8USyMashjGpeg/1vY6L9XW64mR43k2IauM6szygbFAoEf05xwQ9uxSICqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEiXM4RgjoTsKZD+k+9ZSFAwwt/P0IZUfRj6U2E6o4Q=;
 b=iw+4VWjeec9jhdJk2oFQvpyHF9T/3P5tnEE6f2Jv9ugG57PCyKQNQq7D+cgDmmEFGM6aIy4K4ksjOAyUFKeR/g7z2+IqMc1LM2jpokS3qKLZUZHe2xU5I8ZPZqgqSG6e6vak9nEvpCo8LcWuoOluJ3lRGlnCniO6ISe4XfyIg7Qnr/SQtg1/qvT9hJY2GtIvGjPTP5fwNLvc9DfZCGH3/a/8VZyvQhTxvKeDSk+BMeJfSvgh5Y5x2tJ/gozQyP/Jav6G1KbtFTc8v3y11dV/penJqXzTfk7RVvVyDtVS8nnGWtYGSAgrkqkvzDQDef2p0YSdlYx5pkDO2QAuNsbymA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEiXM4RgjoTsKZD+k+9ZSFAwwt/P0IZUfRj6U2E6o4Q=;
 b=ThuVeOkPrJkbwdU8uIM+QqI0gWXA/zlyHAGO7RfvhbuaCJxhi+t0kH+kHAUkFcgsHmM6LcuAk2yxwWyTzWjAJ9PxbU4Gz6HeizLAxG4laLvfMgn324AKQ3l0wf67qehT+KbaBVCxQy7lu0BzLA2HpI7WhrCnJ47Kobn9THSxHiY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB3615.namprd11.prod.outlook.com (2603:10b6:208:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 10:14:17 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 10:14:17 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 3/5] staging: wfx: make warning about pending frame less scary
Date:   Tue, 10 Mar 2020 11:13:54 +0100
Message-Id: <20200310101356.182818-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310101356.182818-1-Jerome.Pouiller@silabs.com>
References: <20200310101356.182818-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0180.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::24) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0180.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Tue, 10 Mar 2020 10:14:16 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fd79580-3387-410e-0c68-08d7c4dbcabb
X-MS-TrafficTypeDiagnostic: MN2PR11MB3615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB3615337894BE9881A890B1B993FF0@MN2PR11MB3615.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(39850400004)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(6666004)(52116002)(5660300002)(2616005)(86362001)(316002)(956004)(36756003)(478600001)(4744005)(7696005)(8936002)(54906003)(4326008)(16526019)(186003)(26005)(6486002)(66574012)(66946007)(8676002)(1076003)(81166006)(2906002)(66476007)(81156014)(66556008)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3615;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rkrRkcAE+o1/t7wJPMHUS7dEDLjhzZxE4cjOdQGIxm8BEbA2odgf5BXeSM2gb5fiebY87NA4dW0JPuGe4REiPQ/0bG3cA0svvKMJsE1+R3C0SGigefTx2uPJeP0++FaFYAC+kedybAEU8cVIV1pU3jK39f9xZBJKz2cQpNk1InV9mtcJYtWx4VU25vlZvHoZ3lxnKu7h0sClOqLpG9NnIFbKP7u42Yc+QggrU7ko7C3thn2UsSua5VbrbF6+vtoN7VD21rob7qRTScnmn0NYWmyboywEg2JspY3vhzzYKgwBDugxJdIqdmrYcBClCAJt7w4zrrfUJy2t73A3JjokHRF1vlMsWmsJtW1SQq/6zSbzzWj9TSUXAvlw1syuiVAgwujwzfw0EwIG+5EfvaHX7EaGFaW5IW6QL6DA7JBUAj5pViTMi9gPdqqBo6wXhTlg
X-MS-Exchange-AntiSpam-MessageData: vaYwbJg5rtL4XC+c0NXlDy+ulAubxhvYgZIbBfFkOPqU6DLpupEum58zwjBVhztFCOhDIyscgYPDtz4/oTXBf1jEPGD3CUgnrf5J0xSsz0Qwvmoe0AUsRTVfQ+ANsariWoPwIjresVLlPeN0FOYi4w==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd79580-3387-410e-0c68-08d7c4dbcabb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 10:14:17.6911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1TwqlqUI6I3J5hj1rqnvAY1chTiIVVgpBtc3F7+woAQzAHUbFMJ3629gYxK/9HnF4PRSsd+RoCVvnFdjkbSouw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3615
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKUmVt
b3Zpbmcgc3RhdGlvbiB3aGlsZSBzb21lIHRyYWZmaWMgaXMgaW4gcHJvZ3Jlc3MgbWF5IGhhcHBl
bi4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgNCArKystCiAxIGZpbGUg
Y2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXgg
MDNkMGYyMjRmZmRiLi4wMTBlMTNiY2QzM2UgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNjA1LDcgKzYwNSw5
IEBAIGludCB3Znhfc3RhX3JlbW92ZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGll
ZWU4MDIxMV92aWYgKnZpZiwKIAlpbnQgaTsKIAogCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpF
KHN0YV9wcml2LT5idWZmZXJlZCk7IGkrKykKLQkJV0FSTihzdGFfcHJpdi0+YnVmZmVyZWRbaV0s
ICJyZWxlYXNlIHN0YXRpb24gd2hpbGUgVHggaXMgaW4gcHJvZ3Jlc3MiKTsKKwkJaWYgKHN0YV9w
cml2LT5idWZmZXJlZFtpXSkKKwkJCWRldl93YXJuKHd2aWYtPndkZXYtPmRldiwgInJlbGVhc2Ug
c3RhdGlvbiB3aGlsZSAlZCBwZW5kaW5nIGZyYW1lIG9uIHF1ZXVlICVkIiwKKwkJCQkgc3RhX3By
aXYtPmJ1ZmZlcmVkW2ldLCBpKTsKIAkvLyBGSVhNRTogc2VlIG5vdGUgaW4gd2Z4X3N0YV9hZGQo
KQogCWlmICh2aWYtPnR5cGUgPT0gTkw4MDIxMV9JRlRZUEVfU1RBVElPTikKIAkJcmV0dXJuIDA7
Ci0tIAoyLjI1LjEKCg==
