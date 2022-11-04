Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9530C619631
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiKDM1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiKDM1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:27:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751831FFB3;
        Fri,  4 Nov 2022 05:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667564871; x=1699100871;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Lx0mmH4gtzkGJIZKyD9cxMC+E78JRBrHSObjdWOEYUQ=;
  b=DnuAr4SQ7bio7LDDH/luE5ZBaXPMTfmlteMjBMTAWkQZWkD/yolob/xK
   9Lhg1fTC1fxBkDthpYPgc/o8tkGSma6phsWG9eHqJb48PhrLxdNT/Spbw
   SaB268tI6gTHTSqwaDDLTpfolPFMQkUmImolYnoj2GdTV+xs+DoqtskOU
   MMAqHtE0Lmsq0O+Y/yhUPw+zyceEhw8a8NOwENMS9WmKZaAjLIkdGKuwl
   pNQjdLyBSnMBSTkuRFDnv3hmud7ih0ipY9ES7uj36mZsb55CwtoA2rZf6
   92qHl7dgHZwstYuNjStneK9uBJ6suS5or7CaS83qFppLCpmUy5zJ6BfnO
   w==;
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="181948995"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Nov 2022 05:27:50 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 4 Nov 2022 05:27:39 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 4 Nov 2022 05:27:37 -0700
Message-ID: <4f500c0d1334d09713842aa1c4def71e5ece7e3c.camel@microchip.com>
Subject: Re: [PATCH net-next] net: flow_offload: add support for ARP frame
 matching
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Louis Peens <louis.peens@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "Tony Nguyen" <anthony.l.nguyen@intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>,
        "Horatiu Vultur" <horatiu.vultur@microchip.com>
Date:   Fri, 4 Nov 2022 13:27:36 +0100
In-Reply-To: <20221104121915.1317246-1-steen.hegelund@microchip.com>
References: <20221104121915.1317246-1-steen.hegelund@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U29ycnk6wqAKClBsZWFzZSBpZ25vcmUgdGhpcy4gIFRoZSBjb21taXQgbWVzc2FnZSBoYWQgbm90
IGJlZW4gdXBkYXRlZC4uLgoKQlIKU3RlZW4KCgpPbiBGcmksIDIwMjItMTEtMDQgYXQgMTM6MTkg
KzAxMDAsIFN0ZWVuIEhlZ2VsdW5kIHdyb3RlOgo+IGZsb3dfcnVsZV9tYXRjaF9hcnAgYWxsb3dz
IGRyaXZlcnMgdG8gZGlzc2VjdCBBUFIgZnJhbWVzCj4gCj4gU2lnbmVkLW9mZi1ieTogU3RlZW4g
SGVnZWx1bmQgPHN0ZWVuLmhlZ2VsdW5kQG1pY3JvY2hpcC5jb20+Cj4gLS0tCj4gwqBpbmNsdWRl
L25ldC9mbG93X29mZmxvYWQuaCB8IDYgKysrKysrCj4gwqBuZXQvY29yZS9mbG93X29mZmxvYWQu
Y8KgwqDCoCB8IDcgKysrKysrKwo+IMKgMiBmaWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCsp
Cj4gCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oIGIvaW5jbHVkZS9u
ZXQvZmxvd19vZmZsb2FkLmgKPiBpbmRleCA3YTYwYmM2ZDcyYzkuLjA0MDBhMGFjOGEyOSAxMDA2
NDQKPiAtLS0gYS9pbmNsdWRlL25ldC9mbG93X29mZmxvYWQuaAo+ICsrKyBiL2luY2x1ZGUvbmV0
L2Zsb3dfb2ZmbG9hZC5oCj4gQEAgLTMyLDYgKzMyLDEwIEBAIHN0cnVjdCBmbG93X21hdGNoX3Zs
YW4gewo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZmxvd19kaXNzZWN0b3Jfa2V5X3ZsYW4gKmtl
eSwgKm1hc2s7Cj4gwqB9Owo+IMKgCj4gK3N0cnVjdCBmbG93X21hdGNoX2FycCB7Cj4gK8KgwqDC
oMKgwqDCoMKgc3RydWN0IGZsb3dfZGlzc2VjdG9yX2tleV9hcnAgKmtleSwgKm1hc2s7Cj4gK307
Cj4gKwo+IMKgc3RydWN0IGZsb3dfbWF0Y2hfaXB2NF9hZGRycyB7Cj4gwqDCoMKgwqDCoMKgwqDC
oHN0cnVjdCBmbG93X2Rpc3NlY3Rvcl9rZXlfaXB2NF9hZGRycyAqa2V5LCAqbWFzazsKPiDCoH07
Cj4gQEAgLTk4LDYgKzEwMiw4IEBAIHZvaWQgZmxvd19ydWxlX21hdGNoX3ZsYW4oY29uc3Qgc3Ry
dWN0IGZsb3dfcnVsZSAqcnVsZSwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgZmxvd19tYXRjaF92bGFuICpvdXQpOwo+IMKgdm9pZCBm
bG93X3J1bGVfbWF0Y2hfY3ZsYW4oY29uc3Qgc3RydWN0IGZsb3dfcnVsZSAqcnVsZSwKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBm
bG93X21hdGNoX3ZsYW4gKm91dCk7Cj4gK3ZvaWQgZmxvd19ydWxlX21hdGNoX2FycChjb25zdCBz
dHJ1Y3QgZmxvd19ydWxlICpydWxlLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBmbG93X21hdGNoX2FycCAqb3V0KTsKPiDCoHZvaWQgZmxv
d19ydWxlX21hdGNoX2lwdjRfYWRkcnMoY29uc3Qgc3RydWN0IGZsb3dfcnVsZSAqcnVsZSwKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgc3RydWN0IGZsb3dfbWF0Y2hfaXB2NF9hZGRycyAqb3V0KTsKPiDCoHZvaWQgZmxvd19y
dWxlX21hdGNoX2lwdjZfYWRkcnMoY29uc3Qgc3RydWN0IGZsb3dfcnVsZSAqcnVsZSwKPiBkaWZm
IC0tZ2l0IGEvbmV0L2NvcmUvZmxvd19vZmZsb2FkLmMgYi9uZXQvY29yZS9mbG93X29mZmxvYWQu
Ywo+IGluZGV4IGFiZTQyM2ZkNTczNi4uYWNmYzFmODhlYTc5IDEwMDY0NAo+IC0tLSBhL25ldC9j
b3JlL2Zsb3dfb2ZmbG9hZC5jCj4gKysrIGIvbmV0L2NvcmUvZmxvd19vZmZsb2FkLmMKPiBAQCAt
OTcsNiArOTcsMTMgQEAgdm9pZCBmbG93X3J1bGVfbWF0Y2hfY3ZsYW4oY29uc3Qgc3RydWN0IGZs
b3dfcnVsZSAqcnVsZSwKPiDCoH0KPiDCoEVYUE9SVF9TWU1CT0woZmxvd19ydWxlX21hdGNoX2N2
bGFuKTsKPiDCoAo+ICt2b2lkIGZsb3dfcnVsZV9tYXRjaF9hcnAoY29uc3Qgc3RydWN0IGZsb3df
cnVsZSAqcnVsZSwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBzdHJ1Y3QgZmxvd19tYXRjaF9hcnAgKm91dCkKPiArewo+ICvCoMKgwqDCoMKgwqDCoEZM
T1dfRElTU0VDVE9SX01BVENIKHJ1bGUsIEZMT1dfRElTU0VDVE9SX0tFWV9BUlAsIG91dCk7Cj4g
K30KPiArRVhQT1JUX1NZTUJPTChmbG93X3J1bGVfbWF0Y2hfYXJwKTsKPiArCj4gwqB2b2lkIGZs
b3dfcnVsZV9tYXRjaF9pcHY0X2FkZHJzKGNvbnN0IHN0cnVjdCBmbG93X3J1bGUgKnJ1bGUsCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHN0cnVjdCBmbG93X21hdGNoX2lwdjRfYWRkcnMgKm91dCkKPiDCoHsKCg==

