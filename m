Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DCD5994C5
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242217AbiHSFhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiHSFhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:37:22 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55180CACBE;
        Thu, 18 Aug 2022 22:37:20 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id A92515FD07;
        Fri, 19 Aug 2022 08:37:18 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660887438;
        bh=M8QbwpizhBqEUoqruWQEZu9WRSDqgcrIIvziju9qy/c=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=K9W78BuRr9a/+6G2w1+n0PGd/0X6YGcijrN4bIPZRDEK94KzIBmxnHJuoAkA4+qpy
         3Z76+sNf0pWpCbvIOVHNoS+yTPhl9p6Dmgm1juI0TrQ1x/wv0NHnpLdQ4H5iLN4BDx
         4Xq8l+zcILkdMB1cW41oMuo5lNbL44WATqcmVFDTV1D2D7rNatrcrc3Mu7Zn8Tfo+B
         eEKtdBzI4UvmEg2lRpFRrujqiCC+X/53yfYAAMNic6ytUm2v1io+i8eJ8nb6eGWNn4
         OVHt3Ed6tymJDI72IRerKIOIZVePFcdp3IP/cesMUqTeYyHUjjf4Fh5pyoqK0VKq0j
         ei9AfP5qVlLqA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri, 19 Aug 2022 08:37:18 +0300 (MSK)
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
Subject: [PATCH net-next v4 6/9] vsock: add API call for data ready
Thread-Topic: [PATCH net-next v4 6/9] vsock: add API call for data ready
Thread-Index: AQHYs42v4z1AREcY90CCwR1c1P12XQ==
Date:   Fri, 19 Aug 2022 05:36:52 +0000
Message-ID: <60fe5506-eb2e-99f0-08ec-27ab611920d0@sberdevices.ru>
In-Reply-To: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <61E37C54AE8DE541AF8C776A1124B686@sberdevices.ru>
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

VGhpcyBhZGRzICd2c29ja19kYXRhX3JlYWR5KCknIHdoaWNoIG11c3QgYmUgY2FsbGVkIGJ5IHRy
YW5zcG9ydCB0byBraWNrDQpzbGVlcGluZyBkYXRhIHJlYWRlcnMuIEl0IGNoZWNrcyBmb3IgU09f
UkNWTE9XQVQgdmFsdWUgYmVmb3JlIHdha2luZw0KdXNlciwgdGh1cyBwcmV2ZW50aW5nIHNwdXJp
b3VzIHdha2UgdXBzLiBCYXNlZCBvbiAndGNwX2RhdGFfcmVhZHkoKScgbG9naWMuDQoNClNpZ25l
ZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KUmV2
aWV3ZWQtYnk6IFN0ZWZhbm8gR2FyemFyZWxsYSA8c2dhcnphcmVAcmVkaGF0LmNvbT4NCi0tLQ0K
IGluY2x1ZGUvbmV0L2FmX3Zzb2NrLmggICB8ICAxICsNCiBuZXQvdm13X3Zzb2NrL2FmX3Zzb2Nr
LmMgfCAxMCArKysrKysrKysrDQogMiBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspDQoN
CmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9hZl92c29jay5oIGIvaW5jbHVkZS9uZXQvYWZfdnNv
Y2suaA0KaW5kZXggZDYwOWEwODhjYjI3Li41NjhhODdjNWUwZDAgMTAwNjQ0DQotLS0gYS9pbmNs
dWRlL25ldC9hZl92c29jay5oDQorKysgYi9pbmNsdWRlL25ldC9hZl92c29jay5oDQpAQCAtNzgs
NiArNzgsNyBAQCBzdHJ1Y3QgdnNvY2tfc29jayB7DQogczY0IHZzb2NrX3N0cmVhbV9oYXNfZGF0
YShzdHJ1Y3QgdnNvY2tfc29jayAqdnNrKTsNCiBzNjQgdnNvY2tfc3RyZWFtX2hhc19zcGFjZShz
dHJ1Y3QgdnNvY2tfc29jayAqdnNrKTsNCiBzdHJ1Y3Qgc29jayAqdnNvY2tfY3JlYXRlX2Nvbm5l
Y3RlZChzdHJ1Y3Qgc29jayAqcGFyZW50KTsNCit2b2lkIHZzb2NrX2RhdGFfcmVhZHkoc3RydWN0
IHNvY2sgKnNrKTsNCiANCiAvKioqKiBUUkFOU1BPUlQgKioqKi8NCiANCmRpZmYgLS1naXQgYS9u
ZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCmluZGV4
IGI1Y2JjODQ5ODQ0Yi4uODVhNjY1MjUzZTg0IDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay9h
Zl92c29jay5jDQorKysgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCkBAIC04ODIsNiArODgy
LDE2IEBAIHM2NCB2c29ja19zdHJlYW1faGFzX3NwYWNlKHN0cnVjdCB2c29ja19zb2NrICp2c2sp
DQogfQ0KIEVYUE9SVF9TWU1CT0xfR1BMKHZzb2NrX3N0cmVhbV9oYXNfc3BhY2UpOw0KIA0KK3Zv
aWQgdnNvY2tfZGF0YV9yZWFkeShzdHJ1Y3Qgc29jayAqc2spDQorew0KKwlzdHJ1Y3QgdnNvY2tf
c29jayAqdnNrID0gdnNvY2tfc2soc2spOw0KKw0KKwlpZiAodnNvY2tfc3RyZWFtX2hhc19kYXRh
KHZzaykgPj0gc2stPnNrX3Jjdmxvd2F0IHx8DQorCSAgICBzb2NrX2ZsYWcoc2ssIFNPQ0tfRE9O
RSkpDQorCQlzay0+c2tfZGF0YV9yZWFkeShzayk7DQorfQ0KK0VYUE9SVF9TWU1CT0xfR1BMKHZz
b2NrX2RhdGFfcmVhZHkpOw0KKw0KIHN0YXRpYyBpbnQgdnNvY2tfcmVsZWFzZShzdHJ1Y3Qgc29j
a2V0ICpzb2NrKQ0KIHsNCiAJX192c29ja19yZWxlYXNlKHNvY2stPnNrLCAwKTsNCi0tIA0KMi4y
NS4xDQo=
