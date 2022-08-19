Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F5259946F
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346216AbiHSFZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346175AbiHSFZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:25:48 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B1ED8B30;
        Thu, 18 Aug 2022 22:25:47 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id BD1845FD07;
        Fri, 19 Aug 2022 08:25:45 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660886745;
        bh=b45BV2ZXGjDFGbqD7Zc7LoRug2dgFwYM1iZaE+GqaIA=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=QPZYdBOUvRAqMbDWuqeHx/lrMrjg2z4INcZAeWFCIbIXE/qYu8mgVX31NEFrDBTvJ
         bQNuD0/3YHikbUAsFLNpBthnsaahPsnHKOU2h2Ts61jKbTXZyrRUzgebQmCGbVi/jr
         t6cic8pffPOmH025W5cKevRmPwWR6k1g2Z0VouXO6FdjAbjShWNo7VHan1fnttEH3a
         qa6fhP6obfo6ZV76Z56Ch3B5G+0y8gezcDiPADH0f3cWWe+jGvIaa855UdD+u754Jp
         XAjMMkrMIIDX3vNxY5bKpKwO/fG3e0ZlNy2l+abCgdHguT3n4Md+f+2SaMhlDQqm2M
         Ht5FmvFs+qM6w==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri, 19 Aug 2022 08:25:44 +0300 (MSK)
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
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Subject: [PATCH net-next v4 1/9] vsock: SO_RCVLOWAT transport set callback
Thread-Topic: [PATCH net-next v4 1/9] vsock: SO_RCVLOWAT transport set
 callback
Thread-Index: AQHYs4wSVKV9ssq90kaiB/V349f4rA==
Date:   Fri, 19 Aug 2022 05:25:19 +0000
Message-ID: <09389925-8a2f-24c8-6975-f84822b12fe8@sberdevices.ru>
In-Reply-To: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E558B7D73F28949B271809B785A889A@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/19 00:26:00 #20118704
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
YyB8IDIwICsrKysrKysrKysrKysrKysrKysrDQogMiBmaWxlcyBjaGFuZ2VkLCAyMSBpbnNlcnRp
b25zKCspDQoNCmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9hZl92c29jay5oIGIvaW5jbHVkZS9u
ZXQvYWZfdnNvY2suaA0KaW5kZXggMWM1M2M0YzRkODhmLi5kNjA5YTA4OGNiMjcgMTAwNjQ0DQot
LS0gYS9pbmNsdWRlL25ldC9hZl92c29jay5oDQorKysgYi9pbmNsdWRlL25ldC9hZl92c29jay5o
DQpAQCAtMTM1LDYgKzEzNSw3IEBAIHN0cnVjdCB2c29ja190cmFuc3BvcnQgew0KIAl1NjQgKCpz
dHJlYW1fcmN2aGl3YXQpKHN0cnVjdCB2c29ja19zb2NrICopOw0KIAlib29sICgqc3RyZWFtX2lz
X2FjdGl2ZSkoc3RydWN0IHZzb2NrX3NvY2sgKik7DQogCWJvb2wgKCpzdHJlYW1fYWxsb3cpKHUz
MiBjaWQsIHUzMiBwb3J0KTsNCisJaW50ICgqc2V0X3Jjdmxvd2F0KShzdHJ1Y3QgdnNvY2tfc29j
ayAqdnNrLCBpbnQgdmFsKTsNCiANCiAJLyogU0VRX1BBQ0tFVC4gKi8NCiAJc3NpemVfdCAoKnNl
cXBhY2tldF9kZXF1ZXVlKShzdHJ1Y3QgdnNvY2tfc29jayAqdnNrLCBzdHJ1Y3QgbXNnaGRyICpt
c2csDQpkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29jay9hZl92c29jay5jIGIvbmV0L3Ztd192c29j
ay9hZl92c29jay5jDQppbmRleCBmMDRhYmY2NjJlYzYuLjBhNjc3NzUyNmM3MyAxMDA2NDQNCi0t
LSBhL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KKysrIGIvbmV0L3Ztd192c29jay9hZl92c29j
ay5jDQpAQCAtMjEyOSw2ICsyMTI5LDI1IEBAIHZzb2NrX2Nvbm5lY3RpYmxlX3JlY3Ztc2coc3Ry
dWN0IHNvY2tldCAqc29jaywgc3RydWN0IG1zZ2hkciAqbXNnLCBzaXplX3QgbGVuLA0KIAlyZXR1
cm4gZXJyOw0KIH0NCiANCitzdGF0aWMgaW50IHZzb2NrX3NldF9yY3Zsb3dhdChzdHJ1Y3Qgc29j
ayAqc2ssIGludCB2YWwpDQorew0KKwljb25zdCBzdHJ1Y3QgdnNvY2tfdHJhbnNwb3J0ICp0cmFu
c3BvcnQ7DQorCXN0cnVjdCB2c29ja19zb2NrICp2c2s7DQorDQorCXZzayA9IHZzb2NrX3NrKHNr
KTsNCisNCisJaWYgKHZhbCA+IHZzay0+YnVmZmVyX3NpemUpDQorCQlyZXR1cm4gLUVJTlZBTDsN
CisNCisJdHJhbnNwb3J0ID0gdnNrLT50cmFuc3BvcnQ7DQorDQorCWlmICh0cmFuc3BvcnQgJiYg
dHJhbnNwb3J0LT5zZXRfcmN2bG93YXQpDQorCQlyZXR1cm4gdHJhbnNwb3J0LT5zZXRfcmN2bG93
YXQodnNrLCB2YWwpOw0KKw0KKwlXUklURV9PTkNFKHNrLT5za19yY3Zsb3dhdCwgdmFsID8gOiAx
KTsNCisJcmV0dXJuIDA7DQorfQ0KKw0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcHJvdG9fb3BzIHZz
b2NrX3N0cmVhbV9vcHMgPSB7DQogCS5mYW1pbHkgPSBQRl9WU09DSywNCiAJLm93bmVyID0gVEhJ
U19NT0RVTEUsDQpAQCAtMjE0OCw2ICsyMTY3LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBwcm90
b19vcHMgdnNvY2tfc3RyZWFtX29wcyA9IHsNCiAJLnJlY3Ztc2cgPSB2c29ja19jb25uZWN0aWJs
ZV9yZWN2bXNnLA0KIAkubW1hcCA9IHNvY2tfbm9fbW1hcCwNCiAJLnNlbmRwYWdlID0gc29ja19u
b19zZW5kcGFnZSwNCisJLnNldF9yY3Zsb3dhdCA9IHZzb2NrX3NldF9yY3Zsb3dhdCwNCiB9Ow0K
IA0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcHJvdG9fb3BzIHZzb2NrX3NlcXBhY2tldF9vcHMgPSB7
DQotLSANCjIuMjUuMQ0K
