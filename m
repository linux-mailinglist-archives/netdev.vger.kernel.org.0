Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA9536B44D
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 15:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhDZNx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 09:53:58 -0400
Received: from smtprelay0040.hostedemail.com ([216.40.44.40]:48124 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230250AbhDZNx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 09:53:57 -0400
Received: from omf11.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id A37821800E39B;
        Mon, 26 Apr 2021 13:53:15 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf11.hostedemail.com (Postfix) with ESMTPA id 491DC20A298;
        Mon, 26 Apr 2021 13:53:14 +0000 (UTC)
Message-ID: <58eb44800ec3aaafa0f3a88a6d046ac85aaa02fe.camel@perches.com>
Subject: Re: [PATCH] bonding/alb: return -ENOMEM when kmalloc failed
From:   Joe Perches <joe@perches.com>
To:     Yang Li <yang.lee@linux.alibaba.com>, j.vosburgh@gmail.com
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 26 Apr 2021 06:53:12 -0700
In-Reply-To: <1619429620-52948-1-git-send-email-yang.lee@linux.alibaba.com>
References: <1619429620-52948-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 491DC20A298
X-Spam-Status: No, score=1.60
X-Stat-Signature: okpmrasujzkq9opcd5o75jf3abzaebt9
X-Rspamd-Server: rspamout02
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19vfUab48sJmY3HRmSzw5Q5g4fiz1KSh2g=
X-HE-Tag: 1619445194-382861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-04-26 at 17:33 +0800, Yang Li wrote:
> The driver is using -1 instead of the -ENOMEM defined macro to
> specify that a buffer allocation failed. Using the correct error
> code is more intuitive.
> 
> Smatch tool warning:
> drivers/net/bonding/bond_alb.c:850 rlb_initialize() warn: returning -1
> instead of -ENOMEM is sloppy
> 
> No functional change, just more standardized.
[]
> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
[]
> @@ -847,7 +847,7 @@ static int rlb_initialize(struct bonding *bond)
>  
> 
>  	new_hashtbl = kmalloc(size, GFP_KERNEL);
>  	if (!new_hashtbl)
> -		return -1;
> +		return -ENOMEM;
>  
> 
>  	spin_lock_bh(&bond->mode_lock);
>  
> 

Perhaps the bond_alb_initialize call here which uses the return
value from this function:

drivers/net/bonding/bond_main.c:                if (bond_alb_initialize(bond, (BOND_MODE(bond) == BOND_MODE_ALB)))
drivers/net/bonding/bond_main.c-                        return -ENOMEM;

should use a store/test/return style instead of a fixed value return.

						res = bond_alb_initialize(bond, BOND_MODE(bond) == BOND_MODE_ALB);
						if (res < 0)
							return res;



