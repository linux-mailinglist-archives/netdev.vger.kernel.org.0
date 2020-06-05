Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CBC1EF304
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 10:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgFEIXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 04:23:37 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48821 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726024AbgFEIXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 04:23:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591345415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2JMbJInhzUsJ9+e9ERl6UPX0rmPsCDgr0I1iZOJwgig=;
        b=K6Eo/b2Q67gfiM1z79Stx2d7VIde804g/diLgdDq5r32GjI917yJYU6BtvMkGS2LKW4fJs
        Ja1oEcTBIeBLfIaCmIPHZ3VWQcKTww2O42SwvN5uYsquEhOcKITXppe63bpKH2dPAQ0qO7
        SksNU36lvPZr/kki+yuVm8VESpuGhEg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-BdyA08kXOu23Lbxn7WO4lg-1; Fri, 05 Jun 2020 04:23:32 -0400
X-MC-Unique: BdyA08kXOu23Lbxn7WO4lg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56DF1A0C00;
        Fri,  5 Jun 2020 08:23:31 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7135C75294;
        Fri,  5 Jun 2020 08:23:25 +0000 (UTC)
Date:   Fri, 5 Jun 2020 10:23:23 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Miller <davem@davemloft.net>, brouer@redhat.com
Subject: Re: [PATCH bpf-next V1] bpf: devmap dynamic map-value area based on
 BTF
Message-ID: <20200605102323.15c2c06c@carbon>
In-Reply-To: <20200604173341.rvfrjmt433knl3uv@ast-mbp.dhcp.thefacebook.com>
References: <159119908343.1649854.17264745504030734400.stgit@firesoul>
        <20200603162257.nxgultkidnb7yb6q@ast-mbp.dhcp.thefacebook.com>
        <20200604174806.29130b81@carbon>
        <205b3716-e571-b38f-614f-86819d153c4e@gmail.com>
        <20200604173341.rvfrjmt433knl3uv@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Jun 2020 10:33:41 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Jun 04, 2020 at 10:40:06AM -0600, David Ahern wrote:
> > On 6/4/20 9:48 AM, Jesper Dangaard Brouer wrote:  
> > > I will NOT send a patch that expose this in uapi/bpf.h.  As I explained
> > > before, this caused the issues for my userspace application, that
> > > automatically picked-up struct bpf_devmap_val, and started to fail
> > > (with no code changes), because it needed minus-1 as input.  I fear
> > > that this will cause more work for me later, when I have to helpout and
> > > support end-users on e.g. xdp-newbies list, as it will not be obvious
> > > to end-users why their programs map-insert start to fail.  I have given
> > > up, so I will not NACK anyone sending such a patch.  
> 
> Jesper,
> 
> you gave wrong direction to David during development of the patches and
> now the devmap uapi is suffering the consequences.
> 
> > > 
> > > Why is it we need to support file-descriptor zero as a valid
> > > file-descriptor for a bpf-prog?  
> > 
> > That was a nice property of using the id instead of fd. And the init to
> > -1 is not unique to this; adopters of the bpf_set_link_xdp_fd_opts for
> > example have to do the same.  
> 
> I think it's better to adopt "fd==0 -> invalid" approach.
> It won't be unique here. We're already using it in other places in bpf syscall.
> I agree with Jesper that requiring -1 init of 2nd field is quite ugly
> and inconvenient.

Great. If we can remove this requirement of -1 init (and let zero mean
feature isn't used), then I'm all for exposing expose in uapi/bpf.h.


For future extensions there is still a problem/challenge in
dev_map_can_have_prog() that blocks generic-XDP for using future
extensions.  BUT next person extending devmap can deal with that, so
it's not something we need to deal with now.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

