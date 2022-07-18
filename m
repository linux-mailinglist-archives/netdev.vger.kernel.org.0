Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40EC7577D46
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 10:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbiGRIN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 04:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbiGRINw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 04:13:52 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F928B34;
        Mon, 18 Jul 2022 01:13:49 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 6E82C5FD02;
        Mon, 18 Jul 2022 11:13:45 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658132025;
        bh=K9t73VPQn1H7rzF6FDTeEbbZIPpEhYN+YhYt5OLk0eg=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=PFqZ48CnBylj1z/FTKdJ/Jp6iVsagp8hwbl5Gqslqw+Y+sxJ0WYuDkcdjUzz8wRKs
         5S5oAXp6iF4uUy9kxoAxe38d16BBNL3ZN8Y4a8fpzt0SI253PGI3IBLPCNFqhsRbcg
         t/bWorEz+to4y/FX38hDXILrYqRcjdSDJbjBYIsin0AN+3vUAxXwobZFboqSQZuQPG
         2EH2EjzpCWEcPIk81IGrOSgx0QnaspBWxynKFow6xqppcKL62TzfA9ksMUiEc2yseu
         0Ypn95pLHMwiQ2/58rdfAPeRtDTJPrZVB21B3rOJ+ULYfHsT2nRcTC4WPGq0hi8QY5
         AG1zPqDzD7vcQ==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Mon, 18 Jul 2022 11:13:41 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v1 0/3] virtio/vsock: use SO_RCVLOWAT to set
 POLLIN/POLLRDNORM
Thread-Topic: [RFC PATCH v1 0/3] virtio/vsock: use SO_RCVLOWAT to set
 POLLIN/POLLRDNORM
Thread-Index: AQHYmn4tqUccpAClwkSIQKaYrjmRMQ==
Date:   Mon, 18 Jul 2022 08:12:52 +0000
Message-ID: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC7CDBA78EB51146931911015FE707E9@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/07/18 02:31:00 #19923013
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCmR1cmluZyBteSBleHBlcmltZW50cyB3aXRoIHplcm9jb3B5IHJlY2VpdmUsIGkg
Zm91bmQsIHRoYXQgaW4gc29tZQ0KY2FzZXMsIHBvbGwoKSBpbXBsZW1lbnRhdGlvbiB2aW9sYXRl
cyBQT1NJWDogd2hlbiBzb2NrZXQgaGFzIG5vbi0NCmRlZmF1bHQgU09fUkNWTE9XQVQoZS5nLiBu
b3QgMSksIHBvbGwoKSB3aWxsIGFsd2F5cyBzZXQgUE9MTElOIGFuZA0KUE9MTFJETk9STSBiaXRz
IGluICdyZXZlbnRzJyBldmVuIG51bWJlciBvZiBieXRlcyBhdmFpbGFibGUgdG8gcmVhZA0Kb24g
c29ja2V0IGlzIHNtYWxsZXIgdGhhbiBTT19SQ1ZMT1dBVCB2YWx1ZS4gSW4gdGhpcyBjYXNlLHVz
ZXIgc2Vlcw0KUE9MTElOIGZsYWcgYW5kIHRoZW4gdHJpZXMgdG8gcmVhZCBkYXRhKGZvciBleGFt
cGxlIHVzaW5nICAncmVhZCgpJw0KY2FsbCksIGJ1dCByZWFkIGNhbGwgd2lsbCBiZSBibG9ja2Vk
LCBiZWNhdXNlICBTT19SQ1ZMT1dBVCBsb2dpYyBpcw0Kc3VwcG9ydGVkIGluIGRlcXVldWUgbG9v
cCBpbiBhZl92c29jay5jLiBCdXQgdGhlIHNhbWUgdGltZSwgIFBPU0lYDQpyZXF1aXJlcyB0aGF0
Og0KDQoiUE9MTElOICAgICBEYXRhIG90aGVyIHRoYW4gaGlnaC1wcmlvcml0eSBkYXRhIG1heSBi
ZSByZWFkIHdpdGhvdXQNCiAgICAgICAgICAgIGJsb2NraW5nLg0KIFBPTExSRE5PUk0gTm9ybWFs
IGRhdGEgbWF5IGJlIHJlYWQgd2l0aG91dCBibG9ja2luZy4iDQoNClNlZSBodHRwczovL3d3dy5v
cGVuLXN0ZC5vcmcvanRjMS9zYzIyL29wZW4vbjQyMTcucGRmLCBwYWdlIDI5My4NCg0KU28sIHdl
IGhhdmUsIHRoYXQgcG9sbCgpIHN5c2NhbGwgcmV0dXJucyBQT0xMSU4sIGJ1dCByZWFkIGNhbGwg
d2lsbA0KYmUgYmxvY2tlZC4NCg0KQWxzbyBpbiBtYW4gcGFnZSBzb2NrZXQoNykgaSBmb3VuZCB0
aGF0Og0KDQoiU2luY2UgTGludXggMi42LjI4LCBzZWxlY3QoMiksIHBvbGwoMiksIGFuZCBlcG9s
bCg3KSBpbmRpY2F0ZSBhDQpzb2NrZXQgYXMgcmVhZGFibGUgb25seSBpZiBhdCBsZWFzdCBTT19S
Q1ZMT1dBVCBieXRlcyBhcmUgYXZhaWxhYmxlLiINCg0KSSBjaGVja2VkIFRDUCBjYWxsYmFjayBm
b3IgcG9sbCgpKG5ldC9pcHY0L3RjcC5jLCB0Y3BfcG9sbCgpKSwgaXQNCnVzZXMgU09fUkNWTE9X
QVQgdmFsdWUgdG8gc2V0IFBPTExJTiBiaXQsIGFsc28gaSd2ZSB0ZXN0ZWQgVENQIHdpdGgNCnRo
aXMgY2FzZSBmb3IgVENQIHNvY2tldCwgaXQgd29ya3MgYXMgUE9TSVggcmVxdWlyZWQuDQoNCkkn
dmUgYWRkZWQgc29tZSBmaXhlcyB0byBhZl92c29jay5jIGFuZCB2aXJ0aW9fdHJhbnNwb3J0X2Nv
bW1vbi5jLA0KdGVzdCBpcyBhbHNvIGltcGxlbWVudGVkLg0KDQpXaGF0IGRvIFlvdSB0aGluayBn
dXlzPw0KDQpUaGFuayBZb3UNCg0KQXJzZW5peSBLcmFzbm92KDMpOg0KIHZzb2NrX3Rlc3Q6IFBP
TExJTiArIFNPX1JDVkxPV0FUIHRlc3QuDQogdmlydGlvL3Zzb2NrOiB1c2UgJ3RhcmdldCcgaW4g
bm90aWZ5X3BvbGxfaW4gY2FsbGJhY2suDQogdnNvY2s6IHVzZSBza19za3Jjdmxvd2F0IHRvIHNl
dCBQT0xMSU4sUE9MTFJETk9STSBiaXRzLg0KDQogbmV0L3Ztd192c29jay9hZl92c29jay5jICAg
ICAgICAgICAgICAgIHwgIDIgKy0NCiBuZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29t
bW9uLmMgfCAgMiArLQ0KIHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jICAgICAgICB8
IDkwICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KIDMgZmlsZXMgY2hhbmdlZCwg
OTIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjI1LjENCg==
