Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D233EACE2
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 00:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhHLWGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 18:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230089AbhHLWGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 18:06:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CB0C60FED;
        Thu, 12 Aug 2021 22:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628805953;
        bh=WTfaH4buFJa02sut6C82lkwT2DzA5++4teVn05ejbzg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pbUex8WpQDtUQi9b40q0YcJwpX0X/tEEbdSP9SyyCd+xRd24lAY5ZG5nmtRfGV4q+
         HwVqnEADc3aJL+2Tx3Wwj7Rtm+O+l7OoACGM/RKnYXXHRwFJ1oXIZmESfjhCCIR7UI
         Uef/2PDWsz/yl9AR8wka5BJYHsTzGcFngYmA0tNHEIY6xZ/5yDxhRpxtXbUYIHjFvO
         jNEsgP5w97tWkBUy4ATpJza069Vn+CREWE3PBaJ6L7R/mr3iYGUNKwXjKWjxmZpWA5
         PzVjUzBe5dEadNIcUjC/knwWiYP6qKBmJr0+VXGSK2ZipVrqVTV87fmNO8urn2h0Wo
         wnULGglC2lq8Q==
Date:   Thu, 12 Aug 2021 15:05:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: gc useless variable in
 nlmsg_attrdata()
Message-ID: <20210812150552.18f32fb2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YRWRcbWR45+zF9mD@localhost.localdomain>
References: <YRWRcbWR45+zF9mD@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Aug 2021 00:24:01 +0300 Alexey Dobriyan wrote:
> Kernel permits pointer arithmetic on "void*" so might as well use it
> without casts back and forth.

But why change existing code? It's perfectly fine, right?

> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -587,8 +587,7 @@ static inline int nlmsg_len(const struct nlmsghdr *nlh)
>  static inline struct nlattr *nlmsg_attrdata(const struct nlmsghdr *nlh,
>  					    int hdrlen)
>  {
> -	unsigned char *data = nlmsg_data(nlh);
> -	return (struct nlattr *) (data + NLMSG_ALIGN(hdrlen));
> +	return nlmsg_data(nlh) + NLMSG_ALIGN(hdrlen);
>  }
>  
>  /**

