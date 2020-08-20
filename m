Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CB024C2B6
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 17:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgHTP73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 11:59:29 -0400
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:47585
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728106AbgHTP71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 11:59:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mi3qKJHz688QVuTLa++wjYkyRsrLjpE+987vkJQ5b9ygFfKXbZscOg/IStxQxfart0LK0d6qh3z24jzA04Z8RJftT3Kwo00tArTZOfj8K8B8VhTlsSNlnigphY93o2rJ/YeCmVb9VgV1oSwQg5PSkU/tSgeweVedBxYhREnB4NcsrerZKvphQnjM2NP+LApszNqOHqo6nXraPYBjnUYn1WbdAh07XM7g7j2wnOIs0wKlMbrRJ0HouQoNFfPZXJwNJJzETxQVIUMRX6+8TO4Tqg0ObK2VWYxtVZfm+Swkwhzmj9dlgazEY0nTvgKUXy3AWmG4RIzk/lF1miebUfhjRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1O69ClsUGJVN6H4G61eCuDxl0C6ZU/YFqdCMqLndOzA=;
 b=jO4E78pX9uEcR6258QerTw9H5JBZkOl6+ShYlRjQCEQZlxG9WyB07RHZI6Rha9fE4B2lCNpELiglYn3b561OQC17mxdA9JCPBMaC+OGOrzIftEIs+Wl6YqAdgiIRSzXt4+jx4cOPObeiXzYJhem72/YNxTPRtdtVTlkeCe2UD3509B923EORoBZD6mt3ReTrC3x05fM1cT6J74Y78FoSQoBTgMbcVOq5ojWS4lPz85G5VPT/Sn+E++7Wv9qSOGWR+TWwYREy+RuMFlcjaxKGawGrR34tnIFkJYQPCvKFcAUXhuBjUm4HgVB0WDInyV7f7+7MGH0DF62FPSsav/AWFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1O69ClsUGJVN6H4G61eCuDxl0C6ZU/YFqdCMqLndOzA=;
 b=U/OqGm3g31myIYMxD/CLizV9idytSE2bwkB6QUfv9VkfFNZbqNqd1bGuEqxrTgUZpMlDB8ojbGn0h0LfSrnbrfJMhhiuX7nfaPrELPhoJVpJ5aYp9QrTCaMP+upUQCZVEWSSAzlLIa73DpD9/zks1EFoninqdX46M/GB4HrQHGI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4541.namprd11.prod.outlook.com (2603:10b6:806:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 15:59:24 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 15:59:24 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 01/12] staging: wfx: fix BA when device is AP and MFP is enabled
Date:   Thu, 20 Aug 2020 17:58:47 +0200
Message-Id: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::14) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 15:59:22 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb6d97bb-1d43-4c9e-8e6a-08d8452201db
X-MS-TrafficTypeDiagnostic: SA0PR11MB4541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4541131B8AA0B15A4B4A9655935A0@SA0PR11MB4541.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5rYOcSG/16rIPPSfgoilSKhosJyMGSp0WsmnDFFs8xLq5hqczey/AIpWt6kTW6JsopigG+6HJEnEFnWgdtuP3p7h/x9kvXSIBroZ1eo2QUNhg9WEBOSUzVnNkEy+Fd3wP4Y4OOkkomz+RSQY8Ea2AhLEvqDAWAfFPTtxsoV1hBEZMW1q7xWfzdyW9tO7N+WuijZRVwuJajj1jj93ni8zcShkgTKNploO4SSzzUWpmPOFnbcsZkG4sNHJ5oQ5Xm6yYgjP880rukE6SpPBgQ5QVdHFknJRl722p2KK+MX1GqSq2bkpCEvgeWQmnbKglkElOVOdruwo1wnKExfe/mNiZX3Cgn8giQA8W/RsCiKJ+KMiFOU7UyJj9+rChjUWkK0w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39850400004)(366004)(346002)(136003)(186003)(6666004)(2906002)(8676002)(316002)(16576012)(54906003)(956004)(26005)(66574015)(8936002)(2616005)(110011004)(52116002)(83380400001)(107886003)(1076003)(5660300002)(478600001)(36756003)(4326008)(66476007)(66556008)(66946007)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3xzL8FV543G/2/LexGXYBHH6BhoHcKT56lN+pOHZxkbSS2pg1sEj4LCGmksgPuE9jUps7Wf+gFAn/3eyB1TwLFMMMzBpwoOhvRQc7VG+ECbFI6ysn+nZIVRH0efaxcmtCjNzBvtoVcqyr4qS/f3VazueVo9jz3pQT7VHK6vuwht80fL7N9Ggv+MCl29lpnkVdFkRg//WYpxlY8zqUl2HxYBKRkoFB6H2CAh4DLSSI0BLuTvwz0Hmpg7T8AEf6HOmYns0DsTux7IAUa0HjYIfb6yIFT5LxXQIeN+OUmC+h5mKfPZUjAr1a7dOqT9vH4S03jZN+3bJIaIBAcR8wK1KnLSdvSSirhRBiM4xiv4+Giu/+rINcKPa/2am0uhqOsmKVgnRw+/fuXdQX+GW0nhf+pBeb9ui2I/5lf5gcuHFEvV+vKs4SoMHU11INPPCI2lzMUdtU0SS0lb9M8n/q1xgJqFzKwewKJPRubgMhZwR4gCCZu04k8P/iAXNnxE1CPVMcs0D0UH3aRv6mjuaRkNwgVnXp7sTaPyrfD+TYPERIGDFHNDtj1vpFwItVgc5GOwLe5as0Vzx65W30Ri1CkCcWKk413iod3fJNEuYO3p0dFyct3iQqxseNwpCivM9mUT5C/eYOIMw5/vgXNDCvqHiiQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6d97bb-1d43-4c9e-8e6a-08d8452201db
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 15:59:23.7984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ih8L1QJ3MhX4kzZV9QjC4MhTWdAqbUfi03AhSHD2IlRUMrUtpUFS69NVdEfR22gT6Etfss2g/kSlVO/NYBu9ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHByb3RlY3Rpb24gb2YgdGhlIG1hbmFnZW1lbnQgZnJhbWVzIGlzIG1haW5seSBkb25lIGJ5IG1h
YzgwMjExLgpIb3dldmVyLCBmcmFtZXMgZm9yIHRoZSBtYW5hZ2VtZW50IG9mIHRoZSBCbG9ja0Fj
ayBzZXNzaW9ucyBhcmUgZGlyZWN0bHkKc2VudCBieSB0aGUgZGV2aWNlLiBUaGVzZSBmcmFtZXMg
aGF2ZSB0byBiZSBwcm90ZWN0ZWQgaWYgTUZQIGlzIGluIHVzZS4KU28gdGhlIGRyaXZlciBoYXMg
dG8gcGFzcyB0aGUgTUZQIGNvbmZpZ3VyYXRpb24gdG8gdGhlIGRldmljZS4KClVudGlsIG5vdywg
dGhlIEJsb2NrQWNrIG1hbmFnZW1lbnQgZnJhbWVzIHdlcmUgY29tcGxldGVseSB1bnByb3RlY3Rl
ZAp3aGF0ZXZlciB0aGUgc3RhdHVzIG9mIHRoZSBNRlAgbmVnb3RpYXRpb24uIFNvLCBzb21lIGRl
dmljZXMgZHJvcHBlZAp0aGVzZSBmcmFtZXMuCgpUaGUgZGV2aWNlIGhhcyB0d28ga25vYnMgdG8g
Y29udHJvbCB0aGUgTUZQLiBPbmUgZ2xvYmFsIGFuZCBvbmUgcGVyCnN0YXRpb24uIE5vcm1hbGx5
LCB0aGUgZHJpdmVyIHNob3VsZCBhbHdheXMgZW5hYmxlIGdsb2JhbCBNRlAuIFRoZW4gaXQKc2hv
dWxkIGVuYWJsZSBNRlAgb24gZXZlcnkgc3RhdGlvbiB3aXRoIHdoaWNoIE1GUCB3YXMgc3VjY2Vz
c2Z1bGx5Cm5lZ290aWF0ZWQuIFVuZm9ydHVuYXRlbHksIHRoZSBvbGRlciBmaXJtd2FyZXMgb25s
eSBwcm92aWRlIHRoZQpnbG9iYWwgY29udHJvbC4KClNvLCB0aGlzIHBhdGNoIGVuYWJsZSBnbG9i
YWwgTUZQIGFzIGl0IGlzIGV4cG9zZWQgaW4gdGhlIGJlYWNvbi4gVGhlbiBpdAptYXJrcyBldmVy
eSBzdGF0aW9uIHdpdGggd2hpY2ggdGhlIE1GUCBpcyBlZmZlY3RpdmUuCgpUaHVzLCB0aGUgc3Vw
cG9ydCBmb3IgdGhlIG9sZCBmaXJtd2FyZXMgaXMgbm90IHNvIGJhZC4gSXQgbWF5IG9ubHkKZW5j
b3VudGVyIHNvbWUgZGlmZmljdWx0aWVzIHRvIG5lZ290aWF0ZSBCQSBzZXNzaW9ucyB3aGVuIHRo
ZSBsb2NhbApkZXZpY2UgKHRoZSBBUCkgaXMgTUZQIGNhcGFibGUgKGllZWU4MDIxMXc9MSkgYnV0
IHRoZSBzdGF0aW9uIGlzIG5vdC4KVGhlIG9ubHkgc29sdXRpb24gZm9yIHRoaXMgY2FzZSBpcyB0
byB1cGdyYWRlIHRoZSBmaXJtd2FyZS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVy
IDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jIHwgMjIgKysrKysrKysrKysrKysrKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDIxIGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBhZDYzMzMyZjY5MGMuLjlj
MWM4MjIzYTQ5ZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC00MzQsNyArNDM0LDcgQEAgaW50IHdmeF9zdGFf
YWRkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAog
CXd2aWYtPmxpbmtfaWRfbWFwIHw9IEJJVChzdGFfcHJpdi0+bGlua19pZCk7CiAJV0FSTl9PTigh
c3RhX3ByaXYtPmxpbmtfaWQpOwogCVdBUk5fT04oc3RhX3ByaXYtPmxpbmtfaWQgPj0gSElGX0xJ
TktfSURfTUFYKTsKLQloaWZfbWFwX2xpbmsod3ZpZiwgc3RhLT5hZGRyLCAwLCBzdGFfcHJpdi0+
bGlua19pZCk7CisJaGlmX21hcF9saW5rKHd2aWYsIHN0YS0+YWRkciwgc3RhLT5tZnAgPyAyIDog
MCwgc3RhX3ByaXYtPmxpbmtfaWQpOwogCiAJcmV0dXJuIDA7CiB9CkBAIC00NzQsNiArNDc0LDI1
IEBAIHN0YXRpYyBpbnQgd2Z4X3VwbG9hZF9hcF90ZW1wbGF0ZXMoc3RydWN0IHdmeF92aWYgKnd2
aWYpCiAJcmV0dXJuIDA7CiB9CiAKK3N0YXRpYyB2b2lkIHdmeF9zZXRfbWZwX2FwKHN0cnVjdCB3
ZnhfdmlmICp3dmlmKQoreworCXN0cnVjdCBza19idWZmICpza2IgPSBpZWVlODAyMTFfYmVhY29u
X2dldCh3dmlmLT53ZGV2LT5odywgd3ZpZi0+dmlmKTsKKwljb25zdCBpbnQgaWVvZmZzZXQgPSBv
ZmZzZXRvZihzdHJ1Y3QgaWVlZTgwMjExX21nbXQsIHUuYmVhY29uLnZhcmlhYmxlKTsKKwljb25z
dCB1MTYgKnB0ciA9ICh1MTYgKiljZmc4MDIxMV9maW5kX2llKFdMQU5fRUlEX1JTTiwKKwkJCQkJ
CSBza2ItPmRhdGEgKyBpZW9mZnNldCwKKwkJCQkJCSBza2ItPmxlbiAtIGllb2Zmc2V0KTsKKwlj
b25zdCBpbnQgcGFpcndpc2VfY2lwaGVyX3N1aXRlX2NvdW50X29mZnNldCA9IDggLyBzaXplb2Yo
dTE2KTsKKwljb25zdCBpbnQgcGFpcndpc2VfY2lwaGVyX3N1aXRlX3NpemUgPSA0IC8gc2l6ZW9m
KHUxNik7CisJY29uc3QgaW50IGFrbV9zdWl0ZV9zaXplID0gNCAvIHNpemVvZih1MTYpOworCisJ
aWYgKHB0cikgeworCQlwdHIgKz0gcGFpcndpc2VfY2lwaGVyX3N1aXRlX2NvdW50X29mZnNldDsK
KwkJcHRyICs9IDEgKyBwYWlyd2lzZV9jaXBoZXJfc3VpdGVfc2l6ZSAqICpwdHI7CisJCXB0ciAr
PSAxICsgYWttX3N1aXRlX3NpemUgKiAqcHRyOworCQloaWZfc2V0X21mcCh3dmlmLCAqcHRyICYg
QklUKDcpLCAqcHRyICYgQklUKDYpKTsKKwl9Cit9CisKIGludCB3Znhfc3RhcnRfYXAoc3RydWN0
IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpCiB7CiAJc3RydWN0
IHdmeF92aWYgKnd2aWYgPSAoc3RydWN0IHdmeF92aWYgKil2aWYtPmRydl9wcml2OwpAQCAtNDg4
LDYgKzUwNyw3IEBAIGludCB3Znhfc3RhcnRfYXAoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0
cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpCiAJcmV0ID0gaGlmX3N0YXJ0KHd2aWYsICZ2aWYtPmJz
c19jb25mLCB3dmlmLT5jaGFubmVsKTsKIAlpZiAocmV0ID4gMCkKIAkJcmV0dXJuIC1FSU87CisJ
d2Z4X3NldF9tZnBfYXAod3ZpZik7CiAJcmV0dXJuIHJldDsKIH0KIAotLSAKMi4yOC4wCgo=
