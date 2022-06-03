Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77BA53C498
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 07:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238175AbiFCFkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 01:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241226AbiFCFjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 01:39:54 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B68396AE;
        Thu,  2 Jun 2022 22:39:52 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 632305FD02;
        Fri,  3 Jun 2022 08:39:50 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1654234790;
        bh=lK6cao0uju2hrt5cbvoIe3JQzXNM+1hhRQxVtKooXw8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=UNN5T8IYi3P36krQSPsocMZEVkk1kXmwNnIC+0HZHzG9ZPXNy+YBwCrFK1yu+aQKE
         S+O3eUEwTCM385w+UFrS3xOkkNX9WNzrAhQwJ38CyXUlOm4/xPvvy4OlqgpF7OducO
         y9Ibhd/FIz5EDFELcILtVQmU+JJ3urdQnhKNm36yno6Dj51Za9JOLhoC+NbXuW9LnF
         TPB4fMZvarF0ZoJch4RFXj+3MZQsHkWjH7af99lI5kwhBTpPghbwIyhXxGeuI0uioi
         krCJeBV0yb/EgPx2Qn9NRb+MS5D4ilUUbDFJOKEjWdbtdbEyuzTXYR1m5j4vE4hJh8
         4X0w9BNA/nmsA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri,  3 Jun 2022 08:39:49 +0300 (MSK)
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
Subject: [RFC PATCH v2 5/8] vhost/vsock: enable zerocopy callback
Thread-Topic: [RFC PATCH v2 5/8] vhost/vsock: enable zerocopy callback
Thread-Index: AQHYdwxHDqmhK66rm0GOZ6CooDdkrg==
Date:   Fri, 3 Jun 2022 05:39:23 +0000
Message-ID: <04c01c03-647c-49c2-bfa3-23fd995ce5bf@sberdevices.ru>
In-Reply-To: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A857DC23EEABFD469BA7DBEE1EBF3BE9@sberdevices.ru>
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

VGhpcyBhZGRzIHplcm9jb3B5IGNhbGxiYWNrIHRvIHZob3N0IHRyYW5zcG9ydC4NCg0KU2lnbmVk
LW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQotLS0N
CiBkcml2ZXJzL3Zob3N0L3Zzb2NrLmMgfCA0MCArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDQwIGluc2VydGlvbnMoKykNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdmhvc3QvdnNvY2suYyBiL2RyaXZlcnMvdmhvc3QvdnNvY2suYw0KaW5k
ZXggMGRjMjIyOWYxOGY3Li5kY2I4MTgyZjVhYzkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Zob3N0
L3Zzb2NrLmMNCisrKyBiL2RyaXZlcnMvdmhvc3QvdnNvY2suYw0KQEAgLTQ4MSw2ICs0ODEsNDMg
QEAgc3RhdGljIGJvb2wgdmhvc3RfdnNvY2tfbW9yZV9yZXBsaWVzKHN0cnVjdCB2aG9zdF92c29j
ayAqdnNvY2spDQogCXJldHVybiB2YWwgPCB2cS0+bnVtOw0KIH0NCiANCitzdGF0aWMgaW50IHZo
b3N0X3RyYW5zcG9ydF96ZXJvY29weV9zZXQoc3RydWN0IHZzb2NrX3NvY2sgKnZzaywgYm9vbCBl
bmFibGUpDQorew0KKwlzdHJ1Y3Qgdmhvc3RfdnNvY2sgKnZzb2NrOw0KKw0KKwlyY3VfcmVhZF9s
b2NrKCk7DQorCXZzb2NrID0gdmhvc3RfdnNvY2tfZ2V0KHZzay0+cmVtb3RlX2FkZHIuc3ZtX2Np
ZCk7DQorDQorCWlmICghdnNvY2spIHsNCisJCXJjdV9yZWFkX3VubG9jaygpOw0KKwkJcmV0dXJu
IC1FTk9ERVY7DQorCX0NCisNCisJdnNvY2stPnplcm9jb3B5X3J4X29uID0gZW5hYmxlOw0KKwly
Y3VfcmVhZF91bmxvY2soKTsNCisNCisJcmV0dXJuIDA7DQorfQ0KKw0KK3N0YXRpYyBpbnQgdmhv
c3RfdHJhbnNwb3J0X3plcm9jb3B5X2dldChzdHJ1Y3QgdnNvY2tfc29jayAqdnNrKQ0KK3sNCisJ
c3RydWN0IHZob3N0X3Zzb2NrICp2c29jazsNCisJYm9vbCByZXM7DQorDQorCXJjdV9yZWFkX2xv
Y2soKTsNCisJdnNvY2sgPSB2aG9zdF92c29ja19nZXQodnNrLT5yZW1vdGVfYWRkci5zdm1fY2lk
KTsNCisNCisJaWYgKCF2c29jaykgew0KKwkJcmN1X3JlYWRfdW5sb2NrKCk7DQorCQlyZXR1cm4g
LUVOT0RFVjsNCisJfQ0KKw0KKwlyZXMgPSB2c29jay0+emVyb2NvcHlfcnhfb247DQorCXJjdV9y
ZWFkX3VubG9jaygpOw0KKw0KKwlyZXR1cm4gcmVzOw0KK30NCisNCiBzdGF0aWMgYm9vbCB2aG9z
dF90cmFuc3BvcnRfc2VxcGFja2V0X2FsbG93KHUzMiByZW1vdGVfY2lkKTsNCiANCiBzdGF0aWMg
c3RydWN0IHZpcnRpb190cmFuc3BvcnQgdmhvc3RfdHJhbnNwb3J0ID0gew0KQEAgLTUwOCw2ICs1
NDUsOSBAQCBzdGF0aWMgc3RydWN0IHZpcnRpb190cmFuc3BvcnQgdmhvc3RfdHJhbnNwb3J0ID0g
ew0KIAkJLnN0cmVhbV9yY3ZoaXdhdCAgICAgICAgICA9IHZpcnRpb190cmFuc3BvcnRfc3RyZWFt
X3Jjdmhpd2F0LA0KIAkJLnN0cmVhbV9pc19hY3RpdmUgICAgICAgICA9IHZpcnRpb190cmFuc3Bv
cnRfc3RyZWFtX2lzX2FjdGl2ZSwNCiAJCS5zdHJlYW1fYWxsb3cgICAgICAgICAgICAgPSB2aXJ0
aW9fdHJhbnNwb3J0X3N0cmVhbV9hbGxvdywNCisJCS56ZXJvY29weV9kZXF1ZXVlCSAgPSB2aXJ0
aW9fdHJhbnNwb3J0X3plcm9jb3B5X2RlcXVldWUsDQorCQkucnhfemVyb2NvcHlfc2V0CSAgPSB2
aG9zdF90cmFuc3BvcnRfemVyb2NvcHlfc2V0LA0KKwkJLnJ4X3plcm9jb3B5X2dldAkgID0gdmhv
c3RfdHJhbnNwb3J0X3plcm9jb3B5X2dldCwNCiANCiAJCS5zZXFwYWNrZXRfZGVxdWV1ZSAgICAg
ICAgPSB2aXJ0aW9fdHJhbnNwb3J0X3NlcXBhY2tldF9kZXF1ZXVlLA0KIAkJLnNlcXBhY2tldF9l
bnF1ZXVlICAgICAgICA9IHZpcnRpb190cmFuc3BvcnRfc2VxcGFja2V0X2VucXVldWUsDQotLSAN
CjIuMjUuMQ0K
