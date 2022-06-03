Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F2553C458
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 07:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240807AbiFCFgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 01:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiFCFge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 01:36:34 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9777939142;
        Thu,  2 Jun 2022 22:36:31 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id BBB495FD04;
        Fri,  3 Jun 2022 08:36:29 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1654234589;
        bh=0LvHAQl3XARivHwA03baFrqhSI1ZsvnwZSA/W3J5NCI=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=Ec9QIUa3BpOFqy+GxJKhjo/GxdhOC/hHDF3x6vp8VDfpgdGFh8iT/ClyrnPtGXRlT
         r0HvffkyQWiHjDTgwXRK9W+6Mtq4p7yIuHt8rDU/494FM6PxFWgfUt7WPPOh8UpgGO
         ycMYB7sDsWQ3EzvU/bN+OXH4AJajqNxMJKbrl/99SA1XLz01/nt6hwo8WSH/vLslfY
         5aUYZXkruXjUvcBDVGK89MS0F7NiYrxWQy3rSi6Tl/uu0fs56645MGLt8fI24Q29k7
         Lg2fiisa54dvmpzH4EiI913+Zoki8cVpNdQ1TL5bUWud5P3TcjRRi7E3NeyJwvcXgS
         GFMgyhhkHdBlA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri,  3 Jun 2022 08:36:15 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 3/8] af_vsock: add zerocopy receive logic
Thread-Topic: [RFC PATCH v2 3/8] af_vsock: add zerocopy receive logic
Thread-Index: AQHYdwvHqkojsXt09k2Zv7nWir8Frg==
Date:   Fri, 3 Jun 2022 05:35:48 +0000
Message-ID: <129aa328-ad4d-cb2c-4a51-4a2bf9c9be37@sberdevices.ru>
In-Reply-To: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A59E824BDDCC4F4C9CF39E7C6094D17F@sberdevices.ru>
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

VGhpczoNCjEpIEFkZHMgY2FsbGJhY2sgZm9yICdtbWFwKCknIGNhbGwgb24gc29ja2V0LiBJdCBj
aGVja3Mgdm0NCiAgIGFyZWEgZmxhZ3MgYW5kIHNldHMgdm0gYXJlYSBvcHMuDQoyKSBBZGRzIHNw
ZWNpYWwgJ2dldHNvY2tvcHQoKScgY2FzZSB3aGljaCBjYWxscyB0cmFuc3BvcnQNCiAgIHplcm9j
b3B5IGNhbGxiYWNrLiBJbnB1dCBhcmd1bWVudCBpcyB2bSBhcmVhIGFkZHJlc3MuDQozKSBBZGRz
ICdnZXRzb2Nrb3B0KCkvc2V0c29ja29wdCgpJyBmb3Igc3dpdGNoaW5nIG9uL29mZiByeA0KICAg
emVyb2NvcHkgbW9kZS4NCg0KU2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNu
b3ZAc2JlcmRldmljZXMucnU+DQotLS0NCiBpbmNsdWRlL25ldC9hZl92c29jay5oICAgICAgICAg
IHwgICA3ICsrKw0KIGluY2x1ZGUvdWFwaS9saW51eC92bV9zb2NrZXRzLmggfCAgIDMgKw0KIG5l
dC92bXdfdnNvY2svYWZfdnNvY2suYyAgICAgICAgfCAxMDAgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCiAzIGZpbGVzIGNoYW5nZWQsIDExMCBpbnNlcnRpb25zKCspDQoNCmRpZmYg
LS1naXQgYS9pbmNsdWRlL25ldC9hZl92c29jay5oIGIvaW5jbHVkZS9uZXQvYWZfdnNvY2suaA0K
aW5kZXggZjc0MmU1MDIwN2ZiLi5mMTVmODRjNjQ4ZmYgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL25l
dC9hZl92c29jay5oDQorKysgYi9pbmNsdWRlL25ldC9hZl92c29jay5oDQpAQCAtMTM1LDYgKzEz
NSwxMyBAQCBzdHJ1Y3QgdnNvY2tfdHJhbnNwb3J0IHsNCiAJYm9vbCAoKnN0cmVhbV9pc19hY3Rp
dmUpKHN0cnVjdCB2c29ja19zb2NrICopOw0KIAlib29sICgqc3RyZWFtX2FsbG93KSh1MzIgY2lk
LCB1MzIgcG9ydCk7DQogDQorCWludCAoKnJ4X3plcm9jb3B5X3NldCkoc3RydWN0IHZzb2NrX3Nv
Y2sgKnZzaywNCisJCQkgICAgICAgYm9vbCBlbmFibGUpOw0KKwlpbnQgKCpyeF96ZXJvY29weV9n
ZXQpKHN0cnVjdCB2c29ja19zb2NrICp2c2spOw0KKwlpbnQgKCp6ZXJvY29weV9kZXF1ZXVlKShz
dHJ1Y3QgdnNvY2tfc29jayAqdnNrLA0KKwkJCQlzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwN
CisJCQkJdW5zaWduZWQgbG9uZyBhZGRyKTsNCisNCiAJLyogU0VRX1BBQ0tFVC4gKi8NCiAJc3Np
emVfdCAoKnNlcXBhY2tldF9kZXF1ZXVlKShzdHJ1Y3QgdnNvY2tfc29jayAqdnNrLCBzdHJ1Y3Qg
bXNnaGRyICptc2csDQogCQkJCSAgICAgaW50IGZsYWdzKTsNCmRpZmYgLS1naXQgYS9pbmNsdWRl
L3VhcGkvbGludXgvdm1fc29ja2V0cy5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L3ZtX3NvY2tldHMu
aA0KaW5kZXggYzYwY2EzM2VhYzU5Li5kMWY3OTJiZWQxYTcgMTAwNjQ0DQotLS0gYS9pbmNsdWRl
L3VhcGkvbGludXgvdm1fc29ja2V0cy5oDQorKysgYi9pbmNsdWRlL3VhcGkvbGludXgvdm1fc29j
a2V0cy5oDQpAQCAtODMsNiArODMsOSBAQA0KIA0KICNkZWZpbmUgU09fVk1fU09DS0VUU19DT05O
RUNUX1RJTUVPVVRfTkVXIDgNCiANCisjZGVmaW5lIFNPX1ZNX1NPQ0tFVFNfTUFQX1JYIDkNCisj
ZGVmaW5lIFNPX1ZNX1NPQ0tFVFNfWkVST0NPUFkgMTANCisNCiAjaWYgIWRlZmluZWQoX19LRVJO
RUxfXykNCiAjaWYgX19CSVRTX1BFUl9MT05HID09IDY0IHx8IChkZWZpbmVkKF9feDg2XzY0X18p
ICYmIGRlZmluZWQoX19JTFAzMl9fKSkNCiAjZGVmaW5lIFNPX1ZNX1NPQ0tFVFNfQ09OTkVDVF9U
SU1FT1VUIFNPX1ZNX1NPQ0tFVFNfQ09OTkVDVF9USU1FT1VUX09MRA0KZGlmZiAtLWdpdCBhL25l
dC92bXdfdnNvY2svYWZfdnNvY2suYyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KaW5kZXgg
ZjA0YWJmNjYyZWM2Li4xMDA2MWVmMjE3MzAgMTAwNjQ0DQotLS0gYS9uZXQvdm13X3Zzb2NrL2Fm
X3Zzb2NrLmMNCisrKyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KQEAgLTE2NDQsNiArMTY0
NCwxNyBAQCBzdGF0aWMgaW50IHZzb2NrX2Nvbm5lY3RpYmxlX3NldHNvY2tvcHQoc3RydWN0IHNv
Y2tldCAqc29jaywNCiAJCX0NCiAJCWJyZWFrOw0KIAl9DQorCWNhc2UgU09fVk1fU09DS0VUU19a
RVJPQ09QWTogew0KKwkJaWYgKCF0cmFuc3BvcnQgfHwgIXRyYW5zcG9ydC0+cnhfemVyb2NvcHlf
c2V0KSB7DQorCQkJZXJyID0gLUVPUE5PVFNVUFA7DQorCQl9IGVsc2Ugew0KKwkJCUNPUFlfSU4o
dmFsKTsNCisNCisJCQlpZiAodHJhbnNwb3J0LT5yeF96ZXJvY29weV9zZXQodnNrLCB2YWwpKQ0K
KwkJCQllcnIgPSAtRUlOVkFMOw0KKwkJfQ0KKwkJYnJlYWs7DQorCX0NCiANCiAJZGVmYXVsdDoN
CiAJCWVyciA9IC1FTk9QUk9UT09QVDsNCkBAIC0xNjU3LDYgKzE2NjgsNDggQEAgc3RhdGljIGlu
dCB2c29ja19jb25uZWN0aWJsZV9zZXRzb2Nrb3B0KHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCXJl
dHVybiBlcnI7DQogfQ0KIA0KK3N0YXRpYyBjb25zdCBzdHJ1Y3Qgdm1fb3BlcmF0aW9uc19zdHJ1
Y3QgYWZ2c29ja192bV9vcHMgPSB7DQorfTsNCisNCitzdGF0aWMgaW50IHZzb2NrX3JlY3ZfemVy
b2NvcHkoc3RydWN0IHNvY2tldCAqc29jaywNCisJCQkgICAgICAgdW5zaWduZWQgbG9uZyBhZGRy
ZXNzKQ0KK3sNCisJc3RydWN0IHNvY2sgKnNrID0gc29jay0+c2s7DQorCXN0cnVjdCB2c29ja19z
b2NrICp2c2sgPSB2c29ja19zayhzayk7DQorCXN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hOw0K
Kwljb25zdCBzdHJ1Y3QgdnNvY2tfdHJhbnNwb3J0ICp0cmFuc3BvcnQ7DQorCWludCByZXM7DQor
DQorCXRyYW5zcG9ydCA9IHZzay0+dHJhbnNwb3J0Ow0KKw0KKwlpZiAoIXRyYW5zcG9ydC0+cnhf
emVyb2NvcHlfZ2V0KQ0KKwkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KKw0KKwlpZiAoIXRyYW5zcG9y
dC0+cnhfemVyb2NvcHlfZ2V0KHZzaykpDQorCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQorDQorCWlm
ICghdHJhbnNwb3J0LT56ZXJvY29weV9kZXF1ZXVlKQ0KKwkJcmV0dXJuIC1FT1BOT1RTVVBQOw0K
Kw0KKwlsb2NrX3NvY2soc2spOw0KKwltbWFwX3dyaXRlX2xvY2soY3VycmVudC0+bW0pOw0KKw0K
Kwl2bWEgPSB2bWFfbG9va3VwKGN1cnJlbnQtPm1tLCBhZGRyZXNzKTsNCisNCisJaWYgKCF2bWEg
fHwgdm1hLT52bV9vcHMgIT0gJmFmdnNvY2tfdm1fb3BzKSB7DQorCQltbWFwX3dyaXRlX3VubG9j
ayhjdXJyZW50LT5tbSk7DQorCQlyZWxlYXNlX3NvY2soc2spOw0KKwkJcmV0dXJuIC1FSU5WQUw7
DQorCX0NCisNCisJcmVzID0gdHJhbnNwb3J0LT56ZXJvY29weV9kZXF1ZXVlKHZzaywgdm1hLCBh
ZGRyZXNzKTsNCisNCisJbW1hcF93cml0ZV91bmxvY2soY3VycmVudC0+bW0pOw0KKwlyZWxlYXNl
X3NvY2soc2spOw0KKw0KKwlyZXR1cm4gcmVzOw0KK30NCisNCiBzdGF0aWMgaW50IHZzb2NrX2Nv
bm5lY3RpYmxlX2dldHNvY2tvcHQoc3RydWN0IHNvY2tldCAqc29jaywNCiAJCQkJCWludCBsZXZl
bCwgaW50IG9wdG5hbWUsDQogCQkJCQljaGFyIF9fdXNlciAqb3B0dmFsLA0KQEAgLTE3MDEsNiAr
MTc1NCwzOSBAQCBzdGF0aWMgaW50IHZzb2NrX2Nvbm5lY3RpYmxlX2dldHNvY2tvcHQoc3RydWN0
IHNvY2tldCAqc29jaywNCiAJCWx2ID0gc29ja19nZXRfdGltZW91dCh2c2stPmNvbm5lY3RfdGlt
ZW91dCwgJnYsDQogCQkJCSAgICAgIG9wdG5hbWUgPT0gU09fVk1fU09DS0VUU19DT05ORUNUX1RJ
TUVPVVRfT0xEKTsNCiAJCWJyZWFrOw0KKwljYXNlIFNPX1ZNX1NPQ0tFVFNfWkVST0NPUFk6IHsN
CisJCWNvbnN0IHN0cnVjdCB2c29ja190cmFuc3BvcnQgKnRyYW5zcG9ydDsNCisJCWludCByZXM7
DQorDQorCQl0cmFuc3BvcnQgPSB2c2stPnRyYW5zcG9ydDsNCisNCisJCWlmICghdHJhbnNwb3J0
LT5yeF96ZXJvY29weV9nZXQpDQorCQkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KKw0KKwkJbG9ja19z
b2NrKHNrKTsNCisNCisJCXJlcyA9IHRyYW5zcG9ydC0+cnhfemVyb2NvcHlfZ2V0KHZzayk7DQor
DQorCQlyZWxlYXNlX3NvY2soc2spOw0KKw0KKwkJaWYgKHJlcyA8IDApDQorCQkJcmV0dXJuIC1F
SU5WQUw7DQorDQorCQl2LnZhbDY0ID0gcmVzOw0KKw0KKwkJYnJlYWs7DQorCX0NCisJY2FzZSBT
T19WTV9TT0NLRVRTX01BUF9SWDogew0KKwkJdW5zaWduZWQgbG9uZyB2bWFfYWRkcjsNCisNCisJ
CWlmIChsZW4gPCBzaXplb2Yodm1hX2FkZHIpKQ0KKwkJCXJldHVybiAtRUlOVkFMOw0KKw0KKwkJ
aWYgKGNvcHlfZnJvbV91c2VyKCZ2bWFfYWRkciwgb3B0dmFsLCBzaXplb2Yodm1hX2FkZHIpKSkN
CisJCQlyZXR1cm4gLUVGQVVMVDsNCisNCisJCXJldHVybiB2c29ja19yZWN2X3plcm9jb3B5KHNv
Y2ssIHZtYV9hZGRyKTsNCisJfQ0KIA0KIAlkZWZhdWx0Og0KIAkJcmV0dXJuIC1FTk9QUk9UT09Q
VDsNCkBAIC0yMTI5LDYgKzIyMTUsMTkgQEAgdnNvY2tfY29ubmVjdGlibGVfcmVjdm1zZyhzdHJ1
Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3QgbXNnaGRyICptc2csIHNpemVfdCBsZW4sDQogCXJldHVy
biBlcnI7DQogfQ0KIA0KK3N0YXRpYyBpbnQgYWZ2c29ja19tbWFwKHN0cnVjdCBmaWxlICpmaWxl
LCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KKwkJCXN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hKQ0K
K3sNCisJaWYgKHZtYS0+dm1fZmxhZ3MgJiAoVk1fV1JJVEUgfCBWTV9FWEVDKSkNCisJCXJldHVy
biAtRVBFUk07DQorDQorCXZtYS0+dm1fZmxhZ3MgJj0gfihWTV9NQVlXUklURSB8IFZNX01BWUVY
RUMpOw0KKwl2bWEtPnZtX2ZsYWdzIHw9IChWTV9NSVhFRE1BUCk7DQorCXZtYS0+dm1fb3BzID0g
JmFmdnNvY2tfdm1fb3BzOw0KKw0KKwlyZXR1cm4gMDsNCit9DQorDQogc3RhdGljIGNvbnN0IHN0
cnVjdCBwcm90b19vcHMgdnNvY2tfc3RyZWFtX29wcyA9IHsNCiAJLmZhbWlseSA9IFBGX1ZTT0NL
LA0KIAkub3duZXIgPSBUSElTX01PRFVMRSwNCkBAIC0yMTQ4LDYgKzIyNDcsNyBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IHByb3RvX29wcyB2c29ja19zdHJlYW1fb3BzID0gew0KIAkucmVjdm1zZyA9
IHZzb2NrX2Nvbm5lY3RpYmxlX3JlY3Ztc2csDQogCS5tbWFwID0gc29ja19ub19tbWFwLA0KIAku
c2VuZHBhZ2UgPSBzb2NrX25vX3NlbmRwYWdlLA0KKwkubW1hcCA9IGFmdnNvY2tfbW1hcCwNCiB9
Ow0KIA0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcHJvdG9fb3BzIHZzb2NrX3NlcXBhY2tldF9vcHMg
PSB7DQotLSANCjIuMjUuMQ0K
