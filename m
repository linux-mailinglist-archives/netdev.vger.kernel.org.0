Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2D96DED54
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjDLIP3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Apr 2023 04:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjDLIPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:15:23 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CCF65BC
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 01:15:20 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-92-gNKhnxOCMImhoK_m4SdLMg-1; Wed, 12 Apr 2023 09:15:17 +0100
X-MC-Unique: gNKhnxOCMImhoK_m4SdLMg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 12 Apr
 2023 09:15:15 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Wed, 12 Apr 2023 09:15:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next v2 2/3] bnxt: use READ_ONCE/WRITE_ONCE for ring
 indexes
Thread-Topic: [PATCH net-next v2 2/3] bnxt: use READ_ONCE/WRITE_ONCE for ring
 indexes
Thread-Index: AQHZbOE4lpy9n4P2zECDFY6wjA/SEa8nUYsg
Date:   Wed, 12 Apr 2023 08:15:15 +0000
Message-ID: <f6c134852244441a88eef8c1774bb67f@AcuMS.aculab.com>
References: <20230412015038.674023-1-kuba@kernel.org>
 <20230412015038.674023-3-kuba@kernel.org>
In-Reply-To: <20230412015038.674023-3-kuba@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski
> Sent: 12 April 2023 02:51
> 
> Eric points out that we should make sure that ring index updates
> are wrapped in the appropriate READ_ONCE/WRITE_ONCE macros.
> 
...
> -static inline u32 bnxt_tx_avail(struct bnxt *bp, struct bnxt_tx_ring_info *txr)
> +static inline u32 bnxt_tx_avail(struct bnxt *bp,
> +				const struct bnxt_tx_ring_info *txr)
>  {
> -	/* Tell compiler to fetch tx indices from memory. */
> -	barrier();
> +	u32 used = READ_ONCE(txr->tx_prod) - READ_ONCE(txr->tx_cons);
> 
> -	return bp->tx_ring_size -
> -		((txr->tx_prod - txr->tx_cons) & bp->tx_ring_mask);
> +	return bp->tx_ring_size - (used & bp->tx_ring_mask);
>  }

Doesn't that function only make sense if only one of
the ring index can be changing?
In this case I think this is being used in the transmit path
so that 'tx_prod' is constant and is either already read
or need not be read again.

Having written a lot of 'ring access' functions over the years
if the ring size is a power of 2 I'd mask the 'tx_prod' value
when it is being used rather than on the increment.
(So the value just wraps modulo 2**32.)
This tends to make the code safer - especially since the
'ring full' and 'ring empty' conditions are different.

Also that code is masking with bp->tx_ring_mask, but the
increments (in hunks I've chopped) use NEXT_TX(prod).
If that is masking with bp->tx_ring_mask then 'bp' should
be a parameter.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

