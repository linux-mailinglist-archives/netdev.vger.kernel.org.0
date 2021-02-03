Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF23430E615
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 23:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhBCWbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 17:31:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231230AbhBCWbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 17:31:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DBB064F65;
        Wed,  3 Feb 2021 22:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612391464;
        bh=Gd6SF8b3uuV9T+hMcJ4T6TrLh14MUW2JylOdNFQDo9M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QdA47Km8I4J+dQ0NowT6TI6o6iuPfLVwhfUkm6XWT+cCiUWwla6KZsalgzvRaUhWH
         FgQfssqrY05Np3xTf7899FJ2fSygrdcUONCRZzRE1UvTCYmk18dwQ10AG7lDGHe/pI
         7Z8cekdLtg2H706QYokTBO8vmX7YCVR16kTT9QmycbcBZ38/5OcLjvlaQxSA+blPtw
         LHcqWZrKvW+SBWeKbwqvDbhI48D+ly3XIWea6SZMi7KWYC8x53QZERY22fTpa4y44P
         qxKRv5qI87MBPKwacb2Ma5QXaxK7ayabAbfVZTN68sv2J0zM/3eOui6VPpbYOo29qI
         Xwgoh3oCSiYmg==
Date:   Wed, 3 Feb 2021 14:31:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH RESEND net-next] netlink: add tracepoint at
 NL_SET_ERR_MSG
Message-ID: <20210203143103.292ea9e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fb6e25a4833e6a0e055633092b05bae3c6e1c0d3.1611934253.git.marcelo.leitner@gmail.com>
References: <fb6e25a4833e6a0e055633092b05bae3c6e1c0d3.1611934253.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Feb 2021 15:12:19 -0300 Marcelo Ricardo Leitner wrote:
> Often userspace won't request the extack information, or they don't log it
> because of log level or so, and even when they do, sometimes it's not
> enough to know exactly what caused the error.
> 
> Netlink extack is the standard way of reporting erros with descriptive
> error messages. With a trace point on it, we then can know exactly where
> the error happened, regardless of userspace app. Also, we can even see if
> the err msg was overwritten.
> 
> The wrapper do_trace_netlink_extack() is because trace points shouldn't be
> called from .h files, as trace points are not that small, and the function
> call to do_trace_netlink_extack() on the macros is not protected by
> tracepoint_enabled() because the macros are called from modules, and this
> would require exporting some trace structs. As this is error path, it's
> better to export just the wrapper instead.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> --- a/include/linux/netlink.h
> +++ b/include/linux/netlink.h
> @@ -6,11 +6,15 @@
>  #include <linux/capability.h>
>  #include <linux/skbuff.h>
>  #include <linux/export.h>
> +#include <linux/tracepoint.h>

Do we need the include...

>  #include <net/scm.h>
>  #include <uapi/linux/netlink.h>
>  
>  struct net;
>  
> +DECLARE_TRACEPOINT(netlink_extack);

... and the declaration? Seems to be a leftover.

> +void do_trace_netlink_extack(const char *msg);
> +
>  static inline struct nlmsghdr *nlmsg_hdr(const struct sk_buff *skb)
>  {
>  	return (struct nlmsghdr *)skb->data;
> @@ -90,6 +94,8 @@ struct netlink_ext_ack {
>  	static const char __msg[] = msg;		\
>  	struct netlink_ext_ack *__extack = (extack);	\
>  							\
> +	do_trace_netlink_extack(__msg);			\
> +							\
>  	if (__extack)					\
>  		__extack->_msg = __msg;			\
>  } while (0)
> @@ -110,6 +116,8 @@ struct netlink_ext_ack {
>  	static const char __msg[] = msg;			\
>  	struct netlink_ext_ack *__extack = (extack);		\
>  								\
> +	do_trace_netlink_extack(__msg);				\
> +								\
>  	if (__extack) {						\
>  		__extack->_msg = __msg;				\
>  		__extack->bad_attr = (attr);			\
