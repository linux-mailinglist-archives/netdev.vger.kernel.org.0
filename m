Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1BF2FBFF3
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 20:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbhASTXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 14:23:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404441AbhASTSC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 14:18:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B350216FD;
        Tue, 19 Jan 2021 19:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611083841;
        bh=P0/TFgWeMMPSXvEZg3hYVPV4pcZWEPVFdWob/yJ/niE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MakoX4Dx7+gQ+UUSSUMyMaz6mTkRXMjvJygrgPxyHxn0Qt1iNOX6yuDBMvOL3vthb
         sjLncl+R/DTozRjM9qtjDDF0sQ5QnJgrgKVwMildJLa/vBd1VfCf9l46tiBa+WRhgP
         KgiKBOW1QZci53IwcBZZ9HmjC6NPJH27ZmW8JzHzN7minmRwJyRz9cZpEbXRXdiyJl
         4uowZLUAEOLjD5xopUY1e9m3cM0sxSXeKAcw9GN7gTj1hoc79MQdF1x0LeOKPIXy9e
         qVPRYMMONtk2hYdEUAGY79aHz6ITtEsNvklDEPc03w1wdNbVGBhztjWo8pMrqPwMyA
         yZ6K2IhbwHU4Q==
Date:   Tue, 19 Jan 2021 11:17:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: inline rollback_registered_many()
Message-ID: <20210119111720.4eac59f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119191158.3093099-5-kuba@kernel.org>
References: <20210119191158.3093099-1-kuba@kernel.org>
        <20210119191158.3093099-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 11:11:58 -0800 Jakub Kicinski wrote:
> @@ -10644,15 +10642,6 @@ EXPORT_SYMBOL(unregister_netdevice_queue);
>   *  we force a list_del() to make sure stack wont be corrupted later.
>   */
>  void unregister_netdevice_many(struct list_head *head)
> -{
> -	if (!list_empty(head)) {
> -		rollback_registered_many(head);
> -		list_del(head);

Obliviously missed the list_del() here, sorry for the noise :/

> -	}
> -}
> -EXPORT_SYMBOL(unregister_netdevice_many);
> -
> -static void rollback_registered_many(struct list_head *head)
>  {
>  	struct net_device *dev, *tmp;
>  	LIST_HEAD(close_head);
> @@ -10660,6 +10649,9 @@ static void rollback_registered_many(struct list_head *head)
>  	BUG_ON(dev_boot_phase);
>  	ASSERT_RTNL();
>  
> +	if (list_empty(head))
> +		return;
> +
>  	list_for_each_entry_safe(dev, tmp, head, unreg_list) {
>  		/* Some devices call without registering
>  		 * for initialization unwind. Remove those
> @@ -10744,6 +10736,7 @@ static void rollback_registered_many(struct list_head *head)
>  		net_set_todo(dev);
>  	}
>  }
> +EXPORT_SYMBOL(unregister_netdevice_many);
