Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F626B8124
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjCMSta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjCMStZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:49:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEC174A51;
        Mon, 13 Mar 2023 11:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0408661280;
        Mon, 13 Mar 2023 18:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E42C433EF;
        Mon, 13 Mar 2023 18:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678733339;
        bh=jXIjkDDartMlz/yDiXSz631XNKJ8bcgA14a26q41U3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iazjSAE6/IeK3sRWP+E+3TPqCohGcUbbv3Hd03aU9RTbgKTNPwTD3XPE1wI5oBRPf
         id9/Nq82GCWdGAj2U7bLotSp061BHbijRrHGH8gcMdILEAeTsiRHd8DvDDi1PiFW/O
         8LbtH+QXWt60tf3qBNl+GXRPZa7wSvJTutrdYSwrCabyL1MXMhZga4gX9g/WpnKv4E
         Sxs/T7RoqBvnRrs3ODhcyYXjn/jrGuGjnPoYpzj6s5zIeYzXVETL2FAzSQx8b88vUB
         TUuvkerX7UD/vra8P9JZWAZ2QYUim/iaFjD8/luq03teFzS5KU1CyMH1qx32JwXnKD
         gyGgQK05TqgZQ==
Date:   Mon, 13 Mar 2023 11:48:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jonas Suhr Christensen" <jsc@umbraculum.org>,
        "Harini Katakam" <harini.katakam@amd.com>
Cc:     "Paolo Abeni" <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Michal Simek" <michal.simek@xilinx.com>,
        "Haoyue Xu" <xuhaoyue1@hisilicon.com>,
        huangjunxian <huangjunxian6@hisilicon.com>,
        "Wang Qing" <wangqing@vivo.com>,
        "Yang Yingliang" <yangyingliang@huawei.com>,
        "Esben Haabendal" <esben@geanix.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] net: ll_temac: Fix DMA resources leak
Message-ID: <20230313114858.54828dda@kernel.org>
In-Reply-To: <bd639016-8a9c-4479-83b4-32306ad734ac@app.fastmail.com>
References: <20230205201130.11303-1-jsc@umbraculum.org>
        <20230205201130.11303-2-jsc@umbraculum.org>
        <5314e0ba3a728787299ca46a60b0a2da5e8ab23a.camel@redhat.com>
        <135b671b1b76978fb147d5fee1e1b922e2c61f26.camel@redhat.com>
        <20230207104204.200da48a@kernel.org>
        <bd639016-8a9c-4479-83b4-32306ad734ac@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Mar 2023 19:37:00 +0100 Jonas Suhr Christensen wrote:
> On Tue, Feb 7, 2023, at 19:42, Jakub Kicinski wrote:
> > On Tue, 07 Feb 2023 12:36:11 +0100 Paolo Abeni wrote:  
> >> You can either try change to phys type to __be32 (likely not suitable
> >> for -net and possibly can introduce even more warnings elsewhere)  
> >
> > FWIW that seems like the best option to me as well. Let's ignore the
> > sparse warning for v3 and try to switch phys to __be32 in a separate
> > patch for net-next. No point adding force casts just to have to remove
> > them a week later, given how prevalent the problem is.
> >  
> >> or explicitly cast the argument.  
> 
> I no longer have access to the hardware, so I'm not rewriting the
> batch. Feel free to take ownership of it and fix what's needed.

Ack.

Harini, are you the designated maintainer for this driver? Could you
add a MAINTAINERS entry for it? I don't see one right now.
And possibly pick up these patches / fix the problem, if you have 
the cycles?
