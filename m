Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199113E88CC
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 05:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhHKD1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 23:27:32 -0400
Received: from smtprelay0157.hostedemail.com ([216.40.44.157]:48640 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232795AbhHKD13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 23:27:29 -0400
Received: from omf16.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id A12421802B564;
        Wed, 11 Aug 2021 03:27:03 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id 3358D2550F6;
        Wed, 11 Aug 2021 03:27:02 +0000 (UTC)
Message-ID: <d5e1aada694465fd62f57695e264259815e60746.camel@perches.com>
Subject: Re: [PATCH net-next v2 2/2] bonding: combine netlink and console
 error messages
From:   Joe Perches <joe@perches.com>
To:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        leon@kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Date:   Tue, 10 Aug 2021 20:27:01 -0700
In-Reply-To: <e6b78ce8f5904a5411a809cf4205d745f8af98cb.1628650079.git.jtoppins@redhat.com>
References: <cover.1628650079.git.jtoppins@redhat.com>
         <e6b78ce8f5904a5411a809cf4205d745f8af98cb.1628650079.git.jtoppins@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.21
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 3358D2550F6
X-Stat-Signature: 75qa5r47bkii4bat47q8hn5j747o34s3
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/2GfxExur2gZjwWpoFAdVLKZaN4FmBi38=
X-HE-Tag: 1628652422-415181
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-08-10 at 22:53 -0400, Jonathan Toppins wrote:
> There seems to be no reason to have different error messages between
> netlink and printk. It also cleans up the function slightly.
> 
> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> ---
> 
> Notes:
>     v2:
>      - changed the printks to reduce object code slightly
>      - emit a single error message based on if netlink or sysfs is
>        attempting to enslave
>      - rebase on top of net-next/master and convert additional
>        instances added by XDP additions
> 
>  drivers/net/bonding/bond_main.c | 69 ++++++++++++++++++---------------
>  1 file changed, 37 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
[]
> @@ -1725,6 +1725,20 @@ void bond_lower_state_changed(struct slave *slave)
>  	netdev_lower_state_changed(slave->dev, &info);
>  }
> 
> +#define BOND_NL_ERR(bond_dev, extack, errmsg) do {		\
> +	if (extack)						\
> +		NL_SET_ERR_MSG(extack, errmsg);			\
> +	else							\
> +		netdev_err(bond_dev, "Error: %s\n", errmsg);	\
> +} while (0)
> +
> +#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do {		\
> +	if (extack)							\
> +		NL_SET_ERR_MSG(extack, errmsg);				\
> +	else								\
> +		slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
> +} while (0)

Ideally both of these would be static functions and not macros.


