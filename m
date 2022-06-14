Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7591B54AED7
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240313AbiFNKwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356177AbiFNKwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:52:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C17E128E3A
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 03:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655203969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j6gazAF8piShvjhu9GHiZkjcHCEjeubkkEpP4stsUJ8=;
        b=aAJDIWFRimcb96XVBog2qp+QSBLjE9f8N+svYbEcPnnAnVWyMK1oQ3sP/wM+QLM9E6zoKq
        gHUsBODzRlTSnohf0ES8eI4JtstyEk/AVCIH9Cha6CmEnzmEgfBX6sTn7r5ZJ3GLiBixLV
        ccL3YzQ8hqN1KxD9GKAQ/xbkGDN4oLA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-aoUR4vQiPd-NgDSkmcd76Q-1; Tue, 14 Jun 2022 06:52:48 -0400
X-MC-Unique: aoUR4vQiPd-NgDSkmcd76Q-1
Received: by mail-qv1-f69.google.com with SMTP id r14-20020ad4576e000000b0046bbacd783bso5673711qvx.14
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 03:52:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=j6gazAF8piShvjhu9GHiZkjcHCEjeubkkEpP4stsUJ8=;
        b=J1baVoO7wxSuIelaoNcn0Vyms/YJ4nJvg5PeQVRPDeq7CstdFJoYtX0zw4pEQQGa88
         fMFR9WZA85FNAw5pn9GfbrfnSUJYwx3QFllTSp8ktaNmX7RkOhkfZ1isdI3xrSZvg+ih
         z6gT3KXh44HTl6ZkHibGMlIiwurnLB99g+sv7j+rInmCFGjIISMhR9pCBioACmKQ3PWn
         oWQvHeJSMBXUg2Djx868EkVgvdGdROT4bZ1juFmbDDh8mQq7rd5l7lmQS6DHPZeibL2q
         UDdaGvaE+XzdCsf+285Vv6HzlIvyamXT9GDkpM7RZXnzQTRhYA0NYC0Oq5s/8mzHiUrt
         imMw==
X-Gm-Message-State: AOAM531dpwe1rz6lZbCligp96/KOnaODvtDY/l6Q2v2LSEiHQ+JIRfLk
        u3stleutV0ajZ9aaqOi5vo4+xMS9T1UzMY0mm1wHfN5LW98FsKqCOvZzb8o5pGlve0damfS7zzy
        5QT09utGvtxSxSmvk
X-Received: by 2002:a05:620a:bc5:b0:6a6:4dbd:b6c2 with SMTP id s5-20020a05620a0bc500b006a64dbdb6c2mr3361223qki.383.1655203967352;
        Tue, 14 Jun 2022 03:52:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPhS0Dx5pR6eFdvrUGU4zCQozA0/d8rAY4zE7tmAo2S9BGY51+Nr0YZl76FInraeW014HZVg==
X-Received: by 2002:a05:620a:bc5:b0:6a6:4dbd:b6c2 with SMTP id s5-20020a05620a0bc500b006a64dbdb6c2mr3361212qki.383.1655203966964;
        Tue, 14 Jun 2022 03:52:46 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id p6-20020a05622a048600b00304de7561a8sm7447520qtx.27.2022.06.14.03.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 03:52:46 -0700 (PDT)
Message-ID: <3c8d69d321e1465be9482285581622fe9947f112.camel@redhat.com>
Subject: Re: [net-next v1 2/2] seg6: add NEXT-C-SID support for SRv6 End
 behavior
From:   Paolo Abeni <pabeni@redhat.com>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Date:   Tue, 14 Jun 2022 12:52:42 +0200
In-Reply-To: <20220611104750.2724-3-andrea.mayer@uniroma2.it>
References: <20220611104750.2724-1-andrea.mayer@uniroma2.it>
         <20220611104750.2724-3-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-06-11 at 12:47 +0200, Andrea Mayer wrote:
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
>  net/ipv6/seg6_local.c           | 311 +++++++++++++++++++++++++++++++-
>  2 files changed, 332 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
> index 332b18f318f8..7919940c84d0 100644
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
> +	SEG6_LOCAL_FLV_LCBLOCK_LEN,
> +	SEG6_LOCAL_FLV_LCNODE_FN_LEN,
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
> index 5ea51ee2ef71..eb31c6c838e3 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -73,6 +73,39 @@ struct bpf_lwt_prog {
>  	char *name;
>  };
>  
> +/* default length values (expressed in bits) for both Locator-Block and
> + * Locator-Node Function.
> + *
> + * Both SEG6_LOCAL_LCBLOCK_DLEN and SEG6_LOCAL_LCNODE_FN_DLEN *must* be:
> + *    i) greater than 0;
> + *   ii) evenly divisible by 8. In other terms, the lengths of the
> + *	 Locator-Block and Locator-Node Function must be byte-aligned (we can
> + *	 relax this constraint in the future if really needed).
> + *
> + * Moreover, a third condition must hold:
> + *  iii) SEG6_LOCAL_LCBLOCK_DLEN + SEG6_LOCAL_LCNODE_FN_DLEN <= 128.
> + *
> + * The correctness of SEG6_LOCAL_LCBLOCK_DLEN and SEG6_LOCAL_LCNODE_FN_DLEN
> + * values are checked during the kernel compilation. If the compilation stops,
> + * check the value of these parameters to see if they meet conditions (i), (ii)
> + * and (iii).
> + */
> +#define SEG6_LOCAL_LCBLOCK_DLEN		32
> +#define SEG6_LOCAL_LCNODE_FN_DLEN	16
> +
> +/* Supported Flavor operations are reported in this bitmask */
> +#define SEG6_LOCAL_FLV_SUPP_OPS	(BIT(SEG6_LOCAL_FLV_OP_NEXT_CSID))
> +
> +struct seg6_flavors_info {
> +	/* Flavor operations */
> +	__u32 flv_ops;
> +
> +	/* Locator-Block length, expressed in bits */
> +	__u8 lcblock_len;
> +	/* Locator-Node Function length, expressed in bits*/
> +	__u8 lcnode_func_len;

IMHO the above names are misleading. I suggest to use a '_bits' suffix
instead.

> +};
> +
>  enum seg6_end_dt_mode {
>  	DT_INVALID_MODE	= -EINVAL,
>  	DT_LEGACY_MODE	= 0,
> @@ -136,6 +169,8 @@ struct seg6_local_lwt {
>  #ifdef CONFIG_NET_L3_MASTER_DEV
>  	struct seg6_end_dt_info dt_info;
>  #endif
> +	struct seg6_flavors_info flv_info;
> +
>  	struct pcpu_seg6_local_counters __percpu *pcpu_counters;
>  
>  	int headroom;
> @@ -270,8 +305,50 @@ int seg6_lookup_nexthop(struct sk_buff *skb,
>  	return seg6_lookup_any_nexthop(skb, nhaddr, tbl_id, false);
>  }
>  
> -/* regular endpoint function */
> -static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> +static __u8 seg6_flv_lcblock_octects(const struct seg6_flavors_info *finfo)
> +{
> +	return finfo->lcblock_len >> 3;
> +}
> +
> +static __u8 seg6_flv_lcnode_func_octects(const struct seg6_flavors_info *finfo)
> +{
> +	return finfo->lcnode_func_len >> 3;
> +}
> +
> +static bool seg6_next_csid_is_arg_zero(const struct in6_addr *addr,
> +				       const struct seg6_flavors_info *finfo)
> +{
> +	__u8 fnc_octects = seg6_flv_lcnode_func_octects(finfo);
> +	__u8 blk_octects = seg6_flv_lcblock_octects(finfo);
> +	__u8 arg_octects;
> +	int i;
> +
> +	arg_octects = 16 - blk_octects - fnc_octects;
> +	for (i = 0; i < arg_octects; ++i) {
> +		if (addr->s6_addr[blk_octects + fnc_octects + i] != 0x00)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +/* assume that DA.Argument length > 0 */
> +static void seg6_next_csid_advance_arg(struct in6_addr *addr,
> +				       const struct seg6_flavors_info *finfo)
> +{
> +	__u8 fnc_octects = seg6_flv_lcnode_func_octects(finfo);
> +	__u8 blk_octects = seg6_flv_lcblock_octects(finfo);
> +
> +	/* advance DA.Argument */
> +	memmove((void *)&addr->s6_addr[blk_octects],
> +		(const void *)&addr->s6_addr[blk_octects + fnc_octects],
> +		16 - blk_octects - fnc_octects);

The void cast should not be needed

> +
> +	memset((void *)&addr->s6_addr[16 - fnc_octects], 0x00, fnc_octects);

Same here.

> +}
> +
> +static int input_action_end_core(struct sk_buff *skb,
> +				 struct seg6_local_lwt *slwt)
>  {
>  	struct ipv6_sr_hdr *srh;
>  
> @@ -290,6 +367,38 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
>  	return -EINVAL;
>  }
>  
> +static int end_next_csid_core(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> +{
> +	const struct seg6_flavors_info *finfo = &slwt->flv_info;
> +	struct in6_addr *daddr = &ipv6_hdr(skb)->daddr;
> +
> +	if (seg6_next_csid_is_arg_zero(daddr, finfo))
> +		return input_action_end_core(skb, slwt);
> +
> +	/* update DA */
> +	seg6_next_csid_advance_arg(daddr, finfo);
> +
> +	seg6_lookup_nexthop(skb, NULL, 0);
> +
> +	return dst_input(skb);
> +}
> +
> +static bool seg6_next_csid_enabled(__u32 fops)
> +{
> +	return fops & BIT(SEG6_LOCAL_FLV_OP_NEXT_CSID);
> +}
> +
> +/* regular endpoint function */
> +static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> +{
> +	const struct seg6_flavors_info *finfo = &slwt->flv_info;
> +
> +	if (seg6_next_csid_enabled(finfo->flv_ops))
> +		return end_next_csid_core(skb, slwt);
> +
> +	return input_action_end_core(skb, slwt);
> +}
> +
>  /* regular endpoint, and forward to specified nexthop */
>  static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
>  {
> @@ -952,7 +1061,8 @@ static struct seg6_action_desc seg6_action_table[] = {
>  	{
>  		.action		= SEG6_LOCAL_ACTION_END,
>  		.attrs		= 0,
> -		.optattrs	= SEG6_F_LOCAL_COUNTERS,
> +		.optattrs	= SEG6_F_LOCAL_COUNTERS |
> +				  SEG6_F_ATTR(SEG6_LOCAL_FLAVORS),
>  		.input		= input_action_end,
>  	},
>  	{
> @@ -1133,6 +1243,7 @@ static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
>  	[SEG6_LOCAL_OIF]	= { .type = NLA_U32 },
>  	[SEG6_LOCAL_BPF]	= { .type = NLA_NESTED },
>  	[SEG6_LOCAL_COUNTERS]	= { .type = NLA_NESTED },
> +	[SEG6_LOCAL_FLAVORS]	= { .type = NLA_NESTED },
>  };
>  
>  static int parse_nla_srh(struct nlattr **attrs, struct seg6_local_lwt *slwt,
> @@ -1552,6 +1663,190 @@ static void destroy_attr_counters(struct seg6_local_lwt *slwt)
>  	free_percpu(slwt->pcpu_counters);
>  }
>  
> +static const
> +struct nla_policy seg6_local_flavors_policy[SEG6_LOCAL_FLV_MAX + 1] = {
> +	[SEG6_LOCAL_FLV_OPERATION]	= { .type = NLA_U32 },
> +	[SEG6_LOCAL_FLV_LCBLOCK_LEN]	= { .type = NLA_U8 },
> +	[SEG6_LOCAL_FLV_LCNODE_FN_LEN]	= { .type = NLA_U8 },
> +};
> +
> +/* check whether the lengths of the Locator-Block and Locator-Node Function
> + * are compatible with the dimension of a C-SID container.
> + */
> +static int seg6_chk_next_csid_cfg(__u8 block_len, __u8 func_len)
> +{
> +	/* Locator-Block and Locator-Node Function cannot exceed 128 bits */
> +	if (block_len + func_len > 128)
> +		return -EINVAL;
> +
> +	/* Locator-Block length must be greater than zero and evenly divisible
> +	 * by 8. There must be room for a Locator-Node Function, at least.
> +	 */
> +	if (block_len < 8 || block_len > 120 || (block_len & 0x07))

The 'block_len < 8' part is not needed, since you later check the 3
less significant bits can't be set and this is an unsigned number.

> +		return -EINVAL;
> +
> +	/* Locator-Node Function length must be greater than zero and evenly
> +	 * divisible by 8. There must be room for the Locator-Block.
> +	 */
> +	if (func_len < 8 || func_len > 120 || (func_len & 0x07))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int seg6_parse_nla_next_csid_cfg(struct nlattr **tb,
> +					struct seg6_flavors_info *finfo,
> +					struct netlink_ext_ack *extack)
> +{
> +	__u8 func_len = SEG6_LOCAL_LCNODE_FN_DLEN;
> +	__u8 block_len = SEG6_LOCAL_LCBLOCK_DLEN;
> +	int rc;
> +
> +	if (tb[SEG6_LOCAL_FLV_LCBLOCK_LEN])
> +		block_len = nla_get_u8(tb[SEG6_LOCAL_FLV_LCBLOCK_LEN]);
> +
> +	if (tb[SEG6_LOCAL_FLV_LCNODE_FN_LEN])
> +		func_len = nla_get_u8(tb[SEG6_LOCAL_FLV_LCNODE_FN_LEN]);
> +
> +	rc = seg6_chk_next_csid_cfg(block_len, func_len);
> +	if (rc < 0) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Invalid Locator Block/Node Function lengths");
> +		return rc;
> +	}
> +
> +	finfo->lcblock_len = block_len;
> +	finfo->lcnode_func_len = func_len;
> +
> +	return 0;
> +}
> +
> +static int parse_nla_flavors(struct nlattr **attrs, struct seg6_local_lwt *slwt,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct seg6_flavors_info *finfo = &slwt->flv_info;
> +	struct nlattr *tb[SEG6_LOCAL_FLV_MAX + 1];
> +	unsigned long fops;
> +	int rc;
> +
> +	rc = nla_parse_nested_deprecated(tb, SEG6_LOCAL_FLV_MAX,
> +					 attrs[SEG6_LOCAL_FLAVORS],
> +					 seg6_local_flavors_policy, NULL);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* this attribute MUST always be present since it represents the Flavor
> +	 * operation(s) to carry out.
> +	 */
> +	if (!tb[SEG6_LOCAL_FLV_OPERATION])
> +		return -EINVAL;
> +
> +	fops = nla_get_u32(tb[SEG6_LOCAL_FLV_OPERATION]);
> +	if (~SEG6_LOCAL_FLV_SUPP_OPS & fops) {

Please avoid 'yoda-style' syntax. The compilar warnings will catch the
eventual mistakes this is supposed to avoid, and the conventional
syntax is more readable.

> +		NL_SET_ERR_MSG(extack, "Unsupported Flavor operation(s)");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	finfo->flv_ops = fops;
> +
> +	if (seg6_next_csid_enabled(fops)) {
> +		/* Locator-Block and Locator-Node Function lengths can be
> +		 * provided by the user space. If not, default values are going
> +		 * to be applied.
> +		 */
> +		rc = seg6_parse_nla_next_csid_cfg(tb, finfo, extack);
> +		if (rc < 0)
> +			return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +static int seg6_fill_nla_next_csid_cfg(struct sk_buff *skb,
> +				       struct seg6_flavors_info *finfo)
> +{
> +	if (nla_put_u8(skb, SEG6_LOCAL_FLV_LCBLOCK_LEN, finfo->lcblock_len))
> +		return -EMSGSIZE;
> +
> +	if (nla_put_u8(skb, SEG6_LOCAL_FLV_LCNODE_FN_LEN,
> +		       finfo->lcnode_func_len))
> +		return -EMSGSIZE;
> +
> +	return 0;
> +}
> +
> +static int put_nla_flavors(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> +{
> +	struct seg6_flavors_info *finfo = &slwt->flv_info;
> +	__u32 fops = finfo->flv_ops;
> +	struct nlattr *nest;
> +	int rc;
> +
> +	nest = nla_nest_start(skb, SEG6_LOCAL_FLAVORS);
> +	if (!nest)
> +		return -EMSGSIZE;
> +
> +	if (nla_put_u32(skb, SEG6_LOCAL_FLV_OPERATION, fops)) {
> +		rc = -EMSGSIZE;
> +		goto err;
> +	}
> +
> +	if (seg6_next_csid_enabled(fops)) {
> +		rc = seg6_fill_nla_next_csid_cfg(skb, finfo);
> +		if (rc < 0)
> +			goto err;
> +	}
> +
> +	return nla_nest_end(skb, nest);
> +
> +err:
> +	nla_nest_cancel(skb, nest);
> +	return rc;
> +}
> +
> +static int seg6_cmp_nla_next_csid_cfg(struct seg6_flavors_info *finfo_a,
> +				      struct seg6_flavors_info *finfo_b)
> +{
> +	if (finfo_a->lcblock_len != finfo_b->lcblock_len)
> +		return 1;
> +
> +	if (finfo_a->lcnode_func_len != finfo_b->lcnode_func_len)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static int cmp_nla_flavors(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
> +{
> +	struct seg6_flavors_info *finfo_a = &a->flv_info;
> +	struct seg6_flavors_info *finfo_b = &b->flv_info;
> +
> +	if (finfo_a->flv_ops != finfo_b->flv_ops)
> +		return 1;
> +
> +	if (seg6_next_csid_enabled(finfo_a->flv_ops)) {
> +		if (seg6_cmp_nla_next_csid_cfg(finfo_a, finfo_b))
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int encap_size_flavors(struct seg6_local_lwt *slwt)
> +{
> +	struct seg6_flavors_info *finfo = &slwt->flv_info;
> +	int nlsize;
> +
> +	nlsize = nla_total_size(0) +	/* nest SEG6_LOCAL_FLAVORS */
> +		 nla_total_size(4);	/* SEG6_LOCAL_FLV_OPERATION */
> +
> +	if (seg6_next_csid_enabled(finfo->flv_ops))
> +		nlsize += nla_total_size(1) + /* SEG6_LOCAL_FLV_LCBLOCK_LEN */
> +			  nla_total_size(1);  /* SEG6_LOCAL_FLV_LCNODE_FN_LEN */
> +
> +	return nlsize;
> +}
> +
>  struct seg6_action_param {
>  	int (*parse)(struct nlattr **attrs, struct seg6_local_lwt *slwt,
>  		     struct netlink_ext_ack *extack);
> @@ -1604,6 +1899,10 @@ static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
>  				    .put = put_nla_counters,
>  				    .cmp = cmp_nla_counters,
>  				    .destroy = destroy_attr_counters },
> +
> +	[SEG6_LOCAL_FLAVORS]	= { .parse = parse_nla_flavors,
> +				    .put = put_nla_flavors,
> +				    .cmp = cmp_nla_flavors },
>  };
>  
>  /* call the destroy() callback (if available) for each set attribute in
> @@ -1917,6 +2216,9 @@ static int seg6_local_get_encap_size(struct lwtunnel_state *lwt)
>  			  /* SEG6_LOCAL_CNT_ERRORS */
>  			  nla_total_size_64bit(sizeof(__u64));
>  
> +	if (attrs & SEG6_F_ATTR(SEG6_LOCAL_FLAVORS))
> +		nlsize += encap_size_flavors(slwt);
> +
>  	return nlsize;
>  }
>  
> @@ -1972,6 +2274,9 @@ int __init seg6_local_init(void)
>  	 */
>  	BUILD_BUG_ON(SEG6_LOCAL_MAX + 1 > BITS_PER_TYPE(unsigned long));
>  
> +	BUILD_BUG_ON(seg6_chk_next_csid_cfg(SEG6_LOCAL_LCBLOCK_DLEN,
> +					    SEG6_LOCAL_LCNODE_FN_DLEN) != 0);
> +

It looks like you are asking too much to the compiler with the above.
You can possibly resort open code the relevant test here.

It would be great if you could add some self-tests on top of the
iproute2 support.

Thanks!

Paolo

