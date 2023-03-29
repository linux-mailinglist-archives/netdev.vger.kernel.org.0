Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531E76CCFBB
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 04:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjC2CCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 22:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjC2CCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 22:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCE51BF8
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 19:01:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7B9261A28
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 02:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3D0C433D2;
        Wed, 29 Mar 2023 02:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680055316;
        bh=HGHh0BjqWpFfMKzaRItb9HJQ+ixFsAIwwozkAhraHX8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FZZY5xTVZH7qo9p9oQoOt3xE/bGeHxEDyOCYOPePACkXb7WON7nj45foF9G4DVBuz
         gAWgK/8XAqkybzo0zR8fAPKp/x7YDK5xd4LrJIyHUcyqX8ihxBwo7mOF9Ao0M3h8ld
         ozF939wWQFpyscgOFFc0fj4TIHKeOs+EpX22yZlL788z8CS6uf/HYVUY0IvzhR3+fj
         Zo8Vku6eXux0Ql4XeM25J3Y9XsjP5dmA5OWZQihqkjeAv2txuT8jEGuKmZF/MaF3Gh
         rETrzU5hWfuObpCnVsEPZh4va9qPLb8CUXwMFo0EgHBjOKSOoFYsjzKm0V37dDYz9z
         rAxuk3ZhxSoXg==
Date:   Tue, 28 Mar 2023 19:01:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix tx throughput
 regression with direct 1G links
Message-ID: <20230328190155.7eab8368@kernel.org>
In-Reply-To: <20230324140404.95745-1-nbd@nbd.name>
References: <20230324140404.95745-1-nbd@nbd.name>
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

On Fri, 24 Mar 2023 15:04:04 +0100 Felix Fietkau wrote:
> Using the QDMA tx scheduler to throttle tx to line speed works fine for
> switch ports, but apparently caused a regression on non-switch ports.
> 
> Based on a number of tests, it seems that this throttling can be safely
> dropped without re-introducing the issues on switch ports that the
> tx scheduling changes resolved.
> 
> Link: https://lore.kernel.org/netdev/trinity-92c3826f-c2c8-40af-8339-bc6d0d3ffea4-1678213958520@3c-app-gmx-bs16/
> Fixes: f63959c7eec3 ("net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues")
> Reported-by: Frank Wunderlich <frank-w@public-files.de>
> Reported-by: Daniel Golle <daniel@makrotopia.org>
> Tested-by: Daniel Golle <daniel@makrotopia.org>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

My reading of the discussion was that this patch is good, even if it
doesn't fix all the models, but it's marked as Changes Requested in PW.
Could you confirm that we should apply this one as is, just to be sure?
