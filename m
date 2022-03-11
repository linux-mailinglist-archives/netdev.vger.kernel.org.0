Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815644D6037
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348108AbiCKK5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347547AbiCKK5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:57:17 -0500
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787381BBF40;
        Fri, 11 Mar 2022 02:56:13 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id E843F5FD03;
        Fri, 11 Mar 2022 13:56:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1646996170;
        bh=DD/056Xz/HdtVJttGh/0J3YuBHetrOfFSU0k/r+/LWU=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=oygVYYnfmxInViijSb+SiWbY6FDcVbeACrqVXJ5/lj7pzqrJUhON6MRdmOrX5a2BX
         DeKfafmEVkco3JdxvWnNvbqxJtig5Rd1MZNcP/SjDjAYFgaX0HO2TZhQCjuA04iR0z
         WcVHnmNFBl8tPFPy5kue7LGFxeI1Njgm+/9ZoHGvriXc1JE55spbw6+lWpOntj5+eC
         nehQQqH2XgxIcm9CQfl75vAPOG0p2MzNqYQeRxvHzvPCXhSdiqq+UfiMhAjGpg1TsC
         J8jnPCH3ZoooJMC2N8R4O9MqNrJ6HsgP464NpkFZ/16dn6tdkXqLwvrdLQWVMPPjGt
         uEafdS1fWAxxA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri, 11 Mar 2022 13:56:10 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v1 2/3] af_vsock: SOCK_SEQPACKET receive timeout test
Thread-Topic: [RFC PATCH v1 2/3] af_vsock: SOCK_SEQPACKET receive timeout test
Thread-Index: AQHYNTaJU61+cjcYFEaSzJHWUZnmpA==
Date:   Fri, 11 Mar 2022 10:55:42 +0000
Message-ID: <6981b132-4121-62d8-7172-dca28ad1e498@sberdevices.ru>
In-Reply-To: <1bb5ce91-da53-7de9-49ba-f49f76f45512@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B649EFA0EFBCF448BF2B340A76F6CAF0@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/11 07:23:00 #18938550
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
IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KLS0tDQogdG9vbHMv
dGVzdGluZy92c29jay92c29ja190ZXN0LmMgfCA0OSArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA0OSBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQg
YS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyBiL3Rvb2xzL3Rlc3RpbmcvdnNvY2sv
dnNvY2tfdGVzdC5jDQppbmRleCAyYTM2MzhjMGEwMDguLmFhMmRlMjdkMGY3NyAxMDA2NDQNCi0t
LSBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQorKysgYi90b29scy90ZXN0aW5n
L3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KQEAgLTM5MSw2ICszOTEsNTAgQEAgc3RhdGljIHZvaWQgdGVz
dF9zZXFwYWNrZXRfbXNnX3RydW5jX3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRz
KQ0KIAljbG9zZShmZCk7DQogfQ0KIA0KK3N0YXRpYyB2b2lkIHRlc3Rfc2VxcGFja2V0X3RpbWVv
dXRfY2xpZW50KGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQorew0KKwlpbnQgZmQ7DQor
CXN0cnVjdCB0aW1ldmFsIHR2Ow0KKwljaGFyIGR1bW15Ow0KKw0KKwlmZCA9IHZzb2NrX3NlcXBh
Y2tldF9jb25uZWN0KG9wdHMtPnBlZXJfY2lkLCAxMjM0KTsNCisJaWYgKGZkIDwgMCkgew0KKwkJ
cGVycm9yKCJjb25uZWN0Iik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJdHYu
dHZfc2VjID0gMTsNCisJdHYudHZfdXNlYyA9IDA7DQorDQorCWlmIChzZXRzb2Nrb3B0KGZkLCBT
T0xfU09DS0VULCBTT19SQ1ZUSU1FTywgKHZvaWQgKikmdHYsIHNpemVvZih0dikpID09IC0xKSB7
DQorCQlwZXJyb3IoInNldHNvY2tvcHQgJ1NPX1JDVlRJTUVPJyIpOw0KKwkJZXhpdChFWElUX0ZB
SUxVUkUpOw0KKwl9DQorDQorCWlmICgocmVhZChmZCwgJmR1bW15LCBzaXplb2YoZHVtbXkpKSAh
PSAtMSkgfHwNCisJICAgIChlcnJubyAhPSBFQUdBSU4pKSB7DQorCQlwZXJyb3IoIkVBR0FJTiBl
eHBlY3RlZCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWNvbnRyb2xfd3Jp
dGVsbigiV0FJVERPTkUiKTsNCisJY2xvc2UoZmQpOw0KK30NCisNCitzdGF0aWMgdm9pZCB0ZXN0
X3NlcXBhY2tldF90aW1lb3V0X3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0K
K3sNCisJaW50IGZkOw0KKw0KKwlmZCA9IHZzb2NrX3NlcXBhY2tldF9hY2NlcHQoVk1BRERSX0NJ
RF9BTlksIDEyMzQsIE5VTEwpOw0KKwlpZiAoZmQgPCAwKSB7DQorCQlwZXJyb3IoImFjY2VwdCIp
Ow0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWNvbnRyb2xfZXhwZWN0bG4oIldB
SVRET05FIik7DQorCWNsb3NlKGZkKTsNCit9DQorDQogc3RhdGljIHN0cnVjdCB0ZXN0X2Nhc2Ug
dGVzdF9jYXNlc1tdID0gew0KIAl7DQogCQkubmFtZSA9ICJTT0NLX1NUUkVBTSBjb25uZWN0aW9u
IHJlc2V0IiwNCkBAIC00MzEsNiArNDc1LDExIEBAIHN0YXRpYyBzdHJ1Y3QgdGVzdF9jYXNlIHRl
c3RfY2FzZXNbXSA9IHsNCiAJCS5ydW5fY2xpZW50ID0gdGVzdF9zZXFwYWNrZXRfbXNnX3RydW5j
X2NsaWVudCwNCiAJCS5ydW5fc2VydmVyID0gdGVzdF9zZXFwYWNrZXRfbXNnX3RydW5jX3NlcnZl
ciwNCiAJfSwNCisJew0KKwkJLm5hbWUgPSAiU09DS19TRVFQQUNLRVQgdGltZW91dCIsDQorCQku
cnVuX2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0X3RpbWVvdXRfY2xpZW50LA0KKwkJLnJ1bl9zZXJ2
ZXIgPSB0ZXN0X3NlcXBhY2tldF90aW1lb3V0X3NlcnZlciwNCisJfSwNCiAJe30sDQogfTsNCiAN
Ci0tIA0KMi4yNS4xDQo=
