Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4296A3EB2B4
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 10:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239218AbhHMIgO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 13 Aug 2021 04:36:14 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:56111 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231127AbhHMIgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 04:36:13 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-65-jWRYdI9NNEi-T8lGlFwTcQ-1; Fri, 13 Aug 2021 09:35:41 +0100
X-MC-Unique: jWRYdI9NNEi-T8lGlFwTcQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Fri, 13 Aug 2021 09:35:39 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Fri, 13 Aug 2021 09:35:39 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "huangjw@broadcom.com" <huangjw@broadcom.com>,
        "eddie.wai@broadcom.com" <eddie.wai@broadcom.com>,
        "prashant@broadcom.com" <prashant@broadcom.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edwin.peer@broadcom.com" <edwin.peer@broadcom.com>
Subject: RE: [PATCH net v2 3/4] bnxt: make sure xmit_more + errors does not
 miss doorbells
Thread-Topic: [PATCH net v2 3/4] bnxt: make sure xmit_more + errors does not
 miss doorbells
Thread-Index: AQHXjvk54dUBDCjz6UWQZn0dScb/IKtxHcpg
Date:   Fri, 13 Aug 2021 08:35:39 +0000
Message-ID: <0d4efdfc3b394ec2bf411dd8036c259e@AcuMS.aculab.com>
References: <20210811213749.3276687-1-kuba@kernel.org>
 <20210811213749.3276687-4-kuba@kernel.org>
In-Reply-To: <20210811213749.3276687-4-kuba@kernel.org>
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

From: Jakub Kicinski
> Sent: 11 August 2021 22:38
> 
> skbs are freed on error and not put on the ring. We may, however,
> be in a situation where we're freeing the last skb of a batch,
> and there is a doorbell ring pending because of xmit_more() being
> true earlier. Make sure we ring the door bell in such situations.
> 
> Since errors are rare don't pay attention to xmit_more() and just
> always flush the pending frames.
> 
...
> +tx_free:
>  	dev_kfree_skb_any(skb);
> +tx_kick_pending:
> +	tx_buf->skb = NULL;
> +	if (txr->kick_pending)
> +		bnxt_txr_db_kick(bp, txr, txr->tx_prod);
>  	return NETDEV_TX_OK;

Is this case actually so unlikely that the 'kick' can be
done unconditionally?
Then all the conditionals can be removed from the hot path.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

