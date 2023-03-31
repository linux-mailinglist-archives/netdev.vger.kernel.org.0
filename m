Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B21D6D17C8
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjCaGuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjCaGuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62971BC3;
        Thu, 30 Mar 2023 23:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 772D162375;
        Fri, 31 Mar 2023 06:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9B8C433D2;
        Fri, 31 Mar 2023 06:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680245410;
        bh=rhyBsElZo0Ta67fGA+xvuCeA4z94ImcI9RFKEh/mtpQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bYlMcsP82q/ZpCZExmr4gv9Yq3dFCE+ZMjWCfOQXzwQpP+xqz8teACYe5wQYouhQF
         Zyl544dWDDO58wE8jxFZlymWXu6DzoJw5HgriP11OIQ1DAyJRi+uVeek3pJ3sd8T2X
         ZpMW7jryQTikQgasYqu9S7HZ6OxDsympkyEicjHfHk3WJaQXXHS6ci/3OWNj1xdWeY
         7UX0oyylKiklREh9+jLqXgw1Wlsz98LrZGDegBPIHBo6Gl1GQmpmAI+3CDVZ2uX8H5
         YwRE5cOKtJo518oJusAErv9ebYwr/RGqB8bSFTDMPrDFLtwWRKPO8ZBJkkP28qB2A5
         50Xb0j6F9F+7w==
Date:   Thu, 30 Mar 2023 23:50:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4] smsc911x: only update stats when interface is up
Message-ID: <20230330235009.4b6d4b8e@kernel.org>
In-Reply-To: <ZCZ+tFtp9NBBjiqv@ninjato>
References: <20230329064010.24657-1-wsa+renesas@sang-engineering.com>
        <20230329123958.045c9861@kernel.org>
        <ZCSWJxuu1EY/zBFm@shikoro>
        <20230329131724.4484a881@kernel.org>
        <ZCZ+tFtp9NBBjiqv@ninjato>
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

On Fri, 31 Mar 2023 08:33:24 +0200 Wolfram Sang wrote:
> > Okay, core changes aside - does pm_runtime_put() imply an RCU sync?
> > Otherwise your check in get_stats is racy...  
> 
> From some light research, I can't find a trace of RCU sync. Pity, I'll
> need to move furhter investigation to later. I'll report back if I have
> something, but it may take a while. Thanks for the help!

If you don't want to spend too much time you can just call it yourself
right? :) Put a synchronize_rcu() with a comment about concurrent stat
reading after pdata->is_open = false; and that's it?
