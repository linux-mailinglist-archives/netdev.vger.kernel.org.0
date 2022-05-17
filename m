Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1216752A684
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349959AbiEQP0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245611AbiEQP0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:26:02 -0400
X-Greylist: delayed 104799 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 May 2022 08:25:57 PDT
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 62533B1CE;
        Tue, 17 May 2022 08:25:55 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Tue, 17 May 2022 23:25:39
 +0800 (GMT+08:00)
X-Originating-IP: [220.246.124.53]
Date:   Tue, 17 May 2022 23:25:39 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] NFC: hci: fix sleep in atomic context bugs in
 nfc_hci_hcp_message_tx
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <2ce7a871-3e55-ae50-955c-bf04a443aba3@linaro.org>
References: <20220517105526.114421-1-duoming@zju.edu.cn>
 <2ce7a871-3e55-ae50-955c-bf04a443aba3@linaro.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <71c24f38.1a1f4.180d29ff1fd.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgC3PiFzvoNifCNdAA--.9211W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgwNAVZdtZvNEQAAs7
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBUdWUsIDE3IE1heSAyMDIyIDEzOjQyOjQxICswMjAwIEtyenlzenRvZiB3cm90
ZToKCj4gT24gMTcvMDUvMjAyMiAxMjo1NSwgRHVvbWluZyBaaG91IHdyb3RlOgo+ID4gVGhlcmUg
YXJlIHNsZWVwIGluIGF0b21pYyBjb250ZXh0IGJ1Z3Mgd2hlbiB0aGUgcmVxdWVzdCB0byBzZWN1
cmUKPiA+IGVsZW1lbnQgb2Ygc3QyMW5mY2EgaXMgdGltZW91dC4gVGhlIHJvb3QgY2F1c2UgaXMg
dGhhdCBremFsbG9jIGFuZAo+ID4gYWxsb2Nfc2tiIHdpdGggR0ZQX0tFUk5FTCBwYXJhbWV0ZXIg
YW5kIG11dGV4X2xvY2sgYXJlIGNhbGxlZCBpbgo+ID4gc3QyMW5mY2Ffc2Vfd3RfdGltZW91dCB3
aGljaCBpcyBhIHRpbWVyIGhhbmRsZXIuIFRoZSBjYWxsIHRyZWUgc2hvd3MKPiA+IHRoZSBleGVj
dXRpb24gcGF0aHMgdGhhdCBjb3VsZCBsZWFkIHRvIGJ1Z3M6Cj4gPiAKPiA+ICAgIChJbnRlcnJ1
cHQgY29udGV4dCkKPiA+IHN0MjFuZmNhX3NlX3d0X3RpbWVvdXQKPiA+ICAgbmZjX2hjaV9zZW5k
X2V2ZW50Cj4gPiAgICAgbmZjX2hjaV9oY3BfbWVzc2FnZV90eAo+ID4gICAgICAga3phbGxvYygu
Li4sIEdGUF9LRVJORUwpIC8vbWF5IHNsZWVwCj4gPiAgICAgICBhbGxvY19za2IoLi4uLCBHRlBf
S0VSTkVMKSAvL21heSBzbGVlcAo+ID4gICAgICAgbXV0ZXhfbG9jaygpIC8vbWF5IHNsZWVwCj4g
PiAKPiA+IFRoaXMgcGF0Y2ggY2hhbmdlcyBhbGxvY2F0aW9uIG1vZGUgb2Yga3phbGxvYyBhbmQg
YWxsb2Nfc2tiIGZyb20KPiA+IEdGUF9LRVJORUwgdG8gR0ZQX0FUT01JQyBhbmQgY2hhbmdlcyBt
dXRleF9sb2NrIHRvIHNwaW5fbG9jayBpbgo+ID4gb3JkZXIgdG8gcHJldmVudCBhdG9taWMgY29u
dGV4dCBmcm9tIHNsZWVwaW5nLgo+ID4gCj4gPiBGaXhlczogMjEzMGZiOTdmZWNmICgiTkZDOiBz
dDIxbmZjYTogQWRkaW5nIHN1cHBvcnQgZm9yIHNlY3VyZSBlbGVtZW50IikKPiA+IFNpZ25lZC1v
ZmYtYnk6IER1b21pbmcgWmhvdSA8ZHVvbWluZ0B6anUuZWR1LmNuPgo+ID4gLS0tCj4gPiBDaGFu
Z2VzIGluIHYyOgo+ID4gICAtIENoYW5nZSBtdXRleF9sb2NrIHRvIHNwaW5fbG9jay4KPiA+IAo+
ID4gIGluY2x1ZGUvbmV0L25mYy9oY2kuaCB8ICAzICsrLQo+ID4gIG5ldC9uZmMvaGNpL2NvcmUu
YyAgICB8IDE4ICsrKysrKysrKy0tLS0tLS0tLQo+ID4gIG5ldC9uZmMvaGNpL2hjcC5jICAgICB8
IDEwICsrKysrLS0tLS0KPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDE1
IGRlbGV0aW9ucygtKQo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvbmZjL2hjaS5o
IGIvaW5jbHVkZS9uZXQvbmZjL2hjaS5oCj4gPiBpbmRleCA3NTZjMTEwODRmNi4uOGY2NmU2ZTZi
OTEgMTAwNjQ0Cj4gPiAtLS0gYS9pbmNsdWRlL25ldC9uZmMvaGNpLmgKPiA+ICsrKyBiL2luY2x1
ZGUvbmV0L25mYy9oY2kuaAo+ID4gQEAgLTEwMyw3ICsxMDMsOCBAQCBzdHJ1Y3QgbmZjX2hjaV9k
ZXYgewo+ID4gIAo+ID4gIAlib29sIHNodXR0aW5nX2Rvd247Cj4gPiAgCj4gPiAtCXN0cnVjdCBt
dXRleCBtc2dfdHhfbXV0ZXg7Cj4gPiArCS8qIFRoZSBzcGlubG9jayBpcyB1c2VkIHRvIHByb3Rl
Y3QgcmVzb3VyY2VzIHJlbGF0ZWQgd2l0aCBoY2kgbWVzc2FnZSBUWCAqLwo+ID4gKwlzcGlubG9j
a190IG1zZ190eF9zcGluOwo+ID4gIAo+ID4gIAlzdHJ1Y3QgbGlzdF9oZWFkIG1zZ190eF9xdWV1
ZTsKPiA+ICAKPiA+IGRpZmYgLS1naXQgYS9uZXQvbmZjL2hjaS9jb3JlLmMgYi9uZXQvbmZjL2hj
aS9jb3JlLmMKPiA+IGluZGV4IGNlYjg3ZGI1N2NkLi5mYTIyZjlmZTVmYyAxMDA2NDQKPiA+IC0t
LSBhL25ldC9uZmMvaGNpL2NvcmUuYwo+ID4gKysrIGIvbmV0L25mYy9oY2kvY29yZS5jCj4gPiBA
QCAtNjgsNyArNjgsNyBAQCBzdGF0aWMgdm9pZCBuZmNfaGNpX21zZ190eF93b3JrKHN0cnVjdCB3
b3JrX3N0cnVjdCAqd29yaykKPiA+ICAJc3RydWN0IHNrX2J1ZmYgKnNrYjsKPiA+ICAJaW50IHIg
PSAwOwo+ID4gIAo+ID4gLQltdXRleF9sb2NrKCZoZGV2LT5tc2dfdHhfbXV0ZXgpOwo+ID4gKwlz
cGluX2xvY2soJmhkZXYtPm1zZ190eF9zcGluKTsKPiA+ICAJaWYgKGhkZXYtPnNodXR0aW5nX2Rv
d24pCj4gPiAgCQlnb3RvIGV4aXQ7Cj4gCj4gSG93IGRpZCB5b3UgdGVzdCB5b3VyIHBhdGNoPwo+
IAo+IERpZCB5b3UgY2hlY2ssIHJlYWxseSBjaGVjaywgdGhhdCB0aGlzIGNhbiBiZSBhbiBhdG9t
aWMgKG5vbi1zbGVlcGluZykKPiBzZWN0aW9uPwo+IAo+IEkgaGF2ZSBkb3VidHMgYmVjYXVzZSBJ
IGZvdW5kIGF0IGxlYXN0IG9uZSBwYXRoIGxlYWRpbmcgdG8gZGV2aWNlX2xvY2sKPiAod2hpY2gg
aXMgYSBtdXRleCkgY2FsbGVkIHdpdGhpbiB5b3VyIG5ldyBjb2RlLgoKVGhlIG5mY19oY2lfaGNw
X21lc3NhZ2VfdHgoKSBpcyBjYWxsZWQgYnkgYm90aCBwcm9jZXNzIGNvbnRleHQoaGNpX2Rldl91
cCBhbmQgc28gb24pCmFuZCBpbnRlcnJ1cHQgY29udGV4dChzdDIxbmZjYV9zZV93dF90aW1lb3V0
KCkpLiBUaGUgcHJvY2VzcyBjb250ZXh0KGhjaV9kZXZfdXAgYW5kIHNvIG9uKQpjYWxscyBkZXZp
Y2VfbG9jaywgYnV0IEkgdGhpbmsgY2FsbGluZyBzcGluX2xvY2soKSB3aXRoaW4gZGV2aWNlX2xv
Y2soKSBpcyBvay4gVGhlcmUgaXMKbm8gZGV2aWNlX2xvY2soKSBjYWxsZWQgd2l0aGluIHNwaW5f
bG9jaygpLiAKClRoZSBzcGlubG9jayBjb3VsZCBhbHNvIGltcHJvdmUgdGhlIHBlcmZvcm1hbmNl
IG9mIHRoZSBwcm9ncmFtLCBiZWNhdXNlIHByb2Nlc3NpbmcgdGhlCmhjaSBtZXNzYWdlcyBzaG91
bGQgYmUgZmluaXNoZWQgaW4gYSBzaG9ydCB0aW1lLgoKPiBCZWZvcmUgc2VuZGluZyBhIG5ldyB2
ZXJzaW9uLCBwbGVhc2Ugd2FpdCBmb3IgZGlzY3Vzc2lvbiB0byByZWFjaCBzb21lCj4gY29uc2Vu
c3VzLiBUaGUgcXVhbGl0eSBvZiB0aGVzZSBmaXhlcyBpcyByZWFsbHkgcG9vci4gOigKCk9rLCBJ
IHdpbGwgd2FpdCBmb3IgZGlzY3Vzc2lvbiB0byByZWFjaCBjb25zZW5zdXMuCgpCZXN0IHJlZ2Fy
ZHMsCkR1b21pbmcgWmhvdQo=
