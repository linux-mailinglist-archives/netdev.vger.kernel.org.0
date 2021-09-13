Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544A1408B8A
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238630AbhIMNDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:03:52 -0400
Received: from mail-bn8nam08on2055.outbound.protection.outlook.com ([40.107.100.55]:54369
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238235AbhIMNDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:03:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDhIJaAIz3IGiTO0VYKvWmyMbwwYVeVkMKSsr1ReCN82B3STwjTcm8+iMdIIE02ua8ItpZA39pUsOuWZFQQBOBlr7KolO/uv+2uVi5/R6QT6tnRU9bT8gW67yvSGfCBVHER3l7W+wEUkiThfodghqbUtJB8zgvqsh3vHUVpPX9/rQZtTRJt70h+AeuGhDezTVknPDXkpeY+5q6EfFWAFKpyJnMcc6bitWZ88T0C34HcvYvOdB/l1X/eV7uyfgqZ3WVTPC/EL+GhOZcEZlsp5LEB9xahv8ixaC6gZLpAM/6wJqZZEz7rDnxLlkvYU+l8yRxR9tnG83ZlpHAc+s6M32Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AmCqsbY3AiU0YiEAlz93ibGj/lSsD0m2Srcg44MoTrQ=;
 b=f3e9bzoPIadgok4mVpDF/az+bY5QV6M16yGGzSp/zkDZYViPfkgNGrM23kGZvXX0PdGi0HTEIeOUMS4Rn++IS9+DARvS9Fp6WSrosYU0aeU3OqvX+bz9ewK7TWh76XoBZsQDJlMupCmGmPVfIolNvDXiwzDJrd84IKBYX1pKJxdZAOCZhlU2WbyMav58IVqDmMpw6xREDulRcqg2CbNigld8x4DE1MJLhr3Drchowd6Cv1n9ID2YUfM6xb4/Y1cPw7H8WlAE7+qvKOvq7ClG6a3xP7Lb3SvmhsztAP+L/jh2lxWz8/8G8wop3gjElwxGCdsU0MDlv1xujKY2zjVcSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmCqsbY3AiU0YiEAlz93ibGj/lSsD0m2Srcg44MoTrQ=;
 b=QDZ4fxs/MuJv5JFpZb85RwN5+Ux9YSHrCDnCaxNGYBH+AzNjPOd6kn2gpASqUy4tJ+cSZy30bOnTwInvjFn+XrsyD1ibe8a5KbA0rsldIcdXUoVitv3XHOO9pMUGWhAjewacN4GpcbyhMiqSQsxZuPEb1epZ66TqYdZo1tlElLQ=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:24 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:24 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 04/32] staging: wfx: wait for SCAN_CMPL after a SCAN_STOP
Date:   Mon, 13 Sep 2021 15:01:35 +0200
Message-Id: <20210913130203.1903622-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16814723-fed5-469b-b454-08d976b6baea
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB48606BB3380146206C5C0DB993D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ggVBmqoy/QHjgqy8zapkjjJnamggkUS3drCd7NnNKe8p/OfBI97LUvJgawpof4hmVqHw3dOwjMSM8T9JfRKBkjG2cWrwvNcKkDvZQv4O6yM0OXEr6Z3KdZeXWqJw8jEK+ta4hp8npQSo4LwMnwfbv9vZEdMNXYo8Ov8pjX6k1T2LvwzHelJ1pa/PY9I8gD3O/gzXmSLssRWXN2shxstiXA6mk8bB3mMbBBkSQbDzOQY9hzb8GcElgIIekOoRPT7Jb1/R0PEaw3oa8cX1FFy1FvKZyGlaiRP0O70tjCYdySfeWXHTIyUuZU+RfNX3eL1ZuDTfur796gXXQwYTg3OvMpFwfmNpoN5CsTs1ogxjWL05fRW33li+Qz2m10286LZTgYOd16m3gwweG7PyXakkpxPWlhyXbmfaDIP/gZLRnu6RjLkDVzcKZStitl1o0AKkJXv4ngZGLAcvteCpKS+CQAyyodPTb15ZzX3+QGMnk0WRGlUVru4Zmw5iKAw0eYdtZFESZyjaIJlKxSVyq0GKKwYG3no5GKoWY61U/KhkN3ERspsaQuaK059FOdv8zfMsCmJQ/GO5mp8tIS1YyeQ+PEzjScZCFDQCWp9q/T55sKMW071MJvZmxFE81z90E6TBP21ug0l/DlajKEV4oq4DF/gPJZ9oBlrKOiqxpvIdW3yFofJ0JxFopKnciEyPXv26zXAFP93SB5JcFuvyUS4WRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(66574015)(6666004)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(83380400001)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eW4rNGIvc1JlNmQrcDI4MlVzU09UL0JMV0dFcExuWHl1WFFYQ3lYWDFZakh0?=
 =?utf-8?B?UWRycElPcERwR3owaUR0M1ArNTFFZFpVN2pCTk13SEp5YXNibDRrUExWakhZ?=
 =?utf-8?B?eFRhVHBOTmJVakhicVd1UkdtRTFsM0xMODc1QWhYcmdQZkRzVkxVNzN2WFJI?=
 =?utf-8?B?Tm5SbDRwYzhCNi9kQ2tGQWRVSGtXS2FuV3NnUDQzaEpVampTdGdOcFlSNjRv?=
 =?utf-8?B?RXJKM0ttTXZwYVlib05QM1BIZTRQa0txckpiQ1ZwSlNHMDAzUW1NY1ArZWdH?=
 =?utf-8?B?aXoyKzVHMU1MeTJDaWE2eFpudTlTVmNaRzRaeHhOK1o5dmwrU01PVmhidlF3?=
 =?utf-8?B?NTFnMWFWam9ET2p1R2FPVzZuUllzWGhuUzcyd1E3QXJSMlVFNmMyYS80L3li?=
 =?utf-8?B?NmtMUEpQTHE1SE9YQ1JEUHZzOHZrM0FEZnNlKzRnNSs4bmtwSktLWERzSnl6?=
 =?utf-8?B?aFdiRmh5THNFNzZpcDUxaU9YMUptTFhSTW5JOVNOMjlHa2l6M0c5U0FKS09Q?=
 =?utf-8?B?SVY1K1FKQW1aQXBTWlBSL0ZiZTZEckxxUUNsWUllVXgrNGxWbjJYUUt0Ti9Z?=
 =?utf-8?B?cTU1Y25OaUhtcFppTXVKTTVhSGRNaWxIT1B4SWp6eWpUOGxyN1UyK3hlcnVX?=
 =?utf-8?B?cTUwaThxcUF5c2NyZ3h6RTkxaHgzMHVBK3hwaUVvMG0yWWlsT1pnc3EvaWJP?=
 =?utf-8?B?eEI4SzZyS3lVdVRJLzhQSFRjMFJMTzFFeTFaVGhBRVZ2UGYzS1FaOTdpVURx?=
 =?utf-8?B?UDYybEpIWXZRaTdVOXV6azhRelpqVnBkRDZ3UGdLOVpnY2RzUG43N3AvTVV3?=
 =?utf-8?B?d1FoaXQwdTJVTEZKdTc2RzBBdC9aUW1KQm81a2pkU2htWWs4VlByTkU3K2h5?=
 =?utf-8?B?YzVwTTBxeGlpSHhSeFRURTVDUVZaUVg2aHBjRkpEbEFoMHZ3aVRsZVVIU01W?=
 =?utf-8?B?RnArbjgwcytQZDFUZnlLTGh6c0IxaWJnekx6S3NmRFlaS2REbFRjS09kWGZT?=
 =?utf-8?B?Y0JobW9IY0RsVTFaVmJLNXFWODZYZVVHMFJkRGJOb3I2K2tyYXVkWE80Vys1?=
 =?utf-8?B?dVBsSTI3QzRVSldGT2xvZkpQOCtyS0VpS3dkN1I0bEdxNmJDclgrNHBHb0p2?=
 =?utf-8?B?MU02YVc3WW9hemRFQ01teW9ZcTlVQjFKSTNjKzExd2RRSHFJQXJTNGNoc2F6?=
 =?utf-8?B?Y3hUNHN5bkUxV2gyZ0tyL0ZNS2JXR0NONmFiQmZSVjBPZThRdTFabzRKSjRL?=
 =?utf-8?B?MzZRZUdSZ3hSSjl2L2EwcnprbVFKcm8wcFJCL0hNazNrVTZpZjJ3OHdsWmI1?=
 =?utf-8?B?Qjd3a0pXSk1zcllxaXJsVVVpSnJsNlU5NWdiQks4ZzlTM05sbUxQN3N4LzI3?=
 =?utf-8?B?V0ZpTG14MEdRTnBJMUM0TjAxdHExaUxyZEZkU3ZMa3RtRTdXSzdqc1NIcHVP?=
 =?utf-8?B?SjFIOUJrM2Uxa09aaFI3ZlFtSEF6N0R5WlhOUWR2SXNwL3JiV0FQVkx1ZDZS?=
 =?utf-8?B?VEFOSllDRUFIcE9mVjhkdGRDV01Zbmk0Wi9JZlA5eTBuRzRQRmtBKzZheER2?=
 =?utf-8?B?QUp0K3pMNmxLTmhHTkloRkYwaHRkSm1xUGtSckNSWi9zY1k2TWswWnJjQzhj?=
 =?utf-8?B?bEd0cHcxRDU4WWtFakhJYjYxeHFEaXVFaVRTR3Z3TTVmekdtUmVzK3BSQ0Qw?=
 =?utf-8?B?MzVxUEluVDU5RmdVQ3Jaem1vdVBKNGhRVXVUaG1OTm1KNjFEelJTNHcvbGY3?=
 =?utf-8?Q?ZQHQeyeJmmujTpPyzlfs3dzkyjLHYqa3ZGDXXG0?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16814723-fed5-469b-b454-08d976b6baea
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:24.3913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zQCI526Z+IOh216yzLQ73aRLCl6SeJnOJFz8UmRmwmWplI2/xTgesOQg7MF0j2/gMAdKpALmxAP05KCL2ATxPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biB0aGUgZGV2aWNlIGhhcyBmaW5pc2hlZCBhIHNjYW4gcmVxdWVzdCwgaXQgc2VuZCBhIHNjYW4g
Y29tcGxldGUKKCJTQ0FOX0NPTVBMIikgaW5kaWNhdGlvbi4gSXQgaXMgYWxzbyBwb3NzaWJsZSB0
byBhYm9ydCBhIHNjYW4gcmVxdWVzdAp3aXRoIGEgIlNDQU5fU1RPUCIgbWVzc2FnZS4gQSBTQ0FO
X0NPTVBMIGlzIGFsc28gc2VuZCBpbiB0aGlzIGNhc2UuCgpUaGUgZHJpdmVyIGxpbWl0cyB0aGUg
ZGVsYXkgdG8gbWFrZSBhIHNjYW4gcmVxdWVzdC4gQSB0aW1lb3V0IGhhcHBlbnMKYWxtb3N0IG5l
dmVyIGJ1dCBpcyB0aGVvcmV0aWNhbGx5IHBvc3NpYmxlLiBDdXJyZW50bHksIGlmIGl0IGhhcHBl
bnMKdGhlIGRyaXZlciBkb2VzIG5vdCB3YWl0IGZvciB0aGUgU0NBTl9DT01QTC4gVGhlbiwgd2hl
biB0aGUgZHJpdmVyCnN0YXJ0cyB0aGUgbmV4dCBzY2FuIHJlcXVlc3QsIHRoZSBkZXZpY2UgbWF5
IHJldHVybiAtRUJVU1kgKHNjYW4KcmVxdWVzdHMgb2Z0ZW4gb2NjdXIgYmFjay10by1iYWNrKS4K
ClRoaXMgcGF0Y2ggZ2l2ZSBhIGNoYW5jZSB0byB0aGUgZGV2aWNlIHRvIHNlbmQgYSBTQ0FOX0NP
TVBMIGFmdGVyIGEgc2Nhbgp0aW1lb3V0LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
c2Nhbi5jIHwgMjQgKysrKysrKysrKysrKysrKy0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTYg
aW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3NjYW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCmluZGV4IGZiNDdjN2Nk
ZGYyZi4uMWUwM2IxMzAwNDliIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4u
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwpAQCAtNTgsMjMgKzU4LDMxIEBAIHN0
YXRpYyBpbnQgc2VuZF9zY2FuX3JlcShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAlyZWluaXRfY29t
cGxldGlvbigmd3ZpZi0+c2Nhbl9jb21wbGV0ZSk7CiAJcmV0ID0gaGlmX3NjYW4od3ZpZiwgcmVx
LCBzdGFydF9pZHgsIGkgLSBzdGFydF9pZHgsICZ0aW1lb3V0KTsKIAlpZiAocmV0KSB7Ci0JCXdm
eF90eF91bmxvY2sod3ZpZi0+d2Rldik7Ci0JCXJldHVybiAtRUlPOworCQlyZXQgPSAtRUlPOwor
CQlnb3RvIGVycl9zY2FuX3N0YXJ0OwogCX0KIAlyZXQgPSB3YWl0X2Zvcl9jb21wbGV0aW9uX3Rp
bWVvdXQoJnd2aWYtPnNjYW5fY29tcGxldGUsIHRpbWVvdXQpOwotCWlmIChyZXEtPmNoYW5uZWxz
W3N0YXJ0X2lkeF0tPm1heF9wb3dlciAhPSB3dmlmLT52aWYtPmJzc19jb25mLnR4cG93ZXIpCi0J
CWhpZl9zZXRfb3V0cHV0X3Bvd2VyKHd2aWYsIHd2aWYtPnZpZi0+YnNzX2NvbmYudHhwb3dlcik7
Ci0Jd2Z4X3R4X3VubG9jayh3dmlmLT53ZGV2KTsKIAlpZiAoIXJldCkgewogCQlkZXZfbm90aWNl
KHd2aWYtPndkZXYtPmRldiwgInNjYW4gdGltZW91dFxuIik7CiAJCWhpZl9zdG9wX3NjYW4od3Zp
Zik7Ci0JCXJldHVybiAtRVRJTUVET1VUOworCQlyZXQgPSB3YWl0X2Zvcl9jb21wbGV0aW9uX3Rp
bWVvdXQoJnd2aWYtPnNjYW5fY29tcGxldGUsIDEgKiBIWik7CisJCWlmICghcmV0KQorCQkJZGV2
X2Vycih3dmlmLT53ZGV2LT5kZXYsICJzY2FuIGRpZG4ndCBzdG9wXG4iKTsKKwkJcmV0ID0gLUVU
SU1FRE9VVDsKKwkJZ290byBlcnJfdGltZW91dDsKIAl9CiAJaWYgKHd2aWYtPnNjYW5fYWJvcnQp
IHsKIAkJZGV2X25vdGljZSh3dmlmLT53ZGV2LT5kZXYsICJzY2FuIGFib3J0XG4iKTsKLQkJcmV0
dXJuIC1FQ09OTkFCT1JURUQ7CisJCXJldCA9IC1FQ09OTkFCT1JURUQ7CisJCWdvdG8gZXJyX3Rp
bWVvdXQ7CiAJfQotCXJldHVybiBpIC0gc3RhcnRfaWR4OworCXJldCA9IGkgLSBzdGFydF9pZHg7
CitlcnJfdGltZW91dDoKKwlpZiAocmVxLT5jaGFubmVsc1tzdGFydF9pZHhdLT5tYXhfcG93ZXIg
IT0gd3ZpZi0+dmlmLT5ic3NfY29uZi50eHBvd2VyKQorCQloaWZfc2V0X291dHB1dF9wb3dlcih3
dmlmLCB3dmlmLT52aWYtPmJzc19jb25mLnR4cG93ZXIpOworZXJyX3NjYW5fc3RhcnQ6CisJd2Z4
X3R4X3VubG9jayh3dmlmLT53ZGV2KTsKKwlyZXR1cm4gcmV0OwogfQogCiAvKgotLSAKMi4zMy4w
Cgo=
