Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3827B3E845E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 22:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbhHJUbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 16:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233150AbhHJUbV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 16:31:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07E99606A5;
        Tue, 10 Aug 2021 20:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628627459;
        bh=pYabKjpxjyymLr6W69svkIvkf/KxoZYS7a6A8PWPyms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TSu2lZ7pnWQM9H8LazKoJA2fYFpIdFBdGBZhco1kw8w/8jQ8Wp78kIgWqwcqTt5hz
         16QqodwCAEo8HdjtrJCPoFyqRPCb45ZDQ5Qz9/zPGNBjONoKJqUl6jaluFW+fYU5uM
         USWRe8gA0v1lN2ZqsnASrGujG+nyYBhKhWdn5qQr8x7MBGpH0L7Bi9vzxbSplaXSmb
         5wK9yf3pVPjRvnQdmcZy+DNBqOqFalWa8A5dYHLvxbDwEtkDMyYmWvQ7jswj0WRVF3
         Q1Kd3N88MLc0jlgvREjq/y3fC+tysm7AXO0qS82nZo8SzInKtIT+xyqwvp77aJfvLK
         7O5qgMcAwPrQA==
Date:   Tue, 10 Aug 2021 13:30:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netlink: NL_SET_ERR_MSG - remove local static array
Message-ID: <20210810133058.0c7f0736@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1f99c69f4e640accaf7459065e6625e73ec0f8d4.camel@perches.com>
References: <1f99c69f4e640accaf7459065e6625e73ec0f8d4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 09 Aug 2021 10:04:00 -0700 Joe Perches wrote:
> The want was to have some separate object section for netlink messages
> so all netlink messages could be specifically listed by some tool but
> the effect is duplicating static const char arrays in the object code.
> 
> It seems unused presently so change the macro to avoid the local static
> declarations until such time as these actually are wanted and used.
> 
> This reduces object size ~8KB in an x86-64 defconfig without modules.
> 
> $ size vmlinux.o*
>    text	   data	    bss	    dec	    hex	filename
> 20110471	3460344	 741760	24312575	172faff	vmlinux.o.new
> 20119444	3460344	 741760	24321548	1731e0c	vmlinux.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I guess we can bring it back when it's needed.

> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> index 61b1c7fcc401e..4bb32ae134aa8 100644
> --- a/include/linux/netlink.h
> +++ b/include/linux/netlink.h
> @@ -89,13 +89,12 @@ struct netlink_ext_ack {
>   * to the lack of an output buffer.)
>   */
>  #define NL_SET_ERR_MSG(extack, msg) do {		\
> -	static const char __msg[] = msg;		\
>  	struct netlink_ext_ack *__extack = (extack);	\
>  							\
> -	do_trace_netlink_extack(__msg);			\
> +	do_trace_netlink_extack(msg);			\
>  							\
>  	if (__extack)					\
> -		__extack->_msg = __msg;			\
> +		__extack->_msg = msg;			\
>  } while (0)

But you've made us evaluate msg multiple times now.
Given extack is carefully evaluated only once this stands out.

>  #define NL_SET_ERR_MSG_MOD(extack, msg)			\
> @@ -111,13 +110,12 @@ struct netlink_ext_ack {
>  #define NL_SET_BAD_ATTR(extack, attr) NL_SET_BAD_ATTR_POLICY(extack, attr, NULL)
>  
>  #define NL_SET_ERR_MSG_ATTR_POL(extack, attr, pol, msg) do {	\
> -	static const char __msg[] = msg;			\
>  	struct netlink_ext_ack *__extack = (extack);		\
>  								\
> -	do_trace_netlink_extack(__msg);				\
> +	do_trace_netlink_extack(msg);				\
>  								\
>  	if (__extack) {						\
> -		__extack->_msg = __msg;				\
> +		__extack->_msg = msg;				\
>  		__extack->bad_attr = (attr);			\
>  		__extack->policy = (pol);			\

Same here.
