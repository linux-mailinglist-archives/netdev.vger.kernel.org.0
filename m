Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4512351A48
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 20:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731804AbfFXSJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 14:09:24 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45406 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727763AbfFXSJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 14:09:24 -0400
Received: by mail-ed1-f68.google.com with SMTP id a14so22998199edv.12
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 11:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5aZLkV+5GdENza15P5YlPpeyQ5E2XYV5us/XHBq2tBU=;
        b=JEEwu1X8v14Z0AxC1lEJgZnr3s+A8LtgPBCPaM1uOfvY7Id5JO5HHqNoC/Qru2gdHg
         2PKnooTgwuk2B3J/QpBfPTPhKvsQJEk/cyzHpmlkGwWfLI+tcVp7I8zBH9e5c1LKc+Yj
         2whc6GkC6t+vFnfhus0RrmU6mf6qdDuw7n6E9UWYrv1LOBZfp44CMLgi24ZnZADbMfqR
         g6ElfGoknvLcZ2PJGkUAG06dwPWNjuIqEgE2o6MI3PvcXhmvnF8NGMaFkVP20A9xz2Pp
         /ZTSW4R3Rbb9WJxU7XSp3DGk6PQmmnyMKyY8xmNRw0Ip4t3ISh/UmvQNRnpdzZwP42R9
         sPig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5aZLkV+5GdENza15P5YlPpeyQ5E2XYV5us/XHBq2tBU=;
        b=UbSZBwuCU7QOjRG1GKvts809XONm8b5b+2N+g0TigKGYFE7+By+HktvvqRNFTDO1wT
         tXMeqVJeBw+pUr589NRWx59pwZ/ev5xSJ9Y1lvS8E3Qirao0W6bzmKVsQayrDdfUBqyL
         Mz2PvBKDDTG/GRawGfY0cwE9eLRN7VQCgyc/XacBDiry2YeD36Bym08AeAjbrz9Z1372
         txa17Xi36IPSnXK3bGfMVdB6/Noa0AOinF3oEssPWHHfXeOUSE3SBO7gWr+IfdyqhctT
         rxOAd/GAo0C6eR9Dd6g1QTU3lEDZ4X6oYrfMwnKygH/U+rc1kIfjont2AKAOkEXcT/e/
         I7ug==
X-Gm-Message-State: APjAAAVNEWGNrzSBFL7tgd+wVcRacVpUGDSkcqipGtX3rLPlh6yrGn8/
        e8DDdDi101xSh4k3f+ZsFE+nBBXeftKVlGTyOLA=
X-Google-Smtp-Source: APXvYqzGRt5GkfD6OTn7h2sLBfyXb1GQg4LlPGeC4dE9d8TL8m2gGp/EiyE1itvvJ0TupAaiU1DqcI7lWYjgEUM5zS8=
X-Received: by 2002:a17:906:cd1f:: with SMTP id oz31mr44804361ejb.226.1561399761349;
 Mon, 24 Jun 2019 11:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190619202533.4856-1-nhorman@tuxdriver.com> <20190624004604.25607-1-nhorman@tuxdriver.com>
In-Reply-To: <20190624004604.25607-1-nhorman@tuxdriver.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 24 Jun 2019 14:08:43 -0400
Message-ID: <CAF=yD-JE9DEbmh6hJEN=DEdc+SCz_5Lv74mngPBuv=4nNH=zxQ@mail.gmail.com>
Subject: Re: [PATCH v3 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 8:46 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> When an application is run that:
> a) Sets its scheduler to be SCHED_FIFO
> and
> b) Opens a memory mapped AF_PACKET socket, and sends frames with the
> MSG_DONTWAIT flag cleared, its possible for the application to hang
> forever in the kernel.  This occurs because when waiting, the code in
> tpacket_snd calls schedule, which under normal circumstances allows
> other tasks to run, including ksoftirqd, which in some cases is
> responsible for freeing the transmitted skb (which in AF_PACKET calls a
> destructor that flips the status bit of the transmitted frame back to
> available, allowing the transmitting task to complete).
>
> However, when the calling application is SCHED_FIFO, its priority is
> such that the schedule call immediately places the task back on the cpu,
> preventing ksoftirqd from freeing the skb, which in turn prevents the
> transmitting task from detecting that the transmission is complete.
>
> We can fix this by converting the schedule call to a completion
> mechanism.  By using a completion queue, we force the calling task, when
> it detects there are no more frames to send, to schedule itself off the
> cpu until such time as the last transmitted skb is freed, allowing
> forward progress to be made.
>
> Tested by myself and the reporter, with good results
>
> Appies to the net tree
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: Matteo Croce <mcroce@redhat.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
>
> Change Notes:
>
> V1->V2:
>         Enhance the sleep logic to support being interruptible and
> allowing for honoring to SK_SNDTIMEO (Willem de Bruijn)
>
> V2->V3:
>         Rearrage the point at which we wait for the completion queue, to
> avoid needing to check for ph/skb being null at the end of the loop.
> Also move the complete call to the skb destructor to avoid needing to
> modify __packet_set_status.  Also gate calling complete on
> packet_read_pending returning zero to avoid multiple calls to complete.
> (Willem de Bruijn)
>
>         Move timeo computation within loop, to re-fetch the socket
> timeout since we also use the timeo variable to record the return code
> from the wait_for_complete call (Neil Horman)
> ---
>  net/packet/af_packet.c | 59 +++++++++++++++++++++++++++++++++++++-----
>  net/packet/internal.h  |  2 ++
>  2 files changed, 55 insertions(+), 6 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index a29d66da7394..5c48bb7a4fa5 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -380,7 +380,6 @@ static void __packet_set_status(struct packet_sock *po, void *frame, int status)
>                 WARN(1, "TPACKET version not supported.\n");
>                 BUG();
>         }
> -

Unrelated to this feature

>         smp_wmb();
>  }
>
> @@ -1148,6 +1147,14 @@ static void *packet_previous_frame(struct packet_sock *po,
>         return packet_lookup_frame(po, rb, previous, status);
>  }
>
> +static void *packet_next_frame(struct packet_sock *po,
> +               struct packet_ring_buffer *rb,
> +               int status)
> +{
> +       unsigned int next = rb->head != rb->frame_max ? rb->head+1 : 0;
> +       return packet_lookup_frame(po, rb, next, status);
> +}
> +
>  static void packet_increment_head(struct packet_ring_buffer *buff)
>  {
>         buff->head = buff->head != buff->frame_max ? buff->head+1 : 0;
> @@ -2401,6 +2408,9 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
>
>                 ts = __packet_set_timestamp(po, ph, skb);
>                 __packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
> +
> +               if (po->wait_on_complete && !packet_read_pending(&po->tx_ring))
> +                       complete(&po->skb_completion);
>         }
>
>         sock_wfree(skb);
> @@ -2600,9 +2610,11 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>         int len_sum = 0;
>         int status = TP_STATUS_AVAILABLE;
>         int hlen, tlen, copylen = 0;
> +       long timeo = 0;
>
>         mutex_lock(&po->pg_vec_lock);
>
> +

Same

>         if (likely(saddr == NULL)) {
>                 dev     = packet_cached_dev_get(po);
>                 proto   = po->num;
> @@ -2647,16 +2659,16 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>                 size_max = dev->mtu + reserve + VLAN_HLEN;
>
>         do {
> +

Same

>                 ph = packet_current_frame(po, &po->tx_ring,
>                                           TP_STATUS_SEND_REQUEST);
> -               if (unlikely(ph == NULL)) {
> -                       if (need_wait && need_resched())
> -                               schedule();
> -                       continue;

Why not keep the test whether the process needs to wait exactly here (A)?

Then no need for packet_next_frame.

> -               }
> +
> +               if (unlikely(ph == NULL))
> +                       break;
>
>                 skb = NULL;
>                 tp_len = tpacket_parse_header(po, ph, size_max, &data);
> +

Again

>                 if (tp_len < 0)
>                         goto tpacket_error;
>
> @@ -2720,6 +2732,21 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>
>                 skb->destructor = tpacket_destruct_skb;
>                 __packet_set_status(po, ph, TP_STATUS_SENDING);
> +
> +               /*
> +                * If we need to wait and we've sent the last frame pending
> +                * transmission in the mmaped buffer, flag that we need to wait
> +                * on those frames to get freed via tpacket_destruct_skb.  This
> +                * flag indicates that tpacket_destruct_skb should call complete
> +                * when the packet_pending count reaches zero, and that we need
> +                * to call wait_on_complete_interruptible_timeout below, to make
> +                * sure we pick up the result of that completion
> +                */
> +               if (need_wait && !packet_next_frame(po, &po->tx_ring, TP_STATUS_SEND_REQUEST)) {
> +                       po->wait_on_complete = 1;
> +                       timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);

This resets timeout on every loop. should only set above the loop once.

Also, please limit the comments in the code (also below). If every
patch would add this many lines of comment, the file would be
enormous. OTOH, it's great to be this explanatory in the git commit,
which is easily reached for any line with git blame.

> +               }
> +
>                 packet_inc_pending(&po->tx_ring);
>
>                 status = TP_STATUS_SEND_REQUEST;
> @@ -2728,6 +2755,11 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>                         err = net_xmit_errno(err);
>                         if (err && __packet_get_status(po, ph) ==
>                                    TP_STATUS_AVAILABLE) {
> +                               /* re-init completion queue to avoid subsequent fallthrough
> +                                * on a future thread calling wait_on_complete_interruptible_timeout
> +                                */
> +                               po->wait_on_complete = 0;

If setting where sleeping, no need for resetting if a failure happens
between those blocks.

> +                               init_completion(&po->skb_completion);

no need to reinit between each use?

>                                 /* skb was destructed already */
>                                 skb = NULL;
>                                 goto out_status;
> @@ -2740,6 +2772,20 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>                 }
>                 packet_increment_head(&po->tx_ring);
>                 len_sum += tp_len;
> +
> +               if (po->wait_on_complete) {
> +                       timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
> +                       po->wait_on_complete = 0;

I was going to argue for clearing in tpacket_destruct_skb. But then we
would have to separate clear on timeout instead of signal, too.

  po->wait_on_complete = 1;
  timeo = wait_for_completion...
  po->wait_on_complete = 0;

as the previous version had is fine, as long as the compiler does not
"optimize" away an assignment. The function call will avoid reordering
by the cpu, at least. Probably requires WRITE_ONCE/READ_ONCE.

> +                       if (!timeo) {
> +                               /* We timed out, break out and notify userspace */
> +                               err = -ETIMEDOUT;
> +                               goto out_status;

goto out_put, there is no active ph or skb here

> +                       } else if (timeo == -ERESTARTSYS) {
> +                               err = -ERESTARTSYS;
> +                               goto out_status;
> +                       }
> +               }
> +
>         } while (likely((ph != NULL) ||
>                 /* Note: packet_read_pending() might be slow if we have
>                  * to call it as it's per_cpu variable, but in fast-path
> @@ -3207,6 +3253,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
>         sock_init_data(sock, sk);
>
>         po = pkt_sk(sk);
> +       init_completion(&po->skb_completion);
>         sk->sk_family = PF_PACKET;
>         po->num = proto;
>         po->xmit = dev_queue_xmit;

This is basically replacing a busy-wait with schedule() with sleeping
using wait_for_completion_interruptible_timeout. My main question is
does this really need to move control flow around and add
packet_next_frame? If not, especially for net, the shortest, simplest
change is preferable.
