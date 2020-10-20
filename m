Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFB62936C3
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 10:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388722AbgJTIYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 04:24:50 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:57487 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727227AbgJTIYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 04:24:42 -0400
X-UUID: 3d94010fe3b8456ea1e40812cad3ca8d-20201020
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=oh69URcuh4hkm/jR6bFeN4nQ+LubGPhNV5qVza78Wls=;
        b=tB3zZjImTLMUHSUQsOAPJLLVLhQP5qYzrW5vmXkaNPuC+kr5/j6Uf2CkOQSrE/OvoT5JINRzLuJhXH2Jd8p174Oek22F5JR5XbnqGtKx+P2l+aR1K4KOlo1Mig1QGJ1SLicmXcMK4I6bR+PZ1sJBx6pakiC9pkQph00yWaf/BYM=;
X-UUID: 3d94010fe3b8456ea1e40812cad3ca8d-20201020
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <zhuoliang.zhang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 489266037; Tue, 20 Oct 2020 16:24:38 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 20 Oct 2020 16:24:30 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Oct 2020 16:24:30 +0800
From:   Zhuoliang Zhang <zhuoliang.zhang@mediatek.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        zhuoliang zhang <zhuoliang.zhang@mediatek.com>
Subject: [PATCH] net: xfrm: fix a race condition during allocing spi
Date:   Tue, 20 Oct 2020 16:18:00 +0800
Message-ID: <20201020081800.29454-1-zhuoliang.zhang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogemh1b2xpYW5nIHpoYW5nIDx6aHVvbGlhbmcuemhhbmdAbWVkaWF0ZWsuY29tPg0KDQp3
ZSBmb3VuZCB0aGF0IHRoZSBmb2xsb3dpbmcgcmFjZSBjb25kaXRpb24gZXhpc3RzIGluDQp4ZnJt
X2FsbG9jX3VzZXJzcGkgZmxvdzoNCg0KdXNlciB0aHJlYWQgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBzdGF0ZV9oYXNoX3dvcmsgdGhyZWFkDQotLS0tICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIC0tLS0NCnhmcm1fYWxsb2NfdXNlcnNwaSgpDQog
X19maW5kX2FjcV9jb3JlKCkNCiAgIC8qYWxsb2MgbmV3IHhmcm1fc3RhdGU6eCovDQogICB4ZnJt
X3N0YXRlX2FsbG9jKCkNCiAgIC8qc2NoZWR1bGUgc3RhdGVfaGFzaF93b3JrIHRocmVhZCovDQog
ICB4ZnJtX2hhc2hfZ3Jvd19jaGVjaygpICAgCSAgICAgICAgICAgICAgIHhmcm1faGFzaF9yZXNp
emUoKQ0KIHhmcm1fYWxsb2Nfc3BpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8q
aG9sZCBsb2NrKi8NCiAgICAgIHgtPmlkLnNwaSA9IGh0b25sKHNwaSkgICAgICAgICAgICAgICAg
ICAgICBzcGluX2xvY2tfYmgoJm5ldC0+eGZybS54ZnJtX3N0YXRlX2xvY2spDQogICAgICAvKndh
aXRpbmcgbG9jayByZWxlYXNlKi8gICAgICAgICAgICAgICAgICAgICB4ZnJtX2hhc2hfdHJhbnNm
ZXIoKQ0KICAgICAgc3Bpbl9sb2NrX2JoKCZuZXQtPnhmcm0ueGZybV9zdGF0ZV9sb2NrKSAgICAg
IC8qYWRkIHggaW50byBobGlzdDpuZXQtPnhmcm0uc3RhdGVfYnlzcGkqLw0KCSAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGhsaXN0X2FkZF9oZWFkX3JjdSgm
eC0+YnlzcGkpDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgc3Bpbl91bmxvY2tfYmgoJm5ldC0+eGZybS54ZnJtX3N0YXRlX2xvY2spDQoNCiAgICAvKmFk
ZCB4IGludG8gaGxpc3Q6bmV0LT54ZnJtLnN0YXRlX2J5c3BpIDIgdGltZXMqLw0KICAgIGhsaXN0
X2FkZF9oZWFkX3JjdSgmeC0+YnlzcGkpDQoNClNvIHRoZSBzYW1lIHhmcm1fc3RhbWUgKHgpIGlz
IGFkZGVkIGludG8gdGhlIHNhbWUgbGlzdF9oYXNoDQoobmV0LT54ZnJtLnN0YXRlX2J5c3BpKTIg
dGltZXMgdGhhdCBtYWtlcyB0aGUgbGlzdF9oYXNoIGJlY29tZQ0KYSBpbmlmaXRlIGxvb3AuDQoN
ClRvIGZpeCB0aGUgcmFjZSx4LT5pZC5zcGkgPSBodG9ubChzcGkpIGluIHRoZSB4ZnJtX2FsbG9j
X3NwaSgpIA0KaXMgbW92ZWQgdG8gdGhlIGJhY2sgb2Ygc3Bpbl9sb2NrX2JoLHNvdGhhdCBzdGF0
ZV9oYXNoX3dvcmsgdGhyZWFkIA0Kbm8gbG9uZ2VyIGFkZCB4IHdoaWNoIGlkLnNwaSBpcyB6ZXJv
IGludG8gdGhlIGhhc2hfbGlzdC4NCg0KU2lnbmVkLW9mZi1ieTogemh1b2xpYW5nIHpoYW5nIDx6
aHVvbGlhbmcuemhhbmdAbWVkaWF0ZWsuY29tPg0KLS0tDQogbmV0L3hmcm0veGZybV9zdGF0ZS5j
IHwgOCArKysrKy0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDMgZGVsZXRp
b25zKC0pDQoNCmRpZmYgLS1naXQgYS9uZXQveGZybS94ZnJtX3N0YXRlLmMgYi9uZXQveGZybS94
ZnJtX3N0YXRlLmMNCmluZGV4IGJiZDQ2NDNkN2U4Mi4uYTc3ZGE3YWFlNmZlIDEwMDY0NA0KLS0t
IGEvbmV0L3hmcm0veGZybV9zdGF0ZS5jDQorKysgYi9uZXQveGZybS94ZnJtX3N0YXRlLmMNCkBA
IC0yMDA0LDYgKzIwMDQsNyBAQCBpbnQgeGZybV9hbGxvY19zcGkoc3RydWN0IHhmcm1fc3RhdGUg
KngsIHUzMiBsb3csIHUzMiBoaWdoKQ0KIAlpbnQgZXJyID0gLUVOT0VOVDsNCiAJX19iZTMyIG1p
bnNwaSA9IGh0b25sKGxvdyk7DQogCV9fYmUzMiBtYXhzcGkgPSBodG9ubChoaWdoKTsNCisJX19i
ZTMyIG5ld3NwaSA9IDA7DQogCXUzMiBtYXJrID0geC0+bWFyay52ICYgeC0+bWFyay5tOw0KIA0K
IAlzcGluX2xvY2tfYmgoJngtPmxvY2spOw0KQEAgLTIwMjIsMjEgKzIwMjMsMjIgQEAgaW50IHhm
cm1fYWxsb2Nfc3BpKHN0cnVjdCB4ZnJtX3N0YXRlICp4LCB1MzIgbG93LCB1MzIgaGlnaCkNCiAJ
CQl4ZnJtX3N0YXRlX3B1dCh4MCk7DQogCQkJZ290byB1bmxvY2s7DQogCQl9DQotCQl4LT5pZC5z
cGkgPSBtaW5zcGk7DQorCQluZXdzcGkgPSBtaW5zcGk7DQogCX0gZWxzZSB7DQogCQl1MzIgc3Bp
ID0gMDsNCiAJCWZvciAoaCA9IDA7IGggPCBoaWdoLWxvdysxOyBoKyspIHsNCiAJCQlzcGkgPSBs
b3cgKyBwcmFuZG9tX3UzMigpJShoaWdoLWxvdysxKTsNCiAJCQl4MCA9IHhmcm1fc3RhdGVfbG9v
a3VwKG5ldCwgbWFyaywgJngtPmlkLmRhZGRyLCBodG9ubChzcGkpLCB4LT5pZC5wcm90bywgeC0+
cHJvcHMuZmFtaWx5KTsNCiAJCQlpZiAoeDAgPT0gTlVMTCkgew0KLQkJCQl4LT5pZC5zcGkgPSBo
dG9ubChzcGkpOw0KKwkJCQluZXdzcGkgPSBodG9ubChzcGkpOw0KIAkJCQlicmVhazsNCiAJCQl9
DQogCQkJeGZybV9zdGF0ZV9wdXQoeDApOw0KIAkJfQ0KIAl9DQotCWlmICh4LT5pZC5zcGkpIHsN
CisJaWYgKG5ld3NwaSkgew0KIAkJc3Bpbl9sb2NrX2JoKCZuZXQtPnhmcm0ueGZybV9zdGF0ZV9s
b2NrKTsNCisJCXgtPmlkLnNwaSA9IG5ld3NwaTsNCiAJCWggPSB4ZnJtX3NwaV9oYXNoKG5ldCwg
JngtPmlkLmRhZGRyLCB4LT5pZC5zcGksIHgtPmlkLnByb3RvLCB4LT5wcm9wcy5mYW1pbHkpOw0K
IAkJaGxpc3RfYWRkX2hlYWRfcmN1KCZ4LT5ieXNwaSwgbmV0LT54ZnJtLnN0YXRlX2J5c3BpICsg
aCk7DQogCQlzcGluX3VubG9ja19iaCgmbmV0LT54ZnJtLnhmcm1fc3RhdGVfbG9jayk7DQotLSAN
CjIuMTguMA0K

