Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580EF69C72A
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 10:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjBTJBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 04:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjBTJBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 04:01:40 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05105C155;
        Mon, 20 Feb 2023 01:01:36 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 33B115FD41;
        Mon, 20 Feb 2023 12:01:34 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1676883694;
        bh=Y3sLq5qhF16bAMVBK1yYQ2qyjlUvy8j6YvmyjoZaj2M=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=UoWlCimCJNrL6clUBS/PynOXhzudIUxtO+SiSbYRgJQwR17AgY4yYsyBiKd5u1f3Z
         rXdMujfCKtJJKMmPL5oaTGNGurSgLpzp7vI10dNlZoQXTxbOXuwiaeNUMniArZz0Ph
         OMkJzlHT1xFkincHIXo+vXhF9x+lUnaJ6PMFw5XiKgq6jmwJgSSO3zEGnB1y2vAkih
         S+0vIg1K4u3reVZ2rn+yRGRQvbjUI/Dfp0+lFDVlDyXpHHKArF+RJU+HmM/eMzc7n1
         eB9cHbgrfevtvm4HEoLW7jgcree5IMzrhLiQgXohvzbjmpNSYJ8TDWR1ypvgmaETH8
         85GKlSLjmJ8WQ==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon, 20 Feb 2023 12:01:34 +0300 (MSK)
From:   Krasnov Arseniy <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 04/12] vhost/vsock: non-linear skb handling support
Thread-Topic: [RFC PATCH v1 04/12] vhost/vsock: non-linear skb handling
 support
Thread-Index: AQHZOfg/4Da0EZnl9kKVLokjsbh9oK7RekeAgAXykgA=
Date:   Mon, 20 Feb 2023 09:01:33 +0000
Message-ID: <df350d42-bfc3-d0d3-f04f-8b3ebeea4d0a@sberdevices.ru>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <c1570fa9-1673-73cf-5545-995e9aac1dbb@sberdevices.ru>
 <20230216140917.jpcmfrwl5gpdzdzi@sgarzare-redhat>
In-Reply-To: <20230216140917.jpcmfrwl5gpdzdzi@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <211613708E294441B6FDBCD1436157D2@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/02/20 05:01:00 #20887657
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTYuMDIuMjAyMyAxNzowOSwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBNb24s
IEZlYiAwNiwgMjAyMyBhdCAwNjo1NzoxNkFNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBUaGlzIGFkZHMgY29weWluZyB0byBndWVzdCdzIHZpcnRpbyBidWZmZXJzIGZyb20gbm9u
LWxpbmVhciBza2JzLiBTdWNoDQo+PiBza2JzIGFyZSBjcmVhdGVkIGJ5IHByb3RvY29sIGxheWVy
IHdoZW4gTVNHX1pFUk9DT1BZIGZsYWdzIGlzIHVzZWQuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTog
QXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQo+PiAtLS0NCj4+IGRy
aXZlcnMvdmhvc3QvdnNvY2suY8KgwqDCoMKgwqDCoMKgIHwgNTYgKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKystLS0tDQo+PiBpbmNsdWRlL2xpbnV4L3ZpcnRpb192c29jay5oIHwgMTIg
KysrKysrKysNCj4+IDIgZmlsZXMgY2hhbmdlZCwgNjMgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlv
bnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aG9zdC92c29jay5jIGIvZHJpdmVy
cy92aG9zdC92c29jay5jDQo+PiBpbmRleCAxZjNiODljODg1Y2MuLjYwYjljYWZhM2UzMSAxMDA2
NDQNCj4+IC0tLSBhL2RyaXZlcnMvdmhvc3QvdnNvY2suYw0KPj4gKysrIGIvZHJpdmVycy92aG9z
dC92c29jay5jDQo+PiBAQCAtODYsNiArODYsNDQgQEAgc3RhdGljIHN0cnVjdCB2aG9zdF92c29j
ayAqdmhvc3RfdnNvY2tfZ2V0KHUzMiBndWVzdF9jaWQpDQo+PiDCoMKgwqDCoHJldHVybiBOVUxM
Ow0KPj4gfQ0KPj4NCj4+ICtzdGF0aWMgaW50IHZob3N0X3RyYW5zcG9ydF9jb3B5X25vbmxpbmVh
cl9za2Ioc3RydWN0IHNrX2J1ZmYgKnNrYiwNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgaW92X2l0ZXIgKmlvdl9pdGVyLA0KPj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNpemVf
dCBsZW4pDQo+PiArew0KPj4gK8KgwqDCoCBzaXplX3QgcmVzdF9sZW4gPSBsZW47DQo+PiArDQo+
PiArwqDCoMKgIHdoaWxlIChyZXN0X2xlbiAmJiB2aXJ0aW9fdnNvY2tfc2tiX2hhc19mcmFncyhz
a2IpKSB7DQo+PiArwqDCoMKgwqDCoMKgwqAgc3RydWN0IGJpb192ZWMgKmN1cnJfdmVjOw0KPj4g
K8KgwqDCoMKgwqDCoMKgIHNpemVfdCBjdXJyX3ZlY19lbmQ7DQo+PiArwqDCoMKgwqDCoMKgwqAg
c2l6ZV90IHRvX2NvcHk7DQo+PiArwqDCoMKgwqDCoMKgwqAgaW50IGN1cnJfZnJhZzsNCj4+ICvC
oMKgwqDCoMKgwqDCoCBpbnQgY3Vycl9vZmZzOw0KPj4gKw0KPj4gK8KgwqDCoMKgwqDCoMKgIGN1
cnJfZnJhZyA9IFZJUlRJT19WU09DS19TS0JfQ0Ioc2tiKS0+Y3Vycl9mcmFnOw0KPj4gK8KgwqDC
oMKgwqDCoMKgIGN1cnJfb2ZmcyA9IFZJUlRJT19WU09DS19TS0JfQ0Ioc2tiKS0+ZnJhZ19vZmY7
DQo+PiArwqDCoMKgwqDCoMKgwqAgY3Vycl92ZWMgPSAmc2tiX3NoaW5mbyhza2IpLT5mcmFnc1tj
dXJyX2ZyYWddOw0KPj4gKw0KPj4gK8KgwqDCoMKgwqDCoMKgIGN1cnJfdmVjX2VuZCA9IGN1cnJf
dmVjLT5idl9vZmZzZXQgKyBjdXJyX3ZlYy0+YnZfbGVuOw0KPj4gK8KgwqDCoMKgwqDCoMKgIHRv
X2NvcHkgPSBtaW4ocmVzdF9sZW4sIChzaXplX3QpKGN1cnJfdmVjX2VuZCAtIGN1cnJfb2Zmcykp
Ow0KPj4gKw0KPj4gK8KgwqDCoMKgwqDCoMKgIGlmIChjb3B5X3BhZ2VfdG9faXRlcihjdXJyX3Zl
Yy0+YnZfcGFnZSwgY3Vycl9vZmZzLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB0b19jb3B5LCBpb3ZfaXRlcikgIT0gdG9fY29weSkNCj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJldHVybiAtMTsNCj4+ICsNCj4+ICvCoMKgwqDCoMKgwqDCoCByZXN0
X2xlbiAtPSB0b19jb3B5Ow0KPj4gK8KgwqDCoMKgwqDCoMKgIFZJUlRJT19WU09DS19TS0JfQ0Io
c2tiKS0+ZnJhZ19vZmYgKz0gdG9fY29weTsNCj4+ICsNCj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAo
VklSVElPX1ZTT0NLX1NLQl9DQihza2IpLT5mcmFnX29mZiA9PSAoY3Vycl92ZWNfZW5kKSkgew0K
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVklSVElPX1ZTT0NLX1NLQl9DQihza2IpLT5jdXJy
X2ZyYWcrKzsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFZJUlRJT19WU09DS19TS0JfQ0Io
c2tiKS0+ZnJhZ19vZmYgPSAwOw0KPj4gK8KgwqDCoMKgwqDCoMKgIH0NCj4+ICvCoMKgwqAgfQ0K
PiANCj4gQ2FuIGl0IGhhcHBlbiB0aGF0IHdlIGV4aXQgdGhpcyBsb29wIGFuZCByZXN0X2xlbiBp
cyBub3QgMD8NCj4gDQo+IEluIHRoaXMgY2FzZSwgaXMgaXQgY29ycmVjdCB0byBkZWNyZW1lbnQg
ZGF0YV9sZW4gYnkgbGVuPw0KDQpJIHNlZQ0KDQo+IA0KPiBUaGFua3MsDQo+IFN0ZWZhbm8NCj4g
DQo+PiArDQo+PiArwqDCoMKgIHNrYi0+ZGF0YV9sZW4gLT0gbGVuOw0KPj4gKw0KPj4gK8KgwqDC
oCByZXR1cm4gMDsNCj4+ICt9DQo+PiArDQo+PiBzdGF0aWMgdm9pZA0KPj4gdmhvc3RfdHJhbnNw
b3J0X2RvX3NlbmRfcGt0KHN0cnVjdCB2aG9zdF92c29jayAqdnNvY2ssDQo+PiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHZob3N0X3ZpcnRxdWV1ZSAqdnEpDQo+PiBAQCAt
MTk3LDExICsyMzUsMTkgQEAgdmhvc3RfdHJhbnNwb3J0X2RvX3NlbmRfcGt0KHN0cnVjdCB2aG9z
dF92c29jayAqdnNvY2ssDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOw0KPj4gwqDC
oMKgwqDCoMKgwqAgfQ0KPj4NCj4+IC3CoMKgwqDCoMKgwqDCoCBuYnl0ZXMgPSBjb3B5X3RvX2l0
ZXIoc2tiLT5kYXRhLCBwYXlsb2FkX2xlbiwgJmlvdl9pdGVyKTsNCj4+IC3CoMKgwqDCoMKgwqDC
oCBpZiAobmJ5dGVzICE9IHBheWxvYWRfbGVuKSB7DQo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBrZnJlZV9za2Ioc2tiKTsNCj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZxX2Vycih2cSwg
IkZhdWx0ZWQgb24gY29weWluZyBwa3QgYnVmXG4iKTsNCj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGJyZWFrOw0KPj4gK8KgwqDCoMKgwqDCoMKgIGlmIChza2JfaXNfbm9ubGluZWFyKHNrYikp
IHsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICh2aG9zdF90cmFuc3BvcnRfY29weV9u
b25saW5lYXJfc2tiKHNrYiwgJmlvdl9pdGVyLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHBheWxvYWRfbGVu
KSkgew0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2cV9lcnIodnEsICJGYXVs
dGVkIG9uIGNvcHlpbmcgcGt0IGJ1ZiBmcm9tIHBhZ2VcbiIpOw0KPj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBicmVhazsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0NCj4+
ICvCoMKgwqDCoMKgwqDCoCB9IGVsc2Ugew0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbmJ5
dGVzID0gY29weV90b19pdGVyKHNrYi0+ZGF0YSwgcGF5bG9hZF9sZW4sICZpb3ZfaXRlcik7DQo+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAobmJ5dGVzICE9IHBheWxvYWRfbGVuKSB7DQo+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGtmcmVlX3NrYihza2IpOw0KPj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2cV9lcnIodnEsICJGYXVsdGVkIG9uIGNvcHlp
bmcgcGt0IGJ1ZlxuIik7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFr
Ow0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQ0KPj4gwqDCoMKgwqDCoMKgwqAgfQ0KPj4N
Cj4+IMKgwqDCoMKgwqDCoMKgIC8qIERlbGl2ZXIgdG8gbW9uaXRvcmluZyBkZXZpY2VzIGFsbCBw
YWNrZXRzIHRoYXQgd2UNCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3ZpcnRpb192c29j
ay5oIGIvaW5jbHVkZS9saW51eC92aXJ0aW9fdnNvY2suaA0KPj4gaW5kZXggM2Y5YzE2NjExMzA2
Li5lN2VmZGI3OGNlNmUgMTAwNjQ0DQo+PiAtLS0gYS9pbmNsdWRlL2xpbnV4L3ZpcnRpb192c29j
ay5oDQo+PiArKysgYi9pbmNsdWRlL2xpbnV4L3ZpcnRpb192c29jay5oDQo+PiBAQCAtMTIsNiAr
MTIsMTAgQEANCj4+IHN0cnVjdCB2aXJ0aW9fdnNvY2tfc2tiX2NiIHsNCj4+IMKgwqDCoMKgYm9v
bCByZXBseTsNCj4+IMKgwqDCoMKgYm9vbCB0YXBfZGVsaXZlcmVkOw0KPj4gK8KgwqDCoCAvKiBD
dXJyZW50IGZyYWdtZW50IGluICdmcmFncycgb2Ygc2tiLiAqLw0KPj4gK8KgwqDCoCB1MzIgY3Vy
cl9mcmFnOw0KPj4gK8KgwqDCoCAvKiBPZmZzZXQgZnJvbSAwIGluIGN1cnJlbnQgZnJhZ21lbnQu
ICovDQo+PiArwqDCoMKgIHUzMiBmcmFnX29mZjsNCj4+IH07DQo+Pg0KPj4gI2RlZmluZSBWSVJU
SU9fVlNPQ0tfU0tCX0NCKHNrYikgKChzdHJ1Y3QgdmlydGlvX3Zzb2NrX3NrYl9jYiAqKSgoc2ti
KS0+Y2IpKQ0KPj4gQEAgLTQ2LDYgKzUwLDE0IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCB2aXJ0aW9f
dnNvY2tfc2tiX2NsZWFyX3RhcF9kZWxpdmVyZWQoc3RydWN0IHNrX2J1ZmYgKnNrYikNCj4+IMKg
wqDCoMKgVklSVElPX1ZTT0NLX1NLQl9DQihza2IpLT50YXBfZGVsaXZlcmVkID0gZmFsc2U7DQo+
PiB9DQo+Pg0KPj4gK3N0YXRpYyBpbmxpbmUgYm9vbCB2aXJ0aW9fdnNvY2tfc2tiX2hhc19mcmFn
cyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPj4gK3sNCj4+ICvCoMKgwqAgaWYgKCFza2JfaXNfbm9u
bGluZWFyKHNrYikpDQo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIGZhbHNlOw0KPj4gKw0KPj4g
K8KgwqDCoCByZXR1cm4gVklSVElPX1ZTT0NLX1NLQl9DQihza2IpLT5jdXJyX2ZyYWcgIT0gc2ti
X3NoaW5mbyhza2IpLT5ucl9mcmFnczsNCj4+ICt9DQo+PiArDQo+PiBzdGF0aWMgaW5saW5lIHZv
aWQgdmlydGlvX3Zzb2NrX3NrYl9yeF9wdXQoc3RydWN0IHNrX2J1ZmYgKnNrYikNCj4+IHsNCj4+
IMKgwqDCoMKgdTMyIGxlbjsNCj4+IC0twqANCj4+IDIuMjUuMQ0KPiANCg0K
