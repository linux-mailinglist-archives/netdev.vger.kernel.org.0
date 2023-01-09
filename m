Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0848B662962
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbjAIPJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbjAIPIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:08:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6231A07F;
        Mon,  9 Jan 2023 07:08:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21FA66118C;
        Mon,  9 Jan 2023 15:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4023AC433EF;
        Mon,  9 Jan 2023 15:08:35 +0000 (UTC)
Date:   Mon, 9 Jan 2023 10:08:33 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>,
        mhiramat@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, kuniyu@amazon.com, xiyou.wangcong@gmail.com,
        duanxiongchun@bytedance.com, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [External] Re: [PATCH v4] sock: add tracepoint for send recv
 length
Message-ID: <20230109100833.03f4d4b1@gandalf.local.home>
In-Reply-To: <CANn89iKY5gOC97NobXkhYv6d9ik=ks5ZEwVe=6H-VTwux=BwGQ@mail.gmail.com>
References: <20230108025545.338-1-cuiyunhui@bytedance.com>
        <CANn89i+W__5-jDUdM=_97jzQy9Wq+n9KBEuOGjUi=Fxe_ntqbg@mail.gmail.com>
        <CAEEQ3wnoKqN+uTmMmUDJ9pp+YVaLmKnv42RApzPbNOGg6CRmnA@mail.gmail.com>
        <CANn89iKY5gOC97NobXkhYv6d9ik=ks5ZEwVe=6H-VTwux=BwGQ@mail.gmail.com>
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

On Mon, 9 Jan 2023 15:54:38 +0100
Eric Dumazet <edumazet@google.com> wrote:

> > static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
> > {
> >         int ret = INDIRECT_CALL_INET(sock->ops->sendmsg, inet6_sendmsg,
> >                                      inet_sendmsg, sock, msg,
> >                                      msg_data_left(msg));
> >         BUG_ON(ret == -EIOCBQUEUED);
> >
> >         if (trace_sock_send_length_enabled()) {  
> 
> A barrier() is needed here, with the current state of affairs.
> 
> IMO, ftrace/x86 experts should take care of this generic issue ?

trace_*_enabled() is a static_branch() (aka. jump label).

It's a nop, where the if block is in the out-of-line code and skipped. When
the tracepoint is enabled, it gets turned into a jump to the if block
(which returns back to this location).

That is, when the tracepoint in the block gets enabled so does the above
branch. Sure, there could be a race between the two being enabled, but I
don't see any issue if there is. But the process to modify the jump labels,
does a bunch of synchronization between the CPUs.

What barrier are you expecting?

-- Steve

> 
> 
> 
> >                 call_trace_sock_send_length(sock->sk, sock->sk->sk_family,
> >                                             sock->sk->sk_protocol, ret, 0);
> >         }
> >         return ret;
> > }
> >
> > What do you think?
