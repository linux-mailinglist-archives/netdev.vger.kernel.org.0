Return-Path: <netdev+bounces-11050-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D03A87315B1
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACDA51C20B5D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C89620EE;
	Thu, 15 Jun 2023 10:46:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2814D138A
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 10:46:00 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB251FE4;
	Thu, 15 Jun 2023 03:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686825957; x=1718361957;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Hx4vjWtNoUgGVQN3qQcXeqlxmDhDgyTOOSXzVVU5UPU=;
  b=h2tC/nYNrOOC94MlqR2KFOdA2ecvE1S9t0Ug04vz6N2+NOtQFILdzydg
   rxa7RaBdccySoZE8VOlAa9scPE9KbV+s/cdJ6EcAsJWz3x270+6kEQtrq
   ZzprWUkggprGup1Q/f+/eBskOmXdWc6by64jKn1NThgLsxCmYflsmMn2s
   EjjjKJN56suRLBZOT0nyyM7Ps6ziwBRWXjOQySI7I4DKc8qLGi5l8KKAY
   5Tw7qJKsJ04fM0HdgARtems6b1XdB2gq5xMU3dAk4xOpmpcYhbDb79pFr
   DHhrxAmyXQ+oQOQe4PTgAKrMa9LRm1NgxS3SpddVUYoKck/M/uJy27Uci
   A==;
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="218005591"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2023 03:45:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 15 Jun 2023 03:45:51 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Thu, 15 Jun 2023 03:45:47 -0700
Message-ID: <255b4de132365501c6e1e97246c30d9729860546.camel@microchip.com>
Subject: Re: [PATCH v7 01/22] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
From: Steen Hegelund <steen.hegelund@microchip.com>
To: Dmitry Safonov <dima@arista.com>, David Ahern <dsahern@kernel.org>, "Eric
 Dumazet" <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, "Jakub
 Kicinski" <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
	"Ard Biesheuvel" <ardb@kernel.org>, Bob Gilligan <gilligan@arista.com>, "Dan
 Carpenter" <error27@gmail.com>, David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>, Donald Cassidy <dcassidy@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>, "Eric W. Biederman"
	<ebiederm@xmission.com>, Francesco Ruggeri <fruggeri05@gmail.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>, Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>, <netdev@vger.kernel.org>
Date: Thu, 15 Jun 2023 12:45:46 +0200
In-Reply-To: <20230614230947.3954084-2-dima@arista.com>
References: <20230614230947.3954084-1-dima@arista.com>
	 <20230614230947.3954084-2-dima@arista.com>
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
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgRG1pdHJ5LAoKT24gVGh1LCAyMDIzLTA2LTE1IGF0IDAwOjA5ICswMTAwLCBEbWl0cnkgU2Fm
b25vdiB3cm90ZToKPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZQo+IGNvbnRlbnQgaXMgc2FmZQo+IAo+IFRD
UC1BTywgc2ltaWxhcmx5IHRvIFRDUC1NRDUsIG5lZWRzIHRvIGFsbG9jYXRlIHRmbXMgb24gYSBz
bG93LXBhdGgsCj4gd2hpY2ggaXMgc2V0c29ja29wdCgpIGFuZCB1c2UgY3J5cHRvIGFoYXNoIHJl
cXVlc3RzIG9uIGZhc3QgcGF0aHMsCj4gd2hpY2ggYXJlIFJYL1RYIHNvZnRpcnFzLiBBbHNvLCBp
dCBuZWVkcyBhIHRlbXBvcmFyeS9zY3JhdGNoIGJ1ZmZlcgo+IGZvciBwcmVwYXJpbmcgdGhlIGhh
c2guCj4gCj4gUmV3b3JrIHRjcF9tZDVzaWdfcG9vbCBpbiBvcmRlciB0byBzdXBwb3J0IG90aGVy
IGhhc2hpbmcgYWxnb3JpdGhtcwo+IHRoYW4gTUQ1LiBJdCB3aWxsIG1ha2UgaXQgcG9zc2libGUg
dG8gc2hhcmUgcHJlLWFsbG9jYXRlZCBjcnlwdG9fYWhhc2gKPiBkZXNjcmlwdG9ycyBhbmQgc2Ny
YXRjaCBhcmVhIGJldHdlZW4gYWxsIFRDUCBoYXNoIHVzZXJzLgo+IAo+IEludGVybmFsbHkgdGNw
X3NpZ3Bvb2wgY2FsbHMgY3J5cHRvX2Nsb25lX2FoYXNoKCkgQVBJIG92ZXIgcHJlLWFsbG9jYXRl
ZAo+IGNyeXB0byBhaGFzaCB0Zm0uIEt1ZG9zIHRvIEhlcmJlcnQsIHdobyBwcm92aWRlZCB0aGlz
IG5ldyBjcnlwdG8gQVBJLgo+IAo+IEkgd2FzIGEgbGl0dGxlIGNvbmNlcm5lZCBvdmVyIEdGUF9B
VE9NSUMgYWxsb2NhdGlvbnMgb2YgYWhhc2ggYW5kCj4gY3J5cHRvX3JlcXVlc3QgaW4gUlgvVFgg
KHNlZSB0Y3Bfc2lncG9vbF9zdGFydCgpKSwgc28gSSBiZW5jaG1hcmtlZCBib3RoCj4gImJhY2tl
bmRzIiB3aXRoIGRpZmZlcmVudCBhbGdvcml0aG1zLCB1c2luZyBwYXRjaGVkIHZlcnNpb24gb2Yg
aXBlcmYzWzJdLgo+IE9uIG15IGxhcHRvcCB3aXRoIGk3LTc2MDBVIEAgMi44MEdIejoKPiAKCi4u
LiBzbmlwIC4uLgoKPiArLyoqCj4gKyAqIHRjcF9zaWdwb29sX2FsbG9jX2FoYXNoIC0gYWxsb2Nh
dGVzIHBvb2wgZm9yIGFoYXNoIHJlcXVlc3RzCj4gKyAqIEBhbGc6IG5hbWUgb2YgYXN5bmMgaGFz
aCBhbGdvcml0aG0KPiArICogQHNjcmF0Y2hfc2l6ZTogcmVzZXJ2ZSBhIHRjcF9zaWdwb29sOjpz
Y3JhdGNoIGJ1ZmZlciBvZiB0aGlzIHNpemUKPiArICovCj4gK2ludCB0Y3Bfc2lncG9vbF9hbGxv
Y19haGFzaChjb25zdCBjaGFyICphbGcsIHNpemVfdCBzY3JhdGNoX3NpemUpCj4gK3sKPiArwqDC
oMKgwqDCoMKgIGludCBpLCByZXQ7Cj4gKwo+ICvCoMKgwqDCoMKgwqAgLyogc2xvdy1wYXRoICov
Cj4gK8KgwqDCoMKgwqDCoCBtdXRleF9sb2NrKCZjcG9vbF9tdXRleCk7Cj4gK8KgwqDCoMKgwqDC
oCByZXQgPSBzaWdwb29sX3Jlc2VydmVfc2NyYXRjaChzY3JhdGNoX3NpemUpOwo+ICvCoMKgwqDC
oMKgwqAgaWYgKHJldCkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsK
PiArwqDCoMKgwqDCoMKgIGZvciAoaSA9IDA7IGkgPCBjcG9vbF9wb3B1bGF0ZWQ7IGkrKykgewo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICghY3Bvb2xbaV0uYWxnKQo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb250aW51ZTsKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoc3RyY21wKGNwb29sW2ldLmFsZywgYWxnKSkK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29udGludWU7
Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChrcmVmX3JlYWQoJmNwb29s
W2ldLmtyZWYpID4gMCkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAga3JlZl9nZXQoJmNwb29sW2ldLmtyZWYpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGVsc2UKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAga3JlZl9pbml0KCZjcG9vbFtpXS5rcmVmKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCByZXQgPSBpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gb3V0Owo+
ICvCoMKgwqDCoMKgwqAgfQoKSGVyZSBpdCBsb29rcyB0byBtZSBsaWtlIHlvdSB3aWxsIG5ldmVy
IGdldCB0byB0aGlzIHBhcnQgb2YgdGhlIGNvZGUgc2luY2UgeW91CmFsd2F5cyBlbmQgdXAgZ29p
bmcgdG8gdGhlIG91dCBsYWJlbCBpbiB0aGUgcHJldmlvdXMgbG9vcC4KCj4gKwo+ICvCoMKgwqDC
oMKgwqAgZm9yIChpID0gMDsgaSA8IGNwb29sX3BvcHVsYXRlZDsgaSsrKSB7Cj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKCFjcG9vbFtpXS5hbGcpCj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOwo+ICvCoMKgwqDCoMKgwqAgfQo+
ICvCoMKgwqDCoMKgwqAgaWYgKGkgPj0gQ1BPT0xfU0laRSkgewo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHJldCA9IC1FTk9TUEM7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgZ290byBvdXQ7Cj4gK8KgwqDCoMKgwqDCoCB9Cj4gKwo+ICvCoMKgwqDCoMKgwqAgcmV0ID0g
X19jcG9vbF9hbGxvY19haGFzaCgmY3Bvb2xbaV0sIGFsZyk7Cj4gK8KgwqDCoMKgwqDCoCBpZiAo
IXJldCkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IGk7Cj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGkgPT0gY3Bvb2xfcG9wdWxhdGVkKQo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjcG9vbF9wb3B1bGF0ZWQr
KzsKPiArwqDCoMKgwqDCoMKgIH0KPiArb3V0Ogo+ICvCoMKgwqDCoMKgwqAgbXV0ZXhfdW5sb2Nr
KCZjcG9vbF9tdXRleCk7Cj4gK8KgwqDCoMKgwqDCoCByZXR1cm4gcmV0Owo+ICt9Cj4gK0VYUE9S
VF9TWU1CT0xfR1BMKHRjcF9zaWdwb29sX2FsbG9jX2FoYXNoKTsKPiArCgouLi4gc25pcCAuLi4K
Cgo+IMKgY2xlYXJfaGFzaDoKPiAtwqDCoMKgwqDCoMKgIHRjcF9wdXRfbWQ1c2lnX3Bvb2woKTsK
PiAtY2xlYXJfaGFzaF9ub3B1dDoKPiArwqDCoMKgwqDCoMKgIHRjcF9zaWdwb29sX2VuZCgmaHAp
Owo+ICtjbGVhcl9oYXNoX25vc3RhcnQ6Cj4gwqDCoMKgwqDCoMKgwqAgbWVtc2V0KG1kNV9oYXNo
LCAwLCAxNik7Cj4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDE7Cj4gwqB9Cj4gLS0KPiAyLjQwLjAK
PiAKPiAKCkJSClN0ZWVuCg==


