Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61AE822452D
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 22:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgGQU2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 16:28:30 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:27071 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgGQU2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 16:28:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595017709; x=1626553709;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=78T8he2hHw6LRwqOxbB7Gva5ys5JWsIzevpTIjiRTqU=;
  b=XqHoVwXWeAK9p51uvtqTBW3zIkqGfivlwVGEV405k83R6rn+mM5sErUx
   52NbkVVD2AidLouIRMiAZenbKRfDEe0KFj53CVX/wA4X0/ff5KP6rO4eS
   6mIArSDobo8poHdTe2d1mHRasATJC8yXURlbekAWnXAKDlke0+or+CYF1
   U=;
IronPort-SDR: 45VENFweVllkOl2Ujz/d9w/Yy2SVMzonrgLDhg6Y6wvc9dy8rB/xvC4e288DrTShpTxLh7eiXs
 iknZQaZ8d3HQ==
X-IronPort-AV: E=Sophos;i="5.75,364,1589241600"; 
   d="scan'208";a="60701036"
Subject: Re: [PATCH V3 net-next 1/8] net: ena: avoid unnecessary rearming of
 interrupt vector when busy-polling
Thread-Topic: [PATCH V3 net-next 1/8] net: ena: avoid unnecessary rearming of interrupt
 vector when busy-polling
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 17 Jul 2020 20:28:21 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id ECE34A2903;
        Fri, 17 Jul 2020 20:28:20 +0000 (UTC)
Received: from EX13D17EUB001.ant.amazon.com (10.43.166.85) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 17 Jul 2020 20:28:20 +0000
Received: from EX13D04EUB002.ant.amazon.com (10.43.166.51) by
 EX13D17EUB001.ant.amazon.com (10.43.166.85) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 17 Jul 2020 20:28:19 +0000
Received: from EX13D04EUB002.ant.amazon.com ([10.43.166.51]) by
 EX13D04EUB002.ant.amazon.com ([10.43.166.51]) with mapi id 15.00.1497.006;
 Fri, 17 Jul 2020 20:28:19 +0000
From:   "Bshara, Nafea" <nafea@amazon.com>
To:     David Miller <davem@davemloft.net>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Thread-Index: AQHWW5xyTj44yofdT0yfVp5o0hgOr6kMMF+A//+UqIA=
Date:   Fri, 17 Jul 2020 20:28:18 +0000
Message-ID: <097BE2F6-0737-4658-B2EA-4760643BCBB1@amazon.com>
References: <1594923010-6234-1-git-send-email-akiyano@amazon.com>
 <1594923010-6234-2-git-send-email-akiyano@amazon.com>
 <20200717.125227.55028219209538840.davem@davemloft.net>
In-Reply-To: <20200717.125227.55028219209538840.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.38.20061401
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.8]
Content-Type: text/plain; charset="utf-8"
Content-ID: <53C01EECA3DE174C989EDD5F046D5EE8@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDcvMTcvMjAsIDEyOjUzIFBNLCAiRGF2aWQgTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldD4gd3JvdGU6DQoNCiAgICBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJv
bSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVu
IGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0
aGUgY29udGVudCBpcyBzYWZlLg0KDQoNCg0KICAgIEZyb206IDxha2l5YW5vQGFtYXpvbi5jb20+
DQogICAgRGF0ZTogVGh1LCAxNiBKdWwgMjAyMCAyMToxMDowMyArMDMwMA0KDQogICAgPiBUbyB0
aGUgYmVzdCBvZiBteSBrbm93bGVkZ2UgdGhpcyBhc3N1bXB0aW9uIGhvbGRzIGZvciBBUk02NCBh
bmQgeDg2XzY0DQogICAgPiBhcmNoaXRlY3R1cmUgd2hpY2ggdXNlIGEgTUVTSSBsaWtlIGNhY2hl
IGNvaGVyZW5jeSBtb2RlbC4NCg0KICAgIFVzZSB0aGUgd2VsbCBkZWZpbmVkIGtlcm5lbCBtZW1v
cnkgbW9kZWwgY29ycmVjdGx5IHBsZWFzZS4NCg0KICAgIFRoaXMgaXMgbm8gcGxhY2UgZm9yIGFy
Y2hpdGVjdHVyYWwgYXNzdW1wdGlvbnMuICBUaGUgbWVtb3J5IG1vZGVsIG9mDQogICAgdGhlIGtl
cm5lbCBkZWZpbmVzIHRoZSBydWxlcywgYW5kIGluIHdoYXQgbG9jYXRpb25zIHZhcmlvdXMgbWVt
b3J5DQogICAgYmFycmllcnMgYXJlIHJlcXVpcmVkIGZvciBjb3JyZWN0IG9wZXJhdGlvbi4NCg0K
ICAgIFRoYW5rIHlvdS4NCg0KVHJ1ZSBhbmQgd2Ugd2lsbCBhZGQgc21wX3JtYigpDQpBbmQgSSB3
b3VsZG7igJl0IHdvcnJ5IGFib3V0IHRoZSBwZXJmIGhpdCBoZXJlLCBib3RoIHg4NiBhbmQgbW9k
ZXJuIGFybSB2OCAoc3BlY2lmaWNhbGx5IHRoZSBHcmF2aXRvbjIgdGhhdCB1c2VzIEVOQSkgYXJl
IHByZXR0eSBlZmZpY2llbnQgYW5kIGNsb3NlIGVub3VnaCB0byBuby1vcA0KDQoNCg==
