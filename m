Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB6A19AA4D
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732642AbgDALGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:06:18 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:6083
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732478AbgDALFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fiuOc9UUKb2YIfQYsT1sQM1b4h6rDJcMqqFS1bKl/n5I9NBxw2+EjlijqQfmen+QTXhgwFFPIUeLEWn6O0yT5iaz6ScCBxxzx+6r2lP5YnVZcuVrq/1avTAAAnfydAxS4hIg3GIL2QFA+4O2m0Rjla6jd5r8xNRkUcd8sKasCRPSNV6W6ic/NCQeW96cX5Wnr+JhoPcdA6UztKgAXxL50JuLniqOW63+sjyhS8RlRrVdSyt4+ZQwqDXcPTHmg8dlcTqNswpvZG2ePb1/Qbnb6jX2I4wEfuExGN2HS6AtMTdeYZus8QZn7LFDnhIimMDNYRcaxUPoHOFpIgyo4j9qiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLXkHtgOfIXkrIv65auGzqAl7SnFA+CICIpiDZd5Mfc=;
 b=hbMMmN1mhanqW0eVozOPCYKmNE6eiX5xdjStQG2LwxVpiWyjIgIzJI3hA2J/YHrOA+ydlmu3LTA5j8MQdT6m6TCAZuKL6sF578KEmVWn9jo5vGlvxW+0PjNbpKNAS+nFz4e3+rk7r9YB9ij3pDAaokP9ucveaCW41VqEow8nnufU2QRKtvE7swEU9APxh7XZUwll8IK2tmpjN8QFnLmB1nhDhbCc1IFrC8Zj0uURfjDG/ZwZLvhBcepUTnykJmlbicJW86Aq7jmlwNfiEQNOW6sSvPS4mOaSJ3Fi2akPBDRjwDFj5eg4scWILj6Gwh0OPb4a7OC03NDqmD137G/1TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLXkHtgOfIXkrIv65auGzqAl7SnFA+CICIpiDZd5Mfc=;
 b=lDoAZBtFGGcMdA0kfRASUGKxWPZ3ctMXJpNMVS1XVfc/rIUcqMjgtipX+WW9TipT5kRFDzPP5Kv+52rYyiUPBhNInnqENBsliRq2dQDSVJEPSbm3KClpJNNvcvlb+T2LwRQdpmA1R7VW38PN5ksK5dPAppMFBdfhnrkN6Tnyuao=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:05:14 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:05:14 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 26/32] staging: wfx: improve interface between data_tx.c and queue.c
Date:   Wed,  1 Apr 2020 13:03:59 +0200
Message-Id: <20200401110405.80282-27-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:05:11 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97463663-6387-4ee3-38c8-08d7d62c8d22
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB428589646418558A6EB0774693C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ctcs35DUbRf2jjxtaIJt/OZH50BOMMP/3GMj37QfEFi8DhsXm+u3KmRY1jZNhI+QDE8kZfvdlqo4kAB0by0IU0FaYSXpxf8rhD6aMR7tOTEQ2pBrDJgdtrK+u3XdIWDm4R752IhevIMb06R2+Vyp7jNwEkjeb2uk0BW6eliC39aeJviURE9FnLH6vuFJKeyEMdgei67/Ye0xmy684nQjVAFE9QIPmWusCAOCivRxYpA0ufCzgJbfE5WXIr0yu89t85KbM4zQ9XwocBJ3wUo6yShJw8DkoWoJ/EW+ZzOUx9fYO0Ksorf4Z4zyh5KzjrW0WKdtYzbdz8huzXdiziXS0rkRzSduw3B2QXv51K/7Ndg4zR2aIZdEIzJzJWCmHwEdh35QjrIvgNmTyP+QODcguNVi61ZmBvr1Xy3kxCvo9oFGMT8dJZkxM4nIs8rnPWVO
X-MS-Exchange-AntiSpam-MessageData: o1fbsVfMdt7w74HbnjKvV1u9FqGuaCryNJ/XBVbfyR6LYOYhaBwe57Uzv11dG2UrUYw5BSIwhySgfvq8ESKCMnBawFfL478iTp3TFYlQLcDPNK/Ghx1vMW3/LlPvZj4aYWGCtRUWGU7Cin7jSvIeb5EkW7QVH6LiFCEgLRphr07e7JGW19WoMS4UU7bRpXLNTK+5GFxU0R8dh6cAfRaT8A==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97463663-6387-4ee3-38c8-08d7d62c8d22
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:05:14.2343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xIEKb6xF6ach2a3TxsvXYiEBqbkVDrWNlRVjoD0JqGKbt6nJdfwDS8+6wMVQ99nEc52KHiMrql+p/por0eungA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudGx5LCB3ZnhfcGVuZGluZ19yZW1vdmUoKSAoZnJvbSBxdWV1ZS5jKSBjYWxsIHdmeF9za2Jf
ZHRvcigpCihmcm9tIGRhdGFfdHguYykgdGhhdCBmb3J3YXJkIHRoZSB0eCBzdGF0dXMgdG8gbWFj
ODAyMTEuCgpNb3Jlb3ZlciwgdGhlcmUgbm8gcHVycG9zZSB0byByZXRyaWV2ZSBhIGZyYW1lIGZy
b20gdGhlIHBlbmRpbmcgcXVldWUKd2l0aG91dCBkZXF1ZXVpbmcgaXQuIFNvLCB0aGUgbWFpbiBw
dXJwb3NlIG9mIHdmeF9wZW5kaW5nX3JlbW92ZSgpIGlzIHRvCmZvcndhcmQgdGhlIHR4IHN0YXR1
cyB0byBtYWM4MDIxMS4KCkxldCdzIG1ha2UgdGhlIGFyY2hpdGVjdHVyZSBjbGVhbmVyOgogIC0g
bWVyZ2Ugd2Z4X3BlbmRpbmdfcmVtb3ZlKCkgaW50byB3ZnhfcGVuZGluZ19nZXQoKQogIC0gY2Fs
bCB3Znhfc2tiX2R0b3IoKSBmcm9tIGRhdGFfdHguYwoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvZGF0YV90eC5jIHwgIDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyAgIHwg
MjIgKysrKysrKy0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oICAg
fCAgMSAtCiAzIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMTcgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2RhdGFfdHguYwppbmRleCBkMmU5MjUyMThlZGEuLjE3MjA5ZjY0NWU0YiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9kYXRhX3R4LmMKQEAgLTU4Niw3ICs1ODYsNyBAQCB2b2lkIHdmeF90eF9jb25maXJt
X2NiKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaGlmX2NuZl90eCAqYXJnKQog
CQkgICAgYXJnLT5wYWNrZXRfaWQgPT0gd3ZpZi0+YnNzX2xvc3NfY29uZmlybV9pZCkKIAkJCXdm
eF9jcW1fYnNzbG9zc19zbSh3dmlmLCAwLCAwLCAxKTsKIAl9Ci0Jd2Z4X3BlbmRpbmdfcmVtb3Zl
KHd2aWYtPndkZXYsIHNrYik7CisJd2Z4X3NrYl9kdG9yKHd2aWYtPndkZXYsIHNrYik7CiB9CiAK
IHN0YXRpYyB2b2lkIHdmeF9ub3RpZnlfYnVmZmVyZWRfdHgoc3RydWN0IHdmeF92aWYgKnd2aWYs
IHN0cnVjdCBza19idWZmICpza2IpCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1
ZXVlLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKaW5kZXggY2M4OWJmZTFkYmI0Li5h
MWEyZjc3NTZhMjcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYworKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKQEAgLTE3NCwzMCArMTc0LDIyIEBAIGludCB3
ZnhfcGVuZGluZ19yZXF1ZXVlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAq
c2tiKQogCXJldHVybiAwOwogfQogCi1pbnQgd2Z4X3BlbmRpbmdfcmVtb3ZlKHN0cnVjdCB3Znhf
ZGV2ICp3ZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQotewotCXN0cnVjdCB3ZnhfcXVldWUgKnF1
ZXVlID0gJndkZXYtPnR4X3F1ZXVlW3NrYl9nZXRfcXVldWVfbWFwcGluZyhza2IpXTsKLQotCVdB
Uk5fT04oc2tiX2dldF9xdWV1ZV9tYXBwaW5nKHNrYikgPiAzKTsKLQlXQVJOX09OKCFhdG9taWNf
cmVhZCgmcXVldWUtPnBlbmRpbmdfZnJhbWVzKSk7Ci0KLQlhdG9taWNfZGVjKCZxdWV1ZS0+cGVu
ZGluZ19mcmFtZXMpOwotCXNrYl91bmxpbmsoc2tiLCAmd2Rldi0+dHhfcGVuZGluZyk7Ci0Jd2Z4
X3NrYl9kdG9yKHdkZXYsIHNrYik7Ci0KLQlyZXR1cm4gMDsKLX0KLQogc3RydWN0IHNrX2J1ZmYg
KndmeF9wZW5kaW5nX2dldChzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgdTMyIHBhY2tldF9pZCkKIHsK
LQlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOworCXN0cnVjdCB3ZnhfcXVldWUgKnF1ZXVlOwogCXN0cnVj
dCBoaWZfcmVxX3R4ICpyZXE7CisJc3RydWN0IHNrX2J1ZmYgKnNrYjsKIAogCXNwaW5fbG9ja19i
aCgmd2Rldi0+dHhfcGVuZGluZy5sb2NrKTsKIAlza2JfcXVldWVfd2Fsaygmd2Rldi0+dHhfcGVu
ZGluZywgc2tiKSB7CiAJCXJlcSA9IHdmeF9za2JfdHhyZXEoc2tiKTsKIAkJaWYgKHJlcS0+cGFj
a2V0X2lkID09IHBhY2tldF9pZCkgewogCQkJc3Bpbl91bmxvY2tfYmgoJndkZXYtPnR4X3BlbmRp
bmcubG9jayk7CisJCQlxdWV1ZSA9ICZ3ZGV2LT50eF9xdWV1ZVtza2JfZ2V0X3F1ZXVlX21hcHBp
bmcoc2tiKV07CisJCQlXQVJOX09OKHNrYl9nZXRfcXVldWVfbWFwcGluZyhza2IpID4gMyk7CisJ
CQlXQVJOX09OKCFhdG9taWNfcmVhZCgmcXVldWUtPnBlbmRpbmdfZnJhbWVzKSk7CisJCQlhdG9t
aWNfZGVjKCZxdWV1ZS0+cGVuZGluZ19mcmFtZXMpOworCQkJc2tiX3VubGluayhza2IsICZ3ZGV2
LT50eF9wZW5kaW5nKTsKIAkJCXJldHVybiBza2I7CiAJCX0KIAl9CmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmgKaW5k
ZXggNDg1MTYzNWQxNTliLi45YmMxYTUyMDBlNjQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvcXVldWUuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmgKQEAgLTQxLDcg
KzQxLDYgQEAgc3RydWN0IGhpZl9tc2cgKndmeF90eF9xdWV1ZXNfZ2V0KHN0cnVjdCB3ZnhfZGV2
ICp3ZGV2KTsKIAogCiBzdHJ1Y3Qgc2tfYnVmZiAqd2Z4X3BlbmRpbmdfZ2V0KHN0cnVjdCB3Znhf
ZGV2ICp3ZGV2LCB1MzIgcGFja2V0X2lkKTsKLWludCB3ZnhfcGVuZGluZ19yZW1vdmUoc3RydWN0
IHdmeF9kZXYgKndkZXYsIHN0cnVjdCBza19idWZmICpza2IpOwogaW50IHdmeF9wZW5kaW5nX3Jl
cXVldWUoc3RydWN0IHdmeF9kZXYgKndkZXYsIHN0cnVjdCBza19idWZmICpza2IpOwogdW5zaWdu
ZWQgaW50IHdmeF9wZW5kaW5nX2dldF9wa3RfdXNfZGVsYXkoc3RydWN0IHdmeF9kZXYgKndkZXYs
CiAJCQkJCSAgc3RydWN0IHNrX2J1ZmYgKnNrYik7Ci0tIAoyLjI1LjEKCg==
