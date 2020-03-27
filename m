Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF01194F1D
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgC0Cfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:35:40 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:44414 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbgC0Cfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:35:39 -0400
Received: by mail-qv1-f65.google.com with SMTP id ef12so2181419qvb.11;
        Thu, 26 Mar 2020 19:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G7Sr1gwaHsCrajdueVmnHwr6RalDOGPbbpo1vRReyaA=;
        b=jvd0KqydU/86zFkzJPupX1YgNwI4hF0SBGrHftrDKBVzZ+qVPUdyUuYZfeYlYaRsUC
         JXy3yJJ10kED8Z0zdlLGCt2tLY3DNEzHfg0CfH7alZRzKU7xf6E8Iutcb1kAWAC4Ueuv
         7koooStyMq2diJfAAqjUfyOtfor4CYXnPlNaqTSEHjh3DL5B5/lXwV7hyI7Sxbwxpx7p
         6ZM2rQmbeYVAw1R8hPN927SmLR8JwR+PQKRLf0X+zkVYBgqJgEm7CkBIWoIs3Qa8WFfT
         LdJj2uofomcHmZ1uCZBWHUgj0cbtXuoM2Y6GmTE+fVZzj7F/o66KcRQGEZpuLaVx3eA5
         W/Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G7Sr1gwaHsCrajdueVmnHwr6RalDOGPbbpo1vRReyaA=;
        b=IkuUIfoVT+sOK5YXw+S0YVKEItbqWBCbVoGKrOjYmYfH1TgK85i8nvXFipMrX9MO/W
         sPikYr43i6k0ctGJ7aWa4kKnLlBG/ScAt2uOcanHDwCdWIMqcDxlaW8FOiCvLy+WdnH8
         7+7LDM+8uPzU5UFJovZOV9lgaWonmU7s567Tx+hoCMVBM/qJzXUo9NzEm6SzY3vPnnwN
         vkYOAIJzUmKQeufP79CSisyMxj4Zjrgdmcjnxm5AQcAzrfgobyiZ2ar8L+tQdzpzL5yV
         eDvWAcpwlXCX/TUePLdNeTgPpcj2Tlbbb7z63ruc5hDm39KNU23FgvX4CTIOLZlA+a6l
         TWMQ==
X-Gm-Message-State: ANhLgQ1CMCZnkw9J6uQscXx3+A7jJn2Dl5HpmfblFLr6jHn3GOZ2WNvz
        3jldijZ2uULer0RJCZ8Hrrs=
X-Google-Smtp-Source: ADFU+vs7EV9uTCvAkNK26DL+gWyTtgaS+Rf3pcu5RVTa0t12aI3gb6LR7rxJJao95kY4E/Q2kTIzXQ==
X-Received: by 2002:a0c:a8e9:: with SMTP id h41mr11909678qvc.235.1585276538114;
        Thu, 26 Mar 2020 19:35:38 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.248])
        by smtp.gmail.com with ESMTPSA id l13sm2843115qtu.66.2020.03.26.19.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 19:35:37 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id CC91CC5CE4; Thu, 26 Mar 2020 23:35:34 -0300 (-03)
Date:   Thu, 26 Mar 2020 23:35:34 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com,
        kuba@kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com
Subject: Re: [PATCH v5 RESEND] sctp: fix refcount bug in sctp_wfree
Message-ID: <20200327023534.GJ3756@localhost.localdomain>
References: <20200327012832.19193-1-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327012832.19193-1-hqjagain@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 09:28:32AM +0800, Qiujun Huang wrote:
> We should iterate over the datamsgs to modify

Just two small things now.
s/modify/move/  , it's more accurate.
But mainly because...

...
> 
> Reported-and-tested-by:syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com

checkpatch.pl is warning that there should be an empty space after the
':' here.

Otherwise, looks very good.

Btw, I learned a lot about syzbot new features with your tests, thanks :-)

> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> ---
>  net/sctp/socket.c | 31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 1b56fc440606..f68076713162 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -147,29 +147,44 @@ static void sctp_clear_owner_w(struct sctp_chunk *chunk)
>  	skb_orphan(chunk->skb);
>  }
>  
> +#define traverse_and_process()	\
> +do {				\
> +	msg = chunk->msg;	\
> +	if (msg == prev_msg)	\
> +		continue;	\
> +	list_for_each_entry(c, &msg->chunks, frag_list) {	\
> +		if ((clear && asoc->base.sk == c->skb->sk) ||	\
> +		    (!clear && asoc->base.sk != c->skb->sk))	\
> +		    cb(c);	\
> +	}			\
> +	prev_msg = msg;		\
> +} while (0)
> +
>  static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
> +				       bool clear,
>  				       void (*cb)(struct sctp_chunk *))
>  
>  {
> +	struct sctp_datamsg *msg, *prev_msg = NULL;
>  	struct sctp_outq *q = &asoc->outqueue;
> +	struct sctp_chunk *chunk, *c;
>  	struct sctp_transport *t;
> -	struct sctp_chunk *chunk;
>  
>  	list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
>  		list_for_each_entry(chunk, &t->transmitted, transmitted_list)
> -			cb(chunk);
> +			traverse_and_process();
>  
>  	list_for_each_entry(chunk, &q->retransmit, transmitted_list)
> -		cb(chunk);
> +		traverse_and_process();
>  
>  	list_for_each_entry(chunk, &q->sacked, transmitted_list)
> -		cb(chunk);
> +		traverse_and_process();
>  
>  	list_for_each_entry(chunk, &q->abandoned, transmitted_list)
> -		cb(chunk);
> +		traverse_and_process();
>  
>  	list_for_each_entry(chunk, &q->out_chunk_list, list)
> -		cb(chunk);
> +		traverse_and_process();
>  }
>  
>  static void sctp_for_each_rx_skb(struct sctp_association *asoc, struct sock *sk,
> @@ -9574,9 +9589,9 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
>  	 * paths won't try to lock it and then oldsk.
>  	 */
>  	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
> -	sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
> +	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
>  	sctp_assoc_migrate(assoc, newsk);
> -	sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
> +	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
>  
>  	/* If the association on the newsk is already closed before accept()
>  	 * is called, set RCV_SHUTDOWN flag.
> -- 
> 2.17.1
> 
