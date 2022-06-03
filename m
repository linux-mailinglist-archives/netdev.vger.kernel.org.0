Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C8753C4A0
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 07:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241215AbiFCFlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 01:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbiFCFli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 01:41:38 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B04736E00;
        Thu,  2 Jun 2022 22:41:36 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 540745FD02;
        Fri,  3 Jun 2022 08:41:34 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1654234894;
        bh=7SQwZfSXoKBQPVHv3x8ggArLeuvotFhF1XdrXYyomo8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=pfpY1GpGZpjUI7/Yy8OekTKh7rv7qGUQ1Us2G65PTuuCs1MeULhER0U/782zFvMxw
         445IvEgRuuvR9yqHkkc7NE0MM4s9oUVMfqOvfGyxpN8OiRxtG7zcWYYwWSEYwSEYRj
         OPinC+ZJCuifVAa4b+cAbB8fGUPgoP/udhhK3VQtimAZaQppi4smDZk+chbnyQs6Ud
         N7mcZSi0KGgtG6EC7lqt6D71VxGylOJTmKthe2TvwR+0UAyRR0ETxf9Ls/bANUitut
         l8Go0XPzeHedM2n6H65Nw9EdtXg6ooNRr0FgI5alCdYL+uVivhEXuPzZhnGwehrPX+
         kDRr/2lMOtL5g==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri,  3 Jun 2022 08:41:34 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 6/8] virtio/vsock: enable zerocopy callback
Thread-Topic: [RFC PATCH v2 6/8] virtio/vsock: enable zerocopy callback
Thread-Index: AQHYdwyFKI2EahWo0ki3hG6/uJhhrg==
Date:   Fri, 3 Jun 2022 05:41:07 +0000
Message-ID: <f969f5e1-ac1a-dbef-5838-9b197934a04d@sberdevices.ru>
In-Reply-To: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3757CE19789524CB7D366A289981A8D@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/06/03 01:19:00 #19656765
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIHplcm9jb3B5IGNhbGxiYWNrIGZvciB2aXJ0aW8gdHJhbnNwb3J0Lg0KDQpTaWdu
ZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0t
LQ0KIG5ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jIHwgNDMgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgNDMgaW5zZXJ0aW9ucygrKQ0KDQpk
aWZmIC0tZ2l0IGEvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0LmMgYi9uZXQvdm13X3Zz
b2NrL3ZpcnRpb190cmFuc3BvcnQuYw0KaW5kZXggMTk5MDljMWU5YmEzLi4yZTA1YjAxY2FhOTQg
MTAwNjQ0DQotLS0gYS9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnQuYw0KKysrIGIvbmV0
L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0LmMNCkBAIC02NCw2ICs2NCw3IEBAIHN0cnVjdCB2
aXJ0aW9fdnNvY2sgew0KIA0KIAl1MzIgZ3Vlc3RfY2lkOw0KIAlib29sIHNlcXBhY2tldF9hbGxv
dzsNCisJYm9vbCB6ZXJvY29weV9yeF9vbjsNCiB9Ow0KIA0KIHN0YXRpYyB1MzIgdmlydGlvX3Ry
YW5zcG9ydF9nZXRfbG9jYWxfY2lkKHZvaWQpDQpAQCAtNDU1LDYgKzQ1Niw0NSBAQCBzdGF0aWMg
dm9pZCB2aXJ0aW9fdnNvY2tfcnhfZG9uZShzdHJ1Y3QgdmlydHF1ZXVlICp2cSkNCiANCiBzdGF0
aWMgYm9vbCB2aXJ0aW9fdHJhbnNwb3J0X3NlcXBhY2tldF9hbGxvdyh1MzIgcmVtb3RlX2NpZCk7
DQogDQorc3RhdGljIGludA0KK3ZpcnRpb190cmFuc3BvcnRfemVyb2NvcHlfc2V0KHN0cnVjdCB2
c29ja19zb2NrICp2c2ssIGJvb2wgZW5hYmxlKQ0KK3sNCisJc3RydWN0IHZpcnRpb192c29jayAq
dnNvY2s7DQorDQorCXJjdV9yZWFkX2xvY2soKTsNCisJdnNvY2sgPSByY3VfZGVyZWZlcmVuY2Uo
dGhlX3ZpcnRpb192c29jayk7DQorDQorCWlmICghdnNvY2spIHsNCisJCXJjdV9yZWFkX3VubG9j
aygpOw0KKwkJcmV0dXJuIC1FTk9ERVY7DQorCX0NCisNCisJdnNvY2stPnplcm9jb3B5X3J4X29u
ID0gZW5hYmxlOw0KKwlyY3VfcmVhZF91bmxvY2soKTsNCisNCisJcmV0dXJuIDA7DQorfQ0KKw0K
K3N0YXRpYyBpbnQNCit2aXJ0aW9fdHJhbnNwb3J0X3plcm9jb3B5X2dldChzdHJ1Y3QgdnNvY2tf
c29jayAqdnNrKQ0KK3sNCisJc3RydWN0IHZpcnRpb192c29jayAqdnNvY2s7DQorCWJvb2wgcmVz
Ow0KKw0KKwlyY3VfcmVhZF9sb2NrKCk7DQorCXZzb2NrID0gcmN1X2RlcmVmZXJlbmNlKHRoZV92
aXJ0aW9fdnNvY2spOw0KKw0KKwlpZiAoIXZzb2NrKSB7DQorCQlyY3VfcmVhZF91bmxvY2soKTsN
CisJCXJldHVybiAtRU5PREVWOw0KKwl9DQorDQorCXJlcyA9IHZzb2NrLT56ZXJvY29weV9yeF9v
bjsNCisJcmN1X3JlYWRfdW5sb2NrKCk7DQorDQorCXJldHVybiByZXM7DQorfQ0KKw0KIHN0YXRp
YyBzdHJ1Y3QgdmlydGlvX3RyYW5zcG9ydCB2aXJ0aW9fdHJhbnNwb3J0ID0gew0KIAkudHJhbnNw
b3J0ID0gew0KIAkJLm1vZHVsZSAgICAgICAgICAgICAgICAgICA9IFRISVNfTU9EVUxFLA0KQEAg
LTQ4MCw2ICs1MjAsOSBAQCBzdGF0aWMgc3RydWN0IHZpcnRpb190cmFuc3BvcnQgdmlydGlvX3Ry
YW5zcG9ydCA9IHsNCiAJCS5zdHJlYW1fcmN2aGl3YXQgICAgICAgICAgPSB2aXJ0aW9fdHJhbnNw
b3J0X3N0cmVhbV9yY3ZoaXdhdCwNCiAJCS5zdHJlYW1faXNfYWN0aXZlICAgICAgICAgPSB2aXJ0
aW9fdHJhbnNwb3J0X3N0cmVhbV9pc19hY3RpdmUsDQogCQkuc3RyZWFtX2FsbG93ICAgICAgICAg
ICAgID0gdmlydGlvX3RyYW5zcG9ydF9zdHJlYW1fYWxsb3csDQorCQkuemVyb2NvcHlfZGVxdWV1
ZSAgICAgICAgID0gdmlydGlvX3RyYW5zcG9ydF96ZXJvY29weV9kZXF1ZXVlLA0KKwkJLnJ4X3pl
cm9jb3B5X3NldAkgID0gdmlydGlvX3RyYW5zcG9ydF96ZXJvY29weV9zZXQsDQorCQkucnhfemVy
b2NvcHlfZ2V0CSAgPSB2aXJ0aW9fdHJhbnNwb3J0X3plcm9jb3B5X2dldCwNCiANCiAJCS5zZXFw
YWNrZXRfZGVxdWV1ZSAgICAgICAgPSB2aXJ0aW9fdHJhbnNwb3J0X3NlcXBhY2tldF9kZXF1ZXVl
LA0KIAkJLnNlcXBhY2tldF9lbnF1ZXVlICAgICAgICA9IHZpcnRpb190cmFuc3BvcnRfc2VxcGFj
a2V0X2VucXVldWUsDQotLSANCjIuMjUuMQ0K
