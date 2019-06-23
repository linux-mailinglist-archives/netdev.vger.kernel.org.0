Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B224F4F97C
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 04:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfFWCNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 22:13:25 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43850 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFWCNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 22:13:25 -0400
Received: by mail-ed1-f67.google.com with SMTP id e3so15898373edr.10
        for <netdev@vger.kernel.org>; Sat, 22 Jun 2019 19:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nzsb1yOq1Jr9oz4E7sKRK6EoEaP6hlfKXwG1VW8Qjdw=;
        b=rNz47hX3rWaVLaaZN5GZ6SEQdf9Sj44q/rftBX4VGw43pz3bjdpmC8vSer4+dzcZTX
         krUzMAGuCfcp684vQkLELe2CQ8OubEjIIeijoAA7MyQgXkJQAZBRwtYksQrWMLQeVtiR
         MjhZyfQPJDh7/MnoFJYJrFOtD8NaOtoj9v2QXBN5Ttpz59jMcuVU4N/QdtF6+42bGMIR
         2zZrRJ1KG2HdlrjeSETz8UEsZIrQvz/Wfa9smrhLnrywjrGbqDG1fGEh8rzSh3Y/t2dd
         SKzGXswpb+VpdFdXr6+BfQPlKtHOzAVauMoBYonzSSngwr9tLxqIxHsgrtrvm0K3L1WB
         Bg6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nzsb1yOq1Jr9oz4E7sKRK6EoEaP6hlfKXwG1VW8Qjdw=;
        b=aqWbz5tiWB36nuw9lHRGyZUSL+u1kz/3G8wReFYHXshLqtRyP6XXw6htl94yiAiS/y
         iSif07T7dBDFs2VRPyGxzRDujq/JbS3nPwenH+/5sxkvMZAha4oAU5Kr1Q8Dbrg6C9hp
         bVIOYTfN1GzIw5ODp2nlmkMSl6UPXRMyuDLXKmxase+ex5Bx3HbiS7d87GDRmGK6lS1Q
         bud+nLq/wasBgo4aOX6/9kOrfJB5lIYYxzQ7zAAxJuKzNwh46+DdVQKCGL32y7Vsbfdj
         KLceZoGHp96EqPhTRp8cvfcOWm19dK62N5kWq2sEboyiSSckurDAP1dlvP0lUY+amoAv
         ZpaA==
X-Gm-Message-State: APjAAAVIRoF3ZeURU4G9nGJmz+MlToRTluWTaEx+5PYLOzwc4+60QBFl
        Z+/gasrCT2/jNts0yHieC4ApIOvy7QifbdAX8uBEGA==
X-Google-Smtp-Source: APXvYqxZWULi8UxyFn5D9WfkK6X9RT8eeux/HUVuRrpPxM08qP/afhNrTT0UR78Ji5tGd//Q2BkkoVDG/JdBd0WAqNo=
X-Received: by 2002:a17:906:d7a8:: with SMTP id pk8mr28891951ejb.246.1561256002558;
 Sat, 22 Jun 2019 19:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190619202533.4856-1-nhorman@tuxdriver.com> <20190622174154.14473-1-nhorman@tuxdriver.com>
In-Reply-To: <20190622174154.14473-1-nhorman@tuxdriver.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 22 Jun 2019 22:12:46 -0400
Message-ID: <CAF=yD-JC_r1vjitN1ccyvQ3DXiP9BNCwq9iiWU11cXznmhAY8Q@mail.gmail.com>
Subject: Re: [PATCH v2 net] af_packet: Block execution of tasks waiting for
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

On Sat, Jun 22, 2019 at 1:42 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> When an application is run that:
> a) Sets its scheduler to be SCHED_FIFO
> and
> b) Opens a memory mapped AF_PACKET socket, and sends frames with the
> MSG_DONTWAIT flag cleared, its possible for the application to hang
> forever in the kernel.  This occurs because when waiting, the code in
> tpacket_snd calls schedule, which under normal circumstances allows
> other tasks to run, including ksoftirqd, which in some cases is
> responsible for freeing the transmitted skb  (which in AF_PACKET calls a
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
> ---
>  net/packet/af_packet.c | 60 ++++++++++++++++++++++++++++++++----------
>  net/packet/internal.h  |  2 ++
>  2 files changed, 48 insertions(+), 14 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index a29d66da7394..8ddb2f7aebb4 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -358,7 +358,8 @@ static inline struct page * __pure pgv_to_page(void *addr)
>         return virt_to_page(addr);
>  }
>
> -static void __packet_set_status(struct packet_sock *po, void *frame, int status)
> +static void __packet_set_status(struct packet_sock *po, void *frame, int status,
> +                               bool call_complete)
>  {
>         union tpacket_uhdr h;
>
> @@ -381,6 +382,8 @@ static void __packet_set_status(struct packet_sock *po, void *frame, int status)
>                 BUG();
>         }
>
> +       if (po->wait_on_complete && call_complete)
> +               complete(&po->skb_completion);

This wake need not happen before the barrier. Only one caller of
__packet_set_status passes call_complete (tpacket_destruct_skb).
Moving this branch to the caller avoids a lot of code churn.

Also, multiple packets may be released before the process is awoken.
The process will block until packet_read_pending drops to zero. Can
defer the wait_on_complete to that one instance.

>         smp_wmb();
>  }
>
> @@ -1148,6 +1151,14 @@ static void *packet_previous_frame(struct packet_sock *po,
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
> @@ -2360,7 +2371,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>  #endif
>
>         if (po->tp_version <= TPACKET_V2) {
> -               __packet_set_status(po, h.raw, status);
> +               __packet_set_status(po, h.raw, status, false);
>                 sk->sk_data_ready(sk);
>         } else {
>                 prb_clear_blk_fill_status(&po->rx_ring);
> @@ -2400,7 +2411,7 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
>                 packet_dec_pending(&po->tx_ring);
>
>                 ts = __packet_set_timestamp(po, ph, skb);
> -               __packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
> +               __packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts, true);
>         }
>
>         sock_wfree(skb);
> @@ -2585,13 +2596,13 @@ static int tpacket_parse_header(struct packet_sock *po, void *frame,
>
>  static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  {
> -       struct sk_buff *skb;
> +       struct sk_buff *skb = NULL;
>         struct net_device *dev;
>         struct virtio_net_hdr *vnet_hdr = NULL;
>         struct sockcm_cookie sockc;
>         __be16 proto;
>         int err, reserve = 0;
> -       void *ph;
> +       void *ph = NULL;
>         DECLARE_SOCKADDR(struct sockaddr_ll *, saddr, msg->msg_name);
>         bool need_wait = !(msg->msg_flags & MSG_DONTWAIT);
>         unsigned char *addr = NULL;
> @@ -2600,9 +2611,12 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>         int len_sum = 0;
>         int status = TP_STATUS_AVAILABLE;
>         int hlen, tlen, copylen = 0;
> +       long timeo;
>
>         mutex_lock(&po->pg_vec_lock);
>
> +       timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
> +
>         if (likely(saddr == NULL)) {
>                 dev     = packet_cached_dev_get(po);
>                 proto   = po->num;
> @@ -2647,16 +2661,29 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>                 size_max = dev->mtu + reserve + VLAN_HLEN;
>
>         do {
> +
> +               if (po->wait_on_complete && need_wait) {
> +                       timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);

Why move the sleeping location from where it was with schedule()?
Without that change, ph and skb are both guaranteed to be NULL after
packet_current_frame, so can jump to out_put and avoid adding branches
at out_status. And no need for packet_next_frame.

Just replace schedule with a sleeping function in place (removing the
then obsolete need_resched call).

That is a much shorter patch and easier to compare for correctness
with the current code.

minor: probably preferable to first check local variable need_wait
before reading a struct member.

> +                       po->wait_on_complete = 0;
> +                       if (!timeo) {
> +                               /* We timed out, break out and notify userspace */
> +                               err = -ETIMEDOUT;
> +                               goto out_status;
> +                       } else if (timeo == -ERESTARTSYS) {
> +                               err = -ERESTARTSYS;
> +                               goto out_status;
> +                       }
> +               }
> +
>                 ph = packet_current_frame(po, &po->tx_ring,
>                                           TP_STATUS_SEND_REQUEST);
> -               if (unlikely(ph == NULL)) {
> -                       if (need_wait && need_resched())
> -                               schedule();
> -                       continue;
> -               }
> +
> +               if (likely(ph == NULL))

why switch from unlikely to likely?

> +                       break;
>
>                 skb = NULL;
>                 tp_len = tpacket_parse_header(po, ph, size_max, &data);
> +

nit: irrelevant

>                 if (tp_len < 0)
>                         goto tpacket_error;
>
> @@ -2699,7 +2726,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  tpacket_error:
>                         if (po->tp_loss) {
>                                 __packet_set_status(po, ph,
> -                                               TP_STATUS_AVAILABLE);
> +                                               TP_STATUS_AVAILABLE, false);
>                                 packet_increment_head(&po->tx_ring);
>                                 kfree_skb(skb);
>                                 continue;
> @@ -2719,7 +2746,9 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>                 }
>
>                 skb->destructor = tpacket_destruct_skb;
> -               __packet_set_status(po, ph, TP_STATUS_SENDING);
> +               __packet_set_status(po, ph, TP_STATUS_SENDING, false);
> +               if (!packet_next_frame(po, &po->tx_ring, TP_STATUS_SEND_REQUEST))
> +                       po->wait_on_complete = 1;
>                 packet_inc_pending(&po->tx_ring);
>
>                 status = TP_STATUS_SEND_REQUEST;
> @@ -2753,8 +2782,10 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>         goto out_put;
>
>  out_status:
> -       __packet_set_status(po, ph, status);
> -       kfree_skb(skb);
> +       if (ph)
> +               __packet_set_status(po, ph, status, false);
> +       if (skb)
> +               kfree_skb(skb);
>  out_put:
>         dev_put(dev);
>  out:
> @@ -3207,6 +3238,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
>         sock_init_data(sock, sk);
>
>         po = pkt_sk(sk);
> +       init_completion(&po->skb_completion);
>         sk->sk_family = PF_PACKET;
>         po->num = proto;
>         po->xmit = dev_queue_xmit;
> diff --git a/net/packet/internal.h b/net/packet/internal.h
> index 3bb7c5fb3bff..bbb4be2c18e7 100644
> --- a/net/packet/internal.h
> +++ b/net/packet/internal.h
> @@ -128,6 +128,8 @@ struct packet_sock {
>         unsigned int            tp_hdrlen;
>         unsigned int            tp_reserve;
>         unsigned int            tp_tstamp;
> +       struct completion       skb_completion;
> +       unsigned int            wait_on_complete;

Probably belong in packet_ring_buffer. Near pending_refcnt as touched
in the same code. And because protected by the ring buffer mutex.



>         struct net_device __rcu *cached_dev;
>         int                     (*xmit)(struct sk_buff *skb);
>         struct packet_type      prot_hook ____cacheline_aligned_in_smp;
> --
> 2.20.1
>
