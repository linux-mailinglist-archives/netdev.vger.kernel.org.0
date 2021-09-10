Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F509406EA3
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhIJQGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:06:51 -0400
Received: from mail-co1nam11on2081.outbound.protection.outlook.com ([40.107.220.81]:23264
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229698AbhIJQGr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:06:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuHjhkD1jkIACHTmey6dRz0jGniLo4HSfO9Yvc37yyK8efQxK9U9z9BCjfXpADWaDZTF94+UpqPe9nvdzOlkginmK3H5J/bvT/gHLX92MKJHCdQgK3JmFmcNbedPQPwm5EVoN46LIwtypFpeWW1j1L+uB3Xj2KeO6mkDbWz5UGWYkbWdE6Du/Zu45Yj3fLNUi6dfH/HCm20A+GdyGSsXdU14rA2tRcOAlP1ZyVHsp7fFbWOZVwep50cjaXlJDxHyBjAr18WPHpDLS83c1VOKE/FDelvkQfEA3RBguFcspNYIk9KIusfyCv7F3cZwb5F+TUvSBxO9lxw1BMiP0qNFAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=W3xhbbkCQnf2vd3TochAY9N0f/ZMLhJVqHh1xnxRZkk=;
 b=Q19fZY1KTLfidtu8KdQBQmnBYGadMrJ8j1aBC90JTF+xO1AuvHVAmsDRkisG/vre0LtyQTZ8BZyrLkKgXVCh/quRY2OCIP2GSutEtTSOozsgZjgJhnPsOEJxXuiOTj+AAMwnApd6kMRcanETSdaVAGufEG6b9zKsNrNdE3PDPV2bfc9qRI27kY5v4mtailHZct3kcI28XKHV/AsoKs84f9b83bGZPh1BdgoPduyyqvar0m2dFZNEBeAVSuVv0osoobkM9OWKtns+zHSZduP1x1+WHJkpsouHwGRaew9KgW+voMlH7HM9wsx5nNcTzUrjrjV112CtwVKOTtds+V8ejQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3xhbbkCQnf2vd3TochAY9N0f/ZMLhJVqHh1xnxRZkk=;
 b=L87qdB3NMetYTccwj5MRSqsz9cUAxXoD7NSHoIDMM9xuhwFYvKoDMznjs9SwteyR33W2OAjaAVSirRUxQ6gd5TrTAItVwzQg4ybgI1kxcsQp5jFWMxqm3GG0+LbvwugLwdMwn8eCYU2x82gVDB4KJUUb7AEVwIeALm7jg6ju3u4=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4592.namprd11.prod.outlook.com (2603:10b6:806:98::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 16:05:35 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:05:35 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 02/31] staging: wfx: do not send CAB while scanning
Date:   Fri, 10 Sep 2021 18:04:35 +0200
Message-Id: <20210910160504.1794332-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:05:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0faf153-c32e-435f-4a62-08d97474d2b4
X-MS-TrafficTypeDiagnostic: SA0PR11MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB45924643F3B86A0557760A6D93D69@SA0PR11MB4592.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5i/7GfUt+a40poWp0Bja3ajvWQO8nUeQDrkcdVajrK/rlNfIJycZL+HabYFEup3FOvok89BKROgNxIZ4JwEJi4yE98bdOJVb7X2A4Y1C2F0mEQi3DINcgOqLIcRA6hcYugFDkJsWT1B0/PzZCYhlU80/+r40hromxws0M7LcsoSMNyNBOJScUPveq1NLT0xt1LKTZtoyMCEjlDyINWINm8/9xevgWr8MdnoKY6gMDH6AzHUktRR9fzEnc+mRvYtfU8OEfYSh7kXpv6fPzvx47AU3WIBpSv69nYSXzn7GlcTcoateOG6tLPnKVjxukumlgwir3kf5dwEMOR4yKU582O1I9QQUlmuIRfMTjfxD3ijeWLqL4wkntz/S87WbjDXL1VXcop6g6ZBsjzHfl7eVKfS5ZnM/3wSE0L2HQDESJna6ud0FIzEvslRAvnsCf/GLuINVv314ekO/ExkTDN75YV7FzCsc3jxCYVp8w5vOzAhGrsAGzjhWZ2lGCsY+8Pw8thwheuLeUvsK9T8C17HtxwjJl8Y7J8+XuGU8kk2ZqwnuKsT6W8D2aUd03saP80nuuD7GWMs4zGfNHoXQbuElqT24JwQxX+lk+D6ZeAGMmfJFnMJT2uLY57CN2xDPkth90QOlgvozZ+Flrnnuyf4cpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(2906002)(66556008)(66476007)(316002)(66946007)(83380400001)(66574015)(8676002)(8936002)(36756003)(86362001)(6486002)(107886003)(7696005)(52116002)(54906003)(2616005)(5660300002)(4326008)(38100700002)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFBxSlFTRUx6b0dMeDJWVlhrWGhLRnVnbnNQbzRXS1lGeGNCTXdkM0Evc1Vh?=
 =?utf-8?B?ZEh6aUp6a1pZR3d6emFIU2NHZEZ3U291bG5wRWdtWDErd0NWNVpTZDk5QUY4?=
 =?utf-8?B?NTlpd1hzZWYyTXZYQ1VzdnVoeUkxcnZMdTBkSDIzNXNhNWRXK2ZpNTRQamUy?=
 =?utf-8?B?dkNLZmdCNWdUVitDU1dIdldnbSs1MDNnNHNodDEyRUZwSnRFUjlBNDJaWTln?=
 =?utf-8?B?cjBHNElVeDBFaVE2Tkh3KzVJYXZWMzVodGxaK3A2bjdJekFzSHpDZGEwbkZO?=
 =?utf-8?B?c09aMEk5SUVQMklNRnRQTVh3SzVQNzdCRVpVRGF1cEd0SXNNajFWWW1IazV5?=
 =?utf-8?B?Yzdha1dBL1cwdFh2UUp5MitibjMzdnYxUXFKVFNvVkJYTmZsYTh0anVvZlFC?=
 =?utf-8?B?K3ExTVhJQXFvak9zNVNNZEltNWhjeUxLRVRPRnR3NkhuTlY0a0o0ZjhVR0Q3?=
 =?utf-8?B?OUU5dzhYRUVpS0dDTGZ5S0g0TTdRT3hUTTF4UDlpMUN3eER1aEcvQS9hMHQ4?=
 =?utf-8?B?VVQ1aG9WWEgxdjZCQ2t0bjdwblhmUnpXNkZjTXJXQTB0S3ptSUVrTURxSEFC?=
 =?utf-8?B?UXlBenZ4bzZWQ0R4Vk50UFNmYU9sYS9DanR5ZEJJSldZZm9ndVF1WkYvNENB?=
 =?utf-8?B?VjZFVGVObXBqVTB0K0lKYnhlVjZNSVdZdHFZQnhLSDJ1M3JHSG5YdnpZZEpy?=
 =?utf-8?B?c0hTTWlRaUNQbGlnL0tPWDdObDZVWkVubmJqSkJEUmwzQ0JKYkdBSG8rSFFj?=
 =?utf-8?B?ZjhWRTNhcDU5QlNtV0NDZkRoc0kxd1A5Qk5lRDZZdDFYNHN5UmVQQ0RobWsw?=
 =?utf-8?B?dXJ5RlhLODQzc2t6aFluMjlaTTlDQnN2RzMza3FKQ0ZQbXlPQVZWY1NXYXUz?=
 =?utf-8?B?akRJZEw2dUxPMGJ6d2lneTRYamZpeGtBd3ZqTTN5Q2J1ZVU4U3k4NkNuc1VT?=
 =?utf-8?B?Y00xQmdNNXBFcXl4VS95bEcvdWNXcVRaVlhyVElSV3djdjhpK1hnRWNnRzJj?=
 =?utf-8?B?cmFPbnBQT1hGbXlxZXVFdFkxYlBpRmtwVDk5SHBHOWNSbGVWdElUQ1pMQ2hs?=
 =?utf-8?B?RjhpN0ZqME51ZmNSVThRYVlzc3Z4cmpNY2NNdXNwTXNyQVVJQlAwYjFveDZW?=
 =?utf-8?B?YTF3L1N3KzV6b3ROTFhCSnJCYnZ3dzBpaDlPVlduekdEYUxzdzdwcnV0YkdS?=
 =?utf-8?B?M3hWa1N1aW5mVGNrRStOdlRUNWRma0xEU0JOTXNvZWw5WkwzZXpUMytmUTZz?=
 =?utf-8?B?azE1VUxQNXRGRWJ4endiVWYybzB3dVRUU3RwdkJBOGF5Q1FFYjVlUDJONFlV?=
 =?utf-8?B?eVZFQ0Fab0h3dGorZXhLYjYrdFcvdEowT0YwVE5vU0Vsc2MreW5DQmxpb080?=
 =?utf-8?B?SXFwa0dYTy9QcURsenVVcXZXLzcyNGZmZ2pLLzRCZWdBUjZKMXpndDJHVTJk?=
 =?utf-8?B?OEEyZENRWDFpZVhZZ3dFRm40d1FGV0ZMVDZHSENtVzAxY3dEcVRxWngyeUxR?=
 =?utf-8?B?L00wckN4bUFkdThYcEYwQkJONVoxemxCZWlUOU94S3NsL1gxbVd2dXorUTd5?=
 =?utf-8?B?MDBzbjlqclhvK3E5aEMrUDFKcjZLMjVYUHNNaysxR2p4bngxZ0EzcWRCemJv?=
 =?utf-8?B?T01BaGI1L1piVGdVR2Q1U0FvOTJreG8xQ3VNeDV6d3dSSXRXdFl5VU9YQTVn?=
 =?utf-8?B?NU5PUG5zTmllUHhVRXE3Z3d2TGE4SWNWdkFUOVNTclErSWduZHR5TjJ2MjZs?=
 =?utf-8?B?cmZPMWRzeGRkVCtnVXEyMG5ZL1JENlhtR0ltTkIxV3R1aldMaW1CVUdrelY4?=
 =?utf-8?B?cCs2dnVTUktlRW91ZE1FL0c5U3NtcHcyUGZkZ3hsbms0YWRDTmpHRTJIQ1Vt?=
 =?utf-8?Q?H9gvrz+7w2FyE?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0faf153-c32e-435f-4a62-08d97474d2b4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:05:35.1923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VS+Z512qR3UvN//OaPndQLct8AYIvkPaf39jVCjtnZ9NEFgs49gFh23TpE4R6fcre+P7HxGbi8bq7Ry94weVLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4592
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
d2Z4L3N0YS5jIHwgMTAgKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMo
KykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYwppbmRleCBhMjM2ZTViYjY5MTQuLmQ5MDE1ODgyMzdhNCAxMDA2NDQKLS0t
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jCkBAIC02MjksOCArNjI5LDE4IEBAIGludCB3Znhfc2V0X3RpbShzdHJ1Y3QgaWVlZTgwMjEx
X2h3ICpodywgc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSwgYm9vbCBzZXQpCiAKIHZvaWQgd2Z4
X3N1c3BlbmRfcmVzdW1lX21jKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBlbnVtIHN0YV9ub3RpZnlf
Y21kIG5vdGlmeV9jbWQpCiB7CisJc3RydWN0IHdmeF92aWYgKnd2aWZfaXQ7CisKIAlpZiAobm90
aWZ5X2NtZCAhPSBTVEFfTk9USUZZX0FXQUtFKQogCQlyZXR1cm47CisKKwkvLyBEZXZpY2Ugd29u
J3QgYmUgYWJsZSB0byBob25vciBDQUIgaWYgYSBzY2FuIGlzIGluIHByb2dyZXNzIG9uIGFueQor
CS8vIGludGVyZmFjZS4gUHJlZmVyIHRvIHNraXAgdGhpcyBEVElNIGFuZCB3YWl0IGZvciB0aGUg
bmV4dCBvbmUuCisJd3ZpZl9pdCA9IE5VTEw7CisJd2hpbGUgKCh3dmlmX2l0ID0gd3ZpZl9pdGVy
YXRlKHd2aWYtPndkZXYsIHd2aWZfaXQpKSAhPSBOVUxMKQorCQlpZiAobXV0ZXhfaXNfbG9ja2Vk
KCZ3dmlmX2l0LT5zY2FuX2xvY2spKQorCQkJcmV0dXJuOworCiAJaWYgKCF3ZnhfdHhfcXVldWVz
X2hhc19jYWIod3ZpZikgfHwgd3ZpZi0+YWZ0ZXJfZHRpbV90eF9hbGxvd2VkKQogCQlkZXZfd2Fy
bih3dmlmLT53ZGV2LT5kZXYsICJpbmNvcnJlY3Qgc2VxdWVuY2UgKCVkIENBQiBpbiBxdWV1ZSki
LAogCQkJIHdmeF90eF9xdWV1ZXNfaGFzX2NhYih3dmlmKSk7Ci0tIAoyLjMzLjAKCg==
