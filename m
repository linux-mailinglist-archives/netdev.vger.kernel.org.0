Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06E15F33D5
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 18:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiJCQqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 12:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiJCQp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 12:45:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5922EF2A;
        Mon,  3 Oct 2022 09:45:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77C9061174;
        Mon,  3 Oct 2022 16:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9740CC433C1;
        Mon,  3 Oct 2022 16:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664815557;
        bh=nzdOonOyGPuvkC96+krKbY28e/QOBRuSwdP5kVCyE7I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s15AJEAXwVf/WOIiuGkaNDZ3CnzWW3H8LAaNj5t8nwmFI2lIh3/gqCAawWWVK9DvW
         AH35vhTnQejsPvQalIGTtVuEOLKXM3G3v3gZwx+sUIH5HEmJtTMJUNkG++ykkko8CN
         MIoFKxysBhLmARCFqlDauc/MB1yxDwvR44EJ3+ZFlpUTKnt8NozjHhhdPoxOFW0LFY
         L2mhHLc4t5qEO5ZmUELeTKfWUJfmJZTP46mYRsSJv0MAL6JFZXa53WT9nehI7iRFmF
         ZHHsQYbCj72j7MTulejycM3R7/l6ZoFMIFuaLvrlWdDtw7Ga5cx5osvPeCYdsa4+AM
         YuAAxZqjUuq0g==
Date:   Mon, 3 Oct 2022 09:45:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v2 00/13] net: fix netdev to devlink_port
 linkage and expose to user
Message-ID: <20221003094556.1f16a255@kernel.org>
In-Reply-To: <20221003105204.3315337-1-jiri@resnulli.us>
References: <20221003105204.3315337-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Oct 2022 12:51:51 +0200 Jiri Pirko wrote:
> Currently, the info about linkage from netdev to the related
> devlink_port instance is done using ndo_get_devlink_port().
> This is not sufficient, as it is up to the driver to implement it and
> some of them don't do that. Also it leads to a lot of unnecessary
> boilerplate code in all the drivers.
> 
> Instead of that, introduce a possibility for driver to expose this
> relationship by new SET_NETDEV_DEVLINK_PORT macro which stores it into
> dev->devlink_port. It is ensured by the driver init/fini flows that
> the devlink_port pointer does not change during the netdev lifetime.
> Devlink port is always registered before netdev register and
> unregistered after netdev unregister.
> 
> Benefit from this linkage setup and remove explicit calls from driver
> to devlink_port_type_eth_set() and clear(). Many of the driver
> didn't use it correctly anyway. Let the devlink.c to track associated
> netdev events and adjust type and type pointer accordingly. Also
> use this events to to keep track on ifname change and remove RTNL lock
> taking from devlink_nl_port_fill().
> 
> Finally, remove the ndo_get_devlink_port() ndo which is no longer used
> and expose devlink_port handle as a new netdev netlink attribute to the
> user. That way, during the ifname->devlink_port lookup, userspace app
> does not have to dump whole devlink port list and instead it can just
> do a simple RTM_GETLINK query.

Would you be okay if we deferred until 6.2?

It's technically past the deadline and some odd driver could regress.
