Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A2858092D
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 03:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbiGZBru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 21:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiGZBrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 21:47:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DCB28719
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 18:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7054DB81167
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 01:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE4DC341C6;
        Tue, 26 Jul 2022 01:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658800066;
        bh=cnZmXew4Y7QyRV3tolO7HHmTvcwRl8Oir8uQT46iIe0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YHDpbJ8EkU+wDp0GP9CeYk36bm41rG0TuuK56zn77kHUZ+fKOoM8fdfVlL/7z9Wqb
         u6CtvqsmQTfFxBVCm4XTwx4zxhPTosXX76cQ8kpZF4+Sp5s7yoezG/EiqljgIkkP8G
         kMebTqICsfCseD/g6S9z5rAFItoRaS2vr6eWdlENiqprFBnhhZ1q9sEYIUWSn+GKlp
         zdXxgv65wU539CSu7gEyLlPePXVb9cGr/aWh2neYzIAQmV+JMtwzNDRzHvTbjtipaH
         qtfqgt8w5BNCQDicJGvTxF4MUNLptof3e3+9M9igxLpyqls8JH2OULs4UCgIT/4hb4
         qYJ6fOzL5UNkw==
Date:   Mon, 25 Jul 2022 18:47:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v4 01/12] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <20220725184744.4e486fd6@kernel.org>
In-Reply-To: <20220725082925.366455-2-jiri@resnulli.us>
References: <20220725082925.366455-1-jiri@resnulli.us>
        <20220725082925.366455-2-jiri@resnulli.us>
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

On Mon, 25 Jul 2022 10:29:14 +0200 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Remove dependency on devlink_mutex during devlinks xarray iteration.
> 
> The reason is that devlink_register/unregister() functions taking
> devlink_mutex would deadlock during devlink reload operation of devlink
> instance which registers/unregisters nested devlink instances.
> 
> The devlinks xarray consistency is ensured internally by xarray.
> There is a reference taken when working with devlink using
> devlink_try_get(). But there is no guarantee that devlink pointer
> picked during xarray iteration is not freed before devlink_try_get()
> is called.
> 
> Make sure that devlink_try_get() works with valid pointer.
> Achieve it by:
> 1) Splitting devlink_put() so the completion is sent only
>    after grace period. Completion unblocks the devlink_unregister()
>    routine, which is followed-up by devlink_free()
> 2) During devlinks xa_array iteration, get devlink pointer from xa_array
>    holding RCU read lock and taking reference using devlink_try_get()
>    before unlock.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
