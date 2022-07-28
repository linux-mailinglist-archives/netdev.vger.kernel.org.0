Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DBE58369C
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 04:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbiG1CCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 22:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiG1CCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 22:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C284F659
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 19:02:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2767C61778
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 02:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A46C433C1;
        Thu, 28 Jul 2022 02:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658973719;
        bh=EfJz1vcpphpsoRZAn1+7akAOc3dvfPp8wwBpNZjcFVk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=shZLWsQASs6CF+h5T/nkTWLuRy8RE5bolO1GU1ywC6vm84+XrD/J//Hgrne8jK6Sx
         2z1ovP+0PReJhm5PfciURYpxvprACgEqXzakl2/Nu3gt0VbH5ZwWoowNgPDDomuTu6
         HROQ8ZzzjrDXIH53Vb1aKLQBxW5IhEvhtar9387PfiuqX63/aL5qRrdnPTKhYjh/Ca
         Rp5vYEnzk0mDqZL5OclhJc++NNFV8MTf1eyyiSOOCEs53PhOSzP4Npfy8cCjb88Vnb
         Py74uJj04aKKAswALvFR7kDHH7UW8/aHQzGaVd1Kjyzkn2A6RoCMlyYM/Z+Z48pPsm
         tx0aUWZ84ViUQ==
Date:   Wed, 27 Jul 2022 19:01:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/9] net: devlink: remove region snapshots list
 dependency on devlink->lock
Message-ID: <20220727190156.0ec856ae@kernel.org>
In-Reply-To: <1658941416-74393-3-git-send-email-moshe@nvidia.com>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
        <1658941416-74393-3-git-send-email-moshe@nvidia.com>
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

On Wed, 27 Jul 2022 20:03:29 +0300 Moshe Shemesh wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> After mlx4 driver is converted to do locked reload,
> devlink_region_snapshot_create() may be called from both locked and
> unlocked context.

You need to explain why, tho. What makes region snapshots special? 

> So resolve this by removing dependency on devlink->lock for region
> snapshots list consistency and introduce new mutex to ensure it.

I was hoping to avoid per-subobject locks. What prevents us from
depending on the instance lock here (once the driver is converted)?
