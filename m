Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB38B57FAEB
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbiGYIHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiGYIHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:07:42 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21BC13CD2;
        Mon, 25 Jul 2022 01:07:40 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 3804D5FD0B;
        Mon, 25 Jul 2022 11:07:39 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658736459;
        bh=sObFnqMOAqUFZ0if5Z6xdt9QYQocsNhmpGqLuSvEmg0=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=ZSC+dgKzMe5KQOX2bHAFy9k1fbo6e4VPd+sP1+eVqADRou6+zZzNJ6VhcMGjrqS2O
         5Lsv2cP1tdj3yS106hiwsdyYImOVdzfPQlmjW6ZSM8td35SZKUv+wcQIgedQndfDkY
         vl4bc3aR0gCvDJuY1aFzQ7zsfvZzgMsvVySHd9lJ/6SmbllceHWJJacRVciHcxhZpU
         k7ZT9Shga1rI+R9xGe2YS8xzye/k4uSxvMmX3DsePSp6NBQL6C3Z7wH4FxIKM5e2yS
         5yYpSRDNj/GgrmiKD2jPp42rIHLNK9mHvxa3Yp16akDmFOyDuGuMzVdgRFgu9n/EtR
         W/l2T3ax8vweA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Mon, 25 Jul 2022 11:07:38 +0300 (MSK)
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
Subject: [RFC PATCH v2 6/9] hv_sock: disable SO_RCVLOWAT support
Thread-Topic: [RFC PATCH v2 6/9] hv_sock: disable SO_RCVLOWAT support
Thread-Index: AQHYn/2PdDRRTeWJ4EqSAxbUzqz6wg==
Date:   Mon, 25 Jul 2022 08:07:19 +0000
Message-ID: <6ee85279-df24-7de1-d62d-7a8249fc8fc3@sberdevices.ru>
In-Reply-To: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E7C70C150A9C040BEFBAFD04BAAB181@sberdevices.ru>
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

Rm9yIEh5cGVyLVYgaXQgaXMgcXVpZXQgZGlmZmljdWx0IHRvIHN1cHBvcnQgdGhpcyBzb2NrZXQg
b3B0aW9uLGR1ZSB0bw0KdHJhbnNwb3J0IGludGVybmFscywgc28gZGlzYWJsZSBpdC4NCg0KU2ln
bmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQot
LS0NCiBuZXQvdm13X3Zzb2NrL2h5cGVydl90cmFuc3BvcnQuYyB8IDcgKysrKysrKw0KIDEgZmls
ZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2sv
aHlwZXJ2X3RyYW5zcG9ydC5jIGIvbmV0L3Ztd192c29jay9oeXBlcnZfdHJhbnNwb3J0LmMNCmlu
ZGV4IGUxMTFlMTNiNjY2MC4uNWZhYjhmMzU2YTg2IDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29j
ay9oeXBlcnZfdHJhbnNwb3J0LmMNCisrKyBiL25ldC92bXdfdnNvY2svaHlwZXJ2X3RyYW5zcG9y
dC5jDQpAQCAtODAyLDYgKzgwMiwxMiBAQCBpbnQgaHZzX25vdGlmeV9zZW5kX3Bvc3RfZW5xdWV1
ZShzdHJ1Y3QgdnNvY2tfc29jayAqdnNrLCBzc2l6ZV90IHdyaXR0ZW4sDQogCXJldHVybiAwOw0K
IH0NCiANCitzdGF0aWMNCitpbnQgaHZzX3NldF9yY3Zsb3dhdChzdHJ1Y3QgdnNvY2tfc29jayAq
dnNrLCBpbnQgdmFsKQ0KK3sNCisJcmV0dXJuIC1FT1BOT1RTVVBQOw0KK30NCisNCiBzdGF0aWMg
c3RydWN0IHZzb2NrX3RyYW5zcG9ydCBodnNfdHJhbnNwb3J0ID0gew0KIAkubW9kdWxlICAgICAg
ICAgICAgICAgICAgID0gVEhJU19NT0RVTEUsDQogDQpAQCAtODM3LDYgKzg0Myw3IEBAIHN0YXRp
YyBzdHJ1Y3QgdnNvY2tfdHJhbnNwb3J0IGh2c190cmFuc3BvcnQgPSB7DQogCS5ub3RpZnlfc2Vu
ZF9wcmVfZW5xdWV1ZSAgPSBodnNfbm90aWZ5X3NlbmRfcHJlX2VucXVldWUsDQogCS5ub3RpZnlf
c2VuZF9wb3N0X2VucXVldWUgPSBodnNfbm90aWZ5X3NlbmRfcG9zdF9lbnF1ZXVlLA0KIA0KKwku
c2V0X3Jjdmxvd2F0ICAgICAgICAgICAgID0gaHZzX3NldF9yY3Zsb3dhdA0KIH07DQogDQogc3Rh
dGljIGJvb2wgaHZzX2NoZWNrX3RyYW5zcG9ydChzdHJ1Y3QgdnNvY2tfc29jayAqdnNrKQ0KLS0g
DQoyLjI1LjENCg==
