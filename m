Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B324AA4D72
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 05:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbfIBDLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 23:11:08 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:50153 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729100AbfIBDLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 23:11:08 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x823B4oh012334, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x823B4oh012334
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 2 Sep 2019 11:11:05 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Mon, 2 Sep 2019
 11:11:04 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] r8152: fix accessing skb after napi_gro_receive
Thread-Topic: [PATCH net-next] r8152: fix accessing skb after
 napi_gro_receive
Thread-Index: AQHVVjxirkaZLXhff0ysFA2DqtVicqcR2+UAgAXqY4A=
Date:   Mon, 2 Sep 2019 03:11:03 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18DA5B5@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-299-albertk@realtek.com>
 <1394712342-15778-302-Taiwan-albertk@realtek.com>
 <b39bc8a1-54c7-42d4-00ed-d48aa1bac734@gmail.com>
In-Reply-To: <b39bc8a1-54c7-42d4-00ed-d48aa1bac734@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RXJpYyBEdW1hemV0IFttYWlsdG86ZXJpYy5kdW1hemV0QGdtYWlsLmNvbV0NCj4gU2VudDogRnJp
ZGF5LCBBdWd1c3QgMzAsIDIwMTkgMTI6MzIgQU0NCj4gVG86IEhheWVzIFdhbmc7IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IG5pY19zd3NkOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHRdIHI4MTUyOiBmaXggYWNjZXNzaW5n
IHNrYiBhZnRlciBuYXBpX2dyb19yZWNlaXZlDQo+IA0KPiBPbiA4LzE5LzE5IDU6MTUgQU0sIEhh
eWVzIFdhbmcgd3JvdGU6DQo+ID4gRml4IGFjY2Vzc2luZyBza2IgYWZ0ZXIgbmFwaV9ncm9fcmVj
ZWl2ZSB3aGljaCBpcyBjYXVzZWQgYnkNCj4gPiBjb21taXQgNDc5MjJmY2RlNTM2ICgicjgxNTI6
IHN1cHBvcnQgc2tiX2FkZF9yeF9mcmFnIikuDQo+ID4NCj4gPiBGaXhlczogNDc5MjJmY2RlNTM2
ICgicjgxNTI6IHN1cHBvcnQgc2tiX2FkZF9yeF9mcmFnIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBI
YXllcyBXYW5nIDxoYXllc3dhbmdAcmVhbHRlay5jb20+DQo+ID4gLS0tDQo+IA0KPiBJdCBpcyBj
dXN0b21hcnkgdG8gYWRkIGEgdGFnIHRvIGNyZWRpdCB0aGUgcmVwb3J0ZXIuLi4NCj4gDQo+IFNv
bWV0aGluZyBsaWtlIDoNCj4gDQo+IFJlcG9ydGVkLWJ5OiAuLi4uDQo+IA0KPiBUaGFua3MuDQoN
ClNvcnJ5LiBJdCdzIG15IG1pc3Rha2UuDQpJIHdvdWxkIG5vdGUgdGhhdCBuZXh0IHRpbWUuDQoN
CkJlc3QgUmVnYXJkcywNCkhheWVzDQoNCg0K
