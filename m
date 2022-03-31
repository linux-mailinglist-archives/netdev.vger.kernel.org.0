Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2E84EE07A
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 20:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbiCaSd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 14:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiCaSdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 14:33:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7051C16FD
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 11:31:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDD9C60F73
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 18:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107FDC340ED;
        Thu, 31 Mar 2022 18:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648751497;
        bh=V9XCmLiay4EpGdK4yjc1Iurj78QfHgULNG8gaQJb7Ro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I0T626yri6eVihKCU3KucQjUC3tYXK7DIh0NwobgGJ9S8BMomyB2msyQLQO1QmaVO
         xtduaXaoPX8ptMTd/owfZrejCwwCjAbw8DEPZoSFTZXr3tc33gLuhxkoChQIkuorvY
         PbTPRAHHNefhJd9jLVCSH8QPz45e+ZRrjy5g2+ZQWB5n9/ZU0V3qCwBsfW1PhFSVsk
         M3Nv5Ohvan+fy6HOQAqqJR91jJhzdNMbG1cpkM9eYkPMO4bcsriRj1VRv+1u81cTcv
         +7lA8XH9VLwva668YCJX9V/pitYQNNYMxr+Dc4PnJTQwW/bAA8hYAIigGn2Xm0H4rK
         aETZCiINyoFwQ==
Date:   Thu, 31 Mar 2022 11:31:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tomas Melin <tomas.melin@vaisala.com>
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        pabeni@redhat.com
Subject: Re: [PATCH] net: macb: Restart tx only if queue pointer is lagging
Message-ID: <20220331113135.025460c1@kernel.org>
In-Reply-To: <20220325065012.279642-1-tomas.melin@vaisala.com>
References: <20220325065012.279642-1-tomas.melin@vaisala.com>
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

On Fri, 25 Mar 2022 08:50:12 +0200 Tomas Melin wrote:
> commit 5ea9c08a8692 ("net: macb: restart tx after tx used bit read")

Ooh, I just noticed the commit ID here is from the stable tree.
Please change it to the original commit ID, so 4298388574da
and repost once the discussion settles.

> added support for restarting transmission. Restarting tx does not work
> in case controller asserts TXUBR interrupt and TQBP is already at the end
> of the tx queue. In that situation, restarting tx will immediately cause
> assertion of another TXUBR interrupt. The driver will end up in an infinite
> interrupt loop which it cannot break out of.
> 
> For cases where TQBP is at the end of the tx queue, instead
> only clear TXUBR interrupt. As more data gets pushed to the queue,
> transmission will resume.
> 
> This issue was observed on a Xilinx Zynq based board. During stress test of
> the network interface, driver would get stuck on interrupt loop
> within seconds or minutes causing CPU to stall.
