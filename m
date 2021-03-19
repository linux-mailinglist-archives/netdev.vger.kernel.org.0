Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6163412CE
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhCSCZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhCSCZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 22:25:32 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B204C06174A;
        Thu, 18 Mar 2021 19:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=dud7ZgPnFjpKsyMcBWxyMBSTGH1CfYz0/tOv
        jH3yQXI=; b=Rq23B81ZdoX0Z1CueTdnW7OM8T/K9STeYpfLsz9dxQZg32rR/zt8
        b/2ZlFb7qdG8mMrGCNwOrNr/ufrXP3xk2iniwDB35h4RUtw1690ODL9xBaZYA36Z
        aoCDWJsA3bJEsbo5y49x5ZFkFJcHkZm6UAmV6L03W/FopF743rx7PkU=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Fri, 19 Mar
 2021 10:25:05 +0800 (GMT+08:00)
X-Originating-IP: [202.38.69.14]
Date:   Fri, 19 Mar 2021 10:25:05 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     "Lv Yunlong" <lyl2019@mail.ustc.edu.cn>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/rds: Fix a use after free in rds_message_map_pages
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
In-Reply-To: <20210311084616.12356-1-lyl2019@mail.ustc.edu.cn>
References: <20210311084616.12356-1-lyl2019@mail.ustc.edu.cn>
X-SendMailWithSms: false
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <22401612.2e0b.178484cf3b6.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygC3vU2CC1RgDmkAAA--.11W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQsFBlQhn5O5GgAAsT
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpKdXN0IGFzIGEgcmVtaW5kZXIsDQp0aGVyZSBoYXMgYmVlbiBubyByZXBseSB0byB0aGlzIG1l
c3NhZ2UgZm9yIG1vcmUgdGhhbiBhIHdlZWsuDQoNCkNvdWxkIHNvbWVvbmUgaGVscCB0byBmaXgg
dGhpcyBpc3N1ZT8NCg0KPiAtLS0tLeWOn+Wni+mCruS7ti0tLS0tDQo+IOWPkeS7tuS6ujogIkx2
IFl1bmxvbmciIDxseWwyMDE5QG1haWwudXN0Yy5lZHUuY24+DQo+IOWPkemAgeaXtumXtDogMjAy
MS0wMy0xMSAxNjo0NjoxNiAo5pif5pyf5ZubKQ0KPiDmlLbku7bkuro6IHNhbnRvc2guc2hpbGlt
a2FyQG9yYWNsZS5jb20sIGRhdmVtQGRhdmVtbG9mdC5uZXQsIGt1YmFAa2VybmVsLm9yZw0KPiDm
ioTpgIE6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcsIGxpbnV4LXJkbWFAdmdlci5rZXJuZWwub3Jn
LCByZHMtZGV2ZWxAb3NzLm9yYWNsZS5jb20sIGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcs
ICJMdiBZdW5sb25nIiA8bHlsMjAxOUBtYWlsLnVzdGMuZWR1LmNuPg0KPiDkuLvpopg6IFtQQVRD
SF0gbmV0L3JkczogRml4IGEgdXNlIGFmdGVyIGZyZWUgaW4gcmRzX21lc3NhZ2VfbWFwX3BhZ2Vz
DQo+IA0KPiBJbiByZHNfbWVzc2FnZV9tYXBfcGFnZXMsIHJkc19tZXNzYWdlX3B1dCgpIHdpbGwg
ZnJlZSBybS4NCj4gTWF5YmUgc3RvcmUgdGhlIHZhbHVlIG9mIHJtLT5kYXRhLm9wX3NnIGFoZWFk
IG9mIHJkc19tZXNzYWdlX3B1dCgpDQo+IGlzIGJldHRlci4gT3RoZXJ3aXNlIG90aGVyIHRocmVh
ZHMgY291bGQgYWxsb2NhdGUgdGhlIGZyZWVkIGNodW5rDQo+IGFuZCBtYXkgY2hhbmdlIHRoZSB2
YWx1ZSBvZiBybS0+ZGF0YS5vcF9zZy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEx2IFl1bmxvbmcg
PGx5bDIwMTlAbWFpbC51c3RjLmVkdS5jbj4NCj4gLS0tDQo+ICBuZXQvcmRzL21lc3NhZ2UuYyB8
IDMgKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L3Jkcy9tZXNzYWdlLmMgYi9uZXQvcmRzL21lc3NhZ2Uu
Yw0KPiBpbmRleCAwNzFhMjYxZmRhYWIuLjM5MmUzYTJmNDFhMCAxMDA2NDQNCj4gLS0tIGEvbmV0
L3Jkcy9tZXNzYWdlLmMNCj4gKysrIGIvbmV0L3Jkcy9tZXNzYWdlLmMNCj4gQEAgLTM0Nyw4ICsz
NDcsOSBAQCBzdHJ1Y3QgcmRzX21lc3NhZ2UgKnJkc19tZXNzYWdlX21hcF9wYWdlcyh1bnNpZ25l
ZCBsb25nICpwYWdlX2FkZHJzLCB1bnNpZ25lZCBpbg0KPiAgCXJtLT5kYXRhLm9wX25lbnRzID0g
RElWX1JPVU5EX1VQKHRvdGFsX2xlbiwgUEFHRV9TSVpFKTsNCj4gIAlybS0+ZGF0YS5vcF9zZyA9
IHJkc19tZXNzYWdlX2FsbG9jX3NncyhybSwgbnVtX3Nncyk7DQo+ICAJaWYgKElTX0VSUihybS0+
ZGF0YS5vcF9zZykpIHsNCj4gKwkJc3RydWN0IHNjYXR0ZXJsaXN0ICp0bXAgPSBybS0+ZGF0YS5v
cF9zZzsNCj4gIAkJcmRzX21lc3NhZ2VfcHV0KHJtKTsNCj4gLQkJcmV0dXJuIEVSUl9DQVNUKHJt
LT5kYXRhLm9wX3NnKTsNCj4gKwkJcmV0dXJuIEVSUl9DQVNUKHRtcCk7DQo+ICAJfQ0KPiAgDQo+
ICAJZm9yIChpID0gMDsgaSA8IHJtLT5kYXRhLm9wX25lbnRzOyArK2kpIHsNCj4gLS0gDQo+IDIu
MjUuMQ0KPiANCg==
