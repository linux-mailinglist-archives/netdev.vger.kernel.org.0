Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FE95994C7
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346508AbiHSFjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241985AbiHSFjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:39:54 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA19BFABC;
        Thu, 18 Aug 2022 22:39:53 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 4E9FF5FD07;
        Fri, 19 Aug 2022 08:39:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660887591;
        bh=R79+XidUY9g0x8il8JzWOIn3o41h8mogyFPGT9KZ2dk=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=DYgOFWe4A013wRMQmmiUgKTPVk1OGKBNjIEvLrykzGdIb5nAP3Z8VqRWZnOoiVIgB
         9INu0/yWirCu8ghVn/IgO5zit4HCIxgYVYLJ4k6RQR6I9boWLMzMusSnlYMIoJ2Ahs
         AUZDAUS62kCSCE5Orz6hNeabMd64uJQYSwdfEIGD44SAzRFDZcyhi5pnv1l5rg2av1
         hoNoGoRwh/EjL167FkvpnQYruswjjy/Z6U8mxsKJJDuEqXr9gOKdrLH5ewf3fbtK0c
         Ilk0SxYTNvoy+HS0bQmJp5DKp8KNO6Ju+MZ+C72kZDDnQdpGTJdJbNnGYUr5HHQ6i6
         PwPAkOOj40zbg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri, 19 Aug 2022 08:39:50 +0300 (MSK)
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
Subject: [PATCH net-next v4 7/9] virtio/vsock: check SO_RCVLOWAT before wake
 up reader
Thread-Topic: [PATCH net-next v4 7/9] virtio/vsock: check SO_RCVLOWAT before
 wake up reader
Thread-Index: AQHYs44KDFwnsmWHL0COnLpDuJnm+Q==
Date:   Fri, 19 Aug 2022 05:39:24 +0000
Message-ID: <696d5dfb-92a6-cd06-60d0-d9c953774226@sberdevices.ru>
In-Reply-To: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAC0646B010E2D44B62BE86754540C47@sberdevices.ru>
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

VGhpcyBhZGRzIGV4dHJhIGNvbmRpdGlvbiB0byB3YWtlIHVwIGRhdGEgcmVhZGVyOiBkbyBpdCBv
bmx5IHdoZW4gbnVtYmVyDQpvZiByZWFkYWJsZSBieXRlcyA+PSBTT19SQ1ZMT1dBVC4gT3RoZXJ3
aXNlLCB0aGVyZSBpcyBubyBzZW5zZSB0byBraWNrDQp1c2VyLGJlY2F1c2UgaXQgd2lsbCB3YWl0
IHVudGlsIFNPX1JDVkxPV0FUIGJ5dGVzIHdpbGwgYmUgZGVxdWV1ZWQuIFRoaXMNCmNoZWNrIGlz
IHBlcmZvcm1lZCBpbiB2c29ja19kYXRhX3JlYWR5KCkuDQoNClNpZ25lZC1vZmYtYnk6IEFyc2Vu
aXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KUmV2aWV3ZWQtYnk6IFN0ZWZh
bm8gR2FyemFyZWxsYSA8c2dhcnphcmVAcmVkaGF0LmNvbT4NCi0tLQ0KIG5ldC92bXdfdnNvY2sv
dmlydGlvX3RyYW5zcG9ydF9jb21tb24uYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svdmly
dGlvX3RyYW5zcG9ydF9jb21tb24uYyBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9j
b21tb24uYw0KaW5kZXggOGY2MzU2ZWJjZGQxLi4zNTg2MzEzMmY0ZjEgMTAwNjQ0DQotLS0gYS9u
ZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMNCisrKyBiL25ldC92bXdfdnNv
Y2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYw0KQEAgLTEwODEsNyArMTA4MSw3IEBAIHZpcnRp
b190cmFuc3BvcnRfcmVjdl9jb25uZWN0ZWQoc3RydWN0IHNvY2sgKnNrLA0KIAlzd2l0Y2ggKGxl
MTZfdG9fY3B1KHBrdC0+aGRyLm9wKSkgew0KIAljYXNlIFZJUlRJT19WU09DS19PUF9SVzoNCiAJ
CXZpcnRpb190cmFuc3BvcnRfcmVjdl9lbnF1ZXVlKHZzaywgcGt0KTsNCi0JCXNrLT5za19kYXRh
X3JlYWR5KHNrKTsNCisJCXZzb2NrX2RhdGFfcmVhZHkoc2spOw0KIAkJcmV0dXJuIGVycjsNCiAJ
Y2FzZSBWSVJUSU9fVlNPQ0tfT1BfQ1JFRElUX1JFUVVFU1Q6DQogCQl2aXJ0aW9fdHJhbnNwb3J0
X3NlbmRfY3JlZGl0X3VwZGF0ZSh2c2spOw0KLS0gDQoyLjI1LjENCg==
