Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5674C620E
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 05:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiB1EGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 23:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiB1EGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 23:06:44 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5543136C;
        Sun, 27 Feb 2022 20:06:06 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id i1so9612367plr.2;
        Sun, 27 Feb 2022 20:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1iMjZs99yFvrTrdGptle5tGXSWiVgsIPGsP79v/GKgc=;
        b=X4AD70sxK4FYMkTRKPnoA2kCchF3BsSFHu8SjsPT8crO4k0K4hHGEm1T33+Md5wx8w
         9/PoXb/TNQc1nbzy9LdXZSV+HJpeHIOmNcJOLtK8gf5Rve0gDUL80lPQN81N+0S4oSG8
         dTuAj/FyjOfOqUykx11xfjTE5azS5xqAI3LRr/o1xfKCj3twfDy74MMP+pPj86WtBHka
         Q2vpjKbXdRZAxR0oSmWVtlSKgdnEFfNEGRtn4l5rPvnYur+qfmY1s/rLsQbaymL7PeQz
         xR7hN4ZfDqPiwfGcxJXUhY1+bBpH+eHyyogr0h3RnK8bS2ydt+LAnqNK4u1IxC7WArZV
         Ir1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1iMjZs99yFvrTrdGptle5tGXSWiVgsIPGsP79v/GKgc=;
        b=gybVozPhZUOJ3/ChRSEnXORgRyrQiwROmPdbuz33Wf6MP+QuVEiiyQNvFOwlSjlr85
         MI8bUy3WUhlEe0jaYtrfyzXhUNEoYdXGZdBNJIxBGzpU8mmLGUczmR0fRdux4zqBd/6j
         aHCU80hA3Wc9OZ7cjAAqKjhyBXPIig59N/QBzr29WAFc15lcEd3HcvV7YGz/t5TXhz4h
         WJegRyXOXSc3piXORsgV9AnZbNbhSYtuJ91PvsvJAU3iP/Kv++gpqwg503US76sN1KMv
         HJpotxQ6AOCPxCBXPal5L596266nQnt395LhYEgK2YNWdIN3/Xii7zTlUAXojlqbsY9G
         LgDg==
X-Gm-Message-State: AOAM530B/AM+FkPOv54hk9ncFjsiQJ3wI/baVyai/z+e/mNp/8OBvJT5
        SXusCXK67Lfcx+4KwoZR1eY=
X-Google-Smtp-Source: ABdhPJzmuzTPTpfDAj3F94nER6rw4HVogjMbSRNHTtb/tUxsVPyyRvOYhvlQvKGNovOhYZy37qekxQ==
X-Received: by 2002:a17:902:bf06:b0:14d:8c72:96c6 with SMTP id bi6-20020a170902bf0600b0014d8c7296c6mr19153920plb.156.1646021166026;
        Sun, 27 Feb 2022 20:06:06 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id k1-20020a056a00168100b004e0e45a39c6sm11172350pfc.181.2022.02.27.20.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Feb 2022 20:06:05 -0800 (PST)
Message-ID: <c687e1d8-e36a-8f23-342a-22b2a1efb372@gmail.com>
Date:   Sun, 27 Feb 2022 20:06:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v2] tun: support NAPI for packets received from
 batched XDP buffs
Content-Language: en-US
To:     Harold Huang <baymaxhuang@gmail.com>, netdev@vger.kernel.org
Cc:     jasowang@redhat.com, pabeni@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        edumazet@google.com
References: <20220224103852.311369-1-baymaxhuang@gmail.com>
 <20220225090223.636877-1-baymaxhuang@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220225090223.636877-1-baymaxhuang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/25/22 01:02, Harold Huang wrote:
> In tun, NAPI is supported and we can also use NAPI in the path of
> batched XDP buffs to accelerate packet processing. What is more, after
> we use NAPI, GRO is also supported. The iperf shows that the throughput of
> single stream could be improved from 4.5Gbps to 9.2Gbps. Additionally, 9.2
> Gbps nearly reachs the line speed of the phy nic and there is still about
> 15% idle cpu core remaining on the vhost thread.
>
> Test topology:
>
> [iperf server]<--->tap<--->dpdk testpmd<--->phy nic<--->[iperf client]
>
> Iperf stream:
>
> Before:
> ...
> [  5]   5.00-6.00   sec   558 MBytes  4.68 Gbits/sec    0   1.50 MBytes
> [  5]   6.00-7.00   sec   556 MBytes  4.67 Gbits/sec    1   1.35 MBytes
> [  5]   7.00-8.00   sec   556 MBytes  4.67 Gbits/sec    2   1.18 MBytes
> [  5]   8.00-9.00   sec   559 MBytes  4.69 Gbits/sec    0   1.48 MBytes
> [  5]   9.00-10.00  sec   556 MBytes  4.67 Gbits/sec    1   1.33 MBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  5.39 GBytes  4.63 Gbits/sec   72          sender
> [  5]   0.00-10.04  sec  5.39 GBytes  4.61 Gbits/sec               receiver
>
> After:
> ...
> [  5]   5.00-6.00   sec  1.07 GBytes  9.19 Gbits/sec    0   1.55 MBytes
> [  5]   6.00-7.00   sec  1.08 GBytes  9.30 Gbits/sec    0   1.63 MBytes
> [  5]   7.00-8.00   sec  1.08 GBytes  9.25 Gbits/sec    0   1.72 MBytes
> [  5]   8.00-9.00   sec  1.08 GBytes  9.25 Gbits/sec   77   1.31 MBytes
> [  5]   9.00-10.00  sec  1.08 GBytes  9.24 Gbits/sec    0   1.48 MBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  10.8 GBytes  9.28 Gbits/sec  166          sender
> [  5]   0.00-10.04  sec  10.8 GBytes  9.24 Gbits/sec               receiver
> ....
>
> Reported-at: https://lore.kernel.org/all/CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com
> Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
> ---
> v1 -> v2
>   - fix commit messages
>   - add queued flag to avoid void unnecessary napi suggested by Jason
>
>   drivers/net/tun.c | 20 ++++++++++++++++----
>   1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index fed85447701a..c7d8b7c821d8 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2379,7 +2379,7 @@ static void tun_put_page(struct tun_page *tpage)
>   }
>   
>   static int tun_xdp_one(struct tun_struct *tun,
> -		       struct tun_file *tfile,
> +		       struct tun_file *tfile, int *queued,
>   		       struct xdp_buff *xdp, int *flush,
>   		       struct tun_page *tpage)
>   {
> @@ -2388,6 +2388,7 @@ static int tun_xdp_one(struct tun_struct *tun,
>   	struct virtio_net_hdr *gso = &hdr->gso;
>   	struct bpf_prog *xdp_prog;
>   	struct sk_buff *skb = NULL;
> +	struct sk_buff_head *queue;
>   	u32 rxhash = 0, act;
>   	int buflen = hdr->buflen;
>   	int err = 0;
> @@ -2464,7 +2465,15 @@ static int tun_xdp_one(struct tun_struct *tun,
>   	    !tfile->detached)
>   		rxhash = __skb_get_hash_symmetric(skb);
>   
> -	netif_receive_skb(skb);
> +	if (tfile->napi_enabled) {
> +		queue = &tfile->sk.sk_write_queue;
> +		spin_lock(&queue->lock);
> +		__skb_queue_tail(queue, skb);
> +		spin_unlock(&queue->lock);
> +		(*queued)++;
> +	} else {
> +		netif_receive_skb(skb);
> +	}
>   
>   	/* No need to disable preemption here since this function is
>   	 * always called with bh disabled
> @@ -2492,7 +2501,7 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>   	if (ctl && (ctl->type == TUN_MSG_PTR)) {
>   		struct tun_page tpage;
>   		int n = ctl->num;
> -		int flush = 0;
> +		int flush = 0, queued = 0;
>   
>   		memset(&tpage, 0, sizeof(tpage));
>   
> @@ -2501,12 +2510,15 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>   
>   		for (i = 0; i < n; i++) {
>   			xdp = &((struct xdp_buff *)ctl->ptr)[i];
> -			tun_xdp_one(tun, tfile, xdp, &flush, &tpage);
> +			tun_xdp_one(tun, tfile, &queued, xdp, &flush, &tpage);


How big n can be ?

BTW I could not find where m->msg_controllen was checked in tun_sendmsg().

struct tun_msg_ctl *ctl = m->msg_control;

if (ctl && (ctl->type == TUN_MSG_PTR)) {

     int n = ctl->num;  // can be set to values in [0..65535]

     for (i = 0; i < n; i++) {

         xdp = &((struct xdp_buff *)ctl->ptr)[i];


I really do not understand how we prevent malicious user space from 
crashing the kernel.



>   		}
>   
>   		if (flush)
>   			xdp_do_flush();
>   
> +		if (tfile->napi_enabled && queued > 0)
> +			napi_schedule(&tfile->napi);
> +
>   		rcu_read_unlock();
>   		local_bh_enable();
>   
