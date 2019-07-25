Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 684FF749BF
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 11:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390384AbfGYJVN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jul 2019 05:21:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:23767 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388732AbfGYJVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 05:21:12 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-235-scnLaRCdNWKuzfuwzi4QFQ-1; Thu, 25 Jul 2019 10:21:09 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Thu,
 25 Jul 2019 10:21:08 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 25 Jul 2019 10:21:08 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jian-Hong Pan' <jian-hong@endlessm.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] rtw88: pci: Use general byte arrays as the elements of RX
 ring
Thread-Topic: [PATCH] rtw88: pci: Use general byte arrays as the elements of
 RX ring
Thread-Index: AQHVQsDFH4BG56wpwU66J+Fzxhx3XabbDGOQ
Date:   Thu, 25 Jul 2019 09:21:08 +0000
Message-ID: <06d713fff7434dfb9ccab32c2e2112e2@AcuMS.aculab.com>
References: <20190725080925.6575-1-jian-hong@endlessm.com>
In-Reply-To: <20190725080925.6575-1-jian-hong@endlessm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: scnLaRCdNWKuzfuwzi4QFQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian-Hong Pan
> Sent: 25 July 2019 09:09
> Each skb as the element in RX ring was expected with sized buffer 8216
> (RTK_PCI_RX_BUF_SIZE) bytes. However, the skb buffer's true size is
> 16640 bytes for alignment after allocated, x86_64 for example. And, the
> difference will be enlarged 512 times (RTK_MAX_RX_DESC_NUM).
> To prevent that much wasted memory, this patch follows David's
> suggestion [1] and uses general buffer arrays, instead of skbs as the
> elements in RX ring.
...
>  	for (i = 0; i < len; i++) {
> -		skb = dev_alloc_skb(buf_sz);
> -		if (!skb) {
> +		buf = devm_kzalloc(rtwdev->dev, buf_sz, GFP_ATOMIC);

You should do this allocation somewhere than can sleep.
So you don't need GFP_ATOMIC, making the allocate (and dma map)
much less likely to fail.
If they do fail using a smaller ring might be better than failing
completely.

I suspect that buf_sz gets rounded up somewhat.
Also you almost certainly want 'buf' to be cache-line aligned.
I don't think devm_kzalloc() guarantees that at all.

While allocating all 512 buffers in one block (just over 4MB)
is probably not a good idea, you may need to allocated (and dma map)
then in groups.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

