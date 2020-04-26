Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1A31B8E8C
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 11:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgDZJoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 05:44:18 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:5485 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgDZJoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 05:44:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587894255; x=1619430255;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=XluPYZr3x952uQ1/FB8CImH8qduPrzQOMNUPEhABjhE=;
  b=g4zfuoTSkrEyteMiSJGSWtMaE1/+hhS6efREFgKHPuETH4mX5BnQVw3z
   aRMOzVsUrVAKJAva4hrO4zNSGskKRqvq/EIS4+HJIW+29WqVWv9Rq4OFA
   2J+hUHhs9swEOk5ZAGeFp05nm2h+tjzIQoIW0YL1tzGQQFXOA0TLNhPJZ
   g=;
IronPort-SDR: iTdpZkGHQRFu5H3JUa4p3AaytzTo1w/lzXPN/eFjV/x7c1nkWs0rFAPvM+zfBfdGyrJ1Jqf0if
 7pax2wea4LRg==
X-IronPort-AV: E=Sophos;i="5.73,319,1583193600"; 
   d="scan'208";a="28729142"
Subject: RE: [PATCH V1 net-next 01/13] net: ena: fix error returning in
 ena_com_get_hash_function()
Thread-Topic: [PATCH V1 net-next 01/13] net: ena: fix error returning in
 ena_com_get_hash_function()
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 26 Apr 2020 09:44:03 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 96276A1E29;
        Sun, 26 Apr 2020 09:44:01 +0000 (UTC)
Received: from EX13D06EUC001.ant.amazon.com (10.43.164.225) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 26 Apr 2020 09:44:01 +0000
Received: from EX13D11EUC003.ant.amazon.com (10.43.164.153) by
 EX13D06EUC001.ant.amazon.com (10.43.164.225) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 26 Apr 2020 09:44:00 +0000
Received: from EX13D11EUC003.ant.amazon.com ([10.43.164.153]) by
 EX13D11EUC003.ant.amazon.com ([10.43.164.153]) with mapi id 15.00.1497.006;
 Sun, 26 Apr 2020 09:44:00 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
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
        "Dagan, Noam" <ndagan@amazon.com>
Thread-Index: AQHWGH5VSmIXfCndfUa5vtyHe/U8/KiF3TQAgAVPuFA=
Date:   Sun, 26 Apr 2020 09:43:53 +0000
Deferred-Delivery: Sun, 26 Apr 2020 09:43:24 +0000
Message-ID: <76237aeabc2e4ce7bf279892c225371f@EX13D11EUC003.ant.amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
        <20200422081628.8103-2-sameehj@amazon.com>
 <20200422173532.702e7b23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200422173532.702e7b23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.8]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, April 23, 2020 3:36 AM
> To: Jubran, Samih <sameehj@amazon.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Kiyanovski, Arthur
> <akiyano@amazon.com>; Woodhouse, David <dwmw@amazon.co.uk>;
> Machulsky, Zorik <zorik@amazon.com>; Matushevsky, Alexander
> <matua@amazon.com>; Bshara, Saeed <saeedb@amazon.com>; Wilson,
> Matt <msw@amazon.com>; Liguori, Anthony <aliguori@amazon.com>;
> Bshara, Nafea <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>;
> Belgazal, Netanel <netanel@amazon.com>; Saidi, Ali
> <alisaidi@amazon.com>; Herrenschmidt, Benjamin <benh@amazon.com>;
> Dagan, Noam <ndagan@amazon.com>
> Subject: RE: [EXTERNAL] [PATCH V1 net-next 01/13] net: ena: fix error
> returning in ena_com_get_hash_function()
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick
> links or open attachments unless you can confirm the sender and know the
> content is safe.
>=20
>=20
>=20
> On Wed, 22 Apr 2020 08:16:16 +0000 sameehj@amazon.com wrote:
> > From: Arthur Kiyanovski <akiyano@amazon.com>
> >
> > In case the "func" parameter is NULL we now return "-EINVAL".
> > This shouldn't happen in general, but when it does happen, this is the
> > proper way to handle it.
> >
> > We also check func for NULL in the beginning of the function, as there
> > is no reason to do all the work and realize in the end of the function
> > it was useless.
> >
> > Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic
> > Network Adapters (ENA)")
>=20
> Also, why the fixes tag? Is this a fix for a user-visible problem?
Will drop.
>=20
> > Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> > Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
