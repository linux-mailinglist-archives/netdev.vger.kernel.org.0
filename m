Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1597F3133DC
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 14:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhBHNy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 08:54:29 -0500
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:23265
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231316AbhBHNx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 08:53:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdigEalrUb3Fa939HUV3ZMgIvOaxiZVNumKH74WjxP910SVakBYplS2Ev8s99+JTXNG0BpwMR1z4Ka7ss8oQ/mr5i2M6qQKcCC+ZGgBxcOq5qXe3FTd0KGCnrofzQGGqNdjHE9+4jfxyBHuPwGTWMYzHmBvkxU0O7e73AcgP6TUEILJqQCxjbJsB7q8l7oGLENz4qFjE1hsye5t3wLmDK5azGzjKbxeZRUqOnctZt2qqW36ja30PkpYHMAfFNP6o1zpMG2N7/qrAJR8zVc/WS0Aa7da+6piNTPmapo7MGF8wGeH30hJ3JbRgJlgfCzDkI0aVRmkvGhfggJZpRQQa7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYbRvdr9gWXYHoiohk6V7nMzJQcS0YgE93JznW8LOTw=;
 b=ly3+YDe8UJo2e1/3MGcel/gGp7HPKJQqxnVUf4vn22qbEHzHu9Qz+n/XKQkvTvaQu/jo5kvuFJqLz1AD7/qBqQNySCWkuIN5ITQNURohUmRyzhHRQBvEp8C7SVUL8vzWyhP3h6jfr6mWmMMlHuz6OWwnNSDH5IxI/CgBSCkSbOio/QfaWccFEC+EjmZWJNbaWhr0DWr14E+1mKXrDu2Z38ejPqw2DWCmrDG+I9/0owNjtmRipAUbkKfO/bCb2Z/D1con5oxCMuQbn1D16LHPv7Z12Ev5h7Nmbzbm+t3cyarV/a/n5wr6hpO7G292a466kMBEQZTcS1aTq6OfZ3BuyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYbRvdr9gWXYHoiohk6V7nMzJQcS0YgE93JznW8LOTw=;
 b=gZyq66XZl6SZaLhfvhgaZ89+Q3DDRlNpCHTW6ymtRA/4nqfxNtqpSj8Ui+H4Nl8cr7UsghLiCqLiZoO5d9SqsX6/DaWiSLc+42DnU/eLM740nAYOVLW2DOR5ys0rK5BO753nHGfsagAEf7SDt14Ci5Aof3LqFrMUO7Rztdt90mI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4969.namprd11.prod.outlook.com (2603:10b6:806:111::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Mon, 8 Feb
 2021 13:53:06 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 13:53:06 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH] staging: wfx: fix possible panic with re-queued frames
Date:   Mon,  8 Feb 2021 14:52:54 +0100
Message-Id: <20210208135254.399964-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.30.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-ClientProxiedBy: SN7PR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:806:121::17) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by SN7PR04CA0072.namprd04.prod.outlook.com (2603:10b6:806:121::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Mon, 8 Feb 2021 13:53:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65b6141d-5834-4223-dffa-08d8cc38dc76
X-MS-TrafficTypeDiagnostic: SA2PR11MB4969:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB49699C817374377B400BE655938F9@SA2PR11MB4969.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cVeBZjP0o4r9SJGtvz8ZKCvy0olOWhzvidJ7D9p2l3m2Tqk2V052eHuDXAbffgbBKdH4d8kVomnCM+h37l1ivKuv4cNooA3B3mX19Wp6Cst1ArUFeEh0KqZptQoIidOn4Ksyw3QnIKBmikijkh1pUwinrGzxLIB6LcUMZ8j34pfH4oX23JECZaPwBFEtSjzSxEOcslY4DZW6WKkXMZ6wiKohNC5yYdABN+SxDcVDotj6ZNWeHXKg9S1Czibw1DVX/NN/lrryRugzZ5w4GfrT/+jwAiYVTJI4eD+Wver37GR5jv8z9iJXLn1f5O2xulaWmiRaz+MSGj3vRMdcwGqZlOq8m242NQLQ0JGY1y22YPOlt3tx6t8y3oCFud//dXT82cNkLd7zI216mS1pY5fOOl4eczZQCRs3abrFjqCxvYaSZML6CbYp+/0t0DfnaUCqGqse9FAOSCzS0LalETKAY3D9wjNRf9xa8gqAzfFYMA4EVW3kUCUoRtP8IJxUIeeIaE1+Hh0lbeUrSUFaSl29Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39850400004)(136003)(346002)(396003)(66476007)(66946007)(66556008)(186003)(2616005)(52116002)(86362001)(16526019)(2906002)(4326008)(66574015)(6666004)(5660300002)(1076003)(54906003)(478600001)(7696005)(6486002)(107886003)(8936002)(8676002)(83380400001)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RDVrTXRUNkNuQjg5MnpobDFEVW9ERTUwN1p2TGo2U2lxNzNRa2NRUFRFUHlK?=
 =?utf-8?B?VWtQelpYdml4cGFJZ0FFZ3ZBUmFRMWo5OWFmNEJ5MXc3MjNzdlRKa2Y4b3U2?=
 =?utf-8?B?NlhwOTV6U3pCOEhHSGZ2Z1NybU05VVJ1ZC82MUtrTzdGTzJROXFZL0U0TXNB?=
 =?utf-8?B?SHRBdlBjMlJLZUIyMHdaV3N6UHJsWmtTdSs4WVFMZWVlWW9ZQ1ZibXEwRmNq?=
 =?utf-8?B?VDFzSzcxNHg1c0w4cE1hcjhqR051aitSVjFQc1A3M1lWQUJDNkV4Ni8vR0VS?=
 =?utf-8?B?UXZlalVvY2tVd1ZnYmd1ZWVEM20ra3dTNUJBTEFhQWt6T2dPSjBRclVydi9k?=
 =?utf-8?B?b3RDNHlEakQzZlF0Ym9DMWpHN3ZteVJJN2pZdGQ3c2FDVXplM1FPT3QyZmw2?=
 =?utf-8?B?SUJ1KzdnTlZHMk5HVC9reHpPYStOUmlUTXR1b09mWS9HTmgraGtwR2dPTWUz?=
 =?utf-8?B?N2tCZ04zYVpCa0dqT3JWK2VwR0tCeXorVXRLQnBCTG5qcjhPcDFTbUJCY3U4?=
 =?utf-8?B?WURkSm80QXNYUlBRaGlPMWRINCtkVXRLZHdIekhoWTMvb3FLMHhMYkdIQkRz?=
 =?utf-8?B?UmZTL0ZFUC9nNlZHMFFFVVJ6Y2FVRlJLZ20zdFc1MWdEMnAwa2cxTFhoaWht?=
 =?utf-8?B?WFVmZEpGd1BySEM3THJ6anFmQ2dqRHM2QkxtcGJMRFAwdXBEbmRDWFlpRStC?=
 =?utf-8?B?enU4YndBWFNQUUFiK2NrRG5OTlBldzFwMTJ4ZENGSzVLRXpUejBVK3BJZmlw?=
 =?utf-8?B?VlBEUEFmQU1VVHhzN2RXWG9HeWZFZ29oQy9JUVNNeU9MYmpTL3NsQVRueVJK?=
 =?utf-8?B?aFZLSWRNbk9UdzZnbDlaaTRWb25hZDgrcHRKV2lmZy83VGdmaUZMQUJiWFJX?=
 =?utf-8?B?VENJUFlod0JvTTRuZytTR3l0RFlGRE1QZWVSZ3JSdURGbzFiQ1dUS2JTSGdm?=
 =?utf-8?B?WHVGTmRHS0NSMDZUcDByTHRrWkxWTGp1cDFEVXBpczFFRDhqN0pFY2kxekxY?=
 =?utf-8?B?aUFoYXZQcXNYWE81dGNxdm5UWUIybG9QYk9UNTVhV056MWV0c2x0YlIwSnJi?=
 =?utf-8?B?L3lWSzdiRkp6a21LaUNXcW1hNzM0eGpvaEltQUhhOG44Y3hlVlZRVDF2cnNj?=
 =?utf-8?B?dWc5VmZHWFJiVWo4R2hzUHRPbWpKVlVKdHFXN2xnTEQzQXBDVE90djdWWGVC?=
 =?utf-8?B?UXdnblBHOUNWRUtVTUROZkNzR25vWVFtUDdvTldvK2ZXNG5pZWZRVnF5c0ha?=
 =?utf-8?B?QytxYkNRSmJMSEJWKzNyOFA2ZC9iL2o2RmpQSHE1Y1FKdE5XR1JCRHBBR000?=
 =?utf-8?B?RWFtd1R6SnU3dkp5UzhWZVBaZFBRK3ZSbG9NbDZCaGw2T1RUMHdmRFRSYmEw?=
 =?utf-8?B?OTdhQWRuY1ZxMS8zdHJ0dzB2R0ZsQ3M5WlBOQlBlNmdyankvaFh1Q0xrTXJP?=
 =?utf-8?B?cFBDbnYxNVdkWk5CKzU5V0lxYSt6UTV0eTdHWkpBNjhzYmV3bmFudUxjUmkv?=
 =?utf-8?B?YkVGcTZvR21paUFDdmQ0M1hnWTRHU1pYL2V0QW5yTW85RDZVNUJhd3VBS0ZH?=
 =?utf-8?B?N29CRWxGWnBLbXRZdFQ2d01ZQzJQcFJUdy83M0Flc0l2TitSUXQ0akQ4KzJ6?=
 =?utf-8?B?UURTcTFlV1hRcEY4VzY3LzB1QUpkMk5xVVBvaXBZNFgwVGVaWjJ5NGpiWWRy?=
 =?utf-8?B?bDcwazhsNWgwaDRmYTRqYWZ0ZHBGMUtVK0dpTklpYjhuVHJWUjk4YTlmU3hC?=
 =?utf-8?B?NUo0WU1OMXlSTFJkVGQ5dVBpcDZ5MWl0U1QzaWNPQWlFNDI4N0RvWmtqTDNp?=
 =?utf-8?B?YzczR0I3QnFUWmJ3Qkg3L2R2VzJiVUlTeWhUSnJvUGZlWHJjU1E4cWR2VFN4?=
 =?utf-8?Q?IHJx58zslYKj6?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b6141d-5834-4223-dffa-08d8cc38dc76
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 13:53:06.4526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rTGgHWGlWZZmaUv6WbSdL+HX2v44kPUnCUuu2/jCWQ/GyAcenODH5JlExshl6TmVKvtvv6t0qrDoiggrU1d5XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4969
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biB0aGUgZmlybXdhcmUgcmVqZWN0cyBhIGZyYW1lIChiZWNhdXNlIHN0YXRpb24gYmVjb21lIGFz
bGVlcCBvcgpkaXNjb25uZWN0ZWQpLCB0aGUgZnJhbWUgaXMgcmUtcXVldWVkIGluIG1hYzgwMjEx
LiBIb3dldmVyLCB0aGUKcmUtcXVldWVkIGZyYW1lIHdhcyA4IGJ5dGVzIGxvbmdlciB0aGFuIHRo
ZSBvcmlnaW5hbCBvbmUgKHRoZSBzaXplIG9mCnRoZSBJQ1YgZm9yIHRoZSBlbmNyeXB0aW9uKS4g
U28sIHdoZW4gbWFjODAyMTEgdHJ5IHRvIHNlbmQgdGhpcyBmcmFtZQphZ2FpbiwgaXQgaXMgYSBs
aXR0bGUgYmlnZ2VyIHRoYW4gZXhwZWN0ZWQuCklmIHRoZSBmcmFtZSBpcyByZS1xdWV1ZWQgc2Vj
dmVyYWwgdGltZSBpdCBlbmQgd2l0aCBhIHNrYl9vdmVyX3BhbmljCmJlY2F1c2UgdGhlIHNrYiBi
dWZmZXIgaXMgbm90IGxhcmdlIGVub3VnaC4KCk5vdGUgaXQgb25seSBoYXBwZW5zIHdoZW4gZGV2
aWNlIGFjdHMgYXMgYW4gQVAgYW5kIGVuY3J5cHRpb24gaXMKZW5hYmxlZC4KClRoaXMgcGF0Y2gg
bW9yZSBvciBsZXNzIHJldmVydHMgdGhlIGNvbW1pdCAwNDlmZGUxMzA0MTkgKCJzdGFnaW5nOiB3
Zng6CmRyb3AgdXNlbGVzcyBmaWVsZCBmcm9tIHN0cnVjdCB3ZnhfdHhfcHJpdiIpLgoKRml4ZXM6
IDA0OWZkZTEzMDQxOSAoInN0YWdpbmc6IHdmeDogZHJvcCB1c2VsZXNzIGZpZWxkIGZyb20gc3Ry
dWN0IHdmeF90eF9wcml2IikKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9t
ZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5j
IHwgMTAgKysrKysrKysrLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmggfCAgMSArCiAy
IGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
ZGF0YV90eC5jCmluZGV4IDM2YjM2ZWYzOWQwNS4uNzdmYjEwNGVmZGVjIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Rh
dGFfdHguYwpAQCAtMzMxLDYgKzMzMSw3IEBAIHN0YXRpYyBpbnQgd2Z4X3R4X2lubmVyKHN0cnVj
dCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhLAogewogCXN0cnVjdCBo
aWZfbXNnICpoaWZfbXNnOwogCXN0cnVjdCBoaWZfcmVxX3R4ICpyZXE7CisJc3RydWN0IHdmeF90
eF9wcml2ICp0eF9wcml2OwogCXN0cnVjdCBpZWVlODAyMTFfdHhfaW5mbyAqdHhfaW5mbyA9IElF
RUU4MDIxMV9TS0JfQ0Ioc2tiKTsKIAlzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICpod19rZXkg
PSB0eF9pbmZvLT5jb250cm9sLmh3X2tleTsKIAlzdHJ1Y3QgaWVlZTgwMjExX2hkciAqaGRyID0g
KHN0cnVjdCBpZWVlODAyMTFfaGRyICopc2tiLT5kYXRhOwpAQCAtMzQ0LDExICszNDUsMTQgQEAg
c3RhdGljIGludCB3ZnhfdHhfaW5uZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBpZWVl
ODAyMTFfc3RhICpzdGEsCiAKIAkvLyBGcm9tIG5vdyB0eF9pbmZvLT5jb250cm9sIGlzIHVudXNh
YmxlCiAJbWVtc2V0KHR4X2luZm8tPnJhdGVfZHJpdmVyX2RhdGEsIDAsIHNpemVvZihzdHJ1Y3Qg
d2Z4X3R4X3ByaXYpKTsKKwkvLyBGaWxsIHR4X3ByaXYKKwl0eF9wcml2ID0gKHN0cnVjdCB3Znhf
dHhfcHJpdiAqKXR4X2luZm8tPnJhdGVfZHJpdmVyX2RhdGE7CisJdHhfcHJpdi0+aWN2X3NpemUg
PSB3ZnhfdHhfZ2V0X2ljdl9sZW4oaHdfa2V5KTsKIAogCS8vIEZpbGwgaGlmX21zZwogCVdBUk4o
c2tiX2hlYWRyb29tKHNrYikgPCB3bXNnX2xlbiwgIm5vdCBlbm91Z2ggc3BhY2UgaW4gc2tiIik7
CiAJV0FSTihvZmZzZXQgJiAxLCAiYXR0ZW1wdCB0byB0cmFuc21pdCBhbiB1bmFsaWduZWQgZnJh
bWUiKTsKLQlza2JfcHV0KHNrYiwgd2Z4X3R4X2dldF9pY3ZfbGVuKGh3X2tleSkpOworCXNrYl9w
dXQoc2tiLCB0eF9wcml2LT5pY3Zfc2l6ZSk7CiAJc2tiX3B1c2goc2tiLCB3bXNnX2xlbik7CiAJ
bWVtc2V0KHNrYi0+ZGF0YSwgMCwgd21zZ19sZW4pOwogCWhpZl9tc2cgPSAoc3RydWN0IGhpZl9t
c2cgKilza2ItPmRhdGE7CkBAIC00ODQsNiArNDg4LDcgQEAgc3RhdGljIHZvaWQgd2Z4X3R4X2Zp
bGxfcmF0ZXMoc3RydWN0IHdmeF9kZXYgKndkZXYsCiAKIHZvaWQgd2Z4X3R4X2NvbmZpcm1fY2Io
c3RydWN0IHdmeF9kZXYgKndkZXYsIGNvbnN0IHN0cnVjdCBoaWZfY25mX3R4ICphcmcpCiB7CisJ
Y29uc3Qgc3RydWN0IHdmeF90eF9wcml2ICp0eF9wcml2OwogCXN0cnVjdCBpZWVlODAyMTFfdHhf
aW5mbyAqdHhfaW5mbzsKIAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZjsKIAlzdHJ1Y3Qgc2tfYnVmZiAq
c2tiOwpAQCAtNDk1LDYgKzUwMCw3IEBAIHZvaWQgd2Z4X3R4X2NvbmZpcm1fY2Ioc3RydWN0IHdm
eF9kZXYgKndkZXYsIGNvbnN0IHN0cnVjdCBoaWZfY25mX3R4ICphcmcpCiAJCXJldHVybjsKIAl9
CiAJdHhfaW5mbyA9IElFRUU4MDIxMV9TS0JfQ0Ioc2tiKTsKKwl0eF9wcml2ID0gd2Z4X3NrYl90
eF9wcml2KHNrYik7CiAJd3ZpZiA9IHdkZXZfdG9fd3ZpZih3ZGV2LCAoKHN0cnVjdCBoaWZfbXNn
ICopc2tiLT5kYXRhKS0+aW50ZXJmYWNlKTsKIAlXQVJOX09OKCF3dmlmKTsKIAlpZiAoIXd2aWYp
CkBAIC01MDMsNiArNTA5LDggQEAgdm9pZCB3ZnhfdHhfY29uZmlybV9jYihzdHJ1Y3Qgd2Z4X2Rl
diAqd2RldiwgY29uc3Qgc3RydWN0IGhpZl9jbmZfdHggKmFyZykKIAkvLyBOb3RlIHRoYXQgd2Z4
X3BlbmRpbmdfZ2V0X3BrdF91c19kZWxheSgpIGdldCBkYXRhIGZyb20gdHhfaW5mbwogCV90cmFj
ZV90eF9zdGF0cyhhcmcsIHNrYiwgd2Z4X3BlbmRpbmdfZ2V0X3BrdF91c19kZWxheSh3ZGV2LCBz
a2IpKTsKIAl3ZnhfdHhfZmlsbF9yYXRlcyh3ZGV2LCB0eF9pbmZvLCBhcmcpOworCXNrYl90cmlt
KHNrYiwgc2tiLT5sZW4gLSB0eF9wcml2LT5pY3Zfc2l6ZSk7CisKIAkvLyBGcm9tIG5vdywgeW91
IGNhbiB0b3VjaCB0byB0eF9pbmZvLT5zdGF0dXMsIGJ1dCBkbyBub3QgdG91Y2ggdG8KIAkvLyB0
eF9wcml2IGFueW1vcmUKIAkvLyBGSVhNRTogdXNlIGllZWU4MDIxMV90eF9pbmZvX2NsZWFyX3N0
YXR1cygpCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaCBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvZGF0YV90eC5oCmluZGV4IDQ2YzlmZmY3YTg3MC4uNDAxMzYzZDZiNTYz
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaAorKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2RhdGFfdHguaApAQCAtMzUsNiArMzUsNyBAQCBzdHJ1Y3QgdHhfcG9saWN5
X2NhY2hlIHsKIAogc3RydWN0IHdmeF90eF9wcml2IHsKIAlrdGltZV90IHhtaXRfdGltZXN0YW1w
OworCXVuc2lnbmVkIGNoYXIgaWN2X3NpemU7CiB9OwogCiB2b2lkIHdmeF90eF9wb2xpY3lfaW5p
dChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZik7Ci0tIAoyLjMwLjAKCg==
