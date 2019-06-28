Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342A159E95
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 17:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfF1PPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 11:15:48 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33517 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfF1PPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 11:15:48 -0400
Received: by mail-ed1-f67.google.com with SMTP id i11so11316306edq.0
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5iKcqBcoazFnqH3lzbUbhSsaHjkPYWC+N5aCQnEhSm0=;
        b=bnp/yomU/paF1YCdqRDlfXa4GbwvwdMZOjOvCld5H25qKk+7OJpM8XYTDe0WCFqIhI
         lhcIugjwmMdhWW5CUNgp2kvgb5x4Yrkc48nBtIQAs2QPR2FCZPKuQ4op+f8yoKRPs3Gr
         GxA8yOmVAzGZHa6ja6Qnk4auJH2GOV0gGdcoL4bnPJG71goq4EmS7I333fBCxxHWrWu7
         nTtVh41dvl6gHg8yK6eoaH/8wvVWHKzVeblEIF2FNib0hH28ZUYvcpgx6BoxKOobT32C
         Kny9higrReTRRraxjqPWn3/J/F1ai1QRx88NvbgAf3tslevMjXM6ATTGZncZ8N3706tn
         aJUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5iKcqBcoazFnqH3lzbUbhSsaHjkPYWC+N5aCQnEhSm0=;
        b=RIupR3qhyj8SQdmm2khriqaNm1BWUyo2bDlY5vlbR6z9zTieIQsUMM9kapb3f6ULjf
         Q/dB70RXJSYTpS5n1Hur/6PEfhuMUxuZ37r/7oN2FlL1k+olP6r+U4kt1k7jph22fo37
         4nQ4/knJVKy6NZvyXJRtKfRGUzP1QUJCmrfhhbo/SrXQpDGOfejXfbRFKx/+8nyvX1M/
         EtnLM6wYxd028v0SXDQCyRZQkjdEkuk6wGR4psD/8PvS+w5D6qLJw7BharF9NmxdOY0C
         9NostrvyyVPQQn4wQYX2ZomhHx3o+ZhMENDvhGhPBCoLRLtuwP3+omsJOeHKQol5/V3b
         CG8g==
X-Gm-Message-State: APjAAAXv0HNfGCZuK0YzBDZTFNbEI/ZzVqwH6YAYOHsBe/JKsLwt58gb
        whG0Ftrs5rrOwMl6qUH4bjhnjgwtRdy7sKv49UM=
X-Google-Smtp-Source: APXvYqwrJ6RmuL21FaSpCBtVmsXOaAY4RFubTkuBt2xlc1oei5BHh/9ZbaeWLv0Sin9JzV/uGVxkJzuQ9P7pq26TMmg=
X-Received: by 2002:a50:9153:: with SMTP id f19mr12259980eda.70.1561734946713;
 Fri, 28 Jun 2019 08:15:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190628145206.13871-1-nhorman@tuxdriver.com>
In-Reply-To: <20190628145206.13871-1-nhorman@tuxdriver.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 28 Jun 2019 11:15:09 -0400
Message-ID: <CAF=yD-Joh1ne4Y_pwDv8VOcWnKP-2veeXWw=eUBoZKr5___3TA@mail.gmail.com>
Subject: Re: [PATCH net-next] af_packet: convert pending frame counter to atomic_t
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 10:53 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> The AF_PACKET protocol, when running as a memory mapped socket uses a
> pending frame counter to track the number of skbs in flight during
> transmission.  It is incremented during the sendmsg call (via
> tpacket_snd), and decremented (possibly asynchronously) in the skb
> desructor during skb_free.
>
> The counter is currently implemented as a percpu variable for each open
> socket, but for reads (via packet_read_pending), we iterate over every
> cpu variable, accumulating the total pending count.
>
> Given that the socket transmit path is an exclusive path (locked via the
> pg_vec_lock mutex), we do not have the ability to increment this counter
> on multiple cpus in parallel.  This implementation also seems to have
> the potential to be broken, in that, should an skb be freed on a cpu
> other than the one that it was initially transmitted on, we may
> decrement a counter that was not initially incremented, leading to
> underflow.
>
> As such, adjust the packet socket struct to convert the per-cpu counter
> to an atomic_t variable (to enforce consistency between the send path
> and the skb free path).  This saves us some space in the packet_sock
> structure, prevents the possibility of underflow, and should reduce the
> run time of packet_read_pending, as we only need to read a single
> variable, instead of having to loop over every available cpu variable
> instance.
>
> Tested by myself by running a small program which sends frames via
> AF_PACKET on multiple cpus in parallel, with good results.
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Willem de Bruijn <willemb@google.com>
> ---

This essentially is a revert of commit b013840810c2 ("packet: use
percpu mmap tx frame pending refcount"). That has some benchmark
numbers and also discusses the overflow issue.

I think more interesting would be to eschew the counter when
MSG_DONTWAIT, as it is only used to know when to exit the loop if
need_wait.

But, IMHO packet sockets are deprecated in favor of AF_XDP and
should be limited to bug fixes at this point.

>  net/packet/af_packet.c | 40 +++++-----------------------------------
>  net/packet/internal.h  |  2 +-
>  2 files changed, 6 insertions(+), 36 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 8d54f3047768..25ffb486fac9 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1154,43 +1154,17 @@ static void packet_increment_head(struct packet_ring_buffer *buff)
>
>  static void packet_inc_pending(struct packet_ring_buffer *rb)
>  {
> -       this_cpu_inc(*rb->pending_refcnt);
> +       atomic_inc(&rb->pending_refcnt);
>  }

If making this change, can also remove these helper functions. The
layer of indirection just hinders readability.
