Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162BB6CF19D
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjC2SBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjC2SBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:01:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0AE5B8E
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680112806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Ex4qAQI8jFlphiortwiuaSdJ0uJRftZB4Xwk8I+YtM=;
        b=fnzEz/lvPml2noUYqxyGU29sEma3xslLqfsd45E8Fvvpi8ibdpeiDY8LDDj+b4zDuSZJMt
        PrVrf6cVm21FcIv/4dyxnC1tnKTB4t9QdbqKvv8SXkBrafdwmJJj9u8dw7S7i27k1SDV+0
        UXoKtAE8/t8CosvDBkCIeR4spo184Y4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-XxdWceW-NGKGcFDbgMUrXQ-1; Wed, 29 Mar 2023 14:00:02 -0400
X-MC-Unique: XxdWceW-NGKGcFDbgMUrXQ-1
Received: by mail-ed1-f69.google.com with SMTP id a40-20020a509eab000000b005024c025bf4so11135146edf.14
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:00:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680112801;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Ex4qAQI8jFlphiortwiuaSdJ0uJRftZB4Xwk8I+YtM=;
        b=eQ+u8fbqRDL4YGBMRIKWPpGzK2zWjcwJIjbFEVUkgPrpzUuQTZLdulLnL0pez0cuw8
         VCbEforprPGXokrYdsvE16pXlug9yk5HLgpnydezyVRfTNUDk8lM35GtTV90ichUwtH6
         sRRo6t96dOhdZRw6xOipEgfeOEUDzbkMUMfk7wimFcXCCsvI0C0OmFkYuMd+w/m1qeKK
         5syAX2mRk2mXNSY2Yp7M6NCHCYl+1PxfCDGlaWFOOp8yznuDyGGxeO9PPoPsegDkt4r6
         K5uwMHk0YQS43sXb2FN1FjUCkAmBY2aMU8n/nSx6qrCP/AdrfvwMDkGB2nGEDhzt/NyG
         r2+g==
X-Gm-Message-State: AAQBX9dMzqSQk56aFSb0OsJLnnwzlvwS0heiKVRWYl3tlhmYiNiPqZ69
        lVJMb7cS2fnOymDKtwSYqXgMj9jgc+aPXyNqjlMEki0TyhZ0LyrfBiTLsAjpP/tWe01eibxt+HC
        Wrl3e4ExlGiHWwK6wbS6PLTY5
X-Received: by 2002:a05:6402:1841:b0:4fc:782c:dca3 with SMTP id v1-20020a056402184100b004fc782cdca3mr20131450edy.28.1680112801220;
        Wed, 29 Mar 2023 11:00:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y43ETxBXALjoHl1MnyGSZbIV9TyYcmvZo2zPeWa/8U1bkANiEzdQlN1uO708Vi3zg4Z4PtFg==
X-Received: by 2002:a05:6402:1841:b0:4fc:782c:dca3 with SMTP id v1-20020a056402184100b004fc782cdca3mr20131432edy.28.1680112800940;
        Wed, 29 Mar 2023 11:00:00 -0700 (PDT)
Received: from [192.168.42.100] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id u2-20020a50a402000000b004c4eed3fe20sm17426270edb.5.2023.03.29.10.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 11:00:00 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <e0363f67-34d9-103f-eac7-e3ab71f87c0b@redhat.com>
Date:   Wed, 29 Mar 2023 19:59:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH bpf RFC-V2 1/5] xdp: rss hash types representation
Content-Language: en-US
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>
References: <168010726310.3039990.2753040700813178259.stgit@firesoul>
 <168010734324.3039990.16454026957159811204.stgit@firesoul>
In-Reply-To: <168010734324.3039990.16454026957159811204.stgit@firesoul>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/03/2023 18.29, Jesper Dangaard Brouer wrote:
> The RSS hash type specifies what portion of packet data NIC hardware used
> when calculating RSS hash value. The RSS types are focused on Internet
> traffic protocols at OSI layers L3 and L4. L2 (e.g. ARP) often get hash
> value zero and no RSS type. For L3 focused on IPv4 vs. IPv6, and L4
> primarily TCP vs UDP, but some hardware supports SCTP.
> 
> Hardware RSS types are differently encoded for each hardware NIC. Most
> hardware represent RSS hash type as a number. Determining L3 vs L4 often
> requires a mapping table as there often isn't a pattern or sorting
> according to ISO layer.
> 
> The patch introduce a XDP RSS hash type (xdp_rss_hash_type) that can both
> be seen as a number that is ordered according by ISO layer, and can be bit
> masked to separate IPv4 and IPv6 types for L4 protocols. Room is available
> for extending later while keeping these properties. This maps and unifies
> difference to hardware specific hashes.
> 
> This proposal change the kfunc API bpf_xdp_metadata_rx_hash() to return
> this RSS hash type on success.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   include/net/xdp.h |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   net/core/xdp.c    |    4 ++-
>   2 files changed, 79 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 5393b3ebe56e..1b2b17625c26 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -8,6 +8,7 @@
>   
>   #include <linux/skbuff.h> /* skb_shared_info */
>   #include <uapi/linux/netdev.h>
> +#include <linux/bitfield.h>
>   
>   /**
>    * DOC: XDP RX-queue information
> @@ -396,6 +397,81 @@ XDP_METADATA_KFUNC_xxx
>   MAX_XDP_METADATA_KFUNC,
>   };
>   
> +/* For partitioning of xdp_rss_hash_type */
> +#define RSS_L3		GENMASK(2,0) /* 3-bits = values between 1-7 */
> +#define L4_BIT		BIT(3)       /* 1-bit - L4 indication */
> +#define RSS_L4_IPV4	GENMASK(6,4) /* 3-bits */
> +#define RSS_L4_IPV6	GENMASK(9,7) /* 3-bits */
> +#define RSS_L4		GENMASK(9,3) /* = 7-bits - covering L4 IPV4+IPV6 */
> +#define L4_IPV6_EX_BIT	BIT(9)       /* 1-bit - L4 IPv6 with Extension hdr */
> +				     /* 11-bits in total */

Please ignore above lines in review ... they should have been deleted,
the new partitioning uses the enum/defines below.

> +
> +/* Lower 4-bits value of xdp_rss_hash_type */
> +enum xdp_rss_L4 {
> +	XDP_RSS_L4_MASK		= GENMASK(3,0), /* 4-bits = values between 0-15 */
> +	XDP_RSS_L4_NONE		= 0, /* Not L4 based hash */
> +	XDP_RSS_L4_ANY		= 1, /* L4 based hash but protocol unknown */
> +	XDP_RSS_L4_TCP		= 2,
> +	XDP_RSS_L4_UDP		= 3,
> +	XDP_RSS_L4_SCTP		= 4,
> +	XDP_RSS_L4_IPSEC	= 5, /* L4 based hash include IPSEC SPI */
> +/*
> + RFC: We don't care about vasting space, then we could just store the
> + protocol number (8-bits) directly. See /etc/protocols
> +	XDP_RSS_L4_TCP		= 6,
> +	XDP_RSS_L4_UDP		= 17,
> +	XDP_RSS_L4_SCTP		= 132,
> +	XDP_RSS_L4_IPSEC_ESP	= 50, // Issue: mlx5 didn't say ESP or AH
> +	XDP_RSS_L4_IPSEC_AH	= 51, // both ESP+AH just include SPI in hash
> + */
> +};
> +
> +/* Values shifted for use in xdp_rss_hash_type */
> +enum xdp_rss_L3 {
> +	XDP_RSS_L3_MASK		= GENMASK(5,4), /* 2-bits = values between 1-3 */
> +	XDP_RSS_L3_IPV4		= FIELD_PREP_CONST(XDP_RSS_L3_MASK, 1),
> +	XDP_RSS_L3_IPV6		= FIELD_PREP_CONST(XDP_RSS_L3_MASK, 2),
> +};
> +
> +/* Bits shifted for use in xdp_rss_hash_type */
> +enum xdp_rss_bit {
> +	XDP_RSS_BIT_MASK	= GENMASK(7,6), /* 2-bits */
> +	/* IPv6 Extension Hdr */
> +	XDP_RSS_BIT_EX = FIELD_PREP_CONST(XDP_RSS_BIT_MASK, BIT(0)),
> +	/* XDP_RSS_BIT_VLAN ??? = FIELD_PREP_CONST(XDP_RSS_BIT_MASK, BIT(1)), */
> +};
> +
> +/* RSS hash type combinations used for driver HW mapping */
> +enum xdp_rss_hash_type {
> +	XDP_RSS_TYPE_NONE            = 0,
> +	XDP_RSS_TYPE_L2              = XDP_RSS_TYPE_NONE,
> +
> +	XDP_RSS_TYPE_L3_MASK         = XDP_RSS_L3_MASK,
> +	XDP_RSS_TYPE_L3_IPV4         = XDP_RSS_L3_IPV4,
> +	XDP_RSS_TYPE_L3_IPV6         = XDP_RSS_L3_IPV6,
> +	XDP_RSS_TYPE_L3_IPV6_EX      = XDP_RSS_L3_IPV6 | XDP_RSS_BIT_EX,
> +
> +	XDP_RSS_TYPE_L4_MASK         = XDP_RSS_L4_MASK,
> +	XDP_RSS_TYPE_L4_ANY          = XDP_RSS_L4_ANY,
> +	XDP_RSS_TYPE_L4_IPV4_TCP     = XDP_RSS_L3_IPV4 | XDP_RSS_L4_TCP,
> +	XDP_RSS_TYPE_L4_IPV4_UDP     = XDP_RSS_L3_IPV4 | XDP_RSS_L4_UDP,
> +	XDP_RSS_TYPE_L4_IPV4_SCTP    = XDP_RSS_L3_IPV4 | XDP_RSS_L4_SCTP,
> +
> +	XDP_RSS_TYPE_L4_IPV6_TCP     = XDP_RSS_L3_IPV6 | XDP_RSS_L4_TCP,
> +	XDP_RSS_TYPE_L4_IPV6_UDP     = XDP_RSS_L3_IPV6 | XDP_RSS_L4_UDP,
> +	XDP_RSS_TYPE_L4_IPV6_SCTP    = XDP_RSS_L3_IPV6 | XDP_RSS_L4_UDP,
> +
> +	XDP_RSS_TYPE_L4_IPV6_TCP_EX  = XDP_RSS_TYPE_L4_IPV6_TCP |XDP_RSS_BIT_EX,
> +	XDP_RSS_TYPE_L4_IPV6_UDP_EX  = XDP_RSS_TYPE_L4_IPV6_UDP |XDP_RSS_BIT_EX,
> +	XDP_RSS_TYPE_L4_IPV6_SCTP_EX = XDP_RSS_TYPE_L4_IPV6_SCTP|XDP_RSS_BIT_EX,
> +};
> +#undef RSS_L3
> +#undef L4_BIT
> +#undef RSS_L4_IPV4
> +#undef RSS_L4_IPV6
> +#undef RSS_L4
> +#undef L4_IPV6_EX_BIT

All the undef's are also unncecessary now.

> +
>   #ifdef CONFIG_NET
>   u32 bpf_xdp_metadata_kfunc_id(int id);
>   bool bpf_dev_bound_kfunc_id(u32 btf_id);
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 7133017bcd74..81d41df30695 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -721,12 +721,14 @@ __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *tim
>    * @hash: Return value pointer.
>    *
>    * Return:
> - * * Returns 0 on success or ``-errno`` on error.
> + * * Returns (positive) RSS hash **type** on success or ``-errno`` on error.
> + * * ``enum xdp_rss_hash_type`` : RSS hash type
>    * * ``-EOPNOTSUPP`` : means device driver doesn't implement kfunc
>    * * ``-ENODATA``    : means no RX-hash available for this frame
>    */
>   __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash)
>   {
> +	BTF_TYPE_EMIT(enum xdp_rss_hash_type);
>   	return -EOPNOTSUPP;
>   }
>   
> 
> 

