Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6163740869C
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238048AbhIMIc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:32:58 -0400
Received: from mail-bn8nam12on2070.outbound.protection.outlook.com ([40.107.237.70]:61217
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238055AbhIMIc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:32:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+qJ1CPskZrjhzKuAXjShv1ivtiN1omT/rIiO2u6coJxMT0g+YWOsNGSRBvb3axuF5YBOCccXDNEFaNtzDGlD1Z8+sspJqQaJEtKQZbGvspC7sAd4HHmznYmEi34p1MYH767Ns49uIN8CfCGOTovuW4J6ak3nWwDTCsB0PkcuVeP9wIaEVCKEmrFTlnOHN/BesPSvNm9L7YX/elo5nYj7GxenLcoEM+DIm3XlwABDSIJbAqEzAvumsIbiFvGast+na8g+TGsed3j23GJwb3Lh6zigrhARl4AB6bkL+GvKwfgbA3K53H3difctTwddMH6UzgIGx+EfrHr6VWK04onxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uUO5xCt55CNozRJ34OB+Ps7TB7KSGWz/tLv7tV6TOJ0=;
 b=B2L7b8nSqKedAcEWg27IPaw/DOjvH8jr4LlmR/vghBdah6WjshgyysfN8xLEYZFBjmS/v4jD9BQb7oAaSTxC/bXxn4Qr0tjGoLNU9bxH/aoMtJ6iAXj9beMF7CY742sljlD2pRW9szIxPSwSZjBrGUZ2n8jRx5PaCXa6VigRQ+TaMLo7PTTXRqkfvbsF58/Dar9zYTPCtxHC4rRpGZ3npA4CQBtvwmVXRwgkChD5aJI2U4PN18Y3SMgqtVbK8TrWk6O2DCma95dukPi6WN1qIBkTl/iAbwwAPCIpqW1y9vL+aWW6cY9SkiA9OquhO3+nVz31D9qmd4TUtsVzZxu8WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUO5xCt55CNozRJ34OB+Ps7TB7KSGWz/tLv7tV6TOJ0=;
 b=Vq/7IqyB/PNldzMYzE/zzAOARxNCZdfHt/Ik2T8hcXApcoZcfC3ghezxAWUnEfOxv9H+/fdYHItpUghnKviatDAcRQN43d1yht3QSuJ1tM7pBAT3Bty165/Qcmxk6AT5FBPsDqx6BjRRxgsXG23WC5v1UPYQj/e3aXOXA3T7qbU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:09 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:09 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 03/33] staging: wfx: ignore PS when STA/AP share same channel
Date:   Mon, 13 Sep 2021 10:30:15 +0200
Message-Id: <20210913083045.1881321-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1c4315b-ef7f-42a2-dc53-08d97690d62f
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB32637239AC7E0D3BB0B5657893D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bjg5shKgIWYzHweGNBC08C6fYU3g2pcOmaGJEpyH+07gouneTiOnKyeN5XVO/ybc6J6UFZArldGN+ixlwTdSwns42kMP1QNV9maoU5WxAV4L4S9YkvJzdsHODwavvtJMEoTaX4XoF/uNGHx2MxjJWtoUjnH0kCk14QncMOVFF48pEybGH3/tEeHsj2zskKq9UQRjizAU4piJ3fBvKjr3YUkRj5hOuxX+QQfu5G+2+E1KR3fRCkgywAez0ZYP0mmEKWjiRXdXRNQ3WxMligF62FxILEj0Tghs1ysKQnOekh6i836ImGs/5ezTbaouowIVJz2RbvlhNungpXbn65Hx6RqUjfUyGugdGDCL/SmhxjQAvrSDfQ3pErgvHiGaajvgYzBy/hZBQB50SEwFFAB4UzcurBZwvvQEIcNpAc3h7YSFLcanBwPwm4skv9vrywpOluihY34EedZ9NaGjs9J1fJ4kNvii8JXvaTKHXMcAyt0ZHUX/FesY6NzmSdPiN5Nqp4DTDYzyM7y/B5TG3CwHPjsUAv3ggHEgmJNxttcwi7rKPRtO+oowQuDao9RyIYaQ1wFqLUem9voTp31PTTiGP1KPC0E1EC5T2JYZkcAGaL4SVQwUqLlz8XssAGK4WXFNGFbaMrqIx+/YDT1Qh0hKXERWxyRUeo2kpd0wXyWv5B/mUSaPs1+dmHIl6jZ0N3YesC0yuO2iru3T0g6VrW1FYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66574015)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(6666004)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGpzNlpZU2pzcExabGFESlpEK2JHci96ME5KMlh6elJpTzRFbmFiWThmMytp?=
 =?utf-8?B?cm5NckpraXAwclV4TUpBTmdWNnN5ei81c2duNmFCeUVrRzlvTnJWVStVMW8r?=
 =?utf-8?B?NnJlNTliWThIOW9iemVPTWpsVFRVRGk2ci9nN1dTS3NKMlVMblF3UnNCNVhi?=
 =?utf-8?B?YmhYeFRVM01iMStNeVk0aGtGcm11TXFIVmFWNXFmZTk3VFFubXhDYkovZlZM?=
 =?utf-8?B?UlpRaDh2eWJnNm9Lc2w1dmI2cW1rcXJkRHBTcGdNMFFhS1RTRnovOUhiclhC?=
 =?utf-8?B?dW9WdnRwYmx4Z3JuREFOMU9ENUVjQTVpYTZ1NmU2UzMwcyt4UXZNR2lDUDlF?=
 =?utf-8?B?V0dzZ003V3RrdytGNFhQUzZaNHFKZ1dhNEV1c0o3dGQ5NmRsMyt1Vk40N29o?=
 =?utf-8?B?a2E2MFY2Ni81ZnRiVGs3WG1wV3BvekRPMEdoT25HZHFBNmRaeFd1bnpYcW1i?=
 =?utf-8?B?akFNZnFMeFpyelozeTlCUExadGhUSDRqUk9HY0EzMUlEcndodjNTTjM0emJ4?=
 =?utf-8?B?QUJGbzdtN2JwSk5lNEpOSXMxZFBnRU4zRVJLQjhCVHErUnloVG9SSGFadFA2?=
 =?utf-8?B?UWFxaklKZW5QV0tkTklub1N1MDVGM2Ixb1lUMExFM0hXa1V6cTdBL1BYV1o0?=
 =?utf-8?B?L3FDK0tPcEVHQmFXNFR3NkRvMFNpNjRNZkZLUEdqSjd1czJBZ0kzUzVRS1lx?=
 =?utf-8?B?OGJOZkVaSDZKWkVwcmZSM285U2RRaE5zT3lsU0dPRlBBSzRGUXM3WmZQRFpY?=
 =?utf-8?B?UDh5ZmsvNmM1STZkN2RYTWx5SlA5R2lXbkRNbE1jcDJSNWNaVUVTdzhoVzc4?=
 =?utf-8?B?Z095OFJsYlJXY09oenJXOU9VREdBMS9yZ1NTN3dOcHh5OGl1TURhU21Fbytz?=
 =?utf-8?B?WUFsWVJKR2VZYWZ3QXI2THEwY0E2azJQbllLWTNvdGc5dFRHbmxnSkxSTWY0?=
 =?utf-8?B?NFU1WTBwUXA0WVphb0NFanBMRW1kVXFRQVNtWHNCVDFHeWgxWXBiUERMNVZR?=
 =?utf-8?B?MGlUNmk5MmZUUHdRSlE2U1lESnRBVC9CUVc3UjdITnJlTTMzbGlHMnRQZnEw?=
 =?utf-8?B?aTdTaTNTNTBNTmhvRnhIZTg4WXIzUzkyUDE5Q09iMmpCS0JzSzhVSEFVZjNp?=
 =?utf-8?B?QTc4ZWxOKzFYVzRyUHYxWUsxRVlVU3BZOUt1QTN3T3d3WTVMb3QrZm9mSm9t?=
 =?utf-8?B?RlJBRTU3eFJjazJaTGdnSW9MeTVVVnZ0TGRURnhyNGVSVU9TOTlpcDdVa3Br?=
 =?utf-8?B?bW11clczcDFJYzlvVTlZTUUwWHN3d1hxRWZJeHJOUjVCdEZvTkg2ZnpHTzI5?=
 =?utf-8?B?VjVEVjdpZ29TbWJoajBzSDF5U0VVK1lOQUdlNyt6cVlvenV5YjRaOGdJWkpq?=
 =?utf-8?B?MW9qdTQxckc5S04xZFp3REtrMno0cXFGSitLWFNKQ084bkJBWFFNejNPSVln?=
 =?utf-8?B?cFVOaTdnYkFxSk5uVFM4QjFJZFNZR01UWFBwbzd0THBaZXQyMEhqNXUvalpZ?=
 =?utf-8?B?Rmx3eW5LY0R1ZFM3R0o5SnBLc2hSUGVRMVhCcXlUT3d1UGo0MG5MdUlQUHlR?=
 =?utf-8?B?bU00NDRWU2FzUHZHbER5dnE2R1NWdFFnRDZjUU41ajIwVitNT2ZXMGNwM2FW?=
 =?utf-8?B?VUsrbUJCWHhhckZmdEhhUXpRc05YM3BEVFRHdFhCM0NrOFl4UXJvTWwxc0Jh?=
 =?utf-8?B?NmVCUW93b0RjeDZsenVyWG9HWno1alJiOTdmUGsvUk1qK2RJNDlHWEJWSVRO?=
 =?utf-8?Q?cD2dq7K86CWbBeMzAmApTntE/pkRBLzk9OMfQar?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c4315b-ef7f-42a2-dc53-08d97690d62f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:09.1664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POb4NpxbqwbqDBkGNtXv/W3J0WKTh0TkRhVuj1PkzUQTuODH06mNIxyk5mfNnB/waukerFTfpGZRvsm5MotoCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBtdWx0aXBsZSBpbnRlcmZhY2UgYXJlIGluIHVzZS4gT25lIGlzIGFsd2F5cyBBUCB3aGlsZSB0
aGUgb3RoZXIgaXMKYWx3YXlzIHN0YXRpb24uIFdoZW4gdGhlIHR3byBpbnRlcmZhY2UgdXNlIHRo
ZSBzYW1lIGNoYW5uZWwsIGl0IG1ha2VzIG5vCnNlbnNlIHRvIGVuYWJsZWQgUG93ZXIgU2F2aW5n
IChQUykgb24gdGhlIHN0YXRpb24uIEluZGVlZCwgYmVjYXVzZSBvZgp0aGUgQVAsIHRoZSBkZXZp
Y2Ugd2lsbCBiZSBrZXB0IGF3YWtlIG9uIHRoaXMgY2hhbm5lbCBhbnl3YXkuCgpJbiBhZGQsIHdo
ZW4gbXVsdGlwbGUgaW50ZXJmYWNlIGFyZSBpbiB1c2UsIG1hYzgwMjExIGRvZXMgbm90IHVwZGF0
ZSB0aGUKUFMgaW5mb3JtYXRpb24gYW5kIGRlbGVnYXRlIHRvIHRoZSBkcml2ZXIgcmVzcG9uc2li
aWxpdHkgdG8gZG8gdGhlCnJpZ2h0IHRoaW5nLgoKVGh1cywgaW4gdGhlIGN1cnJlbnQgY29kZSwg
d2hlbiB0aGUgdXNlciBlbmFibGUgUFMgaW4gdGhpcwpjb25maWd1cmF0aW9uLCB0aGUgZHJpdmVy
IGZpbmFsbHkgZW5hYmxlIFBTLVBvbGwgd2hpY2ggaXMgcHJvYmFibHkgbm90CndoYXQgdGhlIHVz
ZXIgZXhwZWN0ZWQuCgpUaGlzIHBhdGNoIGRldGVjdCB0aGlzIGNhc2UgYW5kIGFwcGxpZXMgYSBz
YW5lIGNvbmZpZ3VyYXRpb24gaW4gYWxsCmNhc2VzLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93Zngvc3RhLmMgfCAzMiArKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLQogMSBmaWxl
IGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmlu
ZGV4IDVkZTljY2YwMjI4NS4uYWZmMDU1OTY1M2JmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTE1NCwxOCAr
MTU0LDI2IEBAIHN0YXRpYyBpbnQgd2Z4X2dldF9wc190aW1lb3V0KHN0cnVjdCB3ZnhfdmlmICp3
dmlmLCBib29sICplbmFibGVfcHMpCiAJCWNoYW4wID0gd2Rldl90b193dmlmKHd2aWYtPndkZXYs
IDApLT52aWYtPmJzc19jb25mLmNoYW5kZWYuY2hhbjsKIAlpZiAod2Rldl90b193dmlmKHd2aWYt
PndkZXYsIDEpKQogCQljaGFuMSA9IHdkZXZfdG9fd3ZpZih3dmlmLT53ZGV2LCAxKS0+dmlmLT5i
c3NfY29uZi5jaGFuZGVmLmNoYW47Ci0JaWYgKGNoYW4wICYmIGNoYW4xICYmIGNoYW4wLT5od192
YWx1ZSAhPSBjaGFuMS0+aHdfdmFsdWUgJiYKLQkgICAgd3ZpZi0+dmlmLT50eXBlICE9IE5MODAy
MTFfSUZUWVBFX0FQKSB7Ci0JCS8vIEl0IGlzIG5lY2Vzc2FyeSB0byBlbmFibGUgcG93ZXJzYXZl
IGlmIGNoYW5uZWxzCi0JCS8vIGFyZSBkaWZmZXJlbnQuCi0JCWlmIChlbmFibGVfcHMpCi0JCQkq
ZW5hYmxlX3BzID0gdHJ1ZTsKLQkJaWYgKHd2aWYtPndkZXYtPmZvcmNlX3BzX3RpbWVvdXQgPiAt
MSkKLQkJCXJldHVybiB3dmlmLT53ZGV2LT5mb3JjZV9wc190aW1lb3V0OwotCQllbHNlIGlmICh3
ZnhfYXBpX29sZGVyX3RoYW4od3ZpZi0+d2RldiwgMywgMikpCi0JCQlyZXR1cm4gMDsKLQkJZWxz
ZQotCQkJcmV0dXJuIDMwOworCWlmIChjaGFuMCAmJiBjaGFuMSAmJiB3dmlmLT52aWYtPnR5cGUg
IT0gTkw4MDIxMV9JRlRZUEVfQVApIHsKKwkJaWYgKGNoYW4wLT5od192YWx1ZSA9PSBjaGFuMS0+
aHdfdmFsdWUpIHsKKwkJCS8vIEl0IGlzIHVzZWxlc3MgdG8gZW5hYmxlIFBTIGlmIGNoYW5uZWxz
IGFyZSB0aGUgc2FtZS4KKwkJCWlmIChlbmFibGVfcHMpCisJCQkJKmVuYWJsZV9wcyA9IGZhbHNl
OworCQkJaWYgKHd2aWYtPnZpZi0+YnNzX2NvbmYuYXNzb2MgJiYgd3ZpZi0+dmlmLT5ic3NfY29u
Zi5wcykKKwkJCQlkZXZfaW5mbyh3dmlmLT53ZGV2LT5kZXYsICJpZ25vcmluZyByZXF1ZXN0ZWQg
UFMgbW9kZSIpOworCQkJcmV0dXJuIC0xOworCQl9IGVsc2UgeworCQkJLy8gSXQgaXMgbmVjZXNz
YXJ5IHRvIGVuYWJsZSBQUyBpZiBjaGFubmVscworCQkJLy8gYXJlIGRpZmZlcmVudC4KKwkJCWlm
IChlbmFibGVfcHMpCisJCQkJKmVuYWJsZV9wcyA9IHRydWU7CisJCQlpZiAod3ZpZi0+d2Rldi0+
Zm9yY2VfcHNfdGltZW91dCA+IC0xKQorCQkJCXJldHVybiB3dmlmLT53ZGV2LT5mb3JjZV9wc190
aW1lb3V0OworCQkJZWxzZSBpZiAod2Z4X2FwaV9vbGRlcl90aGFuKHd2aWYtPndkZXYsIDMsIDIp
KQorCQkJCXJldHVybiAwOworCQkJZWxzZQorCQkJCXJldHVybiAzMDsKKwkJfQogCX0KIAlpZiAo
ZW5hYmxlX3BzKQogCQkqZW5hYmxlX3BzID0gd3ZpZi0+dmlmLT5ic3NfY29uZi5wczsKLS0gCjIu
MzMuMAoK
