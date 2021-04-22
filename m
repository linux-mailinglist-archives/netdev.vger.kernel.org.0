Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1308936807F
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbhDVMb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 08:31:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236074AbhDVMb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 08:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619094682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nnv0dvQZqPXxc01nH7U2XYrCiJ6mI/FgiCk91HgnTno=;
        b=Lj4RPvwnFGT17TBNuRvZtrW4TnJvbSwDyKb5+L0mVTEihgsimwMOYF8K/kOQdYDfDiMIF8
        fb1SxFheKs8UgxHaxkP9m03uH3Ca9j4AtCfZwaVYEHiwW9QO/3kXinite9QJfEAjZDJLqe
        dXGQjdrFX/uBaBnOAnY973EtZiqyAVw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-RNs_buuGOXa4jomgDahXdw-1; Thu, 22 Apr 2021 08:31:19 -0400
X-MC-Unique: RNs_buuGOXa4jomgDahXdw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC86819253C2;
        Thu, 22 Apr 2021 12:31:17 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C623160C05;
        Thu, 22 Apr 2021 12:30:58 +0000 (UTC)
Date:   Thu, 22 Apr 2021 14:30:57 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>,
        Toke Hoiland Jorgensen <toke@redhat.com>, brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next] cpumap: bulk skb using
 netif_receive_skb_list
Message-ID: <20210422143057.223aa339@carbon>
In-Reply-To: <CAJ0CqmVozWi5uCnzWCpkc5kccnEJWRNbLMb-5YmWe7te9E_Odg@mail.gmail.com>
References: <01cd8afa22786b2c8a4cd7250d165741e990a771.1618927173.git.lorenzo@kernel.org>
        <20210420185440.1dfcf71c@carbon>
        <YH8K0gkYoZVfq0FV@lore-desk>
        <CAJ0CqmVozWi5uCnzWCpkc5kccnEJWRNbLMb-5YmWe7te9E_Odg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 12:59:31 +0200
Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> >
> > [...]  
> > > > +   TP_ARGS(map_id, processed, sched, xdp_stats),
> > > >
> > > >     TP_STRUCT__entry(
> > > >             __field(int, map_id)
> > > >             __field(u32, act)
> > > >             __field(int, cpu)
> > > > -           __field(unsigned int, drops)
> > > >             __field(unsigned int, processed)  
> > >
> > > So, struct member @processed will takeover the room for @drops.
> > >
> > > Can you please test how an old xdp_monitor program will react to this?
> > > Will it fail, or extract and show wrong values?  
> >
> > Ack, right. I think we should keep the struct layout in order to maintain
> > back-compatibility. I will fix it in v4.
> >  
> > >
> > > The xdp_mointor tool is in several external git repos:
> > >
> > >  https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/samples/bpf/xdp_monitor_kern.c
> > >  https://github.com/xdp-project/xdp-tutorial/tree/master/tracing02-xdp-monitor  
> 
> Running an old version of xdp_monitor with a patched kernel, I
> verified the xdp sample does not crash but it reports wrong values
> (e.g. pps are reported as drops for tracepoint disagliment).
> I think we have two possibilities here:
> - assuming tracepoints are not a stable ABI, we can just fix xdp
> samples available in the kernel tree and provide a patch for
> xdp-project
>
> - keep current tracepoint layout and just rename current drop variable
> in bpf/cpumap.c in something like skb_alloc_drop.

I like this one the most, rename to skb_alloc_drop, but keep layout.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

