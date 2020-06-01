Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D171EB23F
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 01:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgFAXgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 19:36:43 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:59549 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgFAXgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 19:36:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591054601; x=1622590601;
  h=from:to:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=J/MloPbOinRJ95w81UPzW+FxLSViVtVGzpvoTyLM11E=;
  b=RZxK3wAOHv6CMin5dMxgBXCRZ9obWrv84xYhEPiBIL3JP2iPgWCZwwFw
   MM5UMHV9x/2Qdd3ctwiXXfVvBI85t5xZo9erEs3RhTlSWjyNfakuvmq83
   GgvgzIF33CIaUY4r/+N2Gr61rKg5m85UmMgl/lUZo96Vx6jv+cr0f2+0i
   U=;
IronPort-SDR: LkBdX1Jax7kcHTVh6vnZJsyZjBLWu31bHv/02Ku7vm+Mkckt6fxAI0NtZC78idaa9UVK8IjDRw
 A+7M5cTZONqA==
X-IronPort-AV: E=Sophos;i="5.73,462,1583193600"; 
   d="scan'208";a="33842841"
Subject: Re: [PATCH 02/12] xenbus: add freeze/thaw/restore callbacks support
Thread-Topic: [PATCH 02/12] xenbus: add freeze/thaw/restore callbacks support
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 01 Jun 2020 23:36:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id C2C57A1F45;
        Mon,  1 Jun 2020 23:36:24 +0000 (UTC)
Received: from EX13D10UWB001.ant.amazon.com (10.43.161.111) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Jun 2020 23:36:24 +0000
Received: from EX13D07UWB001.ant.amazon.com (10.43.161.238) by
 EX13D10UWB001.ant.amazon.com (10.43.161.111) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Jun 2020 23:36:24 +0000
Received: from EX13D07UWB001.ant.amazon.com ([10.43.161.238]) by
 EX13D07UWB001.ant.amazon.com ([10.43.161.238]) with mapi id 15.00.1497.006;
 Mon, 1 Jun 2020 23:36:23 +0000
From:   "Agarwal, Anchal" <anchalag@amazon.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Thread-Index: AQHWLjS9hSpS5JM2xU+iWpBujRQ276jBTrMAgAK6doA=
Date:   Mon, 1 Jun 2020 23:36:23 +0000
Message-ID: <687F52C0-A277-4D21-8802-3CF1358EEB31@amazon.com>
References: <cover.1589926004.git.anchalag@amazon.com>
 <7fd12227f923eacc5841b47bd69f72b4105843a7.1589926004.git.anchalag@amazon.com>
 <835ca864-3e35-9a82-f3fd-24ca4e2ec06e@oracle.com>
In-Reply-To: <835ca864-3e35-9a82-f3fd-24ca4e2ec06e@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.200]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4B98ACC553D1F40BCA6C165846D175D@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7vyAgICBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9m
IHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBp
cyBzYWZlLg0KDQoNCg0KICAgIE9uIDUvMTkvMjAgNzoyNSBQTSwgQW5jaGFsIEFnYXJ3YWwgd3Jv
dGU6DQogICAgPg0KICAgID4gIGludCB4ZW5idXNfZGV2X3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpk
ZXYpDQogICAgPiAgew0KICAgID4gLSAgICAgaW50IGVycjsNCiAgICA+ICsgICAgIGludCBlcnIg
PSAwOw0KDQoNCiAgICBUaGF0J3Mgbm90IG5lY2Vzc2FyeS4NCkFDSy4NCg0KICAgID4gICAgICAg
c3RydWN0IHhlbmJ1c19kcml2ZXIgKmRydjsNCiAgICA+ICAgICAgIHN0cnVjdCB4ZW5idXNfZGV2
aWNlICp4ZGV2DQogICAgPiAgICAgICAgICAgICAgID0gY29udGFpbmVyX29mKGRldiwgc3RydWN0
IHhlbmJ1c19kZXZpY2UsIGRldik7DQogICAgPiAtDQogICAgPiArICAgICBib29sIHhlbl9zdXNw
ZW5kID0geGVuX3N1c3BlbmRfbW9kZV9pc194ZW5fc3VzcGVuZCgpOw0KICAgID4gICAgICAgRFBS
SU5USygiJXMiLCB4ZGV2LT5ub2RlbmFtZSk7DQogICAgPg0KICAgID4gICAgICAgaWYgKGRldi0+
ZHJpdmVyID09IE5VTEwpDQogICAgPiBAQCAtNjI3LDI0ICs2NDUsMzIgQEAgaW50IHhlbmJ1c19k
ZXZfcmVzdW1lKHN0cnVjdCBkZXZpY2UgKmRldikNCiAgICA+ICAgICAgIGRydiA9IHRvX3hlbmJ1
c19kcml2ZXIoZGV2LT5kcml2ZXIpOw0KICAgID4gICAgICAgZXJyID0gdGFsa190b19vdGhlcmVu
ZCh4ZGV2KTsNCiAgICA+ICAgICAgIGlmIChlcnIpIHsNCiAgICA+IC0gICAgICAgICAgICAgcHJf
d2FybigicmVzdW1lICh0YWxrX3RvX290aGVyZW5kKSAlcyBmYWlsZWQ6ICVpXG4iLA0KICAgID4g
KyAgICAgICAgICAgICBwcl93YXJuKCIlcyAodGFsa190b19vdGhlcmVuZCkgJXMgZmFpbGVkOiAl
aVxuIiwNCg0KDQogICAgUGxlYXNlIHVzZSBkZXZfd2FybigpIGV2ZXJ5d2hlcmUsIHdlIGp1c3Qg
aGFkIGEgYnVuY2ggb2YgcGF0Y2hlcyB0aGF0DQogICAgcmVwbGFjZWQgcHJfd2FybigpLiBJbiBm
YWN0LCAgdGhpcyBpcyBvbmUgb2YgdGhlIGxpbmVzIHRoYXQgZ290IGNoYW5nZWQuDQoNCkFDSy4g
V2lsbCBzZW5kIGZpeGVzIGluIG5leHQgc2VyaWVzDQoNCiAgICA+DQogICAgPiAgaW50IHhlbmJ1
c19kZXZfY2FuY2VsKHN0cnVjdCBkZXZpY2UgKmRldikNCiAgICA+ICB7DQogICAgPiAtICAgICAv
KiBEbyBub3RoaW5nICovDQogICAgPiAtICAgICBEUFJJTlRLKCJjYW5jZWwiKTsNCiAgICA+ICsg
ICAgIGludCBlcnIgPSAwOw0KDQoNCiAgICBBZ2Fpbiwgbm8gbmVlZCB0byBpbml0aWFsaXplLg0K
DQpBQ0suDQogICAgPiArICAgICBzdHJ1Y3QgeGVuYnVzX2RyaXZlciAqZHJ2Ow0KICAgID4gKyAg
ICAgc3RydWN0IHhlbmJ1c19kZXZpY2UgKnhkZXYNCiAgICA+ICsgICAgICAgICAgICAgPSBjb250
YWluZXJfb2YoZGV2LCBzdHJ1Y3QgeGVuYnVzX2RldmljZSwgZGV2KTsNCg0KDQogICAgeGVuZGV2
IHBsZWFzZSB0byBiZSBjb25zaXN0ZW50IHdpdGggb3RoZXIgY29kZS4gQW5kIHVzZSB0b194ZW5i
dXNfZGV2aWNlKCkuDQpBQ0suDQoNCiAgICAtYm9yaXMNCg0KSSB3aWxsIHB1dCB0aGUgZml4ZXMg
aW4gbmV4dCByb3VuZCBvZiBwYXRjaGVzLg0KDQpUaGFua3MsDQpBbmNoYWwNCg0KDQo=
