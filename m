Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86798603396
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 21:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiJRTy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 15:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiJRTyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 15:54:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CF888A13;
        Tue, 18 Oct 2022 12:54:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DA7161586;
        Tue, 18 Oct 2022 19:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5A9C4314C;
        Tue, 18 Oct 2022 19:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666122839;
        bh=vDB8q/VMJw7D6QQWvyPmzdybESiDa4Iha52O2dpBgLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BPb9SLHGatsCRgoDJr8bSZeGbYCKsgGrfWZxx9BJWueBTd/jbQPU9guGzqQ3XhhMu
         z6+KMnUTmmO9qHQSO0SNFIOpfVKiYR8fk/VNhgdY+w+3NHe1dlvl8OsZNKsHYrEeue
         3yJ43YlM6DsNiJD7OQOd4hVcF29v8Mic0LcmRU5t1rBFbANAMIvJas3Ft5KYLYV2St
         tkePV4iHf4CGlA4yuKC+S2ns/mWhTcAdbFjpEp/xwoJaFegXJuLexd8jIUEDBi7erc
         HggmCu77G0+n05Tb6jpYhXIWZ8NL9GVCMD11UvDyND7r2cnsLN8DQloWBKQpkqPHUp
         LiOVBoas28T6A==
Date:   Tue, 18 Oct 2022 12:53:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 6/6] netlink: add universal 'bigint'
 attribute type
Message-ID: <20221018125358.34bc1a32@kernel.org>
In-Reply-To: <20221018140027.48086-7-alexandr.lobakin@intel.com>
References: <20221018140027.48086-1-alexandr.lobakin@intel.com>
        <20221018140027.48086-7-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 16:00:27 +0200 Alexander Lobakin wrote:
> @@ -235,12 +236,15 @@ enum nla_policy_validation {
>   *                         given type fits, using it verifies minimum length
>   *                         just like "All other"
>   *    NLA_BITFIELD32       Unused
> + *    NLA_BIGINT           Number of bits in the big integer

Should we say "Max number...", otherwise someone may think that user
must match this exactly, since other members specify if it's max or min.

>   *    NLA_REJECT           Unused
>   *    All other            Minimum length of attribute payload
>   *
>   * Meaning of validation union:
>   *    NLA_BITFIELD32       This is a 32-bit bitmap/bitselector attribute and
>   *                         `bitfield32_valid' is the u32 value of valid flags
> + *    NLA_BIGINT           `bigint_mask` is a pointer to the mask of the valid
> + *                         bits of the given bigint to perform the validation.
>   *    NLA_REJECT           This attribute is always rejected and `reject_message'
>   *                         may point to a string to report as the error instead
>   *                         of the generic one in extended ACK.
> @@ -327,6 +331,7 @@ struct nla_policy {
>  			s16 min, max;
>  			u8 network_byte_order:1;
>  		};
> +		const unsigned long *bigint_mask;

kdoc missing

Can we pretend this is an UINT type and reuse the existing validation
types (enum nla_policy_validation)? This way simple cases (<= 32bit
mask, small min/max values) can be defined quite trivially in-place
and things will only get complicated for people who actually need their
values to grow.

>  		int (*validate)(const struct nlattr *attr,
>  				struct netlink_ext_ack *extack);
>  		/* This entry is special, and used for the attribute at index 0
> @@ -451,6 +456,35 @@ struct nla_policy {
>  }
>  #define NLA_POLICY_MIN_LEN(_len)	NLA_POLICY_MIN(NLA_BINARY, _len)
>  
> +/**
> + * NLA_POLICY_BIGINT - represent &nla_policy for a bigint attribute
> + * @nbits - number of bits in the bigint
> + * @... - optional pointer to a bitmap carrying a mask of supported bits
> + */
> +#define NLA_POLICY_BIGINT(nbits, ...) {					\
> +	.type = NLA_BIGINT,						\
> +	.len = (nbits),							\
> +	.bigint_mask =							\
> +		(typeof((__VA_ARGS__ + 0) ? : NULL))(__VA_ARGS__ + 0),	\
> +	.validation_type = (__VA_ARGS__ + 0) ? NLA_VALIDATE_MASK : 0,	\
> +}
> +
> +/* Simplify (and encourage) using the bigint type to send scalars */
> +#define NLA_POLICY_BIGINT_TYPE(type, ...)				\
> +	NLA_POLICY_BIGINT(BITS_PER_TYPE(type), ##__VA_ARGS__)
> +
> +#define NLA_POLICY_BIGINT_U8		NLA_POLICY_BIGINT_TYPE(u8)
> +#define NLA_POLICY_BIGINT_U16		NLA_POLICY_BIGINT_TYPE(u16)
> +#define NLA_POLICY_BIGINT_U32		NLA_POLICY_BIGINT_TYPE(u32)
> +#define NLA_POLICY_BIGINT_U64		NLA_POLICY_BIGINT_TYPE(u64)

Yes, these seem confusing to me. What I was expecting was that user
would say:

	[FAMILY_A_HATCHET]        = NLA_POLICY_MASK(NLA_BIGINT,	HATCHET_BITS),

So very close to existing U8/16/32/64 policies. Inversely your new
mask pointer should be reusable with NLA_U64.

> +/* Transparent alias (for readability purposes) */
> +#define NLA_POLICY_BITMAP(nbits, ...)					\
> +	NLA_POLICY_BIGINT((nbits), ##__VA_ARGS__)
> +
> +#define nla_policy_bigint_mask(pt)	((pt)->bigint_mask)
> +#define nla_policy_bigint_nbits(pt)	((pt)->len)
> +
>  /**
>   * struct nl_info - netlink source information
>   * @nlh: Netlink message header of original request
> @@ -1556,6 +1590,28 @@ static inline int nla_put_bitfield32(struct sk_buff *skb, int attrtype,
>  	return nla_put(skb, attrtype, sizeof(tmp), &tmp);
>  }
>  
> +/**
> + * nla_put_bigint - Add a bigint Netlink attribute to a socket buffer
> + * @skb: socket buffer to add attribute to
> + * @attrtype: attribute type
> + * @bigint: bigint to put, as array of unsigned longs
> + * @nbits: number of bits in the bigint
> + */
> +static inline int nla_put_bigint(struct sk_buff *skb, int attrtype,
> +				 const unsigned long *bigint,
> +				 size_t nbits)
> +{
> +	struct nlattr *nla;
> +
> +	nla = nla_reserve(skb, attrtype, bitmap_arr32_size(nbits));
> +	if (unlikely(!nla))
> +		return -EMSGSIZE;
> +
> +	bitmap_to_arr32(nla_data(nla), bigint, nbits);
> +
> +	return 0;
> +}
> +
>  /**
>   * nla_get_u32 - return payload of u32 attribute
>   * @nla: u32 netlink attribute
> @@ -1749,6 +1805,134 @@ static inline struct nla_bitfield32 nla_get_bitfield32(const struct nlattr *nla)
>  	return tmp;
>  }
>  
> +/**
> + * nla_get_bigint - Return a bigint from u32-array bigint Netlink attribute
> + * @nla: %NLA_BIGINT Netlink attribute
> + * @bigint: target container, as array of unsigned longs
> + * @nbits: expected number of bits in the bigint
> + */
> +static inline void nla_get_bigint(const struct nlattr *nla,
> +				  unsigned long *bigint,
> +				  size_t nbits)
> +{
> +	size_t diff = BITS_TO_LONGS(nbits);
> +
> +	/* Core validated nla_len() is (n + 1) * sizeof(u32), leave a hint */
> +	nbits = clamp_t(size_t, BYTES_TO_BITS(nla_len(nla)),
> +			BITS_PER_TYPE(u32), nbits);
> +	bitmap_from_arr32(bigint, nla_data(nla), nbits);
> +
> +	diff -= BITS_TO_LONGS(nbits);
> +	memset(bigint + BITS_TO_LONGS(nbits), 0, diff * sizeof(long));
> +}
> +
> +/* The macros below build the following set of functions, allowing to
> + * easily use the %NLA_BIGINT API to send scalar values. Their fake
> + * declarations are provided under #if 0, so that source code indexers
> + * could build references to them.
> + */

How many of those do we _actually_ need? Can we codegen them with a
simple script and make it a separate file?

> +#if 0
> +int nla_put_bigint_s8(struct sk_buff *skb, int attrtype, __s8 value);

Any chance we can shorten the names?

	nla_put_s8bi()?

Netlink code already has crazy long lines :S

> +__s8 nla_get_bigint_s8(const struct nlattr *nla);
> +int nla_put_bigint_s16(struct sk_buff *skb, int attrtype, __s16 value);
> +__s16 nla_get_bigint_s16(const struct nlattr *nla);
> +int nla_put_bigint_s32(struct sk_buff *skb, int attrtype, __s32 value);
> +__s32 nla_get_bigint_s32(const struct nlattr *nla);
> +int nla_put_bigint_s64(struct sk_buff *skb, int attrtype, __s64 value);
> +__s64 nla_get_bigint_s64(const struct nlattr *nla);
> +

>  static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
>  			      const struct nla_policy *policy,
>  			      struct netlink_ext_ack *extack,
> @@ -365,6 +392,8 @@ static int nla_validate_mask(const struct nla_policy *pt,
>  	case NLA_U64:
>  		value = nla_get_u64(nla);
>  		break;
> +	case NLA_BIGINT:
> +		return nla_validate_bigint_mask(pt, nla, extack);

I'd think that if someone wants NLA_VALIDATE_MASK they must mean the
32bit in place mask from the policy, not the big one via the pointer.

>  	default:
>  		return -EINVAL;
>  	}
> @@ -445,6 +474,15 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
>  			goto out_err;
>  		break;
>  
> +	case NLA_BIGINT:
> +		if (!bitmap_validate_arr32(nla_data(nla), nla_len(nla),
> +					   nla_policy_bigint_nbits(pt))) {

And here I would not make the assumption that bigint must mean mask
validation.

If the range validation is requested with the in-policy values we
should convert to a small scalar and make sure the top bits are 0.
IOW punt on u128+ for now.

> +			err = -EINVAL;
> +			goto out_err;
> +		}
> +
> +		break;
> +

Very good stuff, the validation vs type separation is the big question.
