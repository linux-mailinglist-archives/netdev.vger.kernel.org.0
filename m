Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 345FB19AA41
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732469AbgDALFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:05:13 -0400
Received: from mail-eopbgr750070.outbound.protection.outlook.com ([40.107.75.70]:46082
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732397AbgDALFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1JZye9hiymctHsY/I0hLU9FKhbmtUAVd+aQCpzPfJkwD6CddKrYqb3PuYx3ZUwnqJJbP6EBa4coeeEcHXZ2OAEximizbTBX0RqyBdM3DrS6nmBeJjRbCHGYtpemSm6EuP2VO+N7/DX0SmylHJ+wzHdQ1W/wDdSKlL8tca8RBByrgqi4UglkIpU73sduPjEOGAhLfMzD/W2x/viWgJEjNmvISYNNL/WLJchYBu5D8NQqy5V2mPYhf113oCGMC4yt1DyTe7tobhKVqwTuY41S0JpFvPAm0vQhw9zJi/NF9VzJpA+ksQ84K6GaDe9UKO03m9tnIK16tO+2zNf3T9fyTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckRI9VlPgVa5+jADj0msC+suM5ZwBwbWygxuwsP1SDM=;
 b=mXxh2OSbGdxfFmLcgUEfihfU9viqMROuuHVsZo1+xMAE75rMTdiMw9NocsXIBARdee0kosRoXBD6SMUXpu9tsaZb5cQ32bM77t7/jXYl0+LofKwkbSj1toyu6k2NPpF/F43/JGXQUAjIOrzeSlINhl5rLgnHYEPNYUnMZxsKOGWRA55bBbU0GrCIp3pzFqie0pfAuPwhSHzFmoni7zCQptGFceSdnawzYp1HV3KmuMGdAyXOdXdajxFvTxKq+lR3qimJ60kZu80//Q2HuK8YgrJOLwb6Rm2hrk4VICQqefCnywdaaXV8Xs2cKKfoKAi6lBnruuVXJ6CrbnxdP1Hg2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckRI9VlPgVa5+jADj0msC+suM5ZwBwbWygxuwsP1SDM=;
 b=bryt0T8F32rI02mleVev5MQRbgh1DYd8Ey17BHwy02QS0RqsWjbvAZJyBgkMCViJUs0twZixW8lnaXERHCBkH9ozwtTxDmgnQDWfr89epJlIiLfSPdKJnK3W2ZZmX+NAV2u4I4SdhGAz49B9lyxtJsSPxZnNa9P768mCTAVMPmU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:05:00 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:05:00 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 20/32] staging: wfx: replace wfx_tx_queues_get_after_dtim() by wfx_tx_queues_has_cab()
Date:   Wed,  1 Apr 2020 13:03:53 +0200
Message-Id: <20200401110405.80282-21-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:59 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06119e87-49bb-4b4b-4862-08d7d62c859e
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285BCDBBC564F7E177CAFD293C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BcnC5xBsteWgenmoLkOeOIhZq7fwBzlwql+JhuLgLy9xPgaRW3LYkQcupxSTn4j+GM00iwEdrdjxJrf4CjHT4iWpitLMnbkedDhGGl2zAjCwGP7/Fp6pV4P6umlsgwe0Kpcfaptv500BovdS8OidimiTinP0U9VsiXM5sPFIHepVwnJI0vNVr8tog85ARnk7fK5m7Y6RcVyaX9i1qXpbKnUXe9w/RqQ1IxweIUTyylUQ5Yz2x84OwABCro5yd1/5JfXRWnWKtCGLJ0a8UEQZRT17Vxh+KECUoE9A3BAezh/f9ttisxpcOYbdGVOPl7dsaHwNQT8dDDzCt8/9LraZv8fjR7TGnLnl9iDc3ZacpuHYM6E2SZPxYsQeyylEskxMWh8GIU0lJYMifL7XbqjgndTb11TYTj0xCPxnvIfU5Wbw4kCq3uAklmwDcFb7iNuy
X-MS-Exchange-AntiSpam-MessageData: yQSkw2LqeoUlc/ZYk9Ski8UbP7shmi3p6woKBAaUIRaXDeCSutir5LBsthHwFWaOf/gzH6kcQhG74g+PomE29gVygnS2fGp8zuafhUw0fCaRGyXhcpQMO7Iou84MbCAIeth9MAiJkr2lF8Suh0I/syJbUZjIS1jv2YfpCYKaY4tvRm/kd/HdXGG9alFO9vBeS/vJu4vVWEAD/z6SGL/ViA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06119e87-49bb-4b4b-4862-08d7d62c859e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:05:00.7800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fIr9lblWd1l+RDm6AVoB/qK2S/kH4IzzQJcvXjuy20xb5o92i9XpcTABrSeg/DbfbWNSPI45KNM5Pl03d2kj5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgbm90IG5lY2Vzc2FyeSB0byByZXR1cm4gYSBza2IuIEp1c3QgZ2V0dGluZyB0aGUgaW5mb3Jt
YXRpb24gaWYKdGhlcmUgaXMgdHJhZmZpYyB0byBiZSBzZW50IGFmdGVyIERUSU0gaXMgc3VmZmlj
aWVudC4KCkluIGFkZCwgdGhlIGFjcm9ueW0gImNhYiIgKENvbnRlbnQgQWZ0ZXIgKERUSU0pIEJl
YWNvbikgaXMgdXNlZCBpbgptYWM4MDIxMSB0byBkZXNpZ25hdGUgdGhpcyBraW5kIG9mIHRyYWZm
aWMuCgpTbywgbWFrZSB3ZnhfdHhfcXVldWVzX2dldF9hZnRlcl9kdGltKCkgcmV0dXJuIGEgYm9v
bGVhbiBhbmQgcmVuYW1lCmFjY29yZGluZ2x5LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91
aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvcXVldWUuYyB8IDQwICsrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0KIGRy
aXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaCB8ICAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jICAgfCAgNCArKy0tCiAzIGZpbGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyksIDIzIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwppbmRleCAwNDZhYmE3NzYxOGEuLjRkZGIyYzczNzBj
ZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvcXVldWUuYwpAQCAtMjY0LDYgKzI2NCwyNiBAQCB1bnNpZ25lZCBpbnQgd2Z4
X3BlbmRpbmdfZ2V0X3BrdF91c19kZWxheShzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwKIAlyZXR1cm4g
a3RpbWVfdXNfZGVsdGEobm93LCB0eF9wcml2LT54bWl0X3RpbWVzdGFtcCk7CiB9CiAKK2Jvb2wg
d2Z4X3R4X3F1ZXVlc19oYXNfY2FiKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQoreworCXN0cnVjdCB3
ZnhfZGV2ICp3ZGV2ID0gd3ZpZi0+d2RldjsKKwlzdHJ1Y3QgaWVlZTgwMjExX3R4X2luZm8gKnR4
X2luZm87CisJc3RydWN0IGhpZl9tc2cgKmhpZjsKKwlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOworCWlu
dCBpOworCisJZm9yIChpID0gMDsgaSA8IElFRUU4MDIxMV9OVU1fQUNTOyArK2kpIHsKKwkJc2ti
X3F1ZXVlX3dhbGsoJndkZXYtPnR4X3F1ZXVlW2ldLnF1ZXVlLCBza2IpIHsKKwkJCXR4X2luZm8g
PSBJRUVFODAyMTFfU0tCX0NCKHNrYik7CisJCQloaWYgPSAoc3RydWN0IGhpZl9tc2cgKilza2It
PmRhdGE7CisJCQlpZiAoKHR4X2luZm8tPmZsYWdzICYgSUVFRTgwMjExX1RYX0NUTF9TRU5EX0FG
VEVSX0RUSU0pICYmCisJCQkgICAgKGhpZi0+aW50ZXJmYWNlID09IHd2aWYtPmlkKSkKKwkJCQly
ZXR1cm4gdHJ1ZTsKKwkJfQorCX0KKwlyZXR1cm4gZmFsc2U7Cit9CisKIGJvb2wgd2Z4X3R4X3F1
ZXVlc19lbXB0eShzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIHsKIAlpbnQgaTsKQEAgLTM0NCwyNiAr
MzY0LDYgQEAgc3RhdGljIHN0cnVjdCB3ZnhfcXVldWUgKndmeF90eF9xdWV1ZV9tYXNrX2dldChz
dHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAlyZXR1cm4gJnd2aWYtPndkZXYtPnR4X3F1ZXVlW3dpbm5l
cl07CiB9CiAKLXN0cnVjdCBoaWZfbXNnICp3ZnhfdHhfcXVldWVzX2dldF9hZnRlcl9kdGltKHN0
cnVjdCB3ZnhfdmlmICp3dmlmKQotewotCXN0cnVjdCB3ZnhfZGV2ICp3ZGV2ID0gd3ZpZi0+d2Rl
djsKLQlzdHJ1Y3QgaWVlZTgwMjExX3R4X2luZm8gKnR4X2luZm87Ci0Jc3RydWN0IGhpZl9tc2cg
KmhpZjsKLQlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOwotCWludCBpOwotCi0JZm9yIChpID0gMDsgaSA8
IElFRUU4MDIxMV9OVU1fQUNTOyArK2kpIHsKLQkJc2tiX3F1ZXVlX3dhbGsoJndkZXYtPnR4X3F1
ZXVlW2ldLnF1ZXVlLCBza2IpIHsKLQkJCXR4X2luZm8gPSBJRUVFODAyMTFfU0tCX0NCKHNrYik7
Ci0JCQloaWYgPSAoc3RydWN0IGhpZl9tc2cgKilza2ItPmRhdGE7Ci0JCQlpZiAoKHR4X2luZm8t
PmZsYWdzICYgSUVFRTgwMjExX1RYX0NUTF9TRU5EX0FGVEVSX0RUSU0pICYmCi0JCQkgICAgKGhp
Zi0+aW50ZXJmYWNlID09IHd2aWYtPmlkKSkKLQkJCQlyZXR1cm4gKHN0cnVjdCBoaWZfbXNnICop
c2tiLT5kYXRhOwotCQl9Ci0JfQotCXJldHVybiBOVUxMOwotfQotCiBzdHJ1Y3QgaGlmX21zZyAq
d2Z4X3R4X3F1ZXVlc19nZXQoc3RydWN0IHdmeF9kZXYgKndkZXYpCiB7CiAJc3RydWN0IHNrX2J1
ZmYgKnNrYjsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaCBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvcXVldWUuaAppbmRleCAzOWMyNjVlNGI4NmUuLjJjNDcyNDY5OWVkMCAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy93ZngvcXVldWUuaApAQCAtMzYsOSArMzYsOSBAQCB2b2lkIHdmeF90eF9xdWV1ZXNfaW5p
dChzdHJ1Y3Qgd2Z4X2RldiAqd2Rldik7CiB2b2lkIHdmeF90eF9xdWV1ZXNfZGVpbml0KHN0cnVj
dCB3ZnhfZGV2ICp3ZGV2KTsKIHZvaWQgd2Z4X3R4X3F1ZXVlc19jbGVhcihzdHJ1Y3Qgd2Z4X2Rl
diAqd2Rldik7CiBib29sIHdmeF90eF9xdWV1ZXNfZW1wdHkoc3RydWN0IHdmeF9kZXYgKndkZXYp
OworYm9vbCB3ZnhfdHhfcXVldWVzX2hhc19jYWIoc3RydWN0IHdmeF92aWYgKnd2aWYpOwogdm9p
ZCB3ZnhfdHhfcXVldWVzX3dhaXRfZW1wdHlfdmlmKHN0cnVjdCB3ZnhfdmlmICp3dmlmKTsKIHN0
cnVjdCBoaWZfbXNnICp3ZnhfdHhfcXVldWVzX2dldChzdHJ1Y3Qgd2Z4X2RldiAqd2Rldik7Ci1z
dHJ1Y3QgaGlmX21zZyAqd2Z4X3R4X3F1ZXVlc19nZXRfYWZ0ZXJfZHRpbShzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZik7CiAKIHZvaWQgd2Z4X3R4X3F1ZXVlX3B1dChzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwg
c3RydWN0IHdmeF9xdWV1ZSAqcXVldWUsCiAJCSAgICAgIHN0cnVjdCBza19idWZmICpza2IpOwpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMKaW5kZXggNWM1YjUyZGM3YmRkLi5lMWQ3YTA2NzBjOWQgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpA
QCAtODU3LDcgKzg1Nyw3IEBAIHN0YXRpYyBpbnQgd2Z4X3VwZGF0ZV90aW0oc3RydWN0IHdmeF92
aWYgKnd2aWYpCiAJCXRpbV9wdHJbMl0gPSAwOwogCiAJCS8qIFNldC9yZXNldCBhaWQwIGJpdCAq
LwotCQlpZiAod2Z4X3R4X3F1ZXVlc19nZXRfYWZ0ZXJfZHRpbSh3dmlmKSkKKwkJaWYgKHdmeF90
eF9xdWV1ZXNfaGFzX2NhYih3dmlmKSkKIAkJCXRpbV9wdHJbNF0gfD0gMTsKIAkJZWxzZQogCQkJ
dGltX3B0cls0XSAmPSB+MTsKQEAgLTg4OCw3ICs4ODgsNyBAQCBpbnQgd2Z4X3NldF90aW0oc3Ry
dWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEsIGJvb2wgc2V0
KQogCiB2b2lkIHdmeF9zdXNwZW5kX3Jlc3VtZV9tYyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgZW51
bSBzdGFfbm90aWZ5X2NtZCBub3RpZnlfY21kKQogewotCVdBUk4oIXdmeF90eF9xdWV1ZXNfZ2V0
X2FmdGVyX2R0aW0od3ZpZiksICJpbmNvcnJlY3Qgc2VxdWVuY2UiKTsKKwlXQVJOKCF3ZnhfdHhf
cXVldWVzX2hhc19jYWIod3ZpZiksICJpbmNvcnJlY3Qgc2VxdWVuY2UiKTsKIAlXQVJOKHd2aWYt
PmFmdGVyX2R0aW1fdHhfYWxsb3dlZCwgImluY29ycmVjdCBzZXF1ZW5jZSIpOwogCXd2aWYtPmFm
dGVyX2R0aW1fdHhfYWxsb3dlZCA9IHRydWU7CiAJd2Z4X2JoX3JlcXVlc3RfdHgod3ZpZi0+d2Rl
dik7Ci0tIAoyLjI1LjEKCg==
