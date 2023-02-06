Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F167468B5E7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 07:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjBFG56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 01:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBFG54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 01:57:56 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB421C586;
        Sun,  5 Feb 2023 22:57:24 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 8ADD55FD03;
        Mon,  6 Feb 2023 09:57:17 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1675666637;
        bh=Ech27EtHT9PBdnbJqZP/Jq1qwSOgf4mVJsXc+SOg5H0=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=ebrYb8QM7X3OghlBstj9jgA7q5ncRJHFpQxNUCWYHr0uC3tNjnt+KugnSSAxgWlpm
         ZFTgPn9gDaiwd4i25AurBM1c3zQKbZLmWelX8qMLY4QW/8SEma+uC6gXWUFCYq1oWg
         fQL61/Av9OvklhTGWnEuqrLlY5XuKMpfdvaB0eBfanZjP9uVZw5sA96oQS+7pZ6ol9
         YepHowbDEEIKDZldGF0xieXaGnUoBTId/lnkHZA1cUgZ1MEPPK9NFuwNPE6Rlb5GjE
         VM10qT7GAcL4CSS97X4VYvwh9wOceKij3r6+yQkRwC5YdelzZ6NDJw3RhIERxsAdLx
         zeFIHvR8PCUEg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  6 Feb 2023 09:57:17 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        "Krasnov Arseniy" <oxffffaa@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v1 04/12] vhost/vsock: non-linear skb handling support
Thread-Topic: [RFC PATCH v1 04/12] vhost/vsock: non-linear skb handling
 support
Thread-Index: AQHZOfg/4Da0EZnl9kKVLokjsbh9oA==
Date:   Mon, 6 Feb 2023 06:57:16 +0000
Message-ID: <c1570fa9-1673-73cf-5545-995e9aac1dbb@sberdevices.ru>
In-Reply-To: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <35D67462721A884E87BD8B0DE1EA7C7D@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/02/06 01:18:00 #20834045
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIGNvcHlpbmcgdG8gZ3Vlc3QncyB2aXJ0aW8gYnVmZmVycyBmcm9tIG5vbi1saW5l
YXIgc2ticy4gU3VjaA0Kc2ticyBhcmUgY3JlYXRlZCBieSBwcm90b2NvbCBsYXllciB3aGVuIE1T
R19aRVJPQ09QWSBmbGFncyBpcyB1c2VkLg0KDQpTaWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNu
b3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0tLQ0KIGRyaXZlcnMvdmhvc3QvdnNvY2su
YyAgICAgICAgfCA1NiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0NCiBpbmNs
dWRlL2xpbnV4L3ZpcnRpb192c29jay5oIHwgMTIgKysrKysrKysNCiAyIGZpbGVzIGNoYW5nZWQs
IDYzIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3Zob3N0L3Zzb2NrLmMgYi9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMNCmluZGV4IDFmM2I4OWM4ODVj
Yy4uNjBiOWNhZmEzZTMxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy92aG9zdC92c29jay5jDQorKysg
Yi9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMNCkBAIC04Niw2ICs4Niw0NCBAQCBzdGF0aWMgc3RydWN0
IHZob3N0X3Zzb2NrICp2aG9zdF92c29ja19nZXQodTMyIGd1ZXN0X2NpZCkNCiAJcmV0dXJuIE5V
TEw7DQogfQ0KIA0KK3N0YXRpYyBpbnQgdmhvc3RfdHJhbnNwb3J0X2NvcHlfbm9ubGluZWFyX3Nr
YihzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KKwkJCQkJICAgICAgc3RydWN0IGlvdl9pdGVyICppb3Zf
aXRlciwNCisJCQkJCSAgICAgIHNpemVfdCBsZW4pDQorew0KKwlzaXplX3QgcmVzdF9sZW4gPSBs
ZW47DQorDQorCXdoaWxlIChyZXN0X2xlbiAmJiB2aXJ0aW9fdnNvY2tfc2tiX2hhc19mcmFncyhz
a2IpKSB7DQorCQlzdHJ1Y3QgYmlvX3ZlYyAqY3Vycl92ZWM7DQorCQlzaXplX3QgY3Vycl92ZWNf
ZW5kOw0KKwkJc2l6ZV90IHRvX2NvcHk7DQorCQlpbnQgY3Vycl9mcmFnOw0KKwkJaW50IGN1cnJf
b2ZmczsNCisNCisJCWN1cnJfZnJhZyA9IFZJUlRJT19WU09DS19TS0JfQ0Ioc2tiKS0+Y3Vycl9m
cmFnOw0KKwkJY3Vycl9vZmZzID0gVklSVElPX1ZTT0NLX1NLQl9DQihza2IpLT5mcmFnX29mZjsN
CisJCWN1cnJfdmVjID0gJnNrYl9zaGluZm8oc2tiKS0+ZnJhZ3NbY3Vycl9mcmFnXTsNCisNCisJ
CWN1cnJfdmVjX2VuZCA9IGN1cnJfdmVjLT5idl9vZmZzZXQgKyBjdXJyX3ZlYy0+YnZfbGVuOw0K
KwkJdG9fY29weSA9IG1pbihyZXN0X2xlbiwgKHNpemVfdCkoY3Vycl92ZWNfZW5kIC0gY3Vycl9v
ZmZzKSk7DQorDQorCQlpZiAoY29weV9wYWdlX3RvX2l0ZXIoY3Vycl92ZWMtPmJ2X3BhZ2UsIGN1
cnJfb2ZmcywNCisJCQkJICAgICAgdG9fY29weSwgaW92X2l0ZXIpICE9IHRvX2NvcHkpDQorCQkJ
cmV0dXJuIC0xOw0KKw0KKwkJcmVzdF9sZW4gLT0gdG9fY29weTsNCisJCVZJUlRJT19WU09DS19T
S0JfQ0Ioc2tiKS0+ZnJhZ19vZmYgKz0gdG9fY29weTsNCisNCisJCWlmIChWSVJUSU9fVlNPQ0tf
U0tCX0NCKHNrYiktPmZyYWdfb2ZmID09IChjdXJyX3ZlY19lbmQpKSB7DQorCQkJVklSVElPX1ZT
T0NLX1NLQl9DQihza2IpLT5jdXJyX2ZyYWcrKzsNCisJCQlWSVJUSU9fVlNPQ0tfU0tCX0NCKHNr
YiktPmZyYWdfb2ZmID0gMDsNCisJCX0NCisJfQ0KKw0KKwlza2ItPmRhdGFfbGVuIC09IGxlbjsN
CisNCisJcmV0dXJuIDA7DQorfQ0KKw0KIHN0YXRpYyB2b2lkDQogdmhvc3RfdHJhbnNwb3J0X2Rv
X3NlbmRfcGt0KHN0cnVjdCB2aG9zdF92c29jayAqdnNvY2ssDQogCQkJICAgIHN0cnVjdCB2aG9z
dF92aXJ0cXVldWUgKnZxKQ0KQEAgLTE5NywxMSArMjM1LDE5IEBAIHZob3N0X3RyYW5zcG9ydF9k
b19zZW5kX3BrdChzdHJ1Y3Qgdmhvc3RfdnNvY2sgKnZzb2NrLA0KIAkJCWJyZWFrOw0KIAkJfQ0K
IA0KLQkJbmJ5dGVzID0gY29weV90b19pdGVyKHNrYi0+ZGF0YSwgcGF5bG9hZF9sZW4sICZpb3Zf
aXRlcik7DQotCQlpZiAobmJ5dGVzICE9IHBheWxvYWRfbGVuKSB7DQotCQkJa2ZyZWVfc2tiKHNr
Yik7DQotCQkJdnFfZXJyKHZxLCAiRmF1bHRlZCBvbiBjb3B5aW5nIHBrdCBidWZcbiIpOw0KLQkJ
CWJyZWFrOw0KKwkJaWYgKHNrYl9pc19ub25saW5lYXIoc2tiKSkgew0KKwkJCWlmICh2aG9zdF90
cmFuc3BvcnRfY29weV9ub25saW5lYXJfc2tiKHNrYiwgJmlvdl9pdGVyLA0KKwkJCQkJCQkgICAg
ICAgcGF5bG9hZF9sZW4pKSB7DQorCQkJCXZxX2Vycih2cSwgIkZhdWx0ZWQgb24gY29weWluZyBw
a3QgYnVmIGZyb20gcGFnZVxuIik7DQorCQkJCWJyZWFrOw0KKwkJCX0NCisJCX0gZWxzZSB7DQor
CQkJbmJ5dGVzID0gY29weV90b19pdGVyKHNrYi0+ZGF0YSwgcGF5bG9hZF9sZW4sICZpb3ZfaXRl
cik7DQorCQkJaWYgKG5ieXRlcyAhPSBwYXlsb2FkX2xlbikgew0KKwkJCQlrZnJlZV9za2Ioc2ti
KTsNCisJCQkJdnFfZXJyKHZxLCAiRmF1bHRlZCBvbiBjb3B5aW5nIHBrdCBidWZcbiIpOw0KKwkJ
CQlicmVhazsNCisJCQl9DQogCQl9DQogDQogCQkvKiBEZWxpdmVyIHRvIG1vbml0b3JpbmcgZGV2
aWNlcyBhbGwgcGFja2V0cyB0aGF0IHdlDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC92aXJ0
aW9fdnNvY2suaCBiL2luY2x1ZGUvbGludXgvdmlydGlvX3Zzb2NrLmgNCmluZGV4IDNmOWMxNjYx
MTMwNi4uZTdlZmRiNzhjZTZlIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC92aXJ0aW9fdnNv
Y2suaA0KKysrIGIvaW5jbHVkZS9saW51eC92aXJ0aW9fdnNvY2suaA0KQEAgLTEyLDYgKzEyLDEw
IEBADQogc3RydWN0IHZpcnRpb192c29ja19za2JfY2Igew0KIAlib29sIHJlcGx5Ow0KIAlib29s
IHRhcF9kZWxpdmVyZWQ7DQorCS8qIEN1cnJlbnQgZnJhZ21lbnQgaW4gJ2ZyYWdzJyBvZiBza2Iu
ICovDQorCXUzMiBjdXJyX2ZyYWc7DQorCS8qIE9mZnNldCBmcm9tIDAgaW4gY3VycmVudCBmcmFn
bWVudC4gKi8NCisJdTMyIGZyYWdfb2ZmOw0KIH07DQogDQogI2RlZmluZSBWSVJUSU9fVlNPQ0tf
U0tCX0NCKHNrYikgKChzdHJ1Y3QgdmlydGlvX3Zzb2NrX3NrYl9jYiAqKSgoc2tiKS0+Y2IpKQ0K
QEAgLTQ2LDYgKzUwLDE0IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCB2aXJ0aW9fdnNvY2tfc2tiX2Ns
ZWFyX3RhcF9kZWxpdmVyZWQoc3RydWN0IHNrX2J1ZmYgKnNrYikNCiAJVklSVElPX1ZTT0NLX1NL
Ql9DQihza2IpLT50YXBfZGVsaXZlcmVkID0gZmFsc2U7DQogfQ0KIA0KK3N0YXRpYyBpbmxpbmUg
Ym9vbCB2aXJ0aW9fdnNvY2tfc2tiX2hhc19mcmFncyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KK3sN
CisJaWYgKCFza2JfaXNfbm9ubGluZWFyKHNrYikpDQorCQlyZXR1cm4gZmFsc2U7DQorDQorCXJl
dHVybiBWSVJUSU9fVlNPQ0tfU0tCX0NCKHNrYiktPmN1cnJfZnJhZyAhPSBza2Jfc2hpbmZvKHNr
YiktPm5yX2ZyYWdzOw0KK30NCisNCiBzdGF0aWMgaW5saW5lIHZvaWQgdmlydGlvX3Zzb2NrX3Nr
Yl9yeF9wdXQoc3RydWN0IHNrX2J1ZmYgKnNrYikNCiB7DQogCXUzMiBsZW47DQotLSANCjIuMjUu
MQ0K
