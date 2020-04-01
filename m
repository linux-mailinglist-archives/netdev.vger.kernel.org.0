Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1D819AA25
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732572AbgDALFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:05:34 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:6083
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732539AbgDALFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+3iJzJaMuf6XoOiJqOndz+RMf0461SDJA9Qi81LMPmqtehqoE1uFDSGMYBZ3LDLzp5R040woI2PIAFttj+93IzTFt5UlsaGcyKqtnGS56CFnmA0ZkDb+/6B1RvA4ALOqwVkpQ0rFn+4Ime+3WKLNeV1FVJvV5/jet+PifRDIBW1Ba9LK4WUOJ0JUcxGI6hu9I7JWhmYgkkUZLILyOqR6PQG7SlqzdxucAgPfa5P3TZ/jjpMAqecr/mNmVW/VvtkQlUkpZI/m/xM46IICBTQx4b8xbOXFA03PaUhR3RiYKY2FYNIWPpg/WGlU5NUjOIigudcuIw99Mp3//9ertNvsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1jqhwnOCvIDXeCRXQIhQJr9ISs6aDNmUCuvc/MDHFs=;
 b=drXvrgkHHQ7i4mp8ujsBA3Xm0ydDwVZslkj66oU2k1iyhjSChdwXBQ+wYO/9g3UsOfxTgrGft6zqpjx/X9iEV/8PVUVCepQH6pwTW/aDsO9oVWkQ2iv/BK0X4USCSfIqO5WfToEWd16JPadZMdwM8pUhreuHU6FhQ3rIualYk83qum0rX08n36ZTqijvv5Z5KpVeTSGLvUmV0iu3Ydb9qLm43wnsLeNHevgcstsccEExRvPYoWMvWU6BDQJd6zXxOeNRNfTuRmIfnYtvBwYNgUbiOhU4vDFOWOWhm8PakvWeFWvMbqeYof7aDKKV633SfThlVW6CMQ8mpjPZyTXBHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1jqhwnOCvIDXeCRXQIhQJr9ISs6aDNmUCuvc/MDHFs=;
 b=U6GpXhF9WwAny3tBT8oH011KVBtUwsieLIQb5lLY4TboY+YHrWFdIITb6tQCVzOtzzod2UNnGGHfbzNikQvQ5w9Gh+PY8pfcRXue+LCiIx70/7WvTGvjB3r2JZRmKLw848duTe8t/6yrMpWBsH3DHF7XUScE15xr9bFCk6g4RJ4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:05:25 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:05:25 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 31/32] staging: wfx: fix case where AP stop with CAB traffic pending
Date:   Wed,  1 Apr 2020 13:04:04 +0200
Message-Id: <20200401110405.80282-32-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0501CA0156.namprd05.prod.outlook.com
 (2603:10b6:803:2c::34) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:05:23 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f642917a-be3c-4d38-ff9c-08d7d62c9412
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285457793A3290031E0861593C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sANo9FWGYNxA1kQVyxYhKx0Ov885UhR3vPmFNEGlOy9V2x7yp9BPp7up2/XLhNYHhHH41wW8S/SCsDuvxcMfDvdRL9zR0G+KxEo0eowNPHFMBTa7CIfRgzCiZDDlcqTcvbeq5pSiZskbglRDbQjlFCKzkSx3LMELuZ2URsioss0CUSWl9aNAa3LuTKspUJe2K48bjapO7m5GMoYc9xZ1P+nwLvoerLmSYZGmMq2u9q61rmyny0f3GI0MOlN+KqT211CECBl4RNZWYXkXsAAr1OvSQIspqASwE5YSjtsjvdVPOOlgB7ehjLGxYT1GgAbUHiGfnMWnVI0TobnPApdHYvkR5SIiMKzI+FFjWPYOCbhKyOgeHTK3FtNPN2SmRWlImnUlpKrm8zeEiwEyePXoKmT8YbPCWJ8zA88C/g2Io9OF8pi9DkWEeElkXJHUy5hQ
X-MS-Exchange-AntiSpam-MessageData: KB9ORJdqZFv4GLWzlwNPLxG4nb6ZH03Esv99EeEOH5/MawncESlH390QTP0tb8LWIV3GyeNZhkw3R6D7iy+qxnxM4ofuM+BpMV3kV21XeVqInmVBKERor9rmIaf+u/j92CNFdMNbwZipwDmKrumYb+t5xjmg1XWniTmDowk8psDMog+yVC3k+/oCSMCtGFixSyM9NSJvTBsaUrN85ONirQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f642917a-be3c-4d38-ff9c-08d7d62c9412
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:05:24.9411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMhziX8BpOw0/fXVzQLxZ1jHOGmEmlJ7H8ydEdWrLFOzHptIWuOlqTIXNkDp8RrczvpednKHaLP6gHmdCkJ3rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBkcml2ZXIgaGFzIENvbnRlbnQgQWZ0ZXIgRFRJTSBCZWFjb24gKENBQikgaW4gcXVldWUsIGl0
IHdhaXQgZm9yIGFuCmluZGljYXRpb24gZnJvbSB0aGUgZmlybXdhcmUuIEhvd2V2ZXIsIHdoZW4g
d2Ugc3RvcCB0byBzZW5kIGJlYWNvbnMsCnRoaXMgaW5kaWNhdGlvbiBtYXkgbmV2ZXIgaGFwcGVu
LgoKU29sdmUgdGhpcyBpc3N1ZSBieSBzaW1wbHkgc2ltdWxhdGUgdGhpcyBpbmRpY2F0aW9uLiBG
aXJtd2FyZSB3aWxsIHNlbmQKZGF0YSB0aGF0IHByb2JhYmx5IG5vYm9keSB3aWxsIGhlYXJkLgoK
U2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMu
Y29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAxNSArKysrKysrKysrKysrKy0K
IDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKaW5kZXggYjFlZTAyZDJmNTE1Li4yZThkM2Y1NzFjM2UgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNjg2
LDYgKzY4NiwxOSBAQCBzdGF0aWMgdm9pZCB3Znhfam9pbl9maW5hbGl6ZShzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZiwKIAl9CiB9CiAKK3ZvaWQgd2Z4X2VuYWJsZV9iZWFjb24oc3RydWN0IHdmeF92aWYg
Knd2aWYsIGJvb2wgZW5hYmxlKQoreworCS8vIERyaXZlciBoYXMgQ29udGVudCBBZnRlciBEVElN
IEJlYWNvbiBpbiBxdWV1ZS4gRHJpdmVyIGlzIHdhaXRpbmcgZm9yCisJLy8gYSBzaWduYWwgZnJv
bSB0aGUgZmlybXdhcmUuIFNpbmNlIHdlIGFyZSBnb2luZyB0byBzdG9wIHRvIHNlbmQKKwkvLyBi
ZWFjb25zLCB0aGlzIHNpZ25hbCB3aWxsIG5ldmVyIGhhcHBlbnMuIFNlZSBhbHNvCisJLy8gd2Z4
X3N1c3BlbmRfcmVzdW1lX21jKCkKKwlpZiAoIWVuYWJsZSAmJiB3ZnhfdHhfcXVldWVzX2hhc19j
YWIod3ZpZikpIHsKKwkJd3ZpZi0+YWZ0ZXJfZHRpbV90eF9hbGxvd2VkID0gdHJ1ZTsKKwkJd2Z4
X2JoX3JlcXVlc3RfdHgod3ZpZi0+d2Rldik7CisJfQorCWhpZl9iZWFjb25fdHJhbnNtaXQod3Zp
ZiwgZW5hYmxlKTsKK30KKwogdm9pZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgw
MjExX2h3ICpodywKIAkJCSAgICAgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAkJCSAgICAg
c3RydWN0IGllZWU4MDIxMV9ic3NfY29uZiAqaW5mbywKQEAgLTcyNCw3ICs3MzcsNyBAQCB2b2lk
IHdmeF9ic3NfaW5mb19jaGFuZ2VkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCiAJaWYgKGNo
YW5nZWQgJiBCU1NfQ0hBTkdFRF9CRUFDT05fRU5BQkxFRCAmJgogCSAgICB3dmlmLT5zdGF0ZSAh
PSBXRlhfU1RBVEVfSUJTUykKLQkJaGlmX2JlYWNvbl90cmFuc21pdCh3dmlmLCBpbmZvLT5lbmFi
bGVfYmVhY29uKTsKKwkJd2Z4X2VuYWJsZV9iZWFjb24od3ZpZiwgaW5mby0+ZW5hYmxlX2JlYWNv
bik7CiAKIAlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0JFQUNPTl9JTkZPKQogCQloaWZfc2V0
X2JlYWNvbl93YWtldXBfcGVyaW9kKHd2aWYsIGluZm8tPmR0aW1fcGVyaW9kLAotLSAKMi4yNS4x
Cgo=
