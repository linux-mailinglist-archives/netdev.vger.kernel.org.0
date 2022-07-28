Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE18F583697
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 03:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbiG1B64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 21:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiG1B6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 21:58:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1665358B52
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 18:58:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B804BB822CC
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6A1C433D6;
        Thu, 28 Jul 2022 01:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658973532;
        bh=hOD4are79SZr/8GppXqI7riucXDu9cv3lqEdzNrO87w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dufUTz+fijINejJUEOYTShBovPa1FZqCXNfSMe8/o3240TFUXgov/dQxGh3iyEqTB
         S5t42uxSzAbgD8F641bKwameKsCxoUxR2R5PFjFTAO/UvFjHbH/lRFCZEi6ydWLJZP
         f6v6ooyoIHfvRA8ahieVjBUCLbGq13TlwLKqe/upZfXp8XmFn6Ahm4wh5irBTG5vch
         kcagx/p6SupcEOdb0WmiUUZLWR3rh/NOF7H7qOV6C6NDH6v3xt7h3vZf2k+Zmmyxs3
         46HiNL/zwE3uffr4QeW4lNgs9nMPGDRorSVB9fKBZqFeE/ZdEm2JqAuXEhKdq/UjGe
         tkIaoGFq9aRBw==
Date:   Wed, 27 Jul 2022 18:58:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/9] net: devlink: remove region snapshot ID
 tracking dependency on devlink->lock
Message-ID: <20220727185851.22ee74aa@kernel.org>
In-Reply-To: <1658941416-74393-2-git-send-email-moshe@nvidia.com>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
        <1658941416-74393-2-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 20:03:28 +0300 Moshe Shemesh wrote:
> So resolve this by removing dependency on devlink->lock for region
> snapshot ID tracking by using internal xa_lock() to maintain
> shapshot_ids xa_array consistency.

xa_lock() is a spin lock, right?  s/GFP_KERNEL/GFP_ATOMIC/
