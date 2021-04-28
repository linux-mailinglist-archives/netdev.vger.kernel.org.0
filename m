Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FCA36DD1D
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 18:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241067AbhD1Qeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 12:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241053AbhD1Qe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 12:34:29 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCACC061574
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 09:33:44 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id q192so21028724ybg.4
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 09:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aTy9+SvPIGV5lFvSWx3LUU1Noi5i+O1/6N3XRc6Yp+s=;
        b=U4cWdJbnMYockksal5W0qWJ2/o3nLv4Lpk4cU+XKGbqMzFEDbp2Bx5blybQ6IenHy/
         JCNxwlpGYWOUVPfdYVzj/m4OnSC4V7s5jz8MmW2I6akFZKirqRk8ups8VD9olaeIqMTC
         w50SxBvWF4kkuIsqyKSuw7Kf0MS552kN6OaZgPxsKL5QNsMn7dlMZSbRBW3isDSraZyz
         3COqcLh12yU4ZJiwgAEhEidLiRAtdm9+6MQzTeRCl0ePVeSnNQaCRLoo2hhKahQ/qczq
         v5VpyIc/F/X6QHkzATVBJgptzCxjSsO0Me0zur5U//06nWHYkFhxuKazsfyigLDdfXPM
         pdEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aTy9+SvPIGV5lFvSWx3LUU1Noi5i+O1/6N3XRc6Yp+s=;
        b=mKmLSwslgQVFoT56bQF7LubKjMNg7TXZmyZjz/UdHYwmAAqMb0l5MC9RAEjPyp1SPT
         pVI80/D+tDFkQMloOBuB/C5GGYYQOS799820w7yWLnyH7z8PcGhczUv2o2jxThOuNeXz
         PyJJwYOEb1NgaHAQPh27G55Z+Qe8XQUoj0ZGhNoHgxWsYmovMIE+d++gZamvBt1jrR/k
         MHpIoQ1M3xnVfAGaJm7La5mOTW1DURsLhQdls9xc47D6V0j/IIynuoutWlG2dRPVXa+V
         k+gMq6WLEqNwk/VDkfJKYA8Np437kBGREVN0ZoqNIwbc6UJvONH9RHFWsvLniCzbAlzc
         q5Fw==
X-Gm-Message-State: AOAM531FsZzo5+c/uYCy6daqg9DQsBaVOn9XrOUl5fc1OVkcgiQCTLdJ
        YDDkDq3QTbXSbORlZJkMGaQ+7hqmemLeMUX3fO888A==
X-Google-Smtp-Source: ABdhPJyXU6+c2wQUbkUCk7vbS8NF7UX3oML1F9qyhFbsvHN7HWAaB4kvmEzqKL7yK1wJlDeicuytO5opWykcIG4u9sw=
X-Received: by 2002:a5b:906:: with SMTP id a6mr33493576ybq.446.1619627623685;
 Wed, 28 Apr 2021 09:33:43 -0700 (PDT)
MIME-Version: 1.0
References: <fabd0598-c62e-ea88-f340-050136bb8266@akamai.com> <20210428155203.39974-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210428155203.39974-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 28 Apr 2021 18:33:32 +0200
Message-ID: <CANn89iK2Wy5WJB+57Y9JU24boy=bb4YQCk6DWD4BvhsM3ZVSdQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Jason Baron <jbaron@akamai.com>, andrii@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 5:52 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> From:   Jason Baron <jbaron@akamai.com>
> Date:   Wed, 28 Apr 2021 10:44:12 -0400
> > On 4/28/21 4:13 AM, Kuniyuki Iwashima wrote:
> > > From:   Jason Baron <jbaron@akamai.com>
> > > Date:   Tue, 27 Apr 2021 12:38:58 -0400
> > >> On 4/26/21 11:46 PM, Kuniyuki Iwashima wrote:
> > >>> The SO_REUSEPORT option allows sockets to listen on the same port and to
> > >>> accept connections evenly. However, there is a defect in the current
> > >>> implementation [1]. When a SYN packet is received, the connection is tied
> > >>> to a listening socket. Accordingly, when the listener is closed, in-flight
> > >>> requests during the three-way handshake and child sockets in the accept
> > >>> queue are dropped even if other listeners on the same port could accept
> > >>> such connections.
> > >>>
> > >>> This situation can happen when various server management tools restart
> > >>> server (such as nginx) processes. For instance, when we change nginx
> > >>> configurations and restart it, it spins up new workers that respect the new
> > >>> configuration and closes all listeners on the old workers, resulting in the
> > >>> in-flight ACK of 3WHS is responded by RST.
> > >>
> > >> Hi Kuniyuki,
> > >>
> > >> I had implemented a different approach to this that I wanted to get your
> > >> thoughts about. The idea is to use unix sockets and SCM_RIGHTS to pass the
> > >> listen fd (or any other fd) around. Currently, if you have an 'old' webserver
> > >> that you want to replace with a 'new' webserver, you would need a separate
> > >> process to receive the listen fd and then have that process send the fd to
> > >> the new webserver, if they are not running con-currently. So instead what
> > >> I'm proposing is a 'delayed close' for a unix socket. That is, one could do:
> > >>
> > >> 1) bind unix socket with path '/sockets'
> > >> 2) sendmsg() the listen fd via the unix socket
> > >> 2) setsockopt() some 'timeout' on the unix socket (maybe 10 seconds or so)
> > >> 3) exit/close the old webserver and the listen socket
> > >> 4) start the new webserver
> > >> 5) create new unix socket and bind to '/sockets' (if has MAY_WRITE file permissions)
> > >> 6) recvmsg() the listen fd
> > >>
> > >> So the idea is that we set a timeout on the unix socket. If the new process
> > >> does not start and bind to the unix socket, it simply closes, thus releasing
> > >> the listen socket. However, if it does bind it can now call recvmsg() and
> > >> use the listen fd as normal. It can then simply continue to use the old listen
> > >> fds and/or create new ones and drain the old ones.
> > >>
> > >> Thus, the old and new webservers do not have to run concurrently. This doesn't
> > >> involve any changes to the tcp layer and can be used to pass any type of fd.
> > >> not sure if it's actually useful for anything else though.
> > >>
> > >> I'm not sure if this solves your use-case or not but I thought I'd share it.
> > >> One can also inherit the fds like in systemd's socket activation model, but
> > >> that again requires another process to hold open the listen fd.
> > >
> > > Thank you for sharing code.
> > >
> > > It seems bit more crash-tolerant than normal fd passing, but it can still
> > > suffer if the process dies before passing fds. With this patch set, we can
> > > migrate children sockets even if the process dies.
> > >
> >
> > I don't think crashing should be much of an issue. The old server can setup the
> > unix socket patch '/sockets' when it starts up and queue the listen sockets
> > there from the start. When it dies it will close all its fds, and the new
> > server can pick anything up any fds that are in the '/sockets' queue.
> >
> >
> > > Also, as Martin said, fd passing tends to make application complicated.
> > >
> >
> > It may be but perhaps its more flexible? It gives the new server the
> > chance to re-use the existing listen fds, close, drain and/or start new
> > ones. It also addresses the non-REUSEPORT case where you can't bind right
> > away.
>
> If the flexibility is really worth the complexity, we do not care about it.
> But, SO_REUSEPORT can give enough flexibility we want.
>
> With socket migration, there is no need to reuse listener (fd passing),
> drain children (incoming connections are automatically migrated if there is
> already another listener bind()ed), and of course another listener can
> close itself and migrated children.
>
> If two different approaches resolves the same issue and one does not need
> complexity in userspace, we select the simpler one.

Kernel bloat and complexity is _not_ the simplest choice.

Touching a complex part of TCP stack is quite risky.
