Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487FF5FEDDD
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 14:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJNMNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 08:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiJNMNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 08:13:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438971C73EB
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 05:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=n/lMrWUfaaAd6lO51QbC3BpojKxdwSChe0kpbn9YYXE=; b=raF3tVIILFLWTSC7+zqsjQJLDC
        lvZskjzU8vKVGgEeDm37AT6bFDm4dULiDjnJGdT/6fWaGFJKBNTD9t3b9v9H5D24l3irqbWIv6ZYh
        R+K3gb1XTQNi5bgK/8kobCkZuRtbrPO7J+CpP/RQD90eYB4o0DlrQSm78cpFrjxyo0ZE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ojJZ3-001y7b-RK; Fri, 14 Oct 2022 14:13:21 +0200
Date:   Fri, 14 Oct 2022 14:13:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     irusskikh@marvell.com, dbogdanov@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, Li Liang <liali@redhat.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
Message-ID: <Y0lSYQ99lBSqk+eH@lunn.ch>
References: <20221014103443.138574-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014103443.138574-1-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fix trying to acquire rtnl_lock at the beginning of those functions, and
> returning if NIC closing is ongoing. Also do the "linkstate" stuff in a
> workqueue instead than in a threaded irq, where sleeping or waiting a
> mutex for a long time is discouraged.

What happens when the same interrupt fires again, while the work queue
is still active? The advantage of the threaded interrupt handler is
that the interrupt will be kept disabled, and should not fire again
until the threaded interrupt handler exits.

> +static void aq_nic_linkstate_task(struct work_struct *work)
> +{
> +	struct aq_nic_s *self = container_of(work, struct aq_nic_s,
> +					     linkstate_task);
> +
> +#if IS_ENABLED(CONFIG_MACSEC)
> +	/* avoid deadlock at aq_nic_stop -> cancel_work_sync */
> +	while (!rtnl_trylock()) {
> +		if (aq_utils_obj_test(&self->flags, AQ_NIC_FLAG_CLOSING))
> +			return;
> +		msleep(AQ_TASK_RETRY_MS);
> +	}
> +#endif
> +
>  	aq_nic_update_link_status(self);
>  
> +#if IS_ENABLED(CONFIG_MACSEC)
> +	rtnl_unlock();
> +#endif
> +

If MACSEC is enabled, aq_nic_update_link_status() is called with RTNL
held. If it is not enabled, RTNL is not held. This sort of
inconsistency could lead to further locking bugs, since it is not
obvious. Please try to make this consistent.

	 Andrew
