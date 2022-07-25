Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC0C57FADB
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbiGYIFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiGYIFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:05:51 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292CA13CD8;
        Mon, 25 Jul 2022 01:05:50 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 47AE05FD0B;
        Mon, 25 Jul 2022 11:05:48 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658736348;
        bh=pCw9/kVOeCE/CCajlNyM8QpfiZna4eRW1EqZxJu2eJg=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=NipdLVEYo9awZ8x/aNxrBaWkKUZJULScNVDO/L5BjJu9VPXvNLJB5etTtlKSRTbRN
         QuHINHSY9o2W8nKRwPGrA7KXTUR5psVb0bg4D+PzLPmNqxhvd3FuiU7/FBdg+k221p
         O2MMfgjHndPhBKb1R/3pS/6XF5TWqpsaeBUztix0L0dSzx5YpbmjwnIH5+eY8kVvM6
         kzoMZ+LK/uTBpJnaMi11fo8I36+AxR9KeaSRIS3xwqv5gfLKE4DPqfHKvOi76a8ZIF
         xDghmsCDdnLue7SaicVx1XVoQdTcbkBG6QwWXb6+MahRZ9l/37O7KRsOojWrekhhLO
         a/DAmCRqqVnfw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Mon, 25 Jul 2022 11:05:47 +0300 (MSK)
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
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v2 5/9] vsock: SO_RCVLOWAT transport set callback
Thread-Topic: [RFC PATCH v2 5/9] vsock: SO_RCVLOWAT transport set callback
Thread-Index: AQHYn/1NoPOM/Um+pUC5XxeDqd2x/w==
Date:   Mon, 25 Jul 2022 08:05:28 +0000
Message-ID: <8baa2e3a-af6b-c0fe-9bfb-7cf89506474a@sberdevices.ru>
In-Reply-To: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <40D3115A2D73A340AB96E70176059B63@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/07/25 03:52:00 #19956163
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
YyB8IDE5ICsrKysrKysrKysrKysrKysrKysNCiAyIGZpbGVzIGNoYW5nZWQsIDIwIGluc2VydGlv
bnMoKykNCg0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2FmX3Zzb2NrLmggYi9pbmNsdWRlL25l
dC9hZl92c29jay5oDQppbmRleCBmNzQyZTUwMjA3ZmIuLmVhZTU4NzRiYWUzNSAxMDA2NDQNCi0t
LSBhL2luY2x1ZGUvbmV0L2FmX3Zzb2NrLmgNCisrKyBiL2luY2x1ZGUvbmV0L2FmX3Zzb2NrLmgN
CkBAIC0xMzQsNiArMTM0LDcgQEAgc3RydWN0IHZzb2NrX3RyYW5zcG9ydCB7DQogCXU2NCAoKnN0
cmVhbV9yY3ZoaXdhdCkoc3RydWN0IHZzb2NrX3NvY2sgKik7DQogCWJvb2wgKCpzdHJlYW1faXNf
YWN0aXZlKShzdHJ1Y3QgdnNvY2tfc29jayAqKTsNCiAJYm9vbCAoKnN0cmVhbV9hbGxvdykodTMy
IGNpZCwgdTMyIHBvcnQpOw0KKwlpbnQgKCpzZXRfcmN2bG93YXQpKHN0cnVjdCB2c29ja19zb2Nr
ICosIGludCk7DQogDQogCS8qIFNFUV9QQUNLRVQuICovDQogCXNzaXplX3QgKCpzZXFwYWNrZXRf
ZGVxdWV1ZSkoc3RydWN0IHZzb2NrX3NvY2sgKnZzaywgc3RydWN0IG1zZ2hkciAqbXNnLA0KZGlm
ZiAtLWdpdCBhL25ldC92bXdfdnNvY2svYWZfdnNvY2suYyBiL25ldC92bXdfdnNvY2svYWZfdnNv
Y2suYw0KaW5kZXggNjNhMTNmYTI2ODZhLi5iN2EyODZkYjRhZjEgMTAwNjQ0DQotLS0gYS9uZXQv
dm13X3Zzb2NrL2FmX3Zzb2NrLmMNCisrKyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KQEAg
LTIxMzAsNiArMjEzMCwyNCBAQCB2c29ja19jb25uZWN0aWJsZV9yZWN2bXNnKHN0cnVjdCBzb2Nr
ZXQgKnNvY2ssIHN0cnVjdCBtc2doZHIgKm1zZywgc2l6ZV90IGxlbiwNCiAJcmV0dXJuIGVycjsN
CiB9DQogDQorc3RhdGljIGludCB2c29ja19zZXRfcmN2bG93YXQoc3RydWN0IHNvY2sgKnNrLCBp
bnQgdmFsKQ0KK3sNCisJY29uc3Qgc3RydWN0IHZzb2NrX3RyYW5zcG9ydCAqdHJhbnNwb3J0Ow0K
KwlzdHJ1Y3QgdnNvY2tfc29jayAqdnNrOw0KKwlpbnQgZXJyID0gMDsNCisNCisJdnNrID0gdnNv
Y2tfc2soc2spOw0KKwl0cmFuc3BvcnQgPSB2c2stPnRyYW5zcG9ydDsNCisNCisJaWYgKHRyYW5z
cG9ydC0+c2V0X3Jjdmxvd2F0KQ0KKwkJZXJyID0gdHJhbnNwb3J0LT5zZXRfcmN2bG93YXQodnNr
LCB2YWwpOw0KKw0KKwlpZiAoIWVycikNCisJCVdSSVRFX09OQ0Uoc2stPnNrX3Jjdmxvd2F0LCB2
YWwgPyA6IDEpOw0KKw0KKwlyZXR1cm4gZXJyOw0KK30NCisNCiBzdGF0aWMgY29uc3Qgc3RydWN0
IHByb3RvX29wcyB2c29ja19zdHJlYW1fb3BzID0gew0KIAkuZmFtaWx5ID0gUEZfVlNPQ0ssDQog
CS5vd25lciA9IFRISVNfTU9EVUxFLA0KQEAgLTIxNDksNiArMjE2Nyw3IEBAIHN0YXRpYyBjb25z
dCBzdHJ1Y3QgcHJvdG9fb3BzIHZzb2NrX3N0cmVhbV9vcHMgPSB7DQogCS5yZWN2bXNnID0gdnNv
Y2tfY29ubmVjdGlibGVfcmVjdm1zZywNCiAJLm1tYXAgPSBzb2NrX25vX21tYXAsDQogCS5zZW5k
cGFnZSA9IHNvY2tfbm9fc2VuZHBhZ2UsDQorCS5zZXRfcmN2bG93YXQgPSB2c29ja19zZXRfcmN2
bG93YXQsDQogfTsNCiANCiBzdGF0aWMgY29uc3Qgc3RydWN0IHByb3RvX29wcyB2c29ja19zZXFw
YWNrZXRfb3BzID0gew0KLS0gDQoyLjI1LjENCg==
