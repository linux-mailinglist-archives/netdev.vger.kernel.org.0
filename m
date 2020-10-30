Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191612A0C05
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgJ3RBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:01:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31764 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727288AbgJ3RBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 13:01:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604077277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O2t9zbtiEUpqP/Ze0QZ2b0Kxf46gRkKbL+zw0zhCGSA=;
        b=Ztq5GHqQAWfHLhaPtrmL4Ykvbs3uNo87U6Ic/4b9c/MgLjUcmKxatd/dvA/hSmYUZz9LFA
        ctne30R6IrSCYngesuALchrfbJdj8i9t29MoCm1kp4sR6+8XA3G16EdOZBBrtsAEln4khG
        v6CmYAO+tYq3ShuIJUU719cwsmE5+co=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-zOtu47g4NR62XwfXeGfrMA-1; Fri, 30 Oct 2020 13:01:14 -0400
X-MC-Unique: zOtu47g4NR62XwfXeGfrMA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2949101962A;
        Fri, 30 Oct 2020 17:01:11 +0000 (UTC)
Received: from carbon (unknown [10.36.110.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 808025DA2A;
        Fri, 30 Oct 2020 17:01:04 +0000 (UTC)
Date:   Fri, 30 Oct 2020 18:01:02 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next V4 2/5] bpf: bpf_fib_lookup return MTU value as
 output when looked up
Message-ID: <20201030180102.567d3751@carbon>
In-Reply-To: <b41f461b-ec5b-edb0-d69d-b413e93359de@gmail.com>
References: <160381592923.1435097.2008820753108719855.stgit@firesoul>
        <160381601522.1435097.11103677488984953095.stgit@firesoul>
        <b41f461b-ec5b-edb0-d69d-b413e93359de@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 11:15:31 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 10/27/20 10:26 AM, Jesper Dangaard Brouer wrote:
> > The BPF-helpers for FIB lookup (bpf_xdp_fib_lookup and bpf_skb_fib_lookup)
> > can perform MTU check and return BPF_FIB_LKUP_RET_FRAG_NEEDED.  The BPF-prog
> > don't know the MTU value that caused this rejection.
> > 
> > If the BPF-prog wants to implement PMTU (Path MTU Discovery) (rfc1191) it
> > need to know this MTU value for the ICMP packet.
> > 
> > Patch change lookup and result struct bpf_fib_lookup, to contain this MTU
> > value as output via a union with 'tot_len' as this is the value used for
> > the MTU lookup.
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  include/uapi/linux/bpf.h       |   11 +++++++++--
> >  net/core/filter.c              |   17 ++++++++++++-----
> >  tools/include/uapi/linux/bpf.h |   11 +++++++++--
> >  3 files changed, 30 insertions(+), 9 deletions(-)
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Thanks a lot for the review.  I didn't propagate-it-over in V5 of this
patch, as I changed the name of the output member from mtu to
mtu_result in V5.  Please review V5 and give your review consent.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

