Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A9B6761DF
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 01:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjAUAGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 19:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjAUAGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 19:06:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FD11630A
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 16:06:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16B36B82A99
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 00:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF9DC433EF;
        Sat, 21 Jan 2023 00:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674259570;
        bh=ZD0ybsK+gSpF++32/7/+lk90bcSUCj8VTYortTTtazk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YePxYd9c4/377h8lhmWyrFFpSdtCDAdr0agmJwzfpuIswgtCTo0carfy4xLeLl3SA
         c5Jj3kQgj/Yq8D5GqcAAjfzBXOv8Kdk7QJTdyMX4IhI5DDSPhnElrGNaTrkzjPPNp4
         kvQHiA/Ucj/KqHkDSjaA7CS+iHuubR5P11EjEUK3YmPCRP3c4pg1SqlTXiej+cFI57
         sW4NOwTepXm1TqmwdWXwR1LBhinXbETALnRzhsDI3b5R3NwoNMJMZCXQA5lHA0N93L
         V/prJca6vmapL/MsDibrD6FSHCokJKDc3wSqTq0U4Xpkaj+YQWch8t+ipBeRI0bbHf
         tSKN69rmdZXmw==
Date:   Fri, 20 Jan 2023 16:06:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Message-ID: <20230120160609.19160723@kernel.org>
In-Reply-To: <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
References: <20230118183602.124323-1-saeed@kernel.org>
        <20230118183602.124323-4-saeed@kernel.org>
        <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
        <20230119194631.1b9fef95@kernel.org>
        <87tu0luadz.fsf@nvidia.com>
        <20230119200343.2eb82899@kernel.org>
        <87pmb9u90j.fsf@nvidia.com>
        <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com>
        <87r0vpcch0.fsf@nvidia.com>
        <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Jan 2023 15:58:25 -0800 Jacob Keller wrote:
> Sure. I guess what I don't understand is why or when one would want to
> use adjphase instead of just performing frequency adjustment via the
> .adjfine operation...
> 
> Especially since "gradual adjustment over time" means it will still be
> slow to converge (just like adjusting frequency is today).
> 
> We should definitely improve the doc to explain the diff between them
> and make sure that its more clear to driver implementations.

Fair point, I assumed that the adjustment is precise (as in the device
is programmed with both the extra addend and number of cycles over
which to use it). Yielding an exact adjustment.

But then again, I also thought that .adjtime is supposed to be a precise
single-shot nudge, while most drivers just do:

time = read_time()
time += delta
write_time(time)

:S  So yeah, let's document..

> It also makes it harder to justify mapping small .adjtime to .adjphase,
> as it seems like .adjphase isn't required to adjust the offset
> immediately. Perhaps the adjustment size is small enough that isn't a
> big problem?

