Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E74F664525
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 16:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238794AbjAJPoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 10:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238799AbjAJPo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 10:44:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1274448CE6;
        Tue, 10 Jan 2023 07:44:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D10461796;
        Tue, 10 Jan 2023 15:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAEBC433D2;
        Tue, 10 Jan 2023 15:44:20 +0000 (UTC)
Date:   Tue, 10 Jan 2023 10:44:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Yunhui Cui <cuiyunhui@bytedance.com>, mhiramat@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        kuniyu@amazon.com, xiyou.wangcong@gmail.com,
        duanxiongchun@bytedance.com, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dust.li@linux.alibaba.com
Subject: Re: [PATCH v5] sock: add tracepoint for send recv length
Message-ID: <20230110104419.67294691@gandalf.local.home>
In-Reply-To: <CANn89i+Wh2krOy4YFWvBsEx-s_JgQ0HixHAVJwGw18dVPeyiqw@mail.gmail.com>
References: <20230110091356.1524-1-cuiyunhui@bytedance.com>
        <CANn89i+Wh2krOy4YFWvBsEx-s_JgQ0HixHAVJwGw18dVPeyiqw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Jan 2023 12:49:30 +0100
Eric Dumazet <edumazet@google.com> wrote:

> > +static noinline void call_trace_sock_recv_length(struct sock *sk, int ret, int flags)
> > +{
> > +       trace_sock_recv_length(sk, !(flags & MSG_PEEK) ? ret :
> > +                              (ret < 0 ? ret : 0), flags);  
> 
> Maybe we should only 'fast assign' the two fields (ret and flags),
> and let this logic happen later at 'print' time ?
> 
> This would reduce storage by one integer, and make fast path really fast.
> 
> This also could potentially remove the need for the peculiar construct with
> these noinline helpers.

I noticed that the trace_sock_send_length() doesn't have this logic, and
they are both DEFINE_EVENT() of the same DECLARE_EVENT_CLASS(). But we
could change this too, by the following:

/*
 * sock send/recv msg length
 */
DECLARE_EVENT_CLASS(sock_msg_length,

	TP_PROTO(struct sock *sk, int ret, int flags),

	TP_ARGS(sk, ret, flags),

	TP_STRUCT__entry(
		__field(void *, sk)
		__field(__u16, family)
		__field(__u16, protocol)
		__field(int, ret)
		__field(int, flags)
	),

	TP_fast_assign(
		__entry->sk = sk;
		__entry->family = sk->sk_family;
		__entry->protocol = sk->sk_protocol;
		__entry->length = ret > 0 ? ret : 0;
		__entry->error = ret < 0 ? ret : 0;
		__entry->flags = flags;
	),

	TP_printk("sk address = %p, family = %s protocol = %s, length = %d, error = %d, flags = 0x%x",
		  __entry->sk, show_family_name(__entry->family),
		  show_inet_protocol_name(__entry->protocol),
		  __entry->ret > 0 ? ret : 0, __entry->ret < 0 ? ret : 0,
		  __entry->flags)
);

DEFINE_EVENT(sock_msg_length, sock_send_length,
	TP_PROTO(struct sock *sk, int ret, int flags),

	TP_ARGS(sk, ret, flags)
);

DEFINE_EVENT_PRINT(sock_msg_length, sock_recv_length,
	TP_PROTO(struct sock *sk, int ret, int flags),

	TP_ARGS(sk, ret, flags)

	TP_printk("sk address = %p, family = %s protocol = %s, length = %d, error = %d, flags = 0x%x",
		  __entry->sk, show_family_name(__entry->family),
		  show_inet_protocol_name(__entry->protocol),
		  !(__entry->flags & MSG_PEEK) ? __entry->ret : __entry->ret > 0 ? ret : 0,
		  __entry->ret < 0 ? ret : 0,
		  __entry->flags)
);
#endif /* _TRACE_SOCK_H */

As DEFINE_EVENT_PRINT() uses the class template, but overrides the
TP_printk() portion (still saving memory).

And then both calls can just do:

	trace_sock_send_length(sk, ret, 0);

	trace_sock_recv_length(sock->sk, ret, flags);

And I bet that will also solve all the gcc being smart waste.

-- Steve

