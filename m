Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11135187869
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 05:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgCQEP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 00:15:28 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44757 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgCQEP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 00:15:28 -0400
Received: by mail-qt1-f195.google.com with SMTP id h16so16344275qtr.11;
        Mon, 16 Mar 2020 21:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IhXlDi82nUfMSc8e72005vtadO4JnqaaXnMY/4/wVw0=;
        b=vFyhO8Y46Ka6tj6OPYqz2u/yoJENKGhfPDofXDT3BwgCwhkcnYy6xyQUCSKfo0rNt7
         fyG9goJqaWVjyiyJfEmx98rcI5506K8GrOM0GYCvrHLlrFhqU25pFuV0p2tMI7nngdbK
         G+PcDffWgZp+Dey1XLP/DLbhTsO5/tQ9VF1GkWu1w3ZUIFQxO9pjYB7THSLCZSNCOcZd
         v6qbemNbJeVy6J65ZPmDMaqIfoRthdNIEvbnDHLJMi9X074oJfLsGsLATangVlT5+q7w
         Nw5Z8YEtTL8UWwJyD8gPXp21dnWlNBeKBrFVL+AZfmJTihTsbi9yzr//9EekrKTyVjVv
         awew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IhXlDi82nUfMSc8e72005vtadO4JnqaaXnMY/4/wVw0=;
        b=ajuVzABDRFPY+NZJ0C8gwNbeCp8c/5IEMxDSf51/IghypvijKj80gkflcJChFEt4B1
         9TJTO8muCqAJjAIiuTrawHNE81S6c3ZtWnrvUDMljmdmdQ05Rhu2tvfKGfj9nBppyulA
         QLdwO/SO8X33/PbdiRpJ+xJw9nthXA4CGNODHKk9fzkWr2xuB6bz+WQVXv/xYdjYIigX
         Shi4Vbnrbd3kz2CvqJiECWUnhGLTmBmi7yQPxr9oQYAiZw9/Tw91RaTsXWhAwib8croI
         Ye8IYYJJiKtFuWTkEYO6V0SNeKHsmKpeEa8f+jtx7FgxQOsSDbPDMqFQa1wFaLgXNwjC
         k1hQ==
X-Gm-Message-State: ANhLgQ1wumZSkuKX3qjOY6aDZODiTkn1/YwmmUBWV9g3kllC1OVVMp9O
        1IkdPjRzZjPjPf8bOnTFCL6K7PH+rVE=
X-Google-Smtp-Source: ADFU+vvVgMpIG6QYKg5/ky/0cONGRz7T1tO3m+dp2QEFcZZGojIQqaIIx/CZMAQKy0AxCUeKPKbwSw==
X-Received: by 2002:ac8:683:: with SMTP id f3mr3415297qth.356.1584418526889;
        Mon, 16 Mar 2020 21:15:26 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:bfaf:5636:cd03:74f7:34b0])
        by smtp.gmail.com with ESMTPSA id c12sm1459511qtb.49.2020.03.16.21.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 21:15:26 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C2589C0DA9; Tue, 17 Mar 2020 01:15:23 -0300 (-03)
Date:   Tue, 17 Mar 2020 01:15:23 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: fix refcount bug in sctp_wfree
Message-ID: <20200317041523.GB3756@localhost.localdomain>
References: <1584330804-18477-1-git-send-email-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584330804-18477-1-git-send-email-hqjagain@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 11:53:24AM +0800, Qiujun Huang wrote:
> Do accounting for skb's real sk.
> In some case skb->sk != asoc->base.sk.

This is a too simple description.  Please elaborate how this can
happen in sctp_wfree. Especially considering the construct for
migrating the tx queue on sctp_sock_migrate(), as both sockets are
locked while moving the chunks around and the asoc itself is only
moved in between decrementing and incrementing the refcount:

        lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
        sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
        sctp_assoc_migrate(assoc, newsk);
        sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
	...

> 
> Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com

I can't see a positive test result, though. If I didn't loose any
email, your last test with a patch similar to this one actually
failed.
I'm talking about syzbot test result at Message-ID: <000000000000e7736205a0e041f5@google.com>

> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> ---
>  net/sctp/socket.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 1b56fc4..5f5c28b 100644
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
> 1.8.3.1
> 
