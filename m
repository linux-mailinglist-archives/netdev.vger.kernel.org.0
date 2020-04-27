Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A941BA531
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgD0NlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:41:15 -0400
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:54528
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728023AbgD0NlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLi1NTJC+bmMOYJr7jR7cgCFcQz7un5Gad0NypAJilKHN0+RrPFKpmfUULW/w2YcLpUswWk2jkRwFl1wSj1ODbTEAdHxYVIOQPMFUkT9QvcnM8rlVi/nVmRrBcE79BkQYHwZOc1JZmuDWIkv1pDxKGvl7ITNPc48wQB5PBjzWeXZmp0QbrqkAKZ2vAGkjfXd6zQu/LQ63N65ZVAaA9JsKgK5XrtAFP3+3HkbUT5/j03aq7+uCQkJ32wKi43yd/UCCxKZu479FXMFmFLdaWY+0xZwlPf+pVivJzz00ulsiTSDc1Kewd92AJAjb7IzuzaWduRqmXcdAEaMXISn8QrXXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwN1CSqxAkNpNx9GcjrtNvXNAKQ0nmOQLgVi1ERHmhs=;
 b=R4bLtpt6+ivDpYySnwOOJWicerD86s4bqrfSmJdWSg2mNE1bJlc8Pkg7pReQqykC234p/YF5YBPWX4kMRQ5bM5+CgeMh1k2qhryraVMHUAgRRPwXgt4i7FPTK2rUHjO7Z/8RMJJA/YXgFTHiRFt9xLXje5p99P70oYZyjJS0RDXdhgyunZIhhklw7k6rKIMdIgh2F5MVHszxu2v4by9fHL219ypHYgnInB3PjEXdCBGEL8b/gMBMyUHx3zI1GIuMau2RBQf/cUrJgEF0UjCmqJk5IUBb/WGwr1m3U2s5KUkZ7KBodCt4rqzAy+ti2lzTzK9BdxAkX/P4ovJXDKGUbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwN1CSqxAkNpNx9GcjrtNvXNAKQ0nmOQLgVi1ERHmhs=;
 b=YVwmDjdhpXYyKHaTSepo7FwTDSV/gaE+/FgPGTnpqlaCYhscPTO/JI011JhAFcjfmanEmUwvI/HKsiYiwpw1hAtArwu8vi9TpakfZ8PY8WIL+5D7aB8j/5s42ddUz7a+O+cMJiaCVfhyz1+wjJxiCWL9gs/sbw/z+IExYQ7gyGc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:12 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:41:12 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 05/17] staging: wfx: fix CAB sent at the wrong time
Date:   Mon, 27 Apr 2020 15:40:19 +0200
Message-Id: <20200427134031.323403-6-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:41:08 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf205ff6-e2b0-4d51-1dd8-08d7eab0a630
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1424EAACB05AA6664744A02993AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4326008)(81156014)(86362001)(8936002)(6486002)(52116002)(6666004)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(66574012)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gR+mlpNiAwzNikdEssHXPT7dx4GD60dgnhWUnHxLd1VX5deMINNj2fCuIY8VGrlf/XR08vxfu3rF9WOLYKL0S7SaKXJllHvKdDOv1/m1jBulKUOdeTGRrMEL9k31qBOvafM/KfsioNmvLi9t/hdo0lNQzvjXAd7n9zypzj/kZoWn3O7cCdGGwluMbOHXHNhX+FwX0bwmfTc92HS+Ee94fxCSvPZoDkVzgv4XFCm0bweAruE82LIE3iMBfjEuNNAFbVtH+t10pleUnNSb+drfw+BS0IdylCHhovfo5toro3fFz0briRnzp9yyWAotuyeKQcZzVogZG1hEbP2tXaq3fmUDlWGUpWkFxm1Z6Sh1em5wkLO++2WfQy30CXyOrkCoN44ljPsra2JoE4P0Aty4QCDU6jnSoiDzQePe9PrhmPEiG3gD/DXia8iFsSR1kKsp
X-MS-Exchange-AntiSpam-MessageData: 31ig2v6Gry7xAuRmP+EBV9VBwuuMOau7Cens3w7boQ0vOaaNCh8c+AUa/EVGL9fMflZYxdSr1X0ePc0BPhYzy1AxWQF3suvSqGZNifIS+gVi6iL0RIGGOI3XFDGBv/dkniZbexwD8Pp39mlRZkxfx7fbmy2BcTtH+mQdiGFGUlDcyIYR6oJXm7ANYJLiGuW8QTa6YX7TKtfJzEn+/9QRCBiFcfbGUqnDVddRkP1nSfUAANvwXDhikXf1uKwTHsvxieAN7WkCQAA92ZSd/ogKfFHFpc9PTxdAPUj7wqjGlv77Gx2KDxPIKLmkpkiWerwnKe3I+LoE1bsW4V3PNSGG57LdoPcQkCuwccKxknT35Y8IrUA/ClHVMgIESjpbi01gc/GDY2Qv6PX7Z8kieghC8yCtqJ2MKRHtudv7ITPX7je+F7JapRxoYQjB++b1aof+1GVnR9Cg0ec0TquMyyq70deB7ue+6bJ5PGVfAheZ42VDWW7MVF/Zg7kmLS0B9Gxo6lRoHMGszF/Dtx/WBs+nAy6wvuxVZ+AmiY4WwVHlyjUNwxTPzRkjQcULLjrCUzyGZsRAtDFJizahmh6sSsP0uz0HzJdznl2y2rVjPBVX+TqDy0UK7iGf1jYu9zCY6CQHfv+eEz4DxIxyvWxxtnyZU9CiPPnQIm4mOCD1cXeLeCBoQsgWVS9uuNyXWUVACaA1/Rwi+Mft38WuL9TxlxGiwb5W4P45lD2U6ick9kkqax45DaGt7JMVpeaKMruMsvipqh9DEKAIb6GSD3hTeQGwM0StHTuHZIL7HNR3CtroZq8EFa6tmZRNMB0OorUklq3a6/WfwgQdIp1cDQBQZ85zMRzQlD//AD8t2sTGgB3uqRA=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf205ff6-e2b0-4d51-1dd8-08d7eab0a630
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:41:12.3327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eh5YG+fAMyJwue/uJD54RNBnVFtwL38J8jWZ3ppIEh+vMdVQeTHoRVZDFZkC6jmNjGXzljvIl5tohtMBLTU1Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3N1c3BlbmRfcmVzdW1lX21jKCkgaXMgY2FsbGVkIHdoZW4gdGhlIGRldmljZSBpcyBhYm91dCB0
byBzZW50IGEKRFRJTS4gVGhpcyBpcyB0aGUgcmlnaHQgbW9tZW50IHRvIGVucXVldWUgQ29udGVu
dCBBZnRlciBEVElNIEJlYWNvbgooQ0FCKS4KCkhvd2V2ZXIsIHdmeF9zdXNwZW5kX3Jlc3VtZV9t
YygpIGlzIGFsc28gY2FsbGVkIHdoZW4gdGhlIERUSU0gcGVyaW9kCmVuZHMuIFVudGlsIG5vdywg
dGhpcyBldmVudCBkaWQgYWxzbyB0cmlnIENBQi4KCk5vdGUgdGhpcyBpc3N1ZSBkaWQgbm90IGhh
dmUgdG9vIG11Y2ggaW1wYWN0IHNpbmNlIHdoZW4gYSBDQUIgaXMgc2VudApvdXRzaWRlIG9mIERU
SU0gd2luZG93LCBhbiBlcnJvciBpcyByZXBvcnRlZCBieSB0aGUgZmlybXdhcmUgYW5kCm1hYzgw
MjExIHJldHJpZXMgdG8gc2VuZCB0aGUgZGF0YS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jIHwgMiArKwogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQoKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jCmluZGV4IDc3ZDVmZjE3YTU5YS4uNTEzMmMxOWUwMzY3IDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTY0
MSw2ICs2NDEsOCBAQCBpbnQgd2Z4X3NldF90aW0oc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0
cnVjdCBpZWVlODAyMTFfc3RhICpzdGEsIGJvb2wgc2V0KQogCiB2b2lkIHdmeF9zdXNwZW5kX3Jl
c3VtZV9tYyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgZW51bSBzdGFfbm90aWZ5X2NtZCBub3RpZnlf
Y21kKQogeworCWlmIChub3RpZnlfY21kICE9IFNUQV9OT1RJRllfQVdBS0UpCisJCXJldHVybjsK
IAlXQVJOKCF3ZnhfdHhfcXVldWVzX2hhc19jYWIod3ZpZiksICJpbmNvcnJlY3Qgc2VxdWVuY2Ui
KTsKIAlXQVJOKHd2aWYtPmFmdGVyX2R0aW1fdHhfYWxsb3dlZCwgImluY29ycmVjdCBzZXF1ZW5j
ZSIpOwogCXd2aWYtPmFmdGVyX2R0aW1fdHhfYWxsb3dlZCA9IHRydWU7Ci0tIAoyLjI2LjEKCg==
