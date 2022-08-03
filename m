Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9D2588E27
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 16:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238546AbiHCOCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 10:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236785AbiHCOCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 10:02:14 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ADC2CE1C;
        Wed,  3 Aug 2022 07:02:12 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id A28B15FD2E;
        Wed,  3 Aug 2022 17:02:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1659535330;
        bh=B7MnM9LlcIMliFAHXLeyzEfSXIZ8NB66nwrKZJSvDgc=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=dubY+hTMsFMWN19jwfE4rvvJP42QM4Q1Rlayal/qamG5DnPV1O6AZrOmFdfK+MLlh
         yH2241C6lJ0DegbnqYsKDBn0rs7Q3l0xU04J7gNW0IhfbdIhZ3Qw/uDYE0gcc2faN3
         xGllPhWGN2OeRcK1s+cTaiXGjbI/x/EDLfwZqUL+gQXjXrxGpkdJ+M37vtkA45HH43
         6uz/RXK6ghh3QAukfqDSx5Yb5Ep5dKLmp+RF4hwblnB9coftL3GR8m488A2T+xD0+b
         5qc/aT4TyBS+Obq0WEH6Xmq/h7JnaXKCDdTkqhj7HA62bTPobp9LUgYFaOiGwsrQXY
         cZYSj59OemWeg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed,  3 Aug 2022 17:02:10 +0300 (MSK)
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
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Arseniy Krasnov" <AVKrasnov@sberdevices.ru>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 6/9] vsock: add API call for data ready
Thread-Topic: [RFC PATCH v3 6/9] vsock: add API call for data ready
Thread-Index: AQHYp0GXMIwj7aEDFUyU7Z65eKQpMg==
Date:   Wed, 3 Aug 2022 14:01:57 +0000
Message-ID: <edb1163d-fb78-3af0-2fdd-606c875a535b@sberdevices.ru>
In-Reply-To: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <85A4929A98C0C144AB0C8DA1959BA189@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/03 07:41:00 #20041172
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzICd2c29ja19kYXRhX3JlYWR5KCknIHdoaWNoIG11c3QgYmUgY2FsbGVkIGJ5IHRy
YW5zcG9ydCB0byBraWNrDQpzbGVlcGluZyBkYXRhIHJlYWRlcnMuIEl0IGNoZWNrcyBmb3IgU09f
UkNWTE9XQVQgdmFsdWUgYmVmb3JlIHdha2luZw0KdXNlcix0aHVzIHByZXZlbnRpbmcgc3B1cmlv
dXMgd2FrZSB1cHMuQmFzZWQgb24gJ3RjcF9kYXRhX3JlYWR5KCknIGxvZ2ljLg0KDQpTaWduZWQt
b2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCi0tLQ0K
IGluY2x1ZGUvbmV0L2FmX3Zzb2NrLmggICB8ICAxICsNCiBuZXQvdm13X3Zzb2NrL2FmX3Zzb2Nr
LmMgfCAxMCArKysrKysrKysrDQogMiBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspDQoN
CmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9hZl92c29jay5oIGIvaW5jbHVkZS9uZXQvYWZfdnNv
Y2suaA0KaW5kZXggZWFlNTg3NGJhZTM1Li43Yjc5ZmM1MTY0Y2MgMTAwNjQ0DQotLS0gYS9pbmNs
dWRlL25ldC9hZl92c29jay5oDQorKysgYi9pbmNsdWRlL25ldC9hZl92c29jay5oDQpAQCAtNzcs
NiArNzcsNyBAQCBzdHJ1Y3QgdnNvY2tfc29jayB7DQogczY0IHZzb2NrX3N0cmVhbV9oYXNfZGF0
YShzdHJ1Y3QgdnNvY2tfc29jayAqdnNrKTsNCiBzNjQgdnNvY2tfc3RyZWFtX2hhc19zcGFjZShz
dHJ1Y3QgdnNvY2tfc29jayAqdnNrKTsNCiBzdHJ1Y3Qgc29jayAqdnNvY2tfY3JlYXRlX2Nvbm5l
Y3RlZChzdHJ1Y3Qgc29jayAqcGFyZW50KTsNCit2b2lkIHZzb2NrX2RhdGFfcmVhZHkoc3RydWN0
IHNvY2sgKnNrKTsNCiANCiAvKioqKiBUUkFOU1BPUlQgKioqKi8NCiANCmRpZmYgLS1naXQgYS9u
ZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCmluZGV4
IDNhMTQyNmViOGJhYS4uNDdlODBhN2NiYmRmIDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay9h
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
