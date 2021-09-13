Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E27408BD9
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240188AbhIMNGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:06:21 -0400
Received: from mail-bn8nam08on2055.outbound.protection.outlook.com ([40.107.100.55]:54369
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239557AbhIMNEH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:04:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hB4Rku8ttKmt5cIq2azaMadASayULCA+eZNrnEIfSp/ujbaqivWDu53pH2vJcA4i/n7lNHETMJmkyjrflXrCD26ShD/X6DWdaAX7c1lzp60pjYYnYh+TEBP2Fv+eLOKLASLJ94D8a+wWwbcHWXEQMxLRSeMaHdcByMkjYjFRe3Xy6e19A3g9wkSFdd+ZPqSYKYFXfnsIZwbWTdqoRytobdAniZ/EGlDe+0lAOibp+ygc+JmBrjpncjnZgUqvoeky3cF+VYDOUJpv1E/WO2LNxu+ACceK5kD23Z+DGsFkHwdBmTI+3+6CWO+856HcKA3GoXUkmBmROJy2d+OsH1j01Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=C31iDdiNELeUy/7hAICgB5wTgF2daKvEZIoAcBSDHBI=;
 b=Yazew4RVeaZHA9jHlPJKZFbz1o8DBmcGe5L1jlHCUVv3UsxwkC9IINohCbsYb0jws1crsY3RB11IxiKAYHs6I5VPJTmkq4X5qfGCzkMKVVceTFlKByv0ev/ymiXDT6Ltbh/AIfYlR36SPGHhJWhcwMr8w14XAIaw2bMveo0pvXlYIDMly/2MMya8Q+1ODag6d9mBxlEXkDXsMOpxmyv4RPG1y7xGWojPXS/qXmZ/5cJLTIoLYEEK4lZm1PjERXjo4YppsIr9GGFY4KaM4A++bCcSLbniGLdXAk0mDZvrE9o2uvSbi8PXkJHBPYo9QR2IlnC0bcN+J6Il5imU36dgdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C31iDdiNELeUy/7hAICgB5wTgF2daKvEZIoAcBSDHBI=;
 b=fApnPK9KplgC4ZJ3rQprZgwMo6ReM6op5RRTfM1SCKzCUDjyGTelK13ubw9H0DEixdGM/jCSJ1K9n7EkqTkHOzVPOJcGV9j+K7axu1ys6UmxBSo8LYzduca2O0936SDl/b1W0dvCt4FUgsvtTOhTU63xaGVF4uVaWCFIdBhKQJI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:36 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:36 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 10/32] staging: wfx: fix support for CSA
Date:   Mon, 13 Sep 2021 15:01:41 +0200
Message-Id: <20210913130203.1903622-11-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fff0c955-08a7-4630-504a-08d976b6c1d4
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB4860EAD8D2804F97B20B31F493D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4+hY7j507rbjwH8W0MxCj4LAWT2alfaltCqWIFXv2xXY6oN6csYiwTiUVr+9GtVGYRtkIqe9a3Wqg8Q3XS61KRjB66/3WeLB4CxST9ba34gf56L7K4bXVjpGQHtDbNqIbB51WJGP/QPSoAOfuP/CnEiyhFxtvNQgSfejRIWao2G24P28BNpwXZk1RCMEQUywG036+Fkt/jhqPL10VaWxFU0tBfS7dDT2ArnTHq/HI0sPAc845Tuj4ydFPPxr1mpPWBZeMPnW6x/D3w6XVCmhFZp27eHCmGIcvP750sf9F3hQCQe4GvV4OJSpuGGZVOLghpnTkuttOO9N/6EtaElz3WQzw/RFrELYEk8TvZ9hp6il0owcPHjPdRzmLH0/Mv2V+KVGjRa08mgSBlqvlMBOspb407T/WetZZ/1a0140gC/1mh1TDdS2MzD0ELz/woCYIpKIBKgaHWwBIDToECMAtdxXu1jT3RI89Wh7DhxhQONOjyfQJUVAacLInygpG5sCnt5WT9Sla23i6Y6Rz4JZVWoM/6lb3SF603p4VAhCI1+qrO+03mbyVSP839PF5rn0HYHJJgKs0DkzJm7DE/D6vXyVb5I0AfvuVP0VWFLo+o3jxCPowPAbtiiCeymu44AHhDC0I/zxuTe0aL8zS77Q5yXoJnHCHYIJ7ig4F5p04KxrhnG8rmzgyjal1r5DALgM+cNcL6DEwRU823rsyK9zIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(66574015)(6666004)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(83380400001)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3NsNmJJbHFrREI0bUsrMEcvTm45eFQ3N0RMOEtyTE9HM1NFeTlaS1NkaGR6?=
 =?utf-8?B?Q0MzKzZnckFqN09YUXoyaFVQK05renBJelJIUm9WMVpWRVNXNm5MMGN6eTly?=
 =?utf-8?B?em40bEJzT0s3ZVhZNFlFRzFybHdTY2FuWDZhdnA5QVJiQ2lBMmxyUVNGL1dx?=
 =?utf-8?B?dGdRZkxINUVJK0hqU1hCQy9NZzhZUThMQUJnUnpyUm9lT1BFdDRWb1c0VVNm?=
 =?utf-8?B?clJrZTVWNnZsbmZKdE9FZkMvUWoyd0pEak5OY1U2Ym04aDdqd0UvcVZDdThK?=
 =?utf-8?B?b1hMQk1WYUU5T3BKRjZ0WmpmbXJLeEwwV0IwcHZQay9lbWhGQ3E0RUtET0c2?=
 =?utf-8?B?MnYzUVRaN1pmUTdLOGV3cHpPZCs2Si92cGpiQTlhRDI0VzdSV1NYVXZoMXBz?=
 =?utf-8?B?L1VET3ZNd2V6TzI5cUhKcVM0S3BFOTB2WkgyclArSlU2NXcxZGJ5WU9oZi95?=
 =?utf-8?B?eks5WmFURjVmRmd4Tng0QytseDJLY2NGc2F3NU5BeXpoTzd6ZDNybzE0SEY0?=
 =?utf-8?B?NXlCQVBRdVdWd3pqcGdnSzZCVHFhY3ZHUkhWSTN3RG15eEtscmErdGxLdlBp?=
 =?utf-8?B?RlQ2QmZtdHVOQVMrVnprWTNOLzhMaytOeXpwVzVNM3FJQ0lsbnZRNWRaS1hp?=
 =?utf-8?B?aHRqQ0RkTTNCdzl5Q1BmN0p6dnlZNUUvNEJZSm9BRTkvWUpOcWtlajdrQjla?=
 =?utf-8?B?azZwRE1PK1lsOS9GS1E0T3JLVHRYZ1ZFdkdPRkxGV3RGbCttdTRPWjY4M3BN?=
 =?utf-8?B?eFdnaGwzL0JPM0dEY0E2LzFjR3NhQkgwQmpacTF6M3hRTldZUmtjaEhCUlBD?=
 =?utf-8?B?Q2hKMkRCL1lYMlpydUdJOWcvOHc2cU8xd2VhR2oyQ1EyYjltSzd0U25CMmhn?=
 =?utf-8?B?TURIS2JRdk1rRndiVm9iSTB3SXN5S0QzOVhuZmF3emk5QnIrVmlQdzNKN2NP?=
 =?utf-8?B?T28vVzRuOVNMSTM5NFNnZ1IzOHVMb2U0S2JGZ0xSb0NsRXk4TDJvYTNLNGNa?=
 =?utf-8?B?SWdWS2dQY3llZW9ZTlB4ekZjK29hSjJEZnhOTm5weGJ6R0V4NVdoWFBVSVFl?=
 =?utf-8?B?OXlBRmhlcWFFVWRWUE1BbnV1emhlZG5wN0JVa1dCVW9lL1pJR0NtNkZQQnBr?=
 =?utf-8?B?SDFsVUwxLzAwM01FTVg4YWJuYzY3eEhSUkNGU0JST2M1V09ZcmZHRDQ2U3Nr?=
 =?utf-8?B?Mk9PSmo0ZVhPNjlzOVI3dHJkdm0vM0pvUWFvejJaM0F5YUlLckRhUDUvK0lG?=
 =?utf-8?B?UXh5MlFXNWc3am5ZMjF2c0Q2eG5URDZRS01QeEhtcjRFLzRnS3lMK3U5WTBu?=
 =?utf-8?B?UnpnYWtlUFEyZUdMMHRWSkFQNm9MZU1EaEFPMU5XQnk2WFNnbVRnMkl1MXEy?=
 =?utf-8?B?Tmh0akxXMGdIV1lQeEM5ZXJYUEJGQWFVZnBHZnRmMjZRaUtiS3hGU2g0dzRt?=
 =?utf-8?B?STFaMVArSWxtcWFFYkc3RDlTOWFiVHFNZjlJWUdpM1hPdW1DNnByYmM1d3o3?=
 =?utf-8?B?SjFFVi9PWHpHWXdKczNvejJYaWkzTEI4WkFzalEvVU1JZTZFajlTNURoTGJO?=
 =?utf-8?B?THgwMDhnb01RVmlZVkFLeTdZM2t0TVNSVElUK2hoZ3krVnB6TWxpTjk4WGVO?=
 =?utf-8?B?bENnWVRjaVBEa3loQ3YxMXRPRGdubmgycXNhcys3aXpIR0tpbHc5V2lNTlRU?=
 =?utf-8?B?dXRCVEF0eGVPbVNMdDBMQjNYbkVtMXR1aStpMWsxbmhQUXNXOEx1ajA4a2sz?=
 =?utf-8?Q?ToUjySLUX81nzP3UWLBcMf1uAPbnkkHUPwW+xv+?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fff0c955-08a7-4630-504a-08d976b6c1d4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:36.0516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLqsA8AC72ZUod6OB5Yk+9LTeTzcArweroJvKHtaQY/bbrVebC89m4+rpF61Ms4afPACQ+H7uqN2ilkxPZ1JUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IFdGMjAwIGlzIGFibGUgdG8gZmlsdGVyIGJlYWNvbnMuIEhvd2V2ZXIsIGl0IHVzZXMgYSBwb3Np
dGl2ZSBmaWx0ZXI6CmFueSBjaGFuZ2UgdG8gYW4gSUUgbm90IGxpc3RlZCB3b24ndCBiZSByZXBv
cnRlZC4KCkluIGN1cnJlbnQgY29kZSwgdGhlIGNoYW5nZXMgaW4gQ2hhbm5lbCBTd2l0Y2ggQW5u
b3VuY2VtZW50IChDU0EpIGFyZQpub3QgcmVwb3J0ZWQgdG8gdGhlIGhvc3QuIFRodXMsIGl0IGZp
eGVzIHRoZSBzdXBwb3J0IGZvciBDU0EgaW4gc3RhdGlvbgptb2RlLgoKU2lnbmVkLW9mZi1ieTog
SsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmMgfCA3ICsrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBhZmYwNTU5NjUzYmYuLjVm
MmY4OTAwY2U5OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC04MCwxMyArODAsMTggQEAgc3RhdGljIHZvaWQg
d2Z4X2ZpbHRlcl9iZWFjb24oc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgZmlsdGVyX2JlYWNv
bikKIAkJCS5oYXNfY2hhbmdlZCAgPSAxLAogCQkJLm5vX2xvbmdlciAgICA9IDEsCiAJCQkuaGFz
X2FwcGVhcmVkID0gMSwKKwkJfSwgeworCQkJLmllX2lkICAgICAgICA9IFdMQU5fRUlEX0NIQU5O
RUxfU1dJVENILAorCQkJLmhhc19jaGFuZ2VkICA9IDEsCisJCQkubm9fbG9uZ2VyICAgID0gMSwK
KwkJCS5oYXNfYXBwZWFyZWQgPSAxLAogCQl9CiAJfTsKIAogCWlmICghZmlsdGVyX2JlYWNvbikg
ewogCQloaWZfYmVhY29uX2ZpbHRlcl9jb250cm9sKHd2aWYsIDAsIDEpOwogCX0gZWxzZSB7Ci0J
CWhpZl9zZXRfYmVhY29uX2ZpbHRlcl90YWJsZSh3dmlmLCAzLCBmaWx0ZXJfaWVzKTsKKwkJaGlm
X3NldF9iZWFjb25fZmlsdGVyX3RhYmxlKHd2aWYsIEFSUkFZX1NJWkUoZmlsdGVyX2llcyksIGZp
bHRlcl9pZXMpOwogCQloaWZfYmVhY29uX2ZpbHRlcl9jb250cm9sKHd2aWYsIEhJRl9CRUFDT05f
RklMVEVSX0VOQUJMRSwgMCk7CiAJfQogfQotLSAKMi4zMy4wCgo=
