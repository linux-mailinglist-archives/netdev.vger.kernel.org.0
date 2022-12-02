Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8562B63FDF4
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 03:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbiLBCG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 21:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbiLBCGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 21:06:54 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E452D49D4
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 18:06:53 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id h193so3217578pgc.10
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 18:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cTJujriYT83KF2w8nG2Y3B03ObzaiIMx8AI30H0MJjg=;
        b=dIupAfdS3jaYJJP0+BMXuI8vC8tEEAuNiG2a6uy+/XO3z91Z7WkB8vWstYYBuLwSy9
         H5N6iqfe35JmYArRLubxMXuKsI8s6/d3h9Mci7FO/wFzG1JU6lUest600csQ+p9lOj8t
         VIGxs8QLZxGtbv0FUsh05zYPzNb+xgzR9d7xC01M/EWoJFkl7YMB30WEnDtpiVYc1K7A
         /YdCo3DRvvDajFsbBOV9l+5ZSBLKSdD7BAgJ3ot5+nQv307yD7fBqpGNTxjKuPL/p4Va
         CIKaqVj0ggzwst4R6+xBrYkLD2oqgZkP8bw32D+N6SQ/+I6BUDtSObOjque3lpGyQvea
         BR+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cTJujriYT83KF2w8nG2Y3B03ObzaiIMx8AI30H0MJjg=;
        b=I3iwFT8OuTd77FjdRM8IQDNlEv6l6vMyj6/nMQNQDwRv0jAsr0WvzbFfCM+/8fjAF+
         BgWIqVMGKNF3yl/Xcxb2HgrorW1UTnGnBMtTavury2npWbZAveXtdtW2H7PxzCMYga8R
         xPkwNLurZEx8pddV6HITQafw38StmdabAlHjeTjEx3XVRPMkVtXR5JafVCtVEnS3+Vp8
         jGfIaK8nnw9luqsFK1BNPa7+sguEw2orGmz0qwabSTTYT3W1xwVsLlCWAc4jDmuTsOoT
         xIzoGQYtDXrGDZh1IrcdY7gX0t0nGfyA4WOPZVhXpdhexgHMa1D9MqBoSoZ6kiLwxG5m
         nWcA==
X-Gm-Message-State: ANoB5pktTJuyU0zgdq3GzMlTsq08mDUyxPdHFJb6ngbzNz/AsqNSZy5F
        wFMHBIBEYwaVgO0hI6C/5A5oxbUt6FRgSBsYJcy0
X-Google-Smtp-Source: AA0mqf6Gdx+iVOTbm/SVPdBUYDHiVRjyPIyenOppLaCF3+FPR/55N1Wcr/Dmplutl3YfOwgmIdNSkm4SHYq1v/jpv5A=
X-Received: by 2002:a62:1d54:0:b0:576:27e4:3b2d with SMTP id
 d81-20020a621d54000000b0057627e43b2dmr4697451pfd.23.1669946812839; Thu, 01
 Dec 2022 18:06:52 -0800 (PST)
MIME-Version: 1.0
References: <CAFqZXNs2LF-OoQBUiiSEyranJUXkPLcCfBkMkwFeM6qEwMKCTw@mail.gmail.com>
 <108a1c80eed41516f85ebb264d0f46f95e86f754.camel@redhat.com>
In-Reply-To: <108a1c80eed41516f85ebb264d0f46f95e86f754.camel@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 1 Dec 2022 21:06:41 -0500
Message-ID: <CAHC9VhSSKN5kh9Kqgj=aCeA92bX1mJm1v4_PnRgua86OHUwE3w@mail.gmail.com>
Subject: Re: Broken SELinux/LSM labeling with MPTCP and accept(2)
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>, mptcp@lists.linux.dev,
        network dev <netdev@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 1, 2022 at 1:26 PM Paolo Abeni <pabeni@redhat.com> wrote:
> Hello,

Hello all.

> On Thu, 2022-12-01 at 14:42 +0100, Ondrej Mosnacek wrote:
> > As discovered by our QE, there is a problem with how the
> > (userspace-facing) sockets returned by accept(2) are labeled when
> > using MPTCP. Currently they always end up with the label representing
> > the kernel (typically system_u:system_r:kernel_t:s0), white they
> > should inherit the context from the parent socket (the one that is
> > passed to accept(2)) ...

Ooof, that's unfortunate :/  Thanks for reporting it though ...

> > So now the big question is: How to fix this? I can think of several
> > possible solutions, but neither of them seems to be the obvious
> > correct one:
> > 1. Wrap the socket cloned from the subflow socket in another socket
> > (similar to how the main socket + subflow(s) are handled), which would
> > be cloned from the non-kern outer socket that has the right label.
> > This could have the disadvantage of adding unnecessary overhead, but
> > would probably be simpler to do.
>
> I would avoid that option: we already have a suboptimal amount of
> indirection.

Agreed, I'm not sure I want to push for this as a fix.

> > 2. Somehow ensure that the cloned socket gets the label from the main
> > socket instead of the subflow socket. This would probably require
> > adding a new LSM hook and I'm not sure at all what would be the best
> > way to implement this.

2a. (?)  Another option would simply be ensuring that the subflow
socket has the proper LSM/SELinux label from the start.  This is
arguably The Right Thing To Do regardless, and in cases where explicit
packet labeling is used, e.g. CALIPSO, it may be necessary to do this
to ensure the traffic is labeled correctly from the start (I would
need to spend more time looking at the MPTCP code to say for certain
here).

> > 3. Somehow communicate the subflow socket <-> main socket relationship
> > to the LSM layer so that it can switch to use the label of the main
> > socket when handling an operation on a subflow socket (thus copying
> > the label correctly on accept(2)). Not a great solution, as it
> > requires each LSM that labels sockets to duplicate the indirection
> > logic.
> > 4. Do not create the subflow sockets as "kern". (Not sure if that
> > would be desirable.)
>
> No, we need subflow being kernel sockets. Lockdep will bail otherwise,
> and the would be the tip of the iceberg.
>
> > 5. Stop labeling kern sockets with the kernel's label on the SELinux
> > side and just label them based on the current task as usual. (This
> > would probably cause other issues, but maybe not...)

I'm not sure we want to open that can of worms right now.

> > Any ideas, suggestions, or patches welcome!
>
> I think something alike the following could work - not even tested,
> with comments on bold assumptions.
>
> I'll try to do some testing later.
>
> ---
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index 99f5e51d5ca4..6cad50c6fd24 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -102,6 +102,20 @@ static int __mptcp_socket_create(struct mptcp_sock *msk)
>         if (err)
>                 return err;
>
> +       /* The first subflow can later be indirectly exposed to security
> +        * relevant syscall alike accept() and bind(), and at this point
> +        * carries a 'kern' related security context.
> +        * Reset the security context to the relevant user-space one.
> +        * Note that the following assumes security_socket_post_create()
> +        * being idempotent
> +        */
> +       err = security_socket_post_create(ssock, sk->sk_family, SOCK_STREAM,
> +                                         IPPROTO_TCP, 0);
> +       if (err) {
> +               sock_release(ssock);
> +               return err;
> +       }

I'm not sure we want to start calling security_socket_post_create()
twice on a given socket, *maybe* it works okay now but that seems like
an awkward constraint to put on future LSMs (or changes to existing
ones).  If we decide that the best approach is to add a LSM hook call
here, we should create a new hook instead of reusing an existing one;
I think this falls under Ondrej's possible solution #2.

However, I think this simplest solution might be what I mentioned
above as #2a, simply labeling the subflow socket properly from the
beginning.  In the case of SELinux I think we could do that by simply
clearing the @kern flag in the case of IPPROTO_MPTCP; completely
untested (and likely whitespace mangled) hack shown below:

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f553c370397e..de6aa80b2319 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4562,6 +4562,7 @@ static int selinux_socket_create(int family, int type,
       u16 secclass;
       int rc;

+       kern = (protocol == IPPROTO_MPTCP ? 0 : kern);
       if (kern)
               return 0;

@@ -4584,6 +4585,7 @@ static int selinux_socket_post_create(struct
socket *sock, int family,
       u32 sid = SECINITSID_KERNEL;
       int err = 0;

+       kern = (protocol == IPPROTO_MPTCP ? 0 : kern);
       if (!kern) {
               err = socket_sockcreate_sid(tsec, sclass, &sid);
               if (err)

... of course the downside is that this is not a general cross-LSM
solution, but those are very hard, if not impossible, to create as the
individual LSMs can vary tremendously.  There is also the downside of
having to have a protocol specific hack in the LSM socket creation
hooks, which is a bit of a bummer, but then again we already have to
do so much worse elsewhere in the LSM networking hooks that this is
far from the worst thing we've had to do.

All this of course assumes that the quick little hack even works, I
may be missing something very obvious ... ;)

-- 
paul-moore.com
