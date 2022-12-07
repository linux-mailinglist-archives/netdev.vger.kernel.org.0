Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675A6645A18
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLGMrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLGMrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:47:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B76CF31
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670417168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OQyAmSUNZyFmd3qPXFCQdcuOPQovsZlF3qScABKGPX4=;
        b=bNqTWvS2okydDbwCvCZ0OzW4TWNcL7dWY3+9foM9G+1duK8BWBZMH8lEG1+OgTrLA/rrbb
        6DDngNlswqwW2bWlvWKHtAW/RDDhjY2OgeYaZ2ZjiHzH3exgYTGuEDdAx58wHH2ZNXbeqq
        boyZAzNhCOtcrulzekgpGaBkMgjfi6A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-53-X18iHUXjM4iC_0lLgUcK7A-1; Wed, 07 Dec 2022 07:46:01 -0500
X-MC-Unique: X18iHUXjM4iC_0lLgUcK7A-1
Received: by mail-wm1-f72.google.com with SMTP id r7-20020a1c4407000000b003d153a83d27so1416385wma.0
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 04:46:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OQyAmSUNZyFmd3qPXFCQdcuOPQovsZlF3qScABKGPX4=;
        b=Llxunzf/uFPIhKASDgy1aAZ2bZf1lgULHJvvfXgVZoDQywyBKU3X/sJg3lm2uyURZ1
         rZY8C04UQPjBKsuGs4YACWeRyuYVlyvwh2/oKOV8CFkFTx8HCzr1tq264vAY5FsWgSn6
         zz2xHYNkJfqyH8/D6ShKIjAskFASFMNMY29DIUag5+bKyrxUiE3LqouPtrvde/Vmcp2b
         g5YokAapd3Is3jJXBRZpQ1m9VMaXKLwt3ljkQX/q4nvwhuSxpvISub+jtEF8CI4+ErfE
         AQfCmQGv6fyVgHYUpb8GSq2+8wXfJgzJC4hCNKnlAnIZC41qGCiKcCLNXUrDou5hjSg5
         qcUQ==
X-Gm-Message-State: ANoB5pluR6q07MrO1FzQDJHpkIp4tjSnjxz82BUwGdPoDzIJj8ZHPI9E
        xff3N2sS2tJ1ZVfsyX0pyYk+zAFhn618PAa/gHBcbVaVEySsP/XGD8goXxXXV3uxvzgadS+UOVT
        7YKcg4ZGvbb63Z3uG
X-Received: by 2002:a5d:6b8d:0:b0:236:4c14:4e4c with SMTP id n13-20020a5d6b8d000000b002364c144e4cmr55543903wrx.634.1670417160609;
        Wed, 07 Dec 2022 04:46:00 -0800 (PST)
X-Google-Smtp-Source: AA0mqf44OzE67jrmbSsa9k3tB5WxLZpIQN+EuYaFBzO50on46kYiKBBvQ7wqtIOieqSg8ctcKFsqmA==
X-Received: by 2002:a5d:6b8d:0:b0:236:4c14:4e4c with SMTP id n13-20020a5d6b8d000000b002364c144e4cmr55543884wrx.634.1670417160331;
        Wed, 07 Dec 2022 04:46:00 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-106-100.dyn.eolo.it. [146.241.106.100])
        by smtp.gmail.com with ESMTPSA id ck14-20020a5d5e8e000000b0023677e1157fsm8155277wrb.56.2022.12.07.04.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 04:45:59 -0800 (PST)
Message-ID: <ad410abb19bdbcdac617878d14a4e37228f1157b.camel@redhat.com>
Subject: Re: [PATCH net-next v3 2/3] net: qualcomm: rmnet: add tx packets
 aggregation
From:   Paolo Abeni <pabeni@redhat.com>
To:     Daniele Palmas <dnlplm@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>
Cc:     =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org
Date:   Wed, 07 Dec 2022 13:45:58 +0100
In-Reply-To: <20221205093359.49350-3-dnlplm@gmail.com>
References: <20221205093359.49350-1-dnlplm@gmail.com>
         <20221205093359.49350-3-dnlplm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-12-05 at 10:33 +0100, Daniele Palmas wrote:
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> index a313242a762e..914ef03b5438 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> @@ -164,8 +164,18 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
>  
>  	map_header->mux_id = mux_id;
>  
> -	skb->protocol = htons(ETH_P_MAP);
> +	if (port->egress_agg_params.count > 1) {

This is racy. Here you read 'count' outside the 'agg_lock' lock and
later, in rmnet_map_tx_aggregate() the code assumes the above condition
helds, but ethtool could have changed the value in the meantime.

You need a READ_ONCE() above, a WRITE_ONCE() on update and cope with 0
value in rmnet_map_tx_aggregate().

[...]

> +static void rmnet_map_flush_tx_packet_work(struct work_struct *work)
> +{
> +	struct sk_buff *skb = NULL;
> +	struct rmnet_port *port;
> +
> +	port = container_of(work, struct rmnet_port, agg_wq);
> +
> +	spin_lock_bh(&port->agg_lock);
> +	if (likely(port->agg_state == -EINPROGRESS)) {
> +		/* Buffer may have already been shipped out */
> +		if (likely(port->skbagg_head)) {
> +			skb = port->skbagg_head;
> +			reset_aggr_params(port);
> +		}
> +		port->agg_state = 0;
> +	}
> +
> +	spin_unlock_bh(&port->agg_lock);
> +	if (skb)
> +		rmnet_send_skb(port, skb);
> +}
> +
> +static enum hrtimer_restart rmnet_map_flush_tx_packet_queue(struct hrtimer *t)
> +{
> +	struct rmnet_port *port;
> +
> +	port = container_of(t, struct rmnet_port, hrtimer);
> +
> +	schedule_work(&port->agg_wq);

Why you need to schedule a work and you can't instead call the core of
rmnet_map_flush_tx_packet_work() here? it looks like the latter does
not need process context...

> +
> +	return HRTIMER_NORESTART;
> +}
> +
> +unsigned int rmnet_map_tx_aggregate(struct sk_buff *skb, struct rmnet_port *port,
> +				    struct net_device *orig_dev)
> +{
> +	struct timespec64 diff, last;
> +	unsigned int len = skb->len;
> +	struct sk_buff *agg_skb;
> +	int size;
> +
> +	spin_lock_bh(&port->agg_lock);
> +	memcpy(&last, &port->agg_last, sizeof(struct timespec64));
> +	ktime_get_real_ts64(&port->agg_last);
> +
> +	if (!port->skbagg_head) {
> +		/* Check to see if we should agg first. If the traffic is very
> +		 * sparse, don't aggregate.
> +		 */
> +new_packet:
> +		diff = timespec64_sub(port->agg_last, last);
> +		size = port->egress_agg_params.bytes - skb->len;
> +
> +		if (size < 0) {
> +			/* dropped */
> +			spin_unlock_bh(&port->agg_lock);
> +			return 0;
> +		}
> +
> +		if (diff.tv_sec > 0 || diff.tv_nsec > RMNET_AGG_BYPASS_TIME_NSEC ||
> +		    size == 0) {

You can avoid some code duplication moving the following lines under an
'error' label and jumping to it here and in the next error case.

> +			spin_unlock_bh(&port->agg_lock);
> +			skb->protocol = htons(ETH_P_MAP);
> +			dev_queue_xmit(skb);
> +			return len;
> +		}
> +
> +		port->skbagg_head = skb_copy_expand(skb, 0, size, GFP_ATOMIC);
> +		if (!port->skbagg_head) {
> +			spin_unlock_bh(&port->agg_lock);
> +			skb->protocol = htons(ETH_P_MAP);
> +			dev_queue_xmit(skb);
> +			return len;
> +		}
> +		dev_kfree_skb_any(skb);
> +		port->skbagg_head->protocol = htons(ETH_P_MAP);
> +		port->agg_count = 1;
> +		ktime_get_real_ts64(&port->agg_time);
> +		skb_frag_list_init(port->skbagg_head);
> +		goto schedule;
> +	}
> +	diff = timespec64_sub(port->agg_last, port->agg_time);
> +	size = port->egress_agg_params.bytes - port->skbagg_head->len;
> +
> +	if (skb->len > size) {
> +		agg_skb = port->skbagg_head;
> +		reset_aggr_params(port);
> +		spin_unlock_bh(&port->agg_lock);
> +		hrtimer_cancel(&port->hrtimer);
> +		rmnet_send_skb(port, agg_skb);
> +		spin_lock_bh(&port->agg_lock);
> +		goto new_packet;
> +	}
> +
> +	if (skb_has_frag_list(port->skbagg_head))
> +		port->skbagg_tail->next = skb;
> +	else
> +		skb_shinfo(port->skbagg_head)->frag_list = skb;
> +
> +	port->skbagg_head->len += skb->len;
> +	port->skbagg_head->data_len += skb->len;
> +	port->skbagg_head->truesize += skb->truesize;
> +	port->skbagg_tail = skb;
> +	port->agg_count++;
> +
> +	if (diff.tv_sec > 0 || diff.tv_nsec > port->egress_agg_params.time_nsec ||
> +	    port->agg_count == port->egress_agg_params.count ||

At this point port->egress_agg_params.count can be 0, you need to check
for:
	port->agg_count >= port->egress_agg_params.count	


Cheers,

Paolo

