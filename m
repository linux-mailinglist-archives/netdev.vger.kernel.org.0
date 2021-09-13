Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8D24086B4
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbhIMIds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:33:48 -0400
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:55755
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238126AbhIMIdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:33:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOSOrGlqeoWcKD21qiYcTBS8qJwBKfdaaFB7u0KJpXZ4ZQCKS+hRQp3bzcNFc2+JNZHj+MX7oZ2WEWMm9L4NOLjRB3Z+KgxB5XXBU3+szQRpNV3xe3UmhT4ZHvc702W2v3V0fJMrnNJk8AY2wg9nefTd7naR4OzqVkrlwYoc7jRqM0q5BzqsKkbYoAQZfvso4Jkbj1JlXCVRNZ77ESFzRd0Ye05qqsw6PXYbTxNt08K+CP9D9nQ78m3LO3mTZCz6f5Rx26dEvMSk7sCCznCow6cWMZEomu8EYvyq0m7R+zgtHpfFtXBEyUt0ECeUeXsS+t3vkTsdCX1iN3n5gJsvEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ukiiaXuHB68lNESJa7s+KPhr2UdHv8KEhL2rJ3/GeVg=;
 b=UfwBUviiBf87r2xKUoZUCOBhkTAze1fyhpk6ofaNgkOp6+7fqU0VDJ7YWmHdyz0ueK9PCh1bedpEcEL/wb2WqHMw/QkM3c8rIoLmRm+0HGmh4GqimnrNTnDWwTTuZmpTy3SXbyngB7xc7IB/IcjVA13fRyo61ktUtal16MXVCIEjQ2GDEAyh/dB+NciGOsBlzYtcrCNFC6XPQ3n78EXEx+wSQ8ImL0DM7i6Rgdag6D5ilkViCiZdoe2HDcDDE7Z5Q+3eEmPc57sAsuUEcQ8i+yQ1kyiUE05vuCj2GtlpAj/uFjMSP3Q2Xbiv/W5qY4I/aOMlKaEu+2sYu0yGzLqw5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukiiaXuHB68lNESJa7s+KPhr2UdHv8KEhL2rJ3/GeVg=;
 b=JSyV/to6s4W0W5ONL7o/xnWgcLHgg594mu+J4x5Epb3tnxU9iNpQd9wlP3qUBM6xoXrhQr+AGBApithpXfusvjzyUV38yuAMD/K0HXQ8lYtb4whyaL7hYN5GxN9YNluuK1xO7jq6SYUWiLq6IZHKlfVl/3gnPfpCPNCrJKbIXn4=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:47 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:47 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 08/33] staging: wfx: take advantage of wfx_tx_queue_empty()
Date:   Mon, 13 Sep 2021 10:30:20 +0200
Message-Id: <20210913083045.1881321-9-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c120811-c4b0-4357-7276-08d97690dbbf
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB326328312AD2F21E655C847993D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UGVD7iG7rZ45Dkq+PqZFgRu8Dx04Z1uR15co5sm9vZoKS75Gne6RlsphFUkQOF9SkFOf41qd2DJ9xXGxJVjnunGjRi68DMT8I1/I//7eT23WrBoQoa1Y0ixPMATpC8mTRJQGM04S1Sy+zC24HdJiFf7aesjDTLago4+j8O+1O7K+aRK6stQxw94kuYjxMTHPq3mDWWVFfPXnLgZz6XqnpxaKDEqbDmrMqikh5WLZaCx3sGtAF/4uacakuoBsOp6beQhjFTkrOYq/BKQcF7BHSyVIRj1X7Va9Nd16p8erzrKX542LtmaUq1xfoQiYAPUD2OPizYnabZsccG+DcTatHB6aX9WSNNAqOmraxKRxPJd5zt9OE2aCzSNj+rzof7AjvxdB26HyGFwn5Vfpes6GkwliNUo5jiD/lvk/39sfj2SGZI3rhh9iW/E3d8VRnS44PrRiLtsORE4hrId2dmCME2/r3FjzT6rY/u1QnxgjGZVG47kk9lkbx/CC9mqT6en6CwqUDUqKzzkbF1nfIFjJrYfm1TGuzIk/h6/ZCv1ArbuKXOJ4c2s6s6lKnEVxBiV6JoDdUY0TVxTK2Q5ykUtb3irnuNIMfUQswlCDR48n0UApEZR6JT1RS8elCu99zZ0YkAboeAKwjCfVfSyU769ohten5m+LzGDKeixLOorWTmW8XdZsW2znAq81+rc28m4R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66574015)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(6666004)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3JrR25DNE02RUFLS2JhbjdTbjVJWXNMQkp0eTFUM3VRTE9jYWtWTTY0Qjl1?=
 =?utf-8?B?VHY2ZHNDRGJJNmFMcllRNElVTmFwajlhTUFlNVQrenduL25TdDdqdk4rZ0hn?=
 =?utf-8?B?YjhVcHJjcWp2eUh5Zm1FZXlhTWlXTE1oUmhaQiszYVJ2VjVFcmtwQlNPZ2ZR?=
 =?utf-8?B?RGVFV1pmUVpuU1EyUWk1T09JWlkzYTVpakZWZU1hQjNqY2NhdFFWRmRPbDFL?=
 =?utf-8?B?UjFVbVZEemE4QUtERmNJNGY0dHI2TytCMjI2MHBQZGJUR3ZmN0RyQUtWYzdP?=
 =?utf-8?B?Q3VpekZORXBiVHhTSXl0enRpOTlVdGtBQ1l6SmJYQndxWklpVFQwR3lhR0Nh?=
 =?utf-8?B?c2Nib2RvTFVkTGpLWW1wT3BpcXFXU2gxa1A4ejhLVjhKa1F4cVB2bktpZDd4?=
 =?utf-8?B?eUN5YVYxNGkyNmI5MlJCZ3oyUDF1WEZjdURXb2hubGdNbXZwUVN5UHpBenNo?=
 =?utf-8?B?YlYyNEZmeXVTdFRSQ1E3WEVwM0NMcHphUTYwZXg1bkJ1UFBGY0doRjJCZCtL?=
 =?utf-8?B?ODlOTUlWclI2M2tRZVNsbkhwNENnTm5vdHE4R3RIbm5oeUFGY2xralRVMUhr?=
 =?utf-8?B?TVNvQ2cvTjFlcW94UHhzOFpxSlZhM2thUFdKcVpUdmpXS1U1eGErdVNZV2pP?=
 =?utf-8?B?TnA4QkxTZWFiTHgxNjBhWmtadEkxTEMwalRxTmxsN0lYVlA1MTlRQmpMNHBm?=
 =?utf-8?B?Rmh3MjRkeVpaR212aWVlNlRyQ3dscTh5a2lrQ3hSSE5ValRZdWdyNEZNaHIv?=
 =?utf-8?B?UUhUTmpBVTBQUzJkcnd1bGwyemxRdWR2K1FmUUhlaVk3NExZUTZ2c1pYSFVw?=
 =?utf-8?B?d1N5SldYTi9mY3ZOakY5alJMeG5UanlERUVwOUVON1ViWnpPbTdPT1lXWDk0?=
 =?utf-8?B?Q3VzSzB2RVE4cWozTHlXeXNPbXlnclZZbGpEcmNGbkNRL05ncVFBU0JTNFVM?=
 =?utf-8?B?TFlOemVLa1hpelBXN2orSkxqOUxnSEQ3bGFRNjE4VlBTc09vVzBId2dzUDkw?=
 =?utf-8?B?dnh1Y1IwdW41UVhtMm9PeENoQ3YzY1ZTdlRXWmplZDBHaktxdlhhMzNwSW50?=
 =?utf-8?B?NjVXN0x2Qzd5eTRaSlY0OXhWa3h4VWY3OTlEM05lbHJBNGRBd0VLZjZkQ3Q1?=
 =?utf-8?B?MVRIaW55RjlsemJXaVVBRmFyZ0c3dVFZZW1pNFB6c1NlUUxua0UvK0llVDYr?=
 =?utf-8?B?YjQ2UnJvRFBKYmlqMXYxNGl0ODR1ekpLZnRzV2hDRWpKZWc4UUM5ODlXenIw?=
 =?utf-8?B?NlNSdFBCRTdzTWhHTFJNU0lPVlFQc2haN3R1eGpKbTJXYmdHSHlKWm8zV0Ez?=
 =?utf-8?B?YlFtQ0p0ZzhHNmQyTVRDNFFoZTVCQ3R4c2FZVGw1d2hDVDU0Ym5NYk5mN2ls?=
 =?utf-8?B?Z3FHRzJTeUltcktLbXpLLzZMVTdrWWx6NXhYMTFiMTVyaGE4OWxZT21iOGx2?=
 =?utf-8?B?bGN3TlpsYjdBR3ZXc3B4NmFUTTBTa28zcm5FM3hRd3Rocllwbk1IREFabVlF?=
 =?utf-8?B?bm03aFJwUUhxeXZaSU1XOWRVaDl5a1BLcGFTNGxxa21pSGhIMTJ6Wmw4cURs?=
 =?utf-8?B?K2k1ajhnQ250R2NHVlRxWk1BWGd5WG1LczVNdTFzN21xUVgwcDVIOU5xVlhT?=
 =?utf-8?B?MldpZGZIRVJXbktkMzhVWWc2RDdrRWJVNW5DYnZQZDhIMCtkdnF5THdVaVlF?=
 =?utf-8?B?ZlA5aHEwMDZFUWRnbCswaHFGL3ltSXRGVUkrbjI3dit4Wm5tRXBtNFlCd3dQ?=
 =?utf-8?Q?8hx7wQBk5GwJ8O2n5defjOsnwrYYnXgqWpq3hQT?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c120811-c4b0-4357-7276-08d97690dbbf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:18.4940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/ZTkMfvZ0wZczqJSBEQv0yBNLcmw1SVY80sqbSp0HAXRVpl+GnI+nSJz+14vGBuIMWX7rZO11kClU0tFeCg+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3R4X3F1ZXVlc19jaGVja19lbXB0eSgpIGNhbiBiZSBzbGlnaHRseSBzaW1wbGlmaWVkIGJ5IGNh
bGxpbmcKd2Z4X3R4X3F1ZXVlX2VtcHR5KCkuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3Vp
bGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9xdWV1ZS5jIHwgMjEgKysrKysrKysrKy0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTAg
aW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9xdWV1ZS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCmluZGV4IGZhMjcy
YzEyMGYxYy4uMGFiMjA3MjM3ZDlmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1
ZXVlLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCkBAIC03MywyMyArNzMsMjIg
QEAgdm9pZCB3ZnhfdHhfcXVldWVzX2luaXQoc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJfQogfQog
Ci12b2lkIHdmeF90eF9xdWV1ZXNfY2hlY2tfZW1wdHkoc3RydWN0IHdmeF92aWYgKnd2aWYpCi17
Ci0JaW50IGk7Ci0KLQlmb3IgKGkgPSAwOyBpIDwgSUVFRTgwMjExX05VTV9BQ1M7ICsraSkgewot
CQlXQVJOX09OKGF0b21pY19yZWFkKCZ3dmlmLT50eF9xdWV1ZVtpXS5wZW5kaW5nX2ZyYW1lcykp
OwotCQlXQVJOX09OKCFza2JfcXVldWVfZW1wdHlfbG9ja2xlc3MoJnd2aWYtPnR4X3F1ZXVlW2ld
Lm5vcm1hbCkpOwotCQlXQVJOX09OKCFza2JfcXVldWVfZW1wdHlfbG9ja2xlc3MoJnd2aWYtPnR4
X3F1ZXVlW2ldLmNhYikpOwotCX0KLX0KLQogYm9vbCB3ZnhfdHhfcXVldWVfZW1wdHkoc3RydWN0
IHdmeF92aWYgKnd2aWYsIHN0cnVjdCB3ZnhfcXVldWUgKnF1ZXVlKQogewogCXJldHVybiBza2Jf
cXVldWVfZW1wdHlfbG9ja2xlc3MoJnF1ZXVlLT5ub3JtYWwpICYmCiAJICAgICAgIHNrYl9xdWV1
ZV9lbXB0eV9sb2NrbGVzcygmcXVldWUtPmNhYik7CiB9CiAKK3ZvaWQgd2Z4X3R4X3F1ZXVlc19j
aGVja19lbXB0eShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKK3sKKwlpbnQgaTsKKworCWZvciAoaSA9
IDA7IGkgPCBJRUVFODAyMTFfTlVNX0FDUzsgKytpKSB7CisJCVdBUk5fT04oYXRvbWljX3JlYWQo
Jnd2aWYtPnR4X3F1ZXVlW2ldLnBlbmRpbmdfZnJhbWVzKSk7CisJCVdBUk5fT04oIXdmeF90eF9x
dWV1ZV9lbXB0eSh3dmlmLCAmd3ZpZi0+dHhfcXVldWVbaV0pKTsKKwl9Cit9CisKIHN0YXRpYyB2
b2lkIF9fd2Z4X3R4X3F1ZXVlX2Ryb3Aoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCQkJc3RydWN0
IHNrX2J1ZmZfaGVhZCAqc2tiX3F1ZXVlLAogCQkJCXN0cnVjdCBza19idWZmX2hlYWQgKmRyb3Bw
ZWQpCi0tIAoyLjMzLjAKCg==
