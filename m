Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DEC641CBB
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 12:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiLDLmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 06:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiLDLlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 06:41:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2CD17A80
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 03:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 683BC60E73
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 11:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D096AC433C1;
        Sun,  4 Dec 2022 11:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670154019;
        bh=JH5e/CSuG05LJpY3wlHORGAia94M6mPClYS6CgKi/7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rdI9ZKI064vHQ+FcXwYLOlYNn8/qGHpuBwHOSeTVpIDx3Z8FZ+v1UaMhRAWi+I0OL
         58QCNJ8dwnIJ2CbU2f8dG0fBUotLpMhMmgvyWj+626gMOO3CdVghrm/RVt+i8bBzaK
         92NTxv2LdU7h263RuBnsJRmPNjHVyb5gjCetsbFSS+e4KlGe180vQnHZNe8HFaGfcK
         5KPyTWKTPHkvgyL7/BPtD8o4N536rDjPb0cnBWdGtYxG1whjkJ3Q8hGACas0iLa4Mv
         JrZuV9/afCafhq1XNT5TYo4YyjeHZLzZNPa22jptgXRctTHyWsw+ItC34w6SqhvgtK
         ++QNiKot9fTWA==
Date:   Sun, 4 Dec 2022 13:40:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, yangyingliang@huawei.com
Subject: Re: [patch net-next RFC 7/7] devlink: assert if
 devl_port_register/unregister() is called on unregistered devlink instance
Message-ID: <Y4yHGT7k4/boMFa0@unreal>
References: <20221201164608.209537-1-jiri@resnulli.us>
 <20221201164608.209537-8-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201164608.209537-8-jiri@resnulli.us>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 05:46:08PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Now when all drivers do call devl_port_register/unregister() withing the
> time frame during which the devlink is registered, put and assertion to
> the functions to check that and avoid going back.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  net/core/devlink.c | 2 ++
>  1 file changed, 2 insertions(+)

You also need to remove delayed notifications from devlink_notify_register()

   9862         xa_for_each(&devlink->ports, port_index, devlink_port)
   9863                 devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);

Thanks
