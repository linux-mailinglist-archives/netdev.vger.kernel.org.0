Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8B169D4FD
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 21:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbjBTUab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 15:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjBTUaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 15:30:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116EC196AB;
        Mon, 20 Feb 2023 12:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A234BB80DC9;
        Mon, 20 Feb 2023 20:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8060C433EF;
        Mon, 20 Feb 2023 20:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676925023;
        bh=yQNVCdw2eC2KHH+8WPvKml/OZ6S8hvGf5xD2OuSM5QI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cam/KxQUkbw6Soonn5rL/DGAxtpEaI4+D8T+PsiPulj5vg72e06NZkHgsRK//w0/G
         oht0u0HFhQ94xmHmJ5gKV7nOzjF1/GM0N1CDqaCwMiVY1wl8lMxar6TF7Mhd1iwHLZ
         7guE1HH+Db7QWvhzkw7Rz6J3bjD/SsbzEAKJPswkxNdJfxyqtVKkEDVb+Nwb4Zxyty
         0+XwHtmvUYrVJ8ytvT19VbrN4XI3i0fNlZZHPM8RFwM+y981em6V2+/7WREDKJSapf
         YecY3FpK59uJehti40JFx56mPSdS3hAQKzvJb0vV0cTIdbMVvvcUYX1C5o+d0h9qWo
         PSBteBm053z3w==
Date:   Mon, 20 Feb 2023 12:30:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Gavin Li <gavinl@nvidia.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [PATCH net-next v3 2/5] vxlan: Expose helper
 vxlan_build_gbp_hdr
Message-ID: <20230220123021.448dc1a0@kernel.org>
In-Reply-To: <Y/NMH2QRKoUpdNef@corigine.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
        <20230217033925.160195-3-gavinl@nvidia.com>
        <Y/KHWxQWqyFbmi9Y@corigine.com>
        <b0f07723-893a-5158-2a95-6570d3a0481c@nvidia.com>
        <Y/MV1JFn4NuptO9q@corigine.com>
        <c8fcebb5-4eba-71c8-e20c-cd7afd7e0d98@nvidia.com>
        <Y/NMH2QRKoUpdNef@corigine.com>
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

On Mon, 20 Feb 2023 11:31:59 +0100 Simon Horman wrote:
> On Mon, Feb 20, 2023 at 03:15:20PM +0800, Gavin Li wrote:
> > > Right. But what I was really wondering is if the definition
> > > of the function could stay in drivers/net/vxlan/vxlan_core.c,
> > > without being static. And have a declaration in include/net/vxlan.h  
> > 
> > Tried that the first time the function was called by driver code. It would
> > introduce dependency in linking between the driver and the kernel module.
> > 
> > Do you think it's OK to have such dependency?  
> 
> IMHO, yes. But others may feel differently.
> 
> I do wonder if any performance overhead of a non-inline function
> also needs to be considered.

Do you recall any details of why Hannes broke the dependency in the
first place? 
Commit b7aade15485a ("vxlan: break dependency with netdev drivers")
Maybe we should stick to the static inline, it doesn't look too
large/terrible?
