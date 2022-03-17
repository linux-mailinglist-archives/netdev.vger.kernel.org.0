Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40024DC076
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 08:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiCQHxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 03:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiCQHxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 03:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C044D372B
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 00:52:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9EC561371
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BFEC340EC;
        Thu, 17 Mar 2022 07:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647503535;
        bh=oWi2YNMdkrKhA3ZPpDQivc9IgKuEzNhCmCt5Ts54VIY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WhmIHMX3tkqQPuNfOWUMIO9pBLTXW5zozYVSPALrMfZb1rAWuC4gk0nUOd6S/22bg
         sa2oflZ2x3zNIxMKqia4emWYvmYHBYhFowC3Y479sM8/zy99/1zvoQcr8+kkbrkLyg
         a8Y/96Th4ljXrJGta3cdkfRw8t7jmPAfuoT81AgAiBarXczU+wZqSqlOObO8pw8iUQ
         iQJrwEse7wVEVmb+rkVpCJodo1f3rsmgoMNwARmt6UmboXJ+nPJ8FEdCD+T5Z6oiVU
         H4wkKneHtn5S3vsoY8NTDaDWdcIThG+YNGkFuAFOJwuR7l1buWUX6NeMlciBIFCywA
         H23wqp5d4XlEA==
Date:   Thu, 17 Mar 2022 09:52:10 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        saeedm@nvidia.com, idosch@idosch.org, michael.chan@broadcom.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next 5/5] devlink: hold the instance lock during
 eswitch_mode callbacks
Message-ID: <YjLoqpwsgJdXeIGq@unreal>
References: <20220317042023.1470039-1-kuba@kernel.org>
 <20220317042023.1470039-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317042023.1470039-6-kuba@kernel.org>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 09:20:23PM -0700, Jakub Kicinski wrote:
> Make the devlink core hold the instance lock during eswitch_mode
> callbacks. Cheat in case of mlx5 (see the cover letter).

And this is one the main difference between your and mine proposals/solutions.
I didn't want to cheat as it doesn't help to the end goal - remove devlink_mutex.

Can you please change the comments in mlx5 to be more direct?
"/* TODO: convert the driver to devl_* */"
->
"/* FIXME: devl_unlock() followed by devl_lock() inside driver callback
  * never correct and prone to races. Never repeat this pattern.
  *
  * This code MUST be fixed before removing devlink_mutex as it is safe
  * to do only because of that mutex.
  */"

Something like that.

The code is correct, but like I said before, I don't like the direction.
I expect that this anti-pattern is going to be copy/pasted very soon.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
