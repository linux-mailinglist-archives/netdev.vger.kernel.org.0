Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3E71F3A87
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 14:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgFIMT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 08:19:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38335 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729239AbgFIMT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 08:19:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591705167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BSEsHrwlhqk7DyzByK+cUZneFESEsg/CqT2uCmrkWg4=;
        b=edwu2eYwyxV6bp022+ft39tlF+JCSoA70dRzg5p8nbMeOYKJU4GcQCEgknU7BFGbhpuRVJ
        WYU5T05rhRC2XIfXsw3L5ky5g2o//gUMvlFEBMWxC9tSmjIoeD21cVHUlHCBsAFkWEefox
        XiUyw+LW+La8Thp6nxws3vXWnyhgRF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-YkP2-4GWN3ijU-xuiQOWIQ-1; Tue, 09 Jun 2020 08:19:23 -0400
X-MC-Unique: YkP2-4GWN3ijU-xuiQOWIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A8FA107ACF5;
        Tue,  9 Jun 2020 12:19:19 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E980A2DE64;
        Tue,  9 Jun 2020 12:19:13 +0000 (UTC)
Date:   Tue, 9 Jun 2020 14:19:12 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Miller <davem@davemloft.net>, brouer@redhat.com
Subject: Re: [PATCH bpf-next V1] bpf: devmap dynamic map-value area based on
 BTF
Message-ID: <20200609141912.34b70975@carbon>
In-Reply-To: <CAADnVQKWj_eoVE9XLqwEX2ZWB_yLwRtuQqY7EuFZSNZd40ukPQ@mail.gmail.com>
References: <159119908343.1649854.17264745504030734400.stgit@firesoul>
        <20200603162257.nxgultkidnb7yb6q@ast-mbp.dhcp.thefacebook.com>
        <20200604174806.29130b81@carbon>
        <205b3716-e571-b38f-614f-86819d153c4e@gmail.com>
        <20200604173341.rvfrjmt433knl3uv@ast-mbp.dhcp.thefacebook.com>
        <20200605102323.15c2c06c@carbon>
        <CAADnVQKWj_eoVE9XLqwEX2ZWB_yLwRtuQqY7EuFZSNZd40ukPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Jun 2020 09:58:26 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Fri, Jun 5, 2020 at 1:23 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> >
> > Great. If we can remove this requirement of -1 init (and let zero mean
> > feature isn't used), then I'm all for exposing expose in uapi/bpf.h.  
> 
> Not having it in bpf.h doesn't magically make it invisible.
> It's uapi because user space C sources rely on its fixed format.
> vmlinux.h contains all kernel types. both uapi and kernel internal.
> devmap selftest taking uapi 'struct bpf_devmap_val' from vmlinux.h is
> an awful hack.
> I prefer to keep vmlinux.h usage to bpf programs only.
> User space C code should interface with kernel via proper uapi headers.
> When vmlinux.h is used by bpf C program it's completely different from
> user space C code doing the same, because llvm emits relocations for
> bpf prog and libbpf adjusts them.
> So doing 'foo->bar' in bpf C is specific to target kernel, whereas
> user C code 'foo->bar' is a hard constant which bakes it into uapi
> that kernel has to keep backwards compatible.

Thank you for taking time to explain this.
Much appreciated, I agree with everything above.


> If in some distant future we teach both gcc and clang to do bpf-style
> relocations for x86 and teach ld.so to adjust them then we can dream
> about very differently looking kernel/user interfaces.
> Right now any struct used by user C code and passed into kernel is uapi.

I like this future vision.

I guess this patch is premature, as it operates in the same problem
space. It tried to address uapi flexbility, by letting userspace define
the uapi layout via BTF at map_create() time, and let kernel-side
validate BTF-info and restrict possible struct member names, which are
remapped to offsets inside the kernel.

I'll instead wait for the future...

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

