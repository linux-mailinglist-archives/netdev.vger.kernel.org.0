Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD906917C8
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 05:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjBJEyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 23:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjBJExr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 23:53:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184A37B147
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 20:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FC7B61C63
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 04:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5067FC433D2;
        Fri, 10 Feb 2023 04:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676004790;
        bh=gLkL1X3163zqKA/H0JH87wtETg4BML9vIuJxw/BKDFY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j3ov8pUoV4HhO30oy4vzjO/pjCshgDnjf0WMxrjrkvU4tRGQ3C0nWg39KQh0hHTYQ
         zDqw4MQI0s0JAlLkdrXHIr5hdJYlWXFqUbrCoRRLSp96oGSU3/GE0bkZL6hhN7GBpj
         5Ns53BJFR5xXiVqIwdifcFZdOp0Y9YLKXTDEPJgYTtIXRw+ScedyhNerb09VGGrIyh
         mvUSwfavmv7hxghQvca1NfeJbBb9KQwO0kJSWZApvnMNN3HV+LU88b7gykVbRBPkKf
         asPulpBfo3A0gOfWm1OmsE75vD7u1CiCpZAkTPnLTvhgnIEeAwlha7guNjJeoJxJcg
         h0oGvMYAEyrsw==
Date:   Thu, 9 Feb 2023 20:53:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com
Subject: Re: [patch net-next 0/7] devlink: params cleanups and
 devl_param_driverinit_value_get() fix
Message-ID: <20230209205309.57e75fdf@kernel.org>
In-Reply-To: <20230209154308.2984602-1-jiri@resnulli.us>
References: <20230209154308.2984602-1-jiri@resnulli.us>
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

On Thu,  9 Feb 2023 16:43:01 +0100 Jiri Pirko wrote:
> The primary motivation of this patchset is the patch #6, which fixes an
> issue introduced by 075935f0ae0f ("devlink: protect devlink param list
> by instance lock") and reported by Kim Phillips <kim.phillips@amd.com>
> (https://lore.kernel.org/netdev/719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com/)
> and my colleagues doing mlx5 driver regression testing.
> 
> The basis idea is that devl_param_driverinit_value_get() could be
> possible to the called without holding devlink intance lock in
> most of the cases (all existing ones in the current codebase),
> which would fix some mlx5 flows where the lock is not held.
> 
> To achieve that, make sure that the param value does not change between
> reloads with patch #2.
> 
> Also, convert the param list to xarray which removes the worry about
> list_head consistency when doing lockless lookup.
> 
> The rest of the patches are doing some small related cleanup of things
> that poke me in the eye during the work.

Acked-by: Jakub Kicinski <kuba@kernel.org>
