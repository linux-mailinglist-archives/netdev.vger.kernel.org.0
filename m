Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37D723239E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 19:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgG2RoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 13:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgG2RoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 13:44:08 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0209EC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 10:44:08 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k71so2219995pje.0
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 10:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UXpbThgoPFMCxaKk+VBIYo315ccTQKqksdF40uLodTU=;
        b=ZhUPAQ0/pgkB2JzMg0WflUcwiw3qKy0QfewBV1RjpdDZ6lduKOcqCoPVxrYRAf1jau
         bjY3gRMGVe5DDgGdoJRUgZhCVguJfUPAP0vsKb780ReVHkiBz/zvlZAKIcyr8/lmbcx2
         c0ytvt7mYAjL5e+XDTUtp+jAOyOiVzY7+smmtrXzNPsMJKbo8rbNAdZVh6c4/BkUExr4
         ttq+1Zv309PPqDQa6Q6GHaGlGUnRS/2wL2gpF8M//dG3ivJpDYIue8R2xlj6U+LyzVjH
         ZIuIDIGx6QFSHR61nMiA7KCD3WK8ZNwdPYBg49nWLzRxOFZe8scDtEn0a+CFrrm9jdrt
         bQEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UXpbThgoPFMCxaKk+VBIYo315ccTQKqksdF40uLodTU=;
        b=se4+11sBLrneuL5iAaNFoGYelMu3D9ue9VcOcUNGB5V4pIbsnUY4tt+zOPV3Sk0Lg7
         oqrAcdq4h95tLKCNhwr+HncRPC5nCdmxA30fXlxUrfVLCQww3EFkwabD6f75uK8xlumJ
         OJNVlGmHABtLIgiUwgxCSu09dzbyUuZF06igeflhP/+OqwHAdDt5HSxi7EPxHk8wi9Jg
         1ROW86qg+I/X/z7vL+7Ydt3OmO2Q/t9hKOIz1ED3PQZNeg5rmRBTe8uNrtWUP9mPOMtr
         tRZh4dmH0BXO3rB32U0saxwVAF0aU1cllG99n2CitcLsZHIHazHoBDac+9qOCuJWagwz
         K8PQ==
X-Gm-Message-State: AOAM532RNzQ7ZP5FttvXUVmz5EsXUygesQtjvayryYxmR4j78rLIYsam
        RXtmACLR0HydujDH0PKtlP8=
X-Google-Smtp-Source: ABdhPJwIGYuzmgrJOQ27NbEukkm+iR5MpfDBmrJtgmZa/IaZn1zROiXSe2WNGb+h2fD2YlNFM79UUA==
X-Received: by 2002:a17:90a:c398:: with SMTP id h24mr10784453pjt.211.1596044647469;
        Wed, 29 Jul 2020 10:44:07 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id b13sm3020828pjl.7.2020.07.29.10.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2020 10:44:06 -0700 (PDT)
Subject: Re: [PATCH] net: add support for threaded NAPI polling
To:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Hillf Danton <hdanton@sina.com>
References: <20200729165058.83984-1-nbd@nbd.name>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <866c7d83-868d-120e-f535-926c4cc9e615@gmail.com>
Date:   Wed, 29 Jul 2020 10:44:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200729165058.83984-1-nbd@nbd.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/20 9:50 AM, Felix Fietkau wrote:
> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
> poll function does not perform well. Since NAPI poll is bound to the CPU it
> was scheduled from, we can easily end up with a few very busy CPUs spending
> most of their time in softirq/ksoftirqd and some idle ones.
> 
> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
> same except for using netif_threaded_napi_add instead of netif_napi_add.
> 
> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
> thread.
> 
> With threaded NAPI, throughput seems stable and consistent (and higher than
> the best results I got without it).
> 
> Based on a patch by Hillf Danton
> 
> Cc: Hillf Danton <hdanton@sina.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
> Changes since RFC v2:
> - fix unused but set variable reported by kbuild test robot
> 
> Changes since RFC:
> - disable softirq around threaded poll functions
> - reuse most parts of napi_poll()
> - fix re-schedule condition
> 
>  include/linux/netdevice.h |  23 ++++++
>  net/core/dev.c            | 162 ++++++++++++++++++++++++++------------
>  2 files changed, 133 insertions(+), 52 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ac2cd3f49aba..3a39211c7598 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -347,6 +347,7 @@ struct napi_struct {
>  	struct list_head	dev_list;
>  	struct hlist_node	napi_hash_node;
>  	unsigned int		napi_id;
> +	struct work_struct	work;
>  };
>  
>  enum {
> @@ -357,6 +358,7 @@ enum {
>  	NAPI_STATE_HASHED,	/* In NAPI hash (busy polling possible) */
>  	NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
>  	NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
> +	NAPI_STATE_THREADED,	/* Use threaded NAPI */
>  };
>  
>  enum {
> @@ -367,6 +369,7 @@ enum {
>  	NAPIF_STATE_HASHED	 = BIT(NAPI_STATE_HASHED),
>  	NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
>  	NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
> +	NAPIF_STATE_THREADED	 = BIT(NAPI_STATE_THREADED),
>  };
>  
>  enum gro_result {
> @@ -2315,6 +2318,26 @@ static inline void *netdev_priv(const struct net_device *dev)
>  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>  		    int (*poll)(struct napi_struct *, int), int weight);
>  
> +/**
> + *	netif_threaded_napi_add - initialize a NAPI context
> + *	@dev:  network device
> + *	@napi: NAPI context
> + *	@poll: polling function
> + *	@weight: default weight
> + *
> + * This variant of netif_napi_add() should be used from drivers using NAPI
> + * with CPU intensive poll functions.
> + * This will schedule polling from a high priority workqueue that
> + */
> +static inline void netif_threaded_napi_add(struct net_device *dev,
> +					   struct napi_struct *napi,
> +					   int (*poll)(struct napi_struct *, int),
> +					   int weight)
> +{
> +	set_bit(NAPI_STATE_THREADED, &napi->state);
> +	netif_napi_add(dev, napi, poll, weight);
> +}
> +
>  /**
>   *	netif_tx_napi_add - initialize a NAPI context
>   *	@dev:  network device
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 19f1abc26fcd..11b027f3a2b9 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -158,6 +158,7 @@ static DEFINE_SPINLOCK(offload_lock);
>  struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
>  struct list_head ptype_all __read_mostly;	/* Taps */
>  static struct list_head offload_base __read_mostly;
> +static struct workqueue_struct *napi_workq __read_mostly;
>  
>  static int netif_rx_internal(struct sk_buff *skb);
>  static int call_netdevice_notifiers_info(unsigned long val,
> @@ -6286,6 +6287,11 @@ void __napi_schedule(struct napi_struct *n)
>  {
>  	unsigned long flags;
>  
> +	if (test_bit(NAPI_STATE_THREADED, &n->state)) {
> +		queue_work(napi_workq, &n->work);
> +		return;
> +	}
> +


Where is the corresponding cancel_work_sync() or flush_work() at device dismantle ?

Just hoping the thread will eventually run seems optimistic to me.


Quite frankly, I do believe this STATE_THREADED status should be a generic NAPI attribute
that can be changed dynamically, at admin request, instead of having to change/recompile
a driver.


