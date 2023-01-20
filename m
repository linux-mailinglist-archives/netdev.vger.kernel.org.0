Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8307674EF3
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 09:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjATIGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 03:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjATIGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 03:06:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463BE881E7
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 00:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674201963; x=1705737963;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=YOBnruVYRIOtz6XH1vFVjpHV/2T+v1ipdX5egBe0aoE=;
  b=15fn8AtYPxl/GPtxXE5HdLNIcvQtDDrJ7cBfg3R0uvsdQRq0lStSt1aq
   HIoJc60lql7ajiACsSX1XaaQ4yYrv+L4OmHGHMhHy6D9QrFP4CQAbILDi
   /aKusuMW34hI8IcW5j2dHmIDpgS0Zis1gi9mKG59XURB7rhB5E6M85jlV
   z3gFZoRzCTwnCSbr7X6mNvn0Epvc5q+rav3OZz/RtPWZcMB2ZC7z1EG64
   0/kW1/ZLpYZ3SqT+6LS4VfgPzcqo2ly2LCw08sKcDxtvFZ2YK3AfSvg2C
   I/FeI9ipvCIeb3d4VPhEHuoCKCSS3M4YY9JUKJKFj9FwrXoGXlsfjIrIT
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="197592612"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 01:06:03 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 01:06:01 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 01:05:59 -0700
Message-ID: <fa74af113933cea071c1639a28ffefa7572f05a2.camel@microchip.com>
Subject: Re: [PATCH net-next] net: microchip: vcap: use kmemdup() to
 allocate memory
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Yang Yingliang <yangyingliang@huawei.com>, <netdev@vger.kernel.org>
CC:     <lars.povlsen@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
Date:   Fri, 20 Jan 2023 09:05:59 +0100
In-Reply-To: <20230119092210.3607634-1-yangyingliang@huawei.com>
References: <20230119092210.3607634-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgWWFuZywKClRoYW5rcyBmb3IgdGhlIGNvcnJlY3Rpb24uCgpSZXZpZXdlZC1ieTogU3RlZW4g
SGVnZWx1bmQgPFN0ZWVuLkhlZ2VsdW5kQG1pY3JvY2hpcC5jb20+CgpCUgpTdGVlbgoKT24gVGh1
LCAyMDIzLTAxLTE5IGF0IDE3OjIyICswODAwLCBZYW5nIFlpbmdsaWFuZyB3cm90ZToKPiBFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZQo+IGNvbnRlbnQgaXMgc2FmZQo+IAo+IFVzZSBrbWVtZHVwKCkgaGVscGVy
IGluc3RlYWQgb2Ygb3Blbi1jb2RpbmcgdG8gc2ltcGxpZnkKPiB0aGUgY29kZSB3aGVuIGFsbG9j
YXRpbmcgbmV3Y2tmIGFuZCBuZXdjYWYuCj4gCj4gR2VuZXJhdGVkIGJ5OiBzY3JpcHRzL2NvY2Np
bmVsbGUvYXBpL21lbWR1cC5jb2NjaQo+IAo+IFNpZ25lZC1vZmYtYnk6IFlhbmcgWWluZ2xpYW5n
IDx5YW5neWluZ2xpYW5nQGh1YXdlaS5jb20+Cj4gLS0tCj4gwqBkcml2ZXJzL25ldC9ldGhlcm5l
dC9taWNyb2NoaXAvdmNhcC92Y2FwX2FwaS5jIHwgNiArKy0tLS0KPiDCoDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21pY3JvY2hpcC92Y2FwL3ZjYXBfYXBpLmMKPiBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21pY3JvY2hpcC92Y2FwL3ZjYXBfYXBpLmMKPiBpbmRleCA3MWY3ODdhNzgyOTUu
LmQ5Y2YyY2QxOTI1YSAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9taWNyb2No
aXAvdmNhcC92Y2FwX2FwaS5jCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlw
L3ZjYXAvdmNhcF9hcGkuYwo+IEBAIC0xMDAwLDE4ICsxMDAwLDE2IEBAIHN0YXRpYyBzdHJ1Y3Qg
dmNhcF9ydWxlX2ludGVybmFsICp2Y2FwX2R1cF9ydWxlKHN0cnVjdAo+IHZjYXBfcnVsZV9pbnRl
cm5hbCAqcmksCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBkdXBydWxl
Owo+IAo+IMKgwqDCoMKgwqDCoMKgIGxpc3RfZm9yX2VhY2hfZW50cnkoY2tmLCAmcmktPmRhdGEu
a2V5ZmllbGRzLCBjdHJsLmxpc3QpIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBu
ZXdja2YgPSBremFsbG9jKHNpemVvZigqbmV3Y2tmKSwgR0ZQX0tFUk5FTCk7Cj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgbmV3Y2tmID0ga21lbWR1cChja2YsIHNpemVvZigqbmV3Y2tm
KSwgR0ZQX0tFUk5FTCk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICghbmV3
Y2tmKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0
dXJuIEVSUl9QVFIoLUVOT01FTSk7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWVt
Y3B5KG5ld2NrZiwgY2tmLCBzaXplb2YoKm5ld2NrZikpOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBsaXN0X2FkZF90YWlsKCZuZXdja2YtPmN0cmwubGlzdCwgJmR1cHJ1bGUtPmRh
dGEua2V5ZmllbGRzKTsKPiDCoMKgwqDCoMKgwqDCoCB9Cj4gCj4gwqDCoMKgwqDCoMKgwqAgbGlz
dF9mb3JfZWFjaF9lbnRyeShjYWYsICZyaS0+ZGF0YS5hY3Rpb25maWVsZHMsIGN0cmwubGlzdCkg
ewo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG5ld2NhZiA9IGt6YWxsb2Moc2l6ZW9m
KCpuZXdjYWYpLCBHRlBfS0VSTkVMKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBu
ZXdjYWYgPSBrbWVtZHVwKGNhZiwgc2l6ZW9mKCpuZXdjYWYpLCBHRlBfS0VSTkVMKTsKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKCFuZXdjYWYpCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsK
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtZW1jcHkobmV3Y2FmLCBjYWYsIHNpemVv
ZigqbmV3Y2FmKSk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGxpc3RfYWRkX3Rh
aWwoJm5ld2NhZi0+Y3RybC5saXN0LCAmZHVwcnVsZS0KPiA+ZGF0YS5hY3Rpb25maWVsZHMpOwo+
IMKgwqDCoMKgwqDCoMKgIH0KPiAKPiAtLQo+IDIuMjUuMQo+IAoK

