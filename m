Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E61463509B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 07:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbiKWGl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 01:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbiKWGlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 01:41:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6CDF6099;
        Tue, 22 Nov 2022 22:41:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C4FDB81ECB;
        Wed, 23 Nov 2022 06:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF754C433D6;
        Wed, 23 Nov 2022 06:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669185664;
        bh=BqF+fMKmQdlgBmpTypjbrHnI9gIDVaSpZN4o3tTBEtI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HGluntDqwOHuKBVKwnocM18xZ5/GHfwov2XKMBY6dMhb/gq7Cgm5bsj4kfoA8VZvk
         u79YMc8/VQLS81gIsUc6qNnCQavEmjIVc3yWZd4C1abPzZ6QGpTmly5evPvnXCJiCj
         jM1HYdDTMY7aQ2egWzYYlukc8pA0fjHntlYzfVZSfMkP+Vj7BhCsYE9//faaA3FGYp
         ocMtnANd1XrCDF26gMYSRfNhD6fL1a8dn3bJ+hX7AZDJOzmc4c6ABV1iR22/GJ1hdl
         T/lPTSAgKy+25GG08yQxLGrVJ8Rc+uLJUONXi/yOF8nEzQeqJgIcaixg2Z70d9LQsz
         J2ms+4nC+LnHQ==
Date:   Wed, 23 Nov 2022 08:40:57 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Peter Kosyh <pkosyh@yandex.ru>, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] mlx4: use snprintf() instead of sprintf() for safety
Message-ID: <Y33AeQzuXFjnr+t/@unreal>
References: <20221122130453.730657-1-pkosyh@yandex.ru>
 <Y3zhL0/OItHF1R03@unreal>
 <20221122121223.265d6d97@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122121223.265d6d97@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 12:12:23PM -0800, Jakub Kicinski wrote:
> On Tue, 22 Nov 2022 16:48:15 +0200 Leon Romanovsky wrote:
> > On Tue, Nov 22, 2022 at 04:04:53PM +0300, Peter Kosyh wrote:
> > > Use snprintf() to avoid the potential buffer overflow. Although in the
> > > current code this is hardly possible, the safety is unclean.  
> > 
> > Let's fix the tools instead. The kernel code is correct.
> 
> I'm guessing the code is correct because port can't be a high value?

Yes, port value is provided as input to mlx4_init_port_info() and it is
capped by MLX4_MAX_PORTS, which is 2.

> Otherwise, if I'm counting right, large enough port representation
> (e.g. 99999999) could overflow the string. If that's the case - how
> would they "fix the tool" to know the port is always a single digit?

I may admit that I don't know how hard or easy to implement it, but it
will be great if tool would be able to understand that dev->caps.num_ports
are not really dynamic values, but constant ones.

However, I don't mind if we merge it.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
