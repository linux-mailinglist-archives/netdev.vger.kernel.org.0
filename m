Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39CD1D488E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgEOIfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:35:06 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:55808
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728228AbgEOIef (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnEn4tixU6LOQm12taaP5og8Gd2KywT+YMfDnDkgheVmgeMIzZ3Yin9pu+A4no4Dwqqn8EZv0RFpOVDbiu9IJYFJyZsqEmojv0cmBsY6+AWQSdofv03KqfSva0mui6Kd+KIJQBjThSNgc761mbe51oEcYx9tVbec2JLqbDr6RJpGr/mENCBnhQTNqNc1emyNwfoQzAFapZGXo+6n/9WIW9NkVeN3rO6gGLApCF5tggBNkErXOCVfdJ74exkVCMu7+n7jDzicxahMqAgXrEzL4wHL/3Q3WDgDpJf3cfH14RTLsODGvD/EFYoj+IDiSQbEaxKteDsXRzM6A0ph++uesg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVglrQBMcn5CVD2oVPoZt0gdUgvFIsqHwfENBGeuAzc=;
 b=il0hMxhdqz+/C+EUBQ9AcC9CpdGxXEpjz9JzSz9fSeIHEbNqpUw+//15xdlzRZazj8f8OFmRr5qfzJbxwEVWLNwYEGygTx5ka3ooxpyk5cof90RUyJFSgT6uZBvAVCa8LLWk30x+8sUtVhpl181nVCyooJxqblmivVYaxjwuWVHw9t32gGBmYNKq1W47C8TYl9hxIxk3uRmlfr+tQn4k7Owyz9pG9cAQiG4WmC34Pb7Ryry/BNbnXDJNsW51WsljymVLelvxYuVa8lGSFK/fuFTiGKPZG2cCKAq6qmzdJTVatTLI9l+5LpYZIxaH3g2A8+l7sOVXPCRdvEhSxjiTWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVglrQBMcn5CVD2oVPoZt0gdUgvFIsqHwfENBGeuAzc=;
 b=awcPbuAqIsnY00IRfjdH6dGtw9wN7op0y/PSs6ucIxxtWmnAv5mI6GSyp1RSoz1UVtdSVQfyGrYrQPiodzHNbF6Dd+zdxbNrK1F+JfE7CEei1F1y3eLELy0gAxvCfdO+No87/GsY6uDH4SlXZGYrkcqSk+pkCwnaDGIGPABNhWw=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:34:19 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:34:19 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 16/19] staging: wfx: fix error reporting in wfx_start_ap()
Date:   Fri, 15 May 2020 10:33:22 +0200
Message-Id: <20200515083325.378539-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::16) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:34:17 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2805e4a3-5ba9-4cd8-be75-08d7f8aac287
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB13109E6391B5DC8ED2C4718593BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AAtSl099U5bDI+oaiW7XLEmXv/tYwUE8ugWsCVKul5gBx4R4BizgLW8BBWq2tqckJpxHoy/Ogw/PcnrYK95bJO+mJiVsuZL9h6c3Zo/5O5kJj7hgWpJpkAQ2VhEKLwfbTWpRaqBrYx+Ycu5LB5eTkX290wQpSh752TnbD9z0KyO7KHaCfHxwok+Vwt6EFUk36Lf6KyG9OlROGGMSwTzyOno6heOLlAP+hRoHzaya+ulYtosv5Et3L+q5RnfWdXXknG+yYYgMWFty9efJsrfy1gk2lQU5+qAEg6i2TagL7x4+l7MEDyb1degh3r8RgUh/um14ERHw2dAwQvULBW4pQuqxxdbqKbcUFECkju02sXVLZnxdvEEF9bFvfHtrbRVxR70h2qfZBsiGxNoQoRls+4WfZffvMlpspqDlJSrVjhxq7bJMH5iuSO2vyxkRxIHH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(6666004)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XERyiG8hFXmo9nZupYJ5EAxogx4V9G08ItaaKB526O+9YTwmCDwP9QHrKphKXoDH6QjA5mIP5Pk3y5JTG23Yz6ziY5U+w2JwwIfmZIJng99IFLEunJY6duVoC8sodqfO/XU7h/7zXIHPQnbDGv47rLhyRmWjlggdhqZLnmBnbqh9odsALk0w78/aW/oqRHgNzpj8OJQwHgiSQVZF8OkFQZBzIEFHFeh7L3Y+V8LJvvHYoegTod/1gGy/nZU1t5r4AyF6YAmOugc14xp+ddkhKmmhMD0dRQhM+TeUGI9htB4uYQZ/s0FdwaPyGCLS1Fcgq1iUs59+kyMxF9p3BVuIXLeZFARWLFKBPXMt1T92Dq1+dmsGYkjLTj6JF0izCRyuH6m3z56pKvMojReuFUQWreiHgFQFE7gVtI3kRLm2OWDX5TRAFfNEHP1ItGAJvobTVlJegg4b+JFNsUNs5YPBrRz63aAVj1H66ILDoVhuZAk=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2805e4a3-5ba9-4cd8-be75-08d7f8aac287
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:34:18.9538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kS1UPXo0ARnujlP4ltLAlhdCrZwI5X0c808F7kyECLlJqwESMG7P3Wm+egAly6Z9EFF/FZo/e1Jts6HdTDlx6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSWYg
QVAgZGlkIG5vdCBzdGFydCwgdGhlIGVycm9yIHdhcyBub3QgcmVwb3J0ZWQgdG8gbWFjODAyMTEu
CgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFi
cy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDcgKysrKystLQogMSBmaWxl
IGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRl
eCA1NzMwNGVkNDJlNzkuLmY0NDg5NTdjMWE5MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC00NzYsMTQgKzQ3
NiwxNyBAQCBpbnQgd2Z4X3N0YXJ0X2FwKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3Qg
aWVlZTgwMjExX3ZpZiAqdmlmKQogewogCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gKHN0cnVjdCB3
ZnhfdmlmICopdmlmLT5kcnZfcHJpdjsKIAlzdHJ1Y3Qgd2Z4X2RldiAqd2RldiA9IHd2aWYtPndk
ZXY7CisJaW50IHJldDsKIAogCXd2aWYgPSAgTlVMTDsKIAl3aGlsZSAoKHd2aWYgPSB3dmlmX2l0
ZXJhdGUod2Rldiwgd3ZpZikpICE9IE5VTEwpCiAJCXdmeF91cGRhdGVfcG0od3ZpZik7CiAJd3Zp
ZiA9IChzdHJ1Y3Qgd2Z4X3ZpZiAqKXZpZi0+ZHJ2X3ByaXY7CiAJd2Z4X3VwbG9hZF9hcF90ZW1w
bGF0ZXMod3ZpZik7Ci0JaGlmX3N0YXJ0KHd2aWYsICZ2aWYtPmJzc19jb25mLCB3dmlmLT5jaGFu
bmVsKTsKLQlyZXR1cm4gMDsKKwlyZXQgPSBoaWZfc3RhcnQod3ZpZiwgJnZpZi0+YnNzX2NvbmYs
IHd2aWYtPmNoYW5uZWwpOworCWlmIChyZXQgPiAwKQorCQlyZXR1cm4gLUVJTzsKKwlyZXR1cm4g
cmV0OwogfQogCiB2b2lkIHdmeF9zdG9wX2FwKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1
Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQotLSAKMi4yNi4yCgo=
