Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8810A520B20
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbiEJC1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 22:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbiEJC1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 22:27:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05AD17EC20
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 19:23:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F191615E5
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 02:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD81FC385B8;
        Tue, 10 May 2022 02:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652149400;
        bh=/lCXdcCqJvf5sXvHuy+hcTdU4qmOBSZXdeDDWgHD3vE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rtnsW88D2f40SQERR9JPtbaqXFOcIzLxUBEyTIxJmRoKyFYnGSXVvjXfGxndgvEQj
         sO3yT7c5RksU8Cenujdwwgixj1fdGvhOlzwVbH23iAEUsnRzt01MaHhZNdLviy2y42
         kOSgHzGSwVx8o0AXmQkrL6pvXgY1gs4puiOXrvWvrSjwA7Ps1BnahHdgJ9Jmv4UY9d
         5O4++bKXv+6dOrC7I0/53pce0zvegdhNYsVNGP9XSsqxPix9bnLZB1E6qdZLwwNo34
         J73CgMNRGDoqey9BNb06EipvXjhZaD3QSU6A8ZMJ29RIsS22L/KE2bNxPt0zTOXLb2
         DTLOC+cG+X6bg==
Date:   Mon, 9 May 2022 19:23:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     kernel test robot <lkp@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] net: warn if transport header was not set
Message-ID: <20220509192319.1fc6729a@kernel.org>
In-Reply-To: <CANn89iK6ydh4JctuYN3DCpMxp+5NhbSVV2=CA50MLOJYJH6HFQ@mail.gmail.com>
References: <20220509190851.1107955-4-eric.dumazet@gmail.com>
        <202205100723.9Wqso3nI-lkp@intel.com>
        <CANn89i+rMnV8RotzD7jfp8TgbJeV+XpzJFkWrhJe9YAtD9Wdbg@mail.gmail.com>
        <20220509183024.0edd698f@kernel.org>
        <CANn89iK6ydh4JctuYN3DCpMxp+5NhbSVV2=CA50MLOJYJH6HFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 May 2022 19:11:15 -0700 Eric Dumazet wrote:
> On Mon, May 9, 2022 at 6:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Yeah the order of inclusion is skbuff -> netdevice, as you probably
> > figured out by yourself. We may want to pull back the code move for
> > the print helpers. Unless you have cycles to untangle that :S  
> 
> I added at the beginning of the new file :
> 
> #include <linux/bug.h>
> struct net_device;
> 
> Hopefully this is enough.

Maybe toss in linux/kern_levels.h for a good measure?

netdev_WARN() uses netdev_name() but it's a macro, so the users of that
will need to include netdevice.h, or we could leave netdev_WARN() in 
netdevice.h. Doesn't matter in practice.
