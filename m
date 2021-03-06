Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C8E32FC80
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 19:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhCFSfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 13:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhCFSe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 13:34:26 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F90C06174A;
        Sat,  6 Mar 2021 10:34:26 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id q2-20020a17090a2e02b02900bee668844dso873006pjd.3;
        Sat, 06 Mar 2021 10:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8gZd8NLDd/BP6NMzCF+ksvN+bAQFSRD3GtTbo2ubDkg=;
        b=YeWCLxQFoijZ9u8cGLT1NZjFpwNsJnGojQR4kv800xuHYCef/xiPVsXaxP8rqBn4Gc
         e+vEzXw4x0YRxy6ZGtqn9aEF8pVhrM627aMY3Z0HH9t/lZQhKga//Babob/DWucJTwvM
         IAO1vpbg4wczKSNEykc0gbUPO2hY0+R1rIx/BNKPNZczWRk8m5BR8LEiIUaiQhlEm/nQ
         YlGC8Q9+M9mvpKUhR5U4nMs+d08cUz1KrmGb3p6dqZKRJg2QJZ+D4b/blIL4XJJiQavv
         G6Thk7AG2YgJIoeuS7uFPWj0bmF4TIGHtJSgh9ge088KOJD3kKNUeqwwNDgHwm1mE0D5
         csOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8gZd8NLDd/BP6NMzCF+ksvN+bAQFSRD3GtTbo2ubDkg=;
        b=i2NjWuA1g61EKh8sWgMTYjMMdgZekcMcsiywIQqnoWNk8NFYuvSRQbHhi8WO3751fZ
         cuAhe1JtWqJGidDRLnK4Cn6zaHpEPWVEZcMgZe5QKQFpg5q5biB6F8vmOecN47unFP2t
         x86T7sJf9+6t+qJPjf2phCOX7f+fGrXi+U58Tm1A83bG5B2maK7i5oGMDpTHzpnHJrTV
         7uxTMO6mT3KJFYVUJw3rgknW0Myt2lRV4GQAPJ+OEhubvDhQUn1sP+LaoZ3wwlMI0FU2
         MDkN3rGVW8a0N3t6J19gJrjfxTsZTOcH/YQeH6QiJ123vRTwn2CLUyVCh4VZjltSkjKu
         IpeA==
X-Gm-Message-State: AOAM533BTkykt2flZ4/sThEHnBTAB2pqkT/L3dVamyFo5dadJd0CwjCc
        nn3vGUcqOvXfQtfM6ChuBCNGGpxSOftLm9jWHHSH9JGGye5s3Q==
X-Google-Smtp-Source: ABdhPJwNm/lf4lFAKLxSBAqmBUgfgJ4j7uhweEd1iPsWxYLvM3HJlw+5dDBDVOqFGbldGdVEXu2MsJ5T+v2cnEmgbm8=
X-Received: by 2002:a17:90a:ce92:: with SMTP id g18mr16960086pju.52.1615055665649;
 Sat, 06 Mar 2021 10:34:25 -0800 (PST)
MIME-Version: 1.0
References: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
 <20210305015655.14249-4-xiyou.wangcong@gmail.com> <6042d8fa32b92_135da20871@john-XPS-13-9370.notmuch>
In-Reply-To: <6042d8fa32b92_135da20871@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 6 Mar 2021 10:34:14 -0800
Message-ID: <CAM_iQpWbcrBCguHXh0NhyOrCfP3N2x7LzM=pYqKHT6=NCN_JAw@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 3/9] udp: implement ->sendmsg_locked()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 5, 2021 at 5:21 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > UDP already has udp_sendmsg() which takes lock_sock() inside.
> > We have to build ->sendmsg_locked() on top of it, by adding
> > a new parameter for whether the sock has been locked.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/net/udp.h  |  1 +
> >  net/ipv4/af_inet.c |  1 +
> >  net/ipv4/udp.c     | 30 +++++++++++++++++++++++-------
> >  3 files changed, 25 insertions(+), 7 deletions(-)
>
> [...]
>
> > -int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
> > +static int __udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len, bool locked)
> >  {
>
> The lock_sock is also taken by BPF_CGROUP_RUN_PROG_UDP4_SENDMSG_LOCK() in
> udp_sendmsg(),
>
>  if (cgroup_bpf_enabled(BPF_CGROUP_UDP4_SENDMSG) && !connected) {
>     err = BPF_CGROUP_RUN_PROG_UDP4_SENDMSG_LOCK(sk,
>                                     (struct sockaddr *)usin, &ipc.addr);
>
> so that will also need to be handled.

Indeed, good catch!

>
> It also looks like sk_dst_set() wants the sock lock to be held, but I'm not
> seeing how its covered in the current code,
>
>  static inline void
>  __sk_dst_set(struct sock *sk, struct dst_entry *dst)
>  {
>         struct dst_entry *old_dst;
>
>         sk_tx_queue_clear(sk);
>         sk->sk_dst_pending_confirm = 0;
>         old_dst = rcu_dereference_protected(sk->sk_dst_cache,
>                                             lockdep_sock_is_held(sk));
>         rcu_assign_pointer(sk->sk_dst_cache, dst);
>         dst_release(old_dst);
>  }

I do not see how __sk_dst_set() is called in udp_sendmsg().

>
> I guess this could trip lockdep now, I'll dig a bit more Monday and see
> if its actually the case.
>
> In general I don't really like code that wraps locks in 'if' branches
> like this. It seem fragile to me. I didn't walk every path in the code

I do not like it either, actually I spent quite some time trying to
get rid of this lock_sock, it is definitely not easy. The comment in
sk_psock_backlog() is clearly wrong, we do not lock_sock to keep
sk_socket, we lock it to protect other structures like
ingress_{skb,msg}.

> to see if a lock is taken in any of the called functions but it looks
> like ip_send_skb() can call into netfilter code and may try to take
> the sock lock.

Are you saying skb_send_sock_locked() is buggy? If so, clearly not
my fault.

>
> Do we need this locked send at all? We use it in sk_psock_backlog
> but that routine needs an optimization rewrite for TCP anyways.
> Its dropping a lot of performance on the floor for no good reason.

At least for ingress_msg. It is not as easy as adding a queue lock here,
because we probably want to retrieve atomically with the receive queue
together.

Thanks.
