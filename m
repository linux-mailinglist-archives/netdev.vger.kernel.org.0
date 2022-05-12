Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D44B5244B9
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 07:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349257AbiELFN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 01:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345766AbiELFN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 01:13:27 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1D654183;
        Wed, 11 May 2022 22:13:25 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 979825FD06;
        Thu, 12 May 2022 08:13:23 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1652332403;
        bh=WEpoyG/FkCWYqdlSPYBa69mJl1hJm+eMFpJP7yLV9Dk=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=RN/PdgDxlPxCj5VoYog3nurPwkzOg86UAXtuLyazDIBRD3tBB+2S7k9QiXWQ7oyAb
         EwAxwRYudYiUZqqbi0hoxVonm4I4nQ3Z3S/0DSliezS2IhQtA2MO978rzmiQZ6x/BX
         vYynpzyO0O9AKITJfK7AjXtySYCUW+wkbEC0nzD2R4PUPLNJ7/rx32MOlq1j/mkDC2
         E/49hBCSjn/V5DSoiB4xJj9hbHncqJmQu8lE5m/TYNcely0KZTpqwij4Gr6Lnc2m5w
         bfZev9CukZ+Vf9hQMHQg30qWihuD+2yiZ51T5/oPtLIRUknK/fediWvIbZpbMP9Fu5
         f0hMEoIiDbi5Q==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 12 May 2022 08:13:23 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
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
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: [RFC PATCH v1 3/8] af_vsock: add zerocopy receive logic
Thread-Topic: [RFC PATCH v1 3/8] af_vsock: add zerocopy receive logic
Thread-Index: AQHYZb7nBASrNXtuFUaX+/Xomq2sVQ==
Date:   Thu, 12 May 2022 05:12:40 +0000
Message-ID: <44d2404f-dc4f-f42c-1235-2ad7f537a030@sberdevices.ru>
In-Reply-To: <7cdcb1e1-7c97-c054-19cf-5caeacae981d@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C71C701713B9140B989C44D085F9EF4@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/05/12 02:55:00 #19424207
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpczoNCjEpIEFkZHMgY2FsbGJhY2sgZm9yICdtbWFwKCknIGNhbGwgb24gc29ja2V0LiBJdA0K
ICAgY2hlY2tzIHZtIGFyZWEgZmxhZ3MgYW5kIHNldHMgdm0gYXJlYSBvcHMuDQoyKSBBZGRzIHNw
ZWNpYWwgJ2dldHNvY2tvcHQoKScgY2FzZSB3aGljaCBjYWxscw0KICAgdHJhbnNwb3J0IHplcm9j
b3B5IGNhbGxiYWNrLiBJbnB1dCBhcmd1bWVudCBpcw0KICAgdm0gYXJlYSBhZGRyZXNzLg0KDQpT
aWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4N
Ci0tLQ0KIGluY2x1ZGUvbmV0L2FmX3Zzb2NrLmggICAgICAgICAgfCAgNCArKysNCiBpbmNsdWRl
L3VhcGkvbGludXgvdm1fc29ja2V0cy5oIHwgIDIgKysNCiBuZXQvdm13X3Zzb2NrL2FmX3Zzb2Nr
LmMgICAgICAgIHwgNjEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQogMyBmaWxl
cyBjaGFuZ2VkLCA2NyBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9h
Zl92c29jay5oIGIvaW5jbHVkZS9uZXQvYWZfdnNvY2suaA0KaW5kZXggYWIyMDc2NzdlMGE4Li5k
MGFlZmI5ZWU0Y2YgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL25ldC9hZl92c29jay5oDQorKysgYi9p
bmNsdWRlL25ldC9hZl92c29jay5oDQpAQCAtMTM1LDYgKzEzNSwxMCBAQCBzdHJ1Y3QgdnNvY2tf
dHJhbnNwb3J0IHsNCiAJYm9vbCAoKnN0cmVhbV9pc19hY3RpdmUpKHN0cnVjdCB2c29ja19zb2Nr
ICopOw0KIAlib29sICgqc3RyZWFtX2FsbG93KSh1MzIgY2lkLCB1MzIgcG9ydCk7DQogDQorCWlu
dCAoKnplcm9jb3B5X2RlcXVldWUpKHN0cnVjdCB2c29ja19zb2NrICp2c2ssDQorCQkJCXN0cnVj
dCB2bV9hcmVhX3N0cnVjdCAqdm1hLA0KKwkJCQl1bnNpZ25lZCBsb25nIGFkZHIpOw0KKw0KIAkv
KiBTRVFfUEFDS0VULiAqLw0KIAlzc2l6ZV90ICgqc2VxcGFja2V0X2RlcXVldWUpKHN0cnVjdCB2
c29ja19zb2NrICp2c2ssIHN0cnVjdCBtc2doZHIgKm1zZywNCiAJCQkJICAgICBpbnQgZmxhZ3Mp
Ow0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC92bV9zb2NrZXRzLmggYi9pbmNsdWRl
L3VhcGkvbGludXgvdm1fc29ja2V0cy5oDQppbmRleCBjNjBjYTMzZWFjNTkuLjYyYWVjNTFhMmJj
MyAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC92bV9zb2NrZXRzLmgNCisrKyBiL2lu
Y2x1ZGUvdWFwaS9saW51eC92bV9zb2NrZXRzLmgNCkBAIC04Myw2ICs4Myw4IEBADQogDQogI2Rl
ZmluZSBTT19WTV9TT0NLRVRTX0NPTk5FQ1RfVElNRU9VVF9ORVcgOA0KIA0KKyNkZWZpbmUgU09f
Vk1fU09DS0VUU19aRVJPQ09QWSA5DQorDQogI2lmICFkZWZpbmVkKF9fS0VSTkVMX18pDQogI2lm
IF9fQklUU19QRVJfTE9ORyA9PSA2NCB8fCAoZGVmaW5lZChfX3g4Nl82NF9fKSAmJiBkZWZpbmVk
KF9fSUxQMzJfXykpDQogI2RlZmluZSBTT19WTV9TT0NLRVRTX0NPTk5FQ1RfVElNRU9VVCBTT19W
TV9TT0NLRVRTX0NPTk5FQ1RfVElNRU9VVF9PTEQNCmRpZmYgLS1naXQgYS9uZXQvdm13X3Zzb2Nr
L2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCmluZGV4IDM4YmFlYjE4OWQ0
ZS4uM2Y5ODQ3N2VhNTQ2IDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay9hZl92c29jay5jDQor
KysgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCkBAIC0xNjUyLDYgKzE2NTIsNDIgQEAgc3Rh
dGljIGludCB2c29ja19jb25uZWN0aWJsZV9zZXRzb2Nrb3B0KHN0cnVjdCBzb2NrZXQgKnNvY2ss
DQogCXJldHVybiBlcnI7DQogfQ0KIA0KK3N0YXRpYyBjb25zdCBzdHJ1Y3Qgdm1fb3BlcmF0aW9u
c19zdHJ1Y3QgYWZ2c29ja192bV9vcHMgPSB7DQorfTsNCisNCitzdGF0aWMgaW50IHZzb2NrX3Jl
Y3ZfemVyb2NvcHkoc3RydWN0IHNvY2tldCAqc29jaywNCisJCQkgICAgICAgdW5zaWduZWQgbG9u
ZyBhZGRyZXNzKQ0KK3sNCisJc3RydWN0IHNvY2sgKnNrID0gc29jay0+c2s7DQorCXN0cnVjdCB2
c29ja19zb2NrICp2c2sgPSB2c29ja19zayhzayk7DQorCXN0cnVjdCB2bV9hcmVhX3N0cnVjdCAq
dm1hOw0KKwljb25zdCBzdHJ1Y3QgdnNvY2tfdHJhbnNwb3J0ICp0cmFuc3BvcnQ7DQorCWludCBy
ZXM7DQorDQorCXRyYW5zcG9ydCA9IHZzay0+dHJhbnNwb3J0Ow0KKw0KKwlpZiAoIXRyYW5zcG9y
dC0+emVyb2NvcHlfZGVxdWV1ZSkNCisJCXJldHVybiAtRU9QTk9UU1VQUDsNCisNCisJbG9ja19z
b2NrKHNrKTsNCisJbW1hcF93cml0ZV9sb2NrKGN1cnJlbnQtPm1tKTsNCisNCisJdm1hID0gdm1h
X2xvb2t1cChjdXJyZW50LT5tbSwgYWRkcmVzcyk7DQorDQorCWlmICghdm1hIHx8IHZtYS0+dm1f
b3BzICE9ICZhZnZzb2NrX3ZtX29wcykgew0KKwkJbW1hcF93cml0ZV91bmxvY2soY3VycmVudC0+
bW0pOw0KKwkJcmVsZWFzZV9zb2NrKHNrKTsNCisJCXJldHVybiAtRUlOVkFMOw0KKwl9DQorDQor
CXJlcyA9IHRyYW5zcG9ydC0+emVyb2NvcHlfZGVxdWV1ZSh2c2ssIHZtYSwgYWRkcmVzcyk7DQor
DQorCW1tYXBfd3JpdGVfdW5sb2NrKGN1cnJlbnQtPm1tKTsNCisJcmVsZWFzZV9zb2NrKHNrKTsN
CisNCisJcmV0dXJuIHJlczsNCit9DQorDQogc3RhdGljIGludCB2c29ja19jb25uZWN0aWJsZV9n
ZXRzb2Nrb3B0KHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCQkJCQlpbnQgbGV2ZWwsIGludCBvcHRu
YW1lLA0KIAkJCQkJY2hhciBfX3VzZXIgKm9wdHZhbCwNCkBAIC0xNjk2LDYgKzE3MzIsMTcgQEAg
c3RhdGljIGludCB2c29ja19jb25uZWN0aWJsZV9nZXRzb2Nrb3B0KHN0cnVjdCBzb2NrZXQgKnNv
Y2ssDQogCQlsdiA9IHNvY2tfZ2V0X3RpbWVvdXQodnNrLT5jb25uZWN0X3RpbWVvdXQsICZ2LA0K
IAkJCQkgICAgICBvcHRuYW1lID09IFNPX1ZNX1NPQ0tFVFNfQ09OTkVDVF9USU1FT1VUX09MRCk7
DQogCQlicmVhazsNCisJY2FzZSBTT19WTV9TT0NLRVRTX1pFUk9DT1BZOiB7DQorCQl1bnNpZ25l
ZCBsb25nIHZtYV9hZGRyOw0KKw0KKwkJaWYgKGxlbiA8IHNpemVvZih2bWFfYWRkcikpDQorCQkJ
cmV0dXJuIC1FSU5WQUw7DQorDQorCQlpZiAoY29weV9mcm9tX3VzZXIoJnZtYV9hZGRyLCBvcHR2
YWwsIHNpemVvZih2bWFfYWRkcikpKQ0KKwkJCXJldHVybiAtRUZBVUxUOw0KKw0KKwkJcmV0dXJu
IHZzb2NrX3JlY3ZfemVyb2NvcHkoc29jaywgdm1hX2FkZHIpOw0KKwl9DQogDQogCWRlZmF1bHQ6
DQogCQlyZXR1cm4gLUVOT1BST1RPT1BUOw0KQEAgLTIxMjQsNiArMjE3MSwxOSBAQCB2c29ja19j
b25uZWN0aWJsZV9yZWN2bXNnKHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBtc2doZHIgKm1z
Zywgc2l6ZV90IGxlbiwNCiAJcmV0dXJuIGVycjsNCiB9DQogDQorc3RhdGljIGludCBhZnZzb2Nr
X21tYXAoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQorCQkJc3RydWN0
IHZtX2FyZWFfc3RydWN0ICp2bWEpDQorew0KKwlpZiAodm1hLT52bV9mbGFncyAmIChWTV9XUklU
RSB8IFZNX0VYRUMpKQ0KKwkJcmV0dXJuIC1FUEVSTTsNCisNCisJdm1hLT52bV9mbGFncyAmPSB+
KFZNX01BWVdSSVRFIHwgVk1fTUFZRVhFQyk7DQorCXZtYS0+dm1fZmxhZ3MgfD0gKFZNX01JWEVE
TUFQKTsNCisJdm1hLT52bV9vcHMgPSAmYWZ2c29ja192bV9vcHM7DQorDQorCXJldHVybiAwOw0K
K30NCisNCiBzdGF0aWMgY29uc3Qgc3RydWN0IHByb3RvX29wcyB2c29ja19zdHJlYW1fb3BzID0g
ew0KIAkuZmFtaWx5ID0gUEZfVlNPQ0ssDQogCS5vd25lciA9IFRISVNfTU9EVUxFLA0KQEAgLTIx
NDMsNiArMjIwMyw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcHJvdG9fb3BzIHZzb2NrX3N0cmVh
bV9vcHMgPSB7DQogCS5yZWN2bXNnID0gdnNvY2tfY29ubmVjdGlibGVfcmVjdm1zZywNCiAJLm1t
YXAgPSBzb2NrX25vX21tYXAsDQogCS5zZW5kcGFnZSA9IHNvY2tfbm9fc2VuZHBhZ2UsDQorCS5t
bWFwID0gYWZ2c29ja19tbWFwLA0KIH07DQogDQogc3RhdGljIGNvbnN0IHN0cnVjdCBwcm90b19v
cHMgdnNvY2tfc2VxcGFja2V0X29wcyA9IHsNCi0tIA0KMi4yNS4xDQo=
