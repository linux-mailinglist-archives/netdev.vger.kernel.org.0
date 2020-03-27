Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA42194E65
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 02:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgC0B0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 21:26:38 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:42814 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgC0B0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 21:26:38 -0400
Received: by mail-il1-f196.google.com with SMTP id f16so7312156ilj.9;
        Thu, 26 Mar 2020 18:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F66RhDQcShFn8I8t+l4V6OVfc7ivlYHohyShv0sMSJw=;
        b=bJXdhtbVVhkri762llCOyn474cVYAsf0pK3aB8y8VzFJP3hllPDzXdFu/774S8VD+D
         DHTowWK3048IAN2IjZvlW0kAIHW3c8F6roCOz1f42azxDUSIaXW4I5JRQqdxB8coMJ/I
         gYqjNqmvg+I4GTFhbhHXB1+0qQRFAb1RKkWFMw5lwfSz4Tzt6ivFCqMiVGzbDdTKw6Pm
         CCkCKzWqEkG9j+lTG8/M79aUU4AbLhtVQ1RzQpvNgvSrl4lsh9MKqnTaggd/cq4lKaSp
         23Cpb8bhbt0lLLoZ6eytNcb1+2/xOmIGnTwkIvx4nHaca56cN9shiT6lg+BVOXXHnNE3
         ipHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F66RhDQcShFn8I8t+l4V6OVfc7ivlYHohyShv0sMSJw=;
        b=HJrxcXDD4TQjbCZUuLk3IuWxOEtZgf640SaAhnwEtWuuh9BNBUlEly8b7rxoBSTJ8V
         I6nm4PYiHzcUE1QwpMQ2ikMTTLr+73k0JM2mM88mpY5RuvXPaVXTCAd8ohk5uJ/xc9U9
         w2+BCS1yc2de2TMsk2SolKPy4qnWIieI2oDzrokGMmkxk1ooVYbju0Wd9UTNjyPjnblu
         UvR/n3nmC2xM9FbNQYFnHPZaRQg7boF/g0Q5AF3CJbW9A/tSUUxWUexTUZPzVq3fiAus
         //puDAQ+KwjqnIinjAeUOTYjg9fXTUrUpB9km5z6J+G9ZFbY4/7DMyyUJ3L92Zjc2YhT
         SeUw==
X-Gm-Message-State: ANhLgQ0F4Ydb5dKsFU+/nS8kO7NMu5itRFWMCqseZifVBw9nDmZnjj9k
        2Yv5wptA9ahtmmZ6KKK4GbZtfwokmkI5xSl4a+Y=
X-Google-Smtp-Source: ADFU+vsOOBBlYuCMTOwzH6Z6+Bh774bOWVgTCpZZwuJpCtrep4eg57i8xz+zwDNshlTZigJBRYU2Bte0hRECN7bSjD4=
X-Received: by 2002:a92:5b56:: with SMTP id p83mr11834956ilb.70.1585272396841;
 Thu, 26 Mar 2020 18:26:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200327011912.19040-1-hqjagain@gmail.com>
In-Reply-To: <20200327011912.19040-1-hqjagain@gmail.com>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Fri, 27 Mar 2020 09:26:24 +0800
Message-ID: <CAJRQjoeEUodD6U8EmFbbKJV-_-4i50tKeAQ--uKm7fwoNqoQ1A@mail.gmail.com>
Subject: Re: [PATCH v5] sctp: fix refcount bug in sctp_wfree
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sorry about missing a line. please ignore this.
I'll resend the patch.

On Fri, Mar 27, 2020 at 9:19 AM Qiujun Huang <hqjagain@gmail.com> wrote:
>
> We should iterate over the datamsgs to modify
> all chunks(skbs) to newsk.
>
> The following case cause the bug:
> for the trouble SKB, it was in outq->transmitted list
>
> sctp_outq_sack
>         sctp_check_transmitted
>                 SKB was moved to outq->sacked list
>         then throw away the sack queue
>                 SKB was deleted from outq->sacked
> (but it was held by datamsg at sctp_datamsg_to_asoc
> So, sctp_wfree was not called here)
>
> then migrate happened
>
>         sctp_for_each_tx_datachunk(
>         sctp_clear_owner_w);
>         sctp_assoc_migrate();
>         sctp_for_each_tx_datachunk(
>         sctp_set_owner_w);
> SKB was not in the outq, and was not changed to newsk
>
> finally
>
> __sctp_outq_teardown
>         sctp_chunk_put (for another skb)
>                 sctp_datamsg_put
>                         __kfree_skb(msg->frag_list)
>                                 sctp_wfree (for SKB)
>         SKB->sk was still oldsk (skb->sk != asoc->base.sk).
>
> Reported-and-tested-by:syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> ---
>  net/sctp/socket.c | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 1b56fc440606..75acbd5d4597 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -147,29 +147,43 @@ static void sctp_clear_owner_w(struct sctp_chunk *chunk)
>         skb_orphan(chunk->skb);
>  }
>
> +#define traverse_and_process() \
> +do {                           \
> +       msg = chunk->msg;       \
> +       if (msg == prev_msg)    \
> +               continue;       \
> +       list_for_each_entry(c, &msg->chunks, frag_list) {       \
> +               if ((clear && asoc->base.sk == c->skb->sk) ||   \
> +                   (!clear && asoc->base.sk != c->skb->sk))    \
> +                   cb(c);      \
> +       }                       \
> +} while (0)
> +
>  static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
> +                                      bool clear,
>                                        void (*cb)(struct sctp_chunk *))
>
>  {
> +       struct sctp_datamsg *msg, *prev_msg = NULL;
>         struct sctp_outq *q = &asoc->outqueue;
> +       struct sctp_chunk *chunk, *c;
>         struct sctp_transport *t;
> -       struct sctp_chunk *chunk;
>
>         list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
>                 list_for_each_entry(chunk, &t->transmitted, transmitted_list)
> -                       cb(chunk);
> +                       traverse_and_process();
>
>         list_for_each_entry(chunk, &q->retransmit, transmitted_list)
> -               cb(chunk);
> +               traverse_and_process();
>
>         list_for_each_entry(chunk, &q->sacked, transmitted_list)
> -               cb(chunk);
> +               traverse_and_process();
>
>         list_for_each_entry(chunk, &q->abandoned, transmitted_list)
> -               cb(chunk);
> +               traverse_and_process();
>
>         list_for_each_entry(chunk, &q->out_chunk_list, list)
> -               cb(chunk);
> +               traverse_and_process();
>  }
>
>  static void sctp_for_each_rx_skb(struct sctp_association *asoc, struct sock *sk,
> @@ -9574,9 +9588,9 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
>          * paths won't try to lock it and then oldsk.
>          */
>         lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
> -       sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
> +       sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
>         sctp_assoc_migrate(assoc, newsk);
> -       sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
> +       sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
>
>         /* If the association on the newsk is already closed before accept()
>          * is called, set RCV_SHUTDOWN flag.
> --
> 2.17.1
>
