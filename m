Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013231E7CE4
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 14:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgE2MNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 08:13:16 -0400
Received: from mail-mw2nam12on2089.outbound.protection.outlook.com ([40.107.244.89]:41665
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725865AbgE2MNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 08:13:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebcbzsnyGsxICLboYQviSixPTwtdufi8aj6kTP2FC2Y5DXS69qpMwZHf9XhmOlJtfDqp9h0iX5T/Smc4sOP0aQjTIP5Zj6lmPJR67aCcUy9AqyVlRIFQisVxg5aJdqDu2e8h82y7crcc7kSKOWx9RuhQoCe9Q1JXOj1M2uyxtU5uFrzdFuFV+47IJyuQFuj2OHTIDnNt23uhFmQeW0pGeLvude0C0zXomTo9FtxkPWGUE3DKkM6gt2n9H0/Ku/aD6KQuL/pKm8GZbj0ePKGzngsVuPBeBb1FTPoF95bFOm1AvOYfxcAjZ+ej3bauAGqAYpefdhX5GmzvgY8Xbrq8qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k04/jIoT8mbQE9s9jyergHe6EA0xMx64gE6i0tErU6s=;
 b=KmsVymE5UPWWXZtUvxyzRYFYyvL6HUdfl1iXGQgZN8VaR8GzAB4qE0JJCHCsl6kKs2YB1vOPGVY5HI5JlFx0H37+N0h4IXKx9Ti3TlCQslCN2dYJiC5CYNEnYNQ1UbyOYudIU5+Qhhskl1DQvGNbWGhPWHpt/UWENSAYsYcHkW6l6ZCk0ZSabrzvsLQfZyyqlgLsIa947LSUZyZamAd/0mNVZBzs2Xpt7fBAAXBmnsZA1qOURO9vTcEmnS0fznb5SHV8wumGTE+mKhoaWUWUhL4htup05xHREP2bPeq5r/fka+5MD8AwMoswKwpdk196rW4Jo1U3MzpJaFbHjcXpUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k04/jIoT8mbQE9s9jyergHe6EA0xMx64gE6i0tErU6s=;
 b=O4tQQd6b3Ztkzq5BCcE7OfV7Y/hnvP66xLoPUdHtux7Z89aMZiAcROz7vrwpCNg/BxvrklSA9tAHATF4VISnI6nP3Pijt/CWtbIt98rjWq1ukKKikxbirUGgaWOMjFao0boo4jPcwzsBTW57/5Jz1wK5hPek56zfgaulEwMhbbM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3469.namprd11.prod.outlook.com (2603:10b6:805:bf::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Fri, 29 May
 2020 12:13:11 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 12:13:11 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2] staging: wfx: fix coherency of hif_scan() prototype
Date:   Fri, 29 May 2020 14:12:56 +0200
Message-Id: <20200529121256.1045521-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA9PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:806:20::23) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by SA9PR03CA0018.namprd03.prod.outlook.com (2603:10b6:806:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Fri, 29 May 2020 12:13:09 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bf1c157-8dc0-414d-99a5-08d803c9a7c1
X-MS-TrafficTypeDiagnostic: SN6PR11MB3469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB34690F57C25D366DFBF8AEB0938F0@SN6PR11MB3469.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /lAXs+xBrLycry2psuAOEDOb3GmIVI/tih2lGmjBdWYLESKzeitLHTXNmvcu8tRfgG6MPFHeL/20EjxpSG7QcpHUEy365MvJeVEi5w2Enjh2kPS1O3gnAt/tjd2BPS78j8b0yUUW0cEoKEBf5+pF14y3t7ulS61HN4xjUfGsIfFyXTXf2bGDgs/YfYi3LyeZeo/o5fr+HHZzaSBPk18e0v/BVSBPbVFzC7+GmJ+jes6b0bHj55aP3/fxlUcZfMZl4Fy1bMxtZ2mu2iO2WogdtT9VkcK4Uc1+ftNO+wrfrWITJRb+tUgkl50aYdVaMYV9MNwO0jAbUbfpBG7TlyiCqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(136003)(346002)(376002)(396003)(366004)(66556008)(66476007)(66946007)(2616005)(2906002)(107886003)(54906003)(478600001)(6486002)(86362001)(4326008)(8676002)(316002)(186003)(52116002)(7696005)(16526019)(8936002)(1076003)(36756003)(66574014)(5660300002)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PP8/DAXC54xDk1f5F4iO3+NiISMbS25YP5bwZ05ktyFFwMIBsfjU4YwWB3KJkaoELiK/xTrD/Nuxp1ypHTvsbwtJ4om9QR9I099jGO3JO5VzhJ6I0ityOKqglrMap7/9PCjpTO4Z5XBzOwP5qVtXfolaujiFX58WKLOA50igQMQSe30FPWn4RwufoUZhT61rzFf1NTfV3H0/wMpJsJQXkLPoQpoHL7wL0eUDFR4hcsc84PenHenwkOr0ETP1PTmMcB3vUdifV15gbrpxIq+eH9SXmOaFzs3jS3hNNcfLcYKGY/fETmJ7bwEVxd05fTcnHN540kyAXMNX+iN6obbKW9qO6RMsmnLEjzigWp0LMqDNO3EZlWVigBYP1xC3T53Ufjew4eJ88DBIWPteAU2qMP8mvjbUSIiP9mTkA4tOxZ3Q7tL8lunbpDaBlkOljGXAC+pbPwHiaXmXaDFDsAwhDdctly63h1XaQp4dtJl8osyERrM9QsuO60m/VsELOuOo8SFov+7wj/cRCafpAmyCR+wOu+9GJT1kr6/HhSZmbOk=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bf1c157-8dc0-414d-99a5-08d803c9a7c1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 12:13:11.5295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2LQ9kxTUosqnVo901wteBfMQMKf/TaL2wkdCYhySGm7gcQVu/Lc+1pUXclmFYydZK0/0mgxx5MedUmXPOAvwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3469
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZ1bmN0aW9uIGhpZl9zY2FuKCkgcmV0dXJuIHRoZSB0aW1lb3V0IGZvciB0aGUgY29tcGxldGlv
biBvZiB0aGUKc2NhbiByZXF1ZXN0LiBJdCBpcyB0aGUgb25seSBmdW5jdGlvbiBmcm9tIGhpZl90
eC5jIHRoYXQgcmV0dXJuIGFub3RoZXIKdGhpbmcgdGhhbiBqdXN0IGFuIGVycm9yIGNvZGUuIFRo
aXMgYmVoYXZpb3IgaXMgbm90IGNvaGVyZW50IHdpdGggdGhlCnJlc3Qgb2YgZmlsZS4gV29yc2Us
IGlmIHZhbHVlIHJldHVybmVkIGlzIHBvc2l0aXZlLCB0aGUgY2FsbGVyIGNhbid0Cm1ha2Ugc2F5
IGlmIGl0IGlzIGEgdGltZW91dCBvciB0aGUgdmFsdWUgcmV0dXJuZWQgYnkgdGhlIGhhcmR3YXJl
LgoKVW5pZm9ybWl6ZSBBUEkgd2l0aCBvdGhlciBISUYgZnVuY3Rpb25zLCBvbmx5IHJldHVybiB0
aGUgZXJyb3IgY29kZSBhbmQKcGFzcyB0aW1lb3V0IHdpdGggcGFyYW1ldGVycy4KClNpZ25lZC1v
ZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0t
CgpJIGhhdmUgYWxyZWFkeSBzZW5kIHRoaXMgcGF0Y2ggc29tZSB0aW1lIGFnbyAgYnV0IGl0IHNl
ZW1zIGl0IGhhcyBiZWVuCmZvcmdvdHRlbiBpbiB0aGUgbWVyZ2VzLiBJdCBpcyBhIGdvb2QgbmV3
cyBiZWNhdXNlIEkgaGF2ZSBmb3VuZCBhIGJ1ZwppbnNpZGUuIFNvIHRoaXMgaXMgdGhlIHYyLgoK
djI6CiAgRml4ICJpZiAoKnRpbWVvdXQpIiBpbnN0ZWFkIG9mICJpZiAodGltZW91dCkiIGluIGhp
Zl9zY2FuKCkgKHRoYXQgbGVkCiAgdG8gdW5leHBlY3RlZCBzY2FuIHRpbWVvdXRzKQoKLS0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIHwgNiArKysrLS0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3R4LmggfCAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyAgIHwgNiArKyst
LS0KIDMgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl90eC5jCmluZGV4IDg5M2I2N2YyZjc5MmUuLjUxMTBmOWI5Mzc2MmMgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfdHguYwpAQCAtMjQwLDcgKzI0MCw3IEBAIGludCBoaWZfd3JpdGVfbWliKHN0cnVjdCB3
ZnhfZGV2ICp3ZGV2LCBpbnQgdmlmX2lkLCB1MTYgbWliX2lkLAogfQogCiBpbnQgaGlmX3NjYW4o
c3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVlc3QgKnJlcSwK
LQkgICAgIGludCBjaGFuX3N0YXJ0X2lkeCwgaW50IGNoYW5fbnVtKQorCSAgICAgaW50IGNoYW5f
c3RhcnRfaWR4LCBpbnQgY2hhbl9udW0sIGludCAqdGltZW91dCkKIHsKIAlpbnQgcmV0LCBpOwog
CXN0cnVjdCBoaWZfbXNnICpoaWY7CkBAIC0yODksMTEgKzI4OSwxMyBAQCBpbnQgaGlmX3NjYW4o
c3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVlc3QgKnJlcSwK
IAl0bW9fY2hhbl9mZyA9IDUxMiAqIFVTRUNfUEVSX1RVICsgYm9keS0+cHJvYmVfZGVsYXk7CiAJ
dG1vX2NoYW5fZmcgKj0gYm9keS0+bnVtX29mX3Byb2JlX3JlcXVlc3RzOwogCXRtbyA9IGNoYW5f
bnVtICogbWF4KHRtb19jaGFuX2JnLCB0bW9fY2hhbl9mZykgKyA1MTIgKiBVU0VDX1BFUl9UVTsK
KwlpZiAodGltZW91dCkKKwkJKnRpbWVvdXQgPSB1c2Vjc190b19qaWZmaWVzKHRtbyk7CiAKIAl3
ZnhfZmlsbF9oZWFkZXIoaGlmLCB3dmlmLT5pZCwgSElGX1JFUV9JRF9TVEFSVF9TQ0FOLCBidWZf
bGVuKTsKIAlyZXQgPSB3ZnhfY21kX3NlbmQod3ZpZi0+d2RldiwgaGlmLCBOVUxMLCAwLCBmYWxz
ZSk7CiAJa2ZyZWUoaGlmKTsKLQlyZXR1cm4gcmV0ID8gcmV0IDogdXNlY3NfdG9famlmZmllcyh0
bW8pOworCXJldHVybiByZXQ7CiB9CiAKIGludCBoaWZfc3RvcF9zY2FuKHN0cnVjdCB3Znhfdmlm
ICp3dmlmKQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaCBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX3R4LmgKaW5kZXggZTllY2E5MzMwMTc4OC4uZTFkYTI4YWVmNzA2
ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaAorKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eC5oCkBAIC00Miw3ICs0Miw3IEBAIGludCBoaWZfcmVhZF9taWIo
c3RydWN0IHdmeF9kZXYgKndkZXYsIGludCB2aWZfaWQsIHUxNiBtaWJfaWQsCiBpbnQgaGlmX3dy
aXRlX21pYihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgaW50IHZpZl9pZCwgdTE2IG1pYl9pZCwKIAkJ
ICB2b2lkICpidWYsIHNpemVfdCBidWZfc2l6ZSk7CiBpbnQgaGlmX3NjYW4oc3RydWN0IHdmeF92
aWYgKnd2aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVlc3QgKnJlcTgwMjExLAotCSAgICAg
aW50IGNoYW5fc3RhcnQsIGludCBjaGFuX251bSk7CisJICAgICBpbnQgY2hhbl9zdGFydCwgaW50
IGNoYW5fbnVtLCBpbnQgKnRpbWVvdXQpOwogaW50IGhpZl9zdG9wX3NjYW4oc3RydWN0IHdmeF92
aWYgKnd2aWYpOwogaW50IGhpZl9qb2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1
Y3QgaWVlZTgwMjExX2Jzc19jb25mICpjb25mLAogCSAgICAgc3RydWN0IGllZWU4MDIxMV9jaGFu
bmVsICpjaGFubmVsLCBjb25zdCB1OCAqc3NpZCwgaW50IHNzaWRsZW4pOwpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwpp
bmRleCA1N2VhOTk5NzgwMGI1Li5lOWRlMTk3ODQ4NjVjIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3NjYW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwpAQCAtNTYs
MTAgKzU2LDEwIEBAIHN0YXRpYyBpbnQgc2VuZF9zY2FuX3JlcShzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwKIAl3ZnhfdHhfbG9ja19mbHVzaCh3dmlmLT53ZGV2KTsKIAl3dmlmLT5zY2FuX2Fib3J0ID0g
ZmFsc2U7CiAJcmVpbml0X2NvbXBsZXRpb24oJnd2aWYtPnNjYW5fY29tcGxldGUpOwotCXRpbWVv
dXQgPSBoaWZfc2Nhbih3dmlmLCByZXEsIHN0YXJ0X2lkeCwgaSAtIHN0YXJ0X2lkeCk7Ci0JaWYg
KHRpbWVvdXQgPCAwKSB7CisJcmV0ID0gaGlmX3NjYW4od3ZpZiwgcmVxLCBzdGFydF9pZHgsIGkg
LSBzdGFydF9pZHgsICZ0aW1lb3V0KTsKKwlpZiAocmV0KSB7CiAJCXdmeF90eF91bmxvY2sod3Zp
Zi0+d2Rldik7Ci0JCXJldHVybiB0aW1lb3V0OworCQlyZXR1cm4gLUVJTzsKIAl9CiAJcmV0ID0g
d2FpdF9mb3JfY29tcGxldGlvbl90aW1lb3V0KCZ3dmlmLT5zY2FuX2NvbXBsZXRlLCB0aW1lb3V0
KTsKIAlpZiAocmVxLT5jaGFubmVsc1tzdGFydF9pZHhdLT5tYXhfcG93ZXIgIT0gd3ZpZi0+dmlm
LT5ic3NfY29uZi50eHBvd2VyKQotLSAKMi4yNi4yCgo=
