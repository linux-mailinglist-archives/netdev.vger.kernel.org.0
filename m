Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEF1210EA5
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731894AbgGAPIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:08:43 -0400
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:60865
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731845AbgGAPIj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 11:08:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFBogDMMFXwTuUF1Qnxe8rrv4Edm/knT06fHnA/vOyl3D0khVdhjGvAdkg5VAl8y9gWG8VAp/5ZV/lVAY7846V4XX9wLFlQdnzC2Nln67ZDZehvZdtZNJAF0c47c4/jA3OlB8Uwo9A0qux1pRLyIQeHdkE+Eo4SEdRU+XK1vYMO2+smpX6xh6RH57GmM/YIPpKDJAkFyPBOTq6pgaq1lROksG7TZxDjbdSiYsePuvN9nEugjiuFLN/j9Ba2bed3EkdxgR6oSaxMVZrOCHlEDZ6G97x1p9m5GoFqucNOWBfJb4QPyMTBlT5RSeoTZUTQLw4A5biHgkt3hoXBoA4Y+SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rU4jZR9bH7uW5J9DSSlLvc4DQzujrGowUAW5IFxdmQk=;
 b=RSftfAtF+9GqpTStdREQ2a6Qx0mmD+zeO6rCdL0mEGyfPdqRtD9APS5oH6frOEXwt0cSUEjIuzW/vXjBIBNc4Q3M/O0zxuB3p2sUlLChF/w3edPvRhsuplNKJGK9SUUukW7ZM2kaMzEnxZ3PAk507wlh7Kqcgz29SBoxY9n1RyCvTRh91OeioimStQkJ/216QW5l+xWnFxEymaTTV3G0y6VcoHSAnFMxn2X8DD6FittpXmNoRodw0Cun23ieQNbz5xgF9z8t6VFGAgoKYuAjJhovpm59VVVmYQoz9BwDkF4sTLa/9eDBvbgVzg+JtQcgSULbFlU/P6hX7+diQHdAlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rU4jZR9bH7uW5J9DSSlLvc4DQzujrGowUAW5IFxdmQk=;
 b=ZRSlMnM+N9NOPGeC8b+ox1q/6zM6afqvIpctDfrgb+I8na0iUffnXOWehDllZQx8FPV7rlQ9YSBu/Y3TQYw5gTcOOQ/IKw8UTx/4IUube9bgNBG6WpM7HerND7uZ9frCfg+j4+K2kW7ljJrIU4Z+ah0O4geGnaGAekIRlg5fnKM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4736.namprd11.prod.outlook.com (2603:10b6:806:9f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Wed, 1 Jul
 2020 15:08:24 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3131.033; Wed, 1 Jul 2020
 15:08:24 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 12/13] staging: wfx: add a debugfs entry to force ps_timeout
Date:   Wed,  1 Jul 2020 17:07:06 +0200
Message-Id: <20200701150707.222985-13-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701150707.222985-1-Jerome.Pouiller@silabs.com>
References: <20200701150707.222985-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR07CA0143.namprd07.prod.outlook.com
 (2603:10b6:3:13e::33) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR07CA0143.namprd07.prod.outlook.com (2603:10b6:3:13e::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Wed, 1 Jul 2020 15:08:22 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 833902b0-7bfc-4da3-7974-08d81dd0998a
X-MS-TrafficTypeDiagnostic: SA0PR11MB4736:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB47365DEE28A185ABD39D67DA936C0@SA0PR11MB4736.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lRBGuYQUi0B3MUbdGz9/U3WfM0pF1LWMC9f6E+Cgn67NyMO+e12zCVNff2mvBVZcoKwmgJttdRS6+GSLV4/CHI9fE9wyL+5FTQFLJqxSS6B3z0AwQL2FzKiK5SFXohqDJgmjnrJTes8VqnkiGw0XaDsyPuKFMMx12IPpmPCMIVqZXkp5A23inWKtYh73BN/2fi5ztDKhRLszNJGqMQwefz7qBi4tWqa3uQOSZSigs/CTZqmGJnwwnsQZ8jmYfncg41Hi5qpxv5psJv9b0t5Uqzm7kvEvIHT2nopcuykeJSGY0qjEeSPml9+aZ1d8hoiucBqiVllpp3J6g6HEvRPvuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(366004)(346002)(376002)(396003)(136003)(5660300002)(6486002)(86362001)(6666004)(66574015)(36756003)(2906002)(186003)(83380400001)(16526019)(8936002)(66556008)(66476007)(107886003)(4326008)(8676002)(2616005)(1076003)(478600001)(316002)(54906003)(66946007)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1RggAmDyEPn204D8Tx7uFYM5Va1B0j0jTYs4fNprp8MLtejMGbWE/qXRJYv453P3yMFT1HkUtkgjfUtYu05wapPZV8ApqSm3a56pbUWuOUKiB4i2fKuLJU7fCDQR4OhN40xEWVKV1TWac0ws8aPZeg7cGvs9+sYcrtOKvYDCpM+3sUeKlVxsi7hOrbYvXRgT4Lyec+yebILZZZW+Btnu/lBVvgM999ob8gJZOO4SvNLJQGiptchh63LYLYshkiHaQL3jFh5MwSLJHV0wJo4LjtbGX+uFam9uXA0hwahEg+Vz+Nhrzl56aQYroxSJ8XoSXcmtw+cv5AwrQRnkf7YUQYbqulJnqzV6ydPZE65WllcrmwR2eoHaN6dV9EdNFgiUurgOTKqGGHXKvoKJkDAWC7aYb7WkGXQ27l+KViVnW9jTztH1SJQo4GoChAkcpezcC1fV/6g0Xlkfnc0Fjv0geXqu1pv/J10pOoK2N9PjcivNd60slnPe7rfvOiKgrvtBDq4AmUk5kUsmmGGipymKsk8BehAiAEprUabw9BAnDeA=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 833902b0-7bfc-4da3-7974-08d81dd0998a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 15:08:24.1656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ObCltJhF3HmpZ/trJINRXlxguRsBC/1AyCDr1Ak7Hfsy4kgyvPMSNfF0qpJ/wDDYuLXC5BfdHjUTQZHwqzvZvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4736
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
c29tZSBhZHZhbmNlZCB1c2FnZSBvciBkZWJ1ZyBzY2VuYXJpb3MsIGl0IGNvdWxkIGludGVyZXN0
aW5nIHRvCmNoYW5nZSB0aGUgdmFsdWUgb2YgcHNfdGltZW91dCBvciBldmVudHVhbGx5IHRvIGZv
cmNlIHVzZSBvZiBQUy1Qb2xsCmZyYW1lcy4KClRoZSB3ZXh0IEFQSSAodXNlZCBieSBpd2NvbmZp
ZykgcHJvdmlkZSBhIHdheSB0byBjaGFuZ2UgcHNfdGltZW91dC4KSG93ZXZlciwgdGhpcyBBUEkg
aXMgb2Jzb2xldGUgYW5kIGl0IHNlZW1zIGEgbGl0dGxlIHdlaXJkIHRvIHVzZSAoaXQKc2VlbXMg
aXQgZG9lcyBhcHBseSB0aGUgY2hhbmdlLCBzbyB0aGUgdXNlciBoYXZlIHRvIGRpc2FibGUgdGhl
bgpyZS1lbmFibGUgZGUgcG93ZXIgc2F2ZSkKCk9uIHNpZGUgb2Ygbmw4MDIxMSwgdGhlcmUgaXMg
bm8gd2F5IHRvIGNoYW5nZSB0aGUgcHNfdGltZW91dC4KClRoaXMgcGF0Y2ggcHJvdmlkZXMgYSBm
aWxlIGluIGRlYnVnZnMgdG8gY2hhbmdlIHRoZSB2YWx1ZSBvZiBwc190aW1lb3V0LgoKU2lnbmVk
LW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgot
LS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYyB8IDIzICsrKysrKysrKysrKysrKysrKysr
KysrCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyAgfCAgMSArCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jICAgfCAxMCArKysrKysrLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oICAg
fCAgMSArCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oICAgfCAgMSArCiA1IGZpbGVzIGNoYW5n
ZWQsIDMzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9kZWJ1Zy5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jCmluZGV4
IDEwZDY0OTk4NTY5NmEuLjNmMTcxMmI3YzkxOWQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvZGVidWcuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmMKQEAgLTMzNCw2
ICszMzQsMjggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgd2Z4X3NlbmRf
aGlmX21zZ19mb3BzID0gewogCS5yZWFkID0gd2Z4X3NlbmRfaGlmX21zZ19yZWFkLAogfTsKIAor
c3RhdGljIGludCB3ZnhfcHNfdGltZW91dF9zZXQodm9pZCAqZGF0YSwgdTY0IHZhbCkKK3sKKwlz
dHJ1Y3Qgd2Z4X2RldiAqd2RldiA9IChzdHJ1Y3Qgd2Z4X2RldiAqKWRhdGE7CisJc3RydWN0IHdm
eF92aWYgKnd2aWY7CisKKwl3ZGV2LT5mb3JjZV9wc190aW1lb3V0ID0gdmFsOworCXd2aWYgPSBO
VUxMOworCXdoaWxlICgod3ZpZiA9IHd2aWZfaXRlcmF0ZSh3ZGV2LCB3dmlmKSkgIT0gTlVMTCkK
KwkJd2Z4X3VwZGF0ZV9wbSh3dmlmKTsKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCB3Znhf
cHNfdGltZW91dF9nZXQodm9pZCAqZGF0YSwgdTY0ICp2YWwpCit7CisJc3RydWN0IHdmeF9kZXYg
KndkZXYgPSAoc3RydWN0IHdmeF9kZXYgKilkYXRhOworCisJKnZhbCA9IHdkZXYtPmZvcmNlX3Bz
X3RpbWVvdXQ7CisJcmV0dXJuIDA7Cit9CisKK0RFRklORV9ERUJVR0ZTX0FUVFJJQlVURSh3Znhf
cHNfdGltZW91dF9mb3BzLCB3ZnhfcHNfdGltZW91dF9nZXQsIHdmeF9wc190aW1lb3V0X3NldCwg
IiVsbGRcbiIpOworCiBpbnQgd2Z4X2RlYnVnX2luaXQoc3RydWN0IHdmeF9kZXYgKndkZXYpCiB7
CiAJc3RydWN0IGRlbnRyeSAqZDsKQEAgLTM0OCw2ICszNzAsNyBAQCBpbnQgd2Z4X2RlYnVnX2lu
aXQoc3RydWN0IHdmeF9kZXYgKndkZXYpCiAJCQkgICAgJndmeF9idXJuX3Nsa19rZXlfZm9wcyk7
CiAJZGVidWdmc19jcmVhdGVfZmlsZSgic2VuZF9oaWZfbXNnIiwgMDYwMCwgZCwgd2RldiwKIAkJ
CSAgICAmd2Z4X3NlbmRfaGlmX21zZ19mb3BzKTsKKwlkZWJ1Z2ZzX2NyZWF0ZV9maWxlKCJwc190
aW1lb3V0IiwgMDYwMCwgZCwgd2RldiwgJndmeF9wc190aW1lb3V0X2ZvcHMpOwogCiAJcmV0dXJu
IDA7CiB9CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvbWFpbi5jCmluZGV4IDgwZTQ0NzRjYzMzMTQuLjYyZTM2MzQ1NTZlYzAgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvbWFpbi5jCkBAIC0zNTIsNiArMzUyLDcgQEAgc3RydWN0IHdmeF9kZXYgKndmeF9pbml0
X2NvbW1vbihzdHJ1Y3QgZGV2aWNlICpkZXYsCiAJc2tiX3F1ZXVlX2hlYWRfaW5pdCgmd2Rldi0+
dHhfcGVuZGluZyk7CiAJaW5pdF93YWl0cXVldWVfaGVhZCgmd2Rldi0+dHhfZGVxdWV1ZSk7CiAJ
d2Z4X2luaXRfaGlmX2NtZCgmd2Rldi0+aGlmX2NtZCk7CisJd2Rldi0+Zm9yY2VfcHNfdGltZW91
dCA9IC0xOwogCiAJaWYgKGRldm1fYWRkX2FjdGlvbl9vcl9yZXNldChkZXYsIHdmeF9mcmVlX2Nv
bW1vbiwgd2RldikpCiAJCXJldHVybiBOVUxMOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggMmMwYWI1MWZjOTJk
YS4uZmRmNGY0OGRkYzJjZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC0yMTcsMjAgKzIxNywyNCBAQCBzdGF0
aWMgaW50IHdmeF9nZXRfcHNfdGltZW91dChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCAqZW5h
YmxlX3BzKQogCQkvLyBhcmUgZGlmZmVyZW50cy4KIAkJaWYgKGVuYWJsZV9wcykKIAkJCSplbmFi
bGVfcHMgPSB0cnVlOwotCQlpZiAod3ZpZi0+YnNzX25vdF9zdXBwb3J0X3BzX3BvbGwpCisJCWlm
ICh3dmlmLT53ZGV2LT5mb3JjZV9wc190aW1lb3V0ID4gLTEpCisJCQlyZXR1cm4gd3ZpZi0+d2Rl
di0+Zm9yY2VfcHNfdGltZW91dDsKKwkJZWxzZSBpZiAod3ZpZi0+YnNzX25vdF9zdXBwb3J0X3Bz
X3BvbGwpCiAJCQlyZXR1cm4gMzA7CiAJCWVsc2UKIAkJCXJldHVybiAwOwogCX0KIAlpZiAoZW5h
YmxlX3BzKQogCQkqZW5hYmxlX3BzID0gd3ZpZi0+dmlmLT5ic3NfY29uZi5wczsKLQlpZiAod3Zp
Zi0+dmlmLT5ic3NfY29uZi5hc3NvYyAmJiB3dmlmLT52aWYtPmJzc19jb25mLnBzKQorCWlmICh3
dmlmLT53ZGV2LT5mb3JjZV9wc190aW1lb3V0ID4gLTEpCisJCXJldHVybiB3dmlmLT53ZGV2LT5m
b3JjZV9wc190aW1lb3V0OworCWVsc2UgaWYgKHd2aWYtPnZpZi0+YnNzX2NvbmYuYXNzb2MgJiYg
d3ZpZi0+dmlmLT5ic3NfY29uZi5wcykKIAkJcmV0dXJuIGNvbmYtPmR5bmFtaWNfcHNfdGltZW91
dDsKIAllbHNlCiAJCXJldHVybiAtMTsKIH0KIAotc3RhdGljIGludCB3ZnhfdXBkYXRlX3BtKHN0
cnVjdCB3ZnhfdmlmICp3dmlmKQoraW50IHdmeF91cGRhdGVfcG0oc3RydWN0IHdmeF92aWYgKnd2
aWYpCiB7CiAJaW50IHBzX3RpbWVvdXQ7CiAJYm9vbCBwczsKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCmluZGV4IDQzODA4
Y2VmNDc4NWMuLjZiMTVhNjRhYzllMjggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaApAQCAtNjYsNiArNjYsNyBAQCB2
b2lkIHdmeF9jb29saW5nX3RpbWVvdXRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOwog
dm9pZCB3Znhfc3VzcGVuZF9ob3RfZGV2KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBlbnVtIHN0YV9u
b3RpZnlfY21kIGNtZCk7CiB2b2lkIHdmeF9zdXNwZW5kX3Jlc3VtZV9tYyhzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZiwgZW51bSBzdGFfbm90aWZ5X2NtZCBjbWQpOwogdm9pZCB3ZnhfZXZlbnRfcmVwb3J0
X3Jzc2koc3RydWN0IHdmeF92aWYgKnd2aWYsIHU4IHJhd19yY3BpX3Jzc2kpOworaW50IHdmeF91
cGRhdGVfcG0oc3RydWN0IHdmeF92aWYgKnd2aWYpOwogCiAvLyBPdGhlciBIZWxwZXJzCiB2b2lk
IHdmeF9yZXNldChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZik7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAppbmRleCAwYzQ0Yjcz
M2VmNmZlLi40NzdjMDhmYzcxM2ZhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dm
eC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKQEAgLTU5LDYgKzU5LDcgQEAgc3Ry
dWN0IHdmeF9kZXYgewogCXN0cnVjdCBtdXRleAkJcnhfc3RhdHNfbG9jazsKIAlzdHJ1Y3QgaGlm
X3R4X3Bvd2VyX2xvb3BfaW5mbyB0eF9wb3dlcl9sb29wX2luZm87CiAJc3RydWN0IG11dGV4CQl0
eF9wb3dlcl9sb29wX2luZm9fbG9jazsKKwlpbnQJCQlmb3JjZV9wc190aW1lb3V0OwogfTsKIAog
c3RydWN0IHdmeF92aWYgewotLSAKMi4yNy4wCgo=
