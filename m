Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578221E5D1B
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 12:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387862AbgE1KZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 06:25:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20615 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387758AbgE1KZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 06:25:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590661528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aI7QziAgUyt26FCsnDIdN4IJj/PsFpIVkZEW9K7NmJo=;
        b=BqL0q9eUwpYAjmCrvaDDpB8pxiJkxc4kaO0xYqeYJKIfDsiGYMjIzqc4F22labk4o6mJ1A
        XTND2V6k8r1sYaSIH6Af5qiqnjJ45e690WE+ceeAazWSNBqK0SlYUuHc0R0YPpUXe0gIYx
        U6DVxJAZOuGx82ou6I9r/TAeY0xJjbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-MXOnknFkODSR9r1EhFEeyQ-1; Thu, 28 May 2020 06:25:26 -0400
X-MC-Unique: MXOnknFkODSR9r1EhFEeyQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2909018FE880;
        Thu, 28 May 2020 10:25:24 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 096672657D;
        Thu, 28 May 2020 10:25:12 +0000 (UTC)
Date:   Thu, 28 May 2020 12:25:10 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dsahern@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next 5/5] selftest: Add tests for XDP programs in
 devmap entries
Message-ID: <20200528122510.1c475484@carbon>
In-Reply-To: <CAEf4BzapqhtWOz666YN1m1wQd0pWJtjYFe4DrUEQpEgPX5UL9g@mail.gmail.com>
References: <20200528001423.58575-1-dsahern@kernel.org>
        <20200528001423.58575-6-dsahern@kernel.org>
        <CAEf4BzapqhtWOz666YN1m1wQd0pWJtjYFe4DrUEQpEgPX5UL9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 00:08:34 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> > diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap.c b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap.c
> > new file mode 100644
> > index 000000000000..815cd59b4866
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap.c
> > @@ -0,0 +1,17 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +struct bpf_map_def SEC("maps") dm_ports = {
> > +       .type = BPF_MAP_TYPE_DEVMAP,
> > +       .key_size = sizeof(__u32),
> > +       .value_size = sizeof(struct devmap_val),
> > +       .max_entries = 4,
> > +};
> > +  
> 
> This is an old syntax for maps, all the selftests were converted to
> BTF-defined maps. Please update.

LOL - The map type BPF_MAP_TYPE_DEVMAP does not support BTF for key and
value, which it what I've been trying to point out... (and yes, I do
have code that makes it work in my tree.).

That said, you should use the new SEC(".maps") definitions, but you
need to use some tricks to avoid a BTF-ID getting generated.  Let me
help you with something that should work:

/* DEVMAP values */
struct devmap_val {
	__u32 ifindex;   /* device index */
};

struct {
	__uint(type, BPF_MAP_TYPE_DEVMAP);
	__uint(key_size, sizeof(u32));
	__uint(value_size, sizeof(struct devmap_val));
	__uint(max_entries, 4);
} dm_ports SEC(".maps");

Notice by setting key_size and value_size, instead of the "__type",
then a BTF-ID will be generated for this map.
Normally with proper BTF it should look like:

struct {
	__uint(type, BPF_MAP_TYPE_DEVMAP);
	__type(key, u32);
	__type(value, struct devmap_val);
	__uint(max_entries, 4);
} dm_ports_with_BTF SEC(".maps");


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

