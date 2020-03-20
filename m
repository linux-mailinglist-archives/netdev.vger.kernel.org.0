Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B28718D7E5
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 19:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgCTSwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 14:52:16 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37433 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbgCTSwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 14:52:09 -0400
Received: by mail-qk1-f194.google.com with SMTP id z25so8025206qkj.4;
        Fri, 20 Mar 2020 11:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=otmorsE/p9yVYit1B4E2Fo3uYEvHK3kalR11YV3EIR0=;
        b=KDqmFhl7PlI8cqrekS70TdybR/cBo9bP1dcWoWHQ2D9mhZ8kwfyn6ttKk957+cOoBp
         7Mb9VnBPd8r2lNyo37LwcRn4wd4X3DtoQPvSjFpk6Y63JYUSeMNjK4lw38Y5myCjIX24
         nm4WbmO6/QBul+eoG126Wn4OQ2Y0yoRxKkqbJ9ubkgOUWMIiOpUFhEYPoR7ncb68T4nc
         hGQiactjc5+lbTman+80F2+ws32ZzEUIjMKvRtthtDy8a4T5TLUpvScUOfEbk1uGVudb
         j6FL+Gue3npK4+uGbJa4fja/dCmx2IS9k4R16aIycx1OcMliHlhG13Jg4DCYuiL5t6hQ
         ikDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=otmorsE/p9yVYit1B4E2Fo3uYEvHK3kalR11YV3EIR0=;
        b=d91MX2vFYmlDILZFOeEp7J8DNSioG2fS/YaHZAGvlBfNLIS7OfWTkhjoKgxrg88roF
         KPIWblwewMYivvBhzKihVOtdO73kB6hFGaQTUmLsiwKICy6J7sP5V2DHahV3Ng6GnEug
         QfZEJ+ANS6BUN5pgGPrR+wirVbRoN+SJO79ZpjE7X6JYXOP97rLcswUkjP3I3aNjB8DK
         rO8Z2bS7iGOFIiv8ChTJsfu9I4FrWeVTPsm/h79sTRZlxfG6gOa4QxI7aZGWjcvidc2O
         niIsgxi9tKc/HBnjp1dGJQxtJSkCr/n0RQb+fJfmt1j2oLiZirL2wNOEC31n8dXhmvib
         ab7g==
X-Gm-Message-State: ANhLgQ0bV4S7gBL0K5tEFhLNXevBFYK8vGyLDXxymbZiRMm4z2X4ATxo
        JXTEgYeXu52s7Tok4EJzSeE=
X-Google-Smtp-Source: ADFU+vsLaMKBQfa91QrFcTCCfGbvag6eFOwipkI3VTsOJqJuGAXiB38uA1I4ak8puiSO6rGub8/nhA==
X-Received: by 2002:a37:61d0:: with SMTP id v199mr9310307qkb.292.1584730328304;
        Fri, 20 Mar 2020 11:52:08 -0700 (PDT)
Received: from localhost.localdomain ([177.220.176.176])
        by smtp.gmail.com with ESMTPSA id f16sm5543535qtk.61.2020.03.20.11.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 11:52:07 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 035FAC215F; Fri, 20 Mar 2020 15:52:04 -0300 (-03)
Date:   Fri, 20 Mar 2020 15:52:04 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com,
        kuba@kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com
Subject: Re: [PATCH v3] sctp: fix refcount bug in sctp_wfree
Message-ID: <20200320185204.GB3828@localhost.localdomain>
References: <20200320110959.2114-1-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320110959.2114-1-hqjagain@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 07:09:59PM +0800, Qiujun Huang wrote:
> Do accounting for skb's real sk.
> In some case skb->sk != asoc->base.sk:
> 
> for the trouble SKB, it was in outq->transmitted queue
> 
> sctp_outq_sack
> 	sctp_check_transmitted
> 		SKB was moved to outq->sack

There is no outq->sack. You mean outq->sacked, I assume.

> 	then throw away the sack queue

Where? How?
If you mean:
        /* Throw away stuff rotting on the sack queue.  */
        list_for_each_safe(lchunk, temp, &q->sacked) {
                tchunk = list_entry(lchunk, struct sctp_chunk,
                                    transmitted_list);
                tsn = ntohl(tchunk->subh.data_hdr->tsn);
                if (TSN_lte(tsn, ctsn)) {
                        list_del_init(&tchunk->transmitted_list);
                        if (asoc->peer.prsctp_capable &&
                            SCTP_PR_PRIO_ENABLED(chunk->sinfo.sinfo_flags))
                                asoc->sent_cnt_removable--;
                        sctp_chunk_free(tchunk);

Then sctp_chunk_free is supposed to free the datamsg as well for
chunks that were cumulative-sacked.
For those not cumulative-sacked, sctp_for_each_tx_datachunk() will
handle q->sacked queue as well:
        list_for_each_entry(chunk, &q->sacked, transmitted_list)
                cb(chunk);

So I don't see how skbs can be overlooked here.

> 		SKB was deleted from outq->sack
> (but the datamsg held SKB at sctp_datamsg_to_asoc

You mean sctp_datamsg_from_user ? If so, isn't it the other way
around? sctp_datamsg_assign() will hold the datamsg, not the skb.

> So, sctp_wfree was not called to destroy SKB)
> 
> then migrate happened
> 
> 	sctp_for_each_tx_datachunk(
> 	sctp_clear_owner_w);
> 	sctp_assoc_migrate();
> 	sctp_for_each_tx_datachunk(
> 	sctp_set_owner_w);
> SKB was not in the outq, and was not changed to newsk

The real fix is to fix the migration to the new socket, though the
situation on which it is happening is still not clear.

The 2nd sendto() call on the reproducer is sending 212992 bytes on a
single call. That's usually the whole sndbuf size, and will cause
fragmentation to happen. That means the datamsg will contain several
skbs. But still, the sacked chunks should be freed if needed while the
remaining ones will be left on the queues that they are.

Thanks,
Marcelo
