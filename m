Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7355818D566
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 18:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgCTRKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 13:10:43 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45231 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCTRKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 13:10:43 -0400
Received: by mail-pl1-f193.google.com with SMTP id b9so2756497pls.12;
        Fri, 20 Mar 2020 10:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dmTAKZsOrskmdb08IB/kIN4Tko0TXFx78YTHcn9sjHs=;
        b=tLZcOTSHbzPVCR3AG2+mAifql+769ivSpTQTBMlh6th2LdR+oAOc2/weE2HUc2wJiu
         /r8N7P0HiDRWNtBMsLHKr6OYdQkFasbGJSQ0ZXp5zCC3Zf1/Bxe7HYGptq8Il9SIjFV3
         RMEjUG5gdrlSW3hSwDoQBnNR2zHagqh9dLK1jHTDh81Pj7oEnJWFc6ysp5ilChxOUBsA
         PlY++RGN6Z/2MGNL+ysUz3vwRNlZ3E5QBslLhy15fBOEVIOKj6ijuiufe8tQ6A6SlVYm
         aJj/8WVGlcUJh6PNfCh5dR3QwtO5oWaVHpc1L5OQ1ODMNPLjMkiYsnlbt/yYhwLmG2kE
         r9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dmTAKZsOrskmdb08IB/kIN4Tko0TXFx78YTHcn9sjHs=;
        b=XEcUN3WExNBcZOUOn37lvd2YJZFBHedbFaRx9gMtdsc+9U4wYM6qLepTCPzjLe4vsB
         K8rEpk3Yz1ZZB7+qu1+7/VulehYd0th3MeEv/xQXb0oivrEfZ56L8k8QXFpWGuUOvZx1
         RnYaXPhxTQjeRTgZtCuhwNR3pEoVYl7MI+MrV1WSjKuNGTYSVUp/f4ObKo1DzxozUyG+
         ut5PRafjFBw8Cmt/MI4Z8qt3oORv8h4UMqFBHXIQyv3Oj4FeqCAMWX9GbEppgy3MvjwJ
         8ERvZLpsLRoY5gqMv5prWq6JKiHKGMog+fc5DONheXWthzThp2D5KXeGMSNUzU8ayj4+
         ysTg==
X-Gm-Message-State: ANhLgQ3RA+eDblyyrMnjisewHbsUsHKE4Kkij/M2mwU1O7elt+o5cE4O
        nu2VhiZLiNq10sIshY3ANk0=
X-Google-Smtp-Source: ADFU+vsbvo0qKpR9+HJnBvXdM8IOc+aDirksacAjmHUPAv08xhQvyOjS8M/zVurVzDlnE+1JD2j6GA==
X-Received: by 2002:a17:902:728d:: with SMTP id d13mr9528398pll.92.1584724241817;
        Fri, 20 Mar 2020 10:10:41 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id j4sm5998656pfg.133.2020.03.20.10.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 10:10:40 -0700 (PDT)
Subject: Re: [PATCH v3] sctp: fix refcount bug in sctp_wfree
To:     Qiujun Huang <hqjagain@gmail.com>, marcelo.leitner@gmail.com,
        davem@davemloft.net
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, anenbupt@gmail.com
References: <20200320110959.2114-1-hqjagain@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2dc8673f-a46d-1438-95a8-cfb455bbea57@gmail.com>
Date:   Fri, 20 Mar 2020 10:10:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200320110959.2114-1-hqjagain@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/20/20 4:09 AM, Qiujun Huang wrote:
> Do accounting for skb's real sk.
> In some case skb->sk != asoc->base.sk:
> 
> for the trouble SKB, it was in outq->transmitted queue
> 
> sctp_outq_sack
> 	sctp_check_transmitted
> 		SKB was moved to outq->sack
> 	then throw away the sack queue
> 		SKB was deleted from outq->sack
> (but the datamsg held SKB at sctp_datamsg_to_asoc
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
> 
> finally
> 
> __sctp_outq_teardown
> 	sctp_chunk_put (for another skb)
> 		sctp_datamsg_put
> 			__kfree_skb(msg->frag_list)
> 				sctp_wfree (for SKB)
> this case in sctp_wfree SKB->sk was oldsk.
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
> 

This does not really solve the issue.

Even if the particular syzbot repro is now fine.

Really, having anything _after_ the sock_wfree(skb) is the bug, since the current thread no longer
own a reference on a socket.




