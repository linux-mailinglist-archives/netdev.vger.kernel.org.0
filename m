Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5240668B12
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 06:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjAMFHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 00:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjAMFHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 00:07:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA935BA0A;
        Thu, 12 Jan 2023 21:07:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A590DB8203D;
        Fri, 13 Jan 2023 05:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D796EC433D2;
        Fri, 13 Jan 2023 05:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673586460;
        bh=si37ZEiLLqD4Qqncw3uQ5PyAKOVJHCNmIcksGtXSdOo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c0cfPWZq1RW4eWz/Lo5HA+NhvY3uDudwZaJg4y3XbFMgGD3QNocNEZGGiiRGVuQaQ
         oZ7vcv+dzXr697jdfFhk7i6Hbhp6I43srwrgOxH0VXOyZvJ5W4gMpUUyf7sjq+0DGW
         Fj4aCcQHLYDxddRgtWRDMkSygSptVrL2knaAV4E9IyiCPUzB/CzMzgG79zrW+Rz7Sb
         WxtKBpSeYMlgeHrsAF5ZJZI186yB6ETCtj/fHM888cOVLOaZiKG02YQPsa2JVXolre
         5hYNvELQRsv5eOxbWpwd9lTMXMswIMAKYUD3oNRprLTUFtymDfgOgSG3Pm2kxTOyzS
         uXi55EwIdcIiQ==
Date:   Thu, 12 Jan 2023 21:07:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     Hariprasad Kelam <hkelam@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 0/5] octeontx2-pf: HTB offload support
Message-ID: <20230112210738.72393731@kernel.org>
In-Reply-To: <20230112173120.23312-1-hkelam@marvell.com>
References: <20230112173120.23312-1-hkelam@marvell.com>
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

On Thu, 12 Jan 2023 23:01:15 +0530 Hariprasad Kelam wrote:
> octeontx2 silicon and CN10K transmit interface consists of five
> transmit levels starting from MDQ, TL4 to TL1. Once packets are
> submitted to MDQ, hardware picks all active MDQs using strict
> priority, and MDQs having the same priority level are chosen using
> round robin. Each packet will traverse MDQ, TL4 to TL1 levels.
> Each level contains an array of queues to support scheduling and
> shaping.
> 
> As HTB supports classful queuing mechanism by supporting rate and
> ceil and allow the user to control the absolute bandwidth to
> particular classes of traffic the same can be achieved by
> configuring shapers and schedulers on different transmit levels.
> 
> This series of patches adds support for HTB offload,
> 
> Patch1: Allow strict priority parameter in HTB offload mode.
> 
> Patch2: defines APIs such that the driver can dynamically initialize/
>         deinitialize the send queues.
> 
> Patch3: Refactors transmit alloc/free calls as preparation for QOS
>         offload code.
> 
> Patch4: Adds devlink support for the user to configure round-robin
>         priority at TL1
> 
> Patch5:  Adds actual HTB offload support.

Rahul, since you're working on fixing the HTB offload warn - 
would you mind reviewing this series?

https://lore.kernel.org/all/20230112173120.23312-1-hkelam@marvell.com/
