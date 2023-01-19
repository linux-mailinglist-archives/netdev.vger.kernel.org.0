Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A261A67412C
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjASSof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjASSod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:44:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B6B2E0D9
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 10:44:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0847CCE2597
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 18:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58C4C433D2;
        Thu, 19 Jan 2023 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674153869;
        bh=hZd62bSQbGfxvkQynjPC4AmoolPY8UR6VEvA5uZ/KzA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IOMCLR2S63vXrecc8pY4p59Rsto8/Ue3Tl7TzrFgJYvVUB7IqnlD/w/dIJgKdkwsY
         9B/XCAxc+t98abaRMIbxeNzZrPffuCRz9snzWlFsEe3AlwxfMwFl5jsQCx58MdzkOS
         Q9DEK8ELjTHazufE3EcyJjNm+vdLYGr4joYQDHn8vp84k29Ms2/sAmLQ/Oi/94eMQC
         3KHZjCeeEtYqt0ChJAOOwNCu72DmSQR/Sj3XNiW9Da3PiMaoXTR8j9vUpD7ZcIjPLP
         wqoVPVRegCuA8ybw2P49P9n+j7Z6tk74Azd5ym+lJ8f9k6gHCPWuTXxkwdrkgACcQt
         2TIH5CrfJcJhQ==
Date:   Thu, 19 Jan 2023 10:44:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 1/7] sfc: add devlink support for ef100
Message-ID: <20230119104427.69d95782@kernel.org>
In-Reply-To: <82a57ba1-bd28-3742-0027-a6a284569aee@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
        <20230119113140.20208-2-alejandro.lucero-palau@amd.com>
        <20230119091606.2ee5a807@kernel.org>
        <82a57ba1-bd28-3742-0027-a6a284569aee@amd.com>
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

On Thu, 19 Jan 2023 17:52:42 +0000 Lucero Palau, Alejandro wrote:
> On 1/19/23 17:16, Jakub Kicinski wrote:
> > On Thu, 19 Jan 2023 11:31:34 +0000 alejandro.lucero-palau@amd.com wrote:  
> >> +		devlink_unregister(efx->devlink);
> >> +		devlink_free(efx->devlink);  
> > Please use the devl_ APIs and take the devl_lock() explicitly.
> > Once you start adding sub-objects the API with implicit locking
> > gets racy.  
> 
> I need more help here.
> 
> The explicit locking you refer to, is it for this specific code only?

I only had a quick look at the series, but I saw you add ports.
So the locking should be something like:

  devlink = devlink_alloc();
  devl_lock(devlink);
  ...
  devl_register(devlink);
  ...
  netdev_register(netdev);
  devl_port_register(port_for_the_netdev);
  ...
  devl_unlock();

And the inverse on the .remove path.
Basically you want to hold the devlink instance lock for most of 
the .probe and .remove. That way nothing can bother the devlink
instance and the driver while the driver is initializing/finalizing.

Without holding the lock the linking between the devlink port and 
the netdev gets a bit iffy. It's a circular dependency of sorts
because both the netdev carries a link to the port and the port
carries info about the netdev.

We've been figuring out workarounds for subtle ordering and locking
problems since devlink ports were created. Recently we just gave up
and started asking drivers to hold the instance lock across .probe/
/.remove.

> Also, I can not see all drivers locking/unlocking when doing 
> devlink_unregister. Those doing it are calling code which invoke 
> unregister devlink ports, like the NFP and I think ml5x as well.

Right, only netdevsim was fully converted so far. The syzbot and other
testers use netdevsim mostly. We'll push actual HW drivers towards this
locking slowly.

> In this case, no devlink port remains at this point, and no netdev either.
> 
> What is the potential race against?

Right, I don't mean this particular spot, just over-trimmed the quote.
