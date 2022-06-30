Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B059561FB4
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbiF3Pvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234996AbiF3Pvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:51:41 -0400
Received: from azure-sdnproxy-1.icoremail.net (azure-sdnproxy.icoremail.net [52.237.72.81])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 5356235851;
        Thu, 30 Jun 2022 08:51:36 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 30 Jun 2022 23:51:21
 +0800 (GMT+08:00)
X-Originating-IP: [221.192.178.120]
Date:   Thu, 30 Jun 2022 23:51:21 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Eric Dumazet" <edumazet@google.com>
Cc:     linux-hams@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David Miller" <davem@davemloft.net>,
        "Ralf Baechle" <ralf@linux-mips.org>
Subject: Re: [PATCH net] net: rose: fix UAF bug caused by
 rose_t0timer_expiry
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <CANn89iKo-uuF-iQWrfL=pgMu7bEakWHPDAVuLvT-TZ4AujiD=w@mail.gmail.com>
References: <20220630143842.24906-1-duoming@zju.edu.cn>
 <CANn89iLda2oxoPQaGd9r8frAaOu1LqxmWYm2O8W4HXaGRN8tcQ@mail.gmail.com>
 <bed69ee.1e8d9.181b528391c.Coremail.duoming@zju.edu.cn>
 <CANn89iKo-uuF-iQWrfL=pgMu7bEakWHPDAVuLvT-TZ4AujiD=w@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <55ffc892.1ea21.181b54f4b2f.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgC3PiF6xr1izobiAg--.64601W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgoRAVZdtaeongAAs3
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBUaHUsIDMwIEp1biAyMDIyIDE3OjE3OjEwICswMjAwIEVyaWMgRHVtYXpldCB3
cm90ZToKCj4gPiA+ID4gVGhlcmUgYXJlIFVBRiBidWdzIGNhdXNlZCBieSByb3NlX3QwdGltZXJf
ZXhwaXJ5KCkuIFRoZQo+ID4gPiA+IHJvb3QgY2F1c2UgaXMgdGhhdCBkZWxfdGltZXIoKSBjb3Vs
ZCBub3Qgc3RvcCB0aGUgdGltZXIKPiA+ID4gPiBoYW5kbGVyIHRoYXQgaXMgcnVubmluZyBhbmQg
dGhlcmUgaXMgbm8gc3luY2hyb25pemF0aW9uLgo+ID4gPiA+IE9uZSBvZiB0aGUgcmFjZSBjb25k
aXRpb25zIGlzIHNob3duIGJlbG93Ogo+ID4gPiA+Cj4gPiA+ID4gICAgICh0aHJlYWQgMSkgICAg
ICAgICAgICAgfCAgICAgICAgKHRocmVhZCAyKQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgcm9zZV9kZXZpY2VfZXZlbnQKPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB8ICAgcm9zZV9ydF9kZXZpY2VfZG93bgo+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgICAgIHJvc2VfcmVtb3ZlX25laWdoCj4gPiA+ID4gcm9zZV90MHRpbWVyX2V4cGly
eSAgICAgICAgfCAgICAgICByb3NlX3N0b3BfdDB0aW1lcihyb3NlX25laWdoKQo+ID4gPiA+ICAg
Li4uICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICBkZWxfdGltZXIoJm5laWdoLT50MHRp
bWVyKQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICBrZnJlZShy
b3NlX25laWdoKSAvL1sxXUZSRUUKPiA+ID4gPiAgIG5laWdoLT5kY2VfbW9kZSAvL1syXVVTRSB8
Cj4gPiA+ID4KPiA+ID4gPiBUaGUgcm9zZV9uZWlnaCBpcyBkZWFsbG9jYXRlZCBpbiBwb3NpdGlv
biBbMV0gYW5kIHVzZSBpbgo+ID4gPiA+IHBvc2l0aW9uIFsyXS4KPiA+ID4gPgo+ID4gPiA+IFRo
ZSBjcmFzaCB0cmFjZSB0cmlnZ2VyZWQgYnkgUE9DIGlzIGxpa2UgYmVsb3c6Cj4gPiA+ID4KPiA+
ID4gPiBCVUc6IEtBU0FOOiB1c2UtYWZ0ZXItZnJlZSBpbiBleHBpcmVfdGltZXJzKzB4MTQ0LzB4
MzIwCj4gPiA+ID4gV3JpdGUgb2Ygc2l6ZSA4IGF0IGFkZHIgZmZmZjg4ODAwOWIxOTY1OCBieSB0
YXNrIHN3YXBwZXIvMC8wCj4gPiA+ID4gLi4uCj4gPiA+ID4gQ2FsbCBUcmFjZToKPiA+ID4gPiAg
PElSUT4KPiA+ID4gPiAgZHVtcF9zdGFja19sdmwrMHhiZi8weGVlCj4gPiA+ID4gIHByaW50X2Fk
ZHJlc3NfZGVzY3JpcHRpb24rMHg3Yi8weDQ0MAo+ID4gPiA+ICBwcmludF9yZXBvcnQrMHgxMDEv
MHgyMzAKPiA+ID4gPiAgPyBleHBpcmVfdGltZXJzKzB4MTQ0LzB4MzIwCj4gPiA+ID4gIGthc2Fu
X3JlcG9ydCsweGVkLzB4MTIwCj4gPiA+ID4gID8gZXhwaXJlX3RpbWVycysweDE0NC8weDMyMAo+
ID4gPiA+ICBleHBpcmVfdGltZXJzKzB4MTQ0LzB4MzIwCj4gPiA+ID4gIF9fcnVuX3RpbWVycysw
eDNmZi8weDRkMAo+ID4gPiA+ICBydW5fdGltZXJfc29mdGlycSsweDQxLzB4ODAKPiA+ID4gPiAg
X19kb19zb2Z0aXJxKzB4MjMzLzB4NTQ0Cj4gPiA+ID4gIC4uLgo+ID4gPiA+Cj4gPiA+ID4gVGhp
cyBwYXRjaCBjaGFuZ2VzIGRlbF90aW1lcigpIGluIHJvc2Vfc3RvcF90MHRpbWVyKCkgYW5kCj4g
PiA+ID4gcm9zZV9zdG9wX2Z0aW1lcigpIHRvIGRlbF90aW1lcl9zeW5jKCkgaW4gb3JkZXIgdGhh
dCB0aGUKPiA+ID4gPiB0aW1lciBoYW5kbGVyIGNvdWxkIGJlIGZpbmlzaGVkIGJlZm9yZSB0aGUg
cmVzb3VyY2VzIHN1Y2ggYXMKPiA+ID4gPiByb3NlX25laWdoIGFuZCBzbyBvbiBhcmUgZGVhbGxv
Y2F0ZWQuIEFzIGEgcmVzdWx0LCB0aGUgVUFGCj4gPiA+ID4gYnVncyBjb3VsZCBiZSBtaXRpZ2F0
ZWQuCj4gPiA+ID4KPiA+ID4gPiBGaXhlczogMWRhMTc3ZTRjM2Y0ICgiTGludXgtMi42LjEyLXJj
MiIpCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogRHVvbWluZyBaaG91IDxkdW9taW5nQHpqdS5lZHUu
Y24+Cj4gPiA+ID4gLS0tCj4gPiA+ID4gIG5ldC9yb3NlL3Jvc2VfbGluay5jIHwgNCArKy0tCj4g
PiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4g
PiA+ID4KPiA+ID4gPiBkaWZmIC0tZ2l0IGEvbmV0L3Jvc2Uvcm9zZV9saW5rLmMgYi9uZXQvcm9z
ZS9yb3NlX2xpbmsuYwo+ID4gPiA+IGluZGV4IDhiOTZhNTZkM2E0Li45NzM0ZDEyNjRkZSAxMDA2
NDQKPiA+ID4gPiAtLS0gYS9uZXQvcm9zZS9yb3NlX2xpbmsuYwo+ID4gPiA+ICsrKyBiL25ldC9y
b3NlL3Jvc2VfbGluay5jCj4gPiA+ID4gQEAgLTU0LDEyICs1NCwxMiBAQCBzdGF0aWMgdm9pZCBy
b3NlX3N0YXJ0X3QwdGltZXIoc3RydWN0IHJvc2VfbmVpZ2ggKm5laWdoKQo+ID4gPiA+Cj4gPiA+
ID4gIHZvaWQgcm9zZV9zdG9wX2Z0aW1lcihzdHJ1Y3Qgcm9zZV9uZWlnaCAqbmVpZ2gpCj4gPiA+
ID4gIHsKPiA+ID4gPiAtICAgICAgIGRlbF90aW1lcigmbmVpZ2gtPmZ0aW1lcik7Cj4gPiA+ID4g
KyAgICAgICBkZWxfdGltZXJfc3luYygmbmVpZ2gtPmZ0aW1lcik7Cj4gPiA+ID4gIH0KPiA+ID4K
PiA+ID4gQXJlIHlvdSBzdXJlIHRoaXMgaXMgc2FmZSA/Cj4gPiA+Cj4gPiA+IGRlbF90aW1lcl9z
eW5jKCkgY291bGQgaGFuZyBpZiB0aGUgY2FsbGVyIGhvbGRzIGEgbG9jayB0aGF0IHRoZSB0aW1l
cgo+ID4gPiBmdW5jdGlvbiB3b3VsZCBuZWVkIHRvIGFjcXVpcmUuCj4gPgo+ID4gSSB0aGluayB0
aGlzIGlzIHNhZmUuIFRoZSByb3NlX2Z0aW1lcl9leHBpcnkoKSBpcyBhbiBlbXB0eSBmdW5jdGlv
biB0aGF0IGlzCj4gPiBzaG93biBiZWxvdzoKPiA+Cj4gPiBzdGF0aWMgdm9pZCByb3NlX2Z0aW1l
cl9leHBpcnkoc3RydWN0IHRpbWVyX2xpc3QgKnQpCj4gPiB7Cj4gPiB9Cj4gPgo+ID4gPiA+Cj4g
PiA+ID4gIHZvaWQgcm9zZV9zdG9wX3QwdGltZXIoc3RydWN0IHJvc2VfbmVpZ2ggKm5laWdoKQo+
ID4gPiA+ICB7Cj4gPiA+ID4gLSAgICAgICBkZWxfdGltZXIoJm5laWdoLT50MHRpbWVyKTsKPiA+
ID4gPiArICAgICAgIGRlbF90aW1lcl9zeW5jKCZuZWlnaC0+dDB0aW1lcik7Cj4gPiA+ID4gIH0K
PiA+ID4KPiA+ID4gU2FtZSBoZXJlLCBwbGVhc2UgZXhwbGFpbiB3aHkgaXQgaXMgc2FmZS4KPiA+
Cj4gPiBUaGUgcm9zZV9zdG9wX3QwdGltZXIoKSBtYXkgaG9sZCAicm9zZV9ub2RlX2xpc3RfbG9j
ayIgYW5kICJyb3NlX25laWdoX2xpc3RfbG9jayIsCj4gPiBidXQgdGhlIHRpbWVyIGhhbmRsZXIg
cm9zZV90MHRpbWVyX2V4cGlyeSgpIHRoYXQgaXMgc2hvd24gYmVsb3cgZG9lcyBub3QgbmVlZAo+
ID4gdGhlc2UgdHdvIGxvY2tzLgo+ID4KPiA+IHN0YXRpYyB2b2lkIHJvc2VfdDB0aW1lcl9leHBp
cnkoc3RydWN0IHRpbWVyX2xpc3QgKnQpCj4gPiB7Cj4gPiAgICAgICAgIHN0cnVjdCByb3NlX25l
aWdoICpuZWlnaCA9IGZyb21fdGltZXIobmVpZ2gsIHQsIHQwdGltZXIpOwo+ID4KPiA+ICAgICAg
ICAgcm9zZV90cmFuc21pdF9yZXN0YXJ0X3JlcXVlc3QobmVpZ2gpOwo+ID4KPiA+ICAgICAgICAg
bmVpZ2gtPmRjZV9tb2RlID0gMDsKPiA+Cj4gPiAgICAgICAgIHJvc2Vfc3RhcnRfdDB0aW1lcihu
ZWlnaCk7Cj4gCj4gVGhpcyB3aWxsIHJlYXJtIHRoZSB0aW1lci4gIGRlbF90aW1lcl9zeW5jKCkg
d2lsbCBub3QgaGVscC4KClRoYW5rIHlvdSBmb3IgeW91ciB0aW1lLCBidXQgSSBkb24ndCB0aGlu
ayBzby4KCj4gUGxlYXNlIHJlYWQgdGhlIGNvbW1lbnQgaW4gZnJvbnQgb2YgZGVsX3RpbWVyX3N5
bmMoKSwgaW4ga2VybmVsL3RpbWUvdGltZXIuYwoKSSB3cm90ZSBhIGtlcm5lbCBtb2R1bGUgdG8g
dGVzdCB3aGV0aGVyIGRlbF90aW1lcl9zeW5jKCkgY291bGQgZmluaXNoIGEgdGltZXIgaGFuZGxl
cgp0aGF0IHVzZSBtb2RfdGltZXIoKSB0byByZXdpbmQgaXRzZWxmLiBUaGUgZm9sbG93aW5nIGlz
IHRoZSByZXN1bHQuCgojIGluc21vZCBkZWxfdGltZXJfc3luYy5rbyAKWyAgOTI5LjM3NDQwNV0g
bXlfdGltZXIgd2lsbCBiZSBjcmVhdGUuClsgIDkyOS4zNzQ3MzhdIHRoZSBqaWZmaWVzIGlzIDo0
Mjk1NTk1NTcyClsgIDkzMC40MTE1ODFdIEluIG15X3RpbWVyX2Z1bmN0aW9uClsgIDkzMC40MTE5
NTZdIHRoZSBqaWZmaWVzIGlzIDQyOTU1OTY2MDkKWyAgOTM1LjQ2NjY0M10gSW4gbXlfdGltZXJf
ZnVuY3Rpb24KWyAgOTM1LjQ2NzUwNV0gdGhlIGppZmZpZXMgaXMgNDI5NTYwMTY2NQpbICA5NDAu
NTg2NTM4XSBJbiBteV90aW1lcl9mdW5jdGlvbgpbICA5NDAuNTg2OTE2XSB0aGUgamlmZmllcyBp
cyA0Mjk1NjA2Nzg0ClsgIDk0NS43MDY1NzldIEluIG15X3RpbWVyX2Z1bmN0aW9uClsgIDk0NS43
MDY4ODVdIHRoZSBqaWZmaWVzIGlzIDQyOTU2MTE5MDQKCiMgCiMgcm1tb2QgZGVsX3RpbWVyX3N5
bmMua28KWyAgOTQ4LjUwNzY5Ml0gdGhlIGRlbF90aW1lcl9zeW5jIGlzIDoxClsgIDk0OC41MDc2
OTJdIAojIAojIAoKVGhlIHJlc3VsdCBvZiB0aGUgZXhwZXJpbWVudCBzaG93cyB0aGF0IHRoZSB0
aW1lciBoYW5kbGVyIGNvdWxkCmJlIGtpbGxlZCBhZnRlciB3ZSBleGVjdXRlIGRlbF90aW1lcl9z
eW5jKCksIGV2ZW4gaWYgdGhlIHRpbWVyIGNvdWxkCnJld2luZCBpdHNlbGYuCgpCZXN0IHJlZ2Fy
ZHMsCkR1b21pbmcgWmhvdQ==
