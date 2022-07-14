Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33EF574659
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiGNIKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiGNIKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:10:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05B162B18E
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 01:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657786198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QbwUGpjbW7JbQyUNjUb2fa5Xyr2Kx7SLSsmZRBY7x/M=;
        b=gQw9FwFp1WzMWZqS1zLu2ppjqjPya1y0Q41wEw2qpYAF6yu1y8f+d+RhJ38aUlMY9WBRsd
        VJ1vxUN7zShht6sKpwgaroQ3avbcKYvZL/LkiwJITOr3v5148H1wBV8epEVWXD9p4NHNCk
        KOCpx1RRtcLvSETrVr3/eyPmVGdUgRI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-yMErnwzcOgSM1qNq3YTiXA-1; Thu, 14 Jul 2022 04:09:57 -0400
X-MC-Unique: yMErnwzcOgSM1qNq3YTiXA-1
Received: by mail-qv1-f71.google.com with SMTP id d18-20020a0cfe92000000b0047342562073so806064qvs.1
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 01:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QbwUGpjbW7JbQyUNjUb2fa5Xyr2Kx7SLSsmZRBY7x/M=;
        b=Ju0c8ewZAiCvTBAOuQYMToOWRfQm+4D/V77c/QxIWWvDZzIMuHF1x7Eo3+9Pb63T04
         Yk9uQJv4TtS76K08hkmpZc/MAR6q8qhJW71oqREUdu0uoXVXiOjg6J7Phslu101/ov0V
         qJ1cQkXlgOabOk1b4sibUMfsSklZtk6p8q4zq6joZbMBCHm8BQJyAUm2YoZEv8CgYDq8
         L4bhlSWqilAbRcoDos7U05w2EtX1RMTHxcT5+FZyn2BTMkXRt8Ug1scZPOUg4FIZ66Io
         JCnnNYF6eSYrbdRdb1Vbiw+r2hGlAMvdfWLQvsOJshNNP+gmJstu4BHcl5BjPTZag427
         VYIA==
X-Gm-Message-State: AJIora8DxWfOByM807P9+W0mR+uY2dL7Z58quhTxSQMg5QQ7htkQg3eG
        5x55QG6R3D/0/4n4X8zK89ynAmAmbywV5q6e2/a+2Y1X1NtIjKFesva+0etCDxRE/AI67h8yNKJ
        tryfnWBQ66qF4QeSR
X-Received: by 2002:a05:620a:1410:b0:6b5:ae3a:8cb2 with SMTP id d16-20020a05620a141000b006b5ae3a8cb2mr5103193qkj.381.1657786196477;
        Thu, 14 Jul 2022 01:09:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sn7eS9DSJAwKhEQSsG9Venj41m/tkOEx8h6WwGJGineMWqhmM+BgcslRhYvh2VgH4+LLCGAQ==
X-Received: by 2002:a05:620a:1410:b0:6b5:ae3a:8cb2 with SMTP id d16-20020a05620a141000b006b5ae3a8cb2mr5103181qkj.381.1657786196088;
        Thu, 14 Jul 2022 01:09:56 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id w3-20020a05620a444300b006a37eb728cfsm867680qkp.1.2022.07.14.01.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 01:09:55 -0700 (PDT)
Message-ID: <bdea7caaaa84adb7c75c19438a7cea43b2391ffc.camel@redhat.com>
Subject: Re: [PATCH net 1/8] amt: use workqueue for gateway side message
 handling
From:   Paolo Abeni <pabeni@redhat.com>
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, netdev@vger.kernel.org
Date:   Thu, 14 Jul 2022 10:09:51 +0200
In-Reply-To: <20220712105714.12282-2-ap420073@gmail.com>
References: <20220712105714.12282-1-ap420073@gmail.com>
         <20220712105714.12282-2-ap420073@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-12 at 10:57 +0000, Taehee Yoo wrote:
> There are some synchronization issues(amt->status, amt->req_cnt, etc)
> if the interface is in gateway mode because gateway message handlers
> are processed concurrently.
> This applies a work queue for processing these messages instead of
> expanding the locking context.
> 
> So, the purposes of this patch are to fix exist race conditions and to make
> gateway to be able to validate a gateway status more correctly.
> 
> When the AMT gateway interface is created, it tries to establish to relay.
> The establishment step looks stateless, but it should be managed well.
> In order to handle messages in the gateway, it saves the current
> status(i.e. AMT_STATUS_XXX).
> This patch makes gateway code to be worked with a single thread.
> 
> Now, all messages except the multicast are triggered(received or
> delay expired), and these messages will be stored in the event
> queue(amt->events).
> Then, the single worker processes stored messages asynchronously one
> by one.
> The multicast data message type will be still processed immediately.
> 
> Now, amt->lock is only needed to access the event queue(amt->events)
> if an interface is the gateway mode.
> 
> Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  drivers/net/amt.c | 158 +++++++++++++++++++++++++++++++++++++++++-----
>  include/net/amt.h |  20 ++++++
>  2 files changed, 163 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
> index be2719a3ba70..032c2934e466 100644
> --- a/drivers/net/amt.c
> +++ b/drivers/net/amt.c
> @@ -900,6 +900,28 @@ static void amt_send_mld_gq(struct amt_dev *amt, struct amt_tunnel_list *tunnel)
>  }
>  #endif
>  
> +static bool amt_queue_events(struct amt_dev *amt, enum amt_event event,
> +			     struct sk_buff *skb)
> +{
> +	int index;
> +
> +	spin_lock_bh(&amt->lock);
> +	if (amt->nr_events >= AMT_MAX_EVENTS) {
> +		spin_unlock_bh(&amt->lock);
> +		return 1;
> +	}
> +
> +	index = (amt->event_idx + amt->nr_events) % AMT_MAX_EVENTS;
> +	amt->events[index].event = event;
> +	amt->events[index].skb = skb;
> +	amt->nr_events++;
> +	amt->event_idx %= AMT_MAX_EVENTS;
> +	queue_work(amt_wq, &amt->event_wq);
> +	spin_unlock_bh(&amt->lock);
> +
> +	return 0;
> +}
> +
>  static void amt_secret_work(struct work_struct *work)
>  {
>  	struct amt_dev *amt = container_of(to_delayed_work(work),
> @@ -913,12 +935,8 @@ static void amt_secret_work(struct work_struct *work)
>  			 msecs_to_jiffies(AMT_SECRET_TIMEOUT));
>  }
>  
> -static void amt_discovery_work(struct work_struct *work)
> +static void amt_event_send_discovery(struct amt_dev *amt)
>  {
> -	struct amt_dev *amt = container_of(to_delayed_work(work),
> -					   struct amt_dev,
> -					   discovery_wq);
> -
>  	spin_lock_bh(&amt->lock);
>  	if (amt->status > AMT_STATUS_SENT_DISCOVERY)
>  		goto out;
> @@ -933,11 +951,19 @@ static void amt_discovery_work(struct work_struct *work)
>  	spin_unlock_bh(&amt->lock);
>  }
>  
> -static void amt_req_work(struct work_struct *work)
> +static void amt_discovery_work(struct work_struct *work)
>  {
>  	struct amt_dev *amt = container_of(to_delayed_work(work),
>  					   struct amt_dev,
> -					   req_wq);
> +					   discovery_wq);
> +
> +	if (amt_queue_events(amt, AMT_EVENT_SEND_DISCOVERY, NULL))
> +		mod_delayed_work(amt_wq, &amt->discovery_wq,
> +				 msecs_to_jiffies(AMT_DISCOVERY_TIMEOUT));
> +}
> +
> +static void amt_event_send_request(struct amt_dev *amt)
> +{
>  	u32 exp;
>  
>  	spin_lock_bh(&amt->lock);
> @@ -967,6 +993,17 @@ static void amt_req_work(struct work_struct *work)
>  	spin_unlock_bh(&amt->lock);
>  }
>  
> +static void amt_req_work(struct work_struct *work)
> +{
> +	struct amt_dev *amt = container_of(to_delayed_work(work),
> +					   struct amt_dev,
> +					   req_wq);
> +
> +	if (amt_queue_events(amt, AMT_EVENT_SEND_REQUEST, NULL))
> +		mod_delayed_work(amt_wq, &amt->req_wq,
> +				 msecs_to_jiffies(100));
> +}
> +
>  static bool amt_send_membership_update(struct amt_dev *amt,
>  				       struct sk_buff *skb,
>  				       bool v6)
> @@ -2392,12 +2429,14 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
>  	skb->pkt_type = PACKET_MULTICAST;
>  	skb->ip_summed = CHECKSUM_NONE;
>  	len = skb->len;
> +	rcu_read_lock_bh();

Here you only need local_bh_disable(), the RCU part is confusing as
Jakub noted, and not needed.

>  	if (__netif_rx(skb) == NET_RX_SUCCESS) {
>  		amt_update_gw_status(amt, AMT_STATUS_RECEIVED_QUERY, true);
>  		dev_sw_netstats_rx_add(amt->dev, len);
>  	} else {
>  		amt->dev->stats.rx_dropped++;
>  	}
> +	rcu_read_unlock_bh();
>  
>  	return false;
>  }
> @@ -2688,6 +2727,38 @@ static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
>  	return false;
>  }
>  
> +static void amt_gw_rcv(struct amt_dev *amt, struct sk_buff *skb)
> +{
> +	int type = amt_parse_type(skb);
> +	int err = 1;
> +
> +	if (type == -1)
> +		goto drop;
> +
> +	if (amt->mode == AMT_MODE_GATEWAY) {
> +		switch (type) {
> +		case AMT_MSG_ADVERTISEMENT:
> +			err = amt_advertisement_handler(amt, skb);
> +			break;
> +		case AMT_MSG_MEMBERSHIP_QUERY:
> +			err = amt_membership_query_handler(amt, skb);
> +			if (!err)
> +				return;
> +			break;
> +		default:
> +			netdev_dbg(amt->dev, "Invalid type of Gateway\n");
> +			break;
> +		}
> +	}
> +drop:
> +	if (err) {
> +		amt->dev->stats.rx_dropped++;
> +		kfree_skb(skb);
> +	} else {
> +		consume_skb(skb);
> +	}
> +}
> +
>  static int amt_rcv(struct sock *sk, struct sk_buff *skb)
>  {
>  	struct amt_dev *amt;
> @@ -2719,8 +2790,12 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
>  				err = true;
>  				goto drop;
>  			}
> -			err = amt_advertisement_handler(amt, skb);
> -			break;
> +			if (amt_queue_events(amt, AMT_EVENT_RECEIVE, skb)) {
> +				netdev_dbg(amt->dev, "AMT Event queue full\n");
> +				err = true;
> +				goto drop;
> +			}
> +			goto out;
>  		case AMT_MSG_MULTICAST_DATA:
>  			if (iph->saddr != amt->remote_ip) {
>  				netdev_dbg(amt->dev, "Invalid Relay IP\n");
> @@ -2738,11 +2813,12 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
>  				err = true;
>  				goto drop;
>  			}
> -			err = amt_membership_query_handler(amt, skb);
> -			if (err)
> +			if (amt_queue_events(amt, AMT_EVENT_RECEIVE, skb)) {
> +				netdev_dbg(amt->dev, "AMT Event queue full\n");
> +				err = true;
>  				goto drop;
> -			else
> -				goto out;
> +			}
> +			goto out;
>  		default:
>  			err = true;
>  			netdev_dbg(amt->dev, "Invalid type of Gateway\n");
> @@ -2780,6 +2856,45 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
>  	return 0;
>  }
>  
> +static void amt_event_work(struct work_struct *work)
> +{
> +	struct amt_dev *amt = container_of(work, struct amt_dev, event_wq);
> +	struct sk_buff *skb;
> +	u8 event;
> +
> +	while (1) {
> +		spin_lock(&amt->lock);

This is called in process context, amd amt->lock can be acquired from
BH context, you need spin_lock_bh() here.

Lockdep should help finding this kind of issue.

> +		if (amt->nr_events == 0) {
> +			spin_unlock(&amt->lock);
> +			return;
> +		}
> +		event = amt->events[amt->event_idx].event;
> +		skb = amt->events[amt->event_idx].skb;
> +		amt->events[amt->event_idx].event = AMT_EVENT_NONE;
> +		amt->events[amt->event_idx].skb = NULL;
> +		amt->nr_events--;
> +		amt->event_idx++;
> +		amt->event_idx %= AMT_MAX_EVENTS;
> +		spin_unlock(&amt->lock);
> +
> +		switch (event) {
> +		case AMT_EVENT_RECEIVE:
> +			amt_gw_rcv(amt, skb);
> +			break;
> +		case AMT_EVENT_SEND_DISCOVERY:
> +			amt_event_send_discovery(amt);
> +			break;
> +		case AMT_EVENT_SEND_REQUEST:
> +			amt_event_send_request(amt);
> +			break;
> +		default:
> +			if (skb)
> +				kfree_skb(skb);
> +			break;
> +		}

This loops is unbound. If the socket keep adding events, it can keep
running forever. You need either to add cond_schedule() or even better
break it after a low max number of iterations - pending event will be
served when the work struct is dequeued next

> +	}
> +}
> +
>  static int amt_err_lookup(struct sock *sk, struct sk_buff *skb)
>  {
>  	struct amt_dev *amt;
> @@ -2892,10 +3007,21 @@ static int amt_dev_stop(struct net_device *dev)
>  	struct amt_dev *amt = netdev_priv(dev);
>  	struct amt_tunnel_list *tunnel, *tmp;
>  	struct socket *sock;
> +	struct sk_buff *skb;
> +	int i;
>  
>  	cancel_delayed_work_sync(&amt->req_wq);
>  	cancel_delayed_work_sync(&amt->discovery_wq);
>  	cancel_delayed_work_sync(&amt->secret_wq);
> +	cancel_work_sync(&amt->event_wq);
> +
> +	for (i = 0; i < AMT_MAX_EVENTS; i++) {
> +		skb = amt->events[i].skb;
> +		if (skb)
> +			kfree_skb(skb);
> +		amt->events[i].event = AMT_EVENT_NONE;
> +		amt->events[i].skb = NULL;
> +	}
>  
>  	/* shutdown */
>  	sock = rtnl_dereference(amt->sock);
> @@ -3051,6 +3177,8 @@ static int amt_newlink(struct net *net, struct net_device *dev,
>  		amt->max_tunnels = AMT_MAX_TUNNELS;
>  
>  	spin_lock_init(&amt->lock);
> +	amt->event_idx = 0;
> +	amt->nr_events = 0;
>  	amt->max_groups = AMT_MAX_GROUP;
>  	amt->max_sources = AMT_MAX_SOURCE;
>  	amt->hash_buckets = AMT_HSIZE;
> @@ -3146,8 +3274,8 @@ static int amt_newlink(struct net *net, struct net_device *dev,
>  	INIT_DELAYED_WORK(&amt->discovery_wq, amt_discovery_work);
>  	INIT_DELAYED_WORK(&amt->req_wq, amt_req_work);
>  	INIT_DELAYED_WORK(&amt->secret_wq, amt_secret_work);
> +	INIT_WORK(&amt->event_wq, amt_event_work);
>  	INIT_LIST_HEAD(&amt->tunnel_list);
> -
>  	return 0;
>  err:
>  	dev_put(amt->stream_dev);
> @@ -3280,7 +3408,7 @@ static int __init amt_init(void)
>  	if (err < 0)
>  		goto unregister_notifier;
>  
> -	amt_wq = alloc_workqueue("amt", WQ_UNBOUND, 1);
> +	amt_wq = alloc_workqueue("amt", WQ_UNBOUND, 0);
>  	if (!amt_wq) {
>  		err = -ENOMEM;
>  		goto rtnl_unregister;
> diff --git a/include/net/amt.h b/include/net/amt.h
> index 0e40c3d64fcf..08fc30cf2f34 100644
> --- a/include/net/amt.h
> +++ b/include/net/amt.h
> @@ -78,6 +78,15 @@ enum amt_status {
>  
>  #define AMT_STATUS_MAX (__AMT_STATUS_MAX - 1)
>  
> +/* Gateway events only */
> +enum amt_event {
> +	AMT_EVENT_NONE,
> +	AMT_EVENT_RECEIVE,
> +	AMT_EVENT_SEND_DISCOVERY,
> +	AMT_EVENT_SEND_REQUEST,
> +	__AMT_EVENT_MAX,
> +};
> +
>  struct amt_header {
>  #if defined(__LITTLE_ENDIAN_BITFIELD)
>  	u8 type:4,
> @@ -292,6 +301,12 @@ struct amt_group_node {
>  	struct hlist_head	sources[];
>  };
>  
> +#define AMT_MAX_EVENTS	16
> +struct amt_events {
> +	enum amt_event event;
> +	struct sk_buff *skb;
> +};
> +
>  struct amt_dev {
>  	struct net_device       *dev;
>  	struct net_device       *stream_dev;
> @@ -308,6 +323,7 @@ struct amt_dev {
>  	struct delayed_work     req_wq;
>  	/* Protected by RTNL */
>  	struct delayed_work     secret_wq;
> +	struct work_struct	event_wq;
>  	/* AMT status */
>  	enum amt_status		status;
>  	/* Generated key */
> @@ -345,6 +361,10 @@ struct amt_dev {
>  	/* Used only in gateway mode */
>  	u64			mac:48,
>  				reserved:16;
> +	/* AMT gateway side message handler queue */
> +	struct amt_events	events[AMT_MAX_EVENTS];
> +	u8			event_idx;
> +	u8			nr_events;
>  };
>  
>  #define AMT_TOS			0xc0

