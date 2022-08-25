Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD57A5A1BD9
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244116AbiHYWBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243483AbiHYWBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:01:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EFC74BB8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 15:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB886B82EA3
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 22:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B74AC433D6;
        Thu, 25 Aug 2022 22:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661464893;
        bh=Y0xTf2jAEvB+eIpfAi4hj4XDfv+AJcuVGQtPdgH6Bzg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rHLVocaAiUc6XtbLFh7Bu2LO/6ecH6A+AwzP53Wuucs0VMOMhwduHWF20Dib7oCdC
         xnpaT28yO33TYU7EYcReq7QtDoPOZNipTKrJWf855XHrVrU6mD1nkSJWYmzuHJX57o
         WibD71EVrqv6qjxkIs8Wj5SZwBecdMNII4CEyPZnRySfcJuDfgOk0m50/xGFrW/Lyw
         BFy5PBCkX9JO/lf56QpQa6x26uG4UltPmNWyxoSPd0JxRCPJO6gD/y4tMn/3UCGJdc
         7POuzqDKxx64RaXK4jj1SVjZuL6v5Hf8P8DDa6K1+WXmtMqUP0km7quFQQtVE+I91v
         fgrFO3obFIXpw==
Date:   Thu, 25 Aug 2022 15:01:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next 0/7] devlink: sanitize per-port region
 creation/destruction
Message-ID: <20220825150132.5ec89092@kernel.org>
In-Reply-To: <20220825103400.1356995-1-jiri@resnulli.us>
References: <20220825103400.1356995-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 12:33:53 +0200 Jiri Pirko wrote:
> Currently the only user of per-port devlink regions is DSA. All drivers
> that use regions register them before devlink registration. For DSA,
> this was not possible as the internals of struct devlink_port needed for
> region creation are initialized during port registration.
> 
> This introduced a mismatch in creation flow of devlink and devlink port
> regions. As you can see, it causes the DSA driver to make the port
> init/exit flow a bit cumbersome.
> 
> Fix this by introducing port_init/fini() which could be optionally
> called by drivers like DSA, to prepare struct devlink_port to be used
> for region creation purposes before devlink port register is called.
> 
> Force similar limitation as for devlink params and disallow to create
> regions after devlink or devlink port are registered. That allows to
> simplify the devlink region internal API to not to rely on
> devlink->lock.

The point of exposing the devlink lock was to avoid forcing drivers 
to order object registration in a specific way. I don't like.

Please provide some solid motivation here 'cause if it's you like vs 
I like...

Also the patches don't apply.
