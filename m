Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFA740868B
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238083AbhIMIc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:32:28 -0400
Received: from mail-bn8nam12on2070.outbound.protection.outlook.com ([40.107.237.70]:61217
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238048AbhIMIcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:32:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fSmbgsVr0AOlbXywbqbjbhOwzaoNWXa20Ku1NyM5mRRH2CL2r8r+OYDiyOquY8h7DEFAozT2HCxl3i23RFrpEV/LtagfEh0/n6ytz3Ge89MPXSay+wayryBuawFoOYLH9RteBrg7oxhw7ZFBKXWWmVQ3rDmlnuwgcnW2CGLlWtiw1Ovq7IkzplAOw+YGTKcbCPC62xrq2UiOkQjx/olHUddDSHmM9fiB8TmU3Gsw5OlSS2f2pQq3aNRoscTBiykymNnkQOtzKOP+KWT8Vb7KpbfA6PbwwpO8MpoplkxfV69jSJnH/9kID6t+atQmE9ENGAHMsC+zeIqkO1iE1N7qfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3TsJ441Hxc5w6kwdECytocZuGWRAv1M22Qp1aIMK6mk=;
 b=dzRg2PSUSC31gMa/fJMHAru5F4S7o507LtOVzY43EeqoCBBe3l7L0x6K0W5ktHrSQ+JB3vHB+shXbKHOyWVM5dmY4HRwZnmy7rJWRaka9ozq4KPoGzyvcIUlOGqDOH86wpOX/w308cLOHvKZPhExVFRWhSXgx88dSRjaMsOQtxd1xxQzpyBypGS8JgjetbtWYH6tCdol5rnVkK0uGcLbZN8NeGemcZLr5QbIVDx86/eNGel3rwJQwujLnREAFysf3X1J0mKjpO3XhzEBE8kaLnsf0cK7UnV9WRiUz/GnIBLg185BElSpfCqUd63qE746XrgOp0Gz9z3100FyacuAUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TsJ441Hxc5w6kwdECytocZuGWRAv1M22Qp1aIMK6mk=;
 b=CPmf60byl1bCyyXm4zPW8+sg5nmI3JotNpdJgMi2JgpZ8MeCxLvrOyI+YIxpEeSN5/HRknZJZBhV7m84U/JFViNu+i7uuwteo2IoDtCYkioGk2keBbR+ABmjycqOLMvjhCzJbHYsfjcsofDW1DnNP96cfVhqRgvIjzb8vFptmwU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:07 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:07 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 02/33] staging: wfx: do not send CAB while scanning
Date:   Mon, 13 Sep 2021 10:30:14 +0200
Message-Id: <20210913083045.1881321-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8604fd4-5d78-4d75-90de-08d97690d517
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3263552C8058F90137FF463993D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fuX4Tu7ugrGwpJAQvpJVwRUGk7yQJ4d2BNFA1FuC9vWSiEkdDsLubw6L3kwa+B5ZPmAHN3E7MDVfSST0AYBx6FgIHfui/n+/ocHwcCQxAg2W0BNGca1KNLRSRuBxkylLDiAumUIGB7an4U0/Y9SI+RJPAXwOBBHwTqVYSCY4MyEUPoybtjDM7NY43pPS8uXeOx2VTnmC1LcvvExfVcr6flF0jo7Yv1e56vWdUjWlpcjzdxXzN4RgTRMJ+z7NZl6rvSSxeaMOsdU6xOz5rgtfsQ+mZKyxXyLyuzI7OiRNP5UaKLfEdb99c2Pa1jWb5cYa1AXT0VK8gjYqvzU1GXUb1LcTgfZgbOTnqMSdMBaVNAVtuvbLNwLQBO7v9fi+ZKS2r8MECw24T13OZ8cdSj+YTn1GtOOpluL0kAV1z0CBkQHPVmab9tLkUsUBvoWgeQDDA3kS6cehtJqw+w0vpprjrTPmkdLOyixgfseDcH5zTqrWozln52SUrUMCukCtefUTcIO9YP4LhAG1tpdlbuMP7019DLNGy1gSNnI7amthl4qhiJN15Jq3M7o2jlb2nulNnl34ybJZCSWrh8ViJ+fwyI6tKVgvj6sc37oI8Zd4ldWNctH4bzXz2yklhtCL6hwhwDO02kVogBg2KPRYvt7fL2u88ChrpUuSvuBuPJVdfAUNQD7GExbSqRcOfnqkeVQ1V3JACXn14KkEqwxh66ijoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66574015)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(6666004)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVZEMHgwaFN6eDFvMTBvaTBBMFZRYThjVStyUUpvSDJXTzVFOGgxRVNPZCtK?=
 =?utf-8?B?N1R6SjJndlhQUHRDUWlDTTFlVWVyenQ4UUtZaFJud2d4RFYwN1Y2ZzM0VXRQ?=
 =?utf-8?B?UEJ0c3UrUjJ4RjgwcmpGOFJGdmhORm9QcFFQWmJIY1JkTGI5VkZabExPNnBm?=
 =?utf-8?B?Q04rUmh0QXBFRFB0Nit5aE93UlV5NkhxNTRkRmt6RGNnL1l5UTdsN2xFNy8y?=
 =?utf-8?B?SE5OMTBibWNnRnZyYThMWlhNUjZEbHdQL1VubmNTWUc0eFUwazN3QTV6MWZV?=
 =?utf-8?B?S0tNQzZIUWpOWlN0WjBXUzdybFY4cjZkRm5JRG1JbXl0ZEdxa2NoNHJhMllr?=
 =?utf-8?B?VzltaVRCR1RERmFTVksvdUs3MXZkVGpZczZhZVNzQlRrdm5CVzlJd1hrbnpK?=
 =?utf-8?B?SEdjTHZvK3hoTUdQamI4QzhLWi9YZXdycTlyS3JiU2p5MjNRc3g5eVZjdVhs?=
 =?utf-8?B?ckxxdVI4cnRIajdSRlpDS2txZ29YRVBCaW9uMkc5TU90aER6MHB0WW5Tb1g5?=
 =?utf-8?B?eVBSZVN3S1VzdTFwTzRNMitndkY4eHBtTW1VQWdiREJxa21IMTJWczI2aHVv?=
 =?utf-8?B?RDRLSjc2cThqYnNWelh5Nm5xT2hVN2d4VHFMQitXTmFybXdyL1JjNFdJbmM4?=
 =?utf-8?B?WG1IcENFWlk0WEVVdWJSNDJJNjdVOEhoaDNyZmZHcytrRnJYbUwzanU5STlu?=
 =?utf-8?B?eWQ0cWw0QjdvOU9YblpzVms1ZFl6clVVM0VsMEZuWFZvejQzOFNNanJ6NVVH?=
 =?utf-8?B?QXBKdGNWQTFjMXZ1NWxieFlHVFFhVGl1K0RKTFBlTGpFYmZIR0plYUk2bS9w?=
 =?utf-8?B?SHUzaWdidUhWZ0hEcVJZODN0blk3OUVPWW1XWUtBdElXd05RT1ZkdW1kaEZw?=
 =?utf-8?B?SncvYU91QlBZdzlnckh0NHJwK2gvZ2tSZTh0UXJVTmdZaGJjUVF3THFJUWxT?=
 =?utf-8?B?a2Z6Y3g4TjBhWUc4ME1aUHlpRDNlaTdQN3pld1JuQmt4VmVQSkUwQ0dmNnRl?=
 =?utf-8?B?ajNuT1c3a3ZzTnk1RG5CZ0JiZzlNdjZlZVgvYi9Jb2J4MTk0UWRsdXRmNXpT?=
 =?utf-8?B?WitBSFQrcWp3VHRTUmlXSUMrK0NnVlVnVWY0ZXZIVFNOTnN0TU9EcklpWmg4?=
 =?utf-8?B?emsrRnQ4NzZENVZEVzdJMmJUenpTOVRNWG1ZcHNlNVhxSW9ZdzRyeklEYUdU?=
 =?utf-8?B?eVBubEFlUXZWNndxQzllR1N6SmV0cVp0L1VJcUp1NmRXTVEveG9PTk1Vd1Bm?=
 =?utf-8?B?dmhMcnFNUTlmNExYL1ZobEUvK0QvWnlWV0p4VU5vM1o0R1BUZUxsYjZReGVw?=
 =?utf-8?B?azdQcE9iRTZjUERWRW51eVRoWHFWQWI4UWdPN1RFRVdES2pmVjFqbjBzejFi?=
 =?utf-8?B?bVRnLzFwOTJkekxkUHBLR2FpSVh1WlgzQWlqc3Q2VHBoZmRyUGRuamRlQ2tS?=
 =?utf-8?B?SVc4b1JyWVgzWUd1ZXZta0FpM0prSk9KdWp1aUdGd1R3V1RKNm5yd2J1UCsv?=
 =?utf-8?B?YXpKL2ljUW94TTVROFNoRk9GUGVNaXgxZHhBVGZ3UWt1aUVmMmZDZmh4WlBG?=
 =?utf-8?B?U1d1T0Z4Y1BOL0xRd0RCSkFrQ0JueVZPQjRpbnFpZEhjUXNmcmhuWFh1c2N6?=
 =?utf-8?B?NXNqNUk2NzNhS0YvQTc0YVluSEFpVlI1aUxSd1I4eGg4UmRoSnJOOFZETWQ4?=
 =?utf-8?B?a21HNWJ6M2NmamM1ZnFMTEkxL3RQN2xUU0t6Ym45ekNTY0NMT2ovVTNqTklI?=
 =?utf-8?Q?/IuyimV13OlZ7kLqyoImIqI5j5nt6E4szH4suag?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8604fd4-5d78-4d75-90de-08d97690d517
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:07.3344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rgjFfsh/iDSFY0I6nOO1wUSG4l4Ge9YcL/INlKjzwr/PTIMWK9QMQk6LALvf53Xac0e+stspsk1C6OLgIiCecw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRHVy
aW5nIHRoZSBzY2FuIHJlcXVlc3RzLCB0aGUgVHggdHJhZmZpYyBpcyBzdXNwZW5kZWQuIFRoaXMg
bG9jayBpcwpzaGFyZWQgYnkgYWxsIHRoZSBuZXR3b3JrIGludGVyZmFjZXMuIFNvLCBhIHNjYW4g
cmVxdWVzdCBvbiBvbmUKaW50ZXJmYWNlIHdpbGwgYmxvY2sgdGhlIHRyYWZmaWMgb24gYSBzZWNv
bmQgaW50ZXJmYWNlLiBUaGlzIGNhdXNlcwp0cm91YmxlIHdoZW4gdGhlIHF1ZXVlZCB0cmFmZmlj
IGNvbnRhaW5zIENBQiAoQ29udGVudCBBZnRlciBEVElNIEJlYWNvbikKc2luY2UgdGhpcyB0cmFm
ZmljIGNhbm5vdCBiZSBkZWxheWVkLgoKSXQgY291bGQgYmUgcG9zc2libGUgdG8gbWFrZSB0aGUg
bG9jayBsb2NhbCB0byBlYWNoIGludGVyZmFjZS4gQnV0IEl0CndvdWxkIG9ubHkgcHVzaCB0aGUg
cHJvYmxlbSBmdXJ0aGVyLiBUaGUgZGV2aWNlIHdvbid0IGJlIGFibGUgdG8gc2VuZAp0aGUgQ0FC
IGJlZm9yZSB0aGUgZW5kIG9mIHRoZSBzY2FuLgoKU28sIHRoaXMgcGF0Y2gganVzdCBpZ25vcmUg
dGhlIERUSU0gaW5kaWNhdGlvbiB3aGVuIGEgc2NhbiBpcyBpbgpwcm9ncmVzcy4gVGhlIGZpcm13
YXJlIHdpbGwgc2VuZCBhbm90aGVyIGluZGljYXRpb24gb24gdGhlIG5leHQgRFRJTSBhbmQKdGhp
cyB0aW1lIHRoZSBzeXN0ZW0gd2lsbCBiZSBhYmxlIHRvIHNlbmQgdGhlIHRyYWZmaWMganVzdCBi
ZWhpbmQgdGhlCmJlYWNvbi4KClRoZSBvbmx5IGRyYXdiYWNrIG9mIHRoaXMgc29sdXRpb24gaXMg
dGhhdCB0aGUgc3RhdGlvbnMgY29ubmVjdGVkIHRvCnRoZSBBUCB3aWxsIHdhaXQgZm9yIHRyYWZm
aWMgYWZ0ZXIgdGhlIERUSU0gZm9yIG5vdGhpbmcuIEJ1dCBzaW5jZSB0aGUKY2FzZSBpcyByZWFs
bHkgcmFyZSBpdCBpcyBub3QgYSBiaWcgZGVhbC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jIHwgMTEgKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25z
KCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMKaW5kZXggYTIzNmU1YmI2OTE0Li41ZGU5Y2NmMDIyODUgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYwpAQCAtNjI5LDggKzYyOSwxOSBAQCBpbnQgd2Z4X3NldF90aW0oc3RydWN0IGllZWU4MDIx
MV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEsIGJvb2wgc2V0KQogCiB2b2lkIHdm
eF9zdXNwZW5kX3Jlc3VtZV9tYyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgZW51bSBzdGFfbm90aWZ5
X2NtZCBub3RpZnlfY21kKQogeworCXN0cnVjdCB3ZnhfdmlmICp3dmlmX2l0OworCiAJaWYgKG5v
dGlmeV9jbWQgIT0gU1RBX05PVElGWV9BV0FLRSkKIAkJcmV0dXJuOworCisJLyogRGV2aWNlIHdv
bid0IGJlIGFibGUgdG8gaG9ub3IgQ0FCIGlmIGEgc2NhbiBpcyBpbiBwcm9ncmVzcyBvbiBhbnkK
KwkgKiBpbnRlcmZhY2UuIFByZWZlciB0byBza2lwIHRoaXMgRFRJTSBhbmQgd2FpdCBmb3IgdGhl
IG5leHQgb25lLgorCSAqLworCXd2aWZfaXQgPSBOVUxMOworCXdoaWxlICgod3ZpZl9pdCA9IHd2
aWZfaXRlcmF0ZSh3dmlmLT53ZGV2LCB3dmlmX2l0KSkgIT0gTlVMTCkKKwkJaWYgKG11dGV4X2lz
X2xvY2tlZCgmd3ZpZl9pdC0+c2Nhbl9sb2NrKSkKKwkJCXJldHVybjsKKwogCWlmICghd2Z4X3R4
X3F1ZXVlc19oYXNfY2FiKHd2aWYpIHx8IHd2aWYtPmFmdGVyX2R0aW1fdHhfYWxsb3dlZCkKIAkJ
ZGV2X3dhcm4od3ZpZi0+d2Rldi0+ZGV2LCAiaW5jb3JyZWN0IHNlcXVlbmNlICglZCBDQUIgaW4g
cXVldWUpIiwKIAkJCSB3ZnhfdHhfcXVldWVzX2hhc19jYWIod3ZpZikpOwotLSAKMi4zMy4wCgo=
