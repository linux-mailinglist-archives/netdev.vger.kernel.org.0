Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860664B2588
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbiBKMXj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Feb 2022 07:23:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbiBKMXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:23:37 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6216EE77
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 04:23:36 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-34-hvtKQwVGNz2Wx0cG_Tixcw-1; Fri, 11 Feb 2022 12:23:33 +0000
X-MC-Unique: hvtKQwVGNz2Wx0cG_Tixcw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Fri, 11 Feb 2022 12:23:32 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Fri, 11 Feb 2022 12:23:32 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kalle Valo' <kvalo@kernel.org>, Qing Wang <wangqing@vivo.com>
CC:     Maya Erez <merez@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "wil6210@qti.qualcomm.com" <wil6210@qti.qualcomm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: wireless: ath: use div64_u64() instead of do_div()
Thread-Topic: [PATCH] net: wireless: ath: use div64_u64() instead of do_div()
Thread-Index: AQHYHngQJL09if2dqkeSlawgaN2aGKyORzbw
Date:   Fri, 11 Feb 2022 12:23:32 +0000
Message-ID: <f552799ea07049829e68ea63668cbcc8@AcuMS.aculab.com>
References: <1644395972-4303-1-git-send-email-wangqing@vivo.com>
 <877da2c3xf.fsf@tynnyri.adurom.net>
In-Reply-To: <877da2c3xf.fsf@tynnyri.adurom.net>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo
> Sent: 10 February 2022 12:16
> 
> Qing Wang <wangqing@vivo.com> writes:
> 
> > From: Wang Qing <wangqing@vivo.com>
> >
> > do_div() does a 64-by-32 division.
> > When the divisor is u64, do_div() truncates it to 32 bits, this means it
> > can test non-zero and be truncated to zero for division.
> >
> > fix do_div.cocci warning:
> > do_div() does a 64-by-32 division, please consider using div64_u64 instead.
> >
> > Signed-off-by: Wang Qing <wangqing@vivo.com>
> > ---
> >  drivers/net/wireless/ath/wil6210/debugfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
> > index 4c944e5..2cee9dd
> > --- a/drivers/net/wireless/ath/wil6210/debugfs.c
> > +++ b/drivers/net/wireless/ath/wil6210/debugfs.c
> > @@ -1766,7 +1766,7 @@ __acquires(&p->tid_rx_lock) __releases(&p->tid_rx_lock)
> >  			seq_puts(s, "\n");
> >  			if (!num_packets)
> >  				continue;
> > -			do_div(tx_latency_avg, num_packets);
> > +			div64_u64(tx_latency_avg, num_packets);
> 
> As you have been pointed out in your other patches, do_div() and
> div64_u64() work differently.

And how long does it take for num_packets to exceed 2^32.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

