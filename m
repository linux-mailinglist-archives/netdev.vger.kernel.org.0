Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDD52F4145
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 02:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbhAMBhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 20:37:52 -0500
Received: from mx21.baidu.com ([220.181.3.85]:47628 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbhAMBhv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 20:37:51 -0500
Received: from BC-Mail-Ex30.internal.baidu.com (unknown [172.31.51.24])
        by Forcepoint Email with ESMTPS id 6BE8323B6FECE21FF455;
        Wed, 13 Jan 2021 09:36:59 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex30.internal.baidu.com (172.31.51.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Wed, 13 Jan 2021 09:36:59 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2106.006; Wed, 13 Jan 2021 09:36:59 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: RE: [PATCH] igb: avoid premature Rx buffer reuse
Thread-Topic: [PATCH] igb: avoid premature Rx buffer reuse
Thread-Index: AQHW6Fvbto35lVctrkuLVJL42A+U1qojSruAgACwj4CAAM0BMA==
Date:   Wed, 13 Jan 2021 01:36:58 +0000
Message-ID: <005b033dad0a47d7858a9d71d20acda0@baidu.com>
References: <1609990905-29220-1-git-send-email-lirongqing@baidu.com>
 <CAKgT0Ucar6h-V2pQK6Gx4wrwFzJqySfv-MGXtW1yEc6Jq3uNSQ@mail.gmail.com>
 <65a7da2dc20c4fa5b69270f078026100@baidu.com>
 <CAKgT0UccR7Mh4efd+d193bvQNP2-QMdBxP0uk0__0Z+dYepNjg@mail.gmail.com>
In-Reply-To: <CAKgT0UccR7Mh4efd+d193bvQNP2-QMdBxP0uk0__0Z+dYepNjg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.52]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxleGFuZGVyIER1eWNr
IFttYWlsdG86YWxleGFuZGVyLmR1eWNrQGdtYWlsLmNvbV0NCj4gU2VudDogV2VkbmVzZGF5LCBK
YW51YXJ5IDEzLCAyMDIxIDU6MjMgQU0NCj4gVG86IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJh
aWR1LmNvbT4NCj4gQ2M6IE5ldGRldiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IGludGVsLXdp
cmVkLWxhbg0KPiA8aW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc+OyBCasO2cm4gVMO2
cGVsIDxiam9ybi50b3BlbEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIGlnYjog
YXZvaWQgcHJlbWF0dXJlIFJ4IGJ1ZmZlciByIA0KPiBPa2F5LCB0aGlzIGV4cGxhbmF0aW9uIG1h
a2VzIG11Y2ggbW9yZSBzZW5zZS4gQ291bGQgeW91IHBsZWFzZSBlaXRoZXIgaW5jbHVkZQ0KPiB0
aGlzIGV4cGxhbmF0aW9uIGluIHlvdXIgcGF0Y2gsIG9yIGluY2x1ZGUgYSByZWZlcmVuY2UgdG8g
dGhpcyBwYXRjaCBhcyB0aGlzDQo+IGV4cGxhaW5zIGNsZWFybHkgd2hhdCB0aGUgaXNzdWUgaXMg
d2hpbGUgeW91cnMgZGlkbid0IGFuZCBsZWQgdG8gdGhlIGNvbmZ1c2lvbiBhcyBJDQo+IHdhcyBh
c3N1bWluZyB0aGUgZnJlZWluZyB3YXMgaGFwcGVuaW5nIGNsb3NlciB0byB0aGUgdDAgY2FzZSwg
YW5kIHJlYWxseSB0aGUNCj4gcHJvYmxlbSBpcyB0MS4NCj4gDQo+IFRoYW5rcy4NCj4gDQo+IC0g
QWxleA0KDQoNCk9rLCBJIHdpbGwgc2VuZCBWMg0KDQpUaGFua3MNCg0KLUxpDQo=
