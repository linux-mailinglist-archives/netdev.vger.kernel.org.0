Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BDB2AE3C7
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732656AbgKJW5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:57:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732616AbgKJW46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 17:56:58 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B660120781;
        Tue, 10 Nov 2020 22:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605049017;
        bh=hryNSK2/6xmZBxdvSLB8GfNxXE7Ss5UN9UXZVORpsMc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nj5wGq7nWKU4nzFYf/8Mutk/iyQ5IAEpAbkFwPxc+pdMFWjEj0Sgw/UK/LTk5y5aq
         3bICJ+IgUA+vKyrm33cXgnruTcXFhWCBmpA2t8yqLlwBz/sUjFZIvO5Ix/PF9I4oWc
         f9Ilt9GCPCWqh2UPII0dSuCKN0abkX2SXx2FaMs4=
Date:   Tue, 10 Nov 2020 14:56:55 -0800
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
Subject: Re: [net-next,v2,3/5] seg6: add callbacks for customizing the
 creation/destruction of a behavior
Message-ID: <20201110145655.513eab48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107153139.3552-4-andrea.mayer@uniroma2.it>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
        <20201107153139.3552-4-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Nov 2020 16:31:37 +0100 Andrea Mayer wrote:
> We introduce two callbacks used for customizing the creation/destruction of
> a SRv6 behavior. Such callbacks are defined in the new struct
> seg6_local_lwtunnel_ops and hereafter we provide a brief description of
> them:
> 
>  - build_state(...): used for calling the custom constructor of the
>    behavior during its initialization phase and after all the attributes
>    have been parsed successfully;
> 
>  - destroy_state(...): used for calling the custom destructor of the
>    behavior before it is completely destroyed.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>

Looks good, minor nits.

> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> index 63a82e2fdea9..4b0f155d641d 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -33,11 +33,23 @@
>  
>  struct seg6_local_lwt;
>  
> +typedef int (*slwt_build_state_t)(struct seg6_local_lwt *slwt, const void *cfg,
> +				  struct netlink_ext_ack *extack);
> +typedef void (*slwt_destroy_state_t)(struct seg6_local_lwt *slwt);

Let's avoid the typedefs. Instead of taking a pointer to the op take a
pointer to the ops struct in seg6_local_lwtunnel_build_state() etc.

> +/* callbacks used for customizing the creation and destruction of a behavior */
> +struct seg6_local_lwtunnel_ops {
> +	slwt_build_state_t build_state;
> +	slwt_destroy_state_t destroy_state;
> +};
> +
>  struct seg6_action_desc {
>  	int action;
>  	unsigned long attrs;
>  	int (*input)(struct sk_buff *skb, struct seg6_local_lwt *slwt);
>  	int static_headroom;
> +
> +	struct seg6_local_lwtunnel_ops slwt_ops;
>  };
>  
>  struct bpf_lwt_prog {
> @@ -1015,6 +1027,45 @@ static void destroy_attrs(struct seg6_local_lwt *slwt)
>  	__destroy_attrs(attrs, 0, SEG6_LOCAL_MAX + 1, slwt);
>  }
>  
> +/* call the custom constructor of the behavior during its initialization phase
> + * and after that all its attributes have been parsed successfully.
> + */
> +static int
> +seg6_local_lwtunnel_build_state(struct seg6_local_lwt *slwt, const void *cfg,
> +				struct netlink_ext_ack *extack)
> +{
> +	slwt_build_state_t build_func;
> +	struct seg6_action_desc *desc;
> +	int err = 0;
> +
> +	desc = slwt->desc;
> +	if (!desc)
> +		return -EINVAL;

This is impossible, right?

> +
> +	build_func = desc->slwt_ops.build_state;
> +	if (build_func)
> +		err = build_func(slwt, cfg, extack);
> +
> +	return err;

no need for err, just use return directly.

	if (!ops->build_state)
		return 0;
	return ops->build_state(...);

> +}
> +
> +/* call the custom destructor of the behavior which is invoked before the
> + * tunnel is going to be destroyed.
> + */
> +static void seg6_local_lwtunnel_destroy_state(struct seg6_local_lwt *slwt)
> +{
> +	slwt_destroy_state_t destroy_func;
> +	struct seg6_action_desc *desc;
> +
> +	desc = slwt->desc;
> +	if (!desc)
> +		return;
> +
> +	destroy_func = desc->slwt_ops.destroy_state;
> +	if (destroy_func)
> +		destroy_func(slwt);
> +}
> +
>  static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
>  {
>  	struct seg6_action_param *param;
> @@ -1090,8 +1141,16 @@ static int seg6_local_build_state(struct net *net, struct nlattr *nla,
>  
>  	err = parse_nla_action(tb, slwt);
>  	if (err < 0)
> +		/* In case of error, the parse_nla_action() takes care of
> +		 * releasing resources which have been acquired during the
> +		 * processing of attributes.
> +		 */

that's the normal behavior for a kernel function, comment is
unnecessary IMO

>  		goto out_free;
>  
> +	err = seg6_local_lwtunnel_build_state(slwt, cfg, extack);
> +	if (err < 0)
> +		goto free_attrs;

The function is called destroy_attrs, call the label out_destroy_attrs,
or err_destroy_attrs.

>  	newts->type = LWTUNNEL_ENCAP_SEG6_LOCAL;
>  	newts->flags = LWTUNNEL_STATE_INPUT_REDIRECT;
>  	newts->headroom = slwt->headroom;
> @@ -1100,6 +1159,9 @@ static int seg6_local_build_state(struct net *net, struct nlattr *nla,
>  
>  	return 0;
>  
> +free_attrs:
> +	destroy_attrs(slwt);
> +

no need for empty lines on error paths

>  out_free:
>  	kfree(newts);
>  	return err;
> @@ -1109,6 +1171,8 @@ static void seg6_local_destroy_state(struct lwtunnel_state *lwt)
>  {
>  	struct seg6_local_lwt *slwt = seg6_local_lwtunnel(lwt);
>  
> +	seg6_local_lwtunnel_destroy_state(slwt);
> +
>  	destroy_attrs(slwt);
>  
>  	return;

