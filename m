Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB73B4D6640
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350373AbiCKQ3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350534AbiCKQ14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:27:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675D81D5296
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 08:26:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EDCBB82B00
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662BBC340E9;
        Fri, 11 Mar 2022 16:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647015972;
        bh=TN7xEAMoYzLgPDXuykKqUiY3U41HuZHpu96M5WnWr9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ftqc6EW9bN07+Lbh+J+W+T3m/uIjyaUQ+oHdU3vYqz6D/l9Mlp0oB28MxR97w56f1
         BC29y4YuH+Sv9jX62elbBtxnPMjKNsL/lZqaFZQGx9UNx/L89DkbeaaEVkOir6gxbo
         nRSM8+GNWds4F8aiOCQc6GIeEaw/IOrz4oPojlOXUbO7moBS7rACiBRPAYEBw9NmaM
         7M5PXAs/1xsQwfINu4LieNX5g0ZGrNhI1y62XrGh1bz/tghtyT0/EO7momeyhb5joh
         e+WFK4a3CU0O1+mjGKUP2JshgRWBXlHpItBzoMoGr0XZGlmC2AKNXzp7umGLqgKKX+
         N+RApmBLk4FHw==
Date:   Fri, 11 Mar 2022 08:26:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     <idosch@nvidia.com>, <petrm@nvidia.com>,
        <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [RFT net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <20220311082611.5bca7d5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yit0QFjt7HAHFNnq@unreal>
References: <20220310001632.470337-1-kuba@kernel.org>
        <20220310001632.470337-2-kuba@kernel.org>
        <Yit0QFjt7HAHFNnq@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 18:09:36 +0200 Leon Romanovsky wrote:
> What about this?

Is it better? Can do it you prefer, but I'd lean towards a version
without an ifdef myself.

> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 8d5349d2fb68..33b47d1a6800 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1762,5 +1762,12 @@ devlink_compat_switch_id_get(struct net_device *dev,
>  }
>  
>  #endif
> -
> +#if IS_ENABLED(CONFIG_LOCKDEP)
> +bool devl_lock_is_held(struct devlink *devlink);
> +#else
> +static inline bool devl_lock_is_held(struct devlink *devlink)
> +{
> +       return true;
> +}
> +#endif
>  #endif /* _NET_DEVLINK_H_ */
