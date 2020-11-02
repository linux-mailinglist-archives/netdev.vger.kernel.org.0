Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78322A34F1
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgKBUMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:12:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726299AbgKBUKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:10:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604347850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WGIbK10Z9+MOpQwKytgwL0i3O6nKvV+A3q1tlV6k+Vw=;
        b=ay0H052i28ZMDhbXbru4CPJ4ZTjmrpRi+AeIs/rQrTizIom3B+/laaSEoihzxVou5FDncG
        SZPJP0FcrBy0HvTpkUbZ+B/r3wfRmbY0MjNXpINBac6rulNHiBAjEfoFj1tOa46vDXUQ+W
        QhR9o/vKeaV/lhCmaAMkfOyFS2QI+r4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-mqgl-XmrPTK8678Ea0I3dg-1; Mon, 02 Nov 2020 15:10:46 -0500
X-MC-Unique: mqgl-XmrPTK8678Ea0I3dg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB1F21009E26;
        Mon,  2 Nov 2020 20:10:43 +0000 (UTC)
Received: from carbon (unknown [10.36.110.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EE177366F;
        Mon,  2 Nov 2020 20:10:37 +0000 (UTC)
Date:   Mon, 2 Nov 2020 21:10:34 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next V5 3/5] bpf: add BPF-helper for MTU checking
Message-ID: <20201102211034.563ef994@carbon>
In-Reply-To: <5fa04a3c7c173_1ecdb20821@john-XPS-13-9370.notmuch>
References: <160407661383.1525159.12855559773280533146.stgit@firesoul>
        <160407666238.1525159.9197344855524540198.stgit@firesoul>
        <5f9c764fc98c6_16d4208d5@john-XPS-13-9370.notmuch>
        <20201102121548.5e2c36b1@carbon>
        <5fa04a3c7c173_1ecdb20821@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 02 Nov 2020 10:04:44 -0800
John Fastabend <john.fastabend@gmail.com> wrote:

> > > > +
> > > > +	/*  Same relax as xdp_ok_fwd_dev() and is_skb_forwardable() */
> > > > +	if (flags & BPF_MTU_CHK_RELAX)
> > > > +		mtu += VLAN_HLEN;    
> > > 
> > > I'm trying to think about the use case where this might be used?
> > > Compared to just adjusting MTU in BPF program side as needed for
> > > packet encapsulation/headers/etc.  
> > 
> > As I wrote above, this were added because the kernels own forwarding
> > have this relaxation in it's checks (in is_skb_forwardable()).  I even
> > tried to dig through the history, introduced in [1] and copy-pasted
> > in[2].  And this seems to be a workaround, that have become standard,
> > that still have practical implications.
> > 
> > My practical experiments showed, that e.g. ixgbe driver with MTU=1500
> > (L3-size) will allow and fully send packets with 1504 (L3-size). But
> > i40e will not, and drops the packet in hardware/firmware step.  So,
> > what is the correct action, strict or relaxed?
> > 
> > My own conclusion is that we should inverse the flag.  Meaning to
> > default add this VLAN_HLEN (4 bytes) relaxation, and have a flag to do
> > more strict check,  e.g. BPF_MTU_CHK_STRICT. As for historical reasons
> > we must act like kernels version of MTU check. Unless you object, I will
> > do this in V6.  
> 
> I'm fine with it either way as long as its documented in the helper
> description so I have a chance of remembering this discussion in 6 months.
> But, if you make it default won't this break for XDP cases? I assume the
> XDP use case doesn't include the VLAN 4-bytes. Would you need to prevent
> the flag from being used from XDP?

XDP actually do include the VLAN_HLEN 4-bytes, see xdp_ok_fwd_dev(). I
was so certain that you John added this code, but looking through git
blame it pointed back to myself.  Going 5 levels git history deep and
3+ years, does seem like I move/reused some of Johns code containing
VLAN_HLEN in the MTU check, introduced for xdp-generic (6103aa96ec077)
which I acked.  Thus, I guess I cannot push this away and have to take
blame myself ;-)

I conclude that we default need to include this VLAN_HLEN, else the XDP
bpf_check_mtu could say deny, while it would have passed the check in
xdp_ok_fwd_dev().  As i40e will drop 1504 this at HW/FW level, I still
see a need for a BPF_MTU_CHK_STRICT flag for programs that want to
catch this.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

