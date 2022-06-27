Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EAE55D2FB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbiF0RuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 13:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238159AbiF0Rt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 13:49:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB3065D3
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 10:49:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65E15B81116
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 17:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE495C3411D;
        Mon, 27 Jun 2022 17:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656352195;
        bh=SUMEhABB4QV3DX/dLzAls++bk6XyNzd6ncEZ0Fw1A4I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u47erLZuVahkpVER0U7AX9lG+HuBFnPCLjooo6qeP9Tic5goDauz5Aknx5pXolWVV
         H+OTUADYVkPBczf91DaYXsh7mz2x5Dji4Kt+ZYaPJGjoW61Obf4ZgBEL7yONQ7+Xu6
         RVV9U2emZxvab8fhrUmdeEOH7V93UnjE9POJDsSCuvj5yFGakvjMRoNkZ5hlfqCcK1
         nh6t2Yo+UQtN8qAwGpK8isM7cTN7+RkSlUJuLqnzuVCq+9Ne4RNS6fOn3WxChGEoyq
         NqPeIj8JBoO3aF1iWNzpTYZhysu069n9r2sKU+A/aYaod584Q5pWaxaxbCG6cv7gkw
         y1x3x4T70sLQQ==
Date:   Mon, 27 Jun 2022 10:49:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, petrm@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [patch net-next RFC 0/2] net: devlink: remove devlink big lock
Message-ID: <20220627104945.5d8337a5@kernel.org>
In-Reply-To: <YrnPqzKexfgNVC10@shredder>
References: <20220627135501.713980-1-jiri@resnulli.us>
        <YrnPqzKexfgNVC10@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jun 2022 18:41:31 +0300 Ido Schimmel wrote:
> On Mon, Jun 27, 2022 at 03:54:59PM +0200, Jiri Pirko wrote:
> > This is an attempt to remove use of devlink_mutex. This is a global lock
> > taken for every user command. That causes that long operations performed
> > on one devlink instance (like flash update) are blocking other
> > operations on different instances.  
> 
> This patchset is supposed to prevent one devlink instance from blocking
> another? Devlink does not enable "parallel_ops", which means that the
> generic netlink mutex is serializing all user space operations. AFAICT,
> this series does not enable "parallel_ops", so I'm not sure what
> difference the removal of the devlink mutex makes.
> 
> The devlink mutex (in accordance with the comment above it) serializes
> all user space operations and accesses to the devlink devices list. This
> resulted in a AA deadlock in the previous submission because we had a
> flow where a user space operation (which acquires this mutex) also tries
> to register / unregister a nested devlink instance which also tries to
> acquire the mutex.
> 
> As long as devlink does not implement "parallel_ops", it seems that the
> devlink mutex can be reduced to only serializing accesses to the devlink
> devices list, thereby eliminating the deadlock.

I'm unclear on why we can't wait for mlx5 locking rework which will
allow us to move completely to per-instance locks. Do you have extra
insights into how that work is progressing? I was hoping that it will
be complete in the next two months. 
