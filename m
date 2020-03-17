Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5ED188C24
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgCQRaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:30:46 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:39442 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgCQRaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:30:46 -0400
Received: by mail-qv1-f68.google.com with SMTP id v38so7281530qvf.6;
        Tue, 17 Mar 2020 10:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uMZI9G+vOGyFJSyjy5BLGE+SbevgQEUuqjy8SQ3+oEs=;
        b=bWh2drfzNsrrjWxTp0zb6MrVMeXTLND0nB3Z8X/MPrWKZC6ZJWYOvgc6bps+int15o
         +rY8bKArNwjzuLFeyrx2ILFrr7pOnSPSR16JqcNyQg6bWQAbyCAenxmW58/7dFikmCLY
         a1RCBsCrlO6LYmgRClI8BfYIWzrFKgS4k2QCcMVXVRyEbEPVFY2C/BO8JmHCtY5xM8HT
         +65qwSnPt5fUOHF6oYUkjryI4HeqIbY9mMxn7PkqifgY8FzMcy/5MjFT3pyAfeKPRxSW
         NU/X9g8sjTTrxBCuWC+iTaiKwlQYAqNwWxhfMKR4Looj5rrs7sT0sqy3xubCe+KcSVLK
         gneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uMZI9G+vOGyFJSyjy5BLGE+SbevgQEUuqjy8SQ3+oEs=;
        b=VMWWmZaLCz6dZPgnP5g/vFjgSzG83PDULC7ERAUhyG69I0StDgIPV1K1Q6QUzAa9h5
         LYZ+6hU1kFgnu28yOOnJsVu5BIzJqrr1gVsnbqQxWxClZqQ1CH8k07O002ZOY8AIJYKS
         ju3PpbFoSecM4i89Via/Lj9pHInpvZHvuYuCSgANd7UudJRLnUA6JYKbMam45gUFjyBm
         wOolumsOFCtciy9Um9TYpubc8wzSO32ww9HW4ehijst6gFs7E3y3EbfC/yNjPgxazP3K
         cH8C+7JRjFcO5dasLdh6WqIA6+7p7sn2YiS3cpLAgbcYgYBl6rbsj7yOjVrePfs1gkDt
         NX5A==
X-Gm-Message-State: ANhLgQ3hWk7ygPFrK0D64USGvTOrBPUKCCOPUZyzP7OS3PoNcMPmPyYM
        xq91M6w6oHMUn+tIiPhn2Nw=
X-Google-Smtp-Source: ADFU+vsxfQXEWzA4tzIws3q/lri+BobagJ+smPhVzlUG+fAuPQFgpcO4I42vwikyOCMQj8SCBopeng==
X-Received: by 2002:ad4:51c3:: with SMTP id p3mr210903qvq.97.1584466242913;
        Tue, 17 Mar 2020 10:30:42 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:bfaf:5636:cd03:74f7:34b0])
        by smtp.gmail.com with ESMTPSA id c12sm2808948qtb.49.2020.03.17.10.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 10:30:42 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C39FBC54E2; Tue, 17 Mar 2020 14:30:39 -0300 (-03)
Date:   Tue, 17 Mar 2020 14:30:39 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com,
        kuba@kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com
Subject: Re: [PATCH v2] sctp: fix refcount bug in sctp_wfree
Message-ID: <20200317173039.GA3828@localhost.localdomain>
References: <20200317155536.10227-1-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317155536.10227-1-hqjagain@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Mar 17, 2020 at 11:55:36PM +0800, Qiujun Huang wrote:
> Do accounting for skb's real sk.
> In some case skb->sk != asoc->base.sk:
> 
> migrate routing        sctp_check_transmitted routing
> ------------                    ---------------
                                 sctp_close();
				   lock_sock(sk2);
				 sctp_primitive_ABORT();
                                 sctp_do_sm();
                                 sctp_cmd_interpreter();
                                 sctp_cmd_process_sack();
                                 sctp_outq_sack();
				 sctp_check_transmitted();

  lock_sock(sk1);
  sctp_getsockopt_peeloff();
  sctp_do_peeloff();
  sctp_sock_migrate();
> lock_sock_nested(sk2);
>                                mv the transmitted skb to
>                                the it's local tlist


How can sctp_do_sm() be called in the 2nd column so that it bypasses
the locks in the left column, allowing this mv to happen?

> 
> sctp_for_each_tx_datachunk(
> sctp_clear_owner_w);
> sctp_assoc_migrate();
> sctp_for_each_tx_datachunk(
> sctp_set_owner_w);
> 
>                                put the skb back to the
>                                assoc lists
> ----------------------------------------------------
> 
> The skbs which held bysctp_check_transmitted were not changed
> to newsk. They were not dealt with by sctp_for_each_tx_datachunk
> (sctp_clear_owner_w/sctp_set_owner_w).

It would make sense but I'm missing one step earlier, I'm not seeing
how the move to local list is allowed/possible in there. It really
shouldn't be possible.

> 
> It looks only trouble here so handling it in sctp_wfree is enough.
> 
> Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> ---
>  net/sctp/socket.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 1b56fc440606..5f5c28b30e25 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -9080,7 +9080,7 @@ static void sctp_wfree(struct sk_buff *skb)
>  {
>  	struct sctp_chunk *chunk = skb_shinfo(skb)->destructor_arg;
>  	struct sctp_association *asoc = chunk->asoc;
> -	struct sock *sk = asoc->base.sk;
> +	struct sock *sk = skb->sk;
>  
>  	sk_mem_uncharge(sk, skb->truesize);
>  	sk->sk_wmem_queued -= skb->truesize + sizeof(struct sctp_chunk);
> @@ -9109,7 +9109,7 @@ static void sctp_wfree(struct sk_buff *skb)
>  	}
>  
>  	sock_wfree(skb);
> -	sctp_wake_up_waiters(sk, asoc);
> +	sctp_wake_up_waiters(asoc->base.sk, asoc);
>  
>  	sctp_association_put(asoc);
>  }
> -- 
> 2.17.1
> 
