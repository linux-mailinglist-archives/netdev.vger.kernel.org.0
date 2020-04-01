Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B80B19AA4F
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732409AbgDALGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:06:25 -0400
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:6024
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732461AbgDALFN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMzf+wbiNmbmyXhoWK1hYBAM/TAnWC+P6WwhX6hfUZ2tN242w33hCfmdVOIOVTbQWc0HV292pRMKZuFPqRqS0wbPRzvz6pZWiTArpLdRcwidae5iw+uRvzF7T2OssSkFK+VODNK6FZ4C6zIILteNviCDQmuVldCMpQedQqLdlRmHnXB10t03rLF0Pk3JVq05AfyIYR/efo+fAUqcpBRqZ13PfACMVC1erRIp5kFFLJw7czCUJnsm6xXx7QsBfrsUkReFqmPZUkIRs0dhFuCZzxoLlqMAmICZsbgAGfY+lOVBBINuglTh9jdPh+VEeJWCkxap5kPq+8VMvGBOU3fjyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SrPGMLsUEPUKhc3RhU1c5TMkTtuEHRylbkifV77yKIE=;
 b=KzjGcCvWYatJdYVWBLYloB56fHZIR3t3YbiqDm3dwQkqQmdl8jzB1tLtLZr8An7sAHnLlE0SisWhRR9nT88m2BMT1MMSwQ2wM+Rdoi2M/syL6gemRGzpLi4cHrcSiSdmE7wK3kv6SC25bZJ1fkLtVNO3gmvKkTWMUyeG8Zt8a7zXMF/cF5NjphGllr2f1cxPymk3r384g0aLHWC0V/Jfr47vr/BWPttVqQb6opaaF/xD6OV05TDpLcxu9sa4ICNMsBkruRXSe/tLUaXAs7cqPVF3RtU8AJd3y3q+3xn25hs8ae1kl1h10E3hvzgcYZ1tiztNgIaa+DHHQzmOCuHb9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SrPGMLsUEPUKhc3RhU1c5TMkTtuEHRylbkifV77yKIE=;
 b=VBN58U+rgULbzVWJvYWUm00f3Hdvq+I7JplszFDkQMSmBsv1Hy9vXjmCTvT2MZ3AMmaG1BLWQFNXqSAfaFtNKi69GbEkWXtc/j4DatXyZG5TqBD03NcwKFrn6wXOCkjkTXu8Rn6/tExbvD9XMUlLm5mCApgCYCDsPphiyud4Z0o=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:05:11 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:05:11 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 25/32] staging: wfx: simplify usage of wfx_tx_queues_put()
Date:   Wed,  1 Apr 2020 13:03:58 +0200
Message-Id: <20200401110405.80282-26-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:05:09 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 938b6c8e-ca5e-43d9-a11c-08d7d62c8bb1
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285282FDB6D743FC4B831FA93C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /vyoY46YSncBi8N6TLiuZ05Fl/YsDNq3A/L4Yj6BL1cbED3dASjytmxJZwN3QlgkSCIrCdNEu7WXibphrQYeQkEQFF5weoZJbmVS9eqIqh419n8pzlN4zpmhiKLLiJn/y79QwZCy9fl6UbUelq1+q/ynrC52wiHSTJpJZ624E1PAzdy7ib0Y4HTHSrjSeoBpmULQLWRDLf/AjT5Hj4fEJ6YfygNklrjByInkxryID1tgpDnpF+bl1++SvNGy6WYMgvSenY6RN44MFs+iEkH2jHEGG8Bg3nIDw89j+AjoofKy+QKdZTApTkduDcZCoHwp0ecJVxiijJaeXIXGSAlbynA2FnYsrjGUmG8M0mrbyelcJ63iBoxw+/jY77OMki7y3qKseb/nyBoHuN+ulw1Ek+I7GrQUjgZNPeAhUKP7qXcA5TangqeYsVBPCY5KnBpT
X-MS-Exchange-AntiSpam-MessageData: m2xNRBDodGcpHi9FDDN1K73uDIgvggk321DDv3eugaX62e6jHbDHaDjIpTedDkeT2hxu3TRbkDLc3XhGvJpUOcS+ofKHd9sXEqyS6w7mdCeO1ao9MmlgGQMbFUH8BVSe+xWT99P6/hBgQwfQj+XWPm5MO4mykDhkQZpnrzeXP+s0YMbCcNTTR5w+oY93Tk5FO4q+SBTuM+0QIm5EEW1dGA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 938b6c8e-ca5e-43d9-a11c-08d7d62c8bb1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:05:11.3549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcDAsAAzybDjXMMKAh+otitrW8ToJwR6+VACUCHYVmw1cn8/oe4jbVr7+C8GD2xIZmg1jwZpkXSQPiEWC09Y5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHF1ZXVlIHVzZWQgZm9yIHdmeF90eF9xdWV1ZV9wdXQoKSBjYW4gYmUgZGVkdWN0ZWQgZnJvbSB0
aGUgY29udGVudApvZiB0aGUgc2tiLiBTbyBkcm9wIHRoaXMgcGFyYW1ldGVyIGZyb20gY2FsbCB0
byB3ZnhfdHhfcXVldWVzX3B1dCgpLgoKSW4gYWRkLCB0aGlzIGNoYW5nZSB1bmlmb3JtaXplcyB1
c2FnZSBvZiBmdW5jdGlvbnMgd2Z4X3R4X3F1ZXVlc18qLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0
bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvZGF0YV90eC5jIHwgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jICAg
fCA2ICsrKy0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oICAgfCAzICstLQogMyBmaWxl
cyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFf
dHguYwppbmRleCAyNTMzZDRmNTNmODMuLmQyZTkyNTIxOGVkYSAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4
LmMKQEAgLTQ2MSw3ICs0NjEsNyBAQCBzdGF0aWMgaW50IHdmeF90eF9pbm5lcihzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSwKIAogCS8vIEF1eGlsaWFyeSBv
cGVyYXRpb25zCiAJd2Z4X3R4X21hbmFnZV9wbSh3dmlmLCBoZHIsIHR4X3ByaXYsIHN0YSk7Ci0J
d2Z4X3R4X3F1ZXVlX3B1dCh3dmlmLT53ZGV2LCAmd3ZpZi0+d2Rldi0+dHhfcXVldWVbcXVldWVf
aWRdLCBza2IpOworCXdmeF90eF9xdWV1ZXNfcHV0KHd2aWYtPndkZXYsIHNrYik7CiAJaWYgKHR4
X2luZm8tPmZsYWdzICYgSUVFRTgwMjExX1RYX0NUTF9TRU5EX0FGVEVSX0RUSU0pCiAJCXNjaGVk
dWxlX3dvcmsoJnd2aWYtPnVwZGF0ZV90aW1fd29yayk7CiAJd2Z4X2JoX3JlcXVlc3RfdHgod3Zp
Zi0+d2Rldik7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKaW5kZXggYTAzODYwZGIyZjU0Li5jYzg5YmZlMWRiYjQg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYworKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3F1ZXVlLmMKQEAgLTE1MCw5ICsxNTAsOSBAQCB2b2lkIHdmeF90eF9xdWV1ZXNf
ZGVpbml0KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCXdmeF90eF9xdWV1ZXNfY2xlYXIod2Rldik7
CiB9CiAKLXZvaWQgd2Z4X3R4X3F1ZXVlX3B1dChzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc3RydWN0
IHdmeF9xdWV1ZSAqcXVldWUsCi0JCSAgICAgIHN0cnVjdCBza19idWZmICpza2IpCit2b2lkIHdm
eF90eF9xdWV1ZXNfcHV0KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2ti
KQogeworCXN0cnVjdCB3ZnhfcXVldWUgKnF1ZXVlID0gJndkZXYtPnR4X3F1ZXVlW3NrYl9nZXRf
cXVldWVfbWFwcGluZyhza2IpXTsKIAlzdHJ1Y3QgaWVlZTgwMjExX3R4X2luZm8gKnR4X2luZm8g
PSBJRUVFODAyMTFfU0tCX0NCKHNrYik7CiAKIAlpZiAodHhfaW5mby0+ZmxhZ3MgJiBJRUVFODAy
MTFfVFhfQ1RMX1NFTkRfQUZURVJfRFRJTSkKQEAgLTE3MCw3ICsxNzAsNyBAQCBpbnQgd2Z4X3Bl
bmRpbmdfcmVxdWV1ZShzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc3RydWN0IHNrX2J1ZmYgKnNrYikK
IAogCWF0b21pY19kZWMoJnF1ZXVlLT5wZW5kaW5nX2ZyYW1lcyk7CiAJc2tiX3VubGluayhza2Is
ICZ3ZGV2LT50eF9wZW5kaW5nKTsKLQl3ZnhfdHhfcXVldWVfcHV0KHdkZXYsIHF1ZXVlLCBza2Ip
OworCXdmeF90eF9xdWV1ZXNfcHV0KHdkZXYsIHNrYik7CiAJcmV0dXJuIDA7CiB9CiAKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
cXVldWUuaAppbmRleCAyNDFjYTMwMzliNTQuLjQ4NTE2MzVkMTU5YiAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUu
aApAQCAtMzYsMTAgKzM2LDkgQEAgdm9pZCB3ZnhfdHhfcXVldWVzX2NsZWFyKHN0cnVjdCB3Znhf
ZGV2ICp3ZGV2KTsKIGJvb2wgd2Z4X3R4X3F1ZXVlc19lbXB0eShzdHJ1Y3Qgd2Z4X2RldiAqd2Rl
dik7CiBib29sIHdmeF90eF9xdWV1ZXNfaGFzX2NhYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZik7CiB2
b2lkIHdmeF90eF9xdWV1ZXNfd2FpdF9lbXB0eV92aWYoc3RydWN0IHdmeF92aWYgKnd2aWYpOwor
dm9pZCB3ZnhfdHhfcXVldWVzX3B1dChzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc3RydWN0IHNrX2J1
ZmYgKnNrYik7CiBzdHJ1Y3QgaGlmX21zZyAqd2Z4X3R4X3F1ZXVlc19nZXQoc3RydWN0IHdmeF9k
ZXYgKndkZXYpOwogCi12b2lkIHdmeF90eF9xdWV1ZV9wdXQoc3RydWN0IHdmeF9kZXYgKndkZXYs
IHN0cnVjdCB3ZnhfcXVldWUgKnF1ZXVlLAotCQkgICAgICBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsK
IAogc3RydWN0IHNrX2J1ZmYgKndmeF9wZW5kaW5nX2dldChzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwg
dTMyIHBhY2tldF9pZCk7CiBpbnQgd2Z4X3BlbmRpbmdfcmVtb3ZlKHN0cnVjdCB3ZnhfZGV2ICp3
ZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsKLS0gCjIuMjUuMQoK
