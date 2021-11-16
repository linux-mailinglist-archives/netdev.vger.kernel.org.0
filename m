Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25D3453294
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 14:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbhKPNJw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Nov 2021 08:09:52 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:57326 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236509AbhKPNJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 08:09:49 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-50-NE7vnzhcM1eRaBZ6g3QBqQ-1; Tue, 16 Nov 2021 13:06:50 +0000
X-MC-Unique: NE7vnzhcM1eRaBZ6g3QBqQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Tue, 16 Nov 2021 13:06:49 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Tue, 16 Nov 2021 13:06:49 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Thomas Gleixner' <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "Benedikt Spranger" <b.spranger@linutronix.de>
Subject: RE: [PATCH] net: stmmac: Fix signed/unsigned wreckage
Thread-Topic: [PATCH] net: stmmac: Fix signed/unsigned wreckage
Thread-Index: AQHX2jSBpdYDfhOuwE+N+VvAPE4QtawGGzyg
Date:   Tue, 16 Nov 2021 13:06:49 +0000
Message-ID: <50343373035f4f2694aac4df86dae618@AcuMS.aculab.com>
References: <87mtm578cs.ffs@tglx>
In-Reply-To: <87mtm578cs.ffs@tglx>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner
> Sent: 15 November 2021 15:21
> 
> The recent addition of timestamp correction to compensate the CDC error
> introduced a subtle signed/unsigned bug in stmmac_get_tx_hwtstamp() while
> it managed for some obscure reason to avoid that in stmmac_get_rx_hwtstamp().
> 
> The issue is:
> 
>     s64 adjust = 0;
>     u64 ns;
> 
>     adjust += -(2 * (NSEC_PER_SEC / priv->plat->clk_ptp_rate));
>     ns += adjust;
> 
> works by chance on 64bit, but falls apart on 32bit because the compiler
> knows that adjust fits into 32bit and then treats the addition as a u64 +
> u32 resulting in an off by ~2 seconds failure.

The problem is earlier.
NSEC_PER_SEC and clk_ptp_rate are almost certainly 32bit and unsigned.
So you have:
	adjust = (s64)((u64)adjust + (u32)-(2 * (NSEC_PER_SEC/...)));

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

