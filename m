Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2923A1A3B
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhFIP5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:57:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230311AbhFIP5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 11:57:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623254145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=keilHIV5bACKUg1mjHegqweisKM/7NCx/zq57buVyEU=;
        b=Ud9zJRS7kOxc6gaSI4GSTLUKuRldHeMyhOhlT/SzOfFRwZt7+NFfhEIf2AUixHkDE0SxS0
        6h01CHzOgsEmV6tp2y4vYjPSWyP5T1JDJ1A7nSe+kutHEALCJ9OvGpkm+LWqi9y0EeeXkk
        6jMYiYMbEYy3nu+Cho2YRiM2HKQCEms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-6R7Mh9AeMNis9DH0m7jMew-1; Wed, 09 Jun 2021 11:55:43 -0400
X-MC-Unique: 6R7Mh9AeMNis9DH0m7jMew-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95422100A8EE;
        Wed,  9 Jun 2021 15:55:41 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 419FC19C45;
        Wed,  9 Jun 2021 15:55:29 +0000 (UTC)
Date:   Wed, 9 Jun 2021 17:55:27 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        brouer@redhat.com,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [RFT net-next] net: ti: add pp skb recycling support
Message-ID: <20210609175527.2f321eca@carbon>
In-Reply-To: <CAFnufp1vY79fxJEL6eKopTFzJkFz_bZCwaD84CaR_=yqjt6QNw@mail.gmail.com>
References: <ef808c4d8447ee8cf832821a985ba68939455461.1623239847.git.lorenzo@kernel.org>
        <CAFnufp11ANN3MRNDAWBN5AifJbfKMPrVD+6THhZHtuyqZCUmqg@mail.gmail.com>
        <e2ac36df-42a7-37d8-3101-ff03fd40510a@ti.com>
        <CAFnufp1vY79fxJEL6eKopTFzJkFz_bZCwaD84CaR_=yqjt6QNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Jun 2021 17:43:57 +0200
Matteo Croce <mcroce@linux.microsoft.com> wrote:

> On Wed, Jun 9, 2021 at 5:03 PM Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
> >
> > On 09/06/2021 15:20, Matteo Croce wrote:  
> > > On Wed, Jun 9, 2021 at 2:01 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:  
> > >>
> > >> As already done for mvneta and mvpp2, enable skb recycling for ti
> > >> ethernet drivers
> > >>
> > >> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>  
> > >
> > > Looks good! If someone with the HW could provide a with and without
> > > the patch, that would be nice!
> > >  
> >
> > What test would you recommend to run?
> >
[...]
> 
> A test which benefits most from this kind of change is one in which
> the frames are freed early.

I would also recommend running an XDP_PASS program, and then running
something that let the packets travel as deep as possible into netstack.
Not to test performance, but to make sure we didn't break something!

I've hacked up bnxt driver (it's not as straight forward as this driver
to convert) and is running some TCP tests.  Not problems so-far :-0

I wanted to ask if someone knows howto setup the zero-copy TCP stuff
that google did? (but is that TX only?)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

