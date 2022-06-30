Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD6F561ECC
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbiF3PJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiF3PJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:09:01 -0400
Received: from azure-sdnproxy-3.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 8609E28E0F;
        Thu, 30 Jun 2022 08:08:59 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 30 Jun 2022 23:08:41
 +0800 (GMT+08:00)
X-Originating-IP: [221.192.178.120]
Date:   Thu, 30 Jun 2022 23:08:41 +0800 (GMT+08:00)
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
In-Reply-To: <CANn89iLda2oxoPQaGd9r8frAaOu1LqxmWYm2O8W4HXaGRN8tcQ@mail.gmail.com>
References: <20220630143842.24906-1-duoming@zju.edu.cn>
 <CANn89iLda2oxoPQaGd9r8frAaOu1LqxmWYm2O8W4HXaGRN8tcQ@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <bed69ee.1e8d9.181b528391c.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgC3COF6vL1iQgHiAg--.63195W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgARAVZdtaenFwABs6
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBUaHUsIDMwIEp1biAyMDIyIDE2OjQ0OjI5ICswMjAwIEVyaWMgRHVtYXpldCB3
cm90ZToKCj4gPiBUaGVyZSBhcmUgVUFGIGJ1Z3MgY2F1c2VkIGJ5IHJvc2VfdDB0aW1lcl9leHBp
cnkoKS4gVGhlCj4gPiByb290IGNhdXNlIGlzIHRoYXQgZGVsX3RpbWVyKCkgY291bGQgbm90IHN0
b3AgdGhlIHRpbWVyCj4gPiBoYW5kbGVyIHRoYXQgaXMgcnVubmluZyBhbmQgdGhlcmUgaXMgbm8g
c3luY2hyb25pemF0aW9uLgo+ID4gT25lIG9mIHRoZSByYWNlIGNvbmRpdGlvbnMgaXMgc2hvd24g
YmVsb3c6Cj4gPgo+ID4gICAgICh0aHJlYWQgMSkgICAgICAgICAgICAgfCAgICAgICAgKHRocmVh
ZCAyKQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfCByb3NlX2RldmljZV9ldmVudAo+
ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIHJvc2VfcnRfZGV2aWNlX2Rvd24KPiA+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgIHJvc2VfcmVtb3ZlX25laWdoCj4gPiBy
b3NlX3QwdGltZXJfZXhwaXJ5ICAgICAgICB8ICAgICAgIHJvc2Vfc3RvcF90MHRpbWVyKHJvc2Vf
bmVpZ2gpCj4gPiAgIC4uLiAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgZGVsX3RpbWVy
KCZuZWlnaC0+dDB0aW1lcikKPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAg
ICBrZnJlZShyb3NlX25laWdoKSAvL1sxXUZSRUUKPiA+ICAgbmVpZ2gtPmRjZV9tb2RlIC8vWzJd
VVNFIHwKPiA+Cj4gPiBUaGUgcm9zZV9uZWlnaCBpcyBkZWFsbG9jYXRlZCBpbiBwb3NpdGlvbiBb
MV0gYW5kIHVzZSBpbgo+ID4gcG9zaXRpb24gWzJdLgo+ID4KPiA+IFRoZSBjcmFzaCB0cmFjZSB0
cmlnZ2VyZWQgYnkgUE9DIGlzIGxpa2UgYmVsb3c6Cj4gPgo+ID4gQlVHOiBLQVNBTjogdXNlLWFm
dGVyLWZyZWUgaW4gZXhwaXJlX3RpbWVycysweDE0NC8weDMyMAo+ID4gV3JpdGUgb2Ygc2l6ZSA4
IGF0IGFkZHIgZmZmZjg4ODAwOWIxOTY1OCBieSB0YXNrIHN3YXBwZXIvMC8wCj4gPiAuLi4KPiA+
IENhbGwgVHJhY2U6Cj4gPiAgPElSUT4KPiA+ICBkdW1wX3N0YWNrX2x2bCsweGJmLzB4ZWUKPiA+
ICBwcmludF9hZGRyZXNzX2Rlc2NyaXB0aW9uKzB4N2IvMHg0NDAKPiA+ICBwcmludF9yZXBvcnQr
MHgxMDEvMHgyMzAKPiA+ICA/IGV4cGlyZV90aW1lcnMrMHgxNDQvMHgzMjAKPiA+ICBrYXNhbl9y
ZXBvcnQrMHhlZC8weDEyMAo+ID4gID8gZXhwaXJlX3RpbWVycysweDE0NC8weDMyMAo+ID4gIGV4
cGlyZV90aW1lcnMrMHgxNDQvMHgzMjAKPiA+ICBfX3J1bl90aW1lcnMrMHgzZmYvMHg0ZDAKPiA+
ICBydW5fdGltZXJfc29mdGlycSsweDQxLzB4ODAKPiA+ICBfX2RvX3NvZnRpcnErMHgyMzMvMHg1
NDQKPiA+ICAuLi4KPiA+Cj4gPiBUaGlzIHBhdGNoIGNoYW5nZXMgZGVsX3RpbWVyKCkgaW4gcm9z
ZV9zdG9wX3QwdGltZXIoKSBhbmQKPiA+IHJvc2Vfc3RvcF9mdGltZXIoKSB0byBkZWxfdGltZXJf
c3luYygpIGluIG9yZGVyIHRoYXQgdGhlCj4gPiB0aW1lciBoYW5kbGVyIGNvdWxkIGJlIGZpbmlz
aGVkIGJlZm9yZSB0aGUgcmVzb3VyY2VzIHN1Y2ggYXMKPiA+IHJvc2VfbmVpZ2ggYW5kIHNvIG9u
IGFyZSBkZWFsbG9jYXRlZC4gQXMgYSByZXN1bHQsIHRoZSBVQUYKPiA+IGJ1Z3MgY291bGQgYmUg
bWl0aWdhdGVkLgo+ID4KPiA+IEZpeGVzOiAxZGExNzdlNGMzZjQgKCJMaW51eC0yLjYuMTItcmMy
IikKPiA+IFNpZ25lZC1vZmYtYnk6IER1b21pbmcgWmhvdSA8ZHVvbWluZ0B6anUuZWR1LmNuPgo+
ID4gLS0tCj4gPiAgbmV0L3Jvc2Uvcm9zZV9saW5rLmMgfCA0ICsrLS0KPiA+ICAxIGZpbGUgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+ID4KPiA+IGRpZmYgLS1naXQg
YS9uZXQvcm9zZS9yb3NlX2xpbmsuYyBiL25ldC9yb3NlL3Jvc2VfbGluay5jCj4gPiBpbmRleCA4
Yjk2YTU2ZDNhNC4uOTczNGQxMjY0ZGUgMTAwNjQ0Cj4gPiAtLS0gYS9uZXQvcm9zZS9yb3NlX2xp
bmsuYwo+ID4gKysrIGIvbmV0L3Jvc2Uvcm9zZV9saW5rLmMKPiA+IEBAIC01NCwxMiArNTQsMTIg
QEAgc3RhdGljIHZvaWQgcm9zZV9zdGFydF90MHRpbWVyKHN0cnVjdCByb3NlX25laWdoICpuZWln
aCkKPiA+Cj4gPiAgdm9pZCByb3NlX3N0b3BfZnRpbWVyKHN0cnVjdCByb3NlX25laWdoICpuZWln
aCkKPiA+ICB7Cj4gPiAtICAgICAgIGRlbF90aW1lcigmbmVpZ2gtPmZ0aW1lcik7Cj4gPiArICAg
ICAgIGRlbF90aW1lcl9zeW5jKCZuZWlnaC0+ZnRpbWVyKTsKPiA+ICB9Cj4gCj4gQXJlIHlvdSBz
dXJlIHRoaXMgaXMgc2FmZSA/Cj4gCj4gZGVsX3RpbWVyX3N5bmMoKSBjb3VsZCBoYW5nIGlmIHRo
ZSBjYWxsZXIgaG9sZHMgYSBsb2NrIHRoYXQgdGhlIHRpbWVyCj4gZnVuY3Rpb24gd291bGQgbmVl
ZCB0byBhY3F1aXJlLgoKSSB0aGluayB0aGlzIGlzIHNhZmUuIFRoZSByb3NlX2Z0aW1lcl9leHBp
cnkoKSBpcyBhbiBlbXB0eSBmdW5jdGlvbiB0aGF0IGlzCnNob3duIGJlbG93OgoKc3RhdGljIHZv
aWQgcm9zZV9mdGltZXJfZXhwaXJ5KHN0cnVjdCB0aW1lcl9saXN0ICp0KQp7Cn0KCj4gPgo+ID4g
IHZvaWQgcm9zZV9zdG9wX3QwdGltZXIoc3RydWN0IHJvc2VfbmVpZ2ggKm5laWdoKQo+ID4gIHsK
PiA+IC0gICAgICAgZGVsX3RpbWVyKCZuZWlnaC0+dDB0aW1lcik7Cj4gPiArICAgICAgIGRlbF90
aW1lcl9zeW5jKCZuZWlnaC0+dDB0aW1lcik7Cj4gPiAgfQo+IAo+IFNhbWUgaGVyZSwgcGxlYXNl
IGV4cGxhaW4gd2h5IGl0IGlzIHNhZmUuCgpUaGUgcm9zZV9zdG9wX3QwdGltZXIoKSBtYXkgaG9s
ZCAicm9zZV9ub2RlX2xpc3RfbG9jayIgYW5kICJyb3NlX25laWdoX2xpc3RfbG9jayIsCmJ1dCB0
aGUgdGltZXIgaGFuZGxlciByb3NlX3QwdGltZXJfZXhwaXJ5KCkgdGhhdCBpcyBzaG93biBiZWxv
dyBkb2VzIG5vdCBuZWVkCnRoZXNlIHR3byBsb2Nrcy4KCnN0YXRpYyB2b2lkIHJvc2VfdDB0aW1l
cl9leHBpcnkoc3RydWN0IHRpbWVyX2xpc3QgKnQpCnsKCXN0cnVjdCByb3NlX25laWdoICpuZWln
aCA9IGZyb21fdGltZXIobmVpZ2gsIHQsIHQwdGltZXIpOwoKCXJvc2VfdHJhbnNtaXRfcmVzdGFy
dF9yZXF1ZXN0KG5laWdoKTsKCgluZWlnaC0+ZGNlX21vZGUgPSAwOwoKCXJvc2Vfc3RhcnRfdDB0
aW1lcihuZWlnaCk7Cn0KCkJlc3QgcmVnYXJkcywKRHVvbWluZyBaaG91
