Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F524FE3A9
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 16:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356240AbiDLOZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 10:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiDLOZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 10:25:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B9E24D61B
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 07:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649773412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2soxPWxXyaINu5B/5pU6gaFeRFwpH5RybjuFL45PFc8=;
        b=LWmr6tVBj5VP0bqT9njSjpMYgctZDj9RwV5f8p1WH+gFEI4DyF5oUYOYu7gjBJSDQpAotk
        LNVb9axCoxzgegI+IOWzx34c9GqbT45CSeRxjW2ly9mK4BQ/8kOtkglzd8ziJD7iRNKZId
        uikjxhsdwo377FKzC6zQv6S8GR8XLm4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-5PG3ojlNM2236rdkcKmr_g-1; Tue, 12 Apr 2022 10:23:31 -0400
X-MC-Unique: 5PG3ojlNM2236rdkcKmr_g-1
Received: by mail-qt1-f198.google.com with SMTP id m20-20020a05622a119400b002ef68184e7fso3008138qtk.15
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 07:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2soxPWxXyaINu5B/5pU6gaFeRFwpH5RybjuFL45PFc8=;
        b=MijlRu4xd5HT1s1JaJ+Ke72TK8unwrb0nTpUgfESvvTWuo/0yrtp/fAjaAFKjO1l1/
         EmbzKNA76CmeCf5OLFOceW0yki4aYlqcFKnvIejwX3cCE87X9xQPAZDQxVSYgErfd3t4
         KeuqbFa4RfZX+RuD/BUCl84bynB0AuAz+BORp9YADxG3+/SgJvC+bKyaOxIHf1jX6h/v
         iQlSKGzgm8pw/CvqxIBMUjwbpmQeOCNt1YKXGeU0AyXBnsPaPufAycZJAaRdTxvT/hBK
         efDT3kYu0oAnEQGXJIhsHRqpQme33JziZ9U8iUANelGw+sWg3g7MtSsfKVeKI1/Y1cnN
         LezA==
X-Gm-Message-State: AOAM533LLUMy4mm4YyLhm+shQXAQBam2qKoDv+KoLd30hTMPP42lfHUQ
        d9pFTE84KnrzIXSQokaBOAh4JLgOJ/8A2Qi5FWPZ0EzwqAH8WNrPkYZmCdYlAp6KlBFxUL9DlsJ
        zbeUxigH2bDvLfDSX
X-Received: by 2002:a05:620a:f0e:b0:699:c94e:1413 with SMTP id v14-20020a05620a0f0e00b00699c94e1413mr3237614qkl.282.1649773409545;
        Tue, 12 Apr 2022 07:23:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMhikLKMz5Z+QktsEKoXbImM5z/1w9fvPEVJZ4MxqJxa5kSAbUu8CBlIbuArOzNaEk0yeKtA==
X-Received: by 2002:a05:620a:f0e:b0:699:c94e:1413 with SMTP id v14-20020a05620a0f0e00b00699c94e1413mr3237596qkl.282.1649773409246;
        Tue, 12 Apr 2022 07:23:29 -0700 (PDT)
Received: from [192.168.98.18] ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id t7-20020a05622a01c700b002e1b3555c2fsm26772462qtw.26.2022.04.12.07.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 07:23:28 -0700 (PDT)
Message-ID: <1d6de134-c14e-4170-d2ad-873db62d8275@redhat.com>
Date:   Tue, 12 Apr 2022 10:23:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next] Bonding: add per port priority support
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220412041322.2409558-1-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20220412041322.2409558-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/22 00:13, Hangbin Liu wrote:
> Add per port priority support for bonding. A higher number means higher
> priority. The primary slave still has the highest priority. This option
> also follows the primary_reselect rules.
> 
> This option could only be configured via netlink.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>   Documentation/networking/bonding.rst |  9 +++++++++
>   drivers/net/bonding/bond_main.c      | 27 +++++++++++++++++++++++++++
>   drivers/net/bonding/bond_netlink.c   | 12 ++++++++++++
>   include/net/bonding.h                |  1 +
>   include/uapi/linux/if_link.h         |  1 +
>   tools/include/uapi/linux/if_link.h   |  1 +
>   6 files changed, 51 insertions(+)
> 
> diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> index 525e6842dd33..103e292a04a1 100644
> --- a/Documentation/networking/bonding.rst
> +++ b/Documentation/networking/bonding.rst
> @@ -780,6 +780,15 @@ peer_notif_delay
>   	value is 0 which means to match the value of the link monitor
>   	interval.
>   
> +prio
> +	Slave priority. A higher number means higher priority.
> +	The primary slave has the highest priority. This option also
> +	follows the primary_reselect rules.
> +
> +	This option could only be configured via netlink, and is only valid
                     ^^ can
> +	for active-backup(1), balance-tlb (5) and balance-alb (6) mode.
> +	The default value is 0.
> +
>   primary
>   
>   	A string (eth0, eth2, etc) specifying which slave is the
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 15eddca7b4b6..4211b79ac619 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1026,12 +1026,38 @@ static void bond_do_fail_over_mac(struct bonding *bond,
>   
>   }
>   
> +/**
> + * bond_choose_primary_or_current - select the primary or high priority slave
> + * @bond: our bonding struct
> + *
> + * - Check if there is a primary link. If the primary link was set and is up,
> + *   go on and do link reselection.
> + *
> + * - If primary link is not set or down, find the highest priority link.
> + *   If the highest priority link is not current slave, set it as primary
> + *   link and do link reselection.
> + */
>   static struct slave *bond_choose_primary_or_current(struct bonding *bond)
>   {
>   	struct slave *prim = rtnl_dereference(bond->primary_slave);
>   	struct slave *curr = rtnl_dereference(bond->curr_active_slave);
> +	struct slave *slave, *hprio = NULL;
> +	struct list_head *iter;
>   
>   	if (!prim || prim->link != BOND_LINK_UP) {
> +		bond_for_each_slave(bond, slave, iter) {
> +			if (slave->link == BOND_LINK_UP) {
> +				hprio = hprio ? hprio : slave;
> +				if (slave->prio > hprio->prio)
> +					hprio = slave;
> +			}
> +		}
> +
> +		if (hprio && hprio != curr) {
> +			prim = hprio;
> +			goto link_reselect;
> +		}
> +
>   		if (!curr || curr->link != BOND_LINK_UP)
>   			return NULL;
>   		return curr;
> @@ -1042,6 +1068,7 @@ static struct slave *bond_choose_primary_or_current(struct bonding *bond)
>   		return prim;
>   	}
>   
> +link_reselect:
>   	if (!curr || curr->link != BOND_LINK_UP)
>   		return prim;
>   
> diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
> index f427fa1737c7..63066559e7d6 100644
> --- a/drivers/net/bonding/bond_netlink.c
> +++ b/drivers/net/bonding/bond_netlink.c
> @@ -27,6 +27,7 @@ static size_t bond_get_slave_size(const struct net_device *bond_dev,
>   		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_AGGREGATOR_ID */
>   		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE */
>   		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE */
> +		nla_total_size(sizeof(s32)) +	/* IFLA_BOND_SLAVE_PRIO */
>   		0;
>   }
>   
> @@ -53,6 +54,9 @@ static int bond_fill_slave_info(struct sk_buff *skb,
>   	if (nla_put_u16(skb, IFLA_BOND_SLAVE_QUEUE_ID, slave->queue_id))
>   		goto nla_put_failure;
>   
> +	if (nla_put_s32(skb, IFLA_BOND_SLAVE_PRIO, slave->prio))
> +		goto nla_put_failure;
> +
>   	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
>   		const struct aggregator *agg;
>   		const struct port *ad_port;
> @@ -117,6 +121,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
>   
>   static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
>   	[IFLA_BOND_SLAVE_QUEUE_ID]	= { .type = NLA_U16 },
> +	[IFLA_BOND_SLAVE_PRIO]		= { .type = NLA_S32 },
>   };
>   
>   static int bond_validate(struct nlattr *tb[], struct nlattr *data[],
> @@ -136,6 +141,7 @@ static int bond_slave_changelink(struct net_device *bond_dev,
>   				 struct nlattr *tb[], struct nlattr *data[],
>   				 struct netlink_ext_ack *extack)
>   {
> +	struct slave *slave = bond_slave_get_rtnl(slave_dev);
>   	struct bonding *bond = netdev_priv(bond_dev);
>   	struct bond_opt_value newval;
>   	int err;
> @@ -156,6 +162,12 @@ static int bond_slave_changelink(struct net_device *bond_dev,
>   			return err;
>   	}
>   
> +	/* No need to bother __bond_opt_set as we only support netlink config */

Not sure this comment is necessary, it doesn't add any value. Also I 
would recommend using bonding's options management, as it would allow 
for checking if the value is in a defined range. That might not be 
particularly useful in this context since it appears +/-INT_MAX is the 
range.

Also, in the Documentation it is mentioned that this parameter is only 
used in modes active-backup and balance-alb/tlb. Do we need to send an 
error message back preventing the modification of this value when not in 
these modes?

> +	if (data[IFLA_BOND_SLAVE_PRIO]) {
> +		slave->prio = nla_get_s32(data[IFLA_BOND_SLAVE_PRIO]);
> +		bond_select_active_slave(bond);
> +	}
> +
>   	return 0;
>   }
>   
> diff --git a/include/net/bonding.h b/include/net/bonding.h
> index b14f4c0b4e9e..4ff093fb2289 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -176,6 +176,7 @@ struct slave {
>   	u32    speed;
>   	u16    queue_id;
>   	u8     perm_hwaddr[MAX_ADDR_LEN];
> +	int    prio;

Do we want a struct slave_params here instead? That would allow us to 
define defaults in a central place and set them once instead of setting 
each parameter.

>   	struct ad_slave_info *ad_info;
>   	struct tlb_slave_info tlb_info;
>   #ifdef CONFIG_NET_POLL_CONTROLLER
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index cc284c048e69..204e342b107a 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -956,6 +956,7 @@ enum {
>   	IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
>   	IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE,
>   	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
> +	IFLA_BOND_SLAVE_PRIO,
>   	__IFLA_BOND_SLAVE_MAX,
>   };
>   
> diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
> index e1ba2d51b717..ee5de9f3700b 100644
> --- a/tools/include/uapi/linux/if_link.h
> +++ b/tools/include/uapi/linux/if_link.h
> @@ -888,6 +888,7 @@ enum {
>   	IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
>   	IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE,
>   	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
> +	IFLA_BOND_SLAVE_PRIO,
>   	__IFLA_BOND_SLAVE_MAX,
>   };
>   

