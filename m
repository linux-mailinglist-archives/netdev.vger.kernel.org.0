Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D70668455
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 21:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjALUwv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Jan 2023 15:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjALUw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 15:52:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE296698E;
        Thu, 12 Jan 2023 12:24:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D20B62177;
        Thu, 12 Jan 2023 20:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CBBC433D2;
        Thu, 12 Jan 2023 20:24:09 +0000 (UTC)
Date:   Thu, 12 Jan 2023 15:24:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yunhui Cui <cuiyunhui@bytedance.com>
Cc:     mhiramat@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com,
        xiyou.wangcong@gmail.com, duanxiongchun@bytedance.com,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org, dust.li@linux.alibaba.com
Subject: Re: [PATCH v6] sock: add tracepoint for send recv length
Message-ID: <20230112152407.7acad054@gandalf.local.home>
In-Reply-To: <20230111065930.1494-1-cuiyunhui@bytedance.com>
References: <20230111065930.1494-1-cuiyunhui@bytedance.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 14:59:30 +0800
Yunhui Cui <cuiyunhui@bytedance.com> wrote:

> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> Signed-off-by: Xiongchun Duan <duanxiongchun@bytedance.com>
> ---
>  include/trace/events/sock.h | 45 +++++++++++++++++++++++++++++++++++++
>  net/socket.c                | 33 +++++++++++++++++++++++----
>  2 files changed, 74 insertions(+), 4 deletions(-)
> 
> diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
> index 777ee6cbe933..71492e8276da 100644
> --- a/include/trace/events/sock.h
> +++ b/include/trace/events/sock.h
> @@ -263,6 +263,51 @@ TRACE_EVENT(inet_sk_error_report,
>  		  __entry->error)
>  );
>  
> +/*
> + * sock send/recv msg length
> + */
> +DECLARE_EVENT_CLASS(sock_msg_length,
> +
> +	TP_PROTO(struct sock *sk, int ret, int flags),
> +
> +	TP_ARGS(sk, ret, flags),
> +
> +	TP_STRUCT__entry(
> +		__field(void *, sk)
> +		__field(__u16, family)
> +		__field(__u16, protocol)
> +		__field(int, ret)
> +		__field(int, flags)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->sk = sk;
> +		__entry->family = sk->sk_family;
> +		__entry->protocol = sk->sk_protocol;
> +		__entry->ret = ret;
> +		__entry->flags = flags;
> +	),
> +
> +	TP_printk("sk address = %p, family = %s protocol = %s, length = %d, error = %d, flags = 0x%x",
> +		  __entry->sk, show_family_name(__entry->family),
> +		  show_inet_protocol_name(__entry->protocol),
> +		  !(__entry->flags & MSG_PEEK) ?
> +		  (__entry->ret > 0 ? __entry->ret : 0) : 0,
> +		  __entry->ret < 0 ? __entry->ret : 0,
> +		  __entry->flags)
> +);
> +
> +DEFINE_EVENT(sock_msg_length, sock_send_length,
> +	TP_PROTO(struct sock *sk, int ret, int flags),
> +
> +	TP_ARGS(sk, ret, flags)
> +);
> +
> +DEFINE_EVENT(sock_msg_length, sock_recv_length,
> +	TP_PROTO(struct sock *sk, int ret, int flags),
> +
> +	TP_ARGS(sk, ret, flags)
> +);

From the tracing POV:

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
