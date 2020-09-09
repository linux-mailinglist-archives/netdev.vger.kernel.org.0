Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE9426359E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgIISKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgIISJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:09:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6049EC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:09:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F15D12954924;
        Wed,  9 Sep 2020 10:53:11 -0700 (PDT)
Date:   Wed, 09 Sep 2020 11:09:56 -0700 (PDT)
Message-Id: <20200909.110956.600909796407174509.davem@davemloft.net>
To:     allen.lkml@gmail.com
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, romain.perier@gmail.com
Subject: Re: [PATCH v2 01/20] ethernet: alteon: convert tasklets to use new
 tasklet_setup() API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909084510.648706-2-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
        <20200909084510.648706-2-allen.lkml@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 10:53:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>
Date: Wed,  9 Sep 2020 14:14:51 +0530

> @@ -1562,10 +1562,11 @@ static void ace_watchdog(struct net_device *data, unsigned int txqueue)
>  }
>  
>  
> -static void ace_tasklet(unsigned long arg)
> +static void ace_tasklet(struct tasklet_struct *t)
>  {
> -	struct net_device *dev = (struct net_device *) arg;
> -	struct ace_private *ap = netdev_priv(dev);
> +	struct ace_private *ap = from_tasklet(ap, t, ace_tasklet);
> +	struct net_device *dev = (struct net_device *)((char *)ap -
> +				ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
>  	int cur_size;
>  

I don't see this is as an improvement.  The 'dev' assignment looks so
incredibly fragile and exposes so many internal details about netdev
object allocation, alignment, and layout.

Who is going to find and fix this if someone changes how netdev object
allocation works?

I don't want to apply this, it sets a very bad precedent.  The existing
code is so much cleaner and easier to understand and audit.

