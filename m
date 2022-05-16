Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949A95281F9
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiEPKZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbiEPKZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:25:38 -0400
X-Greylist: delayed 387 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 May 2022 03:25:29 PDT
Received: from azure-sdnproxy-3.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 4D82C11A29;
        Mon, 16 May 2022 03:25:28 -0700 (PDT)
Received: by ajax-webmail-mail-app2 (Coremail) ; Mon, 16 May 2022 18:18:45
 +0800 (GMT+08:00)
X-Originating-IP: [220.246.124.53]
Date:   Mon, 16 May 2022 18:18:45 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        broonie@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] NFC: hci: fix sleep in atomic context bugs in
 nfc_hci_hcp_message_tx
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <d5fdfe27-a6de-3030-ce51-9f4f45d552f3@linaro.org>
References: <20220516021028.54063-1-duoming@zju.edu.cn>
 <d5fdfe27-a6de-3030-ce51-9f4f45d552f3@linaro.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <6aba1413.196eb.180cc609bf1.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgDH3EAFJYJiSn9MAA--.7122W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgIMAVZdtZs8KwAAs-
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBNb24sIDE2IE1heSAyMDIyIDA4OjQ0OjM5ICswMjAwIEtyenlzenRvZiB3cm90
ZToKCj4gPiBUaGVyZSBhcmUgc2xlZXAgaW4gYXRvbWljIGNvbnRleHQgYnVncyB3aGVuIHRoZSBy
ZXF1ZXN0IHRvIHNlY3VyZQo+ID4gZWxlbWVudCBvZiBzdDIxbmZjYSBpcyB0aW1lb3V0LiBUaGUg
cm9vdCBjYXVzZSBpcyB0aGF0IGt6YWxsb2MgYW5kCj4gPiBhbGxvY19za2Igd2l0aCBHRlBfS0VS
TkVMIHBhcmFtZXRlciBpcyBjYWxsZWQgaW4gc3QyMW5mY2Ffc2Vfd3RfdGltZW91dAo+ID4gd2hp
Y2ggaXMgYSB0aW1lciBoYW5kbGVyLiBUaGUgY2FsbCB0cmVlIHNob3dzIHRoZSBleGVjdXRpb24g
cGF0aHMgdGhhdAo+ID4gY291bGQgbGVhZCB0byBidWdzOgo+ID4gCj4gPiAgICAoSW50ZXJydXB0
IGNvbnRleHQpCj4gPiBzdDIxbmZjYV9zZV93dF90aW1lb3V0Cj4gPiAgIG5mY19oY2lfc2VuZF9l
dmVudAo+ID4gICAgIG5mY19oY2lfaGNwX21lc3NhZ2VfdHgKPiA+ICAgICAgIGt6YWxsb2MoLi4u
LCBHRlBfS0VSTkVMKSAvL21heSBzbGVlcAo+ID4gICAgICAgYWxsb2Nfc2tiKC4uLiwgR0ZQX0tF
Uk5FTCkgLy9tYXkgc2xlZXAKPiA+IAo+ID4gVGhpcyBwYXRjaCBjaGFuZ2VzIGFsbG9jYXRpb24g
bW9kZSBvZiBremFsbG9jIGFuZCBhbGxvY19za2IgZnJvbQo+ID4gR0ZQX0tFUk5FTCB0byBHRlBf
QVRPTUlDIGluIG9yZGVyIHRvIHByZXZlbnQgYXRvbWljIGNvbnRleHQgZnJvbQo+ID4gc2xlZXBp
bmcuIFRoZSBHRlBfQVRPTUlDIGZsYWcgbWFrZXMgbWVtb3J5IGFsbG9jYXRpb24gb3BlcmF0aW9u
Cj4gPiBjb3VsZCBiZSB1c2VkIGluIGF0b21pYyBjb250ZXh0Lgo+ID4gCj4gPiBGaXhlczogOGI4
ZDJlMDhiZjBkICgiTkZDOiBIQ0kgc3VwcG9ydCIpCj4gPiBTaWduZWQtb2ZmLWJ5OiBEdW9taW5n
IFpob3UgPGR1b21pbmdAemp1LmVkdS5jbj4KPiA+IC0tLQo+ID4gIG5ldC9uZmMvaGNpL2hjcC5j
IHwgNCArKy0tCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlv
bnMoLSkKPiA+IAo+ID4gZGlmZiAtLWdpdCBhL25ldC9uZmMvaGNpL2hjcC5jIGIvbmV0L25mYy9o
Y2kvaGNwLmMKPiA+IGluZGV4IDA1YzYwOTg4ZjU5Li4xY2FmOWMyMDg2ZiAxMDA2NDQKPiA+IC0t
LSBhL25ldC9uZmMvaGNpL2hjcC5jCj4gPiArKysgYi9uZXQvbmZjL2hjaS9oY3AuYwo+ID4gQEAg
LTMwLDcgKzMwLDcgQEAgaW50IG5mY19oY2lfaGNwX21lc3NhZ2VfdHgoc3RydWN0IG5mY19oY2lf
ZGV2ICpoZGV2LCB1OCBwaXBlLAo+ID4gIAlpbnQgaGNpX2xlbiwgZXJyOwo+ID4gIAlib29sIGZp
cnN0ZnJhZyA9IHRydWU7Cj4gPiAgCj4gPiAtCWNtZCA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBo
Y2lfbXNnKSwgR0ZQX0tFUk5FTCk7Cj4gPiArCWNtZCA9IGt6YWxsb2Moc2l6ZW9mKCpjbWQpLCBH
RlBfQVRPTUlDKTsKPiAKPiBObywgdGhpcyBkb2VzIG5vdCBsb29rIGNvcnJlY3QuIFRoaXMgZnVu
Y3Rpb24gY2FuIHNsZWVwLCBzbyBpdCBjYW4gdXNlCj4gR0ZQX0tFUk5FTC4gUGxlYXNlIGp1c3Qg
bG9vayBhdCB0aGUgZnVuY3Rpb24gYmVmb3JlIHJlcGxhY2luZyBhbnkgZmxhZ3MuLi4KCkkgYW0g
c29ycnksIEkgZG9uYHQgdW5kZXJzdGFuZCB3aHkgbmZjX2hjaV9oY3BfbWVzc2FnZV90eCgpIGNh
biBzbGVlcC4KCkkgdGhpbmsgc3QyMW5mY2Ffc2Vfd3RfdGltZW91dCgpIGlzIGEgdGltZXIgaGFu
ZGxlciwgd2hpY2ggaXMgaW4gaW50ZXJydXB0IGNvbnRleHQuClRoZSBjYWxsIHRyZWUgc2hvd3Mg
dGhlIGV4ZWN1dGlvbiBwYXRocyB0aGF0IGNvdWxkIGxlYWQgdG8gYnVnczoKCnN0MjFuZmNhX2hj
aV9zZV9pbygpCiAgbW9kX3RpbWVyKCZpbmZvLT5zZV9pbmZvLmJ3aV90aW1lciwuLi4pCiAgICBz
dDIxbmZjYV9zZV93dF90aW1lb3V0KCkgIC8vdGltZXIgaGFuZGxlciwgaW50ZXJydXB0IGNvbnRl
eHQKICAgICAgbmZjX2hjaV9zZW5kX2V2ZW50KCkKICAgICAgICBuZmNfaGNpX2hjcF9tZXNzYWdl
X3R4KCkKICAgICAgICAgIGt6YWxsb2MoLi4uLCBHRlBfS0VSTkVMKSAvL21heSBzbGVlcAogICAg
ICAgICAgYWxsb2Nfc2tiKC4uLiwgR0ZQX0tFUk5FTCkgLy9tYXkgc2xlZXAKCldoYXRgcyBtb3Jl
LCBJIHRoaW5rIHRoZSAibXV0ZXhfbG9jaygmaGRldi0+bXNnX3R4X211dGV4KSIgY2FsbGVkIGJ5
IG5mY19oY2lfaGNwX21lc3NhZ2VfdHgoKQppcyBhbHNvIGltcHJvcGVyLgoKUGxlYXNlIGNvcnJl
Y3QgbWUsIElmIHlvdSB0aGluayBJIGFtIHdyb25nLiBUaGFua3MgZm9yIHlvdXIgdGltZS4KCkJl
c3QgcmVnYXJkcywKRHVvbWluZyBaaG91Cgo=
