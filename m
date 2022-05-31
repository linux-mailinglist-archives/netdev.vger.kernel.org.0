Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9E3538A34
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 05:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243682AbiEaD2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 23:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiEaD2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 23:28:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD09F63BDF
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 20:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653967729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y770a0/hYNmJvryM3kMKfKgJmjrlaN2W1vlxnVye7/c=;
        b=Omj3i+g1VFn2E6Th2Qx3k8PJerRh4zpEGpaid0/CNwNW0+HjKZ6BUjU7AFSv6w4hpv8Ne5
        G2VkC4AZN4RLhdG56YMqfh49RCFUyPR/FS3XltJe59W0JbnXoxGqDWa8qQuxS3t1Iv6dG4
        9UoydR4XMzrAAY6+lKTg1vMDCe5IyS4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-3QqpawW4OZW4Niik-wvN1w-1; Mon, 30 May 2022 23:26:47 -0400
X-MC-Unique: 3QqpawW4OZW4Niik-wvN1w-1
Received: by mail-qt1-f200.google.com with SMTP id m18-20020a05622a119200b00304b4e57cbfso2451425qtk.18
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 20:26:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y770a0/hYNmJvryM3kMKfKgJmjrlaN2W1vlxnVye7/c=;
        b=RevjI46ECAtIYnHsiq7/1E1mWVhTw6CmLlx2SOH/q4IJ4H7DyoGnrTsJjQRi/UR8LT
         MbHdFQ1D+hcyXUW5ruPLRhrlOmuJxUVq8YuRA4Pt/GuyfuzbAGzM2fFbnQuI12H/p1hr
         9I+yoRjbwWyErTuctCOPoYwFrXnXc14JMlUZkcBxeWGwmM3B8aH6UkqQ4N9O+GaepboS
         KTUhRbg3kygG9k8D0gLerf9XxXZHdI0rwLBBzUp/KTUwj4XgDFI049PJpOdcouNS5c3Z
         9BiSuqG2GFcpJLzyAM8KoID53Mce8ize6jEDy+oIEhw4J41bHTIo2M1fHRvJt6gedzHI
         HfNA==
X-Gm-Message-State: AOAM530LXov/BnHftO7PcFM7RtYK8tWLge1gE0uolrGhVx3hn5zkWMfP
        1TmwtmhI+KnHhl/kT28Lozg5GKyjtUKEGAnuBWU8NAqUGRMqfrlZTVwOwSCXqSdKDNVKJIeDlsu
        jisalf1GPndtUf1x/
X-Received: by 2002:a05:6214:2267:b0:461:e790:e80f with SMTP id gs7-20020a056214226700b00461e790e80fmr48717792qvb.81.1653967606761;
        Mon, 30 May 2022 20:26:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxje052hCb/dbZXIFUOqnLoRKx7YGal3vwyXrsiTiiVSvwsrquA8wsqzOB5l5O65WuYMa8KbA==
X-Received: by 2002:a05:6214:2267:b0:461:e790:e80f with SMTP id gs7-20020a056214226700b00461e790e80fmr48717778qvb.81.1653967606538;
        Mon, 30 May 2022 20:26:46 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id l3-20020a37f503000000b006a5c0dce590sm8014412qkk.79.2022.05.30.20.26.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 20:26:46 -0700 (PDT)
Message-ID: <85b6e408-6feb-02bf-fb19-bec3fbb419b9@redhat.com>
Date:   Mon, 30 May 2022 23:26:44 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net] bonding: guard ns_targets by CONFIG_IPV6
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220530072142.44809-1-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20220530072142.44809-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/22 03:21, Hangbin Liu wrote:
> Guard ns_targets in struct bond_params by CONFIG_IPV6, which could save
> 256 bytes if IPv6 not configed. Also add this protection for function
> bond_is_ip6_target_ok() and bond_get_targets_ip6().
> 
> Remove the IS_ENABLED() check for bond_opts[] as this will make
> BOND_OPT_NS_TARGETS uninitialized if CONFIG_IPV6 not enabled. Add
> a dummy bond_option_ns_ip6_targets_set() for this situation.
> 
> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>   drivers/net/bonding/bond_main.c    |  2 ++
>   drivers/net/bonding/bond_options.c | 10 ++++++----
>   include/net/bonding.h              |  6 ++++++
>   3 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 3b7baaeae82c..f85372adf042 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -6159,7 +6159,9 @@ static int bond_check_params(struct bond_params *params)
>   		strscpy_pad(params->primary, primary, sizeof(params->primary));
>   
>   	memcpy(params->arp_targets, arp_target, sizeof(arp_target));
> +#if IS_ENABLED(CONFIG_IPV6)
>   	memset(params->ns_targets, 0, sizeof(struct in6_addr) * BOND_MAX_NS_TARGETS);
> +#endif
>   
>   	return 0;
>   }
> diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
> index 64f7db2627ce..a8a0c5a22517 100644
> --- a/drivers/net/bonding/bond_options.c
> +++ b/drivers/net/bonding/bond_options.c
> @@ -34,10 +34,8 @@ static int bond_option_arp_ip_target_add(struct bonding *bond, __be32 target);
>   static int bond_option_arp_ip_target_rem(struct bonding *bond, __be32 target);
>   static int bond_option_arp_ip_targets_set(struct bonding *bond,
>   					  const struct bond_opt_value *newval);
> -#if IS_ENABLED(CONFIG_IPV6)
>   static int bond_option_ns_ip6_targets_set(struct bonding *bond,
>   					  const struct bond_opt_value *newval);
> -#endif
>   static int bond_option_arp_validate_set(struct bonding *bond,
>   					const struct bond_opt_value *newval);
>   static int bond_option_arp_all_targets_set(struct bonding *bond,
> @@ -299,7 +297,6 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
>   		.flags = BOND_OPTFLAG_RAWVAL,
>   		.set = bond_option_arp_ip_targets_set
>   	},
> -#if IS_ENABLED(CONFIG_IPV6)
>   	[BOND_OPT_NS_TARGETS] = {
>   		.id = BOND_OPT_NS_TARGETS,
>   		.name = "ns_ip6_target",
> @@ -307,7 +304,6 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
>   		.flags = BOND_OPTFLAG_RAWVAL,
>   		.set = bond_option_ns_ip6_targets_set
>   	},
> -#endif
>   	[BOND_OPT_DOWNDELAY] = {
>   		.id = BOND_OPT_DOWNDELAY,
>   		.name = "downdelay",
> @@ -1254,6 +1250,12 @@ static int bond_option_ns_ip6_targets_set(struct bonding *bond,
>   
>   	return 0;
>   }
> +#else
> +static int bond_option_ns_ip6_targets_set(struct bonding *bond,
> +					  const struct bond_opt_value *newval)
> +{
> +	return 0;

I would return -EPERM here as the values cannot actually be set. You do 
not want userspace thinking the command was accepted when it actually 
didn't do anything with the values.

> +}
>   #endif
>   
>   static int bond_option_arp_validate_set(struct bonding *bond,
> diff --git a/include/net/bonding.h b/include/net/bonding.h
> index b14f4c0b4e9e..cb904d356e31 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -149,7 +149,9 @@ struct bond_params {
>   	struct reciprocal_value reciprocal_packets_per_slave;
>   	u16 ad_actor_sys_prio;
>   	u16 ad_user_port_key;
> +#if IS_ENABLED(CONFIG_IPV6)
>   	struct in6_addr ns_targets[BOND_MAX_NS_TARGETS];
> +#endif
>   
>   	/* 2 bytes of padding : see ether_addr_equal_64bits() */
>   	u8 ad_actor_system[ETH_ALEN + 2];
> @@ -503,12 +505,14 @@ static inline int bond_is_ip_target_ok(__be32 addr)
>   	return !ipv4_is_lbcast(addr) && !ipv4_is_zeronet(addr);
>   }
>   
> +#if IS_ENABLED(CONFIG_IPV6)
>   static inline int bond_is_ip6_target_ok(struct in6_addr *addr)
>   {
>   	return !ipv6_addr_any(addr) &&
>   	       !ipv6_addr_loopback(addr) &&
>   	       !ipv6_addr_is_multicast(addr);
>   }
> +#endif
>   
>   /* Get the oldest arp which we've received on this slave for bond's
>    * arp_targets.
> @@ -746,6 +750,7 @@ static inline int bond_get_targets_ip(__be32 *targets, __be32 ip)
>   	return -1;
>   }
>   
> +#if IS_ENABLED(CONFIG_IPV6)
>   static inline int bond_get_targets_ip6(struct in6_addr *targets, struct in6_addr *ip)
>   {
>   	int i;
> @@ -758,6 +763,7 @@ static inline int bond_get_targets_ip6(struct in6_addr *targets, struct in6_addr
>   
>   	return -1;
>   }
> +#endif
>   
>   /* exported from bond_main.c */
>   extern unsigned int bond_net_id;

