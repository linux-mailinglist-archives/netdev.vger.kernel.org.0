Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC390614F24
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 17:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiKAQZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 12:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAQZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 12:25:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49881A213;
        Tue,  1 Nov 2022 09:25:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ED9661683;
        Tue,  1 Nov 2022 16:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544A9C433C1;
        Tue,  1 Nov 2022 16:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667319943;
        bh=jp0haQb56t8TSqgjvFtI9oohs5ER4+8NHZC6BOnlgyA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H5jOmx43ex4T8mI2DWQ3/iBZN2OvC8B9PFop3U7wVyKRnQqmf6RHxk1gQPhjj72Vs
         8qiqTkrlcEjAw9A641Itd3crf37ZMGYWnroFFYkvozh2UQujnUmNOn1sn0LWuxx9/r
         fnkg/StJuVBEWEDFm3HqZXAw7h0C+KkdBAubIsNN8nTUdoXwzVH4/DhUtefvhqye+6
         ioiWF1rHIzxvFTPJVHpTML8qz6Nq+MHkM8fG4d1WMaal24Vxih4cxpEoAIG43jXY97
         rYAzuuDuUvM4tFNwoGTZBLFmFLWGq2keMDKGUyl2+wFPVpZnozvtmFXw7PccM3eTSi
         pWbr9Af+t6QCg==
Date:   Tue, 1 Nov 2022 09:25:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v3 05/13] net: devlink: track netdev with
 devlink_port assigned
Message-ID: <20221101092542.26c66235@kernel.org>
In-Reply-To: <20221031124248.484405-6-jiri@resnulli.us>
References: <20221031124248.484405-1-jiri@resnulli.us>
        <20221031124248.484405-6-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Oct 2022 13:42:40 +0100 Jiri Pirko wrote:
> +/*
> + * Driver should use this to assign devlink port instance to a netdevice
> + * before it registers the netdevice. Therefore devlink_port is static
> + * during the netdev lifetime after it is registered.
> + */
> +#define SET_NETDEV_DEVLINK_PORT(dev, _devlink_port)		\
> +({								\
> +	WARN_ON(dev->reg_state != NETREG_UNINITIALIZED);	\
> +	((dev)->devlink_port = (_devlink_port));		\
> +})

The argument wrapping is inconsistent here - dev is in brackets
on the second line but not on the first. _devlink_port is prefixed 
with underscore and dev is not. Let's make this properly secure
and define a local var for dev.

> @@ -10107,6 +10107,7 @@ int register_netdevice(struct net_device *dev)
>  	return ret;
>  
>  err_uninit:
> +	call_netdevice_notifiers(NETDEV_PRE_UNINIT, dev);

I think we should make this symmetric with POST_INIT.
IOW PRE_UNINIT should only be called if POST_INIT was called.
