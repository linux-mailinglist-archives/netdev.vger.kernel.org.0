Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD866D32FB
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 19:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjDARzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 13:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjDARzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 13:55:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FE11CB9B
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 10:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63F2EB80D52
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 17:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D91C433EF;
        Sat,  1 Apr 2023 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680371735;
        bh=LogUom3M5S0F7dm4NIGTQx33F5VHfB0cLHoRcCYvfic=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dYrpkaIh+eZ64PVtq6pF3S5NOSKNlMd/k+gFLQZmNBPXQ4umcxezsl+cH0rmoTKZt
         9G0qy1S+krzpg9+e2wIABxCroAtN+G3L/2bR5R8C0xCT2ePE6JLo8sHtA+6yQdTf35
         15uMjheLJarUrcSOE7GNWmQqiU6QrprOXO70WGntPxwUe1iizOBQWFHMQ7kG2E/TG6
         FCR/nfj832vovTjU0k+17IRThm5iUovXmKHMhvR9ESPzFRB+yUW78SV4p/XxQznlTC
         26yuU47H8xLgTpPwLbVNCpw2RwlYDGJlR/liRAU4qIvchk1ZQC69iTEzgzQWEZgIoj
         0S6Hmn6YCFOsQ==
Date:   Sat, 1 Apr 2023 10:55:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230401105533.240e27aa@kernel.org>
In-Reply-To: <20230401160829.7tbxnm5l3ke5ggvr@skbuf>
References: <20230331045619.40256-1-glipus@gmail.com>
        <20230330223519.36ce7d23@kernel.org>
        <20230401160829.7tbxnm5l3ke5ggvr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Apr 2023 19:08:29 +0300 Vladimir Oltean wrote:
> > Let's refactor this differently, we need net_hwtstamp_validate()
> > to run on the same in-kernel copy as we'll send down to the driver.
> > If we copy_from_user() twice we may validate a different thing
> > than the driver will end up seeing (ToCToU).  
> 
> I'm not sure I understand this. Since net_hwtstamp_validate() already
> contains a copy_from_user() call, don't we already call copy_to_user()
> twice (the second time being in all SIOCSHWTSTAMP handlers from drivers)?

After this patch we'll be passing an in-kernel-space struct to drivers
rather than the ifr they have to copy themselves. I'm saying that we
should validate that exact copy, rather than copy, validate, copy, pass
to drivers, cause user space may change the values between the two
copies.

Unlikely to cause serious bugs but seems like a good code hygiene.

This is only for the drivers converted to the NDO, obviously, 
the legacy drivers will still have to copy themselves.
