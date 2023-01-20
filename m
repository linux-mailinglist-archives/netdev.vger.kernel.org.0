Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D1367514D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjATJg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjATJg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:36:56 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3810D3C14;
        Fri, 20 Jan 2023 01:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674207416; x=1705743416;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ej2ql3BCd24o4epXI8BXM37w0JnlC2KIwMbHEs3WT7A=;
  b=d7LTrP5PRezXTNxqjpfQ23O5E+7t3wyeE/l40+u2y8M5EF0WlHskEG3y
   H8YKN2iPmFU+8vTwsuuM/r1CqdTew/QakNe0zI7uPvka41rfTKv4qcMBN
   adWsGrb7k7gD8vrp8J92cBv+FJ8d1C68NcdxAPGF3Me/ShvsG/Wa9FkC2
   ObZUF82YBZWw705sGyjUxFAzyo9A54NRyu1VJQ3BOC6U5XwgjG/FjsErm
   pB7hA0KWX1qSIaNnp/LHtdEAUA9afcswXz3czk5LILMKmZU3th+TwBlvy
   9SrK+PY7c72cS7XwEj1PmkYSID7g4Hl5PvcsBVqKbQ7kD8GMD7tU4WIhh
   g==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="193125478"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 02:36:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 02:36:52 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 02:36:49 -0700
Message-ID: <ef0fb089409e1bacecbd2f6d00e09d85253e2637.camel@microchip.com>
Subject: Re: [PATCH net-next 4/8] net: microchip: sparx5: Add TC support for
 IS0 VCAP
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
Date:   Fri, 20 Jan 2023 10:36:48 +0100
In-Reply-To: <Y8pbHvJpvuIuCXws@kadam>
References: <20230120090831.20032-1-steen.hegelund@microchip.com>
         <20230120090831.20032-5-steen.hegelund@microchip.com>
         <Y8pbHvJpvuIuCXws@kadam>
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

SGkgRGFuLAoKT24gRnJpLCAyMDIzLTAxLTIwIGF0IDEyOjEzICswMzAwLCBEYW4gQ2FycGVudGVy
IHdyb3RlOgo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRh
Y2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlCj4gY29udGVudCBpcyBzYWZlCj4gCj4gT24gRnJp
LCBKYW4gMjAsIDIwMjMgYXQgMTA6MDg6MjdBTSArMDEwMCwgU3RlZW4gSGVnZWx1bmQgd3JvdGU6
Cj4gPiAtLyogQWRkIGEgcnVsZSBjb3VudGVyIGFjdGlvbiAtIG9ubHkgSVMyIGlzIGNvbnNpZGVy
ZWQgZm9yIG5vdyAqLwo+ID4gKy8qIEFkZCBhIHJ1bGUgY291bnRlciBhY3Rpb24gKi8KPiA+IMKg
c3RhdGljIGludCBzcGFyeDVfdGNfYWRkX3J1bGVfY291bnRlcihzdHJ1Y3QgdmNhcF9hZG1pbiAq
YWRtaW4sCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCB2Y2FwX3J1bGUgKnZydWxlKQo+ID4gwqB7
Cj4gPiAtwqDCoMKgwqAgaW50IGVycjsKPiA+ICvCoMKgwqDCoCBpbnQgZXJyID0gMDsKPiAKPiBE
b24ndCBpbml0aWFsaXplLgoKWWVwLiBObyBuZWVkIGZvciB0aGF0LgoKPiAKPiA+IAo+ID4gLcKg
wqDCoMKgIGVyciA9IHZjYXBfcnVsZV9tb2RfYWN0aW9uX3UzMih2cnVsZSwgVkNBUF9BRl9DTlRf
SUQsIHZydWxlLT5pZCk7Cj4gPiAtwqDCoMKgwqAgaWYgKGVycikKPiA+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIGVycjsKPiA+ICvCoMKgwqDCoCBpZiAoYWRtaW4tPnZ0eXBlID09
IFZDQVBfVFlQRV9JUzIpIHsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZXJyID0gdmNh
cF9ydWxlX21vZF9hY3Rpb25fdTMyKHZydWxlLCBWQ0FQX0FGX0NOVF9JRCwKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2cnVsZS0+aWQpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAoZXJyKQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIGVycjsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmNhcF9ydWxl
X3NldF9jb3VudGVyX2lkKHZydWxlLCB2cnVsZS0+aWQpOwo+ID4gK8KgwqDCoMKgIH0KPiA+IAo+
ID4gLcKgwqDCoMKgIHZjYXBfcnVsZV9zZXRfY291bnRlcl9pZCh2cnVsZSwgdnJ1bGUtPmlkKTsK
PiA+IMKgwqDCoMKgwqAgcmV0dXJuIGVycjsKPiAKPiByZXR1cm4gMDsKCkkgd2lsbCB1cGRhdGUg
dGhhdC4KPiAKPiA+IMKgfQo+IAo+IHJlZ2FyZHMsCj4gZGFuIGNhcnBlbnRlcgoKVGhhbmtzIGZv
ciB0aGUgcmV2aWV3LgoKQlIKU3RlZW4K

