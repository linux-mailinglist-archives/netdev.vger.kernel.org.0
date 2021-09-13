Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1ED408B88
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238525AbhIMNDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:03:48 -0400
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:19681
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238050AbhIMNDj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:03:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwcCbrzkwRPSABJ7/iIsx53EDBRb7UjOmfZDr8j65X1l/fkIvud7bBPn9Qf8ztOM/UbpVzmnYu8jAGMkxwwNbuvo0q8eTr7CEENQv0Oh+SxHqFcZpWAK9weOxUqUHXsFxER7sFn+GWcwbaJu1tXQiKlwwtWkFwX0fpx6J0nuj9Q91gub6iw8Q9w/0ihLAYyYd4jINlWimv6giO1xviyh1ZGeA1BzP8Jb4tdYuiMJyyrFcDfvzNrKn4RpjRQrf2cadzziDNa2E+gy0Ho+krE9v05ehsMGXaqzt8qN5lBelt3H5APDiWLp7Ml7bSxNtYbuA+cAAeIyIzu76OXVtyCwIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uUO5xCt55CNozRJ34OB+Ps7TB7KSGWz/tLv7tV6TOJ0=;
 b=mmff7e/76xf5zHuae86eZMyZL4MAAug6FmsXj+nuL5XRB5aqJ+uNUanCZSMHH/NrEEqnX248/N+lvYWxfP/y1UsL5sqhdRxJwRkQL2zEwBULsnwcNqwbcRuElKzVjw3uD6GBEWwpXwNHRy8hxliqctlqYIhkz9QQrcBBs4+zy5+z7wrf4vYVx1D2PCSq7ubzcW6wVZuMOU7x+QXEwU/MRCx78hxD3NcOzVnFOE3+mu8Z3GG+JV/DcAYe81b7Rz7IKS3Cj9cEGQAmekq/Uz1wLMKjTF5vPWQxL3aLDbgZoFNO5B9Xjz9wcoVZCZlDu8I21q1HsEdgsZX72DKxhC4yPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUO5xCt55CNozRJ34OB+Ps7TB7KSGWz/tLv7tV6TOJ0=;
 b=decHrQgmbhuEgyOWo2bGtREPuFpGtE+5BhcDYuAaZ58Dp9ir+R6qQWKTjYec/feuAVJ0BqHSp6MA1/t6Lcz4+G0UZSBBiydXjh25f7VP+xod6nKPYeCT9d/tXr87H9ZGPwlwdvZ4rkdSPWjaOmj7SOAmAhStKsJPghvgjI6AQP4=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2894.namprd11.prod.outlook.com (2603:10b6:805:d7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Mon, 13 Sep
 2021 13:02:22 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:22 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 03/32] staging: wfx: ignore PS when STA/AP share same channel
Date:   Mon, 13 Sep 2021 15:01:34 +0200
Message-Id: <20210913130203.1903622-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9acdfcba-781a-4158-a083-08d976b6b9dc
X-MS-TrafficTypeDiagnostic: SN6PR11MB2894:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB289439182A880C518DB67EB493D99@SN6PR11MB2894.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Ao/eU0WOQhNp2B67tEn/8OQRi/Ho5ts0NUCGpU1erzswlhO+Q9/b64bcDjYRhg+cPPUD4ImlURDWkfOgYVZp3uKPfWWWbzZcGQht+CKPa8pEPi/Hr6ExjR3gkU6impIAOuSK7q9pD3cuU8m3YFAnyZSV7UTKRmN6EPB04XMZJWjT2eAlFn/waKUgABlqULTaM7FjmSKpUFFph0v2xNI+vCbWnp6PSen5kLKlSU1ezN0A5tirY45yJoAezk8i4wjcA4HfK1ToDI4qQxVWoaBvnLV2WeghCm23MeT8sw2R78WpYQUTFRm00ZqcjomBH4+PyOCSLWmex82NecIz6gA33yKrz6unHNmdNu8/RN7tAY6RDLNR1NNWiYyI9N0m/n5NfNDjDm+Rp98V8JsOE2WgFOkROAee66xakQB1MpwYlVmKcTUXHcuYyuK+LDAy9FTO4wvvTU26VW2WIyIQeNIWdq9wLyZV3LQYl+vfex+3kDeZ46hL6L3vNGv3+Slob0RXarrCo7vaqPn3JWWEGWbTDSpqQDyJFu3RWt/fSVhx+6OLzFDmu3AUbPZvYgMqf/cCRukRidE7H96SkGCxpiGk93y+XgO1tqCg1rF+ZM7AVs7798zSviXFzQm5KAu65rdbMGrYpuUrV5XEi1G3GqZwdUe0OFyhDr887vJyvL+1T2yFJfZtLezrBzWkIXAJgq5f+gcdYkwp1NakJ1Tr838lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39850400004)(346002)(376002)(5660300002)(26005)(8936002)(6486002)(38350700002)(38100700002)(66946007)(7696005)(186003)(316002)(1076003)(8676002)(956004)(478600001)(2616005)(2906002)(52116002)(4326008)(36756003)(6666004)(54906003)(83380400001)(107886003)(66476007)(66556008)(86362001)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cE50aXpzRjlwYytqeTZJM2NvOS9IZ0NVT05NdGl1aDkvZE5mbHVtQjludHh1?=
 =?utf-8?B?a3M1KzFKNkhncDgyTFdFU0FidDlhVGdkaS9wbjBjclVFcCtsYkhhNUNwZDlL?=
 =?utf-8?B?N2FXM0k1b0tBL0lCNEYzMTRpTnRkNkU3ZXdjUHdwdE9ubjJlZWNPcXJwZmN6?=
 =?utf-8?B?bWsxak1oV1EvdFpjamxVUkM3ZmQyZndEV0c3TlZLZmc2dUZYaUZrWHdKem5S?=
 =?utf-8?B?UlpsWWtCRVpwR0dFVEp0K2tNcEF5bkM0NXBNWnZreHdSb2E2VG9xMjBlbjk2?=
 =?utf-8?B?SDNXY2Jwc3hPRkU4L2NraHdrZGVXbXd2ekZBR3hIZ1NNWThTYWkvZ1NDOXkz?=
 =?utf-8?B?VlZvc3ZjQnI1Z2NaZ05pdUkxbW9IZTZRNW1jVXQzd0dUOUh4dTFhVEF4YlFn?=
 =?utf-8?B?YjYyVjB0ZkprNUVEMW9ETVJuZXkrRFJ4bkJYVXJ3bTFWbzk5N0FnVE5EUGt4?=
 =?utf-8?B?VlFWVytLWnY0WE5sZE1UTWhWR2NLY2l4dW05azk1c2lGQytyN1hJbEJoeVQr?=
 =?utf-8?B?YmRIT0NLZnZDNlRMVU11K0h4YlpFTXlHNHNQTHd6MW53SERKT2RBRGxvclQv?=
 =?utf-8?B?Qkg1cTVaVWlLN3hxY21NUFg4NCtockpOSjI1L1B6SXVsSnMxOUdyVHJhY3Y3?=
 =?utf-8?B?UTRNVWdwUXA3NkFQbmpkZ2Q5WDJEUExpL2JtdkFnZ2VsbFo1V3N2NG51YjY3?=
 =?utf-8?B?aGF4N1pOM2JDdmV1M1dSdEQxbGI2WmJycHhxcXZiYkZCOHM5WndtQVVxeWV2?=
 =?utf-8?B?QUlVVnRld01MSCtIamZaNnB6ZjFmdmdMa2ZnZjcvVURSNFNaTUxnVzhlN3VG?=
 =?utf-8?B?Z2JVSmowLzZTVDJnNVNhME1vbllhOXRUOXZwK290ajV2N3Q2UzFuVXgxNloy?=
 =?utf-8?B?UkNQcFNpcnovZFI3OHFBLzZYUUVxQ0ttc25tRXJxUzUzZnNydEp2SUozNnpt?=
 =?utf-8?B?SjVsZmtBRk9nemVuT1dzOVc4bWdQamFPVUkvd0p2c09pdWhGcnB0cUdyWkIx?=
 =?utf-8?B?b3d0UnJ4dlk4N3J0YkRERFY3TDFnWFNtMWhvckhpTzlwZzlwNDl1Tk1sVTMr?=
 =?utf-8?B?WlMyN29KT2VxckEwRHgrV25ZZ3VRYWtMZDMxaFUxbWpSeWt2NmRSMFkyOS96?=
 =?utf-8?B?blZRQkN0ckFRR0M0WnI4dno0NUhVeUg3N2kxaCt0dnFRMVJSbU1kOE90ajdt?=
 =?utf-8?B?T0U2eG1XTktZUU9pampwdWY1bzlySkRSaFpLYitXMGhlYnI2MkcrWjRKSFkv?=
 =?utf-8?B?VUx1NTMxeFlFTmJ3S2xkMk5XT3ZFZHpVSkJnMlVEUGdkR2QyVHZNdWhFdy9o?=
 =?utf-8?B?S0dENzM2U2owQWxwTEFzMUozb29Qc0FLVG12VHd4Q2NVaHI2MzB4VFpsOWRR?=
 =?utf-8?B?VkJvZ1A3YThQb09teUc3VEhCcnBQSXk1VmxEMTNqSW0xWGxXOUJqWi8vSmVR?=
 =?utf-8?B?V096OG9kd3FKRmNSUVYzYXVZSDAxaDh0cVA0djRKTEs1MHhnd0o2QXlMZE9M?=
 =?utf-8?B?VXJERnJOaUpFcHF4Wmx1TUR0aU1pbFlDMXJMQm4wR3JUanMzSGp5UHhvdFM2?=
 =?utf-8?B?R0hRNlJ6VkYzbjBQR1Jmb3M4R1VrUjNjQzRnUVB0dlczOUp5U0xERlFUTWJs?=
 =?utf-8?B?TVhFWmtIQTRUYVJCMHVvaUZXMlJTUzBVYlVoZmQwRlg5NHZmNDNEYTUvbUNn?=
 =?utf-8?B?MkhUYjFqcXQxU0pma1o2Rk1XckVubmpmOEtUdU1GU0JRL0t4bWJqVklQM2tP?=
 =?utf-8?Q?RT/hgGlxCdsqLE/2/RYiOZ9K9JmMoOdWi9WrWrQ?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9acdfcba-781a-4158-a083-08d976b6b9dc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:22.5444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OcWSp74pUHEkBQmnB/Lg9+lJVUx8Yz0V6kScNU+Og06rbuvc361Q+OLBG8hCUUL0LMQIbyGs525/lso1LVYQcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2894
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
