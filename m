Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AC3273E4F
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 11:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgIVJQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 05:16:03 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58496 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726343AbgIVJQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 05:16:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600766161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RXaWK2ZBUKJSUlDfpRjcrlD7c53gbMCjN/Sb5CkQ9rY=;
        b=QeBXFowHcDMW2x29Ne817J1uY4c36lTMleYQcJWQN06/ILNmaa/88S9aOrq4kKbpGemIkc
        sCgufUi20P1/2zbI8yDXY+7OxGdhvqjWW0ECbKanDkQ6vXyxjeS2vG5vo3UVCZht6xmJ3H
        YIcI9k6XAR6o2H+hrQe41xklpKLLh3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-kYiF2OFyOVGVu7t60ytGig-1; Tue, 22 Sep 2020 05:15:56 -0400
X-MC-Unique: kYiF2OFyOVGVu7t60ytGig-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDFDFADC00;
        Tue, 22 Sep 2020 09:15:54 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C57395577D;
        Tue, 22 Sep 2020 09:15:44 +0000 (UTC)
Date:   Tue, 22 Sep 2020 11:15:43 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Marek Zavodsky <marek.zavodsky@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        David Miller <davem@davemloft.net>,
        Marek Majkowski <marek@cloudflare.com>, brouer@redhat.com
Subject: Re: BPF redirect API design issue for BPF-prog MTU feedback?
Message-ID: <20200922111543.7cefb3b1@carbon>
In-Reply-To: <CA+FuTSdx_a+DGG5dSFRB3wkowwNb1ZXHFed=qA3sj5y6U3VtiA@mail.gmail.com>
References: <20200917143846.37ce43a0@carbon>
        <CANP3RGcxM-Cno=Qw5Lut9DgmV=1suXqetnybA9RgxmW3KmwivQ@mail.gmail.com>
        <56ccfc21195b19d5b25559aca4cef5c450d0c402.camel@kernel.org>
        <20200918120016.7007f437@carbon>
        <CANP3RGfUj-KKHHQtbggiZ4V-Xrr_sk+TWyN5FgYUGZS6rOX1yw@mail.gmail.com>
        <CACAyw9-v_o+gPUpC-R9SXsfzMywrdGsWV13Nk=tx2aS-fEBFYg@mail.gmail.com>
        <20200921144953.6456d47d@carbon>
        <340f209d-58d4-52a6-0804-7102d80c1468@iogearbox.net>
        <CAG0p+LmqDXCJVygVtqvmsd2v4A=HRZdsGU3mSY0G=tGr2DoUvQ@mail.gmail.com>
        <CA+FuTSdx_a+DGG5dSFRB3wkowwNb1ZXHFed=qA3sj5y6U3VtiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Sep 2020 23:17:16 +0200
Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> On Mon, Sep 21, 2020 at 6:22 PM Marek Zavodsky <marek.zavodsky@gmail.com> wrote:
> >
> > Hi guys,
> >
> > My kernel knowledge is small, but I experienced this (similar) issue
> > with packet encapsulation (not a redirect), therefore modifying the
> > redirect branch would not help in my case.
> >
> > I'm working on a TC program to do GUE encap/decap (IP + UDP + GUE,
> > outer header has extra 52B).
> > There are no issues with small packets. But when I use curl to
> > download big file HTTP server chunks data randomly. Some packets have
> > MTU size, others are even bigger. Big packets are not an issue,
> > however MTU sized packets fail on bpf_skb_adjust_room with -524
> > (ENOTSUPP).  
> 
> This is a related, but different, unresolved issue at the boundary of
> GSO packets. Packets that are not GSO, but would exceed MTU once
> encapsulated, will cause adjust room to fail:
> 
>             (!shrink && (skb->len + len_diff_abs > len_max &&
>                          !skb_is_gso(skb))))
>                 return -ENOTSUPP;
> 
> As admin, this can be addressed by setting a lower route MTU on routes
> that may be encapsulated. But that is not very obvious or transparent.

Your issue is very much related, and even-though it is not related to
redirect, I also want to address and allow your use-case (in the
patchset that I'm collecting input for now).

I do think this patch[1][2] will actually solve your problem.  Could
you please try to apply and test this to make sure?  (as we have
discussed on this list, that patch is not a 100% solution, and I will
work on a better solution).

[1] https://lore.kernel.org/bpf/159921182827.1260200.9699352760916903781.stgit@firesoul
[2] http://patchwork.ozlabs.org/project/netdev/patch/159921182827.1260200.9699352760916903781.stgit@firesoul/
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

