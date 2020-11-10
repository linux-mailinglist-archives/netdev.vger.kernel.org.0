Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591E62ADC49
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 17:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgKJQnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 11:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgKJQne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 11:43:34 -0500
X-Greylist: delayed 321 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 Nov 2020 08:43:34 PST
Received: from anxur.fi.muni.cz (anxur.ip6.fi.muni.cz [IPv6:2001:718:801:230::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801B0C0613CF;
        Tue, 10 Nov 2020 08:43:34 -0800 (PST)
Received: by anxur.fi.muni.cz (Postfix, from userid 11561)
        id B10EF62147; Tue, 10 Nov 2020 17:38:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fi.muni.cz;
        s=20190124; t=1605026289;
        bh=TvflFCzvFXxiKiOIiUQj5XppASsorsvTm8Prn4eNH3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BHuZIagpBRYA6sp9rLJguXgzRQemps26S/JNVd9iAAmMeP20RKLj1nZGhGbCBEdAL
         YDp7O1i3g9UD6L7THHaNcgdXHmvbSaC/YDVcTU8hJxVNFUtlf6usCqyp52gxIVmbFn
         v0IoUgKYxyEtZjYMz8t8mQERNTTyeaaIsMoVZ9Ww=
Date:   Tue, 10 Nov 2020 17:38:09 +0100
From:   Jan Kasprzak <kas@fi.muni.cz>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] cosa: Add missing kfree in error path of cosa_write
Message-ID: <20201110163809.GE26676@fi.muni.cz>
References: <20201110144614.43194-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110144614.43194-1-wanghai38@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Hai wrote:
: If memory allocation for 'kbuf' succeed, cosa_write() doesn't have a
: corresponding kfree() in exception handling. Thus add kfree() for this
: function implementation.

Acked-By: Jan "Yenya" Kasprzak <kas@fi.muni.cz>

Looks correct, thanks.

That said, COSA is an ancient ISA bus device designed in late 1990s,
I doubt anybody is still using it. I still do have one or two of these
cards myself, but no computer with ISA bus to use them.

-Yenya

: 
: Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
: Reported-by: Hulk Robot <hulkci@huawei.com>
: Signed-off-by: Wang Hai <wanghai38@huawei.com>
: ---
:  drivers/net/wan/cosa.c | 1 +
:  1 file changed, 1 insertion(+)
: 
: diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
: index f8aed0696d77..2369ca250cd6 100644
: --- a/drivers/net/wan/cosa.c
: +++ b/drivers/net/wan/cosa.c
: @@ -889,6 +889,7 @@ static ssize_t cosa_write(struct file *file,
:  			chan->tx_status = 1;
:  			spin_unlock_irqrestore(&cosa->lock, flags);
:  			up(&chan->wsem);
: +			kfree(kbuf);
:  			return -ERESTARTSYS;
:  		}
:  	}
: -- 
: 2.17.1

-- 
| Jan "Yenya" Kasprzak <kas at {fi.muni.cz - work | yenya.net - private}> |
| http://www.fi.muni.cz/~kas/                         GPG: 4096R/A45477D5 |
    We all agree on the necessity of compromise. We just can't agree on
    when it's necessary to compromise.                     --Larry Wall
