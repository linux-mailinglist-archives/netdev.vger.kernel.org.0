Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5E73BA460
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 21:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhGBTgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 15:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbhGBTgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 15:36:11 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD1FC061762;
        Fri,  2 Jul 2021 12:33:38 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id d12so10598734pgd.9;
        Fri, 02 Jul 2021 12:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/r8KKgt4rwYT9FIcCuBJGz0m9Q7E40Ff+FmgGOp5h80=;
        b=HEP6MCoahI8BGPv0fMzELdc+YcWENvQ0Uo4pBuRonWRl7PHyjFbo8oZKRbrc/TO6OP
         x51IM+8qOTIqbuE3JeAmP5gsSjesxzkbeMzr+pNSNnkdfdLvXfQLPRU6YZH7FdzFS1dh
         HWhGRiO2wzH4R5wXSNXowXPihLBkNzMX3uUAZfPwOQME3Nqz/7BrYthlRzQ0kHtlLaBJ
         ZrKVvQ5dWZw/R14JtnfS8urB+oK4Eb+tJDJykeDs5hazN5tzWJxHhLCsqLoBlSbkJ3Ir
         hLc+bU9JO/W5kQzSHns3YjTaAxfkSrWWal3dWW5Sg9gbYlsvUfEwrdsutLpwnvpFKFrd
         Q4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/r8KKgt4rwYT9FIcCuBJGz0m9Q7E40Ff+FmgGOp5h80=;
        b=Y9WjVLO0mraoOMnIvsSeeYU4iEG6nvWdltCfzARQfRI+PHfBiADhgxS6NQm4JbsCPB
         uJs3MSIT6uKQ0GHgtDoUkriBmf6kn30+4/GylrlH6mqTHozertT7tpSGG55Bh15jE2lj
         gvU9jGjYFoNzpZq/nowNSb+eLrE2Ceo8OCOGTFPSgm6AHR3kkA7FDBSma4Im4k8t6WVL
         duUlVdNQ6YLjdqvUAllqeSE8dUt8zb7jvmFudC7iXVzgCBSA+zuahhT7Exl74mSO6YXo
         iirhECHvhISFfKjZPtNxy1gMMH0Ycvvrsb44zGucGlcNC0lvcWdAC05tR3l+uMCLNDf4
         aAog==
X-Gm-Message-State: AOAM531yrERBfWbf+3GFuqz4Ob39ulFXErYSkxQIqPD7rVemTLwAOK2e
        r33l1CNaSaOj3U2zhaRe01gyIEsSLBuGjIIhRSs=
X-Google-Smtp-Source: ABdhPJya+0Ew123km7P9nQiwmsd+Yk6+qe1QFBxeFfr3jXYkg/xICDgPZByY439O+U+SUoTnj9rmTz36wzWVzc7d0PI=
X-Received: by 2002:a05:6a00:1a50:b029:305:7cd3:ab35 with SMTP id
 h16-20020a056a001a50b02903057cd3ab35mr1310300pfv.31.1625254418046; Fri, 02
 Jul 2021 12:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210701061656.34150-1-xiyou.wangcong@gmail.com>
 <60ddec01c651b_3fe24208dc@john-XPS-13-9370.notmuch> <CAM_iQpUg6EQq0XdahWVZe9CYbN-iY_gfFq5p=+2URPmH0r6bwQ@mail.gmail.com>
In-Reply-To: <CAM_iQpUg6EQq0XdahWVZe9CYbN-iY_gfFq5p=+2URPmH0r6bwQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 2 Jul 2021 12:33:27 -0700
Message-ID: <CAM_iQpXFsBX8CK0YYEsj+MvB7cQdwjjvokWamjGLqmPb8MUktg@mail.gmail.com>
Subject: Re: [Patch bpf v2] skmsg: check sk_rcvbuf limit before queuing to ingress_skb
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 11:00 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Jul 1, 2021 at 9:23 AM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > We can't just drop the packet in the memory overrun case here. This will
> > break TCP because the data will be gone and no one will retransmit.
> >
> > Thats why in the current scheme on redirect we can push back when we
> > move it to the other queues ingress message queue or redirect into
> > the other socket via send.
> >
> > At one point I considered charging the data sitting in the ingress_skb?
> > Would that solve the problem here? I think it would cause the enqueue
> > at the UDP to start dropping packets from __udp_enqueue_schedule_skb()?
>
> I tried to move skb_set_owner_r() here, TCP is clearly unhappy about it,
> as I explained in changelog. Yes, it probably helps if we could move it here.

Sorry for replying too quickly. Actually it probably does _not_ help,
because we have to limit the dest socket buffer, not the source.

For example, if we have 5 sockets in a sockmap and all of them send
packets to the same one, the dest socket could still get 5x sk_rcvbuf
bytes pending in its ingress_skb.

And I do not know why you want to single out the TCP case, at least
the ebpf program can decide to drop TCP packets too, this drop is
not any different from the drop due to rcvbuf overlimit.

Therefore, I think my patch is fine as it is.

Thanks.
