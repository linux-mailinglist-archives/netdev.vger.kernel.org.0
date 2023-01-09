Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EF066223C
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 10:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbjAIJ7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 04:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbjAIJ6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 04:58:33 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AD9BC0C
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 01:56:16 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id t15so8017366ybq.4
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 01:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SfDaq2ASpiM1zBb2WHSIhwQSieUxoxDNWuYmU52fBIY=;
        b=blauc+qxWSvrWJvnw8ziranzXegXkmdq5J/cb3W9GtJvc/dXWfk6uMqzpTrVAp7sPu
         e8alsyX/smcZ+MwKh+qUCW3SzuHbm1CzZxqQ0aonQXNSsN1JEmU5jMsOg9QaZF+ke9gB
         A06wBYBMfhnhMlD2utylI4UP1KWDH6TiCGyaVYgUJyW2n+wbYdoAvEntaj7AkuAAnrQS
         Go1sto9NClzKe1oAKmxAasjn21RR/Wjbml2qG3P4+2n/Uts9TvZ2OvmFrKqeZaT3ChiN
         1QQ8C8ql32/V8INuDNgoRlWlN9ecMGoP84PgzRplF5qgNERvXjpQxZPn9H3VRWeP4LIe
         eaXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SfDaq2ASpiM1zBb2WHSIhwQSieUxoxDNWuYmU52fBIY=;
        b=RGSu5oKDZDZHr/o0F/oMQSJA0Z/7/wMqilvNDhF5JJld7HrPIdZGAfk7mjygbOtVkL
         TH34qRGg5WaiLFDwflm/pnWRui40XAt+g3EdLsTuVR/kqwo2oUzMBJMe6wdV22DPvBRy
         8dZnVv3aS+7w4UVrv0FPAK2cpC2HMW/qK2fc4tKUryrR5jrsCx7GSvcLYvapevOgQoqH
         rFoneSMu89iNiXTo6b0/DxgsBecNDFzeaNMebi87X1ofg66a6QAnAZj0baKhbKQTNqbh
         1i+JnVwuREttDNg3kOLBr/8evRnkxFOc/HabSSYdWg1XNE/6/vCPP7PMIteZ4/TlQKt8
         bhNg==
X-Gm-Message-State: AFqh2kren9sjmguYJMy5oZlrTjevSiFu7VVTNF9L8+ZnsNFehSD5w2Lh
        4MZQTCT3tykW053eCL43btF0ON+95E48/MFD6PaPukW9JS7he3eJ
X-Google-Smtp-Source: AMrXdXsHHnAEm3fH4gz1NO9LoZFtdEIsaXJ4YeYcnXGDlU9/SzIYVGbyu7x7LN0IqTlQ0oQNGt4wIYD/KERNa/pZsSk=
X-Received: by 2002:a25:8f89:0:b0:7b3:bb8:9daf with SMTP id
 u9-20020a258f89000000b007b30bb89dafmr1033768ybl.427.1673258175757; Mon, 09
 Jan 2023 01:56:15 -0800 (PST)
MIME-Version: 1.0
References: <20230108025545.338-1-cuiyunhui@bytedance.com>
In-Reply-To: <20230108025545.338-1-cuiyunhui@bytedance.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Jan 2023 10:56:04 +0100
Message-ID: <CANn89i+W__5-jDUdM=_97jzQy9Wq+n9KBEuOGjUi=Fxe_ntqbg@mail.gmail.com>
Subject: Re: [PATCH v4] sock: add tracepoint for send recv length
To:     Yunhui Cui <cuiyunhui@bytedance.com>
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com,
        xiyou.wangcong@gmail.com, duanxiongchun@bytedance.com,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-16.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 8, 2023 at 3:56 AM Yunhui Cui <cuiyunhui@bytedance.com> wrote:
>
> Add 2 tracepoints to monitor the tcp/udp traffic
> of per process and per cgroup.
>
> Regarding monitoring the tcp/udp traffic of each process, there are two
> existing solutions, the first one is https://www.atoptool.nl/netatop.php.
> The second is via kprobe/kretprobe.
>
> Netatop solution is implemented by registering the hook function at the
> hook point provided by the netfilter framework.
>
> These hook functions may be in the soft interrupt context and cannot
> directly obtain the pid. Some data structures are added to bind packets
> and processes. For example, struct taskinfobucket, struct taskinfo ...
>
> Every time the process sends and receives packets it needs multiple
> hashmaps,resulting in low performance and it has the problem fo inaccurate
> tcp/udp traffic statistics(for example: multiple threads share sockets).
>
> We can obtain the information with kretprobe, but as we know, kprobe gets
> the result by trappig in an exception, which loses performance compared
> to tracepoint.
>
> We compared the performance of tracepoints with the above two methods, and
> the results are as follows:
>
> ab -n 1000000 -c 1000 -r http://127.0.0.1/index.html
> without trace:
> Time per request: 39.660 [ms] (mean)
> Time per request: 0.040 [ms] (mean, across all concurrent requests)
>
> netatop:
> Time per request: 50.717 [ms] (mean)
> Time per request: 0.051 [ms] (mean, across all concurrent requests)
>
> kr:
> Time per request: 43.168 [ms] (mean)
> Time per request: 0.043 [ms] (mean, across all concurrent requests)
>
> tracepoint:
> Time per request: 41.004 [ms] (mean)
> Time per request: 0.041 [ms] (mean, across all concurrent requests
>
> It can be seen that tracepoint has better performance.
>
> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> Signed-off-by: Xiongchun Duan <duanxiongchun@bytedance.com>
> ---
>  include/trace/events/sock.h | 48 +++++++++++++++++++++++++++++++++++++
>  net/socket.c                | 23 ++++++++++++++----
>  2 files changed, 67 insertions(+), 4 deletions(-)
>
> diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
> index 777ee6cbe933..d00a5b272404 100644
> --- a/include/trace/events/sock.h
> +++ b/include/trace/events/sock.h
> @@ -263,6 +263,54 @@ TRACE_EVENT(inet_sk_error_report,
>                   __entry->error)
>  );
>
> +/*
> + * sock send/recv msg length
> + */
> +DECLARE_EVENT_CLASS(sock_msg_length,
> +
> +       TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
> +                int flags),
> +
> +       TP_ARGS(sk, family, protocol, ret, flags),
> +
> +       TP_STRUCT__entry(
> +               __field(void *, sk)
> +               __field(__u16, family)
> +               __field(__u16, protocol)
> +               __field(int, length)
> +               __field(int, error)
> +               __field(int, flags)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->sk = sk;
> +               __entry->family = sk->sk_family;
> +               __entry->protocol = sk->sk_protocol;
> +               __entry->length = ret > 0 ? ret : 0;
> +               __entry->error = ret < 0 ? ret : 0;
> +               __entry->flags = flags;
> +       ),
> +
> +       TP_printk("sk address = %p, family = %s protocol = %s, length = %d, error = %d, flags = 0x%x",
> +                 __entry->sk, show_family_name(__entry->family),
> +                 show_inet_protocol_name(__entry->protocol),
> +                 __entry->length,
> +                 __entry->error, __entry->flags)
> +);
> +
> +DEFINE_EVENT(sock_msg_length, sock_send_length,
> +       TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
> +                int flags),
> +
> +       TP_ARGS(sk, family, protocol, ret, flags)
> +);
> +
> +DEFINE_EVENT(sock_msg_length, sock_recv_length,
> +       TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
> +                int flags),
> +
> +       TP_ARGS(sk, family, protocol, ret, flags)
> +);
>  #endif /* _TRACE_SOCK_H */
>
>  /* This part must be outside protection */
> diff --git a/net/socket.c b/net/socket.c
> index 888cd618a968..60a1ff95b4b1 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -106,6 +106,7 @@
>  #include <net/busy_poll.h>
>  #include <linux/errqueue.h>
>  #include <linux/ptp_clock_kernel.h>
> +#include <trace/events/sock.h>
>
>  #ifdef CONFIG_NET_RX_BUSY_POLL
>  unsigned int sysctl_net_busy_read __read_mostly;
> @@ -715,6 +716,9 @@ static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
>                                      inet_sendmsg, sock, msg,
>                                      msg_data_left(msg));
>         BUG_ON(ret == -EIOCBQUEUED);
> +
> +       trace_sock_send_length(sock->sk, sock->sk->sk_family,
> +                              sock->sk->sk_protocol, ret, 0);

Note: At least for CONFIG_RETPOLINE=y and gcc 12.2, compiler adds many
additional instructions (and additional memory reads),
even when the trace point is not enabled.

Contrary to some belief, adding a tracepoint is not always 'free'.
tail calls for example are replaced with normal calls.

sock_recvmsg_nosec:
        pushq   %r12    #
        movl    %edx, %r12d     # tmp123, flags
        pushq   %rbp    #
# net/socket.c:999:     int ret =
INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
        movl    %r12d, %ecx     # flags,
# net/socket.c:998: {
        movq    %rdi, %rbp      # tmp121, sock
        pushq   %rbx    #
# net/socket.c:999:     int ret =
INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
        movq    32(%rdi), %rax  # sock_19(D)->ops, sock_19(D)->ops
# ./include/linux/uio.h:270:    return i->count;
        movq    32(%rsi), %rdx  # MEM[(const struct iov_iter
*)msg_20(D) + 16B].count, pretmp_48
# net/socket.c:999:     int ret =
INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
        movq    144(%rax), %rax # _1->recvmsg, _2
        cmpq    $inet6_recvmsg, %rax    #, _2
        jne     .L107   #,
        call    inet6_recvmsg   #
        movl    %eax, %ebx      # tmp124, <retval>
.L108:
# net/socket.c:1003:    trace_sock_recv_length(sock->sk, sock->sk->sk_family,
        xorl    %r8d, %r8d      # tmp127
        testl   %ebx, %ebx      # <retval>
# net/socket.c:1004:                           sock->sk->sk_protocol,
        movq    24(%rbp), %rsi  # sock_19(D)->sk, _10
# net/socket.c:1003:    trace_sock_recv_length(sock->sk, sock->sk->sk_family,
        cmovle  %ebx, %r8d      # <retval>,, tmp119
        testb   $2, %r12b       #, flags
# net/socket.c:1004:                           sock->sk->sk_protocol,
        movzwl  516(%rsi), %ecx # _10->sk_protocol,
# net/socket.c:1003:    trace_sock_recv_length(sock->sk, sock->sk->sk_family,
        movzwl  16(%rsi), %edx  # _10->__sk_common.skc_family,
# net/socket.c:1003:    trace_sock_recv_length(sock->sk, sock->sk->sk_family,
        cmove   %ebx, %r8d      # tmp119,, <retval>, iftmp.54_16
# ./arch/x86/include/asm/jump_label.h:27:       asm_volatile_goto("1:"
#APP
# 27 "./arch/x86/include/asm/jump_label.h" 1
        1:jmp .L111 # objtool NOPs this         #
        .pushsection __jump_table,  "aw"
         .balign 8
        .long 1b - .
        .long .L111 - .         #
         .quad __tracepoint_sock_recv_length+8 + 2 - .  #,
        .popsection

# 0 "" 2
#NO_APP
.L106:
# net/socket.c:1008: }
        movl    %ebx, %eax      # <retval>,
        popq    %rbx    #
        popq    %rbp    #
        popq    %r12    #
        ret
.L111:
# ./include/trace/events/sock.h:308: DEFINE_EVENT(sock_msg_length,
sock_recv_length,


>         return ret;
>  }
>
> @@ -992,9 +996,15 @@ INDIRECT_CALLABLE_DECLARE(int inet6_recvmsg(struct socket *, struct msghdr *,
>  static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
>                                      int flags)
>  {
> -       return INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
> -                                 inet_recvmsg, sock, msg, msg_data_left(msg),
> -                                 flags);
> +       int ret = INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
> +                                    inet_recvmsg, sock, msg,
> +                                    msg_data_left(msg), flags);
> +
> +       trace_sock_recv_length(sock->sk, sock->sk->sk_family,
> +                              sock->sk->sk_protocol,
> +                              !(flags & MSG_PEEK) ? ret :
> +                              (ret < 0 ? ret : 0), flags);
> +       return ret;
>  }
>
>  /**
> @@ -1044,6 +1054,7 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
>  {
>         struct socket *sock;
>         int flags;
> +       int ret;
>
>         sock = file->private_data;
>
> @@ -1051,7 +1062,11 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
>         /* more is a combination of MSG_MORE and MSG_SENDPAGE_NOTLAST */
>         flags |= more;
>
> -       return kernel_sendpage(sock, page, offset, size, flags);
> +       ret = kernel_sendpage(sock, page, offset, size, flags);
> +
> +       trace_sock_send_length(sock->sk, sock->sk->sk_family,
> +                              sock->sk->sk_protocol, ret, 0);
> +       return ret;
>  }
>
>  static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
> --
> 2.20.1
>
