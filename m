Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C44A77A523
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732081AbfG3Jsp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Jul 2019 05:48:45 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:25066 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728680AbfG3Jsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 05:48:45 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-174-SV6Xl8A9OrKA0tVNQBwUCg-1; Tue, 30 Jul 2019 10:48:38 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue,
 30 Jul 2019 10:48:38 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 30 Jul 2019 10:48:38 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Stanislaw Gruszka' <sgruszka@redhat.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>
CC:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] rtw88: pci: Use general byte arrays as the elements of RX
 ring
Thread-Topic: [PATCH] rtw88: pci: Use general byte arrays as the elements of
 RX ring
Thread-Index: AQHVRro3Kaj7ufhACkSCuQV9Pmu/hqbi59sQ
Date:   Tue, 30 Jul 2019 09:48:38 +0000
Message-ID: <962a8a8e735946d6b3944b7d0e228309@AcuMS.aculab.com>
References: <20190725080925.6575-1-jian-hong@endlessm.com>
 <20190730093533.GC3174@redhat.com>
In-Reply-To: <20190730093533.GC3174@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: SV6Xl8A9OrKA0tVNQBwUCg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislaw Gruszka
> Sent: 30 July 2019 10:36
...
> > +		len = pkt_stat.pkt_len + pkt_offset;
> > +		skb = dev_alloc_skb(len);
> > +		if (WARN_ONCE(!skb, "rx routine starvation\n"))
> >  			goto next_rp;
> >
> >  		/* put the DMA data including rx_desc from phy to new skb */
> > -		skb_put_data(new, skb->data, new_len);
> > +		skb_put_data(skb, rx_desc, len);
> 
> Coping big packets it quite inefficient. What drivers usually do is
> copy only for small packets and for big ones allocate new rx buf
> (drop packet alloc if fail) and pas old buf to network stack via
> skb_add_rx_frag(). See iwlmvm as example.

If you have to do iommu setup/teardown then the breakeven point
for (not) copying may be surprisingly large.
You do need to do the measurements on a range of hardware.
Coping is also likely to affect the L1 cache - unless you can
copy quickly without polluting the cache.

It is all 'swings and roundabouts'.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

