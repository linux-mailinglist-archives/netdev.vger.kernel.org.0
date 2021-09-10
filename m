Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF032406EB0
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbhIJQHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:07:00 -0400
Received: from mail-dm6nam08on2082.outbound.protection.outlook.com ([40.107.102.82]:61568
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229448AbhIJQGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:06:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWaU2SzGzF+qggdxLtZq1JeICDs+8nxzlFrKEpj3pcEPPhUJDLLWz0t6G5jx56m4VxAVVUeHainBcqb77JD4Ej3IbRFQuukiVuaiJ2Os/7vSqYbxVOIw2o4B6o2fUbIKmRzfG28jR2fkBcbbRFIGmmIxU9wSGSboDukyJlIpw+5nLZ5GKY35KFEycQOVN5Uh/+ZcwW78QuGhp4SLW8lckYK3GsxMt/F/TFYDgENFHLKMsRsXtQ9FIHjD9/2KHlJ/rPMn6vnMiEfF2fGmMqcinpeIfMyQFyIsA3KpHNUAVDa6mYfHm4C+Ydn6xe9H2KcKht5F5O8rgt6AHApZyWgQ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0w+Xz727jgVX/irNEH9/BqvsPmS+ssDQd0a+YfBOGac=;
 b=PHW3pDpHb5orRikOdcrVgaaIuJ9ByGE9sKk3PDwPKLRLmd2hLbP3RMJtHtY9YW+YUgha2/XL1rXWBr+8RjXvyX4rmDdV8zvmkfj1jdGsS23P4jrFiQd+ZXWMnU550WIOknIB0DHvJwKXhvNb00z8Z48EyZ7pgDA578iz18cpHFVjYAWw0FOs2WhqIPfpsFDvsJ6ISjUSB6GzgKoirjuicLLpVU2G4yCqYLyD6HfOFSSQesx97PHmuwiXKbq/BmyjX5JM82cQx27icaeBwJzdKXYZJN7srSvgAT4M9HpzGKP/cSt9NEII7ej/jm8h0kL1Y3enByCD6GMvpbInUaCi5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0w+Xz727jgVX/irNEH9/BqvsPmS+ssDQd0a+YfBOGac=;
 b=JNJcVfmpaeGLD8nErSyssdyFZDCXYFUhEFwDesmzDYjsGtHPnOPj+Jo0lsGM1aqDCcS0GHOkYsipfA7iSsK0P4KRfpJv95s2qlQB47efM7wjBjLgNYJldysivXdsvbpcT8sEtBXb7sMeX3hwhX/6q3Idk0A0IxQCgn2Sh/wo5Ik=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4592.namprd11.prod.outlook.com (2603:10b6:806:98::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 16:05:37 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:05:37 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 03/31] staging: wfx: ignore PS when STA/AP share same channel
Date:   Fri, 10 Sep 2021 18:04:36 +0200
Message-Id: <20210910160504.1794332-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:05:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d615f737-10ce-412b-e499-08d97474d3c3
X-MS-TrafficTypeDiagnostic: SA0PR11MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB459276F3AB5BB13BF8B5C6EE93D69@SA0PR11MB4592.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2EODoa3VjzFV7zowESBQcHs6/DFCjEjtJUU3d9OkIrbdoHleoRaAjy9jJYOO/S+2mF72EpbnFfe+oUSRI+c14oe/B1ir9sYmkEessH0kbdxYK/Wry8LJQzG3PkIO/9GqhP2ybKt267H38IGWZpGPJgdku1WKdjo3s7/eF6fP4+vlKSSPGRxxmXcF5abpvk/UNiLPV9+tnimrK1Cw/N9V1sEW70ntVKllZyOkYGn3UYjLuE3IfPZtwQijKe503nMXXMZu1mq3vftFf85EELo0r9abb781Xx+YNLM+eshMW+Hwrn+RIlghPEuMzDn+3aGZ71Q7rObqqVtXg22QCnfGq/fxu58WXwzxhX0yOG643Lqk7dQ5rNzs85seqwG0seI7R/+/thW2ge9blS4LFxtu3Fy4pq0XfR4F57SzMYnWJ/KHUo/wBGtJC+IHr6R8OczPuK2PhKSyvCIXR9IORfLuFSYJCq3ULczKnkFQgbJOWXvNkzEDTR/ofz+uDPstZL8y3WRRqovGHpYB9hidUjEEMDMdz78C+pEQxDYRiTEbsXFKLT26zkUUbPNH8uKChlu17XX5AWvrWAR8o03W0qw7vsolMuFSWyLjxsOP/UkpD/8/soDYO+CPPdzTUumrk6+8Hd/wQQmIc/4Uw6mxsa/U2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(2906002)(66556008)(66476007)(316002)(66946007)(83380400001)(66574015)(8676002)(8936002)(36756003)(86362001)(6486002)(107886003)(7696005)(52116002)(54906003)(2616005)(5660300002)(4326008)(38100700002)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2tZM0lZUWphemlEYWxqRlAwYnhXMlNrU3NwMWpVYTdoT3piV0psa1ZaUzZ0?=
 =?utf-8?B?S0l4ZWRMcWpIS2RzWU53dVhEcDVvaUJTdnpCQWIyNjdDU2ttcXZXZHVMN0J4?=
 =?utf-8?B?Y2h5ZloyRzRxOWxrNXJ1bm9jTXBkR0YvNkx4SVlrbW9yZjdWOVZVRVptVDMw?=
 =?utf-8?B?cm8vYUdyd0MxOHlvdThDMUxaZVhaK0JxYlQ4NWxhQmp6cDQwOGZLZUNZRnFZ?=
 =?utf-8?B?Sm9aQ2NzZXFSM1h6eE1jWk9CditVbjFmTEhtMzdnUnQ2Y015a2g5R1k3UW1P?=
 =?utf-8?B?T1JUL3ZlMDBjT2ZKWDl1MnBldlVma2hmeHQ0RENVMlpBcC9RWVM2NTdzL0h2?=
 =?utf-8?B?bHdYUm5DbTRBMzErRzl6UW5DMDNSR2hYYitURmxxc29yd2VpZm9UbWpyK1VH?=
 =?utf-8?B?bVVDZkhoV2gvRGlqaEpJdGRTN05rakRnU2E5amtkQlpQVFZrdHU1d3I4c2hu?=
 =?utf-8?B?MExwTERhTGtrYlZqV2t4SStlbDhKVUFnT2IxUldjQmdmajlDWXk1RnBFUHpM?=
 =?utf-8?B?Z1lRazdBYjBuODZLK1ZaMEl5ckJDckMyWkU2REJFVllueUhhaWlFRTVQWlZH?=
 =?utf-8?B?Sk1DU2xJc0RoaEhEZ1crZHdIZGNYbjV0a0ZJV1lQQS9LYzEzWVdhSGVJZ1ly?=
 =?utf-8?B?UHE2ZG5wdmkzekxPdVV1SGl4UlJ4Z3RWdm4rRE1HRS9kK1RWeWg0SWcxZUo2?=
 =?utf-8?B?aEFYZEVla3JrSXBmUmdwQ2JzcG9ka3BmUDNJUzNEOGRhTFpINGUyWGd1UjdX?=
 =?utf-8?B?REtTTUk3dTJzY2hyVTZIRmZzRDFrZFpONXRaa3ZGL2JTRm0ySkwrZ1VNamg5?=
 =?utf-8?B?S09CblM4c0l1dVFHZVlZaGI5THhUemNlbFlSWjcySmxUWnBndWtsQ3o0azZl?=
 =?utf-8?B?clZMZ3N6b1MvbDNlaFdCOVF4dmdKcnpPbzZPOUNwaDZldWp1eDdaeERWK2Ji?=
 =?utf-8?B?UHNUbjBNREVGQXZOV3l4enpXTVRiK1R3QUp1czJPZ0hzUzM5TzlUL1VESCta?=
 =?utf-8?B?ZTZ2eVVCYUVuSytGVmRUb2lTcFpONmZKK1k4eDZRVy9MK2FZT3gyNThvUFVP?=
 =?utf-8?B?cU5JeE82YWtYSm1saWhCSTAvcUthNVFXbjNHaFpzb0h0VVRDZmlwQ1FEMHVu?=
 =?utf-8?B?dXpGcS9lUzR1Nkc4ZlNPM2l2cWZKTjVtbEdFL0pRUFViTDBmU0JzalNIcXox?=
 =?utf-8?B?Y2JDUkV5MHZ2dlFqUzl6UXVWbXlacVpZamtRbGM4Y0ZZaWxmRFdOK0lWdis1?=
 =?utf-8?B?NlNNRk1pVmQ5eG40V0NzY2dWRWxIdTNhUXNRdk1NYkc0RmhTOFh3MnhiTS9S?=
 =?utf-8?B?ZVRpckZOTlpYV2lCRWo4dE82ZkZnNzhPTmNuTEpIdXQwUnVhemFyNm5hUXdL?=
 =?utf-8?B?ZzR1SnRPTE01NU51MDJRMnNtcm1UenFBWHB4Z09GNExaajJRdGJXZ2tQUVBt?=
 =?utf-8?B?WHRKN0k0OVVlOEJvc0JLNzZ0MHF6aXl4OEd6a2J3ZDEzY29XRk94d0xSY0RQ?=
 =?utf-8?B?elFUcUlpRWlEemlvZmllWnNjcE1aRTJlN2NMWWF0NFM4WTdqSlN4WGExNVk5?=
 =?utf-8?B?QS9GM29Hdy9PRDBvRG9ZTVZ5RU9EU0ZVSDk0VHl0VFd4ejlxWU5pQzZ4ZVk2?=
 =?utf-8?B?WHdZV21KaStNcjVrNjRsRE0rcGh1MDYzTU94RVd2WXljMldrN3VJdThOQzBi?=
 =?utf-8?B?NTdzNlJCMnF6WnYzdURhejZkT3hsU1R1cThmZ3dIL2JuaU80TnkzVklYcjRC?=
 =?utf-8?B?Zkk4RllZRlBwY2FnMVFnQjB2R0FjOGdYSG1WcFdkRzN0TXZacExJbHhTUkdH?=
 =?utf-8?B?RDI3eVp2eDEzMFZOUjhXSDFSRTREUVdKWDBDSVhNZENyNTNWYTZtTnlrWTJ0?=
 =?utf-8?Q?HSdRfI5C5hdq3?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d615f737-10ce-412b-e499-08d97474d3c3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:05:37.0573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: csXiGCsefQdRo/M2VmgAbHzyug6fyeBi3F72GvUKvzoGY02enUSFcqwK8Cg2V6Chy7MwDAeH9bOVyWap+uMvhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4592
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
ZGV4IGQ5MDE1ODgyMzdhNC4uNTg0NDZmNzhkNjQ4IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
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
