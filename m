Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931DC69BFA4
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 10:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjBSJel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 04:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjBSJed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 04:34:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B9335B0;
        Sun, 19 Feb 2023 01:33:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEF4360C17;
        Sun, 19 Feb 2023 09:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1511DC43324;
        Sun, 19 Feb 2023 09:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676799124;
        bh=io0T7hhFb3s5WCWM/E/gsyKhTz++GkBgRAdsP2tE8hA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fWrgb2yEyCUWbhSjblOIv0rwQSYhZG2sxriMrTnkUsGVqW9YB15AJ9A7GeKUfolKb
         WBfBG6swP7uLH2GftGqa1GokQNznxuGkmgc4F/7QTwHC1F+wbXvkYUFoxreA454kUA
         ehalplO+a5p3UvPP6Z095UTFUQ6PaZXM1RrOMYEO3uDExRjrxdLATUNKwnw0pwHM36
         EqX4pVIg3MTrto5Bbju6xqLqAzdD1Jwwztk0+3xysx2vgBGjEd+NULzgP4ou3sNYtL
         ijEckdFJ0LhYVn6Zd0gygfIO/qBZYkbc1DEip9TG3GZCk9QvmQD7km8WuMI4j9ran2
         LHXmTBuHhA8Sw==
Date:   Sun, 19 Feb 2023 11:31:59 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfc: use IS_ENABLED() checks for CONFIG_SFC_SRIOV
Message-ID: <Y/Hsj/HW4rl2rFMf@unreal>
References: <20230217095650.2305559-1-arnd@kernel.org>
 <f38d6b22-f846-5637-d58b-2d8862bc6840@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f38d6b22-f846-5637-d58b-2d8862bc6840@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:13:59PM +0000, Edward Cree wrote:
> On 17/02/2023 09:56, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > One local variable has become unused after a recent change:
> > 
> > drivers/net/ethernet/sfc/ef100_nic.c: In function 'ef100_probe_netdev_pf':
> > drivers/net/ethernet/sfc/ef100_nic.c:1155:21: error: unused variable 'net_dev' [-Werror=unused-variable]
> >   struct net_device *net_dev = efx->net_dev;
> >                      ^~~~~~~
> > 
> > The variable is still used in an #ifdef. Replace the #ifdef with
> > an if(IS_ENABLED()) check that lets the compiler see where it is
> > used, rather than adding another #ifdef.
> 
> So we've had Leon telling us[1] to use __maybe_unused, and you're
>  saying to use IS_ENABLED() instead.  Which is right?
> (And does it make any difference to build time?  I'm assuming the
>  compiler is smart enough that this change doesn't affect text
>  size...?)

You are mixing answers, __maybe_unused is for variables. For functions,
it will be much saner to create empty declarations for relevant
functions in tc.h, for !CONFIG_SFC_SRIOV flow.

It will be much cleaner than spaghetti code in .c files which you have now.

Thanks

> -ed
> 
> [1]: https://lore.kernel.org/netdev/cac3fa89-50a3-6de0-796c-a215400f3710@intel.com/T/#md2ecc82f18c200391dc6581ff68ff08eee9a65cf
