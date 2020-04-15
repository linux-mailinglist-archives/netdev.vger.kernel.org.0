Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637FD1AAD93
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415458AbgDOQP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:15:27 -0400
Received: from mail-bn7nam10on2054.outbound.protection.outlook.com ([40.107.92.54]:6037
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410244AbgDOQMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:12:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqDm9owojMYMX/hrwgy1cVgcCMS/sSUvFuqP4b0TW4NeJnH4N0at0GfOYBYd6PMpiUQemeU13+3crqOQ0svIRRj+rqmj1xBJT6pkTW2tLcCul/UtAxOIIf9atIRe6MouPx7x0hyWN9tb5VKeksGUrvYUu663vVhBsT0j/w5urNdUeFvBqdFfADlW8Rn89gFTKZ1Y40NVTZK+hOlmQanS9iXTIyID7Zz4XTsRuHXgQeh0v5G7mnKoU3N7smv4i2s97EyMo3kbwF6kAnLjrczcFGjs7Fm5mK/8wnI2Tgd7ju2PRJc/LCnejn2zNwdjOsdC5vcZLxAt6RAe7hDq2neD6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nxtLj7G7XHMe7btmeHWLVBb66C5a5GyMZEEY3gGfKc=;
 b=mH6HMefeS1tOTD2aSLSd1fkGnbhp0Gvd72kskPwOUF/DPq+FQVo+g8oii6AugniOXJnbWfbUlv0G/36lgmGAkb1uSCaMny1/ROzKKQi6Rtdw623nJbF2O29mBzp+0bS2b0txEgAoD+pRVPa1ujCbWvXOWv87V6HhZ9jVMHeJM8HOves4gXIw3E6cNyW0pO5uBQYooijOtQaPSdauxOo29p9dXy6r338GJ0r67pOjoffZZ+O6wzbXAeG9fpccTre5d09EIT2Vzx6QGomWL3lZqZZsrLPtyWLekhNJUriZ3b/v3os4D1MloGmUoCbbpdaIYuKEItNLLlK0MlRFkOWJlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nxtLj7G7XHMe7btmeHWLVBb66C5a5GyMZEEY3gGfKc=;
 b=Okii4WV7JRTVtHBhesSpJe8YDH8sID9P2F+3mt9RDb1POYzxjPcBV2tSWOh9C5rqglphQEJbLz89SRwhBwN0AG/0XMzThbNpSb6qyNogdZEpMQFlYeLRrdAVwNJP6VkRzOWgQDqCXZd94MeZr+waN/WBz201VYPkdPvP7god4ls=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1599.namprd11.prod.outlook.com (2603:10b6:301:e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Wed, 15 Apr
 2020 16:12:37 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:12:37 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/20] staging: wfx: ensure that probe requests are filtered when AP
Date:   Wed, 15 Apr 2020 18:11:37 +0200
Message-Id: <20200415161147.69738-11-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
References: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::40) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:35 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e33c508f-29e6-44ae-d460-08d7e157d0b4
X-MS-TrafficTypeDiagnostic: MWHPR11MB1599:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB15997D7BD00AF9FA468E84DB93DB0@MWHPR11MB1599.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(376002)(396003)(346002)(366004)(39850400004)(136003)(4326008)(66476007)(107886003)(81156014)(86362001)(8936002)(2616005)(6512007)(6486002)(316002)(52116002)(66556008)(66946007)(6506007)(8886007)(2906002)(1076003)(36756003)(66574012)(5660300002)(54906003)(478600001)(16526019)(8676002)(186003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B/cicagr4l+JnqMyR1SA353fr7oCh+XlYbeD/hRppwtTjt2jEjpUpMwLK6i1zsBWLON/sJS0s0HNyuYXsjCFxJSFa3qIcBg9hxvkBRs2Dl7uX4DalitJGUualO9oHLtCkJTDDJGsMTPP8KWnPNaSF3d+5cVGzhtvFjvy2jTmpkNBO+I8SfkDz7aFuHWrB+z/goZcmlspDQ+PP5/z6E5zAWirXDfELbExW+YpbAks7FCDyAyC49PfR9+qe8FzvTjT6kgEuZfAaSyQbfnsjooQiaTWJlqSW0E2F/xk+U5Ja4m8wWjvFncr9rKI1NOb88zCPJ9vEAeKcMadOV7ODsumeDrCkor2JHPLoAQXkudiM8JQ3fGdMr1hZYsLZLC/2kXbc2bzrzGpSs3JYyaRGiT5/WcCsB7x0UjkzEVXac/DqkWTxJXLkkE3h9c8RaHrNkmL
X-MS-Exchange-AntiSpam-MessageData: /73MTPv8s1zrdRgheHZ8ScoJ0oZxze/PFaHSe7Vuu9k9Xj/MCC8QEj2BLuQvEPJe8RFB4vq27b1s+t702GpNtpsIEmNN+7rLfQXAEk9cGjLS9cYw5ZnOg7gSc/H7Y96H3cOSWhxb7Kb703B9tUyItbVsfq5sSewaOOsOldTX/fUvz7Mn66T0tdJD/8w+tdSE7oJQUwmP9E9vH91CWjKPqA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e33c508f-29e6-44ae-d460-08d7e157d0b4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:12:37.7110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8D7tuwZ9TNJugDx5tNPj/mqnH1E7w4KUOsoLQ1e/AzbX0BsAUoYJ5wjjGTV8+qpVxWuSrjv3L6gvd4x3/NzuYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1599
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRGV2
aWNlIGlzIGFibGUgdG8gYXV0b21hdGljYWxseSByZXBseSB0byBwcm9iZSByZXF1ZXN0ICh0aGVy
ZWZvcmUsIHRoZQpwcm9iZSByZXF1ZXN0cyBhcmUgbm90IGZvcndhcmRlZCB0byBob3N0KS4gVGhp
cyBmZWF0dXJlIGlzIGVuYWJsZWQgYnkKd2Z4X3N0YXJ0X2FwKCkuIEhvd2V2ZXIsIGZ1cnRoZXIg
Y2FsbHMgdG8gd2Z4X2NvbmZpZ3VyZV9maWx0ZXIoKSBjYW4KZGlzYWJsZSBpdC4KClNvLCByZWxv
Y2F0ZSB0aGUgaGFuZGxpbmcgb2YgcHJvYmUgcmVxdWVzdCBmaWx0ZXJpbmcgaW4Kd2Z4X2NvbmZp
Z3VyZV9maWx0ZXIoKS4KCk5vdGUgdGhhdCB3ZnhfY29uZmlndXJlX2ZpbHRlcigpIGlzIGFsd2F5
cyBjYWxsZWQgYnkgbWFjODAyMTEgd2hlbiBhbiBBUApzdGFydC4KClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jIHwgOCArKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDBiMmVmMmQzMDIzYi4uYjc4
NWIxYjdkNTgzIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTI0MSw2ICsyNDEsMTMgQEAgdm9pZCB3ZnhfY29u
ZmlndXJlX2ZpbHRlcihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJZWxzZQogCQkJd3ZpZi0+
ZmlsdGVyX2Jzc2lkID0gdHJ1ZTsKIAorCQkvLyBJbiBBUCBtb2RlLCBjaGlwIGNhbiByZXBseSB0
byBwcm9iZSByZXF1ZXN0IGl0c2VsZgorCQlpZiAoKnRvdGFsX2ZsYWdzICYgRklGX1BST0JFX1JF
USAmJgorCQkgICAgd3ZpZi0+dmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX0FQKSB7CisJCQlk
ZXZfZGJnKHdkZXYtPmRldiwgImRvIG5vdCBmb3J3YXJkIHByb2JlIHJlcXVlc3QgaW4gQVAgbW9k
ZVxuIik7CisJCQkqdG90YWxfZmxhZ3MgJj0gfkZJRl9QUk9CRV9SRVE7CisJCX0KKwogCQlpZiAo
KnRvdGFsX2ZsYWdzICYgRklGX1BST0JFX1JFUSkKIAkJCXdmeF9md2RfcHJvYmVfcmVxKHd2aWYs
IHRydWUpOwogCQllbHNlCkBAIC01NzcsNyArNTg0LDYgQEAgaW50IHdmeF9zdGFydF9hcChzdHJ1
Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKIAl3dmlmLT5z
dGF0ZSA9IFdGWF9TVEFURV9BUDsKIAl3ZnhfdXBkYXRlX2ZpbHRlcmluZyh3dmlmKTsKIAl3Znhf
dXBsb2FkX2FwX3RlbXBsYXRlcyh3dmlmKTsKLQl3ZnhfZndkX3Byb2JlX3JlcSh3dmlmLCBmYWxz
ZSk7CiAJaGlmX3N0YXJ0KHd2aWYsICZ2aWYtPmJzc19jb25mLCB3dmlmLT5jaGFubmVsKTsKIAly
ZXR1cm4gMDsKIH0KLS0gCjIuMjUuMQoK
