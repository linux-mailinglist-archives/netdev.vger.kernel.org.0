Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD16DF038
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbfJUOpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbfJUOpw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 10:45:52 -0400
Received: from localhost (unknown [107.87.137.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A29D12053B;
        Mon, 21 Oct 2019 14:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571669151;
        bh=zSxr6boC9XHsm0JY6dQGUP4Y+pfXYhmlbUslvFJagHU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wzQU8e0ZUFNA8uAikS25qhU+PVVOE1nVLd8tB20kS4RhTnUBXXeHPWRWyrc6EfC/U
         3MxufZMwym9OBnJTJHOyQO6DC35w13zixXNgT34vkVW+/WGisLaRsfWiKq9PCWqjMn
         eR5n3fRA7Hjg+DR0PEPA/XiaRHmax8grcGZk3iAs=
Date:   Mon, 21 Oct 2019 10:45:48 -0400
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] debugfs: Add debugfs_create_xul() for hexadecimal
 unsigned long
Message-ID: <20191021144548.GA41107@kroah.com>
References: <20191021143742.14487-1-geert+renesas@glider.be>
 <20191021143742.14487-2-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021143742.14487-2-geert+renesas@glider.be>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 04:37:36PM +0200, Geert Uytterhoeven wrote:
> The existing debugfs_create_ulong() function supports objects of
> type "unsigned long", which are 32-bit or 64-bit depending on the
> platform, in decimal form.  To format objects in hexadecimal, various
> debugfs_create_x*() functions exist, but all of them take fixed-size
> types.
> 
> Add a debugfs helper for "unsigned long" objects in hexadecimal format.
> This avoids the need for users to open-code the same, or introduce
> bugs when casting the value pointer to "u32 *" or "u64 *" to call
> debugfs_create_x{32,64}().
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  include/linux/debugfs.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
> index 33690949b45d6904..d7b2aebcc277d65e 100644
> --- a/include/linux/debugfs.h
> +++ b/include/linux/debugfs.h
> @@ -356,4 +356,14 @@ static inline ssize_t debugfs_write_file_bool(struct file *file,
>  
>  #endif
>  
> +static inline void debugfs_create_xul(const char *name, umode_t mode,
> +				      struct dentry *parent,
> +				      unsigned long *value)
> +{
> +	if (sizeof(*value) == sizeof(u32))
> +		debugfs_create_x32(name, mode, parent, (u32 *)value);
> +	else
> +		debugfs_create_x64(name, mode, parent, (u64 *)value);
> +}

Looks sane, but can you add some kernel-doc comments here so that we can
pull it into the debugfs documentation?  Also there is debugfs
documentation in Documentation/filesystems/ so maybe also add this
there?  I am going to be overhauling the debugfs documentation "soon"
but it's at the lower part of my todo list, so it will take a while,
might as well keep it up to date with new stuff added like this so that
people don't get lost.

thanks,

greg k-h
