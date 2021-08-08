Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1877A3E39D9
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 12:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhHHKRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 06:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhHHKRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 06:17:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 566D261002;
        Sun,  8 Aug 2021 10:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628417811;
        bh=X9dnTD0xyKMIdTIRG+oJBdvfJeZaP8irwsirpacwiZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wa1neRgs6ZQchJmGvV2//Z3KqL0LzwQa2fSBU2jlLzqJ3o1SxAXyj76TV32RtoeNK
         E8tPA1RBLqZJskjm/0VitWGAZD1elaq6cgm0IokCgaCjaaWQbgEo+1gGp9ZHmrCVBr
         luRZQ4+4vgnmk2M0zjHENrcQJbjS9WO5p1dl8IeflUZRlfZBxNh4DDCRt8LIHFSd1Q
         cC154kLyWE63rE4vtbWY63KCmLvdS0iK6USw9Dx8YkGJbDw6WTluIVzZIzDw1uOEOP
         JAaiz8yNg56rcZccmt/wvewDjTTbxWgC2UI5xl3HoDOGf8EaYmOVjQLmsRbjLxfTJT
         rQygtY0KjZjKw==
Date:   Sun, 8 Aug 2021 13:16:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] bonding: combine netlink and console error
 messages
Message-ID: <YQ+vDtXPV5DHqruU@unreal>
References: <cover.1628306392.git.jtoppins@redhat.com>
 <a36c7639a13963883f49c272ed7993c9625a712a.1628306392.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36c7639a13963883f49c272ed7993c9625a712a.1628306392.git.jtoppins@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 11:30:55PM -0400, Jonathan Toppins wrote:
> There seems to be no reason to have different error messages between
> netlink and printk. It also cleans up the function slightly.
> 
> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> ---
>  drivers/net/bonding/bond_main.c | 45 ++++++++++++++++++---------------
>  1 file changed, 25 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 3ba5f4871162..46b95175690b 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1712,6 +1712,16 @@ void bond_lower_state_changed(struct slave *slave)
>  	netdev_lower_state_changed(slave->dev, &info);
>  }
>  
> +#define BOND_NL_ERR(bond_dev, extack, errmsg) do {		\
> +	NL_SET_ERR_MSG(extack, errmsg);				\
> +	netdev_err(bond_dev, "Error: " errmsg "\n");		\
> +} while (0)
> +
> +#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do {	\
> +	NL_SET_ERR_MSG(extack, errmsg);				\
> +	slave_err(bond_dev, slave_dev, "Error: " errmsg "\n");	\
> +} while (0)

I don't think that both extack messages and dmesg prints are needed.

They both will be caused by the same source, and both will be seen by
the caller, but duplicated.

IMHO, errors that came from the netlink, should be printed with NL_SET_ERR_MSG(),
other errors should use netdev_err/slave_err prints.

Thanks
