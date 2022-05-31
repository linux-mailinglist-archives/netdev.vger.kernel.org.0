Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE875538C46
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 09:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244658AbiEaHvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 03:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbiEaHu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 03:50:56 -0400
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 2B6F322B07;
        Tue, 31 May 2022 00:50:51 -0700 (PDT)
Received: by ajax-webmail-mail-app2 (Coremail) ; Tue, 31 May 2022 15:50:38
 +0800 (GMT+08:00)
X-Originating-IP: [106.117.80.109]
Date:   Tue, 31 May 2022 15:50:38 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Kalle Valo" <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, pontus.fuchs@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless] ar5523: Fix deadlock bugs caused by
 cancel_work_sync in ar5523_stop
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <877d63uuuj.fsf@kernel.org>
References: <20220522133055.96405-1-duoming@zju.edu.cn>
 <877d63uuuj.fsf@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <666661b7.4331b.18119186503.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgDH3EDOyJVidrcTAQ--.25771W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgIHAVZdtZ+JzwABsg
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBNb24sIDMwIE1heSAyMDIyIDE0OjI0OjA0ICswMzAwIEthbGxlIFZhbG8gd3Jv
dGU6Cgo+IER1b21pbmcgWmhvdSA8ZHVvbWluZ0B6anUuZWR1LmNuPiB3cml0ZXM6Cj4gCj4gPiBJ
ZiB0aGUgd29yayBpdGVtIGlzIHJ1bm5pbmcsIHRoZSBjYW5jZWxfd29ya19zeW5jIGluIGFyNTUy
M19zdG9wIHdpbGwKPiA+IG5vdCByZXR1cm4gdW50aWwgd29yayBpdGVtIGlzIGZpbmlzaGVkLiBJ
ZiB3ZSBob2xkIG11dGV4X2xvY2sgYW5kIHVzZQo+ID4gY2FuY2VsX3dvcmtfc3luYyB0byB3YWl0
IHRoZSB3b3JrIGl0ZW0gdG8gZmluaXNoLCB0aGUgd29yayBpdGVtIHN1Y2ggYXMKPiA+IGFyNTUy
M190eF93ZF93b3JrIGFuZCBhcjU1MjNfdHhfd29yayBhbHNvIHJlcXVpcmUgbXV0ZXhfbG9jay4g
QXMgYSByZXN1bHQsCj4gPiB0aGUgYXI1NTIzX3N0b3Agd2lsbCBiZSBibG9ja2VkIGZvcmV2ZXIu
IE9uZSBvZiB0aGUgcmFjZSBjb25kaXRpb25zIGlzCj4gPiBzaG93biBiZWxvdzoKPiA+Cj4gPiAg
ICAgKFRocmVhZCAxKSAgICAgICAgICAgICB8ICAgKFRocmVhZCAyKQo+ID4gYXI1NTIzX3N0b3Ag
ICAgICAgICAgICAgICAgfAo+ID4gICBtdXRleF9sb2NrKCZhci0+bXV0ZXgpICAgfCBhcjU1MjNf
dHhfd2Rfd29yawo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIG11dGV4X2xvY2so
JmFyLT5tdXRleCkKPiA+ICAgY2FuY2VsX3dvcmtfc3luYyAgICAgICAgIHwgICAuLi4KPiA+Cj4g
PiBUaGlzIHBhdGNoIG1vdmVzIGNhbmNlbF93b3JrX3N5bmMgb3V0IG9mIG11dGV4X2xvY2sgaW4g
b3JkZXIgdG8gbWl0aWdhdGUKPiA+IGRlYWRsb2NrIGJ1Z3MuCj4gPgo+ID4gRml4ZXM6IGI3ZDU3
MmUxODcxZCAoImFyNTUyMzogQWRkIG5ldyBkcml2ZXIiKQo+ID4gU2lnbmVkLW9mZi1ieTogRHVv
bWluZyBaaG91IDxkdW9taW5nQHpqdS5lZHUuY24+Cj4gCj4gSSBhc3N1bWUgeW91IGhhdmUgZm91
bmQgdGhpcyB3aXRoIGEgc3RhdGljIGNoZWNrZXIgdG9vbCwgaXQgd291bGQgYmUKPiBnb29kIGRv
Y3VtZW50IHdoYXQgdG9vbCB5b3UgYXJlIHVzaW5nLiBBbmQgaWYgeW91IGhhdmUgbm90IHRlc3Rl
ZCB0aGlzCj4gd2l0aCByZWFsIGhhcmR3YXJlIGNsZWFybHkgbWVudGlvbiB0aGF0IHdpdGggIkNv
bXBpbGUgdGVzdGVkIG9ubHkiLgo+IAo+ID4gLS0tCj4gPiAgZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YXRoL2FyNTUyMy9hcjU1MjMuYyB8IDIgKysKPiA+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRp
b25zKCspCj4gPgo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hcjU1
MjMvYXI1NTIzLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXI1NTIzL2FyNTUyMy5jCj4g
PiBpbmRleCA5Y2FiZDM0MmQxNS4uOTlkNmIxM2ZmY2YgMTAwNjQ0Cj4gPiAtLS0gYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9hdGgvYXI1NTIzL2FyNTUyMy5jCj4gPiArKysgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9hdGgvYXI1NTIzL2FyNTUyMy5jCj4gPiBAQCAtMTA3MSw4ICsxMDcxLDEwIEBAIHN0
YXRpYyB2b2lkIGFyNTUyM19zdG9wKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KQo+ID4gIAlhcjU1
MjNfY21kX3dyaXRlKGFyLCBXRENNU0dfVEFSR0VUX1NUT1AsIE5VTEwsIDAsIDApOwo+ID4gIAo+
ID4gIAlkZWxfdGltZXJfc3luYygmYXItPnR4X3dkX3RpbWVyKTsKPiA+ICsJbXV0ZXhfdW5sb2Nr
KCZhci0+bXV0ZXgpOwo+ID4gIAljYW5jZWxfd29ya19zeW5jKCZhci0+dHhfd2Rfd29yayk7Cj4g
PiAgCWNhbmNlbF93b3JrX3N5bmMoJmFyLT5yeF9yZWZpbGxfd29yayk7Cj4gPiArCW11dGV4X2xv
Y2soJmFyLT5tdXRleCk7Cj4gPiAgCWFyNTUyM19jYW5jZWxfcnhfYnVmcyhhcik7Cj4gPiAgCW11
dGV4X3VubG9jaygmYXItPm11dGV4KTsKPiA+ICB9Cj4gCj4gUmVsZWFzaW5nIGEgbG9jayBhbmQg
dGFraW5nIGl0IGFnYWluIGxvb2tzIGxpa2UgYSBoYWNrIHRvIG1lLiBQbGVhc2UKPiB0ZXN0IHdp
dGggYSByZWFsIGRldmljZSBhbmQgdHJ5IHRvIGZpbmQgYSBiZXR0ZXIgc29sdXRpb24uCgpUaGUg
Zm9sbG93aW5nIGlzIGEgbmV3IHNvbHV0aW9uOgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2F0aC9hcjU1MjMvYXI1NTIzLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXI1
NTIzL2FyNTUyMy5jCmluZGV4IDljYWJkMzQyZDE1Li44YWRhZTg1ZmNiOSAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2FyNTUyMy9hcjU1MjMuYworKysgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9hdGgvYXI1NTIzL2FyNTUyMy5jCkBAIC05MTAsNyArOTEwLDExIEBAIHN0YXRp
YyB2b2lkIGFyNTUyM190eF93ZF93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKICAgICAg
ICAgKiByZWNvdmVyIHNlZW1zIHRvIGJlIHRvIHJlc2V0IHRoZSBkb25nbGUuCiAgICAgICAgICov
CgotICAgICAgIG11dGV4X2xvY2soJmFyLT5tdXRleCk7CisgICAgICAgaWYoIW11dGV4X3RyeWxv
Y2soJmFyLT5tdXRleCkpIHsKKyAgICAgICAgICAgICAgIGlmKHRlc3RfYml0KEFSNTUyM19IV19V
UCwgJmFyLT5mbGFncykpCisgICAgICAgICAgICAgICAgICAgICAgIGllZWU4MDIxMV9xdWV1ZV93
b3JrKGFyLT5odywgJmFyLT50eF93ZF93b3JrKTsKKyAgICAgICAgICAgICAgIHJldHVybjsKKyAg
ICAgICB9CiAgICAgICAgYXI1NTIzX2VycihhciwgIlRYIHF1ZXVlIHN0dWNrICh0b3QgJWQgcGVu
ZCAlZClcbiIsCiAgICAgICAgICAgICAgICAgICBhdG9taWNfcmVhZCgmYXItPnR4X25yX3RvdGFs
KSwKICAgICAgICAgICAgICAgICAgIGF0b21pY19yZWFkKCZhci0+dHhfbnJfcGVuZGluZykpOwoK
SWYgYXI1NTIzX3N0b3AoKSBoYXMgYWNxdWlyZWQgImFyLT5tdXRleCIgbG9jaywgdGhlIGFyNTUy
M190eF93ZF93b3JrKCkgd2lsbCBkaXJlY3RseSByZXR1cm4uCklmICJhci0+bXV0ZXgiIGxvY2sg
aGFzIGFjcXVpcmVkIGJ5IG90aGVyIGZ1bmN0aW9ucyBleGNlcHQgYXI1NTIzX3N0b3AoKSwgYXI1
NTIzX3R4X3dkX3dvcmsoKQp3aWxsIHJlLXF1ZXVlIGl0c2VsZi4KClNvLCB0aGlzIHNvbHV0aW9u
IGNvdWxkIG1pdGlnYXRlIHRoZSBkZWFkbG9jayBiZXR3ZWVuIGFyNTUyM19zdG9wKCkgYW5kIGFy
NTUyM190eF93ZF93b3JrKCkuCgpCZXN0IHJlZ2FyZHMsCkR1b21pbmcgWmhvdQ==
