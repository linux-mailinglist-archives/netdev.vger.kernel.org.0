Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80336E03F6
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 04:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjDMCGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 22:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDMCGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 22:06:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB76D2708
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 19:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5894263869
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFFEC433EF;
        Thu, 13 Apr 2023 02:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681351611;
        bh=LnURsTaW89C4d0dAB0czzJdkeWkx5N7vRoBATa3i9vs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VHuEcsoexPl4fkz4auJLNrQEpOA0mFXshLcrb7S3tf00J5nzrdGPB6ANqOKNDlG8s
         yZY6ucCjngtj06+jBQ8nINIFDBqmpgvnZU4og48j6qT7YtVMzVTaM28U8RSEmuuWh5
         zvSRxxby+wtVv0vAHlbq42alwxDwyqSSIAUwVkXvgCSPwFo4nl8d+yyrydZZHt9YUK
         xuIRmVmsLPXVJLXnIKmGqJgu5VW80z8q4lNVzDY4RjMFLLb7YNo1pSkYR/cYyuG9HL
         4H+SjBgB/xNj5BK0GP53eIZi9kshhVKD43W8Lf8ar5zGf2xFHiPGPYDLGfOZh3FIM9
         Zh32KXk+zYMiQ==
Date:   Wed, 12 Apr 2023 19:06:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, edward.cree@amd.com,
        linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
Subject: Re: [RFC PATCH v2 net-next 6/7] net: ethtool: add a mutex
 protecting RSS contexts
Message-ID: <20230412190650.70baee3e@kernel.org>
In-Reply-To: <3623a7f3-6f90-8570-5b9a-10ff56cc04e5@gmail.com>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
        <9e2bcb887b5cf9cbb8c0c4ba126115fe01a01f3f.1681236654.git.ecree.xilinx@gmail.com>
        <ea711ae7-c730-4347-a148-0602c69c9828@lunn.ch>
        <69612358-2003-677a-80a2-5971dc026646@gmail.com>
        <61041c56-f7d2-49f8-9fc3-57852a96105a@lunn.ch>
        <3623a7f3-6f90-8570-5b9a-10ff56cc04e5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 18:42:16 +0100 Edward Cree wrote:
> On 12/04/2023 18:15, Andrew Lunn wrote:
> > I have to wonder if your locking model is wrong. When i look at the
> > next patch, i see the driver is also using this lock. And i generally
> > find that is wrong.  
> ...
> > Drivers writers should not need to worry about locking. The API
> > into the driver will take the locks needed before entering the driver,
> > and release them on exit.  
> I don't think that's possible without increasing driver complexity in
>  other ways.  Essentially, for the driver to take advantage of the core
>  tracking these contexts, and thus not need its own data structures to
>  track them as well (like the efx->rss_context.list we remove in patch
>  #7), it has to be able to access them on driver-initiated (not just
>  core-initiated) events.  (The central example of this being "oh, the
>  NIC MCPU just rebooted, we have to reinstall all our filters".)  And
>  it needs to be able to exclude writes while it does that, not only for
>  consistency but also because e.g. context deletion will free that
>  memory (though I guess we could finesse that part with RCU?).
> What I *could* do is add suitable wrapper functions for access to
>  dev->ethtool->rss_ctx (e.g. a core equivalent of
>  efx_find_rss_context_entry() that wraps the idr_find()) and have them
>  assert that the lock is held (like efx_find_rss_context_entry() does);
>  that would at least validate the driver locking somewhat.
> But having those helper functions perform the locking themselves would
>  mean going to a get/put model for managing the lifetime of the
>  driver's reference (with a separate get_write for exclusive access),
>  at which point it's probably harder for driver writers to understand
>  than "any time you're touching rss_ctx you need to hold the rss_lock".

IMO the "MCPU has rebooted" case is a control path, taking rtnl seems
like the right thing to do. Does that happen often enough or takes so
long to recover that we need to be concerned about locking down rtnl?
aRFS can't sleep IIUC so the mutex is does not seem like a great match.

IOW I had the same reaction as Andrew first time I saw this mutex :(
