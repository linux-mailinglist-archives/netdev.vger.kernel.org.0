Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DC55299B2
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 08:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240073AbiEQGou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 02:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240105AbiEQGop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 02:44:45 -0400
X-Greylist: delayed 73528 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 May 2022 23:44:41 PDT
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 7B2103FBED;
        Mon, 16 May 2022 23:44:41 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Tue, 17 May 2022 14:44:08
 +0800 (GMT+08:00)
X-Originating-IP: [124.236.130.193]
Date:   Tue, 17 May 2022 14:44:08 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] NFC: nci: fix sleep in atomic context bugs
 caused by nci_skb_alloc
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <4889a6cd-ef96-595e-a117-2965aab97a54@linaro.org>
References: <20220517012530.75714-1-duoming@zju.edu.cn>
 <4889a6cd-ef96-595e-a117-2965aab97a54@linaro.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <71f3cea1.18444.180d0c27b1a.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgC3COE4RINimSVXAA--.6312W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkNAVZdtZuKGAAAsw
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

SGVsbG8sCgpPbiBUdWUsIDE3IE1heSAyMDIyIDA4OjI1OjA0ICswMjAwIEtyenlzenRvZiB3cm90
ZToKCj4gT24gMTcvMDUvMjAyMiAwMzoyNSwgRHVvbWluZyBaaG91IHdyb3RlOgo+ID4gVGhlcmUg
YXJlIHNsZWVwIGluIGF0b21pYyBjb250ZXh0IGJ1Z3Mgd2hlbiB0aGUgcmVxdWVzdCB0byBzZWN1
cmUKPiA+IGVsZW1lbnQgb2Ygc3QtbmNpIGlzIHRpbWVvdXQuIFRoZSByb290IGNhdXNlIGlzIHRo
YXQgbmNpX3NrYl9hbGxvYwo+ID4gd2l0aCBHRlBfS0VSTkVMIHBhcmFtZXRlciBpcyBjYWxsZWQg
aW4gc3RfbmNpX3NlX3d0X3RpbWVvdXQgd2hpY2ggaXMKPiA+IGEgdGltZXIgaGFuZGxlci4gVGhl
IGNhbGwgcGF0aHMgdGhhdCBjb3VsZCB0cmlnZ2VyIGJ1Z3MgYXJlIHNob3duIGJlbG93Ogo+ID4g
Cj4gPiAgICAgKGludGVycnVwdCBjb250ZXh0IDEpCj4gPiBzdF9uY2lfc2Vfd3RfdGltZW91dAo+
ID4gICBuY2lfaGNpX3NlbmRfZXZlbnQKPiA+ICAgICBuY2lfaGNpX3NlbmRfZGF0YQo+ID4gICAg
ICAgbmNpX3NrYl9hbGxvYyguLi4sIEdGUF9LRVJORUwpIC8vbWF5IHNsZWVwCj4gPiAKPiA+ICAg
IChpbnRlcnJ1cHQgY29udGV4dCAyKQo+ID4gc3RfbmNpX3NlX3d0X3RpbWVvdXQKPiA+ICAgbmNp
X2hjaV9zZW5kX2V2ZW50Cj4gPiAgICAgbmNpX2hjaV9zZW5kX2RhdGEKPiA+ICAgICAgIG5jaV9z
ZW5kX2RhdGEKPiA+ICAgICAgICAgbmNpX3F1ZXVlX3R4X2RhdGFfZnJhZ3MKPiA+ICAgICAgICAg
ICBuY2lfc2tiX2FsbG9jKC4uLiwgR0ZQX0tFUk5FTCkgLy9tYXkgc2xlZXAKPiA+IAo+ID4gVGhp
cyBwYXRjaCBjaGFuZ2VzIGFsbG9jYXRpb24gbW9kZSBvZiBuY2lfc2tiX2FsbG9jIGZyb20gR0ZQ
X0tFUk5FTCB0bwo+ID4gR0ZQX0FUT01JQyBpbiBvcmRlciB0byBwcmV2ZW50IGF0b21pYyBjb250
ZXh0IHNsZWVwaW5nLiBUaGUgR0ZQX0FUT01JQwo+ID4gZmxhZyBtYWtlcyBtZW1vcnkgYWxsb2Nh
dGlvbiBvcGVyYXRpb24gY291bGQgYmUgdXNlZCBpbiBhdG9taWMgY29udGV4dC4KPiA+IAo+ID4g
Rml4ZXM6IGVkMDZhZWVmZGFjMyAoIm5mYzogc3QtbmNpOiBSZW5hbWUgc3QyMW5mY2IgdG8gc3Qt
bmNpIikKPiA+IFNpZ25lZC1vZmYtYnk6IER1b21pbmcgWmhvdSA8ZHVvbWluZ0B6anUuZWR1LmNu
Pgo+ID4gLS0tCj4gPiBDaGFuZ2VzIGluIHYyOgo+ID4gICAtIENoYW5nZSB0aGUgRml4ZXMgdGFn
IHRvIGNvbW1pdCBzdF9uY2lfc2Vfd3RfdGltZW91dCB3YXMgYWRkZWQuCj4gCj4gUGxlYXNlIGFk
ZCBBY2tlZC1ieS9SZXZpZXdlZC1ieSB0YWdzIHdoZW4gcG9zdGluZyBuZXcgdmVyc2lvbnMuIEhv
d2V2ZXIsCj4gdGhlcmUncyBubyBuZWVkIHRvIHJlcG9zdCBwYXRjaGVzICpvbmx5KiB0byBhZGQg
dGhlIHRhZ3MuIFRoZSB1cHN0cmVhbQo+IG1haW50YWluZXIgd2lsbCBkbyB0aGF0IGZvciBhY2tz
IHJlY2VpdmVkIG9uIHRoZSB2ZXJzaW9uIHRoZXkgYXBwbHkuCj4gCj4gaHR0cHM6Ly9lbGl4aXIu
Ym9vdGxpbi5jb20vbGludXgvdjUuMTMvc291cmNlL0RvY3VtZW50YXRpb24vcHJvY2Vzcy9zdWJt
aXR0aW5nLXBhdGNoZXMucnN0I0w1NDMKPiAKPiBJZiBhIHRhZyB3YXMgbm90IGFkZGVkIG9uIHB1
cnBvc2UsIHBsZWFzZSBzdGF0ZSB3aHkgYW5kIHdoYXQgY2hhbmdlZC4KClRoYW5rIHlvdSB2ZXJ5
IG11Y2gsIEkgd2lsbCByZWFkIHRoZSBkb2N1bWVudGF0aW9uIGNhcmVmdWxseS4KSSdtIHNvcnJ5
LCBJIGZvcmdvdCB0aGUgUmV2aWV3ZWQtYnkgdGFnLgogCj4gUmV2aWV3ZWQtYnk6IEtyenlzenRv
ZiBLb3psb3dza2kgPGtyenlzenRvZi5rb3psb3dza2lAbGluYXJvLm9yZz4KCkJlc3QgcmVnYXJk
cywKRHVvbWluZyBaaG91
