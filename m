Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AEA210E93
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731823AbgGAPIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:08:22 -0400
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:52640
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731798AbgGAPIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 11:08:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NgqV6/1iT2/iyYcbp6DNJe474OX7XSS2RDb/e16YGt8sOSxZq8ZYyxgIj0YEhpgPP5Cb6LHAuCfqjZq2VY/JNZRVIexH/0HC9CigHkgstoNk00JVT2YmOyTOfIGmQhoBj+9PdQ7HISM3z+iti4hFkxdrh5hVbing4s13kQ2OgHy8pL8IutVsW+t6Wv81i+ryTjh1KpxS/DCp50AG5d2nhugJdul2MVVrOu9r+/X76Chq/qam0KHobF5GyoBJ3zZ4kOjpQ+BgKBv39EGvrd9hzr7vEZccIr0ERuIqBKwQq0I5wPvzuKsYD81UitTmQPDmWRtzjD2Rrei8ohwhO7nHiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoUXTUzrL9Wlx5IeUEgnWIpwJ+//CCk86Mp9ROVa9WQ=;
 b=RdKTte+krGwS7QmE2SjWG5wmFPn9ybHggqapHb65+yXgcNqBGNBdJR36nxsRxEcbeRBQgffSksfKR4BrKMIR3Hz846zcCOYGOBS04UklJFeA5BEzoHTtdxplqb8Ys7tHd58AbULszb8/iNnN8bbQ/nfHu+VEy1a4LdkuP9tvuy/qJ+bPiwAmxX7uO82p8ZMJu2Q2Xwg3PfbmcI/gGxLpv2g+2l7l29A1g/n4dZQ8lElMHukgh6Jm6iWMdkFuU+1XZBAluKsaqh2I9NHbY9ApUnZl9XJv45fSxysrUf4lgDvoPBWflcpSLQTOBmvX3aYivvq50zpUFH2HWZ3kFGC6Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoUXTUzrL9Wlx5IeUEgnWIpwJ+//CCk86Mp9ROVa9WQ=;
 b=J1CE14PaDS2/LvPENGR1qpb+82YDT2GDuHAqnmFdrmG5CoTb/z3mxgCVqumdoXj/imDJ5u6wkvbdy+wjkshgKKc2x8H9m3diMg2tudqsv4A2+2ioxBl6bTAQVCtey+N75rK+SH8NcTsq0QPXWNz0w6cpQxBSXbJ7EqdqSJ2aY5U=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4736.namprd11.prod.outlook.com (2603:10b6:806:9f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Wed, 1 Jul
 2020 15:08:08 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3131.033; Wed, 1 Jul 2020
 15:08:08 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 04/13] staging: wfx: add tracepoint "queues_stats"
Date:   Wed,  1 Jul 2020 17:06:58 +0200
Message-Id: <20200701150707.222985-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701150707.222985-1-Jerome.Pouiller@silabs.com>
References: <20200701150707.222985-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR07CA0143.namprd07.prod.outlook.com
 (2603:10b6:3:13e::33) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR07CA0143.namprd07.prod.outlook.com (2603:10b6:3:13e::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Wed, 1 Jul 2020 15:08:06 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3389e50-2e1a-452f-e6de-08d81dd0903a
X-MS-TrafficTypeDiagnostic: SA0PR11MB4736:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB473671D1B73AE9BD0115BC82936C0@SA0PR11MB4736.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2nR6khtdnSqw6CGIZL9275ji09M0gGbnvwGYp12bUKWtprwrL/0wYQ/JU56OSpMa+6Du4B0yV/ntlWeXO00o+47fbwVe6ReVmN3zycX4uA9JGkayOsqULOT1Lw5a7ywH+yEwvXbO7V+fxLhzC3G1Q9EJn4p7E5icu91s/TVzjglfTSPP6Sm3Iwumj7davUIhKH6rdiv6349O4gHdBo4Tjsj0VNtC1N0tkAOi26sSCsk/bzCOapXn0CQBINb3gIXMFsPxRVrEBXL8F3tQyo5zabWYDZ2BZVjGjaT/QuJ2SeusZVg1jMNX4E+GxM0ulr9KA3whY576nGY3/+VCvTGpnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(366004)(346002)(376002)(396003)(136003)(5660300002)(6486002)(86362001)(6666004)(66574015)(36756003)(2906002)(186003)(83380400001)(16526019)(8936002)(66556008)(66476007)(107886003)(4326008)(8676002)(2616005)(1076003)(478600001)(316002)(54906003)(66946007)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ak0YOdFGxcXrJoOkFPuQQ7xP9UMtzbxD9jBYKrZDYR7ImU/xjc6WwaTWiKQ/wiSG8PL9+uXR68mLf6ZPTvkcU9qyvmrZpY8siCZmVhoQbxtf4+T+AaShwupm9yvCvLSwkAJ71JO624V7Y4ZHBZ1JeT21w0RNQw9hqjTJXXKgeojfsFoaEBp8p6quOTI+2QsLqV4Xiwne3N3gqxNUD7OgqvXEPkcnjBx5C6MfpsWzma97SG15xgTsbrRJLbrXCvPxScJDVssspr9rs/QHHDdK1zptd+/mFh9STFeGzZ5uaCmcKcF/o4AkKVf/omKxIyp90bKU55fyZZOHZD/lQtUvpgEkxVbhcS4gIfrEZPK9yX9Yqh3nCCKb9JB1D9yB1Awf2J3mQtI7qWdOAAUOIvDYVejIHtRsAK/jojuxpT4zoGQuNHiQVkVelH8CKvMQqmNOXKEXzwVKitN9FBwltzkcPvvapGMDw5X+r3XRu3jCCqV9zk3JzDjr4i7WelE0vzMTTA78NU2gL8qaNKjXB3wwncOpy0khDY6eF2KNVgMESik=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3389e50-2e1a-452f-e6de-08d81dd0903a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 15:08:08.5426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WWnuLFKkq14MDgN75Kw1lfNn5a3ZFDOWczAj1TNuPkNFOZ6srw0LEXAmweMBoJsp5hcuBeU9bbEwaAV04zOlPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4736
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgdXNlZnVsIHRvIGNoZWNrIHdoaWNoIHF1ZXVlIHRoZSBkcml2ZXIgY2hvb3NlIHRvIHNlbmQg
dG8gdGhlCmhhcmR3YXJlLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9t
ZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyAg
fCAgMyArKysKIGRyaXZlcnMvc3RhZ2luZy93ZngvdHJhY2VzLmggfCA1MSArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgNTQgaW5zZXJ0aW9ucygr
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyBiL2RyaXZlcnMvc3Rh
Z2luZy93ZngvcXVldWUuYwppbmRleCA2NzhmNjIyNjM5MDkzLi42ZTMxNTkxNjUxNDMyIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9xdWV1ZS5jCkBAIC0xMiw2ICsxMiw3IEBACiAjaW5jbHVkZSAid2Z4LmgiCiAjaW5jbHVk
ZSAic3RhLmgiCiAjaW5jbHVkZSAiZGF0YV90eC5oIgorI2luY2x1ZGUgInRyYWNlcy5oIgogCiB2
b2lkIHdmeF90eF9sb2NrKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogewpAQCAtMjU2LDYgKzI1Nyw3
IEBAIHN0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAqd2Z4X3R4X3F1ZXVlc19nZXRfc2tiKHN0cnVjdCB3
ZnhfZGV2ICp3ZGV2KQogCQkJV0FSTl9PTihxdWV1ZXNbaV0gIT0KIAkJCQkmd3ZpZi0+dHhfcXVl
dWVbc2tiX2dldF9xdWV1ZV9tYXBwaW5nKHNrYildKTsKIAkJCWF0b21pY19pbmMoJnF1ZXVlc1tp
XS0+cGVuZGluZ19mcmFtZXMpOworCQkJdHJhY2VfcXVldWVzX3N0YXRzKHdkZXYsIHF1ZXVlc1tp
XSk7CiAJCQlyZXR1cm4gc2tiOwogCQl9CiAJCS8vIE5vIG1vcmUgbXVsdGljYXN0IHRvIHNlbnQK
QEAgLTI2Nyw2ICsyNjksNyBAQCBzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKndmeF90eF9xdWV1ZXNf
Z2V0X3NrYihzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAkJc2tiID0gc2tiX2RlcXVldWUoJnF1ZXVl
c1tpXS0+bm9ybWFsKTsKIAkJaWYgKHNrYikgewogCQkJYXRvbWljX2luYygmcXVldWVzW2ldLT5w
ZW5kaW5nX2ZyYW1lcyk7CisJCQl0cmFjZV9xdWV1ZXNfc3RhdHMod2RldiwgcXVldWVzW2ldKTsK
IAkJCXJldHVybiBza2I7CiAJCX0KIAl9CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3RyYWNlcy5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC90cmFjZXMuaAppbmRleCAwYjZmYmQ1MTg2
MzgxLi5kMzc2ZGIyZjE4OTFiIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3RyYWNl
cy5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvdHJhY2VzLmgKQEAgLTQzOSw2ICs0MzksNTcg
QEAgVFJBQ0VfRVZFTlQodHhfc3RhdHMsCiApOwogI2RlZmluZSBfdHJhY2VfdHhfc3RhdHModHhf
Y25mLCBza2IsIGRlbGF5KSB0cmFjZV90eF9zdGF0cyh0eF9jbmYsIHNrYiwgZGVsYXkpCiAKK1RS
QUNFX0VWRU5UKHF1ZXVlc19zdGF0cywKKwlUUF9QUk9UTyhzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwg
Y29uc3Qgc3RydWN0IHdmeF9xdWV1ZSAqZWxlY3RlZF9xdWV1ZSksCisJVFBfQVJHUyh3ZGV2LCBl
bGVjdGVkX3F1ZXVlKSwKKwlUUF9TVFJVQ1RfX2VudHJ5KAorCQlfX2ZpZWxkKGludCwgdmlmX2lk
KQorCQlfX2ZpZWxkKGludCwgcXVldWVfaWQpCisJCV9fYXJyYXkoaW50LCBodywgSUVFRTgwMjEx
X05VTV9BQ1MgKiAyKQorCQlfX2FycmF5KGludCwgZHJ2LCBJRUVFODAyMTFfTlVNX0FDUyAqIDIp
CisJCV9fYXJyYXkoaW50LCBjYWIsIElFRUU4MDIxMV9OVU1fQUNTICogMikKKwkpLAorCVRQX2Zh
c3RfYXNzaWduKAorCQljb25zdCBzdHJ1Y3Qgd2Z4X3F1ZXVlICpxdWV1ZTsKKwkJc3RydWN0IHdm
eF92aWYgKnd2aWY7CisJCWludCBpLCBqOworCisJCWZvciAoaiA9IDA7IGogPCBJRUVFODAyMTFf
TlVNX0FDUyAqIDI7IGorKykgeworCQkJX19lbnRyeS0+aHdbal0gPSAtMTsKKwkJCV9fZW50cnkt
PmRydltqXSA9IC0xOworCQkJX19lbnRyeS0+Y2FiW2pdID0gLTE7CisJCX0KKwkJX19lbnRyeS0+
dmlmX2lkID0gLTE7CisJCV9fZW50cnktPnF1ZXVlX2lkID0gLTE7CisJCXd2aWYgPSBOVUxMOwor
CQl3aGlsZSAoKHd2aWYgPSB3dmlmX2l0ZXJhdGUod2Rldiwgd3ZpZikpICE9IE5VTEwpIHsKKwkJ
CWZvciAoaSA9IDA7IGkgPCBJRUVFODAyMTFfTlVNX0FDUzsgaSsrKSB7CisJCQkJaiA9IHd2aWYt
PmlkICogSUVFRTgwMjExX05VTV9BQ1MgKyBpOworCQkJCVdBUk5fT04oaiA+PSBJRUVFODAyMTFf
TlVNX0FDUyAqIDIpOworCQkJCXF1ZXVlID0gJnd2aWYtPnR4X3F1ZXVlW2ldOworCQkJCV9fZW50
cnktPmh3W2pdID0gYXRvbWljX3JlYWQoJnF1ZXVlLT5wZW5kaW5nX2ZyYW1lcyk7CisJCQkJX19l
bnRyeS0+ZHJ2W2pdID0gc2tiX3F1ZXVlX2xlbigmcXVldWUtPm5vcm1hbCk7CisJCQkJX19lbnRy
eS0+Y2FiW2pdID0gc2tiX3F1ZXVlX2xlbigmcXVldWUtPmNhYik7CisJCQkJaWYgKHF1ZXVlID09
IGVsZWN0ZWRfcXVldWUpIHsKKwkJCQkJX19lbnRyeS0+dmlmX2lkID0gd3ZpZi0+aWQ7CisJCQkJ
CV9fZW50cnktPnF1ZXVlX2lkID0gaTsKKwkJCQl9CisJCQl9CisJCX0KKwkpLAorCVRQX3ByaW50
aygiZ290IHNrYiBmcm9tICVkLyVkLCBwZW5kLiBody9ub3JtL2NhYjogWyAlZC8lZC8lZCAlZC8l
ZC8lZCAlZC8lZC8lZCAlZC8lZC8lZCBdIFsgJWQvJWQvJWQgJWQvJWQvJWQgJWQvJWQvJWQgJWQv
JWQvJWQgXSIsCisJCV9fZW50cnktPnZpZl9pZCwgX19lbnRyeS0+cXVldWVfaWQsCisJCV9fZW50
cnktPmh3WzBdLCBfX2VudHJ5LT5kcnZbMF0sIF9fZW50cnktPmNhYlswXSwKKwkJX19lbnRyeS0+
aHdbMV0sIF9fZW50cnktPmRydlsxXSwgX19lbnRyeS0+Y2FiWzFdLAorCQlfX2VudHJ5LT5od1sy
XSwgX19lbnRyeS0+ZHJ2WzJdLCBfX2VudHJ5LT5jYWJbMl0sCisJCV9fZW50cnktPmh3WzNdLCBf
X2VudHJ5LT5kcnZbM10sIF9fZW50cnktPmNhYlszXSwKKwkJX19lbnRyeS0+aHdbNF0sIF9fZW50
cnktPmRydls0XSwgX19lbnRyeS0+Y2FiWzRdLAorCQlfX2VudHJ5LT5od1s1XSwgX19lbnRyeS0+
ZHJ2WzVdLCBfX2VudHJ5LT5jYWJbNV0sCisJCV9fZW50cnktPmh3WzZdLCBfX2VudHJ5LT5kcnZb
Nl0sIF9fZW50cnktPmNhYls2XSwKKwkJX19lbnRyeS0+aHdbN10sIF9fZW50cnktPmRydls3XSwg
X19lbnRyeS0+Y2FiWzddCisJKQorKTsKKwogI2VuZGlmCiAKIC8qIFRoaXMgcGFydCBtdXN0IGJl
IG91dHNpZGUgcHJvdGVjdGlvbiAqLwotLSAKMi4yNy4wCgo=
