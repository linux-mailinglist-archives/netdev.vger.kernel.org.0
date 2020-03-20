Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E7D18DC34
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 00:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgCTXsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 19:48:31 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33582 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgCTXsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 19:48:30 -0400
Received: by mail-io1-f68.google.com with SMTP id o127so7950888iof.0;
        Fri, 20 Mar 2020 16:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=URvaWyYWBa0ayTSuI6CuJhuWpQmYDLzB0f4F17e6SGY=;
        b=QdFHTAxlp5ub6AxMCvW0vdF3zo4oy+YbBUy0p7HoV8X9s/qS9pfEmP5LO8mD3dT2tK
         dMR7+fK+ZXNR8rD6EfERXVdmG3Y26g051UojL8FON/EalPaOgraMFKg2zl1CNLN1OqZ+
         LQMT+Jm7aY2R48IrUvbEWEPzPKnF7kpxphl6NQTLWIcxartjcMw+JzD+DkbUYey2FyoY
         R0e6dFxaqaSveThhXVvEt0+qD91yWySiun9XgVhLZkPcHvZ4mb93VRIM46YhWGI+mJmG
         ZoZmoiocGmVwe6Qdbb7eJ22QjD045Zfg7PHhRHtLaSaHq8r2ZXN08pl99uVdtN78Coka
         XwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=URvaWyYWBa0ayTSuI6CuJhuWpQmYDLzB0f4F17e6SGY=;
        b=JzqF36lW5fxodz3qHBNunnFsBZVoP6CNwLD0ECzycBfqnnl2sNi7a+cbYpIQG7429z
         3TGbLVIQVUxTupn1+IjBUIA09QViqzBiiOgVU5sdGGBCRQ8tomCw7ZZ8PrxhssXyqTYB
         XslZ/YlFrNR5k7pl8cS0Bs6HiAPtQi7T6k5iV5TocC5Qi5GwKzCpMLZTz2wWe6k+3TDv
         QsJjphZ0goblTr8FcSO/gh93KPm7ad6eaguPtz6Ns5y1nChSwgE/KAlktmwwrUT1ReiY
         iOcU6YQPQx6E1AgI/wPgl1m8kTsU+vD9IBfj9+AWQt1qSPRKvKNhhxoBOQh+XoU7uedQ
         88Sg==
X-Gm-Message-State: ANhLgQ2euCJhd9MDyZgLa2mkopO3KwfeezSeMf0K1G909rAbtHT7C2oi
        3Mg/nhsgg3nn8pskccZLmoRHwylfXPEdYeCQFFo=
X-Google-Smtp-Source: ADFU+vvGaiBuyqe+aGFYuLaKmr5DieVsKbqaD4HuUFc/H07YS2gEMTr+9jjbbJd7rLp9eHOu24QRrl5tTVEv1ALQWUQ=
X-Received: by 2002:a02:9288:: with SMTP id b8mr10709077jah.59.1584748110039;
 Fri, 20 Mar 2020 16:48:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200320110959.2114-1-hqjagain@gmail.com> <20200320185204.GB3828@localhost.localdomain>
In-Reply-To: <20200320185204.GB3828@localhost.localdomain>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Sat, 21 Mar 2020 07:48:18 +0800
Message-ID: <CAJRQjocyUUYDXR5G5sNmbWzG1=PsJ1iGyN=e7Kkpa1DcXG+KWQ@mail.gmail.com>
Subject: Re: [PATCH v3] sctp: fix refcount bug in sctp_wfree
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>,
        linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 2:52 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Fri, Mar 20, 2020 at 07:09:59PM +0800, Qiujun Huang wrote:
> > Do accounting for skb's real sk.
> > In some case skb->sk != asoc->base.sk:
> >
> > for the trouble SKB, it was in outq->transmitted queue
> >
> > sctp_outq_sack
> >       sctp_check_transmitted
> >               SKB was moved to outq->sack
>
> There is no outq->sack. You mean outq->sacked, I assume.

Yes, my typo.

>
> >       then throw away the sack queue
>
> Where? How?
> If you mean:
>         /* Throw away stuff rotting on the sack queue.  */
>         list_for_each_safe(lchunk, temp, &q->sacked) {
>                 tchunk = list_entry(lchunk, struct sctp_chunk,
>                                     transmitted_list);
>                 tsn = ntohl(tchunk->subh.data_hdr->tsn);
>                 if (TSN_lte(tsn, ctsn)) {
>                         list_del_init(&tchunk->transmitted_list);
>                         if (asoc->peer.prsctp_capable &&
>                             SCTP_PR_PRIO_ENABLED(chunk->sinfo.sinfo_flags))
>                                 asoc->sent_cnt_removable--;
>                         sctp_chunk_free(tchunk);

Yes, it was delected here.

>
> Then sctp_chunk_free is supposed to free the datamsg as well for
> chunks that were cumulative-sacked.

Datamsg should be freed until all his chunks had been freed.

sctp_datamsg_from_user->sctp_datamsg_assign
every chunks holds datamsg.

> For those not cumulative-sacked, sctp_for_each_tx_datachunk() will
> handle q->sacked queue as well:
>         list_for_each_entry(chunk, &q->sacked, transmitted_list)
>                 cb(chunk);
>
> So I don't see how skbs can be overlooked here.
>
> >               SKB was deleted from outq->sack
> > (but the datamsg held SKB at sctp_datamsg_to_asoc
>
> You mean sctp_datamsg_from_user ? If so, isn't it the other way
> around? sctp_datamsg_assign() will hold the datamsg, not the skb.
yeah.

>
> > So, sctp_wfree was not called to destroy SKB)
> >
> > then migrate happened
> >
> >       sctp_for_each_tx_datachunk(
> >       sctp_clear_owner_w);
> >       sctp_assoc_migrate();
> >       sctp_for_each_tx_datachunk(
> >       sctp_set_owner_w);
> > SKB was not in the outq, and was not changed to newsk
>
> The real fix is to fix the migration to the new socket, though the
> situation on which it is happening is still not clear.
>
> The 2nd sendto() call on the reproducer is sending 212992 bytes on a
> single call. That's usually the whole sndbuf size, and will cause
> fragmentation to happen. That means the datamsg will contain several
> skbs. But still, the sacked chunks should be freed if needed while the
> remaining ones will be left on the queues that they are.
>
> Thanks,
> Marcelo
