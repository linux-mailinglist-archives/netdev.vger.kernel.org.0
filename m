Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F44456895E
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbiGFN1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiGFN1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:27:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3015193C0;
        Wed,  6 Jul 2022 06:27:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 283BC61D65;
        Wed,  6 Jul 2022 13:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273A0C341C0;
        Wed,  6 Jul 2022 13:27:13 +0000 (UTC)
Date:   Wed, 6 Jul 2022 09:27:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH v1 net 11/16] net: Fix a data-race around sysctl_mem.
Message-ID: <20220706092711.28ce57e6@gandalf.local.home>
In-Reply-To: <20220706091707.07251fd9@gandalf.local.home>
References: <20220706052130.16368-1-kuniyu@amazon.com>
        <20220706052130.16368-12-kuniyu@amazon.com>
        <20220706091707.07251fd9@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jul 2022 09:17:07 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 5 Jul 2022 22:21:25 -0700
> Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> 
> > --- a/include/trace/events/sock.h
> > +++ b/include/trace/events/sock.h
> > @@ -122,9 +122,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
> >  
> >  	TP_printk("proto:%s sysctl_mem=%ld,%ld,%ld allocated=%ld sysctl_rmem=%d rmem_alloc=%d sysctl_wmem=%d wmem_alloc=%d wmem_queued=%d kind=%s",
> >  		__entry->name,
> > -		__entry->sysctl_mem[0],
> > -		__entry->sysctl_mem[1],
> > -		__entry->sysctl_mem[2],
> > +		READ_ONCE(__entry->sysctl_mem[0]),
> > +		READ_ONCE(__entry->sysctl_mem[1]),
> > +		READ_ONCE(__entry->sysctl_mem[2]),  
> 
> This is not reading anything to do with sysctl. It's reading the content of
> what was recorded in the ring buffer.
> 
> That is, the READ_ONCE() here is not necessary, and if anything will break
> user space parsing, as this is exported to user space to tell it how to
> read the binary format in the ring buffer.

I take that back. Looking at the actual trace event, it is pointing to
sysctl memory, which is a major bug.

TRACE_EVENT(sock_exceed_buf_limit,

        TP_PROTO(struct sock *sk, struct proto *prot, long allocated, int kind),

        TP_ARGS(sk, prot, allocated, kind),

        TP_STRUCT__entry(
                __array(char, name, 32)
                __field(long *, sysctl_mem)

sysctl_mem is a pointer.

                __field(long, allocated)
                __field(int, sysctl_rmem)
                __field(int, rmem_alloc)
                __field(int, sysctl_wmem)
                __field(int, wmem_alloc)
                __field(int, wmem_queued)
                __field(int, kind)
        ),

        TP_fast_assign(
                strncpy(__entry->name, prot->name, 32);

                __entry->sysctl_mem = prot->sysctl_mem;


They save the pointer **IN THE RING BUFFER**!!!

                __entry->allocated = allocated;
                __entry->sysctl_rmem = sk_get_rmem0(sk, prot);
                __entry->rmem_alloc = atomic_read(&sk->sk_rmem_alloc);
                __entry->sysctl_wmem = sk_get_wmem0(sk, prot);
                __entry->wmem_alloc = refcount_read(&sk->sk_wmem_alloc);
                __entry->wmem_queued = READ_ONCE(sk->sk_wmem_queued);
                __entry->kind = kind;
        ),

        TP_printk("proto:%s sysctl_mem=%ld,%ld,%ld allocated=%ld sysctl_rmem=%d rmem_alloc=%d sysctl_wmem=%d wmem_alloc=%d wmem_queued=%d kind=%s",
                __entry->name,
                __entry->sysctl_mem[0],
                __entry->sysctl_mem[1],
                __entry->sysctl_mem[2],

They are now reading a stale pointer, which can be read at any time. That
is, you get the information of what is in sysctl_mem at the time the ring
buffer is read (which is useless from user space), and not at the time of
the event.

Thanks for pointing this out. This needs to be fixed.

-- Steve


                __entry->allocated,
                __entry->sysctl_rmem,
                __entry->rmem_alloc,
                __entry->sysctl_wmem,
                __entry->wmem_alloc,
                __entry->wmem_queued,
                show_skmem_kind_names(__entry->kind)
        )
