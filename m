Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A99F5FC05C
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 07:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJLF7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 01:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJLF6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 01:58:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252CB9D509;
        Tue, 11 Oct 2022 22:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9C21B80F9B;
        Wed, 12 Oct 2022 05:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DACC433D6;
        Wed, 12 Oct 2022 05:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665554317;
        bh=qTRsNoqEYVKC6cGjuvIxq3oeVauZtuaLJan/sZXNsGw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Itw4Yk+Vuu7vfp4Aurd3lIFwGC2kyc6CFtxEaG4xiri7Jf/T8gMpNfF9hsRnmWlU5
         ZSnJkm9y/cOo69t55ZLBUoosu/ZKs3lRbNTqH1p3PKviPPhqzjHutIK/4Qqlcw5UYG
         5yD1hs70ELKPCndmUmIAnnwKnUSzXHqLTbt0mLzrzsYaZHcw5yOOEeGLBFlGw5WNsG
         GbnAHjBGNCWBPX8axSbPnvEv4zFjjOPfIftqFqA217XmIlEB9NkEkWUWCKD/FtKqpT
         vbwiGDzA0z/a3R+sd6Em8TaGqyRmMSFmChmjGgmfvgi/ZtVWR4ZlAjwOxwXn3bJAQg
         pQ4yzmGxSCOOA==
Date:   Wed, 12 Oct 2022 08:58:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] net/sock: Introduce trace_sk_data_ready()
Message-ID: <Y0ZXiDiqxYb7yYmS@unreal>
References: <20221007221038.2345-1-yepeilin.cs@gmail.com>
 <20221011195856.13691-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011195856.13691-1-yepeilin.cs@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 11, 2022 at 12:58:56PM -0700, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> As suggested by Cong, introduce a tracepoint for all ->sk_data_ready()
> callback implementations.  For example:
> 
> <...>
>   dpkg-deb-7752    [000] .....   145.660735: sk_data_ready: family=16 protocol=16 func=sock_def_readable
>   dpkg-deb-7757    [000] .....   145.759168: sk_data_ready: family=16 protocol=16 func=sock_def_readable
>   dpkg-deb-7758    [000] .....   145.763956: sk_data_ready: family=16 protocol=16 func=sock_def_readable
> <...>
> 
> Suggested-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> ---
> change since v2:
>   - Fix modpost error for modules (kernel test robot)
> 
> changes since v1:
>   - Move tracepoint into ->sk_data_ready() callback implementations
>     (Eric Dumazet)
>   - Fix W=1 warning (Jakub Kicinski)
> 
>  drivers/infiniband/hw/erdma/erdma_cm.c   |  3 +++
>  drivers/infiniband/sw/siw/siw_cm.c       |  5 +++++
>  drivers/infiniband/sw/siw/siw_qp.c       |  3 +++
>  drivers/nvme/host/tcp.c                  |  3 +++
>  drivers/nvme/target/tcp.c                |  5 +++++
>  drivers/scsi/iscsi_tcp.c                 |  3 +++
>  drivers/soc/qcom/qmi_interface.c         |  3 +++
>  drivers/target/iscsi/iscsi_target_nego.c |  2 ++
>  drivers/xen/pvcalls-back.c               |  5 +++++
>  fs/dlm/lowcomms.c                        |  5 +++++
>  fs/ocfs2/cluster/tcp.c                   |  5 +++++
>  include/trace/events/sock.h              | 24 ++++++++++++++++++++++++
>  net/ceph/messenger.c                     |  4 ++++
>  net/core/net-traces.c                    |  2 ++
>  net/core/skmsg.c                         |  3 +++
>  net/core/sock.c                          |  2 ++
>  net/kcm/kcmsock.c                        |  3 +++
>  net/mptcp/subflow.c                      |  3 +++
>  net/qrtr/ns.c                            |  3 +++
>  net/rds/tcp_listen.c                     |  2 ++
>  net/rds/tcp_recv.c                       |  2 ++
>  net/sctp/socket.c                        |  3 +++
>  net/smc/smc_rx.c                         |  3 +++
>  net/sunrpc/svcsock.c                     |  5 +++++
>  net/sunrpc/xprtsock.c                    |  3 +++
>  net/tipc/socket.c                        |  3 +++
>  net/tipc/topsrv.c                        |  5 +++++
>  net/tls/tls_sw.c                         |  3 +++
>  net/xfrm/espintcp.c                      |  3 +++
>  29 files changed, 118 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/erdma/erdma_cm.c b/drivers/infiniband/hw/erdma/erdma_cm.c
> index f13f16479eca..63f314222813 100644
> --- a/drivers/infiniband/hw/erdma/erdma_cm.c
> +++ b/drivers/infiniband/hw/erdma/erdma_cm.c

<...>

> +	trace_sk_data_ready(sk, __func__);

<...>

> +	trace_sk_data_ready(sk, __func__);

<...>

> +	trace_sk_data_ready(sk, __func__);

<...>

> +	trace_sk_data_ready(sk, __func__);

<...>

> +	trace_sk_data_ready(sk, __func__);

<...>

> +	trace_sk_data_ready(sk, __func__);

<...>

> +	trace_sk_data_ready(sk, __func__);

<...>

> +	trace_sk_data_ready(sk, __func__);

<...>

> +	trace_sk_data_ready(sk, __func__);

<...>

> +	trace_sk_data_ready(sk, __func__);
>  	pr_debug("Entering iscsi_target_sk_data_ready: conn: %p\n", conn);

This can go.

<...>

> +	trace_sk_data_ready(sock, __func__);

<...>

> +	trace_sk_data_ready(sock, __func__);

<...>

> +	trace_sk_data_ready(sk, __func__);

<...>

> +	trace_sk_data_ready(sk, __func__);

<...>

> +	trace_sk_data_ready(sk, __func__);

<...>

> +	trace_sk_data_ready(sk, __func__);

<...>

__func__ repetitive pattern hints that it is not best API interface.


> +TRACE_EVENT(sk_data_ready,
> +
> +	TP_PROTO(const struct sock *sk, const char *func),
> +
> +	TP_ARGS(sk, func),
> +
> +	TP_STRUCT__entry(
> +		__field(const void *, skaddr)
> +		__field(__u16, family)
> +		__field(__u16, protocol)
> +		__string(func, func)

TRACE_EVENT() is macro defined in .h file, you can safely put __func__
instead.

> +	),
> +
> +	TP_fast_assign(
> +		__entry->skaddr = sk;
> +		__entry->family = sk->sk_family;
> +		__entry->protocol = sk->sk_protocol;
> +		__assign_str(func, func)
> +	),
> +
> +	TP_printk("family=%u protocol=%u func=%s",
> +		  __entry->family, __entry->protocol, __get_str(func))
> +);
> +
>  #endif /* _TRACE_SOCK_H */
