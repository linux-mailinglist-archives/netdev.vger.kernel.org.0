Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24C96CF344
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 21:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjC2TkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 15:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjC2TkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 15:40:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB334ED4;
        Wed, 29 Mar 2023 12:40:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF933B82371;
        Wed, 29 Mar 2023 19:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FAAC433EF;
        Wed, 29 Mar 2023 19:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680118799;
        bh=lHDaNAh7npioainZTXH9AtcE4qVEJa19Abe0otEfXOw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZcxiiytOV6/vsJRYv4XJlnbULAlO052NYi5o7JXo/uHQyjy5ZYD4JLfud8M+eaBCb
         7eOn5hjoOeG4dv4CqC4pcaaBxPnFv3M3HwH3u05CSfjhhpn7GPxBBPyhd+rd9oP8g+
         oChzxTU82XLcR+oq910d2/IJlBdEWCRiX2SsGfQNMJrb956m5IXUsh1PNsNEMKkREl
         NztpnQjyyxunTFLyUpAkJ3IWkaJeDoDoCwyJk/x5z4X+Eo+GYpCslBiaRHr1IchZOV
         4JypJpTP3BhfAYFekSNj4UXJjoINEDNYZ/i2sEB8LCcsanQybFi2u1NErbYAbpIq6W
         X+4QIfmwShnEA==
Date:   Wed, 29 Mar 2023 12:39:58 -0700
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
Message-ID: <20230329123958.045c9861@kernel.org>
In-Reply-To: <20230329064010.24657-1-wsa+renesas@sang-engineering.com>
References: <20230329064010.24657-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 08:40:10 +0200 Wolfram Sang wrote:
> Otherwise the clocks are not enabled and reading registers will OOPS.
> Copy the behaviour from Renesas SH_ETH and use a custom flag because
> using netif_running() is racy. A generic solution still needs to be
> implemented. Tested on a Renesas APE6-EK.

Hm, so you opted to not add the flag in the core?
To keep the backport small? I think we should just add it..
Clearly multiple drivers would benefit and it's not a huge change.
