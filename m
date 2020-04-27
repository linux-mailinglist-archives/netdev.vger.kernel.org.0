Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6541BA530
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgD0NlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:41:14 -0400
Received: from mail-mw2nam12on2086.outbound.protection.outlook.com ([40.107.244.86]:6127
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727992AbgD0NlL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuLPTCJPT+pvTo2W3Qllvd/2i/Q+yLAU1GYPY2+Mc5ISiSn9dQCSKLGFQwYpCDdhLS2EXUCygragCDtAR1lBz+7rDxSOvfMtTZmIlQrVxAp8kkyAC/d23eKyCMCQFdqZytYccX7jx2FZX6wuu/PXnh2eRYftJotvSbFPLYjOZrPgYYnM12bEIhkOQUlGkyzAzXc18B1J1yV/kczecerxTXZXK4M1oMNXILKTZ3/lgE358rtFMre+J7w0LJspBIXHXwSkS5mgWT8j2p5T2DieEGOmtX/8L/ro5HSjzbyVVh36pmlFqn1yfdmqwXh4btqbsknw+PCmKGi/9dwnKGCm1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4Z9XHMk2EIFcuuUeSbslGWvZpkT0RcgtGB0oJKFgr0=;
 b=NlL99G+ohndy3UsnU7yDVJBHDhRbcafjHZBJsLLJE6Cx8ZxLGfGWtm+XVCn50U0Rfx8GGAVijqcDttZxbyt4Cny6xkmC0M9VHl7j6y0B0fmqx1iw4ruULCPDqPBacPHDnxc2z8w3OMvORsSrHkIYnoC+NJleY0xfOI3CkxdkkyM2oTL3/4AHRat/B7gmb5a281TimvjX//ASlAvY52XjP8hXKXX7U+HZa9ZMOrjSBQrn7C6mjci5lb4bA98p0rUQbrY35DTPFKpcnY08985Itu9PPfwuu6vqLqOqz30hSAmTit0taILkKe3xQ8N5l5S5lDH1wQ2BfWHhwB4KTRQM2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4Z9XHMk2EIFcuuUeSbslGWvZpkT0RcgtGB0oJKFgr0=;
 b=PtYagRck0n60073veLaoidcJxOzY9EtbiBg8FRjMSh+9IiPAvQ+E4Ae9g7dSwQQp/3lEmWPY+xT5vJqhtlJ4e9k5JzUT5tF+4l3/8FtfiDVzx/ptSWvJ3FaEaJIM4/gFtoY/mQrKLHap0FoDqHJB4ttuWXGhhJIVAXMDZGZs4AA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:08 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:41:08 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 04/17] staging: wfx: fix support for AP that do not support PS-Poll
Date:   Mon, 27 Apr 2020 15:40:18 +0200
Message-Id: <20200427134031.323403-5-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:41:06 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5619c46f-bbb2-4c49-21da-08d7eab0a3ef
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB14241ED5BC580BAAA458C29F93AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:800;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4326008)(81156014)(86362001)(8936002)(6486002)(52116002)(6666004)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(66574012)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fcEtMjYai7Rq7+dJ45dUF4QdCRG8QD1PBOodE//mBLCqc0bkH5UkTHI9JUhFBDFBqv+ebWi9aJ4JcNfv+NXVi390TAC+n9RdpC9yKhke+007YE6SDn7I01p+0TqfDg04Tpq0+v0Qgz/qIx2pVfwEgM9e1AxlyQXWdJo+icJr/Z7SV2kG+NQjAplmT6eWNzViAFQGHWpjjCDe98bBzOC+EW9pG+c7teBGoD0EfnWI2waZj/b0qrUJYTj7PFkpX/u68zHVPDjx5bG3kLAXNLB6VJeRvsPwpjughOyS7mJbzyqNT4pBbdbNv6m/MX4MbQzx31RlCr3ucS+rtMraoyG5UlNwCd5amYpXx0Nk6O/F/hgirELmfaBhdqovVelX+sS8HHYtlXpqIrywwMl7yFlqH8ufHgc1KEyg1505Qy8U47yik0WLRr/YYm1kA3mzSWOK
X-MS-Exchange-AntiSpam-MessageData: xBrZGCj7CYMXoY49/QH+1DVO5CAG6zPu9DFeXUw2yh7THlJMLK3MeQ3B0MSyk8QgL/H9J9+/B62goWz5dWHqjheZcd5mPclQITlZ9MPry1l5hNadVFWqT+LtW17U9+LmieLNXC+xuVvMd0bKGtxY6IuOX4SbmEt354yXowjB1mOoCl1CW6UgdO6sz/DhF3l3vivwtr4nYmPpFFUPTxM1VEQNJq1lYTAFofMbcCARiLfGi+c/eun/aR+3Qas7oxXGm0y7H9IC6J40/iEeq17XLPeokRiC1HsktTmh74C4RAZkWC0+hygbo7//PJM4Aj8H0cGaeF2aaiqMNDpdtcIznUQDlTHfKjKkzQASN8PbyRsNJhwpXRfB4D3+tRWnjDv1Vg/JQJ0l9//sCCzljnz0BVhdKuSAxWQiBdszdimf9gZLB/vz/d1jpqLvBrB1uaqcDuVD/+HacqiAzdbte5FvWPskYFjAe3kdQ2ImS6Ld2g4DEu86sfnPoOtSwlZ/89RAlQVJ6BCfTYnCchq7gZ+7lASu4Eap5wS2stYRXtchZrn4yPe97ztrRs/lY3cMsSdrBK6A07DLD2ADlYW8QXBWCFWX4UThcSEla6+zUn1ZPbuLe0gWWnGOYav141pw11KUBTlt5UCtfMEvriJCTVLnv7KyMe1MkXCy3Lo4sI9S37mmlMRYdJhkVGPR29vZRLDqU/dTNJjZ90NgMiayp9Dycod1+G1XUJ9/Z4AbeXiKKMp0FGxKBYYknpQFSr4Y8Vw8PfswlICH9PSTtRyQ6lcG/Vzgpw8nFyFARoELrSRmcI39Kp9WCSbrmh4S/72pUmUfgQy12gZGatdov5JneBVTerRp08RQDUn4D/3u/5cOuhw=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5619c46f-bbb2-4c49-21da-08d7eab0a3ef
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:41:08.5734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uG9VmFYLpqLCr8aRi98Z0BTZ7fuVcTe+5mC6jYWDJIH8ZvQHEGn4ttnVb5gtZZQ6AzpJhZ3ZV6yEutavh5cdBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBtdWx0aXBsZSB2aXJ0dWFsIGludGVyZmFjZXMgKG9uIGRpZmZlcmVudCBjaGFubmVscykgYXJl
IGluIHVzZSwgdGhlCmRldmljZSBhc2sgdG8gYWN0aXZhdGUgUG93ZXIgU2F2ZSBvbiBzdGF0aW9u
IGludGVyZmFjZXMuIFRoZSBkZXZpY2UKZGV2ZWxvcGVycyByZWNvbW1lbmRzIHRvIHVzZSBsZWdh
Y3kgUFMtUG9sbCBpbiB0aGlzIGNhc2Ugc2luY2UgaXQgaXMgdGhlCm1vZGUgdGhhdCBkaXN0dXJi
IHRoZSBsZXNzIHRoZSBvdGhlciBpbnRlcmZhY2UuIEhvd2V2ZXIsIHNvbWUgQVAgc3RhcnQKdG8g
bm90IGFuc3dlciBhbnltb3JlIHRvIFBTLVBvbGwuIFRoZSBkZXZpY2UgaXMgYWJsZSB0byBkZXRl
Y3QgdGhpcyBjYXNlCmFuZCByZXR1cm4gYSBzcGVjaWFsIHdhcm5pbmcgaW4gdGhpcyBjYXNlLgoK
U28sIHRoaXMgY29tbWl0IGNhdGNoIHRoZSB3YXJuaW5nIGFuZCBmb3JjZSB1c2FnZSBvZiBGYXN0
UFMgaW4gdGhpcwpjYXNlLgoKSW4gb3JkZXIgdG8gY29uZnVzZSB0aGUgbGVzcyBwb3NzaWJsZSB0
aGUgb3RoZXIgaW50ZXJmYWNlIGEgc21hbGwgRmFzdFBTCnBlcmlvZCBpcyB1c2VkICgzMG1zKS4K
ClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJz
LmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jIHwgIDggKysrKysrKy0KIGRy
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgfCAxNiArKysrKysrKysrKysrKystCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L3dmeC5oICAgIHwgIDIgKysKIDMgZmlsZXMgY2hhbmdlZCwgMjQgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl9yeC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYwppbmRleCA2ZGJlMjg5YTM2
OGYuLmEyYWM2YzA5ODE2MyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcngu
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCkBAIC0xNzYsNyArMTc2LDEzIEBA
IHN0YXRpYyBpbnQgaGlmX2V2ZW50X2luZGljYXRpb24oc3RydWN0IHdmeF9kZXYgKndkZXYsCiAJ
CWRldl9kYmcod2Rldi0+ZGV2LCAiaWdub3JlIEJTU1JFR0FJTkVEIGluZGljYXRpb25cbiIpOwog
CQlicmVhazsKIAljYXNlIEhJRl9FVkVOVF9JTkRfUFNfTU9ERV9FUlJPUjoKLQkJZGV2X3dhcm4o
d2Rldi0+ZGV2LCAiZXJyb3Igd2hpbGUgcHJvY2Vzc2luZyBwb3dlciBzYXZlIHJlcXVlc3RcbiIp
OworCQlkZXZfd2Fybih3ZGV2LT5kZXYsICJlcnJvciB3aGlsZSBwcm9jZXNzaW5nIHBvd2VyIHNh
dmUgcmVxdWVzdDogJWRcbiIsCisJCQkgYm9keS0+ZXZlbnRfZGF0YS5wc19tb2RlX2Vycm9yKTsK
KwkJaWYgKGJvZHktPmV2ZW50X2RhdGEucHNfbW9kZV9lcnJvciA9PQorCQkgICAgSElGX1BTX0VS
Uk9SX0FQX05PVF9SRVNQX1RPX1BPTEwpIHsKKwkJCXd2aWYtPmJzc19ub3Rfc3VwcG9ydF9wc19w
b2xsID0gdHJ1ZTsKKwkJCXNjaGVkdWxlX3dvcmsoJnd2aWYtPnVwZGF0ZV9wbV93b3JrKTsKKwkJ
fQogCQlicmVhazsKIAlkZWZhdWx0OgogCQlkZXZfd2Fybih3ZGV2LT5kZXYsICJ1bmhhbmRsZWQg
ZXZlbnQgaW5kaWNhdGlvbjogJS4yeFxuIiwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDIyNjJlMWRlMzdmNi4u
NzdkNWZmMTdhNTlhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTIwNSw3ICsyMDUsMTAgQEAgc3RhdGljIGlu
dCB3ZnhfdXBkYXRlX3BtKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCWlmIChjaGFuMCAmJiBjaGFu
MSAmJiBjaGFuMC0+aHdfdmFsdWUgIT0gY2hhbjEtPmh3X3ZhbHVlICYmCiAJICAgIHd2aWYtPnZp
Zi0+dHlwZSAhPSBOTDgwMjExX0lGVFlQRV9BUCkgewogCQlwcyA9IHRydWU7Ci0JCXBzX3RpbWVv
dXQgPSAwOworCQlpZiAod3ZpZi0+YnNzX25vdF9zdXBwb3J0X3BzX3BvbGwpCisJCQlwc190aW1l
b3V0ID0gMzA7CisJCWVsc2UKKwkJCXBzX3RpbWVvdXQgPSAwOwogCX0KIAogCWlmICghd2FpdF9m
b3JfY29tcGxldGlvbl90aW1lb3V0KCZ3dmlmLT5zZXRfcG1fbW9kZV9jb21wbGV0ZSwKQEAgLTIx
NSw2ICsyMTgsMTQgQEAgc3RhdGljIGludCB3ZnhfdXBkYXRlX3BtKHN0cnVjdCB3ZnhfdmlmICp3
dmlmKQogCXJldHVybiBoaWZfc2V0X3BtKHd2aWYsIHBzLCBwc190aW1lb3V0KTsKIH0KIAorc3Rh
dGljIHZvaWQgd2Z4X3VwZGF0ZV9wbV93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKK3sK
KwlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IGNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3Qgd2Z4X3Zp
ZiwKKwkJCQkJICAgIHVwZGF0ZV9wbV93b3JrKTsKKworCXdmeF91cGRhdGVfcG0od3ZpZik7Cit9
CisKIGludCB3ZnhfY29uZl90eChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4
MDIxMV92aWYgKnZpZiwKIAkJICAgdTE2IHF1ZXVlLCBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX3R4
X3F1ZXVlX3BhcmFtcyAqcGFyYW1zKQogewpAQCAtMjkzLDYgKzMwNCw3IEBAIHN0YXRpYyB2b2lk
IHdmeF9kb191bmpvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJaWYgKHd2aWZfY291bnQod3Zp
Zi0+d2RldikgPD0gMSkKIAkJaGlmX3NldF9ibG9ja19hY2tfcG9saWN5KHd2aWYsIDB4RkYsIDB4
RkYpOwogCXdmeF90eF91bmxvY2sod3ZpZi0+d2Rldik7CisJd3ZpZi0+YnNzX25vdF9zdXBwb3J0
X3BzX3BvbGwgPSBmYWxzZTsKIAljYW5jZWxfZGVsYXllZF93b3JrX3N5bmMoJnd2aWYtPmJlYWNv
bl9sb3NzX3dvcmspOwogfQogCkBAIC00NTMsNiArNDY1LDcgQEAgdm9pZCB3Znhfc3RvcF9hcChz
dHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKIAl3Znhf
dHhfcG9saWN5X2luaXQod3ZpZik7CiAJaWYgKHd2aWZfY291bnQod3ZpZi0+d2RldikgPD0gMSkK
IAkJaGlmX3NldF9ibG9ja19hY2tfcG9saWN5KHd2aWYsIDB4RkYsIDB4RkYpOworCXd2aWYtPmJz
c19ub3Rfc3VwcG9ydF9wc19wb2xsID0gZmFsc2U7CiB9CiAKIHN0YXRpYyB2b2lkIHdmeF9qb2lu
X2ZpbmFsaXplKHN0cnVjdCB3ZnhfdmlmICp3dmlmLApAQCAtNzM3LDYgKzc1MCw3IEBAIGludCB3
ZnhfYWRkX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIx
MV92aWYgKnZpZikKIAogCWluaXRfY29tcGxldGlvbigmd3ZpZi0+c2V0X3BtX21vZGVfY29tcGxl
dGUpOwogCWNvbXBsZXRlKCZ3dmlmLT5zZXRfcG1fbW9kZV9jb21wbGV0ZSk7CisJSU5JVF9XT1JL
KCZ3dmlmLT51cGRhdGVfcG1fd29yaywgd2Z4X3VwZGF0ZV9wbV93b3JrKTsKIAlJTklUX1dPUkso
Jnd2aWYtPnR4X3BvbGljeV91cGxvYWRfd29yaywgd2Z4X3R4X3BvbGljeV91cGxvYWRfd29yayk7
CiAKIAltdXRleF9pbml0KCZ3dmlmLT5zY2FuX2xvY2spOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKaW5kZXggNzdiYjZj
NjE3NTQ2Li5jN2E1OGFiM2JlYWEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4
LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApAQCAtODksNiArODksOCBAQCBzdHJ1
Y3Qgd2Z4X3ZpZiB7CiAJYm9vbAkJCXNjYW5fYWJvcnQ7CiAJc3RydWN0IGllZWU4MDIxMV9zY2Fu
X3JlcXVlc3QgKnNjYW5fcmVxOwogCisJYm9vbAkJCWJzc19ub3Rfc3VwcG9ydF9wc19wb2xsOwor
CXN0cnVjdCB3b3JrX3N0cnVjdAl1cGRhdGVfcG1fd29yazsKIAlzdHJ1Y3QgY29tcGxldGlvbglz
ZXRfcG1fbW9kZV9jb21wbGV0ZTsKIH07CiAKLS0gCjIuMjYuMQoK
