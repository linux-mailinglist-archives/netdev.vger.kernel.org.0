Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01335338964
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 10:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbhCLJ5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 04:57:46 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:60686 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233327AbhCLJ5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 04:57:23 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0URdh6OY_1615543040;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0URdh6OY_1615543040)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 12 Mar 2021 17:57:20 +0800
Date:   Fri, 12 Mar 2021 17:57:20 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     eric.dumazet@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next v3 0/4] Expose network namespace cookies to user
 space
Message-ID: <YEs7AKXmuoMvt5Tf@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20210219154330.93615-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219154330.93615-1-lmb@cloudflare.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 03:43:26PM +0000, Lorenz Bauer wrote:
> We're working on a user space control plane for the BPF sk_lookup
> hook [1]. The hook attaches to a network namespace and allows
> control over which socket receives a new connection / packet.

We are developing a net stack latency tracing tool, which need
net_cookie to distinguish different net namespace. Besides that, our
container management system need to read net_cookie from userspace. 

In [0], you said you would give up this patch set. Could you reconsider
continuing with these patches? Because we also need them. 

net_cookie could be an unified net namespace ID to replace netns inode,
but there are lots of work to do.

[0]: https://lkml.org/lkml/2021/3/10/254


Cheers,
Tony Lu

> 
> I'm proposing to add a new getsockopt and a netns ioctl to retrieve
> netns cookies, which allows identifying which netns a socket belongs
> to.
> 
> 1: https://www.kernel.org/doc/html/latest/bpf/prog_sk_lookup.html
> 
> Changes in v3:
> - Use sock_net unconditionally
> - Fix unused variable in nsfs ioctl
> - Be strict about getsockopt value size
> 
> Changes in v2:
> - Rebase on top of Eric Dumazet's netns cookie simplification
> 
> Lorenz Bauer (4):
>   net: add SO_NETNS_COOKIE socket option
>   nsfs: add an ioctl to discover the network namespace cookie
>   tools/testing: add test for NS_GET_COOKIE
>   tools/testing: add a selftest for SO_NETNS_COOKIE
> 
>  arch/alpha/include/uapi/asm/socket.h          |  2 +
>  arch/mips/include/uapi/asm/socket.h           |  2 +
>  arch/parisc/include/uapi/asm/socket.h         |  2 +
>  arch/sparc/include/uapi/asm/socket.h          |  2 +
>  fs/nsfs.c                                     |  7 +++
>  include/uapi/asm-generic/socket.h             |  2 +
>  include/uapi/linux/nsfs.h                     |  2 +
>  net/core/sock.c                               |  7 +++
>  tools/testing/selftests/net/.gitignore        |  1 +
>  tools/testing/selftests/net/Makefile          |  2 +-
>  tools/testing/selftests/net/config            |  1 +
>  tools/testing/selftests/net/so_netns_cookie.c | 61 +++++++++++++++++++
>  tools/testing/selftests/nsfs/.gitignore       |  1 +
>  tools/testing/selftests/nsfs/Makefile         |  2 +-
>  tools/testing/selftests/nsfs/config           |  1 +
>  tools/testing/selftests/nsfs/netns.c          | 57 +++++++++++++++++
>  16 files changed, 150 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/net/so_netns_cookie.c
>  create mode 100644 tools/testing/selftests/nsfs/netns.c
> 
> -- 
> 2.27.0
