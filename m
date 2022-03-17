Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B922B4DC155
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiCQIeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiCQIeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:34:23 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C5EDF79;
        Thu, 17 Mar 2022 01:33:02 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 9B6C85FD05;
        Thu, 17 Mar 2022 11:33:00 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647505980;
        bh=uUIguhPYSRQYuvGZdqq8DZXGX+3rc11w87j08rzjRFk=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=YqCwhA2TOsrZ4EuPltsaHjtahVU+Lf7/sfjsNwZntpvYMF4rR39Rf0jvrw7kPg9lt
         7M8sNRcIRufVwMRD8/yjoQNYNsZuWRuW4VqP4fdY1MZlsQLyy+N7NcPBETHkm/b4qm
         x7ZLRHymF4qdNKNi77AdqmyryDPIlUPL8pfESqV5RXnyPEha7oYztRY79shPRLBD6m
         1ZL1ilWsozM24alvke1/m5ccxxgUQVzPw+10ZDpB1a83x9pMFaLb1RBmfvL0YoFpRb
         MWO05i/sKkfh5OFkJARfkmBgWCQu0qSnOpaOKNW2LwVZxlcM3RZ6m6kq6q9K/C4Ha3
         aTh9uq5Ihe6rA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 17 Mar 2022 11:33:00 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Subject: [PATCH net-next v4 1/2] af_vsock: SOCK_SEQPACKET receive timeout test
Thread-Topic: [PATCH net-next v4 1/2] af_vsock: SOCK_SEQPACKET receive timeout
 test
Thread-Index: AQHYOdluk7UVMpfaN0++JeUqQ0JH4g==
Date:   Thu, 17 Mar 2022 08:31:49 +0000
Message-ID: <3cf108a3-e57f-abf8-e82f-6d6e80c4a37a@sberdevices.ru>
In-Reply-To: <97d6d8c6-f7b2-1b03-a3d9-f312c33134ec@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6BC0D2611369864CBACEDF8E926720A9@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/17 04:52:00 #18991242
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGVzdCBmb3IgcmVjZWl2ZSB0aW1lb3V0IGNoZWNrOiBjb25uZWN0aW9uIGlzIGVzdGFibGlzaGVk
LA0KcmVjZWl2ZXIgc2V0cyB0aW1lb3V0LCBidXQgc2VuZGVyIGRvZXMgbm90aGluZy4gUmVjZWl2
ZXIncw0KJ3JlYWQoKScgY2FsbCBtdXN0IHJldHVybiBFQUdBSU4uDQoNClNpZ25lZC1vZmYtYnk6
IEtyYXNub3YgQXJzZW5peSBWbGFkaW1pcm92aWNoIDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+
DQotLS0NCiB2MyAtPiB2NDoNCiAxKSBGaXggc3R1cGlkIGJ1ZyBhYm91dCBpbnZhbGlkICdpZigp
JyBsaW5lLg0KDQogdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgfCA4NCArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA4NCBpbnNlcnRpb25z
KCspDQoNCmRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyBiL3Rv
b2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQppbmRleCAyYTM2MzhjMGEwMDguLjViODU2
MWI4MDkxNCAxMDA2NDQNCi0tLSBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQor
KysgYi90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KQEAgLTE2LDYgKzE2LDcgQEAN
CiAjaW5jbHVkZSA8bGludXgva2VybmVsLmg+DQogI2luY2x1ZGUgPHN5cy90eXBlcy5oPg0KICNp
bmNsdWRlIDxzeXMvc29ja2V0Lmg+DQorI2luY2x1ZGUgPHRpbWUuaD4NCiANCiAjaW5jbHVkZSAi
dGltZW91dC5oIg0KICNpbmNsdWRlICJjb250cm9sLmgiDQpAQCAtMzkxLDYgKzM5Miw4NCBAQCBz
dGF0aWMgdm9pZCB0ZXN0X3NlcXBhY2tldF9tc2dfdHJ1bmNfc2VydmVyKGNvbnN0IHN0cnVjdCB0
ZXN0X29wdHMgKm9wdHMpDQogCWNsb3NlKGZkKTsNCiB9DQogDQorc3RhdGljIHRpbWVfdCBjdXJy
ZW50X25zZWModm9pZCkNCit7DQorCXN0cnVjdCB0aW1lc3BlYyB0czsNCisNCisJaWYgKGNsb2Nr
X2dldHRpbWUoQ0xPQ0tfUkVBTFRJTUUsICZ0cykpIHsNCisJCXBlcnJvcigiY2xvY2tfZ2V0dGlt
ZSgzKSBmYWlsZWQiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlyZXR1cm4g
KHRzLnR2X3NlYyAqIDEwMDAwMDAwMDBVTEwpICsgdHMudHZfbnNlYzsNCit9DQorDQorI2RlZmlu
ZSBSQ1ZUSU1FT19USU1FT1VUX1NFQyAxDQorI2RlZmluZSBSRUFEX09WRVJIRUFEX05TRUMgMjUw
MDAwMDAwIC8qIDAuMjUgc2VjICovDQorDQorc3RhdGljIHZvaWQgdGVzdF9zZXFwYWNrZXRfdGlt
ZW91dF9jbGllbnQoY29uc3Qgc3RydWN0IHRlc3Rfb3B0cyAqb3B0cykNCit7DQorCWludCBmZDsN
CisJc3RydWN0IHRpbWV2YWwgdHY7DQorCWNoYXIgZHVtbXk7DQorCXRpbWVfdCByZWFkX2VudGVy
X25zOw0KKwl0aW1lX3QgcmVhZF9vdmVyaGVhZF9uczsNCisNCisJZmQgPSB2c29ja19zZXFwYWNr
ZXRfY29ubmVjdChvcHRzLT5wZWVyX2NpZCwgMTIzNCk7DQorCWlmIChmZCA8IDApIHsNCisJCXBl
cnJvcigiY29ubmVjdCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCXR2LnR2
X3NlYyA9IFJDVlRJTUVPX1RJTUVPVVRfU0VDOw0KKwl0di50dl91c2VjID0gMDsNCisNCisJaWYg
KHNldHNvY2tvcHQoZmQsIFNPTF9TT0NLRVQsIFNPX1JDVlRJTUVPLCAodm9pZCAqKSZ0diwgc2l6
ZW9mKHR2KSkgPT0gLTEpIHsNCisJCXBlcnJvcigic2V0c29ja29wdCAnU09fUkNWVElNRU8nIik7
DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJcmVhZF9lbnRlcl9ucyA9IGN1cnJl
bnRfbnNlYygpOw0KKw0KKwlpZiAocmVhZChmZCwgJmR1bW15LCBzaXplb2YoZHVtbXkpKSAhPSAt
MSkgew0KKwkJZnByaW50ZihzdGRlcnIsDQorCQkJImV4cGVjdGVkICdkdW1teScgcmVhZCgyKSBm
YWlsdXJlXG4iKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlpZiAoZXJybm8g
IT0gRUFHQUlOKSB7DQorCQlwZXJyb3IoIkVBR0FJTiBleHBlY3RlZCIpOw0KKwkJZXhpdChFWElU
X0ZBSUxVUkUpOw0KKwl9DQorDQorCXJlYWRfb3ZlcmhlYWRfbnMgPSBjdXJyZW50X25zZWMoKSAt
IHJlYWRfZW50ZXJfbnMgLQ0KKwkJCTEwMDAwMDAwMDBVTEwgKiBSQ1ZUSU1FT19USU1FT1VUX1NF
QzsNCisNCisJaWYgKHJlYWRfb3ZlcmhlYWRfbnMgPiBSRUFEX09WRVJIRUFEX05TRUMpIHsNCisJ
CWZwcmludGYoc3RkZXJyLA0KKwkJCSJ0b28gbXVjaCB0aW1lIGluIHJlYWQoMiksICVsdSA+ICVp
IG5zXG4iLA0KKwkJCXJlYWRfb3ZlcmhlYWRfbnMsIFJFQURfT1ZFUkhFQURfTlNFQyk7DQorCQll
eGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJY29udHJvbF93cml0ZWxuKCJXQUlURE9ORSIp
Ow0KKwljbG9zZShmZCk7DQorfQ0KKw0KK3N0YXRpYyB2b2lkIHRlc3Rfc2VxcGFja2V0X3RpbWVv
dXRfc2VydmVyKGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQorew0KKwlpbnQgZmQ7DQor
DQorCWZkID0gdnNvY2tfc2VxcGFja2V0X2FjY2VwdChWTUFERFJfQ0lEX0FOWSwgMTIzNCwgTlVM
TCk7DQorCWlmIChmZCA8IDApIHsNCisJCXBlcnJvcigiYWNjZXB0Iik7DQorCQlleGl0KEVYSVRf
RkFJTFVSRSk7DQorCX0NCisNCisJY29udHJvbF9leHBlY3RsbigiV0FJVERPTkUiKTsNCisJY2xv
c2UoZmQpOw0KK30NCisNCiBzdGF0aWMgc3RydWN0IHRlc3RfY2FzZSB0ZXN0X2Nhc2VzW10gPSB7
DQogCXsNCiAJCS5uYW1lID0gIlNPQ0tfU1RSRUFNIGNvbm5lY3Rpb24gcmVzZXQiLA0KQEAgLTQz
MSw2ICs1MTAsMTEgQEAgc3RhdGljIHN0cnVjdCB0ZXN0X2Nhc2UgdGVzdF9jYXNlc1tdID0gew0K
IAkJLnJ1bl9jbGllbnQgPSB0ZXN0X3NlcXBhY2tldF9tc2dfdHJ1bmNfY2xpZW50LA0KIAkJLnJ1
bl9zZXJ2ZXIgPSB0ZXN0X3NlcXBhY2tldF9tc2dfdHJ1bmNfc2VydmVyLA0KIAl9LA0KKwl7DQor
CQkubmFtZSA9ICJTT0NLX1NFUVBBQ0tFVCB0aW1lb3V0IiwNCisJCS5ydW5fY2xpZW50ID0gdGVz
dF9zZXFwYWNrZXRfdGltZW91dF9jbGllbnQsDQorCQkucnVuX3NlcnZlciA9IHRlc3Rfc2VxcGFj
a2V0X3RpbWVvdXRfc2VydmVyLA0KKwl9LA0KIAl7fSwNCiB9Ow0KIA0KLS0gDQoyLjI1LjENCg==
