Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583C3563C7D
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 00:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiGAWr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 18:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGAWr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 18:47:58 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D0A71261;
        Fri,  1 Jul 2022 15:47:56 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o7PQI-0002Wh-QY; Sat, 02 Jul 2022 00:47:38 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o7PQI-000PZU-8J; Sat, 02 Jul 2022 00:47:38 +0200
Subject: Re: [PATCH bpf v2] xdp: Fix spurious packet loss in generic XDP TX
 path
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>, ast@kernel.org,
        andrii@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     song@kernel.org, martin.lau@linux.dev, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, Freysteinn.Alfredsson@kau.se, toke@redhat.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20220701094256.1970076-1-johan.almbladh@anyfinetworks.com>
 <20220701151200.2033129-1-johan.almbladh@anyfinetworks.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1558ba51-c9dd-e265-4222-a69e27238813@iogearbox.net>
Date:   Sat, 2 Jul 2022 00:47:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220701151200.2033129-1-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26590/Fri Jul  1 09:25:21 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/22 5:12 PM, Johan Almbladh wrote:
> The byte queue limits (BQL) mechanism is intended to move queuing from
> the driver to the network stack in order to reduce latency caused by
> excessive queuing in hardware. However, when transmitting or redirecting
> a packet using generic XDP, the qdisc layer is bypassed and there are no
> additional queues. Since netif_xmit_stopped() also takes BQL limits into
> account, but without having any alternative queuing, packets are
> silently dropped.
> 
> This patch modifies the drop condition to only consider cases when the
> driver itself cannot accept any more packets. This is analogous to the
> condition in __dev_direct_xmit(). Dropped packets are also counted on
> the device.
> 
> Bypassing the qdisc layer in the generic XDP TX path means that XDP
> packets are able to starve other packets going through a qdisc, and
> DDOS attacks will be more effective. In-driver-XDP use dedicated TX
> queues, so they do not have this starvation issue.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>   net/core/dev.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 8e6f22961206..00fb9249357f 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4863,7 +4863,10 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>   }
>   
>   /* When doing generic XDP we have to bypass the qdisc layer and the
> - * network taps in order to match in-driver-XDP behavior.
> + * network taps in order to match in-driver-XDP behavior. This also means
> + * that XDP packets are able to starve other packets going through a qdisc,
> + * and DDOS attacks will be more effective. In-driver-XDP use dedicated TX
> + * queues, so they do not have this starvation issue.
>    */
>   void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
>   {
> @@ -4875,10 +4878,12 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
>   	txq = netdev_core_pick_tx(dev, skb, NULL);
>   	cpu = smp_processor_id();
>   	HARD_TX_LOCK(dev, txq, cpu);
> -	if (!netif_xmit_stopped(txq)) {
> +	if (!netif_xmit_frozen_or_drv_stopped(txq)) {
>   		rc = netdev_start_xmit(skb, dev, txq, 0);
>   		if (dev_xmit_complete(rc))
>   			free_skb = false;
> +	} else {
> +		dev_core_stats_tx_dropped_inc(dev);
>   	}
>   	HARD_TX_UNLOCK(dev, txq);
>   	if (free_skb) {

Small q: Shouldn't the drop counter go into the free_skb branch?

diff --git a/net/core/dev.c b/net/core/dev.c
index 00fb9249357f..17e2c39477c5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4882,11 +4882,10 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
                 rc = netdev_start_xmit(skb, dev, txq, 0);
                 if (dev_xmit_complete(rc))
                         free_skb = false;
-       } else {
-               dev_core_stats_tx_dropped_inc(dev);
         }
         HARD_TX_UNLOCK(dev, txq);
         if (free_skb) {
+               dev_core_stats_tx_dropped_inc(dev);
                 trace_xdp_exception(dev, xdp_prog, XDP_TX);
                 kfree_skb(skb);
         }
