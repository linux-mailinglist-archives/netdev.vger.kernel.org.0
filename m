Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9111A68738E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 04:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjBBDBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 22:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjBBDBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 22:01:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8549679CA7
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 19:01:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FB41619D2
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 03:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591F8C433EF;
        Thu,  2 Feb 2023 03:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675306876;
        bh=9Os5ZP06yTmnsN40xMze5wYHY+cDsos+Dx5x0azE4j4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZqV+FkLatzyKSp8bcnPf2FhMkwBrT0VKhtpDXHSqXCG122LJf9AQvFIjMVJNnHlDQ
         AoS/ZiJMS1xoczY7ee6FC6bhiCT2HRPjofrbV8Jz36mwl5lc6Y3j3uMPXyxZwuqBwQ
         5cZAMXZdkAbYmSAMyJlqArFRfaU/z5hyNxd+MrOR6UDrizGQv9lPhh7zVyAR474IJW
         1CPvnciyamx3Vy/ImkzEIl3wizruV8+kHHawd2bwfXBERaxo6I+aBIh/OttUhxhUVl
         E5lSA30t0VHaGAv4DSDDdcq0oJFRMPcHbFOxgTkbMIL00IoakiYWFyOMI6uAWm+RGT
         pKxQl+rllLruA==
Date:   Wed, 1 Feb 2023 19:01:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Vadim Fedorenko <vadfed@meta.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Gal Pressman <gal@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v4 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
Message-ID: <20230201190115.48fcebf0@kernel.org>
In-Reply-To: <Y9r4UHZUUAdYdTPp@x130>
References: <20230201122605.1350664-1-vadfed@meta.com>
        <20230201122605.1350664-3-vadfed@meta.com>
        <Y9qtPtTMvZUWtRso@x130>
        <56a2ea34-7730-3794-d2df-53c94b4d9a60@linux.dev>
        <Y9r4UHZUUAdYdTPp@x130>
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

On Wed, 1 Feb 2023 15:40:00 -0800 Saeed Mahameed wrote:
> >And again the only concern here is that we don't have any checks 
> >whether FIFO has anything to pop before actually poping the value. 
> >That can easily bring use-after-free in the futuee, especially because 
> >the function is not ptp specific and is already used for other fifos. 
> >I can add unlikely() for this check if it helps, but I would like to 
> >have this check in the code.
> 
> you shouldn't access the fifo if by design it's guaranteed nothing is there.
> We don't build for a future/fool proof code, the fifo is only accessed
> when we know there's something there by design, this is not a general
> purpose fifo, it's a fifo used by mlx5 ordered cqs.. 

The check for fifo being empty seems 100% sane to me. You can put 
a WARN_ON_ONCE() on it if you believe it can never happen. But the
cost of dealing with random double frees is much higher than a single
conditional on not-so-fast path.

> According to your logic, kfree should also check for double free.. ? :) 

I reckon we'd happily make kfree check for double free if there was
an efficient way of doing that. Various large companies build their
production kernels with KFENCE enabled, AFAIK.
