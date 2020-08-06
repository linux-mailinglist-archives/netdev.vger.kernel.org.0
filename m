Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3804523E061
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgHFScT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728437AbgHFSbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 14:31:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE27E221E3;
        Thu,  6 Aug 2020 18:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596738630;
        bh=0j/Gs+HBIfouG9/zhyHY47+RDgMJzkzUWkX/o6OMrro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I+OXd6pPB0yUX7nf+Xu+8HYNDCXGzahILClI6a/xnXVm2yFkVypzmMi0jgo6k4KB8
         eyAC++GbawumtRkuQ5JAY0yk4r6DEPb8zZpgDKPLe5xbFORRxFXru59lgOabQCrufM
         g1RnGbbbLaU6CieM3JvArku0QjxQwVa0+LXDrqtE=
Date:   Thu, 6 Aug 2020 11:30:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qingyu Li <ieatmuttonchuan@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: enforce CAP_NET_RAW for raw sockets When creating
 a raw AF_NFC socket, CAP_NET_RAW needs to be checked first.
Message-ID: <20200806113026.64b7f755@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200806022808.GA17066@oppo>
References: <20200806022808.GA17066@oppo>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Aug 2020 10:28:08 +0800 Qingyu Li wrote:

Commit message is required. Perhaps shorten the subject and put more
info here.

> Signed-off-by: Qingyu Li <ieatmuttonchuan@gmail.com>
> ---
>  net/nfc/rawsock.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
> index ba5ffd3badd3..c1302b689a98 100644
> --- a/net/nfc/rawsock.c
> +++ b/net/nfc/rawsock.c
> @@ -332,8 +332,11 @@ static int rawsock_create(struct net *net, struct socket *sock,
>  	if ((sock->type != SOCK_SEQPACKET) && (sock->type != SOCK_RAW))
>  		return -ESOCKTNOSUPPORT;
> 
> -	if (sock->type == SOCK_RAW)
> +	if (sock->type == SOCK_RAW){
> +		if (!capable(CAP_NET_RAW))
> +			return -EPERM;
>  		sock->ops = &rawsock_raw_ops;
> +	}

please run checkpatch.pl --strict and fix the issues.

>  	else
>  		sock->ops = &rawsock_ops;
> 
> 
> 

