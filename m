Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F872528DF1
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 21:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345413AbiEPTbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 15:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345479AbiEPTbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 15:31:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BA32B1A0;
        Mon, 16 May 2022 12:31:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 298AD614FC;
        Mon, 16 May 2022 19:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1246BC34100;
        Mon, 16 May 2022 19:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652729463;
        bh=yeLKZJHgwtKyYalDbvtHzvDVJBp8BddUkRB8jSjYmvk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l5rAc7KKzPIJ5XgwaXvyndiN4iGjm3znK/7LgNlPxvRwvkGO3WTpCFqvSj0RF1b2K
         dworej4sH9GS4G5mBbnPNSk2nTXp/UG99pjDqVHzvvg3wONppB634PmCh1wKxm1ftE
         UbHTgZ9PcLqy/bidEY6GfAWnew4NmXMYqA0HJb3kTGY7pZo3EPnWv1NyFV6D635dpm
         V7RwNH8RUz/rLgig0xAZyXQ4ssgC9EQzO6EOv61lpdyws3sdk00YEZNApqeZX15Czy
         LJzfMloi2TFl42c/scsHb3gUbNS9ZRaCJLTarD+5WA89RK0bhmPm8rvufa1BXroqN+
         QMqFd8SdetJiw==
Date:   Mon, 16 May 2022 12:31:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Kahurani <k.kahurani@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
        davem@davemloft.net, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, phil@philpotter.co.uk,
        syzkaller-bugs@googlegroups.com, arnd@arndb.de,
        dan.carpenter@oracle.com
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
Message-ID: <20220516123101.467ad206@kernel.org>
In-Reply-To: <20220514133234.33796-1-k.kahurani@gmail.com>
References: <20220514133234.33796-1-k.kahurani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 May 2022 16:32:34 +0300 David Kahurani wrote:
> -			ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
> -					 1, 1, &buf);
> +			ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
> +					       1, 1, &buf);
> +			if (ret) {
> +				netdev_dbg(dev->net,
> +					   "Failed to read SROM_CMD: %d\n",
> +					   ret);
> +				return ret;
> +			}
>  
>  			if (time_after(jiffies, jtimeout))
>  				return -EINVAL;
>  
>  		} while (buf & EEP_BUSY);

I agree with Pavel, this seems unnecessarily strict. If the error is
not ENODEV we can keep looping.

> @@ -1581,7 +1731,13 @@ static int ax88179_link_reset(struct usbnet *dev)
>  				  &ax179_data->rxctl);
>  
>  		/*link up, check the usb device control TX FIFO full or empty*/
> -		ax88179_read_cmd(dev, 0x81, 0x8c, 0, 4, &tmp32);
> +		ret = ax88179_read_cmd(dev, 0x81, 0x8c, 0, 4, &tmp32);
> +
> +		if (ret) {
> +			netdev_dbg(dev->net, "Failed to read TX FIFO: %d\n",
> +				   ret);
> +			return ret;
> +		}

Please don't add any empty lines within the error checking.
Empty lines are supposed to separate logically separate blocks of code.
Error checking is very much logically part of the call. And no empty
line betwee netdev_dbg() and return ret; either. In this submission you
have all possible configurations of having or not having empty lines
before the if or before the return. None of them should be there, and
please be consistent.
