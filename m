Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87190408697
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbhIMIci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:32:38 -0400
Received: from mail-bn8nam12on2070.outbound.protection.outlook.com ([40.107.237.70]:61217
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238077AbhIMIc2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:32:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POwVjmZoASYuFi3VBQ15DnBd05zL050hmlIDTz6xzF0M0/GQaiwFogKOL9wLQI6AEs4QWZzFe8ILULsKguf4yiFNLkTL+DHagP1oOL1KHPNRNaw1ugbFyLmiYxogLj5RUfO4B8DHbiBW9GYY1lgCrKgqgSgaI1kaVC1Ebp6bNBXqBGxIKEgZM/XWBiI7s7sqMYe3ezt2OzB3rfaofqrBNeqO+bumbSt6hKaRbLjLqOn+PWgoUtWHz6eThPxZJKUfewSGoL4BZ6yFhsHVaM1odMbwnAa/F1OGJ0MMt3AQG3Lc0HslamORoGegZM/GjFBGm/3I91ZGQz4Ca2xtwylJVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AmCqsbY3AiU0YiEAlz93ibGj/lSsD0m2Srcg44MoTrQ=;
 b=DGeNgL+GvaMrAejBVfA3JjEvM0qvBExXxV/sKEbqLtfVb3DU0ZmjUPPdLHV5v8Eyx0ceAlPC1zMS425P+T7iNLImoTo/sOdMJrAc1FhlIW2jzHMzONEvr7k8l4o+Y/JtkNl5HkU6Tj83a5AsuffHmhknvgsZ4jNNLviDrYj2IGyA3KSKBUYWMsw/iAk3IYW054oe5mcJMRrgM2pgbr6QAeT18epbFGUBcMcgoTjcy6hJs08p7buFNhjQB9QWm9Ml8GNiWaoT23G+z2530hijgv1JeJhbKthS2LLEXCPdCJ798rG0ZkMac3gcoUop3HRg3JBNC0PJgDQd5ex+B4Rx9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmCqsbY3AiU0YiEAlz93ibGj/lSsD0m2Srcg44MoTrQ=;
 b=ku//ZlRZxKs4XuISsZJ4p2zmv9jQbb4bal06NatszIIkS72TIWCDEAiWIm+WuC9xPDM11s5aaNCLHfxIcbaT5rGtEbUeKq8r0e8pMH3I7CwVxN6t0qC3eRPerdxrLEG4pMzQMJkvARx2VRW1GqZqYlH6PyCFKrhKaWV4+8NzodY=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:11 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:11 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 04/33] staging: wfx: wait for SCAN_CMPL after a SCAN_STOP
Date:   Mon, 13 Sep 2021 10:30:16 +0200
Message-Id: <20210913083045.1881321-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6403d494-b881-479e-60bf-08d97690d740
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3263656FF3BED268A76A897593D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 92O4kdBxjrM8NJlZuzisnT07sgUh822Ue2Q3WWRmH9PYoYpRFDwbGFSttzUtrzbtU5Fro+ZLBbwVa4k7WU+PWKFwvw7RNp2eVcpeWNVtqvCumDJsjP47MP9QBDeFFoXpkRR8SDNjBDO+lYr12BA43BGeHi0Jq/vYfVUn0hQqvKrLi5+RDpABoMPboYSqMV5IRW6yGAPIqOuauMbfeSdwADnNe6K0OPNy7MSwYDavv1fDOajcOXDYrZmsDK6a9V9Y3lVk0otGcETIGIyE4lTGRuc9UsUJTzhKK5XRK1dAghcB6THQvX9lWOAOvPKoYHxlSd5HIZjo8Y5EX6a12kboaSQkIorVk/lI4WF31mzlLPwdDQOJyz6vVui5OXMvpgDCBwjX1Xq1nunp6lBEhQXWxpcjNNuSmSEKFeW6O0t57R40duruqqLeCNqz/IyP+lVLQ4QkpPEKWZ9JnJyCsJX4XKsbVJI6abZGbhrr5o287JM/VVZUVfj4w3O5vuiZQbKqzHiCB2Eyx9jKoKAicRRfxz1P0Za1dsODMunv6f1PZekszpfohMCZBlO7PJyZOpi/i2psneOdI4GZlly8RzJ6DRr0ObZKVdGjrO1JKJRKQptDnsKVYmm9VdBtKWlhCHp6cXOnB4dy+HSdUalHOPJbPEkW4gTz8GJQdrbnW9UpuuYQ4LkFkA2lK+t3mEyGdqcrnM4+RfzdxqslBvAUtrilBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66574015)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(6666004)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0d4S2k2SE9SaXg1Wklzb2s4WHlmRHJSM1FEY1FWZ05yRkVlUEdhVWw0MXcr?=
 =?utf-8?B?dmpudTdKL3d2bENvYW1WVUtsd3dxMEluUURoOW5TcG1DT2pMVTdJTGFQVVpQ?=
 =?utf-8?B?SFp2QWtCWC9xQjB3MWluaTcyRWRJMXFsL213eTVnM1NOb2p2Umd0emRpa0Jj?=
 =?utf-8?B?SE4veHlpT05lSFQ1T20yRlNiWG9KTVRHQlpUUm5nQU1lcUJmVGh5VVVuVzIw?=
 =?utf-8?B?R0VpdzRTcmJTa1dXZUg1cGNIS2RzdThNME1DUWVOSHl1S2hBaUtsK2Q4S25F?=
 =?utf-8?B?eGdrcE9reTMzaWVxVDFNZWxIbldrUk9kY01od0FZQ1RaTU1tNDBJZFNpd1k4?=
 =?utf-8?B?QVRXK2lFUUZUT1BrcTd2REFFRTJtZmxMb0hIYllCVFFCS2ViUDlkak1EMXFJ?=
 =?utf-8?B?RE50Wk9BT00rc1VEOFBBbUZjd0tsMHFWNFRuOFBVMlE5bkpaazFsQUtRbmIx?=
 =?utf-8?B?bjlOUnc4TkI4RFJWejRBNDZwQ09mYmdLYjdOMGZ1WWxOanp5UHVYNG1xT3pv?=
 =?utf-8?B?K01GTHBHQkpEd3poRjBaR1BwOHhpMkxYejhPMU5IanAyTVQrSVJYTHdpZmwr?=
 =?utf-8?B?TmJ1cTNPVitjYXpSY2VGVlp5cWg0NG1LNFBQV3FyVU96cGRlTWpGYWVuWUx2?=
 =?utf-8?B?cHEzNFBvMkFadTZKQW9mTTdkckZpWTdsS1hLZlRGb0FPTUNVMWNuTHNwMWo1?=
 =?utf-8?B?d0FYbTNJV3YwakRDb0U4aXNTTys5Z0VoVXNwd3dQS1lQRVFUendmbGk4MVR6?=
 =?utf-8?B?Zy9hVlFnTEJRN0dTRGRRNjVxYkN3ZzNnaXNFYkRRUXRQQ25na3EvZjRkYVZM?=
 =?utf-8?B?NVlOUStDR3Q5WW11ZmtPRmg1R3IvY2xLMHJrZ1pBVlYyTzV3Y2h1Wmhicngw?=
 =?utf-8?B?bWRuVE1CbUZmd3FxZDl0L0o5Uk1vZGR2bVVLTm1WUHNueGd0RDk2YThSTURR?=
 =?utf-8?B?aFNTbHZSb21rNW9UUkxpM3lYQkwxajlKbThHWkYwMDg2eVQ0V0V6NHVNWisz?=
 =?utf-8?B?ZEtIeWxEcFhIS1dlNytpcmpnSWJsTFB2L0hDTVM2elZJVEVEekNtU1lDNllp?=
 =?utf-8?B?Y0gxMVZ6RWEzcHRUK0hsT3FmWFV6U3dVOUhLZEdHdFB4TjU3cEY1Zm5xbURS?=
 =?utf-8?B?MG1mZXJiMGkzUE9qQTNDdDUrSDc1S0FKMFdyblFocXkwZ0hVbkF6ZHN0Wmtt?=
 =?utf-8?B?RlVxelRRcm9XV3VyRUtmRGRMbW96Ylc4MWlNcEo2UlEzMm1JWUFsSSsrU0Jh?=
 =?utf-8?B?VzV3bExqK29mQkJvMHNWdS9tT1laUUp5djlRWUlNb0pXeGtBcWN3QzFMNGVY?=
 =?utf-8?B?eU8wSktjdEZ0M2V1RzFNeXFOaGZod1FQcFY1MjhCdnFCdCtGRXVlZ1l5VEpa?=
 =?utf-8?B?NUptOVNWdG94ZVEwazZGSi9BNVpGYWxOSmFEZHB2MWpXa1JMWTkzZXFOV3J2?=
 =?utf-8?B?dnFsdGQwT1l6enovc21Sc2s5UUdubzZDUjR4dU83N1A1NlEzN2RhbzRPdVcx?=
 =?utf-8?B?U0ltanYxR1Roa0tsVFNXdnFnUzBiaHFhYmVVc25EWXdxMUtEekowK0MwbFdJ?=
 =?utf-8?B?SGd5VUV1UHk4UVpRc1pqdzAzMVdiSkIva2VnR2d5WEFtQ1hNUDQ3MjRIT2Zl?=
 =?utf-8?B?TnQ5TTVjRTdNVTFhN3FZL1JmRzhhbU9peDdxTDJrbC9pbUFua09KVEFPQlFi?=
 =?utf-8?B?d0ZmUUtwa1VsMk1tL1h3ajBiUWZIRHVDM0pnOEh2NzJlVzR0cDZjcXVFeCtD?=
 =?utf-8?Q?ZZ6GRc4+bMCwncgAZxqqX1SxsGRnddWZRriEwxo?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6403d494-b881-479e-60bf-08d97690d740
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:10.9783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zLTvTeDA0Doq3TGHojxKbM89HeZcvkHSq/doNDyfUEIGsf3a9nZrooGZOdAD6TBQJ2/9XNBD9gwF6e0Ld55Fpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
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
