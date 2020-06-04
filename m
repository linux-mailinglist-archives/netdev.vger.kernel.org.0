Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D541EE7FF
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 17:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbgFDPsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 11:48:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38707 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729293AbgFDPsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 11:48:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591285700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ypX2HGAenFX8CiIHs612J9G7sHpnxozjQSK2LUFU94=;
        b=E3YO8ZtMIx1w5+OTtUfk2+gnboHOAlNcHDDmmzk1lN+mvpx+KvFSv+DA2QoiogUaXrUDpg
        MceHNhDvzfS7eKDqSPgZGe4iBWm5cBdvLLkO3eT4VCVWU7aeT+4T0fvhCsRfid9K1x7F73
        vpsulUQKmg513uA0c4v2XqbFen6dObs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-2xERtY5CNseVKVVlwHds8Q-1; Thu, 04 Jun 2020 11:48:17 -0400
X-MC-Unique: 2xERtY5CNseVKVVlwHds8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B0D0107ACCD;
        Thu,  4 Jun 2020 15:48:16 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97B1978FAC;
        Thu,  4 Jun 2020 15:48:07 +0000 (UTC)
Date:   Thu, 4 Jun 2020 17:48:06 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH bpf-next V1] bpf: devmap dynamic map-value area based on
 BTF
Message-ID: <20200604174806.29130b81@carbon>
In-Reply-To: <20200603162257.nxgultkidnb7yb6q@ast-mbp.dhcp.thefacebook.com>
References: <159119908343.1649854.17264745504030734400.stgit@firesoul>
        <20200603162257.nxgultkidnb7yb6q@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Jun 2020 09:22:57 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Wed, Jun 03, 2020 at 05:44:43PM +0200, Jesper Dangaard Brouer wrote:
> > The recent commit fbee97feed9b ("bpf: Add support to attach bpf program to a
> > devmap entry"), introduced ability to attach (and run) a separate XDP
> > bpf_prog for each devmap entry. A bpf_prog is added via a file-descriptor,
> > thus not using the feature requires using value minus-1. The UAPI is
> > extended via tail-extending struct bpf_devmap_val and using map->value_size
> > to determine the feature set.
> > 
> > There is a specific problem with dev_map_can_have_prog() check, which is
> > called from net/core/dev.c in generic_xdp_install() to refuse usage of
> > devmap's from generic-XDP that support these bpf_prog's. The check is size
> > based. This means that all newer features will be blocked from being use by
> > generic-XDP.
> > 
> > This patch allows userspace to skip handling of 'bpf_prog' on map-inserts.
> > The feature can be skipped, via not including the member 'bpf_prog' in the
> > map-value struct, which is propagated/described via BTF.
> > 
> > Fixes: fbee97feed9b ("bpf: Add support to attach bpf program to a devmap entry")
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com  
> 
> The patch makes no sense to me.

Hmm, that is not a very constructive answer, and it doesn't help me
to improve and move forward with the code.  I interpret that you think
my approach is completely wrong, but it would have been nice to
understand why.  I will give up on this approach, also given bpf-next
is closed now.


> please expose 'struct struct bpf_devmap_val' in uapi/bpf.h
> That's what it is whether you want to acknowledge that or not.

I will NOT send a patch that expose this in uapi/bpf.h.  As I explained
before, this caused the issues for my userspace application, that
automatically picked-up struct bpf_devmap_val, and started to fail
(with no code changes), because it needed minus-1 as input.  I fear
that this will cause more work for me later, when I have to helpout and
support end-users on e.g. xdp-newbies list, as it will not be obvious
to end-users why their programs map-insert start to fail.  I have given
up, so I will not NACK anyone sending such a patch.

Why is it we need to support file-descriptor zero as a valid
file-descriptor for a bpf-prog?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

