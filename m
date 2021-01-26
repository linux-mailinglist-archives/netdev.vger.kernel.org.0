Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D769303513
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387853AbhAZFef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:34:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730116AbhAZBoT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 20:44:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20C86206A4;
        Tue, 26 Jan 2021 01:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611625413;
        bh=a8W3qU1Zr0uT1o2n9VdtMfnAnrKn7JRz32Oko3cj4+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lkB0smJ5zyTpD2ia/1aS1C14Jh9CGiU2l1k59vUwP7e287jJCc+XCT3DSJTO6o9cH
         EoD1pE7w7cGKGc5b7BOvIW7dLfwsG15UivbRQ1ZFI5Rj/117da2Z0nu0ZbKcPvC6Fb
         RlG6PgOY2GB30CL2YiWNy1q5m/LG1frjG8bijGBk8xD+tvS3Fqvk9YvGvxdGoYvpEW
         P6rwhek+H4h6tuLvcWNZflSnnYTS2JejJdmh+RrHQM7yTgDiwFSK81//MdVPhntUbl
         F/sY9i65osxXFF1z/E3b5y4txfyyGM6quwHokaPDwzzVsG3qzqQtBc459bxLcQo3u+
         lOBcGIH5gaxcA==
Date:   Mon, 25 Jan 2021 17:43:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     netdev@vger.kernel.org,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next 1/4] netlink: truncate overlength attribute
 list in nla_nest_end()
Message-ID: <20210125174332.52beeb9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123045321.2797360-2-edwin.peer@broadcom.com>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
        <20210123045321.2797360-2-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 20:53:18 -0800 Edwin Peer wrote:
> If a nested list of attributes is too long, then the length will
> exceed the 16-bit nla_len of the parent nlattr. In such cases,
> determine how many whole attributes can fit and truncate the
> message to this length. This properly maintains the nesting
> hierarchy, keeping the entire message valid, while fitting more
> subelements inside the nest range than may result if the length
> is wrapped modulo 64KB.
> 
> Marking truncated attributes, such that user space can determine
> the precise attribute truncated, by means of an additional bit in
> the nla_type was considered and rejected. The NLA_F_NESTED and
> NLA_F_NET_BYTEORDER flags are supposed to be mutually exclusive.
> So, in theory, the latter bit could have been redefined for nested
> attributes in order to indicate truncation, but user space tools
> (most notably iproute2) cannot be relied on to honor NLA_TYPE_MASK,
> resulting in alteration of the perceived nla_type and subsequent
> catastrophic failure.
> 
> Failing the entire message with a hard error must also be rejected,
> as this would break existing user space functionality. The trigger
> issue is evident for IFLA_VFINFO_LIST and a hard error here would
> cause iproute2 to fail to render an entire interface list even if
> only a single interface warranted a truncated VF list. Instead, set
> NLM_F_NEST_TRUNCATED in the netlink header to inform user space
> about the incomplete data. In this particular case, however, user
> space can better ascertain which instance is truncated by consulting
> the associated IFLA_NUM_VF to determine how many VFs were expected.
> 
> Fixes: bfa83a9e03cf ("[NETLINK]: Type-safe netlink messages/attributes interface")
> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>


> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index 1ceec518ab49..fc8c57dafb05 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -1785,19 +1785,26 @@ static inline struct nlattr *nla_nest_start(struct sk_buff *skb, int attrtype)
>  	return nla_nest_start_noflag(skb, attrtype | NLA_F_NESTED);
>  }
>  
> +int __nla_nest_trunc_msg(struct sk_buff *skb, const struct nlattr *start);
> +
>  /**
>   * nla_nest_end - Finalize nesting of attributes
>   * @skb: socket buffer the attributes are stored in
>   * @start: container attribute
>   *
>   * Corrects the container attribute header to include the all
> - * appeneded attributes.
> + * appeneded attributes. The list of attributes will be truncated
> + * if too long to fit within the parent attribute's maximum reach.
>   *
>   * Returns the total data length of the skb.
>   */
>  static inline int nla_nest_end(struct sk_buff *skb, struct nlattr *start)

What are the semantics for multiple nests? All attrs down will always
have the trunc flag set? Because I'd have expected the skb_tail to be
trimmed in __nla_nest_trunc_msg()..

In fact if there is another nest around the "full" one, and the "full"
one is close to 0xffff wouldn't that end up cascading all the way down
to the outermost attr yielding an empty top level attr? I feel like we
cater to a specific use case here where that doesn't happen.

After initially being concerned about using up another flag, I warmed
up to the concept of NLM_F_NEST_TRUNCATED, but I think this is all
better driven by the writer. The writer knows the size and count of the
attrs because it sizes the skb. So can the writer not drive the
truncation? Add a "how much space do we have left" check in
rtnl_fill_vf() ?

This would also avoid the assumption that the contents of the nla are
other nlas.

>  {
> -	start->nla_len = skb_tail_pointer(skb) - (unsigned char *)start;
> +	int len = skb_tail_pointer(skb) - (unsigned char *)start;
> +
> +	if (len > 0xffff)
> +		len = __nla_nest_trunc_msg(skb, start);
> +	start->nla_len = len;
>  	return skb->len;

This function really needs to start returning an error on overflow.
Perhaps even with a WARN(). 

Could you please check how many callers we'd need to change to have
nla_nest_end() have the same semantics as nla_put() (i.e. 0 or -errno)?
On a quick scan I see that most cases only care about errors already.

>  }
>  
> diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
> index 3d94269bbfa8..44a250825c30 100644
> --- a/include/uapi/linux/netlink.h
> +++ b/include/uapi/linux/netlink.h
> @@ -57,6 +57,7 @@ struct nlmsghdr {
>  #define NLM_F_ECHO		0x08	/* Echo this request 		*/
>  #define NLM_F_DUMP_INTR		0x10	/* Dump was inconsistent due to sequence change */
>  #define NLM_F_DUMP_FILTERED	0x20	/* Dump was filtered as requested */
> +#define NLM_F_NEST_TRUNCATED	0x40	/* Message contains truncated nested attribute */
>  
>  /* Modifiers to GET request */
>  #define NLM_F_ROOT	0x100	/* specify tree	root	*/
> diff --git a/lib/nlattr.c b/lib/nlattr.c
> index 5b6116e81f9f..2a267c0d3e16 100644
> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c
> @@ -1119,4 +1119,31 @@ int nla_append(struct sk_buff *skb, int attrlen, const void *data)
>  	return 0;
>  }
>  EXPORT_SYMBOL(nla_append);
> +
> +/**
> + * __nla_nest_trunc_msg - Truncate list of nested netlink attributes to max len
> + * @skb: socket buffer with tail pointer positioned after end of nested list
> + * @start: container attribute designating the beginning of the list
> + *
> + * Trims the skb to fit only the attributes which are within the range of the
> + * containing nest attribute. This is a helper for nla_nest_end, to prevent
> + * adding unduly to the length of what is an inline function. It is not
> + * intended to be called from anywhere else.
> + *
> + * Returns the truncated length of the enclosing nest attribute in accordance
> + * with the number of whole attributes that can fit.
> + */
> +int __nla_nest_trunc_msg(struct sk_buff *skb, const struct nlattr *start)
> +{
> +	struct nlattr *attr = nla_data(start);
> +	int rem = 0xffff - NLA_HDRLEN;
> +
> +	while (nla_ok(attr, rem))
> +		attr = nla_next(attr, &rem);
> +	nlmsg_trim(skb, attr);
> +	nlmsg_hdr(skb)->nlmsg_flags |= NLM_F_NEST_TRUNCATED;
> +	return (unsigned char *)attr - (unsigned char *)start;
> +}
> +EXPORT_SYMBOL(__nla_nest_trunc_msg);
> +
>  #endif

