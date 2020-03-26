Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D10D1936B3
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgCZDW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:22:58 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33777 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbgCZDW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 23:22:57 -0400
Received: by mail-qk1-f196.google.com with SMTP id v7so5137759qkc.0;
        Wed, 25 Mar 2020 20:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YeOy0OBasIdly6oWWvsKSzzwXWKpMwurTBwp+GVkZds=;
        b=KCmIfvbYyV7j43ojdw2tuBoWEvYIzBj7v7nPy611jNiX7OuPrMWI1OFBiJODURzwPO
         iIU/LkLvDfZcJ5yqUdM6z97qgBbw+DL5czuJoqk1KdCAzLvvWcJXq2i3wTi6JLIc3KA1
         AkvaRfuM7sxuswgbDJGdPO4sKjnc19a3gTVnrvaFX+hlBbK36TCUlRkXzTO9zFRYnmgs
         gPeJGy04xFJwAMAokTAZ4KO40eX/DDfgg2cf3ffgtwNYkkrcjaWTG6T4VuSF4JVEr/PY
         aHjhSF0712u6Mv5Fc+oi7pDIn6226qGec2iu2g8QzFU/Mj++QPrGgD3h5WWsgOEWk/wQ
         iFQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YeOy0OBasIdly6oWWvsKSzzwXWKpMwurTBwp+GVkZds=;
        b=s4kk8tGoK4NcvpSejZ8uWiWLpZMC9wPsj4itBktbTWL3r/ajwd7dLKGfRkzVSTl8lq
         0fByktlQoiDtruoe8uM7eRH762q6FsMcYUKMvQYhpezNyM4xoyLnLQE1z5QYHPXBhXTx
         VCRSYy6RXVSJppOgwdjmpF8T2QUUIMM+mtwwqb2IxvX5b+C38NUulvl8te+tdVrq0vZe
         EgpEvfxh9icaiSRLxUJP9rqXsJXlZOQv9xpcNdi2hkSp7yWr8R7mugaDAr5nHj7KFNea
         V+XGGlftW6g9+UGzE4qyCoS0/0CF9By1e07HilVnv4ocHTp6pz+RhdaSeN/cEAK90O6X
         daGw==
X-Gm-Message-State: ANhLgQ3teMoYXMoZJLjcBvHmScGrCx1n3rOeiyiFSS/DtUKBE+hvr7NQ
        CBVSuw/cj5sJtHn+9z9SU4I=
X-Google-Smtp-Source: ADFU+vs8Ayeb6bVEbFzkIaUSWWCm8+4rjxtf1TQeNATQ5/YUiFsyKQNQlmIu8dGuhB8WFBwYSX88fQ==
X-Received: by 2002:a37:7e82:: with SMTP id z124mr5941475qkc.360.1585192976039;
        Wed, 25 Mar 2020 20:22:56 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f028:d8e3:b319:cf5:7776:b4d9])
        by smtp.gmail.com with ESMTPSA id t140sm619143qke.48.2020.03.25.20.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 20:22:55 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id EC155C5CE4; Thu, 26 Mar 2020 00:22:52 -0300 (-03)
Date:   Thu, 26 Mar 2020 00:22:52 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>,
        linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com
Subject: Re: [PATCH v4] sctp: fix refcount bug in sctp_wfree
Message-ID: <20200326032252.GI3756@localhost.localdomain>
References: <20200322090425.6253-1-hqjagain@gmail.com>
 <20200326001416.GH3756@localhost.localdomain>
 <CAJRQjoeWUHj7Ep5ycTxVJVuxmhzrzXx=-rP_h=hCCrBvgTUNEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJRQjoeWUHj7Ep5ycTxVJVuxmhzrzXx=-rP_h=hCCrBvgTUNEg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 09:30:08AM +0800, Qiujun Huang wrote:
> On Thu, Mar 26, 2020 at 8:14 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Sun, Mar 22, 2020 at 05:04:25PM +0800, Qiujun Huang wrote:
> > > sctp_sock_migrate should iterate over the datamsgs to modify
> > > all trunks(skbs) to newsk. For this, out_msg_list is added to
> >
> > s/trunks/chunks/
> 
> My :p.
> 
> >
> > > sctp_outq to maintain datamsgs list.
> >
> > It is an interesting approach. It speeds up the migration, yes, but it
> > will also use more memory per datamsg, for an operation that, when
> > performed, the socket is usually calm.
> >
> > It's also another list to be handled, and I'm not seeing the patch
> > here move the datamsg itself now to the new outq. It would need
> > something along these lines:
> 
> Are all the rx chunks in the rx queues?

Yes, even with GSO.

> 
> > sctp_sock_migrate()
> > {
> > ...
> >         /* Move any messages in the old socket's receive queue that are for the
> >          * peeled off association to the new socket's receive queue.
> >          */
> >         sctp_skb_for_each(skb, &oldsk->sk_receive_queue, tmp) {
> >                 event = sctp_skb2event(skb);
> > ...
> >                 /* Walk through the pd_lobby, looking for skbs that
> >                  * need moved to the new socket.
> >                  */
> >                 sctp_skb_for_each(skb, &oldsp->pd_lobby, tmp) {
> >                         event = sctp_skb2event(skb);
> >
> > That said, I don't think it's worth this new list.
> 
> About this case:
> datamsg
>                    ->chunk0                       chunk1
>        chunk2
>  queue          ->transmitted                 ->retransmit
>  ->not in any queue

We always can find it through the other chunks, otherwise it's freed.

> 
> Also need to maintain a datamsg list to record which datamsg is
> processed avoiding repetitive
> processing.

Right, but for that we can add a simple check on
sctp_for_each_tx_datamsg() based on a parameter.

> So, list it to outq. Maybe it will be used sometime.

We can change it when the time comes. For now, if we can avoid growing
sctp_datamsg, it's better. With this patch, it grows from 40 to 56
bytes, leaving just 8 left before it starts using a slab of 128 bytes
for it.


The patched list_for_each_entry() can/should be factored out into
__sctp_for_each_tx_datachunk, whose first parameter then is the queue
instead the asoc.

---8<---

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index fed26a1e9518..62f401799709 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -148,19 +148,30 @@ static void sctp_clear_owner_w(struct sctp_chunk *chunk)
 }
 
 static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
+				       bool clear,
 				       void (*cb)(struct sctp_chunk *))
 
 {
+	struct sctp_datamsg *msg, *prev_msg = NULL;
 	struct sctp_outq *q = &asoc->outqueue;
+	struct sctp_chunk *chunk, *c;
 	struct sctp_transport *t;
-	struct sctp_chunk *chunk;
 
 	list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
 		list_for_each_entry(chunk, &t->transmitted, transmitted_list)
 			cb(chunk);
 
-	list_for_each_entry(chunk, &q->retransmit, transmitted_list)
-		cb(chunk);
+	list_for_each_entry(chunk, &q->sacked, transmitted_list) {
+		msg = chunk->msg;
+		if (msg == prev_msg)
+			continue;
+		list_for_each_entry(c, &msg->chunks, frag_list) {
+			if ((clear && asoc->base.sk == c->skb->sk) ||
+			    (!clear && asoc->base.sk != c->skb->sk))
+				cb(c);
+		}
+		prev_msg = msg;
+	}
 
 	list_for_each_entry(chunk, &q->sacked, transmitted_list)
 		cb(chunk);
@@ -9574,9 +9585,9 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	 * paths won't try to lock it and then oldsk.
 	 */
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
-	sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
+	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
+	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.
