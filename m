Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78C854FCC9
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 20:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383118AbiFQSM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 14:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383598AbiFQSMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 14:12:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39245BF67
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 11:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655489561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5sspUYskcXuVf8cdkBBm555pC87bzbh2NJups+WWKi4=;
        b=QqwQv22xVrXoWCAIK6hi6va/foU4Ik8UxVSzKUDU7zhEwVmSH5Oyrud+UpJFS/nbXkXvhN
        fd7Z+08RgGlxHPJMX5qVGPbj6hoFuR72LNRVRK+052TF7cqvhCgsrZtT9aKTQPswgVoqH7
        t4JsLIx9rzwnVX3D1LRJhq5Xzd2V7Kg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-Bey0yaUzNWaxQufSH13rCw-1; Fri, 17 Jun 2022 14:12:38 -0400
X-MC-Unique: Bey0yaUzNWaxQufSH13rCw-1
Received: by mail-qv1-f70.google.com with SMTP id m1-20020a0cf181000000b0046e65e564cfso5548189qvl.17
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 11:12:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5sspUYskcXuVf8cdkBBm555pC87bzbh2NJups+WWKi4=;
        b=L2UI4Jcd9C3mQzjbG79c7bulFjBotAc82Dj0JSNPGptaCxTG6Z/cCaElhKlrzmOBYb
         bdRSoHDZbzwdCI46MjxG1+3HEIzlWHiAAJixgfu9GuUraC9jCAkVb0PHjFhOhcV8NfQC
         KiJxSBiJvU47KyR1BW/iSDAfc7dDuU2PkxJlFAcSopvCPbS51p5vC9AD4Cf7BEdAJ6w1
         JWy5Lhj6ikJZWoOkbqeTXLJDFUyOtOJQaKY1glAI1ZRnqjyZFLcnI0pefUySi/GSRBHk
         BZgBmdNXuG1RhICxBNHAoqSD4UBsKkfSJzJJA/rnJvwULCCgK32+mSim7sqbAaJRPCWw
         hyJg==
X-Gm-Message-State: AJIora+h5Sa0g0Gs7tePvfjKgtLZvFpjT5Q5fet2P/PnxiY8GJAgEla9
        EioyqpGCu3Mba/XakJfcEcWMpzAP+Owd/uqd3sdE5GvT244Oz/uDXZZF9pCxrGOQnDiljNQb42H
        jtMWtIcF9YkvBHRUT
X-Received: by 2002:ad4:5ba1:0:b0:46e:2f1f:9836 with SMTP id 1-20020ad45ba1000000b0046e2f1f9836mr9511793qvq.87.1655489557449;
        Fri, 17 Jun 2022 11:12:37 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sX316/awVTFKMtS8Cfi9piECtahkRJkLMb5GkdmzsBKxK4o67UZwSY/rHQIicQOX8Q0bItGA==
X-Received: by 2002:ad4:5ba1:0:b0:46e:2f1f:9836 with SMTP id 1-20020ad45ba1000000b0046e2f1f9836mr9511766qvq.87.1655489557108;
        Fri, 17 Jun 2022 11:12:37 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id u12-20020a37ab0c000000b006a34a22bc60sm4657047qke.9.2022.06.17.11.12.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 11:12:36 -0700 (PDT)
Message-ID: <be1629bc-26c2-12d3-45b3-f18d7abead4c@redhat.com>
Date:   Fri, 17 Jun 2022 14:12:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCHv2 net-next] Bonding: add per-port priority for failover
 re-selection
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
References: <20220615032934.2057120-1-liuhangbin@gmail.com>
 <c5d45c3f-065d-c8e7-fcc6-4cdb54bfdd70@redhat.com>
 <YqqcPcXO8rlM52jJ@Laptop-X1> <Yqw1iheXg0fT3QcU@Laptop-X1>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <Yqw1iheXg0fT3QcU@Laptop-X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/22 04:04, Hangbin Liu wrote:
> On Thu, Jun 16, 2022 at 10:58:12AM +0800, Hangbin Liu wrote:
>>>> @@ -157,6 +162,20 @@ static int bond_slave_changelink(struct net_device *bond_dev,
>>>>    			return err;
>>>>    	}
>>>> +	if (data[IFLA_BOND_SLAVE_PRIO]) { > +		int prio = nla_get_s32(data[IFLA_BOND_SLAVE_PRIO]);
>>>> +		char prio_str[IFNAMSIZ + 7];
>>>> +
>>>> +		/* prio option setting expects slave_name:prio */
>>>> +		snprintf(prio_str, sizeof(prio_str), "%s:%d\n",
>>>> +			 slave_dev->name, prio);
>>>> +
>>>> +		bond_opt_initstr(&newval, prio_str);
>>>
>>> It might be less code and a little cleaner to extend struct bond_opt_value
>>> with a slave pointer.
>>>
>>> 	struct bond_opt_value {
>>> 		char *string;
>>> 		u64 value;
>>> 		u32 flags;
>>> 		union {
>>> 			char cextra[BOND_OPT_EXTRA_MAXLEN];
>>> 			struct net_device *slave_dev;
>>> 		} extra;
>>> 	};
>>>
>>> Then modify __bond_opt_init to set the slave pointer, basically a set of
>>> bond_opt_slave_init{} macros. This would remove the need to parse the slave
>>> interface name in the set function. Setting .flags = BOND_OPTFLAG_RAWVAL
>>> (already done I see) in the option definition to avoid bond_opt_parse() from
>>> loosing our extra information by pointing to a .values table entry. Now in
>>> the option specific set function we can just find the slave entry and set
>>> the value, no more string parsing code needed.
>>
>> This looks reasonable to me. It would make all slave options setting easier
>> for future usage.
> 
> Hi Jan, Jay,
> 
> I have updated the slave option setting like the following. I didn't add
> a extra name for the union, so we don't need to edit the existing code. I think
> the slave_dev should be safe as it's protected by rtnl lock. But I'm
> not sure if I missed anything. Do you think if it's OK to store/get slave_dev
> pointer like this?
> 
> diff --git a/include/net/bond_options.h b/include/net/bond_options.h
> index 1618b76f4903..f65be547a73d 100644
> --- a/include/net/bond_options.h
> +++ b/include/net/bond_options.h
> @@ -83,7 +83,10 @@ struct bond_opt_value {
>   	char *string;
>   	u64 value;
>   	u32 flags;
> -	char extra[BOND_OPT_EXTRA_MAXLEN];
> +	union {
> +		char extra[BOND_OPT_EXTRA_MAXLEN];
> +		struct net_device *slave_dev;
> +	};
>   };
>   
>   struct bonding;
> @@ -133,13 +136,16 @@ static inline void __bond_opt_init(struct bond_opt_value *optval,
>   		optval->value = value;
>   	else if (string)
>   		optval->string = string;
> -	else if (extra_len <= BOND_OPT_EXTRA_MAXLEN)
> +
> +	if (extra && extra_len <= BOND_OPT_EXTRA_MAXLEN)
>   		memcpy(optval->extra, extra, extra_len); >   }
>   #define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value, NULL, 0)
>   #define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX, NULL, 0)
>   #define bond_opt_initextra(optval, extra, extra_len) \
>   	__bond_opt_init(optval, NULL, ULLONG_MAX, extra, extra_len)
> +#define bond_opt_initslave(optval, value, slave_dev) \
> +	__bond_opt_init(optval, NULL, value, slave_dev, sizeof(struct net_device *))

To keep the naming consistent with the other helpers I would have chosen:

#define bond_opt_slave_initval(optval, slave_dev, value) \

>   
>   void bond_option_arp_ip_targets_clear(struct bonding *bond);
>   #if IS_ENABLED(CONFIG_IPV6)
> 
> 

[...]

The rest looks good to me.

-Jon

