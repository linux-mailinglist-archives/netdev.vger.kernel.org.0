Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA40421E208
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 23:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgGMV0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 17:26:43 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:10459 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgGMV0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 17:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594675602; x=1626211602;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=kHip+FujKVygAghzNxpEeKx3aczOqdUv0/vZ1Y/rYxo=;
  b=DxNcgZINGC+Q8uEERrVlCmfDKQBieYGfqHPo3++tEu3Lrfgkya558hmR
   pqSMPfSTgY4DLC8sYpcq7Ab13KhjeaGw41grkBvfyTPQqHywS/nl2eqlN
   cQ+CmLui55cwh0kqH4TWKmlWELLohKRsrxZuFJ6V4tnGCNoVFBAyN9P7p
   g=;
IronPort-SDR: fX8lqcK2htMXXB1ksgrKteBIkuQCHLsQO769Q/744JJBL9G8Kw09hAYrjHS6FKrR/phrb9zRNW
 3r2XWL+wLvTw==
X-IronPort-AV: E=Sophos;i="5.75,348,1589241600"; 
   d="scan'208";a="41775692"
Subject: Re: [PATCH V2 net-next 1/7] net: ena: avoid unnecessary rearming of
 interrupt vector when busy-polling
Thread-Topic: [PATCH V2 net-next 1/7] net: ena: avoid unnecessary rearming of interrupt
 vector when busy-polling
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 13 Jul 2020 21:26:38 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 09083A1F96;
        Mon, 13 Jul 2020 21:26:37 +0000 (UTC)
Received: from EX13D17EUB001.ant.amazon.com (10.43.166.85) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 13 Jul 2020 21:26:37 +0000
Received: from EX13D04EUB004.ant.amazon.com (10.43.166.59) by
 EX13D17EUB001.ant.amazon.com (10.43.166.85) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 13 Jul 2020 21:26:36 +0000
Received: from EX13D04EUB004.ant.amazon.com ([10.43.166.59]) by
 EX13D04EUB004.ant.amazon.com ([10.43.166.59]) with mapi id 15.00.1497.006;
 Mon, 13 Jul 2020 21:26:36 +0000
From:   "Bshara, Nafea" <nafea@amazon.com>
To:     "Agroskin, Shay" <shayagr@amazon.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC:     "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>
Thread-Index: AQHWWJzg38vP9s1JxU+8oDTUNJhvBKkFs1gAgAA2HgD//6iHgA==
Date:   Mon, 13 Jul 2020 21:26:35 +0000
Message-ID: <1DFE21D3-2306-4A80-8999-2C0E85E4478C@amazon.com>
References: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
 <1594593371-14045-2-git-send-email-akiyano@amazon.com>
 <3f3cc8e6-a5fd-44f7-7a86-8862e296c40c@gmail.com>
 <pj41zlk0z7rypx.fsf@ua97a68a4e7db56.ant.amazon.com>
In-Reply-To: <pj41zlk0z7rypx.fsf@ua97a68a4e7db56.ant.amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.38.20061401
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.44]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1E9BAE0DCA9AC428754EEE3C837F051@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQogICAgPj4NCiAgICA+PiBBcyBleHBsYWluZWQsIGEgYnVzeS1wb2xsIHNlc3Npb24gZXhpc3Rz
IGZvciBhIHNwZWNpZmllZCB0aW1lb3V0DQogICAgPj4gdmFsdWUsIGFmdGVyIHdoaWNoIGl0IGV4
aXRzIHRoZSBidXN5LXBvbGwgbW9kZSBhbmQgcmUtZW50ZXJzIGl0IGxhdGVyLg0KICAgID4+IFRo
aXMgbGVhZHMgdG8gbWFueSBpbnZvY2F0aW9ucyBvZiB0aGUgbmFwaSBoYW5kbGVyIHdoZXJlDQog
ICAgPj4gbmFwaV9jb21wbGV0ZV9kb25lKCkgZmFsc2UgaW5kaWNhdGVzIHRoYXQgaW50ZXJydXB0
cyBzaG91bGQgYmUNCiAgICA+PiByZS1lbmFibGVkLg0KICAgID4+IFRoaXMgY3JlYXRlcyBhIGJ1
ZyBpbiB3aGljaCB0aGUgaW50ZXJydXB0cyBhcmUgcmUtZW5hYmxlZA0KICAgID4+IHVubmVjZXNz
YXJpbHkuDQogICAgPj4gVG8gcmVwcm9kdWNlIHRoaXMgYnVnOg0KICAgID4+ICAgICAxKSBlY2hv
IDUwIHwgc3VkbyB0ZWUgL3Byb2Mvc3lzL25ldC9jb3JlL2J1c3lfcG9sbA0KICAgID4+ICAgICAy
KSBlY2hvIDUwIHwgc3VkbyB0ZWUgL3Byb2Mvc3lzL25ldC9jb3JlL2J1c3lfcmVhZA0KICAgID4+
ICAgICAzKSBBZGQgY291bnRlcnMgdGhhdCBjaGVjayB3aGV0aGVyDQogICAgPj4gICAgICdlbmFf
dW5tYXNrX2ludGVycnVwdCh0eF9yaW5nLCByeF9yaW5nKTsnDQogICAgPj4gICAgIGlzIGNhbGxl
ZCB3aXRob3V0IGRpc2FibGluZyB0aGUgaW50ZXJydXB0cyBpbiB0aGUgZmlyc3QNCiAgICA+PiAg
ICAgcGxhY2UgKGkuZS4gd2l0aCBjYWxsaW5nIHRoZSBpbnRlcnJ1cHQgcm91dGluZQ0KICAgID4+
ICAgICBlbmFfaW50cl9tc2l4X2lvKCkpDQogICAgPj4NCiAgICA+PiBTdGVwcyAxKzIgZW5hYmxl
IGJ1c3ktcG9sbCBhcyB0aGUgZGVmYXVsdCBtb2RlIGZvciBuZXcgY29ubmVjdGlvbnMuDQogICAg
Pj4NCiAgICA+PiBUaGUgYnVzeSBwb2xsIHJvdXRpbmUgcmVhcm1zIHRoZSBpbnRlcnJ1cHRzIGFm
dGVyIGV2ZXJ5IHNlc3Npb24gYnkNCiAgICA+PiBkZXNpZ24sIGFuZCBzbyB3ZSBuZWVkIHRvIGFk
ZCBhbiBleHRyYSBjaGVjayB0aGF0IHRoZSBpbnRlcnJ1cHRzIHdlcmUNCiAgICA+PiBtYXNrZWQg
aW4gdGhlIGZpcnN0IHBsYWNlLg0KICAgID4+DQogICAgPj4gU2lnbmVkLW9mZi1ieTogU2hheSBB
Z3Jvc2tpbiA8c2hheWFnckBhbWF6b24uY29tPg0KICAgID4+IFNpZ25lZC1vZmYtYnk6IEFydGh1
ciBLaXlhbm92c2tpIDxha2l5YW5vQGFtYXpvbi5jb20+DQogICAgPj4gLS0tDQogICAgPj4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX25ldGRldi5jIHwgNyArKysrKystDQog
ICAgPj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX25ldGRldi5oIHwgMSAr
DQogICAgPj4gIDIgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQogICAgPj4NCiAgICA+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9u
L2VuYS9lbmFfbmV0ZGV2LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hbWF6b24vZW5hL2VuYV9u
ZXRkZXYuYw0KICAgID4+IGluZGV4IDkxYmUzZmZhMWM1Yy4uOTBjMGZlMTVjZDIzIDEwMDY0NA0K
ICAgID4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX25ldGRldi5j
DQogICAgPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfbmV0ZGV2
LmMNCiAgICA+PiBAQCAtMTkxMyw3ICsxOTEzLDkgQEAgc3RhdGljIGludCBlbmFfaW9fcG9sbChz
dHJ1Y3QgbmFwaV9zdHJ1Y3QgKm5hcGksIGludCBidWRnZXQpDQogICAgPj4gICAgICAgICAgICAg
ICAvKiBVcGRhdGUgbnVtYSBhbmQgdW5tYXNrIHRoZSBpbnRlcnJ1cHQgb25seSB3aGVuIHNjaGVk
dWxlDQogICAgPj4gICAgICAgICAgICAgICAgKiBmcm9tIHRoZSBpbnRlcnJ1cHQgY29udGV4dCAo
dnMgZnJvbSBza19idXN5X2xvb3ApDQogICAgPj4gICAgICAgICAgICAgICAgKi8NCiAgICA+PiAt
ICAgICAgICAgICAgIGlmIChuYXBpX2NvbXBsZXRlX2RvbmUobmFwaSwgcnhfd29ya19kb25lKSkg
ew0KICAgID4+ICsgICAgICAgICAgICAgaWYgKG5hcGlfY29tcGxldGVfZG9uZShuYXBpLCByeF93
b3JrX2RvbmUpICYmDQogICAgPj4gKyAgICAgICAgICAgICAgICAgUkVBRF9PTkNFKGVuYV9uYXBp
LT5pbnRlcnJ1cHRzX21hc2tlZCkpIHsNCiAgICA+PiArICAgICAgICAgICAgICAgICAgICAgV1JJ
VEVfT05DRShlbmFfbmFwaS0+aW50ZXJydXB0c19tYXNrZWQsIGZhbHNlKTsNCiAgICA+PiAgICAg
ICAgICAgICAgICAgICAgICAgLyogV2UgYXBwbHkgYWRhcHRpdmUgbW9kZXJhdGlvbiBvbiBSeCBw
YXRoIG9ubHkuDQogICAgPj4gICAgICAgICAgICAgICAgICAgICAgICAqIFR4IHVzZXMgc3RhdGlj
IGludGVycnVwdCBtb2RlcmF0aW9uLg0KICAgID4+ICAgICAgICAgICAgICAgICAgICAgICAgKi8N
CiAgICA+PiBAQCAtMTk2MSw2ICsxOTYzLDkgQEAgc3RhdGljIGlycXJldHVybl90IGVuYV9pbnRy
X21zaXhfaW8oaW50IGlycSwgdm9pZCAqZGF0YSkNCiAgICA+Pg0KICAgID4+ICAgICAgIGVuYV9u
YXBpLT5maXJzdF9pbnRlcnJ1cHQgPSB0cnVlOw0KICAgID4+DQogICAgPj4gKyAgICAgV1JJVEVf
T05DRShlbmFfbmFwaS0+aW50ZXJydXB0c19tYXNrZWQsIHRydWUpOw0KICAgID4+ICsgICAgIHNt
cF93bWIoKTsgLyogd3JpdGUgaW50ZXJydXB0c19tYXNrZWQgYmVmb3JlIGNhbGxpbmcgbmFwaSAq
Lw0KICAgID4NCiAgICA+IEl0IGlzIG5vdCBjbGVhciB3aGVyZSBpcyB0aGUgcGFpcmVkIHNtcF93
bWIoKQ0KICAgID4NCiAgICBDYW4geW91IHBsZWFzZSBleHBsYWluIHdoYXQgeW91IG1lYW4gPyBU
aGUgaWRlYSBvZiBhZGRpbmcgdGhlIHN0b3JlIGJhcnJpZXIgaGVyZSBpcyB0byBlbnN1cmUgdGhh
dCB0aGUgV1JJVEVfT05DRSjigKYpIGludm9jYXRpb24gaXMgZXhlY3V0ZWQgYmVmb3JlDQoNCltO
Ql0gVGhlcmUgYXJlIHR3byBhc3BlY3RzIC4gIGlmIHdlIGRvaW5nIHNtcF93bWIoKSB3aGVuIFdS
SVRFX09OQ0UoLi4udHJ1ZSksICB0aGVuIHUgbmVlZCB0byBzbyBzbXBfd21iKCkgaW4gdGhlIHBs
YWNlIHUgZG8gV1JJVEVfT05DRSguLi5mYWxzZSkNCg0KW05CXSBFcmljIGFsc28gaGlnaGxpZ2h0
ZWQgbmVlZCBmb3Igc21wX3JtYigpLiAgVGhhdCdzIG5vdCBuZWVkZWQgaGVyZSBpbiBteSBvcGlu
aW9uDQpbTkJdIGFzIHRoZSBtYWluIG9iamVjdGl2ZSBpcyB0byBtYWtlIHRoZSB3cml0ZSBvYnNl
cnZhYmxlIGFjcm9zcyBhbGwgdGhlIGNvcmVzIGluIENQVXMgdGhhdCBoYXZlIHdlYWtlciBjb25z
aXN0ZW5jeSBtb2RlbCBhbmQgZG9u4oCZdCBndWFyYW50ZWUgd3JpdGUgb2JzZXJ2YWJpbGl0eSBh
Y3Jvc3MgYWxsIGNvcmVzIChsaWtlIGFybSBhbmQgcHBjKQ0KDQogICAgaW52b2tpbmcgdGhlIG5h
cGkgc29mdCBpcnEuIEZyb20gd2hhdCBJIGdhdGhlcmVkIHVzaW5nIHRoaXMgY29tbWFuZCB3b3Vs
ZCByZXN1bHQgaW4gY29tcGlsZXIgYmFycmllciAod2hpY2ggd291bGQgcHJldmVudCBpdCBmcm9t
IGV4ZWN1dGluZyB0aGUgYm9vbCBzdG9yZSBhZnRlciBuYXBpIHNjaGVkdWxpbmcpIG9uIHg4Ng0K
ICAgIGFuZCBhIG1lbW9yeSBiYXJyaWVyIG9uIEFSTTY0IG1hY2hpbmVzIHdoaWNoIGhhdmUgYSB3
ZWFrZXIgY29uc2lzdGVuY3kgbW9kZWwuDQogICAgPj4gKw0KICAgID4+ICAgICAgIG5hcGlfc2No
ZWR1bGVfaXJxb2ZmKCZlbmFfbmFwaS0+bmFwaSk7DQogICAgPj4NCiAgICA+PiAgICAgICByZXR1
cm4gSVJRX0hBTkRMRUQ7DQogICAgPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2FtYXpvbi9lbmEvZW5hX25ldGRldi5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2Vu
YS9lbmFfbmV0ZGV2LmgNCiAgICA+PiBpbmRleCBiYTAzMGQyNjA5NDAuLjg5MzA0YjQwMzk5NSAx
MDA2NDQNCiAgICA+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hbWF6b24vZW5hL2VuYV9u
ZXRkZXYuaA0KICAgID4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5h
X25ldGRldi5oDQogICAgPj4gQEAgLTE2Nyw2ICsxNjcsNyBAQCBzdHJ1Y3QgZW5hX25hcGkgew0K
ICAgID4+ICAgICAgIHN0cnVjdCBlbmFfcmluZyAqcnhfcmluZzsNCiAgICA+PiAgICAgICBzdHJ1
Y3QgZW5hX3JpbmcgKnhkcF9yaW5nOw0KICAgID4+ICAgICAgIGJvb2wgZmlyc3RfaW50ZXJydXB0
Ow0KICAgID4+ICsgICAgIGJvb2wgaW50ZXJydXB0c19tYXNrZWQ7DQogICAgPj4gICAgICAgdTMy
IHFpZDsNCiAgICA+PiAgICAgICBzdHJ1Y3QgZGltIGRpbTsNCiAgICA+PiAgfTsNCiAgICA+Pg0K
ICAgID4NCiAgICA+IE5vdGUgdGhhdCB3cml0aW5nL3JlYWRpbmcgb3ZlciBib29sIGZpZWxkcyBm
cm9tIGhhcmQgaXJxIGNvbnRleHQgd2l0aG91dCBwcm9wZXIgc3luYyBpcyBub3QgZ2VuZXJhbGx5
IGFsbG93ZWQuDQogICAgPg0KICAgID4gQ29tcGlsZXIgY291bGQgcGVyZm9ybSBSTVcgb3ZlciBw
bGFpbiAzMmJpdCB3b3Jkcy4NCg0KICAgIERvZXNuJ3QgdGhlIFJFQUQvV1JJVEVfT05DRSBtYWNy
b3MgcHJldmVudCB0aGUgY29tcGlsZXIgZnJvbSByZW9yZGVyaW5nIHRoZXNlIGluc3RydWN0aW9u
cyA/IEFsc28gZnJvbSB3aGF0IEkgcmVzZWFyY2hlZCAocGxlYXNlIGNvcnJlY3QgbWUgaWYgSSdt
IHdyb25nIGhlcmUpDQogICAgYm90aCB4ODYgYW5kIEFSTSBkb24ndCBhbGxvdyByZW9yZGVyaW5n
IExPQUQgYW5kIFNUT1JFIHdoZW4gdGhleSBhY2Nlc3MNCiAgICB0aGUgc2FtZSB2YXJpYWJsZSAo
cmVnaXN0ZXIgb3IgbWVtb3J5IGFkZHJlc3MpLg0KDQpbTkJdIHRoYXQgaXMgdHJ1ZSB3aXRoaW4g
dGhlIHNhbWUgY29yZS4gIEJ1dCBpZiBzdG9yZSBpcyBpbiBpbnRlcnJ1cHQgcm91dGluZSwgYW5k
IGxvYWQgaXMgaW4gbmFwaSwgdGhleSBjb3VsZCBiZSBydW5uaW5nIG9uIGRpZmZlcmVudCBjb3Jl
cyBoZW5jZSB5b3UgdXNlIHNtcF93bWIgdG8gbWFrZSBpdCBvYnNlcnZhYmxlDQpbTkJdIHRoZSBr
ZXkgaW4gdGhpcyBkZXNpZ24gdGhhdCB1IHNldCB0aGUgYml0LCBzZW5kIHNtcF93bWIoKSwgYmVm
b3JlIHdha2luZyB1cCBuYXBpLCBvciBvcmRlcmluZyBhbmQgb2JzZXJ2YWJpbGl0eSBpcyBndWFy
YW50ZWVkDQoNCiAgICA+DQogICAgPiBTb21ldGltZXMgd2UgYWNjZXB0IHRoZSByYWNlcywgYnV0
IGluIHRoaXMgY29udGV4dCB0aGlzIG1pZ2h0IGJlIGJhZC4NCg0KICAgIEFzIGxvbmcgYSB0aGUg
d3JpdGluZyBvZiB0aGUgZmxhZyBpcyBhdG9taWMgaW4gdGhlIHNlbnNlIHRoYXQgdGhlIHZhbHVl
IGluIG1lbW9yeSBpc24ndCBzb21lIGh5YnJpZCB2YWx1ZSBvZiB0d28gcGFyYWxsZWwgc3RvcmVz
LCB0aGUgZXhpc3RpbmcgcmFjZSBjYW5ub3QgcmVzdWx0IGluIGEgZGVhZCBsb2NrIG9yDQogICAg
bGVhdmluZyB0aGUgaW50ZXJydXB0IHZlY3RvciBtYXNrZWQuIEFtIEkgbWlzc2luZyBzb21ldGhp
bmcgPw0KDQpbTkJdIHRoZSByYWNlIHdvdWxkIGV4aXN0IGlmIG5hcGkgd2FzIHJ1bm5pbmcgaW4g
c2FtZSB0aW1lIGludGVycnVwdCByb3V0aW5lIGlzIHJ1bm5pbmcNCltOQl0gYnV0IGluIEVOQSBk
ZXNpZ24sIHRoYXQgd29udCBoYXBwZW4sIGFuZCBpdCBpcyBndWFyYW50ZWUgdGhhdCBvbmx5IG9u
ZSBvZiB0aGVtIGlzIHJ1bm5pbmcgYXQgc2FtZSB0aW1lLCBhcyB0aGUgaW50ZXJydXB0IGlzIHVu
bWFza2VkIG9ubHkgYXQgdGhlIGVuZCBvZiBuYXBpKCkgam9iDQpbTkJdIGFzIEVyaWMgbWVudGlv
biwgdGhpcyBzaG91bGQgYmUgZG9jdW1lbnRlZA0KDQogICAgVGhhbmsgeW91IGZvciB0YWtpbmcg
dGhlIHRpbWUgdG8gbG9vayBhdCB0aGlzIHBhdGNoLg0KDQogICAgU2hheQ0KDQoNCg==
