Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34A11BA791
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgD0PNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:13:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31762 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727946AbgD0PNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588000421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=66s/8eB1iQ0h+YO1+aKqro9NIzz8pnnwctS9ugv9wXg=;
        b=JX8qEwN15Kdh1UJUV/7bv4r9qT0gl/lwBa6TEDIRrlQUrfAP3tzAIgbW5YNmQ8XsSxaPQs
        2IBNPApML/0OpZjxMF9cVYB0QiwHXrowfs0wgc6vIrC+fFL+22J500ys00tmRYGGQLMNFA
        Q37Lm3LNeU0H8FIA/cPLGmJsy4OdIO4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-hjyLTOF2MBKW74HnBMIrhA-1; Mon, 27 Apr 2020 11:13:39 -0400
X-MC-Unique: hjyLTOF2MBKW74HnBMIrhA-1
Received: by mail-lf1-f69.google.com with SMTP id h12so7582634lfk.22
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 08:13:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=66s/8eB1iQ0h+YO1+aKqro9NIzz8pnnwctS9ugv9wXg=;
        b=hvWGKfjb+FCPQJbYB43bq++biktAhCVgpFwBFePLNRdTIoudb1G2RxwuDoJlObY/mZ
         4Doo+ego1JrqAlaTzqB/Vl08TML/j7H5qhFGU5fHM60tufYpIy92N5OLloOgrYQKQycz
         LMJUK1KxNPy/yhrgzkODQ6cq/4OzoE8Het9HhT3D3rwgelgmVwRwplYEyHsfRwo27DUo
         gc8UXGRIZUmCzS8AOvQC76P4IVd6k+C1Hf5S0o6mrFrPLqlLdBspKswBWvVXvIfJw7yK
         d8OJfuv8PbVlq09g4FxtRy7yGf1OktQ8OQdpsnotNKqOlwayBWtzS/JJcTqwXGDFJgpw
         XhDQ==
X-Gm-Message-State: AGi0PuYo/XwKvi7r0f3whQ37Q23cIxzjCVVs+2rRAxYIKwpDe1DIqJIV
        ZGaNTttbeQHi/FYPhQJzOpsLqWRZAQlmU2+OBAxFWgZ9Ttr6FdWXXKqmF2ta1S71OHDwiw25tJp
        UTd/09+FnmjXh9N/1
X-Received: by 2002:a19:c607:: with SMTP id w7mr15747718lff.32.1588000417915;
        Mon, 27 Apr 2020 08:13:37 -0700 (PDT)
X-Google-Smtp-Source: APiQypLA0QPbPB1kZbyYw8/MAbf2vOfQ7iFM0+1DGaF+Z/bZe2nDjOb7ic3ChTY5g7uxXHyBnqo46Q==
X-Received: by 2002:a19:c607:: with SMTP id w7mr15747702lff.32.1588000417613;
        Mon, 27 Apr 2020 08:13:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o3sm11532417lfl.78.2020.04.27.08.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 08:13:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 792841814FF; Mon, 27 Apr 2020 17:13:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH v3 bpf-next 12/15] bpftool: Add support for XDP egress
In-Reply-To: <20200424201428.89514-13-dsahern@kernel.org>
References: <20200424201428.89514-1-dsahern@kernel.org> <20200424201428.89514-13-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 27 Apr 2020 17:13:34 +0200
Message-ID: <87368pyna9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dahern@digitalocean.com>
>
> Add xdp_egress as a program type since it requires a new attach
> type. This follows suit with other program type + attach type
> combintations and leverages the SEC name in libbpf.
>
> Add NET_ATTACH_TYPE_XDP_EGRESS and update attach_type_strings to
> allow a user to specify 'xdp_egress' as the attach or detach point.
>
> Update do_attach_detach_xdp to set XDP_FLAGS_EGRESS_MODE if egress
> is selected.
>
> Update do_xdp_dump_one to show egress program ids.
>
> Update the documentation and help output.
>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  tools/bpf/bpftool/Documentation/bpftool-net.rst  | 4 +++-
>  tools/bpf/bpftool/Documentation/bpftool-prog.rst | 2 +-
>  tools/bpf/bpftool/bash-completion/bpftool        | 4 ++--
>  tools/bpf/bpftool/net.c                          | 6 +++++-
>  tools/bpf/bpftool/netlink_dumper.c               | 5 +++++
>  tools/bpf/bpftool/prog.c                         | 2 +-
>  6 files changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
> index 8651b00b81ea..d7398fb00ec4 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
> @@ -26,7 +26,8 @@ NET COMMANDS
>  |	**bpftool** **net help**
>  |
>  |	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
> -|	*ATTACH_TYPE* := { **xdp** | **xdpgeneric** | **xdpdrv** | **xdpoffload** }
> +|	*ATTACH_TYPE* :=
> +|       { **xdp** | **xdpgeneric** | **xdpdrv** | **xdpoffload** | **xdp_egress** }
>  
>  DESCRIPTION
>  ===========
> @@ -63,6 +64,7 @@ DESCRIPTION
>                    **xdpgeneric** - Generic XDP. runs at generic XDP hook when packet already enters receive path as skb;
>                    **xdpdrv** - Native XDP. runs earliest point in driver's receive path;
>                    **xdpoffload** - Offload XDP. runs directly on NIC on each packet reception;
> +                  **xdp_egress** - XDP in egress path. runs at core networking level;
>  
>  	**bpftool** **net detach** *ATTACH_TYPE* **dev** *NAME*
>                    Detach bpf program attached to network interface *NAME* with
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> index 9f19404f470e..ab0a8846a8e3 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> @@ -44,7 +44,7 @@ PROG COMMANDS
>  |		**cgroup/connect4** | **cgroup/connect6** | **cgroup/sendmsg4** | **cgroup/sendmsg6** |
>  |		**cgroup/recvmsg4** | **cgroup/recvmsg6** | **cgroup/sysctl** |
>  |		**cgroup/getsockopt** | **cgroup/setsockopt** |
> -|		**struct_ops** | **fentry** | **fexit** | **freplace**
> +|		**struct_ops** | **fentry** | **fexit** | **freplace** | **xdp_egress**
>  |	}
>  |       *ATTACH_TYPE* := {
>  |		**msg_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index 45ee99b159e2..ab20696c20c6 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -471,7 +471,7 @@ _bpftool()
>                                  cgroup/post_bind4 cgroup/post_bind6 \
>                                  cgroup/sysctl cgroup/getsockopt \
>                                  cgroup/setsockopt struct_ops \
> -                                fentry fexit freplace" -- \
> +                                fentry fexit freplace xdp_egress" -- \
>                                                     "$cur" ) )
>                              return 0
>                              ;;
> @@ -1003,7 +1003,7 @@ _bpftool()
>              ;;
>          net)
>              local PROG_TYPE='id pinned tag name'
> -            local ATTACH_TYPES='xdp xdpgeneric xdpdrv xdpoffload'
> +            local ATTACH_TYPES='xdp xdpgeneric xdpdrv xdpoffload xdp_egress'
>              case $command in
>                  show|list)
>                      [[ $prev != "$command" ]] && return 0
> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> index c5e3895b7c8b..dbace14e5484 100644
> --- a/tools/bpf/bpftool/net.c
> +++ b/tools/bpf/bpftool/net.c
> @@ -61,6 +61,7 @@ enum net_attach_type {
>  	NET_ATTACH_TYPE_XDP_GENERIC,
>  	NET_ATTACH_TYPE_XDP_DRIVER,
>  	NET_ATTACH_TYPE_XDP_OFFLOAD,
> +	NET_ATTACH_TYPE_XDP_EGRESS,
>  };
>  
>  static const char * const attach_type_strings[] = {
> @@ -68,6 +69,7 @@ static const char * const attach_type_strings[] = {
>  	[NET_ATTACH_TYPE_XDP_GENERIC]	= "xdpgeneric",
>  	[NET_ATTACH_TYPE_XDP_DRIVER]	= "xdpdrv",
>  	[NET_ATTACH_TYPE_XDP_OFFLOAD]	= "xdpoffload",
> +	[NET_ATTACH_TYPE_XDP_EGRESS]	= "xdp_egress",
>  };
>  
>  const size_t net_attach_type_size = ARRAY_SIZE(attach_type_strings);
> @@ -286,6 +288,8 @@ static int do_attach_detach_xdp(int progfd, enum net_attach_type attach_type,
>  		flags |= XDP_FLAGS_DRV_MODE;
>  	if (attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
>  		flags |= XDP_FLAGS_HW_MODE;
> +	if (attach_type == NET_ATTACH_TYPE_XDP_EGRESS)
> +		flags |= XDP_FLAGS_EGRESS_MODE;
>  
>  	return bpf_set_link_xdp_fd(ifindex, progfd, flags);
>  }
> @@ -464,7 +468,7 @@ static int do_help(int argc, char **argv)
>  		"       %s %s help\n"
>  		"\n"
>  		"       " HELP_SPEC_PROGRAM "\n"
> -		"       ATTACH_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload }\n"
> +		"       ATTACH_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload | xdp_egress}\n"

Nit: Missing space before }

