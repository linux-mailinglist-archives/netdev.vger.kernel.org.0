Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510164BF1B9
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 06:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiBVFwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 00:52:00 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiBVFvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 00:51:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7766D86C;
        Mon, 21 Feb 2022 21:51:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 369A1615BB;
        Tue, 22 Feb 2022 04:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCA4C340E8;
        Tue, 22 Feb 2022 04:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645505683;
        bh=dnyqlK3OpBmJqYgjXqP/BKGSr4v69qL9WeXUJpQmIsU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p1RvUpj2koTsEzgAlIoUn2jfGydNzSK2skRBGq8ZWrccAg7xnAjL8M0V/AOL1PqJM
         Zl894QLv3B809urdpnbvjMsN30TgmQ1WH6sR3EPWJu39cyGpOFJjorx1CIlxXAsiNd
         q5cjXcqk3UUsY1jD/U0Hc7swjcU+BXTWCEKCs4nGY5LQDWdFgmU5FnokGQTm49h/6a
         hPTg+fs0jFVW+Y1VierTXltu80GrN45BeqA0RMmPjyaX3fxblGVsmOJ12t0ROwB6oK
         IuRhE3VqJ5jgHWep5/tOEF840Nx4VRp1Rb0c1Gx3Sfjh/3Sl1fmFwcpCFZu6X0ERR7
         eU8YM+k50mEDg==
Date:   Mon, 21 Feb 2022 20:54:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Niels Dossche <niels.dossche@ugent.be>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devlink: use devlink lock on DEVLINK_CMD_PORT_SPLIT
Message-ID: <20220221205442.20da7c35@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <18b57f7b-6aa6-e87f-e187-feead42fc90a@ugent.be>
References: <18b57f7b-6aa6-e87f-e187-feead42fc90a@ugent.be>
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

On Mon, 21 Feb 2022 14:33:25 +0100 Niels Dossche wrote:
> devlink_nl_cmd_port_split_doit is executed without taking the devlink
> instance lock. This function calls to devlink_port_get_from_info, which
> calls devlink_port_get_from_attrs, which calls
> devlink_port_get_by_index, which accesses devlink->port_list without the
> instance lock taken, while in other places devlink->port_list access
> always happens with the instance lock taken. The documentation in the
> struct also say that the devlink lock protects the port_list.
> 
> The flag for no locking was added after refactoring the code to no
> longer use a global lock.
> 
> Fixes: 2406e7e546b2 ("devlink: Add per devlink instance lock")
> Signed-off-by: Niels Dossche <niels.dossche@ugent.be>

You can't do this, driver will likely try to register ports and try 
to re-acquire the same lock. I have a series queued to fix this by
moving the locking into drivers. I'll send it out this week.
