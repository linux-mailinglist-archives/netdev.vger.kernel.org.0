Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478F6662A4E
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbjAIPlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237323AbjAIPkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:40:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C161EC7B;
        Mon,  9 Jan 2023 07:39:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADE5EB80D66;
        Mon,  9 Jan 2023 15:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11442C433D2;
        Mon,  9 Jan 2023 15:39:24 +0000 (UTC)
Date:   Mon, 9 Jan 2023 10:39:22 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>,
        mhiramat@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, kuniyu@amazon.com, xiyou.wangcong@gmail.com,
        duanxiongchun@bytedance.com, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [External] Re: [PATCH v4] sock: add tracepoint for send recv
 length
Message-ID: <20230109103922.656eb286@gandalf.local.home>
In-Reply-To: <CANn89iJwBkCsuNH9vih30xy_Ur6+0dtbfs8wmsA4s7r8=J3cBw@mail.gmail.com>
References: <20230108025545.338-1-cuiyunhui@bytedance.com>
        <CANn89i+W__5-jDUdM=_97jzQy9Wq+n9KBEuOGjUi=Fxe_ntqbg@mail.gmail.com>
        <CAEEQ3wnoKqN+uTmMmUDJ9pp+YVaLmKnv42RApzPbNOGg6CRmnA@mail.gmail.com>
        <CANn89iKY5gOC97NobXkhYv6d9ik=ks5ZEwVe=6H-VTwux=BwGQ@mail.gmail.com>
        <20230109100833.03f4d4b1@gandalf.local.home>
        <CANn89iJwBkCsuNH9vih30xy_Ur6+0dtbfs8wmsA4s7r8=J3cBw@mail.gmail.com>
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

On Mon, 9 Jan 2023 16:20:58 +0100
Eric Dumazet <edumazet@google.com> wrote:

> On Mon, Jan 9, 2023 at 4:08 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Mon, 9 Jan 2023 15:54:38 +0100
> > Eric Dumazet <edumazet@google.com> wrote:
> >  
> > > > static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
> > > > {
> > > >         int ret = INDIRECT_CALL_INET(sock->ops->sendmsg, inet6_sendmsg,
> > > >                                      inet_sendmsg, sock, msg,
> > > >                                      msg_data_left(msg));
> > > >         BUG_ON(ret == -EIOCBQUEUED);
> > > >
> > > >         if (trace_sock_send_length_enabled()) {  
> > >
> > > A barrier() is needed here, with the current state of affairs.
> > >
> > > IMO, ftrace/x86 experts should take care of this generic issue ?  
> >
> > trace_*_enabled() is a static_branch() (aka. jump label).
> >
> > It's a nop, where the if block is in the out-of-line code and skipped. When
> > the tracepoint is enabled, it gets turned into a jump to the if block
> > (which returns back to this location).
> >  
> 
> This is not a nop, as shown in the generated assembly, I copied in
> this thread earlier.

But I thought that was for the patch before the added noinline helper
function to force the tracepoint into its own function, and this now just
has the static branch.

> 
> Compiler does all sorts of things before the point the static branch
> is looked at.
> 
> Let's add the extract again with <<*>> tags on added instructions/dereferences.
> 
> 

Ug, bad line wrapping

> sock_recvmsg_nosec:
>         pushq   %r12    #
>         movl    %edx, %r12d     # tmp123, flags
>         pushq   %rbp    #
> # net/socket.c:999:     int ret =
> INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
>         movl    %r12d, %ecx     # flags,
> # net/socket.c:998: {
>         movq    %rdi, %rbp      # tmp121, sock
>         pushq   %rbx    #
> # net/socket.c:999:     int ret =
> INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
>         movq    32(%rdi), %rax  # sock_19(D)->ops, sock_19(D)->ops
> # ./include/linux/uio.h:270:    return i->count;
>         movq    32(%rsi), %rdx  # MEM[(const struct iov_iter
> *)msg_20(D) + 16B].count, pretmp_48
> # net/socket.c:999:     int ret =
> INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
>         movq    144(%rax), %rax # _1->recvmsg, _2
>         cmpq    $inet6_recvmsg, %rax    #, _2
>         jne     .L107   #,
>         call    inet6_recvmsg   #
>  <<*>>       movl    %eax, %ebx      # tmp124, <retval>
> .L108:
> # net/socket.c:1003:    trace_sock_recv_length(sock->sk, sock->sk->sk_family,
>   <<*>>      xorl    %r8d, %r8d      # tmp127
>    <<*>>     testl   %ebx, %ebx      # <retval>
> # net/socket.c:1004:                           sock->sk->sk_protocol,
>  <<*>>       movq    24(%rbp), %rsi  # sock_19(D)->sk, _10
> # net/socket.c:1003:    trace_sock_recv_length(sock->sk, sock->sk->sk_family,
>  <<*>>       cmovle  %ebx, %r8d      # <retval>,, tmp119
>   <<*>>      testb   $2, %r12b       #, flags
> # net/socket.c:1004:                           sock->sk->sk_protocol,
>   <<*>>      movzwl  516(%rsi), %ecx # _10->sk_protocol,
> # net/socket.c:1003:    trace_sock_recv_length(sock->sk, sock->sk->sk_family,
>   <<*>>      movzwl  16(%rsi), %edx  # _10->__sk_common.skc_family,
> # net/socket.c:1003:    trace_sock_recv_length(sock->sk, sock->sk->sk_family,
>   <<*>>      cmove   %ebx, %r8d      # tmp119,, <retval>, iftmp.54_16
> # ./arch/x86/include/asm/jump_label.h:27:       asm_volatile_goto("1:"
> #APP
> # 27 "./arch/x86/include/asm/jump_label.h" 1
>         1:jmp .L111 # objtool NOPs this         #
>         .pushsection __jump_table,  "aw"
>          .balign 8
>         .long 1b - .
>         .long .L111 - .         #
>          .quad __tracepoint_sock_recv_length+8 + 2 - .  #,
>         .popsection
> 
> # 0 "" 2
> #NO_APP
> .L106:
> # net/socket.c:1008: }
>  <<*>>       movl    %ebx, %eax      # <retval>,
>         popq    %rbx    #
>         popq    %rbp    #
>         popq    %r12    #
>         ret
> .L111:
> # ./include/trace/events/sock.h:308: DEFINE_EVENT(sock_msg_length,
> sock_recv_length,
> 
> > That is, when the tracepoint in the block gets enabled so does the above
> > branch. Sure, there could be a race between the two being enabled, but I
> > don't see any issue if there is. But the process to modify the jump labels,
> > does a bunch of synchronization between the CPUs.
> >
> > What barrier are you expecting?  
> 
> Something preventing the compiler being 'smart', forcing expression evaluations
> before TP_fast_assign() is eventually called.

There's no good way to generically keep the compiler from being 'smart',
that I know of. That's because the tracepoint injection is defined by:

#define __DECLARE_TRACE(name, proto, args, cond, data_proto)		\
	extern int __traceiter_##name(data_proto);			\
	DECLARE_STATIC_CALL(tp_func_##name, __traceiter_##name);	\
	extern struct tracepoint __tracepoint_##name;			\
	static inline void __trace_##name(proto)			\
	{								

That (proto) is the prototype being passed in. And because macros can't
create other macros, I don't know how to have a way to inject a barrier()
before and after that call, or better yet, to have the prototype hidden
behind the static_branch.


But looking at this tracepoint again, I see a issue that can help with the
dereferencing.

Why is family and protocol passed in?

+	trace_sock_send_length(sock->sk, sock->sk->sk_family,
+			       sock->sk->sk_protocol, ret, 0);


Where the TP_fast_assign() is:

+	TP_fast_assign(
+		__entry->sk = sk;
+		__entry->family = sk->sk_family;
+		__entry->protocol = sk->sk_protocol;
+		__entry->length = ret > 0 ? ret : 0;
+		__entry->error = ret < 0 ? ret : 0;
+		__entry->flags = flags;
+	),

The family and protocol is taken from the sk, and not the parameters. I bet
dropping those would help.

-- Steve

