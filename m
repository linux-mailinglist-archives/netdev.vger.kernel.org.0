Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AC7295C6B
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 12:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896318AbgJVKIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 06:08:36 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:53942 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2896274AbgJVKIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 06:08:35 -0400
X-UUID: cb0dbf63645c406b86f8dba0a854628f-20201022
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=cLAlegNOIrwzIY2JgBuXu/SNenTIIhJF/b/jv5R+48w=;
        b=SJV3qyzS79qIEWY2s4RwAPrxHIidzYiCfVenbZOgEHSC/ELw4QXH+95X1EUV3dsYjD/jFb0yVL2KU+aMHkisbRd4TkIJw3l0Tmeirg7PuIu1VRvvwlbVy6U+wtOHOrwLOD80CHAbNQBwXlN676Y2lvGCv1mn4ifr0ROvhg04m6Q=;
X-UUID: cb0dbf63645c406b86f8dba0a854628f-20201022
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <zhuoliang.zhang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2093845838; Thu, 22 Oct 2020 18:08:31 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 22 Oct 2020 18:08:23 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Oct 2020 18:08:22 +0800
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
Subject: [PATCH v2] net: xfrm: fix a race condition during allocing spi
Date:   Thu, 22 Oct 2020 18:01:27 +0800
Message-ID: <20201022100126.19565-1-zhuoliang.zhang@mediatek.com>
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
X2FkZF9oZWFkX3JjdSgmeC0+YnlzcGkpDQoNCjEuIGEgbmV3IHN0YXRlIHggaXMgYWxsb2NlZCBp
biB4ZnJtX3N0YXRlX2FsbG9jKCkgYW5kIGFkZGVkIGludG8gdGhlIGJ5ZHN0IGhsaXN0DQppbiAg
X19maW5kX2FjcV9jb3JlKCkgb24gdGhlIExIUzsNCjIuIG9uIHRoZSBSSFMsIHN0YXRlX2hhc2hf
d29yayB0aHJlYWQgdHJhdmVscyB0aGUgb2xkIGJ5ZHN0IGFuZCB0cmFuZmVycyBldmVyeSB4ZnJt
X3N0YXRlDQooaW5jbHVkZSB4KSBpbnRvIHRoZSBuZXcgYnlkc3QgaGxpc3QgYW5kIG5ldyBieXNw
aSBobGlzdDsNCjMuIHVzZXIgdGhyZWFkIG9uIHRoZSBMSFMgZ2V0cyB0aGUgbG9jayBhbmQgYWRk
cyB4IGludG8gdGhlIG5ldyBieXNwaSBobGlzdCBhZ2Fpbi4NCg0KU28gdGhlIHNhbWUgeGZybV9z
dGF0ZSAoeCkgaXMgYWRkZWQgaW50byB0aGUgc2FtZSBsaXN0X2hhc2gNCihuZXQtPnhmcm0uc3Rh
dGVfYnlzcGkpIDIgdGltZXMgdGhhdCBtYWtlcyB0aGUgbGlzdF9oYXNoIGJlY29tZQ0KYW4gaW5p
Zml0ZSBsb29wLg0KDQpUbyBmaXggdGhlIHJhY2UsIHgtPmlkLnNwaSA9IGh0b25sKHNwaSkgaW4g
dGhlIHhmcm1fYWxsb2Nfc3BpKCkgaXMgbW92ZWQNCnRvIHRoZSBiYWNrIG9mIHNwaW5fbG9ja19i
aCwgc290aGF0IHN0YXRlX2hhc2hfd29yayB0aHJlYWQgbm8gbG9uZ2VyIGFkZCB4DQp3aGljaCBp
ZC5zcGkgaXMgemVybyBpbnRvIHRoZSBoYXNoX2xpc3QuDQoNCkZpeGVzOiBmMDM0YjVkNGVmZGYg
KCJbWEZSTV06IER5bmFtaWMgeGZybV9zdGF0ZSBoYXNoIHRhYmxlIHNpemluZy4iKQ0KU2lnbmVk
LW9mZi1ieTogemh1b2xpYW5nIHpoYW5nIDx6aHVvbGlhbmcuemhhbmdAbWVkaWF0ZWsuY29tPg0K
LS0tDQogbmV0L3hmcm0veGZybV9zdGF0ZS5jIHwgOCArKysrKy0tLQ0KIDEgZmlsZSBjaGFuZ2Vk
LCA1IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9uZXQveGZy
bS94ZnJtX3N0YXRlLmMgYi9uZXQveGZybS94ZnJtX3N0YXRlLmMNCmluZGV4IGJiZDQ2NDNkN2U4
Mi4uYTc3ZGE3YWFlNmZlIDEwMDY0NA0KLS0tIGEvbmV0L3hmcm0veGZybV9zdGF0ZS5jDQorKysg
Yi9uZXQveGZybS94ZnJtX3N0YXRlLmMNCkBAIC0yMDA0LDYgKzIwMDQsNyBAQCBpbnQgeGZybV9h
bGxvY19zcGkoc3RydWN0IHhmcm1fc3RhdGUgKngsIHUzMiBsb3csIHUzMiBoaWdoKQ0KIAlpbnQg
ZXJyID0gLUVOT0VOVDsNCiAJX19iZTMyIG1pbnNwaSA9IGh0b25sKGxvdyk7DQogCV9fYmUzMiBt
YXhzcGkgPSBodG9ubChoaWdoKTsNCisJX19iZTMyIG5ld3NwaSA9IDA7DQogCXUzMiBtYXJrID0g
eC0+bWFyay52ICYgeC0+bWFyay5tOw0KIA0KIAlzcGluX2xvY2tfYmgoJngtPmxvY2spOw0KQEAg
LTIwMjIsMjEgKzIwMjMsMjIgQEAgaW50IHhmcm1fYWxsb2Nfc3BpKHN0cnVjdCB4ZnJtX3N0YXRl
ICp4LCB1MzIgbG93LCB1MzIgaGlnaCkNCiAJCQl4ZnJtX3N0YXRlX3B1dCh4MCk7DQogCQkJZ290
byB1bmxvY2s7DQogCQl9DQotCQl4LT5pZC5zcGkgPSBtaW5zcGk7DQorCQluZXdzcGkgPSBtaW5z
cGk7DQogCX0gZWxzZSB7DQogCQl1MzIgc3BpID0gMDsNCiAJCWZvciAoaCA9IDA7IGggPCBoaWdo
LWxvdysxOyBoKyspIHsNCiAJCQlzcGkgPSBsb3cgKyBwcmFuZG9tX3UzMigpJShoaWdoLWxvdysx
KTsNCiAJCQl4MCA9IHhmcm1fc3RhdGVfbG9va3VwKG5ldCwgbWFyaywgJngtPmlkLmRhZGRyLCBo
dG9ubChzcGkpLCB4LT5pZC5wcm90bywgeC0+cHJvcHMuZmFtaWx5KTsNCiAJCQlpZiAoeDAgPT0g
TlVMTCkgew0KLQkJCQl4LT5pZC5zcGkgPSBodG9ubChzcGkpOw0KKwkJCQluZXdzcGkgPSBodG9u
bChzcGkpOw0KIAkJCQlicmVhazsNCiAJCQl9DQogCQkJeGZybV9zdGF0ZV9wdXQoeDApOw0KIAkJ
fQ0KIAl9DQotCWlmICh4LT5pZC5zcGkpIHsNCisJaWYgKG5ld3NwaSkgew0KIAkJc3Bpbl9sb2Nr
X2JoKCZuZXQtPnhmcm0ueGZybV9zdGF0ZV9sb2NrKTsNCisJCXgtPmlkLnNwaSA9IG5ld3NwaTsN
CiAJCWggPSB4ZnJtX3NwaV9oYXNoKG5ldCwgJngtPmlkLmRhZGRyLCB4LT5pZC5zcGksIHgtPmlk
LnByb3RvLCB4LT5wcm9wcy5mYW1pbHkpOw0KIAkJaGxpc3RfYWRkX2hlYWRfcmN1KCZ4LT5ieXNw
aSwgbmV0LT54ZnJtLnN0YXRlX2J5c3BpICsgaCk7DQogCQlzcGluX3VubG9ja19iaCgmbmV0LT54
ZnJtLnhmcm1fc3RhdGVfbG9jayk7DQotLSANCjIuMTguMA0K

