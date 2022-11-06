Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745D161E596
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiKFTih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiKFTig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:38:36 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5F52DC0;
        Sun,  6 Nov 2022 11:38:34 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 2A8055FD04;
        Sun,  6 Nov 2022 22:38:33 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1667763513;
        bh=EEoKcv2eN2h4TIogPlImzmkvyAMOSyDfOwiRdxm5/Uc=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=a5pOFkdns/nGHJF2r6nW/22qh5m7oJXUahsvuEBQLu/LxnAIvk1vOItoJewBTKi+M
         tMAr4D7LOi1HkHOR81DTcrw0U4KexZtPgLBlmM+V1VJj9ZmoFL78xFDQcRKSBQiiMH
         hGbm53187KsXpDmUsh9JXd9Cx1kZc84y+lXtGjhzlqiM3VLdxnwZIqXt3YR3C8g4Bu
         HIWDpl75SJ2tN7KJICVcy37rvNnFLNj/EubHp+TQrvME5ZzwvCdp/nLJ1Dp8a1trWt
         Rd4uIl4wQJVaCJjtOqFVkQ4YXeBLfrjxsK/mW0x3TmhsOXKNRYRnzCOtxVKN2gKh4H
         qtsK72AbxY27w==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  6 Nov 2022 22:38:32 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 02/11] virtio/vsock: update,
 'virtio_transport_recv_pkt()'
Thread-Topic: [RFC PATCH v3 02/11] virtio/vsock: update,
 'virtio_transport_recv_pkt()'
Thread-Index: AQHY8hdI/Cz9wqLJ60mqLRsUlqPepQ==
Date:   Sun, 6 Nov 2022 19:38:01 +0000
Message-ID: <fa130a10-9015-5648-02c8-d921fb3490e0@sberdevices.ru>
In-Reply-To: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <271160C92372DC4C8A0D7E0DB977117E@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/06 12:52:00 #20573807
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGFzcyBkZXN0aW5hdGlvbiBzb2NrZXQgdG8gJ3ZpcnRpb190cmFuc3BvcnRfcmVjdl9wa3QoKScu
IFRoaXMgaXMNCm5lZWRlZCwgYmVjYXVzZSBjYWxsZXIgbWF5IG5lZWQgc29ja2V0IHN0cnVjdHVy
ZSwgdGh1cyB0byBhdm9pZA0Kc29ja2V0IGV4dHJhIGxvb2t1cCBpbiBjb25uZWN0L2JpbmQgbGlz
dHMsIHNvY2tldCBpcyBwYXNzZWQgYXMNCnBhcmFtZXRlcihpZiBpdCBpcyBOVUxMLCB0aGVuIGxv
b2t1cCBpcyBwZXJmb3JtZWQgaW4gdGhlIHNhbWUgd2F5IGFzDQpiZWZvcmUpLg0KDQpTaWduZWQt
b2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0tLQ0K
IGRyaXZlcnMvdmhvc3QvdnNvY2suYyAgICAgICAgICAgICAgICAgICB8ICAyICstDQogaW5jbHVk
ZS9saW51eC92aXJ0aW9fdnNvY2suaCAgICAgICAgICAgIHwgIDEgKw0KIG5ldC92bXdfdnNvY2sv
dmlydGlvX3RyYW5zcG9ydC5jICAgICAgICB8ICAyICstDQogbmV0L3Ztd192c29jay92aXJ0aW9f
dHJhbnNwb3J0X2NvbW1vbi5jIHwgMTIgKysrKysrKy0tLS0tDQogbmV0L3Ztd192c29jay92c29j
a19sb29wYmFjay5jICAgICAgICAgIHwgIDIgKy0NCiA1IGZpbGVzIGNoYW5nZWQsIDExIGluc2Vy
dGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Zob3N0L3Zz
b2NrLmMgYi9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMNCmluZGV4IDY1NDc1ZDEyOGExZC4uNmYzZDlm
MDJjYzFkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy92aG9zdC92c29jay5jDQorKysgYi9kcml2ZXJz
L3Zob3N0L3Zzb2NrLmMNCkBAIC01NDgsNyArNTQ4LDcgQEAgc3RhdGljIHZvaWQgdmhvc3RfdnNv
Y2tfaGFuZGxlX3R4X2tpY2soc3RydWN0IHZob3N0X3dvcmsgKndvcmspDQogCQlpZiAobGU2NF90
b19jcHUocGt0LT5oZHIuc3JjX2NpZCkgPT0gdnNvY2stPmd1ZXN0X2NpZCAmJg0KIAkJICAgIGxl
NjRfdG9fY3B1KHBrdC0+aGRyLmRzdF9jaWQpID09DQogCQkgICAgdmhvc3RfdHJhbnNwb3J0X2dl
dF9sb2NhbF9jaWQoKSkNCi0JCQl2aXJ0aW9fdHJhbnNwb3J0X3JlY3ZfcGt0KCZ2aG9zdF90cmFu
c3BvcnQsIHBrdCk7DQorCQkJdmlydGlvX3RyYW5zcG9ydF9yZWN2X3BrdCgmdmhvc3RfdHJhbnNw
b3J0LCBOVUxMLCBwa3QpOw0KIAkJZWxzZQ0KIAkJCXZpcnRpb190cmFuc3BvcnRfZnJlZV9wa3Qo
cGt0KTsNCiANCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3ZpcnRpb192c29jay5oIGIvaW5j
bHVkZS9saW51eC92aXJ0aW9fdnNvY2suaA0KaW5kZXggZDAyY2I3YWE5MjJmLi5jMWJlNDBmODlh
ODkgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3ZpcnRpb192c29jay5oDQorKysgYi9pbmNs
dWRlL2xpbnV4L3ZpcnRpb192c29jay5oDQpAQCAtMTUwLDYgKzE1MCw3IEBAIHZpcnRpb190cmFu
c3BvcnRfZGdyYW1fZW5xdWV1ZShzdHJ1Y3QgdnNvY2tfc29jayAqdnNrLA0KIHZvaWQgdmlydGlv
X3RyYW5zcG9ydF9kZXN0cnVjdChzdHJ1Y3QgdnNvY2tfc29jayAqdnNrKTsNCiANCiB2b2lkIHZp
cnRpb190cmFuc3BvcnRfcmVjdl9wa3Qoc3RydWN0IHZpcnRpb190cmFuc3BvcnQgKnQsDQorCQkJ
ICAgICAgIHN0cnVjdCBzb2NrICpzaywNCiAJCQkgICAgICAgc3RydWN0IHZpcnRpb192c29ja19w
a3QgKnBrdCk7DQogdm9pZCB2aXJ0aW9fdHJhbnNwb3J0X2ZyZWVfcGt0KHN0cnVjdCB2aXJ0aW9f
dnNvY2tfcGt0ICpwa3QpOw0KIHZvaWQgdmlydGlvX3RyYW5zcG9ydF9pbmNfdHhfcGt0KHN0cnVj
dCB2aXJ0aW9fdnNvY2tfc29jayAqdnZzLCBzdHJ1Y3QgdmlydGlvX3Zzb2NrX3BrdCAqcGt0KTsN
CmRpZmYgLS1naXQgYS9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnQuYyBiL25ldC92bXdf
dnNvY2svdmlydGlvX3RyYW5zcG9ydC5jDQppbmRleCAxOTkwOWMxZTliYTMuLjAzMDVmOTRjOThi
YiAxMDA2NDQNCi0tLSBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jDQorKysgYi9u
ZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnQuYw0KQEAgLTU2MCw3ICs1NjAsNyBAQCBzdGF0
aWMgdm9pZCB2aXJ0aW9fdHJhbnNwb3J0X3J4X3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3Jr
KQ0KIA0KIAkJCXBrdC0+bGVuID0gbGVuIC0gc2l6ZW9mKHBrdC0+aGRyKTsNCiAJCQl2aXJ0aW9f
dHJhbnNwb3J0X2RlbGl2ZXJfdGFwX3BrdChwa3QpOw0KLQkJCXZpcnRpb190cmFuc3BvcnRfcmVj
dl9wa3QoJnZpcnRpb190cmFuc3BvcnQsIHBrdCk7DQorCQkJdmlydGlvX3RyYW5zcG9ydF9yZWN2
X3BrdCgmdmlydGlvX3RyYW5zcG9ydCwgTlVMTCwgcGt0KTsNCiAJCX0NCiAJfSB3aGlsZSAoIXZp
cnRxdWV1ZV9lbmFibGVfY2IodnEpKTsNCiANCmRpZmYgLS1naXQgYS9uZXQvdm13X3Zzb2NrL3Zp
cnRpb190cmFuc3BvcnRfY29tbW9uLmMgYi9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRf
Y29tbW9uLmMNCmluZGV4IDM3ZThkYmZlMmY1ZC4uNDQ0NzY0ODY5NjcwIDEwMDY0NA0KLS0tIGEv
bmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jDQorKysgYi9uZXQvdm13X3Zz
b2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMNCkBAIC0xMjM4LDExICsxMjM4LDExIEBAIHN0
YXRpYyBib29sIHZpcnRpb190cmFuc3BvcnRfdmFsaWRfdHlwZSh1MTYgdHlwZSkNCiAgKiBsb2Nr
Lg0KICAqLw0KIHZvaWQgdmlydGlvX3RyYW5zcG9ydF9yZWN2X3BrdChzdHJ1Y3QgdmlydGlvX3Ry
YW5zcG9ydCAqdCwNCisJCQkgICAgICAgc3RydWN0IHNvY2sgKnNrLA0KIAkJCSAgICAgICBzdHJ1
Y3QgdmlydGlvX3Zzb2NrX3BrdCAqcGt0KQ0KIHsNCiAJc3RydWN0IHNvY2thZGRyX3ZtIHNyYywg
ZHN0Ow0KIAlzdHJ1Y3QgdnNvY2tfc29jayAqdnNrOw0KLQlzdHJ1Y3Qgc29jayAqc2s7DQogCWJv
b2wgc3BhY2VfYXZhaWxhYmxlOw0KIA0KIAl2c29ja19hZGRyX2luaXQoJnNyYywgbGU2NF90b19j
cHUocGt0LT5oZHIuc3JjX2NpZCksDQpAQCAtMTI2NywxMiArMTI2NywxNCBAQCB2b2lkIHZpcnRp
b190cmFuc3BvcnRfcmVjdl9wa3Qoc3RydWN0IHZpcnRpb190cmFuc3BvcnQgKnQsDQogCS8qIFRo
ZSBzb2NrZXQgbXVzdCBiZSBpbiBjb25uZWN0ZWQgb3IgYm91bmQgdGFibGUNCiAJICogb3RoZXJ3
aXNlIHNlbmQgcmVzZXQgYmFjaw0KIAkgKi8NCi0Jc2sgPSB2c29ja19maW5kX2Nvbm5lY3RlZF9z
b2NrZXQoJnNyYywgJmRzdCk7DQogCWlmICghc2spIHsNCi0JCXNrID0gdnNvY2tfZmluZF9ib3Vu
ZF9zb2NrZXQoJmRzdCk7DQorCQlzayA9IHZzb2NrX2ZpbmRfY29ubmVjdGVkX3NvY2tldCgmc3Jj
LCAmZHN0KTsNCiAJCWlmICghc2spIHsNCi0JCQkodm9pZCl2aXJ0aW9fdHJhbnNwb3J0X3Jlc2V0
X25vX3NvY2sodCwgcGt0KTsNCi0JCQlnb3RvIGZyZWVfcGt0Ow0KKwkJCXNrID0gdnNvY2tfZmlu
ZF9ib3VuZF9zb2NrZXQoJmRzdCk7DQorCQkJaWYgKCFzaykgew0KKwkJCQkodm9pZCl2aXJ0aW9f
dHJhbnNwb3J0X3Jlc2V0X25vX3NvY2sodCwgcGt0KTsNCisJCQkJZ290byBmcmVlX3BrdDsNCisJ
CQl9DQogCQl9DQogCX0NCiANCmRpZmYgLS1naXQgYS9uZXQvdm13X3Zzb2NrL3Zzb2NrX2xvb3Bi
YWNrLmMgYi9uZXQvdm13X3Zzb2NrL3Zzb2NrX2xvb3BiYWNrLmMNCmluZGV4IDE2OWE4Y2Y2NWIz
OS4uMzdjMjhiYmVhZmFmIDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay92c29ja19sb29wYmFj
ay5jDQorKysgYi9uZXQvdm13X3Zzb2NrL3Zzb2NrX2xvb3BiYWNrLmMNCkBAIC0xMzQsNyArMTM0
LDcgQEAgc3RhdGljIHZvaWQgdnNvY2tfbG9vcGJhY2tfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
KndvcmspDQogCQlsaXN0X2RlbF9pbml0KCZwa3QtPmxpc3QpOw0KIA0KIAkJdmlydGlvX3RyYW5z
cG9ydF9kZWxpdmVyX3RhcF9wa3QocGt0KTsNCi0JCXZpcnRpb190cmFuc3BvcnRfcmVjdl9wa3Qo
Jmxvb3BiYWNrX3RyYW5zcG9ydCwgcGt0KTsNCisJCXZpcnRpb190cmFuc3BvcnRfcmVjdl9wa3Qo
Jmxvb3BiYWNrX3RyYW5zcG9ydCwgTlVMTCwgcGt0KTsNCiAJfQ0KIH0NCiANCi0tIA0KMi4zNS4w
DQo=
