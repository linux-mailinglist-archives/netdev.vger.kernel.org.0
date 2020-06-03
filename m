Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC69B1ECBED
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 10:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgFCIyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 04:54:22 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:34144 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgFCIyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 04:54:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591174461; x=1622710461;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=oAeYtcn9n6Di1Xvx0m8SYWMYa4erzQPpWXB2AKpSnTg=;
  b=pC0VYxbBSEYPZymn6UcWeVorLGfDHqJfxuSAndtDeHGS/NMV1Qpg8aWs
   sNGhJIjKT4xh6ei+H6I+loSyOnoafzblKxE8YA0FKPjT9+vvHl//FuthM
   PjN0AvEO8GUxqPo+/0C6prD/6qfdvErwwXZ2bOjVCtJDHR8Xs0uKhVx4p
   8=;
IronPort-SDR: 7WjtOrd6Ub0H6gSLivqUnWi17z9G+VtO91VRPr5OTDiHyFGdv6wQJTDJioGhU/LQErf8glwEMg
 Z3O8a3/o/x4g==
X-IronPort-AV: E=Sophos;i="5.73,467,1583193600"; 
   d="scan'208";a="41181029"
Subject: RE: [PATCH V1 net 0/2] Fix xdp in ena driver
Thread-Topic: [PATCH V1 net 0/2] Fix xdp in ena driver
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 03 Jun 2020 08:54:19 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 78A1C2433AA;
        Wed,  3 Jun 2020 08:54:18 +0000 (UTC)
Received: from EX13D17EUB001.ant.amazon.com (10.43.166.85) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 3 Jun 2020 08:54:18 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D17EUB001.ant.amazon.com (10.43.166.85) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 3 Jun 2020 08:54:17 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1497.006;
 Wed, 3 Jun 2020 08:54:17 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     David Miller <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Thread-Index: AQHWOODIEj0iY8dpX0qtUA9NRDGJcajFgo+AgABqTYCAAKmCQA==
Date:   Wed, 3 Jun 2020 08:54:10 +0000
Deferred-Delivery: Wed, 3 Jun 2020 08:52:12 +0000
Message-ID: <ff194834997e4ac4a44d1828adf88eb2@EX13D11EUB003.ant.amazon.com>
References: <20200602132151.366-1-sameehj@amazon.com>
        <20200602092333.53d88bb5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20200602.154401.977499738191444566.davem@davemloft.net>
In-Reply-To: <20200602.154401.977499738191444566.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.137]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Wednesday, June 3, 2020 1:44 AM
> To: kuba@kernel.org
> Cc: Jubran, Samih <sameehj@amazon.com>; netdev@vger.kernel.org;
> Woodhouse, David <dwmw@amazon.co.uk>; Machulsky, Zorik
> <zorik@amazon.com>; Matushevsky, Alexander <matua@amazon.com>;
> Bshara, Saeed <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>;
> Liguori, Anthony <aliguori@amazon.com>; Bshara, Nafea
> <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>; Belgazal,
> Netanel <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>;
> Herrenschmidt, Benjamin <benh@amazon.com>; Kiyanovski, Arthur
> <akiyano@amazon.com>; Dagan, Noam <ndagan@amazon.com>
> Subject: RE: [EXTERNAL] [PATCH V1 net 0/2] Fix xdp in ena driver
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick
> links or open attachments unless you can confirm the sender and know the
> content is safe.
>=20
>=20
>=20
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Tue, 2 Jun 2020 09:23:33 -0700
>=20
> > On Tue, 2 Jun 2020 13:21:49 +0000 sameehj@amazon.com wrote:
> >> From: Sameeh Jubran <sameehj@amazon.com>
> >>
> >> This patchset includes 2 XDP related bug fixes.
> >
> > Both of them have this problem
> >
> > Fixes tag: Fixes: cad451dd2427 ("net: ena: Implement XDP_TX action")
> > Has these problem(s):
> >       - Subject does not match target commit subject
> >         Just use
> >               git log -1 --format=3D'Fixes: %h ("%s")'
>=20
> Whoops, I'll revert, please fix this up.

Sorry, fixed in V2.
