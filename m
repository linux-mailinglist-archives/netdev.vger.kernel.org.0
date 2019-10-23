Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B09E0FEB
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 04:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388392AbfJWCJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 22:09:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:23177 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731549AbfJWCJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 22:09:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 19:09:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,218,1569308400"; 
   d="scan'208";a="191684403"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga008.jf.intel.com with ESMTP; 22 Oct 2019 19:09:42 -0700
Received: from orsmsx113.amr.corp.intel.com (10.22.240.9) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 22 Oct 2019 19:09:42 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.9]) by
 ORSMSX113.amr.corp.intel.com ([169.254.9.28]) with mapi id 14.03.0439.000;
 Tue, 22 Oct 2019 19:09:41 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "zdai@us.ibm.com" <zdai@us.ibm.com>,
        "zdai@linux.vnet.ibm.com" <zdai@linux.vnet.ibm.com>
Subject: RE: [next-queue PATCH v2 1/2] e1000e: Use rtnl_lock to prevent race
 conditions between net and pci/pm
Thread-Topic: [next-queue PATCH v2 1/2] e1000e: Use rtnl_lock to prevent
 race conditions between net and pci/pm
Thread-Index: AQHVgEl0vjnrdVB+gU+og//4Vqxtw6dnjRqg
Date:   Wed, 23 Oct 2019 02:09:41 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B97154DF9@ORSMSX103.amr.corp.intel.com>
References: <20191011153219.22313.60179.stgit@localhost.localdomain>
 <20191011153452.22313.70522.stgit@localhost.localdomain>
In-Reply-To: <20191011153452.22313.70522.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMTUxYmQxYTMtODcxOC00MGZjLTljYmMtOWY3YWQ5ZDIxNzc1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTHIyRWRXeGNqNVFVVndSYlB5SG9vVUk1Rm16ZFwvaVFwMjhZMGhHdlBMbnNIT1B6bGxFZDV0STQ4NnhuNzZhOWgifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBuZXRkZXYtb3duZXJAdmdlci5rZXJuZWwub3JnIDxuZXRkZXYtb3duZXJAdmdlci5r
ZXJuZWwub3JnPg0KPiBPbiBCZWhhbGYgT2YgQWxleGFuZGVyIER1eWNrDQo+IFNlbnQ6IEZyaWRh
eSwgT2N0b2JlciAxMSwgMjAxOSA4OjM1IEFNDQo+IFRvOiBhbGV4YW5kZXIuaC5kdXlja0BsaW51
eC5pbnRlbC5jb207IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOw0KPiBLaXJzaGVy
LCBKZWZmcmV5IFQgPGplZmZyZXkudC5raXJzaGVyQGludGVsLmNvbT4NCj4gQ2M6IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IHpkYWlAdXMuaWJtLmNvbTsgemRhaUBsaW51eC52bmV0LmlibS5jb20N
Cj4gU3ViamVjdDogW25leHQtcXVldWUgUEFUQ0ggdjIgMS8yXSBlMTAwMGU6IFVzZSBydG5sX2xv
Y2sgdG8gcHJldmVudCByYWNlDQo+IGNvbmRpdGlvbnMgYmV0d2VlbiBuZXQgYW5kIHBjaS9wbQ0K
PiANCj4gRnJvbTogQWxleGFuZGVyIER1eWNrIDxhbGV4YW5kZXIuaC5kdXlja0BsaW51eC5pbnRl
bC5jb20+DQo+IA0KPiBUaGlzIHBhdGNoIGlzIG1lYW50IHRvIGFkZHJlc3MgcG9zc2libGUgcmFj
ZSBjb25kaXRpb25zIHRoYXQgY2FuIGV4aXN0DQo+IGJldHdlZW4gbmV0d29yayBjb25maWd1cmF0
aW9uIGFuZCBwb3dlciBtYW5hZ2VtZW50LiBBIHNpbWlsYXIgaXNzdWUgd2FzDQo+IGZpeGVkIGZv
ciBpZ2IgaW4gY29tbWl0IDk0NzQ5MzNjYWYyMSAoImlnYjogY2xvc2Uvc3VzcGVuZCByYWNlIGlu
DQo+IG5ldGlmX2RldmljZV9kZXRhY2giKS4NCj4gDQo+IEluIGFkZGl0aW9uIGl0IGNvbnNvbGlk
YXRlcyB0aGUgY29kZSBzbyB0aGF0IHRoZSBQQ0kgZXJyb3IgaGFuZGxpbmcgY29kZQ0KPiB3aWxs
IGVzc2VudGlhbGx5IHBlcmZvcm0gdGhlIHBvd2VyIG1hbmFnZW1lbnQgZnJlZXplIG9uIHRoZSBk
ZXZpY2UgcHJpb3IgdG8NCj4gYXR0ZW1wdGluZyBhIHJlc2V0LCBhbmQgd2lsbCB0aGF3IHRoZSBk
ZXZpY2UgYWZ0ZXJ3YXJkcyBpZiB0aGF0IGlzIHdoYXQgaXQNCj4gaXMgcGxhbm5pbmcgdG8gZG8u
IE90aGVyd2lzZSB3aGVuIHdlIGNhbGwgY2xvc2Ugb24gdGhlIGludGVyZmFjZSBpdCBzaG91bGQN
Cj4gc2VlIGl0IGlzIGRldGFjaGVkIGFuZCBub3QgYXR0ZW1wdCB0byBjYWxsIHRoZSBsb2dpYyB0
byBkb3duIHRoZSBpbnRlcmZhY2UNCj4gYW5kIGZyZWUgdGhlIElSUXMgYWdhaW4uDQo+IA0KPiA+
RnJvbSB3aGF0IEkgY2FuIHRlbGwgdGhlIGNoZWNrIHRoYXQgd2FzIGFkZGluZyB0aGUgY2hlY2sg
Zm9yDQo+IF9fRTEwMDBfRE9XTg0KPiBpbiBlMTAwMGVfY2xvc2Ugd2FzIGFkZGVkIHdoZW4gcnVu
dGltZSBwb3dlciBtYW5hZ2VtZW50IHdhcyBhZGRlZC4NCj4gSG93ZXZlcg0KPiBpdCBzaG91bGQg
bm90IGJlIHJlbGV2YW50IGZvciB1cyBhcyB3ZSBwZXJmb3JtIGEgY2FsbCB0bw0KPiBwbV9ydW50
aW1lX2dldF9zeW5jIGJlZm9yZSB3ZSBjYWxsIGUxMDAwX2Rvd24vZnJlZV9pcnEgc28gaXQgc2hv
dWxkDQo+IGFsd2F5cw0KPiBiZSBiYWNrIHVwIGJlZm9yZSB3ZSBjYWxsIGludG8gdGhpcyBhbnl3
YXkuDQo+IA0KPiBSZXBvcnRlZC1ieTogTW9ydW11cmkgU3JpdmFsbGkgPHNtb3J1bXUxQGluLmli
bS5jb20+DQo+IFRlc3RlZC1ieTogRGF2aWQgRGFpIDx6ZGFpQGxpbnV4LnZuZXQuaWJtLmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogQWxleGFuZGVyIER1eWNrIDxhbGV4YW5kZXIuaC5kdXlja0BsaW51
eC5pbnRlbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBl
L25ldGRldi5jIHwgICA2OCArKysrKysrKysrKysrKy0tLS0tLS0tLQ0KPiAtLS0tLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDM1IGluc2VydGlvbnMoKyksIDMzIGRlbGV0aW9ucygtKQ0KDQpUZXN0ZWQt
Ynk6IEFhcm9uIEJyb3duIDxhYXJvbi5mLmJyb3duQGludGVsLmNvbT4NCg0K
