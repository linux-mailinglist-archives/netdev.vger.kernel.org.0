Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D3325F783
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgIGKP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:15:57 -0400
Received: from mail-eopbgr770058.outbound.protection.outlook.com ([40.107.77.58]:18596
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728580AbgIGKPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:15:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ciSQpqI0HyTGLLFi5uuWKgtCNP3ARkfsyVPLk/xmCUSen80oNL6PydyYAa6/qKsOcmjIvuoarK0XEBjHoSYo8xHQxMOaQbw9z1vI0inKjiJZGhfquWnCVEkq0vZU7AV/aCUFMyR7uVsY1wyZErqdxK1SF19gti/geZk/G7ne2Y7Cjz9Qm0+FqjXeE0cVIBDoTMC31PdE0VVv8q0DdeKv9kOxtEEurN1bsuvREZgWzfZpd5dDraGHfWl9omtipmfRD0deKc3SCONW4OaxKJgLB2GVszhfyPiAHVsSV418RHIaK0MOWKbQcLegF6AQLCtskO6pPvKPORnSrcg5JMhXuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lng78iQsSR7Ed7fccXBiYyVJklOlUJ2lxl/K0GT01Vo=;
 b=Pu/7HlcM5XuRoK4cUB0vqJu2CeHWwZXqG1ICqYMQl5JjGGUEz+B2zSKOG851QcmjC04ywWm17j9BNf2AQdMajoIAJzdwa6GTdqfZ97ZoMXhiww0XhCBrQVac64K3AbCKETcbyLiMJE/BAUncKP32AHV/hm0L2HkSbbzlzqMjkkqlxO4q6MpiWrMNROxvt6uJ5qXdFv59ihZtR0jdjF6o1aHbXYVTbyXXbLmuXupCIXdAeqN5tFX7OR9D1T3cXOEgkRhiUAQf3uIG1t2QV9CRp3H6StrG0b4SBE6CyVmBM7o0jgq2jjQn8qjbg35hijSMeiJBp1FpKmCYt+RkYvHCAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lng78iQsSR7Ed7fccXBiYyVJklOlUJ2lxl/K0GT01Vo=;
 b=jwSwJXFn8yPDtXDxTeXZmNTwssI/YEN18TCHUj4oL3TyT2jlcG3iwOdDo1g0yJ3FzyHnK/wbtp45wZH6O2IiKAajNr1tjEvplVU6AVsqqHGMNIFdaJ5D460x50JAtbu50prP/cVVSJYEaY1Fv+qm3Gd7Cr1tPblyo4OOmk4cwtI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:15:45 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:15:45 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 01/31] staging: wfx: improve readability of association processing
Date:   Mon,  7 Sep 2020 12:14:51 +0200
Message-Id: <20200907101521.66082-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
References: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::25) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:15:44 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40e4dd50-8b03-4245-1426-08d85316fc06
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2606B99A0964FE97BDA0314A93280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PUYHNr50QnIsJHaJYMmopobpfy1i+dod9100Qe1EGUa77a6F2vhIFr3nn9oi5u1CDP3UQ4LLNw1CMmrEGUdiDG1/wPgR2pkbl8g4GEOxgUin5qTtHnE871J7l9j6WHLNftyRi3eML0uGmSAU0J+zRW0e8gXmovfgpHK1EQjUyNsOZzg2wjWArIZum+f1XV1fYbjJQMus2S3HvFF886Qu6AIO4LKgm2JCHlgxcLqBKxpViPM53bLWLPuYnwSsVcH47EONuqotQH8P+RCp5KaQiumtAwtTJ2vWNWZkjQvaWX+15wptYlqAb3Pgef78UygFFFIKpxBq6Jf6gEzJ5n4NPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(6666004)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(66574015)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Gds44SH5Hor9K0y8OUvBn0utY7Wy9FrVo27qVYGpAIeYgZB1NeAC6DKBjGo27VOHfRTagQzWZOsy6ppUbgHXY0qsUtTgI/nh0p5gqhE8NlvuU7HnLUU0kopsjqSAuaw2oYQAlPgu8Ee5gcYY/A13Btk/h6Lo6h+4/B2oiItIkDeUE39/IhCbe9JNhoxgYA65ElI/bhCU6CWBXXWn65V04rv1d41+1xtg8v6vh1zXuck3DCPWhtW3yYjJDQtzUnn+n6YSTPlJVaGiagIkY8y3pV415JI7KuIV2IP3e5EOVRXEzKwiJs1k/R7utIx43s2+B8E0WYpn73raD+NjT306gZpOqbJFAGAz7AiFGGFXllOWnU1ZYNRgsEnYnKcHQTVoS+84/KBIeucdlXmN60Wku7Uz+nOhLi20bVHqHZZ8YaefWtBG1fGYVFF4Ym06DD24Lrp8DsL3S2I7Sy6HW8mpabHSNSY24d2mEyzW2761I15t55Vdr/0mk61kFd+Iveu0sSBcjuWNX/90mwbPKDsP+wKzTeUXDrzPg7El6TMKepadCTBtAHvavbuv+eUcd5HZFn4cN7Fn84IBfPJb03gGQVJ1HDNt8BodP7mrgqzv/a1lyTAttPF5Tz3F1/xsrSQjbn/TxejJNfaznV+ASLs3LA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e4dd50-8b03-4245-1426-08d85316fc06
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:15:45.7356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/eslpbxM1I3GNCEHrdMsH0J9kKLjV7pS4bJXsgnvqo5Up5iPhXQWcxyV9NwpbI8iYiHysWf/jzHvhJOXT/vjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0YXRlbWVudHMgaW4gd2Z4X2Jzc19pbmZvX2NoYW5nZWQoKSBoYXMgbm8gcGFydGljdWxhciBv
cmRlci4KCkZvciBiZXR0ZXIgcmVhZGFiaWxpdHksIGdyb3VwIGFuZCBzb3J0IHRoZSBzdGF0ZW1l
bnRzIHJlbGF0aXZlIHRvIHRoZQphc3NvY2lhdGlvbiBwcm9jZXNzaW5nLgoKU2lnbmVkLW9mZi1i
eTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRy
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCA1MyArKysrKysrKysrKysrKysrKysrLS0tLS0tLS0t
LS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyNiBpbnNlcnRpb25zKCspLCAyNyBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwppbmRleCBhODkwZmUzMjE2MWMuLjUwMjk2Nzg3NDM3MyAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jCkBAIC01NDcsMTkgKzU0Nyw2IEBAIHZvaWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3Ry
dWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiAKIAltdXRl
eF9sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsKIAotCS8qIFRPRE86IEJTU19DSEFOR0VEX1FPUyAq
LwotCWlmIChjaGFuZ2VkICYgQlNTX0NIQU5HRURfQVJQX0ZJTFRFUikgewotCQlmb3IgKGkgPSAw
OyBpIDwgSElGX01BWF9BUlBfSVBfQUREUlRBQkxFX0VOVFJJRVM7IGkrKykgewotCQkJX19iZTMy
ICphcnBfYWRkciA9ICZpbmZvLT5hcnBfYWRkcl9saXN0W2ldOwotCi0JCQlpZiAoaW5mby0+YXJw
X2FkZHJfY250ID4gSElGX01BWF9BUlBfSVBfQUREUlRBQkxFX0VOVFJJRVMpCi0JCQkJYXJwX2Fk
ZHIgPSBOVUxMOwotCQkJaWYgKGkgPj0gaW5mby0+YXJwX2FkZHJfY250KQotCQkJCWFycF9hZGRy
ID0gTlVMTDsKLQkJCWhpZl9zZXRfYXJwX2lwdjRfZmlsdGVyKHd2aWYsIGksIGFycF9hZGRyKTsK
LQkJfQotCX0KLQogCWlmIChjaGFuZ2VkICYgQlNTX0NIQU5HRURfQkFTSUNfUkFURVMgfHwKIAkg
ICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0JFQUNPTl9JTlQgfHwKIAkgICAgY2hhbmdlZCAmIEJT
U19DSEFOR0VEX0JTU0lEKSB7CkBAIC01NjcsMTIgKzU1NCwxNSBAQCB2b2lkIHdmeF9ic3NfaW5m
b19jaGFuZ2VkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAq
dmlmLAogCQkJd2Z4X2RvX2pvaW4od3ZpZik7CiAJfQogCi0JaWYgKGNoYW5nZWQgJiBCU1NfQ0hB
TkdFRF9BUF9QUk9CRV9SRVNQIHx8Ci0JICAgIGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9CRUFDT04p
Ci0JCXdmeF91cGxvYWRfYXBfdGVtcGxhdGVzKHd2aWYpOwotCi0JaWYgKGNoYW5nZWQgJiBCU1Nf
Q0hBTkdFRF9CRUFDT05fRU5BQkxFRCkKLQkJd2Z4X2VuYWJsZV9iZWFjb24od3ZpZiwgaW5mby0+
ZW5hYmxlX2JlYWNvbik7CisJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9BU1NPQykgeworCQlp
ZiAoaW5mby0+YXNzb2MgfHwgaW5mby0+aWJzc19qb2luZWQpCisJCQl3Znhfam9pbl9maW5hbGl6
ZSh3dmlmLCBpbmZvKTsKKwkJZWxzZSBpZiAoIWluZm8tPmFzc29jICYmIHZpZi0+dHlwZSA9PSBO
TDgwMjExX0lGVFlQRV9TVEFUSU9OKQorCQkJd2Z4X3Jlc2V0KHd2aWYpOworCQllbHNlCisJCQlk
ZXZfd2Fybih3ZGV2LT5kZXYsICIlczogbWlzdW5kZXJzdG9vZCBjaGFuZ2U6IEFTU09DXG4iLAor
CQkJCSBfX2Z1bmNfXyk7CisJfQogCiAJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9CRUFDT05f
SU5GTykgewogCQlpZiAodmlmLT50eXBlICE9IE5MODAyMTFfSUZUWVBFX1NUQVRJT04pCkBAIC01
ODUsMTYgKzU3NSwyNSBAQCB2b2lkIHdmeF9ic3NfaW5mb19jaGFuZ2VkKHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAogCQl3ZnhfZmlsdGVyX2JlYWNv
bih3dmlmLCB0cnVlKTsKIAl9CiAKLQlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0FTU09DKSB7
Ci0JCWlmIChpbmZvLT5hc3NvYyB8fCBpbmZvLT5pYnNzX2pvaW5lZCkKLQkJCXdmeF9qb2luX2Zp
bmFsaXplKHd2aWYsIGluZm8pOwotCQllbHNlIGlmICghaW5mby0+YXNzb2MgJiYgdmlmLT50eXBl
ID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04pCi0JCQl3ZnhfcmVzZXQod3ZpZik7Ci0JCWVsc2UK
LQkJCWRldl93YXJuKHdkZXYtPmRldiwgIiVzOiBtaXN1bmRlcnN0b29kIGNoYW5nZTogQVNTT0Nc
biIsCi0JCQkJIF9fZnVuY19fKTsKKwlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0FSUF9GSUxU
RVIpIHsKKwkJZm9yIChpID0gMDsgaSA8IEhJRl9NQVhfQVJQX0lQX0FERFJUQUJMRV9FTlRSSUVT
OyBpKyspIHsKKwkJCV9fYmUzMiAqYXJwX2FkZHIgPSAmaW5mby0+YXJwX2FkZHJfbGlzdFtpXTsK
KworCQkJaWYgKGluZm8tPmFycF9hZGRyX2NudCA+IEhJRl9NQVhfQVJQX0lQX0FERFJUQUJMRV9F
TlRSSUVTKQorCQkJCWFycF9hZGRyID0gTlVMTDsKKwkJCWlmIChpID49IGluZm8tPmFycF9hZGRy
X2NudCkKKwkJCQlhcnBfYWRkciA9IE5VTEw7CisJCQloaWZfc2V0X2FycF9pcHY0X2ZpbHRlcih3
dmlmLCBpLCBhcnBfYWRkcik7CisJCX0KIAl9CiAKKwlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VE
X0FQX1BST0JFX1JFU1AgfHwKKwkgICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0JFQUNPTikKKwkJ
d2Z4X3VwbG9hZF9hcF90ZW1wbGF0ZXMod3ZpZik7CisKKwlpZiAoY2hhbmdlZCAmIEJTU19DSEFO
R0VEX0JFQUNPTl9FTkFCTEVEKQorCQl3ZnhfZW5hYmxlX2JlYWNvbih3dmlmLCBpbmZvLT5lbmFi
bGVfYmVhY29uKTsKKwogCWlmIChjaGFuZ2VkICYgQlNTX0NIQU5HRURfS0VFUF9BTElWRSkKIAkJ
aGlmX2tlZXBfYWxpdmVfcGVyaW9kKHd2aWYsIGluZm8tPm1heF9pZGxlX3BlcmlvZCAqCiAJCQkJ
CSAgICBVU0VDX1BFUl9UVSAvIFVTRUNfUEVSX01TRUMpOwotLSAKMi4yOC4wCgo=
