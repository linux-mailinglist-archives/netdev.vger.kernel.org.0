Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59DB30959E
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 14:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhA3Nyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 08:54:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44354 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231726AbhA3NxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 08:53:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612014693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aoCtMEaSOyMLjV1GCt7eQQvgQpEqt4qo7aMScA9Bkis=;
        b=cbB9LUhXNFBhHvNxjz+dr0QmPHUJNSVhnf1+vqDdhVyaTrK2+CEpc4NIQWhHzHw+3Ho+ET
        FWUqVMWsVtgm6L4VV2n/bgov+f8HJOMDP48KfoLb7gbtmV8Knb5DBq4dk9SgAYwVl17efF
        JhDnypjSxWioO24G7c53FlTBj1E42WA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-b93pRTlHPZylsV1722MunA-1; Sat, 30 Jan 2021 08:51:29 -0500
X-MC-Unique: b93pRTlHPZylsV1722MunA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC13C801AC0;
        Sat, 30 Jan 2021 13:51:26 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFEE860CDF;
        Sat, 30 Jan 2021 13:51:20 +0000 (UTC)
Date:   Sat, 30 Jan 2021 14:51:19 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V13 4/7] bpf: add BPF-helper for MTU checking
Message-ID: <20210130145119.17f876c3@carbon>
In-Reply-To: <4965401d-c461-15f6-2068-6cefb6c145ba@iogearbox.net>
References: <161159451743.321749.17528005626909164523.stgit@firesoul>
        <161159457239.321749.9067604476261493815.stgit@firesoul>
        <6013b06b83ae2_2683c2085d@john-XPS-13-9370.notmuch>
        <20210129083654.14f343fa@carbon>
        <60142eae7cd59_11fd208f1@john-XPS-13-9370.notmuch>
        <4965401d-c461-15f6-2068-6cefb6c145ba@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 Jan 2021 01:08:17 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 1/29/21 4:50 PM, John Fastabend wrote:
> > Jesper Dangaard Brouer wrote:  
> >> On Thu, 28 Jan 2021 22:51:23 -0800
> >> John Fastabend <john.fastabend@gmail.com> wrote:  
> >>> Jesper Dangaard Brouer wrote:  
> >>>> This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.
> >>>>
> >>>> The SKB object is complex and the skb->len value (accessible from
> >>>> BPF-prog) also include the length of any extra GRO/GSO segments, but
> >>>> without taking into account that these GRO/GSO segments get added
> >>>> transport (L4) and network (L3) headers before being transmitted. Thus,
> >>>> this BPF-helper is created such that the BPF-programmer don't need to
> >>>> handle these details in the BPF-prog.
> >>>>
> >>>> The API is designed to help the BPF-programmer, that want to do packet
> >>>> context size changes, which involves other helpers. These other helpers
> >>>> usually does a delta size adjustment. This helper also support a delta
> >>>> size (len_diff), which allow BPF-programmer to reuse arguments needed by
> >>>> these other helpers, and perform the MTU check prior to doing any actual
> >>>> size adjustment of the packet context.
> >>>>
> >>>> It is on purpose, that we allow the len adjustment to become a negative
> >>>> result, that will pass the MTU check. This might seem weird, but it's not
> >>>> this helpers responsibility to "catch" wrong len_diff adjustments. Other
> >>>> helpers will take care of these checks, if BPF-programmer chooses to do
> >>>> actual size adjustment.  
> >>
> >> The nitpick below about len adjust can become negative, is on purpose
> >> and why is described in above.  
> > 
> > following up on a nitpick :)
> > 
> > What is the use case to allow users to push a negative len_diff with
> > abs(len_diff) > skb_diff and not throw an error. I would understand if it
> > was a pain to catch the case, but below is fairly straightforward. Of
> > course if user really tries to truncate the packet like this later it
> > will also throw an error, but still missing why we don't throw an error
> > here.
> > 
> > Anyways its undefined if len_diff is truely bogus. Its not really a
> > problem I guess because garbage in (bogus len_diff) garbage out is OK I
> > think.  
> 
> What's the rationale to not sanity check for it? I just double checked
> the UAPI helper description comment ... at minimum this behavior would
> need to be documented there to avoid confusion.

The rationale is that the helper asks if the packet size adjustment
will exceed the MTU (on the given ifindex).  It is not this helpers
responsibility to catch if the packet becomes too small.  It the
responsibility of the helper function that does the size change. The
use-case for len_diff is testing prior to doing size adjustment.

The code can easily choose not to do the size adjustment.  E.g. when
parsing the header, and realizing this is not a VXLAN (50 bytes) tunnel
packet, but instead a (small 42 bytes) ARP packet.

Sure, I can spin a V14 of the patchset, where I make it more clear for
the man page that this is the behavior.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

