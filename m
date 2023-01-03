Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF2B65BD3E
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbjACJfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbjACJfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:35:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D30FE094;
        Tue,  3 Jan 2023 01:35:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFE0661228;
        Tue,  3 Jan 2023 09:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A44C433D2;
        Tue,  3 Jan 2023 09:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672738509;
        bh=JUA2lT1qfrNXleMDtLF82i4F/TDM47rJDAehK4IRzWE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iXpIJf3tpbeiVTecgwdjxbmVlDfR8sXNFxkplivk1BDVRtIGCWc8cFgb1WqzCPrmh
         pSv97G0VpNR8j3hHwc/jaVkUc/Y5Ewv8yamA/s61oXZC2s3cV6OXAeMi52NIzQ/O9l
         fyfzwUhhmn6dF1vX5A6/KiiJC9Pf6QEno960d6JEOfCsG9YS7fleQpCMeAeeNG6XIV
         JXUXBALPMV4N3kkIqtEG7XlNQzPjWkj7D5Tc7l/h3eWH7JKBCI+Y6AOL9f6m9pR37s
         PJseOduPM1nwO7SPbb1SYAjTF8/MmXpjqBVNM3LbBO1e5bqBEWxbF3umaLN7Ogovv4
         DzYePuKtc2bbw==
Date:   Tue, 3 Jan 2023 11:35:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Petr Pavlu <petr.pavlu@suse.com>
Cc:     tariqt@nvidia.com, yishaih@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Part of devices not initialized with mlx4
Message-ID: <Y7P2yECHeKvyqQqo@unreal>
References: <0a361ac2-c6bd-2b18-4841-b1b991f0635e@suse.com>
 <Y57jE03Rmr7wphlj@unreal>
 <e939dbde-8905-fc98-5717-c555e05b708d@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e939dbde-8905-fc98-5717-c555e05b708d@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 02, 2023 at 11:33:15AM +0100, Petr Pavlu wrote:
> On 12/18/22 10:53, Leon Romanovsky wrote:
> > On Thu, Dec 15, 2022 at 10:51:15AM +0100, Petr Pavlu wrote:
> >> Hello,
> >>
> >> We have seen an issue when some of ConnectX-3 devices are not initialized
> >> when mlx4 drivers are a part of initrd.
> > 
> > <...>
> > 
> >> * Systemd stops running services and then sends SIGTERM to "unmanaged" tasks
> >>   on the system to terminate them too. This includes the modprobe task.
> >> * Initialization of mlx4_en is interrupted in the middle of its init function.
> > 
> > And why do you think that this systemd behaviour is correct one?
> 
> My view is that this is an issue between the kernel and initrd/systemd.
> Switching the root is a delicate operation and both parts need to carefully
> cooperate for it to work correctly.
> 
> I think it is generally sensible that systemd tries to terminate any remaining
> processes started from the initrd. They would have troubles when the root is
> switched under their hands anyway, unless they are specifically prepared for
> it. Systemd only skips terminating kthreads and allows to exclude root storage
> daemons. A modprobe helper could be excluded from being terminated too but the
> problem with the root switch remains.
> 
> It looks to me that a good approach is to complete all running module loads
> before switching the root and continue with any further loads after the
> operation is done. Leaving module loads to udevd assures this, hence the idea
> to use an auxiliary bus.

I'm not sure about it. Everything above are user-space troubles which
are invited once systemd does root switch. Anyway, if you want to do
aux bus for mlx4, go for it.

Feel free to send me patches off-list and I will add them to our
regression, but be aware that you are stepping on landmine field
here.

Thanks
