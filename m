Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D43E18DD04
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 02:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgCUBCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 21:02:51 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45047 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgCUBCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 21:02:51 -0400
Received: by mail-qt1-f193.google.com with SMTP id y24so6717992qtv.11;
        Fri, 20 Mar 2020 18:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SP3el1IeHgtMqeYCx0AVkkm40OqwUzAvF5os8GiwOs4=;
        b=FbpWCcpd9LHTnS+akC3+GX290aj4hoKE1FHNJTLvRfGWp2aAO4zV3soqt/F1TyWbG+
         d0w14Z6LJbIOPFEseKssJXRbbXYpxsHVU7Jtu7P7C89hJRKjT7JGvDPbmS7XY2ZX9B2t
         qGjSGjQ2py8tLMTGl8rkbbbIxZTl2kVAXtKFoWhu0tlVfj6J7jHrzuLyuxgSXzDMO7/J
         1h4nMWJ64vlB/BuDLAXjtG1sELPDefhYwQ4Gyvt+9ZFPpQrrwAKQy1vLDDdm822U9XkY
         yAG/6t1f6iD9ytDrgjJHfwBfnN90LJV+SxKIV3bCv1iKtzbuJ6lW/ZmYHbtVm9Kptfgv
         1NjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SP3el1IeHgtMqeYCx0AVkkm40OqwUzAvF5os8GiwOs4=;
        b=YXGpAnaNbNrehZEEavJbrHDHkUGuODkVzRGIDwgRpgFeok0UIv1VOJ1f5zVRnDALcs
         M0uLmdzwxKp5uiAsAwwNsAS7a5bW0kJacyveKvdcuBfiKoolu4N8BIdWfJoRLIsQN2Z1
         NnlSijQ5yGczAvXkp0xDr/us3/27Sb1pZ4UTdonBp5GmXz4NttLITJE43R2msp9YCs+9
         pOPxeXWcqV8k3XxbcIlYw4apB2m7Sc+R9PwCzSQYtiRBexjibzajQX+2THGViStB5miz
         Xq0ga/+iWBFLk6B+9AwZrZwygZyGiZ74w2AYB4MAtuY0YWSlXTkVChnsyOO6DFP6ksFr
         5KBw==
X-Gm-Message-State: ANhLgQ0kOD9v9F/m+94Z77gC6D5bSA4pA+a5TYLkolzmuooe7AqlZuX+
        VfW47ppVb47DJiwnqIA4cCQ=
X-Google-Smtp-Source: ADFU+vvUa38Dl8xOfFFceaFo9zzCvGfi2g+6hz8m955ErR/mjUAKA+BmWKI6y9S3WU2IgFOxPY7WaQ==
X-Received: by 2002:ac8:5653:: with SMTP id 19mr11114357qtt.385.1584752570069;
        Fri, 20 Mar 2020 18:02:50 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f028:3cb2:8072:4dfa:fd1:eb22])
        by smtp.gmail.com with ESMTPSA id 85sm3986672qke.128.2020.03.20.18.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 18:02:48 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7F110C3145; Fri, 20 Mar 2020 22:02:46 -0300 (-03)
Date:   Fri, 20 Mar 2020 22:02:46 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>,
        linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com
Subject: Re: [PATCH v3] sctp: fix refcount bug in sctp_wfree
Message-ID: <20200321010246.GC3828@localhost.localdomain>
References: <20200320110959.2114-1-hqjagain@gmail.com>
 <20200320185204.GB3828@localhost.localdomain>
 <CAJRQjoc-U_K-2THbmBOj2TOWDTfP9yr5Vec-WjhTjS8sj19fHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJRQjoc-U_K-2THbmBOj2TOWDTfP9yr5Vec-WjhTjS8sj19fHA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 07:53:29AM +0800, Qiujun Huang wrote:
...
> > > So, sctp_wfree was not called to destroy SKB)
> > >
> > > then migrate happened
> > >
> > >       sctp_for_each_tx_datachunk(
> > >       sctp_clear_owner_w);
> > >       sctp_assoc_migrate();
> > >       sctp_for_each_tx_datachunk(
> > >       sctp_set_owner_w);
> > > SKB was not in the outq, and was not changed to newsk
> >
> > The real fix is to fix the migration to the new socket, though the
> > situation on which it is happening is still not clear.
> >
> > The 2nd sendto() call on the reproducer is sending 212992 bytes on a
> > single call. That's usually the whole sndbuf size, and will cause
> > fragmentation to happen. That means the datamsg will contain several
> > skbs. But still, the sacked chunks should be freed if needed while the
> > remaining ones will be left on the queues that they are.
> 
> in sctp_sendmsg_to_asoc
> datamsg holds his chunk result in that the sacked chunks can't be freed

Right! Now I see it, thanks.
In the end, it's not a locking race condition. It's just not iterating
on the lists properly.

> 
> list_for_each_entry(chunk, &datamsg->chunks, frag_list) {
> sctp_chunk_hold(chunk);
> sctp_set_owner_w(chunk);
> chunk->transport = transport;
> }
> 
> any ideas to handle it?

sctp_for_each_tx_datachunk() needs to be aware of this situation.
Instead of iterating directly/only over the chunk list, it should
iterate over the datamsgs instead. Something like the below (just
compile tested).

Then, the old socket will be free to die regardless of the new one.
Otherwise, if this association gets stuck on retransmissions or so,
the old socket would not be freed till then.

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index fed26a1e9518..85c742310d26 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -151,9 +151,10 @@ static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
 				       void (*cb)(struct sctp_chunk *))
 
 {
+	struct sctp_datamsg *msg, *prev_msg = NULL;
 	struct sctp_outq *q = &asoc->outqueue;
 	struct sctp_transport *t;
-	struct sctp_chunk *chunk;
+	struct sctp_chunk *chunk, *c;
 
 	list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
 		list_for_each_entry(chunk, &t->transmitted, transmitted_list)
@@ -162,8 +163,14 @@ static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
 	list_for_each_entry(chunk, &q->retransmit, transmitted_list)
 		cb(chunk);
 
-	list_for_each_entry(chunk, &q->sacked, transmitted_list)
-		cb(chunk);
+	list_for_each_entry(chunk, &q->sacked, transmitted_list) {
+		msg = chunk->msg;
+		if (msg == prev_msg)
+			continue;
+		list_for_each_entry(c, &msg->chunks, frag_list)
+			cb(c);
+		prev_msg = msg;
+	}
 
 	list_for_each_entry(chunk, &q->abandoned, transmitted_list)
 		cb(chunk);
