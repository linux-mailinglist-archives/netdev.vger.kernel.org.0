Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CEA6B86DB
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCNAYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjCNAYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:24:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722DE4C2C;
        Mon, 13 Mar 2023 17:24:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E51326155A;
        Tue, 14 Mar 2023 00:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AF4C433D2;
        Tue, 14 Mar 2023 00:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678753483;
        bh=8/nS5VmD+weBz0QNdojM2u5joFZlFeUTzdUNbQ1Tusc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g/ZUltV0oLlWkbgqaeq3cxJlJ2OI3HqAVk8yE0BbaHzBNsxNoAdgWvcsTbf+oQj3R
         c7XpVBYch8+cK0KDc3UfYu5yY2HFXFRilQ9ZrM9Scr3u6/538UwCweZ4OQ11eZhlsT
         IjprIdQuKLkjkVQ4Ds2zqqFlIr0BjSgvxm7pAXf0CyPSG5+mjWcKmg9dRkQS7WNeU6
         OFoWFDFw70GIvW859vk8Hwf1YXNBsQXEoMMvR8o7MywEgVeHXxS5gdfQ5al2HavbxI
         jxHOQiF3LaFpzqu3ePLzX942uwm3UadZ32mj4GpfAQUHheHfmc16WaRtTCyXJLJprp
         9OOyKNbkks4tQ==
Date:   Mon, 13 Mar 2023 17:24:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some
 bugs
Message-ID: <20230313172441.480c9ec7@kernel.org>
In-Reply-To: <20230310221547.3656194-3-anjali.k.kulkarni@oracle.com>
References: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
        <20230310221547.3656194-3-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Mar 2023 14:15:44 -0800 Anjali Kulkarni wrote:
> diff --git a/include/linux/connector.h b/include/linux/connector.h
> index 487350bb19c3..1336a5e7dd2f 100644
> --- a/include/linux/connector.h
> +++ b/include/linux/connector.h
> @@ -96,7 +96,11 @@ void cn_del_callback(const struct cb_id *id);
>   *
>   * If there are no listeners for given group %-ESRCH can be returned.
>   */
> -int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 group, gfp_t gfp_mask);
> +int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid,
> +			 u32 group, gfp_t gfp_mask,
> +			 int (*filter)(struct sock *dsk, struct sk_buff *skb,
> +				       void *data),
> +			 void *filter_data);

kdoc needs to be extended

> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 003c7e6ec9be..b311375b8c4c 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -63,6 +63,7 @@
>  #include <linux/net_namespace.h>
>  #include <linux/nospec.h>
>  #include <linux/btf_ids.h>
> +#include <linux/connector.h>
>  
>  #include <net/net_namespace.h>
>  #include <net/netns/generic.h>
> @@ -767,9 +768,14 @@ static int netlink_release(struct socket *sock)
>  	/* must not acquire netlink_table_lock in any way again before unbind
>  	 * and notifying genetlink is done as otherwise it might deadlock
>  	 */
> -	if (nlk->netlink_unbind) {
> +	if (nlk->netlink_unbind && nlk->groups) {
>  		int i;
> -
> +		if (sk->sk_protocol == NETLINK_CONNECTOR) {
> +			if (test_bit(CN_IDX_PROC - 1, nlk->groups)) {
> +				kfree(sk->sk_user_data);
> +				sk->sk_user_data = NULL;
> +			}
> +		}
>  		for (i = 0; i < nlk->ngroups; i++)
>  			if (test_bit(i, nlk->groups))
>  				nlk->netlink_unbind(sock_net(sk), i + 1);

This is clearly a layering violation, right?
Please don't add "if (family_x)" to the core netlink code.
