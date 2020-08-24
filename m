Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D024524F80E
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 11:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgHXIxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 04:53:24 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:45142 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730177AbgHXIxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 04:53:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id F31B820519;
        Mon, 24 Aug 2020 10:53:19 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id USHBQR3CU35V; Mon, 24 Aug 2020 10:53:19 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3A71D204B4;
        Mon, 24 Aug 2020 10:53:19 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 24 Aug 2020 10:53:19 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 24 Aug
 2020 10:53:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9F70A3180449; Mon, 24 Aug 2020 10:53:18 +0200 (CEST)
Date:   Mon, 24 Aug 2020 10:53:18 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH 6/6] xfrm: add espintcp (RFC 8229)
Message-ID: <20200824085318.GQ20687@gauss3.secunet.de>
References: <20200121073858.31120-1-steffen.klassert@secunet.com>
 <20200121073858.31120-7-steffen.klassert@secunet.com>
 <77263327-2fc7-6ba0-567e-0d3643d57c2d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <77263327-2fc7-6ba0-567e-0d3643d57c2d@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ccing Sabrina.

On Fri, Aug 21, 2020 at 02:46:44PM -0700, Eric Dumazet wrote:
> 
> 
> On 1/20/20 11:38 PM, Steffen Klassert wrote:
> > From: Sabrina Dubroca <sd@queasysnail.net>
> > 
> > TCP encapsulation of IKE and IPsec messages (RFC 8229) is implemented
> > as a TCP ULP, overriding in particular the sendmsg and recvmsg
> > operations. A Stream Parser is used to extract messages out of the TCP
> > stream using the first 2 bytes as length marker. Received IKE messages
> > are put on "ike_queue", waiting to be dequeued by the custom recvmsg
> > implementation. Received ESP messages are sent to XFRM, like with UDP
> > encapsulation
> 
> ...
> 
> > +
> > +static int espintcp_sendskb_locked(struct sock *sk, struct espintcp_msg *emsg,
> > +				   int flags)
> > +{
> > +	do {
> > +		int ret;
> > +
> > +		ret = skb_send_sock_locked(sk, emsg->skb,
> > +					   emsg->offset, emsg->len);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		emsg->len -= ret;
> > +		emsg->offset += ret;
> > +	} while (emsg->len > 0);
> > +
> > +	kfree_skb(emsg->skb);
> > +	memset(emsg, 0, sizeof(*emsg));
> > +
> > +	return 0;
> > +}
> 
> 
> Is there any particular reason we use kfree_skb() here instead of consume_skb() ?

I guess not. The skb in not dropped due to an error, so
consume_skb() seems to be more appropriate.

> 
> Same remark for final kfree_skb() in espintcp_recvmsg()
> 
