Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A509696B0C
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbjBNRPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBNROn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:14:43 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657502ED5B
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 09:14:36 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-4c24993965eso215336097b3.12
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 09:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PLZT3h6vRnztVGlEWdiCRPYtkAzt8khpyYR8x7CWHTQ=;
        b=mSTIbSMJOSRMRFi13MWhR6UgMQmTWf78XEcodw/Td3CvQiHO622CmkHc+CUr1C2DjV
         F+8WmAKJJ1FuH54CUbxagqqfACgs7XLgFd6iHRr+HDj0DN3GqRBEUGlpYXXquTtj5+QX
         LwnqNIKEvozQ4LIe07PO0+a63TJJnwgULxAbQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PLZT3h6vRnztVGlEWdiCRPYtkAzt8khpyYR8x7CWHTQ=;
        b=5/maJLhqNcgvbtjBjOmbJAeJlSrjKtPfesHzitNTUo9ZdG+VOKwNjVLGxY03JfOzBD
         172qI8I8t67bon+HHdNOW2Q1eL6P5o+NkcvTfXD+rpLKcCIJd9Faf/z14UmN+rI98Urc
         qKrhK7v60Ds/rnK2Lg1cVaPBNswa0u9TThdXD3Irjv2OmDrPoc5x7YLQuUeaUsp3ky3D
         JoAdY3bZ50At+AlUqN8fbhs0ZtKw704pZCAfwg+PQdDtF30a/EVJOhz+EeiKgyNM+phr
         S47O0ktwnS9UjHqIoRCwWwg6cKgHRX+hPGvX/jxufkhd0tdX4R32OjkHfiqC2FqzOme9
         xtBA==
X-Gm-Message-State: AO0yUKVtk6FS0PCMg9Qj2Kwuk2AHO7xF5En3GsG+iUgs7Iq5PuJ0jCH/
        vYUikOHkygC5fProYRQVuFfKd+DwAewOGuHsKTjI6A==
X-Google-Smtp-Source: AK7set9XkzGFQVNMcNKT3AqjTJvBhlqIk7xpDgER1UEP8BnWvZLt+zpUfoiMtkDE8j9/tJrKfYk0pKzn/aU4cD0X5uA=
X-Received: by 2002:a81:6a85:0:b0:528:4c7:3296 with SMTP id
 f127-20020a816a85000000b0052804c73296mr399915ywc.249.1676394875310; Tue, 14
 Feb 2023 09:14:35 -0800 (PST)
MIME-Version: 1.0
References: <2d2ad1e5-8b03-0c59-4cf1-6a5cc85bbd94@cloudflare.com>
 <CANn89iJvOPH9rJ4YjRP-i99beY3g+moLnRQH2ED-CQX7QnDYpA@mail.gmail.com>
 <fd9d9040-1721-b882-885f-71a4aeef9454@cloudflare.com> <CANn89iLMUP8_HnmmstGHxh7iR+EqPdEAUNM7OfyDdHJFNdBu3g@mail.gmail.com>
In-Reply-To: <CANn89iLMUP8_HnmmstGHxh7iR+EqPdEAUNM7OfyDdHJFNdBu3g@mail.gmail.com>
From:   Frank Hofmann <fhofmann@cloudflare.com>
Date:   Tue, 14 Feb 2023 17:14:24 +0000
Message-ID: <CABEBQimj8Jk659Xb+gNgW_dVub+euLwM6XGrPvkrPaEb=9GH+A@mail.gmail.com>
Subject: Re: BUG: using __this_cpu_add() in preemptible in tcp_make_synack()
To:     Eric Dumazet <edumazet@google.com>
Cc:     Frederick Lawler <fred@cloudflare.com>, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Mon, Jan 23, 2023 at 3:49 PM 'Eric Dumazet' via
kernel-team+notifications <kernel-team@cloudflare.com> wrote:
>
> > On 1/18/23 11:07 AM, Eric Dumazet wrote:
> [ ... ]
> > > Thanks for the report
> > >
> > > I guess this part has been missed in commit 0a375c822497ed6a
> > >
> > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > index 71d01cf3c13eb4bd3d314ef140568d2ffd6a499e..ba839e441450f195012a8d77cb9e5ed956962d2f
> > > 100644
> > > --- a/net/ipv4/tcp_output.c
> > > +++ b/net/ipv4/tcp_output.c
> > > @@ -3605,7 +3605,7 @@ struct sk_buff *tcp_make_synack(const struct
> > > sock *sk, struct dst_entry *dst,
[ ... ]

we're still seeing this with a preempt-enabled kernel, in
tcp_check_req() though, like:

BUG: using __this_cpu_add() in preemptible [00000000] code: nginx-ssl/186233
caller is tcp_check_req+0x49a/0x660
CPU: 58 PID: 186233 Comm: nginx-ssl Kdump: loaded Tainted: G
O       6.1.8-cloudflare-2023.1.16 #1
Hardware name: ...
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x48
 check_preemption_disabled+0xdd/0xe0
 tcp_check_req+0x49a/0x660
 tcp_rcv_state_process+0xa3/0x1020
 ? tcp_sendmsg_locked+0x2a4/0xc50
 tcp_v4_do_rcv+0xc6/0x280
 __release_sock+0xb4/0xc0
 release_sock+0x2b/0x90
 tcp_sendmsg+0x33/0x40
 sock_sendmsg+0x5b/0x70
 sock_write_iter+0x97/0x100
 vfs_write+0x330/0x3d0
 ksys_write+0xab/0xe0
 ? syscall_trace_enter.constprop.0+0x164/0x170
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x4b/0xb5

There's a notable number of "__"-marked stats updates in
tcp_check_req(); I can't claim to understand the code well enough if
all would have to be changed.
The occurence is infrequent (we see about two a week).

Thanks for any pointers!
Frank Hofmann
