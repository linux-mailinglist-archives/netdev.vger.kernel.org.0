Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B0E1A46F7
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgDJNdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:33:24 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:32790
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726817AbgDJNdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e45X+I9InV3K9ZuJIfuvX/0mMTQWB+TjJvFL/IHIopXjS/zykl+/mw+7OL6Y30k2czlSNQTNOcbkw8bWNLF/BqmtTCEQ5LfcMzb2c1NNYIiQVEBHwSmgGyGCyx1DqUzAnjr9hnZBoJbNls2L18pSvDFRPnyBJyhJSPQuculWkX2g2tnKBWthN+Ato76fBecW6zB0PE6SpyAWGKmkITcN9lRyQ2rDHTrJrWON6qEIDjjTQbSgj5hvfoCae2tY+OGsYZeYTMcKprtVsIpse527uPWJ7sr63vuqt+m1v83hRjvSNwkenpvfU7G5rAy6dJdUyKjYxkl7/NxWoqKcsliblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJTAQ/VR5u4yLmSor5pc09/mMk/uKUBfJs00iVDEZYw=;
 b=IKOS5hlWwc5/Yn/xEFqAQG4dcFZIwrC+P5G5tkS3Y6DSx0GcFs/+EWU0xG83DZ+gb1T+6M5VgeSdVlzf2WdgA1F0smtDN449050y0nVKR9IBKQsaPAWCWI4jZrdE7+oz/BWKcNBR6hRZVUT11fl/MuZxDhBP2y4Q4YehlhW8LqIsPBWo3Wqz6MphsgHnwfCXyzB1SSrNY7u10BC2sgEDA5UnfVv5KkqcdfNTc8T8P87f+vhsbDEY516M3FjCv59yQww5bte1e/GeEvEL35+qOFQfgC2a3mvoc6DRkO+scJLPzQMXjDCYy5xwezMzYg6B+QnsPqrXNF0uHLsWpknMCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJTAQ/VR5u4yLmSor5pc09/mMk/uKUBfJs00iVDEZYw=;
 b=NYUfbvJef0Z7+J4XiTcfkWk/vXtlqXdG1VL+7azzWte3hWew+J40n7Ei7S2CExnFjsOtZFPkCreM7D8MBctrl8X59chFQg0HxKGcPy/I7NgbrC4gwBKH/Z22nnFpt7Me4Q/hojvvATyL6FaqFAYRaxMf0ZSAVTm4AqxoYIg9hTo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4333.namprd11.prod.outlook.com (2603:10b6:208:195::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Fri, 10 Apr
 2020 13:33:16 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:16 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 09/19] staging: wfx: disabling keep alive during unjoin is useless
Date:   Fri, 10 Apr 2020 15:32:29 +0200
Message-Id: <20200410133239.438347-10-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:14 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55584d7a-ddd4-4589-c2ab-08d7dd53b966
X-MS-TrafficTypeDiagnostic: MN2PR11MB4333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB433391ABA4AEFB1348204FB993DE0@MN2PR11MB4333.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:193;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(346002)(376002)(136003)(366004)(39850400004)(396003)(2616005)(107886003)(86362001)(316002)(4326008)(8676002)(81156014)(36756003)(52116002)(7696005)(8936002)(478600001)(6486002)(2906002)(66946007)(186003)(66556008)(16526019)(66574012)(5660300002)(1076003)(66476007)(6666004)(4744005)(54906003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ru0fzvK4rAAZVCuCbCQKxWwz55m99BoQrYzUgxNrMKurKKbQKb/R0W/XwesI0pwcyDSojprxEi5TeGj85GU+EtB2PZBTnRtvKpdOXLVPSeexVaBOfFY/HaQeVo3K9BrEugv6FkpNmx8OvjD/xzz49nvTA0MCtFIkCqgvIo/pXnsnjElF7PFPTGvhQQ6v1tdWIOz4JcqJKI7KlsJv0U9CEnHRqaF5wfpTYCNb/IOrGLQPBe0qd3J31BCAo9CyBVmSUkPGRgYpU5dgTqSMtLAeUQfANzEA3dLWtv0DD+LQKleoAVBiwUocHpHBE+cguiWHY8zLtTZtWbwJHmAmIV663NObgyKuNe2Tdg3HMLNdjWMCaiV/vYtaFnNikaVLE0023WAFy7uGGdWt8UFxm/AFk+0OjSdd0F+DF/NsTVvskPZy0ZXUp98GVwnOGHEriyN7
X-MS-Exchange-AntiSpam-MessageData: TKVmW8jLIsHP69lcPzZswanDuQ01Pzvg4O6kXtZJFdig8vPH+TVeCSEhgJF1QhH7vkCsENRz6sqpbVb4bM+2NwhZdd8iY9S+xb7KVFSq6TTZelqZWOz3BsAvvwQ8AS2At2zGXGmiyZZ1RdbcEfx7o0akvqUTAbofBPPfhw19NMN2DMXeGg3467hfrWsUoIDNhxy8+fgv6ngB3uH9t5pY0w==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55584d7a-ddd4-4589-c2ab-08d7dd53b966
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:16.1636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tVs4MvFhCBEjN9vu1XjeETFAh+VWY6Uab1RmmaeNlRWxEu8H1wC13BaP+luZiZyAOwE+YmEeQp8sB3T/U5bVbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQWZ0
ZXIgYSBjYWxsIHRvIGhpZl9yZXNldCgpLCB0aGUgcGFyYW1ldGVycyBhc3NvY2lhdGVkIHdpdGgg
QlNTIGFyZQpyZXNldC4gU28sIGl0IHVzZWxlc3MgdG8gZXhwbGljaXRseSByZXNldCB0aGUga2Vl
cCBhbGl2ZSBwZXJpb2QuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21l
LnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDEg
LQogMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCA2N2UxNmM0
MzU4NDguLmIwNTU3ZGFiOTFmZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEu
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC00MTMsNyArNDEzLDYgQEAgc3Rh
dGljIHZvaWQgd2Z4X2RvX3Vuam9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAogCS8qIFVuam9p
biBpcyBhIHJlc2V0LiAqLwogCXdmeF90eF9sb2NrX2ZsdXNoKHd2aWYtPndkZXYpOwotCWhpZl9r
ZWVwX2FsaXZlX3BlcmlvZCh3dmlmLCAwKTsKIAloaWZfcmVzZXQod3ZpZiwgZmFsc2UpOwogCXdm
eF90eF9wb2xpY3lfaW5pdCh3dmlmKTsKIAloaWZfc2V0X21hY2FkZHIod3ZpZiwgd3ZpZi0+dmlm
LT5hZGRyKTsKLS0gCjIuMjUuMQoK
