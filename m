Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AE7286177
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 16:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgJGOp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 10:45:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728663AbgJGOp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 10:45:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602081958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fnb5nkSzHmdj0EZqMF1MCuYhoEgksBdco1M0vT+a7t4=;
        b=f4vrDl15prijRw14oHrzXrfPmMaoDB8AP1x6gBs6Y+GmHiHCAPSadgf9hjS5AOkId7Jw+7
        xnZnqhTXTPhVLcHtzP3E4p+kz16xpz0u9UTmqA+OAw8GZMqb/yDflyagCPLDVHZlgy1Bn7
        esTZfhUyFacBDjA6yyJ2aAnmtAdJByg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-E4PSZWEgN_CqWqxrDXUDzw-1; Wed, 07 Oct 2020 10:45:54 -0400
X-MC-Unique: E4PSZWEgN_CqWqxrDXUDzw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79D93805EFB;
        Wed,  7 Oct 2020 14:45:53 +0000 (UTC)
Received: from ovpn-112-245.ams2.redhat.com (ovpn-112-245.ams2.redhat.com [10.36.112.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FFF05577A;
        Wed,  7 Oct 2020 14:45:52 +0000 (UTC)
Message-ID: <e9c835401b45da48559f4f0c9347b60c2b9c0911.camel@redhat.com>
Subject: Re: [PATCH net] macsec: avoid use-after-free in
 macsec_handle_frame()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Date:   Wed, 07 Oct 2020 16:45:51 +0200
In-Reply-To: <CANn89iLcZit_0Og9MbW0x0bQ=-6pz18UpRN6RYOY12Czui1eMQ@mail.gmail.com>
References: <20201007084246.4068317-1-eric.dumazet@gmail.com>
         <4544483dd904540cdda04db3d2e2e70bad84efda.camel@redhat.com>
         <CANn89iLcZit_0Og9MbW0x0bQ=-6pz18UpRN6RYOY12Czui1eMQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-07 at 16:31 +0200, Eric Dumazet wrote:
> On Wed, Oct 7, 2020 at 4:09 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > Hi,
> > 
> > On Wed, 2020-10-07 at 01:42 -0700, Eric Dumazet wrote:
> > > @@ -1232,9 +1233,10 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
> > >       macsec_rxsc_put(rx_sc);
> > > 
> > >       skb_orphan(skb);
> > > +     len = skb->len;
> > >       ret = gro_cells_receive(&macsec->gro_cells, skb);
> > >       if (ret == NET_RX_SUCCESS)
> > > -             count_rx(dev, skb->len);
> > > +             count_rx(dev, len);
> > >       else
> > >               macsec->secy.netdev->stats.rx_dropped++;
> > 
> > I'm sorry I'm low on coffee, but I can't see the race?!? here we are in
> > a BH section, and the above code dereference the skb only if it's has
> > been enqueued into the gro_cells napi. It could be dequeued/dropped
> > only after we leave this section ?!?
> 
> We should think of this as an alias for napi_gro_receive(), and not
> make any assumptions.
> Semantically the skb has been given to another layer.
> netif_rx() can absolutely queue the skb to another cpu backlog (RPS,
> RFS...), and the other cpu might have consumed the skb right away.

Ah! I completely missed that code path in gro_cells_receive()!
Thank you for pointing that out!

Acked-by: Paolo Abeni <pabeni@redhat.com>

