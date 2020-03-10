Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6C1B17F4C5
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgCJKOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:14:23 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:6032
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726244AbgCJKOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 06:14:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQ10AYxyTu8wXZ0bvYUOurraAdby+LCmX6CvhAoLWll/TEe07jrIY9A7BFJOT+VvPCMkzwm4hKbQfzuDPSalT3AM/ID76rj/Kc1RNoqlszlfxCFF1Kyl1z4w72Hu21703Tgrqh+8eSVgbvNhmLgmEkD+Zfc6H5BWgJSMW6nv+IMphnT9jZoyZmVj7fZ/vrbo7eMz4AVT3URBCTOphzaOgo092VHJzcGX5g79ojBtJlVyVHswJ/2LBelGByFRrGEDKjJH3fTSTfgeR+8l1cquPz2pIbSkzq1V11oIzhIKkOG+lVxrtY3JAOMS6uvGU1SSGwITngU7Pnj9T+w5hXyrSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTt99lXlWBT9SkY2K/ce2HXok0D7kEfBX17sz2YNvwc=;
 b=UTly7mayQ8iV1LBtnXpJ44AKGaGwOA+lELWW1o/4egT8XjqsSqoK9M2mNMucEtr6pxalYFM7fn8zMYZyQ4Ey4hYtZd3QC+ef6k+gZ0Nf+eJdRt1PXst3HCYJIfqTEl5dcilZ9i8EhSXWKEywn0B+WQ0BcBF5DqeAlGQKBZUFf0b+CXHFdj8X2Y+QQ+cpcQvNf5ndGLnziCY2c3NpudRVYeQ8tUTl80tZHtUkJG2/NfXLvMYOBWZYRI5e9Ib2zycUOIwgRJaCOVzxLDA/FP4718f4ReIVPqxXF9c58QmQfsB386cKoRZzmUojfCVdpEQ/WgvOfVtJwTEkDNSv3DjU/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTt99lXlWBT9SkY2K/ce2HXok0D7kEfBX17sz2YNvwc=;
 b=SCC36KLO7bE6kuhRlXbPv1RQDnOqPv1hg5YTtfGQOJ5RnNnLgaJtsj6KAv2ylfJm6PfSuNVxg85rjmg4ssNFgrwgi0z2gAjqWPuKtu0Jg+C8p2LXDnlev2SKgo6+Wzwi5cuPM5Yp8IinqL+MmwiOjNeiNUJhs2gwbtuXkKFMnfk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB3615.namprd11.prod.outlook.com (2603:10b6:208:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 10:14:20 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 10:14:20 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 5/5] staging: wfx: fix RCU usage between hif_join() and ieee80211_bss_get_ie()
Date:   Tue, 10 Mar 2020 11:13:56 +0100
Message-Id: <20200310101356.182818-6-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0180.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Tue, 10 Mar 2020 10:14:19 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2d1c9ed-6be5-44b9-abf0-08d7c4dbcc76
X-MS-TrafficTypeDiagnostic: MN2PR11MB3615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB36153AFEB65FAE001086A60E93FF0@MN2PR11MB3615.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:619;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(39850400004)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(6666004)(52116002)(5660300002)(2616005)(86362001)(316002)(956004)(36756003)(478600001)(7696005)(8936002)(54906003)(4326008)(16526019)(186003)(26005)(6486002)(66574012)(66946007)(8676002)(1076003)(81166006)(2906002)(66476007)(81156014)(66556008)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3615;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sed0HcwAVpiToN/fG4X5x3hQMDBGULBMd7rqU+9s0n2ye+ceS19kYr6xL/ZjbjmhjInJohx+LVz49Ul7LVKm/5coiOCxaPFbw6PAi7LqL0VSmt0L3X/T1dBunbJRMXwlld33/kdcavMSTEBpO5J+XeqwPVNav0yhcWdatU//MAvJ4kctDx44hb13LuOqNYwzLiN5DvXZvX1FW9gRtV5tliLdcNkzVCZ7mC7VAp8H5RDF60Y7bL1Co5zmRVXuTN6y+f1qrJAxN7mzpbGTzxmKmJyh9ihMoe1x5YknCrPsxPksmosQlMOdEm9vcFLmJstEN1ESVttkWV6/HvJZqyzNgd1jka0TJQachCsDObaTehYvuAtDfhZmTMqzRNTm9M2en+zrt/7W491v5t6ylY3Dihj81dVVUJCy2LdQ9Cn9qNMwHfuzbIrD1s4Uf7Aq5SFP
X-MS-Exchange-AntiSpam-MessageData: GBHhyoH9ZlxpCMcbh+zi6C50TAACtENbeOjHuQ6fA8m5zgBiWZcnjW6YXnxryr8hxG5gaIM3FxYP2cPWd4SuYTQDJ8AGSoFpFj4Rcml6Q4Gq1/TwY3grrTKWhsHoWBkIDyCJjMW3egZnp5LDA1O9zw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d1c9ed-6be5-44b9-abf0-08d7c4dbcc76
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 10:14:20.4984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cgchuckw79sx9+IpY3w9F/NvB3Ib5Nuk6dQ2DH7uljFcpBD/cMYw/lYHX2XOACUhrBoP3LLrTG5Y7iYCW7MgcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3615
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQWNj
ZXNzIHRvIHJlc3VsdCBvZiBpZWVlODAyMTFfYnNzX2dldF9pZSgpIGlzIHByb3RlY3RlZCBieSBS
Q1UuIEluIG90aGVyCmhhbmQsIGZ1bmN0aW9uIGhpZl9qb2luKCkgY2FuIHNsZWVwIGFuZCBjYW5u
b3QgYmUgY2FsbGVkIHdpdGggUkNVCmxvY2tlZC4KClByb3ZpZGUgYSBjb3B5IG9mICJzc2lkaWUi
IHRvIGhpZl9qb2luKCkgdG8gc29sdmUgdGhpcyBiZWhhdmlvci4KCkZpeGVzOiA5Y2VkOWI1OTM3
NDEgKCJzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IGhpZl9qb2luKCkiKQpTaWduZWQtb2ZmLWJ5OiBK
w6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfdHguYyB8ICA4ICsrKystLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl90eC5oIHwgIDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgfCAxNyArKysr
KysrKysrLS0tLS0tLQogMyBmaWxlcyBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAxMiBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCA3YTU2ZTQ1YmNkYWEuLjc3YmNhNDNhY2E0
MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYworKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC0yOTAsNyArMjkwLDcgQEAgaW50IGhpZl9zdG9wX3Nj
YW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiB9CiAKIGludCBoaWZfam9pbihzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGllZWU4MDIxMV9ic3NfY29uZiAqY29uZiwKLQkgICAgIGNv
bnN0IHN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5lbCwgY29uc3QgdTggKnNzaWRpZSkK
KwkgICAgIHN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5lbCwgY29uc3QgdTggKnNzaWQs
IGludCBzc2lkbGVuKQogewogCWludCByZXQ7CiAJc3RydWN0IGhpZl9tc2cgKmhpZjsKQEAgLTMw
OCw5ICszMDgsOSBAQCBpbnQgaGlmX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0
cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmNvbmYsCiAJYm9keS0+YmFzaWNfcmF0ZV9zZXQgPQog
CQljcHVfdG9fbGUzMih3ZnhfcmF0ZV9tYXNrX3RvX2h3KHd2aWYtPndkZXYsIGNvbmYtPmJhc2lj
X3JhdGVzKSk7CiAJbWVtY3B5KGJvZHktPmJzc2lkLCBjb25mLT5ic3NpZCwgc2l6ZW9mKGJvZHkt
PmJzc2lkKSk7Ci0JaWYgKCFjb25mLT5pYnNzX2pvaW5lZCAmJiBzc2lkaWUpIHsKLQkJYm9keS0+
c3NpZF9sZW5ndGggPSBjcHVfdG9fbGUzMihzc2lkaWVbMV0pOwotCQltZW1jcHkoYm9keS0+c3Np
ZCwgJnNzaWRpZVsyXSwgc3NpZGllWzFdKTsKKwlpZiAoIWNvbmYtPmlic3Nfam9pbmVkICYmIHNz
aWQpIHsKKwkJYm9keS0+c3NpZF9sZW5ndGggPSBjcHVfdG9fbGUzMihzc2lkbGVuKTsKKwkJbWVt
Y3B5KGJvZHktPnNzaWQsIHNzaWQsIHNzaWRsZW4pOwogCX0KIAl3ZnhfZmlsbF9oZWFkZXIoaGlm
LCB3dmlmLT5pZCwgSElGX1JFUV9JRF9KT0lOLCBzaXplb2YoKmJvZHkpKTsKIAlyZXQgPSB3Znhf
Y21kX3NlbmQod3ZpZi0+d2RldiwgaGlmLCBOVUxMLCAwLCBmYWxzZSk7CmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHgu
aAppbmRleCAyMDk3N2U0NjE3MTguLmY4NTIwYTE0YzE0YyAxMDA2NDQKLS0tIGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfdHguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oCkBA
IC00Niw3ICs0Niw3IEBAIGludCBoaWZfc2NhbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0
IGNmZzgwMjExX3NjYW5fcmVxdWVzdCAqcmVxODAyMTEsCiAJICAgICBpbnQgY2hhbl9zdGFydCwg
aW50IGNoYW5fbnVtKTsKIGludCBoaWZfc3RvcF9zY2FuKHN0cnVjdCB3ZnhfdmlmICp3dmlmKTsK
IGludCBoaWZfam9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGllZWU4MDIx
MV9ic3NfY29uZiAqY29uZiwKLQkgICAgIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAq
Y2hhbm5lbCwgY29uc3QgdTggKnNzaWRpZSk7CisJICAgICBzdHJ1Y3QgaWVlZTgwMjExX2NoYW5u
ZWwgKmNoYW5uZWwsIGNvbnN0IHU4ICpzc2lkLCBpbnQgc3NpZGxlbik7CiBpbnQgaGlmX3NldF9w
bShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBwcywgaW50IGR5bmFtaWNfcHNfdGltZW91dCk7
CiBpbnQgaGlmX3NldF9ic3NfcGFyYW1zKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCQkgICAgICAg
Y29uc3Qgc3RydWN0IGhpZl9yZXFfc2V0X2Jzc19wYXJhbXMgKmFyZyk7CmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRl
eCBlZDE2NDc1YzIwN2MuLmFmNGY0YmJkMDU3MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC00OTEsOSArNDkx
LDExIEBAIHN0YXRpYyB2b2lkIHdmeF9zZXRfbWZwKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogc3Rh
dGljIHZvaWQgd2Z4X2RvX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiB7CiAJaW50IHJldDsK
LQljb25zdCB1OCAqc3NpZGllOwogCXN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmNvbmYgPSAm
d3ZpZi0+dmlmLT5ic3NfY29uZjsKIAlzdHJ1Y3QgY2ZnODAyMTFfYnNzICpic3MgPSBOVUxMOwor
CXU4IHNzaWRbSUVFRTgwMjExX01BWF9TU0lEX0xFTl07CisJY29uc3QgdTggKnNzaWRpZSA9IE5V
TEw7CisJaW50IHNzaWRsZW4gPSAwOwogCiAJd2Z4X3R4X2xvY2tfZmx1c2god3ZpZi0+d2Rldik7
CiAKQEAgLTUxNCwxMSArNTE2LDE0IEBAIHN0YXRpYyB2b2lkIHdmeF9kb19qb2luKHN0cnVjdCB3
ZnhfdmlmICp3dmlmKQogCWlmICghd3ZpZi0+YmVhY29uX2ludCkKIAkJd3ZpZi0+YmVhY29uX2lu
dCA9IDE7CiAKLQlyY3VfcmVhZF9sb2NrKCk7CisJcmN1X3JlYWRfbG9jaygpOyAvLyBwcm90ZWN0
IHNzaWRpZQogCWlmICghY29uZi0+aWJzc19qb2luZWQpCiAJCXNzaWRpZSA9IGllZWU4MDIxMV9i
c3NfZ2V0X2llKGJzcywgV0xBTl9FSURfU1NJRCk7Ci0JZWxzZQotCQlzc2lkaWUgPSBOVUxMOwor
CWlmIChzc2lkaWUpIHsKKwkJc3NpZGxlbiA9IHNzaWRpZVsxXTsKKwkJbWVtY3B5KHNzaWQsICZz
c2lkaWVbMl0sIHNzaWRpZVsxXSk7CisJfQorCXJjdV9yZWFkX3VubG9jaygpOwogCiAJd2Z4X3R4
X2ZsdXNoKHd2aWYtPndkZXYpOwogCkBAIC01MjcsMTAgKzUzMiw4IEBAIHN0YXRpYyB2b2lkIHdm
eF9kb19qb2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCiAJd2Z4X3NldF9tZnAod3ZpZiwgYnNz
KTsKIAotCS8qIFBlcmZvcm0gYWN0dWFsIGpvaW4gKi8KIAl3dmlmLT53ZGV2LT50eF9idXJzdF9p
ZHggPSAtMTsKLQlyZXQgPSBoaWZfam9pbih3dmlmLCBjb25mLCB3dmlmLT5jaGFubmVsLCBzc2lk
aWUpOwotCXJjdV9yZWFkX3VubG9jaygpOworCXJldCA9IGhpZl9qb2luKHd2aWYsIGNvbmYsIHd2
aWYtPmNoYW5uZWwsIHNzaWQsIHNzaWRsZW4pOwogCWlmIChyZXQpIHsKIAkJaWVlZTgwMjExX2Nv
bm5lY3Rpb25fbG9zcyh3dmlmLT52aWYpOwogCQl3dmlmLT5qb2luX2NvbXBsZXRlX3N0YXR1cyA9
IC0xOwotLSAKMi4yNS4xCgo=
