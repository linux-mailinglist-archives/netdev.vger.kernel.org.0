Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3315869464B
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 13:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjBMMug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 07:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBMMuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 07:50:35 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6083AB6;
        Mon, 13 Feb 2023 04:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676292629; x=1707828629;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=UB3JMVgsvcRlgpqs7yOTCnMRa0t0rNkSKFS1hu7Qga0=;
  b=wF7JFeal/14iDyRVBdWK+xLHppXEu1AMWXDxm8jFJUvZufRCXFJAIsDT
   gNOU3ZS5euQZsB2AY1FZk96xSozRgFKcQluKro68chIlFhVVe0yYU0qqO
   /YoTUZSuCTlCmv7btEP9u5QTFpzJly6La6kznOyZj/1RsuFdByqmICmq5
   sdOpD6aVN8prwJW1QHEAJ9P9n4KSsfmrTRkCLw6R1XjK3yuGfg+GObII7
   VyhZsAkrDomJ0PIYoHJlaw3lWBp4zUD/STnq+lq5HPPBmIbQU7/l9vsHv
   P3/951ox1LkPcGr2pOXZQp+7rOx+d4q2L8BZ9LGsdQ9n3s70B1k6yYu/+
   w==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669100400"; 
   d="scan'208";a="200219144"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2023 05:50:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 05:50:26 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 05:50:23 -0700
Message-ID: <382f9239620edb44cf6b4e6b295e58fe31c45c12.camel@microchip.com>
Subject: Re: [PATCH net-next 10/10] net: microchip: sparx5: Add TC vlan
 action support for the ES0 VCAP
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Dan Carpenter <error27@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        "Russell King" <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Michael Walle <michael@walle.cc>
Date:   Mon, 13 Feb 2023 13:50:23 +0100
In-Reply-To: <Y+oZHpMpW6ODQQpY@kadam>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
         <20230213092426.1331379-11-steen.hegelund@microchip.com>
         <Y+oZHpMpW6ODQQpY@kadam>
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

SGkgRGFuLAoKT24gTW9uLCAyMDIzLTAyLTEzIGF0IDE0OjAzICswMzAwLCBEYW4gQ2FycGVudGVy
IHdyb3RlOgo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRh
Y2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlCj4gY29udGVudCBpcyBzYWZlCj4gCj4gT24gTW9u
LCBGZWIgMTMsIDIwMjMgYXQgMTA6MjQ6MjZBTSArMDEwMCwgU3RlZW4gSGVnZWx1bmQgd3JvdGU6
Cj4gPiArc3RhdGljIGludCBzcGFyeDVfdGNfYWN0aW9uX3ZsYW5fbW9kaWZ5KHN0cnVjdCB2Y2Fw
X2FkbWluICphZG1pbiwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHZjYXBfcnVsZSAqdnJ1
bGUsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBmbG93X2Nsc19vZmZsb2FkICpmY28sCj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBmbG93X2FjdGlvbl9lbnRyeSAqYWN0LAo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB1MTYgdHBpZCkKPiA+ICt7Cj4gPiArwqDCoMKgwqAgaW50IGVyciA9IDA7
Cj4gPiArCj4gPiArwqDCoMKgwqAgc3dpdGNoIChhZG1pbi0+dnR5cGUpIHsKPiA+ICvCoMKgwqDC
oCBjYXNlIFZDQVBfVFlQRV9FUzA6Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGVyciA9
IHZjYXBfcnVsZV9hZGRfYWN0aW9uX3UzMih2cnVsZSwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBWQ0FQX0FGX1BVU0hfT1VURVJfVEFHLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIFNQWDVfT1RBR19UQUdfQSk7Cj4gCj4gVGhpcyBlcnIgYXNzaWdubWVudCBp
cyBuZXZlciB1c2VkLgoKT29wcyEgIEkgd2lsbCB1cGRhdGUgdGhpcy4KCj4gCj4gPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOwo+ID4gK8KgwqDCoMKgIGRlZmF1bHQ6Cj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIE5MX1NFVF9FUlJfTVNHX01PRChmY28tPmNvbW1vbi5leHRh
Y2ssCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgIlZMQU4gbW9kaWZ5IGFjdGlvbiBub3Qgc3VwcG9ydGVkIGluIHRoaXMK
PiA+IFZDQVAiKTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FT1BOT1RT
VVBQOwo+ID4gK8KgwqDCoMKgIH0KPiA+ICsKPiA+ICvCoMKgwqDCoCBzd2l0Y2ggKHRwaWQpIHsK
PiA+ICvCoMKgwqDCoCBjYXNlIEVUSF9QXzgwMjFROgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBlcnIgPSB2Y2FwX3J1bGVfYWRkX2FjdGlvbl91MzIodnJ1bGUsCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgVkNBUF9BRl9UQUdfQV9UUElEX1NFTCwKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBTUFg1X1RQSURfQV84MTAwKTsKPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4gPiArwqDCoMKgwqAgY2FzZSBFVEhfUF84MDIxQUQ6Cj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGVyciA9IHZjYXBfcnVsZV9hZGRfYWN0aW9uX3Uz
Mih2cnVsZSwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBWQ0FQX0FGX1RBR19B
X1RQSURfU0VMLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFNQWDVfVFBJRF9B
Xzg4QTgpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPiA+ICvCoMKgwqDC
oCBkZWZhdWx0Ogo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBOTF9TRVRfRVJSX01TR19N
T0QoZmNvLT5jb21tb24uZXh0YWNrLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJJbnZhbGlkIHZsYW4gcHJvdG8iKTsK
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZXJyID0gLUVJTlZBTDsKPiA+ICvCoMKgwqDC
oCB9Cj4gPiArwqDCoMKgwqAgaWYgKGVycikKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIGVycjsKPiA+ICsKPiA+ICvCoMKgwqDCoCBlcnIgPSB2Y2FwX3J1bGVfYWRkX2FjdGlv
bl91MzIodnJ1bGUsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBWQ0FQX0FGX1RBR19BX1ZJRF9TRUwsCj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBTUFg1X1ZJRF9BX1ZBTCk7Cj4gPiArwqDCoMKgwqAgaWYgKGVycikK
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIGVycjsKPiAKPiByZWdhcmRzLAo+
IGRhbiBjYXJwZW50ZXIKPiAKClRoYW5rcyBmb3IgeW91ciBjb21tZW50cywgYXMgYWx3YXlzIHZl
cnkgaGVscGZ1bC4KCkJSClN0ZWVuCgo=

