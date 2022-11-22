Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F924633961
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbiKVKK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbiKVKKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:10:19 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB3445A3D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669111815; x=1700647815;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=enRvWsoUZKyigkoWE0OWJpNAjOtc3+Y5zxIjuLASlWg=;
  b=HsXGZz5nFQY9k750Txot8YMcWbnmsw2qZVuF/IsXGKSTcLUEJOBz62Ub
   stjKFtRPlwxhjocCtCFERT6bOPvDxWmlFcA3icREy5US5YKjffkTOmQKe
   18FrsRkzHW2OaWzl16K47h0R9B+fAumafzlgmOxyVhmWes416sFKlkAoe
   A7ayeO6hn7Ntw3gTR0D8y1cxTlVUx2haUgjDIxCWpiscmcKQEdEwrhPqf
   hiwmOMoqi5m03XGNr4HgNrCMyAnbkVTp7vzg4/nTx18nWavYUoKlG4bkZ
   IEly/VHJyka4fZN0WXZ5SzBbF3XFiWjkv4jfnuwxZ4AgnWeylWKVq2fhP
   A==;
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="200886119"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 03:10:14 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 03:10:13 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 22 Nov 2022 03:10:11 -0700
Message-ID: <088c09e8b8d375dd9e56b07cbd1fff0bde312236.camel@microchip.com>
Subject: Re: [PATCH net] net: sparx5: fix error handling in
 sparx5_port_open()
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Liu Jian <liujian56@huawei.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <horatiu.vultur@microchip.com>, <bjarni.jonasson@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date:   Tue, 22 Nov 2022 11:10:10 +0100
In-Reply-To: <3a58c574d9ad4ad5c74eb211f6453ef24a50f17b.camel@microchip.com>
References: <20221117125918.203997-1-liujian56@huawei.com>
         <3a58c574d9ad4ad5c74eb211f6453ef24a50f17b.camel@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTGl1LAoKT29wcywgSW5jb3JyZWN0IHRhZ2dpbmcuLi4KClRoYW5rcyBmb3IgeW91ciBwYXRj
aCwgdGhlIGNoYW5nZXMgbG9vayBnb29kIHRvIG1lLiAgV2UgYWxzbyBkaWQgYSByb3VuZCBvZgp0
ZXN0aW5nIG9uIHRoZSBwbGF0Zm9ybSwgc2ltdWxhdGluZyBlcnJvcnMgdG8gc2VlIHRoaXMgaW4g
ZWZmZWN0LgogCgpPbiBUdWUsIDIwMjItMTEtMjIgYXQgMTA6MjggKzAxMDAsIFN0ZWVuIEhlZ2Vs
dW5kIHdyb3RlOgo+IEhpIExpdSwKPiAKPiBUaGFua3MgZm9yIHlvdXIgcGF0Y2gsIHRoZSBjaGFu
Z2VzIGxvb2sgZ29vZCB0byBtZS7CoCBXZSBhbHNvIGRpZCBhIHJvdW5kIG9mCj4gdGVzdGluZyBv
biB0aGUgcGxhdGZvcm0sIHNpbXVsYXRpbmcgZXJyb3JzIHRvIHNlZSB0aGlzIGluIGVmZmVjdC4K
PiAKPiBPbiBUaHUsIDIwMjItMTEtMTcgYXQgMjA6NTkgKzA4MDAsIExpdSBKaWFuIHdyb3RlOgo+
ID4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3Uga25vdyB0aGUKPiA+IGNvbnRlbnQgaXMgc2FmZQo+ID4gCj4gPiBJZiBwaHls
aW5rX29mX3BoeV9jb25uZWN0KCkgZmFpbHMsIHRoZSBwb3J0IHNob3VsZCBiZSBkaXNhYmxlZC4K
PiA+IElmIHNwYXJ4NV9zZXJkZXNfc2V0KCkvcGh5X3Bvd2VyX29uKCkgZmFpbHMsIHRoZSBwb3J0
IHNob3VsZCBiZQo+ID4gZGlzYWJsZWQgYW5kIHRoZSBwaHlsaW5rIHNob3VsZCBiZSBzdG9wcGVk
IGFuZCBkaXNjb25uZWN0ZWQuCj4gPiAKPiA+IEZpeGVzOiA5NDZlN2ZkNTA1M2EgKCJuZXQ6IHNw
YXJ4NTogYWRkIHBvcnQgbW9kdWxlIHN1cHBvcnQiKQo+ID4gRml4ZXM6IGYzY2FkMjYxMWE3NyAo
Im5ldDogc3Bhcng1OiBhZGQgaG9zdG1vZGUgd2l0aCBwaHlsaW5rIHN1cHBvcnQiKQo+ID4gU2ln
bmVkLW9mZi1ieTogTGl1IEppYW4gPGxpdWppYW41NkBodWF3ZWkuY29tPgo+ID4gLS0tCj4gPiDC
oC4uLi9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL3NwYXJ4NS9zcGFyeDVfbmV0ZGV2LmPCoCB8IDE0
ICsrKysrKysrKysrKy0tCj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWljcm9jaGlwL3NwYXJ4NS9zcGFyeDVfbmV0ZGV2LmMKPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWljcm9jaGlwL3NwYXJ4NS9zcGFyeDVfbmV0ZGV2LmMKPiA+IGluZGV4IDE5NTE2Y2NhZDUz
My4uZDA3ODE1NjU4MWQ1IDEwMDY0NAo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWlj
cm9jaGlwL3NwYXJ4NS9zcGFyeDVfbmV0ZGV2LmMKPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21pY3JvY2hpcC9zcGFyeDUvc3Bhcng1X25ldGRldi5jCj4gPiBAQCAtMTA0LDcgKzEwNCw3
IEBAIHN0YXRpYyBpbnQgc3Bhcng1X3BvcnRfb3BlbihzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikK
PiA+IMKgwqDCoMKgwqDCoMKgIGVyciA9IHBoeWxpbmtfb2ZfcGh5X2Nvbm5lY3QocG9ydC0+cGh5
bGluaywgcG9ydC0+b2Zfbm9kZSwgMCk7Cj4gPiDCoMKgwqDCoMKgwqDCoCBpZiAoZXJyKSB7Cj4g
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbmV0ZGV2X2VycihuZGV2LCAiQ291bGQg
bm90IGF0dGFjaCB0byBQSFlcbiIpOwo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIGVycjsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gZXJyX2Nv
bm5lY3Q7Cj4gPiDCoMKgwqDCoMKgwqDCoCB9Cj4gPiAKPiA+IMKgwqDCoMKgwqDCoMKgIHBoeWxp
bmtfc3RhcnQocG9ydC0+cGh5bGluayk7Cj4gPiBAQCAtMTE2LDEwICsxMTYsMjAgQEAgc3RhdGlj
IGludCBzcGFyeDVfcG9ydF9vcGVuKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQo+ID4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlcnIgPSBzcGFyeDVfc2Vy
ZGVzX3NldChwb3J0LT5zcGFyeDUsIHBvcnQsICZwb3J0LQo+ID4gPiBjb25mKTsKPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlbHNlCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGVyciA9IHBoeV9wb3dlcl9vbihwb3J0LT5zZXJkZXMp
Owo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGVycikKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChlcnIpIHsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbmV0ZGV2X2VycihuZGV2LCAiJXMgZmFpbGVkXG4i
LCBfX2Z1bmNfXyk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgZ290byBvdXRfcG93ZXI7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9
Cj4gPiDCoMKgwqDCoMKgwqDCoCB9Cj4gPiAKPiA+ICvCoMKgwqDCoMKgwqAgcmV0dXJuIDA7Cj4g
PiArCj4gPiArb3V0X3Bvd2VyOgo+ID4gK8KgwqDCoMKgwqDCoCBwaHlsaW5rX3N0b3AocG9ydC0+
cGh5bGluayk7Cj4gPiArwqDCoMKgwqDCoMKgIHBoeWxpbmtfZGlzY29ubmVjdF9waHkocG9ydC0+
cGh5bGluayk7Cj4gPiArZXJyX2Nvbm5lY3Q6Cj4gPiArwqDCoMKgwqDCoMKgIHNwYXJ4NV9wb3J0
X2VuYWJsZShwb3J0LCBmYWxzZSk7Cj4gPiArCj4gPiDCoMKgwqDCoMKgwqDCoCByZXR1cm4gZXJy
Owo+ID4gwqB9Cj4gPiAKPiA+IC0tCj4gPiAyLjE3LjEKPiA+IAo+IAo+IFRlc3RlZC1vZmYtYnk6
IEJqYXJuaSBKb25hc3NvbiA8Ymphcm5pLmpvbmFzc29uQG1pY3JvY2hpcC5jb20+Cj4gUmV2aWV3
ZWQtb2ZmLWJ5OiBMYXJzIFBvdmxzZW4gPHN0ZWVuLmhlZ2VsdW5kQG1pY3JvY2hpcC5jb20+Cj4g
Cj4gQlIKPiBTdGVlbgo+IAoKVGVzdGVkLWJ5OiBCamFybmkgSm9uYXNzb24gPGJqYXJuaS5qb25h
c3NvbkBtaWNyb2NoaXAuY29tPgpSZXZpZXdlZC1ieTogU3RlZW4gSGVnZWx1bmQgPHN0ZWVuLmhl
Z2VsdW5kQG1pY3JvY2hpcC5jb20+CgpCUgpTdGVlbgoK

