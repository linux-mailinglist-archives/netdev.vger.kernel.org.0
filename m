Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBF05A2451
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343746AbiHZJ2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343828AbiHZJ1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:27:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60705D86C2
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 02:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661506073; x=1693042073;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=v2TmHKoqxyXsErcqxq16d/2YIfY3nuggmkuZHR39dHE=;
  b=1i8LLn1UooFNPW/G+4mGZjN32HusH6aoCJq1kavXQqgqb3IwLT+vILlc
   34OGVlbe1kj6U5wCdJp8zipil44KCsYmKjjXLisVoAsiY4BLAwA4SedBH
   TK1QjTS5Q6ECrqzkuuI5tYHTW6atxvlMMH+WsXDLz70C/mSKg7AgFXZgn
   uqopNPKpGyy8HjebIy4FcQe9f+j5BaT/3PZ35OUZDKAYlE2rkOprZKbDu
   t7njJHlZv0CF2/148PiEIHJqxNGPTriLNWn36DwU24tUtlLFJL3eJxWlA
   lKIRHp9eHptSXq65vcoTOId/ewLPoiDf5ci816T5w1qQ7L4wOQuQy10OD
   w==;
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="177854825"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Aug 2022 02:27:52 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 26 Aug 2022 02:27:51 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 26 Aug 2022 02:27:49 -0700
Message-ID: <0aa915ca7e7c79daa0b323c3903aff2ba2cc25b3.camel@microchip.com>
Subject: Re: [PATCH net] net: sparx5: fix handling uneven length packets in
 manual extraction
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Lars Povlsen <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>
Date:   Fri, 26 Aug 2022 11:27:49 +0200
In-Reply-To: <20220825084955.684637-1-casper.casan@gmail.com>
References: <20220825084955.684637-1-casper.casan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2FzcGVyLAoKR29vZCBDYXRjaC4KCk9uIFRodSwgMjAyMi0wOC0yNSBhdCAxMDo0OSArMDIw
MCwgQ2FzcGVyIEFuZGVyc3NvbiB3cm90ZToKPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNr
IGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlz
IHNhZmUKPiAKPiBQYWNrZXRzIHRoYXQgYXJlIG5vdCBvZiBsZW5ndGggZGl2aXNpYmxlIGJ5IDQg
KGUuZy4gNzcsIDc4LCA3OSkgd291bGQKPiBoYXZlIHRoZSBjaGVja3N1bSBpbmNsdWRlZCB1cCB0
byBuZXh0IG11bHRpcGxlIG9mIDQgKGEgNzcgYnl0ZXMgcGFja2V0Cj4gd291bGQgaGF2ZSAzIGJ5
dGVzIG9mIGV0aGVybmV0IGNoZWNrc3VtIGluY2x1ZGVkKS4gVGhlIGNoZWNrIGZvciB0aGUKPiB2
YWx1ZSBleHBlY3RzIGl0IGluIGhvc3QgKExpdHRsZSkgZW5kaWFuLgo+IAo+IEZpeGVzOiBmM2Nh
ZDI2MTFhNzcgKCJuZXQ6IHNwYXJ4NTogYWRkIGhvc3Rtb2RlIHdpdGggcGh5bGluayBzdXBwb3J0
IikKPiBTaWduZWQtb2ZmLWJ5OiBDYXNwZXIgQW5kZXJzc29uIDxjYXNwZXIuY2FzYW5AZ21haWwu
Y29tPgo+IC0tLQo+IMKgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL3NwYXJ4NS9zcGFy
eDVfcGFja2V0LmMgfCAyICsrCj4gwqAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCj4g
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21pY3JvY2hpcC9zcGFyeDUvc3Bh
cng1X3BhY2tldC5jCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9taWNyb2NoaXAvc3Bhcng1L3Nw
YXJ4NV9wYWNrZXQuYwo+IGluZGV4IDMwNGY4NGFhZGMzNi4uMjE4NDRiZWJhNzJkIDEwMDY0NAo+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21pY3JvY2hpcC9zcGFyeDUvc3Bhcng1X3BhY2tl
dC5jCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL3NwYXJ4NS9zcGFyeDVf
cGFja2V0LmMKPiBAQCAtMTEzLDYgKzExMyw4IEBAIHN0YXRpYyB2b2lkIHNwYXJ4NV94dHJfZ3Jw
KHN0cnVjdCBzcGFyeDUgKnNwYXJ4NSwgdTggZ3JwLCBib29sIGJ5dGVfc3dhcCkKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIFRoaXMgYXNzdW1lcyBT
VEFUVVNfV09SRF9QT1MgPT0gMSwgU3RhdHVzCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgICoganVzdCBhZnRlciBsYXN0IGRhdGEKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKCFieXRlX3N3YXApCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2
YWwgPSBudG9obCgoX19mb3JjZSBfX2JlMzIpdmFsKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJ5dGVfY250IC09ICg0IC0gWFRSX1ZBTElEX0JZVEVT
KHZhbCkpOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
ZW9mX2ZsYWcgPSB0cnVlOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgYnJlYWs7Cj4gLS0KPiAyLjM0LjEKPiAKUmV2aWV3ZWQtYnk6IFN0ZWVuIEhlZ2Vs
dW5kIDxTdGVlbi5IZWdlbHVuZEBtaWNyb2NoaXAuY29tPgoKLS0gCkJlc3QgUmVnYXJkcwpTdGVl
bgoKLT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPQpzdGVlbi5oZWdlbHVuZEBtaWNyb2NoaXAu
Y29tCgo=

