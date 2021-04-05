Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60A835486D
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 23:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237101AbhDEV7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 17:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241318AbhDEV7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 17:59:37 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B6CC061756;
        Mon,  5 Apr 2021 14:59:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 70CDA4D309A87;
        Mon,  5 Apr 2021 14:59:28 -0700 (PDT)
Date:   Mon, 05 Apr 2021 14:59:21 -0700 (PDT)
Message-Id: <20210405.145921.1248097047641627556.davem@davemloft.net>
To:     phil@philpotter.co.uk
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tun: set tun->dev->addr_len during TUNSETLINK
 processing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210405113555.9419-1-phil@philpotter.co.uk>
References: <20210405113555.9419-1-phil@philpotter.co.uk>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 05 Apr 2021 14:59:28 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>
Date: Mon,  5 Apr 2021 12:35:55 +0100

> When changing type with TUNSETLINK ioctl command, set tun->dev->addr_len
> to match the appropriate type, using new tun_get_addr_len utility function
> which returns appropriate address length for given type. Fixes a
> KMSAN-found uninit-value bug reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=0766d38c656abeace60621896d705743aeefed51
> 
> Reported-by: syzbot+001516d86dbe88862cec@syzkaller.appspotmail.com
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> ---
>  drivers/net/tun.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 978ac0981d16..56c26339ee3b 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -69,6 +69,14 @@
>  #include <linux/bpf.h>
>  #include <linux/bpf_trace.h>
>  #include <linux/mutex.h>
> +#include <linux/ieee802154.h>
> +#include <linux/if_ltalk.h>
> +#include <uapi/linux/if_fddi.h>
> +#include <uapi/linux/if_hippi.h>
> +#include <uapi/linux/if_fc.h>
> +#include <net/ax25.h>
> +#include <net/rose.h>
> +#include <net/6lowpan.h>
>  
>  #include <linux/uaccess.h>
>  #include <linux/proc_fs.h>
> @@ -2925,6 +2933,45 @@ static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog __rcu **prog_p,
>  	return __tun_set_ebpf(tun, prog_p, prog);
>  }
>  
> +/* Return correct value for tun->dev->addr_len based on tun->dev->type. */
> +static inline unsigned char tun_get_addr_len(unsigned short type)
> +{

Please do not use inline in foo.c files, let the compiler decide.

Thanks.
