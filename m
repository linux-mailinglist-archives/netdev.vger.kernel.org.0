Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8BB5BE3A8
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiITKov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiITKo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:44:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E3C6715D
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 03:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663670640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bryd/YqvBscp2y8ehsVjCoNVOvUucCenOquY6lmdqLE=;
        b=UPlzEJJf4gFrlhTDrmO3sq2WxICbnWc9HtDAZN0pnND6VuujN4IAQwDRCOlcgwRDLsfOwj
        3TJeHDupKS0DM1/BIwbSNCL0Fkwaa9j5nNfDS4/iGQM2VwLtLaLp3h0tkaiUNk7BOTPWOt
        lj/cqftEqv5Ada1SMskX8IU/T9VOKkU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-426-nvD_foQONO6LVWgeWsH3yQ-1; Tue, 20 Sep 2022 06:43:59 -0400
X-MC-Unique: nvD_foQONO6LVWgeWsH3yQ-1
Received: by mail-qv1-f69.google.com with SMTP id q5-20020a056214194500b004a03466c568so1680863qvk.19
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 03:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=Bryd/YqvBscp2y8ehsVjCoNVOvUucCenOquY6lmdqLE=;
        b=5FZFR+Kab1YCObCCY826O0kU7cRiKQyYNhQKGkBQ26nI8gX5+LuXTlzKLtHoK1RCsa
         y4KqKl+Nm12rmB3AcXztzpJ+3h65rdTzyPSoSVwOGcpWOTSvsLcp6oeqHN3jDG2rUFir
         YoceMVk13uDx+gjsa0zkD1Ckgw7tmKQO8I0X9jCf3Z5LVyBZi1HO0TR+Xx2niGjP89GJ
         VzFKgUZPGVQ9v9SPtKz4fGVXOHXOZOHMRNbYWA6K+i7KitPW3BPI+1NHkTTuF2PEMuCN
         IVpj1oojkjZqPLF1vAl8Lyl3ZqwJG/4y2n9xKT54yiNVkGJclCU9oOGZeAHQMnLfWCML
         xdKw==
X-Gm-Message-State: ACrzQf1d0YmDcxi+sYNh3M61ngynJVn+qHiO1NmoJImU6Dj0HSqzXZGd
        Mz2hSCWBtJPQ4/5KpMdeaLcOcYin3OsNJMiMUOaQhCdZ82MA5IYUGrn077acPa26EOsc/zsAOyR
        Ia8WOjHTj8bJcidg0
X-Received: by 2002:ad4:5ca2:0:b0:4aa:9d05:2424 with SMTP id q2-20020ad45ca2000000b004aa9d052424mr17937147qvh.71.1663670638672;
        Tue, 20 Sep 2022 03:43:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6Ksp+8em66xjCysoFTBRD+jUUAtxdjlfisN2fuwcZNehJY+I7UeG3BcQTd8r72XLhFC4WzSQ==
X-Received: by 2002:ad4:5ca2:0:b0:4aa:9d05:2424 with SMTP id q2-20020ad45ca2000000b004aa9d052424mr17937131qvh.71.1663670638406;
        Tue, 20 Sep 2022 03:43:58 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-90.dyn.eolo.it. [146.241.114.90])
        by smtp.gmail.com with ESMTPSA id y8-20020a05620a44c800b006ce16588056sm805177qkp.89.2022.09.20.03.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 03:43:57 -0700 (PDT)
Message-ID: <cc46d6ae3bba9dfcc602ac23a32fad9860cb8064.camel@redhat.com>
Subject: Re: [net-next v2 2/3] seg6: add NEXT-C-SID support for SRv6 End
 behavior
From:   Paolo Abeni <pabeni@redhat.com>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Date:   Tue, 20 Sep 2022 12:43:53 +0200
In-Reply-To: <20220912171619.16943-3-andrea.mayer@uniroma2.it>
References: <20220912171619.16943-1-andrea.mayer@uniroma2.it>
         <20220912171619.16943-3-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-09-12 at 19:16 +0200, Andrea Mayer wrote:
> The NEXT-C-SID mechanism described in [1] offers the possibility of
> encoding several SRv6 segments within a single 128 bit SID address. Such
> a SID address is called a Compressed SID (C-SID) container. In this way,
> the length of the SID List can be drastically reduced.
> 
> A SID instantiated with the NEXT-C-SID flavor considers an IPv6 address
> logically structured in three main blocks: i) Locator-Block; ii)
> Locator-Node Function; iii) Argument.
> 
>                         C-SID container
> +------------------------------------------------------------------+
> >     Locator-Block      |Loc-Node|            Argument            |
> >                        |Function|                                |
> +------------------------------------------------------------------+
> <--------- B -----------> <- NF -> <------------- A --------------->
> 
>    (i) The Locator-Block can be any IPv6 prefix available to the provider;
> 
>   (ii) The Locator-Node Function represents the node and the function to
>        be triggered when a packet is received on the node;
> 
>  (iii) The Argument carries the remaining C-SIDs in the current C-SID
>        container.
> 
> The NEXT-C-SID mechanism relies on the "flavors" framework defined in
> [2]. The flavors represent additional operations that can modify or
> extend a subset of the existing behaviors.
> 
> This patch introduces the support for flavors in SRv6 End behavior
> implementing the NEXT-C-SID one. An SRv6 End behavior with NEXT-C-SID
> flavor works as an End behavior but it is capable of processing the
> compressed SID List encoded in C-SID containers.
> 
> An SRv6 End behavior with NEXT-C-SID flavor can be configured to support
> user-provided Locator-Block and Locator-Node Function lengths. In this
> implementation, such lengths must be evenly divisible by 8 (i.e. must be
> byte-aligned), otherwise the kernel informs the user about invalid
> values with a meaningful error code and message through netlink_ext_ack.
> 
> If Locator-Block and/or Locator-Node Function lengths are not provided
> by the user during configuration of an SRv6 End behavior instance with
> NEXT-C-SID flavor, the kernel will choose their default values i.e.,
> 32-bit Locator-Block and 16-bit Locator-Node Function.
> 
> [1] - https://datatracker.ietf.org/doc/html/draft-ietf-spring-srv6-srh-compression
> [2] - https://datatracker.ietf.org/doc/html/rfc8986
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  include/uapi/linux/seg6_local.h |  24 +++
>  net/ipv6/seg6_local.c           | 335 +++++++++++++++++++++++++++++++-
>  2 files changed, 356 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
> index 332b18f318f8..4fdc424c9cb3 100644
> --- a/include/uapi/linux/seg6_local.h
> +++ b/include/uapi/linux/seg6_local.h
> @@ -28,6 +28,7 @@ enum {
>  	SEG6_LOCAL_BPF,
>  	SEG6_LOCAL_VRFTABLE,
>  	SEG6_LOCAL_COUNTERS,
> +	SEG6_LOCAL_FLAVORS,
>  	__SEG6_LOCAL_MAX,
>  };
>  #define SEG6_LOCAL_MAX (__SEG6_LOCAL_MAX - 1)
> @@ -110,4 +111,27 @@ enum {
>  
>  #define SEG6_LOCAL_CNT_MAX (__SEG6_LOCAL_CNT_MAX - 1)
>  
> +/* SRv6 End* Flavor attributes */
> +enum {
> +	SEG6_LOCAL_FLV_UNSPEC,
> +	SEG6_LOCAL_FLV_OPERATION,
> +	SEG6_LOCAL_FLV_LCBLOCK_BITS,
> +	SEG6_LOCAL_FLV_LCNODE_FN_BITS,
> +	__SEG6_LOCAL_FLV_MAX,
> +};
> +
> +#define SEG6_LOCAL_FLV_MAX (__SEG6_LOCAL_FLV_MAX - 1)
> +
> +/* Designed flavor operations for SRv6 End* Behavior */
> +enum {
> +	SEG6_LOCAL_FLV_OP_UNSPEC,
> +	SEG6_LOCAL_FLV_OP_PSP,
> +	SEG6_LOCAL_FLV_OP_USP,
> +	SEG6_LOCAL_FLV_OP_USD,
> +	SEG6_LOCAL_FLV_OP_NEXT_CSID,
> +	__SEG6_LOCAL_FLV_OP_MAX
> +};
> +
> +#define SEG6_LOCAL_FLV_OP_MAX (__SEG6_LOCAL_FLV_OP_MAX - 1)
> +
>  #endif
> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> index f43e6f0baac1..8370726ae7bf 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -73,6 +73,55 @@ struct bpf_lwt_prog {
>  	char *name;
>  };
>  
> +/* default length values (expressed in bits) for both Locator-Block and
> + * Locator-Node Function.
> + *
> + * Both SEG6_LOCAL_LCBLOCK_DBITS and SEG6_LOCAL_LCNODE_FN_DBITS *must* be:
> + *    i) greater than 0;
> + *   ii) evenly divisible by 8. In other terms, the lengths of the
> + *	 Locator-Block and Locator-Node Function must be byte-aligned (we can
> + *	 relax this constraint in the future if really needed).
> + *
> + * Moreover, a third condition must hold:
> + *  iii) SEG6_LOCAL_LCBLOCK_DBITS + SEG6_LOCAL_LCNODE_FN_DBITS <= 128.
> + *
> + * The correctness of SEG6_LOCAL_LCBLOCK_DBITS and SEG6_LOCAL_LCNODE_FN_DBITS
> + * values are checked during the kernel compilation. If the compilation stops,
> + * check the value of these parameters to see if they meet conditions (i), (ii)
> + * and (iii).
> + */
> +#define SEG6_LOCAL_LCBLOCK_DBITS	32
> +#define SEG6_LOCAL_LCNODE_FN_DBITS	16
> +
> +/* The following next_csid_chk_{cntr,lcblock,lcblock_fn}_bits macros can be
> + * used directly to check whether the lengths (in bits) of Locator-Block and
> + * Locator-Node Function are valid according to (i), (ii), (iii).
> + */
> +#define next_csid_chk_cntr_bits(blen, flen)		\
> +	((blen) + (flen) > 128)
> +
> +#define next_csid_chk_lcblock_bits(blen)		\
> +({							\
> +	typeof(blen) __tmp = blen;			\
> +	(!__tmp || __tmp > 120 || (__tmp & 0x07));	\

Just a note to mention that in theory a caller could pass a signed
argument, so the above check does not ensure that __tmp is acutally >=
8.

All the current callers use unsigned arguements, so it still looks
safe. 

Cheers,

Paolo

