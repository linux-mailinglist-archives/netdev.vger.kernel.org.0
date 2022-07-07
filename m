Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA445697E2
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 04:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiGGCVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 22:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGGCVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 22:21:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753272F388
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 19:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 194726208B
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 02:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24052C3411C;
        Thu,  7 Jul 2022 02:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657160468;
        bh=PRY5zsm5z6AYW868LPVwToiUp9mWmHQyJGi+aJsZTdo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GzVf5gGHL5dHQGXf240Lh/eDYQIRRlJIUVTnh4QOpuFqUXrOn7nWY5iwL8SrME7wO
         fjMsGf1v/9v6lJIjTqHKEUTGDGPCdKcnbOs+bpst/Z7xi9YRSaXGHA0/hGyPRHE9NB
         5+sscI3tl5HC0Dd6XTsSvayxe+biBJ/9Lu8thu1GHcwahTz7ALMOWzWvrzbw7z/ex7
         z/2cGmy6W7BlpLz970Zpqgln6qpDGII0W07xoMlWUcsLlHQl/6nj/tvjVPNl8wOOCg
         kmhiAYPK3iOrLuHxLq6CSjVxG6F7dpmKOAWlhKLihGdHgM1XB+GBMb2jhM1O7H7oth
         LZvRlDfEsZ5jg==
Date:   Wed, 6 Jul 2022 19:21:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [net-next 10/15] net/tls: Perform immediate device ctx cleanup
 when possible
Message-ID: <20220706192107.0b6fe869@kernel.org>
In-Reply-To: <20220706232421.41269-11-saeed@kernel.org>
References: <20220706232421.41269-1-saeed@kernel.org>
        <20220706232421.41269-11-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jul 2022 16:24:16 -0700 Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> TLS context destructor can be run in atomic context. Cleanup operations
> for device-offloaded contexts could require access and interaction with
> the device callbacks, which might sleep. Hence, the cleanup of such
> contexts must be deferred and completed inside an async work.
> 
> For all others, this is not necessary, as cleanup is atomic. Invoke
> cleanup immediately for them, avoiding queueuing redundant gc work.
> 
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Not sure if posting core patches as part of driver PRs is a good idea,
if I ack this now the tag will not propagate.
