Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D435588DEF
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 15:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238313AbiHCNx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 09:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbiHCNxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 09:53:42 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF8D5A3F5;
        Wed,  3 Aug 2022 06:51:21 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 4F5245FD33;
        Wed,  3 Aug 2022 16:51:19 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1659534679;
        bh=oL/a8p5fs2n9bkXhDVSnT2JUO1csl3dAvz9ROIfjeX4=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=jeNuV41aXsHCJsi0MYkqCkOCaEsWKiWZ4QsgaoEuftdutAVNol3H5TbirO7wWYvqo
         p6/H/BViiGVKgaMrRq024eBHsMs5dEqTn6T+ojTe2oHoIZFV0GkP5mtcZvhUFqPtbn
         urKhJgu+lWeKSE78+fIZFl6QGnz7cbNruYnDkqX7bxwxttse0mXAGYd6lm+p/3Mobc
         PuRS5+gYiGtXgacxvjVUK1GCt2Wv8urpqB4v+O88ywipW+V9euhO/3pT/40Kvod7q0
         BRuXTVuZtNZ+At1WUwv4e2lo51XZMlriigoUIhOZn+hISARpr3aR9snrSYbcFLbgY/
         wThxKG1Dvazag==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed,  3 Aug 2022 16:51:18 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Arseniy Krasnov" <AVKrasnov@sberdevices.ru>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 1/9] vsock: SO_RCVLOWAT transport set callback
Thread-Topic: [RFC PATCH v3 1/9] vsock: SO_RCVLOWAT transport set callback
Thread-Index: AQHYp0ATlQNqO/GwP0WKlu98/YZplA==
Date:   Wed, 3 Aug 2022 13:51:05 +0000
Message-ID: <45822644-8e37-1625-5944-63fd5fc20dd3@sberdevices.ru>
In-Reply-To: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1B9FCF9D579F840B872C9ED402F8F8B@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/03 07:41:00 #20041172
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIHRyYW5zcG9ydCBzcGVjaWZpYyBjYWxsYmFjayBmb3IgU09fUkNWTE9XQVQsIGJl
Y2F1c2UgaW4gc29tZQ0KdHJhbnNwb3J0cyBpdCBtYXkgYmUgZGlmZmljdWx0IHRvIGtub3cgY3Vy
cmVudCBhdmFpbGFibGUgbnVtYmVyIG9mIGJ5dGVzDQpyZWFkeSB0byByZWFkLiBUaHVzLCB3aGVu
IFNPX1JDVkxPV0FUIGlzIHNldCwgdHJhbnNwb3J0IG1heSByZWplY3QgaXQuDQoNClNpZ25lZC1v
ZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KLS0tDQog
aW5jbHVkZS9uZXQvYWZfdnNvY2suaCAgIHwgIDEgKw0KIG5ldC92bXdfdnNvY2svYWZfdnNvY2su
YyB8IDI1ICsrKysrKysrKysrKysrKysrKysrKysrKysNCiAyIGZpbGVzIGNoYW5nZWQsIDI2IGlu
c2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2FmX3Zzb2NrLmggYi9pbmNs
dWRlL25ldC9hZl92c29jay5oDQppbmRleCBmNzQyZTUwMjA3ZmIuLmVhZTU4NzRiYWUzNSAxMDA2
NDQNCi0tLSBhL2luY2x1ZGUvbmV0L2FmX3Zzb2NrLmgNCisrKyBiL2luY2x1ZGUvbmV0L2FmX3Zz
b2NrLmgNCkBAIC0xMzQsNiArMTM0LDcgQEAgc3RydWN0IHZzb2NrX3RyYW5zcG9ydCB7DQogCXU2
NCAoKnN0cmVhbV9yY3ZoaXdhdCkoc3RydWN0IHZzb2NrX3NvY2sgKik7DQogCWJvb2wgKCpzdHJl
YW1faXNfYWN0aXZlKShzdHJ1Y3QgdnNvY2tfc29jayAqKTsNCiAJYm9vbCAoKnN0cmVhbV9hbGxv
dykodTMyIGNpZCwgdTMyIHBvcnQpOw0KKwlpbnQgKCpzZXRfcmN2bG93YXQpKHN0cnVjdCB2c29j
a19zb2NrICosIGludCk7DQogDQogCS8qIFNFUV9QQUNLRVQuICovDQogCXNzaXplX3QgKCpzZXFw
YWNrZXRfZGVxdWV1ZSkoc3RydWN0IHZzb2NrX3NvY2sgKnZzaywgc3RydWN0IG1zZ2hkciAqbXNn
LA0KZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svYWZfdnNvY2suYyBiL25ldC92bXdfdnNvY2sv
YWZfdnNvY2suYw0KaW5kZXggZjA0YWJmNjYyZWM2Li4wMTZhZDVmZjc4YjcgMTAwNjQ0DQotLS0g
YS9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCisrKyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2su
Yw0KQEAgLTIxMjksNiArMjEyOSwzMCBAQCB2c29ja19jb25uZWN0aWJsZV9yZWN2bXNnKHN0cnVj
dCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBtc2doZHIgKm1zZywgc2l6ZV90IGxlbiwNCiAJcmV0dXJu
IGVycjsNCiB9DQogDQorc3RhdGljIGludCB2c29ja19zZXRfcmN2bG93YXQoc3RydWN0IHNvY2sg
KnNrLCBpbnQgdmFsKQ0KK3sNCisJY29uc3Qgc3RydWN0IHZzb2NrX3RyYW5zcG9ydCAqdHJhbnNw
b3J0Ow0KKwlzdHJ1Y3QgdnNvY2tfc29jayAqdnNrOw0KKwlpbnQgZXJyID0gMDsNCisNCisJdnNr
ID0gdnNvY2tfc2soc2spOw0KKw0KKwlpZiAodmFsID4gdnNrLT5idWZmZXJfc2l6ZSkNCisJCXJl
dHVybiAtRUlOVkFMOw0KKw0KKwl0cmFuc3BvcnQgPSB2c2stPnRyYW5zcG9ydDsNCisNCisJaWYg
KCF0cmFuc3BvcnQpDQorCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQorDQorCWlmICh0cmFuc3BvcnQt
PnNldF9yY3Zsb3dhdCkNCisJCWVyciA9IHRyYW5zcG9ydC0+c2V0X3Jjdmxvd2F0KHZzaywgdmFs
KTsNCisJZWxzZQ0KKwkJV1JJVEVfT05DRShzay0+c2tfcmN2bG93YXQsIHZhbCA/IDogMSk7DQor
DQorCXJldHVybiBlcnI7DQorfQ0KKw0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcHJvdG9fb3BzIHZz
b2NrX3N0cmVhbV9vcHMgPSB7DQogCS5mYW1pbHkgPSBQRl9WU09DSywNCiAJLm93bmVyID0gVEhJ
U19NT0RVTEUsDQpAQCAtMjE0OCw2ICsyMTcyLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBwcm90
b19vcHMgdnNvY2tfc3RyZWFtX29wcyA9IHsNCiAJLnJlY3Ztc2cgPSB2c29ja19jb25uZWN0aWJs
ZV9yZWN2bXNnLA0KIAkubW1hcCA9IHNvY2tfbm9fbW1hcCwNCiAJLnNlbmRwYWdlID0gc29ja19u
b19zZW5kcGFnZSwNCisJLnNldF9yY3Zsb3dhdCA9IHZzb2NrX3NldF9yY3Zsb3dhdCwNCiB9Ow0K
IA0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcHJvdG9fb3BzIHZzb2NrX3NlcXBhY2tldF9vcHMgPSB7
DQotLSANCjIuMjUuMQ0K
