Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD19C17A7F1
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgCEOjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 09:39:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40038 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725944AbgCEOjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 09:39:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583419191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=939ubS6/Mea4GeLT83aqVqtxGhj3OLFtb6w5myvHrnQ=;
        b=P9BrOgBpU4WM/DakR7mLyT5cMATbQdKtVzh4jYROEG5vlq+NiOtVI1xcLF1STN84hRxYF3
        vuen4LTuifXtvvMvIuqiY2+WPbXMyTqWWWi009GyhvIl+Qeg6GhPksPoic88VYOWTtBM7v
        vgWSd53cxY+i0PC0Q9CCpuD+vP/+zt8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-QKvHbWmKN32hWozKMqjuXQ-1; Thu, 05 Mar 2020 09:39:49 -0500
X-MC-Unique: QKvHbWmKN32hWozKMqjuXQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EC651062682;
        Thu,  5 Mar 2020 14:39:48 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19E9884D90;
        Thu,  5 Mar 2020 14:39:43 +0000 (UTC)
Date:   Thu, 5 Mar 2020 15:39:41 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     brouer@redhat.com, Denis Kirjanov <kirjanov@gmail.com>,
        Denis Kirjanov <kda@linux-powerpc.org>, netdev@vger.kernel.org,
        jgross@suse.com
Subject: Re: [PATCH net-next v2] xen-netfront: add basic XDP support
Message-ID: <20200305153929.186819a8@carbon>
In-Reply-To: <20200305133114.GA574299@apalos.home>
References: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
        <20200305130404.GA574021@apalos.home>
        <CAHj3AVndOjLsOkjC1h5WOb+NaswHaggC3MTaRq-r7mA6rGcCZw@mail.gmail.com>
        <20200305133114.GA574299@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Mar 2020 15:31:14 +0200
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> On Thu, Mar 05, 2020 at 04:23:31PM +0300, Denis Kirjanov wrote:
> > On 3/5/20, Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:  
> > > Hi Denis,
> > >
> > > There's a bunch of things still missing from my remarks on V1.
> > > XDP is not supposed to allocate and free pages constantly as that's one of
> > > the things that's making it fast.  
> > 
> > Hi Ilias,
> > 
> > I've removed the copying to an allocated page so there is no page
> > allocation/free logic added.
> >   
> 
> Yea that has been removed. I am not familiar with the driver though, so i'll
> give you an example. 
> Let's say the BPF program says the packet must be dropped. What will happen to
> the page with the packet payload?
> Ideally on XDP we want that page recycled back into the device descriptors, so
> the driver won't have to allocate and map a fresh page.

I agree.  The main point with XDP is that we can do something
faster-than the normal network stack.  Especially in case of XDP_DROP,
we do driver specific recycling tricks, to avoid any allocations and
reinsert the RX-frame in RX-ring, and avoid overhead of SKB allocations.

Looking closer at your patch it seem you run XDP after the SKB alloc?!?

> >   
> > >
> > > You are also missing proper support for XDP_REDIRECT, ndo_xdp_xmit. We
> > > usually require the whole functionality to merge the driver.  

I agree, we have unfortunately seen drivers not getting completed if we
don't require full-XDP feature set.

> > 
> > I wanted to minimize changes and send follow-up patches
> >   
> 
> Adding XDP_REDIRECT is pretty trivial and the ndo_xdp_xmit should be very
> similar to XDP_TX. So assuming you'll fix XDP_TX adding the .ndo one will be
> relatively small amount of code.

You can have a patchset with more patches, if you prefer splitting this
up in multiple patches.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

