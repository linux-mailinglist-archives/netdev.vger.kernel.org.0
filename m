Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A46B681C48
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjA3VGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjA3VF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:05:59 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243E0474F8;
        Mon, 30 Jan 2023 13:05:39 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pMbLC-000NMm-Ba; Mon, 30 Jan 2023 22:05:26 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pMbLB-000BBl-TF; Mon, 30 Jan 2023 22:05:25 +0100
Subject: Re: [PATCH] net: fix NULL pointer in skb_segment_list
To:     Yan Zhai <yan@cloudflare.com>, netdev@vger.kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, asml.silence@gmail.com, imagedong@tencent.com,
        keescook@chromium.org, jbenc@redhat.com, richardbgobert@gmail.com,
        willemb@google.com, steffen.klassert@secunet.com,
        linux-kernel@vger.kernel.org
References: <Y9gt5EUizK1UImEP@debian>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0e41673f-457d-1685-ea47-0166ca71ff97@iogearbox.net>
Date:   Mon, 30 Jan 2023 22:05:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <Y9gt5EUizK1UImEP@debian>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26797/Mon Jan 30 09:24:58 2023)
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/23 9:51 PM, Yan Zhai wrote:
> Commit 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
> introduced UDP listifyed GRO. The segmentation relies on frag_list being
> untouched when passing through the network stack. This assumption can be
> broken sometimes, where frag_list itself gets pulled into linear area,
> leaving frag_list being NULL. When this happens it can trigger
> following NULL pointer dereference, and panic the kernel. Reverse the
> test condition should fix it.
> 
> [19185.577801][    C1] BUG: kernel NULL pointer dereference, address:
> ...
> [19185.663775][    C1] RIP: 0010:skb_segment_list+0x1cc/0x390
> ...
> [19185.834644][    C1] Call Trace:
> [19185.841730][    C1]  <TASK>
> [19185.848563][    C1]  __udp_gso_segment+0x33e/0x510
> [19185.857370][    C1]  inet_gso_segment+0x15b/0x3e0
> [19185.866059][    C1]  skb_mac_gso_segment+0x97/0x110
> [19185.874939][    C1]  __skb_gso_segment+0xb2/0x160
> [19185.883646][    C1]  udp_queue_rcv_skb+0xc3/0x1d0
> [19185.892319][    C1]  udp_unicast_rcv_skb+0x75/0x90
> [19185.900979][    C1]  ip_protocol_deliver_rcu+0xd2/0x200
> [19185.910003][    C1]  ip_local_deliver_finish+0x44/0x60
> [19185.918757][    C1]  __netif_receive_skb_one_core+0x8b/0xa0
> [19185.927834][    C1]  process_backlog+0x88/0x130
> [19185.935840][    C1]  __napi_poll+0x27/0x150
> [19185.943447][    C1]  net_rx_action+0x27e/0x5f0
> [19185.951331][    C1]  ? mlx5_cq_tasklet_cb+0x70/0x160 [mlx5_core]
> [19185.960848][    C1]  __do_softirq+0xbc/0x25d
> [19185.968607][    C1]  irq_exit_rcu+0x83/0xb0
> [19185.976247][    C1]  common_interrupt+0x43/0xa0
> [19185.984235][    C1]  asm_common_interrupt+0x22/0x40
> ...
> [19186.094106][    C1]  </TASK>
> 
> Fixes: 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
> Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Yan Zhai <yan@cloudflare.com>

Acked-by: Daniel Borkmann <daniel@iogearbox.net>

>   net/core/skbuff.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 4a0eb5593275..a31ff4d83ecc 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4100,7 +4100,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>   
>   	skb_shinfo(skb)->frag_list = NULL;
>   
> -	do {
> +	while (list_skb) {
>   		nskb = list_skb;
>   		list_skb = list_skb->next;
>   
> @@ -4146,8 +4146,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>   		if (skb_needs_linearize(nskb, features) &&
>   		    __skb_linearize(nskb))
>   			goto err_linearize;
> -
> -	} while (list_skb);
> +	}
>   
>   	skb->truesize = skb->truesize - delta_truesize;
>   	skb->data_len = skb->data_len - delta_len;
> 

