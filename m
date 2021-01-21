Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365342FED0A
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 15:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbhAUOfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 09:35:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731281AbhAUOfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 09:35:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611239638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=srskRK3C1cQychsxFrYDRzsB8wxgSiF9DG6BTtAqebM=;
        b=LRLlT5hVrIh+0b8w0VZ0V6Abj0NYzgNWCWcToV1jUBJnaR6AHYAkzfzUKNkkiw2/u3toKJ
        ofbQrWjVkaTxtjsiiciZ/m42bPYveq+mkI+lwZhCjl7lhO1mntbIdu8ZYdw5Nw2+hbaUJa
        3Kd51/3Yr7vX4u5RDKw5dTLYpIn/SMk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-v8YB5K79NAm--wR9SIWusA-1; Thu, 21 Jan 2021 09:33:56 -0500
X-MC-Unique: v8YB5K79NAm--wR9SIWusA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEB9CCE64B;
        Thu, 21 Jan 2021 14:33:54 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E21D6B540;
        Thu, 21 Jan 2021 14:33:39 +0000 (UTC)
Date:   Thu, 21 Jan 2021 15:33:38 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCHv14 bpf-next 1/6] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20210121153338.187a8fcd@carbon>
In-Reply-To: <20210118100717.GF1421720@Leo-laptop-t470s>
References: <20201221123505.1962185-1-liuhangbin@gmail.com>
        <20210114142321.2594697-1-liuhangbin@gmail.com>
        <20210114142321.2594697-2-liuhangbin@gmail.com>
        <6004c0be660fd_2664208e8@john-XPS-13-9370.notmuch>
        <20210118100717.GF1421720@Leo-laptop-t470s>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 18:07:17 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> On Sun, Jan 17, 2021 at 02:57:02PM -0800, John Fastabend wrote:
> [...]
> > It looks like we could embed xdp_buff in xdp_frame and then keep the metadata
> > at the end.
> > 
> > Because you are working performance here wdyt? <- @Jesper as well.  
> 
> Leave this question to Jesper.

The struct xdp_buff is larger than struct xdp_frame.  The size of
xdp_frame matters. It is a reserved areas in top of the frame.
An XDP BPF-program cannot access this area (and limit headroom grow).
This is why this code works, as afterwards xdp_frame is still valid.
Looking at the code xdp_update_frame_from_buff() we do seem to update
more fields than actually needed.


> > >  
> > > -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> > > +	if (unlikely(bq->xdp_prog)) {  
> > 
> > Whats the rational for making above unlikely()? Seems for users its not
> > unlikely. Can you measure a performance increase/decrease here? I think
> > its probably fine to just let compiler/prefetcher do its thing here. Or
> > I'm not reading this right, but seems users of bq->xdp_prog would disagree
> > on unlikely case?
> > 
> > Either way a comment might be nice to give us some insight in 6 months
> > why we decided this is unlikely.  
> 
> I agree that there is no need to use unlikely() here.

I added the unlikely() to preserve the baseline performance when not
having the 2nd prog loaded.  But I'm fine with removing that.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

