Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B421C2B0E
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 11:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgECJyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 05:54:52 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:28844 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbgECJyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 05:54:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588499692; x=1620035692;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=El1DonQ72GwZAc7VbdXnxLchEpnjDBkpef0kc+cpsNM=;
  b=U6FKrQiucX3a14FMCcNCj9o8c+oP8/evFAtjFzU9xBkSy5x6gMQdIxFq
   gbTbLIwygu3KuYk1mK69ghz49Q7tOknIB598nh60BPwcf8wDN13c4iUj+
   vBz0hYy2ev3fUXNy0qKj0Z970Y94wQwYp0aDAdzmsB/jKcXaCaN7MEmKi
   A=;
IronPort-SDR: 6rCUAPDDs72RrCqtL3CAHjwWagN5Z9K7Cc28IFzukV2u+IZ0MClZ5OgqRttouYO6UFnf0zqXtM
 HTuQftaFwL/g==
X-IronPort-AV: E=Sophos;i="5.73,347,1583193600"; 
   d="scan'208";a="42280505"
Subject: RE: [PATCH V2 net-next 11/13] net: ena: move llq configuration from
 ena_probe to ena_device_init()
Thread-Topic: [PATCH V2 net-next 11/13] net: ena: move llq configuration from ena_probe to
 ena_device_init()
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 03 May 2020 09:54:52 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 6106F141858;
        Sun,  3 May 2020 09:54:50 +0000 (UTC)
Received: from EX13D06EUC001.ant.amazon.com (10.43.164.225) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:54:49 +0000
Received: from EX13D11EUC003.ant.amazon.com (10.43.164.153) by
 EX13D06EUC001.ant.amazon.com (10.43.164.225) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:54:48 +0000
Received: from EX13D11EUC003.ant.amazon.com ([10.43.164.153]) by
 EX13D11EUC003.ant.amazon.com ([10.43.164.153]) with mapi id 15.00.1497.006;
 Sun, 3 May 2020 09:54:48 +0000
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
Thread-Index: AQHWHS57p693UO6iGU2y69/McnX9iqiO8QSAgAc19JA=
Date:   Sun, 3 May 2020 09:54:45 +0000
Deferred-Delivery: Sun, 3 May 2020 09:54:43 +0000
Message-ID: <2dc068f499bb4053923d08d08e4e5dcc@EX13D11EUC003.ant.amazon.com>
References: <20200428072726.22247-1-sameehj@amazon.com>
        <20200428072726.22247-12-sameehj@amazon.com>
 <20200428124621.0ce3dc5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200428124621.0ce3dc5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
> Sent: Tuesday, April 28, 2020 10:46 PM
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
> Subject: RE: [EXTERNAL] [PATCH V2 net-next 11/13] net: ena: move llq
> configuration from ena_probe to ena_device_init()
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick
> links or open attachments unless you can confirm the sender and know the
> content is safe.
>=20
>=20
>=20
> On Tue, 28 Apr 2020 07:27:24 +0000 sameehj@amazon.com wrote:
> > +     ena_dev->mem_bar =3D devm_ioremap_wc(&pdev->dev,
> > +                                        pci_resource_start(pdev, ENA_M=
EM_BAR),
> > +                                        pci_resource_len(pdev, ENA_MEM=
_BAR));
>=20
> Is there anything that'd undo the mapping in case of reset?
>=20
> The use of devm_ functions outside of probe seems questionable.

I agree, dropped patch in v3.
