Return-Path: <netdev+bounces-11307-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E56AC732843
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AA661C20F5A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0146130;
	Fri, 16 Jun 2023 07:00:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D910612C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 07:00:45 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8937D30FB;
	Fri, 16 Jun 2023 00:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686898842; x=1718434842;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=MmKqtmrlh+EYKLQqFwRe8hMCaqMpX+dV2NfE6pRnra0=;
  b=AoFSNwAkxgTsL7UhAHqLcdB6Zx7uJtjKY9669xixrI1bbrorLBwyZGPo
   RoUglJC+Kzt74mwI1LeBgCt0RKqGdnUHVx2Zg7Wl+PPCfmMqi3cAMibMP
   BzO1Ijdfo/bAgDG+LD/9uSByqbtfUdnvZhjFXRR624Jxtn1kLNsIdQCUB
   KvPr3ILFsfwscp1sQ5eu7aw7LTC1ePFetftTgx47Uq/+LDFhEJWtCNL15
   ihRgBRA1cTgUIDK4X88LM4erI7pgpgaA5Ar1YBW8tekeKZF8ZaeDgO7Vw
   2pVdHMkwzigQgMiyAjz/y9xWcoFlB/wqiy0BowjThNXSSkycWSAq87FHi
   g==;
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="218830621"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jun 2023 00:00:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 16 Jun 2023 00:00:41 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 16 Jun 2023 00:00:37 -0700
Message-ID: <3225c5197b80960a66c89214b4823080388963d2.camel@microchip.com>
Subject: Re: [PATCH v7 01/22] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
From: Steen Hegelund <steen.hegelund@microchip.com>
To: Dmitry Safonov <dima@arista.com>
CC: David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, "David S.
 Miller" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>, "Andy
 Lutomirski" <luto@amacapital.net>, Ard Biesheuvel <ardb@kernel.org>, "Bob
 Gilligan" <gilligan@arista.com>, Dan Carpenter <error27@gmail.com>, "David
 Laight" <David.Laight@aculab.com>, Dmitry Safonov <0x7f454c46@gmail.com>,
	Donald Cassidy <dcassidy@redhat.com>, Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>, Francesco Ruggeri
	<fruggeri05@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, "Hideaki
 YOSHIFUJI" <yoshfuji@linux-ipv6.org>, Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>, Salam Noureddine
	<noureddine@arista.com>, <netdev@vger.kernel.org>
Date: Fri, 16 Jun 2023 09:00:36 +0200
In-Reply-To: <21845b01-a915-d80a-8b87-85c6987c7691@arista.com>
References: <20230614230947.3954084-1-dima@arista.com>
	 <20230614230947.3954084-2-dima@arista.com>
	 <255b4de132365501c6e1e97246c30d9729860546.camel@microchip.com>
	 <21845b01-a915-d80a-8b87-85c6987c7691@arista.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.48.3 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgRG1pdHJ5LAoKT24gVGh1LCAyMDIzLTA2LTE1IGF0IDE3OjQ0ICswMTAwLCBEbWl0cnkgU2Fm
b25vdiB3cm90ZToKPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZQo+IGNvbnRlbnQgaXMgc2FmZQo+IAo+IEhp
IFN0ZWVuLAo+IAo+IE9uIDYvMTUvMjMgMTE6NDUsIFN0ZWVuIEhlZ2VsdW5kIHdyb3RlOgo+ID4g
SGkgRG1pdHJ5LAo+ID4gCj4gPiBPbiBUaHUsIDIwMjMtMDYtMTUgYXQgMDA6MDkgKzAxMDAsIERt
aXRyeSBTYWZvbm92IHdyb3RlOgo+IFsuLl0KPiA+ID4gKy8qKgo+ID4gPiArICogdGNwX3NpZ3Bv
b2xfYWxsb2NfYWhhc2ggLSBhbGxvY2F0ZXMgcG9vbCBmb3IgYWhhc2ggcmVxdWVzdHMKPiA+ID4g
KyAqIEBhbGc6IG5hbWUgb2YgYXN5bmMgaGFzaCBhbGdvcml0aG0KPiA+ID4gKyAqIEBzY3JhdGNo
X3NpemU6IHJlc2VydmUgYSB0Y3Bfc2lncG9vbDo6c2NyYXRjaCBidWZmZXIgb2YgdGhpcyBzaXpl
Cj4gPiA+ICsgKi8KPiA+ID4gK2ludCB0Y3Bfc2lncG9vbF9hbGxvY19haGFzaChjb25zdCBjaGFy
ICphbGcsIHNpemVfdCBzY3JhdGNoX3NpemUpCj4gPiA+ICt7Cj4gPiA+ICvCoMKgwqDCoMKgwqAg
aW50IGksIHJldDsKPiA+ID4gKwo+ID4gPiArwqDCoMKgwqDCoMKgIC8qIHNsb3ctcGF0aCAqLwo+
ID4gPiArwqDCoMKgwqDCoMKgIG11dGV4X2xvY2soJmNwb29sX211dGV4KTsKPiA+ID4gK8KgwqDC
oMKgwqDCoCByZXQgPSBzaWdwb29sX3Jlc2VydmVfc2NyYXRjaChzY3JhdGNoX3NpemUpOwo+ID4g
PiArwqDCoMKgwqDCoMKgIGlmIChyZXQpCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGdvdG8gb3V0Owo+ID4gPiArwqDCoMKgwqDCoMKgIGZvciAoaSA9IDA7IGkgPCBjcG9vbF9w
b3B1bGF0ZWQ7IGkrKykgewo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAo
IWNwb29sW2ldLmFsZykKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGNvbnRpbnVlOwo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBp
ZiAoc3RyY21wKGNwb29sW2ldLmFsZywgYWxnKSkKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+ID4gPiArCj4gPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChrcmVmX3JlYWQoJmNwb29sW2ldLmtyZWYpID4gMCkK
PiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGtyZWZf
Z2V0KCZjcG9vbFtpXS5rcmVmKTsKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
ZWxzZQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
a3JlZl9pbml0KCZjcG9vbFtpXS5rcmVmKTsKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcmV0ID0gaTsKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBv
dXQ7Cj4gPiA+ICvCoMKgwqDCoMKgwqAgfQo+ID4gCj4gPiBIZXJlIGl0IGxvb2tzIHRvIG1lIGxp
a2UgeW91IHdpbGwgbmV2ZXIgZ2V0IHRvIHRoaXMgcGFydCBvZiB0aGUgY29kZSBzaW5jZQo+ID4g
eW91Cj4gPiBhbHdheXMgZW5kIHVwIGdvaW5nIHRvIHRoZSBvdXQgbGFiZWwgaW4gdGhlIHByZXZp
b3VzIGxvb3AuCj4gCj4gV2VsbCwgbm90IGV4YWN0bHk6IHRoaXMgcGFydCBpcyBsb29raW5nIGlm
IHRoZSBjcnlwdG8gYWxnb3JpdGhtIGlzCj4gYWxyZWFkeSBpbiB0aGlzIHBvb2wsIHNvIHRoYXQg
aXQgY2FuIGluY3JlbWVudCByZWZjb3VudGVyIHJhdGhlciB0aGFuCj4gaW5pdGlhbGl6ZSBhIG5l
dyB0Zm0uIEluIGNhc2Ugc3RyY21wKGNwb29sW2ldLmFsZywgYWxnKSBmYWlscywgdGhpcyBsb29w
Cj4gd2lsbCBuZXZlciBnb3RvIG91dC4KCkFoLCByaWdodCwgeW91IG5ldmVyIGZpbmQgYW55IGFs
Z28gYW5kIHRoZW4gZ2V0IG91dCBhdCB0aGUgZW5kIG9mIHRoZSBsaXN0LgoKPiAKPiBJLmUuLCB5
b3UgaXNzdWVkIHByZXZpb3VzbHkgc2V0c29ja29wdCgpcyBmb3IgVENQLU1ENSBhbmQgVENQLUFP
IHdpdGgKPiBITUFDLVNIQTEsIHNvIGluIHRoaXMgcG9vbCB0aGVyZSdsbCBiZSB0d28gYWxnb3Jp
dGhtczogIm1kNSIgYW5kCj4gImhtYWMoc2hhMSkiLiBOb3cgaWYgeW91IHdhbnQgdG8gdXNlIFRD
UC1BTyB3aXRoICJjbWFjKGFlczEyOCkiIG9yCj4gImhtYWMoc2hhMjU2KSIsIHlvdSB3b24ndCBm
aW5kIHRoZW0gaW4gdGhlIHBvb2wgeWV0Lgo+IAo+ID4gCj4gPiA+ICsKPiA+ID4gK8KgwqDCoMKg
wqDCoCBmb3IgKGkgPSAwOyBpIDwgY3Bvb2xfcG9wdWxhdGVkOyBpKyspIHsKPiA+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKCFjcG9vbFtpXS5hbGcpCj4gPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPiA+ID4gK8KgwqDC
oMKgwqDCoCB9Cj4gPiA+ICvCoMKgwqDCoMKgwqAgaWYgKGkgPj0gQ1BPT0xfU0laRSkgewo+ID4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSAtRU5PU1BDOwo+ID4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsKPiA+ID4gK8KgwqDCoMKgwqDCoCB9
Cj4gPiA+ICsKPiA+ID4gK8KgwqDCoMKgwqDCoCByZXQgPSBfX2Nwb29sX2FsbG9jX2FoYXNoKCZj
cG9vbFtpXSwgYWxnKTsKPiA+ID4gK8KgwqDCoMKgwqDCoCBpZiAoIXJldCkgewo+ID4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBpOwo+ID4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBpZiAoaSA9PSBjcG9vbF9wb3B1bGF0ZWQpCj4gPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjcG9vbF9wb3B1bGF0ZWQrKzsKPiA+
ID4gK8KgwqDCoMKgwqDCoCB9Cj4gPiA+ICtvdXQ6Cj4gPiA+ICvCoMKgwqDCoMKgwqAgbXV0ZXhf
dW5sb2NrKCZjcG9vbF9tdXRleCk7Cj4gPiA+ICvCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsKPiA+
ID4gK30KPiA+ID4gK0VYUE9SVF9TWU1CT0xfR1BMKHRjcF9zaWdwb29sX2FsbG9jX2FoYXNoKTsK
PiA+ID4gKwo+ID4gCj4gPiAuLi4gc25pcCAuLi4KPiA+IAo+ID4gCj4gPiA+IMKgY2xlYXJfaGFz
aDoKPiA+ID4gLcKgwqDCoMKgwqDCoCB0Y3BfcHV0X21kNXNpZ19wb29sKCk7Cj4gPiA+IC1jbGVh
cl9oYXNoX25vcHV0Ogo+ID4gPiArwqDCoMKgwqDCoMKgIHRjcF9zaWdwb29sX2VuZCgmaHApOwo+
ID4gPiArY2xlYXJfaGFzaF9ub3N0YXJ0Ogo+ID4gPiDCoMKgwqDCoMKgwqDCoCBtZW1zZXQobWQ1
X2hhc2gsIDAsIDE2KTsKPiA+ID4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDE7Cj4gPiA+IMKgfQo+
IFRoYW5rcywKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIERtaXRyeQo+IAoKUmV2aWV3ZWQtYnk6
IFN0ZWVuIEhlZ2VsdW5kIDxTdGVlbi5IZWdlbHVuZEBtaWNyb2NoaXAuY29tPgoKQlIKU3RlZW4K



