Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C451059948A
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346350AbiHSFcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245231AbiHSFcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:32:13 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4D7E0975;
        Thu, 18 Aug 2022 22:32:11 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id A94B95FD07;
        Fri, 19 Aug 2022 08:32:09 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660887129;
        bh=MffpD9Q67yZWb6PgCIyam3kH6wvkxNCaMLYOrl7CGq8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=mme8nP1o+/ascBxNJ4jhAn7Fj39ob5cI+lmJKiVV9jcbIL98MV2Px4GBdTCY2EByt
         n1wDJ4JVzE5yoDycecadk23+nN5TcXy8+MK9q5ER47YuL4YJqvVydRa1wqNXRy54JN
         jUcejNF0+uB7Gli2t6CcuV/QxnugvhPH8f7reOVjH35xHLAPBG3Y898HBs+OU7ipnh
         uTR3h2RcS7NkbU/QQ+OivHQx+uj7auWmMpBjaDBtEY8fNv4dqVUgsYxHEm6MTwYxRU
         jqQCGNhiv/WiThnFH+pc+mSWFu9aVApHflYqeNFEqiarkQK5povwnTQu7m4L/lzqsG
         duHFfGEzeUTUg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri, 19 Aug 2022 08:32:08 +0300 (MSK)
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
Subject: [PATCH net-next v4 4/9] vmci/vsock: use 'target' in notify_poll_in
 callback
Thread-Topic: [PATCH net-next v4 4/9] vmci/vsock: use 'target' in
 notify_poll_in callback
Thread-Index: AQHYs4z3iUPUdUWzCECKsbhSpky0eg==
Date:   Fri, 19 Aug 2022 05:31:43 +0000
Message-ID: <804cdfe1-44c7-33f8-3cc6-49107d1b6998@sberdevices.ru>
In-Reply-To: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <22CE547177774447B03005A61D2A48FE@sberdevices.ru>
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

VGhpcyBjYWxsYmFjayBjb250cm9scyBzZXR0aW5nIG9mIFBPTExJTiwgUE9MTFJETk9STSBvdXRw
dXQgYml0cyBvZiBwb2xsKCkNCnN5c2NhbGwsIGJ1dCBpbiBzb21lIGNhc2VzLCBpdCBpcyBpbmNv
cnJlY3RseSB0byBzZXQgaXQsIHdoZW4gc29ja2V0IGhhcw0KYXQgbGVhc3QgMSBieXRlcyBvZiBh
dmFpbGFibGUgZGF0YS4gVXNlICd0YXJnZXQnIHdoaWNoIGlzIGFscmVhZHkgZXhpc3RzLg0KDQpT
aWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4N
ClJldmlld2VkLWJ5OiBTdGVmYW5vIEdhcnphcmVsbGEgPHNnYXJ6YXJlQHJlZGhhdC5jb20+DQpS
ZXZpZXdlZC1ieTogVmlzaG51IERhc2EgPHZkYXNhQHZtd2FyZS5jb20+DQotLS0NCiBuZXQvdm13
X3Zzb2NrL3ZtY2lfdHJhbnNwb3J0X25vdGlmeS5jICAgICAgICB8IDggKysrKy0tLS0NCiBuZXQv
dm13X3Zzb2NrL3ZtY2lfdHJhbnNwb3J0X25vdGlmeV9xc3RhdGUuYyB8IDggKysrKy0tLS0NCiAy
IGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5LmMgYi9uZXQvdm13X3Zz
b2NrL3ZtY2lfdHJhbnNwb3J0X25vdGlmeS5jDQppbmRleCBkNjlmYzRiNTk1YWQuLjg1MjA5N2Uy
YjllNiAxMDA2NDQNCi0tLSBhL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5LmMN
CisrKyBiL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5LmMNCkBAIC0zNDAsMTIg
KzM0MCwxMiBAQCB2bWNpX3RyYW5zcG9ydF9ub3RpZnlfcGt0X3BvbGxfaW4oc3RydWN0IHNvY2sg
KnNrLA0KIHsNCiAJc3RydWN0IHZzb2NrX3NvY2sgKnZzayA9IHZzb2NrX3NrKHNrKTsNCiANCi0J
aWYgKHZzb2NrX3N0cmVhbV9oYXNfZGF0YSh2c2spKSB7DQorCWlmICh2c29ja19zdHJlYW1faGFz
X2RhdGEodnNrKSA+PSB0YXJnZXQpIHsNCiAJCSpkYXRhX3JlYWR5X25vdyA9IHRydWU7DQogCX0g
ZWxzZSB7DQotCQkvKiBXZSBjYW4ndCByZWFkIHJpZ2h0IG5vdyBiZWNhdXNlIHRoZXJlIGlzIG5v
dGhpbmcgaW4gdGhlDQotCQkgKiBxdWV1ZS4gQXNrIGZvciBub3RpZmljYXRpb25zIHdoZW4gdGhl
cmUgaXMgc29tZXRoaW5nIHRvDQotCQkgKiByZWFkLg0KKwkJLyogV2UgY2FuJ3QgcmVhZCByaWdo
dCBub3cgYmVjYXVzZSB0aGVyZSBpcyBub3QgZW5vdWdoIGRhdGENCisJCSAqIGluIHRoZSBxdWV1
ZS4gQXNrIGZvciBub3RpZmljYXRpb25zIHdoZW4gdGhlcmUgaXMgc29tZXRoaW5nDQorCQkgKiB0
byByZWFkLg0KIAkJICovDQogCQlpZiAoc2stPnNrX3N0YXRlID09IFRDUF9FU1RBQkxJU0hFRCkg
ew0KIAkJCWlmICghc2VuZF93YWl0aW5nX3JlYWQoc2ssIDEpKQ0KZGlmZiAtLWdpdCBhL25ldC92
bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5X3FzdGF0ZS5jIGIvbmV0L3Ztd192c29jay92
bWNpX3RyYW5zcG9ydF9ub3RpZnlfcXN0YXRlLmMNCmluZGV4IDBmMzZkN2M0NWRiMy4uMTJmMGNi
OGZlOTk4IDEwMDY0NA0KLS0tIGEvbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnlf
cXN0YXRlLmMNCisrKyBiL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5X3FzdGF0
ZS5jDQpAQCAtMTYxLDEyICsxNjEsMTIgQEAgdm1jaV90cmFuc3BvcnRfbm90aWZ5X3BrdF9wb2xs
X2luKHN0cnVjdCBzb2NrICpzaywNCiB7DQogCXN0cnVjdCB2c29ja19zb2NrICp2c2sgPSB2c29j
a19zayhzayk7DQogDQotCWlmICh2c29ja19zdHJlYW1faGFzX2RhdGEodnNrKSkgew0KKwlpZiAo
dnNvY2tfc3RyZWFtX2hhc19kYXRhKHZzaykgPj0gdGFyZ2V0KSB7DQogCQkqZGF0YV9yZWFkeV9u
b3cgPSB0cnVlOw0KIAl9IGVsc2Ugew0KLQkJLyogV2UgY2FuJ3QgcmVhZCByaWdodCBub3cgYmVj
YXVzZSB0aGVyZSBpcyBub3RoaW5nIGluIHRoZQ0KLQkJICogcXVldWUuIEFzayBmb3Igbm90aWZp
Y2F0aW9ucyB3aGVuIHRoZXJlIGlzIHNvbWV0aGluZyB0bw0KLQkJICogcmVhZC4NCisJCS8qIFdl
IGNhbid0IHJlYWQgcmlnaHQgbm93IGJlY2F1c2UgdGhlcmUgaXMgbm90IGVub3VnaCBkYXRhDQor
CQkgKiBpbiB0aGUgcXVldWUuIEFzayBmb3Igbm90aWZpY2F0aW9ucyB3aGVuIHRoZXJlIGlzIHNv
bWV0aGluZw0KKwkJICogdG8gcmVhZC4NCiAJCSAqLw0KIAkJaWYgKHNrLT5za19zdGF0ZSA9PSBU
Q1BfRVNUQUJMSVNIRUQpDQogCQkJdnNvY2tfYmxvY2tfdXBkYXRlX3dyaXRlX3dpbmRvdyhzayk7
DQotLSANCjIuMjUuMQ0K
