Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084171A46F2
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgDJNeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:34:22 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:6130
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726864AbgDJNdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpsdjyomrqNf/9TneYJ76lIQb8DwiXodNKov/orvvnn67tVH2Ro6jmf/BsMSaEvsWm1USTj1yKWu5S2gajf5OfDvAiw625gDN1jDMcmzf7ipBGR+nRpOUi/SJL4oI9fd865sz+GbQqoiTlgcoc2Bp9VASrqJ7EfZHQZkP9biM1BfAZ2XsHWmOqDkCeAf7OGAkTJCK7Bi0u0WH7lxKYXOFxHNiB3mbcyFfR4zmAm811G4Q71oCbwH2zIpYJLoxTENPYvvJ2vaA0M0m/H1cSsgYgguLGtxEL2hlEczuzKI8uEfmdao1EuhG5Yt9bKTHtRLpY47b5N7j46q+Y0uz4UZig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ve+8SIp3rtlHm7bPzlyH7FGbTwMhSVUoT+6DV6jEyM=;
 b=ejfwABO2HUFoK/3JTPXVZps0gLTqAsGSXpe0HG12arsI0l6XA9goDSc/yLudZHf+Au8QEdO75MioFLJSklzSg/OXu+M91blucHmdH+OD+5z3mFYYjm353NK1KWeLY1bDJynoiBy80jxlKA2PQugkYolTfuJQ/kQ1wDJv1ZqW+jMtkJfCtMWKy6mf5eNJQARX0f9kZaExLkzsiCz6DLl+W2iTnPAJ5XK4TZKLFUBVSATtTMAqeBW4MFk/xWwW33csBWx94xRdb64H+QkSs7XMBvGFvJabF6nxb59AJC/oW21Tzy6eMQKMYwC2MdW5GIVgLmb14fgIe090kA0PbGAxQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ve+8SIp3rtlHm7bPzlyH7FGbTwMhSVUoT+6DV6jEyM=;
 b=kobS98tKyDzRSWn41BYYnuOE8/UiayB2dM5Oz1m/OFuqOWKNN9kWB5/1h6Tqg0wokIb78cgMmWc5l/XVXkKKbA7/aPjUfp7h9HX4bUhJ1U08yxGU/CNS4cP0UPBqqqCP9HvMit4ZG31/lmmVA4opiCBFfbeHGaP1aT8tZvFkQ/8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:23 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:23 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 13/19] staging: wfx: avoid duplicate updating of beacon template
Date:   Fri, 10 Apr 2020 15:32:33 +0200
Message-Id: <20200410133239.438347-14-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:22 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8143d64-7beb-4f31-a322-08d7dd53bde9
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB439843669924671DE300895A93DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(6666004)(8936002)(4326008)(52116002)(66574012)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7FoVybUYhEXzDTb06r6lBdYNwzFL4VyZ+euwYd+f2yxz7KIc99idJ9/OGOXUQcAYKgeCj88OOxRoQhljSXc6l/z27VVGKFroMrh3ttn84BTTY274ZfMFNuDqT8/N80zClbOwraUslXq8f4hKqMmTw2Mle3JJozdhk6HWmwmWeYg4V09UrFXVaFh/TP9eQIt/NmhlYa0TAHxi8sc5LJJ9LBLgvGP5hPl8G9FBWfv0Hiq8U98e93EPjM2aY2gjPuhGS+6FE7I/OR0aFu7HSg+LAJZfVxCYbWYSLCK8AjGBiSczz/wdz9mWfAdPLtfd4nR5VUl6i0gL84J0l6cySxm4shYVcok2nIthQ6UY+VAF3IgeRK+X45z5rkFUBmNM4RNUSs0SYyt0Tt+97r5fe1rOM6A1tBC9WwKZXSf9NISmh/SMPiaRoFquQ6XWxnGusgDe
X-MS-Exchange-AntiSpam-MessageData: 2pOL9djZlemsc473Ssf0n6TLFxaTWhJX+xgeR/UrqU3EUmMF/LOk8dHbETO3ZF3uXlVUhdvQDdDIyV6pLPKcgF2M37NvL3t4jdGv3ViT+Yy3VwE7+JE5ypd9SVAq75uxO2d9drE7Gg33LhRdv2b8VaOQFMIYEKrvNR9CQexaQmU9BtQcu0SX0RUDo3oFcv4CraiGZ0e9dKHU1Cf6crFPeQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8143d64-7beb-4f31-a322-08d7dd53bde9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:23.7422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QcOdWAJJvbgO9nPjv9ziPXFIDsMmY7BjJFg0Gbb5BP1avBgEtDmAxr+hdWTBmOgofHMQJdtaexGaNIskJtbuBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBFUlAgY2hhbmdlcywgbWFjODAyMTEgY2FsbCB3ZnhfYnNzX2luZm9fY2hhbmdlZCgpIHdpdGgK
QlNTX0NIQU5HRURfRVJQXyogYW5kIHdpdGggQlNTX0NIQU5HRURfQkVBQ09OLgoKVGhlIGRyaXZl
ciBhbHJlYWR5IHVwZGF0ZSBiZWFjb24gdGVtcGxhdGUgYmVjYXVzZSBvZgpCU1NfQ0hBTkdFRF9C
RUFDT04uIEl0IGlzIG5vdCBuZWNlc3NhcnkgdG8gYWxzbyB1cGRhdGUgYmVhY29uIHRlbXBsYXRl
CmJlY2F1c2Ugb2YgQlNTX0NIQU5HRURfRVJQXyouCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQ
b3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYyB8IDEyICstLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCAxMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCAxMWQ2MmRlNTMxZTcuLjc1ZjFj
NTE1NzUxYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC03MjUsMTggKzcyNSw4IEBAIHZvaWQgd2Z4X2Jzc19p
bmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCiAJCWhpZl9rZWVwX2FsaXZlX3Bl
cmlvZCh3dmlmLCBpbmZvLT5tYXhfaWRsZV9wZXJpb2QgKgogCQkJCQkgICAgVVNFQ19QRVJfVFUg
LyBVU0VDX1BFUl9NU0VDKTsKIAotCWlmIChjaGFuZ2VkICYgQlNTX0NIQU5HRURfRVJQX0NUU19Q
Uk9UIHx8Ci0JICAgIGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9FUlBfUFJFQU1CTEUpIHsKLQkJdTgg
ZXJwX2llWzNdID0geyBXTEFOX0VJRF9FUlBfSU5GTywgMSwgMCB9OwotCisJaWYgKGNoYW5nZWQg
JiBCU1NfQ0hBTkdFRF9FUlBfQ1RTX1BST1QpCiAJCWhpZl9lcnBfdXNlX3Byb3RlY3Rpb24od3Zp
ZiwgaW5mby0+dXNlX2N0c19wcm90KTsKLQkJaWYgKGluZm8tPnVzZV9jdHNfcHJvdCkKLQkJCWVy
cF9pZVsyXSB8PSBXTEFOX0VSUF9VU0VfUFJPVEVDVElPTjsKLQkJaWYgKGluZm8tPnVzZV9zaG9y
dF9wcmVhbWJsZSkKLQkJCWVycF9pZVsyXSB8PSBXTEFOX0VSUF9CQVJLRVJfUFJFQU1CTEU7Ci0J
CWlmICh3dmlmLT52aWYtPnR5cGUgIT0gTkw4MDIxMV9JRlRZUEVfU1RBVElPTikKLQkJCWhpZl91
cGRhdGVfaWVfYmVhY29uKHd2aWYsIGVycF9pZSwgc2l6ZW9mKGVycF9pZSkpOwotCX0KIAogCWlm
IChjaGFuZ2VkICYgQlNTX0NIQU5HRURfRVJQX1NMT1QpCiAJCWhpZl9zbG90X3RpbWUod3ZpZiwg
aW5mby0+dXNlX3Nob3J0X3Nsb3QgPyA5IDogMjApOwotLSAKMi4yNS4xCgo=
