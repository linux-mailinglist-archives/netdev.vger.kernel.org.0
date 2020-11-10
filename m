Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA842AE3AC
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732429AbgKJWuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:50:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731981AbgKJWuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 17:50:23 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF5D52076E;
        Tue, 10 Nov 2020 22:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605048622;
        bh=Zkjo0/Wuk/Kqi5o9mQjGlsLXqHmHaUp2Dh+TASGGorA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QXbFdj3ZIgWaVu9npA3/iMUu5LgWhqIECdjqphQ6myBgSQoJ+IJ0l0ax+HUZ8wyF3
         YAkU4gry0N2u0uz2ol1CzcGsO1pG0mkJUGW7So4CpJ0NzM9+qoqogtu3w/hkB9H0GP
         MQ+aVm/6bEEjau2xdp/ByEM/SHpOz37E7AhkCQTo=
Date:   Tue, 10 Nov 2020 14:50:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [net-next,v2,2/5] seg6: improve management of behavior
 attributes
Message-ID: <20201110145021.761f5ee7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107153139.3552-3-andrea.mayer@uniroma2.it>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
        <20201107153139.3552-3-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Nov 2020 16:31:36 +0100 Andrea Mayer wrote:
> Depending on the attribute (i.e.: SEG6_LOCAL_SRH, SEG6_LOCAL_TABLE, etc),
> the parse() callback performs some validity checks on the provided input
> and updates the tunnel state (slwt) with the result of the parsing
> operation. However, an attribute may also need to reserve some additional
> resources (i.e.: memory or setting up an eBPF program) in the parse()
> callback to complete the parsing operation.

Looks good, a few nit picks below.

> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> index eba23279912d..63a82e2fdea9 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -710,6 +710,12 @@ static int cmp_nla_srh(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
>  	return memcmp(a->srh, b->srh, len);
>  }
>  
> +static void destroy_attr_srh(struct seg6_local_lwt *slwt)
> +{
> +	kfree(slwt->srh);
> +	slwt->srh = NULL;

This should never be called twice, right? No need for defensive
programming then.

> +}
> +
>  static int parse_nla_table(struct nlattr **attrs, struct seg6_local_lwt *slwt)
>  {
>  	slwt->table = nla_get_u32(attrs[SEG6_LOCAL_TABLE]);
> @@ -901,16 +907,33 @@ static int cmp_nla_bpf(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
>  	return strcmp(a->bpf.name, b->bpf.name);
>  }
>  
> +static void destroy_attr_bpf(struct seg6_local_lwt *slwt)
> +{
> +	kfree(slwt->bpf.name);
> +	if (slwt->bpf.prog)
> +		bpf_prog_put(slwt->bpf.prog);

Same - why check if prog is NULL? That doesn't seem necessary if the
code is correct.

> +	slwt->bpf.name = NULL;
> +	slwt->bpf.prog = NULL;
> +}
> +
>  struct seg6_action_param {
>  	int (*parse)(struct nlattr **attrs, struct seg6_local_lwt *slwt);
>  	int (*put)(struct sk_buff *skb, struct seg6_local_lwt *slwt);
>  	int (*cmp)(struct seg6_local_lwt *a, struct seg6_local_lwt *b);
> +
> +	/* optional destroy() callback useful for releasing resources which
> +	 * have been previously acquired in the corresponding parse()
> +	 * function.
> +	 */
> +	void (*destroy)(struct seg6_local_lwt *slwt);
>  };
>  
>  static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
>  	[SEG6_LOCAL_SRH]	= { .parse = parse_nla_srh,
>  				    .put = put_nla_srh,
> -				    .cmp = cmp_nla_srh },
> +				    .cmp = cmp_nla_srh,
> +				    .destroy = destroy_attr_srh },
>  
>  	[SEG6_LOCAL_TABLE]	= { .parse = parse_nla_table,
>  				    .put = put_nla_table,
> @@ -934,13 +957,68 @@ static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
>  
>  	[SEG6_LOCAL_BPF]	= { .parse = parse_nla_bpf,
>  				    .put = put_nla_bpf,
> -				    .cmp = cmp_nla_bpf },
> +				    .cmp = cmp_nla_bpf,
> +				    .destroy = destroy_attr_bpf },
>  
>  };
>  
> +/* call the destroy() callback (if available) for each set attribute in
> + * @parsed_attrs, starting from attribute index @start up to @end excluded.
> + */
> +static void __destroy_attrs(unsigned long parsed_attrs, int start, int end,

You always pass 0 as start, no need for that argument.

slwt and max_parsed should be the only args this function needs.

> +			    struct seg6_local_lwt *slwt)
> +{
> +	struct seg6_action_param *param;
> +	int i;
> +
> +	/* Every seg6local attribute is identified by an ID which is encoded as
> +	 * a flag (i.e: 1 << ID) in the @parsed_attrs bitmask; such bitmask
> +	 * keeps track of the attributes parsed so far.
> +
> +	 * We scan the @parsed_attrs bitmask, starting from the attribute
> +	 * identified by @start up to the attribute identified by @end
> +	 * excluded. For each set attribute, we retrieve the corresponding
> +	 * destroy() callback.
> +	 * If the callback is not available, then we skip to the next
> +	 * attribute; otherwise, we call the destroy() callback.
> +	 */
> +	for (i = start; i < end; ++i) {
> +		if (!(parsed_attrs & (1 << i)))
> +			continue;
> +
> +		param = &seg6_action_params[i];
> +
> +		if (param->destroy)
> +			param->destroy(slwt);
> +	}
> +}
> +
> +/* release all the resources that may have been acquired during parsing
> + * operations.
> + */
> +static void destroy_attrs(struct seg6_local_lwt *slwt)
> +{
> +	struct seg6_action_desc *desc;
> +	unsigned long attrs;
> +
> +	desc = slwt->desc;
> +	if (!desc) {
> +		WARN_ONCE(1,
> +			  "seg6local: seg6_action_desc* for action %d is NULL",
> +			  slwt->action);
> +		return;
> +	}

Defensive programming?

> +
> +	/* get the attributes for the current behavior instance */
> +	attrs = desc->attrs;
> +
> +	__destroy_attrs(attrs, 0, SEG6_LOCAL_MAX + 1, slwt);
> +}
> +
>  static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
>  {
>  	struct seg6_action_param *param;
> +	unsigned long parsed_attrs = 0;
>  	struct seg6_action_desc *desc;
>  	int i, err;
>  
> @@ -963,11 +1041,22 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
>  
>  			err = param->parse(attrs, slwt);
>  			if (err < 0)
> -				return err;
> +				goto parse_err;
> +
> +			/* current attribute has been parsed correctly */
> +			parsed_attrs |= (1 << i);

Why do you need parsed_attrs, attributes are not optional. Everything
that's sepecified in desc->attrs and lower than i must had been parsed.

>  		}
>  	}
>  
>  	return 0;
> +
> +parse_err:
> +	/* release any resource that may have been acquired during the i-1
> +	 * parse() operations.
> +	 */
> +	__destroy_attrs(parsed_attrs, 0, i, slwt);
> +
> +	return err;
>  }
>  
>  static int seg6_local_build_state(struct net *net, struct nlattr *nla,


