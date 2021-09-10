Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3548C406EB1
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhIJQHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:07:06 -0400
Received: from mail-mw2nam10on2043.outbound.protection.outlook.com ([40.107.94.43]:40801
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229919AbhIJQGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:06:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5YNXOxBX7QeSsAiy9pXGQmK1aUAYDQMvAko65Tgb8RugeZzttdjIV60Ra6kAm/qDei6OZW+50D461JzQNPCux9QK/AclxuQMwYPKkI0qKRla0OU77H2DjjBkzMu5OmNCCve6yax3k9hhNGXxrnabv+SkQUqi5M7I1VGqKxJf7J0BIpmARNQSqHmxYQxjW9JYRE9+Asd9VwbJYU6dG5/UHUzVLYhLm79V9aLjvpu2NJuwDh8q9QEahY2ANWIKWJm+oHdDUlCeG7b0Tn5M+Mmwtzpr0PW8Xhf1DcptCshpc5d9IgDhMiA6ysjdhXGktrh1j5Gi5SvZ375Ekuy6c+k9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AmCqsbY3AiU0YiEAlz93ibGj/lSsD0m2Srcg44MoTrQ=;
 b=CoRRTO7wkUGxSXlMcK8zwbxQGSQDSRIysTp3cdmYBe1MAmNDRE2B8OYNDmId+SvdX2AlkTh8pmU+OxLBUnsP40Q23urq8j4YxdO5NW5ES0ta0vj1CNN7xWX5sQ7EdCOxmrEKKtpoZvi790jZiXG4pdvyNGWNAbjdb24pCeZLoVNk8uU+gFlTtNU9fBxMJyR76mqGTnVGcdyHBpLD7Ws7XlNKHQKkWLF0A1kgkmv4mlBnJMKCaVNyUYJURgzuw0N/zfaTSydZ0TJMmr4k9awtmioMX8SayJ2Ix6VULyj6uVK4crjsUkkxUgZ37yseP5b5OYSNZhZap6092ObCMud3Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmCqsbY3AiU0YiEAlz93ibGj/lSsD0m2Srcg44MoTrQ=;
 b=Cn7QDbn9dahwxLKnFFM0PDTnm386BOTKmppRX93flw3a283S54t8LUKtkHBVRKlZRPjLAHA7R7AevxskD3AEmbL/JVijVZ1xQhzYebA6EjzenU6ohjueSM8IP8ELqW41TN4rd0PHytKGSbjJqj0eN2K+JgWTXxstXfm7jWkOSqI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3118.namprd11.prod.outlook.com (2603:10b6:805:dc::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 16:05:40 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:05:40 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 04/31] staging: wfx: wait for SCAN_CMPL after a SCAN_STOP
Date:   Fri, 10 Sep 2021 18:04:37 +0200
Message-Id: <20210910160504.1794332-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:05:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08b928fc-6f41-417c-97c3-08d97474d599
X-MS-TrafficTypeDiagnostic: SN6PR11MB3118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB31181BD0715E17471B73309693D69@SN6PR11MB3118.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zasamjVgn4oZb4+UaHWE7f1ct0+bSfClxh+giwSQqn4HErVzo+YXfmWynDzluUXtrdB26V+KqLb5l2hYODK1H1k324Y0CTMBKFhn647MYFR4z1DoneFMg0mTl4epOhLNIw4chL4EWLMHtBPZSn4E6m7zH6tUurWXqjwRX4HSEubRXyoy9dSsUNBjAWLiUqP6IRzfJqC/SLaPxEM+DVfRzVlZSN986xpHtv8Lfe/X/Yo8mAu95wmNnv1F4zSRSpSU1faz5a7zQl7tpMt/JPBratGchsH9b2tUhHYhE2NUAsi3xHpmOQfx4ulW70x3rpB6xkqMQPC9mOYrQtGXposU9ycXwifB68lth3hLRXvbKYoK7aBwKXyaIgy7YDCZNr/HfL55tOLfmZLCezDF8iMH6ue/o9PzCnArlAAzlkdtBF/EXMYNbbQq8NOEDZuTcdE36NVHAmU0+CXBgOzRmFDNjeif6pQSU5giZW0VVgfztUJBa8G4m6IpUikPOWYPUbEty8UZnVgrpy9i5q+Udd7sV0N21pGr5njk+P4CROV5DNNrpGv9WCe6s7Dm9oEyqhSGH4dWPasJTw4f11xcCr1WSqaoppjekogZzJjkwW8ICq02tGYq8PJxcqa7Xy5VhXe9KTP7iq0dnXh5qVoY07QTtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39850400004)(396003)(4326008)(66476007)(107886003)(36756003)(186003)(316002)(6486002)(66556008)(8676002)(86362001)(2906002)(54906003)(38100700002)(83380400001)(8936002)(66574015)(5660300002)(66946007)(1076003)(2616005)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1hadUtndG5lNzRtclJ1bG96WExHQ290YndjVlpFeWdoenZjMWZxdG5EVmlV?=
 =?utf-8?B?c0NwOFZhbWJ0QUJVVGZiOVVQUEh4cnlQc01xYkVpcTBlZE5pOExWWHRIMEJI?=
 =?utf-8?B?dDgzY3BXdEtSeEF1R3NxY0R5RzIxVW1maVJWakplT1MwSnl2YkdIaGEydjFF?=
 =?utf-8?B?VHlWNEdaemRIZFVsRWFlcXlLQkx1UDg0RXFzTnZJaFBGVWIrVGoyS2hBY2sr?=
 =?utf-8?B?WmZuNllRVStyZ1k2U3IzN0tzYTdVcEc3dmxsVmx4dmtqTEt2VlVOTnFBR2hX?=
 =?utf-8?B?bWVZR0ViQXQ0b2pzbGJzUmVuTDhPQi9jWWMwZUVLY21zMW90MzhuaGUvNFZH?=
 =?utf-8?B?RldYUG9FTlpUOFBKZmJIaER4YldUaFRBRzJoSFNmYW1ibGVBK3FFZkN3a3h4?=
 =?utf-8?B?NkhJS0ZuSk43ZVRHb3BYaEpTcnBHMWFua2UwRnVVRU00Z05CV1gzWmVIZGZ2?=
 =?utf-8?B?WlBMSjZDSThSS0VPRHFQWkNHcFZ6ZHFLZlFxREI1SGxybVMxdUJ0RGFnY1NV?=
 =?utf-8?B?UFZoZG1hWm4wMll4eGxrSERSSTl5WWU1dlZBRjVQM2oxaDJ5clRqRGxwcUk5?=
 =?utf-8?B?UnhoSVFXTEptMVR3R2IxSWRzU2tBTkhPLzlaejJobE9seFNGem1DU0htbk9C?=
 =?utf-8?B?VzFwWXRBbEtJVGNQUGNIZkpJL2FLZmJ4djVRNjdtTi8wSU51QjFwWEFCdHZN?=
 =?utf-8?B?dUFWak81NnVSMEROZEdzYzNVU1BTbk0zM0ZCaVRpVlBpOFFQdmRoVjNqb3RC?=
 =?utf-8?B?UDlnS0liSmtmcC82d0ZlMExWOGk5WWJOaDdhemZtSzNVZndQdHBuZHNwSnJa?=
 =?utf-8?B?cnU2bzhOZ3J3UDUwSzhIY2tYVXkxOWFxbElNVkhHbm13WVFtSTVOSTkzYkc2?=
 =?utf-8?B?VGlWYkV4bitNOW44cU1UdkJFYk45dEN5djJOZUJLVng3TXdwbGF5bzMreGV6?=
 =?utf-8?B?em95R1I0dkQrRFIxWExuMmNHQW1FK0tOSHpFMkdWSUc3UzVETE5KQThtUUp3?=
 =?utf-8?B?NDhIS28yRGJGQUJaSW9XOHAvQlhzenZyLzY4VDkzelVxT3hsekpkMUxNNkxh?=
 =?utf-8?B?QUpOY2x4NUV4WGVrWi9qZVJVRC9zcWNPZjBWZ2t1V1pFK2R6Y0dNSTdYaEZt?=
 =?utf-8?B?Q0FpNnJ0VWthdklNbFB1aW1BbFpyUmZwdFhyczFZL2ZtSWd4WE00dnE4Z1Fk?=
 =?utf-8?B?VWdaZ0FOMVo5dHluMFhkTjBLV2pRWU1VOEhvUmdHZ25mSG9rRXJSVDlHakxr?=
 =?utf-8?B?dzhKQlhFTnRGakVWTFpIQWczK1VvOUw0U3l0cDdPcmZLcVp0RW5DTjN3TCtQ?=
 =?utf-8?B?bWNYM2ZvWjcyY2gweHNCZVM4YzRkYW1KYXV4TWZKOHA2YUVyRm9vUTQ4ekJJ?=
 =?utf-8?B?OFVxUHVWUEtjQXVVcGNHczRsbXFLM0dTc0VLRG9OWEVuTXkrMUNXVFFySHBo?=
 =?utf-8?B?VjN3SFBYdU9zVU5Qa3RKOHlDbmQwdm1rSEI4VmhqaldUK21icWxLQkFHNnhF?=
 =?utf-8?B?R3hWazBBYUFoWExLT000Q0FCWlF5MitSdFpOTnVDak1YNzBEQzgvY3MrZXcy?=
 =?utf-8?B?dCs3S1RjZk96Z3REcFFhajV2ajRqeG9yTjd1MGYvNVBMYjUxU1NmOVRuQld5?=
 =?utf-8?B?WFFGdm1ac1NEMzQ2UTVNaDdUUWxrNjJpZXZIMjFDTjZDTmpGYi9QQ01RUkxG?=
 =?utf-8?B?TjRPVzVCbTFHZmpCQzJnL00yVW5OKzZjcXBvYWZjNjRRQlhWOFU1TGY3SDVC?=
 =?utf-8?B?V3AwVUVhK2Y2V1Q2NmVZc0FmaCt6ZHB3SlpWWDVDMDVzRXhheTdBWHViMzJR?=
 =?utf-8?B?Q0J0NWgwZDdEdk5YcVVzaG5VWU5UeVExazc0YTU1OTl2cm4yL3hsdGtIYWg0?=
 =?utf-8?Q?pMRJKupUHeDHY?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08b928fc-6f41-417c-97c3-08d97474d599
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:05:40.0605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vfr/L8nWbfyEvUtT7rNl43JaLw9fXosr4XGZSwgDyQVL3vrb+XwfYSLjckDvQ92prHm/EFE2pUHOnirdQxP/3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3118
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
